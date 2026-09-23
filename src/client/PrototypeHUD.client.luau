local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("MonsterFighterRemotes")
local combatRemote = remotes:WaitForChild("CombatAction")

local gui = Instance.new("ScreenGui")
gui.Name = "MonsterFighterHUD"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local title = Instance.new("TextLabel")
title.Size = UDim2.fromOffset(300, 40)
title.Position = UDim2.fromOffset(20, 20)
title.BackgroundTransparency = 1
title.Text = "MONSTER FIGHTER  •  PROTOTYPE"
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = gui

local barBack = Instance.new("Frame")
barBack.Size = UDim2.fromOffset(260, 24)
barBack.Position = UDim2.fromOffset(20, 65)
barBack.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
barBack.BorderSizePixel = 0
barBack.Parent = gui

local bar = Instance.new("Frame")
bar.Size = UDim2.fromScale(1, 1)
bar.BackgroundColor3 = Color3.fromRGB(225, 75, 55)
bar.BorderSizePixel = 0
bar.Parent = barBack

local hpText = Instance.new("TextLabel")
hpText.Size = UDim2.fromScale(1, 1)
hpText.BackgroundTransparency = 1
hpText.Text = "TRAINING DUMMY  100 / 100"
hpText.TextSize = 14
hpText.Font = Enum.Font.GothamBold
hpText.TextColor3 = Color3.new(1, 1, 1)
hpText.Parent = barBack

local hint = Instance.new("TextLabel")
hint.Size = UDim2.fromOffset(500, 30)
hint.Position = UDim2.new(0, 20, 1, -50)
hint.BackgroundTransparency = 1
hint.Text = "LMB Attack   Q Dodge   F Parry   1/2/3 Skills   4 Ultimate"
hint.TextSize = 14
hint.Font = Enum.Font.Gotham
hint.TextColor3 = Color3.new(1, 1, 1)
hint.TextXAlignment = Enum.TextXAlignment.Left
hint.Parent = gui

local function updateHp(data)
  local hp = math.max(0, data.Health or 0)
  local maxHp = math.max(1, data.MaxHealth or 100)
  bar.Size = UDim2.fromScale(hp / maxHp, 1)
  hpText.Text = string.format("TRAINING DUMMY  %d / %d", hp, maxHp)
end

combatRemote.OnClientEvent:Connect(function(result)
  if result.PrototypeCombat then
    updateHp(result.PrototypeCombat)
    if result.PrototypeCombat.Damage then
      title.Text = "MONSTER FIGHTER  •  -" .. tostring(result.PrototypeCombat.Damage) .. " DAMAGE"
      task.delay(0.35, function()
        title.Text = "MONSTER FIGHTER  •  PROTOTYPE"
      end)
    end
  end
end)
