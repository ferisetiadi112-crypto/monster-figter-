local MonsterSchema = require(game:GetService("ReplicatedStorage").Shared.MonsterSchema)

local CompanionService = {}
local active = {}

function CompanionService:SetMode(player, monsterService, monsterId, mode)
  if not player or type(monsterId) ~= "string" then
    return false, "InvalidRequest"
  end

  local monster = monsterService:Get(monsterId)
  if not monster or monster.OwnerUserId ~= player.UserId then
    return false, "NotOwner"
  end

  if monster.Status ~= MonsterSchema.Status.OWNED then
    return false, "NotAvailable"
  end

  if mode ~= "Following" and mode ~= "Stored" then
    return false, "InvalidMode"
  end

  active[player.UserId] = mode == "Following" and monsterId or nil
  return true, mode
end

function CompanionService:GetActive(player)
  return player and active[player.UserId] or nil
end

function CompanionService:Cleanup(player)
  if player then
    active[player.UserId] = nil
  end
end

return CompanionService
