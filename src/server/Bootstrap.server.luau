local ReplicatedStorage = game:GetService("ReplicatedStorage")

local shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(shared:WaitForChild("Constants"))

print("[MonsterFighter] Server booted:", Constants.GameName, Constants.Version)

-- Foundation services will be registered here.
-- Server remains authoritative for identity, combat, economy and population.
