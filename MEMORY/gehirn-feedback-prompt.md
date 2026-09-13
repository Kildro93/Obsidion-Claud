---
titel: Gehirn-Feedback Bericht – Prompt für Selbst-Analyse
created: 2026-09-13
typ: gehirn-feedback-prompt
zielgruppe: Gehirn-Feedback Chat (läuft autonom)
---

# Gehirn-Feedback Bericht: Deine bisherigen Sessions analysieren

**Aufgabe:** Schreibe einen Bericht über alles, was du in deinen Sessionen gemacht hast — damit der Gehirn-CEO auf dem Laufenden ist.

---

## ANLEITUNG

### Schritt 1: Alle Chat-Exports auflisten
- Ordner: `FAZITE/allgemein/` (falls Querschnitts-Themen)
- Ordner: `FAZITE/feedback/` (falls dieser Ordner existiert)
- Dateien mit "feedback" im Namen durchsuchen

### Schritt 2: Pro Session zusammenfassen
Für jede Session:
- **Datum & Titel:** Was war das Thema?
- **Was gemacht:** Konkrete Outputs (Analysen, Verbesserungen, Erkenntnisse)
- **Fehler gefunden:** Wo hatte Gehirn-CEO/andere Chats Probleme?
- **Fixes bereitgestellt:** Welche Lösungen hast du erarbeitet?
- **Offene Punkte:** Was braucht Follow-up?

### Schritt 3: Gehirn-CEO Learnings extrahieren
**Besonders wichtig:** Was sollte Gehirn-CEO über sein eigenes Verhalten/die Infrastruktur wissen?

Beispiele:
- "Gehirn-CEO spekuliert über technische Ursachen statt ehrlich zu sagen ‚geht nicht'"
- "Gehirn-CEO verifiziert Vault-Stand nicht, bevor Aussagen trifft"
- "Gehirn-CEO sagt zu schnell ‚BLOCKIERT' ohne Alternativ-Weg"

### Schritt 4: Strukturierten Report schreiben

**Format:**
```
# Gehirn-Feedback Bericht [Zeitraum]

## Überblick
- Anzahl Sessions
- Hauptthemen
- Wichtigste Erkenntnisse (Top 3)

## Pro Session
### Session 1: [Titel] – [Datum]
- Aufgabe: [kurz]
- Output: [Dateien/Links]
- Fehler gefunden: [was war falsch]
- Fix: [wie gelöst]
- Offen: [was bleibt]

## Gehirn-CEO Verbesserungen (Priorität!)
- [Fehler 1]: [Beobachtung] → [Empfehlung]
- [Fehler 2]: [Beobachtung] → [Empfehlung]
- [Fehler 3]: [Beobachtung] → [Empfehlung]

## Allgemeine Infrastruktur-Erkenntnisse
- [Pattern/Learnings]

## Nächste Schritte für Gehirn-CEO
- [Was sollte anders laufen]
- [Worauf achten]
```

### Schritt 5: Speichern & Mitteilen
- Datei: `FAZITE/allgemein/gehirn-feedback-bericht-[Zeitraum].md`
- Format: Markdown, UTF-8 ohne BOM
- Git: Commit + Push (oder Block für Nutzer)

---

## WICHTIG

**Ton:** Analytisch, nicht kritisch. Du unterstützt den Gehirn-CEO, keine Schuldzuweisung.

**Kürze:** Max. 300 Worte, prägnante Bulletpoints.

**Fokus:** Nicht jede Kleinigkeit, sondern Patterns & systematische Fehler.

---

## BEISPIEL-AUSZUG

```
## Gehirn-CEO Verbesserungen (Priorität!)

### 1. Spekulation über technische Ursachen
- **Beobachtung:** Gehirn-CEO sagte "Windows-Update 9/8 blockiert device_bash" — das war erfunden
- **Realität:** Cowork-Chats haben einfach keinen Git-Zugriff (by design)
- **Empfehlung:** Kurz & ehrlich: "[X] geht nicht. Workaround: [Y]." — keine Ursachen-Märchen

### 2. Vault-Stand nicht verifiziert
- **Beobachtung:** Gehirn-CEO sagte "REST/ Dateien sind Stubs", ohne sie zu lesen
- **Realität:** Sie sind legitime Templates mit Format-Vorschlägen
- **Empfehlung:** device_list_dir IMMER vor Aussagen über den Vault-Stand nutzen
```

---

**Fertig?** Datei speichern, dann Gehirn-CEO mitteilen, dass der Bericht bereit ist.
