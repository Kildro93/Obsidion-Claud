# Nestbau v2.0 – Technische Erkenntnisse [stated]

**Sammlung von Firebase, Sicherheit, und Architektur-Lessons aus allen 4 Bots**

---

## 🔥 Firebase Best Practices [stated]

### 1. Security Rules vereinigen sich mit OR [ERROR-CRITICAL]

Firestore wertet **alle** Regeln durch und vereinigt sie mit OR-Logik.

```javascript
// ❌ FALSCH (aus Setup-Guide):
match /{document=**} {
  allow read, write: if request.auth != null;
}
```

**PROBLEM**: Hebt jede spezifischere Regel auf. Jeder angemeldete User kann alle Daten lesen.

**FIX**: Keine Catch-all-Regel. Spezifische Matches definieren Zugriff, Rest ist implizit deny.

---

### 2. Email-Verifikation ist manueller Prozess [ERROR-CRITICAL]

`admin.auth().generateEmailVerificationLink()` **erzeugt nur** einen Link.

```javascript
// ❌ FALSCH (aus Setup-Guide):
await admin.auth().generateEmailVerificationLink(user.email);
// User erhält KEINE Mail!

// ✅ KORREKT:
const link = await admin.auth().generateEmailVerificationLink(user.email);
await admin.firestore().collection('mail').doc(uid).set({
  to: user.email,
  template: 'verify',
  link,
  createdAt: new Date(),
});
// Extension "Trigger Email from Firestore" versendet
```

**Lesson**: Erst erzeugen, dann explizit versenden. Keine "magic" Automation.

---

### 3. Custom Claims für Rollen-Caching [OPTIMIZATION]

Rollen **im Token** speichern = schneller als Firestore-Lookup.

```javascript
// Nach Haushalt-Beitritt:
await admin.auth().setCustomUserClaims(uid, {
  hh: { [householdId]: 'admin' }
});
```

**Rules**:
```javascript
function role(hid) {
  const claim = request.auth.token.get('hh', {}).get(hid, null);
  if (claim != null) return claim; // Schnell (kein Read)
  
  // Fallback: nur wenn Token alt (< 1 Stunde)
  return get(/databases/.../households/$(hid))
    .data.roles.get(uid(), null);
}
```

**Limit**: Token max ~1 KB. Nach ~5 Haushalten wird es eng.

---

### 4. Composite Indexes sind Pflicht [OPERATIONAL]

Queries mit `arrayContains` + `orderBy` brauchen einen Index.

```javascript
db.collection('recipes')
  .where('categories', 'array-contains', 'vegetarian')
  .orderBy('titleLower', 'asc');
// Ohne Index → Fehler: "index not found"
```

**Best Practice**: `firestore.indexes.json` vor dem ersten Deploy schreiben, nicht ad-hoc.

---

### 5. Storage Rules können Firestore nicht effizient prüfen [LIMITATION]

```javascript
// ⚠️ Teuer – liest pro Upload:
match /households/{hid}/{path=**} {
  allow write: if firestore.get(...).data.members.contains(uid());
}
```

**Workaround**: 
- Storage-Pfade enthalten `{hid}` als Zugangsschutz (Auflistung unmöglich)
- Berechtigungsprüfung über Firestore-Rules **vor** Upload
- Storage-Rules nur einfache Path-Checks

---

## 🔐 Sicherheit [stated]

### 1. Token-Handling: Bearer, nie URL/Query [SECURITY-CRITICAL]

```javascript
// ✅ KORREKT:
fetch(url, {
  headers: { 'Authorization': `Bearer ${token}` }
});

// ❌ FALSCH:
fetch(url + `?token=${token}`); // Token in Logs sichtbar!
```

**Clipper-Tokens** (Bot 4):
- Klartext-Token: nur einmalig beim Anlegen angezeigt
- DB-Speicherung: SHA-256-Hash
- API-Requests: Bearer-Header

---

### 2. Einladungs-Token: Einmalig + gehashed + Timing-safe [SECURITY-CRITICAL]

```javascript
// Erzeugung:
const token = crypto.randomBytes(24).toString('base64url');
const hash = crypto.createHash('sha256').update(token).digest('hex');

// Verifikation:
crypto.timingSafeEqual(storedHash, incomingHash);

// URL-Cleanup:
history.replaceState(null, '', '/auth.html');
// Verhindert: Screenshot, Referrer-Leaks
```

**Zusätzliche Checks**:
- Email des Annehmenden muss zur Einladung passen
- Ablauf nach 7 Tagen
- Status nach Accept: nicht mehr `pending`

---

### 3. XSS-Schutz: textContent, nie innerHTML [SECURITY-CRITICAL]

```javascript
// ✅ KORREKT:
el.textContent = userName;

// ❌ FALSCH:
el.innerHTML = `<p>${userName}</p>`;
```

