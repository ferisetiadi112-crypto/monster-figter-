local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Shared.Constants)
local MonsterSchema = require(ReplicatedStorage.Shared.MonsterSchema)
local TransactionService = require(script.Parent.TransactionService)
local EconomyService = require(script.Parent.EconomyService)
local SettlementJournal = require(script.Parent.SettlementJournal)

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

function ArenaService:SettleMatch(result)
  if type(result) ~= "table" then
    return false, "InvalidResult"
  end

  local winnerId = result.WinnerUserId
  local loserId = result.LoserUserId
  local stake = math.floor(tonumber(result.StakePerPlayer) or 0)
  if not winnerId or not loserId or stake <= 0 then
    return false, "InvalidSettlement"
  end

  local settlementId = SettlementJournal:Create("Arena", result)
  local winnerTx = TransactionService:NewId("ARENA")
  local loserTx = TransactionService:NewId("ARENA")

  local loserDebit, debitReason = EconomyService:DebitCoins(loserId, stake, loserTx)
  if not loserDebit then
    SettlementJournal:Fail(settlementId, debitReason)
    return false, debitReason
  end

  local winnerCredit, creditReason = EconomyService:CreditCoins(winnerId, stake * 2, winnerTx)
  if not winnerCredit then
    SettlementJournal:Fail(settlementId, creditReason)
    return false, "SettlementPendingRecovery"
  end

  SettlementJournal:Complete(settlementId)
  return true, {
    SettlementId = settlementId,
    WinnerBalance = winnerCredit,
  }
end

function ArenaService:ResolveMatch(tier, winnerPlayer, winnerMonster, loserPlayer, loserMonster, defeatedHolder)
  local ok, result = self:RecordWin(tier, winnerPlayer, winnerMonster, defeatedHolder)
  if not ok then
    return false, result
  end

  local stake = self:GetStake(tier)
  local payout = stake * 2

  if loserMonster and loserMonster.MonsterID == winnerMonster.MonsterID then
    return false, "InvalidParticipants"
  end

  return true, {
    Tier = tier,
    StakePerPlayer = stake,
    Pot = payout,
    WinnerUserId = winnerPlayer.UserId,
    WinnerMonsterId = winnerMonster.MonsterID,
    LoserUserId = loserPlayer and loserPlayer.UserId or nil,
    LoserMonsterId = loserMonster and loserMonster.MonsterID or nil,
    Belt = result,
  }
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
