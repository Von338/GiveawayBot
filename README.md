# 🗡️ Demon Slayer Game - Roblox

Un gioco multiplayer PvP ispirato all'anime **Demon Slayer** per Roblox, dove i giocatori possono scegliere tra i personaggi principali e combattere usando le loro tecniche di respirazione uniche.

## ⚔️ Personaggi Disponibili

### 🌊 **Tanjiro Kamado** - Water Breathing
- **Salute**: 120 HP
- **Velocità**: 18
- **Abilità**:
  - Water Surface Slash (35 danni)
  - Water Wheel (45 danni) 
  - Hinokami Kagura (70 danni)

### ⚡ **Zenitsu Agatsuma** - Thunder Breathing
- **Salute**: 100 HP
- **Velocità**: 25 (più veloce)
- **Abilità**:
  - Thunderclap and Flash (50 danni)
  - Rice Spirit (40 danni)
  - Thunder Swarm (60 danni)

### 🐗 **Inosuke Hashibira** - Beast Breathing
- **Salute**: 140 HP (più resistente)
- **Velocità**: 20
- **Abilità**:
  - Fang of the Beast (40 danni)
  - Rampaging Arc (55 danni)
  - Crazy Cutting (65 danni)

### 🌊 **Giyu Tomioka** - Water Breathing (Hashira)
- **Salute**: 150 HP
- **Velocità**: 22
- **Abilità**:
  - Dead Calm (60 danni)
  - Flowing Dance (50 danni)
  - Lull (80 danni)

### 🔥 **Kyojuro Rengoku** - Flame Breathing
- **Salute**: 160 HP (più resistente)
- **Velocità**: 20
- **Abilità**:
  - Unknowing Fire (55 danni)
  - Blooming Flame Undulation (65 danni)
  - Ninth Form: Rengoku (90 danni)

## 🎮 Come Giocare

### Controlli:
- **Click Sinistro** / **Spazio**: Usa prima abilità
- **Click Destro**: Usa seconda abilità
- **1, 2, 3**: Usa abilità specifica
- **WASD**: Movimento
- **Mouse**: Mira

### Meccaniche:
- Ogni personaggio ha **3 abilità uniche** con danni e cooldown diversi
- Gli attacchi creano **slash colorati** con effetti particellari
- Sistema di **knockback** realistico
- **Barra della salute** dinamica con cambio colore
- **Sistema di punteggio** basato sui colpi a segno

## 🏗️ Setup del Progetto

### Requisiti:
- **Roblox Studio**
- **Rojo** (per sincronizzare il codice)

### Installazione:
1. Clona questo repository
2. Apri Roblox Studio
3. Installa Rojo: `npm install -g rojo`
4. Avvia Rojo: `rojo serve`
5. In Roblox Studio: Plugins → Rojo → Connect

### Struttura del Progetto:
```
src/
├── server/           # Script server
│   └── DemonSlayerSystem.server.lua
├── client/           # Script client
│   └── scripts/
│       └── DemonSlayerClient.client.lua
├── shared/           # Configurazioni condivise
│   └── GameConfig.lua
└── workspace/        # Setup dell'arena
    └── SpawnPoints.lua
```

## 🎨 Caratteristiche

- **Selezione Personaggi**: Interfaccia elegante per scegliere il tuo Demon Slayer
- **Effetti Visivi**: Slash colorati, particelle e luci dinamiche
- **Arena Giapponese**: Dojo autentico con lanterne e ostacoli
- **Sistema PvP**: Combattimento multiplayer bilanciato
- **HUD Intuitivo**: Informazioni chiare su salute, punteggio e abilità

## 🚀 Prossime Funzionalità

- Più personaggi (Nezuko, Shinobu, Tengen, ecc.)
- Modalità demoni vs slayer
- Power-up temporanei
- Classifiche globali
- Animazioni custom per ogni tecnica

---

**Sviluppato con ❤️ per i fan di Demon Slayer**