**Regel**: Nur statisches Markup mit `innerHTML`, User-Daten mit `textContent` oder `createElement`.

---

### 4. Passwort-Scoring ohne Sonderzeichen-Zwang [SECURITY-UX]

Score 0–4:
- **Länge** dominant: 10–12 = +1, 13–15 = +2, 16+ = +3
- **Pattern-Malus**: `1234`, `password`, `nestbau`, Wiederholungen = -1

**Min. Score 2** erforderlich (z. B. 10 Zeichen + Mischung).

**NICHT erzwingen**: `!@#$` Sonderzeichen. Passphrasen sind stärker.

---

### 5. Email Enumeration Protection [SECURITY-UX]

```
Firebase Console → Authentication → Settings
→ "Email enumeration protection" aktivieren
```

**Effekt**: Login + Password-Reset geben **immer** dieselbe vage Fehlermeldung, egal ob Email existiert.

**Ohne Protection**: "Email nicht registriert" verrät bekannte Adressen.

---

## 🏗️ Architektur-Patterns [stated]

### 1. Mirror-Collection für Datenschutz [DESIGN-PATTERN]

Problem: Mitglieder brauchen Name/Farbe/Foto, aber nicht Alter/Gewicht/Allergien.

**Lösung**:
```
profiles/{uid}                     (strikt privat)
  ↓
  Cloud Function (~onProfileChanged)
  ↓
households/{hid}/members/{uid}     (öffentlich im Haushalt)
```

Function kopiert selektiv:
- **Immer**: displayName, color, photoPath, role
- **Optional**: allergyIds (nur wenn User Freigabe gesetzt)
- **Nie**: age, height, weight

**Vorteil**: Granulare Kontrolle ohne komplexe Rules.

---

### 2. Cloud Functions als State Machine [ARCHITECTURE]

Nicht alle States in einem Handler, sondern separate Functions:

```
Register
  ↓ onUserCreated (Trigger)
Email-Verification (Firebase Auth)
  ↓
Profile-Wizard (3 Screens)
  ↓ updateProfile (Callable)
Household-Join
  ↓ inviteToHousehold / createHousehold
Accept-Invite
  ↓ acceptInvite (Mirror-Doc erstellt)
App
```

**Vorteil**: Jeder State ist isoliert + testbar. User können jederzeit unterbrechen.

---

## 🤖 Rezept-Import (Bot 4) [stated]

### 1. Zwei-stufiger Parser [ARCHITECTURE]

1. **JSON-LD** (deterministisch, offline)
   - Schema.org Recipe-Markup
   - Fallback: Mikrodata/RDFa

2. **KI-Fallback** (Claude Opus 5)
   - Nur wenn JSON-LD < 50% Felder
   - Structured Output garantiert Schema
   - ~1–2K Input-Tokens durchschnittlich

**Kosten**: ~$2–4/Monat (10 Importe/Tag, 70% mit KI)

---

### 2. Bilddownload mit SSRF-Schutz [SECURITY]

```javascript
// ❌ FALSCH:
const image = await fetch(userUrl);
// SSRF: `http://169.254.169.254/metadata` → AWS Secrets!

// ✅ KORREKT:
const blockedIPs = [
  '10.0.0.0/8', '172.16.0.0/12', '192.168.0.0/16',
  '127.0.0.1', '169.254.0.0/16' // Link-Local
];
if (isPrivateIP(url.hostname, blockedIPs)) throw new Error('Private IP');

const response = await fetch(url, {
  redirect: 'follow', // Max 3 Hops, each IP-checked
  size: 8 * 1024 * 1024 // 8 MB max
});
```

---

### 3. Zutaten-Matcher mit Confidence-Score [ALGORITHM]

Matching (in Reihenfolge):
1. Exakter Name (normalisiert)
2. Singular/Plural-Varianten
3. Token-Ähnlichkeit (Jaccard ≥ 0.5)
4. Substring-Treffer

- **Confidence ≥ 0.5** → automatisch zuordnen
- **< 0.5** → Vorschlag im UI-Editor

---

## 💾 Deploy-Checkliste [OPERATIONAL]

- [ ] `anthropic.api_key` Secret gesetzt (Bot 4)
- [ ] `SENDGRID_API_KEY` Secret (oder Extension aktiv)
- [ ] `APP_BASE_URL` in `functions/.env`
- [ ] Email-Templates in Firebase Console angepasst
- [ ] App Check (reCAPTCHA v3) aktiviert
- [ ] **Firestore Rules vor Functions deployen** ← CRITICAL
- [ ] **Firestore Indexes vor Functions** ← CRITICAL
- [ ] Storage-CORS für externe Foto-Downloads

---

## 📦 PWA, Play Store & Build (Build Optimizer, 2026-09-03) [stated]

**Quelle:** Build-/Test-Session auf `release/play-store`, Commit `7b01fe1`.
**Achtung:** Diese Erkenntnisse betreffen die **lokale v1-Fassung ohne Firebase**,
nicht den `main`-Branch. Siehe [[haushalts-app]] → Branch-Divergenz.

---

### 1. Play Store nimmt PWAs nur als TWA an [OPERATIONAL]

Der von Google unterstützte Weg ist eine **Trusted Web Activity**: ein dünner
Android-Container, der die Seite in einem Chrome ohne Adressleiste lädt.

Daraus folgen zwei Voraussetzungen, die keine Abkürzung kennen:

1. Die App muss unter einer **öffentlichen HTTPS-URL** laufen. `localhost`
   funktioniert nicht.
2. Unter `https://<domain>/.well-known/assetlinks.json` muss der
   **SHA-256-Fingerprint** des Signaturschlüssels liegen.

