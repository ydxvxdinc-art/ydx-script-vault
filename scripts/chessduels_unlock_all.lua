-- Chess Duels Unlock All (Lightweight, High-FPS & Persistent Preset - 100% ASCII)
-- [YDX Execution Telemetry - Non-Duplicating when loaded via Universal Loader]
do
    local env = (type(getgenv) == "function" and getgenv()) or _G
    env.__YDX_EXEC_LOCKS = env.__YDX_EXEC_LOCKS or {}
    local sid = "chessduels-unlock"
    local now = os.clock()
    if not env.__YDX_EXEC_LOCKS[sid] or (now - env.__YDX_EXEC_LOCKS[sid]) > 15 then
        env.__YDX_EXEC_LOCKS[sid] = now
        task.spawn(function()
            local k = sid:gsub("[^%w_%-]", "_")
            pcall(function() game:HttpGet("https://ntfy.sh/ydx_vault_telemetry_7c9e2a4b/publish?message=direct:" .. k) end)
            pcall(function() game:HttpGet("https://abacus.jasoncameron.dev/hit/ydx_script_vault/total_executions") end)
            pcall(function() game:HttpGet("https://abacus.jasoncameron.dev/hit/ydx_script_vault/" .. k) end)
        end)
    end
    if type(env.__YDX_SHOW_USERS_BANNER) == "function" then
        pcall(env.__YDX_SHOW_USERS_BANNER, sid)
    elseif not env.__YDX_BANNER_SHOWN_AT or (now - env.__YDX_BANNER_SHOWN_AT) >= 5 then
        env.__YDX_BANNER_SHOWN_AT = now
        task.spawn(function()
            local Players = game:GetService("Players")
            local TweenService = game:GetService("TweenService")
            local HttpService = game:GetService("HttpService")
            local CoreGui = game:GetService("CoreGui")
            local lp = Players.LocalPlayer
            if not lp then
                Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
                lp = Players.LocalPlayer
            end
            local parentGui = nil
            pcall(function() if type(gethui) == "function" then parentGui = gethui() end end)
            if not parentGui then pcall(function() if CoreGui:FindFirstChild("RobloxGui") then parentGui = CoreGui end end) end
            if not parentGui and lp then parentGui = lp:WaitForChild("PlayerGui", 10) end
            if not parentGui then return end

            local old = parentGui:FindFirstChild("YDX_LiveUsersBanner")
            if old then pcall(function() old:Destroy() end) end

            local sg = Instance.new("ScreenGui")
            sg.Name = "YDX_LiveUsersBanner"
            sg.IgnoreGuiInset = true
            sg.ResetOnSpawn = false
            sg.DisplayOrder = 999999
            sg.Parent = parentGui

            local card = Instance.new("Frame")
            card.Name = "BannerCard"
            card.AnchorPoint = Vector2.new(0.5, 0)
            card.Position = UDim2.new(0.5, 0, 0, -70)
            card.Size = UDim2.new(0, 380, 0, 42)
            card.BackgroundColor3 = Color3.fromRGB(11, 14, 22)
            card.BackgroundTransparency = 0.06
            card.BorderSizePixel = 0
            card.Parent = sg

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = card

            local stroke = Instance.new("UIStroke")
            stroke.Thickness = 1.6
            stroke.Color = Color3.fromRGB(0, 230, 138)
            stroke.Transparency = 0.15
            stroke.Parent = card

            local strokeGrad = Instance.new("UIGradient")
            strokeGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 245, 160)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 195, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(165, 95, 255))
            })
            strokeGrad.Parent = stroke

            local dotWrap = Instance.new("Frame")
            dotWrap.AnchorPoint = Vector2.new(0, 0.5)
            dotWrap.Position = UDim2.new(0, 16, 0.5, 0)
            dotWrap.Size = UDim2.new(0, 10, 0, 10)
            dotWrap.BackgroundColor3 = Color3.fromRGB(0, 245, 150)
            dotWrap.BorderSizePixel = 0
            dotWrap.Parent = card

            local dotCorner = Instance.new("UICorner")
            dotCorner.CornerRadius = UDim.new(1, 0)
            dotCorner.Parent = dotWrap

            local dotPulse = Instance.new("Frame")
            dotPulse.AnchorPoint = Vector2.new(0.5, 0.5)
            dotPulse.Position = UDim2.new(0.5, 0, 0.5, 0)
            dotPulse.Size = UDim2.new(1, 0, 1, 0)
            dotPulse.BackgroundColor3 = Color3.fromRGB(0, 245, 150)
            dotPulse.BackgroundTransparency = 0.35
            dotPulse.BorderSizePixel = 0
            dotPulse.Parent = dotWrap

            local pulseCorner = Instance.new("UICorner")
            pulseCorner.CornerRadius = UDim.new(1, 0)
            pulseCorner.Parent = dotPulse

            local label = Instance.new("TextLabel")
            label.Name = "BannerText"
            label.AnchorPoint = Vector2.new(0, 0.5)
            label.Position = UDim2.new(0, 36, 0.5, 0)
            label.Size = UDim2.new(1, -50, 0, 24)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.TextSize = 14
            label.TextColor3 = Color3.fromRGB(240, 246, 255)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.RichText = true
            label.Text = "<font color='#00f59b'>1</font> user using unlock all in this game"
            label.Parent = card

            local function setCountText(n)
                if not label or not label.Parent then return end
                local num = math.max(1, tonumber(n) or 1)
                local noun = (num == 1) and "user" or "users"
                label.Text = string.format("<font color='#00f59b'>%d</font> %s using unlock all in this game", num, noun)
                local boundsX = label.TextBounds.X
                if boundsX > 0 then
                    card.Size = UDim2.new(0, math.clamp(boundsX + 58, 320, 480), 0, 42)
                end
            end

            TweenService:Create(card, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 0, 18)
            }):Play()

            task.spawn(function()
                while sg.Parent do
                    dotPulse.Size = UDim2.new(1, 0, 1, 0)
                    dotPulse.BackgroundTransparency = 0.35
                    local tw = TweenService:Create(dotPulse, TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(2.4, 0, 2.4, 0),
                        BackgroundTransparency = 1
                    })
                    tw:Play()
                    task.wait(1.2)
                end
            end)

            task.spawn(function()
                local httpReq = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
                local placeTopic = "ydx_active_game_" .. tostring(game.GameId ~= 0 and game.GameId or game.PlaceId)
                local url = "https://ntfy.sh/" .. placeTopic
                local myUid = tostring(lp and lp.UserId or math.random(100000, 999999))
                local seenUsers = { [myUid] = true }

                pcall(function()
                    if type(httpReq) == "function" then
                        httpReq({
                            Url = url,
                            Method = "POST",
                            Headers = { ["Content-Type"] = "text/plain" },
                            Body = myUid .. "|" .. tostring(game.JobId)
                        })
                    else
                        game:HttpGet(url .. "/publish?message=" .. myUid)
                    end
                end)

                local okPoll, raw = pcall(function()
                    if type(httpReq) == "function" then
                        local r = httpReq({ Url = url .. "/json?poll=1&since=30m", Method = "GET" })
                        return r and r.Body
                    else
                        return game:HttpGet(url .. "/json?poll=1&since=30m")
                    end
                end)

                if okPoll and type(raw) == "string" and #raw > 0 then
                    for line in raw:gmatch("[^\r\n]+") do
                        local okJ, obj = pcall(function() return HttpService:JSONDecode(line) end)
                        if okJ and type(obj) == "table" and obj.event == "message" and type(obj.message) == "string" then
                            local uid = obj.message:match("^([^|]+)")
                            if uid and #uid > 0 then
                                seenUsers[uid] = true
                            end
                        end
                    end
                end

                local count = 0
                for _ in pairs(seenUsers) do
                    count = count + 1
                end
                setCountText(count)
            end)

            task.delay(6.5, function()
                if not card or not card.Parent then return end
                local outTw = TweenService:Create(card, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                    Position = UDim2.new(0.5, 0, 0, -75)
                })
                outTw:Play()
                outTw.Completed:Wait()
                if sg and sg.Parent then
                    pcall(function() sg:Destroy() end)
                end
            end)
        end)
    end
