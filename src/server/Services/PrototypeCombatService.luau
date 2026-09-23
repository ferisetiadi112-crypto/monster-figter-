local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local CombatConfig = require(ReplicatedStorage.Shared.CombatConfig)

local PrototypeCombatService = {}
local dummyHealth = 100
local lastAttack = {}

local function getDummy()
  local folder = Workspace:FindFirstChild("MonsterFighterPrototype")
  return folder and folder:FindFirstChild("TrainingDummy")
end

function PrototypeCombatService:CreateDummy()
  local folder = Workspace:FindFirstChild("MonsterFighterPrototype")
  if not folder or folder:FindFirstChild("TrainingDummy") then return end

  local model = Instance.new("Model")
  model.Name = "TrainingDummy"
  model:SetAttribute("PrototypeEnemy", true)
  model.Parent = folder

  local root = Instance.new("Part")
  root.Name = "Root"
  root.Size = Vector3.new(2.5, 4, 2.5)
  root.Position = Vector3.new(0, 2, -12)
  root.Anchored = true
  root.CanCollide = true
  root.Color = Color3.fromRGB(120, 120, 130)
  root.Parent = model
  model.PrimaryPart = root

  local head = Instance.new("Part")
  head.Name = "Head"
  head.Shape = Enum.PartType.Ball
  head.Size = Vector3.new(2, 2, 2)
  head.Position = Vector3.new(0, 5, -12)
  head.Anchored = true
  head.CanCollide = false
  head.Color = Color3.fromRGB(150, 150, 160)
  head.Parent = model

  local health = Instance.new("IntValue")
  health.Name = "Health"
  health.Value = dummyHealth
  health.Parent = model
end

function PrototypeCombatService:ResetDummy()
  local dummy = getDummy()
  if not dummy then return end
  local health = dummy:FindFirstChild("Health")
  if health then health.Value = dummyHealth end
  dummy:SetAttribute("Defeated", false)
end

function PrototypeCombatService:Attack(player, actionType)
  local character = player.Character
  local root = character and character:FindFirstChild("HumanoidRootPart")
  local dummy = getDummy()
  if not root or not dummy or not dummy.PrimaryPart then
    return false, "TargetUnavailable"
  end

  local now = os.clock()
  local previous = lastAttack[player.UserId] or 0
  local config = CombatConfig.Actions[actionType] or CombatConfig.Actions.Attack
  if now - previous < config.Cooldown then
    return false, "Cooldown"
  end
  lastAttack[player.UserId] = now

  local distance = (root.Position - dummy.PrimaryPart.Position).Magnitude
  if distance > 14 then
    return false, "OutOfRange"
  end

  local health = dummy:FindFirstChild("Health")
  if not health or health.Value <= 0 then
    return false, "TargetDefeated"
  end

  local damage = math.max(1, math.floor(10 * (config.DamageMultiplier or 1)))
  health.Value = math.max(0, health.Value - damage)
  if health.Value <= 0 then
    dummy:SetAttribute("Defeated", true)
  end

  return true, {
    Damage = damage,
    Health = health.Value,
    MaxHealth = dummyHealth,
    Defeated = health.Value <= 0,
  }
end

function PrototypeCombatService:Cleanup(player)
  lastAttack[player.UserId] = nil
end

return PrototypeCombatService
