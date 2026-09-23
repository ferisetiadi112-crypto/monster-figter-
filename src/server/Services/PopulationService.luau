local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constants = require(ReplicatedStorage.Shared.Constants)
local WorldConfig = require(ReplicatedStorage.Shared.WorldConfig)

local PopulationService = {}

local state = {
  AccountCount = 0,
  Capacity = 0,
  OwnedCount = 0,
  WildCount = 0,
  ReserveCount = 0,
  StarterHoldCount = 0,
  IncubatingCount = 0,
}

local wildByLocation = {}
for _, location in ipairs(WorldConfig.Locations) do
  wildByLocation[location.Id] = 0
end

function PopulationService:RegisterAccount()
  state.AccountCount += 1
  state.Capacity = state.AccountCount * Constants.Population.MonstersPerNewAccount
end

function PopulationService:GetState()
  local snapshot = table.clone(state)
  snapshot.WildByLocation = table.clone(wildByLocation)
  return snapshot
end

function PopulationService:GetUsedPopulation()
  return state.OwnedCount
    + state.WildCount
    + state.ReserveCount
    + state.StarterHoldCount
end

function PopulationService:GetAvailableCapacity()
  return math.max(0, state.Capacity - self:GetUsedPopulation())
end

function PopulationService:CanCreateWild(locationId)
  local location = nil
  for _, candidate in ipairs(WorldConfig.Locations) do
    if candidate.Id == locationId then
      location = candidate
      break
    end
  end

  if not location then
    return false
  end

  if state.WildCount >= Constants.Population.MaxWildMonsters then
    return false
  end

  if (wildByLocation[locationId] or 0) >= location.WildSlots then
    return false
  end

  return self:GetUsedPopulation() < state.Capacity
end

function PopulationService:RegisterWild(locationId)
  if not self:CanCreateWild(locationId) then
    return false
  end

  state.WildCount += 1
  wildByLocation[locationId] = (wildByLocation[locationId] or 0) + 1
  return true
end

function PopulationService:ReleaseWild(locationId)
  if not wildByLocation[locationId] or wildByLocation[locationId] <= 0 then
    return false
  end

  wildByLocation[locationId] -= 1
  state.WildCount = math.max(0, state.WildCount - 1)
  return true
end

function PopulationService:CreateStarterHold()
  if state.StarterHoldCount >= state.AccountCount then
    return false
  end

  if self:GetUsedPopulation() >= state.Capacity then
    return false
  end

  state.StarterHoldCount += 1
  return true
end

function PopulationService:ConsumeStarterHold()
  if state.StarterHoldCount <= 0 then
    return false
  end

  state.StarterHoldCount -= 1
  state.OwnedCount += 1
  return true
end

return PopulationService
