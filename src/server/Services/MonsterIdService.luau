local HttpService = game:GetService("HttpService")

local MonsterIdService = {}

function MonsterIdService:Generate()
  local guid = string.gsub(HttpService:GenerateGUID(false), "-", "")
  return "MNF-" .. string.upper(guid)
end

return MonsterIdService
