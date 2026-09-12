# Chat-Export: Vault-Setup & Automation [2026-09-06]

## Zusammenfassung
Einrichtung eines GitHub-basierten Obsidian Vaults mit automatischer Verwaltung durch Claude. Ziel war es, GitHub als SOURCE OF TRUTH zu etablieren und Chat-basierte Vault-Pflege zu automatisieren. Erreicht: System-Prompt in Claude Settings, klare Vault-Struktur, Push-Prompt für on-demand Updates, Prozess-Dokumentation.

## Gelöste Probleme
- Wie hoste ich Obsidian auf GitHub? → Vault als Git-Repo mit .gitignore für sensitive Daten
- Wie automatisiere ich Vault-Verwaltung über Chats? → System-Prompt in Claude Custom Instructions
- Wie strukturiere ich den Vault sinnvoll? → Kategorien: Lernen, Projekte, Koch-Wissen, Routinen, Templates
- Wie pushe ich from Home? → Eigenständiger Push-Prompt für on-demand Nutzung
- Soll lokaler Vault noch Primär sein? → Nein: GitHub = Live, Lokal = Backup nur

## Ergebnisse
- System-Prompt in claude.ai Settings gespeichert
- Vault-Struktur lokal erstellt
- Dateien: MEMORY_INDEX.md, Regeln.md, Profil.md
- Ordnerstruktur: Lernen, Projekte, Koch-Wissen, Routinen, Templates
- Chat-Export-Format standardisiert
- GitHub-Repo: github.com/Kildro93/obsidian-vault  
  *(Korrektur 07.09.2026: Repo heisst inzwischen `Kildro93/Obsidion-Claud`.)*

## Erkenntnisse
- Obsidian ist Markdown + .obsidian/ Config → perfekt für Git
- System-Prompts wirken global über alle Chats
- Push-Prompt als separates Werkzeug verhindert Overhead
- .gitignore ist essentiell für sensitive Dateien
- Klare Struktur spart Orientierungszeit

## Status
Erledigt: System-Prompt-Text, Vault-Struktur, Chat-Export-Format, Phase 1 Anleitung
Offen: Phase 1 lokal durchführen, Phase 2 validieren

---
*Exportiert am 2026-09-06*
*Chat-Länge: 15 Nachrichten*
*Typ: Setup & Automation*

---
*Verschoben 07.09.2026 aus dem Restordner `📋 Routinen/` (Altstruktur vor der Reorganisation) nach `FAZITE/allgemein/`.*
