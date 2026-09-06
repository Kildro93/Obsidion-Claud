# Nestbau

**Progressive Web App für gemeinsames Haushalt-Management**

---

## 📝 Basis-Informationen

| Feld | Wert |
|------|------|
| **Projektname** | Nestbau |
| **Repo-Name** | `Nestbau` |
| **Typ** | Full-Stack PWA |
| **Status** | active |
| **Sichtbarkeit** | public |
| **GitHub Repo** | https://github.com/Kildro93/Nestbau |
| **Autor** | Kildro93 |

---

## 📖 Beschreibung

Eine Progressive Web App für Paare, um gemeinsam ihren Haushalt zu verwalten. Mit Finanztracking, Task-Management, Kalender-Integration und Kochbuch-Funktionen. Vollständig offline-funktionsfähig mit Service Worker und IndexedDB.

---

## ✨ Features (Implementiert)

- [x] **Finanztracking**: Ausgaben & Einnahmen tracken, mit Partner teilen
- [x] **Task-Management**: Haushaltaufgaben verwalten, Deadline setzen
- [x] **Kalender-Integration**: Sync mit Google Calendar & Outlook Calendar
- [x] **Kochbuch**: Rezepte verwalten & speichern
- [x] **Offline-Support**: PWA mit Service Worker & IndexedDB
- [x] **Responsive Design**: Optimiert für 375px+ Viewports (Mobile-First)
- [x] **Dark Mode**: Automatische + manuelle Umschaltung
- [x] **Modern Design**: Orange/Peach/Green Farbpalette mit Animations
- [x] **Accessibility**: WCAG AA (4.5:1 Kontrast-Verhältnis)

## 🚀 Geplante Features

- [ ] **Authentication**: Firebase Google/Email Sign-In (In Progress)
- [ ] **Sync**: Echtzeit-Daten-Sync zwischen Devices
- [ ] **Android Build**: Native Android APK
- [ ] **Push Notifications**: Reminders & Alerts
- [ ] **Expense Splitting**: Intelligente Kostenaufteilung

---

## 🔧 Tech-Stack

### Frontend
- **Framework**: React 18+ mit TypeScript
- **Styling**: Custom CSS mit CSS Variables (nestbau-design.css, 1028 Zeilen)
- **State Management**: React Hooks (useState, useContext)
- **Offline**: Service Worker + IndexedDB
- **Icons**: SVG (custom icon.svg)
- **Responsive**: Mobile-First (375px+)

### Backend
- **Runtime**: Node.js
- **API**: REST API
- **Database**: Firebase/Firestore (geplant)
- **Auth**: Firebase Authentication (Setup erforderlich)

### Datenbank
- **Lokal**: IndexedDB (offline-first)
- **Cloud**: Firebase Firestore (geplant)

### Besondere Integrationen
- [ ] Google Calendar API (für Sync)
- [ ] Microsoft Outlook API (für Sync)
- [ ] Firebase Authentication (in Setup)
- [ ] Progressive Web App (PWA)

---

## 📊 Repository-Setup

### Visibility
- [x] public
- [ ] private

### Topics
```
react, typescript, fullstack, pwa, firebase, offline-first, 
calendar-sync, household-management, finance-tracking, responsive, 
dark-mode, tailwindcss, mobile-first, progressive-web-app
```

---

## 📄 README-Struktur

Das automatisch generierte README wird enthalten:

