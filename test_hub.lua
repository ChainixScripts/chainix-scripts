--[[
	╔═══════════════════════════════════════╗
	║     CHAINIX TEST HUB - PREMIUM        ║
	║         Made with CHAINIX             ║
	╚═══════════════════════════════════════╝
]]--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Feature states
local flyEnabled = false
local speedEnabled = false
local jumpEnabled = false
local espEnabled = false
local noclipEnabled = false
local bodyVelocity, bodyGyro
local flySpeed = 50
local walkSpeed = 100

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChainixPremiumHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true

local success = pcall(function()
	screenGui.Parent = game:GetService("CoreGui")
end)
if not success then
	screenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Utility functions
local function createTween(object, time, properties)
	return TweenService:Create(object, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
end

local function notify(msg, duration)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "CHAINIX";
		Text = msg;
		Duration = duration or 2;
	})
end

-- Main Frame (Glassmorphism)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 550, 0, 600)
mainFrame.Position = UDim2.new(0.5, -275, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Slide in animation
mainFrame.Position = UDim2.new(0.5, -275, 1.5, 0)
createTween(mainFrame, 0.5, {Position = UDim2.new(0.5, -275, 0.5, -300)}):Play()

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

-- Glow border
local glowBorder = Instance.new("UIStroke")
glowBorder.Color = Color3.fromRGB(100, 200, 255)
glowBorder.Thickness = 3
glowBorder.Transparency = 0.5
glowBorder.Parent = mainFrame

-- Animated gradient
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 200, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 100, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255))
}
gradient.Rotation = 45
gradient.Parent = glowBorder

-- Rotate gradient animation
spawn(function()
	while screenGui.Parent do
		createTween(gradient, 3, {Rotation = gradient.Rotation + 180}):Play()
		wait(3)
	end
end)

-- Blur effect background
local blurFrame = Instance.new("Frame")
blurFrame.Size = UDim2.new(1, 0, 1, 0)
blurFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
blurFrame.BackgroundTransparency = 0.3
blurFrame.BorderSizePixel = 0
blurFrame.ZIndex = 0
blurFrame.Parent = mainFrame

local blurCorner = Instance.new("UICorner")
blurCorner.CornerRadius = UDim.new(0, 16)
blurCorner.Parent = blurFrame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 80)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

-- Logo
local logo = Instance.new("TextLabel")
logo.Text = "⚡"
logo.Font = Enum.Font.GothamBold
logo.TextSize = 40
logo.TextColor3 = Color3.fromRGB(100, 200, 255)
logo.BackgroundTransparency = 1
logo.Size = UDim2.new(0, 60, 0, 60)
logo.Position = UDim2.new(0, 15, 0, 10)
logo.Parent = header

-- Pulse animation for logo
spawn(function()
	while screenGui.Parent do
		createTween(logo, 1, {TextSize = 45}):Play()
		wait(1)
		createTween(logo, 1, {TextSize = 40}):Play()
		wait(1)
	end
end)

-- Title
local title = Instance.new("TextLabel")
title.Text = "CHAINIX PREMIUM"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(240, 245, 250)
title.TextSize = 24
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -160, 0, 30)
title.Position = UDim2.new(0, 80, 0, 15)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Text = "Universal Script Hub • v2.0"
subtitle.Font = Enum.Font.Gotham
subtitle.TextColor3 = Color3.fromRGB(160, 170, 180)
subtitle.TextSize = 12
subtitle.BackgroundTransparency = 1
subtitle.Size = UDim2.new(1, -160, 0, 20)
subtitle.Position = UDim2.new(0, 80, 0, 45)
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

-- Status indicator
local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 10, 0, 10)
statusDot.Position = UDim2.new(1, -70, 0, 25)
statusDot.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
statusDot.BorderSizePixel = 0
statusDot.Parent = header

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = statusDot

local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "ONLINE"
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.TextSize = 11
statusLabel.BackgroundTransparency = 1
statusLabel.Size = UDim2.new(0, 50, 0, 20)
statusLabel.Position = UDim2.new(1, -55, 0, 20)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = header

-- Pulse status dot
spawn(function()
	while screenGui.Parent do
		createTween(statusDot, 0.5, {BackgroundTransparency = 0.5}):Play()
		wait(0.5)
		createTween(statusDot, 0.5, {BackgroundTransparency = 0}):Play()
		wait(0.5)
	end
end)

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 20
closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -55, 0, 20)
closeBtn.AutoButtonColor = false
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeBtn

closeBtn.MouseEnter:Connect(function()
	createTween(closeBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(255, 50, 50), BackgroundTransparency = 0}):Play()
end)

