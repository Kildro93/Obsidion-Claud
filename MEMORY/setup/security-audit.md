---
title: security-audit
created: 2026-09-06
updated: 2026-09-12
status: aktuell
tags: [typ/setup, bereich/security, status/aktuell]
autor: indra
---

# Security-Audit Vault

**Stand:** 2026-09-06
**Umfang:** kompletter Vault ausser `node_modules/`, `.git/`, `build/`, `dist/`
**Gesucht:** GitHub-PATs (`ghp_`/`github_pat_`), Google-API-Keys (`AIza…`), Anthropic-Keys (`sk-ant-`), private Schluessel (PEM), Klartext-Passwoerter, OAuth-Client-Secrets

## Ergebnis

| Fund | Datei | Bewertung | Status |
|---|---|---|---|
| Keystore-Passwoerter im Klartext | `Nestbau/android/keystore.properties` | untracked und per `.gitignore` ausgeschlossen, war nie in einem Commit | OK, kein Handlungsbedarf im Repo |
| Firebase Web-API-Key | `nestbau-firebase/test-firebase.js` (committet) | Web-API-Keys sind bauartbedingt oeffentlich, sie identifizieren nur das Projekt | offen: API-Key in der Cloud Console auf eigene Domains einschraenken |
| OAuth-Client-Secrets | `nestbau-firebase/functions/src/tokens.js` | nur `defineSecret()`-Referenzen, keine Werte | OK |
| GitHub-PAT | — | kein Fund im Vault | OK |
| Anthropic-Key | — | kein Fund im Vault | OK |
| Private Keys (PEM) | — | kein Fund | OK |

## Massnahmen aus diesem Audit

- [x] Vault-Root-`.gitignore` erweitert: `Nestbau/`, `nestbau-firebase/`, `Claude outputs/nestbau-v2-*`, `backups/`
- [x] Setup-Doku angelegt, echte Werte konsequent ausserhalb des Vaults
- [ ] Firebase-API-Key in der Google Cloud Console auf erlaubte Domains beschraenken (Mensch, 5 Min) — siehe [[MEMORY/setup/setup-firebase]], Abschnitt 4
- [ ] Keystore-Backup ausser Haus ablegen — siehe [[MEMORY/setup/backup-strategy]], Ebene 3

## Audit wiederholen

Vor jedem groesseren Push, in Git Bash im Vault-Ordner:

```bash
grep -rInE "(gh[pousr]_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|sk-ant-[A-Za-z0-9_-]{20,}|-----BEGIN [A-Z ]*PRIVATE KEY|storePassword\s*=|keyPassword\s*=)" . \
  --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=build --exclude-dir=dist
```

Treffer sind nur dann kritisch, wenn die Datei von Git verfolgt wird:

```bash
git ls-files --error-unmatch <pfad>
```

## Wenn doch etwas geleakt ist

1. Token/Key sofort widerrufen (GitHub Settings bzw. Cloud Console) — das ist der eigentliche Fix
2. Datei aus dem Index nehmen: `git rm --cached <pfad>`, Pfad in `.gitignore`
3. History-Bereinigung (`git filter-repo`) nur, wenn das Repo oeffentlich ist. Ein widerrufener Key in der History ist harmlos
