local CombatService = {}

local ACTION_COOLDOWNS = {Attack=0.35, Dodge=0.8, Parry=0.55, Skill1=3, Skill2=5, Skill3=8, Ultimate=20}
local ACTION_COSTS = {Dodge=20, Parry=10, Skill1=15, Skill2=20, Skill3=25, Ultimate=40}
local lastAction = {}

local function now() return os.clock() end
local function clamp(v,a,b) return math.max(a, math.min(b,v)) end

function CombatService:ValidateAction(player, action)
  if not player or type(action) ~= "table" then return false, "InvalidAction" end
  local t = action.Type
  if type(t) ~= "string" or ACTION_COOLDOWNS[t] == nil then return false, "UnknownAction" end
  lastAction[player] = lastAction[player] or {}
  local previous = lastAction[player][t] or 0
  if now() - previous < ACTION_COOLDOWNS[t] then return false, "Cooldown" end
  lastAction[player][t] = now()
  return true
end

function CombatService:GetEnergyCost(actionType) return ACTION_COSTS[actionType] or 0 end
function CombatService:GetActionCooldown(actionType) return ACTION_COOLDOWNS[actionType] end

function CombatService:CalculateDamage(attacker, defender, skill)
  local power = tonumber(attacker and attacker.Power) or 10
  local modifier = tonumber(skill and skill.Multiplier) or 1
  local defense = tonumber(defender and defender.Defense) or 0
  return math.max(1, math.floor(power * modifier * (100 / (100 + clamp(defense,0,10000)))))
end

function CombatService:CleanupPlayer(player) lastAction[player] = nil end

return CombatService
