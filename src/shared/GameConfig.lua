-- Configurazioni condivise per il gioco Fireballs
local GameConfig = {}

-- Impostazioni Fireball
GameConfig.Fireball = {
    Speed = 50,
    Damage = 25,
    Size = Vector3.new(2, 2, 2),
    Lifetime = 5,
    ExplosionRadius = 20,
    ExplosionPressure = 500000
}

-- Impostazioni Punteggio
GameConfig.Scoring = {
    HitPoints = 10,
    KillPoints = 25
}

-- Impostazioni Giocatore
GameConfig.Player = {
    ShotCooldown = 0.5,
    MaxHealth = 100
}

-- Colori
GameConfig.Colors = {
    Fireball = BrickColor.new("Bright red"),
    FireLight = Color3.new(1, 0.5, 0),
    UI = {
        Primary = Color3.new(1, 0.5, 0),
        Secondary = Color3.new(1, 1, 1),
        Background = Color3.new(0, 0, 0)
    }
}

return GameConfig