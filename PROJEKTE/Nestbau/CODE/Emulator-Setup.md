# Nestbau – Android-Emulator neu aufbauen

Der AVD `NestbauTest` (4,5 GB) wurde am 2026-09-06 gelöscht, um Platz zu sparen. Diese Datei baut ihn 1:1 wieder auf. Gebraucht für: Firebase Phase 2 (Two-Device-Sync, Offline-Tests), APK-Smoke-Test.

## Original-Spezifikation (aus `config.ini` / `hardware-qemu.ini`)

| Feld | Wert |
|------|------|
| AVD-Name / ID | `NestbauTest` (Anzeigename „Nestbau Test") |
| System-Image | `system-images;android-36;google_apis_playstore;x86_64` |
| Tag | `google_apis_playstore` (Google Play Store aktiv) |
| ABI | x86_64 |
| API-Level | 36 |
| CPU-Kerne | 4 |
| RAM | 2048 MB |
| Data-Partition | 6 GB (6442450944 Bytes) |
| Auflösung | 1080 × 1920 |
| Dichte | 420 dpi |
| GPU | an, `swiftshader_indirect` |
| Tastatur | Hardware-Tastatur an |
| Boot | Cold Boot erzwungen (`fastboot.forceColdBoot = yes`) |
| SD-Karte | ja · Cache-Partition 66 MB |

Die Auflösung 1080×1920 entspricht dem Play-Store-Screenshot-Format (`tools/screenshots.js`).

## Neu erstellen – Kommandozeile

Voraussetzungen (auf dem Rechner bestätigt vorhanden): Android SDK unter `C:\Users\indra\AppData\Local\Android\Sdk`, `cmdline-tools`.

```bash
# 1. System-Image laden (falls noch nicht da)
sdkmanager "system-images;android-36;google_apis_playstore;x86_64"

# 2. AVD anlegen
avdmanager create avd ^
  --name NestbauTest ^
  --package "system-images;android-36;google_apis_playstore;x86_64" ^
  --abi x86_64 ^
  --device "pixel_5"

# 3. config.ini nachziehen: %USERPROFILE%\.android\avd\NestbauTest.avd\config.ini
#    folgende Zeilen setzen/anpassen:
```

```ini
avd.ini.displayname = Nestbau Test
hw.cpu.ncore = 4
hw.ramSize = 2048
hw.lcd.width = 1080
hw.lcd.height = 1920
hw.lcd.density = 420
hw.keyboard = yes
hw.gpu.enabled = yes
hw.gpu.mode = swiftshader_indirect
disk.dataPartition.size = 6442450944
PlayStore.enabled = true
fastboot.forceColdBoot = yes
```

```bash
# 4. Starten
emulator -avd NestbauTest
```

## Neu erstellen – Android Studio

Device Manager → Create Device → **Phone**, Custom: 1080×1920, 420 dpi → System Image **API 36, Google Play, x86_64** → Name `NestbauTest` → Advanced: RAM 2048, 4 Cores, Internal Storage 6 GB, Boot: Cold.

## App auf den Emulator

```bash
cd "C:/KI Programme/Obsidion für Claud/Nestbau"
npm install
npm run sync
node tools/android-build.js debug
adb install -r dist/nestbau-2.0.0-debug.apk
# oder direkt: cd android && gradlew.bat installDebug
```

Firebase-Emulator (für Phase-2-Tests) parallel: `firebase emulators:start` – die App erkennt `localhost` und schaltet automatisch um (siehe `Nestbau/DEV-QUICKSTART.md`).

## Verweise

- [[CODE-Landkarte]] · [[Tech-Stack]] (JDK/SDK-Versionen) · [[nestbau-testing]] (Phase-2-Testplan)
