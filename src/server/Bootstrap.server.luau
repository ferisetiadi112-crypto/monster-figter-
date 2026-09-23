local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(shared:WaitForChild("Constants"))
local CombatService = require(script.Parent.Services.CombatService)

local remotes = ReplicatedStorage:FindFirstChild("MonsterFighterRemotes")
if not remotes then
  remotes = Instance.new("Folder")
  remotes.Name = "MonsterFighterRemotes"
  remotes.Parent = ReplicatedStorage
end

local combatRemote = remotes:FindFirstChild("CombatAction")
if not combatRemote then
  combatRemote = Instance.new("RemoteEvent")
  combatRemote.Name = "CombatAction"
  combatRemote.Parent = remotes
end

combatRemote.OnServerEvent:Connect(function(player, action)
  local valid, reason = CombatService:ValidateAction(player, action)

  combatRemote:FireClient(player, {
    Accepted = valid,
    Action = type(action) == "table" and action.Type or nil,
    Reason = reason,
    ServerTime = os.clock(),
  })
end)

Players.PlayerRemoving:Connect(function(player)
  CombatService:CleanupPlayer(player)
end)

print("[MonsterFighter] Server booted:", Constants.GameName, Constants.Version)
print("[MonsterFighter] CombatAction RemoteEvent ready.")
