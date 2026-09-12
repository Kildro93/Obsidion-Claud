---
tags: [projekt/nestbau, typ/status, status/aktuell]
aktualisiert: 2026-09-12
---

# PROJEKT-UPDATE: Nestbau

**Stand:** 2026-09-12
**Aktualisiert von:** CEO-Nestbau (Cowork)

## Status

**Gesamt-Progress:** v2.0 produktiv, Firebase Phase 1 abgeschlossen, Design-System konsistent auf `main` (PR #1 gemergt, 43/43 Tests grün).
**Aktuell:** Kein Bot aktiv. Google-Kalender-Sync läuft (1h-Token-Limit). Firebase-Anmeldung + Multi-Device-Sync live (ohne manuellen Schalter). Phase-2-Kernpfad (Test 1–5) bestanden.
**Nächster Schritt:** Auth-Bot für Token-Refresh starten. Brief liegt vor: `docs/auth-bot-token-refresh-brief-2026-09-12.md`.

---

## A) WAS FUNKTIONIERT

| Feature | Status | Quelle |
|---------|--------|--------|
| Aufgaben & Listen (5 Standard + eigene, Filter, Wiederholung) | live | NESTBAU_AKTUELL, Features.md |
| Kalender (Wochen-/Monatsansicht, SBB-Uhr, Kategorien, To-Dos) | live | NESTBAU_AKTUELL |
| Finanzen/Abos (Kategorien, Intervalle, Jahresübersicht, Diagramm) | live | NESTBAU_AKTUELL |
| Kochbuch: Zutaten (Datenbank, Nährwerte, Kamera, Allergene) | live | NESTBAU_AKTUELL |
| Kochbuch: Rezepte (Kacheln, Filter, Leseansicht, Nährwert-Berechnung) | live | NESTBAU_AKTUELL |
| Kochbuch: Menüplan (4 Slots/Tag, Stepper, saisonale Vorschläge) | live | NESTBAU_AKTUELL |
| Kochbuch: Einkaufsliste aus Menüplan | live | NESTBAU_AKTUELL |
| Profile (2 Profile, lokaler Login) | live | NESTBAU_AKTUELL |
| Firebase Auth (Google Sign-In) | live | PROJEKT-UPDATE 07.09., Fazit 07.09. |
| Firestore-Sync (Aufgaben, Events, Abos, Kochbuch komplett) | live | Phase-2-Testplan, Test 1–5 bestanden |
| Multi-Device-Sync (ohne manuellen Schalter, 1,2s-Fenster geschlossen) | live | Commit 97583da, Konzept-Multi-Device |
| Haushalt teilen via Beitrittscode | live | Test 3 bestanden |
| Google-Kalender-Sync (OAuth PKCE, bidirektional) | eingeschränkt | Token läuft nach 1h ab, kein Refresh |
| Design-System (warme Palette, WCAG-AA, Dark Mode) | live | PR #1 gemergt (91197f5) |
| Test-Suite (43 Tests) | grün | npm test, Fazit 07.09. |
| Security-Audit | 0 Befunde | npm run audit:security |
| Vault Auto-Sync & Backup | live | VBS-Wrapper verifiziert 12.09. |
| Release-Keystore + signiertes AAB | vorhanden | dist/nestbau-2.0.0-release.aab |

**Nicht verifiziert / fraglich:**
- NESTBAU_AKTUELL.md behauptet "Outlook Kalender: ✅ Live" — kein anderes Dokument stützt das. **Bitte manuell prüfen.**

---

## B) WAS NICHT FUNKTIONIERT

| Problem | Ursache | Schweregrad | Aufwand |
|---------|---------|-------------|---------|
| Google-Kalender-Token läuft nach 1h ab | PKCE liefert kein Refresh-Token im Browser | **hoch** | ~2h (Code liegt vor in `nestbau-firebase/functions/src/tokens.js`) |
| Tests decken Firebase nicht ab | 43 Tests stammen von vor der Firebase-Integration | mittel | ~3–4h (neue Test-Szenarien mit Emulator) |
| Phase-2-Tests 6–9 nicht durchgeführt | Brauchen zwei echte Browser-Profile gegen echtes Firebase | mittel | ~30min (manuell, am PC) |
| Zwei parallele Function-Sets | `nestbau-firebase/functions/` vs. `Claude outputs/nestbau-v2-auth/functions/` — unklar welches maßgeblich | mittel | ~1h (Abgleich + Entscheidung) |
| Tasks als nested items[] statt Subsammlung | Architektur-Altlast, Perf bei vielen Tasks | niedrig | ~2–3h |
| Offline-Konflikt: last-write-wins ohne Meldung | Option A (Meldung) konzipiert, nicht umgesetzt | niedrig (2 Nutzer) | ~1–2h |
| Play-Store-Release blockiert | GitHub Pages nicht aktiviert + Produktions-Redirect-URI fehlt | blockiert | Manuelle Aktion + ~15min |
| OAuth-Client-Secret bei Google löschen | Unnötiger PKCE-Restwert | niedrig | 2min (Console) |
| Branch `claude/new-session-je60jy` auf GitHub | Gemergt, nicht gelöscht (403 beim Versuch) | kosmetisch | 1min |

---

## C) WAS UNKLAR IST

1. **Outlook-Kalender:** NESTBAU_AKTUELL.md sagt "Live", aber kein Fazit, kein Test, kein Commit erwähnt eine funktionierende Outlook-Integration. Entweder veraltet oder nie verifiziert.

2. **Maßgebliches Function-Set:** CODE-Landkarte warnt: "Zwei parallele Function-Sets — vor Deploy klären, welches der Stand ist." Die `nestbau-firebase/functions/` haben die Token-Refresh-Logik, die `Claude outputs/nestbau-v2-auth/functions/` haben den Auth-Flow. Beides zeigt auf dasselbe Firebase-Projekt `nestbau-app`. Der Repo-Merge (aufgaben/repo-merge-nestbau-firebase.md) würde das lösen, ist aber offen.

3. **Git-Stand des Vault-Klons:** CODE-Landkarte (07.09.) sagt "1 Commit hinter origin/main". War inzwischen `git pull` gemacht? Die 5-Task-Session (12.09.) hat auf `main` gemergt und gepusht — unklar, ob lokal synchron.

4. **GitHub-PAT-Status:** Unbekannt ob gültig oder abgelaufen. Nur am Windows-PC prüfbar (Credential Manager).

5. **NESTBAU_AKTUELL.md insgesamt veraltet:** "Letzte Änderung: 28.08.2026", listet unter "Nächste Schritte" Punkte, die seit 07.09. erledigt sind (Client-IDs, firebase deploy). Braucht ein Update oder Deprecation zugunsten von PROJEKT-UPDATE.md.

---

## D) ROADMAP — Nächste 5 Schritte

| # | Schritt | Bot-Rolle | Blocker | Aufwand |
|---|---------|-----------|---------|---------|
| 1 | **Token-Refresh ausrollen** — Cloud Function deployen, Frontend anbinden, testen | Auth-Bot (Claude Code) | GOOGLE_CLIENT_SECRET muss gesetzt sein | ~2h |
| 2 | **Phase-2-Tests 6–9 durchführen** — Offline, Konflikt, Regeln, falscher Code | Manuell (Indra am PC) | Keiner (Testplan liegt vor) | ~30min |
| 3 | **Repo-Merge: nestbau-firebase → Nestbau** — Ein Repo statt zwei, Function-Konflikt lösen | Infra-Bot (Claude Code) | Beide Repos auf main, alles committet | ~2–3h |
| 4 | **Tasks → Firestore-Subsammlung** — Perf-Refactor, nested items[] ablösen | Code-Bot (Claude Code) | Nach Repo-Merge (sonst unklar wo) | ~2–3h |
| 5 | **Play-Store-Vorbereitung** — GitHub Pages aktivieren, Produktions-Redirect-URI, assetlinks.json | Manuell + Bot | GitHub Pages = manuell | ~1h |

**Sofort von Indra zu erledigen (kein Bot nötig):**
- `git pull origin main` im Vault-Ordner (falls nicht seit 12.09. geschehen)
- GitHub-PAT prüfen/erneuern
- Outlook-Kalender-Behauptung verifizieren (App öffnen, testen)
- NESTBAU_AKTUELL.md als veraltet markieren oder aktualisieren

---

## Vorbereiteter nächster Bot-Auftrag

**Bot:** Auth-Bot (Token-Refresh)
**Brief:** `PROJEKTE/Nestbau/docs/auth-bot-token-refresh-brief-2026-09-12.md` ✅ Ready
**Kurzfassung:** PKCE liefert kein Refresh-Token → nach 1h "Neu anmelden". Code für Token-Tausch über Cloud Function existiert (`nestbau-firebase/functions/src/tokens.js`), nicht ausgerollt. Bot soll: prüfen, deployen, Frontend anbinden, testen, dokumentieren.
**Fallback:** Tasks zu Firestore-Subsammlung refaktorieren (unabhängig, bounded).

---

## Erledigt (letzte Sessions)

- 2026-09-12: Design-System-Bug behoben (dupliziertes Inline-CSS), WCAG-AA-Kontrast korrigiert, PR #1 gemergt (91197f5), Icon/Splash/Store-Assets neu generiert
- 2026-09-12: VBS-Wrapper für Auto-Sync/Backup verdrahtet, Weekly-Backup getestet, Loop-Vorbereitung (Auth-Bot-Brief)
- 2026-09-10: Phase-2-Kernpfad bestanden (Test 1–5), Multi-Device-Sync ohne Schalter umgebaut (97583da)
- 2026-09-08: Firestore-Regeln für lists/events/subscriptions ergänzt (76cd20e)
- 2026-09-07: Branch-Entscheidung, 43 Tests portiert, XSS-Härtung, Google-Kalender + Firebase ans Laufen gebracht
- 2026-09-06: Vault konsolidiert, Wegwerf-Ordner gelöscht, Git-Repo initialisiert

## Wichtigste Dateien

| Frage | Datei |
|-------|-------|
| Einstieg | [[README]] |
| Loop-Struktur | [[PROJEKT-LOOP]] |
| Erkenntnisse | [[PROJEKT-LEARNINGS]] |
| Zugänge | [[PROJEKT-ACCESS]] |
| Features | [[Features]] / [[NESTBAU_AKTUELL]] (⚠️ veraltet) |
| Code | [[CODE-Landkarte]] |
| Testplan | [[Phase-2-Testplan]] |
| Repo-Merge-Aufgabe | [[repo-merge-nestbau-firebase]] |
| Auth-Bot-Brief | `docs/auth-bot-token-refresh-brief-2026-09-12.md` |

**Tipps für nächsten Bot:** Vor Code-Änderung Bereich per grep lokalisieren. Nach jedem Batch `node --check`. Tests nur über UI, nie über App-Closures. Light/Dark-Screenshot-Review vor Publish. BUILD-GUIDE.md lesen, bevor man ein Problem als "neu" diagnostiziert.
