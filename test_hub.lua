--[[
	CHAINIX SCRIPT HUB
	Professional Edition
	Version 2.0
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
screenGui.Name = "ChainixPro"
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
local function createTween(object, time, properties, style, direction)
	style = style or Enum.EasingStyle.Quad
	direction = direction or Enum.EasingDirection.Out
	return TweenService:Create(object, TweenInfo.new(time, style, direction), properties)
end

local function notify(msg, duration)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "CHAINIX";
		Text = msg;
		Duration = duration or 2;
	})
end

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 550)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Entrance animation
mainFrame.Position = UDim2.new(0.5, -300, 1.2, 0)
createTween(mainFrame, 0.6, {Position = UDim2.new(0.5, -300, 0.5, -275)}, Enum.EasingStyle.Back):Play()

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Subtle border
local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(45, 45, 52)
border.Thickness = 1
border.Parent = mainFrame

-- Accent line (top)
local accentLine = Instance.new("Frame")
accentLine.Size = UDim2.new(1, 0, 0, 2)
accentLine.Position = UDim2.new(0, 0, 0, 0)
accentLine.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
accentLine.BorderSizePixel = 0
accentLine.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 70)
header.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.Position = UDim2.new(0, 0, 1, -1)
headerLine.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
headerLine.BorderSizePixel = 0
headerLine.Parent = header

-- Logo container
local logoContainer = Instance.new("Frame")
logoContainer.Size = UDim2.new(0, 36, 0, 36)
logoContainer.Position = UDim2.new(0, 20, 0, 17)
logoContainer.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
logoContainer.BorderSizePixel = 0
logoContainer.Parent = header

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 6)
logoCorner.Parent = logoContainer

local logoText = Instance.new("TextLabel")
logoText.Text = "C"
logoText.Font = Enum.Font.GothamBold
logoText.TextSize = 20
logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
logoText.BackgroundTransparency = 1
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.Parent = logoContainer

-- Title
local title = Instance.new("TextLabel")
title.Text = "CHAINIX"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.BackgroundTransparency = 1
title.Size = UDim2.new(0, 200, 0, 20)
title.Position = UDim2.new(0, 65, 0, 18)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Text = "Script Hub • Professional Edition"
subtitle.Font = Enum.Font.Gotham
subtitle.TextColor3 = Color3.fromRGB(130, 135, 145)
subtitle.TextSize = 11
subtitle.BackgroundTransparency = 1
subtitle.Size = UDim2.new(0, 300, 0, 16)
subtitle.Position = UDim2.new(0, 65, 0, 38)
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

-- Version badge
local versionBadge = Instance.new("Frame")
versionBadge.Size = UDim2.new(0, 50, 0, 22)
versionBadge.Position = UDim2.new(1, -180, 0, 24)
versionBadge.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
versionBadge.BorderSizePixel = 0
versionBadge.Parent = header

local versionCorner = Instance.new("UICorner")
versionCorner.CornerRadius = UDim.new(0, 4)
versionCorner.Parent = versionBadge

local versionText = Instance.new("TextLabel")
versionText.Text = "v2.0"
versionText.Font = Enum.Font.GothamMedium
versionText.TextColor3 = Color3.fromRGB(160, 165, 175)
versionText.TextSize = 10
versionText.BackgroundTransparency = 1
versionText.Size = UDim2.new(1, 0, 1, 0)
versionText.Parent = versionBadge

-- Status indicator
local statusContainer = Instance.new("Frame")
statusContainer.Size = UDim2.new(0, 70, 0, 22)
statusContainer.Position = UDim2.new(1, -120, 0, 24)
statusContainer.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
statusContainer.BorderSizePixel = 0
statusContainer.Parent = header

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 4)
statusCorner.Parent = statusContainer

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 6, 0, 6)
statusDot.Position = UDim2.new(0, 8, 0.5, -3)
statusDot.BackgroundColor3 = Color3.fromRGB(67, 181, 129)
statusDot.BorderSizePixel = 0
statusDot.Parent = statusContainer

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = statusDot

