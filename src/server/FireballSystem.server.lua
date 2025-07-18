-- Fireballs Game - Server Script
-- Gestisce la logica principale del gioco delle fireballs

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

-- Eventi remoti
local remoteEvents = Instance.new("Folder")
remoteEvents.Name = "RemoteEvents"
remoteEvents.Parent = ReplicatedStorage

local shootFireballEvent = Instance.new("RemoteEvent")
shootFireballEvent.Name = "ShootFireball"
shootFireballEvent.Parent = remoteEvents

local updateScoreEvent = Instance.new("RemoteEvent")
updateScoreEvent.Name = "UpdateScore"
updateScoreEvent.Parent = remoteEvents

-- Tabella per tenere traccia dei punteggi
local playerScores = {}

-- Funzione per creare una fireball
local function createFireball(startPosition, direction, owner)
    local fireball = Instance.new("Part")
    fireball.Name = "Fireball"
    fireball.Size = Vector3.new(2, 2, 2)
    fireball.Shape = Enum.PartType.Ball
    fireball.Material = Enum.Material.Neon
    fireball.BrickColor = BrickColor.new("Bright red")
    fireball.Position = startPosition
    fireball.CanCollide = false
    fireball.TopSurface = Enum.SurfaceType.Smooth
    fireball.BottomSurface = Enum.SurfaceType.Smooth
    
    -- Effetto di luce
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.new(1, 0.5, 0)
    pointLight.Brightness = 2
    pointLight.Range = 10
    pointLight.Parent = fireball
    
    -- Effetto particelle
    local attachment = Instance.new("Attachment")
    attachment.Parent = fireball
    
    local fire = Instance.new("Fire")
    fire.Size = 5
    fire.Heat = 10
    fire.Parent = fireball
    
    -- BodyVelocity per il movimento
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = direction * 50 -- Velocità della fireball
    bodyVelocity.Parent = fireball
    
    fireball.Parent = workspace
    
    -- Gestione collisioni
    local function onTouched(hit)
        local humanoid = hit.Parent:FindFirstChild("Humanoid")
        if humanoid and hit.Parent ~= owner then
            -- Danneggia il giocatore colpito
            humanoid:TakeDamage(25)
            
            -- Aggiorna punteggio
            if owner and playerScores[owner] then
                playerScores[owner] = playerScores[owner] + 10
                updateScoreEvent:FireClient(owner, playerScores[owner])
            end
            
            -- Effetto esplosione
            local explosion = Instance.new("Explosion")
            explosion.Position = fireball.Position
            explosion.BlastRadius = 20
            explosion.BlastPressure = 500000
            explosion.Parent = workspace
            
            -- Rimuovi la fireball
            fireball:Destroy()
        elseif hit.Name ~= "Fireball" and hit.Parent.Name ~= "Fireball" then
            -- Collisione con ambiente
            local explosion = Instance.new("Explosion")
            explosion.Position = fireball.Position
            explosion.BlastRadius = 15
            explosion.BlastPressure = 300000
            explosion.Parent = workspace
            
            fireball:Destroy()
        end
    end
    
    fireball.Touched:Connect(onTouched)
    
    -- Rimuovi automaticamente dopo 5 secondi
    Debris:AddItem(fireball, 5)
end

-- Gestione dell'evento di sparo
shootFireballEvent.OnServerEvent:Connect(function(player, direction)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local startPosition = player.Character.HumanoidRootPart.Position + direction * 3
        createFireball(startPosition, direction, player.Character)
    end
end)

-- Inizializza punteggio per nuovi giocatori
Players.PlayerAdded:Connect(function(player)
    playerScores[player.Character or player] = 0
    
    player.CharacterAdded:Connect(function(character)
        playerScores[character] = 0
        
        -- Invia punteggio iniziale
        wait(1) -- Aspetta che il client sia pronto
        updateScoreEvent:FireClient(player, 0)
    end)
end)

print("Fireballs Game Server loaded!")