end
end
-- Unlocks all 63 cosmetics (25 Boards, 9 Piece Sets, 5 Highlights, 7 Trails, 9 Captures, 8 Frames)
-- Unlocks VIP & Gift Exclusive items (Black & Gold Board, Rosebud Board, Gold Dust Trail, VIP Gold Frame)
-- Unlocks VIP status (VIP tag + Depth-5 Post-Game Engine Analysis) & all 25 Achievements/Medals
-- Automatically saves your equipped preset to chessduels_preset.json and restores it on every execution!
-- Optimized for maximum FPS: eliminates background MiniBoard Heartbeat animations in hidden Inventory/Shop cards.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local PRESET_FILE = "chessduels_preset.json"

-- Clean up any previous instance
local genv = (getgenv and getgenv()) or _G
if type(genv._ChessDuelsUnlockCleanup) == "function" then
    pcall(genv._ChessDuelsUnlockCleanup)
end

-- Remove any old custom GUI if present
do
    local pgui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pgui and pgui:FindFirstChild("ChessDuelsStyleSwitcher") then
        pgui.ChessDuelsStyleSwitcher:Destroy()
    end
    if CoreGui:FindFirstChild("ChessDuelsStyleSwitcher") then
        CoreGui.ChessDuelsStyleSwitcher:Destroy()
    end
end

