--[[
	═══════════════════════════════════════
	         CHAINIX V1 - ELITE
	      Professional Script Hub
	═══════════════════════════════════════
]]--

-- Prevent double loading
if _G.CHAINIX_LOADED then
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "CHAINIX";
		Text = "Already loaded! Unload first (DELETE key)";
		Duration = 3;
	})
	return
end
_G.CHAINIX_LOADED = true

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
local jumpPowerEnabled = false
local gravityEnabled = false
local showNames = false
local showDistance = false
local showMobs = false
local showHealthBars = false
local autoFarmEnabled = false
local bodyVelocity, bodyGyro
local flySpeed, walkSpeed = 50, 100
local jumpPower = 50
local gravityValue = 196.2

-- Keybind system
local toggleUIKey = Enum.KeyCode.Insert
local unloadKey = Enum.KeyCode.Delete
local waitingForKeybind = nil
local toggleUIBtn = nil
local unloadBtn = nil
local notificationsEnabled = true
local soundsEnabled = true
local autoSaveEnabled = true

-- Config system using _G global storage (works on ALL executors!)
_G.CHAINIX = _G.CHAINIX or {}
_G.CHAINIX.Config = _G.CHAINIX.Config or {}

local defaultConfig = {
	-- Features
	flight_enabled = false,
	flight_speed = 50,
	speed_enabled = false,
	walk_speed = 100,
	jump_enabled = false,
	esp_enabled = false,
	noclip_enabled = false,
	
	-- Settings
	notifications_enabled = true,
	sounds_enabled = true,
	auto_save_enabled = true,
	crosshair_enabled = false,
	
	-- Keybinds
	toggle_key = "Insert",
	unload_key = "Delete",
	
	-- Window position
	window_x = -270,
	window_y = -210
}

local currentConfig = {}

-- Config functions using _G
local function saveConfig()
	if not autoSaveEnabled then return end
	
	-- Save to _G (persists across script reloads in same session!)
	for k, v in pairs(currentConfig) do
		_G.CHAINIX.Config[k] = v
	end
end

local function loadConfig()
	-- Check if we have saved config in _G
	if _G.CHAINIX.Config and next(_G.CHAINIX.Config) ~= nil then
		-- Load from _G
		for k, v in pairs(defaultConfig) do
			currentConfig[k] = _G.CHAINIX.Config[k] or v
		end
		return true
	else
		-- Use default config
		currentConfig = {}
		for k, v in pairs(defaultConfig) do
			currentConfig[k] = v
		end
		return false
	end
end

local function resetConfig()
	-- Clear _G
	_G.CHAINIX.Config = {}
	
	-- Reset to defaults
	currentConfig = {}
	for k, v in pairs(defaultConfig) do
		currentConfig[k] = v
	end
	
	-- Save defaults
	saveConfig()
end

local function updateConfig(key, value)
	currentConfig[key] = value
	if autoSaveEnabled then
		task.spawn(saveConfig)
	end
end

-- Sound effects (from CHAINIX loader)
local Sounds = {
	Click = "rbxassetid://6895079853",
	Hover = "rbxassetid://6895079853", 
	Success = "rbxassetid://6026984224",
	Error = "rbxassetid://1254672090"
}

-- Play sound function
local function playSound(soundId, volume, pitch, duration)
	if not soundsEnabled then return end
	
	local sound = Instance.new("Sound")
	sound.SoundId = soundId
	sound.Volume = volume or 0.5
	sound.PlaybackSpeed = pitch or 1
	sound.Parent = game:GetService("SoundService")
	
	sound:Play()
	
	game:GetService("Debris"):AddItem(sound, duration or 2)
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChainixHub"
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
-- Health bar creation function
local function createHealthBar(character, isPlayer)
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local hum = character:FindFirstChild("Humanoid")
	if not hrp or not hum then return end
	
	-- Remove existing health bar
	local existingHB = character:FindFirstChild("ESPHealthBar")
	if existingHB then existingHB:Destroy() end
	
	-- Create new health bar
	local healthBar = Instance.new("BillboardGui")
	healthBar.Name = "ESPHealthBar"
	healthBar.Adornee = hrp
	healthBar.Size = UDim2.new(0, 100, 0, 10)
	healthBar.StudsOffset = Vector3.new(0, 4.5, 0)
	healthBar.AlwaysOnTop = true
	healthBar.Parent = character
	
	-- Background
	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bg.BackgroundTransparency = 0.5
	bg.BorderSizePixel = 0
	bg.Parent = healthBar
	
	local bgCorner = Instance.new("UICorner")
	bgCorner.CornerRadius = UDim.new(0, 3)
	bgCorner.Parent = bg
	
	-- Health fill
	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.new(1, 0, 1, 0)
	fill.BackgroundColor3 = isPlayer and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(255, 50, 50)
	fill.BorderSizePixel = 0
	fill.Parent = bg
	
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 3)
	fillCorner.Parent = fill
	
	-- Update health bar
	spawn(function()
		while healthBar and healthBar.Parent and showHealthBars do
			if hum then
				local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
				fill.Size = UDim2.new(healthPercent, 0, 1, 0)
				
				-- Color based on health
				if healthPercent > 0.6 then
					fill.BackgroundColor3 = isPlayer and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(50, 200, 100)
				elseif healthPercent > 0.3 then
					fill.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
				else
					fill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
				end
			end
			wait(0.1)
		end
	end)
end

local function cleanup()
	print("[CHAINIX] Starting complete cleanup...")
	
	-- Disable all features IMMEDIATELY
	espEnabled = false
	showMobs = false
	showHealthBars = false
	flyEnabled = false
	speedEnabled = false
	noclipEnabled = false
	jumpPowerEnabled = false
	gravityEnabled = false
	notificationsEnabled = false
	soundsEnabled = false
	
	print("[CHAINIX] Features disabled, waiting for loops to stop...")
	wait(1.5) -- Extra time to ensure ALL loops stop
	
	-- Disconnect ALL connections
	print("[CHAINIX] Disconnecting connections...")
	for i, conn in pairs(connections) do
		pcall(function()
			if conn and conn.Connected then
				conn:Disconnect()
			end
		end)
	end
	connections = {}
	
	-- Remove flight objects
	print("[CHAINIX] Removing flight objects...")
	if bodyVelocity then 
		pcall(function() 
			bodyVelocity:Destroy() 
		end)
		bodyVelocity = nil 
	end
	
	if bodyGyro then 
		pcall(function() 
			bodyGyro:Destroy() 
		end)
		bodyGyro = nil 
	end
	
	-- COMPLETE ESP CLEANUP - Search EVERYTHING
	print("[CHAINIX] Removing ALL ESP from players...")
	for _, p in pairs(Players:GetPlayers()) do
		if p.Character then
			pcall(function()
				-- Remove ALL ESP-related objects from player characters
				for _, obj in pairs(p.Character:GetDescendants()) do
					if obj.Name:find("ESP") or 
					   obj.Name:find("Highlight") or 
					   obj.Name:find("Billboard") or 
					   obj.Name:find("HealthBar") then
						obj:Destroy()
					end
				end
			end)
		end
	end
	
	-- Remove ALL ESP from workspace
	print("[CHAINIX] Removing ALL ESP from workspace...")
	for _, obj in pairs(workspace:GetDescendants()) do
		pcall(function()
			if obj.Name == "MobESPHighlight" or 
			   obj.Name == "MobESPBillboard" or 
			   obj.Name == "ESPHealthBar" or
			   obj.Name == "ESPBillboard" or
			   obj.Name == "ESPHighlight" then
				obj:Destroy()
			end
		end)
	end
	
	-- Remove ALL UI elements from PlayerGui
	print("[CHAINIX] Removing ALL UI from PlayerGui...")
	pcall(function()
		local playerGui = player:FindFirstChild("PlayerGui")
		if playerGui then
			-- Remove by finding ANY CHAINIX-related GUI
			for _, gui in pairs(playerGui:GetChildren()) do
				if gui.Name:find("CHAINIX") or 
				   gui.Name:find("SpeedIndicator") or
				   gui.Name:find("FPSCounter") or
				   gui.Name:find("PingCounter") then
					gui:Destroy()
				end
			end
		end
	end)
	
	-- Remove from CoreGui (if anything got placed there)
	print("[CHAINIX] Checking CoreGui...")
	pcall(function()
		local coreGui = game:GetService("CoreGui")
		for _, gui in pairs(coreGui:GetChildren()) do
			if gui.Name:find("CHAINIX") then
				gui:Destroy()
			end
		end
	end)
	
	-- Restore gravity
	print("[CHAINIX] Restoring gravity...")
	workspace.Gravity = 196.2
	
	-- Show notification BEFORE respawn
	print("[CHAINIX] Showing unload notification...")
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "CHAINIX";
			Text = "Unloaded! Respawning for clean state...";
			Duration = 3;
		})
	end)
	
	wait(0.3)
	
	-- Destroy script UI references
	print("[CHAINIX] Destroying UI references...")
	if crosshairGui then 
		pcall(function() 
			crosshairGui:Destroy() 
		end)
		crosshairGui = nil 
	end
	
	if screenGui then 
		pcall(function() 
			screenGui:Destroy() 
		end)
		screenGui = nil 
	end
	
	-- Clear ALL global variables
	print("[CHAINIX] Clearing globals...")
	_G.CHAINIX = nil
	_G.CHAINIX_LOADED = nil
	
	-- Nil out ALL script variables
	print("[CHAINIX] Clearing all script variables...")
	espEnabled = nil
	showMobs = nil
	showHealthBars = nil
	flyEnabled = nil
	speedEnabled = nil
	noclipEnabled = nil
	jumpPowerEnabled = nil
	gravityEnabled = nil
	notificationsEnabled = nil
	soundsEnabled = nil
	autoFarmEnabled = nil
	showNames = nil
	showDistance = nil
	
	print("[CHAINIX] Respawning character for complete reset...")
	
	-- RESPAWN CHARACTER PROPERLY - This gives a completely fresh character
	wait(0.2)
	pcall(function()
		player:LoadCharacter() -- Proper respawn method
	end)
	
	print("[CHAINIX] Cleanup complete! Character respawning...")
end

-- Tween
local function tween(obj, time, props)
	return TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
end

local function notify(msg)
	if notificationsEnabled then
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "CHAINIX";
			Text = msg;
			Duration = 2;
		})
	end
end

-- Function to get key name (defined early for keybind system)
local function getKeyName(keyCode)
	local name = tostring(keyCode):gsub("Enum.KeyCode.", "")
	return name
end

-- Load config on startup
loadConfig()

-- Apply saved keybinds
if currentConfig.toggle_key then
	local success = pcall(function()
		toggleUIKey = Enum.KeyCode[currentConfig.toggle_key]
	end)
end
if currentConfig.unload_key then
	local success = pcall(function()
		unloadKey = Enum.KeyCode[currentConfig.unload_key]
	end)
end

