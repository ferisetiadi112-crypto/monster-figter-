local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WorldConfig = require(ReplicatedStorage.Shared.WorldConfig)
local MonsterService = require(script.Parent.MonsterService)

local WorldService = {}

local activeWildByLocation = {}

for _, location in ipairs(WorldConfig.Locations) do
  activeWildByLocation[location.Id] = {}
end

function WorldService:GetLocation(locationId)
  for _, location in ipairs(WorldConfig.Locations) do
    if location.Id == locationId then
      return location
    end
  end
  return nil
end

function WorldService:RegisterWild(monsterId, locationId)
  local location = self:GetLocation(locationId)
  if not location or not activeWildByLocation[locationId] then
    return false, "InvalidLocation"
  end

  if #activeWildByLocation[locationId] >= location.WildSlots then
    return false, "WildSlotFull"
  end

  table.insert(activeWildByLocation[locationId], monsterId)
  return true
end

function WorldService:GetWildAt(locationId)
  local ids = activeWildByLocation[locationId] or {}
  local result = {}

  for _, monsterId in ipairs(ids) do
    local monster = MonsterService:Get(monsterId)
    if monster then
      table.insert(result, monster)
    end
  end

  return result
end

return WorldService