local statusText = Instance.new("TextLabel")
statusText.Text = "Active"
statusText.Font = Enum.Font.GothamMedium
statusText.TextColor3 = Color3.fromRGB(67, 181, 129)
statusText.TextSize = 10
statusText.BackgroundTransparency = 1
statusText.Size = UDim2.new(1, -18, 1, 0)
statusText.Position = UDim2.new(0, 18, 0, 0)
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusContainer

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.fromRGB(180, 185, 195)
closeBtn.TextSize = 24
closeBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -56, 0, 17)
closeBtn.AutoButtonColor = false
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseEnter:Connect(function()
	createTween(closeBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(239, 83, 80), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)

closeBtn.MouseLeave:Connect(function()
	createTween(closeBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(28, 28, 34), TextColor3 = Color3.fromRGB(180, 185, 195)}):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
	createTween(mainFrame, 0.4, {Position = UDim2.new(0.5, -300, 1.2, 0)}, Enum.EasingStyle.Back, Enum.EasingDirection.In):Play()
	wait(0.4)
	screenGui:Destroy()
end)

-- Tab System
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -40, 0, 42)
tabContainer.Position = UDim2.new(0, 20, 0, 85)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

local currentTab = "Features"
local tabs = {"Features", "Settings", "About"}
local tabButtons = {}
local tabContents = {}

-- Create tabs
for i, tabName in ipairs(tabs) do
	local tabBtn = Instance.new("TextButton")
	tabBtn.Name = tabName
	tabBtn.Text = tabName
	tabBtn.Font = Enum.Font.GothamMedium
	tabBtn.TextSize = 12
	tabBtn.BackgroundColor3 = currentTab == tabName and Color3.fromRGB(28, 28, 34) or Color3.fromRGB(22, 22, 27)
	tabBtn.TextColor3 = currentTab == tabName and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(130, 135, 145)
	tabBtn.Size = UDim2.new(0.33, -7, 1, 0)
	tabBtn.Position = UDim2.new((i-1) * 0.33, (i-1) * 3.5, 0, 0)
	tabBtn.AutoButtonColor = false
	tabBtn.BorderSizePixel = 0
	tabBtn.Parent = tabContainer
	
	local tabCorner = Instance.new("UICorner")
	tabCorner.CornerRadius = UDim.new(0, 6)
	tabCorner.Parent = tabBtn
	
	if currentTab == tabName then
		local activeIndicator = Instance.new("Frame")
		activeIndicator.Name = "ActiveIndicator"
		activeIndicator.Size = UDim2.new(1, 0, 0, 2)
		activeIndicator.Position = UDim2.new(0, 0, 1, -2)
		activeIndicator.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
		activeIndicator.BorderSizePixel = 0
		activeIndicator.Parent = tabBtn
	end
	
	tabButtons[tabName] = tabBtn
	
	-- Tab content frame
	local contentFrame = Instance.new("ScrollingFrame")
	contentFrame.Name = tabName .. "Content"
	contentFrame.Size = UDim2.new(1, -40, 1, -155)
	contentFrame.Position = UDim2.new(0, 20, 0, 137)
	contentFrame.BackgroundTransparency = 1
	contentFrame.BorderSizePixel = 0
	contentFrame.ScrollBarThickness = 3
	contentFrame.ScrollBarImageColor3 = Color3.fromRGB(88, 101, 242)
	contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	contentFrame.Visible = (tabName == currentTab)
	contentFrame.Parent = mainFrame
	
	tabContents[tabName] = contentFrame
end

-- Tab switching
local function switchTab(tabName)
	currentTab = tabName
	for name, btn in pairs(tabButtons) do
		local isActive = (name == tabName)
		
		createTween(btn, 0.2, {
			BackgroundColor3 = isActive and Color3.fromRGB(28, 28, 34) or Color3.fromRGB(22, 22, 27),
			TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(130, 135, 145)
		}):Play()
		
		local indicator = btn:FindFirstChild("ActiveIndicator")
		if isActive and not indicator then
			indicator = Instance.new("Frame")
			indicator.Name = "ActiveIndicator"
			indicator.Size = UDim2.new(1, 0, 0, 2)
			indicator.Position = UDim2.new(0, 0, 1, -2)
			indicator.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
			indicator.BorderSizePixel = 0
			indicator.BackgroundTransparency = 1
			indicator.Parent = btn
			createTween(indicator, 0.2, {BackgroundTransparency = 0}):Play()
		elseif not isActive and indicator then
			createTween(indicator, 0.2, {BackgroundTransparency = 1}):Play()
			task.delay(0.2, function() if indicator then indicator:Destroy() end end)
		end
	end
	
	for name, content in pairs(tabContents) do
		content.Visible = (name == tabName)
	end
end

