-- Demon Slayer Game - Client Script
-- Gestisce l'interfaccia utente e la selezione dei personaggi

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Aspetta che gli eventi remoti siano disponibili
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local selectCharacterEvent = remoteEvents:WaitForChild("SelectCharacter")
local useAbilityEvent = remoteEvents:WaitForChild("UseAbility")
local updateScoreEvent = remoteEvents:WaitForChild("UpdateScore")
local updateHealthEvent = remoteEvents:WaitForChild("UpdateHealth")

-- Configurazioni personaggi (client-side)
local characters = {
    ["Tanjiro"] = {
        name = "Tanjiro Kamado",
        breathing = "Water Breathing",
        color = Color3.new(0, 0.5, 1),
        description = "Protagonista gentile con Hinokami Kagura",
        abilities = {"Water Surface Slash", "Water Wheel", "Hinokami Kagura"}
    },
    ["Zenitsu"] = {
        name = "Zenitsu Agatsuma",
        breathing = "Thunder Breathing", 
        color = Color3.new(1, 1, 0),
        description = "Velocissimo con tecniche fulmine",
        abilities = {"Thunderclap and Flash", "Rice Spirit", "Thunder Swarm"}
    },
    ["Inosuke"] = {
        name = "Inosuke Hashibira",
        breathing = "Beast Breathing",
        color = Color3.new(0.6, 0.3, 0),
        description = "Combattente selvaggio e resistente",
        abilities = {"Fang of the Beast", "Rampaging Arc", "Crazy Cutting"}
    },
    ["Giyu"] = {
        name = "Giyu Tomioka",
        breathing = "Water Breathing (Hashira)",
        color = Color3.new(0, 0.3, 0.8),
        description = "Hashira dell'Acqua, potente e silenzioso",
        abilities = {"Dead Calm", "Flowing Dance", "Lull"}
    },
    ["Rengoku"] = {
        name = "Kyojuro Rengoku",
        breathing = "Flame Breathing",
        color = Color3.new(1, 0.5, 0),
        description = "Hashira della Fiamma, passionale",
        abilities = {"Unknowing Fire", "Blooming Flame Undulation", "Ninth Form: Rengoku"}
    }
}

local selectedCharacter = nil
local characterSelectionGui = nil
local gameGui = nil

-- Funzione per creare GUI di selezione personaggio
local function createCharacterSelection()
    -- GUI principale
    characterSelectionGui = Instance.new("ScreenGui")
    characterSelectionGui.Name = "CharacterSelection"
    characterSelectionGui.Parent = player.PlayerGui
    
    -- Sfondo
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.Position = UDim2.new(0, 0, 0, 0)
    background.BackgroundColor3 = Color3.new(0, 0, 0)
    background.BackgroundTransparency = 0.2
    background.Parent = characterSelectionGui
    
    -- Frame principale
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 800, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
    mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.2)
    mainFrame.BorderSizePixel = 3
    mainFrame.BorderColor3 = Color3.new(0.8, 0.8, 0.9)
    mainFrame.Parent = background
    
    -- Titolo
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚔️ SELEZIONA IL TUO DEMON SLAYER ⚔️"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextScaled = true
    title.Font = Enum.Font.SourceSansBold
    title.Parent = mainFrame
    
    -- Scroll frame per i personaggi
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -20, 1, -80)
    scrollFrame.Position = UDim2.new(0, 10, 0, 70)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 10
    scrollFrame.Parent = mainFrame
    
    local yOffset = 0
    for charKey, charData in pairs(characters) do
        -- Frame del personaggio
        local charFrame = Instance.new("Frame")
        charFrame.Size = UDim2.new(1, -20, 0, 120)
        charFrame.Position = UDim2.new(0, 10, 0, yOffset)
        charFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
        charFrame.BorderSizePixel = 2
        charFrame.BorderColor3 = charData.color
        charFrame.Parent = scrollFrame
        
        -- Nome personaggio
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0.4, 0, 0, 30)
        nameLabel.Position = UDim2.new(0, 10, 0, 10)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = charData.name
        nameLabel.TextColor3 = charData.color
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.Parent = charFrame
        
        -- Stile di respirazione
        local breathingLabel = Instance.new("TextLabel")
        breathingLabel.Size = UDim2.new(0.4, 0, 0, 20)
        breathingLabel.Position = UDim2.new(0, 10, 0, 40)
        breathingLabel.BackgroundTransparency = 1
        breathingLabel.Text = charData.breathing
        breathingLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        breathingLabel.TextScaled = true
        breathingLabel.Font = Enum.Font.SourceSans
        breathingLabel.Parent = charFrame
        
        -- Descrizione
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(0.4, 0, 0, 40)
        descLabel.Position = UDim2.new(0, 10, 0, 65)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = charData.description
        descLabel.TextColor3 = Color3.new(0.7, 0.7, 0.7)
        descLabel.TextScaled = true
        descLabel.Font = Enum.Font.SourceSans
        descLabel.TextWrapped = true
        descLabel.Parent = charFrame
        
        -- Abilità
        local abilitiesLabel = Instance.new("TextLabel")
        abilitiesLabel.Size = UDim2.new(0.4, 0, 1, -20)
        abilitiesLabel.Position = UDim2.new(0.5, 0, 0, 10)
        abilitiesLabel.BackgroundTransparency = 1
        abilitiesLabel.Text = "Abilità:\n• " .. table.concat(charData.abilities, "\n• ")
        abilitiesLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
        abilitiesLabel.TextScaled = true
        abilitiesLabel.Font = Enum.Font.SourceSans
        abilitiesLabel.TextXAlignment = Enum.TextXAlignment.Left
        abilitiesLabel.TextYAlignment = Enum.TextYAlignment.Top
        abilitiesLabel.Parent = charFrame
        
        -- Bottone di selezione
        local selectButton = Instance.new("TextButton")
        selectButton.Size = UDim2.new(0, 100, 0, 40)
        selectButton.Position = UDim2.new(1, -110, 0.5, -20)
        selectButton.BackgroundColor3 = charData.color
        selectButton.Text = "SCEGLI"
        selectButton.TextColor3 = Color3.new(1, 1, 1)
        selectButton.TextScaled = true
        selectButton.Font = Enum.Font.SourceSansBold
        selectButton.Parent = charFrame
        
        -- Animazione hover
        selectButton.MouseEnter:Connect(function()
            TweenService:Create(selectButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 110, 0, 45)}):Play()
        end)
        
        selectButton.MouseLeave:Connect(function()
            TweenService:Create(selectButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 100, 0, 40)}):Play()
        end)
        
        -- Funzione di selezione
        selectButton.MouseButton1Click:Connect(function()
            selectedCharacter = charKey
            selectCharacterEvent:FireServer(charKey)
            characterSelectionGui:Destroy()
            createGameGui(charData)
        end)
        
        yOffset = yOffset + 130
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

