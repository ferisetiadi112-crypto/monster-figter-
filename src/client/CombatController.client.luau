local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local combatRemote = ReplicatedStorage:WaitForChild("MonsterFighterRemotes"):WaitForChild("CombatAction")

local function sendAction(t) combatRemote:FireServer({Type=t, ClientTime=os.clock()}) end

UserInputService.InputBegan:Connect(function(input, processed)
  if processed then return end
  if input.UserInputType == Enum.UserInputType.MouseButton1 then sendAction("Attack")
  elseif input.KeyCode == Enum.KeyCode.Q then sendAction("Dodge")
  elseif input.KeyCode == Enum.KeyCode.F then sendAction("Parry")
  elseif input.KeyCode == Enum.KeyCode.One then sendAction("Skill1")
  elseif input.KeyCode == Enum.KeyCode.Two then sendAction("Skill2")
  elseif input.KeyCode == Enum.KeyCode.Three then sendAction("Skill3")
  elseif input.KeyCode == Enum.KeyCode.Four then sendAction("Ultimate") end
end)

combatRemote.OnClientEvent:Connect(function(result)
  if result.Accepted then print("[Combat] "..tostring(result.Action).." accepted")
  else print("[Combat] rejected:", result.Reason) end
end)
print("[MonsterFighter] Combat input foundation ready for "..player.Name)
