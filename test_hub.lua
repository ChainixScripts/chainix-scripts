--[[
	═══════════════════════════════════════
	    CHAINIX ULTIMATE EDITION
	    Premium Script Hub v3.0
	═══════════════════════════════════════
]]--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Connection storage for proper cleanup
local connections = {}

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
screenGui.Name = "ChainixUltimate"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true

local success = pcall(function()
	screenGui.Parent = game:GetService("CoreGui")
end)
if not success then
	screenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Cleanup function
local function cleanup()
	-- Disconnect all connections
	for _, connection in pairs(connections) do
		if connection then
			connection:Disconnect()
		end
	end
	connections = {}
	
	-- Clean up fly objects
	if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
	if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
	
	-- Clean up ESP
	for _, otherPlayer in pairs(Players:GetPlayers()) do
		if otherPlayer.Character then
			local highlight = otherPlayer.Character:FindFirstChild("ESPHighlight")
			if highlight then highlight:Destroy() end
		end
	end
	
	-- Reset humanoid
	if humanoid then
		humanoid.WalkSpeed = 16
	end
	
	-- Destroy GUI
	if screenGui then
		screenGui:Destroy()
	end
	
	print("CHAINIX: Fully cleaned up")
end

-- Utility functions
local function tween(object, time, properties, style, direction)
	style = style or Enum.EasingStyle.Quart
	direction = direction or Enum.EasingDirection.Out
	return TweenService:Create(object, TweenInfo.new(time, style, direction), properties)
end

local function notify(msg)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "CHAINIX";
		Text = msg;
		Duration = 2;
	})
end

-- Main container with backdrop blur effect
local backdrop = Instance.new("Frame")
backdrop.Size = UDim2.new(1, 0, 1, 0)
backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backdrop.BackgroundTransparency = 0.4
backdrop.BorderSizePixel = 0
backdrop.Parent = screenGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Size = UDim2.new(0, 680, 0, 580)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = backdrop

-- Entrance animation
backdrop.BackgroundTransparency = 1
mainFrame.Size = UDim2.new(0, 580, 0, 480)
tween(backdrop, 0.3, {BackgroundTransparency = 0.4}):Play()
tween(mainFrame, 0.5, {Size = UDim2.new(0, 680, 0, 580)}, Enum.EasingStyle.Back):Play()

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

-- Outer glow
local outerGlow = Instance.new("ImageLabel")
outerGlow.AnchorPoint = Vector2.new(0.5, 0.5)
outerGlow.Size = UDim2.new(1, 80, 1, 80)
outerGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
outerGlow.BackgroundTransparency = 1
outerGlow.Image = "rbxassetid://4996891970"
outerGlow.ImageColor3 = Color3.fromRGB(70, 80, 200)
outerGlow.ImageTransparency = 0.7
outerGlow.ScaleType = Enum.ScaleType.Slice
outerGlow.SliceCenter = Rect.new(128, 128, 128, 128)
outerGlow.ZIndex = 0
outerGlow.Parent = mainFrame

-- Subtle border
local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(55, 60, 80)
border.Thickness = 1
border.Transparency = 0.5
border.Parent = mainFrame

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 220, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sidebarBorder = Instance.new("Frame")
sidebarBorder.Size = UDim2.new(0, 1, 1, 0)
sidebarBorder.Position = UDim2.new(1, 0, 0, 0)
sidebarBorder.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
sidebarBorder.BorderSizePixel = 0
sidebarBorder.Parent = sidebar

-- Logo section
local logoSection = Instance.new("Frame")
logoSection.Size = UDim2.new(1, 0, 0, 90)
logoSection.BackgroundTransparency = 1
logoSection.Parent = sidebar

local logoBox = Instance.new("Frame")
logoBox.AnchorPoint = Vector2.new(0.5, 0)
logoBox.Size = UDim2.new(0, 50, 0, 50)
logoBox.Position = UDim2.new(0.5, 0, 0, 20)
logoBox.BackgroundColor3 = Color3.fromRGB(70, 80, 200)
logoBox.BorderSizePixel = 0
logoBox.Parent = logoSection

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 10)
logoCorner.Parent = logoBox

local logoGradient = Instance.new("UIGradient")
logoGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 100, 220)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 70, 180))
}
logoGradient.Rotation = 45
logoGradient.Parent = logoBox

