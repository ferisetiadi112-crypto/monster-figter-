local TrainingConfig = {}

TrainingConfig.BaseXPPerSession = 25
TrainingConfig.BaseBondPerSession = 2
TrainingConfig.MaxBond = 100
TrainingConfig.MaxLevel = 100
TrainingConfig.BaseXPToNextLevel = 100
TrainingConfig.XPGrowth = 1.15

TrainingConfig.Equipment = {
  Basic = {XP = 25, Bond = 2, FoodCost = 3, WaterCost = 2},
  Advanced = {XP = 50, Bond = 4, FoodCost = 5, WaterCost = 4},
  Elite = {XP = 90, Bond = 7, FoodCost = 8, WaterCost = 6},
}

function TrainingConfig:GetXPRequired(level)
  if level >= self.MaxLevel then
    return math.huge
  end
  return math.floor(self.BaseXPToNextLevel * (self.XPGrowth ^ (level - 1)))
end

return TrainingConfig
