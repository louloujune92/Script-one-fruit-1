local Q = "LVL 1"
local QTP = "LVL 1"
local ITP = "Starter Island"
local MTP = "Bandit"
local MTPCD = 1
local W = 1
local SB = "M1"
local CD = 0.1

getgenv().APunch = false
getgenv().ADef = false
getgenv().AQuest = false
getgenv().ASSpam = false
getgenv().AMob = false

local function FireCombat(skill)
    local args = {
        [1] = {
            [1] = {
                [1] = "\3",
                [2] = "Combat",
                [3] = skill,
                [4] = false,
                [5] = game:GetService("Players").LocalPlayer.Character.Combat,
                [6] = "Melee"
            }
        }
    }
    game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args))
end

local function FireDefense()
    local args = {
        [1] = {
            [1] = {
                [1] = "\3",
                [2] = "Defence",
                [3] = game:GetService("Players").LocalPlayer.Character.Defence,
                [4] = "Defence"
            }
        }
    }
    game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args))
end

local function FireQuest(level)
    local questMap = {
        ["LVL 1"] = 1,
        ["LVL 10"] = 2,
        ["LVL 20"] = 3,
        ["LVL 35"] = 4,
        ["LVL 50"] = 5,
        ["LVL 60"] = 6,
        ["LVL 75"] = 7,
        ["LVL 90"] = 8,
        ["LVL 100"] = 9,
        ["LVL 120"] = 10,
        ["LVL 135"] = 11,
        ["LVL 150"] = 12,
        ["LVL 170"] = 13,
        ["LVL 185"] = 14,
        ["LVL 200"] = 15,
    }
    local id = questMap[level]
    if id then
        local args = {
            [1] = {
                [1] = {
                    [1] = "\7",
                    [2] = "GetQuest",
                    [3] = id
                }
            }
        }
        game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args))
    end
end

local function FireSkillRelease(wpn, skillName, delay)
    local args = {
        [1] = {
            [1] = {
                [1] = "\3",
                [2] = "skillsControl",
                [3] = wpn,
                [4] = skillName,
                [5] = "Release",
                [6] = Vector3.new(game:GetService("Players").LocalPlayer:GetMouse().Hit)
            }
        }
    }
    game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args))
    wait(delay)
end

local function TPTo(PCFrame)
    local plr = game.Players.LocalPlayer
    if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = PCFrame
    end
end

function AutoPunch()
    spawn(function()
        while getgenv().APunch do
            for i = 1, 5 do
                FireCombat(i)
                wait(0.1)
            end
        end
    end)
end

function AutoDefense()
    spawn(function()
        while getgenv().ADef do
            FireDefense()
            wait(0.1)
        end
    end)
end

function AutoQuest()
    spawn(function()
        while getgenv().AQuest do
            if Q then
                FireQuest(Q)
            end
            wait(0.1)
        end
    end)
end

function SSPam(W, S, CD)
    spawn(function()
        while getgenv().ASSpam do
            FireSkillRelease(W, S, CD)
        end
    end)
end

function AutoMob(CDBTP)
    spawn(function()
        while getgenv().AMob do
            if MTP == "Bandit" then
                for _, name in ipairs({"Bandit1", "Bandit2", "Bandit3", "Bandit4", "Bandit5", "Bandit6", "Bandit7", "Bandit8", "Bandit9"}) do
                    local mob = game:GetService("Workspace")["__GAME"]["__Mobs"]["Ilha_01"][name]
                    if mob and mob.NpcModel and mob.NpcModel:FindFirstChild("Torso") then
                        TPTo(mob.NpcModel.Torso.CFrame)
                        wait(CDBTP)
                    end
                end
            elseif MTP == "Strong Bandit" then
                for _, name in ipairs({"StrongBandit1", "StrongBandit2", "StrongBandit3", "StrongBandit4", "StrongBandit5", "StrongBandit6", "StrongBandit7", "StrongBandit8", "StrongBandit9"}) do
                    local mob = game:GetService("Workspace")["__GAME"]["__Mobs"]["Ilha_01"][name]
                    if mob and mob.NpcModel and mob.NpcModel:FindFirstChild("Torso") then
                        TPTo(mob.NpcModel.Torso.CFrame)
                        wait(CDBTP)
                    end
                end
            end
            wait(0.1)
        end
    end)
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3"))()
local w = library:CreateWindow("One Fruit Simulator")

local b = w:CreateFolder("Autofarm")

b:Toggle("Auto Punch", function(val)
    getgenv().APunch = val
    AutoPunch()
end)

b:Toggle("Auto Defense", function(val)
    getgenv().ADef = val
    AutoDefense()
end)

b:Toggle("Auto Take Quest", function(val)
    getgenv().AQuest = val
    AutoQuest()
end)

