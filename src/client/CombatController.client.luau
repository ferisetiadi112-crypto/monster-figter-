local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- Mobile/PC input foundation.
-- Actual combat UI and remotes will be added in the next milestone.

local function onInputBegan(input, processed)
  if processed then
    return
  end

  if input.KeyCode == Enum.KeyCode.Q then
    -- Dodge intent
  elseif input.KeyCode == Enum.KeyCode.F then
    -- Parry intent
  elseif input.KeyCode == Enum.KeyCode.One then
    -- Skill 1 intent
  elseif input.KeyCode == Enum.KeyCode.Two then
    -- Skill 2 intent
  elseif input.KeyCode == Enum.KeyCode.Three then
    -- Skill 3 intent
  end
end

UserInputService.InputBegan:Connect(onInputBegan)

print("[MonsterFighter] Combat controller ready for", player.Name)