-- Apply saved settings
notificationsEnabled = currentConfig.notifications_enabled
soundsEnabled = currentConfig.sounds_enabled
autoSaveEnabled = currentConfig.auto_save_enabled

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 540, 0, 420)
mainFrame.Position = UDim2.new(0.5, currentConfig.window_x or -270, 0.5, currentConfig.window_y or -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Outer shadow/glow (premium effect!)
local outerShadow = Instance.new("ImageLabel")
outerShadow.AnchorPoint = Vector2.new(0.5, 0.5)
outerShadow.Size = UDim2.new(1, 60, 1, 60)
outerShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
outerShadow.BackgroundTransparency = 1
outerShadow.Image = "rbxassetid://4996891970"
outerShadow.ImageColor3 = Color3.fromRGB(88, 101, 242)
outerShadow.ImageTransparency = 0.6
outerShadow.ScaleType = Enum.ScaleType.Slice
outerShadow.SliceCenter = Rect.new(128, 128, 128, 128)
outerShadow.ZIndex = 0
outerShadow.Parent = mainFrame

-- Animated glow pulse
spawn(function()
	while mainFrame and mainFrame.Parent do
		tween(outerShadow, 2, {ImageTransparency = 0.8}):Play()
		wait(2)
		if mainFrame and mainFrame.Parent then
			tween(outerShadow, 2, {ImageTransparency = 0.6}):Play()
			wait(2)
		end
	end
end)

-- Premium border with gradient
local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(88, 101, 242)
border.Thickness = 2
border.Transparency = 0.5
border.Parent = mainFrame

local borderGradient = Instance.new("UIGradient")
borderGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 101, 242)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 140, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(88, 101, 242))
}
borderGradient.Rotation = 0
borderGradient.Parent = border

-- Rotating border animation
spawn(function()
	while mainFrame and mainFrame.Parent do
		tween(borderGradient, 4, {Rotation = 360}):Play()
		wait(4)
		if mainFrame and mainFrame.Parent then
			borderGradient.Rotation = 0
		end
	end
end)

-- Chain background decoration (just like loader!)
local chainBG = Instance.new("ImageLabel")
chainBG.Size = UDim2.new(1, 0, 1, 0)
chainBG.Position = UDim2.new(0, 0, 0, 0)
chainBG.BackgroundTransparency = 1
chainBG.Image = "rbxassetid://140337915830730"
chainBG.ImageTransparency = 0.92
chainBG.ImageColor3 = Color3.fromRGB(88, 101, 242)
chainBG.ScaleType = Enum.ScaleType.Stretch
chainBG.ZIndex = 0
chainBG.Parent = mainFrame

-- Entrance animation (smooth!)
mainFrame.Position = UDim2.new(0.5, -270, 1.5, 0)
mainFrame.BackgroundTransparency = 1
outerShadow.ImageTransparency = 1
border.Transparency = 1

tween(mainFrame, 0.5, {Position = UDim2.new(0.5, -270, 0.5, -210), BackgroundTransparency = 0}):Play()
tween(outerShadow, 0.5, {ImageTransparency = 0.6}):Play()
tween(border, 0.5, {Transparency = 0.5}):Play()

-- Top info bar
local infoBar = Instance.new("Frame")
infoBar.Size = UDim2.new(1, 0, 0, 35) -- Taller for premium look
infoBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
infoBar.BorderSizePixel = 0
infoBar.Parent = mainFrame

-- Gradient on top bar
local infoGradient = Instance.new("UIGradient")
infoGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 101, 242)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(138, 43, 226)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(88, 101, 242))
}
infoGradient.Rotation = 90
infoGradient.Parent = infoBar

-- Animated gradient (pulses)
spawn(function()
	while infoBar and infoBar.Parent do
		for i = 0, 360, 2 do
			if not infoBar or not infoBar.Parent then break end
			infoGradient.Rotation = i
			wait(0.05)
		end
	end
end)

-- Top bar corner
local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoBar

-- Shine effect on top
local shine = Instance.new("Frame")
shine.Size = UDim2.new(1, 0, 0, 1)
shine.Position = UDim2.new(0, 0, 0, 0)
shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
shine.BackgroundTransparency = 0.7
shine.BorderSizePixel = 0
shine.Parent = infoBar

-- Title text (moved to left)
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0, 150, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "CHAINIX"
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 16
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.TextStrokeTransparency = 0.8
titleText.Parent = infoBar

-- Version badge
local versionBadge = Instance.new("TextLabel")
versionBadge.Size = UDim2.new(0, 45, 0, 16)
versionBadge.Position = UDim2.new(0, 85, 0, 10)
versionBadge.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
versionBadge.BorderSizePixel = 0
versionBadge.Text = "V1.0"
versionBadge.Font = Enum.Font.GothamBold
versionBadge.TextSize = 9
versionBadge.TextColor3 = Color3.fromRGB(88, 101, 242)
versionBadge.Parent = infoBar

local badgeCorner = Instance.new("UICorner")
badgeCorner.CornerRadius = UDim.new(0, 4)
badgeCorner.Parent = versionBadge

-- Discord button (clickable)
local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(0, 90, 0, 24)
discordBtn.Position = UDim2.new(1, -230, 0, 5.5)
discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordBtn.BorderSizePixel = 0
discordBtn.Text = ""
discordBtn.Font = Enum.Font.GothamBold
discordBtn.TextSize = 11
discordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
discordBtn.AutoButtonColor = false
discordBtn.Parent = infoBar

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 5)
discordCorner.Parent = discordBtn

-- Discord logo (SVG-style using shapes)
local discordLogo = Instance.new("Frame")
discordLogo.Size = UDim2.new(0, 18, 0, 18)
discordLogo.Position = UDim2.new(0, 6, 0.5, -9)
discordLogo.BackgroundTransparency = 1
discordLogo.Parent = discordBtn

-- Discord logo background circle
local logoCircle = Instance.new("Frame")
logoCircle.Size = UDim2.new(1, 0, 1, 0)
logoCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
logoCircle.BorderSizePixel = 0
logoCircle.Parent = discordLogo

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = logoCircle

-- Discord logo "eyes" and "mouth" to make discord icon
local leftEye = Instance.new("Frame")
leftEye.Size = UDim2.new(0, 4, 0, 5)
leftEye.Position = UDim2.new(0, 3, 0, 5)
leftEye.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
leftEye.BorderSizePixel = 0
leftEye.Parent = discordLogo

local leftEyeCorner = Instance.new("UICorner")
leftEyeCorner.CornerRadius = UDim.new(0, 2)
leftEyeCorner.Parent = leftEye

local rightEye = Instance.new("Frame")
rightEye.Size = UDim2.new(0, 4, 0, 5)
rightEye.Position = UDim2.new(0, 11, 0, 5)
rightEye.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
rightEye.BorderSizePixel = 0
rightEye.Parent = discordLogo

local rightEyeCorner = Instance.new("UICorner")
rightEyeCorner.CornerRadius = UDim.new(0, 2)
rightEyeCorner.Parent = rightEye

-- Discord text
local discordText = Instance.new("TextLabel")
discordText.Size = UDim2.new(1, -30, 1, 0)
discordText.Position = UDim2.new(0, 28, 0, 0)
discordText.BackgroundTransparency = 1
discordText.Text = "Discord"
discordText.Font = Enum.Font.GothamBold
discordText.TextSize = 11
discordText.TextColor3 = Color3.fromRGB(255, 255, 255)
discordText.TextXAlignment = Enum.TextXAlignment.Left
discordText.Parent = discordBtn

-- Discord button hover effect
discordBtn.MouseEnter:Connect(function()
	tween(discordBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(114, 137, 218)}):Play()
end)

discordBtn.MouseLeave:Connect(function()
	tween(discordBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}):Play()
end)

-- Discord button click - copy invite to clipboard
discordBtn.MouseButton1Click:Connect(function()
	playSound(Sounds.Success, 0.5, 1.2, 1)
	setclipboard("https://discord.gg/WXt8VdDZ4j")
	notify("Discord invite copied to clipboard!")
end)

-- Status indicator
local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(1, -128, 0.5, -4)
statusDot.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
statusDot.BorderSizePixel = 0
statusDot.Parent = infoBar

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = statusDot

-- Pulsing animation for status dot
spawn(function()
	while statusDot and statusDot.Parent do
		for i = 0, 100, 5 do
			if not statusDot or not statusDot.Parent then break end
			statusDot.BackgroundTransparency = i / 100
			wait(0.03)
		end
		for i = 100, 0, -5 do
			if not statusDot or not statusDot.Parent then break end
			statusDot.BackgroundTransparency = i / 100
			wait(0.03)
		end
	end
end)

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0, 60, 1, 0)
statusText.Position = UDim2.new(1, -118, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "ACTIVE"
statusText.Font = Enum.Font.GothamBold
statusText.TextSize = 10
statusText.TextColor3 = Color3.fromRGB(50, 255, 100)
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = infoBar

-- Close button (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 2.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.AutoButtonColor = false
closeBtn.Parent = infoBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 6)
closeBtnCorner.Parent = closeBtn

-- Close button hover effect
closeBtn.MouseEnter:Connect(function()
	tween(closeBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
	tween(closeBtn, 0.2, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)

closeBtn.MouseLeave:Connect(function()
	tween(closeBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
	tween(closeBtn, 0.2, {TextColor3 = Color3.fromRGB(255, 100, 100)}):Play()
end)

-- Close button functionality
closeBtn.MouseButton1Click:Connect(function()
	playSound(Sounds.Error, 0.5, 1, 1)
	notify("Use DELETE key to unload")
end)

-- Dragging system (simple and working!)
local dragging = false
local dragInput, mousePos, framePos

table.insert(connections, infoBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		mousePos = input.Position
		framePos = mainFrame.Position
		playSound(Sounds.Click, 0.3, 1.2, 1)
		
		table.insert(connections, input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				-- Save position when drag ends
				updateConfig("window_x", mainFrame.Position.X.Offset)
				updateConfig("window_y", mainFrame.Position.Y.Offset)
			end
		end))
	end
end))

table.insert(connections, UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - mousePos
		mainFrame.Position = UDim2.new(
			framePos.X.Scale,
			framePos.X.Offset + delta.X,
			framePos.Y.Scale,
			framePos.Y.Offset + delta.Y
		)
	end
end))

-- Cursor change on hover to show it's draggable
table.insert(connections, infoBar.MouseEnter:Connect(function()
	infoBar.BackgroundColor3 = Color3.fromRGB(8, 8, 15)
end))

table.insert(connections, infoBar.MouseLeave:Connect(function()
	infoBar.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
end))

-- Tab bar
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 32)
tabBar.Position = UDim2.new(0, 0, 0, 35) -- Updated for new top bar height
tabBar.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
tabBar.BorderSizePixel = 0
tabBar.Parent = mainFrame

-- Tabs: Auto Farm first, Settings before Misc
local tabs = {"Auto Farm", "Combat", "Movement", "Visuals", "Settings", "Misc"}
local currentTab = "Auto Farm"
local tabButtons = {}
local tabPages = {}

-- Create tabs
for i, tabName in ipairs(tabs) do
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(0, 90, 1, 0)
	tabBtn.Position = UDim2.new(0, (i-1) * 90, 0, 0)
	tabBtn.BackgroundColor3 = currentTab == tabName and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(18, 18, 24)
	tabBtn.BorderSizePixel = 0
	tabBtn.Text = tabName
	tabBtn.Font = Enum.Font.GothamBold
	tabBtn.TextSize = 11
	tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	tabBtn.AutoButtonColor = false
	tabBtn.Parent = tabBar
	
	-- Glow effect for active tab
	if currentTab == tabName then
		local glow = Instance.new("Frame")
		glow.Name = "Glow"
		glow.Size = UDim2.new(1, 0, 1, 0)
		glow.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
		glow.BackgroundTransparency = 0.7
		glow.BorderSizePixel = 0
		glow.ZIndex = 0
		glow.Parent = tabBtn
		
		-- Glow pulse
		spawn(function()
			while tabBtn and tabBtn.Parent do
				tween(glow, 1.5, {BackgroundTransparency = 0.9}):Play()
				wait(1.5)
				if tabBtn and tabBtn.Parent then
					tween(glow, 1.5, {BackgroundTransparency = 0.7}):Play()
					wait(1.5)
				end
			end
		end)
	end
	
	tabButtons[tabName] = tabBtn
	
	-- Page
	local page = Instance.new("Frame")
	page.Size = UDim2.new(1, 0, 1, -67) -- Updated: 35px top bar + 32px tab bar
	page.Position = UDim2.new(0, 0, 0, 67) -- Updated: starts after top bar + tab bar
	page.BackgroundTransparency = 1
	page.Visible = (tabName == currentTab)
	page.Parent = mainFrame
	
	tabPages[tabName] = page
