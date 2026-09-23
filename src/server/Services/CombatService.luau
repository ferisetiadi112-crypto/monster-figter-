local CombatService = {}

local function clamp(value, minValue, maxValue)
  return math.max(minValue, math.min(maxValue, value))
end

function CombatService:ValidateAction(action)
  if type(action) ~= "table" then
    return false
  end

  local allowed = {
    Attack = true,
    Dodge = true,
    Parry = true,
    Skill1 = true,
    Skill2 = true,
    Skill3 = true,
    Ultimate = true,
  }

  return allowed[action.Type] == true
end

function CombatService:CalculateDamage(attacker, defender, skill)
  local power = tonumber(attacker.Power) or 10
  local modifier = tonumber(skill and skill.Multiplier) or 1
  local defense = tonumber(defender.Defense) or 0

  return math.max(1, math.floor(power * modifier * (100 / (100 + clamp(defense, 0, 10000)))))
end

return CombatService
