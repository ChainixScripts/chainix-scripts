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
	for _, connection in pairs(connections) do
		if connection then
			connection:Disconnect()
		end
	end
	connections = {}
	
	if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
	if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
	
	for _, otherPlayer in pairs(Players:GetPlayers()) do
		if otherPlayer.Character then
			local highlight = otherPlayer.Character:FindFirstChild("ESPHighlight")
			if highlight then highlight:Destroy() end
		end
	end
	
	if humanoid then
		humanoid.WalkSpeed = 16
	end
	
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

-- Main container with backdrop
local backdrop = Instance.new("Frame")
backdrop.Size = UDim2.new(1, 0, 1, 0)
backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backdrop.BackgroundTransparency = 0.5
backdrop.BorderSizePixel = 0
backdrop.Parent = screenGui

-- Main Frame (matching CHAINIX size: 500x320)
local mainFrame = Instance.new("Frame")
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Size = UDim2.new(0, 500, 0, 320)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = false
mainFrame.Parent = backdrop

-- Entrance animations
backdrop.BackgroundTransparency = 1
mainFrame.Size = UDim2.new(0, 400, 0, 250)
tween(backdrop, 0.3, {BackgroundTransparency = 0.5}):Play()
tween(mainFrame, 0.5, {Size = UDim2.new(0, 500, 0, 320)}, Enum.EasingStyle.Back):Play()

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Outer glow
local outerGlow = Instance.new("ImageLabel")
outerGlow.AnchorPoint = Vector2.new(0.5, 0.5)
outerGlow.Size = UDim2.new(1, 60, 1, 60)
outerGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
outerGlow.BackgroundTransparency = 1
outerGlow.Image = "rbxassetid://4996891970"
outerGlow.ImageColor3 = Color3.fromRGB(88, 101, 242)
outerGlow.ImageTransparency = 0.7
outerGlow.ScaleType = Enum.ScaleType.Slice
outerGlow.SliceCenter = Rect.new(128, 128, 128, 128)
outerGlow.ZIndex = 0
outerGlow.Parent = mainFrame

-- Border
local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(88, 101, 242)
border.Thickness = 1
border.Transparency = 0.6
border.Parent = mainFrame

-- Animated gradient border
local borderGradient = Instance.new("UIGradient")
borderGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 101, 242)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 130, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(88, 101, 242))
}
borderGradient.Rotation = 0
borderGradient.Parent = border

spawn(function()
	while screenGui.Parent do
		tween(borderGradient, 3, {Rotation = 360}):Play()
		wait(3)
		borderGradient.Rotation = 0
	end
end)

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Fix header corners (only top)
local headerMask = Instance.new("Frame")
headerMask.Size = UDim2.new(1, 0, 0, 12)
headerMask.Position = UDim2.new(0, 0, 1, -12)
headerMask.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
headerMask.BorderSizePixel = 0
headerMask.Parent = header

local headerBorder = Instance.new("Frame")
headerBorder.Size = UDim2.new(1, 0, 0, 1)
headerBorder.Position = UDim2.new(0, 0, 1, 0)
headerBorder.BackgroundColor3 = Color3.fromRGB(40, 44, 60)
headerBorder.BorderSizePixel = 0
headerBorder.Parent = header

-- Logo
local logoBox = Instance.new("Frame")
logoBox.Size = UDim2.new(0, 32, 0, 32)
logoBox.Position = UDim2.new(0, 12, 0, 9)
logoBox.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
logoBox.BorderSizePixel = 0
logoBox.Parent = header

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 6)
logoCorner.Parent = logoBox

local logoText = Instance.new("TextLabel")
logoText.Text = "C"
logoText.Font = Enum.Font.GothamBold
logoText.TextSize = 18
logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
logoText.BackgroundTransparency = 1
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.Parent = logoBox

-- Pulsing logo animation
spawn(function()
	while screenGui.Parent do
		tween(logoBox, 1, {Size = UDim2.new(0, 34, 0, 34), Position = UDim2.new(0, 11, 0, 8)}):Play()
		wait(1)
		tween(logoBox, 1, {Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(0, 12, 0, 9)}):Play()
		wait(1)
	end
end)

