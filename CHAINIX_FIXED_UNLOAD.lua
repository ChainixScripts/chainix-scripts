--[[
	CHAINIX ULTIMATE EDITION v5.0
	EVERY FEATURE IMAGINABLE!
	Premium Dark Theme | All Visual Effects | Complete Feature Set
]]--

-- ========================================
-- SERVICES
-- ========================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

-- ========================================
-- SAVED DATA (Favorites, Recent, Settings)
-- ========================================
local SavedData = {
	Favorites = {},
	RecentlyUsed = {},
	Settings = {
		Volume = 100,
		AnimationsEnabled = true,
		Theme = "Default",
		ToggleKey = Enum.KeyCode.Insert,
		NotificationsEnabled = true
	},
	CurrentVersion = "5.0"
}

-- ========================================
-- THEMES
-- ========================================
local Themes = {
	Black = {
		Name = "Pure Black",
		BackgroundDark = Color3.fromRGB(0, 0, 0),
		BackgroundMain = Color3.fromRGB(0, 0, 0),
		AccentPrimary = Color3.fromRGB(240, 245, 250),
		AccentSecondary = Color3.fromRGB(160, 170, 180),
		AccentDim = Color3.fromRGB(80, 90, 100),
		BorderLight = Color3.fromRGB(200, 210, 220),
		ButtonNormal = Color3.fromRGB(200, 210, 220),
		ButtonHover = Color3.fromRGB(255, 255, 255),
		StatusColor = Color3.fromRGB(50, 200, 100)
	},
	Default = {
		Name = "Default Dark",
		BackgroundDark = Color3.fromRGB(10, 10, 12),
		BackgroundMain = Color3.fromRGB(16, 16, 20),
		AccentPrimary = Color3.fromRGB(240, 245, 250),
		AccentSecondary = Color3.fromRGB(160, 170, 180),
		AccentDim = Color3.fromRGB(80, 90, 100),
		BorderLight = Color3.fromRGB(200, 210, 220),
		ButtonNormal = Color3.fromRGB(200, 210, 220),
		ButtonHover = Color3.fromRGB(255, 255, 255),
		StatusColor = Color3.fromRGB(50, 200, 100)
	},
	Ocean = {
		Name = "Ocean Blue",
		BackgroundDark = Color3.fromRGB(10, 15, 25),
		BackgroundMain = Color3.fromRGB(15, 25, 40),
		AccentPrimary = Color3.fromRGB(100, 200, 255),
		AccentSecondary = Color3.fromRGB(80, 150, 200),
		AccentDim = Color3.fromRGB(50, 100, 150),
		BorderLight = Color3.fromRGB(120, 180, 230),
		ButtonNormal = Color3.fromRGB(80, 160, 220),
		ButtonHover = Color3.fromRGB(100, 200, 255),
		StatusColor = Color3.fromRGB(50, 200, 255)
	},
	Purple = {
		Name = "Royal Purple",
		BackgroundDark = Color3.fromRGB(15, 10, 20),
		BackgroundMain = Color3.fromRGB(25, 15, 35),
		AccentPrimary = Color3.fromRGB(200, 150, 255),
		AccentSecondary = Color3.fromRGB(150, 100, 200),
		AccentDim = Color3.fromRGB(100, 60, 150),
		BorderLight = Color3.fromRGB(180, 130, 230),
		ButtonNormal = Color3.fromRGB(160, 100, 220),
		ButtonHover = Color3.fromRGB(200, 150, 255),
		StatusColor = Color3.fromRGB(180, 100, 255)
	},
	Matrix = {
		Name = "Matrix Green",
		BackgroundDark = Color3.fromRGB(5, 10, 5),
		BackgroundMain = Color3.fromRGB(10, 20, 10),
		AccentPrimary = Color3.fromRGB(50, 255, 50),
		AccentSecondary = Color3.fromRGB(40, 200, 40),
		AccentDim = Color3.fromRGB(30, 150, 30),
		BorderLight = Color3.fromRGB(60, 220, 60),
		ButtonNormal = Color3.fromRGB(40, 180, 40),
		ButtonHover = Color3.fromRGB(50, 255, 50),
		StatusColor = Color3.fromRGB(50, 255, 50)
	},
	Ruby = {
		Name = "Ruby Red",
		BackgroundDark = Color3.fromRGB(20, 5, 5),
		BackgroundMain = Color3.fromRGB(30, 10, 10),
		AccentPrimary = Color3.fromRGB(255, 100, 100),
		AccentSecondary = Color3.fromRGB(200, 80, 80),
		AccentDim = Color3.fromRGB(150, 50, 50),
		BorderLight = Color3.fromRGB(230, 100, 100),
		ButtonNormal = Color3.fromRGB(200, 80, 80),
		ButtonHover = Color3.fromRGB(255, 100, 100),
		StatusColor = Color3.fromRGB(255, 50, 50)
	},
	Gold = {
		Name = "Gold",
		BackgroundDark = Color3.fromRGB(20, 15, 5),
		BackgroundMain = Color3.fromRGB(30, 25, 10),
		AccentPrimary = Color3.fromRGB(255, 215, 100),
		AccentSecondary = Color3.fromRGB(200, 170, 80),
		AccentDim = Color3.fromRGB(150, 120, 50),
		BorderLight = Color3.fromRGB(230, 190, 100),
		ButtonNormal = Color3.fromRGB(200, 160, 80),
		ButtonHover = Color3.fromRGB(255, 215, 100),
		StatusColor = Color3.fromRGB(255, 200, 50)
	},
	Pink = {
		Name = "Hot Pink",
		BackgroundDark = Color3.fromRGB(20, 5, 15),
		BackgroundMain = Color3.fromRGB(30, 10, 20),
		AccentPrimary = Color3.fromRGB(255, 105, 180),
		AccentSecondary = Color3.fromRGB(255, 182, 193),
		AccentDim = Color3.fromRGB(199, 21, 133),
		BorderLight = Color3.fromRGB(255, 192, 203),
		ButtonNormal = Color3.fromRGB(255, 105, 180),
		ButtonHover = Color3.fromRGB(255, 20, 147),
		StatusColor = Color3.fromRGB(255, 105, 180)
	},
	Custom = {
		Name = "Create Custom",
		BackgroundDark = Color3.fromRGB(10, 10, 12),
		BackgroundMain = Color3.fromRGB(16, 16, 20),
		AccentPrimary = Color3.fromRGB(100, 200, 255),
		AccentSecondary = Color3.fromRGB(160, 170, 180),
		AccentDim = Color3.fromRGB(80, 90, 100),
		BorderLight = Color3.fromRGB(200, 210, 220),
		ButtonNormal = Color3.fromRGB(200, 210, 220),
		ButtonHover = Color3.fromRGB(255, 255, 255),
		StatusColor = Color3.fromRGB(50, 200, 100)
	}
}

local Config = Themes.Black

-- ========================================
-- OTHER CONFIGURATION
-- ========================================
Config.FrameSize = UDim2.new(0, 500, 0, 320)
Config.FramePosition = UDim2.new(0.5, -250, 0.5, -160)

Config.Sounds = {
	Boot = "rbxassetid://138081500",
	Scrape = "rbxassetid://184432003",
	Activate = "rbxassetid://9123742171",
	ChainBreak = "rbxassetid://71798054966140",
	Hover = "rbxassetid://156286438",
	Click = "rbxassetid://156286438",
	GameClick = "rbxassetid://108829144248244"
}

Config.ChainFrames = {
	"rbxassetid://140337915830730",
	"rbxassetid://81996960442467",
	"rbxassetid://131276524233250",
	"rbxassetid://118029488236360",
	"rbxassetid://137991765165431"
}

Config.GridColumns = 4
Config.ButtonWidth = 105
Config.ButtonHeight = 45
Config.ButtonSpacingX = 12
Config.ButtonSpacingY = 12

-- ========================================
-- GAME LIST
-- ========================================
local GameList = {
	{
		name = "TEST", 
		url = "",
		icon = "🧪",
		available = true,
		description = "Test hub with UI",
		lastUpdated = "2026-02-07",
		script = [[local p=game:GetService("Players")local t=game:GetService("TweenService")local u=game:GetService("UserInputService")local r=game:GetService("RunService")local l=p.LocalPlayer;local c=l.Character or l.CharacterAdded:Wait()local h=c:WaitForChild("HumanoidRootPart")local g=Instance.new("ScreenGui")g.Name="ChainixTestHub"g.ResetOnSpawn=false;g.Parent=l.PlayerGui;local m=Instance.new("Frame")m.Size=UDim2.new(0,400,0,450)m.Position=UDim2.new(0.5,-200,0.5,-225)m.BackgroundColor3=Color3.fromRGB(0,0,0)m.BorderSizePixel=0;m.Active=true;m.Draggable=true;m.Parent=g;local n=Instance.new("UICorner")n.CornerRadius=UDim.new(0,12)n.Parent=m;local o=Instance.new("UIStroke")o.Color=Color3.fromRGB(200,210,220)o.Thickness=2;o.Transparency=0.7;o.Parent=m;local q=Instance.new("TextLabel")q.Text="CHAINIX TEST"q.Font=Enum.Font.GothamBold;q.TextColor3=Color3.fromRGB(240,245,250)q.TextSize=20;q.BackgroundTransparency=1;q.Size=UDim2.new(1,-60,0,50)q.Position=UDim2.new(0,0,0,10)q.Parent=m;local s=Instance.new("TextLabel")s.Text="Universal Script Hub"s.Font=Enum.Font.Gotham;s.TextColor3=Color3.fromRGB(160,170,180)s.TextSize=12;s.BackgroundTransparency=1;s.Size=UDim2.new(1,0,0,20)s.Position=UDim2.new(0,0,0,35)s.Parent=m;local v=Instance.new("TextButton")v.Text="X"v.Font=Enum.Font.GothamBold;v.TextColor3=Color3.fromRGB(160,170,180)v.TextSize=18;v.BackgroundColor3=Color3.fromRGB(0,0,0)v.BackgroundTransparency=0.3;v.Size=UDim2.new(0,36,0,36)v.Position=UDim2.new(1,-48,0,12)v.AutoButtonColor=false;v.Parent=m;local w=Instance.new("UICorner")w.CornerRadius=UDim.new(0,8)w.Parent=v;v.MouseButton1Click:Connect(function()g:Destroy()end)local x=Instance.new("Frame")x.Size=UDim2.new(1,-40,0,2)x.Position=UDim2.new(0,20,0,60)x.BackgroundColor3=Color3.fromRGB(240,245,250)x.BorderSizePixel=0;x.Parent=m;local y,z,A=false,false,false;local B,C;local function D(E)game:GetService("StarterGui"):SetCore("SendNotification",{Title="CHAINIX TEST";Text=E;Duration=2})end;local function F(G,H,I,J)local K=Instance.new("Frame")K.Size=UDim2.new(1,-40,0,50)K.Position=UDim2.new(0,20,0,I)K.BackgroundColor3=Color3.fromRGB(16,16,20)K.BackgroundTransparency=0.3;K.Parent=m;local L=Instance.new("UICorner")L.CornerRadius=UDim.new(0,8)L.Parent=K;local M=Instance.new("TextLabel")M.Text=H;M.Font=Enum.Font.GothamBold;M.TextSize=24;M.BackgroundTransparency=1;M.Size=UDim2.new(0,40,1,0)M.Position=UDim2.new(0,10,0,0)M.Parent=K;local N=Instance.new("TextLabel")N.Text=G;N.Font=Enum.Font.GothamMedium;N.TextColor3=Color3.fromRGB(240,245,250)N.TextSize=14;N.BackgroundTransparency=1;N.Size=UDim2.new(1,-140,1,0)N.Position=UDim2.new(0,50,0,0)N.TextXAlignment=Enum.TextXAlignment.Left;N.Parent=K;local O=Instance.new("TextButton")O.Text="OFF"O.Font=Enum.Font.GothamBold;O.TextColor3=Color3.fromRGB(255,100,100)O.TextSize=12;O.BackgroundColor3=Color3.fromRGB(10,10,12)O.Size=UDim2.new(0,60,0,30)O.Position=UDim2.new(1,-70,0.5,-15)O.AutoButtonColor=false;O.Parent=K;local P=Instance.new("UICorner")P.CornerRadius=UDim.new(0,6)P.Parent=O;local Q=Instance.new("UIStroke")Q.Color=Color3.fromRGB(255,100,100)Q.Thickness=2;Q.Transparency=0.3;Q.Parent=O;local R=false;O.MouseButton1Click:Connect(function()R=not R;if R then O.Text="ON"O.TextColor3=Color3.fromRGB(100,255,100)Q.Color=Color3.fromRGB(100,255,100)else O.Text="OFF"O.TextColor3=Color3.fromRGB(255,100,100)Q.Color=Color3.fromRGB(255,100,100)end;J(R)end)end;F("Fly (Press X)","🚀",80,function(S)if S then y=true;B=Instance.new("BodyVelocity")B.Velocity=Vector3.new(0,0,0)B.MaxForce=Vector3.new(9e9,9e9,9e9)B.Parent=h;C=Instance.new("BodyGyro")C.MaxTorque=Vector3.new(9e9,9e9,9e9)C.CFrame=h.CFrame;C.Parent=h;D("Fly enabled! ✅")else y=false;if B then B:Destroy()end;if C then C:Destroy()end;D("Fly disabled! ❌")end end)F("Speed Hack","⚡",140,function(S)local T=c:FindFirstChild("Humanoid")if T then if S then T.WalkSpeed=100;z=true;D("Speed enabled! ✅")else T.WalkSpeed=16;z=false;D("Speed disabled! ❌")end end end)F("Infinite Jump","🦘",200,function(S)A=S;if S then D("Infinite Jump enabled! ✅")else D("Infinite Jump disabled! ❌")end end)F("ESP (Wallhack)","👁️",260,function(S)for U,V in pairs(p:GetPlayers())do if V~=p.LocalPlayer and V.Character then local W=V.Character:FindFirstChild("ESPHighlight")if S and not W then W=Instance.new("Highlight")W.Name="ESPHighlight"W.FillColor=Color3.fromRGB(255,100,100)W.OutlineColor=Color3.fromRGB(255,255,255)W.FillTransparency=0.5;W.OutlineTransparency=0;W.Parent=V.Character elseif not S and W then W:Destroy()end end end;if S then D("ESP enabled! ✅")else D("ESP disabled! ❌")end end)local X=false;F("No-Clip","👻",320,function(S)X=S;if S then D("No-Clip enabled! ✅")else D("No-Clip disabled! ❌")end end)r.Heartbeat:Connect(function()if y and B and C then local Y=workspace.CurrentCamera;local Z=Vector3.new(0,0,0)local _=50;if u:IsKeyDown(Enum.KeyCode.W)then Z=Z+Y.CFrame.LookVector*_ end;if u:IsKeyDown(Enum.KeyCode.S)then Z=Z-Y.CFrame.LookVector*_ end;if u:IsKeyDown(Enum.KeyCode.A)then Z=Z-Y.CFrame.RightVector*_ end;if u:IsKeyDown(Enum.KeyCode.D)then Z=Z+Y.CFrame.RightVector*_ end;if u:IsKeyDown(Enum.KeyCode.Space)then Z=Z+Vector3.new(0,_,0)end;if u:IsKeyDown(Enum.KeyCode.LeftShift)then Z=Z-Vector3.new(0,_,0)end;B.Velocity=Z;C.CFrame=Y.CFrame end end)u.JumpRequest:Connect(function()if A then local T=c:FindFirstChild("Humanoid")if T then T:ChangeState(Enum.HumanoidStateType.Jumping)end end end)r.Stepped:Connect(function()if X then for U,a0 in pairs(c:GetDescendants())do if a0:IsA("BasePart")then a0.CanCollide=false end end end end)l.CharacterAdded:Connect(function(a1)c=a1;h=a1:WaitForChild("HumanoidRootPart")if y then y=false;if B then B:Destroy()end;if C then C:Destroy()end end end)D("Test Hub loaded! 🎮")]]
	},
	{name = "Coming Soon", url = "", icon = "🔒", available = false, description = "Stay tuned!", lastUpdated = "N/A"},
	{name = "Coming Soon", url = "", icon = "🔒", available = false, description = "Stay tuned!", lastUpdated = "N/A"},
	{name = "Coming Soon", url = "", icon = "🔒", available = false, description = "Stay tuned!", lastUpdated = "N/A"},
	{name = "Coming Soon", url = "", icon = "🔒", available = false, description = "Stay tuned!", lastUpdated = "N/A"},
	{name = "Coming Soon", url = "", icon = "🔒", available = false, description = "Stay tuned!", lastUpdated = "N/A"},
	{name = "Coming Soon", url = "", icon = "🔒", available = false, description = "Stay tuned!", lastUpdated = "N/A"},
	{name = "Coming Soon", url = "", icon = "🔒", available = false, description = "Stay tuned!", lastUpdated = "N/A"},
	{name = "Coming Soon", url = "", icon = "🔒", available = false, description = "Stay tuned!", lastUpdated = "N/A"},
	{name = "Coming Soon", url = "", icon = "🔒", available = false, description = "Stay tuned!", lastUpdated = "N/A"},
	{name = "Coming Soon", url = "", icon = "🔒", available = false, description = "Stay tuned!", lastUpdated = "N/A"},
	{name = "Coming Soon", url = "", icon = "🔒", available = false, description = "Stay tuned!", lastUpdated = "N/A"}
}

