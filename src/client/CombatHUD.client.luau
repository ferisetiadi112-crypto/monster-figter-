local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local player=Players.LocalPlayer
local remote=ReplicatedStorage:WaitForChild("MonsterFighterRemotes"):WaitForChild("CombatAction")
local gui=Instance.new("ScreenGui"); gui.Name="MonsterFighterCombatHUD"; gui.ResetOnSpawn=false; gui.Parent=player:WaitForChild("PlayerGui")

local function button(name,label,pos,action)
 local b=Instance.new("TextButton"); b.Name=name; b.Text=label; b.Size=UDim2.fromOffset(72,52); b.Position=pos; b.TextScaled=true; b.Parent=gui
 b.Activated:Connect(function() remote:FireServer({Type=action,ClientTime=os.clock()}) end)
end

button("Attack","ATTACK",UDim2.new(1,-170,1,-95),"Attack")
button("Dodge","DODGE",UDim2.new(1,-90,1,-160),"Dodge")
button("Parry","PARRY",UDim2.new(1,-90,1,-95),"Parry")
button("Skill1","1",UDim2.new(1,-250,1,-95),"Skill1")
button("Skill2","2",UDim2.new(1,-330,1,-95),"Skill2")
button("Skill3","3",UDim2.new(1,-410,1,-95),"Skill3")
button("Ultimate","ULT",UDim2.new(1,-490,1,-95),"Ultimate")
print("[MonsterFighter] Combat HUD loaded.")