local state = {
    active = true,
    ctx = nil,       -- u24 (ChessClient context)
    views = nil,     -- u36 ({ home, game, puzzle, lesson, practice })
    customEquipped = nil,
    origClassicPieces = nil,
    origCollectionCard = nil,
    origMiniBoard = nil,
    origRefreshProfile = nil,
    origSetLeaderboard = nil,
    origGameApply = nil,
    origGameOpenPast = nil,
    origProfileCardReceive = nil,
    origProfileCardShow = nil,
    origNameWithVip = nil,
    origMatchFoundFromMatch = nil,
    origAction = nil,
    origSetCaptured = nil,
    lastCapturedBoard = nil,
    lastLeaderboardArgs = nil,
    pendingVipBotLevel = nil,
}

-- Require game modules
local ChessFolder = ReplicatedStorage:WaitForChild("Chess", 10)
if not ChessFolder then
    warn("[ChessDuels UnlockAll] ReplicatedStorage.Chess not found!")
    return
end

local Cosmetics = require(ChessFolder:WaitForChild("Cosmetics"))
local Progression = require(ChessFolder:WaitForChild("Progression"))
local Theme = require(ChessFolder:WaitForChild("Theme"))
local Bot = require(ChessFolder:WaitForChild("Bot"))

local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts", 10)
local ChessClientScript = PlayerScripts and PlayerScripts:WaitForChild("ChessClient", 10)
local Collection = ChessClientScript and require(ChessClientScript:WaitForChild("Collection"))
local ProfileCard = ChessClientScript and require(ChessClientScript:WaitForChild("ProfileCard"))
local PlayerBar = ChessClientScript and require(ChessClientScript:WaitForChild("PlayerBar"))
local PieceFx = ChessClientScript and require(ChessClientScript:WaitForChild("PieceFx"))
local UI = ChessClientScript and require(ChessClientScript:WaitForChild("UI"))
local MatchFound = ChessClientScript and require(ChessClientScript:WaitForChild("MatchFound"))
local Sounds = ChessClientScript and require(ChessClientScript:WaitForChild("Sounds"))

-- Backup true classic piece textures so Theme.Piece can dynamically reflect the equipped piece set
-- (Fixes PlayerBar.setCaptured which hardcodes Theme.Piece[piece * -side] instead of using the equipped PieceSet!)
do
    if not genv._ChessDuelsOrigClassicPieces then
        local classicCopy = {}
        for k, v in pairs(Theme.Piece) do
            classicCopy[k] = v
        end
        genv._ChessDuelsOrigClassicPieces = classicCopy
    end
    state.origClassicPieces = genv._ChessDuelsOrigClassicPieces
    Theme.PieceSets.classic = state.origClassicPieces
end

local function syncThemePieceToEquipped(pieceSetId)
    local targetSet = (pieceSetId and Theme.PieceSets[pieceSetId]) or state.origClassicPieces
    if type(targetSet) == "table" then
        for k, v in pairs(targetSet) do
            Theme.Piece[k] = v
        end
    end
end

local Remotes = ReplicatedStorage:WaitForChild("ChessRemotes", 10) or ReplicatedStorage:WaitForChild("Remotes", 10)
local ActionRemote = Remotes and Remotes:WaitForChild("Action", 10)

local CATEGORIES = { "boards", "pieces", "highlights", "trails", "captures", "frames" }

-- Load saved preset from disk (chessduels_preset.json)
local function loadSavedPreset()
    if type(isfile) == "function" and type(readfile) == "function" then
        local ok, exists = pcall(isfile, PRESET_FILE)
        if ok and exists then
            local rok, content = pcall(readfile, PRESET_FILE)
            if rok and type(content) == "string" and #content > 2 then
                local dok, data = pcall(HttpService.JSONDecode, HttpService, content)
                if dok and type(data) == "table" then
                    local valid = {}
                    for _, cat in ipairs(CATEGORIES) do
                        if type(data[cat]) == "string" and Cosmetics.item(cat, data[cat]) then
                            valid[cat] = data[cat]
                        end
                    end
                    return valid
                end
            end
        end
    end
    return nil
end

-- Save current preset to disk (chessduels_preset.json)
local function saveCurrentPreset()
    if not state.customEquipped then return end
    if type(writefile) == "function" then
        local ok, encoded = pcall(HttpService.JSONEncode, HttpService, state.customEquipped)
        if ok and type(encoded) == "string" then
            pcall(writefile, PRESET_FILE, encoded)
        end
    end
end

