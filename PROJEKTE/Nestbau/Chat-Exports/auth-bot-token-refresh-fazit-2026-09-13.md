# Auth-Bot Summary: Token-Refresh
Datum: 2026-09-13
Bot: Auth-Bot (Claude Code)
Branch Nestbau: fix/google-token-refresh (Commit 0c59814)
Branch nestbau-firebase: fix/token-refresh-function (Commit 2d070d8)

## Was wurde gemacht

**Befund vor dem Coden (wichtig fuer die Einordnung):** Der Auftrag ging von "Cloud Function deployen + Frontend ruft sie bei Ablauf auf" aus. Tatsaechlich war die Lage komplexer:
- `tokens.js` war fuer einen serverseitigen Sync-Job gebaut (`getValidAccessToken()` sollte laut eigenem Kommentar *nie* an einen Client zurueck) - der Kalender-Sync laeuft aber komplett clientseitig (`nb-google-calendar.js` ruft die Calendar-API direkt aus dem Browser).
- Google nutzte bislang GIS `initTokenClient` (Implicit-Token, kein `code`) - `connectCalendar` erwartet aber genau einen `code`. Die Function war vom Frontend aus nie erreichbar.
- Die Firebase-Functions-SDK war im Frontend gar nicht geladen (nur app/auth/firestore/storage-compat) - kein einziger Callable-Aufruf existierte bisher irgendwo im Code.

Diese Abweichung wurde vor der Umsetzung mit dem User geklaert; gewaehlt wurde die volle Umsetzung (Option "Vollen Umbau umsetzen").

**Backend (`nestbau-firebase`):**
- [functions/src/tokens.js](../../../nestbau-firebase/functions/src/tokens.js): neue Funktion `getCalendarAccessToken` (onCall, Zeilen ~159-179) - liefert dem eingeloggten Client `{accessToken, expiresAt}` fuer seine eigene `uid`, ruft intern `getValidAccessToken()` auf (erneuert bei Bedarf per Refresh-Token). Refresh-Token und Client-Secret verlassen die Function weiterhin nie.
- `connectCalendar`: `redirectUri`-Pruefung erweitert, akzeptiert jetzt zusaetzlich zu `https://`-URIs den Wert `"postmessage"` (GIS-Popup-Code-Flow).
- Modul-Kopfkommentar aktualisiert (Redirect-Token-Garantie praezisiert: Access-Token darf an Client, Refresh-Token/Secret nie).
- [functions/index.js](../../../nestbau-firebase/functions/index.js): `getCalendarAccessToken` exportiert.
- CORS war bereits konfiguriert (`cors: true` je onCall) - keine Aenderung noetig.
- Keine Aenderung an `package.json` (keine fehlenden Dependencies - Node 20 hat globales `fetch`).
- Keine Aenderung an Firestore-Regeln - `secureTokens` ist bereits fuer Clients gesperrt, `users/{uid}/integrations/{provider}` bereits korrekt eingeschraenkt.

**Frontend (`Nestbau`):**
- [js/nb-firebase.js](../../../Nestbau/js/nb-firebase.js): `firebase-functions-compat.js` zum SDK-Ladepfad ergaenzt; `cloud.callFunction(name, data)` als Callable-Helper mit Error-Mapping (`unauthenticated`->AUTH_REQUIRED, `permission-denied`->PERMISSION, `failed-precondition`->AUTH_EXPIRED, `not-found`->NOT_FOUND, `unavailable`/`internal`->SERVER); Emulator-Unterstuetzung fuer Functions ergaenzt.
- [js/nb-google-calendar.js](../../../Nestbau/js/nb-google-calendar.js):
  - `connect()`: nutzt jetzt GIS `initCodeClient` (`requestCode()`) statt `initTokenClient` - holt einen Authorization Code, schickt ihn an `connectCalendar` (Cloud Function), holt danach per `getCalendarAccessToken` den ersten Access-Token.
  - `ensureToken()`: bei Ablauf wird `getCalendarAccessToken` aufgerufen statt des stillen GIS-Refresh (der ohne Refresh-Token nach 1h scheiterte). Schlaegt der Aufruf fehl, wird `markReauth()` gesetzt und `AUTH_REFRESH_FAILED` geworfen (Fallback = Neuanmeldung, wie im Brief gefordert).
  - `disconnect()`: ruft jetzt `disconnectCalendar` (Cloud Function) auf - widerruft serverseitig bei Google und loescht `/secureTokens` - statt nur lokal den Client-Token zu widerrufen.
  - Alter, jetzt ungenutzter `initTokenClient`-Code entfernt.
- [js/nb-core.js](../../../Nestbau/js/nb-core.js): neuer Error-Code `AUTH_REFRESH_FAILED` + deutscher Klartext.

## Was wurde NICHT gemacht (und warum)
- **Kein `firebase deploy`** - braucht `firebase login` + Secrets, die der Bot nicht hat.
- **Kein `git push`** - beide Branches sind lokal committet, der User pusht selbst.
- **Kein neuer automatisierter Test fuer den Refresh-Flow** - die bestehenden 43 Tests decken kein Firebase ab (reine Markup-/Statik-Pruefungen), ein echter Test braucht den Firebase-Emulator + einen Google-Test-Account. Als "optional" im Brief markiert, hier ausgelassen zugunsten des eigentlichen Umbaus.
- **Outlook/Microsoft nicht angefasst** - funktioniert bereits eigenstaendig client-seitig mit echtem Refresh-Token (Entra ID erlaubt das fuer SPA-Clients ohne Secret), betrifft dieses Problem nicht.
- **Firestore-Regeln unveraendert** - bereits korrekt (siehe oben).

