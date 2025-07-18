-- Script per creare punti di spawn nel workspace
local spawnLocations = {
    Vector3.new(0, 10, 0),
    Vector3.new(20, 10, 20),
    Vector3.new(-20, 10, 20),
    Vector3.new(20, 10, -20),
    Vector3.new(-20, 10, -20)
}

-- Crea le piattaforme di spawn
for i, position in ipairs(spawnLocations) do
    local spawnPart = Instance.new("Part")
    spawnPart.Name = "SpawnPlatform" .. i
    spawnPart.Size = Vector3.new(8, 1, 8)
    spawnPart.Position = position
    spawnPart.BrickColor = BrickColor.new("Bright blue")
    spawnPart.Material = Enum.Material.Neon
    spawnPart.Anchored = true
    spawnPart.CanCollide = true
    spawnPart.Parent = workspace
    
    -- Aggiungi un SpawnLocation
    local spawn = Instance.new("SpawnLocation")
    spawn.Size = Vector3.new(8, 1, 8)
    spawn.Position = position + Vector3.new(0, 0.5, 0)
    spawn.BrickColor = BrickColor.new("Bright green")
    spawn.Material = Enum.Material.ForceField
    spawn.Anchored = true
    spawn.CanCollide = false
    spawn.Transparency = 0.5
    spawn.Parent = workspace
end

-- Crea il terreno base
local basePlate = Instance.new("Part")
basePlate.Name = "BasePlate"
basePlate.Size = Vector3.new(100, 1, 100)
basePlate.Position = Vector3.new(0, -0.5, 0)
basePlate.BrickColor = BrickColor.new("Bright green")
basePlate.Material = Enum.Material.Grass
basePlate.Anchored = true
basePlate.CanCollide = true
basePlate.Parent = workspace

print("Spawn points created!")