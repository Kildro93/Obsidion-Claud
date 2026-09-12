---
title: projekt-credentials
created: 2026-09-06
updated: 2026-09-12
status: aktuell
tags: [typ/setup, bereich/security, status/aktuell]
autor: indra
---

# PROJEKT-CREDENTIALS (Vault-weit)

Nur Orientierung. Echte Tokens, Keys und Passwoerter stehen NIE in dieser Datei und nie im Vault-Repo.
Ablage der echten Werte: siehe [[MEMORY/setup/setup-env-local]].

## Uebersicht

| Zugang | Wo liegt der echte Wert | Anleitung |
|---|---|---|
| GitHub PAT | Windows Credential Manager (via `git credential`) | [[MEMORY/setup/setup-github-token]] |
| Firebase Client-IDs | `Nestbau/js/nb-config.local.js` (git-ignoriert) | [[MEMORY/setup/setup-firebase]] |
| Firebase Admin/Secrets | `firebase functions:secrets:set` | [[MEMORY/setup/setup-firebase]] |
| Google/Microsoft OAuth Client-IDs | `Nestbau/js/nb-config.local.js` | [[MEMORY/setup/setup-env-local]] |
| Anthropic API Key | Firebase Functions Secret `ANTHROPIC_API_KEY` | [[MEMORY/setup/setup-env-local]] |
| Release-Keystore | `C:\Users\indra\.nestbau-keys\nestbau-release.jks` (ausserhalb Vault) | [[PROJEKT-ACCESS]] |
| Keystore-Passwoerter | `Nestbau/android/keystore.properties` (git-ignoriert) | [[PROJEKT-ACCESS]] |

## Konstanten (keine Geheimnisse)

```
GITHUB_USER       Kildro93
VAULT_REPO        https://github.com/Kildro93/Obsidion-Claud
CODE_REPO         https://github.com/Kildro93/Nestbau
FIREBASE_PROJECT  nestbau-app
FIREBASE_CONSOLE  https://console.firebase.google.com/project/nestbau-app
VAULT_PFAD        C:\KI Programme\Obsidion für Claud
KEYSTORE_ALIAS    nestbau-release
```

## Regeln

- Kein Bot und kein Chat schreibt echte Keys in eine Vault-Datei
- Im Chat-Export stehen Keys als `[REDACTED]`
- Vor jedem Push: `.gitignore` deckt `.env*`, `*.jks`, `keystore.properties`, `nb-config.local.js` ab
- Bei Leak-Verdacht: Token in GitHub sofort widerrufen, Firebase-Key in der Cloud Console einschraenken

## Verweise

- Projektspezifisch: [[PROJEKT-ACCESS]] (Nestbau)
- Audit-Stand: [[MEMORY/setup/security-audit]]
