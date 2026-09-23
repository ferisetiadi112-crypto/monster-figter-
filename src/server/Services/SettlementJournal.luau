local HttpService = game:GetService("HttpService")
local DataStoreService = game:GetService("DataStoreService")

local SettlementJournal = {}
local store = DataStoreService:GetDataStore("MonsterFighter_Settlements_v1")
local memory = {}

function SettlementJournal:Create(kind, payload)
  local id = "SET-" .. string.upper(string.gsub(HttpService:GenerateGUID(false), "-", ""))
  local entry = {
    SettlementId = id,
    Kind = kind,
    Status = "Pending",
    Payload = payload,
    CreatedAt = os.time(),
    UpdatedAt = os.time(),
  }
  memory[id] = entry
  return id, table.clone(entry)
end

function SettlementJournal:Complete(id)
  local entry = memory[id]
  if not entry then return false, "NotFound" end
  entry.Status = "Completed"
  entry.UpdatedAt = os.time()
  local ok = pcall(function()
    store:UpdateAsync(id, function()
      return entry
    end)
  end)
  if not ok then
    return false, "JournalSaveFailed"
  end
  return true, table.clone(entry)
end

function SettlementJournal:Fail(id, reason)
  local entry = memory[id]
  if not entry then return false, "NotFound" end
  entry.Status = "Failed"
  entry.FailureReason = reason
  entry.UpdatedAt = os.time()
  return true, table.clone(entry)
end

return SettlementJournal
