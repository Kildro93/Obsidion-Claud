# Chat-Closure-Protocol

Speicherort im Vault: `SYSTEM/Chat-Closure-Protocol.md`
Zweck: Kein Chat endet, ohne dass Erkenntnisse und offene Punkte gesichert sind.

---

## Teil 1: Chat meldet Fertigstellung selbst

Sobald die Aufgabe erledigt ist, meldet der Chat von sich aus – ohne dass gefragt wird, und ohne die Meldung in Fließtext zu verstecken:

```
FERTIG: <Aufgabe>
Status: <was gemacht wurde, ein Satz>
Nächster Schritt: <was Indra jetzt tut>
Chat kann geschlossen werden: ja | nein, weil <grund>
```

Falsch: "Bin ich fertig? Soll ich noch was machen?" – der Chat entscheidet das selbst.
Falsch: die Fertigmeldung im vierten Absatz vergraben.

Teilfertig ist auch eine Meldung. Dann `Status: teilweise` und die offenen Punkte benennen.

---

## Teil 2: Schließ-Befehl

Diese Formulierungen lösen alle dasselbe aus:

- "Schließ dich"
- "Chat schließen"
- "Bye"
- "Danke, fertig für heute"
- "Fazit schreiben"
- jede Variante mit schließ / close / bye / done

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
- Tests bestanden: <n/n>

## Wichtigste Erkenntnisse
1. <Erkenntnis>: <warum relevant für später>
2. <Erkenntnis>: <warum relevant für später>

## Nächste Schritte
1. <Schritt> – wer, wann
2. <Schritt> – wer, wann

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
- <Lessons Learned>
```

---

## Teil 4: Speicherort

Allgemeine Chats:

```
SYSTEM/Chat-Exports/<Chat-Name>-Fazit-<YYYY-MM-DD>.md
```

Projektbezogene Chats zusätzlich:

```
PROJEKTE/<Projekt>/Chat-Exports/<Chat-Name>-Fazit-<YYYY-MM-DD>.md
```

Hat der Chat Vault-Zugriff: direkt schreiben, committen, pushen.
Hat er keinen: den Block als Copy-Paste ausgeben und den Zielpfad nennen.

---

## Teil 5: Checkliste vor dem Schließen

Der Chat prüft selbst:

- Fazit erstellt
- Erkenntnisse dokumentiert, nicht nur Tätigkeiten aufgelistet
- Nächste Schritte konkret, mit Zuständigkeit
- Offene Probleme benannt statt weggelassen
- Dateipfade vollständig
- Git- und Vault-Status eindeutig
- MASTER-INDEX.md aktualisiert

Danach: "Chat kann geschlossen werden."

---

## Teil 6: Warum

Ohne Protokoll geht beim Schließen der Kontext verloren und der nächste Chat beginnt von vorn.
Mit Protokoll liest der nächste Chat das Fazit und arbeitet direkt weiter.

Die Erkenntnisse sind der eigentliche Wert, nicht die Tätigkeitsliste. Ein Fazit, das nur aufzählt was gemacht wurde, ist wertlos. Es muss festhalten, was beim nächsten Mal Zeit spart.
