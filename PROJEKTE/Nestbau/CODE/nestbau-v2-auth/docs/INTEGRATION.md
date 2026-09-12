# Integration – Setup und Schnittstellen

Fuer Bot 2 (Firebase & Data) und Bot 3 (Kochbuch & Calendar).

---

## 1. Firebase-Console: was aktiviert sein muss

| Bereich | Einstellung |
|---|---|
| Authentication | Sign-in method > **Email/Password** aktivieren |
| Authentication | Settings > **Email enumeration protection** aktivieren |
| Authentication | Settings > Authorized domains: Hosting-Domain + eigene Domain |
| Firestore | Location **europe-west1**, Start im *Locked mode* (nicht Test-Modus) |
| Storage | Location **europe-west1** |
| Functions | Region **europe-west1**, Blaze-Plan noetig |
| Extensions | **Trigger Email from Firestore**, Collection `mail` |
| App Check | reCAPTCHA v3 fuer Web – schuetzt Functions vor fremden Clients |

Die Extension "Trigger Email from Firestore" braucht einmalig SMTP-Zugangsdaten
(SendGrid, Mailgun, oder ein eigener SMTP-Server). Dadurch liegt **kein API-Key
im Function-Code**.

Ohne Extension: `lib/mail.js#enqueue` durch einen direkten Mailer ersetzen und
den Key ueber `defineSecret('SENDGRID_KEY')` einbinden – nie als Klartext-Env.

## 2. Deploy-Reihenfolge

```bash
cd functions && npm install && cd ..

# 1. Rules zuerst – sonst laeuft die App kurz ungeschuetzt
firebase deploy --only firestore:rules,storage:rules

# 2. Indexes (die Queries in household-service.js brauchen sie)
firebase deploy --only firestore:indexes

# 3. Functions
firebase functions:config:unset 2>/dev/null || true
firebase deploy --only functions

# 4. Frontend
firebase deploy --only hosting
```

`functions/.env` anlegen (siehe `.env.example`):

```
APP_BASE_URL=https://nestbau-app.web.app
```

Die URL landet in den Email-Links. Falsch gesetzt heisst: Einladungen zeigen
ins Leere.

## 3. Email-Templates in der Console

Firebase verschickt zwei Mails selbst, die nicht durch unsere Templates laufen:
**Passwort-Reset** und (im Fallback) **Email-Verifikation**. Beide unter
Authentication > Templates anpassen:

**Email-Verifikation**
- Betreff: `Bestaetige deine Nestbau-Email`
- Nachricht: `Hallo, bestaetige deine Email-Adresse fuer Nestbau: %LINK% – Der Link ist 24 Stunden gueltig. Du hast dich nicht registriert? Dann ignoriere diese Nachricht.`

**Passwort zuruecksetzen**
- Betreff: `Neues Passwort fuer Nestbau`
- Nachricht: `Setze dein Nestbau-Passwort zurueck: %LINK% – Wenn du das nicht warst, passiert nichts; dein aktuelles Passwort bleibt gueltig.`

Absender-Adresse auf eine eigene Domain umstellen (Authentication > Templates >
Absender anpassen), sonst landen die Mails haeufiger im Spam.

## 4. Callable Functions – die API fuer die anderen Bots

Alle in `europe-west1`, alle verlangen **angemeldet + Email verifiziert**.

| Function | Input | Output |
|---|---|---|
| `syncAuthState` | `{}` | `{status, emailVerified, profileComplete, householdIds, activeHouseholdId}` |
| `sendVerificationEmail` | `{}` | `{ok}` |
| `createHousehold` | `{name, description?}` | `{householdId, name}` |
| `inviteToHousehold` | `{householdId, email, role?}` | `{inviteId, expiresAt}` |
| `acceptHouseholdInvite` | `{inviteId, token}` | `{householdId, householdName}` |
| `declineHouseholdInvite` | `{inviteId}` | `{ok}` |
| `revokeHouseholdInvite` | `{inviteId}` | `{ok}` |
| `removeHouseholdMember` | `{householdId, uid}` | `{ok}` |
| `updateMemberRole` | `{householdId, uid, role}` | `{ok}` |
| `leaveHousehold` | `{householdId}` | `{ok, transferredAdmin}` |

Fehler kommen als `HttpsError` mit deutscher Message zurueck;
`auth-service.js#toMessage()` mappt sie fuer die UI.

