local HttpService = game:GetService("HttpService")

local TransactionService = {}
local seen = {}

function TransactionService:NewId(prefix)
  return (prefix or "TX") .. "-" .. string.upper(string.gsub(HttpService:GenerateGUID(false), "-", ""))
end

function TransactionService:Begin(userId, transactionId)
  if type(transactionId) ~= "string" or transactionId == "" then
    return false, "InvalidTransactionId"
  end

  seen[userId] = seen[userId] or {}

  if seen[userId][transactionId] then
    return false, "DuplicateTransaction"
  end

  seen[userId][transactionId] = {
    StartedAt = os.time(),
  }

  return true
end

function TransactionService:Complete(userId, transactionId)
  if not seen[userId] or not seen[userId][transactionId] then
    return false, "TransactionNotFound"
  end

  seen[userId][transactionId].CompletedAt = os.time()
  return true
end

function TransactionService:Cleanup(userId)
  seen[userId] = nil
end

return TransactionService