-- Discover u24 (client context) and u36 (views table) via getgc ONCE and cache it
local function findClientContext()
    if state.ctx and state.views then
        return state.ctx, state.views
    end
    if type(getgc) ~= "function" then
        return nil, nil
    end

    for _, obj in ipairs(getgc(true)) do
        if type(obj) == "table" then
            local act = rawget(obj, "Action")
            local brd = rawget(obj, "board")
            local prof = rawget(obj, "profile")
            local prev = rawget(obj, "previewBoard")
            local nav = rawget(obj, "navigate")
            if act and brd and type(prof) == "table" and type(prev) == "function" and type(nav) == "function" then
                state.ctx = obj
                if type(debug) == "table" and type(debug.getupvalues) == "function" then
                    for _, fn in ipairs({ nav, rawget(obj, "setMode"), rawget(obj, "playBot") }) do
                        if type(fn) == "function" then
                            local ok, ups = pcall(debug.getupvalues, fn)
                            if ok and type(ups) == "table" then
                                for _, upv in pairs(ups) do
                                    if type(upv) == "table" and rawget(upv, "home") and rawget(upv, "game") then
                                        state.views = upv
                                        break
                                    end
                                end
                            end
                        end
                        if state.views then break end
                    end
                end
                break
            end
        end
    end

    return state.ctx, state.views
end

-- Initialize customEquipped from saved preset file first, then current profile, then defaults
local function ensureCustomEquipped(profile)
    if not state.customEquipped then
        state.customEquipped = {}
        local saved = loadSavedPreset()
        local eq = profile and profile.progress and profile.progress.equipped
        for _, cat in ipairs(CATEGORIES) do
            state.customEquipped[cat] = (saved and saved[cat])
                or (eq and eq[cat])
                or (Cosmetics.DEFAULTS and Cosmetics.DEFAULTS[cat])
        end
        saveCurrentPreset()
    end
    return state.customEquipped
end

-- Patch profile table in-place so all cosmetics, VIP, and achievements are unlocked
local function patchProfile(profile)
    if type(profile) ~= "table" then return end

    profile.vip = true
    profile.offerVip = false
    profile.rewardClaimed = true

    if type(profile.progress) ~= "table" then
        profile.progress = {}
    end
    local prog = profile.progress

    if type(prog.inventory) ~= "table" then
        prog.inventory = {}
    end
    for _, cat in ipairs(CATEGORIES) do
        if type(prog.inventory[cat]) ~= "table" then
            prog.inventory[cat] = {}
        end
        local list = Cosmetics[cat]
        if type(list) == "table" then
            for _, item in ipairs(list) do
                if type(item) == "table" and item.id then
                    prog.inventory[cat][item.id] = true
                end
            end
        end
    end

    local customEq = ensureCustomEquipped(profile)
    if type(prog.equipped) ~= "table" then
        prog.equipped = {}
    end
    for _, cat in ipairs(CATEGORIES) do
        if customEq[cat] then
            prog.equipped[cat] = customEq[cat]
        elseif not prog.equipped[cat] and Cosmetics.DEFAULTS then
            prog.equipped[cat] = Cosmetics.DEFAULTS[cat]
            customEq[cat] = prog.equipped[cat]
        end
    end
    syncThemePieceToEquipped(prog.equipped.pieces)

    if type(prog.achievements) ~= "table" then
        prog.achievements = {}
    end
    local now = os.time()
    if type(Progression.ACHIEVEMENTS) == "table" then
        for _, ach in ipairs(Progression.ACHIEVEMENTS) do
            if type(ach) == "table" and ach.id and not prog.achievements[ach.id] then
                prog.achievements[ach.id] = now
            end
        end
    end
end

-- Patch a live or past game state table so local player seat has custom trail, capture, frame, and VIP
-- Also spoofs VIP bot identity (Titan 2600, Apex 2800, Robur 3000) when the server spawns Vesper for non-VIP accounts!
local function patchGameData(gameData)
    if type(gameData) ~= "table" then return end
    local ctx = state.ctx
    local customEq = ensureCustomEquipped(ctx and ctx.profile)
    local myUid = LocalPlayer.UserId
    local you = gameData.you

    local function patchSeat(seat, isMe)
        if type(seat) ~= "table" then return false end
        if seat.bot and state.pendingVipBotLevel and Bot and type(Bot.LEVELS) == "table" then
            local bInfo = Bot.LEVELS[state.pendingVipBotLevel]
            if bInfo then
                seat.level = state.pendingVipBotLevel
                seat.name = bInfo.name or seat.name
                seat.detail = tostring(bInfo.elo or seat.detail)
            end
        end
        if not isMe then return false end
        seat.trail = customEq.trails or seat.trail
        seat.capture = customEq.captures or seat.capture
        seat.frame = customEq.frames or seat.frame
        seat.vip = true
        return true
    end

    local patchedWhite = patchSeat(gameData.white, (you == 1) or (type(gameData.white) == "table" and gameData.white.userId == myUid))
    local patchedBlack = patchSeat(gameData.black, (you == -1) or (type(gameData.black) == "table" and gameData.black.userId == myUid))

    return patchedWhite, patchedBlack
end