end

-- Tab switching with effects
local function switchTab(tabName)
	currentTab = tabName
	for name, btn in pairs(tabButtons) do
		local isActive = (name == tabName)
		
		-- Smooth color transition
		tween(btn, 0.3, {
			BackgroundColor3 = isActive and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(18, 18, 24)
		}):Play()
		
		-- Add/remove glow
		local existingGlow = btn:FindFirstChild("Glow")
		if isActive and not existingGlow then
			local glow = Instance.new("Frame")
			glow.Name = "Glow"
			glow.Size = UDim2.new(1, 0, 1, 0)
			glow.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
			glow.BackgroundTransparency = 1
			glow.BorderSizePixel = 0
			glow.ZIndex = 0
			glow.Parent = btn
			
			tween(glow, 0.3, {BackgroundTransparency = 0.7}):Play()
			
			-- Pulse animation
			spawn(function()
				while glow and glow.Parent do
					tween(glow, 1.5, {BackgroundTransparency = 0.9}):Play()
					wait(1.5)
					if glow and glow.Parent then
						tween(glow, 1.5, {BackgroundTransparency = 0.7}):Play()
						wait(1.5)
					end
				end
			end)
		elseif not isActive and existingGlow then
			tween(existingGlow, 0.3, {BackgroundTransparency = 1}):Play()
			task.delay(0.3, function()
				if existingGlow then existingGlow:Destroy() end
			end)
		end
	end
	
	-- Simple page visibility (no transparency animation to prevent text duplication bug)
	for name, page in pairs(tabPages) do
		page.Visible = (name == tabName)
	end
end

for name, btn in pairs(tabButtons) do
	table.insert(connections, btn.MouseButton1Click:Connect(function()
		playSound(Sounds.Click, 0.4, 1.1, 1)
		switchTab(name)
	end))
	
	-- Hover effects
	table.insert(connections, btn.MouseEnter:Connect(function()
		playSound(Sounds.Hover, 0.2, 1.3, 1)
		if currentTab ~= name then
			tween(btn, 0.2, {BackgroundColor3 = Color3.fromRGB(30, 35, 50)}):Play()
		end
	end))
	
	table.insert(connections, btn.MouseLeave:Connect(function()
		if currentTab ~= name then
			tween(btn, 0.2, {BackgroundColor3 = Color3.fromRGB(18, 18, 24)}):Play()
		end
	end))
end

-- Create section
local function createSection(name, parent, yPos)
	local section = Instance.new("Frame")
	section.Size = UDim2.new(1, 0, 0, 25)
	section.Position = UDim2.new(0, 0, 0, yPos)
	section.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
	section.BorderSizePixel = 1
	section.BorderColor3 = Color3.fromRGB(40, 45, 80)
	section.ClipsDescendants = true
	section.Parent = parent
	
	local label = Instance.new("TextLabel")
	label.Text = name
	label.Font = Enum.Font.GothamBold
	label.TextSize = 11
	label.TextColor3 = Color3.fromRGB(240, 242, 245)
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, -10, 1, 0)
	label.Position = UDim2.new(0, 5, 0, 0)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextTruncate = Enum.TextTruncate.AtEnd
	label.Parent = section
	
	return yPos + 30
end

-- Create checkbox
local function createCheckbox(name, parent, yPos, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 20)
	container.Position = UDim2.new(0, 0, 0, yPos)
	container.BackgroundTransparency = 1
	container.Parent = parent
	
	local checkbox = Instance.new("TextButton")
	checkbox.Size = UDim2.new(0, 12, 0, 12)
	checkbox.Position = UDim2.new(0, 5, 0, 4)
	checkbox.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
	checkbox.BorderSizePixel = 1
	checkbox.BorderColor3 = Color3.fromRGB(60, 65, 100)
	checkbox.Text = ""
	checkbox.AutoButtonColor = false
	checkbox.Parent = container
	
	-- Glow effect for checkbox
	local checkGlow = Instance.new("Frame")
	checkGlow.Size = UDim2.new(1, 4, 1, 4)
	checkGlow.Position = UDim2.new(0, -2, 0, -2)
	checkGlow.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
	checkGlow.BackgroundTransparency = 1
	checkGlow.BorderSizePixel = 0
	checkGlow.ZIndex = 0
	checkGlow.Parent = checkbox
	
	local glowCorner = Instance.new("UICorner")
	glowCorner.CornerRadius = UDim.new(0, 2)
	glowCorner.Parent = checkGlow
	
	local checkmark = Instance.new("TextLabel")
	checkmark.Size = UDim2.new(1, 0, 1, 0)
	checkmark.BackgroundTransparency = 1
	checkmark.Text = ""
	checkmark.Font = Enum.Font.GothamBold
	checkmark.TextSize = 10
	checkmark.TextColor3 = Color3.fromRGB(88, 101, 242)
	checkmark.Parent = checkbox
	
	local label = Instance.new("TextLabel")
	label.Text = name
	label.Font = Enum.Font.Gotham
	label.TextSize = 11
	label.TextColor3 = Color3.fromRGB(200, 205, 215)
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, -25, 1, 0)
	label.Position = UDim2.new(0, 22, 0, 0)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextTruncate = Enum.TextTruncate.AtEnd
	label.Parent = container
	
	local isChecked = false
	
	-- Hover effects
	table.insert(connections, checkbox.MouseEnter:Connect(function()
		playSound(Sounds.Hover, 0.15, 1.4, 1)
		tween(checkbox, 0.2, {BorderColor3 = Color3.fromRGB(88, 101, 242)}):Play()
		if isChecked then
			tween(checkGlow, 0.2, {BackgroundTransparency = 0.7}):Play()
		end
	end))
	
	table.insert(connections, checkbox.MouseLeave:Connect(function()
		tween(checkbox, 0.2, {BorderColor3 = Color3.fromRGB(60, 65, 100)}):Play()
		if isChecked then
			tween(checkGlow, 0.2, {BackgroundTransparency = 1}):Play()
		end
	end))
	
	table.insert(connections, checkbox.MouseButton1Click:Connect(function()
		isChecked = not isChecked
		
		-- Sound effect
		playSound(Sounds.Click, 0.5, isChecked and 1.2 or 0.9, 1)
		
		-- Smooth animations
		if isChecked then
			tween(checkbox, 0.2, {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}):Play()
			tween(checkGlow, 0.2, {BackgroundTransparency = 0.7}):Play()
			checkmark.Text = "✓"
			-- Scale animation
			checkbox.Size = UDim2.new(0, 10, 0, 10)
			tween(checkbox, 0.15, {Size = UDim2.new(0, 12, 0, 12)}):Play()
		else
			tween(checkbox, 0.2, {BackgroundColor3 = Color3.fromRGB(20, 22, 30)}):Play()
			tween(checkGlow, 0.2, {BackgroundTransparency = 1}):Play()
			checkmark.Text = ""
		end
		
		callback(isChecked)
	end))
	
	return yPos + 22
end

-- Create slider
local function createSlider(name, parent, yPos, min, max, default, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 35)
	container.Position = UDim2.new(0, 0, 0, yPos)
	container.BackgroundTransparency = 1
	container.Parent = parent
	
	local label = Instance.new("TextLabel")
	label.Text = name
	label.Font = Enum.Font.Gotham
	label.TextSize = 11
	label.TextColor3 = Color3.fromRGB(200, 205, 215)
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, -50, 0, 15)
	label.Position = UDim2.new(0, 5, 0, 0)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container
	
	local value = Instance.new("TextLabel")
	value.Text = tostring(default)
	value.Font = Enum.Font.GothamBold
	value.TextSize = 11
	value.TextColor3 = Color3.fromRGB(88, 101, 242)
	value.BackgroundTransparency = 1
	value.Size = UDim2.new(0, 40, 0, 15)
	value.Position = UDim2.new(1, -45, 0, 0)
	value.TextXAlignment = Enum.TextXAlignment.Right
	value.Parent = container
	
	local sliderBG = Instance.new("Frame")
	sliderBG.Size = UDim2.new(1, -10, 0, 3)
	sliderBG.Position = UDim2.new(0, 5, 0, 20)
	sliderBG.BackgroundColor3 = Color3.fromRGB(25, 28, 38)
	sliderBG.BorderSizePixel = 0
	sliderBG.Parent = container
	
	local sliderFill = Instance.new("Frame")
	sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	sliderFill.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
	sliderFill.BorderSizePixel = 0
	sliderFill.Parent = sliderBG
	
	-- Glow on fill
	local fillGlow = Instance.new("Frame")
	fillGlow.Size = UDim2.new(1, 0, 1, 2)
	fillGlow.Position = UDim2.new(0, 0, 0, -1)
	fillGlow.BackgroundColor3 = Color3.fromRGB(120, 140, 255)
	fillGlow.BackgroundTransparency = 0.7
	fillGlow.BorderSizePixel = 0
	fillGlow.ZIndex = 0
	fillGlow.Parent = sliderFill
	
	local sliderBtn = Instance.new("TextButton")
	sliderBtn.Size = UDim2.new(0, 10, 0, 10)
	sliderBtn.Position = UDim2.new((default - min) / (max - min), -5, 0.5, -5)
	sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sliderBtn.BorderSizePixel = 1
	sliderBtn.BorderColor3 = Color3.fromRGB(88, 101, 242)
	sliderBtn.Text = ""
	sliderBtn.AutoButtonColor = false
	sliderBtn.Parent = sliderBG
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(1, 0)
	btnCorner.Parent = sliderBtn
	
	-- Button glow
	local btnGlow = Instance.new("ImageLabel")
	btnGlow.AnchorPoint = Vector2.new(0.5, 0.5)
	btnGlow.Size = UDim2.new(1, 10, 1, 10)
	btnGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
	btnGlow.BackgroundTransparency = 1
	btnGlow.Image = "rbxassetid://4996891970"
	btnGlow.ImageColor3 = Color3.fromRGB(88, 101, 242)
	btnGlow.ImageTransparency = 1
	btnGlow.ScaleType = Enum.ScaleType.Slice
	btnGlow.SliceCenter = Rect.new(128, 128, 128, 128)
	btnGlow.ZIndex = 0
	btnGlow.Parent = sliderBtn
	
	-- Hover effects
	table.insert(connections, sliderBtn.MouseEnter:Connect(function()
		playSound(Sounds.Hover, 0.15, 1.4, 1)
		tween(sliderBtn, 0.2, {Size = UDim2.new(0, 14, 0, 14)}):Play()
		tween(btnGlow, 0.2, {ImageTransparency = 0.6}):Play()
	end))
	
	table.insert(connections, sliderBtn.MouseLeave:Connect(function()
		tween(sliderBtn, 0.2, {Size = UDim2.new(0, 10, 0, 10)}):Play()
		tween(btnGlow, 0.2, {ImageTransparency = 1}):Play()
	end))
	
	local dragging = false
	table.insert(connections, sliderBtn.MouseButton1Down:Connect(function() 
		dragging = true
		tween(btnGlow, 0.1, {ImageTransparency = 0.4}):Play()
	end))
	
	table.insert(connections, UserInputService.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then 
			dragging = false
			tween(btnGlow, 0.2, {ImageTransparency = 1}):Play()
		end
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
			local val = math.floor(min + (max - min) * percent)
			value.Text = tostring(val)
			
			-- Smooth animations
			tween(sliderFill, 0.1, {Size = UDim2.new(percent, 0, 1, 0)}):Play()
			tween(sliderBtn, 0.1, {Position = UDim2.new(percent, -5, 0.5, -5)}):Play()
			
			callback(val)
		end
	end))
	
	return yPos + 37