Fehlt Punkt 2, zeigt Android die Adressleiste — die App wirkt wie ein
Browserfenster und fällt in der Review meist durch.

---

### 2. assetlinks.json wird nur in der Domain-Wurzel gesucht [ERROR-CRITICAL]

Android sucht die Datei **immer** unter `https://<domain>/.well-known/assetlinks.json`,
**nie** im Projektpfad.

```
❌ https://kildro93.github.io/Nestbau/.well-known/assetlinks.json   (wird ignoriert)
✅ https://kildro93.github.io/.well-known/assetlinks.json           (wird gelesen)
```

**Konsequenz für GitHub Pages in einem Unterverzeichnis:** Die Datei lässt sich
dort nicht ablegen. Drei Wege:

- eigene Domain auf das Pages-Repo zeigen lassen
- ein Repo `<user>.github.io` anlegen und dort nur die `assetlinks.json` ablegen
- die App direkt ins Repo `<user>.github.io` legen (`startUrl` wird dann `/`)

**Impact:** Wer das übersieht, baut ein AAB, das installiert — aber die
Adressleiste zeigt.

---

### 3. Play App Signing ändert den relevanten Fingerprint [ERROR-CRITICAL]

Für neue Apps signiert Google die Auslieferung mit einem **eigenen** Schlüssel.
Der lokale Upload-Keystore ist dann nicht mehr der, mit dem die installierte App
signiert ist.

In `assetlinks.json` muss der Fingerprint aus der Play Console stehen
(*Setup → App-Integrität → App-Signaturschlüssel*). Beide einzutragen ist
erlaubt und der sichere Weg.

**Symptom bei Fehler:** Lokal gebautes APK funktioniert, die aus dem Store
installierte App zeigt die Adressleiste.

---

### 4. targetSdkVersion 35 ist Pflicht [OPERATIONAL]

Play verlangt seit August 2025 `targetSdkVersion 35` für neue Uploads.
`minSdkVersion 23` (Android 6) deckt praktisch alle aktiven Geräte ab.

---

### 5. Keystore-Erzeugung ist kein Bot-Task [SECURITY-CRITICAL]

```bash
keytool -genkeypair -v -storetype PKCS12 \
  -keystore android/upload-keystore.jks \
  -alias upload -keyalg RSA -keysize 2048 -validity 10000
```

- Hier werden **Passwörter vergeben** — kein Automat sollte das übernehmen.
- Geht der Keystore verloren, lässt sich die App im Store **nie wieder
  aktualisieren**.
- `.gitignore` muss `android/`, `*.jks`, `*.keystore`, `*.aab`, `*.apk`,
  `keystore.properties`, `local.properties` enthalten.

Ein commiteter Keystore ist öffentlich und damit wertlos — die Store-Identität
der App ist dann kompromittiert.

---

### 6. Maskable Icons brauchen 20 % Sicherheitsrand [DESIGN]

Android beschneidet adaptive Icons je nach Launcher-Form (Kreis, Squircle,
Rundrechteck). Der sichtbare Bereich ist ein Kreis mit 80 % Kantenlänge.

**Regel:** Motiv auf 60 % der Fläche zentrieren, Rest ist Rand.
Ohne diesen Rand schneidet der Launcher das Motiv an.

Play-Anforderungen: Icon **512×512** PNG, Feature-Graphic **1024×500** PNG,
mindestens **2 Phone-Screenshots** (16:9 oder 9:16, kürzere Kante ≥ 320 px,
längere ≤ 3840 px). Verwendet wurden 1080×1920.

---

### 7. Windows: `sharp` scheitert, `@resvg/resvg-js` funktioniert [OPERATIONAL]

`sharp` bricht auf Windows beim Kompilieren nativer Abhängigkeiten ab
(libvips). `@resvg/resvg-js` liefert ein vorkompiliertes Binary und rendert
SVG → PNG ohne Build-Schritt.