-- ========================================
-- UTILITY FUNCTIONS
-- ========================================
local Utils = {}

function Utils.CreateSound(soundId, volume, playbackSpeed)
	local sound = Instance.new("Sound", SoundService)
	sound.SoundId = soundId
	sound.Volume = (volume or 1) * (SavedData.Settings.Volume / 100)
	sound.PlaybackSpeed = playbackSpeed or 1
	return sound
end

function Utils.PlaySound(soundId, volume, playbackSpeed, destroyAfter)
	local sound = Utils.CreateSound(soundId, volume, playbackSpeed)
	sound:Play()
	Debris:AddItem(sound, destroyAfter or 2)
end

function Utils.CreateTween(instance, duration, properties, easingStyle)
	if not SavedData.Settings.AnimationsEnabled then
		for prop, value in pairs(properties) do
			instance[prop] = value
		end
		return {Play = function() end, Completed = Instance.new("BindableEvent").Event}
	end
	local tweenInfo = TweenInfo.new(duration, easingStyle or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	return TweenService:Create(instance, tweenInfo, properties)
end

function Utils.ShowNotification(message, duration)
	if not SavedData.Settings.NotificationsEnabled then return end
	-- Will implement notification system
	print(">> NOTIFICATION: " .. message)
end

-- ========================================
-- MAIN INITIALIZATION
-- ========================================
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "CHAINIX_ULTIMATE"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local UI = {}
local gameButtons = {}
local settingsPanelOpen = false
local loaderVisible = true

print(">> CHAINIX ULTIMATE: Initializing v5.0...")
print(">> Loading with ALL features enabled!")
print(">> This is going to be INSANE! 🔥")

-- I'll continue with the massive UI creation in the next part...
-- This file is getting huge with ALL features!

-- ========================================
-- UI CREATION - SHADOWS
-- ========================================
local shadowFrame1 = Instance.new("Frame")
shadowFrame1.Size = UDim2.new(0, 520, 0, 340)
shadowFrame1.Position = UDim2.new(0.5, -260, 0.5, -170)
shadowFrame1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadowFrame1.BackgroundTransparency = 0.92
shadowFrame1.BorderSizePixel = 0
shadowFrame1.ZIndex = 0
shadowFrame1.Parent = gui

local shadowCorner1 = Instance.new("UICorner")
shadowCorner1.CornerRadius = UDim.new(0, 16)
shadowCorner1.Parent = shadowFrame1

local shadowFrame2 = Instance.new("Frame")
shadowFrame2.Size = UDim2.new(0, 510, 0, 330)
shadowFrame2.Position = UDim2.new(0.5, -255, 0.5, -165)
shadowFrame2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadowFrame2.BackgroundTransparency = 0.88
shadowFrame2.BorderSizePixel = 0
shadowFrame2.ZIndex = 0
shadowFrame2.Parent = gui

local shadowCorner2 = Instance.new("UICorner")
shadowCorner2.CornerRadius = UDim.new(0, 14)
shadowCorner2.Parent = shadowFrame2

-- ========================================
-- MAIN FRAME
-- ========================================
UI.Frame = Instance.new("Frame")
UI.Frame.Size = Config.FrameSize
UI.Frame.Position = Config.FramePosition
UI.Frame.BackgroundColor3 = Config.BackgroundMain
UI.Frame.BorderSizePixel = 0
UI.Frame.BackgroundTransparency = 1
UI.Frame.ClipsDescendants = true
UI.Frame.ZIndex = 1
UI.Frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = UI.Frame

-- Animated Background
local animatedBG = Instance.new("Frame")
animatedBG.Size = UDim2.new(1, 0, 1, 0)
animatedBG.BackgroundColor3 = Config.BackgroundMain
animatedBG.BorderSizePixel = 0
animatedBG.ZIndex = 0
animatedBG.Parent = UI.Frame

local animatedCorner = Instance.new("UICorner")
animatedCorner.CornerRadius = UDim.new(0, 12)
animatedCorner.Parent = animatedBG

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Config.BackgroundMain),
	ColorSequenceKeypoint.new(0.5, Config.BackgroundDark),
	ColorSequenceKeypoint.new(1, Config.BackgroundMain)
}
gradient.Rotation = 45
gradient.Parent = animatedBG

-- Border
UI.OuterBorder = Instance.new("UIStroke")
UI.OuterBorder.Thickness = 1.5
UI.OuterBorder.Color = Config.BorderLight
UI.OuterBorder.Transparency = 0.85
UI.OuterBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.OuterBorder.Parent = UI.Frame

-- Accent Line
local accentLine = Instance.new("Frame")
accentLine.Size = UDim2.new(0.4, 0, 0, 2)
accentLine.Position = UDim2.new(0.3, 0, 0, 0)
accentLine.BackgroundColor3 = Config.AccentPrimary
accentLine.BorderSizePixel = 0
accentLine.BackgroundTransparency = 0.7
accentLine.ZIndex = 5
accentLine.Parent = UI.Frame

local accentGradient = Instance.new("UIGradient")
accentGradient.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.5, 0),
	NumberSequenceKeypoint.new(1, 1)
}
accentGradient.Parent = accentLine

-- ========================================
-- FLOATING PARTICLES
-- ========================================
local particlesContainer = Instance.new("Frame")
particlesContainer.Size = UDim2.new(1, 0, 1, 0)
particlesContainer.BackgroundTransparency = 1
particlesContainer.ClipsDescendants = true
particlesContainer.ZIndex = 1
particlesContainer.Parent = UI.Frame

local function createParticle()
	local particle = Instance.new("Frame")
	particle.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
	particle.Position = UDim2.new(math.random(), 0, 1.2, 0)
	particle.BackgroundColor3 = Config.AccentPrimary
	particle.BackgroundTransparency = math.random(70, 90) / 100
	particle.BorderSizePixel = 0
	particle.ZIndex = 2
	particle.Parent = particlesContainer
	
	local particleCorner = Instance.new("UICorner")
	particleCorner.CornerRadius = UDim.new(1, 0)
	particleCorner.Parent = particle
	
	local duration = math.random(8, 15)
	task.spawn(function()
		Utils.CreateTween(particle, duration, {Position = UDim2.new(math.random(), 0, -0.2, 0)}, Enum.EasingStyle.Linear):Play()
		task.wait(duration)
		particle:Destroy()
	end)
end

-- ========================================
-- LOGO & TITLE
-- ========================================
UI.LogoBG = Instance.new("Frame")
UI.LogoBG.Size = UDim2.new(1, 0, 1, 0)
UI.LogoBG.BackgroundTransparency = 1
UI.LogoBG.ClipsDescendants = true
UI.LogoBG.ZIndex = 2
UI.LogoBG.Parent = UI.Frame

UI.Logo = Instance.new("ImageLabel")
UI.Logo.Size = UDim2.new(1, 0, 1, 0)
UI.Logo.BackgroundTransparency = 1
UI.Logo.Image = Config.ChainFrames[1]
UI.Logo.ImageTransparency = 0.15
UI.Logo.ImageColor3 = Config.AccentPrimary
UI.Logo.ScaleType = Enum.ScaleType.Stretch
UI.Logo.ZIndex = 2
UI.Logo.Parent = UI.LogoBG

local titleContainer = Instance.new("Frame")
titleContainer.Size = UDim2.new(1, 0, 0, 100)
titleContainer.Position = UDim2.new(0, 0, 0.32, 0)
titleContainer.BackgroundTransparency = 1
titleContainer.ZIndex = 3
titleContainer.Parent = UI.Frame

UI.Title = Instance.new("TextLabel")
UI.Title.Text = "CHAINIX"
UI.Title.Font = Enum.Font.GothamBold
UI.Title.TextColor3 = Config.AccentPrimary
UI.Title.TextSize = 48
UI.Title.BackgroundTransparency = 1
UI.Title.Size = UDim2.new(1, 0, 0, 55)
UI.Title.ZIndex = 4
UI.Title.Parent = titleContainer

UI.Subtitle = Instance.new("TextLabel")
UI.Subtitle.Text = "Ultimate Script Loader"
UI.Subtitle.Font = Enum.Font.GothamMedium
UI.Subtitle.TextColor3 = Config.AccentSecondary
UI.Subtitle.TextSize = 13
UI.Subtitle.BackgroundTransparency = 1
UI.Subtitle.Size = UDim2.new(1, 0, 0, 20)
UI.Subtitle.Position = UDim2.new(0, 0, 0, 50)
UI.Subtitle.TextTransparency = 0.3
UI.Subtitle.ZIndex = 4
UI.Subtitle.Parent = titleContainer

-- ========================================
-- VERSION & STATUS & DISCORD
-- ========================================
UI.Version = Instance.new("TextLabel")
UI.Version.Text = "v5.0 ULTIMATE"
UI.Version.Font = Enum.Font.GothamMedium
UI.Version.TextColor3 = Config.AccentSecondary
UI.Version.TextSize = 10
UI.Version.BackgroundTransparency = 0.1
UI.Version.BackgroundColor3 = Config.BackgroundDark
UI.Version.Size = UDim2.new(0, 85, 0, 22)
UI.Version.Position = UDim2.new(0, 12, 0, 12)
UI.Version.ZIndex = 6
UI.Version.Parent = UI.Frame

local versionCorner = Instance.new("UICorner")
versionCorner.CornerRadius = UDim.new(0, 6)
versionCorner.Parent = UI.Version

local versionBorder = Instance.new("UIStroke")
versionBorder.Color = Config.AccentDim
versionBorder.Thickness = 1
versionBorder.Transparency = 0.7
versionBorder.Parent = UI.Version

UI.DiscordButton = Instance.new("TextButton")
UI.DiscordButton.Text = "Discord"
UI.DiscordButton.Font = Enum.Font.GothamBold
UI.DiscordButton.TextColor3 = Color3.fromRGB(88, 101, 242)
UI.DiscordButton.TextSize = 11
UI.DiscordButton.BackgroundTransparency = 0.1
UI.DiscordButton.BackgroundColor3 = Config.BackgroundDark
UI.DiscordButton.Size = UDim2.new(0, 70, 0, 22)
UI.DiscordButton.Position = UDim2.new(0, 105, 0, 12)
UI.DiscordButton.AutoButtonColor = false
UI.DiscordButton.ZIndex = 6
UI.DiscordButton.Parent = UI.Frame

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 6)
discordCorner.Parent = UI.DiscordButton

local discordBorder = Instance.new("UIStroke")
discordBorder.Color = Color3.fromRGB(88, 101, 242)
discordBorder.Thickness = 1
discordBorder.Transparency = 0.7
discordBorder.Parent = UI.DiscordButton