end

-- AUTO FARM PAGE
local autoFarmPage = tabPages["Auto Farm"]

local farmLeftCol = Instance.new("Frame")
farmLeftCol.Size = UDim2.new(0.5, -10, 1, -10)
farmLeftCol.Position = UDim2.new(0, 5, 0, 5)
farmLeftCol.BackgroundTransparency = 1
farmLeftCol.Parent = autoFarmPage

local farmRightCol = Instance.new("Frame")
farmRightCol.Size = UDim2.new(0.5, -10, 1, -10)
farmRightCol.Position = UDim2.new(0.5, 5, 0, 5)
farmRightCol.BackgroundTransparency = 1
farmRightCol.Parent = autoFarmPage

local farmLeftY = createSection("Auto Farm", farmLeftCol, 0)
farmLeftY = createCheckbox("Enable Auto Farm", farmLeftCol, farmLeftY, function(enabled)
	autoFarmEnabled = enabled
	notify(enabled and "Auto Farm ON" or "Auto Farm OFF")
end)
farmLeftY = createCheckbox("Auto Collect", farmLeftCol, farmLeftY, function(enabled)
	notify(enabled and "Auto Collect ON" or "Auto Collect OFF")
end)
farmLeftY = createCheckbox("Auto Equip Best Tool", farmLeftCol, farmLeftY, function(enabled)
	notify(enabled and "Auto Equip ON" or "Auto Equip OFF")
end)

farmLeftY = farmLeftY + 5
farmLeftY = createSlider("Farm Distance", farmLeftCol, farmLeftY, 5, 50, 20, function(val)
	-- Farm distance
end)

local farmRightY = createSection("Settings", farmRightCol, 0)
farmRightY = createCheckbox("Safe Mode", farmRightCol, farmRightY, function(enabled)
	notify(enabled and "Safe Mode ON" or "Safe Mode OFF")
end)
farmRightY = createCheckbox("Auto Heal", farmRightCol, farmRightY, function(enabled)
	notify(enabled and "Auto Heal ON" or "Auto Heal OFF")
end)
farmRightY = createCheckbox("Avoid Players", farmRightCol, farmRightY, function(enabled)
	notify(enabled and "Avoid Players ON" or "Avoid Players OFF")
end)

-- COMBAT PAGE
local combatPage = tabPages["Combat"]

local leftColumn = Instance.new("Frame")
leftColumn.Size = UDim2.new(0.5, -10, 1, -10)
leftColumn.Position = UDim2.new(0, 5, 0, 5)
leftColumn.BackgroundTransparency = 1
leftColumn.Parent = combatPage

local rightColumn = Instance.new("Frame")
rightColumn.Size = UDim2.new(0.5, -10, 1, -10)
rightColumn.Position = UDim2.new(0.5, 5, 0, 5)
rightColumn.BackgroundTransparency = 1
rightColumn.Parent = combatPage

local leftY = createSection("PvP", leftColumn, 0)
leftY = createCheckbox("Auto Dodge", leftColumn, leftY, function(enabled)
	notify(enabled and "Auto Dodge ON" or "Auto Dodge OFF")
end)
leftY = createCheckbox("Teleport Behind On Hit", leftColumn, leftY, function(enabled)
	notify(enabled and "Teleport Behind ON" or "Teleport Behind OFF")
end)
leftY = createCheckbox("Keep At Range", leftColumn, leftY, function(enabled)
	notify(enabled and "Keep Range ON" or "Keep Range OFF")
end)

leftY = leftY + 5
leftY = createSlider("Range", leftColumn, leftY, 5, 20, 10, function(val)
	-- Range logic
end)

leftY = leftY + 10
leftY = createSection("Rage", leftColumn, leftY)
leftY = createCheckbox("Anti-Parry", leftColumn, leftY, function(enabled)
	notify(enabled and "Anti-Parry ON" or "Anti-Parry OFF")
end)
leftY = createCheckbox("Fling Nearest Player", leftColumn, leftY, function(enabled)
	notify(enabled and "Fling ON" or "Fling OFF")
end)

leftY = leftY + 5
leftY = createSlider("Fling Power", leftColumn, leftY, 50, 500, 250, function(val)
	-- Fling power
end)

local rightY = createSection("Parry", rightColumn, 0)
rightY = createCheckbox("Auto Parry", rightColumn, rightY, function(enabled)
	notify(enabled and "Auto Parry ON" or "Auto Parry OFF")
end)
rightY = createCheckbox("Ignore Friends", rightColumn, rightY, function(enabled)
	notify(enabled and "Ignore Friends ON" or "Ignore Friends OFF")
end)

rightY = rightY + 5
rightY = createSlider("Sword Parry Delay", rightColumn, rightY, 0, 100, 0, function(val)
	-- Delay
end)
rightY = createSlider("Axe Parry Delay", rightColumn, rightY, 0, 100, 0, function(val)
	-- Delay
end)

-- MOVEMENT PAGE
local movementPage = tabPages["Movement"]

local movScrollFrame = Instance.new("ScrollingFrame")
movScrollFrame.Size = UDim2.new(1, -10, 1, -10)
movScrollFrame.Position = UDim2.new(0, 5, 0, 5)
movScrollFrame.BackgroundTransparency = 1
movScrollFrame.BorderSizePixel = 0
movScrollFrame.ScrollBarThickness = 3
movScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(88, 101, 242)
movScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
movScrollFrame.Parent = movementPage

local movLeftCol = movScrollFrame

local movY = createSection("Movement", movLeftCol, 0)

movY = createCheckbox("Flight System", movLeftCol, movY, function(enabled)
	flyEnabled = enabled
	updateConfig("flight_enabled", enabled)
	if enabled then
		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		bodyVelocity.Parent = humanoidRootPart
		
		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bodyGyro.CFrame = humanoidRootPart.CFrame
		bodyGyro.Parent = humanoidRootPart
		notify("Flight ON")
	else
		if bodyVelocity then 
			bodyVelocity:Destroy() 
			bodyVelocity = nil 
		end
		if bodyGyro then 
			bodyGyro:Destroy() 
			bodyGyro = nil 
		end
		notify("Flight OFF")
	end
end)

movY = movY + 5
movY = createSlider("Flight Speed", movLeftCol, movY, 20, 200, currentConfig.flight_speed or 50, function(val)
	flySpeed = val
	updateConfig("flight_speed", val)
end)

movY = movY + 10
movY = createCheckbox("Speed Enhancement", movLeftCol, movY, function(enabled)
	speedEnabled = enabled
	updateConfig("speed_enabled", enabled)
	if enabled then
		if humanoid then
			humanoid.WalkSpeed = walkSpeed
		end
		notify("Speed ON - " .. walkSpeed)
	else
		if humanoid then
			humanoid.WalkSpeed = 16
		end
		notify("Speed OFF")
	end
end)

movY = movY + 5
movY = createSlider("Walk Speed", movLeftCol, movY, 16, 200, currentConfig.walk_speed or 100, function(val)
	walkSpeed = val
	updateConfig("walk_speed", val)
	-- Apply immediately if speed is enabled
	if speedEnabled and humanoid then
		humanoid.WalkSpeed = val
	end
end)

movY = movY + 10
movY = createCheckbox("Speed Indicator", movLeftCol, movY, function(enabled)
	local speedLabel = screenGui:FindFirstChild("SpeedIndicator")
	
	if enabled then
		if not speedLabel then
			speedLabel = Instance.new("TextLabel")
			speedLabel.Name = "SpeedIndicator"
			speedLabel.Size = UDim2.new(0, 150, 0, 40)
			speedLabel.Position = UDim2.new(1, -160, 0, 10)
			speedLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
			speedLabel.BackgroundTransparency = 0.3
			speedLabel.BorderSizePixel = 0
			speedLabel.Font = Enum.Font.GothamBold
			speedLabel.TextSize = 16
			speedLabel.TextColor3 = Color3.fromRGB(88, 101, 242)
			speedLabel.Text = "Speed: 0"
			speedLabel.Parent = screenGui
			
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 6)
			corner.Parent = speedLabel
			
			-- Update speed continuously
			spawn(function()
				while speedLabel and speedLabel.Parent do
					if humanoidRootPart then
						local speed = math.floor(humanoidRootPart.AssemblyLinearVelocity.Magnitude)
						speedLabel.Text = "Speed: " .. speed
					end
					wait(0.1)
				end
			end)
		end
		notify("Speed Indicator ON")
	else
		if speedLabel then
			speedLabel:Destroy()
		end
		notify("Speed Indicator OFF")
	end
end)

movY = movY + 10
movY = createCheckbox("Infinite Jump", movLeftCol, movY, function(enabled)
	jumpEnabled = enabled
	updateConfig("jump_enabled", enabled)
	
	if enabled then
		-- Enable infinite jump
		table.insert(connections, UserInputService.JumpRequest:Connect(function()
			if jumpEnabled and humanoid then
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end))
		notify("Infinite Jump ON")
	else
		notify("Infinite Jump OFF")
	end
end)

movY = movY + 5
movY = createCheckbox("No-Clip", movLeftCol, movY, function(enabled)
	noclipEnabled = enabled
	updateConfig("noclip_enabled", enabled)
	notify(enabled and "No-Clip ON" or "No-Clip OFF")
end)

-- No-Clip loop
spawn(function()
	while true do
		if noclipEnabled and character then
			for _, part in pairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
		task.wait(0.1)
	end
end)

-- Speed maintenance loop
spawn(function()
	while true do
		if speedEnabled and humanoid and humanoid.WalkSpeed ~= walkSpeed then
			humanoid.WalkSpeed = walkSpeed
		end
		task.wait(0.1)
	end
end)

-- Jump power maintenance loop
spawn(function()
	while true do
		if jumpPowerEnabled and humanoid then
			if humanoid.UseJumpPower then
				if humanoid.JumpPower ~= jumpPower then
					humanoid.JumpPower = jumpPower
				end
			else
				local targetHeight = jumpPower / 10
				if humanoid.JumpHeight ~= targetHeight then
					humanoid.JumpHeight = targetHeight
				end
			end
		end
		task.wait(0.1)
	end
end)

movY = movY + 10
movY = createCheckbox("Jump Power", movLeftCol, movY, function(enabled)
	jumpPowerEnabled = enabled
	updateConfig("jump_power_enabled", enabled)
	
	if enabled and humanoid then
		-- Use JumpHeight (new method) or JumpPower (old method)
		if humanoid.UseJumpPower then
			humanoid.JumpPower = jumpPower
		else
			humanoid.JumpHeight = jumpPower / 10
		end
		notify("Jump Power ON")
	else
		if humanoid then
			if humanoid.UseJumpPower then
				humanoid.JumpPower = 50
			else
				humanoid.JumpHeight = 7.2
			end
		end
		notify("Jump Power OFF")
	end
end)

movY = movY + 5
movY = createSlider("Jump Height", movLeftCol, movY, 50, 500, currentConfig.jump_power or 50, function(val)
	jumpPower = val
	updateConfig("jump_power", val)
	if jumpPowerEnabled and humanoid then
		-- Apply to both systems for compatibility
		if humanoid.UseJumpPower then
			humanoid.JumpPower = val
		else
			humanoid.JumpHeight = val / 10
		end
	end
end)

