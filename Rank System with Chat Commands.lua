-- Rank System with Chat Commands
-- Commands: /rank [username] [rankName]
-- Example: /rank Aces22378 Owner

local Players = game:GetService("Players")

-- 1. EASY TO ADD RANKS: Add name and color here
local RANK_CONFIG = {
	["Owner"] = Color3.fromRGB(255, 0, 0),      -- Red
	["Admin"] = Color3.fromRGB(255, 170, 0),    -- Orange
	["Dev"] = Color3.fromRGB(0, 255, 255),      -- Cyan
	["Supporter"] = Color3.fromRGB(0, 255, 0),  -- Green
	["Player"] = Color3.fromRGB(255, 255, 255)  -- White (Default)
}

-- Table to store manual ranks assigned during the session
local manualRanks = {}

-- Function to update the tag text and color
local function updateTag(player, character)
	local head = character:FindFirstChild("Head")
	if not head then return end
	
	local billboard = head:FindFirstChild("RankTag") or Instance.new("BillboardGui")
	billboard.Name = "RankTag"
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.Parent = head
	
	local label = billboard:FindFirstChild("RankLabel") or Instance.new("TextLabel")
	label.Name = "RankLabel"
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextStrokeTransparency = 0
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.Parent = billboard
	
	-- Determine the rank
	local currentRankName = manualRanks[player.UserId] or "Player"
	local rankColor = RANK_CONFIG[currentRankName] or RANK_CONFIG["Player"]
	
	label.Text = "[" .. currentRankName .. "] " .. player.Name
	label.TextColor3 = rankColor
end

-- 2. CHAT COMMAND LOGIC
local function onChat(sender, message)
	-- Only allow the Owner (You) to use the command
	-- Replace 1234567 with your actual UserId or use name check
	if sender.Name ~= "Aces22378-Dev" then return end 

	local args = string.split(message, " ")
	
	if args[1] == "/rank" and args[2] and args[3] then
		local targetName = args[2]
		local newRank = args[3]
		
		-- Clean the @ if the user typed @PlayerName
		targetName = targetName:gsub("@", "")
		
		-- Find the player
		for _, targetPlayer in pairs(Players:GetPlayers()) do
			if targetPlayer.Name:lower() == targetName:lower() then
				if RANK_CONFIG[newRank] then
					manualRanks[targetPlayer.UserId] = newRank
					if targetPlayer.Character then
						updateTag(targetPlayer, targetPlayer.Character)
					end
					print("Rank updated for " .. targetPlayer.Name)
				end
			end
		end
	end
end

-- Handle joining and respawning
Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(msg) onChat(player, msg) end)
	
	player.CharacterAdded:Connect(function(character)
		task.wait(0.1) -- Small wait to ensure head exists
		updateTag(player, character)
	end)
end)