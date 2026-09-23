local GeneticsEngine = {}

local function contains(list, value)
  for _, item in ipairs(list or {}) do
    if item == value then
      return true
    end
  end
  return false
end

local function chooseDeterministic(first, second, selector)
  if selector % 2 == 0 then
    return first
  end
  return second
end

function GeneticsEngine:ValidateParents(parentA, parentB)
  if not parentA or not parentB then
    return false, "MissingParent"
  end

  if parentA.Gender == parentB.Gender then
    return false, "SameGender"
  end

  if parentA.Status ~= "Owned" or parentB.Status ~= "Owned" then
    return false, "ParentNotOwned"
  end

  if parentA.AgeDays < 30 or parentB.AgeDays < 30 then
    return false, "ParentTooYoung"
  end

  if parentA.BreedingCount >= 3 or parentB.BreedingCount >= 3 then
    return false, "BreedingLimit"
  end

  return true
end

function GeneticsEngine:BuildOffspringGenes(parentA, parentB, seed)
  local selector = math.abs(tonumber(seed) or 1)

  local core = chooseDeterministic(parentA.Core, parentB.Core, selector)
  local traitsA = parentA.Traits or {}
  local traitsB = parentB.Traits or {}
  local skillsA = parentA.Skills or {}
  local skillsB = parentB.Skills or {}

  local inheritedTraits = {}
  for _, trait in ipairs(traitsA) do
    if contains(traitsB, trait) or selector % 3 == 0 then
      table.insert(inheritedTraits, trait)
    end
  end
  for _, trait in ipairs(traitsB) do
    if not contains(inheritedTraits, trait) and selector % 2 == 0 then
      table.insert(inheritedTraits, trait)
    end
  end

  local inheritedSkills = {}
  for _, skill in ipairs(skillsA) do
    if selector % 2 == 0 then
      table.insert(inheritedSkills, skill)
    end
  end
  for _, skill in ipairs(skillsB) do
    if selector % 3 == 0 and not contains(inheritedSkills, skill) then
      table.insert(inheritedSkills, skill)
    end
  end

  return {
    Core = core,
    Traits = inheritedTraits,
    Skills = inheritedSkills,
    ParentA = parentA.MonsterID,
    ParentB = parentB.MonsterID,
    Generation = math.max(parentA.Generation or 1, parentB.Generation or 1) + 1,
    Mutation = selector % 17 == 0,
  }
end

return GeneticsEngine