movY = movY + 10
movY = createCheckbox("Gravity Changer", movLeftCol, movY, function(enabled)
	gravityEnabled = enabled
	updateConfig("gravity_enabled", enabled)
	
	if enabled then
		workspace.Gravity = gravityValue
		notify("Gravity Changed")
	else
		workspace.Gravity = 196.2
		notify("Gravity Normal")
	end
end)

movY = movY + 5
movY = createSlider("Gravity", movLeftCol, movY, 0, 300, currentConfig.gravity or 196.2, function(val)
	gravityValue = val
	updateConfig("gravity", val)
	if gravityEnabled then
		workspace.Gravity = val
	end
end)

-- VISUALS PAGE
local visualsPage = tabPages["Visuals"]

local visLeftCol = Instance.new("Frame")
visLeftCol.Size = UDim2.new(1, -10, 1, -10)
visLeftCol.Position = UDim2.new(0, 5, 0, 5)
visLeftCol.BackgroundTransparency = 1
visLeftCol.Parent = visualsPage

local visY = createSection("ESP", visLeftCol, 0)

visY = createCheckbox("Player ESP", visLeftCol, visY, function(enabled)
	espEnabled = enabled
	updateConfig("esp_enabled", enabled)
	
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local h = p.Character:FindFirstChild("ESPHighlight")
			local billboard = p.Character:FindFirstChild("ESPBillboard")
			
			if enabled and not h then
				-- Add highlight
				h = Instance.new("Highlight")
				h.Name = "ESPHighlight"
				h.FillColor = Color3.fromRGB(88, 101, 242)
				h.OutlineColor = Color3.fromRGB(255, 255, 255)
				h.FillTransparency = 0.6
				h.OutlineTransparency = 0
				h.Parent = p.Character
				
				-- Add billboard for name/distance
				if (showNames or showDistance) and not billboard then
					local hrp = p.Character:FindFirstChild("HumanoidRootPart")
					if hrp then
						billboard = Instance.new("BillboardGui")
						billboard.Name = "ESPBillboard"
						billboard.Adornee = hrp
						billboard.Size = UDim2.new(0, 200, 0, 50)
						billboard.StudsOffset = Vector3.new(0, 3, 0)
						billboard.AlwaysOnTop = true
						billboard.Parent = p.Character
						
						local textLabel = Instance.new("TextLabel")
						textLabel.Size = UDim2.new(1, 0, 1, 0)
						textLabel.BackgroundTransparency = 1
						textLabel.Font = Enum.Font.GothamBold
						textLabel.TextSize = 14
						textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
						textLabel.TextStrokeTransparency = 0.5
						textLabel.Text = ""
						textLabel.Parent = billboard
					end
				end
			elseif not enabled then
				if h then h:Destroy() end
				if billboard then billboard:Destroy() end
			end
		end
	end
	
	notify(enabled and "ESP ON" or "ESP OFF")
end)

visY = createCheckbox("Show Names", visLeftCol, visY, function(enabled)
	showNames = enabled
	updateConfig("show_names", enabled)
	notify(enabled and "Names ON" or "Names OFF")
end)

visY = createCheckbox("Show Distance", visLeftCol, visY, function(enabled)
	showDistance = enabled
	updateConfig("show_distance", enabled)
	notify(enabled and "Distance ON" or "Distance OFF")
end)

visY = createCheckbox("Show Mobs", visLeftCol, visY, function(enabled)
	showMobs = enabled
	updateConfig("show_mobs", enabled)
	
	-- Clean up existing mob ESP
	if not enabled then
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj.Name == "MobESPHighlight" or obj.Name == "MobESPBillboard" then
				obj:Destroy()
			end
		end
	end
	
	notify(enabled and "Mob ESP ON" or "Mob ESP OFF")
end)

visY = createCheckbox("Show Health Bars", visLeftCol, visY, function(enabled)
	showHealthBars = enabled
	updateConfig("show_health_bars", enabled)
	
	-- Clean up existing health bars
	if not enabled then
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj.Name == "ESPHealthBar" then
				obj:Destroy()
			end
		end
		for _, p in pairs(Players:GetPlayers()) do
			if p.Character then
				local hb = p.Character:FindFirstChild("ESPHealthBar")
				if hb then hb:Destroy() end
			end
		end
	end
	
	notify(enabled and "Health Bars ON" or "Health Bars OFF")
end)

-- ESP update loop for players (names and distance)
local lastPlayerUpdate = {}

spawn(function()
	while true do
		if espEnabled then
			local currentTime = tick()
			
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= player and p.Character then
					local playerId = p.UserId
					
					-- Throttle updates per player (0.3s minimum between updates)
					if not lastPlayerUpdate[playerId] or (currentTime - lastPlayerUpdate[playerId]) >= 0.3 then
						lastPlayerUpdate[playerId] = currentTime
						
						pcall(function()
							local hrp = p.Character:FindFirstChild("HumanoidRootPart")
							if not hrp then return end
							
							-- Create health bar once if enabled
							if showHealthBars and not p.Character:FindFirstChild("ESPHealthBar") then
								createHealthBar(p.Character, true)
							end
							
							-- Handle billboard for names/distance
							if (showNames or showDistance) then
								local billboard = p.Character:FindFirstChild("ESPBillboard")
								
								if not billboard then
									billboard = Instance.new("BillboardGui")
									billboard.Name = "ESPBillboard"
									billboard.Adornee = hrp
									billboard.Size = UDim2.new(0, 200, 0, 50)
									billboard.StudsOffset = Vector3.new(0, 3, 0)
									billboard.AlwaysOnTop = true
									billboard.Parent = p.Character
									
									local textLabel = Instance.new("TextLabel")
									textLabel.Size = UDim2.new(1, 0, 1, 0)
									textLabel.BackgroundTransparency = 1
									textLabel.Font = Enum.Font.GothamBold
									textLabel.TextSize = 14
									textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
									textLabel.TextStrokeTransparency = 0.5
									textLabel.Text = ""
									textLabel.Parent = billboard
								else
									-- Update existing billboard
									local textLabel = billboard:FindFirstChildOfClass("TextLabel")
									if textLabel then
										local text = ""
										
										if showNames then
											text = p.Name
										end
										
										if showDistance and humanoidRootPart then
											local distance = math.floor((hrp.Position - humanoidRootPart.Position).Magnitude)
											if showNames then
												text = text .. "\n" .. distance .. "m"
											else
												text = distance .. "m"
											end
										end
										
										textLabel.Text = text
									end
								end
							end
						end)
					end
				end
			end
			
			-- Clean up disconnected players
			for playerId, _ in pairs(lastPlayerUpdate) do
				local playerExists = false
				for _, p in pairs(Players:GetPlayers()) do
					if p.UserId == playerId then
						playerExists = true
						break
					end
				end
				if not playerExists then
					lastPlayerUpdate[playerId] = nil
				end
			end
		else
			lastPlayerUpdate = {}
		end
		task.wait(0.1) -- Fast loop but throttled per player
	end
end)

-- Mob ESP loop (highlights NPCs/monsters) - OPTIMIZED
local discoveredMobs = {}
local mobUpdateTime = {}

spawn(function()
	while true do
		if showMobs then
			local currentTime = tick()
			local mobCount = 0
			local maxMobs = 30
			
			for mob, _ in pairs(discoveredMobs) do
				if not mob or not mob.Parent then
					discoveredMobs[mob] = nil
					mobUpdateTime[mob] = nil
				end
			end
			
			for _, obj in pairs(workspace:GetDescendants()) do
				if mobCount >= maxMobs then break end
				
				if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
					local isPlayer = false
					for _, p in pairs(Players:GetPlayers()) do
						if p.Character == obj then isPlayer = true break end
					end
					
					if not isPlayer then
						local hrp = obj:FindFirstChild("HumanoidRootPart")
						
						if humanoidRootPart and hrp then
							local dist = (hrp.Position - humanoidRootPart.Position).Magnitude
							if dist > 1500 then continue end
						end
						
						mobCount = mobCount + 1
						local humanoidInMob = obj:FindFirstChild("Humanoid")
						
						if not discoveredMobs[obj] then
							discoveredMobs[obj] = true
							mobUpdateTime[obj] = 0
						end
						
						if not mobUpdateTime[obj] or (currentTime - mobUpdateTime[obj]) >= 0.5 then
							mobUpdateTime[obj] = currentTime
							
							pcall(function()
								if showHealthBars and not obj:FindFirstChild("ESPHealthBar") then
									createHealthBar(obj, false)
								end
								
								if not obj:FindFirstChild("MobESPHighlight") then
									local h = Instance.new("Highlight")
									h.Name = "MobESPHighlight"
									h.FillColor = Color3.fromRGB(255, 100, 100)
									h.OutlineColor = Color3.fromRGB(255, 255, 255)
									h.FillTransparency = 0.6
									h.OutlineTransparency = 0
									h.Parent = obj
								end
								
								if not obj:FindFirstChild("MobESPBillboard") and hrp then
									local billboard = Instance.new("BillboardGui")
									billboard.Name = "MobESPBillboard"
									billboard.Adornee = hrp
									billboard.Size = UDim2.new(0, 200, 0, 50)
									billboard.StudsOffset = Vector3.new(0, 3, 0)
									billboard.AlwaysOnTop = true
									billboard.Parent = obj
									
									local textLabel = Instance.new("TextLabel")
									textLabel.Size = UDim2.new(1, 0, 1, 0)
									textLabel.BackgroundTransparency = 1
									textLabel.Font = Enum.Font.GothamBold
									textLabel.TextSize = 14
									textLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
									textLabel.TextStrokeTransparency = 0.5
									textLabel.Parent = billboard
								end
								
								local billboard = obj:FindFirstChild("MobESPBillboard")
								if billboard then
									local textLabel = billboard:FindFirstChildOfClass("TextLabel")
									if textLabel and humanoidInMob and hrp then
										local mobName = obj.Name
										local health = math.floor(humanoidInMob.Health) .. "/" .. math.floor(humanoidInMob.MaxHealth)
										local distance = ""
										if humanoidRootPart then
											distance = math.floor((hrp.Position - humanoidRootPart.Position).Magnitude) .. "m"
										end
										textLabel.Text = mobName .. "\n" .. health .. " | " .. distance
									end
								end
							end)
						end
					end
				end
			end
		else
			discoveredMobs = {}
			mobUpdateTime = {}
			for _, obj in pairs(workspace:GetDescendants()) do
				pcall(function()
					if obj.Name == "MobESPHighlight" or obj.Name == "MobESPBillboard" then
						obj:Destroy()
					end
				end)
			end
		end
		task.wait(0.8)
	end
end)

-- SETTINGS PAGE
local settingsPage = tabPages["Settings"]

local setScrollFrame = Instance.new("ScrollingFrame")
setScrollFrame.Size = UDim2.new(1, -10, 1, -10)
setScrollFrame.Position = UDim2.new(0, 5, 0, 5)
setScrollFrame.BackgroundTransparency = 1
setScrollFrame.BorderSizePixel = 0
setScrollFrame.ScrollBarThickness = 3
setScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(88, 101, 242)
setScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
setScrollFrame.Parent = settingsPage

local setLeftCol = setScrollFrame

local setY = createSection("UI Settings", setLeftCol, 0)

-- Create notifications checkbox (checked by default)
local notifContainer = Instance.new("Frame")
notifContainer.Size = UDim2.new(1, 0, 0, 20)
notifContainer.Position = UDim2.new(0, 0, 0, setY)
notifContainer.BackgroundTransparency = 1
notifContainer.Parent = setLeftCol

