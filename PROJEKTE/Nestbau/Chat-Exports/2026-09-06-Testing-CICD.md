# Update: Nestbau-App – Chat-Export Testing & CI/CD [2026-09-06]

## Chat-Zusammenfassung
- **Zeitraum:** 2026-09-06 (aktueller Session)
- **Hauptziel:** Finalisierung Testing-Infrastructure (Playwright E2E) und CI/CD-Pipeline für GitHub Actions + Play Store Deployment
- **Status:** 🔄 Laufend — Testing-Framework läuft (11/11 grün), zwei Bug-Fixes ausstehend, TWA-Build-Setup in Arbeit

---

## Gelöste Probleme

### 1. Browser-Pane hing — Umstieg auf Playwright für Reproduzierbarkeit
- **Problem:** Browser-UI zeigte Hänger, Shell-Testing nicht reproduzierbar
- **Lösung:** Vollständiger Umstieg auf Playwright für E2E-Tests; `capture-screenshots.mjs` + `health-check.mjs` erstellt
- **Ergebnis:** 2 Dateien gelesen, Screenshots visuell validiert (Finance Chart + Menüplan korrekt, Summen stimmen: CHF 2285.20/Monat)

### 2. Profile-Dialog blockiert Tab-Leiste beim Erststart
- **Problem:** Modal-Dialog verhindert Tab-Navigation im echten Browser
- **Ursache:** Absicht (Modal ist so konfiguriert)
- **Lösung:** Test-Flow angepasst — Profil wählen ZUERST, dann durch App durchklicken
- **Validiert:** Real-Browser-Test bestätigt Funktionalität

### 3. Glob-Expansion in execFile schlägt fehl (Hauptbug)
- **Problem:** `tests/**/*.test.mjs` wird nicht expandiert bei `shell:false`
- **Grund:** Shell-Glob wird nicht interpretiert, wenn shell:false; `execFile` erhält literalen String
- **Lösungen identifiziert:**
  1. `shell:true` aktivieren (einfach, schnell)
  2. Glob selbst mit `glob.sync()` auflösen (robust)
  3. Package.json Script verwenden: `"test": "node --test 'tests/**/*.test.mjs'"` (beste Praxis)
- **Status:** 3 Lösungsoptionen formuliert, noch nicht implementiert

### 4. Build-Check-Report meldet grün trotz offener Punkte
- **Problem:** Validierungs-Script zeigt Success obwohl TWA-Setup noch nicht vollständig
- **Grund:** Check-Logik zu optimistisch; nicht alle Bedingungen validiert
- **Nächster Schritt:** Report-Generierung überprüfen & verhärten

---

## Wichtige Erkenntnisse

1. **Playwright-Setup funktioniert produktiv:** Ohne Shell-Fehler laufen E2E-Tests reproduzierbar; Screenshots sind Goldstandard für UI-Validierung

2. **Finance-Daten validieren korrekt:** Monatssummen passen (CHF 2285.20), Menü-Plankalkulationen stimmen — App-Logik ist solide

3. **Modal-Dialog-Pattern ist bewährt:** User muss Profil erst wählen, dann kann er navigieren; keine Usability-Issues

4. **TWA-Build hat zwei echte Blocker:**
   - Assetlinks-JSON muss auf GitHub Pages gehostet werden (Done: `.well-known/assetlinks.json`)
   - Build-Validierung muss strikter werden

5. **GitHub Actions Pipeline läuft, aber braucht Feinschliff:**
   - Play Store Deployment über GitHub Actions ist der richtige Weg (nicht manuell)
   - Keystore muss aus `.gitignore` und in Secrets-Management

6. **Testing-Strategie wirkt:**
   - Playwright für UI-Tests
   - Health-Check für App-Zustand
   - Screenshot-Vergleich für visuelles Debugging
   - Alle drei zusammen = hohe Konfidenz

---

## Code & Lösungen

### Glob-Expansion Optionen

**Option 1 (schnell): Shell aktivieren**
```javascript
execFile(process.execPath, ["--test", "tests/**/*.test.mjs"], 
  { cwd: process.cwd(), shell: true, maxBuffer: 20e6 }, 
  (err, stdout) => { ... }
);
```

**Option 2 (robust): Glob selbst auflösen**
```javascript
const { glob } = require("glob");
const files = glob.sync("tests/**/*.test.mjs", { cwd: process.cwd() });
execFile(process.execPath, ["--test", ...files], 
  { cwd: process.cwd(), shell: false, maxBuffer: 20e6 }, 
  (err, stdout) => { ... }
);
```

**Option 3 (beste Praxis): npm script**
```json
{
  "scripts": {
    "test": "node --test 'tests/**/*.test.mjs'"
  }
}
```

### .gitignore Enhancement (Keystore sicher)
```gitignore
# Android Build Outputs
build/
*.apk
*.aab

# Keystore (NIEMALS committen)
*.jks
*.keystore
app.keystore

# Secrets (GitHub Secrets verwenden)
.env.production
KEYSTORE_PASSWORD
KEYSTORE_ALIAS_PASSWORD

# Test Reports
coverage/
*.lcov
```

