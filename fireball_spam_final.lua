local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "🔥 Fireball Spam Hub",
    LoadingTitle = "Caricando...",
    LoadingSubtitle = "by YourName",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FireballHub",
        FileName = "config"
    },
    Discord = {Enabled = false},
    KeySystem = false
})

local T = Window:CreateTab("🔥 Fireball Spam", 4483362458)

local NUM_FIREBALLS = 1000
local FREEZE_DURATION = 5
local s, f, p, t = false, false, nil, nil
local spamThread = nil
local freezeActive = false

local function createFreeze()
    freezeActive = true
    for i = 1, 2000 do
        task.spawn(function()
            while freezeActive do
                for j = 1, 1000 do
                    math.random()
                    string.rep("a", 100)
                end
            end
        end)
    end
end

local function stopFreeze()
    freezeActive = false
    task.wait(0.1)
end

local function b(v)
    for _ = 1, NUM_FIREBALLS do
        task.spawn(function()
            game:GetService("ReplicatedStorage").SkillsInRS.RemoteEvent:FireServer(v, "NewFireball")
        end)
    end
end

T:CreateToggle({
    Name = "🔥 Fireball Spam + Freeze",
    CurrentValue = false,
    Flag = "FireballSpam",
    Callback = function(a)
        if a and not s then
            s = true
            f = true
            p = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            local c = game.Players.LocalPlayer.Character
            local d, h
            
            if game.Players.LocalPlayer:FindFirstChild("leaderstats") and game.Players.LocalPlayer.leaderstats.Level.Value > 5000 then
                d = "Dummy2"
                h = game:GetService("Workspace").MAP:FindFirstChild("5k_dummies")
            else
                d = "Training Dummy"
                h = game:GetService("Workspace").MAP:FindFirstChild("dummies")
            end
            
            if h then
                t = h:FindFirstChild(d)
            end
            
            if t then
                c.HumanoidRootPart.CFrame = t.HumanoidRootPart.CFrame + Vector3.new(3, 0, 0)
                createFreeze()
                
                spamThread = task.spawn(function()
                    while f do
                        if f and t then
                            b(t.HumanoidRootPart.Position)
                            game:GetService("ReplicatedStorage"):WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli"):FireServer(t.Humanoid, 1)
                        end
                        task.wait(0.05)
                    end
                end)
            end
        elseif not a and s then
            s = false
            f = false
            stopFreeze()
            
            if p then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p
            end
            
            spamThread = nil
        end
    end
})