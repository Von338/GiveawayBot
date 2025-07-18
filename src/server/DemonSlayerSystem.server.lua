-- Demon Slayer Game - Server Script
-- Gestisce la logica principale del gioco con personaggi e tecniche di respirazione

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

-- Eventi remoti
local remoteEvents = Instance.new("Folder")
remoteEvents.Name = "RemoteEvents"
remoteEvents.Parent = ReplicatedStorage

local selectCharacterEvent = Instance.new("RemoteEvent")
selectCharacterEvent.Name = "SelectCharacter"
selectCharacterEvent.Parent = remoteEvents

local useAbilityEvent = Instance.new("RemoteEvent")
useAbilityEvent.Name = "UseAbility"
useAbilityEvent.Parent = remoteEvents

local updateScoreEvent = Instance.new("RemoteEvent")
updateScoreEvent.Name = "UpdateScore"
updateScoreEvent.Parent = remoteEvents

local updateHealthEvent = Instance.new("RemoteEvent")
updateHealthEvent.Name = "UpdateHealth"
updateHealthEvent.Parent = remoteEvents

-- Configurazioni personaggi
local characters = {
    ["Tanjiro"] = {
        name = "Tanjiro Kamado",
        breathing = "Water Breathing",
        color = Color3.new(0, 0.5, 1),
        abilities = {
            {name = "Water Surface Slash", damage = 35, cooldown = 2, range = 25},
            {name = "Water Wheel", damage = 45, cooldown = 4, range = 20},
            {name = "Hinokami Kagura", damage = 70, cooldown = 8, range = 30}
        },
        stats = {health = 120, speed = 18}
    },
    ["Zenitsu"] = {
        name = "Zenitsu Agatsuma",
        breathing = "Thunder Breathing",
        color = Color3.new(1, 1, 0),
        abilities = {
            {name = "Thunderclap and Flash", damage = 50, cooldown = 3, range = 35},
            {name = "Rice Spirit", damage = 40, cooldown = 2.5, range = 20},
            {name = "Thunder Swarm", damage = 60, cooldown = 6, range = 40}
        },
        stats = {health = 100, speed = 25}
    },
    ["Inosuke"] = {
        name = "Inosuke Hashibira",
        breathing = "Beast Breathing",
        color = Color3.new(0.6, 0.3, 0),
        abilities = {
            {name = "Fang of the Beast", damage = 40, cooldown = 2, range = 15},
            {name = "Rampaging Arc", damage = 55, cooldown = 4, range = 25},
            {name = "Crazy Cutting", damage = 65, cooldown = 5, range = 20}
        },
        stats = {health = 140, speed = 20}
    },
    ["Giyu"] = {
        name = "Giyu Tomioka",
        breathing = "Water Breathing (Hashira)",
        color = Color3.new(0, 0.3, 0.8),
        abilities = {
            {name = "Dead Calm", damage = 60, cooldown = 4, range = 30},
            {name = "Flowing Dance", damage = 50, cooldown = 3, range = 25},
            {name = "Lull", damage = 80, cooldown = 10, range = 35}
        },
        stats = {health = 150, speed = 22}
    },
    ["Rengoku"] = {
        name = "Kyojuro Rengoku",
        breathing = "Flame Breathing",
        color = Color3.new(1, 0.5, 0),
        abilities = {
            {name = "Unknowing Fire", damage = 55, cooldown = 3, range = 28},
            {name = "Blooming Flame Undulation", damage = 65, cooldown = 5, range = 30},
            {name = "Ninth Form: Rengoku", damage = 90, cooldown = 12, range = 40}
        },
        stats = {health = 160, speed = 20}
    }
}

-- Tabelle per tracciare stato giocatori
local playerData = {}
local playerCooldowns = {}

