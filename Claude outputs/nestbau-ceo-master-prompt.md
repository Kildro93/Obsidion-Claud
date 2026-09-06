# 🎯 NESTBAU – CEO Master-Prompt für Bot-System

**Projekt:** Nestbau App v2.0 mit Firebase Backend  
**Ziel:** Transformation von lokaler PWA zu Cloud-gestütztem System  
**Status:** In Entwicklung

---

## 📊 System-Übersicht

Die Nestbau-App wird umgebaut mit 3 spezialisierten Bot-Teams:

```
┌─────────────────────────────────────────────────────────┐
│         NESTBAU v2.0 – Cloud Architecture               │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Frontend (Progressive Web App)                          │
│  ├─ Authentication UI                                   │
│  ├─ Profile Management                                  │
│  ├─ Household/Family Management                         │
│  ├─ Kochbuch (Zutaten/Rezepte/Menüplan)               │
│  └─ Calendar (Google/Outlook Integration)              │
│                                                          │
│  ↓↓↓ Firebase Backend ↓↓↓                               │
│                                                          │
│  ├─ Realtime Database / Firestore                       │
│  ├─ Authentication (Email/Password)                     │
│  ├─ Cloud Functions (Validierung, Emails)              │
│  └─ Storage (Fotos, Rezept-Bilder)                     │
│                                                          │
│  External APIs                                          │
│  ├─ Google Calendar API                                │
│  ├─ Microsoft Outlook/Graph API                        │
│  └─ SendGrid (Email-Verifikation)                      │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## 🤖 Die 3 Bot-Teams

### **Bot 1: AUTH & PROFILE BOT** 🔐
**Fokus:** Benutzer-Management, Registrierung, Profilerstellung

**Aufgaben:**
- Authentifizierungs-System (Email/Password)
- Email-Verifikation Flow
- Profilerstellung (Alter, Größe, Gewicht, Fitnesslevel, Allergien)
- Haushalt/Familie-Verwaltung
- Benutzer einladen
- Profile aktualisieren

**Output:** Frontend-Code + Firebase Rules + Email-Templates

---

### **Bot 2: FIREBASE & DATA BOT** 🔥
**Fokus:** Datenspeicherung, Struktur, Cloud Functions

**Aufgaben:**
- Firebase Project Setup
- Database/Firestore Struktur
- Cloud Functions schreiben
- Security Rules
- Data Migration (lokal → Firebase)
- Performance Optimization

**Output:** Firebase Config + Firestore Schema + Cloud Functions

---

### **Bot 3: KOCHBUCH & INTEGRATIONS BOT** 👨‍🍳
**Fokus:** Kochbuch-Module + Calendar-Integration

**Aufgaben:**
- Kochbuch lokal → Firebase Migration
- Zutaten-Management
- Rezept-Speicherung
- Menüplan auf Firebase
- Google Calendar Integration
- Outlook Calendar Integration
- Foto-Upload & Storage

**Output:** Frontend Components + API Wrapper + Integration Code

---

## 📋 Bot-Prompts (Copy-Paste Ready)

### 🔐 **PROMPT 1: Bot für AUTH & PROFILE**

```
Du bist der AUTH & PROFILE ARCHITECT für die Nestbau-App v2.0.

AUFGABEN:
1. Registrierungs-Flow mit Email-Verifikation
   - User gibt Email + Passwort ein
   - Verifizierungs-Email wird gesendet
   - Bestätigungslink aktiviert Account
   
2. Profilerstellung (während/nach Registrierung)
   - Alter, Größe, Gewicht, Fitnesslevel
   - Lebensmittelallergien (mehrfach möglich)
   - Profilbild hochladen
   - Design: Schöne UI entsprechend Nestbau-Design
   
3. Haushalt/Familie-System
   - Benutzer kann "Haushalt erstellen"
   - Andere Mitglieder einladen via Email
   - Unterschiedliche Rollen (Admin/Member)
   - Haushalt-Name + Beschreibung
   
