# Prompt-Typen-Guide: Code vs Chat vs Cowork

> Übersicht: Welchen Claude-Modus für welche Aufgabe nutzen.

---

## Die drei Modi

### Claude Chat (claude.ai / App)
**Wofür:** Denken, Planen, Texte, Recherche, Brainstorming

- Fragen beantworten, Konzepte erklären
- Texte schreiben, übersetzen, zusammenfassen
- Vault-Inhalte besprechen & strukturieren
- Prompts entwerfen & verfeinern
- Lernmaterial erstellen (Primarlehrer-Studium)
- Rezepte & Koch-Wissen aufbereiten

**Stärken:** Schnell, günstig, gut für Konversation & iteratives Arbeiten
**Grenzen:** Kein Dateizugriff, kein Code ausführen, keine Tools

---

### Claude Code (Terminal / CLI)
**Wofür:** Programmieren, Dateien bearbeiten, Git, Automatisierung

- Code schreiben, debuggen, refactoren
- Git-Operationen (commit, push, branch)
- Dateien lesen, erstellen, bearbeiten auf dem lokalen System
- Scripts ausführen (PowerShell, Python, Node)
- Vault-Dateien direkt bearbeiten & pushen
- Build-Prozesse, Tests, Deployments

**Stärken:** Voller Dateisystem-Zugriff, Code-Ausführung, Git-Integration
**Grenzen:** Terminal-basiert, kein visuelles UI, erfordert CLI-Kenntnisse

---

### Cowork (Claude Desktop App)
**Wofür:** Dateien + Denken kombiniert, visuell arbeiten

- Dateien auf dem Computer lesen & bearbeiten (über Ordner-Verbindung)
- Dokumente erstellen (Word, Excel, PowerPoint, PDF)
- Vault-Dateien direkt im Ordner erstellen/ändern
- Browser-Automatisierung (Chrome, eingebauter Browser)
- Recherche + Datei-Output in einem Schritt
- Längere Aufgaben, die im Hintergrund laufen

**Stärken:** Kombination aus Chat + Dateizugriff + Tools, läuft im Hintergrund weiter
**Grenzen:** Kein direkter Git-Zugriff (nur über device_bash), braucht Desktop-App

---

## Entscheidungshilfe

| Aufgabe | Modus |
|---------|-------|
| Frage beantworten | Chat |
| Text/Prompt schreiben | Chat |
| Code schreiben & testen | Code |
| Git commit & push | Code |
| Vault-Datei erstellen (ohne Git) | Cowork |
| Vault reorganisieren + pushen | Code |
| Word/Excel/PDF erstellen | Cowork |
| Lernmaterial zusammenstellen | Chat → Cowork (für Datei) |
| Bot-Prompt entwerfen | Chat |
| Bot-Prompt ausführen (mit Dateien) | Code oder Cowork |
| Browser-Aufgabe automatisieren | Cowork |
| Debugging & Logs analysieren | Code |
| Projektplanung & Strategie | Chat |
| Mehrere Dateien gleichzeitig bearbeiten | Code |

## Faustregel

- **Nur denken/reden?** → Chat
- **Dateien anfassen?** → Cowork (visuell) oder Code (Terminal)
- **Git involviert?** → Code
- **Im Hintergrund laufen lassen?** → Cowork
