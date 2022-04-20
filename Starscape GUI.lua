local Succ, Error = pcall(function()
repeat wait() until game:IsLoaded()

local GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
if string.find(GameName,"Starscape") and not game:GetService("CoreGui"):FindFirstChild("dosage's solaris gui") then

local CGui = game:GetService("CoreGui")

local Player = game:GetService("Players").LocalPlayer
local Feats = game:GetService("Workspace").Features
local Sounds = game:GetService("ReplicatedStorage").Sounds
local SoundGood = Sounds.Raid.Update
local SoundBad = Sounds.Raid.Stage

local DefSettings = {
	PlrDist = 10000,
	NPCDist = 10000,
	AsteroidDist = 5000,
	PlayerNotif = false,
	MineralNotif = true,
	UpdateDelay = .5,
	SelectedMinerals = {"Reknite (pristine)","Gellium (pristine)","Axnit (pristine)","Red Narcor","Vexnium"},
	PlayerTog = true,
	NPCTog = true,
	AsteroidTog = true
}

function TableToString(tbl)
    local result = "{"
    for k, v in pairs(tbl) do
        -- Check the key type (ignore any numerical keys - assume its an array)
        if type(k) == "string" then
            result = result.."[\""..k.."\"]".."="
        end

        -- Check the value type
        if type(v) == "table" then
            result = result..TableToString(v)
        elseif type(v) == "boolean" then
            result = result..tostring(v)
		elseif type(v) == "number" then
            result = result..tostring(v)
        else
            result = result.."\""..v.."\""
        end
        result = result..","
    end
    -- Remove leading commas from the result
    if result ~= "" then
        result = result:sub(1, result:len()-1)
    end
    return result.."}"
end

local function SaveSettings(Sett)
	local Str = TableToString(Sett)
	writefile("StarscapeGUI_Vick/configs/settings.txt",Str)
end

local Valid = isfile("StarscapeGUI_Vick/configs/settings.txt")
if not Valid then
	SaveSettings(DefSettings)
end
local Loaded = loadstring("return "..readfile("StarscapeGUI_Vick/configs/settings.txt"))
local Settings = Loaded()
print(Settings)

local function GetDistance(Pos)
    local Char = Player.Character or Player.CharacterAdded:Wait()
    if Char then
        return math.floor((Char:WaitForChild("HumanoidRootPart").Position - Pos).Magnitude)
    end
    return 0
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

local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/sol"))()

local Main = Lib:New({
  Name = "Starscape UI",
  FolderToSave = "StarscapeGUI_Vick"
})

local GUI = CGui:FindFirstChild("dosage's solaris gui")
local PlayerFolder = Instance.new("Folder")
PlayerFolder.Parent = GUI
PlayerFolder.Name = "PlayerMarkers"
local NPCFolder = Instance.new("Folder")
NPCFolder.Parent = GUI
NPCFolder.Name = "NPCMarkers"
local AsteroidFolder = Instance.new("Folder")
AsteroidFolder.Parent = GUI
AsteroidFolder.Name = "AsteroidMarkers"

local function AsteroidMarker(Ador)
    local AsteroidMarker = Instance.new("BillboardGui")
    local Marker = Instance.new("ImageLabel")
    local Dist = Instance.new("TextLabel")
    
    AsteroidMarker.Name = "AsteroidMarker"
    AsteroidMarker.Parent = AsteroidFolder
    AsteroidMarker.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    AsteroidMarker.Active = true
    AsteroidMarker.AlwaysOnTop = true
    AsteroidMarker.LightInfluence = 1.000
    AsteroidMarker.Size = UDim2.new(0, 50, 0, 50)
    AsteroidMarker.Adornee = Ador
    
    Marker.Name = "Marker"
    Marker.Parent = AsteroidMarker
    Marker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Marker.BackgroundTransparency = 1.000
    Marker.Size = UDim2.new(1, 0, 1, 0)
    Marker.Image = "rbxassetid://5412272324"
    
    Dist.Name = "Dist"
    Dist.Parent = Marker
    Dist.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dist.BackgroundTransparency = 1.000
    Dist.Position = UDim2.new(0, 0, -0.400000006, 0)
    Dist.Size = UDim2.new(1, 0, 0.5, 0)
    Dist.Font = Enum.Font.Gotham
    Dist.Text = "0"
    Dist.TextColor3 = Color3.fromRGB(255, 255, 255)
    Dist.TextSize = 20.000
    Dist.TextYAlignment = Enum.TextYAlignment.Top
    Dist.Text = GetDistance(Ador.Position)
    
    Marker.ImageColor3 = Ador.Parent.Mineral.Color
	
	if Settings.AsteroidTog == false or GetDistance(Ador.Position) > Settings.AsteroidDist then
		AsteroidMarker.Enabled = false
	end
end

local function PlayerMarker(Plr)
	if Plr.Character then
		local PlayerMarker = Instance.new("BillboardGui")
		local Marker = Instance.new("ImageLabel")
		local Dist = Instance.new("TextLabel")
		local PlrName = Instance.new("TextLabel")

		PlayerMarker.Name = "PlayerMarker"
		PlayerMarker.Parent = PlayerFolder
		PlayerMarker.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		PlayerMarker.Active = true
		PlayerMarker.Adornee = Plr.Character.HumanoidRootPart
		PlayerMarker.AlwaysOnTop = true
		PlayerMarker.LightInfluence = 1.000
		PlayerMarker.Size = UDim2.new(0, 50, 0, 50)

		Marker.Name = "Marker"
		Marker.Parent = PlayerMarker
		Marker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Marker.BackgroundTransparency = 1.000
		Marker.Size = UDim2.new(1, 0, 1, 0)
		Marker.Image = "rbxassetid://7268197516"
		local Afil = Plr.PublicData.Affiliation
		if Afil.Value == "Kavani" then
			Marker.ImageColor3 = Color3.fromRGB(52, 227, 25)
		elseif Afil.Value == "Lycentian" then
			Marker.ImageColor3 = Color3.fromRGB(4, 131, 227)
		elseif Afil.Value == "Foralkan" then
			Marker.ImageColor3 = Color3.fromRGB(167, 28, 28)
		end

		Dist.Name = "Dist"
		Dist.Parent = Marker
		Dist.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Dist.BackgroundTransparency = 1.000
		Dist.Position = UDim2.new(0, 0, 0.899999976, 0)
		Dist.Size = UDim2.new(1, 0, 0.5, 0)
		Dist.Font = Enum.Font.Gotham
		Dist.Text = GetDistance(Plr.Character.HumanoidRootPart.Position)
		Dist.TextColor3 = Color3.fromRGB(255, 255, 255)
		Dist.TextSize = 20.000
		Dist.TextStrokeTransparency = 0.830
		Dist.TextYAlignment = Enum.TextYAlignment.Bottom
		Dist.Text = GetDistance(Plr.Character.HumanoidRootPart.Position)

		PlrName.Name = "PlrName"
		PlrName.Parent = Marker
		PlrName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		PlrName.BackgroundTransparency = 1.000
		PlrName.Position = UDim2.new(0, 0, -0.400000006, 0)
		PlrName.Size = UDim2.new(1, 0, 0.5, 0)
		PlrName.Font = Enum.Font.Gotham
		PlrName.Text = Plr.Name
		PlrName.TextColor3 = Color3.fromRGB(255, 255, 255)
		PlrName.TextSize = 20.000
		PlrName.TextStrokeTransparency = 0.830
		PlrName.TextYAlignment = Enum.TextYAlignment.Top
		
		if Settings.PlayerTog == false or GetDistance(Plr.Character.HumanoidRootPart.Position) > Settings.PlrDist then
			PlayerMarker.Enabled = false
		end
	end
end

local function NPCMarker(Ship)
	local PlayerMarker = Instance.new("BillboardGui")
	local Marker = Instance.new("ImageLabel")
	local Dist = Instance.new("TextLabel")
	local PlrName = Instance.new("TextLabel")

	PlayerMarker.Name = "NPCMarker"
	PlayerMarker.Parent = NPCFolder
	PlayerMarker.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	PlayerMarker.Active = true
	PlayerMarker.Adornee = Ship.PrimaryPart
	PlayerMarker.AlwaysOnTop = true
	PlayerMarker.LightInfluence = 1.000
	PlayerMarker.Size = UDim2.new(0, 50, 0, 50)

	Marker.Name = "Marker"
	Marker.Parent = PlayerMarker
	Marker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Marker.BackgroundTransparency = 1.000
	Marker.Size = UDim2.new(1, 0, 1, 0)
	Marker.Image = "rbxassetid://2866597030"
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

	Dist.Name = "Dist"
	Dist.Parent = Marker
	Dist.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Dist.BackgroundTransparency = 1.000
	Dist.Position = UDim2.new(0, 0, 0.899999976, 0)
	Dist.Size = UDim2.new(1, 0, 0.5, 0)
	Dist.Font = Enum.Font.Gotham
	Dist.Text = GetDistance(Ship.PrimaryPart.Position)
	Dist.TextColor3 = Color3.fromRGB(255, 255, 255)
	Dist.TextSize = 20.000
	Dist.TextStrokeTransparency = 0.830
	Dist.TextYAlignment = Enum.TextYAlignment.Bottom
	Dist.Text = GetDistance(Ship.PrimaryPart.Position)

	PlrName.Name = "PlrName"
	PlrName.Parent = Marker
	PlrName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	PlrName.BackgroundTransparency = 1.000
	PlrName.Position = UDim2.new(0, 0, -0.400000006, 0)
	PlrName.Size = UDim2.new(1, 0, 0.5, 0)
	PlrName.Font = Enum.Font.Gotham
	PlrName.Text = Ship.npc.faction.Value.." "..Ship.ship.chassis.Value
	PlrName.TextColor3 = Color3.fromRGB(255, 255, 255)
	PlrName.TextSize = 20.000
	PlrName.TextStrokeTransparency = 0.830
	PlrName.TextYAlignment = Enum.TextYAlignment.Top
	
	if Settings.NPCTog == false or GetDistance(Ship.PrimaryPart.Position) > Settings.NPCDist then
		PlayerMarker.Enabled = false
	end
end

local function GetAdor(Folder,Ador)
	for i,v in pairs(Folder:GetChildren()) do
		if v.Adornee == Ador then
			return v
		end
	end
end

local function UpdatePlayer()
	for i,v in pairs(PlayerFolder:GetChildren()) do
		if not v.Adornee then
			v:Destroy()
		end
	end
	for i,v in pairs(game:GetService("Players"):GetChildren()) do
		local Char = v.Character
		if Char and not GetAdor(Char.HumanoidRootPart) then
			PlayerMarker(v)
		end
	end
end
local function UpdateNPC()
	for i,v in pairs(NPCFolder:GetChildren()) do
		if not v.Adornee then
			v:Destroy()
		end
	end
	for i,v in pairs(game:GetService("Workspace").NPCs.Ships:GetChildren()) do
		if not string.find(v.Name, "Turret") and not GetAdor(v.PrimaryPart) then
			NPCMarker(v)
		end
	end
end
local function UpdateAsteroid()
	for i,v in pairs(AsteroidFolder:GetChildren()) do
		if not v.Adornee then
			v:Destroy()
		end
	end
	for i,v in pairs(Feats:GetDescendants()) do
        if v.Name == "Asteroid" and not GetAdor(v.Rock) then
			AsteroidMarker(v.Rock)
        end
    end
end

local function UpdateDist()
	if Settings.PlayerTog == true then
		UpdatePlayer()
		for i,v in pairs(PlayerFolder:GetChildren()) do
			if v.Adornee then
				local Dist = GetDistance(v.Adornee.Position)
				v.Marker.Dist.Text = tostring(Dist).."st"
				if Dist <= Settings.PlrDist then
					v.Enabled = true
				else
					v.Enabled = false
				end
			else
				v:Destroy()
			end
		end
	end
	if Settings.NPCTog == true then
		UpdateNPC()
		for i,v in pairs(NPCFolder:GetChildren()) do
			if v.Adornee then
				local Dist = GetDistance(v.Adornee.Position)
				v.Marker.Dist.Text = tostring(Dist).."st"
				if Dist <= Settings.NPCDist then
					v.Enabled = true
				else
					v.Enabled = false
				end
			else
				v:Destroy()
			end
		end
	end
	if Settings.AsteroidTog == true then
		UpdateAsteroid()
		for i,v in pairs(AsteroidFolder:GetChildren()) do
			if v.Adornee then
				local Dist = GetDistance(v.Adornee.Position)
				v.Marker.Dist.Text = tostring(Dist).."st"
				if Dist <= Settings.AsteroidDist then
					v.Enabled = true
				else
					v.Enabled = false
				end
			else
				v:Destroy()
			end
		end
	end
end

local function ToggleMarkers(Folder,State)
	for i,v in pairs(Folder:GetChildren()) do
		v.Enabled = State
		UpdateDist()
	end
end

local function RunUpdate()
	while wait(Settings.UpdateDelay) do
		UpdateDist()
	end
end

local T_ESP = Main:Tab("ESP")

local S_Players = T_ESP:Section("Players")
local TogglePlayers = S_Players:Toggle("Toggle", Settings.PlayerTog,"TogglePlayers", function(t)
	Settings.PlayerTog = t
	UpdatePlayer()
	
	UpdateDist()
	ToggleMarkers(PlayerFolder,t)
	
	SaveSettings(Settings)
end)
game:GetService("Players").PlayerAdded:Connect(function(Plr)
	if GUI then
		Plr.CharacterAdded:Connect(function(Char)
			PlayerMarker(v)
			for i,v in pairs(PlayerFolder:GetChildren()) do
				if not v.Adornee then
					v:Destroy()
				end
			end
		end)
		if Settings.PlayerNotif == true then
			SoundBad:Play()
			Lib:Notification("Player Joined",Plr.Name.." has joined the server")
		end
	end
end)
game:GetService("Players").PlayerRemoving:Connect(function(Plr)
	if GUI then
		if Settings.PlayerNotif == true then
			SoundGood:Play()
			Lib:Notification("Player Left",Plr.Name.." has left the server")
		end
		for i,v in pairs(PlayerFolder:GetChildren()) do
			if not v.Adornee then
				v:Destroy()
			end
		end
	end
end)
local TogglePlayerNotif = S_Players:Toggle("Player Join Notify", Settings.PlayerNotif,"ToggleSettings.PlayerNotif", function(t)
	Settings.PlayerNotif = t
	SaveSettings(Settings)
end)
local SliderPlayerRange = S_Players:Slider("Range", 50,60000,Settings.PlrDist,50,"SliderPlayerRange", function(t)
	Settings.PlrDist = t
	UpdateDist()
	SaveSettings(Settings)
end)

local S_NPCs = T_ESP:Section("NPCs")
local ToggleNPCs = S_NPCs:Toggle("Toggle", Settings.NPCTog,"ToggleNPCs", function(t)
	Settings.NPCTog = t
	UpdateNPC()
	
	UpdateDist()
	ToggleMarkers(NPCFolder,t)
	
	SaveSettings(Settings)
end)
local SliderNPCRange = S_NPCs:Slider("Range", 50,60000,Settings.NPCDist,50,"SliderNPCRange", function(t)
	Settings.NPCDist = t
	UpdateDist()
	SaveSettings(Settings)
end)

local S_Asteroids = T_ESP:Section("Asteroids")
local ToggleAsteroids = S_Asteroids:Toggle("Toggle", Settings.AsteroidTog,"ToggleAsteroids", function(t)
	Settings.AsteroidTog = t
	UpdateAsteroid()
	
	UpdateDist()
	ToggleMarkers(AsteroidFolder,t)
	
	SaveSettings(Settings)
end)
local SliderAsteroidRange = S_Asteroids:Slider("Range", 50,60000,Settings.AsteroidDist,50,"SliderAsteroidRange", function(t)
	Settings.AsteroidDist = t
	UpdateDist()
	SaveSettings(Settings)
end)

local S_Minerals = T_ESP:Section("Minerals")
local ToggleMineralNotif = S_Minerals:Toggle("Toggle Notification", Settings.MineralNotif,"ToggleSettings.MineralNotif", function(t)
	Settings.MineralNotif = t
	SaveSettings(Settings)
end)
S_Minerals:Button("Manual Scan", function()
	SoundGood:Play()
	local Found = {}
	for i,v in pairs(Settings.SelectedMinerals) do
		if GetMineralNum(v) > 0 then
			Found[v] = GetMineralNum(v)
		end
	end
	local TableLen = 0
	for i,v in pairs(Found) do
		TableLen = TableLen + 1
	end
	if TableLen == 0 then
		Lib:Notification("Detected Minerals","There are no filtered minerals in this server")
	else
		local NewStr = ""
		for i,v in pairs(Found) do
			NewStr = NewStr..i.." x"..tostring(v).."\n"
		end
		Lib:Notification("Detected Minerals",NewStr)
	end
end)
local Ran = false
local MultiDropMineralFilter = S_Minerals:MultiDropdown("Mineral Filter", {
	"Korrelite (inferior)","Korrelite","Korrelite (superior)","Korrelite (pristine)",
	"Reknite (inferior)","Reknite","Reknite (superior)","Reknite (pristine)",
	"Gellium","Gellium (superior)","Gellium (pristine)",
	"Axnit","Axnit (pristine)",
	"Narcor",
	"Red Narcor",
	"Vexnium"},Settings.SelectedMinerals,"MultiDropMineralFilter",
	function(t)
		Settings.SelectedMinerals = t
		if Settings.MineralNotif == true and Ran == false then
			Ran = true
			wait(8)
			if Settings.MineralNotif == true then
				SoundGood:Play()
				local Found = {}
				for i,v in pairs(Settings.SelectedMinerals) do
					if GetMineralNum(v) > 0 then
						Found[v] = GetMineralNum(v)
					end
				end
				local TableLen = 0
				for i,v in pairs(Found) do
					TableLen = TableLen + 1
				end
				if TableLen == 0 then
					Lib:Notification("Detected Minerals","There are no filtered minerals in this server")
				else
					local NewStr = ""
					for i,v in pairs(Found) do
						NewStr = NewStr..i.." x"..tostring(v).."\n"
					end
					Lib:Notification("Detected Minerals",NewStr)
				end
			end
		end
		SaveSettings(Settings)
end)


local T_Other = Main:Tab("Other")

local S_Settings = T_Other:Section("Settings")
local SliderUpdateDelay = S_Settings:Slider("Update Delay", .05,5,Settings.UpdateDelay,.05,"SliderSettings.UpdateDelay", function(t)
	Settings.UpdateDelay = t
	SaveSettings(Settings)
end)
RunUpdate()

end
end)
print(Error)
