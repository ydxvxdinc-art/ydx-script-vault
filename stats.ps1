# stats.ps1 - Consulta INSTANTANEA (~500ms em 1 unico request) + Cache Permanente Local!
$ErrorActionPreference = "SilentlyContinue"
$sw = [System.Diagnostics.Stopwatch]::StartNew()

$cachePath = Join-Path $PSScriptRoot "stats_cache.json"
$keys = @(
    @{ id = "total_executions";  label = "TOTAL GERAL DE EXECUCOES (Sem Duplicar)" },
    @{ id = "loader_executions"; label = "Execucoes via Loader Universal (/loader.lua)" },
    @{ id = "sidespin-unlock";   label = "Sidespin | 8 Ball Pool & Sinuca (v2.2)" },
    @{ id = "volleyball-unlock"; label = "Volleyball Legends - Unlock All & P2P Sync" },
    @{ id = "hussvalley-unlock"; label = "Huss Valley - Knife & Emote Unlock All" },
    @{ id = "boxing-unlock";     label = "Ragdoll Boxing 3D - Unlock All" },
    @{ id = "primedash-unlock";  label = "Prime Dash - Unlock All & Instant GUI" },
    @{ id = "wolvot-3d";         label = "Wolvot 3D - Turbo Soccer Bot & Unlock All" },
    @{ id = "wolvot-2d";         label = "Wolvot 2D - Car Soccer / Sideswipe Bot" },
    @{ id = "chessduels-unlock"; label = "Chess Duels - Unlock All + VIP" },
    @{ id = "chess-ai";          label = "Chess Duels - Chess AI Bot" },
    @{ id = "subway-livesplit";  label = "Subway Surfing - LiveSplit Timer" }
)

$seenIds = @{}
$counts  = @{}
foreach ($k in $keys) { $counts[$k.id] = 0 }

if (Test-Path $cachePath) {
    try {
        $rawCache = Get-Content -Raw $cachePath | ConvertFrom-Json
        if ($rawCache.seenIds) {
            foreach ($p in $rawCache.seenIds.PSObject.Properties) { $seenIds[$p.Name] = $true }
        }
        if ($rawCache.counts) {
            foreach ($p in $rawCache.counts.PSObject.Properties) { $counts[$p.Name] = [int]$p.Value }
        }
    } catch {}
}

# 1 unico request ultra-rapido via curl.exe (~500ms) para buscar todos os novos eventos da nuvem!
$lines = curl.exe -s --max-time 3 "https://ntfy.sh/ydx_vault_telemetry_7c9e2a4b/json?poll=1&since=all"
$newEvents = 0
if ($lines) {
    foreach ($line in ($lines -split "`r?`n")) {
        if (-not $line.Trim()) { continue }
        try {
            $ev = $line | ConvertFrom-Json
            if ($ev.event -eq "message" -and $ev.id -and -not $seenIds.ContainsKey($ev.id)) {
                $seenIds[$ev.id] = $true
                $msg = [string]$ev.message
                if ($msg -match "^(loader|direct):(.+)$") {
                    $mode = $Matches[1]
                    $sid  = $Matches[2]
                    $counts["total_executions"] = [int]$counts["total_executions"] + 1
                    if ($mode -eq "loader") {
                        $counts["loader_executions"] = [int]$counts["loader_executions"] + 1
                    }
                    if ($counts.ContainsKey($sid)) {
                        $counts[$sid] = [int]$counts[$sid] + 1
                    }
                    $newEvents++
                }
            }
        } catch {}
    }
}

if ($newEvents -gt 0 -or -not (Test-Path $cachePath)) {
    @{
        seenIds = $seenIds
        counts  = $counts
    } | ConvertTo-Json -Depth 4 | Set-Content -Path $cachePath -Encoding UTF8
}

$sw.Stop()
Write-Output "======================================================================"
Write-Output ("   YDX SCRIPT VAULT // TELEMETRIA EM TEMPO REAL ({0} ms)" -f $sw.ElapsedMilliseconds)
Write-Output "======================================================================"
foreach ($item in $keys) {
    $cnt = [int]$counts[$item.id]
    Write-Output ("{0,-50} : {1,8} execucoes" -f $item.label, $cnt)
    if ($item.id -eq "loader_executions") {
        Write-Output "----------------------------------------------------------------------"
    }
}
Write-Output "======================================================================"
