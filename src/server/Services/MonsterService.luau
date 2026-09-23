local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Shared.Constants)
local MonsterSchema = require(ReplicatedStorage.Shared.MonsterSchema)
local MonsterIdService = require(script.Parent.MonsterIdService)
local PopulationService = require(script.Parent.PopulationService)

local MonsterService = {}

local monsters = {}

local function assertCore(core)
  for _, value in ipairs(Constants.CoreTypes) do
    if value == core then
      return true
    end
  end
  return false
end

function MonsterService:CreateWild(species, gender, core, locationId)
  assert(type(species) == "string" and species ~= "", "Invalid species")
  assert(gender == "Male" or gender == "Female", "Invalid gender")
  assert(assertCore(core), "Invalid core")
  assert(type(locationId) == "string" and locationId ~= "", "Invalid location")

  if not PopulationService:CanCreateWild() then
    return nil, "PopulationLimit"
  end

  local monster = MonsterSchema.newIdentity(
    MonsterIdService:Generate(),
    species,
    gender,
    core
  )

  monster.BirthType = "Wild"
  monster.Status = MonsterSchema.Status.WILD
  monster.LocationId = locationId

  monsters[monster.MonsterID] = monster
  PopulationService:RegisterWild()

  return table.clone(monster)
end

function MonsterService:Get(monsterId)
  local monster = monsters[monsterId]
  return monster and table.clone(monster) or nil
end

function MonsterService:GetAll()
  local result = {}
  for _, monster in pairs(monsters) do
    table.insert(result, table.clone(monster))
  end
  return result
end

function MonsterService:SetStatus(monsterId, status)
  local monster = monsters[monsterId]
  if not monster then
    return false, "NotFound"
  end
  monster.Status = status
  monster.UpdatedAt = os.time()
  return true
end

function MonsterService:CanTrain(monsterId)
  local monster = monsters[monsterId]
  return monster ~= nil and monster.AgeDays >= Constants.Lifecycle.TrainingAgeDays
end

function MonsterService:CanBattle(monsterId)
  local monster = monsters[monsterId]
  return monster ~= nil and monster.AgeDays >= Constants.Lifecycle.BattleAgeDays
end

function MonsterService:CanBreed(monsterId)
  local monster = monsters[monsterId]
  if not monster or monster.AgeDays < Constants.Lifecycle.BreedingAgeDays then
    return false
  end

  if monster.Gender == "Male" then
    return monster.BreedingCount < Constants.Lifecycle.MaxMaleBreedings
  end

  return monster.BreedingCount < Constants.Lifecycle.MaxFemaleEggCycles
end

return MonsterService