for name, btn in pairs(tabButtons) do
	btn.MouseButton1Click:Connect(function()
		switchTab(name)
	end)
	
	btn.MouseEnter:Connect(function()
		if currentTab ~= name then
			createTween(btn, 0.2, {BackgroundColor3 = Color3.fromRGB(25, 25, 31)}):Play()
		end
	end)
	
	btn.MouseLeave:Connect(function()
		if currentTab ~= name then
			createTween(btn, 0.2, {BackgroundColor3 = Color3.fromRGB(22, 22, 27)}):Play()
		end
	end)
end

-- FEATURES TAB
local featuresContent = tabContents["Features"]
local yPos = 0

local function createFeature(name, desc, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 70)
	container.Position = UDim2.new(0, 0, 0, yPos)
	container.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
	container.BorderSizePixel = 0
	container.Parent = featuresContent
	
	yPos = yPos + 75
	featuresContent.CanvasSize = UDim2.new(0, 0, 0, yPos - 5)
	
	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 8)
	containerCorner.Parent = container
	
	container.MouseEnter:Connect(function()
		createTween(container, 0.15, {BackgroundColor3 = Color3.fromRGB(28, 28, 35)}):Play()
	end)
	
	container.MouseLeave:Connect(function()
		createTween(container, 0.15, {BackgroundColor3 = Color3.fromRGB(24, 24, 30)}):Play()
	end)
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Text = name
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextSize = 14
	nameLabel.BackgroundTransparency = 1
	nameLabel.Size = UDim2.new(1, -140, 0, 20)
	nameLabel.Position = UDim2.new(0, 16, 0, 14)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = container
	
	local descLabel = Instance.new("TextLabel")
	descLabel.Text = desc
	descLabel.Font = Enum.Font.Gotham
	descLabel.TextColor3 = Color3.fromRGB(130, 135, 145)
	descLabel.TextSize = 11
	descLabel.BackgroundTransparency = 1
	descLabel.Size = UDim2.new(1, -140, 0, 18)
	descLabel.Position = UDim2.new(0, 16, 0, 36)
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.Parent = container
	
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Text = "Inactive"
	statusLabel.Font = Enum.Font.GothamMedium
	statusLabel.TextColor3 = Color3.fromRGB(130, 135, 145)
	statusLabel.TextSize = 10
	statusLabel.BackgroundTransparency = 1
	statusLabel.Size = UDim2.new(0, 60, 0, 14)
	statusLabel.Position = UDim2.new(1, -110, 0, 53)
	statusLabel.TextXAlignment = Enum.TextXAlignment.Right
	statusLabel.Parent = container
	
	-- Modern toggle switch
	local toggleTrack = Instance.new("Frame")
	toggleTrack.Size = UDim2.new(0, 50, 0, 26)
	toggleTrack.Position = UDim2.new(1, -66, 0, 22)
	toggleTrack.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
	toggleTrack.BorderSizePixel = 0
	toggleTrack.Parent = container
	
	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(1, 0)
	trackCorner.Parent = toggleTrack
	
	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Text = ""
	toggleBtn.Size = UDim2.new(0, 22, 0, 22)
	toggleBtn.Position = UDim2.new(0, 2, 0, 2)
	toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	toggleBtn.BorderSizePixel = 0
	toggleBtn.AutoButtonColor = false
	toggleBtn.Parent = toggleTrack
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(1, 0)
	btnCorner.Parent = toggleBtn
	
	local isOn = false
	
	toggleBtn.MouseButton1Click:Connect(function()
		isOn = not isOn
		
		if isOn then
			createTween(toggleTrack, 0.2, {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}):Play()
			createTween(toggleBtn, 0.2, {Position = UDim2.new(1, -24, 0, 2)}):Play()
			statusLabel.Text = "Active"
			statusLabel.TextColor3 = Color3.fromRGB(67, 181, 129)
		else
			createTween(toggleTrack, 0.2, {BackgroundColor3 = Color3.fromRGB(45, 45, 52)}):Play()
			createTween(toggleBtn, 0.2, {Position = UDim2.new(0, 2, 0, 2)}):Play()
			statusLabel.Text = "Inactive"
			statusLabel.TextColor3 = Color3.fromRGB(130, 135, 145)
		end
		
		callback(isOn)
	end)
end

createFeature("Flight System", "Navigate freely in all directions", function(enabled)
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
		
		notify("Flight system activated", 2)
	else
		if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
		if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
		notify("Flight system deactivated", 2)
	end
end)

createFeature("Speed Enhancement", "Increase movement velocity", function(enabled)
	speedEnabled = enabled
	if enabled then
		humanoid.WalkSpeed = walkSpeed
		notify("Speed enhancement activated", 2)
	else
		humanoid.WalkSpeed = 16
		notify("Speed enhancement deactivated", 2)
	end
end)

