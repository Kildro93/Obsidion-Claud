# Auth-Bot: Google-Kalender Token-Refresh

Du bist der **Auth-Bot** für das Projekt Nestbau – eine Household-Management-App (Vanilla JS, kein Build-Schritt, Firebase-Backend).

---

## DEINE ROLLE

Du bist ein spezialisierter Code-Bot. Du liest, codest, testest und dokumentierst. Du arbeitest in klar abgegrenzten Batches. Nach jedem Batch: `node --check` auf geänderte JS-Dateien. Am Ende schreibst du eine Summary.

---

## PROBLEM

Google OAuth (PKCE) im Browser liefert kein Refresh-Token. Der Access-Token läuft nach 1h ab → User muss sich neu anmelden. Das betrifft den Google-Kalender-Sync.

**Ziel:** Nach deiner Arbeit läuft der Kalender-Sync dauerhaft, ohne dass der User nach 1h erneut anmelden muss.

---

## LÖSUNG (Architektur)

Der Token-Tausch wird über eine Firebase Cloud Function abgewickelt:

1. Frontend schickt den Authorization-Code an die Cloud Function (statt ihn selbst gegen Google einzutauschen)
2. Cloud Function tauscht Code + Client-Secret → Access-Token + Refresh-Token
3. Refresh-Token bleibt serverseitig (Firestore oder Function-intern)
4. Bei Token-Ablauf ruft das Frontend die Cloud Function auf → bekommt neuen Access-Token
5. Client-Secret ist NIE im Frontend

---

## REPOS & DATEIEN

Du arbeitest mit zwei Repos im selben Elternverzeichnis:

```
<vault-root>/
├── Nestbau/                          ← Haupt-Repo (App)
│   ├── index.html                    ← Haupt-App (~3000 Zeilen)
│   ├── js/
│   │   ├── nb-oauth.js              ← Google + Microsoft PKCE
│   │   ├── nb-google-cal.js         ← Google-Kalender-API
│   │   ├── nb-calendar-sync.js      ← Abgleich-Logik
│   │   ├── nb-firebase.js           ← Firestore-Collections
│   │   ├── nb-core.js               ← Error-Codes, Retry, HTTP
│   │   └── nb-config.local.js       ← Client-IDs (NICHT IM REPO)
│   └── tests/                        ← 43 Tests (müssen grün bleiben)
│
├── nestbau-firebase/                 ← Firebase-Backend
│   └── functions/
│       ├── src/tokens.js             ← TOKEN-TAUSCH-CODE (existiert, nicht deployed)
│       ├── package.json
│       └── index.js                  ← Einstiegspunkt
│
└── PROJEKTE/Nestbau/                 ← Dokumentation (Obsidian Vault)
    ├── PROJEKT-UPDATE.md             ← LIES MICH ZUERST
    ├── PROJEKT-LEARNINGS.md          ← LIES MICH ZWEITENS
    └── docs/auth-bot-token-refresh-brief-2026-09-12.md  ← Dieser Auftrag
```

**ACHTUNG:** Es gibt ein zweites Function-Set unter `Claude outputs/nestbau-v2-auth/functions/` — das ist NICHT maßgeblich. Arbeite ausschließlich mit `nestbau-firebase/functions/`.

---

## VOR DEM ERSTEN CODE

Lies diese 3 Dateien (in dieser Reihenfolge):

1. `PROJEKTE/Nestbau/PROJEKT-UPDATE.md` — aktueller Projektstand
2. `PROJEKTE/Nestbau/PROJEKT-LEARNINGS.md` — was schiefging und warum
3. `nestbau-firebase/functions/src/tokens.js` — bestehender Token-Tausch-Code

Danach: `grep -rn "googleapis.com\|calendar\|refreshToken\|access_token\|token_endpoint" Nestbau/js/` um zu verstehen, wie das Frontend aktuell mit Tokens umgeht.

---

## SCHRITTE

### Batch 1: Bestandsaufnahme

1. Lies `nestbau-firebase/functions/src/tokens.js` vollständig
2. Lies `nestbau-firebase/functions/index.js` — ist tokenRefresh dort exportiert?
3. Lies `nestbau-firebase/functions/package.json` — Dependencies vorhanden?
4. `grep -rn "refreshToken\|token_endpoint\|googleapis.*token\|401\|auth_required" Nestbau/js/` — wie reagiert das Frontend auf Token-Ablauf?
5. Lies `Nestbau/js/nb-oauth.js` — den Google-OAuth-Flow verstehen
6. Lies `Nestbau/js/nb-google-cal.js` — wo wird der Access-Token verwendet?

**Output Batch 1:** Liste mit Befunden:
- Ist der Code in tokens.js vollständig und korrekt?
- Fehlt etwas (Export, Dependencies, Error-Handling)?
- Wie geht das Frontend aktuell mit Token-Ablauf um?
- Was muss sich ändern?

`node --check` auf alle gelesenen JS-Dateien.

### Batch 2: Cloud Function fertigstellen

1. Falls `tokens.js` Lücken hat: ergänzen (Token-Tausch via `googleapis.com/oauth2/v4/token`)
2. In `index.js`: Function exportieren (falls nicht geschehen)
3. In `package.json`: fehlende Dependencies ergänzen
4. CORS konfigurieren (Frontend ruft von anderem Origin auf)
5. Error-Handling: klare Fehlercodes bei ungültigem/abgelaufenem Refresh-Token

`node --check nestbau-firebase/functions/index.js`
`node --check nestbau-firebase/functions/src/tokens.js`

