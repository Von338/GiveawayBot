-- Fireballs Game - Client Script
-- Gestisce l'input del giocatore e l'interfaccia

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Aspetta che gli eventi remoti siano disponibili
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local shootFireballEvent = remoteEvents:WaitForChild("ShootFireball")
local updateScoreEvent = remoteEvents:WaitForChild("UpdateScore")

-- Variabili per il cooldown
local lastShotTime = 0
local shotCooldown = 0.5 -- Mezzo secondo tra i colpi

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FireballsGui"
screenGui.Parent = player.PlayerGui

-- Frame principale
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 150)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.new(1, 0.5, 0)
mainFrame.Parent = screenGui

-- Titolo
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🔥 FIREBALLS GAME 🔥"
titleLabel.TextColor3 = Color3.new(1, 0.5, 0)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame

-- Punteggio
local scoreLabel = Instance.new("TextLabel")
scoreLabel.Size = UDim2.new(1, 0, 0, 25)
scoreLabel.Position = UDim2.new(0, 0, 0, 35)
scoreLabel.BackgroundTransparency = 1
scoreLabel.Text = "Score: 0"
scoreLabel.TextColor3 = Color3.new(1, 1, 1)
scoreLabel.TextScaled = true
scoreLabel.Font = Enum.Font.SourceSans
scoreLabel.Parent = mainFrame

-- Istruzioni
local instructionsLabel = Instance.new("TextLabel")
instructionsLabel.Size = UDim2.new(1, 0, 0, 60)
instructionsLabel.Position = UDim2.new(0, 0, 0, 65)
instructionsLabel.BackgroundTransparency = 1
instructionsLabel.Text = "Click to shoot fireballs!\nHit other players to score!\nMove with WASD"
instructionsLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
instructionsLabel.TextScaled = true
instructionsLabel.Font = Enum.Font.SourceSans
instructionsLabel.Parent = mainFrame

-- Crosshair
local crosshair = Instance.new("Frame")
crosshair.Size = UDim2.new(0, 20, 0, 20)
crosshair.Position = UDim2.new(0.5, -10, 0.5, -10)
crosshair.BackgroundColor3 = Color3.new(1, 0, 0)
crosshair.BorderSizePixel = 2
crosshair.BorderColor3 = Color3.new(1, 1, 1)
crosshair.Parent = screenGui

local crosshairInner = Instance.new("Frame")
crosshairInner.Size = UDim2.new(0, 4, 0, 4)
crosshairInner.Position = UDim2.new(0.5, -2, 0.5, -2)
crosshairInner.BackgroundColor3 = Color3.new(1, 1, 1)
crosshairInner.BorderSizePixel = 0
crosshairInner.Parent = crosshair

-- Funzione per sparare fireball
local function shootFireball()
    local currentTime = tick()
    if currentTime - lastShotTime < shotCooldown then
        return -- Ancora in cooldown
    end
    
    lastShotTime = currentTime
    
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        -- Calcola la direzione verso il mouse
        local camera = workspace.CurrentCamera
        local unitRay = camera:ScreenPointToRay(mouse.X, mouse.Y)
        local direction = unitRay.Direction.Unit
        
        -- Invia l'evento al server
        shootFireballEvent:FireServer(direction)
        
        -- Effetto visivo del crosshair
        crosshair.BackgroundColor3 = Color3.new(1, 1, 0)
        wait(0.1)
        crosshair.BackgroundColor3 = Color3.new(1, 0, 0)
    end
end

-- Gestione input
mouse.Button1Down:Connect(shootFireball)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Space then
        shootFireball()
    end
end)

-- Aggiorna punteggio
updateScoreEvent.OnClientEvent:Connect(function(score)
    scoreLabel.Text = "Score: " .. score
end)

print("Fireballs Game Client loaded!")