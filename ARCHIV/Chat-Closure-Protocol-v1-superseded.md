# Chat-Closure-Protocol (v1, ersetzt durch [[Chat-Closure-Protocol]] am 12.09.2026)

> Automatisches Fazit-System für alle Claude-Chats.
> Stellt sicher, dass Erkenntnisse nie verloren gehen und neue Chats nahtlos weitermachen können.

---

## Wann wird das Protokoll ausgelöst?

Bei jedem Schließ-Befehl:
- "Schließ dich"
- "Bye"
- "Chat schließen"
- "Fertig, schließen"
- Sinngemäße Varianten

## Fazit-Struktur

Jedes Fazit folgt diesem Template:

```markdown
# Fazit: [Chat-Name] – [Datum]

## Abgeschlossene Aufgaben
- [Was wurde erledigt, kurz & konkret]

## Status
- [Aktueller Stand des Projekts/der Aufgabe]
- [Was läuft, was wartet]

## Wichtigste Erkenntnisse
- [Top-Learnings aus diesem Chat]
- [Patterns, die sich bewährt haben]
- [Fehler, die aufgetreten sind + Lösung]

## Nächste Schritte
- [Was als Nächstes getan werden muss]
- [Priorisierung, falls mehrere Punkte]

## Dateipfade
- [Alle erstellten/geänderten Dateien mit vollständigem Pfad]

## Offene Probleme
- [Ungelöste Issues, Blocker, bekannte Bugs]

## Tipps für zukünftige Chats
- [Kontext, den der nächste Chat wissen muss]
- [Fallstricke, die vermieden werden sollten]
- [Empfohlene Vorgehensweise]
```

## Speicherort

| Kontext | Pfad |
|---------|------|
| Allgemein | `SYSTEM/Chat-Exports/[Name]-Fazit-[Datum].md` |
| Projektspezifisch | `PROJEKTE/[Projekt]/Chat-Exports/[Name]-Fazit-[Datum].md` |

## Regeln

- Fazit wird **automatisch** erstellt – User muss nicht danach fragen
- Maximal **200 Worte** pro Fazit (knapp & scanbar)
- Keine Wiederholung von Dingen, die schon in anderen Vault-Dateien stehen
- Dateipfade immer **vollständig** angeben
- Bei projektspezifischen Chats: Fazit im **Projektordner** speichern
- Erkenntnisse, die allgemein nützlich sind: zusätzlich in `PROJEKT-LEARNINGS.md` konsolidieren
- Keine Tokens, Keys oder Passwörter im Fazit – stattdessen `[REDACTED]`

## Beispiel-Fazit

```markdown
# Fazit: Firebase-Setup-Bot – 2026-09-06

## Abgeschlossene Aufgaben
- Firebase-Projekt "nestbau-app" konfiguriert
- Security Rules für Firestore geschrieben
- Test-Script erstellt und validiert

## Status
- Firebase läuft, Auth + Firestore aktiv
- Hosting noch nicht eingerichtet

## Wichtigste Erkenntnisse
- Firebase Web-API-Key ist public by design, aber Domain-Restriction nötig
- Firestore Rules: deny all als Default, dann explizit freigeben
- Test mit test-firebase.js vor Deployment spart Debugging-Zeit

## Nächste Schritte
- Firebase Hosting aktivieren
- Domain-Restriction in Cloud Console setzen
- Auth-Flow in App integrieren

## Dateipfade
- PROJEKTE/Nestbau/Knowledge/firebase-rules.md
- nestbau-firebase/test-firebase.js
- SYSTEM/SETUP/SETUP-FIREBASE.md

## Offene Probleme
- API-Key noch nicht auf Domains beschränkt

## Tipps für zukünftige Chats
- Immer PROJEKT-LEARNINGS.md lesen vor Firebase-Arbeit
- test-firebase.js als Smoke-Test nach jeder Änderung nutzen
```

## Integration in Custom Instructions

Damit alle Chats dieses Protokoll automatisch befolgen, folgenden Text in Claude Settings → Profile → Custom Instructions einfügen (siehe Schritt 2 des AUTOMATION-Bots).
