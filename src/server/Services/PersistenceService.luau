local Players = game:GetService("Players")

local SessionService = require(script.Parent.SessionService)
local DataStoreRepository = require(script.Parent.DataStoreRepository)
local PopulationService = require(script.Parent.PopulationService)
local MonsterService = require(script.Parent.MonsterService)
local EggService = require(script.Parent.EggService)
local SnapshotService = require(script.Parent.SnapshotService)

local PersistenceService = {}
local loaded = {}

function PersistenceService:PlayerAdded(player)
  local userId = player.UserId

  local acquired, reason = SessionService:Acquire(userId)
  if not acquired then
    player:Kick("Your Monster Fighter data is already active on another server. Please try again.")
    return false, reason
  end

  local data, loadReason = DataStoreRepository:Load(userId)
  if not data then
    SessionService:Release(userId)
    player:Kick("Monster Fighter data could not be loaded. Please try again.")
    return false, loadReason
  end

  loaded[userId] = data
  return true, data
end

function PersistenceService:Save(player)
  if not player or not loaded[player.UserId] then
    return false, "NotLoaded"
  end

  if not SessionService:Refresh(player.UserId) then
    return false, "SessionLost"
  end

  local snapshot = SnapshotService:Build(player, MonsterService, EggService)
  local stored = loaded[player.UserId]

  snapshot.Coins = stored.Coins or 0
  snapshot.Diamonds = stored.Diamonds or 0
  snapshot.Home = stored.Home or {}

  local success, reason = DataStoreRepository:Save(player.UserId, snapshot)
  if success then
    loaded[player.UserId] = snapshot
  end

  return success, reason
end

function PersistenceService:PlayerRemoving(player)
  self:Save(player)
  loaded[player.UserId] = nil
  SessionService:Release(player.UserId)
end

function PersistenceService:Get(player)
  return loaded[player.UserId]
end

Players.PlayerAdded:Connect(function(player)
  PersistenceService:PlayerAdded(player)
end)

Players.PlayerRemoving:Connect(function(player)
  PersistenceService:PlayerRemoving(player)
end)

return PersistenceService