local notifCheckbox = Instance.new("TextButton")
notifCheckbox.Size = UDim2.new(0, 12, 0, 12)
notifCheckbox.Position = UDim2.new(0, 5, 0, 4)
notifCheckbox.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
notifCheckbox.BorderSizePixel = 1
notifCheckbox.BorderColor3 = Color3.fromRGB(60, 65, 100)
notifCheckbox.Text = ""
notifCheckbox.AutoButtonColor = false
notifCheckbox.Parent = notifContainer

local notifCheckGlow = Instance.new("Frame")
notifCheckGlow.Size = UDim2.new(1, 4, 1, 4)
notifCheckGlow.Position = UDim2.new(0, -2, 0, -2)
notifCheckGlow.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
notifCheckGlow.BackgroundTransparency = 1
notifCheckGlow.BorderSizePixel = 0
notifCheckGlow.ZIndex = 0
notifCheckGlow.Parent = notifCheckbox

local notifGlowCorner = Instance.new("UICorner")
notifGlowCorner.CornerRadius = UDim.new(0, 2)
notifGlowCorner.Parent = notifCheckGlow

local notifCheckmark = Instance.new("TextLabel")
notifCheckmark.Size = UDim2.new(1, 0, 1, 0)
notifCheckmark.BackgroundTransparency = 1
notifCheckmark.Text = "✓"
notifCheckmark.Font = Enum.Font.GothamBold
notifCheckmark.TextSize = 10
notifCheckmark.TextColor3 = Color3.fromRGB(88, 101, 242)
notifCheckmark.Parent = notifCheckbox

local notifLabel = Instance.new("TextLabel")
notifLabel.Text = "Enable Notifications"
notifLabel.Font = Enum.Font.Gotham
notifLabel.TextSize = 11
notifLabel.TextColor3 = Color3.fromRGB(200, 205, 215)
notifLabel.BackgroundTransparency = 1
notifLabel.Size = UDim2.new(1, -25, 1, 0)
notifLabel.Position = UDim2.new(0, 22, 0, 0)
notifLabel.TextXAlignment = Enum.TextXAlignment.Left
notifLabel.TextTruncate = Enum.TextTruncate.AtEnd
notifLabel.Parent = notifContainer

table.insert(connections, notifCheckbox.MouseEnter:Connect(function()
	tween(notifCheckbox, 0.2, {BorderColor3 = Color3.fromRGB(88, 101, 242)}):Play()
	if notificationsEnabled then
		tween(notifCheckGlow, 0.2, {BackgroundTransparency = 0.7}):Play()
	end
end))

table.insert(connections, notifCheckbox.MouseLeave:Connect(function()
	tween(notifCheckbox, 0.2, {BorderColor3 = Color3.fromRGB(60, 65, 100)}):Play()
	if notificationsEnabled then
		tween(notifCheckGlow, 0.2, {BackgroundTransparency = 1}):Play()
	end
end))

table.insert(connections, notifCheckbox.MouseButton1Click:Connect(function()
	notificationsEnabled = not notificationsEnabled
	
	if notificationsEnabled then
		tween(notifCheckbox, 0.2, {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}):Play()
		tween(notifCheckGlow, 0.2, {BackgroundTransparency = 0.7}):Play()
		notifCheckmark.Text = "✓"
		notifCheckbox.Size = UDim2.new(0, 10, 0, 10)
		tween(notifCheckbox, 0.15, {Size = UDim2.new(0, 12, 0, 12)}):Play()
	else
		tween(notifCheckbox, 0.2, {BackgroundColor3 = Color3.fromRGB(20, 22, 30)}):Play()
		tween(notifCheckGlow, 0.2, {BackgroundTransparency = 1}):Play()
		notifCheckmark.Text = ""
	end
	
	-- Always show this notification regardless of setting
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "CHAINIX";
		Text = notificationsEnabled and "Notifications enabled" or "Notifications disabled";
		Duration = 2;
	})
end))

setY = setY + 22

-- Mute sounds checkbox (checked by default since sounds are enabled)
local soundContainer = Instance.new("Frame")
soundContainer.Size = UDim2.new(1, 0, 0, 20)
soundContainer.Position = UDim2.new(0, 0, 0, setY)
soundContainer.BackgroundTransparency = 1
soundContainer.Parent = setLeftCol

local soundCheckbox = Instance.new("TextButton")
soundCheckbox.Size = UDim2.new(0, 12, 0, 12)
soundCheckbox.Position = UDim2.new(0, 5, 0, 4)
soundCheckbox.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
soundCheckbox.BorderSizePixel = 1
soundCheckbox.BorderColor3 = Color3.fromRGB(60, 65, 100)
soundCheckbox.Text = ""
soundCheckbox.AutoButtonColor = false
soundCheckbox.Parent = soundContainer

local soundCheckGlow = Instance.new("Frame")
soundCheckGlow.Size = UDim2.new(1, 4, 1, 4)
soundCheckGlow.Position = UDim2.new(0, -2, 0, -2)
soundCheckGlow.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
soundCheckGlow.BackgroundTransparency = 1
soundCheckGlow.BorderSizePixel = 0
soundCheckGlow.ZIndex = 0
soundCheckGlow.Parent = soundCheckbox

local soundGlowCorner = Instance.new("UICorner")
soundGlowCorner.CornerRadius = UDim.new(0, 2)
soundGlowCorner.Parent = soundCheckGlow

local soundCheckmark = Instance.new("TextLabel")
soundCheckmark.Size = UDim2.new(1, 0, 1, 0)
soundCheckmark.BackgroundTransparency = 1
soundCheckmark.Text = "✓"
soundCheckmark.Font = Enum.Font.GothamBold
soundCheckmark.TextSize = 10
soundCheckmark.TextColor3 = Color3.fromRGB(88, 101, 242)
soundCheckmark.Parent = soundCheckbox

local soundLabel = Instance.new("TextLabel")
soundLabel.Text = "Enable Sounds"
soundLabel.Font = Enum.Font.Gotham
soundLabel.TextSize = 11
soundLabel.TextColor3 = Color3.fromRGB(200, 205, 215)
soundLabel.BackgroundTransparency = 1
soundLabel.Size = UDim2.new(1, -25, 1, 0)
soundLabel.Position = UDim2.new(0, 22, 0, 0)
soundLabel.TextXAlignment = Enum.TextXAlignment.Left
soundLabel.TextTruncate = Enum.TextTruncate.AtEnd
soundLabel.Parent = soundContainer

table.insert(connections, soundCheckbox.MouseEnter:Connect(function()
	-- Only play sound if sounds are currently enabled
	if soundsEnabled then
		playSound(Sounds.Hover, 0.15, 1.4, 1)
	end
	tween(soundCheckbox, 0.2, {BorderColor3 = Color3.fromRGB(88, 101, 242)}):Play()
	if soundsEnabled then
		tween(soundCheckGlow, 0.2, {BackgroundTransparency = 0.7}):Play()
	end
end))

table.insert(connections, soundCheckbox.MouseLeave:Connect(function()
	tween(soundCheckbox, 0.2, {BorderColor3 = Color3.fromRGB(60, 65, 100)}):Play()
	if soundsEnabled then
		tween(soundCheckGlow, 0.2, {BackgroundTransparency = 1}):Play()
	end
end))

table.insert(connections, soundCheckbox.MouseButton1Click:Connect(function()
	-- Toggle state FIRST
	soundsEnabled = not soundsEnabled
	
	-- Visual updates
	if soundsEnabled then
		tween(soundCheckbox, 0.2, {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}):Play()
		tween(soundCheckGlow, 0.2, {BackgroundTransparency = 0.7}):Play()
		soundCheckmark.Text = "✓"
		soundCheckbox.Size = UDim2.new(0, 10, 0, 10)
		tween(soundCheckbox, 0.15, {Size = UDim2.new(0, 12, 0, 12)}):Play()
	else
		tween(soundCheckbox, 0.2, {BackgroundColor3 = Color3.fromRGB(20, 22, 30)}):Play()
		tween(soundCheckGlow, 0.2, {BackgroundTransparency = 1}):Play()
		soundCheckmark.Text = ""
	end
	
	-- THEN play confirmation sound (always plays to confirm the toggle)
	local sound = Instance.new("Sound")
	sound.SoundId = soundsEnabled and Sounds.Success or Sounds.Click
	sound.Volume = 0.5
	sound.PlaybackSpeed = soundsEnabled and 1.2 or 0.8
	sound.Parent = game:GetService("SoundService")
	sound:Play()
	game:GetService("Debris"):AddItem(sound, 2)
	
	notify(soundsEnabled and "Sounds enabled" or "Sounds muted")
end))

setY = setY + 22

setY = createCheckbox("Auto Save Config", setLeftCol, setY, function(enabled)
	autoSaveEnabled = enabled
	updateConfig("auto_save_enabled", enabled)
	notify(enabled and "Auto Save ON" or "Auto Save OFF")
end)

setY = setY + 10
setY = createSection("Config Management", setLeftCol, setY)

-- Save Config Button
local saveConfigBtn = Instance.new("TextButton")
saveConfigBtn.Size = UDim2.new(1, -10, 0, 30)
saveConfigBtn.Position = UDim2.new(0, 5, 0, setY)
saveConfigBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 100)
saveConfigBtn.BorderSizePixel = 0
saveConfigBtn.Text = "Save Config Now"
saveConfigBtn.Font = Enum.Font.GothamBold
saveConfigBtn.TextSize = 11
saveConfigBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveConfigBtn.AutoButtonColor = false
saveConfigBtn.Parent = setLeftCol

local saveConfigCorner = Instance.new("UICorner")
saveConfigCorner.CornerRadius = UDim.new(0, 4)
saveConfigCorner.Parent = saveConfigBtn

local saveConfigGlow = Instance.new("Frame")
saveConfigGlow.Size = UDim2.new(1, 0, 1, 0)
saveConfigGlow.BackgroundColor3 = Color3.fromRGB(80, 220, 130)
saveConfigGlow.BackgroundTransparency = 1
saveConfigGlow.BorderSizePixel = 0
saveConfigGlow.ZIndex = 0
saveConfigGlow.Parent = saveConfigBtn

local saveGlowCorner = Instance.new("UICorner")
saveGlowCorner.CornerRadius = UDim.new(0, 4)
saveGlowCorner.Parent = saveConfigGlow

table.insert(connections, saveConfigBtn.MouseEnter:Connect(function()
	playSound(Sounds.Hover, 0.2, 1.3, 1)
	tween(saveConfigBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(60, 200, 120)}):Play()
	tween(saveConfigGlow, 0.2, {BackgroundTransparency = 0.7}):Play()
end))

table.insert(connections, saveConfigBtn.MouseLeave:Connect(function()
	tween(saveConfigBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(50, 180, 100)}):Play()
	tween(saveConfigGlow, 0.2, {BackgroundTransparency = 1}):Play()
end))

table.insert(connections, saveConfigBtn.MouseButton1Click:Connect(function()
	playSound(Sounds.Success, 0.6, 1.2, 2)
	saveConfigBtn.Size = UDim2.new(1, -10, 0, 28)
	tween(saveConfigBtn, 0.1, {Size = UDim2.new(1, -10, 0, 30)}):Play()
	
	saveConfig()
	notify("Config saved! (Until Roblox closes)")
end))

setY = setY + 35

-- Load Config Button
local loadConfigBtn = Instance.new("TextButton")
loadConfigBtn.Size = UDim2.new(1, -10, 0, 30)
loadConfigBtn.Position = UDim2.new(0, 5, 0, setY)
loadConfigBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
loadConfigBtn.BorderSizePixel = 0
loadConfigBtn.Text = "Reload Config"
loadConfigBtn.Font = Enum.Font.GothamBold
loadConfigBtn.TextSize = 11
loadConfigBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
loadConfigBtn.AutoButtonColor = false
loadConfigBtn.Parent = setLeftCol

