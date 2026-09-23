local MonsterSchema = {}

MonsterSchema.Status = {
  WILD = "Wild",
  OWNED = "Owned",
  EGG = "Egg",
  INCUBATING = "Incubating",
  FALLEN = "Fallen",
  RESERVE = "Reserve",
  STARTER_HOLD = "StarterHold",
}

function MonsterSchema.newIdentity(monsterId, species, gender, core)
  local timestamp = os.time()

  return {
    MonsterID = monsterId,
    Species = species,
    Gender = gender,
    Core = core,

    Rarity = "Common",
    BirthType = "Wild",
    Status = MonsterSchema.Status.WILD,

    LifeNumber = 1,
    ReincarnationCount = 0,
    Generation = 1,

    BirthTimestamp = timestamp,
    AgeDays = 0,
    Level = 1,
    XP = 0,
    Bond = 0,
    Stats = {
      Power = 10,
      Defense = 10,
      Speed = 16,
      MaxHealth = 100,
    },

    Care = {
      Food = 100,
      Water = 100,
      LastCareUpdate = timestamp,
    },
    Companion = {
      Mode = "Stored",
      HomeId = "Home",
    },

    BreedingCount = 0,
    Skills = {},
    Traits = {},
    Parents = nil,

    BattleHistory = {
      Battles = 0,
      Wins = 0,
      ArenaWins = 0,
    },

    Legacy = {
      PreviousOwners = {},
      PreviousLives = {},
      FallenEvents = {},
    },

    OwnerUserId = nil,
    LocationId = nil,
    CreatedAt = timestamp,
    UpdatedAt = timestamp,
  }
end

function MonsterSchema:IsValidStatus(status)
  for _, value in pairs(self.Status) do
    if value == status then
      return true
    end
  end
  return false
end

return MonsterSchema
