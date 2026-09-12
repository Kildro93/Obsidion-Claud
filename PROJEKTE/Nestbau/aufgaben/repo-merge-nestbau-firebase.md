---
title: repo-merge-nestbau-firebase
created: 2026-09-12
updated: 2026-09-12
status: offen
tags: [typ/aufgabe, projekt/nestbau, bereich/firebase]
autor: indra
---

# Aufgabe: Nestbau + nestbau-firebase zu einem Repo zusammenfuehren

## Ausgangslage

Zwei separate Git-Repos im Vault-Root:

- `Nestbau/` — App (Frontend, Android/Capacitor, Firebase Hosting)
  - GitHub: `Kildro93/Nestbau`
  - Hat eigene `firebase.json`, `firestore.rules`, `functions/`
- `nestbau-firebase/` — Backend (Cloud Functions, Clipper-Extension, Migration)
  - GitHub: `Kildro93/nestbau-firebase` (vermutlich, pruefen)
  - Hat eigene `firebase.json`, `firestore.rules`, `functions/`, `clipper/`, `migration/`, `schema/`

Beide zeigen auf dasselbe Firebase-Projekt: `nestbau-app`

## Ziel

Ein einzelnes Repo statt zwei. Deployment muss weiter funktionieren.

## Kritische Punkte

1. **Doppelte Dateien pruefen** — beide haben `firebase.json`, `firestore.rules`, `firestore.indexes.json`, `storage.rules`, `functions/`. Welche Version ist aktueller?
2. **Firebase-Config mergen** — `firebase.json` aus beiden Repos muss zusammengefuehrt werden (Hosting + Functions-Targets)
3. **Firestore-Rules mergen** — Nestbau hat 4.5 KB, nestbau-firebase hat 11.5 KB. Die groessere ist vermutlich vollstaendiger.
4. **Functions zusammenfuehren** — Nestbau hat `functions/index.js`, nestbau-firebase hat `functions/` mit separaten Modulen
5. **Clipper-Extension** aus nestbau-firebase → evtl. als Unterordner `clipper/` im Ziel-Repo
6. **Git-Historie** — Entscheidung: einfach kopieren (Historie von nestbau-firebase geht verloren) oder `git subtree add` (Historie bleibt)
7. **.gitignore** im Vault anpassen — `/nestbau-firebase/` Eintrag kann danach entfernt werden
8. **PROJEKTE/Nestbau/CODE/** — dort liegen bereits `nestbau-v2-auth/` und `nestbau-v2-recipe-import/` als Vault-Kopien von Code-Fragmenten. Abgleichen.

## Dateipfade

| Was | Pfad |
|---|---|
| App-Repo | `C:\KI Programme\Obsidion fuer Claud\Nestbau\` |
| Firebase-Repo | `C:\KI Programme\Obsidion fuer Claud\nestbau-firebase\` |
| Vault-Notizen | `PROJEKTE\Nestbau\` |
| Vault .gitignore | `.gitignore` (Zeile 63-64: `/Nestbau/` und `/nestbau-firebase/`) |
| Firebase-Projekt | `nestbau-app` |
| GitHub-User | `Kildro93` |

## Empfohlene Reihenfolge

1. Beide Repos lokal auf main bringen, alles committet
2. Entscheiden: Nestbau als Ziel-Repo (groesser, hat App + Hosting)
3. nestbau-firebase-Inhalte nach Nestbau/ kopieren/mergen
4. Konflikte in firebase.json, rules, functions loesen
5. Lokal testen: `firebase emulators:start`, `firebase deploy --only functions --dry-run`
6. Altes Repo archivieren (nicht sofort loeschen)
7. Vault .gitignore anpassen
