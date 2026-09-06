# 🚀 GitHub Standards & Naming-Konventionen

**Diese Regeln gelten für alle Projekte, die Claude automatisch erstellt**

---

## 📝 Repo-Naming

### Format
- **Stil**: `kebab-case` (Wörter mit Bindestrich, keine Leerzeichen)
- **Länge**: Max. 30 Zeichen
- **Beispiele**:
  - ✅ `household-app`
  - ✅ `anime-tracker`
  - ✅ `nestbau`
  - ❌ `Household_App` (Underscore)
  - ❌ `household app` (Leerzeichen)
  - ❌ `HouseholdApp` (CamelCase)

### Aussagekraft
- Repo-Name sollte sofort klar machen, was das Projekt ist
- Kurz, prägnant, merkbar
- **Nicht**: `project-1`, `test`, `stuff`

---

## 🏷️ Topics & Tags

Automatisch gesetzte Topics:
- **Tech-Stack**: `react`, `typescript`, `nodejs`, etc.
- **Kategorie**: `fullstack`, `frontend`, `backend`, `utility`
- **Besonderheiten**: `pwa`, `mobile`, `learning`, `experiment`
- **System-Tag**: `claude-automation` (immer gesetzt)

---

## 📄 Automatische Dateien

Diese Dateien werden **immer** automatisch erstellt/aktualisiert:

### `README.md`
```
# [Projektname]

[Beschreibung]

## Features
- Feature 1
- Feature 2

## Installation
[Setup-Anleitung]

## Tech Stack
- Sprache(n)
- Frameworks
- Besonderheiten

## Author
Created by Claude Automation
```

### `.gitignore`
Automatisch basierend auf Tech-Stack:
- Node.js: `node_modules/`, `dist/`, `.env`
- Python: `__pycache__/`, `venv/`, `.env`
- General: `.DS_Store`, `*.log`, `.vscode/`

### `LICENSE`
- **Default**: MIT (kostenlos, Bedingungen minimal)
- **Alternative**: Specify in Projekt-Datei

### `.github/workflows/` (optional)
- Automatische Tests
- Deployment-Pipeline

---

## 🔐 Visibility & Permissions

- **Public**: Sichtbar für alle (default)
- **Private**: Nur du (wenn in Projekt-Datei angegeben)
- **Archive**: Automatisch bei Status `archived`

---

## 🌿 Branch-Struktur

### Main Branch
- `main` = Production-Ready Code
- Protected: PR-Review erforderlich (optional)
- Auto-delete branches nach PR-Merge

### Develop Branch (optional)
- `develop` = Aktive Entwicklung
- Basis für Feature-Branches
- Nur wenn Multi-Branch-Workflow gewünscht

---

## 💬 Commit-Nachricht Format

Wenn du selbst committst (über Git CLI):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**:
- `feat`: Neue Funktion
- `fix`: Bug-Fix
- `docs`: Dokumentation
- `style`: Code-Formatierung
- `refactor`: Code-Umstrukturierung
- `test`: Tests hinzufügen
- `chore`: Build, Dependencies, etc.

**Beispiel**:
```
feat(auth): add Google Sign-In

- Integrate Firebase Authentication
- Add Google OAuth provider
- Update login screen

Closes #42
```

---

## 🔄 Automatische Updates

Claude aktualisiert automatisch:

✅ **README.md** — Wenn Beschreibung/Features sich ändern
✅ **Topics** — Neu gesetzt bei jeder Sync
✅ **Description** — Wenn in Obsidian geändert
✅ **.gitignore** — Bei Tech-Stack-Änderung

---

## ❌ Was Claude NICHT tut

- 🚫 Committed keinen Code (nur Struktur)
- 🚫 Löscht Repos nicht automatisch
- 🚫 Ändert Datei-Inhalte außer README/Gitignore
- 🚫 Pusht zu Git (nur API-Calls zu GitHub)

---

## 🔗 Integrationen

Automatisch konfiguriert:
- GitHub Pages (falls docs-Ordner vorhanden)
- GitHub Actions (CI/CD optional)
- Branch Protection (optional)

---

## 📌 Checkliste für neue Projekte

Vor du `Projekte/template.md` mit Daten ausfüllst:

- [ ] Repo-Name in `kebab-case` überlegt?
- [ ] Tech-Stack dokumentiert?
- [ ] Features mindestens 3 genannt?
- [ ] Beschreibung 1-2 Sätze vorhanden?
- [ ] Status (`planning`, `active`, `maintenance`, `archived`) klar?
- [ ] Public oder Private?
- [ ] Topics überlegt?

---

## ⚠️ Spezialfälle

### Repo mit bestehender Git-History?
→ Erstelle in GitHub manuell, Claude wird es bei Sync erkennen

### Private Repos?
→ In Projekt-Datei: `visibility: private`

### Mit Team/Organisation?
→ Momentan nicht unterstützt (nur persönliche Repos)

### Bot-Namen setzen?
→ Alle Repos bekommen `claude-automation` Topic

---

*Letzte Aktualisierung: 2026-09-05*
