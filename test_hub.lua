--[[
	═══════════════════════════════════════
	      CHAINIX ULTIMATE PREMIUM
	        Elite Edition v3.0
	     The Most Advanced Script Hub
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

local connections = {}
local flyEnabled, speedEnabled, jumpEnabled, espEnabled, noclipEnabled = false, false, false, false, false
local bodyVelocity, bodyGyro
local flySpeed, walkSpeed = 50, 100

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChainixElite"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true

pcall(function()
	screenGui.Parent = game:GetService("CoreGui")
end)
if not screenGui.Parent then
	screenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Cleanup
local function cleanup()
	for _, conn in pairs(connections) do
		if conn then conn:Disconnect() end
	end
	connections = {}
	if bodyVelocity then bodyVelocity:Destroy() end
	if bodyGyro then bodyGyro:Destroy() end
	for _, p in pairs(Players:GetPlayers()) do
		if p.Character then
			local h = p.Character:FindFirstChild("ESPHighlight")
			if h then h:Destroy() end
		end
	end
	if humanoid then humanoid.WalkSpeed = 16 end
	if screenGui then screenGui:Destroy() end
end

-- Tween utility
local function tween(obj, time, props, style, dir)
	return TweenService:Create(obj, TweenInfo.new(time, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props)
end

local function notify(msg)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "CHAINIX ELITE";
		Text = msg;
		Duration = 2;
	})
end

-- Backdrop with blur effect
local backdrop = Instance.new("Frame")
backdrop.Size = UDim2.new(1, 0, 1, 0)
backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backdrop.BackgroundTransparency = 0.3
backdrop.BorderSizePixel = 0
backdrop.Parent = screenGui

-- Blur effect
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = game:GetService("Lighting")

-- Main container
local mainFrame = Instance.new("Frame")
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Size = UDim2.new(0, 500, 0, 320)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = false
mainFrame.Parent = backdrop

-- Entrance animations
backdrop.BackgroundTransparency = 1
blur.Size = 0
mainFrame.Size = UDim2.new(0, 400, 0, 250)
mainFrame.BackgroundTransparency = 1
tween(backdrop, 0.4, {BackgroundTransparency = 0.3}):Play()
tween(blur, 0.4, {Size = 12}):Play()
tween(mainFrame, 0.6, {Size = UDim2.new(0, 500, 0, 320), BackgroundTransparency = 0.15}, Enum.EasingStyle.Back):Play()

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

-- Glass effect overlay
local glassOverlay = Instance.new("Frame")
glassOverlay.Size = UDim2.new(1, 0, 1, 0)
glassOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glassOverlay.BackgroundTransparency = 0.96
glassOverlay.BorderSizePixel = 0
glassOverlay.Parent = mainFrame

local glassCorner = Instance.new("UICorner")
glassCorner.CornerRadius = UDim.new(0, 16)
glassCorner.Parent = glassOverlay

-- Gradient overlay
local gradientOverlay = Instance.new("Frame")
gradientOverlay.Size = UDim2.new(1, 0, 1, 0)
gradientOverlay.BackgroundTransparency = 1
gradientOverlay.BorderSizePixel = 0
gradientOverlay.Parent = mainFrame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 150, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 100, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 150, 255))
}
gradient.Rotation = 45
gradient.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 0.95),
	NumberSequenceKeypoint.new(0.5, 0.98),
	NumberSequenceKeypoint.new(1, 0.95)
}
gradient.Parent = gradientOverlay

-- Rotating gradient animation
spawn(function()
	while screenGui.Parent do
		tween(gradient, 4, {Rotation = gradient.Rotation + 180}, Enum.EasingStyle.Linear):Play()
		wait(4)
	end
end)

-- Premium border with RGB effect
local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(100, 150, 255)
border.Thickness = 2
border.Transparency = 0.3
border.Parent = mainFrame

local borderGradient = Instance.new("UIGradient")
borderGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 150, 255)),
	ColorSequenceKeypoint.new(0.33, Color3.fromRGB(150, 100, 255)),
	ColorSequenceKeypoint.new(0.66, Color3.fromRGB(255, 100, 150)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 150, 255))
}
borderGradient.Rotation = 0
borderGradient.Parent = border

-- RGB border rotation
spawn(function()
	while screenGui.Parent do
		tween(borderGradient, 3, {Rotation = 360}, Enum.EasingStyle.Linear):Play()
		wait(3)
		borderGradient.Rotation = 0
	end
end)

