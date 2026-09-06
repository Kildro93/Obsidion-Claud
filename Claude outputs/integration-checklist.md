# ✅ Integration Checklist für Nestbau v2.0

**Für alle 3 Bots – um sicherzustellen, dass alles zusammenpasst**

---

## 🔐 BOT 1: AUTH & PROFILE – Checklist

### Frontend Components
- [ ] Registration Form (Email, Password)
- [ ] Email Verification UI
- [ ] Profile Setup Form (Alter, Größe, Gewicht, Fitness, Allergien)
- [ ] Profile Picture Upload
- [ ] Household Creation Modal
- [ ] Household Invite Flow
- [ ] Login Screen
- [ ] User Settings/Profile Edit

### Firebase Integration
- [ ] `auth.createUserWithEmailAndPassword()` implementiert
- [ ] `auth.signInWithEmailAndPassword()` implementiert
- [ ] Email Verification Link Flow
- [ ] Auto-Login nach Email-Verifizierung
- [ ] Profiles Collection Listener
- [ ] Household Creation Logic
- [ ] Household Invite Logic

### Security
- [ ] Passwords gehashed (Firebase macht das!)
- [ ] No Tokens in localStorage (nur Session)
- [ ] CORS konfiguriert
- [ ] Rate limiting auf Login
- [ ] Error Messages nicht spezifisch ("User not found" vs "Invalid credentials")

### Testing
- [ ] Registration Flow getestet
- [ ] Email Verifizierung funktioniert
- [ ] Profile wird erstellt
- [ ] Haushalt-Einladung funktioniert
- [ ] Logout funktioniert

---

## 🔥 BOT 2: FIREBASE & DATA – Checklist

### Firestore Struktur
- [ ] Users Collection
- [ ] Profiles Collection
- [ ] Households Collection
- [ ] Recipes Collection
- [ ] Ingredients Collection
- [ ] MenuPlans Collection
- [ ] CalendarIntegrations Collection
- [ ] Indexes für häufige Queries erstellt

### Security Rules
- [ ] User können nur ihre Daten lesen
- [ ] Household-Mitglieder können Haushalt-Daten lesen
- [ ] Nur Admin kann Haushalt-Daten ändern
- [ ] Shared Recipes sind public readable
- [ ] Allergies sind privat
- [ ] Alle Rules getestet

### Cloud Functions
- [ ] `onUserCreated` Trigger
- [ ] `inviteToHousehold` Funktion
- [ ] Email-Versand für Invites
- [ ] Error Handling
- [ ] Logging

### Performance
- [ ] Indexes für häufige Queries
- [ ] Subcollections vs. Top-level entschieden
- [ ] Caching-Strategie definiert
- [ ] Pagination implementiert (für große Listen)

### Storage
- [ ] Storage Rules deployed
- [ ] Bild-Größen-Limits gesetzt (5-10MB)
- [ ] File Type Validation
- [ ] Deletion bei Benutzer-Löschung

### Testing
- [ ] Firestore Daten-Struktur getestet
- [ ] Security Rules getestet (mit Emulator)
- [ ] Cloud Functions getestet
- [ ] Storage Upload/Download getestet

---

## 👨‍🍳 BOT 3: KOCHBUCH & CALENDAR – Checklist

### Kochbuch-Migration
- [ ] Lokale Rezepte → Firebase exportiert
- [ ] Lokale Zutaten → Firebase exportiert
- [ ] Menüpläne → Firebase exportiert
- [ ] Bilder → Storage hochgeladen
- [ ] Nährwerte berechnet
- [ ] Rezept-Suche funktioniert
- [ ] Filter (Allergien, Kategorien) funktionieren

### Google Calendar Integration
- [ ] Google OAuth Flow implementiert
- [ ] Access Token speichern (sicher!)
- [ ] Refresh Token speichern
- [ ] Calendar Events lesen
- [ ] Nestbau-Events zu Google Calendar synchen
- [ ] Google Events zu Nestbau synchen
- [ ] Disconnect funktioniert
- [ ] Token-Refresh automatisch

### Outlook Integration
- [ ] Microsoft OAuth Flow implementiert
- [ ] Access Token speichern
- [ ] Refresh Token speichern
- [ ] Graph API Calendar Events lesen
- [ ] Sync bidirektional
- [ ] Disconnect funktioniert
- [ ] Error Handling (invalid tokens, etc.)

### Profil-Integration
- [ ] "Google Calendar verbinden" Button
- [ ] "Outlook verbinden" Button
- [ ] Connection Status anzeigen
- [ ] Disconnect Option
- [ ] Sync Status anzeigen

### Sicherheit
- [ ] Tokens nicht in localStorage
- [ ] Tokens mit Secret Manager verschlüsselt
- [ ] Scopes minimal (nur Calendar lesen)
- [ ] Tokens regelmäßig erneuert
- [ ] Permissions-Dialog zeigt was die App macht

