local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(shared:WaitForChild("Constants"))
local CombatService = require(script.Parent.Services.CombatService)
local PlayerLifecycleService = require(script.Parent.Services.PlayerLifecycleService)
local PersistenceService = require(script.Parent.Services.PersistenceService)

local remotes = ReplicatedStorage:FindFirstChild("MonsterFighterRemotes") or Instance.new("Folder")
remotes.Name = "MonsterFighterRemotes"
remotes.Parent = ReplicatedStorage

local combatRemote = remotes:FindFirstChild("CombatAction") or Instance.new("RemoteEvent")
combatRemote.Name = "CombatAction"
combatRemote.Parent = remotes

combatRemote.OnServerEvent:Connect(function(player, action)
  local valid, reason = CombatService:ValidateAction(player, action)
  combatRemote:FireClient(player, {
    Accepted = valid,
    Action = type(action) == "table" and action.Type or nil,
    Reason = reason,
    ServerTime = os.clock(),
  })
end)

for _, player in ipairs(Players:GetPlayers()) do
  PlayerLifecycleService:PlayerAdded(player)
  PersistenceService:PlayerAdded(player)
end

Players.PlayerRemoving:Connect(function(player)
  PersistenceService:PlayerRemoving(player)
  CombatService:CleanupPlayer(player)
end)

game:BindToClose(function()
  if RunService:IsStudio() then
    task.wait(1)
  end

  for _, player in ipairs(Players:GetPlayers()) do
    PersistenceService:Save(player)
  end

  task.wait(2)
end)

print("[MonsterFighter] Server booted:", Constants.GameName, Constants.Version)