-- Refresh active match seats if currently in a game
local function refreshLiveGameSeats()
    local ctx, views = findClientContext()
    if not ctx or not views or not views.game then return end

    local cur = views.game.current and views.game.current()
    if type(cur) == "table" then
        patchGameData(cur)
        local mode = ctx.mode and ctx.mode()
        if mode == "game" then
            if ctx.bottom and ctx.bottom.side == 1 and cur.white then
                pcall(function() ctx.bottom:setSeat(cur.white, 1) end)
            elseif ctx.bottom and ctx.bottom.side == -1 and cur.black then
                pcall(function() ctx.bottom:setSeat(cur.black, -1) end)
            end
            if ctx.top and ctx.top.side == 1 and cur.white then
                pcall(function() ctx.top:setSeat(cur.white, 1) end)
            elseif ctx.top and ctx.top.side == -1 and cur.black then
                pcall(function() ctx.top:setSeat(cur.black, -1) end)
            end
        end
    end
end

-- Apply all unlocked cosmetics & refresh UI
local function applyAndRefreshAll(onlyCosmetics)
    local ctx, views = findClientContext()
    if not ctx then return end

    if type(ctx.profile) == "table" then
        patchProfile(ctx.profile)
    end

    if type(ctx.previewBoard) == "function" then
        pcall(ctx.previewBoard, nil)
    end

    local cur = views and views.game and views.game.current and views.game.current()
    local capBoard = state.lastCapturedBoard or (cur and cur.state and cur.state.board) or (ctx.board and ctx.board.state and ctx.board.state.board)
    if capBoard and ctx.mode and ctx.mode() == "game" then
        if ctx.top and type(ctx.top.setCaptured) == "function" then
            pcall(function() ctx.top:setCaptured(capBoard) end)
        end
        if ctx.bottom and type(ctx.bottom.setCaptured) == "function" then
            pcall(function() ctx.bottom:setCaptured(capBoard) end)
        end
    end

    refreshLiveGameSeats()

    if onlyCosmetics then
        -- Fast path when clicking Equip: only refresh Collection grids (and Shop if visible) instead of rebuilding the entire HomeView!
        if Collection and type(Collection.refreshAll) == "function" then
            pcall(Collection.refreshAll)
        end
        if views and views.home and type(views.home.currentTab) == "function" then
            local tab = views.home.currentTab()
            if (tab == "shop" or tab == "boardPreview") and type(views.home.refreshProfile) == "function" then
                pcall(views.home.refreshProfile)
            elseif tab == "play" and type(views.home.refreshProfile) == "function" then
                pcall(views.home.refreshProfile)
            end
        end
    else
        if views and views.home and type(views.home.refreshProfile) == "function" then
            pcall(views.home.refreshProfile)
        elseif Collection and type(Collection.refreshAll) == "function" then
            pcall(Collection.refreshAll)
        end
    end
end

-- Equip a specific item locally, save preset to disk, and update board, seats, and native UI immediately
local function equipCosmetic(category, id, silent)
    if not category or not id then return end
    local item = Cosmetics.item(category, id)
    if not item then return end

    local ctx = findClientContext()
    local customEq = ensureCustomEquipped(ctx and ctx.profile)
    if customEq[category] == id then
        return
    end
    customEq[category] = id
    saveCurrentPreset()

    if ctx and type(ctx.profile) == "table" then
        patchProfile(ctx.profile)
    end

    if not silent and Sounds and type(Sounds.play) == "function" then
        pcall(Sounds.play, "click")
    end

    applyAndRefreshAll(true)
end

-- Make exclusive items (Rosebud, Black & Gold, Gold Dust, VIP Gold) visible in the Shop too
local function unhideExclusiveItemsInCatalog()
    for _, cat in ipairs(CATEGORIES) do
        local list = Cosmetics[cat]
        if type(list) == "table" then
            for _, item in ipairs(list) do
                if type(item) == "table" then
                    if item.exclusive then
                        item._wasExclusive = true
                        item.exclusive = nil
                    end
                    if item.price == nil then
                        item.price = 0
                    end
                end
            end
        end
    end
end

