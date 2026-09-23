local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local WorldPrototype = {}
local companions = {}

local function part(parent, name, size, color, cframe, shape)
  local p = Instance.new("Part")
  p.Name = name
  p.Size = size
  p.Color = color
  p.Material = Enum.Material.SmoothPlastic
  p.Anchored = true
  p.CanCollide = false
  if shape then p.Shape = shape end
  p.CFrame = cframe
  p.Parent = parent
  return p
end

local function createMonster(player)
  local model = Instance.new("Model")
  model.Name = "Pyroxi_" .. player.UserId
  model:SetAttribute("Species", "Pyroxi")
  model:SetAttribute("Prototype", true)
  model.Parent = Workspace

  local root = part(model, "Root", Vector3.new(1.8, 1.4, 2.2), Color3.fromRGB(225, 92, 38), CFrame.new(0, 2, 0), Enum.PartType.Ball)
  model.PrimaryPart = root

  part(model, "Head", Vector3.new(1.5, 1.35, 1.45), Color3.fromRGB(241, 116, 44), CFrame.new(0, 2.8, -0.55), Enum.PartType.Ball)
  part(model, "EarL", Vector3.new(.35, .8, .35), Color3.fromRGB(255, 170, 48), CFrame.new(-.55, 3.35, -.45), Enum.PartType.Ball)
  part(model, "EarR", Vector3.new(.35, .8, .35), Color3.fromRGB(255, 170, 48), CFrame.new(.55, 3.35, -.45), Enum.PartType.Ball)
  part(model, "EyeL", Vector3.new(.18, .22, .12), Color3.fromRGB(25, 25, 25), CFrame.new(-.32, 2.92, -1.22), Enum.PartType.Ball)
  part(model, "EyeR", Vector3.new(.18, .22, .12), Color3.fromRGB(25, 25, 25), CFrame.new(.32, 2.92, -1.22), Enum.PartType.Ball)
  part(model, "Tail", Vector3.new(.35, 1.2, .35), Color3.fromRGB(255, 183, 54), CFrame.new(0, 2.2, 1.35), Enum.PartType.Ball)
  part(model, "FootL", Vector3.new(.55, .35, .7), Color3.fromRGB(193, 65, 34), CFrame.new(-.6, 1.35, -.25), Enum.PartType.Block)
  part(model, "FootR", Vector3.new(.55, .35, .7), Color3.fromRGB(193, 65, 34), CFrame.new(.6, 1.35, -.25), Enum.PartType.Block)

  return model
end

function WorldPrototype:EnsureWorld()
  local folder = Workspace:FindFirstChild("MonsterFighterPrototype")
  if folder then return folder end

  folder = Instance.new("Folder")
  folder.Name = "MonsterFighterPrototype"
  folder.Parent = Workspace

  local ground = part(folder, "PrototypeGround", Vector3.new(180, 1, 180), Color3.fromRGB(82, 145, 75), CFrame.new(0, -0.5, 0))
  ground.CanCollide = true

  for i = 1, 8 do
    local angle = (i / 8) * math.pi * 2
    local x, z = math.cos(angle) * 55, math.sin(angle) * 55
    part(folder, "Tree_" .. i, Vector3.new(3, 12, 3), Color3.fromRGB(100, 67, 42), CFrame.new(x, 6, z))
    part(folder, "Crown_" .. i, Vector3.new(11, 9, 11), Color3.fromRGB(53, 125, 65), CFrame.new(x, 13, z), Enum.PartType.Ball)
  end

  return folder
end

function WorldPrototype:PlayerAdded(player)
  self:EnsureWorld()
  if companions[player] then return end

  local character = player.Character or player.CharacterAdded:Wait()
  local monster = createMonster(player)
  local root = character:FindFirstChild("HumanoidRootPart")
  if root then
    monster:PivotTo(root.CFrame * CFrame.new(4, 0, 5))
  end
  companions[player] = monster
end

function WorldPrototype:PlayerRemoving(player)
  local monster = companions[player]
  if monster then monster:Destroy() end
  companions[player] = nil
end

RunService.Heartbeat:Connect(function(dt)
  for player, monster in pairs(companions) do
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root and monster and monster.Parent then
      local target = root.CFrame * CFrame.new(4, 0, 5)
      local current = monster:GetPivot()
      local alpha = math.clamp(dt * 5, 0, 1)
      monster:PivotTo(current:Lerp(target, alpha))
    end
  end
end)

return WorldPrototype
