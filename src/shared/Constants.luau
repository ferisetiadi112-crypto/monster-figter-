local Constants = {}

Constants.GameName = "Monster Fighter"
Constants.Version = "0.1.0-foundation"

Constants.Population = {
  MonstersPerNewAccount = 5,
  WildLocations = 5,
  WildSlotsPerLocation = 3,
  MaxWildMonsters = 15,
}

Constants.Arena = {
  Tiers = {"Bronze", "Silver", "Gold", "Titanium", "Platinum"},
  BeltsPerTier = 3,
  Stake = {
    Bronze = 100,
    Silver = 500,
    Gold = 2500,
    Titanium = 10000,
    Platinum = 50000,
  },
}

Constants.Lifecycle = {
  TrainingAgeDays = 5,
  BattleAgeDays = 10,
  BreedingAgeDays = 30,
  MaxMaleBreedings = 3,
  MaxFemaleEggCycles = 3,
}

Constants.CoreTypes = {
  "Ember", "Tide", "Bloom", "Pulse", "Terra",
  "Gale", "Frost", "Void", "Radiant",
}

return Constants