### Performance
- [ ] Bilder komprimiert vor Upload
- [ ] Lazy Loading für Rezepte
- [ ] Caching für häufig gelesene Rezepte
- [ ] Sync läuft im Hintergrund (nicht blocking)

### Testing
- [ ] Rezepte von lokal zu Firebase funktionieren
- [ ] Google Calendar Sync funktioniert
- [ ] Outlook Sync funktioniert
- [ ] Bidirektionale Sync getestet
- [ ] Error Cases getestet (Disconnect, Token-Fehler)

---

## 🔄 CROSS-BOT Integration

### Daten-Abhängigkeiten
- [ ] Bot 1 erstellt User → Bot 2 erstellt Profile
- [ ] Bot 1 erstellt Household → Bot 3 kann darauf zugreifen
- [ ] Bot 3 speichert Rezepte in Household → Bot 2 kann auf Firestore zugreifen

### API Calls
- [ ] Frontend ruft Bot 1 API auf (Auth)
- [ ] Frontend ruft Bot 2 API auf (Daten)
- [ ] Frontend ruft Bot 3 API auf (Calendar)
- [ ] Alle APIs haben Error Handling

### Session Management
- [ ] Firebase Auth Token wird gespeichert
- [ ] Token wird automatisch refreshed
- [ ] Logout löscht Token
- [ ] Session-Timeout funktioniert

### Error Handling
- [ ] Network Errors werden gefangen
- [ ] Validation Errors zeigen Benutzer-Meldung
- [ ] Firebase Errors werden abgefangen
- [ ] OAuth Errors werden behandelt

---

## 🧪 Testing-Roadmap

### Unit Tests
- [ ] Auth Functions (login, register, logout)
- [ ] Firebase Query Functions
- [ ] Calendar Sync Functions
- [ ] Data Validation

### Integration Tests
- [ ] Registration → Profile Creation → Household Create
- [ ] Google Calendar Connect → Sync
- [ ] Outlook Connect → Sync
- [ ] Recipe Upload → Firebase Storage

### E2E Tests
- [ ] Complete Registration Flow
- [ ] Complete Household Setup
- [ ] Recipe Management
- [ ] Calendar Sync

### Performance Tests
- [ ] Firestore Query Performance
- [ ] Firebase Storage Upload Speed
- [ ] Calendar Sync Speed
- [ ] Image Compression

---

## 📊 Metriken zum Tracken

Die Bots sollten diese Metriken dokumentieren:

```json
{
  "performance": {
    "registrationTime": "< 3 seconds",
    "firestoreQueryTime": "< 500ms",
    "storageUploadTime": "< 2s for 1MB image",
    "calendarSyncTime": "< 5s"
  },
  "reliability": {
    "authSuccess": "> 99%",
    "firestoreSyncSuccess": "> 99%",
    "calendarSyncSuccess": "> 95%"
  },
  "security": {
    "tokenExpiryCheck": "every 1 hour",
    "passwordStrengthCheck": "implemented",
    "firebaseRulesValidated": true
  }
}
```

---

## 🚀 Deployment Checklist

Bevor in Production gehen:

### Frontend
- [ ] Production Build gemacht
- [ ] Environment Variables gesetzt
- [ ] Firebase Config für Production
- [ ] Service Worker funktioniert
- [ ] Progressive Web App funktioniert

### Firebase
- [ ] Backups konfiguriert
- [ ] Security Rules sind stricter als TEST
- [ ] Monitoring aktiviert
- [ ] Quotas gesetzt (um Kosten zu kontrollieren)
- [ ] Logging aktiviert

### Google Calendar API
- [ ] OAuth Screen ist nicht in TEST
- [ ] Production Credentials verwendet
- [ ] Scopes minimal gesetzt

### Outlook Integration
- [ ] Azure App ist nicht in TEST
- [ ] Production Credentials verwendet
- [ ] Redirect URIs stimmen

### Monitoring
- [ ] Error Logging (Sentry/Crashlytics)
- [ ] Performance Monitoring
- [ ] Firebase Quota Monitoring
- [ ] Uptime Monitoring

---

## 💡 Continuous Improvement

Nach Launch sollten die Bots monitor:

- [ ] User Feedback sammeln
- [ ] Error Logs analysieren
- [ ] Performance Metrics tracken
- [ ] Security Audit machen (monatlich)
- [ ] Code Review durchführen (vor jedem Push)

---

## 📞 Bot-Kommunikation

Damit die Bots sich koordinieren:

**Bot 1 → Bot 2:**
"Ich habe User erstellt, erstelle bitte die Firestore-Struktur"

**Bot 2 → Bot 3:**
"Firestore ist ready, ihr könnt anfangen zu speichern"

**Bot 3 → Bot 1:**
"Brauchen einen Field 'calendarSyncStatus' im Profil"

---

**Viel Erfolg mit der Umsetzung!** 🚀

