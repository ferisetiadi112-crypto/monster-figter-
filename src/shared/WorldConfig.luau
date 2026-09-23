local WorldConfig = {}

WorldConfig.Locations = {
  {
    Id = "EvergreenForest",
    Name = "Evergreen Forest",
    CoreAffinity = {"Bloom", "Gale"},
    WildSlots = 3,
  },
  {
    Id = "EmberValley",
    Name = "Ember Valley",
    CoreAffinity = {"Ember", "Terra"},
    WildSlots = 3,
  },
  {
    Id = "StoneMountain",
    Name = "Stone Mountain",
    CoreAffinity = {"Terra", "Pulse"},
    WildSlots = 3,
  },
  {
    Id = "FrostHollow",
    Name = "Frost Hollow",
    CoreAffinity = {"Frost", "Void"},
    WildSlots = 3,
  },
  {
    Id = "TideCoast",
    Name = "Tide Coast",
    CoreAffinity = {"Tide", "Radiant"},
    WildSlots = 3,
  },
}

WorldConfig.Starter = {
  FirstMissionRequired = true,
  ProtectedHoldPerNewAccount = 1,
}

return WorldConfig
