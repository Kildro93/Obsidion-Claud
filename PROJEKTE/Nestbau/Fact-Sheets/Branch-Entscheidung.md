# Fact-Sheet: Branch-Entscheidung Nestbau

**Stand:** 2026-09-07
**Frage:** Welche Fassung geht in den Play Store, was passiert mit den drei Branches?

## Befund

| Branch | Inhalt | Verhältnis zu main | Bewertung |
|---|---|---|---|
| `main` | aktuelle App: Capacitor/Android, Firebase, Design-System, Play-Store-Unterlagen, signierter AAB | Produktionsstand, 23 Commits | **geht in den Play Store** |
| `release/play-store` | 43 Tests, Audit-Skripte, TWA-Build-Kette, GitHub-Pages-Workflow, PWA-Icons | Abzweig vor 19 Commits, 1 eigener Commit, 47 Dateien (nur 7 überschneiden sich) | Tests portiert, Rest verworfen |
| `master` | Recipe-Import-System: Web-Clipper, Cloud Functions, Firestore-Rules, 164 Dateien | **keine gemeinsame History** – eigener Root-Commit, faktisch ein anderes Projekt (entspricht dem Ordner `nestbau-firebase/`) | kein Merge-Kandidat |

## Entscheidung

1. **Play Store: `main`.** Der signierte AAB (2.0.0, versionCode 1) stammt von hier, die Play-Store-Unterlagen liegen hier. Capacitor ist der gewählte Auslieferungsweg.
2. **`release/play-store` wird nicht gemergt.** Der Branch verfolgt einen zweiten Auslieferungsweg (TWA über GitHub Pages mit assetlinks.json). Zwei Wege parallel zu pflegen kostet mehr, als der TWA-Weg bringt. Wertvoll waren nur die vom Auslieferungsweg unabhängigen Teile — die sind portiert (Commit 6fa2fbe):
   - `tests/` (43 Tests, unit + integration, jsdom)
   - `scripts/server.mjs`, `health-check.mjs`, `security-check.mjs`, `perf-audit.mjs`, `error-report.mjs`
   - Nicht portiert: `build-twa.mjs`, `make-assetlinks.mjs`, `twa-manifest.json`, `.github/workflows/pages.yml`, `assets/play/`
3. **`master` bleibt liegen.** Sinnvoller wäre ein eigenes Repo `Kildro93/nestbau-firebase`, weil ein Branch ohne gemeinsame History in einem App-Repo dauerhaft verwirrt. Kein dringender Handlungsbedarf.

## Verifikation (07.09.2026)

- 43/43 Tests grün auf `release/play-store` **und** unverändert grün gegen den heutigen `main`
- Security-Audit gegen `main`: 0 hoch, 2 mittel, 6 niedrig — nicht blockierend
  - mittel: `innerHTML` mit interpoliertem Nutzerwert ohne sichtbares `escapeHtml()` (index.html:2110, 2477)
  - niedrig: 6× ungefilterter Wert in einem HTML-Attribut (Foto-URLs, dataUrl, key)
- Performance-Budgets gegen `main` alle eingehalten: index.html 38,7 KB gzip (Budget 60), Auslieferung gesamt 40,2 KB (90), Bootzeit 203 ms (1500)

## Offen daraus

- [x] XSS-Befunde entschärft (07.09.2026): vier Vorschauen über `setPhotoPreview()` per DOM-API, zwei HTML-String-Stellen mit `escapeHtml()`. Audit danach 0 hoch / 0 mittel / 0 niedrig.
- [x] `npm install` gelaufen; `sharp` auf ^0.35.4 angehoben, `npm audit` meldet 0 Schwachstellen
- [ ] Entscheiden, ob `master` in ein eigenes Repo umzieht

## Verweise

- Status: [[PROJEKT-UPDATE]] · Erkenntnisse: [[PROJEKT-LEARNINGS]]
- Build: `Nestbau/BUILD-GUIDE.md`
