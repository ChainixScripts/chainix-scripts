--[[
	═══════════════════════════════════════
	         CHAINIX V1 - ELITE
	      Professional Script Hub
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
local autoFarmEnabled = false
local bodyVelocity, bodyGyro
local flySpeed, walkSpeed = 50, 100

-- Keybind system
local toggleUIKey = Enum.KeyCode.Insert
local unloadKey = Enum.KeyCode.Delete
local waitingForKeybind = nil
local toggleUIBtn = nil
local unloadBtn = nil
local notificationsEnabled = true

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
	if crosshairGui then crosshairGui:Destroy() end
	if screenGui then screenGui:Destroy() end
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

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 540, 0, 420)
mainFrame.Position = UDim2.new(0.5, -270, 0.5, -210)
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
infoBar.Size = UDim2.new(1, 0, 0, 24)
infoBar.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
infoBar.BorderSizePixel = 0
infoBar.Parent = mainFrame

local infoText = Instance.new("TextLabel")
infoText.Text = "CHAINIX V1 - Time : " .. os.date("%a %b %d %H:%M:%S %Y") .. " - Welcome to the club."
infoText.Font = Enum.Font.Code
infoText.TextSize = 10
infoText.TextColor3 = Color3.fromRGB(150, 160, 200)
infoText.BackgroundTransparency = 1
infoText.Size = UDim2.new(1, -10, 1, 0)
infoText.Position = UDim2.new(0, 5, 0, 0)
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.Parent = infoBar

-- Tab bar
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 32)
tabBar.Position = UDim2.new(0, 0, 0, 24)
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
	page.Size = UDim2.new(1, 0, 1, -56)
	page.Position = UDim2.new(0, 0, 0, 56)
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
		switchTab(name)
	end))
	
	-- Hover effects
	table.insert(connections, btn.MouseEnter:Connect(function()
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

local movLeftCol = Instance.new("Frame")
movLeftCol.Size = UDim2.new(1, -10, 1, -10)
movLeftCol.Position = UDim2.new(0, 5, 0, 5)
movLeftCol.BackgroundTransparency = 1
movLeftCol.Parent = movementPage

local movY = createSection("Movement", movLeftCol, 0)

movY = createCheckbox("Flight System", movLeftCol, movY, function(enabled)
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
		notify("Flight ON")
	else
		if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
		if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
		notify("Flight OFF")
	end
end)

movY = movY + 5
movY = createSlider("Flight Speed", movLeftCol, movY, 20, 200, 50, function(val)
	flySpeed = val
end)

movY = movY + 10
movY = createCheckbox("Speed Enhancement", movLeftCol, movY, function(enabled)
	speedEnabled = enabled
	if enabled then
		humanoid.WalkSpeed = walkSpeed
		notify("Speed ON")
	else
		humanoid.WalkSpeed = 16
		notify("Speed OFF")
	end
end)

movY = movY + 5
movY = createSlider("Walk Speed", movLeftCol, movY, 16, 200, 100, function(val)
	walkSpeed = val
	if speedEnabled then humanoid.WalkSpeed = val end
end)

movY = movY + 10
movY = createCheckbox("Infinite Jump", movLeftCol, movY, function(enabled)
	jumpEnabled = enabled
	notify(enabled and "Infinite Jump ON" or "Infinite Jump OFF")
end)

movY = movY + 5
movY = createCheckbox("No-Clip", movLeftCol, movY, function(enabled)
	noclipEnabled = enabled
	notify(enabled and "No-Clip ON" or "No-Clip OFF")
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
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local h = p.Character:FindFirstChild("ESPHighlight")
			if enabled and not h then
				h = Instance.new("Highlight")
				h.Name = "ESPHighlight"
				h.FillColor = Color3.fromRGB(88, 101, 242)
				h.OutlineColor = Color3.fromRGB(255, 255, 255)
				h.FillTransparency = 0.6
				h.OutlineTransparency = 0
				h.Parent = p.Character
			elseif not enabled and h then
				h:Destroy()
			end
		end
	end
	notify(enabled and "ESP ON" or "ESP OFF")
end)

visY = createCheckbox("Show Names", visLeftCol, visY, function(enabled)
	notify(enabled and "Names ON" or "Names OFF")
end)

visY = createCheckbox("Show Distance", visLeftCol, visY, function(enabled)
	notify(enabled and "Distance ON" or "Distance OFF")
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

setY = createCheckbox("Auto Save Config", setLeftCol, setY, function(enabled)
	notify(enabled and "Auto Save ON" or "Auto Save OFF")
end)

-- Custom Crosshair
local crosshairEnabled = false
local crosshairGui = nil

setY = setY + 5
setY = createCheckbox("Custom Crosshair", setLeftCol, setY, function(enabled)
	crosshairEnabled = enabled
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
	tween(hideBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(100, 115, 255)}):Play()
	tween(hideBtnGlow, 0.2, {BackgroundTransparency = 0.7}):Play()
end))

table.insert(connections, hideBtn.MouseLeave:Connect(function()
	tween(hideBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}):Play()
	tween(hideBtnGlow, 0.2, {BackgroundTransparency = 1}):Play()
end))