-- Outer glow (premium shadow)
local outerGlow = Instance.new("ImageLabel")
outerGlow.AnchorPoint = Vector2.new(0.5, 0.5)
outerGlow.Size = UDim2.new(1, 100, 1, 100)
outerGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
outerGlow.BackgroundTransparency = 1
outerGlow.Image = "rbxassetid://4996891970"
outerGlow.ImageColor3 = Color3.fromRGB(100, 150, 255)
outerGlow.ImageTransparency = 0.5
outerGlow.ScaleType = Enum.ScaleType.Slice
outerGlow.SliceCenter = Rect.new(128, 128, 128, 128)
outerGlow.ZIndex = 0
outerGlow.Parent = mainFrame

-- Glow pulsing animation
spawn(function()
	while screenGui.Parent do
		tween(outerGlow, 2, {ImageTransparency = 0.7}):Play()
		wait(2)
		tween(outerGlow, 2, {ImageTransparency = 0.5}):Play()
		wait(2)
	end
end)

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

-- Fix header bottom corners
local headerMask = Instance.new("Frame")
headerMask.Size = UDim2.new(1, 0, 0, 16)
headerMask.Position = UDim2.new(0, 0, 1, -16)
headerMask.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
headerMask.BackgroundTransparency = 0.3
headerMask.BorderSizePixel = 0
headerMask.Parent = header

-- Premium shine effect on header
local headerShine = Instance.new("Frame")
headerShine.Size = UDim2.new(0, 200, 1, 0)
headerShine.Position = UDim2.new(0, -200, 0, 0)
headerShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
headerShine.BackgroundTransparency = 0.9
headerShine.BorderSizePixel = 0
headerShine.Rotation = 20
headerShine.Parent = header

-- Animated shine sweep
spawn(function()
	wait(0.5)
	while screenGui.Parent do
		tween(headerShine, 2, {Position = UDim2.new(1, 0, 0, 0)}, Enum.EasingStyle.Sine):Play()
		wait(4)
		headerShine.Position = UDim2.new(0, -200, 0, 0)
		wait(2)
	end
end)

local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, 0, 0, 2)
headerLine.Position = UDim2.new(0, 0, 1, 0)
headerLine.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
headerLine.BackgroundTransparency = 0.6
headerLine.BorderSizePixel = 0
headerLine.Parent = header

local lineGradient = Instance.new("UIGradient")
lineGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 150, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 100, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 150, 255))
}
lineGradient.Parent = headerLine

-- Premium logo with glow
local logoContainer = Instance.new("Frame")
logoContainer.Size = UDim2.new(0, 40, 0, 40)
logoContainer.Position = UDim2.new(0, 15, 0, 10)
logoContainer.BackgroundTransparency = 1
logoContainer.Parent = header

local logoGlow = Instance.new("ImageLabel")
logoGlow.AnchorPoint = Vector2.new(0.5, 0.5)
logoGlow.Size = UDim2.new(1, 30, 1, 30)
logoGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
logoGlow.BackgroundTransparency = 1
logoGlow.Image = "rbxassetid://4996891970"
logoGlow.ImageColor3 = Color3.fromRGB(100, 150, 255)
logoGlow.ImageTransparency = 0.6
logoGlow.ScaleType = Enum.ScaleType.Slice
logoGlow.SliceCenter = Rect.new(128, 128, 128, 128)
logoGlow.Parent = logoContainer

local logo = Instance.new("Frame")
logo.Size = UDim2.new(1, 0, 1, 0)
logo.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
logo.BorderSizePixel = 0
logo.Parent = logoContainer

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 10)
logoCorner.Parent = logo

local logoGradient = Instance.new("UIGradient")
logoGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 170, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 130, 235))
}
logoGradient.Rotation = 90
logoGradient.Parent = logo

local logoText = Instance.new("TextLabel")
logoText.Text = "C"
logoText.Font = Enum.Font.GothamBold
logoText.TextSize = 22
logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
logoText.BackgroundTransparency = 1
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.Parent = logo

-- Pulsing logo
spawn(function()
	while screenGui.Parent do
		tween(logoContainer, 1.5, {Size = UDim2.new(0, 44, 0, 44), Position = UDim2.new(0, 13, 0, 8)}):Play()
		tween(logoGlow, 1.5, {ImageTransparency = 0.3}):Play()
		wait(1.5)
		tween(logoContainer, 1.5, {Size = UDim2.new(0, 40, 0, 40), Position = UDim2.new(0, 15, 0, 10)}):Play()
		tween(logoGlow, 1.5, {ImageTransparency = 0.6}):Play()
		wait(1.5)
	end
end)

