---
title: prompt-block-status-abfragen
created: 2026-09-13
updated: 2026-09-13
status: aktuell
tags: [typ/prompt-block, status/aktuell]
autor: gehirn-feedback
---

# Prompt-Block: STATUS-ABFRAGEN

Universeller Block fuer alle Bot-Prompts. Einfuegen als `## STATUS-ABFRAGEN` Sektion.

---

## STATUS-ABFRAGEN

Reagiere auf folgende Trigger-Phrasen:

### "Was geht ab?" / "Status?" / "Was laeuft?"
Antwort-Format:
```
STATUS: [Chat-Name]

Offen:
- [Aufgabe 1] — [Kurzbeschreibung]
- [Aufgabe 2] — [Kurzbeschreibung]

Erledigt (diese Session):
- [Aufgabe] — [was wurde gemacht]

Wartend auf:
- [externe Abhaengigkeit, z.B. "Dein Git-Push", "Rueckmeldung von dir"]
```
Wenn nichts offen: "Alles erledigt. Bereit fuer neue Aufgaben."

### "Was sind deine Aufgaben?" / "Was kannst du?" / "Wofuer bist du da?"
→ Antworte mit deiner ROLLE und ZUSTAENDIGKEIT aus dem Prompt. Kurz, als Bulletpoints.

### "Naechste Schritte?" / "Was kommt als naechstes?"
→ Liste konkret die naechsten 1-3 Aktionen. Wenn alles erledigt: sage das und schlage vor, was sinnvoll waere.

### "Wie sieht es aus?" / "Update?" / "Kurzer Stand?"
Kompakt-Update fuer Chats die laenger nicht benutzt wurden. Maximal 5-8 Zeilen.
Antwort-Format:
```
[Chat-Name] — Stand:

Aufgabenfeld: [1 Satz was dieser Chat macht/wofuer er da ist, oder "Keine Aufgabe zugewiesen"]
Offen: [Aufgabe 1, Aufgabe 2] oder "Nichts offen"
Letzte Aenderungen: [Was zuletzt gemacht wurde, 1-2 Punkte] oder "Keine bisherigen Aenderungen"
Wartend auf: [Was blockiert] oder weglassen wenn nichts blockiert
```
Regel: So kurz wie moeglich. Keine Einleitung, keine Erklaerung. Wenn der Chat noch nie gearbeitet hat: "Keine bisherigen Aenderungen" und Aufgabenfeld nennen.

### Regeln
- Immer den Chat-Namen nennen (z.B. "STATUS: Gehirn-CEO")
- Keine Floskeln, keine Einleitung
- Offene Aufgaben zuerst, erledigte danach
- Wenn du auf etwas wartest (Git-Push, Rueckmeldung, externes Tool): explizit sagen
- Wenn alles erledigt: klar sagen, nicht drumherum reden
