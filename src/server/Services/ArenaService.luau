local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Shared.Constants)
local MonsterSchema = require(ReplicatedStorage.Shared.MonsterSchema)

local ArenaService = {}
local belts = {}

local function makeBelt(tier, number)
  return {
    BeltId = tier .. "-Belt-" .. tostring(number),
    Tier = tier,
    Number = number,
    HolderUserId = nil,
    HolderMonsterId = nil,
    Wins = 0,
    Defenses = 0,
    UpdatedAt = os.time(),
  }
end

for _, tier in ipairs(Constants.Arena.Tiers) do
  belts[tier] = {}
  for number = 1, Constants.Arena.BeltsPerTier do
    belts[tier][number] = makeBelt(tier, number)
  end
end

function ArenaService:GetTier(tier)
  if not belts[tier] then
    return nil
  end
  local result = {}
  for _, belt in ipairs(belts[tier]) do
    table.insert(result, table.clone(belt))
  end
  return result
end

function ArenaService:GetAllBelts()
  local result = {}
  for _, tier in ipairs(Constants.Arena.Tiers) do
    result[tier] = self:GetTier(tier)
  end
  return result
end

function ArenaService:GetStake(tier)
  return Constants.Arena.Stake[tier]
end

function ArenaService:ValidateChallenge(tier, monster)
  if not belts[tier] or not monster then
    return false, "InvalidChallenge"
  end
  if monster.Status ~= MonsterSchema.Status.OWNED then
    return false, "MonsterNotOwned"
  end

  local ageDays = math.max(0, math.floor((os.time() - monster.BirthTimestamp) / 86400))
  if ageDays < Constants.Lifecycle.BattleAgeDays then
    return false, "BattleAgeLocked"
  end

  local care = monster.Care or {Food = 100, Water = 100}
  if care.Food < 20 or care.Water < 20 then
    return false, "CareTooLow"
  end

  return true
end

function ArenaService:RecordWin(tier, player, monster, defeatedHolder)
  if not belts[tier] or not player or not monster then
    return false, "InvalidResult"
  end

  local candidates = belts[tier]
  local target = candidates[1]
  if defeatedHolder and defeatedHolder.BeltNumber then
    target = candidates[defeatedHolder.BeltNumber] or target
  end

  if target.HolderUserId == player.UserId and target.HolderMonsterId == monster.MonsterID then
    target.Defenses += 1
  else
    target.HolderUserId = player.UserId
    target.HolderMonsterId = monster.MonsterID
    target.Wins += 1
    target.Defenses = 0
  end

  target.UpdatedAt = os.time()
  return true, table.clone(target)
end

return ArenaService
