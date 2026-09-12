# Fazit: Vault-Analyse – 2026-09-12

## Abgeschlossene Aufgaben
- Vollständige Vault-Analyse (Redundanzen, Widersprüche, Struktur, Tags)
- Erstanalyse vom 04.09. gegen den heutigen Stand geprüft

## Status
Der Umbau vom 06./07.09. hat den Grossteil der damaligen Befunde erledigt:
Ordnerstruktur, Git-Repo, Archiv, Auflösung des zweiten Knowledge-Index.
Sechs Punkte sind offen, alle kosmetisch bis klein.

## Wichtigste Erkenntnisse
- Die Analyse vom 04.09. wurde nie in Dateien geschrieben, nur in den Chat – sie ist mit jenem Chat verloren gegangen. Ergebnisse gehören sofort in den Vault.
- Git-Hygiene ist sauber: Code-Ordner und `.env.local` sind korrekt ignoriert, keine Secrets im Repo.

## Nächste Schritte
1. `.obsidian/app.json` Ausschlussfilter setzen (siehe Offene Probleme)
2. `ARTIFACT_LINKS.md` klären oder nach `ARCHIV/`
3. Dubletten in `Claude outputs/` löschen
4. Frontmatter-/Tag-Schema einführen

## Dateipfade
- SYSTEM/Chat-Exports/Vault-Analyse-Fazit-2026-09-12.md (diese Datei)

## Offene Probleme

| # | Befund | Ort |
|---|---|---|
| 1 | `app.json` ist leer → Obsidian indexiert ~180 Markdown-Dateien aus `Nestbau/node_modules`; Play-Store-Platzhalter erzeugen über 170 tote Graph-Knoten | `.obsidian/app.json` |
| 2 | 1 von 62 Notizen hat Frontmatter, im ganzen Vault keine Tags | vault-weit |
| 3 | Artifact vom 28.08. steht als „Live, wird laufend aktualisiert" – überholt seit GitHub/AAB | `PROJEKTE/Nestbau/ARTIFACT_LINKS.md` |
| 4 | Session-Backup ist eine 1:1-Kopie von 7 Prompt- und 2 Doku-Dateien, die daneben liegen | `Claude outputs/Nestbau-Session-Backup-2026-09-07/` |
| 5 | Zwei abweichende Fassungen des Closure-Protokolls, keine als gültig markiert | `SYSTEM/Chat-Closure-Protocol.md` vs. `Claude outputs/Chat-Closure-Protocol-v2.md` |
| 6 | Überschrift `## Changelog` steht zweimal (Zeile 10 und 12) | `PROJEKTE/Nestbau/Learnings.md` |

Ebenfalls doppelt: Rezept-Import-Code liegt in `nestbau-firebase/` (mit Git-Historie)
und in `Claude outputs/nestbau-v2-recipe-import/` (byte-identisch). Beide von Git ignoriert.

## Tipps für zukünftige Chats
- Ausschlussfilter für `app.json`, direkt einsetzbar:

```json
{
  "userIgnoreFilters": [
    "Nestbau/node_modules",
    "Nestbau/android",
    "Nestbau/dist",
    "nestbau-firebase/node_modules",
    "Nestbau/play-store"
  ]
}
```

- Vorgeschlagenes Tag-Schema: `projekt/`, `bereich/`, `typ/`, `status/`;
  Frontmatter je Notiz mit `tags` und `aktualisiert`.
- Keine Statuskopien anlegen: Nestbau-Status gehört nach [[PROJEKT-UPDATE]].
- Befunde nie nur im Chat lassen – sofort als Datei ablegen.