-- Premium title with gradient
local titleContainer = Instance.new("Frame")
titleContainer.Size = UDim2.new(0, 200, 0, 40)
titleContainer.Position = UDim2.new(0, 65, 0, 10)
titleContainer.BackgroundTransparency = 1
titleContainer.Parent = header

local title = Instance.new("TextLabel")
title.Text = "CHAINIX"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 24)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleContainer

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 200, 255))
}
titleGradient.Parent = title

local subtitle = Instance.new("TextLabel")
subtitle.Text = "ELITE EDITION"
subtitle.Font = Enum.Font.GothamBold
subtitle.TextSize = 10
subtitle.TextColor3 = Color3.fromRGB(100, 150, 255)
subtitle.BackgroundTransparency = 1
subtitle.Size = UDim2.new(1, 0, 0, 14)
subtitle.Position = UDim2.new(0, 0, 0, 24)
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = titleContainer

-- Premium badge
local badge = Instance.new("Frame")
badge.Size = UDim2.new(0, 70, 0, 22)
badge.Position = UDim2.new(1, -160, 0, 19)
badge.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
badge.BackgroundTransparency = 0.8
badge.BorderSizePixel = 0
badge.Parent = header

local badgeCorner = Instance.new("UICorner")
badgeCorner.CornerRadius = UDim.new(0, 11)
badgeCorner.Parent = badge

local badgeBorder = Instance.new("UIStroke")
badgeBorder.Color = Color3.fromRGB(100, 150, 255)
badgeBorder.Thickness = 1
badgeBorder.Transparency = 0.5
badgeBorder.Parent = badge

local badgeText = Instance.new("TextLabel")
badgeText.Text = "PREMIUM"
badgeText.Font = Enum.Font.GothamBold
badgeText.TextSize = 9
badgeText.TextColor3 = Color3.fromRGB(255, 255, 255)
badgeText.BackgroundTransparency = 1
badgeText.Size = UDim2.new(1, 0, 1, 0)
badgeText.Parent = badge

-- Close button (premium style)
local closeBtn = Instance.new("TextButton")
closeBtn.Text = ""
closeBtn.Size = UDim2.new(0, 44, 0, 44)
closeBtn.Position = UDim2.new(1, -56, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
closeBtn.BackgroundTransparency = 0.5
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeBtn

local closeBorder = Instance.new("UIStroke")
closeBorder.Color = Color3.fromRGB(60, 65, 80)
closeBorder.Thickness = 1
closeBorder.Transparency = 0.5
closeBorder.Parent = closeBtn

local closeX = Instance.new("TextLabel")
closeX.Text = "×"
closeX.Font = Enum.Font.GothamBold
closeX.TextSize = 28
closeX.TextColor3 = Color3.fromRGB(200, 205, 215)
closeX.BackgroundTransparency = 1
closeX.Size = UDim2.new(1, 0, 1, 0)
closeX.Parent = closeBtn

table.insert(connections, closeBtn.MouseEnter:Connect(function()
	tween(closeBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(255, 80, 80), BackgroundTransparency = 0}):Play()
	tween(closeBorder, 0.2, {Color = Color3.fromRGB(255, 100, 100), Transparency = 0}):Play()
	tween(closeX, 0.2, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end))

table.insert(connections, closeBtn.MouseLeave:Connect(function()
	tween(closeBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(20, 20, 28), BackgroundTransparency = 0.5}):Play()
	tween(closeBorder, 0.2, {Color = Color3.fromRGB(60, 65, 80), Transparency = 0.5}):Play()
	tween(closeX, 0.2, {TextColor3 = Color3.fromRGB(200, 205, 215)}):Play()
end))

table.insert(connections, closeBtn.MouseButton1Click:Connect(function()
	-- Exit animations
	tween(mainFrame, 0.5, {Size = UDim2.new(0, 400, 0, 250), BackgroundTransparency = 1}, Enum.EasingStyle.Back, Enum.EasingDirection.In):Play()
	tween(backdrop, 0.4, {BackgroundTransparency = 1}):Play()
	tween(blur, 0.4, {Size = 0}):Play()
	wait(0.5)
	blur:Destroy()
	cleanup()
end))