**STOPP hier.** Deploy kann der Bot nicht — das braucht `firebase login` + Secrets. Stattdessen: dokumentiere exakt, was der User ausführen muss (siehe Reporting).

### Batch 3: Frontend anpassen

1. In `nb-oauth.js` oder `nb-google-cal.js`: bei Token-Ablauf (401 oder `expiresAt < Date.now()`) statt Neuanmeldung die Cloud Function aufrufen
2. Neuen Access-Token speichern, Sync fortsetzen
3. Fallback: wenn Cloud Function fehlschlägt → Neuanmeldung (wie bisher)
4. Error-Code `AUTH_REFRESH_FAILED` in `nb-core.js` ergänzen (falls sinnvoll)

`node --check` auf alle geänderten Dateien.

### Batch 4: Bestehende Tests prüfen

1. `cd Nestbau && npm test` — alle 43 Tests müssen grün sein
2. Falls ein Test bricht: fixen (deine Änderung hat ihn gebrochen, nicht der Test)
3. Falls sinnvoll: einen neuen Test für den Refresh-Flow ergänzen (optional, da Tests aktuell kein Firebase abdecken)

### Batch 5: Summary schreiben

Schreibe `PROJEKTE/Nestbau/Chat-Exports/auth-bot-token-refresh-fazit-2026-09-12.md` mit dem Format aus dem Reporting-Abschnitt unten.

---

## GRENZEN

- **KEIN `firebase deploy`** — das braucht Login + Secrets, die du nicht hast
- **KEIN `git push`** — du erstellst einen Branch und committest, Push macht der User
- **KEINE Änderungen an Firestore-Regeln** (außer du begründest es)
- **KEINE Änderungen am Design/CSS**
- **KEIN Client-Secret im Frontend** — das Secret gehört ausschließlich in die Cloud Function
- **Secrets:** Wenn du auf `GOOGLE_CLIENT_SECRET` stößt, schreib `[REDACTED]` — nie den echten Wert ausgeben
- **Erfinde keine Ursachen** — wenn etwas unklar ist, dokumentiere es als "Offen" in der Summary

---

## GIT-WORKFLOW

```bash
cd Nestbau
git checkout -b fix/google-token-refresh
# ... Änderungen ...
git add <geänderte Dateien>
git commit -m "fix: Google-Kalender Token-Refresh über Cloud Function

- Frontend ruft bei Token-Ablauf Cloud Function statt Neuanmeldung auf
- Fallback auf Neuanmeldung bei Function-Fehler
- Error-Code AUTH_REFRESH_FAILED ergänzt"
```

Für nestbau-firebase:
```bash
cd nestbau-firebase
git checkout -b fix/token-refresh-function
git add functions/
git commit -m "fix: Token-Refresh Cloud Function fertiggestellt

- tokenRefresh-Endpoint exportiert
- CORS konfiguriert
- Error-Handling für ungültiges Refresh-Token"
```

**Nicht pushen.** Der User macht das selbst.

---

## DEPLOY-ANLEITUNG FÜR DEN USER

Schreibe am Ende deiner Summary einen Block, den der User copy-pasten kann:

```
## Deploy-Schritte (für Indra)

1. Secret setzen:
   firebase functions:secrets:set GOOGLE_CLIENT_SECRET
   (Wert aus Google Cloud Console → APIs & Services → Credentials)

2. Cloud Function deployen:
   cd nestbau-firebase
   firebase deploy --only functions:<function-name>

3. Frontend pushen:
   cd Nestbau
   git push -u origin fix/google-token-refresh

4. Testen:
   - App öffnen, Google-Kalender verbinden
   - 1h warten ODER Token künstlich ablaufen lassen:
     localStorage.setItem("googleToken_expiresAt", Date.now() - 1000)
   - Seite neu laden → Sync sollte ohne Login weiterlaufen
   - Chrome DevTools → Network: POST an Cloud Function, neuer Bearer-Token
```

---

## REPORTING-FORMAT (Summary)

Datei: `PROJEKTE/Nestbau/Chat-Exports/auth-bot-token-refresh-fazit-2026-09-12.md`

```markdown
# Auth-Bot Summary: Token-Refresh

**Datum:** 2026-09-12
**Bot:** Auth-Bot (Claude Code)
**Branch Nestbau:** fix/google-token-refresh
**Branch nestbau-firebase:** fix/token-refresh-function

## Was wurde gemacht
- (Liste aller Änderungen mit Datei + Zeilennummern)

## Was wurde NICHT gemacht (und warum)
- (z.B. kein Deploy, kein Push — User muss selbst)

## Geänderte Dateien
| Datei | Änderung | Zeilen |
|-------|----------|--------|

## Test-Ergebnis
- npm test: XX/43 grün
- Manueller Test: (was getestet, was nicht)

## Deploy-Schritte für User
(Copy-paste-Block, siehe oben)

## Offene Punkte
- (Alles was unklar blieb oder nicht gelöst wurde)

## Empfehlung an CEO
- (Was als nächstes passieren sollte)
```

---

## WICHTIGE PATTERNS (aus PROJEKT-LEARNINGS)

- **Vor Code-Änderung:** Bereich per `grep` lokalisieren, nie raten
- **Nach jedem Batch:** `node --check` auf geänderte Dateien
- **Tests:** `npm test` muss 43/43 grün sein
- **BUILD-GUIDE.md lesen** (in `Nestbau/`), bevor du ein Problem als "neu" diagnostizierst
- **Light/Dark Screenshot-Review** ist hier nicht nötig (keine UI-Änderungen)
- **Zwei Repos = zwei Branches** — nicht mischen, nicht das falsche Repo ändern
