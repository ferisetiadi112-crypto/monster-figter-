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

    BirthTimestamp = os.time(),
    AgeDays = 0,
    Level = 1,
    XP = 0,

    BreedingCount = 0,
    Bond = 0,

    Skills = {},
    Traits = {},
    Parents = nil,

    BattleHistory = {
      Battles = 0,
      Wins = 0,
      ArenaWins = 0,
    },

    OwnerUserId = nil,
    CreatedAt = os.time(),
    UpdatedAt = os.time(),
  }
end

return MonsterSchema