-- Title
local title = Instance.new("TextLabel")
title.Text = "CHAINIX"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(240, 242, 245)
title.BackgroundTransparency = 1
title.Size = UDim2.new(0, 150, 0, 50)
title.Position = UDim2.new(0, 52, 0, 0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 24
closeBtn.TextColor3 = Color3.fromRGB(180, 185, 195)
closeBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -48, 0, 7)
closeBtn.AutoButtonColor = false
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

table.insert(connections, closeBtn.MouseEnter:Connect(function()
	tween(closeBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(239, 68, 68), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end))

table.insert(connections, closeBtn.MouseLeave:Connect(function()
	tween(closeBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(25, 25, 32), TextColor3 = Color3.fromRGB(180, 185, 195)}):Play()
end))

table.insert(connections, closeBtn.MouseButton1Click:Connect(function()
	tween(mainFrame, 0.4, {Size = UDim2.new(0, 400, 0, 250)}, Enum.EasingStyle.Back, Enum.EasingDirection.In):Play()
	tween(backdrop, 0.3, {BackgroundTransparency = 1}):Play()
	wait(0.4)
	cleanup()
end))

-- Content area
local contentScroll = Instance.new("ScrollingFrame")
contentScroll.Size = UDim2.new(1, -24, 1, -64)
contentScroll.Position = UDim2.new(0, 12, 0, 56)
contentScroll.BackgroundTransparency = 1
contentScroll.BorderSizePixel = 0
contentScroll.ScrollBarThickness = 4
contentScroll.ScrollBarImageColor3 = Color3.fromRGB(88, 101, 242)
contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
contentScroll.Parent = mainFrame

local featureY = 0

-- Flight system with dynamic speed slider
local flightContainer = Instance.new("Frame")
flightContainer.Size = UDim2.new(1, 0, 0, 70)
flightContainer.Position = UDim2.new(0, 0, 0, featureY)
flightContainer.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
flightContainer.BorderSizePixel = 0
flightContainer.ClipsDescendants = true
flightContainer.Parent = contentScroll

featureY = featureY + 75

local flightCorner = Instance.new("UICorner")
flightCorner.CornerRadius = UDim.new(0, 8)
flightCorner.Parent = flightContainer

table.insert(connections, flightContainer.MouseEnter:Connect(function()
	tween(flightContainer, 0.15, {BackgroundColor3 = Color3.fromRGB(20, 20, 28)}):Play()
end))

table.insert(connections, flightContainer.MouseLeave:Connect(function()
	tween(flightContainer, 0.15, {BackgroundColor3 = Color3.fromRGB(16, 16, 22)}):Play()
end))

local flightName = Instance.new("TextLabel")
flightName.Text = "Flight System"
flightName.Font = Enum.Font.GothamBold
flightName.TextSize = 14
flightName.TextColor3 = Color3.fromRGB(240, 242, 245)
flightName.BackgroundTransparency = 1
flightName.Size = UDim2.new(1, -140, 0, 20)
flightName.Position = UDim2.new(0, 14, 0, 12)
flightName.TextXAlignment = Enum.TextXAlignment.Left
flightName.Parent = flightContainer

local flightDesc = Instance.new("TextLabel")
flightDesc.Text = "Advanced 3D movement control"
flightDesc.Font = Enum.Font.Gotham
flightDesc.TextSize = 11
flightDesc.TextColor3 = Color3.fromRGB(140, 145, 160)
flightDesc.BackgroundTransparency = 1
flightDesc.Size = UDim2.new(1, -140, 0, 18)
flightDesc.Position = UDim2.new(0, 14, 0, 32)
flightDesc.TextXAlignment = Enum.TextXAlignment.Left
flightDesc.Parent = flightContainer

local flightStatus = Instance.new("TextLabel")
flightStatus.Text = "Inactive"
flightStatus.Font = Enum.Font.GothamMedium
flightStatus.TextSize = 10
flightStatus.TextColor3 = Color3.fromRGB(120, 125, 140)
flightStatus.BackgroundTransparency = 1
flightStatus.Size = UDim2.new(0, 70, 0, 14)
flightStatus.Position = UDim2.new(1, -130, 0, 50)
flightStatus.TextXAlignment = Enum.TextXAlignment.Right
flightStatus.Parent = flightContainer