-- Content area
local contentScroll = Instance.new("ScrollingFrame")
contentScroll.Size = UDim2.new(1, -30, 1, -78)
contentScroll.Position = UDim2.new(0, 15, 0, 68)
contentScroll.BackgroundTransparency = 1
contentScroll.BorderSizePixel = 0
contentScroll.ScrollBarThickness = 3
contentScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
contentScroll.Parent = mainFrame

local featureY = 0

-- Flight system with dynamic slider
local flightContainer = Instance.new("Frame")
flightContainer.Size = UDim2.new(1, 0, 0, 75)
flightContainer.Position = UDim2.new(0, 0, 0, 0)
flightContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
flightContainer.BackgroundTransparency = 0.4
flightContainer.BorderSizePixel = 0
flightContainer.ClipsDescendants = true
flightContainer.Parent = contentScroll

local flightCorner = Instance.new("UICorner")
flightCorner.CornerRadius = UDim.new(0, 12)
flightCorner.Parent = flightContainer

local flightBorder = Instance.new("UIStroke")
flightBorder.Color = Color3.fromRGB(100, 150, 255)
flightBorder.Thickness = 1
flightBorder.Transparency = 0.8
flightBorder.Parent = flightContainer

local flightGlow = Instance.new("Frame")
flightGlow.Size = UDim2.new(1, 0, 1, 0)
flightGlow.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
flightGlow.BackgroundTransparency = 0.97
flightGlow.BorderSizePixel = 0
flightGlow.Parent = flightContainer

local flightGlowCorner = Instance.new("UICorner")
flightGlowCorner.CornerRadius = UDim.new(0, 12)
flightGlowCorner.Parent = flightGlow

table.insert(connections, flightContainer.MouseEnter:Connect(function()
	tween(flightBorder, 0.2, {Transparency = 0.4}):Play()
	tween(flightGlow, 0.2, {BackgroundTransparency = 0.94}):Play()
end))

table.insert(connections, flightContainer.MouseLeave:Connect(function()
	tween(flightBorder, 0.2, {Transparency = 0.8}):Play()
	tween(flightGlow, 0.2, {BackgroundTransparency = 0.97}):Play()
end))

local flightName = Instance.new("TextLabel")
flightName.Text = "Flight System"
flightName.Font = Enum.Font.GothamBold
flightName.TextSize = 15
flightName.TextColor3 = Color3.fromRGB(255, 255, 255)
flightName.BackgroundTransparency = 1
flightName.Size = UDim2.new(1, -140, 0, 22)
flightName.Position = UDim2.new(0, 18, 0, 14)
flightName.TextXAlignment = Enum.TextXAlignment.Left
flightName.Parent = flightContainer

local flightDesc = Instance.new("TextLabel")
flightDesc.Text = "Advanced 3D movement control"
flightDesc.Font = Enum.Font.Gotham
flightDesc.TextSize = 11
flightDesc.TextColor3 = Color3.fromRGB(160, 170, 190)
flightDesc.BackgroundTransparency = 1
flightDesc.Size = UDim2.new(1, -140, 0, 18)
flightDesc.Position = UDim2.new(0, 18, 0, 36)
flightDesc.TextXAlignment = Enum.TextXAlignment.Left
flightDesc.Parent = flightContainer

local flightStatus = Instance.new("TextLabel")
flightStatus.Text = "Inactive"
flightStatus.Font = Enum.Font.GothamBold
flightStatus.TextSize = 10
flightStatus.TextColor3 = Color3.fromRGB(140, 145, 160)
flightStatus.BackgroundTransparency = 1
flightStatus.Size = UDim2.new(0, 70, 0, 16)
flightStatus.Position = UDim2.new(1, -130, 0, 54)
flightStatus.TextXAlignment = Enum.TextXAlignment.Right
flightStatus.Parent = flightContainer

-- Premium toggle switch
local flightToggleBG = Instance.new("Frame")
flightToggleBG.Size = UDim2.new(0, 56, 0, 30)
flightToggleBG.Position = UDim2.new(1, -70, 0, 22.5)
flightToggleBG.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
flightToggleBG.BorderSizePixel = 0
flightToggleBG.Parent = flightContainer

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = flightToggleBG

local toggleGlow = Instance.new("Frame")
toggleGlow.Size = UDim2.new(1, 0, 1, 0)
toggleGlow.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
toggleGlow.BackgroundTransparency = 1
toggleGlow.BorderSizePixel = 0
toggleGlow.Parent = flightToggleBG