-- Funzione per creare GUI di gioco
local function createGameGui(characterData)
    gameGui = Instance.new("ScreenGui")
    gameGui.Name = "DemonSlayerGui"
    gameGui.Parent = player.PlayerGui
    
    -- Frame principale HUD
    local hudFrame = Instance.new("Frame")
    hudFrame.Size = UDim2.new(0, 350, 0, 200)
    hudFrame.Position = UDim2.new(0, 10, 0, 10)
    hudFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    hudFrame.BackgroundTransparency = 0.3
    hudFrame.BorderSizePixel = 2
    hudFrame.BorderColor3 = characterData.color
    hudFrame.Parent = gameGui
    
    -- Nome personaggio
    local charNameLabel = Instance.new("TextLabel")
    charNameLabel.Size = UDim2.new(1, 0, 0, 30)
    charNameLabel.Position = UDim2.new(0, 0, 0, 5)
    charNameLabel.BackgroundTransparency = 1
    charNameLabel.Text = characterData.name
    charNameLabel.TextColor3 = characterData.color
    charNameLabel.TextScaled = true
    charNameLabel.Font = Enum.Font.SourceSansBold
    charNameLabel.Parent = hudFrame
    
    -- Barra salute
    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(0.9, 0, 0, 20)
    healthBar.Position = UDim2.new(0.05, 0, 0, 40)
    healthBar.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    healthBar.BorderSizePixel = 1
    healthBar.BorderColor3 = Color3.new(1, 1, 1)
    healthBar.Parent = hudFrame
    
    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.Position = UDim2.new(0, 0, 0, 0)
    healthFill.BackgroundColor3 = Color3.new(0, 1, 0)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBar
    
    -- Label salute
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0, 15)
    healthLabel.Position = UDim2.new(0, 0, 0, 65)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "Salute: 100%"
    healthLabel.TextColor3 = Color3.new(1, 1, 1)
    healthLabel.TextScaled = true
    healthLabel.Font = Enum.Font.SourceSans
    healthLabel.Parent = hudFrame
    
    -- Punteggio
    local scoreLabel = Instance.new("TextLabel")
    scoreLabel.Size = UDim2.new(1, 0, 0, 20)
    scoreLabel.Position = UDim2.new(0, 0, 0, 85)
    scoreLabel.BackgroundTransparency = 1
    scoreLabel.Text = "Punteggio: 0"
    scoreLabel.TextColor3 = Color3.new(1, 1, 1)
    scoreLabel.TextScaled = true
    scoreLabel.Font = Enum.Font.SourceSans
    scoreLabel.Parent = hudFrame
    
    -- Abilità
    local abilitiesFrame = Instance.new("Frame")
    abilitiesFrame.Size = UDim2.new(1, 0, 0, 80)
    abilitiesFrame.Position = UDim2.new(0, 0, 0, 110)
    abilitiesFrame.BackgroundTransparency = 1
    abilitiesFrame.Parent = hudFrame
    
    local abilityButtons = {}
    for i, abilityName in ipairs(characterData.abilities) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 22)
        button.Position = UDim2.new(0, 0, 0, (i-1) * 26)
        button.BackgroundColor3 = characterData.color
        button.BackgroundTransparency = 0.3
        button.Text = i .. ". " .. abilityName
        button.TextColor3 = Color3.new(1, 1, 1)
        button.TextScaled = true
        button.Font = Enum.Font.SourceSans
        button.BorderSizePixel = 1
        button.BorderColor3 = characterData.color
        button.Parent = abilitiesFrame
        
        abilityButtons[i] = button
        
        button.MouseButton1Click:Connect(function()
            useAbility(i)
        end)
    end
    
    -- Crosshair
    local crosshair = Instance.new("Frame")
    crosshair.Size = UDim2.new(0, 30, 0, 30)
    crosshair.Position = UDim2.new(0.5, -15, 0.5, -15)
    crosshair.BackgroundColor3 = characterData.color
    crosshair.BorderSizePixel = 2
    crosshair.BorderColor3 = Color3.new(1, 1, 1)
    crosshair.Parent = gameGui
    
    local crosshairCenter = Instance.new("Frame")
    crosshairCenter.Size = UDim2.new(0, 6, 0, 6)
    crosshairCenter.Position = UDim2.new(0.5, -3, 0.5, -3)
    crosshairCenter.BackgroundColor3 = Color3.new(1, 1, 1)
    crosshairCenter.BorderSizePixel = 0
    crosshairCenter.Parent = crosshair
    
    -- Funzioni di aggiornamento
    updateHealthEvent.OnClientEvent:Connect(function(health)
        local maxHealth = 120 -- Valore base, dovresti passarlo dal server
        local healthPercentage = health / maxHealth
        healthFill.Size = UDim2.new(healthPercentage, 0, 1, 0)
        healthLabel.Text = "Salute: " .. math.floor(healthPercentage * 100) .. "%"
        
        -- Cambia colore in base alla salute
        if healthPercentage > 0.6 then
            healthFill.BackgroundColor3 = Color3.new(0, 1, 0)
        elseif healthPercentage > 0.3 then
            healthFill.BackgroundColor3 = Color3.new(1, 1, 0)
        else
            healthFill.BackgroundColor3 = Color3.new(1, 0, 0)
        end
    end)
    
    updateScoreEvent.OnClientEvent:Connect(function(score)
        scoreLabel.Text = "Punteggio: " .. score
    end)
