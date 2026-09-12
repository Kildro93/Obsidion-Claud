# Nestbau v2.0 – Auth & Profile

Bot 1 der v2.0-Architektur: Registrierung, Email-Verifikation, Profil und
Haushalts-System. Alles ist als Drop-in fuer das Repo
[Kildro93/Nestbau](https://github.com/Kildro93/Nestbau) gebaut – kein Build-Schritt,
kein Framework, ES-Module direkt im Browser.

## Inhalt

```
public/
  auth.html               Kompletter Auth-Flow (alle Screens in einer Datei)
  css/nestbau.css         Design-System (Markenfarben, Komponenten, Dark Mode)
  js/firebase-config.js   SDK-Init, Emulator-Erkennung, Persistenz
  js/validation.js        Validierung + Konstanten (Allergene, Fitnesslevel, Farben)
  js/auth-service.js      Registrierung, Login, Verifikation, Passwort-Reset
  js/profile-service.js   Profil lesen/schreiben, Avatar-Upload mit Resize
  js/household-service.js Haushalte, Einladungen, Mitglieder
  js/ui.js                Toasts, Feldfehler, Chips, Wizard-Fortschritt
  js/auth-app.js          Flow-Controller (Routing zwischen den Screens)

functions/
  index.js                Exports, Region europe-west1
  lib/common.js           Admin-SDK, Auth-Guards, Validierung
  lib/render.js           Email-Rendering (ohne Admin-SDK, damit lokal testbar)
  lib/mail.js             Mail-Queue fuer die Trigger-Email-Extension
  lib/users.js            Auth-Trigger, Verifikation, Profil-Sync
  lib/households.js       Haushalte, Einladungen, Rollen
  templates/*.html        Email-Templates (Quelle der Wahrheit)

emails/preview/           Generierte Vorschau (node tools/render-emails.js)
firestore.rules           Security Rules
storage.rules             Storage Rules
firestore.indexes.json    Composite Indexes
firebase.json             Hosting, Emulatoren, Deploy-Ziele
docs/INTEGRATION.md       Setup + Schnittstellen fuer Bot 2 und Bot 3
docs/SECURITY.md          Bedrohungsmodell und was dagegen tut
```

## Schnellstart

```bash
cd nestbau-v2-auth/functions && npm install && cd ..
firebase emulators:start
```

Dann `http://localhost:5000/auth.html` oeffnen. Auf `localhost` schaltet
`firebase-config.js` automatisch auf die Emulatoren um.

Vor dem ersten echten Deploy: Firebase-Config in
[public/js/firebase-config.js](public/js/firebase-config.js) ersetzen
(Console > Projekteinstellungen > Web-App).

```bash
firebase deploy --only firestore:rules,storage:rules,functions,hosting
```

## Der Flow

```
Registrieren -> Email bestaetigen -> Profil-Wizard (3 Schritte) -> Haushalt -> App
                                     Name/Farbe/Foto
                                     Alter/Groesse/Gewicht/Fitness
                                     Allergien/Ernaehrung
```

Der Controller routet bei jedem Auth-State-Wechsel neu und springt an die
Stelle, an der der User stehengeblieben ist. Ein Abbruch mitten im Wizard
kostet nichts – beim naechsten Login geht es dort weiter.

Einladungen laufen ueber einen Link in der Email
(`auth.html?invite=<id>&token=<token>`). Der Token wird nur gehasht
gespeichert und nach dem Einloesen sofort aus der Adresszeile entfernt.

## Datenmodell

| Collection | Sichtbarkeit | Inhalt |
|---|---|---|
| `users/{uid}` | nur eigener User | Email, Status, `householdIds`, aktiver Haushalt |
| `profiles/{uid}` | **nur eigener User** | Name, Farbe, Alter, Groesse, Gewicht, Fitness, Allergien |
| `households/{hid}` | Mitglieder | Name, Beschreibung, `members{uid: {role}}`, `memberUids[]` |
| `households/{hid}/members/{uid}` | Mitglieder | Geteilte Karte: Name, Farbe, Foto, Rolle, ggf. Allergien |
| `invites/{id}` | Eingeladene + Absender | Haushalt, Email, Rolle, Token-Hash, Ablauf |
| `mail/{id}` | niemand (Server) | Ausgangs-Queue der Email-Extension |

Der Trick mit der Member-Card: `profiles` bleibt komplett privat.
Was Mitglieder voneinander sehen duerfen, kopiert eine Cloud Function in
`households/{hid}/members/{uid}` – Allergien nur, wenn der User das im
Profil freigibt. Gewicht, Groesse und Alter verlassen das private Profil nie.

## Abweichungen vom ersten Firebase-Setup-Guide

Zwei Punkte im urspruenglichen Entwurf funktionieren so nicht:

- **`match /{document=**} { allow read, write: if request.auth != null }`**
  hebt jede spezifischere Regel wieder auf. Firestore-Rules werden vereinigt,
  nicht ueberschrieben – mit dieser Catch-all-Regel haette jeder angemeldete
  User alle Profile und Haushalte lesen koennen. Sie ist ersatzlos raus.
- **`admin.auth().generateEmailVerificationLink()`** erzeugt nur einen Link,
  verschickt aber nichts. Der Versand laeuft hier ueber die `mail`-Collection
  (Trigger-Email-Extension); ohne Extension faellt der Client automatisch auf
  Firebases Standard-`sendEmailVerification()` zurueck.

Details und weitere Abweichungen: [docs/SECURITY.md](docs/SECURITY.md).
