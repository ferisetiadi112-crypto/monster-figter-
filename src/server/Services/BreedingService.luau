local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MonsterService = require(script.Parent.MonsterService)
local GeneticsEngine = require(script.Parent.GeneticsEngine)
local EggService = require(script.Parent.EggService)
local PopulationService = require(script.Parent.PopulationService)

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

function BreedingService:HatchEgg(player, eggId)
  local egg = EggService:Get(eggId)
  if not egg then
    return nil, "EggNotFound"
  end

  if egg.Status ~= "Ready" then
    return nil, "EggNotReady"
  end

  if not PopulationService:CanMaterializeOwned() then
    PopulationService:MoveToReserve()
    return nil, "PopulationFullWaiting"
  end

  local hatched = EggService:Hatch(eggId)
  if not hatched then
    return nil, "HatchFailed"
  end

  local monster, reason = MonsterService:MaterializeFromEgg(player, hatched)
  if not monster then
    return nil, reason
  end

  if not PopulationService:AddOwned() then
    return nil, "PopulationCommitFailed"
  end

  EggService:Remove(eggId)
  return monster
end