-- Status Badge
UI.StatusBadge = Instance.new("Frame")
UI.StatusBadge.Size = UDim2.new(0, 80, 0, 22)
UI.StatusBadge.Position = UDim2.new(1, -88, 1, -34)
UI.StatusBadge.BackgroundColor3 = Config.BackgroundDark
UI.StatusBadge.BackgroundTransparency = 0.1
UI.StatusBadge.BorderSizePixel = 0
UI.StatusBadge.ZIndex = 6
UI.StatusBadge.Parent = UI.Frame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = UI.StatusBadge

local statusBorder = Instance.new("UIStroke")
statusBorder.Color = Config.StatusColor
statusBorder.Thickness = 1
statusBorder.Transparency = 0.7
statusBorder.Parent = UI.StatusBadge

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(0, 8, 0.5, -4)
statusDot.BackgroundColor3 = Config.StatusColor
statusDot.BorderSizePixel = 0
statusDot.ZIndex = 7
statusDot.Parent = UI.StatusBadge

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = statusDot

local statusText = Instance.new("TextLabel")
statusText.Text = "ONLINE"
statusText.Font = Enum.Font.GothamBold
statusText.TextColor3 = Config.StatusColor
statusText.TextSize = 11
statusText.BackgroundTransparency = 1
statusText.Size = UDim2.new(1, -20, 1, 0)
statusText.Position = UDim2.new(0, 20, 0, 0)
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.ZIndex = 7
statusText.Parent = UI.StatusBadge

-- Toggle Key Hint (Bottom Left)
local toggleHint = Instance.new("TextLabel")
toggleHint.Text = "Press INSERT to hide"
toggleHint.Font = Enum.Font.GothamMedium
toggleHint.TextColor3 = Config.AccentSecondary
toggleHint.TextSize = 9
toggleHint.BackgroundTransparency = 1
toggleHint.Size = UDim2.new(0, 120, 0, 15)
toggleHint.Position = UDim2.new(0, 12, 1, -20)
toggleHint.TextTransparency = 0.5
toggleHint.TextXAlignment = Enum.TextXAlignment.Left
toggleHint.ZIndex = 6
toggleHint.Parent = UI.Frame

-- ========================================
-- ========================================
-- BUTTONS (Close, Back, Settings, Theme)
-- ========================================
UI.CloseButton = Instance.new("TextButton")
UI.CloseButton.Text = "X"
UI.CloseButton.Font = Enum.Font.GothamBold
UI.CloseButton.TextColor3 = Config.AccentSecondary
UI.CloseButton.TextSize = 18
UI.CloseButton.BackgroundColor3 = Config.BackgroundDark
UI.CloseButton.BackgroundTransparency = 0.3
UI.CloseButton.Size = UDim2.new(0, 36, 0, 36)
UI.CloseButton.Position = UDim2.new(1, -48, 0, 12)
UI.CloseButton.AutoButtonColor = false
UI.CloseButton.ZIndex = 6
UI.CloseButton.Parent = UI.Frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = UI.CloseButton

local closeBorder = Instance.new("UIStroke")
closeBorder.Color = Config.AccentDim
closeBorder.Thickness = 1.5
closeBorder.Transparency = 0.6
closeBorder.Parent = UI.CloseButton

UI.BackButton = Instance.new("TextButton")
UI.BackButton.Text = "←"
UI.BackButton.Font = Enum.Font.GothamBold
UI.BackButton.TextColor3 = Config.AccentSecondary
UI.BackButton.TextSize = 22
UI.BackButton.BackgroundColor3 = Config.BackgroundDark
UI.BackButton.BackgroundTransparency = 0.3
UI.BackButton.Size = UDim2.new(0, 36, 0, 36)
UI.BackButton.Position = UDim2.new(0, 12, 0, 12)
UI.BackButton.Visible = false
UI.BackButton.AutoButtonColor = false
UI.BackButton.ZIndex = 6
UI.BackButton.Parent = UI.Frame

local backCorner = Instance.new("UICorner")
backCorner.CornerRadius = UDim.new(0, 8)
backCorner.Parent = UI.BackButton

local backBorder = Instance.new("UIStroke")
backBorder.Color = Config.AccentDim
backBorder.Thickness = 1.5
backBorder.Transparency = 0.6
backBorder.Parent = UI.BackButton

-- Settings Button
UI.SettingsButton = Instance.new("TextButton")
UI.SettingsButton.Text = "⚙"
UI.SettingsButton.Font = Enum.Font.GothamBold
UI.SettingsButton.TextColor3 = Config.AccentSecondary
UI.SettingsButton.TextSize = 20
UI.SettingsButton.BackgroundColor3 = Config.BackgroundDark
UI.SettingsButton.BackgroundTransparency = 0.3
UI.SettingsButton.Size = UDim2.new(0, 36, 0, 36)
UI.SettingsButton.Position = UDim2.new(1, -92, 0, 12)
UI.SettingsButton.AutoButtonColor = false
UI.SettingsButton.ZIndex = 6
UI.SettingsButton.Parent = UI.Frame

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 8)
settingsCorner.Parent = UI.SettingsButton

local settingsBorder = Instance.new("UIStroke")
settingsBorder.Color = Config.AccentDim
settingsBorder.Thickness = 1.5
settingsBorder.Transparency = 0.6
settingsBorder.Parent = UI.SettingsButton

-- Theme Button
-- ========================================
-- ACTIVATE BUTTON
-- ========================================
UI.ActivateButton = Instance.new("TextButton")
UI.ActivateButton.Text = ""
UI.ActivateButton.BackgroundColor3 = Config.ButtonNormal
UI.ActivateButton.BackgroundTransparency = 0.1
UI.ActivateButton.Position = UDim2.new(0.5, -100, 1, -70)
UI.ActivateButton.Size = UDim2.new(0, 200, 0, 50)
UI.ActivateButton.AutoButtonColor = false
UI.ActivateButton.ZIndex = 5
UI.ActivateButton.Parent = UI.Frame

local activateCorner = Instance.new("UICorner")
activateCorner.CornerRadius = UDim.new(0, 12)
activateCorner.Parent = UI.ActivateButton

local activateBorder = Instance.new("UIStroke")
activateBorder.Color = Config.ButtonNormal
activateBorder.Thickness = 2
activateBorder.Transparency = 0.3
activateBorder.Parent = UI.ActivateButton

local btnGradient = Instance.new("UIGradient")
btnGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 230, 240)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 190, 200))
}
btnGradient.Rotation = 90
btnGradient.Parent = UI.ActivateButton

local btnText = Instance.new("TextLabel")
btnText.Text = "ACTIVATE"
btnText.Font = Enum.Font.GothamBold
btnText.TextColor3 = Config.BackgroundDark
btnText.TextSize = 16
btnText.BackgroundTransparency = 1
btnText.Size = UDim2.new(1, 0, 1, 0)
btnText.ZIndex = 6
btnText.Parent = UI.ActivateButton

-- ========================================
-- CUSTOM CURSOR
-- ========================================
UI.CursorGlow = Instance.new("Frame")
UI.CursorGlow.Size = UDim2.new(0, 18, 0, 18)
UI.CursorGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.CursorGlow.BackgroundTransparency = 0
UI.CursorGlow.BorderSizePixel = 0
UI.CursorGlow.ZIndex = 1000
UI.CursorGlow.AnchorPoint = Vector2.new(0.5, 0.5)
UI.CursorGlow.Parent = gui

local cursorCorner = Instance.new("UICorner")
cursorCorner.CornerRadius = UDim.new(1, 0)
cursorCorner.Parent = UI.CursorGlow

local outerRing = Instance.new("Frame")
outerRing.Size = UDim2.new(0, 28, 0, 28)
outerRing.Position = UDim2.new(0.5, 0, 0.5, 0)
outerRing.AnchorPoint = Vector2.new(0.5, 0.5)
outerRing.BackgroundTransparency = 1
outerRing.ZIndex = 999
outerRing.Parent = UI.CursorGlow

local ringCorner = Instance.new("UICorner")
ringCorner.CornerRadius = UDim.new(1, 0)
ringCorner.Parent = outerRing

local ringStroke = Instance.new("UIStroke")
ringStroke.Color = Color3.fromRGB(255, 255, 255)
ringStroke.Thickness = 1.5
ringStroke.Transparency = 0.6
ringStroke.Parent = outerRing

print(">> CHAINIX: UI elements created successfully")
print(">> Total features loaded: ALL OF THEM! 🔥")

-- ========================================
-- SETTINGS PANEL
-- ========================================
UI.SettingsPanel = Instance.new("Frame")
UI.SettingsPanel.Size = UDim2.new(0, 250, 1, 0)
UI.SettingsPanel.Position = UDim2.new(1, 0, 0, 0)
UI.SettingsPanel.BackgroundColor3 = Config.BackgroundDark
UI.SettingsPanel.BorderSizePixel = 0
UI.SettingsPanel.ZIndex = 20
UI.SettingsPanel.Parent = UI.Frame

local settingsPanelCorner = Instance.new("UICorner")
settingsPanelCorner.CornerRadius = UDim.new(0, 0)
settingsPanelCorner.Parent = UI.SettingsPanel

local settingsPanelBorder = Instance.new("UIStroke")
settingsPanelBorder.Color = Config.BorderLight
settingsPanelBorder.Thickness = 2
settingsPanelBorder.Transparency = 0.7
settingsPanelBorder.Parent = UI.SettingsPanel

-- Settings Title
local settingsTitle = Instance.new("TextLabel")
settingsTitle.Text = "SETTINGS"
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextColor3 = Config.AccentPrimary
settingsTitle.TextSize = 18
settingsTitle.BackgroundTransparency = 1
settingsTitle.Size = UDim2.new(1, 0, 0, 50)
settingsTitle.Position = UDim2.new(0, 0, 0, 10)
settingsTitle.ZIndex = 21
settingsTitle.Parent = UI.SettingsPanel

-- Back button for settings
UI.SettingsBackButton = Instance.new("TextButton")
UI.SettingsBackButton.Text = "×"
UI.SettingsBackButton.Font = Enum.Font.GothamBold
UI.SettingsBackButton.TextColor3 = Config.AccentSecondary
UI.SettingsBackButton.TextSize = 24
UI.SettingsBackButton.BackgroundColor3 = Config.BackgroundMain
UI.SettingsBackButton.BackgroundTransparency = 0.3
UI.SettingsBackButton.Size = UDim2.new(0, 32, 0, 32)
UI.SettingsBackButton.Position = UDim2.new(1, -40, 0, 15)
UI.SettingsBackButton.AutoButtonColor = false
UI.SettingsBackButton.ZIndex = 22
UI.SettingsBackButton.Parent = UI.SettingsPanel

local settingsBackCorner = Instance.new("UICorner")
settingsBackCorner.CornerRadius = UDim.new(0, 8)
settingsBackCorner.Parent = UI.SettingsBackButton

local settingsBackBorder = Instance.new("UIStroke")
settingsBackBorder.Color = Config.AccentDim
settingsBackBorder.Thickness = 1.5
settingsBackBorder.Transparency = 0.6
settingsBackBorder.Parent = UI.SettingsBackButton

-- Volume Setting
local volumeLabel = Instance.new("TextLabel")
volumeLabel.Text = "Volume: 100%"
volumeLabel.Font = Enum.Font.GothamMedium
volumeLabel.TextColor3 = Config.AccentSecondary
volumeLabel.TextSize = 12
volumeLabel.BackgroundTransparency = 1
volumeLabel.Size = UDim2.new(1, -20, 0, 20)
volumeLabel.Position = UDim2.new(0, 10, 0, 70)
volumeLabel.TextXAlignment = Enum.TextXAlignment.Left
volumeLabel.ZIndex = 21
volumeLabel.Parent = UI.SettingsPanel

-- Volume Slider Container
local volumeSliderBG = Instance.new("Frame")
volumeSliderBG.Size = UDim2.new(1, -40, 0, 6)
volumeSliderBG.Position = UDim2.new(0, 20, 0, 100)
volumeSliderBG.BackgroundColor3 = Config.BackgroundMain
volumeSliderBG.BorderSizePixel = 0
volumeSliderBG.ZIndex = 21
volumeSliderBG.Parent = UI.SettingsPanel

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(1, 0)
sliderCorner.Parent = volumeSliderBG

-- Volume Slider Fill
UI.VolumeSliderFill = Instance.new("Frame")
UI.VolumeSliderFill.Size = UDim2.new(1, 0, 1, 0)
UI.VolumeSliderFill.BackgroundColor3 = Config.AccentPrimary
UI.VolumeSliderFill.BorderSizePixel = 0
UI.VolumeSliderFill.ZIndex = 22
UI.VolumeSliderFill.Parent = volumeSliderBG

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = UI.VolumeSliderFill

-- Slider Handle (Knob)
local sliderHandle = Instance.new("TextLabel")
sliderHandle.Size = UDim2.new(0, 16, 0, 16)
sliderHandle.Position = UDim2.new(1, -8, 0.5, -8)
sliderHandle.AnchorPoint = Vector2.new(0.5, 0.5)
sliderHandle.BackgroundColor3 = Config.AccentPrimary
sliderHandle.BorderSizePixel = 0
sliderHandle.ZIndex = 23
sliderHandle.Text = ""
sliderHandle.Parent = volumeSliderBG

local handleCorner = Instance.new("UICorner")
handleCorner.CornerRadius = UDim.new(1, 0)
handleCorner.Parent = sliderHandle

local handleBorder = Instance.new("UIStroke")
handleBorder.Color = Color3.fromRGB(0, 0, 0)
handleBorder.Thickness = 2
handleBorder.Transparency = 0
handleBorder.Parent = sliderHandle

-- Notifications Toggle
local notificationsLabel = Instance.new("TextLabel")
notificationsLabel.Text = "Notifications"
notificationsLabel.Font = Enum.Font.GothamMedium
notificationsLabel.TextColor3 = Config.AccentSecondary
notificationsLabel.TextSize = 12
notificationsLabel.BackgroundTransparency = 1
notificationsLabel.Size = UDim2.new(0.7, 0, 0, 20)
notificationsLabel.Position = UDim2.new(0, 10, 0, 130)
notificationsLabel.TextXAlignment = Enum.TextXAlignment.Left
notificationsLabel.ZIndex = 21
notificationsLabel.Parent = UI.SettingsPanel

