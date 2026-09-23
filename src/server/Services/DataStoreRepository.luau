local DataStoreService = game:GetService("DataStoreService")

local DataStoreRepository = {}
local store = DataStoreService:GetDataStore("MonsterFighter_Player_v1")

function DataStoreRepository:Load(userId)
  local key = "PLAYER_" .. tostring(userId)
  local success, data = pcall(function()
    return store:GetAsync(key)
  end)

  if not success then
    return nil, "LoadFailed"
  end

  return data or {
    Version = 1,
    Coins = 0,
    Diamonds = 0,
    Monsters = {},
    Eggs = {},
    Home = {},
  }
end

function DataStoreRepository:Save(userId, data)
  local key = "PLAYER_" .. tostring(userId)
  local success, result = pcall(function()
    return store:UpdateAsync(key, function()
      return data
    end)
  end)

  if not success then
    return false, "SaveFailed"
  end

  return true, result
end

return DataStoreRepository
