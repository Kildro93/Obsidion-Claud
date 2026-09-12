---
title: chat-closure-protocol
created: 2026-09-06
updated: 2026-09-12
status: aktuell
tags: [typ/regel, status/aktuell]
autor: indra
---

# Chat-Closure-Protocol

Zweck: Kein Chat endet, ohne dass Erkenntnisse und offene Punkte gesichert sind.

---

## Teil 1: Chat meldet Fertigstellung selbst

Sobald die Aufgabe erledigt ist, meldet der Chat von sich aus:

```
FERTIG: <Aufgabe>
Status: <was gemacht wurde, ein Satz>
Nächster Schritt: <was Indra jetzt tut>
Chat kann geschlossen werden: ja | nein, weil <grund>
```

Teilfertig ist auch eine Meldung. Dann `Status: teilweise` und die offenen Punkte benennen.

---

## Teil 2: Schließ-Befehl

Diese Formulierungen lösen alle dasselbe aus: "Schließ dich", "Chat schließen", "Bye", "Danke, fertig für heute", "Fazit schreiben", jede Variante mit schließ / close / bye / done.

---

## Teil 3: Fazit-Format

Bei Schließ-Befehl erzeugt der Chat sofort diesen Block, ohne Rückfrage:

```markdown
# Fazit: <Chat-Name> – <Datum>

## Abgeschlossen
- <Aufgabe>: <Ergebnis>

## Zahlen
- Dateien erstellt: <n>
- Dateien geändert: <n>
- Commits: <hashes>

## Wichtigste Erkenntnisse
1. <Erkenntnis>: <warum relevant für später>

## Nächste Schritte
1. <Schritt> – wer, wann

## Wo liegt was
- Dateien: <pfade>
- Lokal committet: ja | nein
- GitHub gepusht: ja | nein, weil <grund>
- Vault aktualisiert: ja | nein

## Offene Probleme
- <Problem>: <Status, was blockiert>

## Für zukünftige Chats
- <was funktioniert hat>
- <welche Falle zu vermeiden ist>
```

---

## Teil 4: Speicherort

Alle Fazite zentral in `FAZITE/`:

- Allgemein: `FAZITE/allgemein/<chat-name>-fazit-<YYYY-MM-DD>.md`
- Projektbezogen: `FAZITE/<projekt>/<chat-name>-fazit-<YYYY-MM-DD>.md`

---

## Teil 5: Checkliste vor dem Schließen

Der Chat prüft selbst:

- Fazit erstellt
- Erkenntnisse dokumentiert, nicht nur Tätigkeiten aufgelistet
- Nächste Schritte konkret, mit Zuständigkeit
- Offene Probleme benannt
- Dateipfade vollständig
- Git- und Vault-Status eindeutig
- [[MEMORY/memory-index]] aktualisiert (falls nötig)

Danach: "Chat kann geschlossen werden."

---

## Teil 6: Warum

Ohne Protokoll geht beim Schließen der Kontext verloren und der nächste Chat beginnt von vorn. Mit Protokoll liest der nächste Chat das Fazit und arbeitet direkt weiter. Die Erkenntnisse sind der eigentliche Wert, nicht die Tätigkeitsliste.
