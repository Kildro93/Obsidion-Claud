# 🔐 GitHub Personal Access Token (PAT) Setup

**Dieses Dokument ist LOKAL. Teile es niemals online oder öffentlich!**

---

## 📌 Wichtig: Token-Sicherheit

⚠️ **DAS TOKEN IST WIE EIN PASSWORD!**

- Befindet sich **nur im Browser** (localStorage)
- **NIEMALS** in GitHub, in Dateien oder online speichern
- **NIEMALS** teilen oder weitergeben
- Regelmäßig neu generieren (90 Tage)

---

## 🔑 Erstmaliges Setup

### Schritt 1: Token generieren

1. Gehe zu: https://github.com/settings/tokens?type=beta
2. Oben rechts: **"Generate new token (beta)"**
3. Ausfüllen:
   - **Token name**: `Claude-Automation`
   - **Expiration**: `90 days`
   - **Description**: `Automatische GitHub Repo-Verwaltung via Claude`

### Schritt 2: Permissions setzen

Folgende Permissions **checken** (✅):

```
☑ Repository
  ├── [x] Contents (read & write)
  ├── [x] Issues (read & write)
  ├── [x] Discussions (read & write)
  ├── [x] Metadata (read-only)
  └── [x] Pull Requests (read & write)

☑ User
  └── [x] read:user (profile info)
```

### Schritt 3: Token kopieren

1. **"Generate token"** klicken
2. **Sofort kopieren** (wird nur einmal angezeigt!)
3. In den Bereich unten "Dein Token" einfügen

### Schritt 4: In der App speichern

1. Öffne `github-automation.html`
2. Paste Token in: **"GitHub Personal Access Token"**
3. Gib Username ein: `Kildro93`
4. Klick: **"✅ Konfiguration speichern"**
5. Fertig! Token wird nur lokal gespeichert

---

## 🗂️ Mein Token

| Feld | Wert |
|------|------|
| **Name** | Claude-Automation |
| **Status** | ✅ Aktiv |
| **Erstellt** | — (Datum später eintragen) |
| **Expires** | — (Ablaufdatum später eintragen) |
| **Permissions** | repository + user |
| **Speicherort** | Browser localStorage (html-app) |

**Token-String**: `[Hier nach Generierung einfügen]`

---

## 🔄 Token-Rotation (Alle 90 Tage)

### Checklist:

**4 Wochen vorher** (Erinnerung: 56 Tage)
- [ ] Sich selbst erinnern, Token erneuern

**Bei Ablauf**:
- [ ] Neuen Token generieren
- [ ] Alten Token in GitHub **"Delete"** (optional)
- [ ] Neuen Token in der App eingeben
- [ ] Test: "🔄 Mit GitHub synchen" klicken

**Was passiert bei abgelaufenem Token**:
- ❌ App zeigt: `"Invalid token"` oder `"401 Unauthorized"`
- ❌ Neue Repos können nicht erstellt werden
- ✅ Bestehendes GitHub wird nicht gelöscht

---

## ⚠️ Was tun bei Token-Leak?

Falls du glaubst, das Token wurde geleakt:

1. Gehe zu https://github.com/settings/tokens
2. Finde **"Claude-Automation"** Token
3. Klick: **"Delete"**
4. Generiere **sofort neuen Token** (Schritt 1-4)
5. Updatee in der App

**Wichtig**: GitHub benachrichtigt dich automatisch bei verdächtiger Aktivität!

---

## 🛡️ Best Practices

✅ **TU DAS**:
- Token regelmäßig rotieren (90 Tage)
- Token nur in der App speichern (localStorage)
- Permissions minimal halten (nur repo + user)
- Token-Namen aussagekräftig machen
- Bei Zeichen fehlerhaft → Neuen generieren

❌ **TU DAS NICHT**:
- Token in Dateien speichern (`.env`, `.txt`, etc.)
- Token teilen oder posten
- Token über Chat/Email verschicken
- Token mit Versionskontrolle (Git) speichern
- Token in Logs anzeigen lassen

---

## 🔍 Token-Status prüfen

In GitHub:

1. Gehe zu: https://github.com/settings/tokens
2. Finde: **"Claude-Automation"**
3. Sieh dir an:
   - Letzter Zugriff (Last used)
   - Ablaufdatum (Expires)
   - Permissions (Scope)

---

## 🚨 Fehlerbehebung

### "Invalid token" oder "401 Unauthorized"
- [ ] Token korrekt kopiert? (Keine Spaces vor/nach)
- [ ] Token abgelaufen? → Neuen generieren
- [ ] Permissions richtig? → Checke Schritt 2

### "Permission denied"
- [ ] Hat Token `repository` Permission?
- [ ] Hat Token `user:read` Permission?
- [ ] Accounts korrekt verlinkt? (Token-Owner = dein GitHub Account)

### "Rate limit exceeded"
- GitHub API hat Max 5000 Requests/Stunde
- Das sollte selten vorkommen
- Lösung: 5-10 Minuten warten

---

## 📋 Checklist

- [ ] Token generiert?
- [ ] Permissions richtig gesetzt (repo + user)?
- [ ] Token in die App eingeben?
- [ ] "Konfiguration speichern" geklickt?
- [ ] Test: "🔄 Mit GitHub synchen" erfolgreich?
- [ ] Dieses Dokument lokal gespeichert?
- [ ] Token-String sicher aufbewahrt?

---

## 🔗 Nützliche Links

- Token verwalten: https://github.com/settings/tokens
- App Authorizations: https://github.com/settings/applications
- Security Log: https://github.com/settings/security-log
- Account Recovery: https://github.com/password_reset

---

*Letzte Aktualisierung: 2026-09-05*
*Nächste Token-Erneuerung: [Datum + 90 Tage eintragen]*
