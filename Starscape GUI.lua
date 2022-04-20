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

local PlrDist = 10000
local NPCDist = 10000
local AsteroidDist = 5000
local PlayerNotif = false
local MineralNotif = true
local UpdateDelay = .5
local SelectedMinerals = {}
local PlayerTog = true
local NPCTog = true
local AsteroidTog = true

local function GetDistance(Pos)
    local Char = Player.Character or Player.CharacterAdded:Wait()
    if Char then
        return math.floor((Char.HumanoidRootPart.Position - Pos).Magnitude)
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
	
	if AsteroidTog == false or GetDistance(Ador.Position) > AsteroidDist then
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
		
		if PlayerTog == false or GetDistance(Plr.Character.HumanoidRootPart.Position) > PlrDist then
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
	elseif Afil.Value == "Drones" then
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
	
	if NPCTog == false or GetDistance(Ship.PrimaryPart.Position) > NPCDist then
		PlayerMarker.Enabled = false
	end
end

local function UpdateDist()
	if PlayerTog == true then
		for i,v in pairs(PlayerFolder:GetChildren()) do
			if v.Adornee then
				local Dist = GetDistance(v.Adornee.Position)
				v.Marker.Dist.Text = tostring(Dist).."st"
				if Dist <= PlrDist then
					v.Enabled = true
				else
					v.Enabled = false
				end
			else
				v:Destroy()
			end
		end
	end
	if NPCTog == true then
		for i,v in pairs(NPCFolder:GetChildren()) do
			if v.Adornee then
				local Dist = GetDistance(v.Adornee.Position)
				v.Marker.Dist.Text = tostring(Dist).."st"
				if Dist <= NPCDist then
					v.Enabled = true
				else
					v.Enabled = false
				end
			else
				v:Destroy()
			end
		end
	end
	if AsteroidTog == true then
		for i,v in pairs(AsteroidFolder:GetChildren()) do
			if v.Adornee then
				local Dist = GetDistance(v.Adornee.Position)
				v.Marker.Dist.Text = tostring(Dist).."st"
				if Dist <= AsteroidDist then
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
	while wait(UpdateDelay) do
		UpdateDist()
	end
end

local T_ESP = Main:Tab("ESP")

local S_Players = T_ESP:Section("Players")
local TogglePlayers = S_Players:Toggle("Toggle", PlayerTog,"TogglePlayers", function(t)
	PlayerTog = t
	for i,v in pairs(PlayerFolder:GetChildren()) do
		v:Destroy()
	end
	for i,v in pairs(game:GetService("Players"):GetChildren()) do
		if v ~= Player then
			PlayerMarker(v)
		end
	end
	
	UpdateDist()
	ToggleMarkers(PlayerFolder,t)
	
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
			if PlayerNotif == true then
				SoundBad:Play()
				Lib:Notification("Player Joined",Plr.Name.." has joined the server")
			end
		end
	end)
	game:GetService("Players").PlayerRemoving:Connect(function(Plr)
		if GUI then
			if PlayerNotif == true then
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
end)
local TogglePlayerNotif = S_Players:Toggle("Player Join Notify", PlayerNotif,"TogglePlayerNotif", function(t)
	PlayerNotif = t
end)
local SliderPlayerRange = S_Players:Slider("Range", 50,60000,PlrDist,50,"SliderPlayerRange", function(t)
	PlrDist = t
	UpdateDist()
end)

local S_NPCs = T_ESP:Section("NPCs")
local ToggleNPCs = S_NPCs:Toggle("Toggle", NPCTog,"ToggleNPCs", function(t)
	NPCTog = t
	for i,v in pairs(NPCFolder:GetChildren()) do
		v:Destroy()
	end
	for i,v in pairs(game:GetService("Workspace").NPCs.Ships:GetChildren()) do
		if not string.find(v.Name, "Turret") then
			NPCMarker(v)
		end
	end
	UpdateDist()
	ToggleMarkers(NPCFolder,t)
end)
local SliderNPCRange = S_NPCs:Slider("Range", 50,60000,NPCDist,50,"SliderNPCRange", function(t)
	NPCDist = t
	UpdateDist()
end)

local S_Asteroids = T_ESP:Section("Asteroids")
local ToggleAsteroids = S_Asteroids:Toggle("Toggle", AsteroidTog,"ToggleAsteroids", function(t)
	AsteroidTog = t
	for i,v in pairs(AsteroidFolder:GetChildren()) do
		v:Destroy()
	end
	for i,v in pairs(Feats:GetDescendants()) do
        if v.Name == "Asteroid" then
			AsteroidMarker(v.Rock)
        end
    end
	UpdateDist()
	ToggleMarkers(AsteroidFolder,t)
end)
local SliderAsteroidRange = S_Asteroids:Slider("Range", 50,60000,AsteroidDist,50,"SliderAsteroidRange", function(t)
	AsteroidDist = t
	UpdateDist()
end)

local S_Minerals = T_ESP:Section("Minerals")
local ToggleMineralNotif = S_Minerals:Toggle("Toggle Notification", MineralNotif,"ToggleMineralNotif", function(t)
	MineralNotif = t
end)
S_Minerals:Button("Manual Scan", function()
	SoundGood:Play()
	local Found = {}
	for i,v in pairs(SelectedMinerals) do
		if GetMineralNum(v) > 0 then
			if Found[v] then
				Found[v] = Found[v] + 1
			else
				Found[v] = 1
			end
		end
	end
	if #Found == 0 then
		Lib:Notification("Detected Minerals","There are no filtered minerals in this server")
	else
		local NewStr = ""
		for i,v in pairs(Found) do
			NewStr = NewStr..i.." x"..tostring(v).."\n"
		end
		Lib:Notification("Detected Minerals",Str)
	end
end)
local MultiDropMineralFilter = S_Minerals:MultiDropdown("Mineral Filter", {
	"Korrelite (inferior)","Korrelite","Korrelite (superior)","Korrelite (pristine)",
	"Reknite (inferior)","Reknite","Reknite (superior)","Reknite (pristine)",
	"Gellium","Gellium (superior)","Gellium (pristine)",
	"Axnit","Axnit (pristine)",
	"Narcor",
	"Red Narcor",
	"Vexnium"},{"Reknite (pristine)","Gellium (pristine)","Axnit (pristine)","Red Narcor","Vexnium"},"MultiDropMineralFilter",
	function(t)
		SelectedMinerals = t
		if MineralNotif == true then
			wait(8)
			if MineralNotif == true then
				SoundGood:Play()
				local Found = {}
				for i,v in pairs(t) do
					if GetMineralNum(v) > 0 then
						if Found[v] then
							Found[v] = Found[v] + 1
						else
							Found[v] = 1
						end
					end
				end
				if #Found == 0 then
					Lib:Notification("Detected Minerals","There are no filtered minerals in this server")
				else
					local NewStr = ""
					for i,v in pairs(Found) do
						NewStr = NewStr..i.." x"..tostring(v).."\n"
					end
					Lib:Notification("Detected Minerals",Str)
				end
			end
		end
end)


local T_Other = Main:Tab("Other")

local S_Settings = T_Other:Section("Settings")
local SliderUpdateDelay = S_Settings:Slider("Update Delay", .05,5,UpdateDelay,.05,"SliderUpdateDelay", function(t)
	UpdateDelay = t
end)
RunUpdate()

end
end)
print(Error)