UI.NotificationsToggle = Instance.new("TextButton")
UI.NotificationsToggle.Text = "ON"
UI.NotificationsToggle.Font = Enum.Font.GothamBold
UI.NotificationsToggle.TextColor3 = Config.StatusColor
UI.NotificationsToggle.TextSize = 11
UI.NotificationsToggle.BackgroundColor3 = Config.BackgroundMain
UI.NotificationsToggle.Size = UDim2.new(0, 50, 0, 24)
UI.NotificationsToggle.Position = UDim2.new(1, -60, 0, 128)
UI.NotificationsToggle.AutoButtonColor = false
UI.NotificationsToggle.ZIndex = 21
UI.NotificationsToggle.Parent = UI.SettingsPanel

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 6)
notifCorner.Parent = UI.NotificationsToggle

local notifBorder = Instance.new("UIStroke")
notifBorder.Color = Config.StatusColor
notifBorder.Thickness = 1.5
notifBorder.Transparency = 0.5
notifBorder.Parent = UI.NotificationsToggle

-- Theme Selector in Settings
local themeLabel = Instance.new("TextLabel")
themeLabel.Text = "Theme"
themeLabel.Font = Enum.Font.GothamMedium
themeLabel.TextColor3 = Config.AccentSecondary
themeLabel.TextSize = 12
themeLabel.BackgroundTransparency = 1
themeLabel.Size = UDim2.new(0.5, 0, 0, 20)
themeLabel.Position = UDim2.new(0, 10, 0, 165)
themeLabel.TextXAlignment = Enum.TextXAlignment.Left
themeLabel.ZIndex = 21
themeLabel.Parent = UI.SettingsPanel

-- Theme Dropdown Button
local themeDropdown = Instance.new("TextButton")
themeDropdown.Text = "Default Dark  ▼"
themeDropdown.Font = Enum.Font.GothamMedium
themeDropdown.TextColor3 = Config.AccentPrimary
themeDropdown.TextSize = 11
themeDropdown.BackgroundColor3 = Config.BackgroundMain
themeDropdown.Size = UDim2.new(1, -20, 0, 28)
themeDropdown.Position = UDim2.new(0, 10, 0, 190)
themeDropdown.TextXAlignment = Enum.TextXAlignment.Left
themeDropdown.AutoButtonColor = false
themeDropdown.ZIndex = 21
themeDropdown.Parent = UI.SettingsPanel

local dropdownCorner = Instance.new("UICorner")
dropdownCorner.CornerRadius = UDim.new(0, 6)
dropdownCorner.Parent = themeDropdown

local dropdownBorder = Instance.new("UIStroke")
dropdownBorder.Color = Config.AccentDim
dropdownBorder.Thickness = 1.5
dropdownBorder.Transparency = 0.6
dropdownBorder.Parent = themeDropdown

local dropdownPadding = Instance.new("UIPadding")
dropdownPadding.PaddingLeft = UDim.new(0, 10)
dropdownPadding.Parent = themeDropdown

-- Theme Dropdown Menu (hidden by default)
-- Theme Dropdown Menu (hidden by default) - Now with scrolling!
local themeDropdownMenu = Instance.new("ScrollingFrame")
themeDropdownMenu.Size = UDim2.new(1, -20, 0, 0)
themeDropdownMenu.Position = UDim2.new(0, 10, 0, 222)
themeDropdownMenu.BackgroundColor3 = Config.BackgroundDark
themeDropdownMenu.BorderSizePixel = 0
themeDropdownMenu.Visible = false
themeDropdownMenu.ZIndex = 30
themeDropdownMenu.ScrollBarThickness = 6
themeDropdownMenu.ScrollBarImageColor3 = Config.AccentPrimary
themeDropdownMenu.ScrollBarImageTransparency = 0.3
themeDropdownMenu.CanvasSize = UDim2.new(0, 0, 0, 250) -- 8 themes × 30px + padding = 250px
themeDropdownMenu.Parent = UI.SettingsPanel

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 6)
menuCorner.Parent = themeDropdownMenu

local menuBorder = Instance.new("UIStroke")
menuBorder.Color = Config.BorderLight
menuBorder.Thickness = 2
menuBorder.Transparency = 0.7
menuBorder.Parent = themeDropdownMenu

-- Create theme options
local themeNames = {"Default", "Ocean", "Purple", "Matrix", "Ruby", "Gold", "Pink", "Custom"}
local themeButtons = {}
local themeDropdownOpen = false

for i, themeName in ipairs(themeNames) do
	local optionBtn = Instance.new("TextButton")
	optionBtn.Name = themeName
	optionBtn.Text = Themes[themeName].Name
	optionBtn.Font = Enum.Font.GothamMedium
	optionBtn.TextColor3 = Themes[themeName].AccentPrimary
	optionBtn.TextSize = 11
	optionBtn.BackgroundColor3 = Config.BackgroundMain
	optionBtn.BackgroundTransparency = 0.3
	optionBtn.Size = UDim2.new(1, -4, 0, 30)
	optionBtn.Position = UDim2.new(0, 0, 0, (i-1) * 30)
	optionBtn.TextXAlignment = Enum.TextXAlignment.Left
	optionBtn.AutoButtonColor = false
	optionBtn.ZIndex = 31
	optionBtn.Parent = themeDropdownMenu
	
	local optionPadding = Instance.new("UIPadding")
	optionPadding.PaddingLeft = UDim.new(0, 10)
	optionPadding.Parent = optionBtn
	
	table.insert(themeButtons, optionBtn)
end


-- Custom Theme Creator Panel
local customThemePanel = Instance.new("Frame")
customThemePanel.Size = UDim2.new(0, 280, 0, 400)
customThemePanel.Position = UDim2.new(0.5, -140, 0.5, -200)
customThemePanel.BackgroundColor3 = Config.BackgroundDark
customThemePanel.BorderSizePixel = 0
customThemePanel.Visible = false
customThemePanel.ZIndex = 50
customThemePanel.Parent = UI.Frame

local customPanelCorner = Instance.new("UICorner")
customPanelCorner.CornerRadius = UDim.new(0, 12)
customPanelCorner.Parent = customThemePanel

local customPanelBorder = Instance.new("UIStroke")
customPanelBorder.Color = Config.BorderLight
customPanelBorder.Thickness = 2
customPanelBorder.Transparency = 0.5
customPanelBorder.Parent = customThemePanel

-- Title
local customThemeTitle = Instance.new("TextLabel")
customThemeTitle.Text = "CUSTOM THEME CREATOR"
customThemeTitle.Font = Enum.Font.GothamBold
customThemeTitle.TextColor3 = Config.AccentPrimary
customThemeTitle.TextSize = 16
customThemeTitle.BackgroundTransparency = 1
customThemeTitle.Size = UDim2.new(1, -60, 0, 40)
customThemeTitle.Position = UDim2.new(0, 20, 0, 10)
customThemeTitle.TextXAlignment = Enum.TextXAlignment.Left
customThemeTitle.ZIndex = 51
customThemeTitle.Parent = customThemePanel

-- Close button for custom theme panel
local customThemeClose = Instance.new("TextButton")
customThemeClose.Text = "×"
customThemeClose.Font = Enum.Font.GothamBold
customThemeClose.TextColor3 = Config.AccentSecondary
customThemeClose.TextSize = 24
customThemeClose.BackgroundColor3 = Config.BackgroundMain
customThemeClose.BackgroundTransparency = 0.3
customThemeClose.Size = UDim2.new(0, 32, 0, 32)
customThemeClose.Position = UDim2.new(1, -42, 0, 10)
customThemeClose.AutoButtonColor = false
customThemeClose.ZIndex = 51
customThemeClose.Parent = customThemePanel

local customCloseCorner = Instance.new("UICorner")
customCloseCorner.CornerRadius = UDim.new(0, 8)
customCloseCorner.Parent = customThemeClose

-- Color pickers storage
local customColors = {
	Background = Color3.fromRGB(0, 0, 0),
	Accent = Color3.fromRGB(255, 255, 255),
	Status = Color3.fromRGB(50, 200, 100)
}

-- Background Color Picker
local bgLabel = Instance.new("TextLabel")
bgLabel.Text = "Background Color"
bgLabel.Font = Enum.Font.GothamMedium
bgLabel.TextColor3 = Config.AccentSecondary
bgLabel.TextSize = 12
bgLabel.BackgroundTransparency = 1
bgLabel.Size = UDim2.new(1, -40, 0, 20)
bgLabel.Position = UDim2.new(0, 20, 0, 60)
bgLabel.TextXAlignment = Enum.TextXAlignment.Left
bgLabel.ZIndex = 51
bgLabel.Parent = customThemePanel

local bgPicker = Instance.new("Frame")
bgPicker.Size = UDim2.new(1, -40, 0, 80)
bgPicker.Position = UDim2.new(0, 20, 0, 85)
bgPicker.BackgroundColor3 = Config.BackgroundMain
bgPicker.BorderSizePixel = 0
bgPicker.ZIndex = 51
bgPicker.Parent = customThemePanel

local bgPickerCorner = Instance.new("UICorner")
bgPickerCorner.CornerRadius = UDim.new(0, 8)
bgPickerCorner.Parent = bgPicker

-- RGB Sliders for Background
local bgSliders = {}
local colorNames = {"R", "G", "B"}
local colorDefaults = {0, 0, 0}

for i, colorName in ipairs(colorNames) do
	local label = Instance.new("TextLabel")
	label.Text = colorName .. ": 0"
	label.Font = Enum.Font.GothamMedium
	label.TextColor3 = Config.AccentSecondary
	label.TextSize = 10
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(0, 40, 0, 20)
	label.Position = UDim2.new(0, 10, 0, (i-1) * 25 + 5)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 52
	label.Parent = bgPicker
	
	local sliderBG = Instance.new("Frame")
	sliderBG.Size = UDim2.new(1, -60, 0, 6)
	sliderBG.Position = UDim2.new(0, 50, 0, (i-1) * 25 + 12)
	sliderBG.BackgroundColor3 = Config.BackgroundDark
	sliderBG.BorderSizePixel = 0
	sliderBG.ZIndex = 52
	sliderBG.Parent = bgPicker
	
	local sliderCorner = Instance.new("UICorner")
	sliderCorner.CornerRadius = UDim.new(1, 0)
	sliderCorner.Parent = sliderBG
	
	local sliderFill = Instance.new("Frame")
	sliderFill.Size = UDim2.new(0, 0, 1, 0)
	sliderFill.BackgroundColor3 = i == 1 and Color3.fromRGB(255, 0, 0) or i == 2 and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 0, 255)
	sliderFill.BorderSizePixel = 0
	sliderFill.ZIndex = 53
	sliderFill.Parent = sliderBG
	
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = sliderFill
	
	bgSliders[colorName] = {label = label, sliderBG = sliderBG, sliderFill = sliderFill, value = colorDefaults[i]}
end

-- Accent Color Label
local accentLabel = Instance.new("TextLabel")
accentLabel.Text = "Accent Color"
accentLabel.Font = Enum.Font.GothamMedium
accentLabel.TextColor3 = Config.AccentSecondary
accentLabel.TextSize = 12
accentLabel.BackgroundTransparency = 1
accentLabel.Size = UDim2.new(1, -40, 0, 20)
accentLabel.Position = UDim2.new(0, 20, 0, 175)
accentLabel.TextXAlignment = Enum.TextXAlignment.Left
accentLabel.ZIndex = 51
accentLabel.Parent = customThemePanel

-- Accent Color Preview Box
local accentPreview = Instance.new("Frame")
accentPreview.Size = UDim2.new(1, -40, 0, 40)
accentPreview.Position = UDim2.new(0, 20, 0, 200)
accentPreview.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
accentPreview.BorderSizePixel = 0
accentPreview.ZIndex = 51
accentPreview.Parent = customThemePanel

local accentPreviewCorner = Instance.new("UICorner")
accentPreviewCorner.CornerRadius = UDim.new(0, 8)
accentPreviewCorner.Parent = accentPreview

local accentPreviewText = Instance.new("TextLabel")
accentPreviewText.Text = "RGB(255, 255, 255)"
accentPreviewText.Font = Enum.Font.GothamBold
accentPreviewText.TextColor3 = Color3.fromRGB(0, 0, 0)
accentPreviewText.TextSize = 11
accentPreviewText.BackgroundTransparency = 1
accentPreviewText.Size = UDim2.new(1, 0, 1, 0)
accentPreviewText.ZIndex = 52
accentPreviewText.Parent = accentPreview

-- Status Color Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "Status Color"
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextColor3 = Config.AccentSecondary
statusLabel.TextSize = 12
statusLabel.BackgroundTransparency = 1
statusLabel.Size = UDim2.new(1, -40, 0, 20)
statusLabel.Position = UDim2.new(0, 20, 0, 250)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.ZIndex = 51
statusLabel.Parent = customThemePanel

-- Status Color Preview Box
local statusPreview = Instance.new("Frame")
statusPreview.Size = UDim2.new(1, -40, 0, 40)
statusPreview.Position = UDim2.new(0, 20, 0, 275)
statusPreview.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
statusPreview.BorderSizePixel = 0
statusPreview.ZIndex = 51
statusPreview.Parent = customThemePanel

local statusPreviewCorner = Instance.new("UICorner")
statusPreviewCorner.CornerRadius = UDim.new(0, 8)
statusPreviewCorner.Parent = statusPreview

local statusPreviewText = Instance.new("TextLabel")
statusPreviewText.Text = "RGB(50, 200, 100)"
statusPreviewText.Font = Enum.Font.GothamBold
statusPreviewText.TextColor3 = Color3.fromRGB(255, 255, 255)
statusPreviewText.TextSize = 11
statusPreviewText.BackgroundTransparency = 1
statusPreviewText.Size = UDim2.new(1, 0, 1, 0)
statusPreviewText.ZIndex = 52
statusPreviewText.Parent = statusPreview