local logoText = Instance.new("TextLabel")
logoText.Text = "C"
logoText.Font = Enum.Font.GothamBold
logoText.TextSize = 28
logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
logoText.BackgroundTransparency = 1
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.Parent = logoBox

local brandText = Instance.new("TextLabel")
brandText.Text = "CHAINIX"
brandText.Font = Enum.Font.GothamBold
brandText.TextSize = 15
brandText.TextColor3 = Color3.fromRGB(240, 242, 245)
brandText.BackgroundTransparency = 1
brandText.Size = UDim2.new(1, 0, 0, 20)
brandText.Position = UDim2.new(0, 0, 0, 75)
brandText.Parent = logoSection

-- Navigation
local navFrame = Instance.new("Frame")
navFrame.Size = UDim2.new(1, 0, 1, -100)
navFrame.Position = UDim2.new(0, 0, 0, 100)
navFrame.BackgroundTransparency = 1
navFrame.Parent = sidebar

local currentPage = "Features"
local navButtons = {}
local pageFrames = {}

local navItems = {
	{name = "Features", icon = "■"},
	{name = "Settings", icon = "◆"},
	{name = "About", icon = "●"}
}

for i, item in ipairs(navItems) do
	local btn = Instance.new("TextButton")
	btn.Name = item.name
	btn.Size = UDim2.new(1, -24, 0, 44)
	btn.Position = UDim2.new(0, 12, 0, (i-1) * 50)
	btn.BackgroundColor3 = currentPage == item.name and Color3.fromRGB(70, 80, 200) or Color3.fromRGB(25, 25, 32)
	btn.BackgroundTransparency = currentPage == item.name and 0 or 0.3
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Text = ""
	btn.Parent = navFrame
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 8)
	btnCorner.Parent = btn
	
	local iconLabel = Instance.new("TextLabel")
	iconLabel.Text = item.icon
	iconLabel.Font = Enum.Font.GothamBold
	iconLabel.TextSize = 16
	iconLabel.TextColor3 = currentPage == item.name and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 145, 160)
	iconLabel.BackgroundTransparency = 1
	iconLabel.Size = UDim2.new(0, 30, 1, 0)
	iconLabel.Position = UDim2.new(0, 8, 0, 0)
	iconLabel.Parent = btn
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Text = item.name
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 13
	nameLabel.TextColor3 = currentPage == item.name and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 145, 160)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Size = UDim2.new(1, -45, 1, 0)
	nameLabel.Position = UDim2.new(0, 38, 0, 0)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = btn
	
	navButtons[item.name] = {button = btn, icon = iconLabel, label = nameLabel}
end

-- Content area
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -220, 1, -80)
contentArea.Position = UDim2.new(0, 220, 0, 80)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

-- Header bar
local headerBar = Instance.new("Frame")
headerBar.Size = UDim2.new(1, -220, 0, 80)
headerBar.Position = UDim2.new(0, 220, 0, 0)
headerBar.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
headerBar.BorderSizePixel = 0
headerBar.Parent = mainFrame

local headerBorder = Instance.new("Frame")
headerBorder.Size = UDim2.new(1, 0, 0, 1)
headerBorder.Position = UDim2.new(0, 0, 1, -1)
headerBorder.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
headerBorder.BorderSizePixel = 0
headerBorder.Parent = headerBar

local pageTitle = Instance.new("TextLabel")
pageTitle.Text = "Features"
pageTitle.Font = Enum.Font.GothamBold
pageTitle.TextSize = 22
pageTitle.TextColor3 = Color3.fromRGB(240, 242, 245)
pageTitle.BackgroundTransparency = 1
pageTitle.Size = UDim2.new(0, 300, 0, 30)
pageTitle.Position = UDim2.new(0, 30, 0, 25)
pageTitle.TextXAlignment = Enum.TextXAlignment.Left
pageTitle.Parent = headerBar

local closeBtn = Instance.new("TextButton")
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 28
closeBtn.TextColor3 = Color3.fromRGB(160, 165, 175)
closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
closeBtn.Size = UDim2.new(0, 44, 0, 44)
closeBtn.Position = UDim2.new(1, -64, 0, 18)
closeBtn.AutoButtonColor = false
closeBtn.Parent = headerBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- Close button functionality
closeBtn.MouseEnter:Connect(function()
	tween(closeBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(220, 60, 60), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)

closeBtn.MouseLeave:Connect(function()
	tween(closeBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(30, 30, 38), TextColor3 = Color3.fromRGB(160, 165, 175)}):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
	-- Exit animations
	tween(mainFrame, 0.4, {Size = UDim2.new(0, 580, 0, 480)}, Enum.EasingStyle.Back, Enum.EasingDirection.In):Play()
	tween(backdrop, 0.3, {BackgroundTransparency = 1}):Play()
	wait(0.4)
	cleanup() -- Proper cleanup
end)

