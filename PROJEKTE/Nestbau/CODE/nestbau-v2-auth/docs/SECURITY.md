# Sicherheit – was geschuetzt wird und wodurch

Kurzfassung: der Client darf nichts, was er sich selbst zuweisen koennte.
Alles, was Berechtigungen veraendert, laeuft ueber Cloud Functions.

---

## Die zwei Korrekturen am urspruenglichen Entwurf

**1. Catch-all-Regel entfernt**

```javascript
// Aus dem Setup-Guide – so nicht einsetzen:
match /{document=**} {
  allow read, write: if request.auth != null;
}
```

Firestore-Rules werden **vereinigt (OR)**, nicht ueberschrieben. Solange
irgendeine Regel zutrifft, ist der Zugriff erlaubt. Die Catch-all-Regel oben
haette also jede darunter stehende, engere Regel wirkungslos gemacht: jeder
angemeldete User haette alle Profile inklusive Allergien, Gewicht und
Groesse lesen und schreiben koennen.

**2. Verifikations-Email wurde nie verschickt**

`admin.auth().generateEmailVerificationLink()` *erzeugt* einen Link und gibt
ihn zurueck – der Versand ist Sache des Aufrufers. Im Entwurf wurde der
Rueckgabewert verworfen, es waere nie eine Mail angekommen. Hier geht der Link
in `lib/mail.js` und von dort in die `mail`-Collection.

---

## Bedrohungen und Gegenmassnahmen

### Fremde Profildaten lesen
`profiles/{uid}` erlaubt `get` nur fuer `request.auth.uid == uid`, `list` gar
nicht. Selbst Haushalts-Mitglieder kommen nicht ans private Profil. Was sie
sehen duerfen, steht in `households/{hid}/members/{uid}` und wird
serverseitig aus dem Profil abgeleitet – Allergien nur bei ausdruecklicher
Freigabe, Alter/Groesse/Gewicht grundsaetzlich nie.

### Sich selbst in einen fremden Haushalt schreiben
`households/{hid}` erlaubt `update` nur dem Admin und nur fuer
`name`, `description`, `color`, `updatedAt` (`onlyChanged`-Helper).
Die Felder `members`, `memberUids` und `adminUid` sind fuer den Client
komplett gesperrt; nur das Admin-SDK schreibt sie. Die Subcollection
`members` ist client-seitig read-only.

### Einladungslink raten oder wiederverwenden
- Token: 24 zufaellige Bytes (`crypto.randomBytes`), base64url.
- In Firestore liegt nur der **SHA-256-Hash**. Wer die Datenbank liest,
  kann daraus keinen gueltigen Link bauen.
- Der Vergleich laeuft ueber `crypto.timingSafeEqual`.
- Zusaetzlich muss die **Email des Annehmenden** zur Einladung passen –
  ein geleakter Link allein reicht nicht.
- Ablauf nach 7 Tagen, Status wechselt auf `expired`.
- Einmalig: nach `accepted` ist der Status nicht mehr `pending`.
- Der Client entfernt Token und Invite-ID sofort per `history.replaceState`
  aus der URL, damit sie nicht in Verlauf, Screenshots oder Referrer landen.

### Konten aufzaehlen (User Enumeration)
Falsches Passwort und unbekannte Email liefern **dieselbe** Meldung
("Email oder Passwort stimmt nicht."). Der Passwort-Reset meldet immer Erfolg,
unabhaengig davon, ob die Adresse existiert. In der Console zusaetzlich
*Email enumeration protection* aktivieren – dann liefert Firebase selbst nur
noch `auth/invalid-credential`.

Die Einladungsfunktion verraet ebenfalls nicht, ob eine Adresse registriert
ist: eingeladen wird jede Adresse, ein Konto entsteht erst beim Annehmen.

### Passwort-Raten
- Client: nach 5 Fehlversuchen exponentieller Backoff (15 s, 30 s, 60 s, …),
  in `sessionStorage`. Das ist reine UX-Bremse und kein Schutz – wer die
  Konsole benutzt, umgeht sie.
- Server: Firebase Auth sperrt nach zu vielen Versuchen selbst
  (`auth/too-many-requests`).
- Empfohlen: **App Check** (reCAPTCHA v3) aktivieren. Ohne App Check kann
  jeder mit dem oeffentlichen apiKey direkt gegen die Auth-API laufen.

