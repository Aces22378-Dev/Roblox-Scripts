--How to use
--Open Roblox Studio and enter your place.
--In the Explorer window, navigate to ServerScriptService.
--Click the "+" button and select Script.
--Rename the script to "RankSystem".

Lua
-- Rank System with Permanent Staff List
-- Commands: /rank @player RankName

local Players = game:GetService("Players")

-- 1. PERMANENT STAFF LIST (Add UserIDs here)
-- You can find a UserID in the URL of a profile page
local STAFF_LIST = {
	[1] = "Owner", -- Replace with UserID
	[1] = "Admin", -- Replace with UserID
}

-- 2. EASY TO ADD/CHANGE RANKS
local RANK_CONFIG = {
	["Owner"] = Color3.fromRGB(255, 0, 0),      -- Red
	["Admin"] = Color3.fromRGB(255, 170, 0),    -- Orange
	["Dev"] = Color3.fromRGB(0, 255, 255),      -- Cyan
	["Supporter"] = Color3.fromRGB(0, 255, 0),  -- Green
	["Player"] = Color3.fromRGB(255, 255, 255)  -- White
}

local manualRanks = {}

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
	
	-- Priority: 1. Manual Command -> 2. Staff List -> 3. Default Player
	local currentRankName = manualRanks[player.UserId] or STAFF_LIST[player.UserId] or "Player"
	local rankColor = RANK_CONFIG[currentRankName] or RANK_CONFIG["Player"]
	
	label.Text = "[" .. currentRankName .. "] " .. player.Name
	label.TextColor3 = rankColor
end

-- 3. CHAT COMMAND LOGIC
local function onChat(sender, message)
	-- Only the Owner (from the Staff List) can use the command
	if STAFF_LIST[sender.UserId] ~= "Owner" then return end 

	local args = string.split(message, " ")
	
	if args[1] == "/rank" and args[2] and args[3] then
		local targetName = args[2]:gsub("@", "")
		local newRank = args[3]
		
		for _, targetPlayer in pairs(Players:GetPlayers()) do
			if targetPlayer.Name:lower() == targetName:lower() then
				if RANK_CONFIG[newRank] then
					manualRanks[targetPlayer.UserId] = newRank
					if targetPlayer.Character then
						updateTag(targetPlayer, targetPlayer.Character)
					end
				end
			end
		end
	end
end

Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(msg) onChat(player, msg) end)
	player.CharacterAdded:Connect(function(character)
		task.wait(0.1)
		updateTag(player, character)
	end)
end)