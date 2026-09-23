local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MonsterService = require(script.Parent.MonsterService)
local GeneticsEngine = require(script.Parent.GeneticsEngine)
local EggService = require(script.Parent.EggService)

local BreedingService = {}

function BreedingService:CreateEgg(player, parentAId, parentBId)
  local parentA = MonsterService:Get(parentAId)
  local parentB = MonsterService:Get(parentBId)

  if not parentA or not parentB then
    return nil, "ParentNotFound"
  end

  if parentA.OwnerUserId ~= player.UserId or parentB.OwnerUserId ~= player.UserId then
    return nil, "NotOwner"
  end

  local valid, reason = GeneticsEngine:ValidateParents(parentA, parentB)
  if not valid then
    return nil, reason
  end

  local genes = GeneticsEngine:BuildOffspringGenes(
    parentA,
    parentB,
    os.time() + player.UserId
  )

  -- Reserve both breeding uses before creating the egg.
  local aOk, aReason = MonsterService:IncrementBreedingCount(parentA.MonsterID)
  if not aOk then
    return nil, aReason
  end

  local bOk, bReason = MonsterService:IncrementBreedingCount(parentB.MonsterID)
  if not bOk then
    return nil, bReason
  end

  local egg = EggService:Create(parentA.MonsterID, parentB.MonsterID, genes)
  return egg
end

return BreedingService
