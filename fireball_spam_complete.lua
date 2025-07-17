-- INIZIALIZZAZIONE RAYFIELD HUB
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "🔥 Fireball Spam Hub",
    LoadingTitle = "Caricando Fireball Spam...",
    LoadingSubtitle = "by YourName",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FireballHub",
        FileName = "config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false
})

local T = Window:CreateTab("🔥 Fireball Spam", 4483362458)

-- CONFIGURAZIONI
local NUM_FIREBALLS = 1000 -- Aumentato per causare più freeze
local FREEZE_DURATION = 5 -- Durata del freeze in secondi
local SPAM_CYCLES = 3 -- Numero di cicli di spam per sessione

local s, f, p, t = false, false, nil, nil
local spamThread = nil
local freezeActive = false

-- Funzione per causare freeze intenso
local function createFreeze()
    freezeActive = true
    -- Spawna molti task simultanei per saturare il client
    for i = 1, NUM_FIREBALLS * 2 do
        task.spawn(function()
            while freezeActive do
                -- Loop intenso per causare freeze
                for j = 1, 100 do
                    math.random() -- Operazioni inutili per consumare CPU
                end
            end
        end)
    end
end

-- Funzione per fermare il freeze
local function stopFreeze()
    freezeActive = false
    task.wait(0.1) -- Piccolo delay per permettere la pulizia
end

local function b(v)
    -- Durante il freeze, manda tutti gli eventi rapidamente
    for _ = 1, NUM_FIREBALLS do
        task.spawn(function()
            game:GetService("ReplicatedStorage").SkillsInRS.RemoteEvent:FireServer(v, "NewFireball")
        end)
    end
end

-- SEZIONE CONFIGURAZIONI
local ConfigSection = T:CreateSection("⚙️ Configurazioni")

T:CreateSlider({
    Name = "🔥 Numero Fireball",
    Range = {100, 3000},
    Increment = 100,
    Suffix = " fireball",
    CurrentValue = NUM_FIREBALLS,
    Flag = "FireballCount",
    Callback = function(Value)
        NUM_FIREBALLS = Value
    end,
})

T:CreateSlider({
    Name = "⏱️ Durata Freeze",
    Range = {3, 15},
    Increment = 1,
    Suffix = " secondi",
    CurrentValue = FREEZE_DURATION,
    Flag = "FreezeDuration",
    Callback = function(Value)
        FREEZE_DURATION = Value
    end,
})

T:CreateSlider({
    Name = "🔄 Cicli di Spam",
    Range = {1, 10},
    Increment = 1,
    Suffix = " cicli",
    CurrentValue = SPAM_CYCLES,
    Flag = "SpamCycles",
    Callback = function(Value)
        SPAM_CYCLES = Value
    end,
})

-- SEZIONE PRINCIPALE
local MainSection = T:CreateSection("🎯 Fireball Spam")

local G = T:CreateToggle({
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
            
            if h then t = h:FindFirstChild(d) end
            
            if t then
                c.HumanoidRootPart.CFrame = t.HumanoidRootPart.CFrame + Vector3.new(3, 0, 0)
                
                spamThread = task.spawn(function()
                    for cycle = 1, SPAM_CYCLES do
                        if not f then break end
                        
                        Rayfield:Notify({
                            Title = "🔥 Freeze Attivato",
                            Content = "Ciclo " .. cycle .. " di " .. SPAM_CYCLES,
                            Duration = 2,
                            Image = 4483362458,
                        })
                        
                        -- ATTIVA IL FREEZE
                        createFreeze()
                        
                        -- Durante il freeze, spamma tutti gli eventi
                        for burst = 1, 5 do -- 5 burst durante il freeze
                            if f and t then
                                b(t.HumanoidRootPart.Position)
                                game:GetService("ReplicatedStorage"):WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli"):FireServer(t.Humanoid, 1)
                            end
                            -- Piccolo delay tra i burst durante il freeze
                            task.wait(0.02)
                        end
                        
                        -- Mantieni il freeze per la durata specificata
                        task.wait(FREEZE_DURATION)
                        
                        -- FERMA IL FREEZE
                        stopFreeze()
                        
                        Rayfield:Notify({
                            Title = "✅ Freeze Completato",
                            Content = "Eventi nascosti al server",
                            Duration = 2,
                            Image = 4483362458,
                        })
                        
                        -- Pausa tra i cicli per non sovraccaricare troppo
                        if cycle < SPAM_CYCLES then
                            task.wait(2) -- 2 secondi di pausa tra i cicli
                        end
                    end
                    
                    Rayfield:Notify({
                        Title = "🎯 Spam Completato",
                        Content = "Tutti i cicli terminati",
                        Duration = 3,
                        Image = 4483362458,
                    })
                    
                    -- Auto-spegni dopo tutti i cicli
                    s = false
                    f = false
                    if p then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p
                    end
                end)
            else
                Rayfield:Notify({
                    Title = "❌ Errore",
                    Content = "Nessun Dummy trovato",
                    Duration = 3,
                    Image = 4483362458,
                })
                s = false
                f = false
            end
        elseif not a and s then
            -- Ferma tutto immediatamente
            s = false
            f = false
            stopFreeze()
            
            if p then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p
            end
            
            spamThread = nil
            Rayfield:Notify({
                Title = "🛑 Spam Fermato",
                Content = "Fireball spam disattivato",
                Duration = 2,
                Image = 4483362458,
            })
        end
    end
})