-- Create page frames
for _, item in ipairs(navItems) do
	local pageFrame = Instance.new("ScrollingFrame")
	pageFrame.Name = item.name .. "Page"
	pageFrame.Size = UDim2.new(1, -40, 1, -20)
	pageFrame.Position = UDim2.new(0, 20, 0, 10)
	pageFrame.BackgroundTransparency = 1
	pageFrame.BorderSizePixel = 0
	pageFrame.ScrollBarThickness = 4
	pageFrame.ScrollBarImageColor3 = Color3.fromRGB(70, 80, 200)
	pageFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	pageFrame.Visible = (item.name == currentPage)
	pageFrame.Parent = contentArea
	
	pageFrames[item.name] = pageFrame
end

-- Navigation switching
local function switchPage(pageName)
	currentPage = pageName
	pageTitle.Text = pageName
	
	for name, elements in pairs(navButtons) do
		local isActive = (name == pageName)
		tween(elements.button, 0.2, {
			BackgroundColor3 = isActive and Color3.fromRGB(70, 80, 200) or Color3.fromRGB(25, 25, 32),
			BackgroundTransparency = isActive and 0 or 0.3
		}):Play()
		tween(elements.icon, 0.2, {TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 145, 160)}):Play()
		tween(elements.label, 0.2, {TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 145, 160)}):Play()
	end
	
	for name, frame in pairs(pageFrames) do
		frame.Visible = (name == pageName)
	end
end

for name, elements in pairs(navButtons) do
	table.insert(connections, elements.button.MouseButton1Click:Connect(function()
		switchPage(name)
	end))
	
	table.insert(connections, elements.button.MouseEnter:Connect(function()
		if currentPage ~= name then
			tween(elements.button, 0.15, {BackgroundTransparency = 0.1}):Play()
		end
	end))
	
	table.insert(connections, elements.button.MouseLeave:Connect(function()
		if currentPage ~= name then
			tween(elements.button, 0.15, {BackgroundTransparency = 0.3}):Play()
		end
	end))
end

-- FEATURES PAGE
local featuresPage = pageFrames["Features"]
local featureY = 0

