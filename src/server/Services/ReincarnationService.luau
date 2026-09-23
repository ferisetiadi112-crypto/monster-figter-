local MonsterService = require(script.Parent.MonsterService)
local PopulationService = require(script.Parent.PopulationService)

local ReincarnationService = {}

function ReincarnationService:MarkFallen(monsterId, reason)
  local monster = MonsterService:Get(monsterId)
  if not monster then
    return false, "NotFound"
  end

  if monster.Status == "Fallen" then
    return false, "AlreadyFallen"
  end

  local ok, err = MonsterService:RecordFallen(monsterId, reason)
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

function ReincarnationService:WildRebirth(monsterId, locationId)
  local monster = MonsterService:Get(monsterId)
  if not monster or monster.Status ~= "Fallen" then
    return false, "NotReincarnatable"
  end

  if not PopulationService:CanCreateWild(locationId) then
    return false, "PopulationLimit"
  end

  if not PopulationService:RegisterWild(locationId) then
    return false, "WildSlotUnavailable"
  end

  local reborn, reason = MonsterService:ReincarnateAsWild(monsterId, locationId)
  if not reborn then
    PopulationService:ReleaseWild(locationId)
    return false, reason
  end

  return true, reborn
end
