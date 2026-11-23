# stats.ps1 - Consulta em tempo real quantas vezes o Loader e cada Script do YDX Script Vault foram executados!
$ErrorActionPreference = "SilentlyContinue"

$keys = @(
    @{ id = "total_executions";  backup = "ydx_vault_total";             label = "TOTAL GERAL DE EXECUCOES (Sem Duplicar)" },
    @{ id = "loader_executions"; backup = "ydx_vault_loader";            label = "Execucoes via Loader Universal (/loader.lua)" },
    @{ id = "sidespin-unlock";   backup = "ydx_vault_sidespin-unlock";   label = "Sidespin | 8 Ball Pool & Sinuca (v2.2)" },
    @{ id = "volleyball-unlock"; backup = "ydx_vault_volleyball-unlock"; label = "Volleyball Legends - Unlock All & P2P Sync" },
    @{ id = "hussvalley-unlock"; backup = "ydx_vault_hussvalley-unlock"; label = "Huss Valley - Knife & Emote Unlock All" },
    @{ id = "boxing-unlock";     backup = "ydx_vault_boxing-unlock";     label = "Ragdoll Boxing 3D - Unlock All" },
    @{ id = "primedash-unlock";  backup = "ydx_vault_primedash-unlock";  label = "Prime Dash - Unlock All & Instant GUI" },
    @{ id = "wolvot-3d";         backup = "ydx_vault_wolvot-3d";         label = "Wolvot 3D - Turbo Soccer Bot & Unlock All" },
    @{ id = "wolvot-2d";         backup = "ydx_vault_wolvot-2d";         label = "Wolvot 2D - Car Soccer / Sideswipe Bot" },
    @{ id = "chessduels-unlock"; backup = "ydx_vault_chessduels-unlock"; label = "Chess Duels - Unlock All + VIP" },
    @{ id = "chess-ai";          backup = "ydx_vault_chess-ai";          label = "Chess Duels - Chess AI Bot" },
    @{ id = "subway-livesplit";  backup = "ydx_vault_subway-livesplit";  label = "Subway Surfing - LiveSplit Timer" }
)

function Get-Count([string]$abacusKey, [string]$backupKey) {
    $val1 = 0
    $val2 = 0
    try {
        $r1 = Invoke-RestMethod -Uri "https://abacus.jasoncameron.dev/get/ydx_script_vault/$abacusKey" -Method Get -TimeoutSec 4
        if ($null -ne $r1 -and $null -ne $r1.value) { $val1 = [int]$r1.value }
    } catch {}
    try {
        $r2 = Invoke-RestMethod -Uri "https://countapi.mileshilliard.com/api/v1/get/$backupKey" -Method Get -TimeoutSec 4
        if ($null -ne $r2 -and $null -ne $r2.value) { $val2 = [int]$r2.value }
    } catch {}
    return [Math]::Max($val1, $val2)
}

Write-Output "======================================================================"
Write-Output "   YDX SCRIPT VAULT // TELEMETRIA DE EXECUCOES EM TEMPO REAL"
Write-Output "======================================================================"
foreach ($item in $keys) {
    $cnt = Get-Count $item.id $item.backup
    Write-Output ("{0,-50} : {1,8} execucoes" -f $item.label, $cnt)
    if ($item.id -eq "loader_executions") {
        Write-Output "----------------------------------------------------------------------"
    }
}
Write-Output "======================================================================"
