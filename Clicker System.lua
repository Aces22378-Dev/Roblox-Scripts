--How to use
-- Go to the Home tab in Roblox Studio.
-- Click Game Settings (you must publish your game first).
-- Go to Security.
-- Turn ON "Allow HTTP Requests" and "Enable Studio Access to API Services".


local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local clickDataStore = DataStoreService:GetDataStore("ScreenClickData")

-- 1. SETUP REMOTE EVENT (For Screen Clicking)
local clickEvent = Instance.new("RemoteEvent")
clickEvent.Name = "ScreenClickEvent"
clickEvent.Parent = ReplicatedStorage

-- 2. LEADERSTATS & LOADING
game.Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"

	local clicks = Instance.new("IntValue", leaderstats)
	clicks.Name = "Clicks"

	-- Load Data
	local success, data = pcall(function() return clickDataStore:GetAsync(player.UserId) end)
	if success and data then clicks.Value = data end

	-- 3. CREATE LOCAL SCRIPT AUTOMATICALLY
	-- This injects the screen-click detection into the player
	local localScript = Instance.new("LocalScript")
	localScript.Name = "DetectScreenClick"
	localScript.Source = [[
		local UIS = game:GetService("UserInputService")
		local event = game:GetService("ReplicatedStorage"):WaitForChild("ScreenClickEvent")
		
		UIS.InputBegan:Connect(function(input, processed)
			if processed then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				event:FireServer()
			end
		end)
	]]
	localScript.Parent = player:WaitForChild("PlayerGui")
end)

-- 4. SAVING DATA
game.Players.PlayerRemoving:Connect(function(player)
	pcall(function() 
		clickDataStore:SetAsync(player.UserId, player.leaderstats.Clicks.Value) 
	end)
end)

-- 5. RECEIVE CLICK SIGNAL
clickEvent.OnServerEvent:Connect(function(player)
	if player:FindFirstChild("leaderstats") then
		player.leaderstats.Clicks.Value += 1
	end
end)