-- Flight toggle
local flightToggleBG = Instance.new("Frame")
flightToggleBG.Size = UDim2.new(0, 52, 0, 28)
flightToggleBG.Position = UDim2.new(1, -66, 0, 21)
flightToggleBG.BackgroundColor3 = Color3.fromRGB(40, 42, 50)
flightToggleBG.BorderSizePixel = 0
flightToggleBG.Parent = flightContainer

local flightToggleCorner = Instance.new("UICorner")
flightToggleCorner.CornerRadius = UDim.new(1, 0)
flightToggleCorner.Parent = flightToggleBG

local flightToggleBtn = Instance.new("TextButton")
flightToggleBtn.Text = ""
flightToggleBtn.Size = UDim2.new(0, 22, 0, 22)
flightToggleBtn.Position = UDim2.new(0, 3, 0, 3)
flightToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 222, 228)
flightToggleBtn.BorderSizePixel = 0
flightToggleBtn.AutoButtonColor = false
flightToggleBtn.Parent = flightToggleBG

local flightBtnCorner = Instance.new("UICorner")
flightBtnCorner.CornerRadius = UDim.new(1, 0)
flightBtnCorner.Parent = flightToggleBtn

-- Flight speed slider (hidden by default)
local flightSpeedSlider = Instance.new("Frame")
flightSpeedSlider.Size = UDim2.new(1, -28, 0, 0)
flightSpeedSlider.Position = UDim2.new(0, 14, 0, 70)
flightSpeedSlider.BackgroundTransparency = 1
flightSpeedSlider.ClipsDescendants = true
flightSpeedSlider.Parent = flightContainer

local speedLabel = Instance.new("TextLabel")
speedLabel.Text = "Flight Speed"
speedLabel.Font = Enum.Font.GothamMedium
speedLabel.TextSize = 12
speedLabel.TextColor3 = Color3.fromRGB(200, 205, 215)
speedLabel.BackgroundTransparency = 1
speedLabel.Size = UDim2.new(1, -80, 0, 18)
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = flightSpeedSlider

local speedValue = Instance.new("TextLabel")
speedValue.Text = tostring(flySpeed)
speedValue.Font = Enum.Font.GothamBold
speedValue.TextSize = 12
speedValue.TextColor3 = Color3.fromRGB(88, 101, 242)
speedValue.BackgroundTransparency = 1
speedValue.Size = UDim2.new(0, 60, 0, 18)
speedValue.Position = UDim2.new(1, -60, 0, 0)
speedValue.TextXAlignment = Enum.TextXAlignment.Right
speedValue.Parent = flightSpeedSlider

local sliderBG = Instance.new("Frame")
sliderBG.Size = UDim2.new(1, 0, 0, 4)
sliderBG.Position = UDim2.new(0, 0, 0, 26)
sliderBG.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
sliderBG.BorderSizePixel = 0
sliderBG.Parent = flightSpeedSlider

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(1, 0)
sliderCorner.Parent = sliderBG

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new((flySpeed - 20) / 180, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderBG

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = sliderFill

local sliderBtn = Instance.new("TextButton")
sliderBtn.Text = ""
sliderBtn.Size = UDim2.new(0, 14, 0, 14)
sliderBtn.Position = UDim2.new((flySpeed - 20) / 180, -7, 0.5, -7)
sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderBtn.BorderSizePixel = 0
sliderBtn.AutoButtonColor = false
sliderBtn.Parent = sliderBG

local sliderBtnCorner = Instance.new("UICorner")
sliderBtnCorner.CornerRadius = UDim.new(1, 0)
sliderBtnCorner.Parent = sliderBtn

-- Slider drag logic
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
		local value = math.floor(20 + 180 * percent)
		
		flySpeed = value
		speedValue.Text = tostring(value)
		tween(sliderFill, 0.1, {Size = UDim2.new(percent, 0, 1, 0)}):Play()
		tween(sliderBtn, 0.1, {Position = UDim2.new(percent, -7, 0.5, -7)}):Play()
	end
end))