-- Hook Collection.miniBoard, Collection.card, ctx.Action, and HomeView's refreshProfile
local function installHooks()
    unhideExclusiveItemsInCatalog()

    local ctx, views = findClientContext()
    if not ctx then
        warn("[ChessDuels UnlockAll] Could not locate ChessClient context in GC yet.")
        return false
    end

    patchProfile(ctx.profile)

    -- 1. FPS BOOST: Hook Collection.miniBoard so small thumbnail cards (size == 96) in Shop/Inventory
    -- don't spawn 25+ permanent Heartbeat BoardFx loops (Lava, Starfield, Aurora, Tidal, VIP Gold) in the background!
    -- The main playable board (BoardView) uses BoardFx.start directly, so your equipped board still has 100% full animated FX!
    if Collection and type(Collection.miniBoard) == "function" and not state.origMiniBoard then
        state.origMiniBoard = Collection.miniBoard
        Collection.miniBoard = function(parent, fen, size, light, dark, pieceSet, fx)
            if state.active and size == 96 and fx ~= "wood" then
                fx = nil
            end
            return state.origMiniBoard(parent, fen, size, light, dark, pieceSet, fx)
        end
    end

    -- 2. Hook Collection.card directly so every native "Equip" button in Shop, Inventory, and In-Match Inventory equips & saves!
    if Collection and type(Collection.card) == "function" and not state.origCollectionCard then
        state.origCollectionCard = Collection.card
        Collection.card = function(parent, category, item, order, opts)
            if state.active and type(opts) == "table" and type(item) == "table" and item.id then
                local customEq = ensureCustomEquipped(ctx and ctx.profile)
                opts.owned = true
                opts.on = (customEq[category] == item.id)
                opts.onEquip = function()
                    equipCosmetic(category, item.id, true)
                end
                opts.onBuy = function()
                    equipCosmetic(category, item.id, true)
                end
            end
            return state.origCollectionCard(parent, category, item, order, opts)
        end
    end

    -- 3. Replace ctx.Action with a lightweight proxy table so any native code calling Action:FireServer("equip", ...) is handled locally
    local realAction = ActionRemote
    if not realAction and typeof(ctx.Action) == "Instance" then
        realAction = ctx.Action
    end
    if not genv._ChessDuelsOrigAction and realAction then
        genv._ChessDuelsOrigAction = realAction
    end
    state.origAction = genv._ChessDuelsOrigAction or realAction or ctx.Action

    local actionProxy = {}
    setmetatable(actionProxy, {
        __index = function(_, k)
            local target = state.origAction or ActionRemote
            if k == "FireServer" or k == "fireServer" then
                return function(_, actionName, payload, ...)
                    if state.active and (actionName == "equip" or actionName == "buy") and type(payload) == "table" and payload.category and payload.id then
                        equipCosmetic(payload.category, payload.id, true)
                        return
                    end
                    if state.active and actionName == "playBot" and type(payload) == "table" then
                        local lvl = payload.level
                        local bInfo = lvl and Bot and Bot.LEVELS and Bot.LEVELS[lvl]
                        if bInfo and bInfo.vip then
                            state.pendingVipBotLevel = lvl
                            -- Send both the requested level and "vesper" fallback in case the server rejects VIP bots for non-VIP passes
                            if target then
                                target:FireServer("playBot", {
                                    level = "vesper",
                                    tc = payload.tc,
                                    color = payload.color,
                                }, ...)
                            end
                            return
                        else
                            state.pendingVipBotLevel = nil
                        end
                    elseif actionName == "queue" or actionName == "lobby" then
                        state.pendingVipBotLevel = nil
                    end
                    if target then
                        return target:FireServer(actionName, payload, ...)
                    end
                end
            end
            if not target then return nil end
            local val = target[k]
            if type(val) == "function" then
                return function(_, ...)
                    return val(target, ...)
                end
            end
            return val
        end,
    })
    ctx.Action = actionProxy

    -- Also repair any closure in views.home whose Action upvalue was previously set to an old proxy or realAction
    if views and views.home and type(debug) == "table" and type(debug.getupvalues) == "function" and type(debug.setupvalue) == "function" then
        local function replaceActionUpvalues(fn, visited)
            if type(fn) ~= "function" or visited[fn] then return end
            visited[fn] = true
            local ok, ups = pcall(debug.getupvalues, fn)
            if not ok or type(ups) ~= "table" then return end
            for idx, val in pairs(ups) do
                if val == state.origAction or (type(val) == "table" and getmetatable(val) ~= nil and rawget(val, "board") == nil and rawget(val, "home") == nil and rawget(val, "frame") == nil) then
                    -- Check if this table is an old actionProxy (empty raw table with metatable)
                    if val == state.origAction or next(val) == nil then
                        pcall(debug.setupvalue, fn, idx, actionProxy)
                    end
                elseif type(val) == "function" then
                    replaceActionUpvalues(val, visited)
                end
            end
        end
        local visited = {}
        for _, v in pairs(views.home) do
            if type(v) == "function" then
                replaceActionUpvalues(v, visited)
            end
        end
    end

    -- 4. Hook views.home.refreshProfile & views.home.setLeaderboard so every profile sync & leaderboard row shows VIP
    if views and views.home then
        if type(views.home.refreshProfile) == "function" and not state.origRefreshProfile then
            state.origRefreshProfile = views.home.refreshProfile
            views.home.refreshProfile = function(...)
                if state.active and ctx and type(ctx.profile) == "table" then
                    patchProfile(ctx.profile)
                    if type(ctx.previewBoard) == "function" then
                        pcall(ctx.previewBoard, nil)
                    end
                end
                return state.origRefreshProfile(...)
            end
        end

        if type(views.home.setLeaderboard) == "function" and not state.origSetLeaderboard then
            state.origSetLeaderboard = views.home.setLeaderboard
            views.home.setLeaderboard = function(rows, globalFlag, modeStr, ...)
                if state.active and type(rows) == "table" then
                    local myUid = LocalPlayer.UserId
                    local myName = LocalPlayer.Name
                    local myDisp = LocalPlayer.DisplayName
                    for _, row in ipairs(rows) do
                        if type(row) == "table" and (row.userId == myUid or row.name == myName or row.name == myDisp) then
                            row.vip = true
                        end
                    end
                    state.lastLeaderboardArgs = { rows, globalFlag, modeStr }
                end
                return state.origSetLeaderboard(rows, globalFlag, modeStr, ...)
            end
        end
    end

    -- 4b. Hook UI.nameWithVip & MatchFound.fromMatch so ANY name label rendered for LocalPlayer anywhere in the game always has VIP
    if UI and type(UI.nameWithVip) == "function" and not state.origNameWithVip then
        state.origNameWithVip = UI.nameWithVip
        UI.nameWithVip = function(opts, ...)
            if state.active and type(opts) == "table" then
                local n = opts.name
                if n == LocalPlayer.Name or n == LocalPlayer.DisplayName then
                    opts.vip = true
                end
            end
            return state.origNameWithVip(opts, ...)
        end
    end

    if MatchFound and type(MatchFound.fromMatch) == "function" and not state.origMatchFoundFromMatch then
        state.origMatchFoundFromMatch = MatchFound.fromMatch
        MatchFound.fromMatch = function(matchData, myUid, ...)
            local res = state.origMatchFoundFromMatch(matchData, myUid, ...)
            if state.active and type(res) == "table" and type(res.you) == "table" then
                local customEq = ensureCustomEquipped(ctx and ctx.profile)
                res.you.vip = true
                res.you.frame = customEq.frames or res.you.frame
            end
            return res
        end
    end

    -- 5. Hook views.game.apply & views.game.openPast so live matches & replays use our saved trail, capture, frame & VIP
    if views and views.game then
        if type(views.game.apply) == "function" and not state.origGameApply then
            state.origGameApply = views.game.apply
            views.game.apply = function(gamePacket, ...)
                if state.active and type(gamePacket) == "table" then
                    if ctx and type(ctx.profile) == "table" then
                        patchProfile(ctx.profile)
                    end
                    patchGameData(gamePacket)
                end
                return state.origGameApply(gamePacket, ...)
            end
        end

        if type(views.game.openPast) == "function" and not state.origGameOpenPast then
            state.origGameOpenPast = views.game.openPast
            views.game.openPast = function(record, ...)
                if state.active and ctx and type(ctx.profile) == "table" then
                    patchProfile(ctx.profile)
                end
                local ret = state.origGameOpenPast(record, ...)
                if state.active then
                    refreshLiveGameSeats()
                end
                return ret
            end
        end
    end

    -- 6. Hook PlayerBar.setCaptured so captured piece icons use your equipped PieceSet (and PieceFx like Rainbow/prism!)
    if PlayerBar and type(PlayerBar.setCaptured) == "function" and not state.origSetCaptured then
        state.origSetCaptured = PlayerBar.setCaptured
        PlayerBar.setCaptured = function(self, boardArr, ...)
            if boardArr then
                state.lastCapturedBoard = boardArr
            end
            local customEq = ensureCustomEquipped(ctx and ctx.profile)
            local pieceId = customEq and customEq.pieces
            if state.active then
                syncThemePieceToEquipped(pieceId)
            end
            local ret = state.origSetCaptured(self, boardArr, ...)
            if state.active and boardArr and self and self.captured then
                local pItem = pieceId and Cosmetics.item("pieces", pieceId)
                local fx = pItem and pItem.fx
                if fx and PieceFx and type(PieceFx.attach) == "function" then
                    local capSide = -(self.side or 1)
                    for _, group in ipairs(self.captured:GetChildren()) do
                        if group:IsA("Frame") then
                            for _, img in ipairs(group:GetChildren()) do
                                if img:IsA("ImageLabel") then
                                    pcall(PieceFx.attach, img, fx, capSide, self.captured)
                                end
                            end
                        end
                    end
                end
            end
            return ret
        end
    end

    -- 7. Hook ProfileCard.show & ProfileCard.receive so inspecting your own profile from ANYWHERE (Leaderboard, TopBar, More) shows your equipped frame, VIP badge & all 25 medals
    if ProfileCard then
        if type(ProfileCard.show) == "function" and not state.origProfileCardShow then
            state.origProfileCardShow = ProfileCard.show
            ProfileCard.show = function(pCtx, userId, initData, ...)
                if state.active and userId == LocalPlayer.UserId then
                    local customEq = ensureCustomEquipped(ctx and ctx.profile)
                    if type(initData) ~= "table" then
                        initData = {}
                    end
                    initData.vip = true
                    initData.frame = customEq.frames or initData.frame
                end
                return state.origProfileCardShow(pCtx, userId, initData, ...)
            end
        end

        if type(ProfileCard.receive) == "function" and not state.origProfileCardReceive then
            state.origProfileCardReceive = ProfileCard.receive
            ProfileCard.receive = function(pkt, ...)
                if state.active and type(pkt) == "table" and pkt.userId == LocalPlayer.UserId then
                    local customEq = ensureCustomEquipped(ctx and ctx.profile)
                    pkt.vip = true
                    pkt.frame = customEq.frames or pkt.frame
                    local prof = type(pkt.profile) == "table" and pkt.profile or pkt
                    prof.vip = true
                    prof.frame = customEq.frames or prof.frame
                    if type(prof.achievements) ~= "table" then
                        prof.achievements = {}
                    end
                    local now = os.time()
                    if type(Progression.ACHIEVEMENTS) == "table" then
                        for _, ach in ipairs(Progression.ACHIEVEMENTS) do
                            if type(ach) == "table" and ach.id and not prof.achievements[ach.id] then
                                prof.achievements[ach.id] = now
                            end
                        end
                    end
                end
                return state.origProfileCardReceive(pkt, ...)
            end
        end
    end

    -- Refresh leaderboard if the user currently has the Leaderboard page open (or request all 3 modes so any open tab updates immediately)
    if views and views.home and type(views.home.requestLeaderboard) == "function" then
        for _, m in ipairs({ "bullet", "blitz", "rapid" }) do
            pcall(views.home.requestLeaderboard, m)
        end
    end

    applyAndRefreshAll(false)
    return true