closeBtn.MouseLeave:Connect(function()
	createTween(closeBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(30, 30, 40), BackgroundTransparency = 0.3}):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
	createTween(mainFrame, 0.3, {Position = UDim2.new(0.5, -275, 1.5, 0)}):Play()
	wait(0.3)
	screenGui:Destroy()
end)

-- Tab System
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -30, 0, 45)
tabContainer.Position = UDim2.new(0, 15, 0, 90)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

local currentTab = "Features"
local tabs = {"Features", "Settings", "Info"}
local tabButtons = {}
local tabContents = {}

-- Create tabs
for i, tabName in ipairs(tabs) do
	local tabBtn = Instance.new("TextButton")
	tabBtn.Name = tabName
	tabBtn.Text = tabName
	tabBtn.Font = Enum.Font.GothamBold
	tabBtn.TextSize = 13
	tabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	tabBtn.BackgroundTransparency = currentTab == tabName and 0 or 0.5
	tabBtn.TextColor3 = currentTab == tabName and Color3.fromRGB(100, 200, 255) or Color3.fromRGB(160, 170, 180)
	tabBtn.Size = UDim2.new(0.33, -7, 1, 0)
	tabBtn.Position = UDim2.new((i-1) * 0.33, (i-1) * 3.5, 0, 0)
	tabBtn.AutoButtonColor = false
	tabBtn.Parent = tabContainer
	
	local tabCorner = Instance.new("UICorner")
	tabCorner.CornerRadius = UDim.new(0, 8)
	tabCorner.Parent = tabBtn
	
	tabButtons[tabName] = tabBtn
	
	-- Tab content frame
	local contentFrame = Instance.new("ScrollingFrame")
	contentFrame.Name = tabName .. "Content"
	contentFrame.Size = UDim2.new(1, -30, 1, -165)
	contentFrame.Position = UDim2.new(0, 15, 0, 145)
	contentFrame.BackgroundTransparency = 1
	contentFrame.BorderSizePixel = 0
	contentFrame.ScrollBarThickness = 4
	contentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 200, 255)
	contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	contentFrame.Visible = (tabName == currentTab)
	contentFrame.Parent = mainFrame
	
	tabContents[tabName] = contentFrame
end

-- Tab switching function
local function switchTab(tabName)
	currentTab = tabName
	for name, btn in pairs(tabButtons) do
		local isActive = (name == tabName)
		createTween(btn, 0.2, {
			BackgroundTransparency = isActive and 0 or 0.5,
			TextColor3 = isActive and Color3.fromRGB(100, 200, 255) or Color3.fromRGB(160, 170, 180)
		}):Play()
	end
	
	for name, content in pairs(tabContents) do
		content.Visible = (name == tabName)
	end
end

-- Connect tab buttons
for name, btn in pairs(tabButtons) do
	btn.MouseButton1Click:Connect(function()
		switchTab(name)
	end)
	
	btn.MouseEnter:Connect(function()
		if currentTab ~= name then
			createTween(btn, 0.2, {BackgroundTransparency = 0.3}):Play()
		end
	end)
	
	btn.MouseLeave:Connect(function()
		if currentTab ~= name then
			createTween(btn, 0.2, {BackgroundTransparency = 0.5}):Play()
		end
	end)
end

-- FEATURES TAB CONTENT
local featuresContent = tabContents["Features"]

