# Sync-Vault.ps1
# Copia automaticamente todos os scripts atualizados do scratch para a pasta do site (script_vault/scripts)
# No Wolvot (3D e 2D), remove fisicamente toda a logica de Skin Changer + Unlock All e deixa o botao em estado "FIXING" (impossivel de bypassar)!

$ErrorActionPreference = "Stop"
$scratchDir = "c:\Users\ydxvxd\.gemini\antigravity\scratch"
$vaultDir   = Join-Path $scratchDir "script_vault"
$scriptsDir = Join-Path $vaultDir "scripts"
$utf8NoBom  = New-Object System.Text.UTF8Encoding($false)

if (-not (Test-Path $scriptsDir)) {
    New-Item -ItemType Directory -Path $scriptsDir -Force | Out-Null
}

# Defina $stripWolvotSkins = $false quando o usuario mandar liberar o Skin Changer + Unlock All do Wolvot!
$stripWolvotSkins = $false

function Strip-LinesBetween([string]$text, [string]$startMarker, [string]$endMarker, [string]$replacement) {
    $lines = $text -split "`r?`n"
    $startIdx = -1
    $endIdx = -1
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($startIdx -lt 0 -and $lines[$i].Contains($startMarker)) {
            $startIdx = $i
        } elseif ($startIdx -ge 0 -and $lines[$i].Contains($endMarker)) {
            $endIdx = $i
            break
        }
    }
    if ($startIdx -lt 0 -or $endIdx -lt 0) {
        throw "Markers not found: [$startMarker] .. [$endMarker]"
    }
    $out = New-Object System.Collections.Generic.List[string]
    for ($i = 0; $i -lt $startIdx; $i++) { $out.Add($lines[$i]) }
    foreach ($rLine in ($replacement -split "`r?`n")) { $out.Add($rLine) }
    for ($i = $endIdx; $i -lt $lines.Count; $i++) { $out.Add($lines[$i]) }
    return ($out -join "`n")
}

$filesToSync = @(
    "subway_livesplit.lua",
    "chessduels_unlock_all.lua",
    "chess.lua",
    "wolvot_free.lua",
    "wolvot_2d.lua",
    "primedash_unlock_all.lua",
    "boxing_unlock_all.lua",
    "hussvalley_unlock_all.lua",
    "volleyball_unlock_all.lua",
    "sidespin_unlock_all.lua"
)

foreach ($file in $filesToSync) {
    $srcPath = Join-Path $scratchDir $file
    $dstPath = Join-Path $scriptsDir $file
    if (-not (Test-Path $srcPath)) {
        Write-Host "[Sync] Aviso: $file nao encontrado em $scratchDir" -ForegroundColor Yellow
        continue
    }

    if ($stripWolvotSkins -and $file -eq "wolvot_free.lua") {
        $txt = [System.IO.File]::ReadAllText($srcPath, $utf8NoBom)
        $txt = $txt.Replace('version.Text = "v1.2.0  |  C preset  |  RCtrl"', 'version.Text = "v1.2.0  |  RCtrl"')
        $txt = $txt.Replace('skinBtn.BackgroundColor3 = Color3.fromRGB(48, 42, 74)', 'skinBtn.BackgroundColor3 = Color3.fromRGB(36, 32, 28)')
        $txt = $txt.Replace('skinBtn.Text = "SKIN: GARAGE UNLOCKED >"', 'skinBtn.Text = "SKIN & UNLOCK ALL: FIXING"')
        $txt = $txt.Replace('skinBtn.TextColor3 = Color3.fromRGB(255, 215, 95)', 'skinBtn.TextColor3 = Color3.fromRGB(165, 145, 115)')
        $txt = $txt.Replace('skinBtn.Font = Enum.Font.GothamBold', "skinBtn.AutoButtonColor = false`nskinBtn.Active = false`nskinBtn.Font = Enum.Font.GothamBold")
        $txt = $txt.Replace('hoverable(skinBtn, skinScale)', '-- skinBtn disabled (FIXING)')

        # 1. Remove todo o painel SkinChangerPanel (linhas 245..332)
        $txt = Strip-LinesBetween $txt "-- Instant Visual Skin Changer & Native Garage Unlocker (Turbo Soccer)" "-- Pulsing indicator dot while the bot is on." "-- Skin Changer UI & Unlock All stripped (FIXING)`n"

        # 2. Remove os ~2415 linhas de logica do Skin Changer & Garage Unlocker (linhas 545..2960)
        $txt = Strip-LinesBetween $txt "-- Skin Changer & Native Garage Unlocker Logic" "connect(UIS.InputBegan, function(input, gpe)" "-- Skin Changer & Unlock All logic stripped (FIXING)`nlocal cyclePresetByKey = nil`n`n"

        [System.IO.File]::WriteAllText($dstPath, $txt, $utf8NoBom)
        Write-Host "[Sync] Publicado Wolvot 3D (Bot ATIVO | Skin Changer + Unlock All REMOVIDO / FIXING): $file" -ForegroundColor Cyan
        continue
    }

    Copy-Item -Path $srcPath -Destination $dstPath -Force
    Write-Host "[Sync] Copiado completo: $file" -ForegroundColor Green
}