b:Toggle("Autofarm Mob", function(val)
    getgenv().AMob = val
    AutoMob(MTPCD)
end)

b:Box("CD Between TP", "number", function(val)
    MTPCD = tonumber(val) or 1
end)

b:Dropdown("Mobs", {"Bandit", "Strong Bandit", "Bandit Leader", "Monkey", "Gorilla", "King Gorilla", "Clown", "Killer Clown", "Clown King", "Marine", "Marine Official", "Lorgan", "Cat Pirate", "Mansion Guard", "Buros"}, true, function(val)
    MTP = val
end)

b:Dropdown("Quest", {"LVL 1", "LVL 10", "LVL 20", "LVL 35", "LVL 50", "LVL 60", "LVL 75", "LVL 90", "LVL 100", "LVL 120", "LVL 135", "LVL 150", "LVL 170", "LVL 185", "LVL 200"}, true, function(val)
    Q = val
end)

local b2 = w:CreateFolder("Skills")

b2:Toggle("Spam Skill", function(val)
    getgenv().ASSpam = val
    SSPam(W, SB, CD)
end)

b2:Box("Spam Cooldown", "yes", function(val)
    CD = tonumber(val) or 0.1
end)

b2:Bind("Skill Bind Toggle", Enum.KeyCode.C, function()
    local args = {
        [1] = {
            [1] = {
                [1] = "\3",
                [2] = "skillsControl",
                [3] = W,
                [4] = SB,
                [5] = "Release",
                [6] = Vector3.new(game:GetService("Players").LocalPlayer:GetMouse().Hit)
            }
        }
    }
    game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args))
end)

b2:Box("Weapon", "yes", function(val)
    W = val
end)

b2:Box("Skill Bind", "yes", function(val)
    SB = val
end)

local b3 = w:CreateFolder("Teleports")

b3:Dropdown("Quest TP", {"LVL 1", "LVL 10", "LVL 20", "LVL 35", "LVL 50", "LVL 60", "LVL 75", "LVL 90", "LVL 100", "LVL 120", "LVL 135", "LVL 150", "LVL 170", "LVL 185", "LVL 200"}, true, function(val)
    QTP = val
end)

b3:Button("Teleport To Quest", function()
    if QTP == "LVL 1" then TPTo(game:GetService("Workspace")["__GAME"]["__Quests"].Quest01.Torso.CFrame) end
    if QTP == "LVL 10" then TPTo(game:GetService("Workspace")["__GAME"]["__Quests"].Quest02.Torso.CFrame) end
    if QTP == "LVL 20" then TPTo(game:GetService("Workspace")["__GAME"]["__Quests"].Quest03.Torso.CFrame) end
    if QTP == "LVL 35" then TPTo(game:GetService("Workspace")["__GAME"]["__Quests"].Quest04.Torso.CFrame) end
    if QTP == "LVL 50" then TPTo(game:GetService("Workspace")["__GAME"]["__Quests"].Quest05.Torso.CFrame) end
    if QTP == "LVL 60" then TPTo(game:GetService("Workspace")["__GAME"]["__Quests"].Quest06.Torso.CFrame) end
    if QTP == "LVL 75" then TPTo(game:GetService("Workspace")["__GAME"]["__Quests"].Quest07.Torso.CFrame) end
    if QTP == "LVL 90" then TPTo(game:GetService("Workspace")["__GAME"]["__Quests"].Quest08.Torso.CFrame) end
    if QTP == "LVL 100" then TPTo(game:GetService("Workspace")["__GAME"]["__Quests"].Quest09.Torso.CFrame) end
    if QTP == "LVL 120" then TPTo(game:GetService("Workspace")["__GAME"]["__Quests"].Quest10.Torso.CFrame) end
    if QTP == "LVL 135" then TPTo(game:GetService("Workspace")["__GAME"]["__Quests"].Quest11.Torso.CFrame) end
    if QTP == "LVL 150" then TPTo(game:GetService("Workspace")["__GAME"]["__Quests"].Quest12.Torso.CFrame) end
    if QTP == "LVL 170" then TPTo(game:GetService("Workspace")["__GAME"]["__Quests"].Quest13.Torso.CFrame) end
    if QTP == "LVL 185" then TPTo(game:GetService("Workspace")["__GAME"]["__Quests"].Quest14.Torso.CFrame) end
    if QTP == "LVL 200" then TPTo(game:GetService("Workspace")["__GAME"]["__Quests"].Quest15.Torso.CFrame) end
end)

b3:Dropdown("Island TP", {"Starter Island", "Jungle", "Clown Island", "Grand City", "Snow Island"}, true, function(val)
    ITP = val
end)

