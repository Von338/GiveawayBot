local NUM_FIREBALLS = 50 -- Ridotto da 500 a 50 per evitare freeze
local FIREBALL_DELAY = 0.01 -- Delay tra ogni fireball per evitare sovraccarico
local SPAM_DELAY = 0.1 -- Aumentato da 0.05 a 0.1 per ridurre intensità

local s, f, p, t = false, false, nil, nil
local spamThread = nil
local fireballConnections = {}

local function b(v)
   -- Invece di spawnare 500 task simultanei, li spawniamo con un piccolo delay
   for i = 1, NUM_FIREBALLS do
      local connection = task.spawn(function()
         task.wait(i * FIREBALL_DELAY) -- Delay progressivo per evitare picco simultaneo
         if f then -- Controlla se lo spam è ancora attivo
            pcall(function() -- Usa pcall per evitare errori che possono causare freeze
               game:GetService("ReplicatedStorage").SkillsInRS.RemoteEvent:FireServer(v, "NewFireball")
            end)
         end
      end)
      table.insert(fireballConnections, connection)
   end
end

-- Funzione per pulire le connessioni
local function cleanupConnections()
   for _, connection in pairs(fireballConnections) do
      if connection then
         -- Non possiamo killare direttamente i task, ma possiamo svuotare la lista
      end
   end
   fireballConnections = {}
end

local G = T:CreateToggle({
   Name = "🔥 Fireball Spam (Optimized)",
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
            
            -- Thread principale con controlli anti-freeze
            spamThread = task.spawn(function()
               while f do
                  if t and t.Parent then -- Verifica che il target esista ancora
                     pcall(function() -- Usa pcall per evitare errori
                        b(t.HumanoidRootPart.Position)
                        game:GetService("ReplicatedStorage"):WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli"):FireServer(t.Humanoid, 1)
                     end)
                  end
                  
                  -- Yield più frequente per evitare freeze
                  task.wait(SPAM_DELAY)
                  
                  -- Controllo aggiuntivo per sicurezza
                  if not f then break end
               end
            end)
         else
            print("Nessun Dummy trovato.")
            s = false
            f = false
         end
      elseif not a and s then
         -- Ferma tutto
         s = false
         f = false
         
         -- Pulisci le connessioni
         cleanupConnections()
         
         -- Torna alla posizione originale
         if p and game.Players.LocalPlayer.Character then
            pcall(function()
               game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p
            end)
         end
         
         -- Reset del thread
         spamThread = nil
         print("Fireball spam fermato.")
      end
   end
})

-- Pulizia automatica quando il player lascia o il character viene distrutto
game.Players.LocalPlayer.CharacterRemoving:Connect(function()
   if s then
      s = false
      f = false
      cleanupConnections()
   end
end)