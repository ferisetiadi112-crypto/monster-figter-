local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TransactionService = require(script.Parent.TransactionService)

local EconomyService = {}
local balances = {}

function EconomyService:Load(userId, coins, diamonds)
  balances[userId] = {
    Coins = math.max(0, tonumber(coins) or 0),
    Diamonds = math.max(0, tonumber(diamonds) or 0),
  }
end

function EconomyService:Get(userId)
  local b = balances[userId] or {Coins = 0, Diamonds = 0}
  return table.clone(b)
end

function EconomyService:CreditCoins(userId, amount, transactionId)
  amount = math.floor(tonumber(amount) or 0)
  if amount <= 0 then return false, "InvalidAmount" end
  local ok, reason = TransactionService:Begin(userId, transactionId)
  if not ok then return false, reason end

  balances[userId] = balances[userId] or {Coins = 0, Diamonds = 0}
  balances[userId].Coins += amount
  TransactionService:Complete(userId, transactionId)
  return true, self:Get(userId)
end

function EconomyService:DebitCoins(userId, amount, transactionId)
  amount = math.floor(tonumber(amount) or 0)
  if amount <= 0 then return false, "InvalidAmount" end
  local ok, reason = TransactionService:Begin(userId, transactionId)
  if not ok then return false, reason end

  balances[userId] = balances[userId] or {Coins = 0, Diamonds = 0}
  if balances[userId].Coins < amount then
    return false, "InsufficientCoins"
  end

  balances[userId].Coins -= amount
  TransactionService:Complete(userId, transactionId)
  return true, self:Get(userId)
end

function EconomyService:Cleanup(userId)
  balances[userId] = nil
  TransactionService:Cleanup(userId)
end

return EconomyService
