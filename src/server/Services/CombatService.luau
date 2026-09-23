local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CombatConfig = require(ReplicatedStorage.Shared.CombatConfig)

local CombatService = {}
local state = {}

local function now()
  return os.clock()
end

local function clamp(v, a, b)
  return math.max(a, math.min(b, v))
end

local function getState(player)
  state[player] = state[player] or {
    Energy = CombatConfig.DefaultStats.MaxEnergy,
    Stamina = CombatConfig.DefaultStats.MaxStamina,
    ComboCount = 0,
    LastHitAt = 0,
    Guarding = false,
    ParryStartedAt = 0,
    Stagger = 0,
    Health = CombatConfig.DefaultStats.MaxHealth,
    LastAction = {},
  }
  return state[player]
end

function CombatService:ValidateAction(player, action)
  if not player or type(action) ~= "table" then
    return false, "InvalidAction"
  end

  local config = CombatConfig:GetAction(action.Type)
  if not config then
    return false, "UnknownAction"
  end

  local s = getState(player)
  local current = now()
  local previous = s.LastAction[action.Type] or 0

  if current - previous < config.Cooldown then
    return false, "Cooldown"
  end

  if s.Stagger > 0 then
    return false, "Staggered"
  end

  if s.Stamina < (config.StaminaCost or 0) then
    return false, "InsufficientStamina"
  end

  if s.Energy < (config.EnergyCost or 0) then
    return false, "InsufficientEnergy"
  end

  s.Stamina -= config.StaminaCost or 0
  s.Energy -= config.EnergyCost or 0
  s.LastAction[action.Type] = current

  if action.Type == "Parry" then
    s.Guarding = true
    s.ParryStartedAt = current
  elseif action.Type ~= "Attack" and string.sub(action.Type, 1, 5) ~= "Skill" and action.Type ~= "Ultimate" then
    s.Guarding = false
  end

  if action.Type == "Attack" or string.sub(action.Type, 1, 5) == "Skill" or action.Type == "Ultimate" then
    if current - s.LastHitAt <= CombatConfig.Combo.Window then
      s.ComboCount = math.min(CombatConfig.Combo.MaxCount, s.ComboCount + 1)
    else
      s.ComboCount = 1
    end
    s.LastHitAt = current
  end

  return true, {
    Action = action.Type,
    ComboCount = s.ComboCount,
    Energy = s.Energy,
    Stamina = s.Stamina,
  }
end

function CombatService:Regenerate(player, deltaTime)
  local s = getState(player)
  s.Energy = clamp(s.Energy + 20 * deltaTime, 0, CombatConfig.DefaultStats.MaxEnergy)
  s.Stamina = clamp(s.Stamina + 30 * deltaTime, 0, CombatConfig.DefaultStats.MaxStamina)
  if s.Stagger > 0 then
    s.Stagger = math.max(0, s.Stagger - deltaTime)
  end
  if now() - s.LastHitAt > CombatConfig.Combo.Window then
    s.ComboCount = 0
  end
end

function CombatService:GetCombatStats(monster)
  local stats = monster and monster.Stats or CombatConfig.DefaultStats
  return {
    Power = tonumber(stats.Power) or CombatConfig.DefaultStats.Power,
    Defense = tonumber(stats.Defense) or CombatConfig.DefaultStats.Defense,
    Speed = tonumber(stats.Speed) or CombatConfig.DefaultStats.Speed,
    MaxHealth = tonumber(stats.MaxHealth) or CombatConfig.DefaultStats.MaxHealth,
  }
end

function CombatService:CalculateDamage(attacker, defender, skill, options)
  local attackerStats = self:GetCombatStats(attacker)
  local defenderStats = self:GetCombatStats(defender)
  local power = attackerStats.Power
  local defense = defenderStats.Defense
  local action = skill or {}
  local modifier = tonumber(action.Multiplier) or 1
  local comboCount = tonumber(options and options.ComboCount) or 1
  local comboBonus = 1 + math.max(0, comboCount - 1) * CombatConfig.Combo.DamageBonusPerHit

  local critical = options and options.Critical == true
  local criticalBonus = critical and CombatConfig.Critical.DamageMultiplier or 1
  local raw = power * modifier * comboBonus * criticalBonus
  return math.max(1, math.floor(raw * (100 / (100 + clamp(defense, 0, 10000)))))
end

function CombatService:RollCritical(attacker, luck)
  local stats = self:GetCombatStats(attacker)
  local speedBonus = math.max(0, stats.Speed - CombatConfig.DefaultStats.Speed) * 0.0025
  local chance = clamp(CombatConfig.Critical.BaseChance + speedBonus + (tonumber(luck) or 0), 0, 1)
  return math.random() < chance
end

function CombatService:ApplyHit(player, amount)
  local s = getState(player)
  local damage = math.max(0, math.floor(tonumber(amount) or 0))
  s.Health = math.max(0, s.Health - damage)
  s.Stagger = s.Stagger + CombatConfig.Stagger.HitValue
  if s.Stagger >= CombatConfig.Stagger.Threshold then
    s.Stagger = 0
    s.StaggeredUntil = now() + CombatConfig.Stagger.Duration
  end
  return {
    Health = s.Health,
    Staggered = s.StaggeredUntil and s.StaggeredUntil > now() or false,
  }
end

function CombatService:IsPerfectParry(player, attackStartedAt)
  local s = getState(player)
  if not s.Guarding then
    return false
  end
  local elapsed = math.abs((tonumber(attackStartedAt) or now()) - s.ParryStartedAt)
  return elapsed <= CombatConfig.Parry.PerfectWindow
end

function CombatService:CounterDamage(amount)
  return math.max(1, math.floor(amount * CombatConfig.Parry.CounterMultiplier))
end

function CombatService:GetState(player)
  local s = getState(player)
  return {
    Energy = s.Energy,
    Stamina = s.Stamina,
    Health = s.Health,
    ComboCount = s.ComboCount,
    Stagger = s.Stagger,
    Guarding = s.Guarding,
  }
end

function CombatService:CleanupPlayer(player)
  state[player] = nil
end

return CombatService