```
# Nestbau 🏠

Eine Progressive Web App für Paare, um gemeinsam ihren Haushalt zu verwalten.

## ✨ Features

- 💰 Finanztracking (Einnahmen & Ausgaben)
- ✅ Task-Management (Haushalt-Aufgaben)
- 📅 Kalender-Integration (Google + Outlook)
- 📖 Kochbuch (Rezepte-Verwaltung)
- 📱 Offline-Funktionalität (PWA)
- 🌙 Dark Mode
- ♿ Accessible (WCAG AA)

## 🚀 Installation

### Lokal (Development)
\`\`\`bash
git clone https://github.com/Kildro93/Nestbau.git
cd Nestbau
npm install
npm start
\`\`\`

Server läuft auf: http://localhost:8000

### PWA Installation
1. Browser: Adresszeile → "App installieren"
2. Oder: Menü → "Zum Startbildschirm"
3. App läuft offline!

## 📖 Verwendung

### Finanztracking
1. Öffne "Finances" Tab
2. Klick: "Add Expense"
3. Gib Betrag & Kategorie ein
4. Mit Partner teilen

### Tasks
1. Tab: "Tasks"
2. "New Task" → Aufgabe erstellen
3. Setze Deadline & Kategorie

### Kalender-Sync
1. Settings → "Calendar Integration"
2. Wähle: Google oder Outlook
3. Autorisiere den Login
4. Events werden synchronisiert

## 🛠️ Tech Stack

- **Frontend**: React 18 + TypeScript + CSS
- **Offline**: Service Worker + IndexedDB
- **API**: REST (Node.js Backend)
- **Database**: Firebase Firestore
- **Auth**: Firebase + Google/Outlook OAuth
- **Hosting**: Vercel oder Firebase Hosting
- **Mobile**: PWA (installierbar wie Native App)

## 📝 Lizenz

MIT License

## 👤 Author

Created by Kildro93
Claude Automation System
```

---

## 🔗 Integrationen

- [x] Google Calendar API (in Setup)
- [x] Outlook Calendar API (in Setup)
- [ ] Firebase Firestore
- [ ] Firebase Authentication

---

## 📅 Zeitplan & Priorität

| Punkt | Status |
|-------|--------|
| **Start-Datum** | 2024-01 |
| **Aktueller Status** | v2.0 - Design & Auth In Progress |
| **Priorität** | Hoch |
| **Wöchentliches Zeit-Budget** | < 2 Stunden |

---

## 📝 Notizen & TODOs

### Abgeschlossen ✅

- [x] React App-Struktur
- [x] Finanz-Module (Ausgaben tracken)
- [x] Task-Management-Module
- [x] Kalender-Integration (Frontend)
- [x] Kochbuch-Modul
- [x] Service Worker & Offline-Funktionalität
- [x] Responsive Design (375px+)
- [x] Dark Mode Support
- [x] Modern Design-System (Orange/Peach/Green)
- [x] Accessibility (WCAG AA)
- [x] README.md & Documentation

### In Arbeit 🔄

- [ ] **Firebase Auth Setup** — Credentials konfigurieren (PRIORITÄT)
- [ ] **OAuth Redirect URLs** — Google & Outlook URLs in Firebase konfigurieren
- [ ] **Login-Screen** — Dedizierte Auth-Guard & Login UI
- [ ] **Haushalt-Creation** — "Neuen Haushalt erstellen" Flow
- [ ] **Join-Code System** — Partner einladen & Haushalt teilen

### Nächste Phase 📋

- [ ] Firebase Credentials eingeben (PRIORITÄT)
- [ ] OAuth Setup testen (Google & Outlook)
- [ ] Auth Flow vollständig testen
- [ ] Haushalt erstellen & Join-Code generieren
- [ ] Android PWA Build via Capacitor/Cordova
- [ ] Deployment auf Firebase Hosting / Vercel

### Known Issues ⚠️

- OAuth Pop-Up blockiert (Browser-Sicherheit) — Fix: OAuth Redirect konfigurieren
- Firebase Config fehlend — Add credentials in config.js

---

## 🔄 Versionierung

| Version | Datum | Changes |
|---------|-------|---------|
| v1.0 | 2024-01 | Initial MVP (Finanztracking, Tasks, Kalender) |
| v2.0 | 2026-09 | Design-Modernisierung, Dark Mode, Offline-Support |
| v2.1 | 2026-09 | Firebase Auth Setup (In Progress) |
| v3.0 | 2026-10 | Android PWA Release (Planned) |

---

## ✅ Vor dem "Erstellen" Checklist

- [x] Repo-Name: `Nestbau` ✓
- [x] Beschreibung vorhanden ✓
- [x] Features dokumentiert ✓
- [x] Tech-Stack komplett ✓
- [x] Status: active ✓
- [x] Topics überlegt ✓
- [x] In `_INDEX.md` eingetragen ✓

---

**Status**: ✅ Bereit für GitHub-Sync

---

*Letzte Aktualisierung: 2026-09-05*
*GitHub Repository: https://github.com/Kildro93/Nestbau*
