---
tags: [projekt/nestbau, typ/status, status/aktuell]
aktualisiert: 2026-09-12
---

# Nestbau – Projekt-Übersicht

Household-Management-App für einen Zweipersonenhaushalt (Indra + Partnerin). Web-App (Vanilla JS), Android via Capacitor, optionaler Firebase-Sync. Repo: https://github.com/Kildro93/Nestbau

## Schnelleinstieg

| Frage | Datei |
|-------|-------|
| Was ist Nestbau, wie läuft der Loop? | [[PROJEKT-LOOP]] |
| Aktueller Stand? | [[PROJEKT-UPDATE]] |
| Was haben wir gelernt? | [[PROJEKT-LEARNINGS]] |
| Zugänge? | [[PROJEKT-ACCESS]] |
| Features & Anforderungen? | [[Features]] · [[User-Stories]] · [[Tech-Stack]] |
| Design & UI? | [[Design-System]] · [[User-Flows]] · Entscheidungs-Log: [[Learnings]] |
| Code & Struktur? | [[CODE-Landkarte]] |
| Alle Sessions & Diskussionen? | [[INDEX\|Chat-Exports/INDEX]] |
| Wie hängt alles zusammen? | [[VERKNUEPFUNGEN]] |
| Technische Tiefe? | [[NESTBAU-KNOWLEDGE-INDEX]] |

## Ordner

```
PROJEKTE/Nestbau/
├─ PROJEKT-LOOP / -UPDATE / -LEARNINGS / -ACCESS   Loop-Steuerung
├─ README.md            Diese Datei
├─ VERKNUEPFUNGEN.md    Abhängigkeits-Map
├─ NESTBAU_AKTUELL.md   Feature-Status im Detail
├─ ARTIFACT_LINKS.md    Versions-URLs
├─ Learnings.md         Chronologischer Feature-/UI-Entscheidungs-Log
├─ REQUIREMENTS/        Features, User-Stories, Tech-Stack
├─ DESIGN/              Design-System, User-Flows
├─ CODE/                Zeiger auf die echten Repos + lose Snippets
├─ Knowledge/           tech, testing, haushalts-app, quickref, INDEX
├─ Chat-Exports/        Session-Ergebnisse + INDEX
└─ Fact-Sheets/         Firebase-Architektur, Kochbuch-Datenmodell
```

## Wo liegt der Code?

Nicht hier. Der Code liegt im Vault-Root:

- `Nestbau/` – Haupt-Repo (App + Android + Play-Store), eigenes Git
- `nestbau-firebase/` – Firebase-Backend-Ansatz, eigenes Git
- `Claude outputs/nestbau-v2-auth/`, `.../nestbau-v2-recipe-import/` – generierte Drop-in-Bundles

Details und Zuordnung: [[CODE-Landkarte]].

## Wichtige Links

- Repo: https://github.com/Kildro93/Nestbau
- Issues: https://github.com/Kildro93/Nestbau/issues
- Aktuelle Artifact: siehe [[ARTIFACT_LINKS]]