local toggleGlowCorner = Instance.new("UICorner")
toggleGlowCorner.CornerRadius = UDim.new(1, 0)
toggleGlowCorner.Parent = toggleGlow

local flightToggleBtn = Instance.new("TextButton")
flightToggleBtn.Text = ""
flightToggleBtn.Size = UDim2.new(0, 24, 0, 24)
flightToggleBtn.Position = UDim2.new(0, 3, 0, 3)
flightToggleBtn.BackgroundColor3 = Color3.fromRGB(240, 242, 245)
flightToggleBtn.BorderSizePixel = 0
flightToggleBtn.AutoButtonColor = false
flightToggleBtn.Parent = flightToggleBG

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = flightToggleBtn

-- Flight speed slider (hidden initially)
local flightSpeedSlider = Instance.new("Frame")
flightSpeedSlider.Size = UDim2.new(1, -36, 0, 0)
flightSpeedSlider.Position = UDim2.new(0, 18, 0, 75)
flightSpeedSlider.BackgroundTransparency = 1
flightSpeedSlider.ClipsDescendants = true
flightSpeedSlider.Parent = flightContainer

local speedLabel = Instance.new("TextLabel")
speedLabel.Text = "Flight Speed"
speedLabel.Font = Enum.Font.GothamMedium
speedLabel.TextSize = 12
speedLabel.TextColor3 = Color3.fromRGB(200, 210, 230)
speedLabel.BackgroundTransparency = 1
speedLabel.Size = UDim2.new(1, -70, 0, 20)
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = flightSpeedSlider

local speedValue = Instance.new("TextLabel")
speedValue.Text = tostring(flySpeed)
speedValue.Font = Enum.Font.GothamBold
speedValue.TextSize = 13
speedValue.TextColor3 = Color3.fromRGB(100, 150, 255)
speedValue.BackgroundTransparency = 1
speedValue.Size = UDim2.new(0, 60, 0, 20)
speedValue.Position = UDim2.new(1, -60, 0, 0)
speedValue.TextXAlignment = Enum.TextXAlignment.Right
speedValue.Parent = flightSpeedSlider

local sliderBG = Instance.new("Frame")
sliderBG.Size = UDim2.new(1, 0, 0, 5)
sliderBG.Position = UDim2.new(0, 0, 0, 28)
sliderBG.BackgroundColor3 = Color3.fromRGB(30, 35, 48)
sliderBG.BorderSizePixel = 0
sliderBG.Parent = flightSpeedSlider

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(1, 0)
sliderCorner.Parent = sliderBG

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new((flySpeed - 20) / 180, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderBG

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = sliderFill

local fillGlow = Instance.new("Frame")
fillGlow.Size = UDim2.new(1, 0, 1, 0)
fillGlow.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
fillGlow.BackgroundTransparency = 0.5
fillGlow.BorderSizePixel = 0
fillGlow.Parent = sliderFill

local fillGlowCorner = Instance.new("UICorner")
fillGlowCorner.CornerRadius = UDim.new(1, 0)
fillGlowCorner.Parent = fillGlow

local sliderBtn = Instance.new("TextButton")
sliderBtn.Text = ""
sliderBtn.Size = UDim2.new(0, 16, 0, 16)
sliderBtn.Position = UDim2.new((flySpeed - 20) / 180, -8, 0.5, -8)
sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderBtn.BorderSizePixel = 0
sliderBtn.AutoButtonColor = false
sliderBtn.Parent = sliderBG

local sliderBtnCorner = Instance.new("UICorner")
sliderBtnCorner.CornerRadius = UDim.new(1, 0)
sliderBtnCorner.Parent = sliderBtn

local sliderBtnGlow = Instance.new("ImageLabel")
sliderBtnGlow.AnchorPoint = Vector2.new(0.5, 0.5)
sliderBtnGlow.Size = UDim2.new(1, 20, 1, 20)
sliderBtnGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
sliderBtnGlow.BackgroundTransparency = 1
sliderBtnGlow.Image = "rbxassetid://4996891970"
sliderBtnGlow.ImageColor3 = Color3.fromRGB(100, 150, 255)
sliderBtnGlow.ImageTransparency = 0.7
sliderBtnGlow.ScaleType = Enum.ScaleType.Slice
sliderBtnGlow.SliceCenter = Rect.new(128, 128, 128, 128)
sliderBtnGlow.Parent = sliderBtn

-- Slider logic
local dragging = false
table.insert(connections, sliderBtn.MouseButton1Down:Connect(function() dragging = true end))
table.insert(connections, UserInputService.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end))
table.insert(connections, sliderBG.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
end))
table.insert(connections, UserInputService.InputChanged:Connect(function(inp)
	if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
		local mousePos = UserInputService:GetMouseLocation().X
		local sliderPos = sliderBG.AbsolutePosition.X
		local sliderSize = sliderBG.AbsoluteSize.X
		local percent = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
		local value = math.floor(20 + 180 * percent)
		flySpeed = value
		speedValue.Text = tostring(value)
		tween(sliderFill, 0.1, {Size = UDim2.new(percent, 0, 1, 0)}):Play()
		tween(sliderBtn, 0.1, {Position = UDim2.new(percent, -8, 0.5, -8)}):Play()
	end
end))