local function createFeature(name, desc, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 85)
	container.Position = UDim2.new(0, 0, 0, featureY)
	container.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
	container.BorderSizePixel = 0
	container.Parent = featuresPage
	
	featureY = featureY + 92
	featuresPage.CanvasSize = UDim2.new(0, 0, 0, featureY)
	
	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 10)
	containerCorner.Parent = container
	
	table.insert(connections, container.MouseEnter:Connect(function()
		tween(container, 0.15, {BackgroundColor3 = Color3.fromRGB(24, 24, 32)}):Play()
	end))
	
	table.insert(connections, container.MouseLeave:Connect(function()
		tween(container, 0.15, {BackgroundColor3 = Color3.fromRGB(20, 20, 26)}):Play()
	end))
	
	local contentFrame = Instance.new("Frame")
	contentFrame.Size = UDim2.new(1, -28, 1, -28)
	contentFrame.Position = UDim2.new(0, 14, 0, 14)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Parent = container
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Text = name
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 15
	nameLabel.TextColor3 = Color3.fromRGB(240, 242, 245)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Size = UDim2.new(1, -120, 0, 22)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = contentFrame
	
	local descLabel = Instance.new("TextLabel")
	descLabel.Text = desc
	descLabel.Font = Enum.Font.Gotham
	descLabel.TextSize = 12
	descLabel.TextColor3 = Color3.fromRGB(140, 145, 160)
	descLabel.BackgroundTransparency = 1
	descLabel.Size = UDim2.new(1, -120, 0, 18)
	descLabel.Position = UDim2.new(0, 0, 0, 24)
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.Parent = contentFrame
	
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Text = "Inactive"
	statusLabel.Font = Enum.Font.GothamMedium
	statusLabel.TextSize = 11
	statusLabel.TextColor3 = Color3.fromRGB(120, 125, 140)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Size = UDim2.new(0, 80, 0, 16)
	statusLabel.Position = UDim2.new(1, -120, 0, 41)
	statusLabel.TextXAlignment = Enum.TextXAlignment.Right
	statusLabel.Parent = contentFrame
	
	-- Modern toggle
	local toggleBG = Instance.new("Frame")
	toggleBG.Size = UDim2.new(0, 56, 0, 30)
	toggleBG.Position = UDim2.new(1, -56, 0, 13.5)
	toggleBG.BackgroundColor3 = Color3.fromRGB(40, 42, 50)
	toggleBG.BorderSizePixel = 0
	toggleBG.Parent = contentFrame
	
	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(1, 0)
	toggleCorner.Parent = toggleBG
	
	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Text = ""
	toggleBtn.Size = UDim2.new(0, 24, 0, 24)
	toggleBtn.Position = UDim2.new(0, 3, 0, 3)
	toggleBtn.BackgroundColor3 = Color3.fromRGB(220, 222, 228)
	toggleBtn.BorderSizePixel = 0
	toggleBtn.AutoButtonColor = false
	toggleBtn.Parent = toggleBG
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(1, 0)
	btnCorner.Parent = toggleBtn
	
	local isOn = false
	
	table.insert(connections, toggleBtn.MouseButton1Click:Connect(function()
		isOn = not isOn
		
		if isOn then
			tween(toggleBG, 0.25, {BackgroundColor3 = Color3.fromRGB(70, 80, 200)}):Play()
			tween(toggleBtn, 0.25, {Position = UDim2.new(1, -27, 0, 3)}):Play()
			statusLabel.Text = "Active"
			statusLabel.TextColor3 = Color3.fromRGB(100, 200, 120)
		else
			tween(toggleBG, 0.25, {BackgroundColor3 = Color3.fromRGB(40, 42, 50)}):Play()
			tween(toggleBtn, 0.25, {Position = UDim2.new(0, 3, 0, 3)}):Play()
			statusLabel.Text = "Inactive"
			statusLabel.TextColor3 = Color3.fromRGB(120, 125, 140)
		end
		
		callback(isOn)
	end))
end

createFeature("Flight System", "Advanced 3D movement control", function(enabled)
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
		
		notify("Flight system activated")
	else
		if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
		if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
		notify("Flight system deactivated")
	end
end)

createFeature("Speed Enhancement", "Customizable movement velocity", function(enabled)
	speedEnabled = enabled
	if enabled then
		humanoid.WalkSpeed = walkSpeed
		notify("Speed enhancement activated")
	else
		humanoid.WalkSpeed = 16
		notify("Speed enhancement deactivated")
	end
end)

createFeature("Infinite Jump", "Unlimited vertical movement", function(enabled)
	jumpEnabled = enabled
	notify(enabled and "Infinite jump activated" or "Infinite jump deactivated")
end)

createFeature("Player ESP", "Visual awareness system", function(enabled)
	espEnabled = enabled
	for _, otherPlayer in pairs(Players:GetPlayers()) do
		if otherPlayer ~= player and otherPlayer.Character then
			local highlight = otherPlayer.Character:FindFirstChild("ESPHighlight")
			if enabled and not highlight then
				highlight = Instance.new("Highlight")
				highlight.Name = "ESPHighlight"
				highlight.FillColor = Color3.fromRGB(70, 80, 200)
				highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				highlight.FillTransparency = 0.6
				highlight.OutlineTransparency = 0
				highlight.Parent = otherPlayer.Character
			elseif not enabled and highlight then
				highlight:Destroy()
			end
		end
	end
	notify(enabled and "Player ESP activated" or "Player ESP deactivated")
end)

createFeature("No-Clip", "Phase through solid objects", function(enabled)
	noclipEnabled = enabled
	notify(enabled and "No-clip activated" or "No-clip deactivated")
end)

-- SETTINGS PAGE
local settingsPage = pageFrames["Settings"]
local settingsY = 0

