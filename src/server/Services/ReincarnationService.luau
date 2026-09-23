local MonsterService = require(script.Parent.MonsterService)

local ReincarnationService = {}

function ReincarnationService:MarkFallen(monsterId, reason)
  local monster = MonsterService:Get(monsterId)
  if not monster then
    return false, "NotFound"
  end

  if monster.Status == "Fallen" then
    return false, "AlreadyFallen"
  end

  local ok, err = MonsterService:SetStatus(monsterId, "Fallen")
  if not ok then
    return false, err
  end

  return true, {
    MonsterID = monsterId,
    Reason = reason or "ArenaDefeat",
    FallenAt = os.time(),
  }
end

return ReincarnationService
