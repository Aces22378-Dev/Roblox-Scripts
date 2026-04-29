--How to use
--Open Roblox Studio and enter your place.
--In the Explorer window, navigate to StarterPlayer > StarterCharacterScripts.
--Right-click StarterCharacterScripts, select Insert Object, and choose LocalScript.



local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local SPRINT_SPEED = 24 -- Speed while sprinting
local NORMAL_SPEED = 16 -- Default walk speed

local function onInputBegan(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.LeftShift then
		humanoid.WalkSpeed = SPRINT_SPEED
	end
end

local function onInputEnded(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		humanoid.WalkSpeed = NORMAL_SPEED
	end
end

UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputEnded:Connect(onInputEnded)
Use code with caution.