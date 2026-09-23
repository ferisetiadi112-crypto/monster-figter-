local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(shared:WaitForChild("Constants"))
local CombatService = require(script.Parent.Services.CombatService)

local remotes = ReplicatedStorage:FindFirstChild("MonsterFighterRemotes") or Instance.new("Folder")
remotes.Name = "MonsterFighterRemotes"
remotes.Parent = ReplicatedStorage

local combatRemote = remotes:FindFirstChild("CombatAction") or Instance.new("RemoteEvent")
combatRemote.Name = "CombatAction"
combatRemote.Parent = remotes

combatRemote.OnServerEvent:Connect(function(player, action)
  local valid, reason = CombatService:ValidateAction(player, action)
  combatRemote:FireClient(player, {Accepted=valid, Action=type(action)=="table" and action.Type or nil, Reason=reason, ServerTime=os.clock()})
end)

Players.PlayerRemoving:Connect(function(player) CombatService:CleanupPlayer(player) end)
print("[MonsterFighter] Server booted:", Constants.GameName, Constants.Version)