end

-- Funzione per usare abilità
function useAbility(abilityIndex)
    if selectedCharacter and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local camera = workspace.CurrentCamera
        local unitRay = camera:ScreenPointToRay(mouse.X, mouse.Y)
        local direction = unitRay.Direction.Unit
        
        useAbilityEvent:FireServer(abilityIndex, direction)
        
        -- Effetto visivo del crosshair
        if gameGui then
            local crosshair = gameGui:FindFirstChild("Frame", true)
            if crosshair then
                TweenService:Create(crosshair, TweenInfo.new(0.1), {BackgroundColor3 = Color3.new(1, 1, 1)}):Play()
                wait(0.1)
                TweenService:Create(crosshair, TweenInfo.new(0.1), {BackgroundColor3 = characters[selectedCharacter].color}):Play()
            end
        end
    end
end

-- Gestione input
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.One then
        useAbility(1)
    elseif input.KeyCode == Enum.KeyCode.Two then
        useAbility(2)
    elseif input.KeyCode == Enum.KeyCode.Three then
        useAbility(3)
    elseif input.KeyCode == Enum.KeyCode.Space then
        useAbility(1) -- Abilità principale con spazio
    end
end)

mouse.Button1Down:Connect(function()
    useAbility(1) -- Click sinistro per prima abilità
end)

mouse.Button2Down:Connect(function()
    useAbility(2) -- Click destro per seconda abilità
end)

-- Gestione eventi dal server
selectCharacterEvent.OnClientEvent:Connect(function(message)
    if message == "OpenSelection" then
        createCharacterSelection()
    end
end)

print("Demon Slayer Game Client loaded!")