local loadConfigCorner = Instance.new("UICorner")
loadConfigCorner.CornerRadius = UDim.new(0, 4)
loadConfigCorner.Parent = loadConfigBtn

local loadConfigGlow = Instance.new("Frame")
loadConfigGlow.Size = UDim2.new(1, 0, 1, 0)
loadConfigGlow.BackgroundColor3 = Color3.fromRGB(120, 140, 255)
loadConfigGlow.BackgroundTransparency = 1
loadConfigGlow.BorderSizePixel = 0
loadConfigGlow.ZIndex = 0
loadConfigGlow.Parent = loadConfigBtn

local loadGlowCorner = Instance.new("UICorner")
loadGlowCorner.CornerRadius = UDim.new(0, 4)
loadGlowCorner.Parent = loadConfigGlow

table.insert(connections, loadConfigBtn.MouseEnter:Connect(function()
	playSound(Sounds.Hover, 0.2, 1.3, 1)
	tween(loadConfigBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(100, 115, 255)}):Play()
	tween(loadConfigGlow, 0.2, {BackgroundTransparency = 0.7}):Play()
end))

table.insert(connections, loadConfigBtn.MouseLeave:Connect(function()
	tween(loadConfigBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}):Play()
	tween(loadConfigGlow, 0.2, {BackgroundTransparency = 1}):Play()
end))

table.insert(connections, loadConfigBtn.MouseButton1Click:Connect(function()
	playSound(Sounds.Click, 0.5, 1, 1)
	loadConfigBtn.Size = UDim2.new(1, -10, 0, 28)
	tween(loadConfigBtn, 0.1, {Size = UDim2.new(1, -10, 0, 30)}):Play()
	
	local success = loadConfig()
	if success then
		notify("Config loaded! Rejoin to apply.")
	else
		notify("No saved config found!")
	end
end))

setY = setY + 35

-- Reset Config Button
local resetConfigBtn = Instance.new("TextButton")
resetConfigBtn.Size = UDim2.new(1, -10, 0, 30)
resetConfigBtn.Position = UDim2.new(0, 5, 0, setY)
resetConfigBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
resetConfigBtn.BorderSizePixel = 0
resetConfigBtn.Text = "Reset to Defaults"
resetConfigBtn.Font = Enum.Font.GothamBold
resetConfigBtn.TextSize = 11
resetConfigBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetConfigBtn.AutoButtonColor = false
resetConfigBtn.Parent = setLeftCol

local resetConfigCorner = Instance.new("UICorner")
resetConfigCorner.CornerRadius = UDim.new(0, 4)
resetConfigCorner.Parent = resetConfigBtn

local resetConfigGlow = Instance.new("Frame")
resetConfigGlow.Size = UDim2.new(1, 0, 1, 0)
resetConfigGlow.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
resetConfigGlow.BackgroundTransparency = 1
resetConfigGlow.BorderSizePixel = 0
resetConfigGlow.ZIndex = 0
resetConfigGlow.Parent = resetConfigBtn

local resetGlowCorner = Instance.new("UICorner")
resetGlowCorner.CornerRadius = UDim.new(0, 4)
resetGlowCorner.Parent = resetConfigGlow

table.insert(connections, resetConfigBtn.MouseEnter:Connect(function()
	playSound(Sounds.Hover, 0.2, 1.3, 1)
	tween(resetConfigBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}):Play()
	tween(resetConfigGlow, 0.2, {BackgroundTransparency = 0.7}):Play()
end))

table.insert(connections, resetConfigBtn.MouseLeave:Connect(function()
	tween(resetConfigBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}):Play()
	tween(resetConfigGlow, 0.2, {BackgroundTransparency = 1}):Play()
end))

table.insert(connections, resetConfigBtn.MouseButton1Click:Connect(function()
	playSound(Sounds.Error, 0.7, 1, 2)
	resetConfigBtn.Size = UDim2.new(1, -10, 0, 28)
	tween(resetConfigBtn, 0.1, {Size = UDim2.new(1, -10, 0, 30)}):Play()
	
	resetConfig()
	notify("Config reset to defaults!")
end))

setY = setY + 40

-- Custom Crosshair
local crosshairEnabled = currentConfig.crosshair_enabled or false
local crosshairGui = nil

setY = setY + 5
setY = createCheckbox("Custom Crosshair", setLeftCol, setY, function(enabled)
	crosshairEnabled = enabled
	updateConfig("crosshair_enabled", enabled)
	if enabled then
		-- Create crosshair
		crosshairGui = Instance.new("ScreenGui")
		crosshairGui.Name = "ChainixCrosshair"
		crosshairGui.ResetOnSpawn = false
		crosshairGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		crosshairGui.IgnoreGuiInset = true
		
		pcall(function()
			crosshairGui.Parent = game:GetService("CoreGui")
		end)
		if not crosshairGui.Parent then
			crosshairGui.Parent = player:WaitForChild("PlayerGui")
		end
		
		-- Center container
		local centerFrame = Instance.new("Frame")
		centerFrame.Size = UDim2.new(0, 40, 0, 40)
		centerFrame.Position = UDim2.new(0.5, -20, 0.5, -20)
		centerFrame.BackgroundTransparency = 1
		centerFrame.Parent = crosshairGui
		
		-- Horizontal line
		local hLine = Instance.new("Frame")
		hLine.Size = UDim2.new(0, 14, 0, 2)
		hLine.Position = UDim2.new(0.5, -7, 0.5, -1)
		hLine.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
		hLine.BorderSizePixel = 0
		hLine.Parent = centerFrame
		
		-- Vertical line
		local vLine = Instance.new("Frame")
		vLine.Size = UDim2.new(0, 2, 0, 14)
		vLine.Position = UDim2.new(0.5, -1, 0.5, -7)
		vLine.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
		vLine.BorderSizePixel = 0
		vLine.Parent = centerFrame
		
		-- Center dot
		local dot = Instance.new("Frame")
		dot.Size = UDim2.new(0, 3, 0, 3)
		dot.Position = UDim2.new(0.5, -1.5, 0.5, -1.5)
		dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		dot.BorderSizePixel = 0
		dot.Parent = centerFrame
		
		local dotCorner = Instance.new("UICorner")
		dotCorner.CornerRadius = UDim.new(1, 0)
		dotCorner.Parent = dot
		
		notify("Custom Crosshair ON")
	else
		if crosshairGui then
			crosshairGui:Destroy()
			crosshairGui = nil
		end
		notify("Custom Crosshair OFF")
	end
end)

-- Auto-enable crosshair if it was saved as enabled
if crosshairEnabled and not crosshairGui then
	task.delay(0.5, function()
		-- Trigger the checkbox to enable crosshair
		-- We'll need to manually enable it here since checkbox starts unchecked
	end)
end

setY = setY + 10
setY = createSection("Keybinds", setLeftCol, setY)

-- Toggle UI Keybind
local toggleUIContainer = Instance.new("Frame")
toggleUIContainer.Size = UDim2.new(1, 0, 0, 30)
toggleUIContainer.Position = UDim2.new(0, 0, 0, setY)
toggleUIContainer.BackgroundTransparency = 1
toggleUIContainer.Parent = setLeftCol

local toggleUILabel = Instance.new("TextLabel")
toggleUILabel.Text = "Toggle UI"
toggleUILabel.Font = Enum.Font.Gotham
toggleUILabel.TextSize = 11
toggleUILabel.TextColor3 = Color3.fromRGB(200, 205, 215)
toggleUILabel.BackgroundTransparency = 1
toggleUILabel.Size = UDim2.new(0.5, -10, 1, 0)
toggleUILabel.Position = UDim2.new(0, 5, 0, 0)
toggleUILabel.TextXAlignment = Enum.TextXAlignment.Left
toggleUILabel.Parent = toggleUIContainer

toggleUIBtn = Instance.new("TextButton")
toggleUIBtn.Size = UDim2.new(0.5, -10, 0, 24)
toggleUIBtn.Position = UDim2.new(0.5, 5, 0, 3)
toggleUIBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
toggleUIBtn.BorderSizePixel = 1
toggleUIBtn.BorderColor3 = Color3.fromRGB(60, 65, 100)
toggleUIBtn.Text = getKeyName(toggleUIKey)
toggleUIBtn.Font = Enum.Font.GothamBold
toggleUIBtn.TextSize = 10
toggleUIBtn.TextColor3 = Color3.fromRGB(88, 101, 242)
toggleUIBtn.AutoButtonColor = false
toggleUIBtn.Parent = toggleUIContainer

local toggleUICorner = Instance.new("UICorner")
toggleUICorner.CornerRadius = UDim.new(0, 4)
toggleUICorner.Parent = toggleUIBtn

table.insert(connections, toggleUIBtn.MouseButton1Click:Connect(function()
	playSound(Sounds.Click, 0.4, 1.1, 1)
	toggleUIBtn.Text = "Press any key..."
	toggleUIBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
	waitingForKeybind = "toggleUI"
end))

setY = setY + 33

-- Unload Keybind
local unloadContainer = Instance.new("Frame")
unloadContainer.Size = UDim2.new(1, 0, 0, 30)
unloadContainer.Position = UDim2.new(0, 0, 0, setY)
unloadContainer.BackgroundTransparency = 1
unloadContainer.Parent = setLeftCol

local unloadLabel = Instance.new("TextLabel")
unloadLabel.Text = "Unload Script"
unloadLabel.Font = Enum.Font.Gotham
unloadLabel.TextSize = 11
unloadLabel.TextColor3 = Color3.fromRGB(200, 205, 215)
unloadLabel.BackgroundTransparency = 1
unloadLabel.Size = UDim2.new(0.5, -10, 1, 0)
unloadLabel.Position = UDim2.new(0, 5, 0, 0)
unloadLabel.TextXAlignment = Enum.TextXAlignment.Left
unloadLabel.Parent = unloadContainer

unloadBtn = Instance.new("TextButton")
unloadBtn.Size = UDim2.new(0.5, -10, 0, 24)
unloadBtn.Position = UDim2.new(0.5, 5, 0, 3)
unloadBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
unloadBtn.BorderSizePixel = 1
unloadBtn.BorderColor3 = Color3.fromRGB(60, 65, 100)
unloadBtn.Text = getKeyName(unloadKey)
unloadBtn.Font = Enum.Font.GothamBold
unloadBtn.TextSize = 10
unloadBtn.TextColor3 = Color3.fromRGB(220, 50, 50)
unloadBtn.AutoButtonColor = false
unloadBtn.Parent = unloadContainer

local unloadBtnCorner = Instance.new("UICorner")
unloadBtnCorner.CornerRadius = UDim.new(0, 4)
unloadBtnCorner.Parent = unloadBtn

table.insert(connections, unloadBtn.MouseButton1Click:Connect(function()
	playSound(Sounds.Click, 0.4, 1.1, 1)
	unloadBtn.Text = "Press any key..."
	unloadBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
	waitingForKeybind = "unload"
end))

setY = setY + 40

setY = createSection("UI Controls", setLeftCol, setY)

-- Hide button
local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(1, -10, 0, 30)
hideBtn.Position = UDim2.new(0, 5, 0, setY)
hideBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
hideBtn.BorderSizePixel = 0
hideBtn.Text = "Hide UI"
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextSize = 11
hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hideBtn.AutoButtonColor = false
hideBtn.Parent = setLeftCol

local hideBtnCorner = Instance.new("UICorner")
hideBtnCorner.CornerRadius = UDim.new(0, 4)
hideBtnCorner.Parent = hideBtn