-- Funzione per creare effetto slash
local function createSlashEffect(startPosition, direction, character, ability, owner)
    local slash = Instance.new("Part")
    slash.Name = "Slash"
    slash.Size = Vector3.new(0.5, 0.5, ability.range)
    slash.Shape = Enum.PartType.Block
    slash.Material = Enum.Material.Neon
    slash.Color = character.color
    slash.Position = startPosition + direction * (ability.range / 2)
    slash.CanCollide = false
    slash.Anchored = true
    slash.Transparency = 0.3
    
    -- Orienta lo slash nella direzione corretta
    slash.CFrame = CFrame.lookAt(slash.Position, slash.Position + direction)
    
    -- Effetti visivi
    local selectionBox = Instance.new("SelectionBox")
    selectionBox.Adornee = slash
    selectionBox.Color3 = character.color
    selectionBox.Transparency = 0.5
    selectionBox.LineThickness = 0.2
    selectionBox.Parent = slash
    
    -- Effetto di luce
    local pointLight = Instance.new("PointLight")
    pointLight.Color = character.color
    pointLight.Brightness = 2
    pointLight.Range = 15
    pointLight.Parent = slash
    
    slash.Parent = workspace
    
    -- Animazione di espansione
    local tween = game:GetService("TweenService"):Create(
        slash,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = Vector3.new(3, 3, ability.range), Transparency = 0.1}
    )
    tween:Play()
    
    -- Effetto particelle
    spawn(function()
        for i = 1, 10 do
            local particle = Instance.new("Part")
            particle.Size = Vector3.new(0.2, 0.2, 0.2)
            particle.Material = Enum.Material.Neon
            particle.Color = character.color
            particle.Position = slash.Position + Vector3.new(
                math.random(-5, 5),
                math.random(-3, 3),
                math.random(-ability.range/2, ability.range/2)
            )
            particle.CanCollide = false
            particle.Parent = workspace
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Velocity = Vector3.new(
                math.random(-20, 20),
                math.random(5, 15),
                math.random(-20, 20)
            )
            bodyVelocity.Parent = particle
            
            Debris:AddItem(particle, 2)
        end
    end)
    
    -- Rileva collisioni
    local hitPlayers = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character ~= owner then
            local distance = (player.Character.HumanoidRootPart.Position - slash.Position).Magnitude
            if distance <= ability.range / 2 + 5 then
                if not hitPlayers[player] then
                    hitPlayers[player] = true
                    
                    -- Danneggia il giocatore
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid:TakeDamage(ability.damage)
                        
                        -- Aggiorna punteggio dell'attaccante
                        if owner and playerData[owner] then
                            playerData[owner].score = playerData[owner].score + 15
                            updateScoreEvent:FireClient(Players:GetPlayerFromCharacter(owner), playerData[owner].score)
                        end
                        
                        -- Aggiorna salute del difensore
                        updateHealthEvent:FireClient(player, humanoid.Health)
                        
                        -- Effetto knockback
                        local bodyVelocity = Instance.new("BodyVelocity")
                        bodyVelocity.MaxForce = Vector3.new(4000, 0, 4000)
                        bodyVelocity.Velocity = direction * 30
                        bodyVelocity.Parent = player.Character.HumanoidRootPart
                        
                        Debris:AddItem(bodyVelocity, 0.5)
                    end
                end
            end
        end
    end
    
    -- Rimuovi lo slash
    Debris:AddItem(slash, 1)
end

-- Gestione selezione personaggio
selectCharacterEvent.OnServerEvent:Connect(function(player, characterName)
    if characters[characterName] then
        local character = characters[characterName]
        playerData[player] = {
            characterName = characterName,
            character = character,
            score = 0,
            health = character.stats.health
        }
        
        -- Applica stats al personaggio
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.MaxHealth = character.stats.health
            player.Character.Humanoid.Health = character.stats.health
            player.Character.Humanoid.WalkSpeed = character.stats.speed
        end
        
        print(player.Name .. " ha scelto " .. characterName)
    end
end)

-- Gestione uso abilità
useAbilityEvent.OnServerEvent:Connect(function(player, abilityIndex, direction)
    if not playerData[player] then return end
    
    local currentTime = tick()
    local playerId = tostring(player.UserId)
    
    if not playerCooldowns[playerId] then
        playerCooldowns[playerId] = {}
    end
    
    local lastUse = playerCooldowns[playerId][abilityIndex] or 0
    local character = playerData[player].character
    local ability = character.abilities[abilityIndex]
    
    if not ability then return end
    
    if currentTime - lastUse < ability.cooldown then
        return -- Ancora in cooldown
    end
    
    playerCooldowns[playerId][abilityIndex] = currentTime
    
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local startPosition = player.Character.HumanoidRootPart.Position + direction * 3
        createSlashEffect(startPosition, direction, character, ability, player.Character)
    end
end)

-- Inizializza giocatori
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(1)
        -- Invia evento per aprire selezione personaggio
        selectCharacterEvent:FireClient(player, "OpenSelection")
    end)
end)

print("Demon Slayer Game Server loaded!")