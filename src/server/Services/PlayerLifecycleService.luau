local Players = game:GetService("Players")

local PopulationService = require(script.Parent.PopulationService)

local PlayerLifecycleService = {}

local registered = {}

function PlayerLifecycleService:PlayerAdded(player)
  if registered[player.UserId] then
    return
  end

  registered[player.UserId] = true
  PopulationService:RegisterAccount()
  PopulationService:CreateStarterHold()
end

function PlayerLifecycleService:PlayerRemoving(player)
  registered[player.UserId] = nil
end

Players.PlayerAdded:Connect(function(player)
  PlayerLifecycleService:PlayerAdded(player)
end)

Players.PlayerRemoving:Connect(function(player)
  PlayerLifecycleService:PlayerRemoving(player)
end)

return PlayerLifecycleService
