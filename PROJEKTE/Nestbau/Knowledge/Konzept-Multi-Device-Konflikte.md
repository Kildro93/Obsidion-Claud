# Konzept: Multi-Device-Konflikte

**Stand:** 2026-09-10 · **Status:** Option A umgesetzt (Commit 97583da)

> **Umgesetzt:** Das Verzögerungsfenster (Fall 1) ist geschlossen — ein eintreffender Snapshot überschreibt keine lokal geänderten, noch nicht hochgeladenen Dokumente mehr; sie werden behalten und anschliessend hochgeladen. Ebenfalls erledigt: der Abgleich braucht keinen manuellen Start mehr. **Offen bleibt Fall 2 und 3** (beide Geräte ändern dasselbe Dokument, während eines offline ist) — dort gewinnt weiterhin der letzte Schreibvorgang, ohne Meldung.
**Anlass:** letzter offener Architektur-Punkt aus [[PROJEKT-UPDATE]]

## Wie es heute funktioniert

- Jede Sammlung hängt an einem `onSnapshot`. Kommt ein Snapshot, wird das **komplette lokale Array ersetzt** (`applyRemote`).
- Hochgeladen wird pro Dokument, ausgelöst 1,2 Sekunden nach der letzten Änderung (`schedulePush`). Erkannt wird eine Änderung über einen Hash-Vergleich gegen den letzten eigenen Stand.
- `saveDoc` schreibt bereits `updatedAt` (Servertzeit) und `updatedBy` (uid) mit; `stripMeta` entfernt beide, bevor sie in den lokalen State gelangen. **Die Metadaten sind also da, werden aber nirgends ausgewertet.**
- Gelöscht wird nur, was das Gerät vorher selbst kannte — ein Gerät kann nichts löschen, was es nie hatte.

Ergebnis: **Letzter Schreibvorgang gewinnt, lautlos.** Kein Fehler, keine Meldung, keine zweite Fassung.

## Wo das real weh tut

1. **Verzögerungsfenster (1,2 s):** Änderung auf A, in derselben Sekunde trifft ein Snapshot mit einer fremden Fassung desselben Dokuments ein → `applyRemote` überschreibt den noch nicht hochgeladenen lokalen Stand. Die Änderung ist weg, bevor sie je gesendet wurde.
2. **Offline-Rückkehr:** Beide Geräte haben dasselbe Rezept offline geändert. Wer später wieder online geht, überschreibt den anderen.
3. **Gleichzeitiges Tippen:** Zwei Leute im selben Rezept, einer verliert.

Fall 1 ist der unangenehmste, weil er ohne Offline-Phase auftritt und schon bei normaler Nutzung zu zweit passieren kann.

## Optionen

### A – Fenster schliessen und Konflikte sichtbar machen
**Aufwand: ~1–2 h.**

- Vor dem Anwenden eines Snapshots ausstehenden Push abschliessen (`pushTimer` sofort feuern), statt ihn zu überholen. Behebt Fall 1 vollständig.
- Beim Anwenden pro Dokument prüfen: weicht die eingehende Fassung von der lokalen ab **und** hat das Gerät für dieses Dokument eine nicht hochgeladene Änderung, dann nicht stillschweigend ersetzen, sondern die lokale Fassung behalten und den Konflikt melden (`cloud:conflict` auf dem Bus, Hinweis in der Karte: „Rezept X wurde auch auf einem anderen Gerät geändert").
- `updatedAt`/`updatedBy` dabei mitlesen, um „geändert von" anzeigen zu können.

Löst Fall 1, macht Fall 2 und 3 sichtbar statt lautlos. Keine Datenmodell-Änderung.

### B – Zusammenführen pro Feld
**Aufwand: ~4–6 h.**

Pro Feld einen Zeitstempel führen und beim Zusammenführen feldweise das Neuere nehmen. Zwei Leute können dann gleichzeitig am selben Rezept arbeiten, solange sie unterschiedliche Felder anfassen.

Kostet: grössere Dokumente, deutlich mehr Code, mehr Fehlerquellen bei Listen (Zutaten eines Rezepts sind ein Array — dort greift Feld-Merge nicht sauber).

### C – CRDT (z. B. Yjs)
**Aufwand: Tage.** Löst das Problem grundsätzlich und wirklich zuverlässig, bedeutet aber ein neues Datenmodell und eine Fremdbibliothek in einer App, die bewusst ohne Build-Schritt läuft. Für zwei Nutzer im selben Haushalt weit überdimensioniert.

## Empfehlung

**Option A.** Sie behebt den einzigen Fall, der ohne Offline-Phase auftritt, und verwandelt die übrigen von lautlosem Datenverlust in eine sichtbare Meldung. Das passt zum Zeitbudget und zur Nutzerzahl: zwei Personen, die selten dasselbe Rezept in derselben Minute bearbeiten.

Option B lohnt erst, wenn sich in der Praxis zeigt, dass Konflikte häufig sind — dann weiss man auch, welche Felder betroffen sind, statt es zu raten.

## Vorher belegen

Test 7 aus [[Phase-2-Testplan]] zeigt das heutige Verhalten. Erst messen, dann bauen: wenn sich der Konflikt im Alltag nie zeigt, ist selbst Option A nur der erste Punkt (Push-Fenster schliessen) wert.

## Verweise

- Status: [[PROJEKT-UPDATE]] · Testplan: [[Phase-2-Testplan]]
- Code: `js/nb-firebase.js` — `schedulePush`, `pushChanges`, `applyRemote`, `cloud.watch`