-- Flight toggle logic
table.insert(connections, flightToggleBtn.MouseButton1Click:Connect(function()
	flyEnabled = not flyEnabled
	if flyEnabled then
		tween(flightToggleBG, 0.3, {BackgroundColor3 = Color3.fromRGB(100, 150, 255)}):Play()
		tween(toggleGlow, 0.3, {BackgroundTransparency = 0.7}):Play()
		tween(flightToggleBtn, 0.3, {Position = UDim2.new(1, -27, 0, 3)}):Play()
		flightStatus.Text = "Active"
		flightStatus.TextColor3 = Color3.fromRGB(100, 255, 150)
		tween(flightContainer, 0.4, {Size = UDim2.new(1, 0, 0, 130)}, Enum.EasingStyle.Back):Play()
		tween(flightSpeedSlider, 0.4, {Size = UDim2.new(1, -36, 0, 45)}, Enum.EasingStyle.Back):Play()
		
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
		tween(flightToggleBG, 0.3, {BackgroundColor3 = Color3.fromRGB(40, 45, 60)}):Play()
		tween(toggleGlow, 0.3, {BackgroundTransparency = 1}):Play()
		tween(flightToggleBtn, 0.3, {Position = UDim2.new(0, 3, 0, 3)}):Play()
		flightStatus.Text = "Inactive"
		flightStatus.TextColor3 = Color3.fromRGB(140, 145, 160)
		tween(flightSpeedSlider, 0.3, {Size = UDim2.new(1, -36, 0, 0)}):Play()
		tween(flightContainer, 0.3, {Size = UDim2.new(1, 0, 0, 75)}):Play()
		
		if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
		if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
		notify("Flight system deactivated")
	end
end))

featureY = featureY + 80