-- Apply Custom Theme Button
local applyCustomButton = Instance.new("TextButton")
applyCustomButton.Text = "APPLY CUSTOM THEME"
applyCustomButton.Font = Enum.Font.GothamBold
applyCustomButton.TextColor3 = Color3.fromRGB(255, 255, 255)
applyCustomButton.TextSize = 13
applyCustomButton.BackgroundColor3 = Config.AccentPrimary
applyCustomButton.Size = UDim2.new(1, -40, 0, 45)
applyCustomButton.Position = UDim2.new(0, 20, 1, -60)
applyCustomButton.AutoButtonColor = false
applyCustomButton.ZIndex = 51
applyCustomButton.Parent = customThemePanel

local applyCustomCorner = Instance.new("UICorner")
applyCustomCorner.CornerRadius = UDim.new(0, 8)
applyCustomCorner.Parent = applyCustomButton

-- Keybind Setting
local keybindLabel = Instance.new("TextLabel")
keybindLabel.Text = "Toggle Key: INSERT"
keybindLabel.Font = Enum.Font.GothamMedium
keybindLabel.TextColor3 = Config.AccentSecondary
keybindLabel.TextSize = 12
keybindLabel.BackgroundTransparency = 1
keybindLabel.Size = UDim2.new(1, -20, 0, 20)
keybindLabel.Position = UDim2.new(0, 10, 1, -30)
keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
keybindLabel.ZIndex = 21
keybindLabel.Parent = UI.SettingsPanel

-- ========================================
-- CUSTOM THEME CREATOR PANEL
-- ========================================
local customThemePanel = Instance.new("ScrollingFrame")
customThemePanel.Size = UDim2.new(0, 250, 1, 0)
customThemePanel.Position = UDim2.new(1, 0, 0, 0)
customThemePanel.BackgroundColor3 = Config.BackgroundDark
customThemePanel.BorderSizePixel = 0
customThemePanel.Visible = false
customThemePanel.ZIndex = 20
customThemePanel.ScrollBarThickness = 6
customThemePanel.ScrollBarImageColor3 = Config.AccentPrimary
customThemePanel.ScrollBarImageTransparency = 0.3
customThemePanel.CanvasSize = UDim2.new(0, 0, 0, 390)
customThemePanel.Parent = UI.Frame

local customPanelCorner = Instance.new("UICorner")
customPanelCorner.CornerRadius = UDim.new(0, 12)
customPanelCorner.Parent = customThemePanel

local customPanelBorder = Instance.new("UIStroke")
customPanelBorder.Color = Config.BorderLight
customPanelBorder.Thickness = 2
customPanelBorder.Transparency = 0.7
customPanelBorder.Parent = customThemePanel

-- Custom Theme Title
local customTitle = Instance.new("TextLabel")
customTitle.Text = "CUSTOM THEME"
customTitle.Font = Enum.Font.GothamBold
customTitle.TextColor3 = Config.AccentPrimary
customTitle.TextSize = 14
customTitle.BackgroundTransparency = 1
customTitle.Size = UDim2.new(1, -50, 0, 50)
customTitle.Position = UDim2.new(0, 10, 0, 0)
customTitle.TextXAlignment = Enum.TextXAlignment.Left
customTitle.ZIndex = 21
customTitle.Parent = customThemePanel

-- Custom Theme Back Button
local customBackButton = Instance.new("TextButton")
customBackButton.Text = "×"
customBackButton.Font = Enum.Font.GothamBold
customBackButton.TextColor3 = Config.AccentSecondary
customBackButton.TextSize = 24
customBackButton.BackgroundColor3 = Config.BackgroundMain
customBackButton.BackgroundTransparency = 0.3
customBackButton.Size = UDim2.new(0, 32, 0, 32)
customBackButton.Position = UDim2.new(1, -40, 0, 15)
customBackButton.AutoButtonColor = false
customBackButton.ZIndex = 22
customBackButton.Parent = customThemePanel

local customBackCorner = Instance.new("UICorner")
customBackCorner.CornerRadius = UDim.new(0, 8)
customBackCorner.Parent = customBackButton

-- Color Picker Helper Function
local function createColorPicker(name, yPos, defaultColor)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, -20, 0, 85)
	container.Position = UDim2.new(0, 10, 0, yPos)
	container.BackgroundTransparency = 1
	container.ZIndex = 21
	container.Parent = customThemePanel
	
	local label = Instance.new("TextLabel")
	label.Text = name
	label.Font = Enum.Font.GothamMedium
	label.TextColor3 = Config.AccentSecondary
	label.TextSize = 11
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, 0, 0, 20)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 21
	label.Parent = container
	
	-- Color preview (bigger)
	local colorPreview = Instance.new("Frame")
	colorPreview.Size = UDim2.new(1, 0, 0, 25)
	colorPreview.Position = UDim2.new(0, 0, 0, 18)
	colorPreview.BackgroundColor3 = defaultColor
	colorPreview.BorderSizePixel = 0
	colorPreview.ZIndex = 22
	colorPreview.Parent = container
	
	local previewCorner = Instance.new("UICorner")
	previewCorner.CornerRadius = UDim.new(0, 6)
	previewCorner.Parent = colorPreview
	
	local previewBorder = Instance.new("UIStroke")
	previewBorder.Color = Color3.fromRGB(255, 255, 255)
	previewBorder.Thickness = 2
	previewBorder.Transparency = 0.5
	previewBorder.Parent = colorPreview
	
	-- Color wheel (preset colors in a grid)
	local colors = {
		Color3.fromRGB(255, 0, 0),     -- Red
		Color3.fromRGB(255, 128, 0),   -- Orange
		Color3.fromRGB(255, 255, 0),   -- Yellow
		Color3.fromRGB(128, 255, 0),   -- Lime
		Color3.fromRGB(0, 255, 0),     -- Green
		Color3.fromRGB(0, 255, 128),   -- Cyan-Green
		Color3.fromRGB(0, 255, 255),   -- Cyan
		Color3.fromRGB(0, 128, 255),   -- Sky Blue
		Color3.fromRGB(0, 0, 255),     -- Blue
		Color3.fromRGB(128, 0, 255),   -- Purple
		Color3.fromRGB(255, 0, 255),   -- Magenta
		Color3.fromRGB(255, 0, 128),   -- Pink
		Color3.fromRGB(255, 255, 255), -- White
		Color3.fromRGB(180, 180, 180), -- Light Gray
		Color3.fromRGB(100, 100, 100), -- Gray
		Color3.fromRGB(0, 0, 0),       -- Black
	}
	
	local colorButtons = {}
	for i, color in ipairs(colors) do
		local colorBtn = Instance.new("TextButton")
		colorBtn.Size = UDim2.new(0, 20, 0, 20)
		colorBtn.Position = UDim2.new((i-1) % 8 * 0.125, 1, math.floor((i-1) / 8) * 24, 48)
		colorBtn.BackgroundColor3 = color
		colorBtn.BorderSizePixel = 0
		colorBtn.Text = ""
		colorBtn.AutoButtonColor = false
		colorBtn.ZIndex = 22
		colorBtn.Parent = container
		
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(1, 0)
		btnCorner.Parent = colorBtn
		
		local btnBorder = Instance.new("UIStroke")
		btnBorder.Color = Color3.fromRGB(255, 255, 255)
		btnBorder.Thickness = 1
		btnBorder.Transparency = 0.7
		btnBorder.Parent = colorBtn
		
		table.insert(colorButtons, {button = colorBtn, color = color})
	end
	
	return {container = container, preview = colorPreview, buttons = colorButtons, selectedColor = defaultColor}
end

-- Create Color Pickers
local backgroundPicker = createColorPicker("Background Color", 60, Config.BackgroundMain)
local accentPicker = createColorPicker("Accent Color", 150, Config.AccentPrimary)
local statusPicker = createColorPicker("Status Color", 240, Config.StatusColor)

-- Save Custom Theme Button
local saveCustomButton = Instance.new("TextButton")
saveCustomButton.Text = "DONE"
saveCustomButton.Font = Enum.Font.GothamBold
saveCustomButton.TextColor3 = Config.AccentPrimary
saveCustomButton.TextSize = 13
saveCustomButton.BackgroundColor3 = Config.BackgroundMain
saveCustomButton.BackgroundTransparency = 0.2
saveCustomButton.Size = UDim2.new(1, -20, 0, 40)
saveCustomButton.Position = UDim2.new(0, 10, 0, 335)
saveCustomButton.AutoButtonColor = false
saveCustomButton.ZIndex = 22
saveCustomButton.Parent = customThemePanel

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 8)
saveCorner.Parent = saveCustomButton

local saveBorder = Instance.new("UIStroke")
saveBorder.Color = Config.AccentPrimary
saveBorder.Thickness = 2
saveBorder.Transparency = 0.3
saveBorder.Parent = saveCustomButton

-- ========================================
-- NOTIFICATION CONTAINER
-- ========================================
UI.NotificationContainer = Instance.new("Frame")
UI.NotificationContainer.Size = UDim2.new(0, 300, 0, 400)
UI.NotificationContainer.Position = UDim2.new(1, -320, 0, 20)
UI.NotificationContainer.BackgroundTransparency = 1
UI.NotificationContainer.ZIndex = 50
UI.NotificationContainer.Parent = gui

-- ========================================
-- SEARCH BAR (for game menu)
-- ========================================
UI.SearchBar = Instance.new("TextBox")
UI.SearchBar.PlaceholderText = "Search games..."
UI.SearchBar.Text = ""
UI.SearchBar.Font = Enum.Font.GothamMedium
UI.SearchBar.TextColor3 = Config.AccentPrimary
UI.SearchBar.PlaceholderColor3 = Config.AccentSecondary
UI.SearchBar.TextSize = 12
UI.SearchBar.BackgroundColor3 = Config.BackgroundDark
UI.SearchBar.BackgroundTransparency = 0.3
UI.SearchBar.Size = UDim2.new(1, -24, 0, 32)
UI.SearchBar.Position = UDim2.new(0, 12, 0, 50)
UI.SearchBar.Visible = false
UI.SearchBar.ClearTextOnFocus = false
UI.SearchBar.ZIndex = 6
UI.SearchBar.Parent = UI.Frame

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 8)
searchCorner.Parent = UI.SearchBar

local searchBorder = Instance.new("UIStroke")
searchBorder.Color = Config.AccentDim
searchBorder.Thickness = 1.5
searchBorder.Transparency = 0.6
searchBorder.Parent = UI.SearchBar

print(">> CHAINIX: Settings panel, theme selector, and notifications ready!")

-- ========================================
-- ANIMATION FUNCTIONS
-- ========================================
local function startBackgroundAnimation()
	task.spawn(function()
		while animatedBG.Parent do
			for i = 45, 135, 1 do
				gradient.Rotation = i
				task.wait(0.05)
			end
			for i = 135, 45, -1 do
				gradient.Rotation = i
				task.wait(0.05)
			end
		end
	end)
end

local function startParticleSpawning()
	task.spawn(function()
		while particlesContainer.Parent do
			createParticle()
			task.wait(math.random(50, 150) / 100)
		end
	end)
end

local function pulseStatusDot()
	task.spawn(function()
		while statusDot.Parent do
			Utils.CreateTween(statusDot, 1, {BackgroundTransparency = 0.3}, Enum.EasingStyle.Sine):Play()
			task.wait(1)
			Utils.CreateTween(statusDot, 1, {BackgroundTransparency = 0}, Enum.EasingStyle.Sine):Play()
			task.wait(1)
		end
	end)
end

local function pulseBorder()
	task.spawn(function()
		while UI.Frame.Parent do
			Utils.CreateTween(UI.OuterBorder, 3, {Transparency = 0.7}, Enum.EasingStyle.Sine):Play()
			task.wait(3)
			Utils.CreateTween(UI.OuterBorder, 3, {Transparency = 0.9}, Enum.EasingStyle.Sine):Play()
			task.wait(3)
		end
	end)
end

local function pulseCursor()
	task.spawn(function()
		while UI.CursorGlow.Parent do
			Utils.CreateTween(outerRing, 1.5, {Size = UDim2.new(0, 34, 0, 34)}, Enum.EasingStyle.Sine):Play()
			Utils.CreateTween(ringStroke, 1.5, {Transparency = 0.8}, Enum.EasingStyle.Sine):Play()
			task.wait(1.5)
			Utils.CreateTween(outerRing, 1.5, {Size = UDim2.new(0, 28, 0, 28)}, Enum.EasingStyle.Sine):Play()
			Utils.CreateTween(ringStroke, 1.5, {Transparency = 0.5}, Enum.EasingStyle.Sine):Play()
			task.wait(1.5)
		end
	end)
end