createFeature("Infinite Jump", "Unlimited jump capability", function(enabled)
	jumpEnabled = enabled
	notify(enabled and "Infinite jump activated" or "Infinite jump deactivated", 2)
end)

createFeature("Player ESP", "Visualize players through obstacles", function(enabled)
	espEnabled = enabled
	for _, otherPlayer in pairs(Players:GetPlayers()) do
		if otherPlayer ~= player and otherPlayer.Character then
			local highlight = otherPlayer.Character:FindFirstChild("ESPHighlight")
			if enabled and not highlight then
				highlight = Instance.new("Highlight")
				highlight.Name = "ESPHighlight"
				highlight.FillColor = Color3.fromRGB(88, 101, 242)
				highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				highlight.FillTransparency = 0.6
				highlight.OutlineTransparency = 0
				highlight.Parent = otherPlayer.Character
			elseif not enabled and highlight then
				highlight:Destroy()
			end
		end
	end
	notify(enabled and "Player ESP activated" or "Player ESP deactivated", 2)
end)

createFeature("No-Clip", "Phase through solid objects", function(enabled)
	noclipEnabled = enabled
	notify(enabled and "No-clip activated" or "No-clip deactivated", 2)
end)

-- SETTINGS TAB
local settingsContent = tabContents["Settings"]
local settingsY = 0

local function createSlider(name, desc, min, max, default, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 80)
	container.Position = UDim2.new(0, 0, 0, settingsY)
	container.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
	container.BorderSizePixel = 0
	container.Parent = settingsContent
	
	settingsY = settingsY + 85
	settingsContent.CanvasSize = UDim2.new(0, 0, 0, settingsY - 5)
	
	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 8)
	containerCorner.Parent = container
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Text = name
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextSize = 13
	nameLabel.BackgroundTransparency = 1
	nameLabel.Size = UDim2.new(1, -100, 0, 18)
	nameLabel.Position = UDim2.new(0, 16, 0, 12)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = container
	
	local valueLabel = Instance.new("TextLabel")
	valueLabel.Text = tostring(default)
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextColor3 = Color3.fromRGB(88, 101, 242)
	valueLabel.TextSize = 13
	valueLabel.BackgroundTransparency = 1
	valueLabel.Size = UDim2.new(0, 70, 0, 18)
	valueLabel.Position = UDim2.new(1, -86, 0, 12)
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = container
	
	local descLabel = Instance.new("TextLabel")
	descLabel.Text = desc
	descLabel.Font = Enum.Font.Gotham
	descLabel.TextColor3 = Color3.fromRGB(130, 135, 145)
	descLabel.TextSize = 10
	descLabel.BackgroundTransparency = 1
	descLabel.Size = UDim2.new(1, -32, 0, 16)
	descLabel.Position = UDim2.new(0, 16, 0, 30)
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.Parent = container
	
	local sliderBG = Instance.new("Frame")
	sliderBG.Size = UDim2.new(1, -32, 0, 4)
	sliderBG.Position = UDim2.new(0, 16, 0, 58)
	sliderBG.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
	sliderBG.BorderSizePixel = 0
	sliderBG.Parent = container
	
	local sliderCorner = Instance.new("UICorner")
	sliderCorner.CornerRadius = UDim.new(1, 0)
	sliderCorner.Parent = sliderBG
	
	local sliderFill = Instance.new("Frame")
	sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	sliderFill.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
	sliderFill.BorderSizePixel = 0
	sliderFill.Parent = sliderBG
	
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = sliderFill
	
	local sliderBtn = Instance.new("TextButton")
	sliderBtn.Text = ""
	sliderBtn.Size = UDim2.new(0, 16, 0, 16)
	sliderBtn.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
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
			createTween(sliderBtn, 0.1, {Position = UDim2.new(percent, -8, 0.5, -8)}):Play()
			
			callback(value)
		end
	end)
end

createSlider("Flight Speed", "Adjust flight movement velocity", 20, 200, 50, function(value)
	flySpeed = value
end)

createSlider("Walk Speed", "Modify ground movement speed", 16, 200, 100, function(value)
	walkSpeed = value
	if speedEnabled then
		humanoid.WalkSpeed = value
	end
end)

-- ABOUT TAB
local aboutContent = tabContents["About"]

local aboutContainer = Instance.new("Frame")
aboutContainer.Size = UDim2.new(1, 0, 0, 320)
aboutContainer.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
aboutContainer.BorderSizePixel = 0
aboutContainer.Parent = aboutContent