table.insert(connections, hideBtn.MouseButton1Click:Connect(function()
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
	tween(unloadBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}):Play()
	tween(unloadBtnGlow, 0.2, {BackgroundTransparency = 0.7}):Play()
end))

table.insert(connections, unloadBtn.MouseLeave:Connect(function()
	tween(unloadBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}):Play()
	tween(unloadBtnGlow, 0.2, {BackgroundTransparency = 1}):Play()
end))

table.insert(connections, unloadBtn.MouseButton1Click:Connect(function()
	-- Click animation
	unloadBtn.Size = UDim2.new(1, -10, 0, 28)
	tween(unloadBtn, 0.1, {Size = UDim2.new(1, -10, 0, 30)}):Play()
	
	notify("Unloading CHAINIX...")
	wait(0.5)
	cleanup()
end))

setY = setY + 40

setY = createSection("Performance", setLeftCol, setY)

setY = createCheckbox("Low Graphics Mode", setLeftCol, setY, function(enabled)
	notify(enabled and "Low Graphics ON" or "Low Graphics OFF")
end)

-- Update canvas size so Performance section is reachable!
setScrollFrame.CanvasSize = UDim2.new(0, 0, 0, setY + 20)

-- MISC PAGE
local miscPage = tabPages["Misc"]

local miscLeftCol = Instance.new("Frame")
miscLeftCol.Size = UDim2.new(1, -10, 1, -10)
miscLeftCol.Position = UDim2.new(0, 5, 0, 5)
miscLeftCol.BackgroundTransparency = 1
miscLeftCol.Parent = miscPage

local miscY = createSection("Misc", miscLeftCol, 0)

miscY = createCheckbox("Anti AFK", miscLeftCol, miscY, function(enabled)
	notify(enabled and "Anti AFK ON" or "Anti AFK OFF")
end)

miscY = createCheckbox("Auto Respawn", miscLeftCol, miscY, function(enabled)
	notify(enabled and "Auto Respawn ON" or "Auto Respawn OFF")
end)

-- CHAINIX Logo (bottom right)
local logo = Instance.new("TextLabel")
logo.Text = "⛓"
logo.Font = Enum.Font.GothamBold
logo.TextSize = 32
logo.TextColor3 = Color3.fromRGB(88, 101, 242)
logo.BackgroundTransparency = 1
logo.Size = UDim2.new(0, 40, 0, 40)
logo.Position = UDim2.new(1, -50, 1, -50)
logo.TextTransparency = 0.3
logo.Parent = mainFrame

local logoText = Instance.new("TextLabel")
logoText.Text = "CHAINIX"
logoText.Font = Enum.Font.Code
logoText.TextSize = 8
logoText.TextColor3 = Color3.fromRGB(150, 160, 200)
logoText.BackgroundTransparency = 1
logoText.Size = UDim2.new(0, 60, 0, 15)
logoText.Position = UDim2.new(1, -65, 1, -20)
logoText.TextTransparency = 0.5
logoText.Parent = mainFrame

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
			if waitingForKeybind == "toggleUI" then
				toggleUIKey = input.KeyCode
				toggleUIBtn.Text = getKeyName(toggleUIKey)
				toggleUIBtn.TextColor3 = Color3.fromRGB(88, 101, 242)
				notify("Toggle UI key set to: " .. getKeyName(toggleUIKey))
			elseif waitingForKeybind == "unload" then
				unloadKey = input.KeyCode
				unloadBtn.Text = getKeyName(unloadKey)
				unloadBtn.TextColor3 = Color3.fromRGB(220, 50, 50)
				notify("Unload key set to: " .. getKeyName(unloadKey))
			end
			waitingForKeybind = nil
		end
		return
	end
	
	-- Toggle UI keybind
	if input.KeyCode == toggleUIKey then
		mainFrame.Visible = not mainFrame.Visible
		if mainFrame.Visible then
			notify("UI Shown")
		else
			notify("UI Hidden - Press " .. getKeyName(toggleUIKey) .. " to show")
		end
	end
	
	-- Unload keybind
	if input.KeyCode == unloadKey then
		notify("Unloading CHAINIX...")
		wait(0.5)
		cleanup()
	end
end))

notify("CHAINIX V1 loaded")
print("CHAINIX V1: Initialized")
