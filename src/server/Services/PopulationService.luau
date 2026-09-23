local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constants = require(ReplicatedStorage.Shared.Constants)

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

function PopulationService:RegisterAccount()
  state.AccountCount += 1
  state.Capacity = state.AccountCount * Constants.Population.MonstersPerNewAccount
end

function PopulationService:GetState()
  return table.clone(state)
end

function PopulationService:CanCreateWild()
  return state.WildCount < Constants.Population.MaxWildMonsters
    and (state.OwnedCount + state.WildCount + state.ReserveCount + state.StarterHoldCount) < state.Capacity
end

function PopulationService:CreateStarterHold()
  if state.StarterHoldCount >= state.AccountCount then
    return false
  end
  local used = state.OwnedCount + state.WildCount + state.ReserveCount + state.StarterHoldCount
  if used >= state.Capacity then
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
