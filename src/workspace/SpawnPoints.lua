-- Script per creare l'arena di battaglia in stile Demon Slayer
local spawnLocations = {
    Vector3.new(0, 10, 0),
    Vector3.new(25, 10, 25),
    Vector3.new(-25, 10, 25),
    Vector3.new(25, 10, -25),
    Vector3.new(-25, 10, -25),
    Vector3.new(0, 10, 30),
    Vector3.new(0, 10, -30)
}

-- Crea le piattaforme di spawn in stile giapponese
for i, position in ipairs(spawnLocations) do
    -- Piattaforma principale
    local spawnPart = Instance.new("Part")
    spawnPart.Name = "SpawnPlatform" .. i
    spawnPart.Size = Vector3.new(10, 1, 10)
    spawnPart.Position = position
    spawnPart.BrickColor = BrickColor.new("Dark stone grey")
    spawnPart.Material = Enum.Material.Rock
    spawnPart.Anchored = true
    spawnPart.CanCollide = true
    spawnPart.Parent = workspace
    
    -- Bordo decorativo
    local border = Instance.new("Part")
    border.Name = "PlatformBorder" .. i
    border.Size = Vector3.new(12, 0.5, 12)
    border.Position = position - Vector3.new(0, 0.75, 0)
    border.BrickColor = BrickColor.new("Really black")
    border.Material = Enum.Material.Marble
    border.Anchored = true
    border.CanCollide = true
    border.Parent = workspace
    
    -- SpawnLocation
    local spawn = Instance.new("SpawnLocation")
    spawn.Size = Vector3.new(10, 1, 10)
    spawn.Position = position + Vector3.new(0, 0.5, 0)
    spawn.BrickColor = BrickColor.new("Bright blue")
    spawn.Material = Enum.Material.ForceField
    spawn.Anchored = true
    spawn.CanCollide = false
    spawn.Transparency = 0.7
    spawn.Parent = workspace
    
    -- Lanterna giapponese
    local lantern = Instance.new("Part")
    lantern.Name = "Lantern" .. i
    lantern.Size = Vector3.new(2, 6, 2)
    lantern.Position = position + Vector3.new(6, 3.5, 0)
    lantern.BrickColor = BrickColor.new("Bright red")
    lantern.Material = Enum.Material.Neon
    lantern.Anchored = true
    lantern.CanCollide = false
    lantern.Shape = Enum.PartType.Cylinder
    lantern.Parent = workspace
    
    -- Luce della lanterna
    local light = Instance.new("PointLight")
    light.Color = Color3.new(1, 0.5, 0)
    light.Brightness = 2
    light.Range = 20
    light.Parent = lantern
end

-- Terreno principale (tatami style)
local basePlate = Instance.new("Part")
basePlate.Name = "DojoFloor"
basePlate.Size = Vector3.new(120, 1, 120)
basePlate.Position = Vector3.new(0, -0.5, 0)
basePlate.BrickColor = BrickColor.new("Reddish brown")
basePlate.Material = Enum.Material.Wood
basePlate.Anchored = true
basePlate.CanCollide = true
basePlate.Parent = workspace

-- Aggiunge texture al pavimento
local texture = Instance.new("Texture")
texture.Face = Enum.NormalId.Top
texture.Texture = "rbxasset://textures/wood_texture.jpg"
texture.StudsPerTileU = 4
texture.StudsPerTileV = 4
texture.Parent = basePlate

-- Muri del dojo
local walls = {
    {pos = Vector3.new(0, 10, 60), size = Vector3.new(120, 20, 1)},
    {pos = Vector3.new(0, 10, -60), size = Vector3.new(120, 20, 1)},
    {pos = Vector3.new(60, 10, 0), size = Vector3.new(1, 20, 120)},
    {pos = Vector3.new(-60, 10, 0), size = Vector3.new(1, 20, 120)}
}

for i, wallData in ipairs(walls) do
    local wall = Instance.new("Part")
    wall.Name = "DojoWall" .. i
    wall.Size = wallData.size
    wall.Position = wallData.pos
    wall.BrickColor = BrickColor.new("Dark stone grey")
    wall.Material = Enum.Material.Brick
    wall.Anchored = true
    wall.CanCollide = true
    wall.Parent = workspace
end

-- Crea alcuni ostacoli/piattaforme per il combattimento
local obstacles = {
    {pos = Vector3.new(15, 5, 15), size = Vector3.new(8, 10, 8)},
    {pos = Vector3.new(-15, 5, 15), size = Vector3.new(8, 10, 8)},
    {pos = Vector3.new(15, 5, -15), size = Vector3.new(8, 10, 8)},
    {pos = Vector3.new(-15, 5, -15), size = Vector3.new(8, 10, 8)},
    {pos = Vector3.new(0, 3, 0), size = Vector3.new(6, 6, 6)}
}

for i, obstData in ipairs(obstacles) do
    local obstacle = Instance.new("Part")
    obstacle.Name = "Obstacle" .. i
    obstacle.Size = obstData.size
    obstacle.Position = obstData.pos
    obstacle.BrickColor = BrickColor.new("Medium stone grey")
    obstacle.Material = Enum.Material.Rock
    obstacle.Anchored = true
    obstacle.CanCollide = true
    obstacle.Parent = workspace
    
    -- Aggiungi un po' di vegetazione sui pilastri
    if i <= 4 then
        local plant = Instance.new("Part")
        plant.Name = "Plant" .. i
        plant.Size = Vector3.new(2, 3, 2)
        plant.Position = obstData.pos + Vector3.new(0, obstData.size.Y/2 + 1.5, 0)
        plant.BrickColor = BrickColor.new("Bright green")
        plant.Material = Enum.Material.Grass
        plant.Anchored = true
        plant.CanCollide = false
        plant.Shape = Enum.PartType.Ball
        plant.Parent = workspace
    end
end

-- Cielo e illuminazione
local lighting = game:GetService("Lighting")
lighting.TimeOfDay = "18:00:00" -- Tramonto per atmosfera drammatica
lighting.Ambient = Color3.new(0.2, 0.2, 0.3)
lighting.Brightness = 2
lighting.FogEnd = 200
lighting.FogColor = Color3.new(0.8, 0.6, 0.4)

print("Dojo arena created - Ready for Demon Slayer battles!")