-- Premium feature creator
local function createFeature(name, desc, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 75)
	container.Position = UDim2.new(0, 0, 0, featureY)
	container.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
	container.BackgroundTransparency = 0.4
	container.BorderSizePixel = 0
	container.Parent = contentScroll
	
	featureY = featureY + 80
	contentScroll.CanvasSize = UDim2.new(0, 0, 0, featureY)
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = container
	
	local containerBorder = Instance.new("UIStroke")
	containerBorder.Color = Color3.fromRGB(100, 150, 255)
	containerBorder.Thickness = 1
	containerBorder.Transparency = 0.8
	containerBorder.Parent = container
	
	local containerGlow = Instance.new("Frame")
	containerGlow.Size = UDim2.new(1, 0, 1, 0)
	containerGlow.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
	containerGlow.BackgroundTransparency = 0.97
	containerGlow.BorderSizePixel = 0
	containerGlow.Parent = container
	
	local glowCorner = Instance.new("UICorner")
	glowCorner.CornerRadius = UDim.new(0, 12)
	glowCorner.Parent = containerGlow
	
	table.insert(connections, container.MouseEnter:Connect(function()
		tween(containerBorder, 0.2, {Transparency = 0.4}):Play()
		tween(containerGlow, 0.2, {BackgroundTransparency = 0.94}):Play()
	end))
	
	table.insert(connections, container.MouseLeave:Connect(function()
		tween(containerBorder, 0.2, {Transparency = 0.8}):Play()
		tween(containerGlow, 0.2, {BackgroundTransparency = 0.97}):Play()
	end))
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Text = name
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 15
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Size = UDim2.new(1, -140, 0, 22)
	nameLabel.Position = UDim2.new(0, 18, 0, 14)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = container
	
	local descLabel = Instance.new("TextLabel")
	descLabel.Text = desc
	descLabel.Font = Enum.Font.Gotham
	descLabel.TextSize = 11
	descLabel.TextColor3 = Color3.fromRGB(160, 170, 190)
	descLabel.BackgroundTransparency = 1
	descLabel.Size = UDim2.new(1, -140, 0, 18)
	descLabel.Position = UDim2.new(0, 18, 0, 36)
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.Parent = container
	
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Text = "Inactive"
	statusLabel.Font = Enum.Font.GothamBold
	statusLabel.TextSize = 10
	statusLabel.TextColor3 = Color3.fromRGB(140, 145, 160)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Size = UDim2.new(0, 70, 0, 16)
	statusLabel.Position = UDim2.new(1, -130, 0, 54)
	statusLabel.TextXAlignment = Enum.TextXAlignment.Right
	statusLabel.Parent = container
	
	local toggleBG = Instance.new("Frame")
	toggleBG.Size = UDim2.new(0, 56, 0, 30)
	toggleBG.Position = UDim2.new(1, -70, 0, 22.5)
	toggleBG.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
	toggleBG.BorderSizePixel = 0
	toggleBG.Parent = container
	
	local tCorner = Instance.new("UICorner")
	tCorner.CornerRadius = UDim.new(1, 0)
	tCorner.Parent = toggleBG
	
	local tGlow = Instance.new("Frame")
	tGlow.Size = UDim2.new(1, 0, 1, 0)
	tGlow.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
	tGlow.BackgroundTransparency = 1
	tGlow.BorderSizePixel = 0
	tGlow.Parent = toggleBG
	
	local tGlowCorner = Instance.new("UICorner")
	tGlowCorner.CornerRadius = UDim.new(1, 0)
	tGlowCorner.Parent = tGlow
	
	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Text = ""
	toggleBtn.Size = UDim2.new(0, 24, 0, 24)
	toggleBtn.Position = UDim2.new(0, 3, 0, 3)
	toggleBtn.BackgroundColor3 = Color3.fromRGB(240, 242, 245)
	toggleBtn.BorderSizePixel = 0
	toggleBtn.AutoButtonColor = false
	toggleBtn.Parent = toggleBG
	
	local tBtnCorner = Instance.new("UICorner")
	tBtnCorner.CornerRadius = UDim.new(1, 0)
	tBtnCorner.Parent = toggleBtn
	
	local isOn = false
	
	table.insert(connections, toggleBtn.MouseButton1Click:Connect(function()
		isOn = not isOn
		if isOn then
			tween(toggleBG, 0.3, {BackgroundColor3 = Color3.fromRGB(100, 150, 255)}):Play()
			tween(tGlow, 0.3, {BackgroundTransparency = 0.7}):Play()
			tween(toggleBtn, 0.3, {Position = UDim2.new(1, -27, 0, 3)}):Play()
			statusLabel.Text = "Active"
			statusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
		else
			tween(toggleBG, 0.3, {BackgroundColor3 = Color3.fromRGB(40, 45, 60)}):Play()
			tween(tGlow, 0.3, {BackgroundTransparency = 1}):Play()
			tween(toggleBtn, 0.3, {Position = UDim2.new(0, 3, 0, 3)}):Play()
			statusLabel.Text = "Inactive"
			statusLabel.TextColor3 = Color3.fromRGB(140, 145, 160)
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
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local h = p.Character:FindFirstChild("ESPHighlight")
			if enabled and not h then
				h = Instance.new("Highlight")
				h.Name = "ESPHighlight"
				h.FillColor = Color3.fromRGB(100, 150, 255)
				h.OutlineColor = Color3.fromRGB(255, 255, 255)
				h.FillTransparency = 0.6
				h.OutlineTransparency = 0
				h.Parent = p.Character
			elseif not enabled and h then
				h:Destroy()
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
		local cam = workspace.CurrentCamera
		local move = Vector3.new(0, 0, 0)
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector * flySpeed end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector * flySpeed end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector * flySpeed end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector * flySpeed end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, flySpeed, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, flySpeed, 0) end
		bodyVelocity.Velocity = move
		bodyGyro.CFrame = cam.CFrame
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

notify("CHAINIX ELITE loaded")
print("CHAINIX ELITE v3.0: Premium Edition Initialized")
