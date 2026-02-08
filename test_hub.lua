--[[
	CHAINIX TEST HUB - CLEAN VERSION
	Working test hub with 5 features
]]--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Wait for character
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChainixTestHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Protection
local success = pcall(function()
	screenGui.Parent = game:GetService("CoreGui")
end)
if not success then
	screenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 450)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainBorder = Instance.new("UIStroke")
mainBorder.Color = Color3.fromRGB(200, 210, 220)
mainBorder.Thickness = 2
mainBorder.Transparency = 0.7
mainBorder.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Text = "CHAINIX TEST HUB"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(240, 245, 250)
title.TextSize = 20
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -60, 0, 50)
title.Position = UDim2.new(0, 0, 0, 10)
title.Parent = mainFrame

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.fromRGB(160, 170, 180)
closeBtn.TextSize = 18
closeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -48, 0, 12)
closeBtn.AutoButtonColor = false
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- Line
local line = Instance.new("Frame")
line.Size = UDim2.new(1, -40, 0, 2)
line.Position = UDim2.new(0, 20, 0, 60)
line.BackgroundColor3 = Color3.fromRGB(240, 245, 250)
line.BorderSizePixel = 0
line.Parent = mainFrame

-- Feature states
local flyEnabled = false
local speedEnabled = false
local jumpEnabled = false
local espEnabled = false
local noclipEnabled = false
local bodyVelocity, bodyGyro

-- Notification
local function notify(msg)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "CHAINIX TEST";
		Text = msg;
		Duration = 2;
	})
end

-- Create toggle button
local function createToggle(name, icon, yPos, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, -40, 0, 50)
	container.Position = UDim2.new(0, 20, 0, yPos)
	container.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
	container.BackgroundTransparency = 0.3
	container.Parent = mainFrame
	
	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 8)
	containerCorner.Parent = container
	
	local iconLabel = Instance.new("TextLabel")
	iconLabel.Text = icon
	iconLabel.Font = Enum.Font.GothamBold
	iconLabel.TextSize = 24
	iconLabel.BackgroundTransparency = 1
	iconLabel.Size = UDim2.new(0, 40, 1, 0)
	iconLabel.Position = UDim2.new(0, 10, 0, 0)
	iconLabel.Parent = container
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Text = name
	nameLabel.Font = Enum.Font.GothamMedium
	nameLabel.TextColor3 = Color3.fromRGB(240, 245, 250)
	nameLabel.TextSize = 14
	nameLabel.BackgroundTransparency = 1
	nameLabel.Size = UDim2.new(1, -140, 1, 0)
	nameLabel.Position = UDim2.new(0, 50, 0, 0)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = container
	
	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Text = "OFF"
	toggleBtn.Font = Enum.Font.GothamBold
	toggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
	toggleBtn.TextSize = 12
	toggleBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
	toggleBtn.Size = UDim2.new(0, 60, 0, 30)
	toggleBtn.Position = UDim2.new(1, -70, 0.5, -15)
	toggleBtn.AutoButtonColor = false
	toggleBtn.Parent = container
	
	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0, 6)
	toggleCorner.Parent = toggleBtn
	
	local toggleBorder = Instance.new("UIStroke")
	toggleBorder.Color = Color3.fromRGB(255, 100, 100)
	toggleBorder.Thickness = 2
	toggleBorder.Transparency = 0.3
	toggleBorder.Parent = toggleBtn
	
	local isOn = false
	
	toggleBtn.MouseButton1Click:Connect(function()
		isOn = not isOn
		
		if isOn then
			toggleBtn.Text = "ON"
			toggleBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
			toggleBorder.Color = Color3.fromRGB(100, 255, 100)
		else
			toggleBtn.Text = "OFF"
			toggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
			toggleBorder.Color = Color3.fromRGB(255, 100, 100)
		end
		
		callback(isOn)
	end)
end

-- FLY
createToggle("Fly", "🚀", 80, function(enabled)
	flyEnabled = enabled
	if enabled then
		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		bodyVelocity.Parent = humanoidRootPart
		
		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bodyGyro.CFrame = humanoidRootPart.CFrame
		bodyGyro.Parent = humanoidRootPart
		
		notify("Fly enabled! ✅")
	else
		if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
		if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
		notify("Fly disabled! ❌")
	end
end)

-- SPEED
createToggle("Speed Hack", "⚡", 140, function(enabled)
	speedEnabled = enabled
	if enabled then
		humanoid.WalkSpeed = 100
		notify("Speed enabled! ✅")
	else
		humanoid.WalkSpeed = 16
		notify("Speed disabled! ❌")
	end
end)

-- INFINITE JUMP
createToggle("Infinite Jump", "🦘", 200, function(enabled)
	jumpEnabled = enabled
	if enabled then
		notify("Infinite Jump enabled! ✅")
	else
		notify("Infinite Jump disabled! ❌")
	end
end)

-- ESP
createToggle("ESP", "👁️", 260, function(enabled)
	espEnabled = enabled
	for _, otherPlayer in pairs(Players:GetPlayers()) do
		if otherPlayer ~= player and otherPlayer.Character then
			local highlight = otherPlayer.Character:FindFirstChild("ESPHighlight")
			if enabled and not highlight then
				highlight = Instance.new("Highlight")
				highlight.Name = "ESPHighlight"
				highlight.FillColor = Color3.fromRGB(255, 100, 100)
				highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				highlight.FillTransparency = 0.5
				highlight.OutlineTransparency = 0
				highlight.Parent = otherPlayer.Character
			elseif not enabled and highlight then
				highlight:Destroy()
			end
		end
	end
	if enabled then
		notify("ESP enabled! ✅")
	else
		notify("ESP disabled! ❌")
	end
end)

-- NO-CLIP
createToggle("No-Clip", "👻", 320, function(enabled)
	noclipEnabled = enabled
	if enabled then
		notify("No-Clip enabled! ✅")
	else
		notify("No-Clip disabled! ❌")
	end
end)

-- FLY LOOP
RunService.Heartbeat:Connect(function()
	if flyEnabled and bodyVelocity and bodyGyro then
		local camera = workspace.CurrentCamera
		local move = Vector3.new(0, 0, 0)
		local speed = 50
		
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + camera.CFrame.LookVector * speed end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - camera.CFrame.LookVector * speed end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - camera.CFrame.RightVector * speed end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + camera.CFrame.RightVector * speed end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, speed, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, speed, 0) end
		
		bodyVelocity.Velocity = move
		bodyGyro.CFrame = camera.CFrame
	end
end)

-- INFINITE JUMP LOOP
UserInputService.JumpRequest:Connect(function()
	if jumpEnabled then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- NO-CLIP LOOP
RunService.Stepped:Connect(function()
	if noclipEnabled and character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- CHARACTER RESPAWN
player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
	humanoid = newChar:WaitForChild("Humanoid")
	
	if flyEnabled then
		flyEnabled = false
		if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
		if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
	end
end)

notify("Test Hub loaded! 🎮")
print("CHAINIX TEST HUB: Loaded successfully!")
