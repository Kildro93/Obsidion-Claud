# Backup-Strategie

Drei Ebenen, absteigend nach Aufwand.

## Ebene 1: GitHub (laufend)

Auto-Sync alle 30 Minuten, siehe [[AUTO-SYNC]]. Deckt alles ab, was im Vault-Repo liegt. Deckt NICHT ab: die per `.gitignore` ausgeschlossenen Dateien — Keystore, `nb-config.local.js`, Backups, `Nestbau/`, `nestbau-firebase/` (die haben eigene Repos).

## Ebene 2: Woechentliches ZIP (lokal)

```powershell
cd "C:\KI Programme\Obsidion für Claud\scripts"
powershell -ExecutionPolicy Bypass -File .\install-backup-task.ps1
```

- Laeuft sonntags 02:00, holt nach wenn der PC aus war
- Ziel: `backups/vault-backup-JJJJ-MM-TT.zip` (git-ignoriert)
- Haelt die letzten 8 ZIPs, loescht aeltere automatisch
- Ausgeschlossen: `node_modules`, `.git`, `build`, `dist`, `.gradle`, `backups`

Sofort testen:

```powershell
powershell -ExecutionPolicy Bypass -File .\weekly-backup.ps1
```

## Ebene 3: Ausser Haus (manuell, monatlich)

Was ein Repo-Verlust oder ein defekter PC nicht ueberlebt:

| Datei | Warum kritisch | Ablage |
|---|---|---|
| `nestbau-release.jks` | Verlust = Play-Store-App nie wieder aktualisierbar | Passwortmanager oder verschluesselter Cloud-Ordner |
| `keystore.properties` | Passwoerter zum Keystore | gleicher Ort, getrennt vom Keystore |
| Neuestes `vault-backup-*.zip` | vollstaendiger Wissensstand | Cloud-Ordner oder externe SSD |

Kalendereintrag monatlich, 5 Minuten. Das ist die einzige Ebene, die kein Script uebernimmt.

## Wiederherstellung

Vault komplett verloren:

```powershell
cd "C:\KI Programme"
git clone https://github.com/Kildro93/obsidian-vault "Obsidion für Claud"
cd "Obsidion für Claud"
git clone https://github.com/Kildro93/Nestbau Nestbau
```

Danach `nb-config.local.js` und `keystore.properties` aus Ebene 3 zurueckkopieren.
