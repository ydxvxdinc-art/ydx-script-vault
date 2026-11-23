-- YDX Script Vault - Universal Loader (100% ASCII)
-- Detects current game PlaceId (including all match/tournament/sub-places) and Universe GameId automatically!
-- Also hooks queue_on_teleport so when a game teleports you from Lobby to a Match sub-place, the script reloads automatically!
-- Usage:
--   getgenv().YDX_SCRIPT = "volleyball-unlock" -- optional: force a specific script id
--   loadstring(game:HttpGet("https://ydxvxdinc-art.github.io/ydx-script-vault/loader.lua"))()

local BASE_URL = (getgenv and getgenv().YDX_BASE_URL) or "https://ydxvxdinc-art.github.io/ydx-script-vault"
if BASE_URL:sub(-1) == "/" then
    BASE_URL = BASE_URL:sub(1, -2)
end

local SCRIPTS_BY_ID = {
    ["subway-livesplit"]  = "scripts/subway_livesplit.lua",
    ["chessduels-unlock"] = "scripts/chessduels_unlock_all.lua",
    ["chess-ai"]          = "scripts/chess.lua",
    ["wolvot-3d"]         = "scripts/wolvot_free.lua",
    ["wolvot-2d"]         = "scripts/wolvot_2d.lua",
    ["primedash-unlock"]  = "scripts/primedash_unlock_all.lua",
    ["boxing-unlock"]     = "scripts/boxing_unlock_all.lua",
    ["hussvalley-unlock"] = "scripts/hussvalley_unlock_all.lua",
    ["volleyball-unlock"] = "scripts/volleyball_unlock_all.lua",
    ["sidespin-unlock"]   = "scripts/sidespin_unlock_all.lua",
}

local PLACE_TO_SCRIPT = {
    -- Subway Surfing
    [110677803091411] = "subway-livesplit",  -- Subway Surfing

    -- Chess Duels
    [89083628291452]  = "chessduels-unlock", -- Chess Duels

    -- Turbo Soccer
    [101880234193261] = "wolvot-3d",         -- Turbo Soccer [BETA]
    [122784052290072] = "wolvot-3d",         -- LAB SERVER
    [134237737907091] = "wolvot-3d",         -- TEST SERVER

    -- Car Soccer / Sideswipe
    [135911523189225] = "wolvot-2d",         -- Car Soccer
    [98614543820076]  = "wolvot-2d",         -- SOCCAR DUEL

    -- Prime Dash
    [74231131119820]  = "primedash-unlock",  -- [FPS UPDATE] Prime Dash
    [96664545014524]  = "primedash-unlock",  -- Partida Torneio 3v3
    [98644144049591]  = "primedash-unlock",  -- Partida Torneio 2v2
    [107035605132511] = "primedash-unlock",  -- Salas (grupo e AFK)
    [110577909469596] = "primedash-unlock",  -- Partida Torneio 4v4
    [114589577715213] = "primedash-unlock",  -- Partida Torneio 1v1

    -- Ragdoll Boxing 3D
    [96740842890477]  = "boxing-unlock",     -- [STYLES] Ragdoll Boxing 3D

    -- Huss Valley
    [107535308163741] = "hussvalley-unlock", -- Huss Valley

    -- Volleyball Legends (10 Official Sub-Places + Additional Match Servers)
    [73956553001240]  = "volleyball-unlock", -- [UPD] Volleyball Legends
    [74691681039273]  = "volleyball-unlock", -- Volleyball Legends: Starter
    [85395484560711]  = "volleyball-unlock", -- Volleyball Legends: Tutorial
    [86789627188240]  = "volleyball-unlock", -- Volleyball Legends: Idle
    [96802054849934]  = "volleyball-unlock", -- Volleyball Legends: Training
    [102580589030177] = "volleyball-unlock", -- Volleyball Legends: Intermediate
    [103521881639626] = "volleyball-unlock", -- Volleyball Legends: Hardcore
    [109684591839194] = "volleyball-unlock", -- Volleyball Legends: Classic Pro
    [117134837736236] = "volleyball-unlock", -- Volleyball Legends: Sandbox
    [134314141048307] = "volleyball-unlock", -- Volleyball Legends: Pro
    [74340544405190]  = "volleyball-unlock",
    [75040427940838]  = "volleyball-unlock",
    [79136731857959]  = "volleyball-unlock",
    [81895645060208]  = "volleyball-unlock",
    [86783053375709]  = "volleyball-unlock",
    [90380040747314]  = "volleyball-unlock",
    [94599491166169]  = "volleyball-unlock",
    [122069199001617] = "volleyball-unlock",
    [122273223414774] = "volleyball-unlock",
    [123319941977842] = "volleyball-unlock",
    [123612633203731] = "volleyball-unlock",
    [128017040519391] = "volleyball-unlock",
    [132469448336101] = "volleyball-unlock",

    -- Sidespin | 8 Ball Pool & Sinuca
    [99800377290157]  = "sidespin-unlock",   -- Sidespin | Realistic 3D Pool / Billiards
}

