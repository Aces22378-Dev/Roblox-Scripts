--How to use
--Open Roblox Studio and enter your place.
--In the Explorer window, navigate to Workspace.
--Insert a Part, name it "Lava", and color it Bright orange.
--Inside that Part, click the "+" button and select Script (Server Script).

Lua
local lavaPart = script.Parent

-- Damage settings
local DAMAGE_AMOUNT = 10
local DAMAGE_INTERVAL = 0.5 -- How often (in seconds) the player takes damage

-- Table to keep track of players currently touching the lava
local touchingPlayers = {}

local function onTouch(otherPart)
	local character = otherPart.Parent
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	-- Check if what touched the part is a player and they aren't already being damaged
	if humanoid and not touchingPlayers[character] then
		touchingPlayers[character] = true
		
		-- Keep damaging the player as long as they are touching the part
		while touchingPlayers[character] and humanoid.Health > 0 do
			humanoid:TakeDamage(DAMAGE_AMOUNT)
			task.wait(DAMAGE_INTERVAL)
		end
	end
end

local function onTouchEnded(otherPart)
	local character = otherPart.Parent
	-- Remove character from tracking table when they stop touching
	if touchingPlayers[character] then
		touchingPlayers[character] = nil
	end
end

lavaPart.Touched:Connect(onTouch)
lavaPart.TouchEnded:Connect(onTouchEnded)