local function createSlider(name, desc, min, max, default, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 95)
	container.Position = UDim2.new(0, 0, 0, settingsY)
	container.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
	container.BorderSizePixel = 0
	container.Parent = settingsPage
	
	settingsY = settingsY + 102
	settingsPage.CanvasSize = UDim2.new(0, 0, 0, settingsY)
	
	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 10)
	containerCorner.Parent = container
	
	local contentFrame = Instance.new("Frame")
	contentFrame.Size = UDim2.new(1, -28, 1, -28)
	contentFrame.Position = UDim2.new(0, 14, 0, 14)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Parent = container
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Text = name
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 14
	nameLabel.TextColor3 = Color3.fromRGB(240, 242, 245)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Size = UDim2.new(1, -80, 0, 20)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = contentFrame
	
	local valueLabel = Instance.new("TextLabel")
	valueLabel.Text = tostring(default)
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextSize = 14
	valueLabel.TextColor3 = Color3.fromRGB(70, 80, 200)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Size = UDim2.new(0, 70, 0, 20)
	valueLabel.Position = UDim2.new(1, -70, 0, 0)
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = contentFrame
	
	local descLabel = Instance.new("TextLabel")
	descLabel.Text = desc
	descLabel.Font = Enum.Font.Gotham
	descLabel.TextSize = 11
	descLabel.TextColor3 = Color3.fromRGB(140, 145, 160)
	descLabel.BackgroundTransparency = 1
	descLabel.Size = UDim2.new(1, 0, 0, 18)
	descLabel.Position = UDim2.new(0, 0, 0, 22)
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.Parent = contentFrame
	
	local sliderBG = Instance.new("Frame")
	sliderBG.Size = UDim2.new(1, 0, 0, 6)
	sliderBG.Position = UDim2.new(0, 0, 0, 55)
	sliderBG.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
	sliderBG.BorderSizePixel = 0
	sliderBG.Parent = contentFrame
	
	local sliderCorner = Instance.new("UICorner")
	sliderCorner.CornerRadius = UDim.new(1, 0)
	sliderCorner.Parent = sliderBG
	
	local sliderFill = Instance.new("Frame")
	sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	sliderFill.BackgroundColor3 = Color3.fromRGB(70, 80, 200)
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
	
	table.insert(connections, sliderBtn.MouseButton1Down:Connect(function()
		dragging = true
	end))
	
	table.insert(connections, UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end))
	
	table.insert(connections, sliderBG.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end))
	
	table.insert(connections, UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mousePos = UserInputService:GetMouseLocation().X
			local sliderPos = sliderBG.AbsolutePosition.X
			local sliderSize = sliderBG.AbsoluteSize.X
			
			local percent = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
			local value = math.floor(min + (max - min) * percent)
			
			valueLabel.Text = tostring(value)
			tween(sliderFill, 0.1, {Size = UDim2.new(percent, 0, 1, 0)}):Play()
			tween(sliderBtn, 0.1, {Position = UDim2.new(percent, -9, 0.5, -9)}):Play()
			
			callback(value)
		end
	end))
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

-- ABOUT PAGE
local aboutPage = pageFrames["About"]

local aboutContainer = Instance.new("Frame")
aboutContainer.Size = UDim2.new(1, 0, 0, 380)
aboutContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
aboutContainer.BorderSizePixel = 0
aboutContainer.Parent = aboutPage

local aboutCorner = Instance.new("UICorner")
aboutCorner.CornerRadius = UDim.new(0, 10)
aboutCorner.Parent = aboutContainer

local aboutContent = Instance.new("Frame")
aboutContent.Size = UDim2.new(1, -40, 1, -40)
aboutContent.Position = UDim2.new(0, 20, 0, 20)
aboutContent.BackgroundTransparency = 1
aboutContent.Parent = aboutContainer

-- About content
local sections = {
	{title = "CHAINIX Ultimate", subtitle = "Version 3.0 • Professional Edition", yPos = 0},
	{type = "divider", yPos = 60},
	{type = "header", text = "FEATURES", yPos = 75},
	{type = "list", text = "Flight System • Advanced 3D movement\nSpeed Enhancement • Customizable velocity\nInfinite Jump • Unlimited vertical movement\nPlayer ESP • Visual awareness system\nNo-Clip • Phase through solid objects", yPos = 95},
	{type = "divider", yPos = 200},
	{type = "header", text = "DEVELOPER", yPos = 215},
	{type = "info", text = "ChainixScripts\nGitHub.com/ChainixScripts", yPos = 235},
	{type = "divider", yPos = 290},
	{type = "footer", text = "Thank you for using CHAINIX Ultimate\nFor support and updates, visit our GitHub", yPos = 305}
}

