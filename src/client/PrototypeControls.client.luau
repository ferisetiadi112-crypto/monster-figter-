local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")

local remotes = ReplicatedStorage:WaitForChild("MonsterFighterRemotes")
local combatRemote = remotes:WaitForChild("CombatAction")

local ACTIONS = {
  Attack = Enum.KeyCode.MouseButton1,
  Dodge = Enum.KeyCode.Q,
  Parry = Enum.KeyCode.F,
  Skill1 = Enum.KeyCode.One,
  Skill2 = Enum.KeyCode.Two,
  Skill3 = Enum.KeyCode.Three,
  Ultimate = Enum.KeyCode.Four,
}

local function fire(actionType)
  combatRemote:FireServer({Type = actionType})
end

for name, key in pairs(ACTIONS) do
  ContextActionService:BindAction(
    "MonsterFighter_" .. name,
    function(_, state)
      if state == Enum.UserInputState.Begin then
        fire(name)
      end
      return Enum.ContextActionResult.Sink
    end,
    true,
    key
  )
end

combatRemote.OnClientEvent:Connect(function(result)
  if result.Accepted then
    -- Prototype feedback hook. UI/animations will be added in the next Studio pass.
  end
end)
