local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WorldConfig = require(ReplicatedStorage.Shared.WorldConfig)
local MonsterService = require(script.Parent.MonsterService)

local WorldService = {}

function WorldService:GetLocation(locationId)
  for _, location in ipairs(WorldConfig.Locations) do
    if location.Id == locationId then
      return location
    end
  end
  return nil
end

function WorldService:GetWildAt(locationId)
  local result = {}

  for _, monster in ipairs(MonsterService:GetAll()) do
    if monster.Status == "Wild" and monster.LocationId == locationId then
      table.insert(result, monster)
    end
  end

  return result
end

function WorldService:GetAllLocations()
  return table.clone(WorldConfig.Locations)
end

return WorldService
