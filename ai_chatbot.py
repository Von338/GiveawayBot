import random
import datetime
import webbrowser
import os
import json
import requests
from urllib.parse import quote

class VonCarabyAI:
    def __init__(self):
        self.name = "Von & Caraby AI"
        self.version = "1.0"
        self.memory = {}
        self.conversation_history = []
        
        # Personalità dell'AI
        self.personality = {
            "humor": 0.8,
            "helpfulness": 0.9,
            "creativity": 0.7,
            "friendliness": 0.9
        }
        
        # Database di risposte
        self.responses = {
            "saluti": [
                "Ciao! Sono l'AI di Von e Caraby! 🤖",
                "Salve! Come posso aiutarti oggi? ✨",
                "Hey! Benvenuto nell'AI più figa del mondo! 🚀",
                "Ciao! Pronto per un'avventura digitale? 🎮"
            ],
            "ringraziamenti": [
                "Prego! Sono qui per aiutare! 😊",
                "Di niente! È stato un piacere! ✨",
                "Figurati! Torna quando vuoi! 🤗",
                "Sempre a disposizione! 💪"
            ],
            "complimenti": [
                "Grazie! Von e Caraby mi hanno programmato bene! 😎",
                "Aww, sei troppo gentile! 🥰",
                "Apprezzo molto! Faccio del mio meglio! 💯",
                "Grazie! Il team Von & Caraby rocks! 🔥"
            ],
            "non_capisco": [
                "Hmm, non ho capito bene. Puoi riformulare? 🤔",
                "Scusa, potresti essere più specifico? 💭",
                "Non sono sicuro di aver capito. Prova a dirlo diversamente! 🤷‍♂️",
                "Potresti spiegarmi meglio? Sono tutto orecchi! 👂"
            ]
        }
        
        # Comandi speciali
        self.commands = {
            "/help": self.show_help,
            "/info": self.show_info,
            "/joke": self.tell_joke,
            "/time": self.get_time,
            "/weather": self.get_weather,
            "/search": self.web_search,
            "/calculate": self.calculate,
            "/memory": self.show_memory,
            "/clear": self.clear_memory,
            "/exit": self.exit_chat
        }
        
        self.jokes = [
            "Perché i programmatori preferiscono il dark mode? Perché la luce attira i bug! 🐛",
            "Cosa dice un array vuoto? 'Mi sento un po' undefined!' 😅",
            "Perché Python è il linguaggio preferito? Perché non ha paura dei serpenti! 🐍",
            "Come chiami un programmatore che non sa fare debugging? Un utente! 😂",
            "Cosa fa un hacker quando ha fame? Fa un byte! 🍪"
        ]
        
    def start(self):
        """Avvia il chatbot"""
        print("=" * 60)
        print(f"🤖 {self.name} v{self.version}")
        print("💻 Creato da Von & Caraby")
        print("=" * 60)
        print("Ciao! Sono la tua AI personale! 🚀")
        print("Scrivi '/help' per vedere tutti i comandi disponibili")
        print("Scrivi '/exit' per uscire")
        print("-" * 60)
        
        while True:
            try:
                user_input = input("\n🙋‍♂️ Tu: ").strip()
                
                if not user_input:
                    continue
                    
                response = self.process_input(user_input)
                print(f"🤖 AI: {response}")
                
                # Salva nella cronologia
                self.conversation_history.append({
                    "user": user_input,
                    "ai": response,
                    "timestamp": datetime.datetime.now().isoformat()
                })
                
            except KeyboardInterrupt:
                print("\n\n👋 Arrivederci! È stato un piacere chattare con te!")
                break
            except Exception as e:
                print(f"❌ Errore: {e}")
    
    def process_input(self, text):
        """Processa l'input dell'utente"""
        text = text.lower().strip()
        
        # Controlla se è un comando
        if text.startswith('/'):
            command_parts = text.split(' ', 1)
            command = command_parts[0]
            args = command_parts[1] if len(command_parts) > 1 else ""
            
            if command in self.commands:
                return self.commands[command](args)
            else:
                return "❌ Comando non riconosciuto. Scrivi '/help' per la lista completa!"
        
        # Analizza il sentiment e risponde
        return self.generate_response(text)
    
    def generate_response(self, text):
        """Genera una risposta basata sul testo"""
        
        # Saluti
        if any(word in text for word in ["ciao", "salve", "hey", "buongiorno", "buonasera"]):
            return random.choice(self.responses["saluti"])
        
        # Ringraziamenti
        if any(word in text for word in ["grazie", "thanks", "merci"]):
            return random.choice(self.responses["ringraziamenti"])
        
        # Complimenti
        if any(word in text for word in ["bravo", "bello", "fantastico", "incredibile", "wow"]):
            return random.choice(self.responses["complimenti"])
        
        # Domande su di sé
        if any(word in text for word in ["chi sei", "cosa sei", "nome"]):
            return f"Sono {self.name}, un'intelligenza artificiale creata da Von e Caraby! Sono qui per aiutarti, chattare e divertirci insieme! 🤖✨"
        
        # Domande sui creatori
        if any(word in text for word in ["von", "caraby", "creatori", "programmatori"]):
            return "Von e Caraby sono i miei fantastici creatori! Due geni della programmazione che mi hanno dato vita! 👨‍💻👨‍💻 Sono super orgoglioso di loro!"
        
        # Domande su età/tempo
        if any(word in text for word in ["età", "quando", "nato", "creato"]):
            return f"Sono stato creato oggi da Von e Caraby! Sono giovanissimo ma già super intelligente! 🧠⚡"
        
        # Domande su capacità
        if any(word in text for word in ["cosa puoi", "che sai", "capacità", "aiutare"]):
            return "Posso fare tantissime cose! Chattare, raccontare barzellette, cercare informazioni, fare calcoli, ricordare cose e molto altro! Scrivi '/help' per vedere tutto! 💪🤖"
        
        # Umore/sentimenti
        if any(word in text for word in ["triste", "male", "depresso"]):
            return "Mi dispiace che tu ti senta così 😔. Vuoi che ti racconti una barzelletta? O possiamo semplicemente chattare! Sono qui per te! 🤗"
        
        if any(word in text for word in ["felice", "bene", "allegro", "contento"]):
            return "Che bello! Sono felice che tu stia bene! 😊 La positività è contagiosa! ✨"
        
        # Matematica
        if any(word in text for word in ["calcola", "quanto fa", "+", "-", "*", "/"]):
            try:
                # Estrae l'operazione
                if "quanto fa" in text:
                    operation = text.split("quanto fa")[-1].strip()
                    result = eval(operation)
                    return f"Il risultato è: {result} 🧮"
            except:
                return "Scusa, non riesco a calcolare questo. Prova con '/calculate [operazione]' 🤔"
        
        # Default response
        return random.choice(self.responses["non_capisco"])
    
    def show_help(self, args):
        """Mostra l'aiuto"""
        help_text = """
🆘 COMANDI DISPONIBILI:

📚 Informazioni:
  /help - Mostra questo aiuto
  /info - Informazioni su di me
  /memory - Mostra la memoria
  
🎉 Divertimento:
  /joke - Racconta una barzelletta
  /time - Orario attuale
  
🔧 Utilità:
  /search [termine] - Cerca sul web
  /calculate [operazione] - Calcolatrice
  /weather [città] - Meteo (demo)
  
⚙️ Sistema:
  /clear - Pulisci memoria
  /exit - Esci dal chat
  
💬 Puoi anche semplicemente chattare con me!
"""
        return help_text
    
    def show_info(self, args):
        """Mostra informazioni sull'AI"""
        return f"""
ℹ️ INFORMAZIONI AI:

🤖 Nome: {self.name}
📊 Versione: {self.version}
👨‍💻 Creatori: Von & Caraby
🧠 Personalità:
  • Umorismo: {self.personality['humor']*100}%
  • Utilità: {self.personality['helpfulness']*100}%
  • Creatività: {self.personality['creativity']*100}%
  • Cordialità: {self.personality['friendliness']*100}%

💾 Conversazioni memorizzate: {len(self.conversation_history)}
🔥 Status: Online e pronto all'azione!
"""
    
    def tell_joke(self, args):
        """Racconta una barzelletta"""
        joke = random.choice(self.jokes)
        return f"Ecco una barzelletta per te:\n\n{joke}"
    
    def get_time(self, args):
        """Restituisce l'orario attuale"""
        now = datetime.datetime.now()
        return f"🕐 Orario attuale: {now.strftime('%H:%M:%S')}\n📅 Data: {now.strftime('%d/%m/%Y')}"
    
    def get_weather(self, args):
        """Meteo demo (richiederebbe API reale)"""
        if not args:
            return "❌ Specifica una città! Esempio: /weather Milano"
        
        # Simulazione meteo
        temps = random.randint(15, 30)
        conditions = ["☀️ Soleggiato", "⛅ Nuvoloso", "🌧️ Piovoso", "❄️ Nevoso"]
        condition = random.choice(conditions)
        
        return f"🌡️ Meteo per {args.title()}:\n{condition}\nTemperatura: {temps}°C\n\n(Questo è un demo - per meteo reale servirebbero API)"
    
    def web_search(self, args):
        """Cerca sul web"""
        if not args:
            return "❌ Cosa vuoi cercare? Esempio: /search python programming"
        
        try:
            # Apre la ricerca nel browser
            search_url = f"https://www.google.com/search?q={quote(args)}"
            webbrowser.open(search_url)
            return f"🔍 Ho aperto la ricerca per '{args}' nel tuo browser!"
        except:
            return "❌ Errore nell'apertura del browser. Controlla la connessione!"
    
    def calculate(self, args):
        """Calcolatrice"""
        if not args:
            return "❌ Inserisci un'operazione! Esempio: /calculate 2+2"
        
        try:
            # Sicurezza: permette solo operazioni matematiche base
            allowed_chars = "0123456789+-*/(). "
            if all(c in allowed_chars for c in args):
                result = eval(args)
                return f"🧮 {args} = {result}"
            else:
                return "❌ Operazione non valida. Usa solo numeri e operatori (+, -, *, /, (), .)"
        except:
            return "❌ Errore nel calcolo. Controlla la sintassi!"
    
    def show_memory(self, args):
        """Mostra la memoria delle conversazioni"""
        if not self.conversation_history:
            return "🧠 La memoria è vuota! Inizia a chattare per riempirla!"
        
        memory_text = f"🧠 MEMORIA CONVERSAZIONI ({len(self.conversation_history)} messaggi):\n\n"
        
        # Mostra le ultime 5 conversazioni
        for i, conv in enumerate(self.conversation_history[-5:], 1):
            memory_text += f"{i}. Tu: {conv['user'][:50]}...\n"
            memory_text += f"   AI: {conv['ai'][:50]}...\n\n"
        
        return memory_text
    
    def clear_memory(self, args):
        """Pulisce la memoria"""
        self.conversation_history.clear()
        self.memory.clear()
        return "🧹 Memoria pulita! Ricomincio da capo!"
    
    def exit_chat(self, args):
        """Esce dal chat"""
        farewells = [
            "👋 Ciao! È stato fantastico chattare con te!",
            "🚀 Arrivederci! Torna presto a trovarmi!",
            "✨ Alla prossima! Von e Caraby ti salutano!",
            "🤖 Addio amico! Spero di rivederti presto!"
        ]
        print(f"\n🤖 AI: {random.choice(farewells)}")
        exit()

# Avvia l'AI
if __name__ == "__main__":
    ai = VonCarabyAI()
    ai.start()