### Schwache Passwoerter
Mindestens 10 Zeichen, Bewertung 0–4 mit Laengen-Gewichtung; offensichtliche
Muster (`1234`, `passwort`, `nestbau`, Wiederholungen) ziehen ab. Unter Score 2
lehnt das Formular ab. Bewusst *keine* erzwungenen Sonderzeichen: eine lange
Wortkombination ist staerker und wird nicht auf einen Zettel geschrieben.

### Einladungs-Spam ueber unser Mail-Kontingent
Maximal 10 Einladungen pro Haushalt und Stunde (`count()`-Query auf `invites`),
maximal 8 Mitglieder pro Haushalt, maximal 5 Haushalte pro Konto.
Verifikations-Mails: 60 Sekunden Cooldown pro User.

### XSS ueber Namen und Beschreibungen
- Frontend: ausschliesslich `textContent` / `createElement`, nie `innerHTML`
  mit User-Daten. (Die einzigen `innerHTML`-Aufrufe leeren Container oder
  setzen statisches Markup.)
- Emails: `render()` escaped jeden Platzhalter. Nur `link` und
  `householdDescription` sind als `raw` markiert – beide werden serverseitig
  erzeugt bzw. vorher selbst escaped.
- Hosting: `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY`,
  `Referrer-Policy: strict-origin-when-cross-origin` in `firebase.json`.

### Uploads
Storage-Rules: nur `image/jpeg|png|webp`, maximal 5 MB, nur unter dem eigenen
`profiles/{uid}/`-Pfad, Schreiben nur mit verifizierter Email. Der Client
rechnet das Bild vorher auf 512x512 WebP herunter – ein Handyfoto schrumpft
von ~4 MB auf ~40 KB. Fester Dateiname `avatar.webp`, damit ein neuer Upload
den alten ersetzt statt den Bucket vollaufen zu lassen.

Profilbilder sind **nicht** oeffentlich lesbar (`allow read: if signedIn()`),
anders als im urspruenglichen Entwurf. Eine oeffentliche Download-URL laesst
sich sonst beliebig weiterreichen.

### Verwaiste Daten nach Kontolöschung
`onUserDeleted` entfernt Profil, User-Dokument, alle Member-Cards und zieht
offene Einladungen zurueck. War der Geloeschte letzter Admin eines Haushalts
mit weiteren Mitgliedern, wandert die Admin-Rolle automatisch weiter – sonst
waere der Haushalt fuer immer unverwaltbar. Dieselbe Logik greift bei
`leaveHousehold`.

---

## Bewusste Kompromisse

**Tokens im Browser-Storage.** Die Integrations-Checkliste verlangt
"keine Tokens in localStorage, nur Session". Umgesetzt ist:
Firebase verwaltet seine Tokens selbst in IndexedDB (nie von Hand gesetzt),
und der Login-Screen hat den Schalter *Angemeldet bleiben*.
Aus: `browserSessionPersistence` – Abmeldung beim Schliessen des Tabs.
An (Default): `browserLocalPersistence`.

Grund fuer den Default: Nestbau ist eine installierte PWA auf dem Handy.
Mit Session-Persistenz muesste man sich bei jedem App-Start neu anmelden,
und die vorhersehbare Folge waere ein kuerzeres Passwort. Der ID-Token laeuft
ohnehin nach einer Stunde ab; erneuert wird ueber den Refresh-Token, den nur
das SDK anfasst.

**Keine Custom Claims fuer Haushalts-Mitgliedschaft.** Waere schneller
(kein `get()` in den Rules), erfordert aber einen Token-Refresh nach jeder
Aenderung – bis dahin sieht der Client veraltete Berechtigungen. Bei zwei
bis acht Mitgliedern lohnt die Komplexitaet nicht. Falls Bot 2 spaeter viele
Reads pro Sekunde misst: Subcollections unter `households/{hid}` verwenden,
das reduziert die Rule-Reads staerker als Claims.

---

## Vor dem Live-Gang

- [ ] `firebaseConfig` durch echte Projektwerte ersetzt
- [ ] `APP_BASE_URL` in `functions/.env` auf die Produktionsdomain
- [ ] Firestore/Storage im *Locked mode* gestartet, Rules deployed
- [ ] App Check aktiviert und in Functions erzwungen
- [ ] Email enumeration protection aktiviert
- [ ] Authorized domains auf die eigenen Domains begrenzt
- [ ] Absenderadresse der Auth-Mails auf eigene Domain (SPF/DKIM gesetzt)
- [ ] Budget-Alert in der Google Cloud Console (Blaze-Plan hat kein Limit)
- [ ] Rules mit `@firebase/rules-unit-testing` getestet
- [ ] Kontolöschung einmal durchgespielt (verwaiste Member-Cards?)