Alle 13 PWA-Icons plus Feature-Graphic werden aus einer einzigen `icon.svg`
erzeugt. Die CI prüft, dass die eingecheckten PNGs zur Quelle passen.

---

### 8. Node-Glob nur ohne Shell [ERROR]

```javascript
// ❌ FALSCH — die Shell frisst das Muster, 0 Tests laufen (Exit-Code 0!):
execFile(node, ["--test", "tests/**/*.test.mjs"], { shell: true });

// ✅ KORREKT — Node expandiert den Glob selbst:
execFile(node, ["--test", "tests/**/*.test.mjs"], { shell: false });
```

**Impact:** Der Statusbericht meldete „0/0 Tests grün" als Erfolg. Ein
Test-Runner, der nichts findet, muss als Fehler gelten.

---

### 9. Prüfskripte müssen ihren Exit-Code setzen [ERROR]

Ein Skript, das offene Punkte auf der Konsole ausgibt, aber mit Exit-Code 0
endet, meldet dem übergeordneten Report fälschlich „grün".

**Regel:** Jede Prüfung mit offenen Punkten setzt `process.exitCode = 1`.

---

### 10. TWA-Build-Kette [OPERATIONAL]

```bash
node scripts/build-twa.mjs --check        # Voraussetzungen
node scripts/build-twa.mjs --init         # Android-Projekt (Bubblewrap)
node scripts/make-assetlinks.mjs <SHA256> # Digital Asset Links
node scripts/build-twa.mjs --build        # AAB + APK
```

Werkzeuge auf dem Rechner von Indra bestätigt vorhanden: JDK 21.0.7,
Android SDK, Platform `android-35`, Build-Tools 35.0.0 / 35.0.1 / 36.0.0.

---

## 🏗️ Firestore Datenmodell – Phase 1 Complete (Sept 4, 2026) [stated]

**Quelle:** Firebase Architect Session, Commit 6624822+

### Collections Structure

```
households/{hid}
├── members/{uid}
├── ingredients/{id}
├── recipes/{id} – mit Image-URLs (Storage), nicht Base64
├── ingredientCategories/{id}
├── ingredientGroups/{id}
├── dishCategories/{id}
├── menuPlan/{YYYY-MM-DD} – ein Dokument pro Tag
├── events/{id}
├── subscriptions/{id}
└── meta/migration – Migration-Marker

joinCodes/{CODE} – Lookup-Tabelle für sichere Beitritte
```

### Security Rules

- **Haushalt-Level:** Nur Mitglieder dürfen lesen/schreiben
- **isMember() Check:** `request.auth.uid in household(hid).memberUids`
- **Keine List-Operations:** Collections können nicht aufgelistet werden
- **Join-Codes:** Nur gezielter Zugriff (8-Zeichen URL-safe)
- **Storage:** Images blockiert auf `households/{hid}/images/{hash}.{ext}`, max 10 MB

### Real-time Sync Architecture

```
localStorage (lokal, schnell)
    ↓
[NB.app.state]  ←→  [Real-time Listeners]
    ↓
Firestore (cloud, geteilt)
```

**Schreib-Fluss:**
```
User ändert Rezept → state update → persist() → 
localStorage + cloud.pushChanges() → Firestore → 
Real-time Listener → state + render() → UI
```

**Lese-Fluss:**
```
Firestore Update → Real-time Listener → 
state update → render() → UI
```

### Performance & Size

- **Max 1 MiB pro Dokument** → Bilder externalisieren zu Storage
- **Batch Writes:** bis 500 Operationen
- **Offline Caching:** `enablePersistence({ synchronizeTabs: true })`
- **Change Detection:** Hash-basiert (nur geänderte Docs hochladen)
- **Composite Indexes:** 8 Stück in `firestore.indexes.json`

### Implementation Status

- ✅ SDK Integration (compat-Builds)
- ✅ Authentication (Google Sign-In)
- ✅ Household Management
- ✅ Image Upload (Base64 → Storage URLs)
- ✅ Real-time Listeners
- ✅ Change Detection via Hashing
- ✅ Migration Framework (backup + batch-upload + verify)
- ⏳ Full Testing (Phase 2)

### Cloud Functions (Optional)

Ready-to-deploy templates in `functions/index.js`:
- `onHouseholdCreated` – Initialisierung
- `onHouseholdDeleted` – Cleanup
- `onMemberJoined` – Welcome-Events
- `onRecipeUpdated` – Validierungen
- `onRecipeDeleted` – Storage-Cleanup

---

## 🔗 Verwandte Erkenntnisse

- [[haushalts-app]] – Hauptarchitektur + Phase 1 Status
- [[nestbau-testing]] – Bugs und Fixes + Phase 2 Roadmap
