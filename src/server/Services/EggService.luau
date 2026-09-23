local HttpService = game:GetService("HttpService")

local EggService = {}
local eggs = {}

function EggService:Create(parentA, parentB, genes)
  local eggId = "EGG-" .. string.upper(string.gsub(HttpService:GenerateGUID(false), "-", ""))
  local now = os.time()

  local egg = {
    EggID = eggId,
    Status = "Egg",
    CreatedAt = now,
    IncubationStartedAt = nil,
    ReadyAt = nil,
    ParentA = parentA,
    ParentB = parentB,
    Genes = genes,
  }

  eggs[eggId] = egg
  return table.clone(egg)
end

function EggService:StartIncubation(eggId)
  local egg = eggs[eggId]
  if not egg or egg.Status ~= "Egg" then
    return false, "InvalidEgg"
  end

  egg.Status = "Incubating"
  egg.IncubationStartedAt = os.time()
  egg.ReadyAt = os.time() + 60
  return true, table.clone(egg)
end

function EggService:Refresh(eggId)
  local egg = eggs[eggId]
  if not egg then
    return nil, "NotFound"
  end

  if egg.Status == "Incubating" and egg.ReadyAt and os.time() >= egg.ReadyAt then
    egg.Status = "Ready"
  end

  return table.clone(egg)
end

function EggService:Get(eggId)
  return egg and table.clone(egg) or nil
end

function EggService:Hatch(eggId)
  local egg = eggs[eggId]
  if not egg then
    return nil, "NotFound"
  end

  self:Refresh(eggId)
  if egg.Status ~= "Ready" then
    return nil, "NotReady"
  end

  egg.Status = "Hatched"
  egg.HatchedAt = os.time()
  return table.clone(egg)
end

function EggService:Remove(eggId)
  if not eggs[eggId] then
    return false, "NotFound"
  end
  eggs[eggId] = nil
  return true
end

function EggService:GetAll()
  local result = {}
  for _, egg in pairs(eggs) do
    table.insert(result, table.clone(egg))
  end
  return result
end

return EggService
