# 📖 Schritt-für-Schritt: GitHub-Chat in Claude Code öffnen

## 🎯 Ziel
Ein Chat in Claude Code öffnen, der direkt auf dein GitHub-Projekt zugreift und Änderungen pushen kann.

---

## 📋 Schritt 1: Terminal öffnen

1. **Windows:** PowerShell oder CMD öffnen
2. **Mac/Linux:** Terminal öffnen
3. Zum Projekt navigieren:

```bash
cd "C:\KI Programme\nestbau-app"
```

*(Wichtig: Du musst im Git-Repository sein)*

---

## 🔑 Schritt 2: GitHub Authentifizierung prüfen

Prüfe, ob GitHub bereits authentifiziert ist:

```bash
git config --global user.name
git config --global user.email
```

**Falls leer:** Einmal konfigurieren:

```bash
git config --global user.email "indra.kroeger@live.com"
git config --global user.name "Kildro93"
```

---

## 🚀 Schritt 3: Claude Code öffnen

### **Option A: Direkt mit Git-Repo (EMPFOHLEN)**

```bash
claude code
```

Das öffnet Claude Code mit deinem Projekt als Kontext.

---

### **Option B: Mit GitHub-Link direkt**

Oder in Claude Code (Web oder Desktop):

1. Gehe zu **claude.ai/code**
2. Klicke auf **"New Chat"** oder **"+"**
3. Gib ein:

```
https://github.com/Kildro93/Nestbau
```

Claude lädt dann automatisch dein Repo.

---

### **Option C: Dateiordner verbinden (Beste Option!)**

**Im Claude Desktop App:**

1. Öffne **Claude Desktop App**
2. Gehe zu **"Einstellungen" (⚙️)**
3. **"Ordner hinzufügen"** → `C:\KI Programme\nestbau-app`
4. Starte einen **neuen Chat**
5. Oben rechts: **"+ Datei/Ordner"** → wähle deinen Ordner

→ **Jetzt hat dieser Chat Zugriff auf dein Projekt UND GitHub!**

---

## 💬 Schritt 4: Im Chat mit GitHub arbeiten

Jetzt kannst du Claude sagen:

```
Ich möchte Feature X hinzufügen
Mach mir einen neuen Tab für...
Fix den Bug in index.html
Erstelle einen neuen Branch für...
Push die Änderungen zu GitHub
```

Claude kann dann:
- ✅ Dateien lesen
- ✅ Änderungen machen
- ✅ Git-Befehle ausführen
- ✅ Zu GitHub pushen

---

## 🔗 Schritt 5: GitHub-Integration aktivieren

Damit Claude **automatisch pushen** kann:

```bash
# Im Terminal (im Projekt-Ordner):
gh auth login
```

Das verbindet dein GitHub-Account mit Claude Code.

**Danach kann Claude:**
- Commits erstellen
- Branches pushen
- PRs öffnen (optional)

---

## ✅ Checkliste

- [ ] Im Projekt-Ordner (`C:\KI Programme\nestbau-app`)
- [ ] Git konfiguriert (`git config --global user.name` etc.)
- [ ] Claude Code geöffnet (lokal oder Web)
- [ ] GitHub-Auth aktiviert (`gh auth login`)
- [ ] Chat offen mit Projekt-Zugriff
- [ ] Bereit, Befehle zu geben!

---

## 🎯 Praktische Beispiele

### **Neue Funktion entwickeln:**

```
Du: Erstelle einen neuen Tab "Berichte" in der Nestbau-App.
Claude: [liest index.html, fügt Tab hinzu, tested es, pusht zu GitHub]
```

### **Bug fixen:**

```
Du: Der Kalender zeigt falsche Daten. Fixiere das.
Claude: [findet den Bug, behebt ihn, committed, pusht]
```

### **Refactoring:**

```
Du: Mach den Code in sw.js sauberer.
Claude: [refaktoriert, committed mit Nachricht, pusht]
```

---

## 🐛 Falls was nicht funktioniert

### **"Git nicht gefunden"**
```bash
# Git installieren von https://git-scm.com
# Dann Terminal neustarten
```

### **"GitHub-Authentifizierung fehlgeschlagen"**
```bash
gh auth logout
gh auth login
# Dann Browser-Dialog folgen
```

### **"Claude kann nicht pushen"**
```bash
# Prüfen, ob Remote richtig konfiguriert ist:
git remote -v

# Falls nicht:
git remote set-url origin https://github.com/Kildro93/Nestbau.git
```

---

## 🚀 **Fertig!**

Jetzt hast du einen Chat in Claude Code, der:
- ✅ Auf GitHub zugreift
- ✅ Dein Projekt liest
- ✅ Änderungen machen kann
- ✅ Automatisch pushen kann

**Los gehts! Gib Claude einen Befehl!** 🎉
