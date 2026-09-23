local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Shared.Constants)
local MonsterSchema = require(ReplicatedStorage.Shared.MonsterSchema)
local MonsterIdService = require(script.Parent.MonsterIdService)
local PopulationService = require(script.Parent.PopulationService)
local SpeciesConfig = require(ReplicatedStorage.Shared.SpeciesConfig)

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
  assert(SpeciesConfig:IsValid(species), "Invalid species")
  assert(gender == "Male" or gender == "Female", "Invalid gender")
  assert(assertCore(core), "Invalid core")
  assert(type(locationId) == "string" and locationId ~= "", "Invalid location")

  if not PopulationService:CanCreateWild(locationId) then
    return nil, "PopulationLimit"
  end

  local monster = MonsterSchema.newIdentity(
    MonsterIdService:Generate(),
    species,
    gender,
    core
  )

  local speciesData = SpeciesConfig:Get(species)
  monster.Rarity = speciesData.Rarity
  monster.BirthType = "Wild"
  monster.Status = MonsterSchema.Status.WILD
  monster.LocationId = locationId

  monsters[monster.MonsterID] = monster
  if not PopulationService:RegisterWild(locationId) then\n    return nil, "WildSlotUnavailable"\n  end

  return table.clone(monster)
end

function MonsterService:Get(monsterId)
  local monster = monsters[monsterId]
  if not monster then
    return nil
  end

  local snapshot = table.clone(monster)
  snapshot.AgeDays = math.max(0, math.floor((os.time() - monster.BirthTimestamp) / 86400))
  return snapshot
end

function MonsterService:GetAll()
  local result = {}
  for monsterId in pairs(monsters) do
    table.insert(result, self:Get(monsterId))
  end
  return result
end

function MonsterService:Capture(player, monsterId)
  if not player or not monsterId then
    return false, "InvalidRequest"
  end

  local monster = monsters[monsterId]
  if not monster or monster.Status ~= MonsterSchema.Status.WILD then
    return false, "NotCapturable"
  end

  local ageDays = math.max(0, math.floor((os.time() - monster.BirthTimestamp) / 86400))
  if ageDays < 0 then
    return false, "InvalidAge"
  end

  if not PopulationService:TransferWildToOwned(monster.LocationId) then
    return false, "PopulationTransferFailed"
  end

  monster.Status = MonsterSchema.Status.OWNED
  monster.OwnerUserId = player.UserId
  monster.LocationId = nil
  monster.UpdatedAt = os.time()

  return true, self:Get(monsterId)
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