## Geaenderte Dateien
| Datei | Aenderung | Repo |
|-------|-----------|------|
| functions/src/tokens.js | neue Function `getCalendarAccessToken`, `redirectUri`-Validierung erweitert, Kommentar praezisiert | nestbau-firebase |
| functions/index.js | Export ergaenzt | nestbau-firebase |
| js/nb-firebase.js | Functions-SDK laden, `cloud.callFunction()` + Error-Mapping | Nestbau |
| js/nb-google-calendar.js | GIS Code-Client statt Token-Client, `ensureToken`/`disconnect` an Cloud Function gebunden | Nestbau |
| js/nb-core.js | Error-Code `AUTH_REFRESH_FAILED` | Nestbau |

## Test-Ergebnis
- `npm test` (Nestbau): **43/43 gruen** (keine Regression; das Google-Kalender-Modul war zuvor nicht testabgedeckt).
- `node --check` auf alle gelesenen/geaenderten JS-Dateien nach jedem Batch: alle ok.
- **Manueller Test: NICHT durchgefuehrt.** Braucht einen deployten Stand (Secrets + `firebase deploy`), den der Bot nicht herstellen kann. Siehe Deploy-Schritte unten fuer den manuellen Test durch den User.

## Deploy-Schritte fuer User

```bash
# 1. Secret setzen (falls noch nicht geschehen)
firebase functions:secrets:set GOOGLE_CLIENT_SECRET
# Wert aus Google Cloud Console -> APIs & Services -> Credentials

# 2. Cloud Functions deployen
cd nestbau-firebase
firebase deploy --only functions:connectCalendar,functions:getCalendarAccessToken,functions:disconnectCalendar

# 3. Frontend-Branch pushen
cd ../Nestbau
git push -u origin fix/google-token-refresh

# 4. Backend-Branch pushen
cd ../nestbau-firebase
git push -u origin fix/token-refresh-function
```

**Testen:**
1. App oeffnen, Google-Kalender **neu verbinden** (bestehende Verbindungen haben keinen serverseitigen Refresh-Token - einmalige Neuverbindung ist noetig, danach laeuft es dauerhaft).
2. Beim Connect-Popup erscheint jetzt ein Google-Zustimmungsbildschirm mit Offline-Zugriff - das ist neu und erwartet.
3. Chrome DevTools -> Network: Aufruf von `getCalendarAccessToken` beobachten.
4. Token kuenstlich ablaufen lassen:
   ```js
   var t = JSON.parse(localStorage.getItem("token:google"));
   t.expiresAt = Date.now() - 1000;
   localStorage.setItem("token:google", JSON.stringify(t));
   ```
5. Seite neu laden -> Sync sollte **ohne Login** weiterlaufen (Cloud Function liefert neuen Access-Token).
6. Firestore Console -> `secureTokens/{uid}_google` pruefen: Dokument sollte existieren, `expiresAt` sollte sich nach Schritt 5 aktualisiert haben.

## Offene Punkte
- **Manueller Test steht aus** - siehe oben, braucht Deploy.
- **Bestehende Google-Verbindungen muessen einmalig neu verbunden werden** - der alte Implicit-Flow hat nie einen serverseitigen Refresh-Token erzeugt. Kein automatischer Migrationspfad moeglich (Google liefert keinen Refresh-Token nachtraeglich ohne neuen Consent).
- **GIS `initCodeClient` + `ux_mode: "popup"` mit `redirect_uri: "postmessage"`**: Dieses Verhalten ist Google-dokumentiertes Standardverhalten, aber nicht in diesem Repo getestet worden (kein Google-Testkonto verfuegbar). Falls der Popup-Flow in der Praxis einen anderen `redirect_uri`-Wert liefert, wuerde `connectCalendar` mit "redirectUri muss https sein oder postmessage" fehlschlagen - dann in den Firebase Function Logs (`firebase functions:log`) nachsehen, was tatsaechlich ankommt.
- **Kein neuer automatisierter Test** fuer den Refresh-Flow (siehe "Was wurde NICHT gemacht").
- **`GOOGLE_CLIENT_SECRET`-Wert selbst wurde nicht geprueft** (nicht sichtbar/nicht eingesehen) - nur die Code-Seite, die ihn erwartet.

## Empfehlung an CEO
- Nach erfolgreichem manuellem Test (Schritte oben): PR fuer beide Repos erstellen, mergen, PROJEKT-UPDATE.md und PROJEKT-LEARNINGS.md aktualisieren (Zeile "Google-Kalender-Token laeuft nach 1h ab" abhaken).
- Neue Lernen fuer PROJEKT-LEARNINGS: "GIS bietet zwei Modi - `initTokenClient` (Implicit, kein Refresh-Token, rein clientseitig) und `initCodeClient` (Code, braucht Backend-Tausch mit Client-Secret). Wer dauerhaften Server-Zugriff auf Google-APIs braucht, kommt um Letzteres + eigenes Backend nicht herum."
- Zwei-Repo-Situation (Nestbau + nestbau-firebase) hat diese Aufgabe spuerbar verlangsamt (Functions-SDK fehlte komplett im Frontend, kein einziger Callable war bisher verdrahtet) - der offene Punkt "Repo-Merge" aus PROJEKT-UPDATE.md gewinnt dadurch an Dringlichkeit.