-- ========================================
-- NOTIFICATION SYSTEM
-- ========================================
function Utils.ShowNotification(message, duration)
	if not SavedData.Settings.NotificationsEnabled then return end
	
	duration = duration or 3
	
	local notif = Instance.new("Frame")
	notif.Size = UDim2.new(1, 0, 0, 60)
	notif.Position = UDim2.new(0, 0, 0, 0)
	notif.BackgroundColor3 = Config.BackgroundDark
	notif.BackgroundTransparency = 1
	notif.BorderSizePixel = 0
	notif.ZIndex = 51
	
	local notifCorner = Instance.new("UICorner")
	notifCorner.CornerRadius = UDim.new(0, 10)
	notifCorner.Parent = notif
	
	local notifBorder = Instance.new("UIStroke")
	notifBorder.Color = Config.AccentPrimary
	notifBorder.Thickness = 2
	notifBorder.Transparency = 1
	notifBorder.Parent = notif
	
	local notifText = Instance.new("TextLabel")
	notifText.Text = message
	notifText.Font = Enum.Font.GothamMedium
	notifText.TextColor3 = Config.AccentPrimary
	notifText.TextSize = 12
	notifText.BackgroundTransparency = 1
	notifText.Size = UDim2.new(1, -20, 1, 0)
	notifText.Position = UDim2.new(0, 10, 0, 0)
	notifText.TextWrapped = true
	notifText.TextTransparency = 1
	notifText.ZIndex = 52
	notifText.Parent = notif
	
	-- Shift existing notifications down
	for _, child in ipairs(UI.NotificationContainer:GetChildren()) do
		if child:IsA("Frame") then
			Utils.CreateTween(child, 0.3, {Position = child.Position + UDim2.new(0, 0, 0, 65)}):Play()
		end
	end
	
	notif.Parent = UI.NotificationContainer
	
	-- Fade in
	Utils.CreateTween(notif, 0.3, {BackgroundTransparency = 0.1}):Play()
	Utils.CreateTween(notifBorder, 0.3, {Transparency = 0.6}):Play()
	Utils.CreateTween(notifText, 0.3, {TextTransparency = 0}):Play()
	
	-- Fade out after duration
	task.spawn(function()
		task.wait(duration)
		Utils.CreateTween(notif, 0.3, {BackgroundTransparency = 1}):Play()
		Utils.CreateTween(notifBorder, 0.3, {Transparency = 1}):Play()
		Utils.CreateTween(notifText, 0.3, {TextTransparency = 1}):Play()
		task.wait(0.3)
		notif:Destroy()
	end)
	
	Utils.PlaySound(Config.Sounds.Hover, 0.4, 1.2, 1)
end

-- ========================================
-- THEME SWITCHING
-- ========================================
local function applyTheme(themeName)
	print(">> CHAINIX: Attempting to apply theme: " .. tostring(themeName))
	
	local theme = Themes[themeName]
	if not theme then 
		warn(">> CHAINIX ERROR: Theme '" .. tostring(themeName) .. "' not found!")
		return 
	end
	
	print(">> CHAINIX: Found theme: " .. theme.Name)
	
	-- Store non-color properties before theme switch
	local frameSizeBackup = Config.FrameSize
	local framePosBackup = Config.FramePosition
	local soundsBackup = Config.Sounds
	local framesBackup = Config.ChainFrames
	local gridBackup = Config.GridColumns
	local btnWidthBackup = Config.ButtonWidth
	local btnHeightBackup = Config.ButtonHeight
	local spacingXBackup = Config.ButtonSpacingX
	local spacingYBackup = Config.ButtonSpacingY
	
	print(">> CHAINIX: Backed up non-color properties")
	
	-- Apply ONLY color properties from theme
	Config.BackgroundDark = theme.BackgroundDark
	Config.BackgroundMain = theme.BackgroundMain
	Config.AccentPrimary = theme.AccentPrimary
	Config.AccentSecondary = theme.AccentSecondary
	Config.AccentDim = theme.AccentDim
	Config.BorderLight = theme.BorderLight
	Config.ButtonNormal = theme.ButtonNormal
	Config.ButtonHover = theme.ButtonHover
	Config.StatusColor = theme.StatusColor
	
	print(">> CHAINIX: Applied color properties")
	
	-- Restore non-color properties
	Config.FrameSize = frameSizeBackup
	Config.FramePosition = framePosBackup
	Config.Sounds = soundsBackup
	Config.ChainFrames = framesBackup
	Config.GridColumns = gridBackup
	Config.ButtonWidth = btnWidthBackup
	Config.ButtonHeight = btnHeightBackup
	Config.ButtonSpacingX = spacingXBackup
	Config.ButtonSpacingY = spacingYBackup
	
	print(">> CHAINIX: Restored non-color properties")
	
	-- Update all UI colors
	animatedBG.BackgroundColor3 = Config.BackgroundMain
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Config.BackgroundMain),
		ColorSequenceKeypoint.new(0.5, Config.BackgroundDark),
		ColorSequenceKeypoint.new(1, Config.BackgroundMain)
	}
	
	UI.OuterBorder.Color = Config.BorderLight
	accentLine.BackgroundColor3 = Config.AccentPrimary
	UI.Title.TextColor3 = Config.AccentPrimary
	UI.Subtitle.TextColor3 = Config.AccentSecondary
	UI.Logo.ImageColor3 = Config.AccentPrimary
	
	statusBorder.Color = Config.StatusColor
	statusDot.BackgroundColor3 = Config.StatusColor
	statusText.TextColor3 = Config.StatusColor
	
	activateBorder.Color = Config.ButtonNormal
	btnGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(math.clamp(Config.ButtonNormal.R*255 + 20, 0, 255), math.clamp(Config.ButtonNormal.G*255 + 20, 0, 255), math.clamp(Config.ButtonNormal.B*255 + 20, 0, 255))),
		ColorSequenceKeypoint.new(1, Config.ButtonNormal)
	}
	
	-- Update all buttons
	UI.CloseButton.BackgroundColor3 = Config.BackgroundDark
	UI.CloseButton.TextColor3 = Config.AccentSecondary
	UI.SettingsButton.BackgroundColor3 = Config.BackgroundDark
	UI.SettingsButton.TextColor3 = Config.AccentSecondary
	UI.BackButton.BackgroundColor3 = Config.BackgroundDark
	UI.BackButton.TextColor3 = Config.AccentSecondary
	
	-- Update settings panel
	UI.SettingsPanel.BackgroundColor3 = Config.BackgroundDark
	volumeLabel.TextColor3 = Config.AccentSecondary
	UI.VolumeSliderFill.BackgroundColor3 = Config.AccentPrimary
	sliderHandle.BackgroundColor3 = Config.AccentPrimary
	volumeSliderBG.BackgroundColor3 = Config.BackgroundMain
	
	notificationsLabel.TextColor3 = Config.AccentSecondary
	UI.NotificationsToggle.BackgroundColor3 = Config.BackgroundMain
	
	themeLabel.TextColor3 = Config.AccentSecondary
	themeDropdown.BackgroundColor3 = Config.BackgroundMain
	themeDropdown.TextColor3 = Config.AccentPrimary
	themeDropdownMenu.BackgroundColor3 = Config.BackgroundDark
	themeDropdownMenu.ScrollBarImageColor3 = Config.AccentPrimary
	
	keybindLabel.TextColor3 = Config.AccentSecondary
	
	-- Update version badge
	UI.Version.TextColor3 = Config.AccentSecondary
	
	-- Update discord button
	UI.DiscordButton.BackgroundColor3 = Config.BackgroundDark
	UI.DiscordButton.TextColor3 = Config.AccentSecondary
	
	-- Update search bar
	UI.SearchBar.TextColor3 = Config.AccentPrimary
	UI.SearchBar.PlaceholderColor3 = Config.AccentSecondary
	UI.SearchBar.BackgroundColor3 = Config.BackgroundMain
	
	print(">> CHAINIX: Updated all UI colors")
	
	SavedData.Settings.Theme = themeName
	Utils.ShowNotification("Theme changed to " .. theme.Name .. "! ✅", 2)
	
	print(">> CHAINIX: Theme change complete! ✅")
end

-- ========================================
-- SETTINGS PANEL FUNCTIONS
-- ========================================
local function toggleSettingsPanel()
	settingsPanelOpen = not settingsPanelOpen
	
	if settingsPanelOpen then
		Utils.CreateTween(UI.SettingsPanel, 0.3, {Position = UDim2.new(1, -250, 0, 0)}):Play()
		Utils.ShowNotification("Settings opened ⚙️", 1.5)
	else
		Utils.CreateTween(UI.SettingsPanel, 0.3, {Position = UDim2.new(1, 0, 0, 0)}):Play()
	end
	
	Utils.PlaySound(Config.Sounds.Click, 0.5, 1, 1)
end

local function toggleNotifications()
	SavedData.Settings.NotificationsEnabled = not SavedData.Settings.NotificationsEnabled
	
	if SavedData.Settings.NotificationsEnabled then
		UI.NotificationsToggle.Text = "ON"
		UI.NotificationsToggle.TextColor3 = Config.StatusColor
		notifBorder.Color = Config.StatusColor
		Utils.ShowNotification("Notifications enabled! 🔔", 2)
	else
		UI.NotificationsToggle.Text = "OFF"
		UI.NotificationsToggle.TextColor3 = Color3.fromRGB(200, 80, 80)
		notifBorder.Color = Color3.fromRGB(200, 80, 80)
	end
	
	Utils.PlaySound(Config.Sounds.Click, 0.5, 1, 1)
end

-- ========================================
-- THEME PANEL FUNCTIONS
-- ========================================
-- BUTTON HOVER EFFECTS
-- ========================================
local function setupActivateButton()
	local hoverIn = Utils.CreateTween(UI.ActivateButton, 0.25, {
		Size = UDim2.new(0, 210, 0, 52),
		BackgroundColor3 = Config.ButtonHover,
		BackgroundTransparency = 0
	})
	local hoverOut = Utils.CreateTween(UI.ActivateButton, 0.25, {
		Size = UDim2.new(0, 200, 0, 50),
		BackgroundColor3 = Config.ButtonNormal,
		BackgroundTransparency = 0.1
	})
	local glowIn = Utils.CreateTween(activateBorder, 0.25, {Transparency = 0, Thickness = 3})
	local glowOut = Utils.CreateTween(activateBorder, 0.25, {Transparency = 0.3, Thickness = 2})
	local textIn = Utils.CreateTween(btnText, 0.25, {TextColor3 = Color3.fromRGB(0, 0, 0)})
	local textOut = Utils.CreateTween(btnText, 0.25, {TextColor3 = Config.BackgroundDark})
	
	UI.ActivateButton.MouseEnter:Connect(function()
		hoverIn:Play()
		glowIn:Play()
		textIn:Play()
		Utils.PlaySound(Config.Sounds.Hover, 0.2, 1.3, 1)
	end)
	
	UI.ActivateButton.MouseLeave:Connect(function()
		hoverOut:Play()
		glowOut:Play()
		textOut:Play()
	end)
end

local function setupCloseButton()
	local hoverIn = Utils.CreateTween(UI.CloseButton, 0.2, {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0,
		TextColor3 = Color3.fromRGB(255, 50, 50)
	})
	local hoverOut = Utils.CreateTween(UI.CloseButton, 0.2, {
		BackgroundColor3 = Config.BackgroundDark,
		BackgroundTransparency = 0.3,
		TextColor3 = Config.AccentSecondary
	})
	
	UI.CloseButton.MouseEnter:Connect(function()
		hoverIn:Play()
		Utils.PlaySound(Config.Sounds.Hover, 0.2, 1.3, 1)
	end)
	
	UI.CloseButton.MouseLeave:Connect(function()
		hoverOut:Play()
	end)
end

local function setupBackButton()
	local hoverIn = Utils.CreateTween(UI.BackButton, 0.2, {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0,
		TextColor3 = Config.BackgroundDark
	})
	local hoverOut = Utils.CreateTween(UI.BackButton, 0.2, {
		BackgroundColor3 = Config.BackgroundDark,
		BackgroundTransparency = 0.3,
		TextColor3 = Config.AccentSecondary
	})
	
	UI.BackButton.MouseEnter:Connect(function()
		hoverIn:Play()
	end)
	
	UI.BackButton.MouseLeave:Connect(function()
		hoverOut:Play()
	end)
end

local function setupDiscordButton()
	local hoverIn = Utils.CreateTween(UI.DiscordButton, 0.2, {
		BackgroundColor3 = Color3.fromRGB(88, 101, 242),
		BackgroundTransparency = 0,
		TextColor3 = Color3.fromRGB(255, 255, 255)
	})
	local hoverOut = Utils.CreateTween(UI.DiscordButton, 0.2, {
		BackgroundColor3 = Config.BackgroundDark,
		BackgroundTransparency = 0.1,
		TextColor3 = Color3.fromRGB(88, 101, 242)
	})
	
	UI.DiscordButton.MouseEnter:Connect(function()
		hoverIn:Play()
		Utils.PlaySound(Config.Sounds.Hover, 0.2, 1.3, 1)
	end)
	
	UI.DiscordButton.MouseLeave:Connect(function()
		hoverOut:Play()
	end)
	
	UI.DiscordButton.MouseButton1Click:Connect(function()
		Utils.PlaySound(Config.Sounds.Click, 0.6, 1.1, 1)
		setclipboard("https://discord.gg/uc3ywyJM7B")
		Utils.ShowNotification("Discord link copied! 💬", 2)
	end)
end

local function setupSettingsButton()
	-- Hover effect for main settings button
	local settingsHoverIn = Utils.CreateTween(UI.SettingsButton, 0.2, {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0,
		TextColor3 = Config.AccentPrimary
	})
	local settingsHoverOut = Utils.CreateTween(UI.SettingsButton, 0.2, {
		BackgroundColor3 = Config.BackgroundDark,
		BackgroundTransparency = 0.3,
		TextColor3 = Config.AccentSecondary
	})
	local settingsGlowIn = Utils.CreateTween(settingsBorder, 0.2, {Transparency = 0, Thickness = 2})
	local settingsGlowOut = Utils.CreateTween(settingsBorder, 0.2, {Transparency = 0.6, Thickness = 1.5})
	
	UI.SettingsButton.MouseEnter:Connect(function()
		settingsHoverIn:Play()
		settingsGlowIn:Play()
		Utils.PlaySound(Config.Sounds.Hover, 0.2, 1.3, 1)
	end)
	
	UI.SettingsButton.MouseLeave:Connect(function()
		settingsHoverOut:Play()
		settingsGlowOut:Play()
	end)
	
	UI.SettingsButton.MouseButton1Click:Connect(toggleSettingsPanel)
	
	-- Settings back button
	UI.SettingsBackButton.MouseButton1Click:Connect(toggleSettingsPanel)
	
	-- Hover effect for settings back button
	local backHoverIn = Utils.CreateTween(UI.SettingsBackButton, 0.2, {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0,
		TextColor3 = Color3.fromRGB(255, 50, 50)
	})
	local backHoverOut = Utils.CreateTween(UI.SettingsBackButton, 0.2, {
		BackgroundColor3 = Config.BackgroundMain,
		BackgroundTransparency = 0.3,
		TextColor3 = Config.AccentSecondary
	})
	
	UI.SettingsBackButton.MouseEnter:Connect(function()
		backHoverIn:Play()
		Utils.PlaySound(Config.Sounds.Hover, 0.2, 1.3, 1)
	end)
	
	UI.SettingsBackButton.MouseLeave:Connect(function()
		backHoverOut:Play()
	end)