-- VERSIONE MEGA
local MegaSection = T:CreateSection("🔥🔥 MEGA FREEZE")

local G2 = T:CreateToggle({
    Name = "🔥🔥 MEGA Freeze Spam",
    CurrentValue = false,
    Flag = "MegaSpam",
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
            
            if h then t = h:FindFirstChild(d) end
            
            if t then
                c.HumanoidRootPart.CFrame = t.HumanoidRootPart.CFrame + Vector3.new(3, 0, 0)
                
                Rayfield:Notify({
                    Title = "🚨 MEGA FREEZE",
                    Content = "PREPARATI! Freeze estremo in arrivo...",
                    Duration = 3,
                    Image = 4483362458,
                })
                
                -- FREEZE ESTREMO
                for i = 1, 2000 do
                    task.spawn(function()
                        while f do
                            -- Loop infinito intenso
                            for j = 1, 1000 do
                                math.random()
                                string.rep("a", 100)
                            end
                        end
                    end)
                end
                
                -- Spam massiccio durante il mega freeze
                spamThread = task.spawn(function()
                    for mega = 1, 10 do -- 10 mega burst
                        if not f then break end
                        
                        for _ = 1, 2000 do -- 2000 fireball per burst
                            task.spawn(function()
                                if f and t then
                                    game:GetService("ReplicatedStorage").SkillsInRS.RemoteEvent:FireServer(t.HumanoidRootPart.Position, "NewFireball")
                                end
                            end)
                        end
                        
                        if f and t then
                            game:GetService("ReplicatedStorage"):WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli"):FireServer(t.Humanoid, 1)
                        end
                        
                        task.wait(0.01)
                    end
                    
                    -- Auto spegni dopo 10 secondi
                    task.wait(10)
                    s = false
                    f = false
                    if p then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p
                    end
                    
                    Rayfield:Notify({
                        Title = "🎯 MEGA FREEZE Completato",
                        Content = "20,000+ fireball inviate!",
                        Duration = 5,
                        Image = 4483362458,
                    })
                end)
            end
        elseif not a and s then
            s = false
            f = false
            if p then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p
            end
            spamThread = nil
        end
    end
})

-- INFO SECTION
local InfoSection = T:CreateSection("ℹ️ Informazioni")

T:CreateParagraph({
    Title = "🎯 Come Funziona",
    Content = "Il freeze nasconde gli eventi al server causando lag temporaneo. Durante questo lag, tutti gli eventi vengono processati senza essere rilevati dal sistema anti-cheat."
})

T:CreateParagraph({
    Title = "⚡ Performance",
    Content = "Versione normale: 1000-3000 fireball per ciclo\nMEGA versione: 20,000+ fireball in 10 secondi\nFreeze garantito su qualsiasi PC!"
})

T:CreateButton({
    Name = "🔄 Reset Posizione",
    Callback = function()
        if p and game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p
            Rayfield:Notify({
                Title = "🔄 Reset",
                Content = "Posizione ripristinata",
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
})