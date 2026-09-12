---
titel: Auth-Bot – Google-Kalender Token-Refresh
created: 2026-09-12
typ: bot-brief
projekt: Nestbau
phase: Phase 2 Testing
---

# Auth-Bot Brief: Google-Kalender Token-Refresh

**Auftrag:** Behebe Token-Ablauf bei Google-Kalender (nach 1h neuer Login nötig).

---

## PROBLEM

Google OAuth (PKCE) liefert im Browser kein Refresh-Token → Access-Token läuft nach 1h ab → User muss neu anmelden.

**Auswirkung:** Im Produktionsbetrieb müssen Nutzer täglich erneut authentifizieren.

**Status:** Code existiert bereits (`nestbau-firebase/functions/src/tokens.js`), ist aber nicht ausgerollt.

---

## AUFGABE

1. **Prüfen:** Token-Tausch-Code lesen & Secrets prüfen
2. **Ausrollen:** Firebase Cloud Function deployen
3. **Binden:** Frontend anpassen (bei Token-Ablauf Function statt erneutes Login aufrufen)
4. **Testen:** Token künstlich ablaufen lassen, Sync ohne Login verifizieren
5. **Dokumentieren:** Summary schreiben, in Chat-Exports/ speichern

---

## INPUT

### Bestehender Code
- `nestbau-firebase/functions/src/tokens.js` – Token-Tausch-Logik (nicht ausgerollt)
- `js/nb-config.local.js` – Google-Client-Konfiguration (mit Client-Secret?)
- Kalender-Sync-Modul im Frontend (Ort per grep `googleapis.com|calendar` lokalisieren)

### Abhängigkeiten
- Firebase Cloud Functions deployable
- Secrets in [[SETUP-ENV-LOCAL]] gesetzt (GOOGLE_CLIENT_SECRET)
- Frontend kann auf Cloud Function reagieren

---

## SCHRITTE

### Schritt 1: Secrets & Code prüfen
- `nestbau-firebase/functions/src/tokens.js` lesen
- Prüfen: `GOOGLE_CLIENT_SECRET` in Umgebung gesetzt?
- Prüfen: Redirect-URI stimmt mit Firebase-Config überein?

### Schritt 2: Cloud Function ausrollen
```bash
firebase deploy --only functions:tokenRefresh
```
(oder welcher Name im Code verwendet wird)

### Schritt 3: Frontend anpassen
- Kalender-Sync-Modul finden (grep `googleapis.com|calendar`)
- Bei `401 Unauthorized` oder Token-Ablauf statt Neu-Login aufrufen:
  ```
  POST /api/refreshToken
  Body: { refreshToken: "…" }
  → Neuer Access-Token zurück
  ```
- Token speichern, Sync weiterlaufen

### Schritt 4: Testen
- Lokal `npm start`
- Haushalt-Setup durchführen (Kalender-Sync wird aktiv)
- **Künstlich ablaufen lassen:**
  - localStorage.setItem("googleToken_expiresAt", Date.now() - 1000)
  - Haushalt neu laden
  - Prüfen: Sync läuft ohne erneuten Login
- Chrome DevTools: `Authorization: Bearer [neuer Token]` Header prüfen

### Schritt 5: Dokumentieren
- Neues File: `Chat-Exports/auth-bot-token-refresh-fazit-2026-09-[DD].md`
- Inhalt:
  - Ursache & Lösung (kurz)
  - Getestete Szenarien (online/offline, Token läuft ab, User-Wechsel)
  - Code-Änderungen (Zeilen/Dateien)
  - Timing (1h ohne Refresh-Token, nach Rollout dauerhaft)
  - Offen (Logout-Flow, mobile Token-Handling)

---

## WICHTIG

- **Git:** Nur zu `main` commiten (PR, nicht direkt pushen)
- **Tests:** `npm test` muss 43/43 grün sein
- **UI-Review:** Light + Dark Theme nach Änderungen
- **Secrets:** GOOGLE_CLIENT_SECRET nie ins Repo, nur lokal in `.env`

---

## FALLBACK

Falls Token-Refresh blockiert:
- Alternative Aufgabe: "Tasks zu Firestore-Subsammlung refaktorieren (Perf)" aus PROJEKT-UPDATE Zeile 72
- Unabhängig vom Auth-Thema, ebenfalls bounded

---

## OUTPUT

**Deliverable:** 
- Cloud Function ausgerollt (`firebase deploy --only functions:…`)
- Frontend reagiert auf Token-Ablauf (Sync läuft ohne Neulogin)
- `Chat-Exports/auth-bot-token-refresh-fazit-[Datum].md` geschrieben
- PR gemergt auf `main`

**Danach:** CEO aktualisiert PROJEKT-LEARNINGS.md, hakt "Google-Kalender: Token läuft nach 1h ab" ab.

---

**Vorbereitungsstatus:** ✅ Ready to go (14.09.2026 oder später)