end


-- Setup theme buttons
-- Theme dropdown toggle
themeDropdown.MouseButton1Click:Connect(function()
	themeDropdownOpen = not themeDropdownOpen
	
	if themeDropdownOpen then
		themeDropdown.Text = themeDropdown.Text:gsub("▼", "▲")
		Utils.CreateTween(themeDropdownMenu, 0.2, {Size = UDim2.new(1, -20, 0, 120)}):Play()
		themeDropdownMenu.Visible = true
	else
		themeDropdown.Text = themeDropdown.Text:gsub("▲", "▼")
		Utils.CreateTween(themeDropdownMenu, 0.2, {Size = UDim2.new(1, -20, 0, 0)}):Play()
		task.wait(0.2)
		themeDropdownMenu.Visible = false
	end
	
	Utils.PlaySound(Config.Sounds.Click, 0.4, 1.1, 1)
end)

-- Theme option clicks
for _, themeBtn in ipairs(themeButtons) do
	-- Hover effect
	themeBtn.MouseEnter:Connect(function()
		Utils.CreateTween(themeBtn, 0.15, {BackgroundTransparency = 0}):Play()
	end)
	
	themeBtn.MouseLeave:Connect(function()
		Utils.CreateTween(themeBtn, 0.15, {BackgroundTransparency = 0.3}):Play()
	end)
	
	-- Click to select theme
	themeBtn.MouseButton1Click:Connect(function()
		-- If Custom theme, open custom theme creator
		if themeBtn.Name == "Custom" then
			-- Close dropdown
			themeDropdownOpen = false
			Utils.CreateTween(themeDropdownMenu, 0.2, {Size = UDim2.new(1, -20, 0, 0)}):Play()
			themeDropdownMenu.Visible = false
			
			-- Close settings panel
			settingsPanelOpen = false
			Utils.CreateTween(UI.SettingsPanel, 0.3, {Position = UDim2.new(1, 0, 0, 0)}):Play()
			
			-- Open custom theme panel
			customThemePanel.Visible = true
			Utils.CreateTween(customThemePanel, 0.3, {Position = UDim2.new(1, -250, 0, 0)}):Play()
			Utils.PlaySound(Config.Sounds.Click, 0.5, 1, 1)
		else
			-- Normal theme selection
			applyTheme(themeBtn.Name)
			
			-- Update dropdown text
			themeDropdown.Text = Themes[themeBtn.Name].Name .. "  ▼"
			
			-- Close dropdown
			themeDropdownOpen = false
			Utils.CreateTween(themeDropdownMenu, 0.2, {Size = UDim2.new(1, -20, 0, 0)}):Play()
			task.wait(0.2)
			themeDropdownMenu.Visible = false
			
			Utils.PlaySound(Config.Sounds.Click, 0.5, 1, 1)
		end
	end)
end

-- Setup toggles
UI.NotificationsToggle.MouseButton1Click:Connect(toggleNotifications)

-- Custom Theme Creator functionality
-- Back button to close custom theme panel
customBackButton.MouseButton1Click:Connect(function()
	Utils.CreateTween(customThemePanel, 0.3, {Position = UDim2.new(1, 0, 0, 0)}):Play()
	task.wait(0.3)
	customThemePanel.Visible = false
	Utils.PlaySound(Config.Sounds.Click, 0.5, 1, 1)
end)

-- Color slider functionality
local function setupColorButtons(picker)
	for _, colorData in ipairs(picker.buttons) do
		colorData.button.MouseButton1Click:Connect(function()
			picker.selectedColor = colorData.color
			picker.preview.BackgroundColor3 = colorData.color
			Utils.PlaySound(Config.Sounds.Click, 0.3, 1.2, 1)
		end)
	end
end

setupColorButtons(backgroundPicker)
setupColorButtons(accentPicker)
setupColorButtons(statusPicker)

-- Save custom theme button
saveCustomButton.MouseButton1Click:Connect(function()
	-- Get selected colors from buttons
	local bgColor = backgroundPicker.selectedColor
	local acColor = accentPicker.selectedColor
	local stColor = statusPicker.selectedColor
	
	-- Update Custom theme
	Themes.Custom.BackgroundDark = Color3.fromRGB(
		math.max(0, bgColor.R * 255 - 10),
		math.max(0, bgColor.G * 255 - 10),
		math.max(0, bgColor.B * 255 - 10)
	)
	Themes.Custom.BackgroundMain = bgColor
	Themes.Custom.AccentPrimary = acColor
	Themes.Custom.AccentSecondary = Color3.fromRGB(
		math.min(255, acColor.R * 255 + 50),
		math.min(255, acColor.G * 255 + 50),
		math.min(255, acColor.B * 255 + 50)
	)
	Themes.Custom.AccentDim = Color3.fromRGB(
		math.max(0, acColor.R * 255 - 50),
		math.max(0, acColor.G * 255 - 50),
		math.max(0, acColor.B * 255 - 50)
	)
	Themes.Custom.BorderLight = acColor
	Themes.Custom.ButtonNormal = acColor
	Themes.Custom.ButtonHover = Color3.fromRGB(
		math.min(255, acColor.R * 255 + 20),
		math.min(255, acColor.G * 255 + 20),
		math.min(255, acColor.B * 255 + 20)
	)
	Themes.Custom.StatusColor = stColor
	
	-- Apply the custom theme
	applyTheme("Custom")
	
	-- Update dropdown to show Custom
	themeDropdown.Text = "Custom Theme  ▼"
	
	-- Close custom panel
	Utils.CreateTween(customThemePanel, 0.3, {Position = UDim2.new(1, 0, 0, 0)}):Play()
	task.wait(0.3)
	customThemePanel.Visible = false
	
	Utils.ShowNotification("Custom theme applied! ✨", 2)
	Utils.PlaySound(Config.Sounds.Click, 0.7, 1.2, 1)
end)



-- Volume slider functionality
local volumeDragging = false

volumeSliderBG.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		volumeDragging = true
		
		local function updateVolume(inputPos)
			local sliderPos = volumeSliderBG.AbsolutePosition.X
			local sliderSize = volumeSliderBG.AbsoluteSize.X
			local mouseX = inputPos.X
			
			local percent = math.clamp((mouseX - sliderPos) / sliderSize, 0, 1)
			local volume = math.floor(percent * 100)
			
			SavedData.Settings.Volume = volume
			UI.VolumeSliderFill.Size = UDim2.new(percent, 0, 1, 0)
			sliderHandle.Position = UDim2.new(percent, 0, 0.5, 0)
			volumeLabel.Text = "Volume: " .. volume .. "%"
		end
		
		updateVolume(input.Position)
		
		local connection
		connection = UserInputService.InputChanged:Connect(function(input2)
			if input2.UserInputType == Enum.UserInputType.MouseMovement and volumeDragging then
				updateVolume(input2.Position)
			end
		end)
		
		local endConnection
		endConnection = UserInputService.InputEnded:Connect(function(input3)
			if input3.UserInputType == Enum.UserInputType.MouseButton1 then
				volumeDragging = false
				connection:Disconnect()
				endConnection:Disconnect()
				Utils.PlaySound(Config.Sounds.Click, 0.5, 1, 1)
			end
		end)
	end
end)

volumeSliderBG.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement and volumeDragging then
		local sliderPos = volumeSliderBG.AbsolutePosition.X
		local sliderSize = volumeSliderBG.AbsoluteSize.X
		local mouseX = input.Position.X
		
		local percent = math.clamp((mouseX - sliderPos) / sliderSize, 0, 1)
		local volume = math.floor(percent * 100)
		
		SavedData.Settings.Volume = volume
		UI.VolumeSliderFill.Size = UDim2.new(percent, 0, 1, 0)
		sliderHandle.Position = UDim2.new(percent, 0, 0.5, 0)
		volumeLabel.Text = "Volume: " .. volume .. "%"
	end
end)

print(">> CHAINIX: All interactive functions loaded!")
print(">> Settings, themes, notifications ready!")

-- ========================================
-- GAME MENU FUNCTIONS
-- ========================================
local function isFavorite(gameName)
	for _, name in ipairs(SavedData.Favorites) do
		if name == gameName then return true end
	end
	return false
end

local function toggleFavorite(gameName)
	if isFavorite(gameName) then
		for i, name in ipairs(SavedData.Favorites) do
			if name == gameName then
				table.remove(SavedData.Favorites, i)
				Utils.ShowNotification("Removed from favorites! ⭐", 2)
				break
			end
		end
	else
		table.insert(SavedData.Favorites, gameName)
		Utils.ShowNotification("Added to favorites! ⭐", 2)
	end
end

local function addToRecentlyUsed(gameName)
	-- Remove if already in list
	for i, name in ipairs(SavedData.RecentlyUsed) do
		if name == gameName then
			table.remove(SavedData.RecentlyUsed, i)
			break
		end
	end
	
	-- Add to front
	table.insert(SavedData.RecentlyUsed, 1, gameName)
	
	-- Keep only last 3
	while #SavedData.RecentlyUsed > 3 do
		table.remove(SavedData.RecentlyUsed)
	end
end

local function createGameButton(info, index)
	local col = (index - 1) % Config.GridColumns
	local row = math.floor((index - 1) / Config.GridColumns)
	
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, Config.ButtonWidth, 0, Config.ButtonHeight)
	button.Position = UDim2.new(
		0, 
		20 + col * (Config.ButtonWidth + Config.ButtonSpacingX), 
		0, 
		95 + row * (Config.ButtonHeight + Config.ButtonSpacingY)
	)
	button.BackgroundColor3 = info.available and Config.ButtonNormal or Config.AccentDim
	button.BackgroundTransparency = info.available and 0.1 or 0.5
	button.Text = ""
	button.AutoButtonColor = false
	button.ZIndex = 5
	button.Parent = UI.Frame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = button
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = info.available and Config.BorderLight or Config.AccentDim
	stroke.Thickness = 1.5
	stroke.Transparency = info.available and 0.3 or 0.7
	stroke.Parent = button
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Text = info.name
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextColor3 = info.available and Config.BackgroundDark or Config.AccentSecondary
	nameLabel.TextSize = 11
	nameLabel.BackgroundTransparency = 1
	nameLabel.Size = UDim2.new(1, -10, 1, 0)
	nameLabel.Position = UDim2.new(0, 5, 0, 0)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Center
	nameLabel.TextYAlignment = Enum.TextYAlignment.Center
	nameLabel.TextTransparency = info.available and 0 or 0.4
	nameLabel.ZIndex = 6
	nameLabel.Parent = button
	
	if info.available then
		-- Favorite star
		local starBtn = Instance.new("TextButton")
		starBtn.Text = isFavorite(info.name) and "⭐" or "☆"
		starBtn.Font = Enum.Font.GothamBold
		starBtn.TextSize = 14
		starBtn.BackgroundTransparency = 1
		starBtn.Size = UDim2.new(0, 20, 0, 20)
		starBtn.Position = UDim2.new(1, -22, 0, 2)
		starBtn.ZIndex = 7
		starBtn.Parent = button
		
		starBtn.MouseButton1Click:Connect(function()
			toggleFavorite(info.name)
			starBtn.Text = isFavorite(info.name) and "⭐" or "☆"
			Utils.PlaySound(Config.Sounds.Click, 0.4, 1.2, 1)
		end)
		
		-- Hover effects
		local hoverIn = Utils.CreateTween(button, 0.2, {
			Size = UDim2.new(0, Config.ButtonWidth + 4, 0, Config.ButtonHeight + 2),
			BackgroundColor3 = Config.ButtonHover,
			BackgroundTransparency = 0
		})
		local hoverOut = Utils.CreateTween(button, 0.2, {
			Size = UDim2.new(0, Config.ButtonWidth, 0, Config.ButtonHeight),
			BackgroundColor3 = Config.ButtonNormal,
			BackgroundTransparency = 0.1
		})
		local textIn = Utils.CreateTween(nameLabel, 0.2, {TextColor3 = Color3.fromRGB(0, 0, 0)})
		local textOut = Utils.CreateTween(nameLabel, 0.2, {TextColor3 = Config.BackgroundDark})
		
		button.MouseEnter:Connect(function()
			Utils.PlaySound(Config.Sounds.Hover, 0.3, 1.4, 1)
			hoverIn:Play()
			textIn:Play()
			
			-- Show info tooltip
			if info.description then
				Utils.ShowNotification(info.name .. "\n" .. info.description, 2)
			end
		end)
		
		button.MouseLeave:Connect(function()
			hoverOut:Play()
			textOut:Play()
		end)
		
		button.MouseButton1Click:Connect(function()
			Utils.PlaySound(Config.Sounds.Click, 0.6, 0.9, 1)
			print(">> CHAINIX: Loading " .. info.name)
			
			addToRecentlyUsed(info.name)
			Utils.ShowNotification("Loading " .. info.name .. "... ⏳", 2)
			
			local flash = Instance.new("Frame")
			flash.Size = UDim2.new(1, 0, 1, 0)
			flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			flash.BackgroundTransparency = 0
			flash.BorderSizePixel = 0
			flash.ZIndex = 10
			flash.Parent = button
			
			local flashCorner = Instance.new("UICorner")
			flashCorner.CornerRadius = UDim.new(0, 10)
			flashCorner.Parent = flash
			
			Utils.CreateTween(flash, 0.3, {BackgroundTransparency = 1}):Play()
			Debris:AddItem(flash, 0.3)
			
			task.wait(0.5)
			
			local success, err = pcall(function()
				if info.script then
					-- Load embedded script
					loadstring(info.script)()
				elseif info.url ~= "" then
					-- Load from URL
					loadstring(game:HttpGet(info.url))()
				else
					error("No script or URL provided")
				end
			end)
			
			if success then
				Utils.ShowNotification(info.name .. " loaded successfully! ✅", 3)
				
				-- Unload CHAINIX completely
				task.wait(0.5)
				gui:Destroy()
				print(">> CHAINIX: Unloaded - " .. info.name .. " is now running")
			else
				warn("CHAINIX Error: " .. tostring(err))
				Utils.ShowNotification("Failed to load " .. info.name .. " ❌", 3)
			end
		end)
	end
	
	table.insert(gameButtons, button)
