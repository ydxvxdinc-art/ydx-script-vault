-- YDX Script Vault - Universal Loader (100% ASCII)
-- Detects current game PlaceId / GameId or loads all scripts from your hosted site automatically!
-- Usage:
--   getgenv().YDX_SCRIPT = "hussvalley-unlock" -- optional: force a specific script id
--   loadstring(game:HttpGet("https://ydxvxdinc-art.github.io/ydx-script-vault/loader.lua"))()

local BASE_URL = getgenv and getgenv().YDX_BASE_URL or "https://ydxvxdinc-art.github.io/ydx-script-vault"
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
    [110677803091411] = "subway-livesplit",  -- Subway Surfing
    [89083628291452]  = "chessduels-unlock", -- Chess Duels
    [101880234193261] = "wolvot-3d",         -- Turbo Soccer
    [135911523189225] = "wolvot-2d",         -- Sideswipe / Car Soccer
    [74231131119820]  = "primedash-unlock",  -- Prime Dash
    [107035605132511] = "primedash-unlock",  -- Prime Dash (Salas / AFK)
    [96740842890477]  = "boxing-unlock",     -- Ragdoll Boxing 3D
    [107535308163741] = "hussvalley-unlock", -- Huss Valley
    [73956553001240]  = "volleyball-unlock", -- Volleyball Legends
    [99800377290157]  = "sidespin-unlock",   -- Sidespin 8 Ball Pool & Sinuca
}

local GAME_TO_SCRIPT = {
    [10764627709] = "hussvalley-unlock", -- Huss Valley Universe
    [10773109486] = "primedash-unlock",  -- Prime Dash Universe
    [6931042565]  = "volleyball-unlock", -- Volleyball Legends Universe
    [10771094670] = "sidespin-unlock",   -- Sidespin 8 Ball Pool & Sinuca Universe
}

local forcedId = (getgenv and getgenv().YDX_SCRIPT) or _G.YDX_SCRIPT
local targetId = forcedId or PLACE_TO_SCRIPT[game.PlaceId] or GAME_TO_SCRIPT[game.GameId] or "chessduels-unlock"
local relPath = SCRIPTS_BY_ID[targetId]

if not relPath then
    warn("[YDX Loader] Script ID not found: " .. tostring(targetId))
    return
end

local url = BASE_URL .. "/" .. relPath
print("[YDX Loader] Fetching: " .. url)
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