4. Firebase Integration:
   - Users Tabelle mit Auth
   - Profiles Tabelle mit Daten
   - Households Tabelle
   - Security Rules für Datenschutz

DELIVERABLES:
- HTML/JS für Auth-Flow
- Firebase Security Rules
- Email-Verifizierungs-Template
- Profil-UI Components
- Backend Logic (Cloud Functions)

REPOSITORY: https://github.com/Kildro93/Nestbau
BRAND: Nestbau Design (Farben: #1c7d70, #4a6741, #8a5f22, #b5342a)

Starte jetzt!
```

---

### 🔥 **PROMPT 2: Bot für FIREBASE & DATA ARCHITECTURE**

```
Du bist der FIREBASE ARCHITECT für die Nestbau-App v2.0.

AUFGABEN:
1. Firebase Project einrichten
   - Firestore (oder Realtime DB?) - welche ist besser?
   - Authentication aktivieren
   - Storage für Fotos
   - Cloud Functions
   
2. Datenbankstruktur definieren
   - Users (Email, UID, Registered)
   - Profiles (Alter, Gewicht, Allergien, etc.)
   - Households (Familie/Haushalt)
   - HouseholdMembers (Zuordnung)
   - Recipes (Rezepte vom Kochbuch)
   - Ingredients (Zutaten)
   - MenuPlans (Menüpläne)
   - CalendarEvents (Kalender-Events)
   - CalendarIntegrations (Google/Outlook-Tokens)
   
3. Security Rules schreiben
   - Users können nur ihre Daten lesen
   - Haushalt-Admins verwalten Mitglieder
   - Shared Data (Rezepte) sind visible
   - Allergien sind privat
   
4. Cloud Functions entwickeln
   - Email-Verifizierung senden
   - Haushalt-Einladung verarbeiten
   - Foto-Upload validieren
   - Allergien-Benachrichtigungen
   
5. Lokale Daten → Firebase Migration
   - Bestandsdaten konvertieren
   - Import-Script schreiben

DELIVERABLES:
- Firebase Config
- Firestore Schema (JSON)
- Security Rules
- Cloud Functions Code
- Data Migration Script
- Performance Guide

Starte jetzt!
```

---

### 👨‍🍳 **PROMPT 3: Bot für KOCHBUCH & CALENDAR INTEGRATIONS**

```
Du bist der INTEGRATIONS ARCHITECT für die Nestbau-App v2.0.

AUFGABEN:
1. Kochbuch-Modul upgraden
   - Zutaten lokal → Firebase Migration
   - Rezepte lokal → Firebase Migration
   - Menüpläne lokal → Firebase Migration
   - Bilder → Firebase Storage
   - Nährwerte-Berechnung bleibt lokal (schneller)
   
2. Google Calendar Integration
   - Google OAuth Setup
   - Kalender-Events lesen
   - Events mit Nestbau synchronisieren
   - Speichern in Firebase
   - Token-Refresh handling
   
3. Outlook/Microsoft Graph Integration
   - Outlook OAuth Setup
   - Calendar Events lesen
   - Synchronisierung
   - Firebase Token Storage
   
4. Profil-Einstellungen
   - "Google Calendar verbinden" Button
   - "Outlook verbinden" Button
   - Token-Status anzeigen
   - Disconnect-Option
   
5. Datenschutz & Performance
   - Tokens sicher speichern (Firebase Secret Manager)
   - Nur notwendige Daten synchen
   - Caching implementieren

DELIVERABLES:
- Google Calendar Integration Code
- Outlook Integration Code
- Kochbuch-Migration Code
- Firebase Storage Config
- OAuth Token Management
- Sync Logic
- Error Handling

REPOSITORY: https://github.com/Kildro93/Nestbau

Starte jetzt!
```

---

## 🚀 Firebase Setup-Anleitung für die Bots

Die Bots brauchen folgende Informationen:

### **Firebase Project erstellen:**

1. Gehe zu https://console.firebase.google.com
2. Klicke "Neues Projekt erstellen"
3. Name: `nestbau-app`
4. Aktiviere: Google Analytics (optional)
5. Erstelle

### **Nach Erstellung:**

```
Firebase Project: nestbau-app
Project ID: [wird angezeigt]
API Key: [Settings > Project Settings > Web API Key]
Auth Domain: nestbau-app.firebaseapp.com
Database URL: https://nestbau-app.firebaseio.com
Storage Bucket: nestbau-app.appspot.com
Messaging Sender ID: [wird angezeigt]
App ID: [wird angezeigt]
```

**Diese Werte MÜSSEN in die App:**
```javascript
const firebaseConfig = {
  apiKey: "AIza...",
  authDomain: "nestbau-app.firebaseapp.com",
  projectId: "nestbau-app",
  storageBucket: "nestbau-app.appspot.com",
  messagingSenderId: "123...",
  appId: "1:123...:web:abc...",
  databaseURL: "https://nestbau-app.firebaseio.com"
};
```

### **Was die Bots aktivieren müssen:**

- [ ] Firestore Database
- [ ] Realtime Database (optional)
- [ ] Authentication (Email/Password)
- [ ] Firebase Storage
- [ ] Cloud Functions
- [ ] Cloud Messaging (optional, für Push)

### **Google Calendar API:**

1. Google Cloud Console: https://console.cloud.google.com
2. APIs & Services > Library
3. Suche "Google Calendar API" > Enable
4. OAuth Consent Screen konfigurieren
5. Credentials > OAuth 2.0 Client ID erstellen

### **Outlook/Microsoft Graph:**

1. https://entra.microsoft.com (Azure Portal)
2. App registrations > New registration
3. Redirect URI: `https://nestbau-app.firebaseapp.com/auth/outlook`
4. Credentials erstellen

---

## 📝 Anforderungen an die Bots

Alle Bots müssen:
- ✅ Auf GitHub pushen können
- ✅ Mit `index.html` arbeiten (oder komponenten-basiert)
- ✅ Nestbau-Design respektieren (#1c7d70, #4a6741 colors)
- ✅ Responsive sein (Mobile first)
- ✅ Sichere Patterns nutzen (kein Secret in Frontend!)
- ✅ Error-Handling haben
- ✅ Dokumentation schreiben

---

## 🔄 Workflow für die Bots

1. **Bot startet mit dem Prompt**
2. **Bot liest aktuellen Code vom GitHub**
3. **Bot entwickelt Feature**
4. **Bot testet lokal**
5. **Bot committed + pusht zu GitHub**
6. **Du reviewst die Änderungen**
7. **Merge zu main**

---

## 💡 Improvement Suggestions (offen für Vorschläge!)

Falls die Bots Ideen haben:
- **Bot 1:** "Sollten wir Two-Factor-Auth hinzufügen?"
- **Bot 2:** "Firestore oder Realtime DB? Hier meine Empfehlung..."
- **Bot 3:** "Können wir auch iCal-Support hinzufügen?"

→ Diese können sie direkt in dem Chat schreiben!

---

## 📞 Support

**Fragen an die Bots stellen:**
```
[In jedem Bot-Chat]
"Was brauchst du noch von mir?"
"Kann ich die Anforderungen klären?"
"Hast du Fragen zu Firebase?"
```

---

## ✅ Checkliste für die Bots

Bevor sie starten, sollten sie sagen:
- [ ] Ich habe GitHub-Zugriff
- [ ] Ich kenne die Anforderungen
- [ ] Ich weiß, welche Firebase-Services ich nutzen muss
- [ ] Ich verstehe das Design-System
- [ ] Ich bin bereit, Code zu schreiben + pushen

---

**Los gehts! Erstelle die 3 Bots und lass sie die Arbeit machen!** 🚀