-- Create toggle with status
local yPos = 10
local function createFeatureToggle(name, icon, desc, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 75)
	container.Position = UDim2.new(0, 0, 0, yPos)
	container.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
	container.BackgroundTransparency = 0.3
	container.BorderSizePixel = 0
	container.Parent = featuresContent
	
	yPos = yPos + 80
	featuresContent.CanvasSize = UDim2.new(0, 0, 0, yPos)
	
	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 12)
	containerCorner.Parent = container
	
	-- Hover effect
	container.MouseEnter:Connect(function()
		createTween(container, 0.2, {BackgroundTransparency = 0.1}):Play()
	end)
	container.MouseLeave:Connect(function()
		createTween(container, 0.2, {BackgroundTransparency = 0.3}):Play()
	end)
	
	local iconLabel = Instance.new("TextLabel")
	iconLabel.Text = icon
	iconLabel.Font = Enum.Font.GothamBold
	iconLabel.TextSize = 28
	iconLabel.BackgroundTransparency = 1
	iconLabel.Size = UDim2.new(0, 50, 0, 50)
	iconLabel.Position = UDim2.new(0, 12, 0, 12)
	iconLabel.Parent = container
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Text = name
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextColor3 = Color3.fromRGB(240, 245, 250)
	nameLabel.TextSize = 15
	nameLabel.BackgroundTransparency = 1
	nameLabel.Size = UDim2.new(1, -180, 0, 22)
	nameLabel.Position = UDim2.new(0, 70, 0, 12)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = container
	
	local descLabel = Instance.new("TextLabel")
	descLabel.Text = desc
	descLabel.Font = Enum.Font.Gotham
	descLabel.TextColor3 = Color3.fromRGB(140, 150, 160)
	descLabel.TextSize = 11
	descLabel.BackgroundTransparency = 1
	descLabel.Size = UDim2.new(1, -180, 0, 18)
	descLabel.Position = UDim2.new(0, 70, 0, 36)
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.Parent = container
	
	-- Status indicator
	local statusText = Instance.new("TextLabel")
	statusText.Text = "OFF"
	statusText.Font = Enum.Font.GothamBold
	statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
	statusText.TextSize = 10
	statusText.BackgroundTransparency = 1
	statusText.Size = UDim2.new(0, 40, 0, 15)
	statusText.Position = UDim2.new(1, -115, 0, 55)
	statusText.Parent = container
	
	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Text = ""
	toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
	toggleBtn.Size = UDim2.new(0, 90, 0, 38)
	toggleBtn.Position = UDim2.new(1, -105, 0, 18)
	toggleBtn.AutoButtonColor = false
	toggleBtn.Parent = container
	
	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0, 19)
	toggleCorner.Parent = toggleBtn
	
	local toggleCircle = Instance.new("Frame")
	toggleCircle.Size = UDim2.new(0, 32, 0, 32)
	toggleCircle.Position = UDim2.new(0, 3, 0, 3)
	toggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
	toggleCircle.BorderSizePixel = 0
	toggleCircle.Parent = toggleBtn
	
	local circleCorner = Instance.new("UICorner")
	circleCorner.CornerRadius = UDim.new(1, 0)
	circleCorner.Parent = toggleCircle
	
	local isOn = false
	
	toggleBtn.MouseButton1Click:Connect(function()
		isOn = not isOn
		
		if isOn then
			createTween(toggleBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(100, 200, 255)}):Play()
			createTween(toggleCircle, 0.2, {Position = UDim2.new(1, -35, 0, 3)}):Play()
			statusText.Text = "ON"
			statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
		else
			createTween(toggleBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
			createTween(toggleCircle, 0.2, {Position = UDim2.new(0, 3, 0, 3)}):Play()
			statusText.Text = "OFF"
			statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
		end
		
		callback(isOn)
	end)
	
	return {toggle = toggleBtn, status = statusText, icon = iconLabel}
end

-- Add features
createFeatureToggle("Fly", "🚀", "Fly around freely • WASD to move", function(enabled)
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
		
		notify("Fly enabled! ✅", 2)
	else
		if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
		if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
		notify("Fly disabled! ❌", 2)
	end
end)

createFeatureToggle("Speed Hack", "⚡", "Increase your walk speed", function(enabled)
	speedEnabled = enabled
	if enabled then
		humanoid.WalkSpeed = walkSpeed
		notify("Speed enabled! ✅", 2)
	else
		humanoid.WalkSpeed = 16
		notify("Speed disabled! ❌", 2)
	end
end)

createFeatureToggle("Infinite Jump", "🦘", "Jump unlimited times", function(enabled)
	jumpEnabled = enabled
	if enabled then
		notify("Infinite Jump enabled! ✅", 2)
	else
		notify("Infinite Jump disabled! ❌", 2)
	end
end)

createFeatureToggle("ESP", "👁️", "See players through walls", function(enabled)
	espEnabled = enabled
	for _, otherPlayer in pairs(Players:GetPlayers()) do
		if otherPlayer ~= player and otherPlayer.Character then
			local highlight = otherPlayer.Character:FindFirstChild("ESPHighlight")
			if enabled and not highlight then
				highlight = Instance.new("Highlight")
				highlight.Name = "ESPHighlight"
				highlight.FillColor = Color3.fromRGB(100, 200, 255)
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
		notify("ESP enabled! ✅", 2)
	else
		notify("ESP disabled! ❌", 2)
	end
end)

createFeatureToggle("No-Clip", "👻", "Walk through walls", function(enabled)
	noclipEnabled = enabled
	if enabled then
		notify("No-Clip enabled! ✅", 2)
	else
		notify("No-Clip disabled! ❌", 2)
	end
end)

-- SETTINGS TAB CONTENT
local settingsContent = tabContents["Settings"]

