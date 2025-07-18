-- Configurazioni condivise per il gioco Demon Slayer
local GameConfig = {}

-- Configurazioni personaggi
GameConfig.Characters = {
    Tanjiro = {
        baseHealth = 120,
        baseSpeed = 18,
        breathingStyle = "Water Breathing"
    },
    Zenitsu = {
        baseHealth = 100,
        baseSpeed = 25,
        breathingStyle = "Thunder Breathing"
    },
    Inosuke = {
        baseHealth = 140,
        baseSpeed = 20,
        breathingStyle = "Beast Breathing"
    },
    Giyu = {
        baseHealth = 150,
        baseSpeed = 22,
        breathingStyle = "Water Breathing (Hashira)"
    },
    Rengoku = {
        baseHealth = 160,
        baseSpeed = 20,
        breathingStyle = "Flame Breathing"
    }
}

-- Impostazioni Abilità
GameConfig.Abilities = {
    BaseDamage = 35,
    BaseRange = 25,
    BaseCooldown = 2
}

-- Impostazioni Punteggio
GameConfig.Scoring = {
    HitPoints = 15,
    KillPoints = 50
}

-- Effetti visivi
GameConfig.Effects = {
    SlashDuration = 1,
    ParticleCount = 10,
    KnockbackForce = 30
}

-- Colori per stili di respirazione
GameConfig.Colors = {
    Water = Color3.new(0, 0.5, 1),
    Thunder = Color3.new(1, 1, 0),
    Beast = Color3.new(0.6, 0.3, 0),
    Flame = Color3.new(1, 0.5, 0),
    UI = {
        Primary = Color3.new(0.8, 0.8, 0.9),
        Secondary = Color3.new(1, 1, 1),
        Background = Color3.new(0.1, 0.1, 0.2)
    }
}

return GameConfig