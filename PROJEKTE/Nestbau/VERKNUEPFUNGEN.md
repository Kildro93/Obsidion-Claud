# VERKNÜPFUNGEN: Nestbau-Projekt

Wie die Notiz-Dateien zusammenhängen. Einstieg: [[README]].

## Abhängigkeits-Map

```
README  ──►  PROJEKT-LOOP ──► PROJEKT-UPDATE ──► PROJEKT-LEARNINGS
   │                │                                  ▲
   │                └── PROJEKT-ACCESS                  │  (CEO zieht Learnings
   │                                                    │   nach jedem Bot-Ende)
   ├─► REQUIREMENTS/Features ──► User-Stories
   │        │
   │        └── Tech-Stack ──► CODE/CODE-Landkarte ──► echte Repos (Nestbau/, nestbau-firebase/, Claude outputs/)
   │                                 │
   │                                 ├── CODE/Datenbank-Schema ──► Fact-Sheets/Firebase-Architektur
   │                                 └── CODE/Snippets/* ──► Fact-Sheets/Kochbuch-Datenmodell
   │
   ├─► DESIGN/Design-System  ◄── Learnings (chronolog. UI-Entscheidungen)
   │        └── DESIGN/User-Flows
   │
   ├─► Knowledge/NESTBAU-KNOWLEDGE-INDEX ──► nestbau-tech / nestbau-testing / haushalts-app / nestbau-quickref
   │
   └─► Chat-Exports/INDEX ──► einzelne Session-Exports ──► CODE/Snippets/*
                                     └──► Erkenntnisse ──► PROJEKT-LEARNINGS
```

## Tabelle

| Datei | verweist auf | Beziehung |
|-------|--------------|-----------|
| README.md | alle Kern-Dateien | Einstieg |
| PROJEKT-LOOP.md | PROJEKT-UPDATE, -LEARNINGS, -ACCESS, NESTBAU_AKTUELL | Loop-Steuerung |
| Features.md | User-Stories, NESTBAU_AKTUELL, Learnings | Was |
| User-Stories.md | Features | Warum / Rollen |
| Tech-Stack.md | CODE-Landkarte, haushalts-app (Branch-Divergenz) | Womit |
| CODE-Landkarte.md | Nestbau/, nestbau-firebase/, Claude outputs/*, Datenbank-Schema, Snippets | Wo liegt Code |
| Datenbank-Schema.md | Firebase-Architektur, nestbau-tech, kochbuch-naehrwert-berechnung | Firestore-Modell |
| Design-System.md | Nestbau/DESIGN-GUIDE.md, Learnings | Wie es aussieht |
| User-Flows.md | Features, Datenbank-Schema | Abläufe |
| Snippets/menuplan-migration.md | 2026-09-05-Export, kochbuch-naehrwert-berechnung, PROJEKT-LEARNINGS | Code-Fragment |
| Snippets/css-spezifitaet-dark-mode-fix.md | 2026-09-05-Export, Design-System, PROJEKT-LEARNINGS | Code-Fragment |
| Snippets/kochbuch-naehrwert-berechnung.md | Kochbuch-Datenmodell, Datenbank-Schema, Features | Code-Fragment |
| Chat-Exports/INDEX.md | Session-Exports, Claude outputs/BOT_*, PROJEKT-LEARNINGS | Session-Register |
| Knowledge/NESTBAU-KNOWLEDGE-INDEX.md | nestbau-tech, nestbau-testing, haushalts-app, nestbau-quickref | Wissens-Navigation |
| ARTIFACT_LINKS.md | Learnings | Versions-URLs |
| Learnings.md | Profil, Regeln | chronolog. Changelog + Feedback |

## Externe Anker

- Repo: https://github.com/Kildro93/Nestbau
- Maßgebliche Doku im Repo: `Nestbau/README.md`, `BUILD-GUIDE.md`, `DEPLOYMENT.md`, `FIREBASE-ARCHITECTURE.md`, `DESIGN-GUIDE.md`, `IMPLEMENTATION-STATUS.md`, `docs/INTEGRATIONEN.md`, `play-store/`
- SYSTEM: [[MEMORY_INDEX]], [[Regeln]], [[Profil]], [[Vault-Struktur]]
