local Succ, Error = pcall(function()
repeat wait() until game:IsLoaded()
if string.find(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, "Starscape:") then
--=============================================================

-- Services
local CGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local WS = game:GetService("Workspace")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local RunS = game:GetService("RunService")

-- Setup
local GUIName = "Starscape GUI"
if CGui:FindFirstChild(GUIName) then
	CGui:FindFirstChild(GUIName):Destroy()
end
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
local GUI = Lib.new(GUIName)

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui
local Sounds = RS.Sounds
local SoundGood = Sounds.Raid.Update
local SoundBad = Sounds.Raid.Stage
local Minerals = {"Korrelite (inferior)","Korrelite","Korrelite (superior)","Korrelite (pristine)","Reknite (inferior)","Reknite","Reknite (superior)","Reknite (pristine)","Gellium","Gellium (superior)","Gellium (pristine)","Axnit","Axnit (pristine)","Narcor","Red Narcor","Vexnium"}
local MouseUnlock = false

-- Settings
local DefSettings = {
	PlayerTog = true,
	PlayerNotif = true,
	PlayerRange = 40000,
	PlayerBounty = 1000,
	NPCTog = true,
	NPCRange = 14000,
	AsteroidTog = true,
	AsteroidRange = 10000,
	ContainerTog = true,
	RemoveContainerMarker = true,
	ContainerRange = 10000,
	UpdaterDelay = .5,
	PlayerESPSize = 100,
	NPCESPSize = 100,
	AsteroidESPSize = 100,
	ContainerESPSize = 100,
	ToggleUIBind = Enum.KeyCode.K,
	UIState = true,
	ToggleMouseUnlock = Enum.KeyCode.RightAlt,
	ToggleAutoWarp = Enum.KeyCode.J,
	AutoWarp = false,
	MouseUnlockOpenUI = true
}
function TableToString(tbl)
    local result = "{"
    for k, v in pairs(tbl) do
        if type(k) == "string" then
            result = result.."[\""..k.."\"]".."="
        end
        if type(v) == "table" then
            result = result..TableToString(v)
        elseif type(v) == "boolean" then
            result = result..tostring(v)
		elseif type(v) == "number" then
            result = result..tostring(v)
		elseif type(v) == "userdata" then
            result = result..tostring(v)
        else
            result = result.."\""..v.."\""
        end
        result = result..","
    end
    if result ~= "" then
        result = result:sub(1, result:len()-1)
    end
    return result.."}"
end
local FileName = "VickStarscapeGUISettings.txt"
local function SaveSettings(Sett)
	local Str = TableToString(Sett)
	writefile(FileName,Str)
end
if not isfile(FileName) then
	SaveSettings(DefSettings)
end
local Settings = loadstring("return "..readfile(FileName))()

-- Create marker folders
local FGUI = CGui:FindFirstChild(GUIName)
local PlayerFolder = Instance.new("Folder")
PlayerFolder.Parent = FGUI
PlayerFolder.Name = "PlayerMarkers"
local NPCFolder = Instance.new("Folder")
NPCFolder.Parent = FGUI
NPCFolder.Name = "NPCMarkers"
local AsteroidFolder = Instance.new("Folder")
AsteroidFolder.Parent = FGUI
AsteroidFolder.Name = "AsteroidMarkers"
local ContainerFolder = Instance.new("Folder")
ContainerFolder.Parent = FGUI
ContainerFolder.Name = "ContainerMarkers"

-- Functions
local function GetDistance(Pos)
    local Char = Player.Character or Player.CharacterAdded:Wait()
    if Char then
        return math.floor((Char:WaitForChild("HumanoidRootPart").Position - Pos).Magnitude)
    end
    return 0
end

local function Notif(Title, Desc, Bad)
	GUI:Notify(Title,Desc)
	if Bad then
		SoundBad:Play()
	else
		SoundGood:Play()
	end
end

local function waitUntilTimeout(event, timeout)
    local signal = RbxUtility.CreateSignal()
    local conn = nil
    conn = event:Connect(function(...)
        conn:Disconnect()
        signal:fire(...)
    end)

    delay(timeout, function()
        if (conn ~= nil) then
            conn:Disconnect()
            conn = nil
            signal:fire(nil)
        end
    end)

    return signal:wait()
end

local function MarkerUpdater(MGUI)
	while FGUI and MGUI do
		if MGUI.Adornee then
			local CurDist = GetDistance(MGUI.Dist.Parent.Adornee.Position)
			if MGUI.Name == "PlayerMarker" then
				MGUI.Size = UDim2.new(0, Settings.PlayerESPSize, 0, Settings.PlayerESPSize)
				if CurDist <= Settings.PlayerRange and Settings.PlayerTog == true then
					MGUI.Enabled = true
					MGUI.Dist.Text = CurDist
				else
					MGUI.Enabled = false
				end
			elseif MGUI.Name == "NPCMarker" then
				MGUI.Size = UDim2.new(0, Settings.NPCESPSize, 0, Settings.NPCESPSize)
				if CurDist <= Settings.NPCRange and Settings.NPCTog == true then
					MGUI.Enabled = true
					MGUI.Dist.Text = CurDist
				else
					MGUI.Enabled = false
				end
			elseif MGUI.Name == "AsteroidMarker" then
				MGUI.Size = UDim2.new(0, Settings.AsteroidESPSize, 0, Settings.AsteroidESPSize)
				if CurDist <= Settings.AsteroidRange and Settings.AsteroidTog == true then
					MGUI.Enabled = true
					MGUI.Dist.Text = CurDist
				else
					MGUI.Enabled = false
				end
			elseif MGUI.Name == "ContainerMarker" then
				MGUI.Size = UDim2.new(0, Settings.ContainerESPSize, 0, Settings.ContainerESPSize)
				MGUI.Marker.ImageColor3 = MGUI.Adornee.Parent.Hull.Lights.Part.Color
				if CurDist <= Settings.ContainerRange and Settings.ContainerTog == true and not (Settings.RemoveContainerMarker == true and #MGUI.Adornee.Parent.Contents:GetChildren() == 0) then
					MGUI.Enabled = true
					MGUI.Dist.Text = CurDist
				else
					MGUI.Enabled = false
				end
			end
		elseif MGUI.Name == "PlayerMarker" then
			for i,v in pairs(Players:GetChildren()) do
				if MGUI.PlrName.Text == v.Name then
					local Char = v.Character or waitUntilTimeout(v.CharacterAdded, 10)
					if Char then
						MGUI.Adornee = Char:WaitForChild("HumanoidRootPart")
					end
					break
				end
			end
			if not MGUI.Adornee then
				MGUI:Destroy()
				break
			end
		else
			MGUI:Destroy()
			break
		end
		wait(Settings.UpdaterDelay)
	end
end

local function GetMineralNum(Mineral)
    local Num = 0
    local PGui = Player.PlayerGui
    local Trackers = PGui.Trackers.Flight.Trackers
    for i,v in pairs(Trackers:GetChildren()) do
        local Label = v:FindFirstChild("Label")
        if Label and v.Label.Text == Mineral then
            Num = Num + 1
        end
    end
    return Num
end

local function SetModal(State)
	for i,v in pairs(FGUI:GetDescendants()) do
		if v:IsA("ImageButton") or v:IsA("TextButton") then
			v.Modal = State
		end
	end
end

local function CreatePlayerMarker(TargPlayer)
	local PData = TargPlayer.PublicData
	local PlayerMarker = Instance.new("BillboardGui")
	local Marker = Instance.new("ImageLabel")
	local PlrName = Instance.new("TextLabel")
	local Bounty = Instance.new("ImageLabel")
	local Dist = Instance.new("TextLabel")

	PlayerMarker.Name = "PlayerMarker"
	PlayerMarker.Parent = PlayerFolder
	PlayerMarker.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	PlayerMarker.Active = true
	PlayerMarker.AlwaysOnTop = true
	PlayerMarker.LightInfluence = 1.000
	PlayerMarker.Size = UDim2.new(0, Settings.PlayerESPSize, 0, Settings.PlayerESPSize)
	local Char = TargPlayer.Character
	if Char then
		PlayerMarker.Adornee = Char.HumanoidRootPart
	end
	if Settings.PlayerTog == false then
		PlayerMarker.Enabled = false
	end

	Marker.Name = "Marker"
	Marker.Parent = PlayerMarker
	Marker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Marker.BackgroundTransparency = 1.000
	Marker.Position = UDim2.new(0.300000012, 0, 0.300000012, 0)
	Marker.Size = UDim2.new(0.400000006, 0, 0.400000006, 0)
	Marker.Image = "rbxassetid://7268197516"
	local Afil = PData.Affiliation
	if Afil.Value == "Kavani" then
		Marker.ImageColor3 = Color3.fromRGB(52, 227, 25)
	elseif Afil.Value == "Lycentian" then
		Marker.ImageColor3 = Color3.fromRGB(4, 131, 227)
	elseif Afil.Value == "Foralkan" then
		Marker.ImageColor3 = Color3.fromRGB(167, 28, 28)
	end

	PlrName.Name = "PlrName"
	PlrName.Parent = PlayerMarker
	PlrName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	PlrName.BackgroundTransparency = 1.000
	PlrName.Position = UDim2.new(-0.5, 0, 0.100000001, 0)
	PlrName.Size = UDim2.new(2, 0, 0.200000003, 0)
	PlrName.Font = Enum.Font.GothamBold
	PlrName.Text = TargPlayer.Name
	PlrName.TextColor3 = Color3.fromRGB(255, 255, 255)
	PlrName.TextScaled = true
	PlrName.TextSize = 14.000
	PlrName.TextStrokeTransparency = 0.800
	PlrName.TextWrapped = true

	Bounty.Name = "Bounty"
	Bounty.Parent = PlayerMarker
	Bounty.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Bounty.BackgroundTransparency = 1.000
	Bounty.Position = UDim2.new(0.75, 0, 0.375, 0)
	Bounty.Size = UDim2.new(0.25, 0, 0.25, 0)
	Bounty.Visible = false
	if PData.Bounty.Value >= Settings.PlayerBounty then
		Bounty.Visible = true
	end
	Bounty.Image = "rbxassetid://7245682360"
	Bounty.ImageColor3 = Color3.fromRGB(255, 0, 0)

	Dist.Name = "Dist"
	Dist.Parent = PlayerMarker
	Dist.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Dist.BackgroundTransparency = 1.000
	Dist.Position = UDim2.new(-0.5, 0, 0.699999988, 0)
	Dist.Size = UDim2.new(2, 0, 0.200000003, 0)
	Dist.Font = Enum.Font.GothamBold
	Dist.Text = "0"
	if Char then
		Dist.Text = GetDistance(Char.HumanoidRootPart.Position)
	end
	Dist.TextColor3 = Color3.fromRGB(255, 255, 255)
	Dist.TextScaled = true
	Dist.TextSize = 14.000
	Dist.TextStrokeTransparency = 0.800
	Dist.TextWrapped = true
	
	spawn(function()
		MarkerUpdater(PlayerMarker)
	end)
end
local function CreateNPCMarker(Ship)
	local NPCMarker = Instance.new("BillboardGui")
	local Marker = Instance.new("ImageLabel")
	local NPCName = Instance.new("TextLabel")
	local Dist = Instance.new("TextLabel")

	NPCMarker.Name = "NPCMarker"
	NPCMarker.Parent = NPCFolder
	NPCMarker.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	NPCMarker.Active = true
	NPCMarker.AlwaysOnTop = true
	NPCMarker.LightInfluence = 1.000
	NPCMarker.Size = UDim2.new(0, Settings.NPCESPSize, 0, Settings.NPCESPSize)
	NPCMarker.Adornee = Ship.PrimaryPart
	local Afil = Ship.npc.faction
	if Afil.Value == "Kavani" then
		Marker.ImageColor3 = Color3.fromRGB(52, 227, 25)
	elseif Afil.Value == "Lycentian" then
		Marker.ImageColor3 = Color3.fromRGB(4, 131, 227)
	elseif Afil.Value == "Foralkan" then
		Marker.ImageColor3 = Color3.fromRGB(167, 28, 28)
	elseif Afil.Value == "Drones" or Afil.Value == "Pirates" then
		Marker.ImageColor3 = Color3.fromRGB(255,0,0)
	end
	if Settings.NPCTog == false then
		NPCMarker.Enabled = false
	end

	Marker.Name = "Marker"
	Marker.Parent = NPCMarker
	Marker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Marker.BackgroundTransparency = 1.000
	Marker.Position = UDim2.new(0.300000012, 0, 0.300000012, 0)
	Marker.Size = UDim2.new(0.400000006, 0, 0.400000006, 0)
	Marker.Image = "rbxassetid://2866597030"

	NPCName.Name = "NPCName"
	NPCName.Parent = NPCMarker
	NPCName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NPCName.BackgroundTransparency = 1.000
	NPCName.Position = UDim2.new(-0.5, 0, 0.100000001, 0)
	NPCName.Size = UDim2.new(2, 0, 0.200000003, 0)
	NPCName.Font = Enum.Font.GothamBold
	NPCName.Text = Ship.npc.faction.Value.." "..Ship.ship.chassis.Value
	NPCName.TextColor3 = Color3.fromRGB(255, 255, 255)
	NPCName.TextScaled = true
	NPCName.TextSize = 14.000
	NPCName.TextStrokeTransparency = 0.800
	NPCName.TextWrapped = true

	Dist.Name = "Dist"
	Dist.Parent = NPCMarker
	Dist.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Dist.BackgroundTransparency = 1.000
	Dist.Position = UDim2.new(-0.5, 0, 0.699999988, 0)
	Dist.Size = UDim2.new(2, 0, 0.200000003, 0)
	Dist.Font = Enum.Font.GothamBold
	Dist.Text = GetDistance(Ship.PrimaryPart.Position)
	Dist.TextColor3 = Color3.fromRGB(255, 255, 255)
	Dist.TextScaled = true
	Dist.TextSize = 14.000
	Dist.TextStrokeTransparency = 0.800
	Dist.TextWrapped = true
	
	spawn(function()
		MarkerUpdater(NPCMarker)
	end)
end
local function CreateAsteroidMarker(Rock)
	local AsteroidMarker = Instance.new("BillboardGui")
	local Marker = Instance.new("ImageLabel")
	local Dist = Instance.new("TextLabel")
	local Superior = Instance.new("ImageLabel")
	local Pristine = Instance.new("ImageLabel")

	AsteroidMarker.Name = "AsteroidMarker"
	AsteroidMarker.Parent = AsteroidFolder
	AsteroidMarker.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	AsteroidMarker.Active = true
	AsteroidMarker.AlwaysOnTop = true
	AsteroidMarker.LightInfluence = 1.000
	AsteroidMarker.Size = UDim2.new(0, Settings.AsteroidESPSize, 0, Settings.AsteroidESPSize)
	AsteroidMarker.Adornee = Rock
	if Settings.AsteroidTog == false then
		AsteroidMarker.Enabled = false
	end

	Marker.Name = "Marker"
	Marker.Parent = AsteroidMarker
	Marker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Marker.BackgroundTransparency = 1.000
	Marker.Position = UDim2.new(0.300000012, 0, 0.300000012, 0)
	Marker.Size = UDim2.new(0.400000006, 0, 0.400000006, 0)
	Marker.Image = "rbxassetid://5412272324"
	Marker.ImageColor3 = Rock.Parent.Mineral.Color

	Dist.Name = "Dist"
	Dist.Parent = AsteroidMarker
	Dist.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Dist.BackgroundTransparency = 1.000
	Dist.Position = UDim2.new(-0.5, 0, 0.699999988, 0)
	Dist.Size = UDim2.new(2, 0, 0.200000003, 0)
	Dist.Font = Enum.Font.GothamBold
	Dist.Text = GetDistance(Rock.Position)
	Dist.TextColor3 = Color3.fromRGB(255, 255, 255)
	Dist.TextScaled = true
	Dist.TextSize = 14.000
	Dist.TextStrokeTransparency = 0.800
	Dist.TextWrapped = true

	Superior.Name = "Superior"
	Superior.Parent = AsteroidMarker
	Superior.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Superior.BackgroundTransparency = 1.000
	Superior.Position = UDim2.new(0.75, 0, 0.375, 0)
	Superior.Size = UDim2.new(0.25, 0, 0.25, 0)
	Superior.Visible = false
	if Rock.Parent.Mineral.Material == Enum.Material.Marble then
		Superior.Visible = true
	end
	Superior.Image = "rbxassetid://5710750120"

	Pristine.Name = "Pristine"
	Pristine.Parent = AsteroidMarker
	Pristine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Pristine.BackgroundTransparency = 1.000
	Pristine.Position = UDim2.new(1, 0, 0.375, 0)
	Pristine.Size = UDim2.new(0.25, 0, 0.25, 0)
	Pristine.Visible = false
	if Rock.Parent.Mineral.Material == Enum.Material.Ice then
		Superior.Visible = true
		Pristine.Visible = true
	end
	Pristine.Image = "rbxassetid://5710750120"
	
	spawn(function()
		MarkerUpdater(AsteroidMarker)
	end)
end
local function CreateContainerMarker(Cont)
	local ContainerMarker = Instance.new("BillboardGui")
	local Marker = Instance.new("ImageLabel")
	local Dist = Instance.new("TextLabel")
	local ContentsHolder = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	local ItemTemp = Instance.new("TextLabel")

	ContainerMarker.Name = "ContainerMarker"
	ContainerMarker.Parent = ContainerFolder
	ContainerMarker.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ContainerMarker.Active = true
	ContainerMarker.AlwaysOnTop = true
	ContainerMarker.LightInfluence = 1.000
	ContainerMarker.Size = UDim2.new(0, 100, 0, 100)
	ContainerMarker.Adornee = Cont:WaitForChild("Base")

	Marker.Name = "Marker"
	Marker.Parent = ContainerMarker
	Marker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Marker.BackgroundTransparency = 1.000
	Marker.Position = UDim2.new(0.300000012, 0, 0.300000012, 0)
	Marker.Size = UDim2.new(0.400000006, 0, 0.400000006, 0)
	Marker.Image = "rbxassetid://9165072179"
	Marker.ImageColor3 = Cont.Hull.Lights.Part.Color

	Dist.Name = "Dist"
	Dist.Parent = ContainerMarker
	Dist.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Dist.BackgroundTransparency = 1.000
	Dist.Position = UDim2.new(-0.5, 0, 0.699999988, 0)
	Dist.Size = UDim2.new(2, 0, 0.200000003, 0)
	Dist.Font = Enum.Font.GothamBold
	Dist.Text = GetDistance(Cont.PrimaryPart.Position)
	Dist.TextColor3 = Color3.fromRGB(255, 255, 255)
	Dist.TextScaled = true
	Dist.TextSize = 14.000
	Dist.TextStrokeTransparency = 0.800
	Dist.TextWrapped = true

	ContentsHolder.Name = "ContentsHolder"
	ContentsHolder.Parent = ContainerMarker
	ContentsHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ContentsHolder.BackgroundTransparency = 1.000
	ContentsHolder.Position = UDim2.new(0.800000012, 0, 0.400000006, 0)
	ContentsHolder.Size = UDim2.new(1, 0, 2, 0)

	UIListLayout.Parent = ContentsHolder
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	ItemTemp.Name = "ItemTemp"
	ItemTemp.Parent = ContentsHolder
	ItemTemp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ItemTemp.BackgroundTransparency = 1.000
	ItemTemp.Size = UDim2.new(1, 0, 0.0700000003, 0)
	ItemTemp.Visible = false
	ItemTemp.Font = Enum.Font.GothamBold
	ItemTemp.Text = "Nil"
	ItemTemp.TextColor3 = Color3.fromRGB(255, 255, 255)
	ItemTemp.TextSize = 14.000
	ItemTemp.TextStrokeTransparency = 0.800
	ItemTemp.TextXAlignment = Enum.TextXAlignment.Left
	
	for i,v in pairs(Cont.Contents:GetChildren()) do
		local Clone = ItemTemp:Clone()
		Clone.Parent = ContentsHolder
		Clone.Text = v.Name:gsub("(%l)(%u)", "%1 %2").." x"..tostring(v.Value)
		Clone.Visible = true
	end
	
	spawn(function()
		MarkerUpdater(ContainerMarker)
	end)
end

local function CheckForNewMarkers()
	for i,v in pairs(Players:GetChildren()) do
		if v ~= Player then
			local Found = false
			for i2,v2 in pairs(PlayerFolder:GetChildren()) do
				if v2.Adornee.Parent.Name == v.Name then
					Found = true
					break
				end
			end
			if Found == false then
				CreatePlayerMarker(v)
			end
		end
	end
	for i,v in pairs(WS.NPCs.Ships:GetChildren()) do
		if not string.find(Child.Name, "Turret") then
			local Found = false
			for i2,v2 in pairs(NPCFolder:GetChildren()) do
				if v.PrimaryPart == v2.Adornee then
					Found = true
					break
				end
			end
			if Found == false then
				CreateNPCMarker(Child)
			end
		end
	end
	for i,v in pairs(WS.Features:GetDescendants()) do
		if v.Name == "Asteroid" then
			local Found = false
			for i2,v2 in pairs(AsteroidFolder:GetChildren()) do
				if v.Rock == v2.Adornee then
					Found = true
					break
				end
			end
			if Found == false then
				CreateAsteroidMarker(v.Rock)
			end
		end
	end
	for i,v in pairs(WS.Containers:GetChildren()) do
		if v.Name == "SecureContainer" then
			local Found = false
			for i2,v2 in pairs(ContainerFolder:GetChildren()) do
				if v.PrimaryPart == v2.Adornee then
					Found = true
					break
				end
			end
			if Found == false then
				CreateContainerMarker(v)
			end
		elseif v.Name == "Wreck" then
			for i2,v2 in pairs(v.Contents:GetChildren()) do
				local Found = false
				for i3,v3 in pairs(ContainerFolder:GetChildren()) do
					if v2.PrimaryPart == v3.Adornee then
						Found = true
						break
					end
				end
				if Found == false then
					CreateContainerMarker(v2)
				end
			end
		end
	end
end

-- Update UI Toggle
if Settings.UIState == false then
	GUI:toggle()
end

-- PAGE 1
local Page1 = GUI:addPage("ESP")

local P1_Section1 = Page1:addSection("Players")
P1_Section1:addToggle("Toggle", Settings.PlayerTog, function(State)
	Settings.PlayerTog = State
	SaveSettings(Settings)
end)
P1_Section1:addToggle("Player Join/Leave Notification", Settings.PlayerNotif, function(State)
	Settings.PlayerNotif = State
	SaveSettings(Settings)
end)
P1_Section1:addSlider("Range", Settings.PlayerRange, 0, 80000, function(Val)
	Settings.PlayerRange = Val
	SaveSettings(Settings)
end)

local P1_Section2 = Page1:addSection("NPCs")
P1_Section2:addToggle("Toggle", Settings.NPCTog, function(State)
	Settings.NPCTog = State
	SaveSettings(Settings)
end)
P1_Section2:addSlider("Range", Settings.NPCRange, 0, 80000, function(Val)
	Settings.NPCRange = Val
	SaveSettings(Settings)
end)

local P1_Section3 = Page1:addSection("Asteroids")
P1_Section3:addToggle("Toggle", Settings.AsteroidTog, function(State)
	Settings.AsteroidTog = State
	SaveSettings(Settings)
end)
P1_Section3:addSlider("Range", Settings.AsteroidRange, 0, 80000, function(Val)
	Settings.AsteroidRange = Val
	SaveSettings(Settings)
end)

local P1_Section4 = Page1:addSection("Containers")
P1_Section4:addToggle("Toggle", Settings.ContainerTog, function(State)
	Settings.ContainerTog = State
	SaveSettings(Settings)
end)
P1_Section4:addToggle("Remove Marker if Empty", Settings.RemoveContainerMarker, function(State)
	Settings.RemoveContainerMarker = State
	SaveSettings(Settings)
end)
P1_Section4:addSlider("Range", Settings.ContainerRange, 0, 80000, function(Val)
	Settings.ContainerRange = Val
	SaveSettings(Settings)
end)

-- PAGE 2
local Page2 = GUI:addPage("Settings")
local P2_Section1 = Page2:addSection("Delays")
P2_Section1:addSlider("Updater Delay", Settings.UpdaterDelay, 0.03, 10, function(Val)
	Settings.UpdaterDelay = Val
	SaveSettings(Settings)
end)

local P2_Section2 = Page2:addSection("Sizes")
P2_Section2:addSlider("Player ESP UI Size", Settings.PlayerESPSize, 10, 1000, function(Val)
	Settings.PlayerESPSize = Val
	SaveSettings(Settings)
end)
P2_Section2:addSlider("NPC ESP UI Size", Settings.NPCESPSize, 10, 1000, function(Val)
	Settings.NPCESPSize = Val
	SaveSettings(Settings)
end)
P2_Section2:addSlider("Asteroid ESP UI Size", Settings.AsteroidESPSize, 10, 1000, function(Val)
	Settings.AsteroidESPSize = Val
	SaveSettings(Settings)
end)
P2_Section2:addSlider("Container ESP UI Size", Settings.ContainerESPSize, 10, 1000, function(Val)
	Settings.ContainerESPSize = Val
	SaveSettings(Settings)
end)

-- PAGE 3
local Page3 = GUI:addPage("Other")
local P3_Section1 = Page3:addSection("Other")
P3_Section1:addKeybind("Toggle UI", Settings.ToggleUIBind, function()
	if FGUI then
		if Settings.UIState == true then
			Settings.UIState = false
		else
			Settings.UIState = true
		end
		SaveSettings(Settings)
		GUI:toggle()
	end
end, function(Key)
	Settings.ToggleUIBind = Key
	SaveSettings(Settings)
end)
P3_Section1:addKeybind("Unlock Mouse", Settings.ToggleMouseUnlock, function()
	if FGUI then
		local Mouse = Player:GetMouse()
		if MouseUnlock == true then
			MouseUnlock = false
			SetModal(false)
			UIS.MouseIconEnabled = false
		else
			MouseUnlock = true
			SetModal(true)
			spawn(function()
				while MouseUnlock == true do
					RunS.RenderStepped:Wait()
					UIS.MouseIconEnabled = true
				end
			end)
			if Settings.UIState == false then
				Settings.UIState = true
				GUI:toggle()
			end
		end
	end
end, function(Key)
	if Key.KeyCode then
		Settings.ToggleMouseUnlock = Key
		SaveSettings(Settings)
	end
end)
local Deb = false
P3_Section1:addKeybind("Toggle Auto Warp", Settings.ToggleAutoWarp, function()
	if FGUI and Deb == false then
		Deb = true
		if Settings.AutoWarp == true then
			Notif("Auto Warp","Auto Warp has been toggle OFF")
			Settings.AutoWarp = false
		else
			Notif("Auto Warp","Auto Warp has been toggle ON")
			Settings.AutoWarp = true
		end
		SaveSettings(Settings)
		wait(1)
		Deb = false
	end
end, function(Key)
	if Key.KeyCode then
		Settings.ToggleAutoWarp = Key
		SaveSettings(Settings)
	end
end)
P3_Section1:addToggle("Open UI When Mouse Unlocked", Settings.MouseUnlockOpenUI, function(State)
	Settings.MouseUnlockOpenUI = State
	SaveSettings(Settings)
end)
P3_Section1:addButton("Terminate UI", function()
	CGui:FindFirstChild(GUIName):Destroy()
end)

-- Events
Players.PlayerAdded:Connect(function(Plr)
	if FGUI and Settings.PlayerNotif == true and Plr ~= Player then
		Notif("Player Joined",Plr.Name.." has joined the server",true)
	end
	
	CreatePlayerMarker(Plr)
end)
Players.PlayerRemoving:Connect(function(Plr)
	if FGUI and Settings.PlayerNotif == true and Plr ~= Player then
		Notif("Player Left",Plr.Name.." has left the server")
	end
end)

-- Load
GUI:SelectPage(GUI.pages[1], true)

-- Init
for i,v in pairs(Players:GetChildren()) do
	if v ~= Player then
		CreatePlayerMarker(v)
	end
end
for i,v in pairs(WS.NPCs.Ships:GetChildren()) do
	if not string.find(v.Name, "Turret") then
		CreateNPCMarker(v)
	end
end
for i,v in pairs(WS.Features:GetDescendants()) do
	if v.Name == "Asteroid" then
		CreateAsteroidMarker(v:WaitForChild("Rock"))
	end
end
for i,v in pairs(WS.Containers:GetChildren()) do
	if v.Name == "SecureContainer" then
		CreateContainerMarker(v)
	elseif v.Name == "Wreck" then
		for i2,v2 in pairs(v.Contents:GetChildren()) do
			if v2.Name == "SecureContainer" then
				CreateContainerMarker(v2)
			end
		end
	end
end

spawn(function()
    while FGUI do
		wait(2) 
		if Settings.AutoWarp == true and PlayerGui.Overlays.Standard.System.Destination.Visible == true then
			local warpMenu = PlayerGui.QuickWarp
			while wait() do
				if Settings.AutoWarp == true and PlayerGui.Overlays.Standard.Flying.Wrapper.HUD.Indicators.Warp.Visible == false then
					keypress(0x20)
					for k,v in pairs(warpMenu.Items:GetChildren()) do
						if v:IsA("Frame") and v.Icon.Image == "rbxassetid://3885669481" and v.Icon.ImageColor3 ~= Color3.new(1,1,1)and v.Back.BackgroundTransparency == 0 then
							keyrelease(0x20)
							break
						end
					end
					mousemoverel(0,20)
				else
					keyrelease(0x20)
					break
				end
			end
		end
    end
end)

local Warp = PlayerGui.Overlays.Standard.Flying.Wrapper.HUD.Indicators.Warp
Warp.Changed:Connect(function(Change)
	if FGUI and Change == "Visible" and Warp.Visible == false then
		CheckForNewMarkers()
	end
end)

--=============================================================
end
end)
if Error then
	warn(Error)
end