b3:Button("Teleport To Island", function()
    if ITP == "Starter Island" then TPTo(game:GetService("Workspace").Locations["Starter Island"].CFrame) end
    if ITP == "Jungle" then TPTo(game:GetService("Workspace").Locations.Jungle.CFrame) end
    if ITP == "Clown Island" then TPTo(game:GetService("Workspace").Locations["Clown Island"].CFrame) end
    if ITP == "Grand City" then TPTo(game:GetService("Workspace").Locations["Grand City"].CFrame) end
    if ITP == "Snow Island" then TPTo(game:GetService("Workspace").Locations["Snow Island"].CFrame) end
end)

local w2 = library:CreateWindow("Others")

local S, J, H, G, C, CF = 16, 50, 0.1, 196.2, "", 1

local b4 = w2:CreateFolder("LocalPlayer")

b4:Box("Speed", "number", function(val)
    S = tonumber(val) or 16
end)

b4:Box("Jump", "number", function(val)
    J = tonumber(val) or 50
end)

b4:Box("Hip Height", "number", function(val)
    H = tonumber(val) or 0.1
end)

b4:Box("Gravity", "number", function(val)
    G = tonumber(val) or 196.2
end)

b4:Toggle("Speed", function(bool)
    getgenv().Speed = bool
    Speed(S)
end)

b4:Toggle("Jump", function(bool)
    getgenv().Jump = bool
    Jump(J)
end)

b4:Toggle("Hip Height", function(bool)
    getgenv().Hip = bool
    Hip(H)
end)

b4:Toggle("Gravity", function(bool)
    getgenv().Grav = bool
    Grav(G)
end)

b4:Slider("FOV (Default is 70)", {min = 0; max = 120; precise = true;}, function(val)
    game.workspace.CurrentCamera.FieldOfView = val
end)

b4:Button("Print Current XYZ", function()
    local function GetPOS()
        return game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    end
    print(GetPOS())
end)

local b5 = w2:CreateFolder("Stuff")

b5:Box("Chat", "Message", function(val)
    C = val
end)

b5:Box("Cooldown", "Speed", function(val)
    CF = tonumber(val) or 1
end)

b5:Toggle("Spam", function(bool)
    getgenv().Chat = bool
    Chat(C, CF)
end)

b5:Button("Rejoin", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/NukeVsCity/TheALLHACKLoader/main/NukeLoader", true))()
end)

b5:Button("Giant", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Universal-Syn-Saveinstance-14624", true))()
end)

b5:Button("Noclip", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua", true))()
end)

b5:Button("Reset", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-RemainsHub-49836", true))()
end)

b5:Button("RTX Summer", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Oproxide/scripthub/refs/heads/main/main.lua", true))()
end)

b5:Button("RTX Autumn", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/phareignxd/xemonscripts/refs/heads/main/antiloggerv2", true))()
end)

b5:Button("Anti-Report", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Delta-Keyboard-open-sourced-44576", true))()
end)

local b6 = w2:CreateFolder("Credits")

b6:Label("Made by X_LuaF#0705", {
    TextSize = 21,
    TextColor = Color3.fromRGB(255,255,255),
    BgColor = Color3.fromRGB(69,69,69)
})

b6:Button("Copy Discord Invite", function()
    setclipboard("https://discord.gg/8tRb8MQcW5")
end)

b6:DestroyGui()

getgenv().Speed = false
getgenv().Jump = false
getgenv().Hip = false
getgenv().Chat = false
getgenv().Grav = false

function Chat(Mes, Freq)
    spawn(function()
        while getgenv().Chat do
            local args = {Mes, "All"}
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
            wait(Freq)
        end
    end)
end

function Speed(Nume)
    spawn(function()
        if getgenv().Speed then
            while getgenv().Speed do
                game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = Nume
                wait()
            end
        elseif not getgenv().Speed then
            game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end)
end

function Jump(Nume)
    spawn(function()
        if getgenv().Jump then
            while getgenv().Jump do
                game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = Nume
                wait()
            end
        elseif not getgenv().Jump then
            game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = 50
        end
    end)
end

function Hip(Nume)
    spawn(function()
        if getgenv().Hip then
            while getgenv().Hip do
                game:GetService("Players").LocalPlayer.Character.Humanoid.HipHeight = Nume
                wait()
            end
        elseif not getgenv().Hip then
            game:GetService("Players").LocalPlayer.Character.Humanoid.HipHeight = 0.1
        end
    end)
end

function Grav(Nume)
    spawn(function()
        if getgenv().Grav then
            while getgenv().Grav do
                game:GetService("Workspace").Gravity = Nume
                wait()
            end
        elseif not getgenv().Grav then
            game:GetService("Workspace").Gravity = 196.2
        end
    end)
end