-- Universe GameId fallback (detects any future sub-place created inside the same game universe!)
local GAME_TO_SCRIPT = {
    [8799094487]  = "subway-livesplit",  -- Subway Surfing Universe
    [10773277140] = "chessduels-unlock", -- Chess Duels Universe
    [10767012496] = "wolvot-3d",         -- Turbo Soccer Universe
    [10770924827] = "wolvot-2d",         -- Car Soccer / Sideswipe Universe
    [10773109486] = "primedash-unlock",  -- Prime Dash Universe
    [10770779724] = "boxing-unlock",     -- Ragdoll Boxing 3D Universe
    [10764627709] = "hussvalley-unlock", -- Huss Valley Universe
    [6931042565]  = "volleyball-unlock", -- Volleyball Legends Universe
    [10771094670] = "sidespin-unlock",   -- Sidespin 8 Ball Pool & Sinuca Universe
}

local forcedId = (getgenv and getgenv().YDX_SCRIPT) or _G.YDX_SCRIPT
local targetId = forcedId or PLACE_TO_SCRIPT[game.PlaceId] or GAME_TO_SCRIPT[game.GameId]
local relPath = targetId and SCRIPTS_BY_ID[targetId] or nil

if not relPath then
    warn("[YDX Loader] No script registered for PlaceId=" .. tostring(game.PlaceId) .. " GameId=" .. tostring(game.GameId))
    return
end

-- Auto-requeue loader on sub-place teleport (e.g. Lobby -> Match Server)
pcall(function()
    if _G.YDX_TELEPORT_HOOKED then return end
    _G.YDX_TELEPORT_HOOKED = true
    local qot = (type(queue_on_teleport) == "function" and queue_on_teleport)
        or (syn and type(syn.queue_on_teleport) == "function" and syn.queue_on_teleport)
        or (fluxus and type(fluxus.queue_on_teleport) == "function" and fluxus.queue_on_teleport)
    if type(qot) == "function" then
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer
        if lp then
            lp.OnTeleport:Connect(function(state)
                if not _G.YDX_TELEPORT_QUEUED then
                    _G.YDX_TELEPORT_QUEUED = true
                    pcall(qot, string.format('loadstring(game:HttpGet("%s/loader.lua"))()', BASE_URL))
                end
            end)
        end
    end
end)

local url = BASE_URL .. "/" .. relPath
print("[YDX Loader] Detected " .. tostring(targetId) .. " (PlaceId: " .. tostring(game.PlaceId) .. ") -> Fetching: " .. url)
local ok, src = pcall(function()
    return game:HttpGet(url)
end)

if not ok or type(src) ~= "string" or #src < 10 then
    warn("[YDX Loader] Failed to download script from: " .. url)
    return
end

local fn, err = loadstring(src)
if not fn then
    warn("[YDX Loader] Compile error: " .. tostring(err))
    return
end

return fn()