## 5. Was Bot 2 und Bot 3 brauchen

**Der Haushalts-Scope fuer alle geteilten Daten:**

```js
import { auth, db } from './js/firebase-config.js';

// Aktiver Haushalt des Users
const userSnap = await getDoc(doc(db, 'users', auth.currentUser.uid));
const householdId = userSnap.data().activeHouseholdId;

// Alle geteilten Collections haengen daran
const recipes = collection(db, 'households', householdId, 'recipes');
```

**Empfehlung an Bot 2:** Rezepte, Zutaten und Menuepläne als **Subcollections
unter `households/{hid}`** anlegen, nicht als Top-Level-Collections mit
`householdId`-Feld. Grund: die Rule ist dann ein einziger `get()` auf den
Elterndokument-Pfad statt eines `get()` pro gelesenem Dokument – das spart
bei einer Rezeptliste mit 50 Eintraegen 50 zusaetzliche Reads.

Passendes Rules-Muster (an `firestore.rules` anhaengen):

```javascript
match /households/{hid}/recipes/{recipeId} {
  allow read, write: if isMember(hid);
}
match /households/{hid}/ingredients/{ingredientId} {
  allow read, write: if isMember(hid);
}
match /households/{hid}/menuPlans/{planId} {
  allow read, write: if isMember(hid);
}
```

`isMember(hid)` ist in `firestore.rules` bereits definiert.

**Allergien fuer den Menueplan (Bot 3):**
Nicht aus `profiles/{uid}` lesen – darauf hat niemand ausser dem Besitzer
Zugriff. Stattdessen:

```js
const members = await getDocs(collection(db, 'households', householdId, 'members'));
const allergies = members.docs
  .filter((d) => d.data().allergiesShared)
  .flatMap((d) => d.data().allergies);
```

Wer nicht freigegeben hat, taucht mit leerer Liste auf. Das ist Absicht:
die UI sollte dann "Allergien nicht freigegeben" anzeigen statt "keine Allergien".

**Calendar-Tokens (Bot 3):**
`calendarIntegrations` gehoert nicht in dieses Modul, aber die Rule muss
dazu passen – Tokens sind streng privat:

```javascript
match /calendarIntegrations/{docId} {
  allow read, write: if isSelf(resource.data.uid);
  allow create: if isSelf(request.resource.data.uid);
}
```

Besser noch: Refresh-Tokens gar nicht in Firestore, sondern im **Secret
Manager** ablegen und nur eine Referenz speichern.

## 6. Migration der bestehenden lokalen Profile

Die v1-App speichert zwei Profile lokal ("Ich" + "Partnerin"). Beim ersten
v2-Login laesst sich das uebernehmen:

```js
const legacy = JSON.parse(localStorage.getItem('nestbau_profiles') || '[]');
const mine = legacy.find((p) => p.id === 'me');
if (mine) {
  await saveProfile({
    displayName: mine.name,
    color: mine.color,
    age: mine.age,
    heightCm: mine.height,
    weightKg: mine.weight,
    fitnessLevel: mine.fitnessLevel || 'medium',
    allergies: mine.allergies || [],
    dietary: [],
    shareAllergiesWithHousehold: false
  }, { markComplete: false });   // Wizard trotzdem einmal durchlaufen lassen
}
```

Das Partnerin-Profil wird **nicht** migriert – daraus wird eine Einladung.
Sonst haette man ein Profil ohne Konto, das niemand bearbeiten kann.

## 7. Testen

```bash
firebase emulators:start                 # Auth, Firestore, Functions, Storage, Hosting
node tools/render-emails.js              # Email-Vorschau nach emails/preview/
```

Im Emulator gehen keine echten Mails raus. Der Verifikations-Link steht in der
Emulator-UI unter Authentication, die Einladungs-Mail als Dokument in der
`mail`-Collection im Firestore-Emulator.

Rules-Tests (empfohlen fuer Bot 2, `@firebase/rules-unit-testing`):

```js
// Fremdes Profil lesen muss scheitern
await assertFails(getDoc(doc(bobDb, 'profiles', aliceUid)));
// Mitglied darf den Haushalt lesen
await assertSucceeds(getDoc(doc(aliceDb, 'households', hid)));
// Niemand darf sich selbst zum Mitglied machen
await assertFails(updateDoc(doc(bobDb, 'households', hid), { [`members.${bobUid}`]: { role: 'admin' } }));
```
