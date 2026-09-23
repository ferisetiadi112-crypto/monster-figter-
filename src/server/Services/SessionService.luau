local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")

local SessionService = {}

local lockStore = DataStoreService:GetDataStore("MonsterFighter_Sessions_v1")
local sessions = {}
local SESSION_TTL = 120

local function makeToken()
  return HttpService:GenerateGUID(false)
end

function SessionService:Acquire(userId)
  local key = "LOCK_" .. tostring(userId)
  local token = makeToken()
  local now = os.time()

  local success, result = pcall(function()
    return lockStore:UpdateAsync(key, function(current)
      if current and current.ExpiresAt and current.ExpiresAt > now then
        return current
      end

      return {
        Token = token,
        AcquiredAt = now,
        ExpiresAt = now + SESSION_TTL,
      }
    end)
  end)

  if not success or not result or result.Token ~= token then
    return false, "SessionLocked"
  end

  sessions[userId] = {
    Token = token,
    ExpiresAt = result.ExpiresAt,
  }

  return true
end

function SessionService:Refresh(userId)
  local session = sessions[userId]
  if not session then
    return false, "NoSession"
  end

  local key = "LOCK_" .. tostring(userId)
  local now = os.time()

  local success, result = pcall(function()
    return lockStore:UpdateAsync(key, function(current)
      if not current or current.Token ~= session.Token then
        return current
      end

      current.ExpiresAt = now + SESSION_TTL
      return current
    end)
  end)

  if not success or not result or result.Token ~= session.Token then
    sessions[userId] = nil
    return false, "SessionLost"
  end

  session.ExpiresAt = result.ExpiresAt
  return true
end

function SessionService:Release(userId)
  local session = sessions[userId]
  if not session then
    return true
  end

  local key = "LOCK_" .. tostring(userId)

  pcall(function()
    lockStore:UpdateAsync(key, function(current)
      if current and current.Token == session.Token then
        return nil
      end
      return current
    end)
  end)

  sessions[userId] = nil
  return true
end

function SessionService:HasSession(userId)
  return sessions[userId] ~= nil
end

return SessionService
