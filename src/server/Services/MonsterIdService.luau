local MonsterIdService = {}

local nextSequence = 0

local function pad(value, width)
  return string.rep("0", math.max(0, width - #tostring(value))) .. tostring(value)
end

function MonsterIdService:Generate()
  nextSequence += 1
  return "MNF-" .. pad(nextSequence, 6)
end

return MonsterIdService
