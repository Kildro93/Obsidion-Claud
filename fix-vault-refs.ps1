# fix-vault-refs.ps1 — Korrigiert alle obsidian-vault Referenzen + veraltete Eintraege
# Ausfuehren im Vault-Root: powershell -ExecutionPolicy Bypass -File fix-vault-refs.ps1

$ErrorActionPreference = "Stop"
$count = 0

function Fix($path, $old, $new) {
    $file = Get-Content -Path $path -Raw -Encoding UTF8
    if ($file.Contains($old)) {
        $file = $file.Replace($old, $new)
        Set-Content -Path $path -Value $file -Encoding UTF8 -NoNewline
        Write-Host "  FIXED: $path"
        $script:count++
    }
}

Write-Host "=== Vault-Referenzen korrigieren ==="

# 1. Vault-Struktur.md
Fix "SYSTEM\Vault-Struktur.md" `
    "Kildro93/obsidian-vault" `
    "Kildro93/Obsidion-Claud"

# 2. PROJEKT-CREDENTIALS.md
Fix "SYSTEM\SETUP\PROJEKT-CREDENTIALS.md" `
    "https://github.com/Kildro93/obsidian-vault" `
    "https://github.com/Kildro93/Obsidion-Claud"

# 3. BACKUP-STRATEGY.md
Fix "SYSTEM\SETUP\BACKUP-STRATEGY.md" `
    "https://github.com/Kildro93/obsidian-vault" `
    "https://github.com/Kildro93/Obsidion-Claud"

# 4. SETUP-GITHUB-TOKEN.md (2 Stellen)
Fix "SYSTEM\SETUP\SETUP-GITHUB-TOKEN.md" `
    "obsidian-vault``" `
    "Obsidion-Claud``"

Fix "SYSTEM\SETUP\SETUP-GITHUB-TOKEN.md" `
    "https://github.com/Kildro93/obsidian-vault" `
    "https://github.com/Kildro93/Obsidion-Claud"

# 5. CHECKLIST.md
Fix "SYSTEM\SETUP\CHECKLIST.md" `
    "- [ ] github.com" `
    "- [x] ~~github.com~~"

Fix "SYSTEM\SETUP\CHECKLIST.md" `
    "obsidian-vault``**, **Private**, ohne README/gitignore" `
    "Obsidion-Claud`` (bereits angelegt)"

# 6. PROJEKT-LEARNINGS.md
Fix "PROJEKTE\Nestbau\PROJEKT-LEARNINGS.md" `
    "Kildro93/obsidian-vault" `
    "Kildro93/Obsidion-Claud"

# 7. PROJEKT-UPDATE.md
Fix "PROJEKTE\Nestbau\PROJEKT-UPDATE.md" `
    "Kildro93/obsidian-vault" `
    "Kildro93/Obsidion-Claud"

Write-Host ""
Write-Host "=== $count Korrekturen angewendet ==="
Write-Host "Jetzt: git add -A && git commit -m 'Fix: obsidian-vault -> Obsidion-Claud' && git push origin main"