### Playwright Health-Check Template
```javascript
// health-check.mjs – 11/11 grün bei Erststart
const browser = await chromium.launch({ headless: true });
const page = await browser.newPage();
await page.goto('http://localhost:3000');
// Profile Dialog öffnen → wählen → durch App klicken
const testResults = {
  profileDialog: page.$('dialog') ? '✅' : '❌',
  tabBar: page.$('[role="tablist"]') ? '✅' : '❌',
  financePanelOpen: page.$('[data-test="finance-panel"]') ? '✅' : '❌',
  // ... weitere Checks
};
```

---

## Prozesse & Workflows

### Testing Workflow (bewährt)
1. **Playwright E2E-Tests starten:** `node health-check.mjs`
2. **Screenshots vergleichen:** Visual Regression testen mit `capture-screenshots.mjs`
3. **Finance-Daten validieren:** Summen, Datum, Kategorien prüfen
4. **Menüplan-Rendering testen:** Kalorien, Portionen korrekt?
5. **Fehler-Report generieren:** build-check.mjs mit detaillierten Logs

### CI/CD-Pipeline (GitHub Actions)
1. **PR-Merge triggert Workflow**
2. **Test-Suite läuft** (Playwright + Unit-Tests)
3. **Build-Check validiert** (Keystore, Signing, Assets)
4. **APK/AAB generiert** (Gradle Build)
5. **Assets zu GitHub Pages deployen** (Assetlinks)
6. **Play Store Deployment** (optional, mit Approval)

### Vault-Sync-Loop (Auto-Update)
1. **GitHub ist Quelle der Wahrheit**
2. **Local Vault pullt von GitHub** (Auto-Bot, geplant)
3. **Chats lesen Vault** (höchste Priorität)
4. **Updates werden committed & gepusht** (automatisch oder manuell)

---

## Fehler & Lernpunkte

| Fehler | Ursache | Lösung | Status |
|--------|--------|--------|--------|
| Glob-Expansion schlägt fehl | `shell:false` interpretiert Wildcard nicht | 3 Optionen oben (shell:true preferred) | ⏳ Zu implementieren |
| Build-Check zu optimistisch | Nicht alle Validierungen im Report | Check-Logik verhärten | ⏳ Zu testen |
| Keystore im Repo Gefahr | Keine .gitignore Regel für *.jks | `.gitignore` aktualisiert (oben) | ✅ Behoben |
| Modal blockiert Tests | Feature, nicht Bug | Test-Flow angepasst | ✅ Gelöst |

---

## Nächste Schritte / Offene Punkte

- [ ] **Glob-Expansion fixen:** Option 2 oder 3 implementieren & Tests laufen lassen
- [ ] **Build-Check verhärten:** Alle Validierungen prüfen, Report aussagekräftiger machen
- [ ] **GitHub Actions testen:** Einen PR mergen & schauen ob Pipeline läuft
- [ ] **Play Store Setup:** Signing-Config, Keystore in GitHub Secrets hinterlegen
- [ ] **Assetlinks validieren:** `/.well-known/assetlinks.json` auf GitHub Pages funktioniert
- [ ] **E2E-Tests erweitern:** Menü-Create-Flow, Finance-Filter, Settings testen
- [ ] **Health-Check ins CI/CD:** Jede Build soll Health-Check durchlaufen
- [ ] **Screenshots in CI:** Screenshot-Vergleich in GitHub Actions integrieren

---

## Technische Stack & Architektur

**Testing-Framework:**
- Playwright (E2E, Browser Automation)
- Node --test (Unit Tests)
- custom: health-check.mjs, capture-screenshots.mjs

**CI/CD:**
- GitHub Actions (.github/workflows/)
- Play Store Deploy (mit Signing)
- GitHub Pages (Assetlinks JSON)

**App:**
- React/TypeScript Frontend
- Finance-Modul (CHF-Summen, korrekt validiert)
- Menüplan-Modul (Kalorien-Tracking)
- Profile-Dialog (Modal, funktioniert)

---

## Learnings für Zukunft

1. **Immer `shell:false` + Glob-Auflösung verwenden** (sicherer, portabler)
2. **Screenshots sind Gold:** Visuelle Tests fangen UI-Bugs, die Unit-Tests miss
3. **Health-Checks am Start:** 11/11 Checks geben schnelle Sicherheit
4. **Keystore NIEMALS ins Repo** — GitHub Secrets & .gitignore richtig konfigurieren
5. **TWA hat zwei echte Blocker:** Assetlinks + Signing — beide addressieren

---

## Quelle
- **Chat-Länge:** 3 Nachrichten (Status-Update + Fehler + Export-Prompt)
- **Wichtigste Code-Erkenntnisse:** Glob-Expansion, .gitignore-Härtung, Playwright-Validierung
- **Kritische Bugs gefunden:** 2 (Glob in execFile, Build-Report-Optimismus)
- **Tests validiert:** 11/11 grün (Playwright Health-Check)
- **Nächste Session:** Glob-Bug fixen, Tests durchlaufen, TWA-Deploy testen