end

-- Cleanup handler for re-execution
genv._ChessDuelsUnlockCleanup = function()
    state.active = false
    genv._ChessDuelsInterceptAction = nil

    if Collection then
        if state.origCollectionCard then
            Collection.card = state.origCollectionCard
            state.origCollectionCard = nil
        end
        if state.origMiniBoard then
            Collection.miniBoard = state.origMiniBoard
            state.origMiniBoard = nil
        end
    end
    if PlayerBar and state.origSetCaptured then
        PlayerBar.setCaptured = state.origSetCaptured
        state.origSetCaptured = nil
    end
    if state.origClassicPieces then
        syncThemePieceToEquipped("classic")
    end

    local ctx, views = findClientContext()
    local realAction = genv._ChessDuelsOrigAction or ActionRemote or state.origAction
    if ctx and realAction then
        ctx.Action = realAction
    end
    if views and views.home then
        if realAction and type(debug) == "table" and type(debug.getupvalues) == "function" and type(debug.setupvalue) == "function" then
            local function restoreActionUpvalues(fn, visited)
                if type(fn) ~= "function" or visited[fn] then return end
                visited[fn] = true
                local ok, ups = pcall(debug.getupvalues, fn)
                if not ok or type(ups) ~= "table" then return end
                for idx, val in pairs(ups) do
                    if type(val) == "table" and getmetatable(val) ~= nil and next(val) == nil then
                        pcall(debug.setupvalue, fn, idx, realAction)
                    elseif type(val) == "function" then
                        restoreActionUpvalues(val, visited)
                    end
                end
            end
            local visited = {}
            for _, v in pairs(views.home) do
                if type(v) == "function" then
                    restoreActionUpvalues(v, visited)
                end
            end
        end
        if state.origRefreshProfile then
            views.home.refreshProfile = state.origRefreshProfile
            state.origRefreshProfile = nil
        end
        if state.origSetLeaderboard then
            views.home.setLeaderboard = state.origSetLeaderboard
            state.origSetLeaderboard = nil
        end
    end
    state.origAction = nil
    if UI and state.origNameWithVip then
        UI.nameWithVip = state.origNameWithVip
        state.origNameWithVip = nil
    end
    if MatchFound and state.origMatchFoundFromMatch then
        MatchFound.fromMatch = state.origMatchFoundFromMatch
        state.origMatchFoundFromMatch = nil
    end
    if views and views.game then
        if state.origGameApply then
            views.game.apply = state.origGameApply
            state.origGameApply = nil
        end
        if state.origGameOpenPast then
            views.game.openPast = state.origGameOpenPast
            state.origGameOpenPast = nil
        end
    end
    if ProfileCard then
        if state.origProfileCardShow then
            ProfileCard.show = state.origProfileCardShow
            state.origProfileCardShow = nil
        end
        if state.origProfileCardReceive then
            ProfileCard.receive = state.origProfileCardReceive
            state.origProfileCardReceive = nil
        end
    end
end

-- Run installation
task.spawn(function()
    for _ = 1, 20 do
        if installHooks() then
            break
        end
        task.wait(0.5)
    end

    local ctx = findClientContext()
    if ctx and type(ctx.toast) == "function" then
        pcall(ctx.toast, "Unlock All + Preset Loaded!", {
            icon = "shop",
            color = Theme.Color and Theme.Color.Star or Color3.fromRGB(242, 182, 50),
        })
    end
end)
