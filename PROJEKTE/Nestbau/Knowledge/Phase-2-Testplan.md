# Phase 2: Testplan Two-Device-Sync

**Erstellt:** 2026-09-07 · **Dauer Kernpfad:** ~20 Minuten
**Voraussetzung:** Kalender-Sync und Firebase-Anmeldung laufen, Regeln ausgerollt (alles erledigt am 07.09.2026)

## Vorbereitung

1. Dev-Server läuft: `node scripts/server.mjs --port 8000` im Nestbau-Ordner
2. **Gerät A**: dein normales Browser-Profil auf `http://localhost:8000`
3. **Gerät B**: zweites Profil im selben Browser (Chrome/Brave: Profil-Symbol → „Hinzufügen" → ohne Konto) — **nicht** das Inkognito-Fenster, das teilt sich den Speicher nicht sauber und verliert alles beim Schliessen
4. In beiden Profilen `http://localhost:8000` öffnen

Wichtig: beide Profile melden sich mit **demselben Google-Konto** an. Getestet wird der Haushalt, nicht die Kontotrennung.

## Kernpfad (Test 1–5)

### Test 1 – Haushalt anlegen (Gerät A)
Einstellungen → Kochbuch in der Cloud → „Mit Google anmelden" → „Haushalt anlegen".
**Erwartet:** Karte zeigt „Haushalt: <ID>" und darunter den Beitrittscode. Code notieren.

### Test 2 – Kochbuch hochladen (Gerät A)
Button „Kochbuch hochladen". Vorher läuft ein `window.confirm`, und die App lädt automatisch eine Sicherungsdatei herunter.
**Erwartet:** Fortschrittsbalken läuft durch, danach steht „Live-Abgleich läuft".
**Tipp:** Vorher „Testlauf" klicken — der macht dieselbe Prüfung ohne zu schreiben.

### Test 3 – Beitreten (Gerät B)
Anmelden → Code aus Test 1 in das Feld „Beitrittscode" → „Beitreten".
**Erwartet:** Karte zeigt dieselbe Haushalts-ID. Danach erscheint „In diesem Haushalt liegt bereits ein Kochbuch" → „Kochbuch übernehmen".
**Achtung:** Dieser Schritt ersetzt den lokalen Bestand von Gerät B durch den gemeinsamen. Da B ein frisches Profil ist, ist das unkritisch.

### Test 4 – Änderung von A nach B
Auf **A** ein Rezept anlegen oder umbenennen.
**Erwartet:** Nach spätestens ~2 Sekunden erscheint es auf **B** ohne Neuladen. Der Upload ist um 1,2 Sekunden verzögert gebündelt, danach kommt der Live-Abgleich.

### Test 5 – Änderung von B nach A
Dasselbe rückwärts: auf **B** eine Zutat anlegen, auf **A** prüfen.
**Erwartet:** dito.

## Was synchronisiert wird

| Bereich | Sammlung | synchronisiert |
|---|---|---|
| Aufgaben & Listen | `lists` | ja |
| Kalender-Termine | `events` | ja |
| Abos / Finanzen | `subscriptions` | ja |
| Zutaten | `ingredients` | ja |
| Rezepte | `recipes` | ja |
| Zutaten-Kategorien & -Gruppen | `ingredientCategories`, `ingredientGroups` | ja |
| Gerichtkategorien | `dishCategories` | ja |
| Menüplan | `menuPlan` | ja |

Nicht synchronisiert: alles, was nicht in dieser Liste steht — z. B. reine Geräteeinstellungen.

## Erweiterte Tests (danach, je ~5 Minuten)

### Test 6 – Offline
Auf **B** DevTools → Network → „Offline". Eine Zutat anlegen. Wieder online schalten.
**Erwartet:** Die Änderung landet nach dem Wiederverbinden auf A. Firestore hat Offline-Persistenz aktiv.

### Test 7 – Konflikt
Beide Geräte offline schalten, **dasselbe** Rezept unterschiedlich ändern, beide online schalten.
**Erwartet (Ist-Zustand):** Der letzte Schreibvorgang gewinnt, die andere Änderung geht verloren. Das ist der offene Architektur-Punkt „Multi-Device-Konflikt-Resolution" — hier geht es nur darum, das Verhalten zu belegen, nicht es zu beheben.

### Test 8 – Regeln greifen
In einem dritten Profil mit **anderem** Google-Konto anmelden, ohne Beitrittscode.
**Erwartet:** Kein Zugriff auf die Daten des Haushalts. Die Firestore-Regeln erlauben Lesen nur Mitgliedern aus `memberUids`.

### Test 9 – Falscher Code
Auf einem frischen Profil einen erfundenen Beitrittscode eingeben.
**Erwartet:** saubere Fehlermeldung, kein Absturz.

## Was ich bei Fehlern brauche

- Die Meldung aus der Karte selbst
- F12 → Console: Zeilen mit `[nb:cloud]` oder `[nb:sync]`
- Bei Regelfehlern: der Firestore-Fehlercode (`permission-denied`, `failed-precondition`, `unavailable`)

## Verweise

- Status: [[PROJEKT-UPDATE]] · Erkenntnisse: [[PROJEKT-LEARNINGS]]
- Emulator statt echtem Projekt: `emulator: true` in `js/nb-config.local.js`, siehe [[Emulator-Setup]]
