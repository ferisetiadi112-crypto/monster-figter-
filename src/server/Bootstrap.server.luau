local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(shared:WaitForChild("Constants"))
local CombatService = require(script.Parent.Services.CombatService)
local PlayerLifecycleService = require(script.Parent.Services.PlayerLifecycleService)
local PersistenceService = require(script.Parent.Services.PersistenceService)
local CombatConfig = require(shared:WaitForChild("CombatConfig"))
local WorldPrototypeService = require(script.Parent.Services.WorldPrototypeService)
local PrototypeCombatService = require(script.Parent.Services.PrototypeCombatService)

local remotes = ReplicatedStorage:FindFirstChild("MonsterFighterRemotes") or Instance.new("Folder")
remotes.Name = "MonsterFighterRemotes"
remotes.Parent = ReplicatedStorage

WorldPrototypeService:EnsureWorld()
PrototypeCombatService:CreateDummy()

local combatRemote = remotes:FindFirstChild("CombatAction") or Instance.new("RemoteEvent")
combatRemote.Name = "CombatAction"
combatRemote.Parent = remotes

combatRemote.OnServerEvent:Connect(function(player, action)
  if type(action) == "table" and action.Type and string.match(action.Type, "^Attack$") then
    local protoOk, protoResult = PrototypeCombatService:Attack(player, action.Type)
    if protoOk then
      combatRemote:FireClient(player, {
        Accepted = true,
        Action = action.Type,
        PrototypeCombat = protoResult,
        ServerTime = os.clock(),
      })
      return
    end
  end

  local valid, result = CombatService:ValidateAction(player, action)
  combatRemote:FireClient(player, {
    Accepted = valid,
    Action = type(action) == "table" and action.Type or nil,
    Reason = valid and nil or result,
    State = valid and result or nil,
    ServerTime = os.clock(),
  })
end)

for _, player in ipairs(Players:GetPlayers()) do
  PlayerLifecycleService:PlayerAdded(player)
  PersistenceService:PlayerAdded(player)
  task.spawn(function() WorldPrototypeService:PlayerAdded(player) end)
end

Players.PlayerAdded:Connect(function(player)
  task.spawn(function() WorldPrototypeService:PlayerAdded(player) end)
end)

Players.PlayerRemoving:Connect(function(player)
  PersistenceService:PlayerRemoving(player)
  WorldPrototypeService:PlayerRemoving(player)
  PrototypeCombatService:Cleanup(player)
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

task.spawn(function()
  local last = os.clock()
  while true do
    task.wait(0.1)
    local current = os.clock()
    local delta = current - last
    last = current
    for _, player in ipairs(Players:GetPlayers()) do
      CombatService:Regenerate(player, delta)
    end
  end
end)

print("[MonsterFighter] Server booted:", Constants.GameName, Constants.Version, "Combat:", CombatConfig.DefaultStats.MaxHealth)