-- Flight toggle logic
table.insert(connections, flightToggleBtn.MouseButton1Click:Connect(function()
	flyEnabled = not flyEnabled
	
	if flyEnabled then
		-- Activate flight
		tween(flightToggleBG, 0.25, {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}):Play()
		tween(flightToggleBtn, 0.25, {Position = UDim2.new(1, -25, 0, 3)}):Play()
		flightStatus.Text = "Active"
		flightStatus.TextColor3 = Color3.fromRGB(100, 200, 120)
		
		-- Expand container to show slider
		tween(flightContainer, 0.3, {Size = UDim2.new(1, 0, 0, 120)}):Play()
		tween(flightSpeedSlider, 0.3, {Size = UDim2.new(1, -28, 0, 40)}):Play()
		
		-- Create flight objects
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
		-- Deactivate flight
		tween(flightToggleBG, 0.25, {BackgroundColor3 = Color3.fromRGB(40, 42, 50)}):Play()
		tween(flightToggleBtn, 0.25, {Position = UDim2.new(0, 3, 0, 3)}):Play()
		flightStatus.Text = "Inactive"
		flightStatus.TextColor3 = Color3.fromRGB(120, 125, 140)
		
		-- Collapse container
		tween(flightSpeedSlider, 0.3, {Size = UDim2.new(1, -28, 0, 0)}):Play()
		tween(flightContainer, 0.3, {Size = UDim2.new(1, 0, 0, 70)}):Play()
		
		-- Remove flight objects
		if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
		if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
		
		notify("Flight system deactivated")
	end
end))

-- Other features (standard size)
local function createFeature(name, desc, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 70)
	container.Position = UDim2.new(0, 0, 0, featureY)
	container.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
	container.BorderSizePixel = 0
	container.Parent = contentScroll
	
	featureY = featureY + 75
	contentScroll.CanvasSize = UDim2.new(0, 0, 0, featureY)
	
	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 8)
	containerCorner.Parent = container
	
	table.insert(connections, container.MouseEnter:Connect(function()
		tween(container, 0.15, {BackgroundColor3 = Color3.fromRGB(20, 20, 28)}):Play()
	end))
	
	table.insert(connections, container.MouseLeave:Connect(function()
		tween(container, 0.15, {BackgroundColor3 = Color3.fromRGB(16, 16, 22)}):Play()
	end))
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Text = name
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 14
	nameLabel.TextColor3 = Color3.fromRGB(240, 242, 245)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Size = UDim2.new(1, -140, 0, 20)
	nameLabel.Position = UDim2.new(0, 14, 0, 12)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = container
	
	local descLabel = Instance.new("TextLabel")
	descLabel.Text = desc
	descLabel.Font = Enum.Font.Gotham
	descLabel.TextSize = 11
	descLabel.TextColor3 = Color3.fromRGB(140, 145, 160)
	descLabel.BackgroundTransparency = 1
	descLabel.Size = UDim2.new(1, -140, 0, 18)
	descLabel.Position = UDim2.new(0, 14, 0, 32)
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.Parent = container
	
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Text = "Inactive"
	statusLabel.Font = Enum.Font.GothamMedium
	statusLabel.TextSize = 10
	statusLabel.TextColor3 = Color3.fromRGB(120, 125, 140)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Size = UDim2.new(0, 70, 0, 14)
	statusLabel.Position = UDim2.new(1, -130, 0, 50)
	statusLabel.TextXAlignment = Enum.TextXAlignment.Right
	statusLabel.Parent = container
	
	local toggleBG = Instance.new("Frame")
	toggleBG.Size = UDim2.new(0, 52, 0, 28)
	toggleBG.Position = UDim2.new(1, -66, 0, 21)
	toggleBG.BackgroundColor3 = Color3.fromRGB(40, 42, 50)
	toggleBG.BorderSizePixel = 0
	toggleBG.Parent = container
	
	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(1, 0)
	toggleCorner.Parent = toggleBG
	
	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Text = ""
	toggleBtn.Size = UDim2.new(0, 22, 0, 22)
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
			tween(toggleBG, 0.25, {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}):Play()
			tween(toggleBtn, 0.25, {Position = UDim2.new(1, -25, 0, 3)}):Play()
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
	notify(enabled and "Player ESP activated" or "Player ESP deactivated")
end)

createFeature("No-Clip", "Phase through solid objects", function(enabled)
	noclipEnabled = enabled
	notify(enabled and "No-clip activated" or "No-clip deactivated")
end)

-- Feature loops
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
