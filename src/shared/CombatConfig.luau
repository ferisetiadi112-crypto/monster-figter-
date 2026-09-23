local CombatConfig = {}

CombatConfig.Actions = {
  Attack = {Cooldown = 0.35, EnergyCost = 0, DamageMultiplier = 1.0, StaminaCost = 5},
  Dodge = {Cooldown = 0.8, EnergyCost = 0, StaminaCost = 20},
  Parry = {Cooldown = 0.55, EnergyCost = 10, StaminaCost = 10, Window = 0.22},
  Skill1 = {Cooldown = 3, EnergyCost = 15, DamageMultiplier = 1.25, StaminaCost = 8},
  Skill2 = {Cooldown = 5, EnergyCost = 20, DamageMultiplier = 1.5, StaminaCost = 10},
  Skill3 = {Cooldown = 8, EnergyCost = 25, DamageMultiplier = 1.8, StaminaCost = 12},
  Ultimate = {Cooldown = 20, EnergyCost = 40, DamageMultiplier = 3.0, StaminaCost = 20},
}

CombatConfig.DefaultStats = {
  MaxHealth = 100,
  MaxEnergy = 100,
  MaxStamina = 100,
  Power = 10,
  Defense = 10,
  Speed = 16,
}

CombatConfig.Combo = {
  Window = 1.25,
  MaxCount = 5,
  DamageBonusPerHit = 0.05,
}

CombatConfig.Parry = {
  PerfectWindow = 0.12,
  CounterMultiplier = 1.5,
}

CombatConfig.Critical = {
  BaseChance = 0.05,
  DamageMultiplier = 1.75,
}

CombatConfig.Stagger = {
  Threshold = 100,
  HitValue = 25,
  Duration = 0.8,
}

function CombatConfig:GetAction(actionType)
  return self.Actions[actionType]
end

return CombatConfig
