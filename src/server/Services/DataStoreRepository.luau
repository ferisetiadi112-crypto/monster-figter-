local DataStoreService = game:GetService("DataStoreService")

local DataStoreRepository = {}
local store = DataStoreService:GetDataStore("MonsterFighter_Player_v2")

local DEFAULT = {
  Version = 2,
  Coins = 0,
  Diamonds = 0,
  Monsters = {},
  Eggs = {},
  Home = {},
}

local function copyDefault()
  return {
    Version = DEFAULT.Version,
    Coins = DEFAULT.Coins,
    Diamonds = DEFAULT.Diamonds,
    Monsters = {},
    Eggs = {},
    Home = {},
  }
end

function DataStoreRepository:Load(userId)
  local key = "PLAYER_" .. tostring(userId)
  local success, data = pcall(function()
    return store:GetAsync(key)
  end)

  if not success then
    return nil, "LoadFailed"
  end

  if type(data) ~= "table" then
    return copyDefault()
  end

  data.Version = tonumber(data.Version) or 2
  data.Coins = tonumber(data.Coins) or 0
  data.Diamonds = tonumber(data.Diamonds) or 0
  data.Monsters = type(data.Monsters) == "table" and data.Monsters or {}
  data.Eggs = type(data.Eggs) == "table" and data.Eggs or {}
  data.Home = type(data.Home) == "table" and data.Home or {}

  return data
end

function DataStoreRepository:Save(userId, data)
  local key = "PLAYER_" .. tostring(userId)

  if type(data) ~= "table" then
    return false, "InvalidData"
  end

  data.Version = 2
  data.UpdatedAt = os.time()

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