for _, section in ipairs(sections) do
	if section.type == "divider" then
		local divider = Instance.new("Frame")
		divider.Size = UDim2.new(1, 0, 0, 1)
		divider.Position = UDim2.new(0, 0, 0, section.yPos)
		divider.BackgroundColor3 = Color3.fromRGB(35, 37, 45)
		divider.BorderSizePixel = 0
		divider.Parent = aboutContent
	elseif section.type == "header" then
		local header = Instance.new("TextLabel")
		header.Text = section.text
		header.Font = Enum.Font.GothamBold
		header.TextSize = 12
		header.TextColor3 = Color3.fromRGB(200, 205, 215)
		header.BackgroundTransparency = 1
		header.Size = UDim2.new(1, 0, 0, 18)
		header.Position = UDim2.new(0, 0, 0, section.yPos)
		header.TextXAlignment = Enum.TextXAlignment.Left
		header.Parent = aboutContent
	elseif section.type == "list" then
		local list = Instance.new("TextLabel")
		list.Text = section.text
		list.Font = Enum.Font.Gotham
		list.TextSize = 12
		list.TextColor3 = Color3.fromRGB(160, 165, 180)
		list.BackgroundTransparency = 1
		list.Size = UDim2.new(1, 0, 0, 100)
		list.Position = UDim2.new(0, 0, 0, section.yPos)
		list.TextXAlignment = Enum.TextXAlignment.Left
		list.TextYAlignment = Enum.TextYAlignment.Top
		list.Parent = aboutContent
	elseif section.type == "info" then
		local info = Instance.new("TextLabel")
		info.Text = section.text
		info.Font = Enum.Font.Gotham
		info.TextSize = 12
		info.TextColor3 = Color3.fromRGB(160, 165, 180)
		info.BackgroundTransparency = 1
		info.Size = UDim2.new(1, 0, 0, 45)
		info.Position = UDim2.new(0, 0, 0, section.yPos)
		info.TextXAlignment = Enum.TextXAlignment.Left
		info.TextYAlignment = Enum.TextYAlignment.Top
		info.Parent = aboutContent
	elseif section.type == "footer" then
		local footer = Instance.new("TextLabel")
		footer.Text = section.text
		footer.Font = Enum.Font.GothamMedium
		footer.TextSize = 11
		footer.TextColor3 = Color3.fromRGB(120, 125, 140)
		footer.BackgroundTransparency = 1
		footer.Size = UDim2.new(1, 0, 0, 40)
		footer.Position = UDim2.new(0, 0, 0, section.yPos)
		footer.TextXAlignment = Enum.TextXAlignment.Center
		footer.TextYAlignment = Enum.TextYAlignment.Top
		footer.Parent = aboutContent
	else
		local title = Instance.new("TextLabel")
		title.Text = section.title
		title.Font = Enum.Font.GothamBold
		title.TextSize = 18
		title.TextColor3 = Color3.fromRGB(240, 242, 245)
		title.BackgroundTransparency = 1
		title.Size = UDim2.new(1, 0, 0, 24)
		title.Position = UDim2.new(0, 0, 0, section.yPos)
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = aboutContent
		
		local subtitle = Instance.new("TextLabel")
		subtitle.Text = section.subtitle
		subtitle.Font = Enum.Font.Gotham
		subtitle.TextSize = 12
		subtitle.TextColor3 = Color3.fromRGB(140, 145, 160)
		subtitle.BackgroundTransparency = 1
		subtitle.Size = UDim2.new(1, 0, 0, 20)
		subtitle.Position = UDim2.new(0, 0, 0, section.yPos + 26)
		subtitle.TextXAlignment = Enum.TextXAlignment.Left
		subtitle.Parent = aboutContent
	end
end

-- Feature loops (properly stored in connections)
table.insert(connections, RunService.Heartbeat:Connect(function()
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
end))

table.insert(connections, UserInputService.JumpRequest:Connect(function()
	if jumpEnabled then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end))

table.insert(connections, RunService.Stepped:Connect(function()
	if noclipEnabled and character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end))

table.insert(connections, player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
	humanoid = newChar:WaitForChild("Humanoid")
	
	if flyEnabled then
		flyEnabled = false
		if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
		if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
	end
end))

notify("CHAINIX Ultimate loaded")
print("CHAINIX Ultimate v3.0: Initialized")