local aboutCorner = Instance.new("UICorner")
aboutCorner.CornerRadius = UDim.new(0, 8)
aboutCorner.Parent = aboutContainer

local infoTitle = Instance.new("TextLabel")
infoTitle.Text = "CHAINIX Professional"
infoTitle.Font = Enum.Font.GothamBold
infoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
infoTitle.TextSize = 16
infoTitle.BackgroundTransparency = 1
infoTitle.Size = UDim2.new(1, -32, 0, 24)
infoTitle.Position = UDim2.new(0, 16, 0, 16)
infoTitle.TextXAlignment = Enum.TextXAlignment.Left
infoTitle.Parent = aboutContainer

local infoVersion = Instance.new("TextLabel")
infoVersion.Text = "Version 2.0 • Professional Edition"
infoVersion.Font = Enum.Font.Gotham
infoVersion.TextColor3 = Color3.fromRGB(130, 135, 145)
infoVersion.TextSize = 11
infoVersion.BackgroundTransparency = 1
infoVersion.Size = UDim2.new(1, -32, 0, 18)
infoVersion.Position = UDim2.new(0, 16, 0, 40)
infoVersion.TextXAlignment = Enum.TextXAlignment.Left
infoVersion.Parent = aboutContainer

local divider1 = Instance.new("Frame")
divider1.Size = UDim2.new(1, -32, 0, 1)
divider1.Position = UDim2.new(0, 16, 0, 72)
divider1.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
divider1.BorderSizePixel = 0
divider1.Parent = aboutContainer

local featuresTitle = Instance.new("TextLabel")
featuresTitle.Text = "FEATURES"
featuresTitle.Font = Enum.Font.GothamBold
featuresTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
featuresTitle.TextSize = 12
featuresTitle.BackgroundTransparency = 1
featuresTitle.Size = UDim2.new(1, -32, 0, 18)
featuresTitle.Position = UDim2.new(0, 16, 0, 88)
featuresTitle.TextXAlignment = Enum.TextXAlignment.Left
featuresTitle.Parent = aboutContainer

local featuresList = Instance.new("TextLabel")
featuresList.Text = [[Flight System - Advanced movement control
Speed Enhancement - Customizable velocity
Infinite Jump - Unlimited vertical movement
Player ESP - Visual awareness system
No-Clip - Collision bypass]]
featuresList.Font = Enum.Font.Gotham
featuresList.TextColor3 = Color3.fromRGB(160, 165, 175)
featuresList.TextSize = 11
featuresList.BackgroundTransparency = 1
featuresList.Size = UDim2.new(1, -32, 0, 100)
featuresList.Position = UDim2.new(0, 16, 0, 110)
featuresList.TextXAlignment = Enum.TextXAlignment.Left
featuresList.TextYAlignment = Enum.TextYAlignment.Top
featuresList.Parent = aboutContainer

local divider2 = Instance.new("Frame")
divider2.Size = UDim2.new(1, -32, 0, 1)
divider2.Position = UDim2.new(0, 16, 0, 220)
divider2.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
divider2.BorderSizePixel = 0
divider2.Parent = aboutContainer

local creditsTitle = Instance.new("TextLabel")
creditsTitle.Text = "DEVELOPER"
creditsTitle.Font = Enum.Font.GothamBold
creditsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
creditsTitle.TextSize = 12
creditsTitle.BackgroundTransparency = 1
creditsTitle.Size = UDim2.new(1, -32, 0, 18)
creditsTitle.Position = UDim2.new(0, 16, 0, 236)
creditsTitle.TextXAlignment = Enum.TextXAlignment.Left
creditsTitle.Parent = aboutContainer

local creditsText = Instance.new("TextLabel")
creditsText.Text = "ChainixScripts\nGitHub.com/ChainixScripts"
creditsText.Font = Enum.Font.Gotham
creditsText.TextColor3 = Color3.fromRGB(160, 165, 175)
creditsText.TextSize = 11
creditsText.BackgroundTransparency = 1
creditsText.Size = UDim2.new(1, -32, 0, 40)
creditsText.Position = UDim2.new(0, 16, 0, 258)
creditsText.TextXAlignment = Enum.TextXAlignment.Left
creditsText.TextYAlignment = Enum.TextYAlignment.Top
creditsText.Parent = aboutContainer

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

notify("CHAINIX loaded successfully", 2)
print("CHAINIX Professional: Initialized")
