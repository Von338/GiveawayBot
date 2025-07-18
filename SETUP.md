# 🛠️ Setup Guida - Demon Slayer Game

Questa guida ti aiuterà a configurare e avviare il gioco Demon Slayer in Roblox Studio.

## 📋 Prerequisiti

### 1. Installa Roblox Studio
- Scarica da [roblox.com/create](https://www.roblox.com/create)
- Accedi con il tuo account Roblox

### 2. Installa Node.js (per Rojo)
- Scarica da [nodejs.org](https://nodejs.org/)
- Versione consigliata: LTS (Long Term Support)

### 3. Installa Rojo
```bash
npm install -g rojo
```

## 🚀 Setup del Progetto

### Passo 1: Avvia Rojo
Apri il terminale nella cartella del progetto e esegui:
```bash
rojo serve
```

Dovresti vedere:
```
Rojo server listening on http://127.0.0.1:34872
```

### Passo 2: Configura Roblox Studio
1. Apri **Roblox Studio**
2. Vai su **Plugins** → **Manage Plugins**
3. Cerca e installa **Rojo**
4. Riavvia Roblox Studio se necessario

### Passo 3: Connetti Rojo
1. In Roblox Studio, vai su **Plugins** → **Rojo** → **Connect**
2. Usa l'indirizzo: `http://127.0.0.1:34872`
3. Clicca **Connect**

### Passo 4: Sync del Progetto
1. Clicca **Sync In** per importare tutti i file
2. Attendi che tutti gli script siano caricati
3. Dovresti vedere la struttura del progetto nell'Explorer

## 🎮 Test del Gioco

### Test in Studio
1. Clicca **Play** (F5) in Roblox Studio
2. Dovrebbe apparire la schermata di selezione personaggio
3. Scegli un personaggio e inizia a combattere!

### Test Multiplayer
1. Clicca **Play** → **Start Server** (F7)
2. Poi clicca **Players** → **2 Players** per testare con più giocatori
3. Testa il combattimento PvP

## 🔧 Risoluzione Problemi

### Problema: Rojo non si connette
**Soluzione:**
- Verifica che il server Rojo sia avviato
- Controlla che la porta 34872 non sia usata da altre applicazioni
- Riavvia sia Rojo che Roblox Studio

### Problema: Script non funzionano
**Soluzione:**
- Verifica che tutti i file siano stati sincronizzati
- Controlla la console per errori (View → Output)
- Assicurati che i RemoteEvents siano stati creati correttamente

### Problema: GUI non appare
**Soluzione:**
- Controlla che StarterPlayerScripts contenga il client script
- Verifica che ReplicatedStorage abbia i RemoteEvents
- Testa in modalità Play, non Edit

## 📁 Struttura File Spiegata

```
📦 Progetto
├── 📄 default.project.json    # Configurazione Rojo principale
├── 📄 rojofile.toml           # Configurazione Rojo alternativa
├── 📂 src/
│   ├── 📂 server/             # Script lato server
│   │   └── 📄 DemonSlayerSystem.server.lua
│   ├── 📂 client/             # Script lato client
│   │   └── 📂 scripts/
│   │       └── 📄 DemonSlayerClient.client.lua
│   ├── 📂 shared/             # Configurazioni condivise
│   │   └── 📄 GameConfig.lua
│   └── 📂 workspace/          # Setup arena di gioco
│       └── 📄 SpawnPoints.lua
```

## 🎯 Personalizzazione

### Aggiungere Nuovi Personaggi
1. Modifica `DemonSlayerSystem.server.lua` - sezione `characters`
2. Aggiorna `DemonSlayerClient.client.lua` - sezione `characters`
3. Aggiungi configurazioni in `GameConfig.lua`

### Modificare Abilità
- Cambia `damage`, `cooldown`, `range` nelle configurazioni personaggi
- Personalizza gli effetti visivi nella funzione `createSlashEffect`

### Personalizzare Arena
- Modifica `SpawnPoints.lua` per cambiare l'aspetto del dojo
- Aggiungi ostacoli, decorazioni o nuove piattaforme

## 📞 Supporto

Se hai problemi:
1. Controlla la console Output in Roblox Studio
2. Verifica che Rojo sia aggiornato: `npm update -g rojo`
3. Riavvia tutto: chiudi Studio, ferma Rojo (Ctrl+C), riavvia entrambi

---

**Buon sviluppo! 🗡️**