-- Button glow
local hideBtnGlow = Instance.new("Frame")
hideBtnGlow.Size = UDim2.new(1, 0, 1, 0)
hideBtnGlow.BackgroundColor3 = Color3.fromRGB(120, 140, 255)
hideBtnGlow.BackgroundTransparency = 1
hideBtnGlow.BorderSizePixel = 0
hideBtnGlow.ZIndex = 0
hideBtnGlow.Parent = hideBtn

local hideGlowCorner = Instance.new("UICorner")
hideGlowCorner.CornerRadius = UDim.new(0, 4)
hideGlowCorner.Parent = hideBtnGlow

table.insert(connections, hideBtn.MouseEnter:Connect(function()
	playSound(Sounds.Hover, 0.2, 1.3, 1)
	tween(hideBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(100, 115, 255)}):Play()
	tween(hideBtnGlow, 0.2, {BackgroundTransparency = 0.7}):Play()
end))

table.insert(connections, hideBtn.MouseLeave:Connect(function()
	tween(hideBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}):Play()
	tween(hideBtnGlow, 0.2, {BackgroundTransparency = 1}):Play()
end))

table.insert(connections, hideBtn.MouseButton1Click:Connect(function()
	playSound(Sounds.Click, 0.5, 1, 1)
	-- Click animation
	hideBtn.Size = UDim2.new(1, -10, 0, 28)
	tween(hideBtn, 0.1, {Size = UDim2.new(1, -10, 0, 30)}):Play()
	
	mainFrame.Visible = false
	notify("UI Hidden - Press " .. getKeyName(toggleUIKey) .. " to show")
end))

setY = setY + 35

-- Unload button
local unloadBtn = Instance.new("TextButton")
unloadBtn.Size = UDim2.new(1, -10, 0, 30)
unloadBtn.Position = UDim2.new(0, 5, 0, setY)
unloadBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
unloadBtn.BorderSizePixel = 0
unloadBtn.Text = "Unload CHAINIX"
unloadBtn.Font = Enum.Font.GothamBold
unloadBtn.TextSize = 11
unloadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
unloadBtn.AutoButtonColor = false
unloadBtn.Parent = setLeftCol

local unloadBtnCorner = Instance.new("UICorner")
unloadBtnCorner.CornerRadius = UDim.new(0, 4)
unloadBtnCorner.Parent = unloadBtn

-- Button glow
local unloadBtnGlow = Instance.new("Frame")
unloadBtnGlow.Size = UDim2.new(1, 0, 1, 0)
unloadBtnGlow.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
unloadBtnGlow.BackgroundTransparency = 1
unloadBtnGlow.BorderSizePixel = 0
unloadBtnGlow.ZIndex = 0
unloadBtnGlow.Parent = unloadBtn

local unloadGlowCorner = Instance.new("UICorner")
unloadGlowCorner.CornerRadius = UDim.new(0, 4)
unloadGlowCorner.Parent = unloadBtnGlow

table.insert(connections, unloadBtn.MouseEnter:Connect(function()
	playSound(Sounds.Hover, 0.2, 1.3, 1)
	tween(unloadBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}):Play()
	tween(unloadBtnGlow, 0.2, {BackgroundTransparency = 0.7}):Play()
end))

table.insert(connections, unloadBtn.MouseLeave:Connect(function()
	tween(unloadBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}):Play()
	tween(unloadBtnGlow, 0.2, {BackgroundTransparency = 1}):Play()
end))

table.insert(connections, unloadBtn.MouseButton1Click:Connect(function()
	playSound(Sounds.Error, 0.7, 1, 2)
	-- Click animation
	unloadBtn.Size = UDim2.new(1, -10, 0, 28)
	tween(unloadBtn, 0.1, {Size = UDim2.new(1, -10, 0, 30)}):Play()
	
	notify("Unloading CHAINIX...")
	wait(0.5)
	cleanup()
end))

-- Update canvas size so all sections are reachable!
setScrollFrame.CanvasSize = UDim2.new(0, 0, 0, setY + 20)

-- MISC PAGE
local miscPage = tabPages["Misc"]

local miscLeftCol = Instance.new("Frame")
miscLeftCol.Size = UDim2.new(1, -10, 1, -10)
miscLeftCol.Position = UDim2.new(0, 5, 0, 5)
miscLeftCol.BackgroundTransparency = 1
miscLeftCol.Parent = miscPage

local miscY = createSection("Performance", miscLeftCol, 0)

miscY = createCheckbox("Performance Mode", miscLeftCol, miscY, function(enabled)
	if enabled then
		-- Disable shadows
		local Lighting = game:GetService("Lighting")
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 9e9
		
		-- Reduce quality
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		
		notify("Performance Mode ON - FPS Boost!")
	else
		-- Re-enable shadows
		local Lighting = game:GetService("Lighting")
		Lighting.GlobalShadows = true
		Lighting.FogEnd = 100000
		
		-- Normal quality
		settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
		
		notify("Performance Mode OFF")
	end
end)

miscY = createCheckbox("Remove Textures", miscLeftCol, miscY, function(enabled)
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
			if enabled then
				obj.Material = Enum.Material.SmoothPlastic
			end
		end
	end
	notify(enabled and "Textures Removed - FPS Boost!" or "Textures Restored")
end)

miscY = miscY + 10
miscY = createSection("Other", miscLeftCol, miscY)

miscY = createCheckbox("Show FPS", miscLeftCol, miscY, function(enabled)
	local fpsLabel = screenGui:FindFirstChild("FPSCounter")
	
	if enabled then
		if not fpsLabel then
			fpsLabel = Instance.new("TextLabel")
			fpsLabel.Name = "FPSCounter"
			fpsLabel.Size = UDim2.new(0, 120, 0, 40)
			fpsLabel.Position = UDim2.new(1, -130, 0, 60) -- Top right, below speed indicator
			fpsLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
			fpsLabel.BackgroundTransparency = 0.3
			fpsLabel.BorderSizePixel = 0
			fpsLabel.Font = Enum.Font.GothamBold
			fpsLabel.TextSize = 16
			fpsLabel.TextColor3 = Color3.fromRGB(88, 101, 242)
			fpsLabel.Text = "FPS: 60"
			fpsLabel.Parent = screenGui
			
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 6)
			corner.Parent = fpsLabel
			
			-- FPS calculation
			local lastTime = tick()
			local frameCount = 0
			local fps = 60
			
			spawn(function()
				while fpsLabel and fpsLabel.Parent do
					frameCount = frameCount + 1
					local currentTime = tick()
					
					if currentTime - lastTime >= 1 then
						fps = frameCount
						frameCount = 0
						lastTime = currentTime
						
						-- Color code based on FPS
						if fps >= 60 then
							fpsLabel.TextColor3 = Color3.fromRGB(50, 200, 100) -- Green
						elseif fps >= 30 then
							fpsLabel.TextColor3 = Color3.fromRGB(255, 200, 50) -- Yellow
						else
							fpsLabel.TextColor3 = Color3.fromRGB(255, 50, 50) -- Red
						end
						
						fpsLabel.Text = "FPS: " .. fps
					end
					
					game:GetService("RunService").RenderStepped:Wait()
				end
			end)
		end
		notify("FPS Counter ON")
	else
		if fpsLabel then
			fpsLabel:Destroy()
		end
		notify("FPS Counter OFF")
	end
end)

miscY = createCheckbox("Show Ping", miscLeftCol, miscY, function(enabled)
	local pingLabel = screenGui:FindFirstChild("PingCounter")
	
	if enabled then
		if not pingLabel then
			pingLabel = Instance.new("TextLabel")
			pingLabel.Name = "PingCounter"
			pingLabel.Size = UDim2.new(0, 120, 0, 40)
			pingLabel.Position = UDim2.new(1, -130, 0, 110)
			pingLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
			pingLabel.BackgroundTransparency = 0.3
			pingLabel.BorderSizePixel = 0
			pingLabel.Font = Enum.Font.GothamBold
			pingLabel.TextSize = 16
			pingLabel.TextColor3 = Color3.fromRGB(88, 101, 242)
			pingLabel.Text = "Ping: 0ms"
			pingLabel.Parent = screenGui
			
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 6)
			corner.Parent = pingLabel
			
			-- Ping calculation
			spawn(function()
				while pingLabel and pingLabel.Parent do
					pcall(function()
						local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
						
						-- Color code based on ping
						if ping <= 50 then
							pingLabel.TextColor3 = Color3.fromRGB(50, 200, 100)
						elseif ping <= 100 then
							pingLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
						else
							pingLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
						end
						
						pingLabel.Text = "Ping: " .. ping .. "ms"
					end)
					wait(1)
				end
			end)
		end
		notify("Ping Counter ON")
	else
		if pingLabel then
			pingLabel:Destroy()
		end
		notify("Ping Counter OFF")
	end
end)

local antiAFKEnabled = false
miscY = createCheckbox("Anti AFK", miscLeftCol, miscY, function(enabled)
	antiAFKEnabled = enabled
	notify(enabled and "Anti AFK ON" or "Anti AFK OFF")
end)

-- Anti-AFK loop
spawn(function()
	while true do
		if antiAFKEnabled then
			local VirtualUser = game:GetService("VirtualUser")
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end
		wait(300) -- Every 5 minutes
	end
end)

local autoRespawnEnabled = false
miscY = createCheckbox("Auto Respawn", miscLeftCol, miscY, function(enabled)
	autoRespawnEnabled = enabled
	notify(enabled and "Auto Respawn ON" or "Auto Respawn OFF")
end)

-- Auto Respawn detection
table.insert(connections, player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoid = newChar:WaitForChild("Humanoid")
	humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
end))

table.insert(connections, player.CharacterRemoving:Connect(function()
	if autoRespawnEnabled then
		wait(0.5)
		player:LoadCharacter()
	end
end))

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
	if jumpEnabled then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end))

table.insert(connections, RunService.Stepped:Connect(function()
	if noclipEnabled and character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
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

-- Keybind detection system
table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	-- Check if waiting for keybind
	if waitingForKeybind then
		if input.KeyCode ~= Enum.KeyCode.Unknown then
			playSound(Sounds.Success, 0.5, 1.2, 2)
			if waitingForKeybind == "toggleUI" then
				toggleUIKey = input.KeyCode
				toggleUIBtn.Text = getKeyName(toggleUIKey)
				toggleUIBtn.TextColor3 = Color3.fromRGB(88, 101, 242)
				updateConfig("toggle_key", getKeyName(toggleUIKey))
				notify("Toggle UI key set to: " .. getKeyName(toggleUIKey))
			elseif waitingForKeybind == "unload" then
				unloadKey = input.KeyCode
				unloadBtn.Text = getKeyName(unloadKey)
				unloadBtn.TextColor3 = Color3.fromRGB(220, 50, 50)
				updateConfig("unload_key", getKeyName(unloadKey))
				notify("Unload key set to: " .. getKeyName(unloadKey))
			end
			waitingForKeybind = nil
		end
		return
	end
	
	-- Toggle UI keybind
	if input.KeyCode == toggleUIKey then
		playSound(Sounds.Click, 0.3, 1, 1)
		mainFrame.Visible = not mainFrame.Visible
		if mainFrame.Visible then
			notify("UI Shown")
		else
			notify("UI Hidden - Press " .. getKeyName(toggleUIKey) .. " to show")
		end
	end
	
	-- Unload keybind
	if input.KeyCode == unloadKey then
		playSound(Sounds.Error, 0.7, 1, 2)
		notify("Unloading CHAINIX...")
		wait(0.5)
		cleanup()
	end
end))

notify("CHAINIX V1 loaded")
print("CHAINIX V1: Initialized")