-- Create slider
local function createSlider(name, min, max, default, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 70)
	container.Position = UDim2.new(0, 0, 0, settingsContent.CanvasSize.Y.Offset)
	container.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
	container.BackgroundTransparency = 0.3
	container.BorderSizePixel = 0
	container.Parent = settingsContent
	
	settingsContent.CanvasSize = UDim2.new(0, 0, 0, settingsContent.CanvasSize.Y.Offset + 80)
	
	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 12)
	containerCorner.Parent = container
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Text = name
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextColor3 = Color3.fromRGB(240, 245, 250)
	nameLabel.TextSize = 14
	nameLabel.BackgroundTransparency = 1
	nameLabel.Size = UDim2.new(1, -20, 0, 20)
	nameLabel.Position = UDim2.new(0, 12, 0, 10)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = container
	
	local valueLabel = Instance.new("TextLabel")
	valueLabel.Text = tostring(default)
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
	valueLabel.TextSize = 13
	valueLabel.BackgroundTransparency = 1
	valueLabel.Size = UDim2.new(0, 60, 0, 20)
	valueLabel.Position = UDim2.new(1, -70, 0, 10)
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = container
	
	local sliderBG = Instance.new("Frame")
	sliderBG.Size = UDim2.new(1, -24, 0, 6)
	sliderBG.Position = UDim2.new(0, 12, 0, 45)
	sliderBG.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	sliderBG.BorderSizePixel = 0
	sliderBG.Parent = container
	
	local sliderCorner = Instance.new("UICorner")
	sliderCorner.CornerRadius = UDim.new(1, 0)
	sliderCorner.Parent = sliderBG
	
	local sliderFill = Instance.new("Frame")
	sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	sliderFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
	sliderFill.BorderSizePixel = 0
	sliderFill.Parent = sliderBG
	
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = sliderFill
	
	local sliderBtn = Instance.new("TextButton")
	sliderBtn.Text = ""
	sliderBtn.Size = UDim2.new(0, 18, 0, 18)
	sliderBtn.Position = UDim2.new((default - min) / (max - min), -9, 0.5, -9)
	sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sliderBtn.BorderSizePixel = 0
	sliderBtn.AutoButtonColor = false
	sliderBtn.Parent = sliderBG
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(1, 0)
	btnCorner.Parent = sliderBtn
	
	local dragging = false
	
	sliderBtn.MouseButton1Down:Connect(function()
		dragging = true
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	
	sliderBG.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mousePos = UserInputService:GetMouseLocation().X
			local sliderPos = sliderBG.AbsolutePosition.X
			local sliderSize = sliderBG.AbsoluteSize.X
			
			local percent = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
			local value = math.floor(min + (max - min) * percent)
			
			valueLabel.Text = tostring(value)
			createTween(sliderFill, 0.1, {Size = UDim2.new(percent, 0, 1, 0)}):Play()
			createTween(sliderBtn, 0.1, {Position = UDim2.new(percent, -9, 0.5, -9)}):Play()
			
			callback(value)
		end
	end)
end

createSlider("Fly Speed", 20, 200, 50, function(value)
	flySpeed = value
end)

createSlider("Walk Speed", 16, 200, 100, function(value)
	walkSpeed = value
	if speedEnabled then
		humanoid.WalkSpeed = value
	end
end)

-- INFO TAB CONTENT
local infoContent = tabContents["Info"]

local infoText = Instance.new("TextLabel")
infoText.Text = [[
╔═══════════════════════════════╗
        CHAINIX PREMIUM
╚═══════════════════════════════╝

Version: 2.0
Made with: CHAINIX Loader

Features:
• Fly - Explore freely
• Speed Hack - Move faster
• Infinite Jump - Reach new heights
• ESP - See through walls
• No-Clip - Phase through objects

Controls:
• Fly: WASD + Space/Shift
• All features: Toggle ON/OFF

Credits:
Made by ChainixScripts
GitHub.com/ChainixScripts

Enjoy! ⚡
]]
infoText.Font = Enum.Font.Code
infoText.TextColor3 = Color3.fromRGB(180, 190, 200)
infoText.TextSize = 12
infoText.BackgroundTransparency = 1
infoText.Size = UDim2.new(1, -20, 1, 0)
infoText.Position = UDim2.new(0, 10, 0, 10)
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.Parent = infoContent

-- Feature loops
RunService.Heartbeat:Connect(function()
	if flyEnabled and bodyVelocity and bodyGyro then
		local camera = workspace.CurrentCamera
		local move = Vector3.new(0, 0, 0)
		
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + camera.CFrame.LookVector * flySpeed end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - camera.CFrame.LookVector * flySpeed end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - camera.CFrame.RightVector * flySpeed end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + camera.CFrame.RightVector * flySpeed end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, flySpeed, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, flySpeed, 0) end
		
		bodyVelocity.Velocity = move
		bodyGyro.CFrame = camera.CFrame
	end
end)

UserInputService.JumpRequest:Connect(function()
	if jumpEnabled then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

RunService.Stepped:Connect(function()
	if noclipEnabled and character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

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

notify("CHAINIX Premium loaded! ⚡", 3)
print("CHAINIX PREMIUM: Loaded successfully!")
