local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Shared.Constants)
local MonsterSchema = require(ReplicatedStorage.Shared.MonsterSchema)
local MonsterIdService = require(script.Parent.MonsterIdService)
local PopulationService = require(script.Parent.PopulationService)
local SpeciesConfig = require(ReplicatedStorage.Shared.SpeciesConfig)
local TrainingConfig = require(ReplicatedStorage.Shared.TrainingConfig)

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
  if not PopulationService:RegisterWild(locationId) then
    monsters[monster.MonsterID] = nil
    return nil, "WildSlotUnavailable"
  end

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

function MonsterService:Hydrate(records)
  for _, record in ipairs(records or {}) do
    if type(record) == "table" and type(record.MonsterID) == "string" then
      monsters[record.MonsterID] = table.clone(record)
    end
  end
end

function MonsterService:ClearOwnedForPlayer(userId)
  for id, monster in pairs(monsters) do
    if monster.OwnerUserId == userId then
      monsters[id] = nil
    end
  end
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

function MonsterService:Train(monsterId, equipment)
  local monster = monsters[monsterId]
  if not monster then
    return false, "NotFound"
  end
  if monster.Status ~= MonsterSchema.Status.OWNED then
    return false, "NotOwned"
  end
  if not self:CanTrain(monsterId) then
    return false, "TrainingLocked"
  end

  local profile = TrainingConfig.Equipment[equipment or "Basic"]
  if not profile then
    return false, "InvalidEquipment"
  end

  local care = monster.Care or {Food = 100, Water = 100}
  if care.Food < profile.FoodCost or care.Water < profile.WaterCost then
    return false, "InsufficientCare"
  end

  monster.XP += profile.XP
  monster.Bond = math.clamp(monster.Bond + profile.Bond, 0, TrainingConfig.MaxBond)
  care.Food = math.max(0, care.Food - profile.FoodCost)
  care.Water = math.max(0, care.Water - profile.WaterCost)
  monster.Care = care

  local levelsGained = 0
  while monster.Level < TrainingConfig.MaxLevel do
    local required = TrainingConfig:GetXPRequired(monster.Level)
    if monster.XP < required then
      break
    end
    monster.XP -= required
    monster.Level += 1
    levelsGained += 1
  end

  monster.UpdatedAt = os.time()
  return true, {
    Monster = self:Get(monsterId),
    Equipment = equipment or "Basic",
    XPGained = profile.XP,
    BondGained = profile.Bond,
    LevelsGained = levelsGained,
  }
end

function MonsterService:SetCare(monsterId, food, water)
  local monster = monsters[monsterId]
  if not monster then
    return false, "NotFound"
  end

  monster.Care = monster.Care or {
    Food = 100,
    Water = 100,
    LastCareUpdate = os.time(),
  }

  if type(food) == "number" then
    monster.Care.Food = math.clamp(food, 0, 100)
  end
  if type(water) == "number" then
    monster.Care.Water = math.clamp(water, 0, 100)
  end
  monster.Care.LastCareUpdate = os.time()
  monster.UpdatedAt = os.time()
  return true, self:Get(monsterId)
end

function MonsterService:SetStatus(monsterId, status)
  local monster = monsters[monsterId]
  if not monster then
    return false, "NotFound"
  end
  if not MonsterSchema:IsValidStatus(status) then
    return false, "InvalidStatus"
  end
  monster.Status = status
  monster.UpdatedAt = os.time()
  return true
end

function MonsterService:MaterializeFromEgg(player, egg)
  if not player or not egg or egg.Status ~= "Hatched" then
    return nil, "InvalidHatch"
  end

  local genes = egg.Genes or {}
  local monster = MonsterSchema.newIdentity(
    MonsterIdService:Generate(),
    genes.Species,
    genes.Gender,
    genes.Core
  )

  monster.BirthType = "Hatch"
  monster.Rarity = "Common"
  monster.Status = MonsterSchema.Status.OWNED
  monster.OwnerUserId = player.UserId
  monster.Generation = genes.Generation or 1
  monster.Traits = table.clone(genes.Traits or {})
  monster.Skills = table.clone(genes.Skills or {})
  monster.Parents = {
    genes.ParentA,
    genes.ParentB,
  }

  monsters[monster.MonsterID] = monster
  return self:Get(monster.MonsterID)
end

function MonsterService:RecordFallen(monsterId, reason)
  local monster = monsters[monsterId]
  if not monster then
    return false, "NotFound"
  end

  monster.Status = MonsterSchema.Status.FALLEN
  table.insert(monster.Legacy.FallenEvents, {
    At = os.time(),
    Reason = reason or "ArenaDefeat",
    LifeNumber = monster.LifeNumber,
  })
  monster.UpdatedAt = os.time()
  return true
end

function MonsterService:ReincarnateAsWild(monsterId, locationId)
  local monster = monsters[monsterId]
  if not monster or monster.Status ~= MonsterSchema.Status.FALLEN then
    return nil, "NotReincarnatable"
  end

  local oldLife = {
    LifeNumber = monster.LifeNumber,
    OwnerUserId = monster.OwnerUserId,
    AgeDays = monster.AgeDays,
    Level = monster.Level,
    ArenaWins = monster.BattleHistory.ArenaWins,
    FallenAt = os.time(),
  }

  table.insert(monster.Legacy.PreviousLives, oldLife)
  if monster.OwnerUserId then
    table.insert(monster.Legacy.PreviousOwners, monster.OwnerUserId)
  end

  monster.LifeNumber += 1
  monster.ReincarnationCount += 1
  monster.BirthTimestamp = os.time()
  monster.Level = 1
  monster.XP = 0
  monster.Bond = 0
  monster.BreedingCount = 0
  monster.BattleHistory = {
    Battles = 0,
    Wins = 0,
    ArenaWins = 0,
  }
  monster.OwnerUserId = nil
  monster.LocationId = locationId
  monster.Status = MonsterSchema.Status.WILD
  monster.BirthType = "Reincarnation"
  monster.UpdatedAt = os.time()

  return self:Get(monsterId)
end

function MonsterService:IncrementBreedingCount(monsterId)
  local monster = monsters[monsterId]
  if not monster then
    return false, "NotFound"
  end

  if not self:CanBreed(monsterId) then
    return false, "BreedingLimit"
  end

  monster.BreedingCount += 1
  monster.UpdatedAt = os.time()
  return true
end

function MonsterService:CanTrain(monsterId)
  local monster = monsters[monsterId]
  if not monster then
    return false
  end
  local care = monster.Care or {Food = 100, Water = 100}
  local ageDays = math.max(0, math.floor((os.time() - monster.BirthTimestamp) / 86400))
  return care.Food >= 20 and care.Water >= 20 and ageDays >= Constants.Lifecycle.TrainingAgeDays
end

function MonsterService:CanBattle(monsterId)
  local monster = monsters[monsterId]
  if not monster then
    return false
  end
  local ageDays = math.max(0, math.floor((os.time() - monster.BirthTimestamp) / 86400))
  return ageDays >= Constants.Lifecycle.BattleAgeDays
end

function MonsterService:CanBreed(monsterId)
  local monster = monsters[monsterId]
  local ageDays = monster and math.max(0, math.floor((os.time() - monster.BirthTimestamp) / 86400)) or 0
  if not monster or ageDays < Constants.Lifecycle.BreedingAgeDays then
    return false
  end

  if monster.Gender == "Male" then
    return monster.BreedingCount < Constants.Lifecycle.MaxMaleBreedings
  end

  return monster.BreedingCount < Constants.Lifecycle.MaxFemaleEggCycles
end

return MonsterService