end

local function showGameMenu()
	print(">> CHAINIX: Activation triggered")
	
	-- Create loading bar
	local loadingContainer = Instance.new("Frame")
	loadingContainer.Size = UDim2.new(0, 300, 0, 6)
	loadingContainer.Position = UDim2.new(0.5, -150, 0.5, 30)
	loadingContainer.BackgroundColor3 = Config.BackgroundDark
	loadingContainer.BackgroundTransparency = 0.3
	loadingContainer.BorderSizePixel = 0
	loadingContainer.ZIndex = 11
	loadingContainer.Parent = UI.Frame
	
	local loadingCorner = Instance.new("UICorner")
	loadingCorner.CornerRadius = UDim.new(1, 0)
	loadingCorner.Parent = loadingContainer
	
	local loadingBar = Instance.new("Frame")
	loadingBar.Size = UDim2.new(0, 0, 1, 0)
	loadingBar.BackgroundColor3 = Config.AccentPrimary
	loadingBar.BorderSizePixel = 0
	loadingBar.ZIndex = 12
	loadingBar.Parent = loadingContainer
	
	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(1, 0)
	barCorner.Parent = loadingBar
	
	local loadingText = Instance.new("TextLabel")
	loadingText.Text = "LOADING..."
	loadingText.Font = Enum.Font.GothamBold
	loadingText.TextColor3 = Config.AccentPrimary
	loadingText.TextSize = 12
	loadingText.BackgroundTransparency = 1
	loadingText.Size = UDim2.new(0, 300, 0, 20)
	loadingText.Position = UDim2.new(0.5, -150, 0.5, 8)
	loadingText.TextTransparency = 0.3
	loadingText.ZIndex = 11
	loadingText.Parent = UI.Frame
	
	local percentText = Instance.new("TextLabel")
	percentText.Text = "0%"
	percentText.Font = Enum.Font.GothamBold
	percentText.TextColor3 = Config.AccentSecondary
	percentText.TextSize = 11
	percentText.BackgroundTransparency = 1
	percentText.Size = UDim2.new(0, 50, 0, 20)
	percentText.Position = UDim2.new(0.5, -25, 0.5, 40)
	percentText.ZIndex = 11
	percentText.Parent = UI.Frame
	
	-- Animate loading bar independently
	task.spawn(function()
		Utils.CreateTween(loadingBar, 1, {Size = UDim2.new(1, 0, 1, 0)}, Enum.EasingStyle.Sine):Play()
		
		for i = 0, 100 do
			percentText.Text = i .. "%"
			task.wait(0.01)
		end
		
		task.wait(0.2)
		Utils.CreateTween(loadingContainer, 0.2, {BackgroundTransparency = 1}):Play()
		Utils.CreateTween(loadingBar, 0.2, {BackgroundTransparency = 1}):Play()
		Utils.CreateTween(loadingText, 0.2, {TextTransparency = 1}):Play()
		Utils.CreateTween(percentText, 0.2, {TextTransparency = 1}):Play()
		task.wait(0.2)
		loadingContainer:Destroy()
		loadingText:Destroy()
		percentText:Destroy()
	end)
	
	Utils.PlaySound(Config.Sounds.ChainBreak, 0.7, 1, 2)
	
	-- Chain animation
	for i, frameId in ipairs(Config.ChainFrames) do
		UI.Logo.Image = frameId
		if i == #Config.ChainFrames then
			task.wait(0.15)
		else
			task.wait(0.1)
		end
	end
	
	-- Flash
	local flash = Instance.new("Frame")
	flash.Size = UDim2.new(1, 0, 1, 0)
	flash.BackgroundColor3 = Color3.fromRGB(240, 245, 250)
	flash.BackgroundTransparency = 0.6
	flash.BorderSizePixel = 0
	flash.ZIndex = 10
	flash.Parent = UI.Frame
	
	local flashIn = Utils.CreateTween(flash, 0.12, {BackgroundTransparency = 0.2})
	local flashOut = Utils.CreateTween(flash, 0.25, {BackgroundTransparency = 1})
	flashIn:Play()
	flashIn.Completed:Connect(function()
		flashOut:Play()
	end)
	Debris:AddItem(flash, 0.4)
	
	task.wait(0.25)
	
	-- Title change
	Utils.CreateTween(UI.Title, 0.18, {TextTransparency = 1}):Play()
	task.wait(0.18)
	UI.Title.Text = "SELECT GAME"
	UI.Title.TextSize = 26
	UI.Title.Position = UDim2.new(0, 0, 0, 18)
	Utils.CreateTween(UI.Title, 0.25, {TextTransparency = 0}):Play()
	
	-- Fade elements
	Utils.CreateTween(UI.LogoBG, 0.22, {BackgroundTransparency = 1}):Play()
	Utils.CreateTween(UI.Logo, 0.22, {ImageTransparency = 1}):Play()
	Utils.CreateTween(UI.Subtitle, 0.22, {TextTransparency = 1}):Play()
	
	task.wait(0.22)
	
	UI.ActivateButton.Visible = false
	UI.CloseButton.Visible = false
	UI.BackButton.Visible = true
	UI.Version.Visible = false
	UI.DiscordButton.Visible = false
	UI.SettingsButton.Visible = false
	UI.SearchBar.Visible = true
	
	task.wait(0.35)
	
	Utils.PlaySound(Config.Sounds.GameClick, 0.7, 1, 3)
	Utils.ShowNotification("Choose your script! 🎮", 2)
	
	task.wait(0.12)
	
	-- Show favorites first, then rest
	local sortedGames = {}
	for _, info in ipairs(GameList) do
		if info.available and isFavorite(info.name) then
			table.insert(sortedGames, info)
		end
	end
	for _, info in ipairs(GameList) do
		if not isFavorite(info.name) then
			table.insert(sortedGames, info)
		end
	end
	
	for i, gameInfo in ipairs(sortedGames) do
		createGameButton(gameInfo, i)
		task.wait(0.035)
	end
end

local function hideGameMenu()
	Utils.PlaySound(Config.Sounds.Click, 0.6, 1, 1)
	
	-- Title change
	Utils.CreateTween(UI.Title, 0.18, {TextTransparency = 1}):Play()
	task.wait(0.18)
	UI.Title.Text = "CHAINIX"
	UI.Title.TextSize = 48
	UI.Title.Position = UDim2.new(0, 0, 0, 0)
	Utils.CreateTween(UI.Title, 0.25, {TextTransparency = 0}):Play()
	
	for _, button in ipairs(gameButtons) do
		Utils.CreateTween(button, 0.18, {BackgroundTransparency = 1}):Play()
		task.wait(0.025)
		button:Destroy()
	end
	gameButtons = {}
	
	UI.Logo.Image = Config.ChainFrames[1]
	Utils.CreateTween(UI.Logo, 0.35, {ImageTransparency = 0.15}):Play()
	Utils.CreateTween(UI.Subtitle, 0.35, {TextTransparency = 0.3}):Play()
	
	UI.ActivateButton.Visible = true
	UI.CloseButton.Visible = true
	UI.BackButton.Visible = false
	UI.Version.Visible = true
	UI.DiscordButton.Visible = true
	UI.SettingsButton.Visible = true
	UI.SearchBar.Visible = false
	UI.SearchBar.Text = ""
end

-- Search functionality
UI.SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
	local query = UI.SearchBar.Text:lower()
	
	for _, button in ipairs(gameButtons) do
		local gameName = button:FindFirstChild("TextLabel")
		if gameName then
			local matches = gameName.Text:lower():find(query, 1, true)
			button.Visible = (query == "" or matches ~= nil)
		end
	end
end)

print(">> CHAINIX: Game menu functions loaded!")
print(">> Favorites, search, recently used ready!")

-- ========================================
-- CURSOR TRACKING
-- ========================================
local function setupCursorGlow()
	local mouse = game:GetService("Players").LocalPlayer:GetMouse()
	
	RunService.RenderStepped:Connect(function()
		UI.CursorGlow.Position = UDim2.new(0, mouse.X, 0, mouse.Y)
	end)
end

-- ========================================
-- DRAGGABLE FUNCTIONALITY
-- ========================================
local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
	local delta = input.Position - dragStart
	UI.Frame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
	shadowFrame1.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X - 10,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y - 10
	)
	shadowFrame2.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X - 5,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y - 5
	)
end

local function setupDragging()
	UI.Frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			-- Don't drag if clicking on settings panel, volume slider, or custom theme panel
			if settingsPanelOpen or customThemePanel.Visible then
				return
			end
			
			dragging = true
			dragStart = input.Position
			startPos = UI.Frame.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	UI.Frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			updateDrag(input)
		end
	end)
end

-- ========================================
-- KEYBIND SYSTEM
-- ========================================
local keybindConnection

local function setupKeybind()
	keybindConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		
		if input.KeyCode == SavedData.Settings.ToggleKey then
			loaderVisible = not loaderVisible
			
			if loaderVisible then
				Utils.CreateTween(UI.Frame, 0.3, {Position = Config.FramePosition}):Play()
				Utils.CreateTween(shadowFrame1, 0.3, {BackgroundTransparency = 0.92}):Play()
				Utils.CreateTween(shadowFrame2, 0.3, {BackgroundTransparency = 0.88}):Play()
				Utils.ShowNotification("Loader opened! 🔓", 1.5)
			else
				Utils.CreateTween(UI.Frame, 0.3, {Position = UDim2.new(0.5, -250, 1.5, 0)}):Play()
				Utils.CreateTween(shadowFrame1, 0.3, {BackgroundTransparency = 1}):Play()
				Utils.CreateTween(shadowFrame2, 0.3, {BackgroundTransparency = 1}):Play()
			end
			
			Utils.PlaySound(Config.Sounds.Click, 0.5, 1, 1)
		end
	end)
end

-- ========================================
-- INITIALIZATION
-- ========================================
local function initializeUI()
	Utils.PlaySound(Config.Sounds.Boot, 0.8, 1, 3)
	task.wait(0.2)
	Utils.PlaySound(Config.Sounds.Scrape, 0.5, 1, 3)
	
	-- Fade in
	Utils.CreateTween(UI.Frame, 1, {BackgroundTransparency = 0}):Play()
	Utils.CreateTween(shadowFrame1, 1, {BackgroundTransparency = 0.92}):Play()
	Utils.CreateTween(shadowFrame2, 1, {BackgroundTransparency = 0.88}):Play()
	Utils.CreateTween(UI.OuterBorder, 1, {Transparency = 0.85}):Play()
	
	Utils.ShowNotification("CHAINIX ULTIMATE v5.0 loaded! 🔥", 3)
	Utils.ShowNotification("Press INSERT to toggle loader 🔑", 3)
end

-- ========================================
-- EVENT CONNECTIONS
-- ========================================
UI.CloseButton.MouseButton1Click:Connect(function()
	Utils.PlaySound(Config.Sounds.Click, 0.6, 1, 1)
	Utils.ShowNotification("Closing CHAINIX... 👋", 2)
	
	-- Disconnect keybind listener
	if keybindConnection then
		keybindConnection:Disconnect()
		keybindConnection = nil
		print(">> CHAINIX: Keybind disconnected")
	end
	
	task.wait(0.5)
	Utils.CreateTween(UI.Frame, 0.25, {BackgroundTransparency = 1}):Play()
	Utils.CreateTween(shadowFrame1, 0.25, {BackgroundTransparency = 1}):Play()
	Utils.CreateTween(shadowFrame2, 0.25, {BackgroundTransparency = 1}):Play()
	Utils.CreateTween(UI.OuterBorder, 0.25, {Transparency = 1}):Play()
	task.wait(0.25)
	gui:Destroy()
	print(">> CHAINIX: Fully unloaded!")
end)

UI.ActivateButton.MouseButton1Click:Connect(showGameMenu)
UI.BackButton.MouseButton1Click:Connect(hideGameMenu)

-- ========================================
-- STARTUP SEQUENCE
-- ========================================
setupActivateButton()
setupCloseButton()
setupBackButton()
setupDiscordButton()
setupSettingsButton()
setupDragging()
setupCursorGlow()
setupKeybind()

-- Start all animations
startBackgroundAnimation()
startParticleSpawning()
pulseStatusDot()
pulseBorder()
pulseCursor()

-- Initialize
initializeUI()

-- ========================================
-- FINAL MESSAGES
-- ========================================
print("=" .. string.rep("=", 60))
print(">> CHAINIX ULTIMATE EDITION v5.0 - FULLY LOADED!")
print("=" .. string.rep("=", 60))
print(">> ✅ ALL FEATURES ENABLED:")
print(">>    🎨 5 Themes (Default, Ocean, Purple, Matrix, Ruby, Gold)")
print(">>    ⚙️  Settings Panel (Volume, Animations, Notifications)")
print(">>    ⌨️  Keybind System (Press INSERT to toggle)")
print(">>    ⭐ Favorites System")
print(">>    🔍 Search Bar")
print(">>    📊 Sound Visualizer")
print(">>    🟢 Status Indicator")
print(">>    ✨ Floating Particles")
print(">>    🌊 Animated Background")
print(">>    🔔 Notification System")
print(">>    📱 Discord Integration")
print(">>    💎 Loading Bar")
print(">>    🎯 Recently Used")
print(">>    ℹ️  Info Tooltips")
print(">>    🖱️  Custom Cursor")
print(">>    🎮 12 Game Slots")
print("=" .. string.rep("=", 60))
print(">> THIS IS THE MOST FEATURE-RICH LOADER EVER! 🔥")
print("=" .. string.rep("=", 60))

