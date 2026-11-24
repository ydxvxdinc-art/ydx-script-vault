-- Huss Valley: Knife & Emote Unlock All + Real-Time 1:1 P2P Sync (v2.5)
-- [YDX Execution Telemetry - Non-Duplicating when loaded via Universal Loader]
do
    local env = (type(getgenv) == "function" and getgenv()) or _G
    env.__YDX_EXEC_LOCKS = env.__YDX_EXEC_LOCKS or {}
    local sid = "hussvalley-unlock"
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
    if type(env.__YDX_START_UPDATE_WATCHER) == "function" then
        pcall(env.__YDX_START_UPDATE_WATCHER, sid)
    else
        env.__YDX_UPDATE_WATCH_GEN = env.__YDX_UPDATE_WATCH_GEN or {}
        local myGen = (env.__YDX_UPDATE_WATCH_GEN[sid] or 0) + 1
        env.__YDX_UPDATE_WATCH_GEN[sid] = myGen
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
            if parentGui then
                local oldUpd = parentGui:FindFirstChild("YDX_UpdateBanner")
                if oldUpd then pcall(function() oldUpd:Destroy() end) end
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
            local rPath = SCRIPTS_BY_ID[sid]

            local function showUpdateBanner()
                if env.__YDX_UPDATE_WATCH_GEN[sid] ~= myGen or not parentGui then return end
                local old = parentGui:FindFirstChild("YDX_UpdateBanner")
                if old then pcall(function() old:Destroy() end) end

                local sg = Instance.new("ScreenGui")
                sg.Name = "YDX_UpdateBanner"
                sg.IgnoreGuiInset = true
                sg.ResetOnSpawn = false
                sg.DisplayOrder = 1000000
                sg.Parent = parentGui

                local card = Instance.new("Frame")
                card.Name = "UpdateCard"
                card.AnchorPoint = Vector2.new(0.5, 0)
                card.Position = UDim2.new(0.5, 0, 0, -80)
                card.Size = UDim2.new(0, 520, 0, 44)
                card.BackgroundColor3 = Color3.fromRGB(16, 14, 24)
                card.BackgroundTransparency = 0.04
                card.BorderSizePixel = 0
                card.Parent = sg

                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(1, 0)
                corner.Parent = card

                local stroke = Instance.new("UIStroke")
                stroke.Thickness = 1.8
                stroke.Color = Color3.fromRGB(255, 190, 11)
                stroke.Transparency = 0.1
                stroke.Parent = card

                local strokeGrad = Instance.new("UIGradient")
                strokeGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 190, 11)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 95, 109)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 210, 255))
                })
                strokeGrad.Parent = stroke

                local dotWrap = Instance.new("Frame")
                dotWrap.AnchorPoint = Vector2.new(0, 0.5)
                dotWrap.Position = UDim2.new(0, 16, 0.5, 0)
                dotWrap.Size = UDim2.new(0, 10, 0, 10)
                dotWrap.BackgroundColor3 = Color3.fromRGB(255, 190, 11)
                dotWrap.BorderSizePixel = 0
                dotWrap.Parent = card

                local dotCorner = Instance.new("UICorner")
                dotCorner.CornerRadius = UDim.new(1, 0)
                dotCorner.Parent = dotWrap

                local dotPulse = Instance.new("Frame")
                dotPulse.AnchorPoint = Vector2.new(0.5, 0.5)
                dotPulse.Position = UDim2.new(0.5, 0, 0.5, 0)
                dotPulse.Size = UDim2.new(1, 0, 1, 0)
                dotPulse.BackgroundColor3 = Color3.fromRGB(255, 190, 11)
                dotPulse.BackgroundTransparency = 0.3
                dotPulse.BorderSizePixel = 0
                dotPulse.Parent = dotWrap

                local pulseCorner = Instance.new("UICorner")
                pulseCorner.CornerRadius = UDim.new(1, 0)
                pulseCorner.Parent = dotPulse

                local label = Instance.new("TextLabel")
                label.Name = "UpdateText"
                label.AnchorPoint = Vector2.new(0, 0.5)
                label.Position = UDim2.new(0, 36, 0.5, 0)
                label.Size = UDim2.new(1, -74, 0, 26)
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.GothamBold
                label.TextSize = 13
                label.TextColor3 = Color3.fromRGB(245, 247, 255)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.RichText = true
                label.Text = "<font color='#ffbe0b'>SCRIPT UPDATED!</font> Please re-execute to get the latest update."
                label.Parent = card

                local closeBtn = Instance.new("TextButton")
                closeBtn.Name = "CloseBtn"
                closeBtn.AnchorPoint = Vector2.new(1, 0.5)
                closeBtn.Position = UDim2.new(1, -10, 0.5, 0)
                closeBtn.Size = UDim2.new(0, 26, 0, 26)
                closeBtn.BackgroundColor3 = Color3.fromRGB(32, 30, 46)
                closeBtn.BackgroundTransparency = 0.2
                closeBtn.BorderSizePixel = 0
                closeBtn.Font = Enum.Font.GothamBold
                closeBtn.TextSize = 12
                closeBtn.TextColor3 = Color3.fromRGB(200, 205, 225)
                closeBtn.Text = "X"
                closeBtn.Parent = card

                local closeCorner = Instance.new("UICorner")
                closeCorner.CornerRadius = UDim.new(1, 0)
                closeCorner.Parent = closeBtn

                local boundsX = label.TextBounds.X
                if boundsX > 0 then
                    card.Size = UDim2.new(0, math.clamp(boundsX + 82, 380, 580), 0, 44)
                end

                local targetY = parentGui:FindFirstChild("YDX_LiveUsersBanner") and 66 or 18
                TweenService:Create(card, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0.5, 0, 0, targetY)
                }):Play()

                local dismissed = false
                closeBtn.MouseButton1Click:Connect(function()
                    if dismissed then return end
                    dismissed = true
                    if not card or not card.Parent then return end
                    local outTw = TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                        Position = UDim2.new(0.5, 0, 0, -80)
                    })
                    outTw:Play()
                    outTw.Completed:Wait()
                    if sg and sg.Parent then pcall(function() sg:Destroy() end) end
                end)

                task.spawn(function()
                    while sg.Parent and not dismissed do
                        dotPulse.Size = UDim2.new(1, 0, 1, 0)
                        dotPulse.BackgroundTransparency = 0.3
                        local tw = TweenService:Create(dotPulse, TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Size = UDim2.new(2.5, 0, 2.5, 0),
                            BackgroundTransparency = 1
                        })
                        tw:Play()
                        task.wait(1.1)
                    end
                end)
            end

            local function computeSig(s)
                if type(s) ~= "string" or #s < 32 then return nil end
                local clean = s:gsub("\r\n", "\n")
                local h = 2166136261
                local len = #clean
                local step = math.max(1, math.floor(len / 512))
                for i = 1, len, step do
                    h = (h * 16777619 + string.byte(clean, i)) % 4294967296
                end
                return tostring(len) .. ":" .. tostring(h)
            end

            local rawBase = "https://raw.githubusercontent.com/ydxvxdinc-art/ydx-script-vault/main/"
            local ghBase = "https://ydxvxdinc-art.github.io/ydx-script-vault/"
            local function fetchSigFrom(baseUrl)
                if not rPath then return nil end
                local cb = "?cb=" .. tostring(os.time()) .. "_" .. tostring(math.random(1000, 9999))
                local okR, body = pcall(function() return game:HttpGet(baseUrl .. rPath .. cb) end)
                if okR and type(body) == "string" and #body >= 64 then
                    return computeSig(body)
                end
                return nil
            end

            local rootStore = (type(shared) == "table" and shared) or _G
            rootStore.__YDX_KNOWN_SIGS = rootStore.__YDX_KNOWN_SIGS or {}
            env.__YDX_KNOWN_SIGS = rootStore.__YDX_KNOWN_SIGS
            local knownSigs = rootStore.__YDX_KNOWN_SIGS[sid] or {}
            rootStore.__YDX_KNOWN_SIGS[sid] = knownSigs

            local initGhSig = fetchSigFrom(ghBase)
            local initRawSig = fetchSigFrom(rawBase)
            if initGhSig then knownSigs[initGhSig] = true end
            if initRawSig then knownSigs[initRawSig] = true end

            local candidateSig = nil
            local candidateHits = 0

            while env.__YDX_UPDATE_WATCH_GEN[sid] == myGen do
                task.wait(30)
                if env.__YDX_UPDATE_WATCH_GEN[sid] ~= myGen then break end
                local ghSig = fetchSigFrom(ghBase)
                local rawSig = fetchSigFrom(rawBase)
                local newSig = nil
                if ghSig and not knownSigs[ghSig] and rawSig and not knownSigs[rawSig] and ghSig == rawSig then
                    newSig = ghSig
                end
                if newSig then
                    if candidateSig == newSig then
                        candidateHits = candidateHits + 1
                    else
                        candidateSig = newSig
                        candidateHits = 1
                    end
                    if candidateHits >= 2 then
                        knownSigs[newSig] = true
                        showUpdateBanner()
                        break
                    end
                else
                    candidateSig = nil
                    candidateHits = 0
                end
            end
        end)
    end
end
-- Scope: All Knives + Special Rigs (Chains/Balls/Hoverboard/IceSkates) + Combat/Run Anims + Audio + Mythic Kill FX + All Emotes

if type(_G.HussValleyCleanup) == "function" then
    pcall(_G.HussValleyCleanup)
end
_G.HussValleyUnlockAllLoaded = true

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    Players.PlayerAdded:Wait()
    LocalPlayer = Players.LocalPlayer
end

local ChickenOrHero = ReplicatedStorage:WaitForChild("ChickenOrHero", 30)
if not ChickenOrHero then
    warn("[HussValleyUnlockAll] ChickenOrHero not found!")
    return
end

local WeaponsFolder = ChickenOrHero:WaitForChild("Weapons", 20)
local EmotesFolder = ChickenOrHero:WaitForChild("Emotes", 20)
local BotsFolder = ChickenOrHero:WaitForChild("Bots", 20)
local PresentationFolder = ChickenOrHero:WaitForChild("Presentation", 20)
local AudioFolder = ChickenOrHero:FindFirstChild("Audio")

local ArmoryEvent = WeaponsFolder:WaitForChild("ArmoryEvent", 20)
local WeaponModels = WeaponsFolder:WaitForChild("Models", 20)
local MythicKillEvent = WeaponsFolder:FindFirstChild("MythicKillEvent")
local EmoteEvent = EmotesFolder:WaitForChild("EmoteEvent", 20)
local CaughtLoadoutEvent = PresentationFolder and PresentationFolder:FindFirstChild("CaughtLoadoutEvent")
local SpectateEvent = PresentationFolder and PresentationFolder:FindFirstChild("SpectateEvent")
local AudioEvents = AudioFolder and AudioFolder:FindFirstChild("Events")

local SkinCatalog = require(WeaponsFolder:WaitForChild("SkinCatalog"))
local KnifeVFXSetup = require(WeaponsFolder:WaitForChild("KnifeVFXSetup"))
local KnifeClips = require(WeaponsFolder:WaitForChild("KnifeClips"))
local KnifeVisibility = require(WeaponsFolder:WaitForChild("KnifeVisibility"))
local KnifeChains = require(WeaponsFolder:WaitForChild("KnifeChains"))
local KillEffectsOk, KillEffects = pcall(function()
    return require(WeaponsFolder:WaitForChild("KillEffects", 5))
end)
if not KillEffectsOk then KillEffects = nil end

local EmoteCatalog = require(EmotesFolder:WaitForChild("EmoteCatalog"))
local EmotePlayback = require(EmotesFolder:WaitForChild("EmotePlayback"))
local EmotePieces = require(EmotesFolder:WaitForChild("EmotePieces"))
local ClientBotKnife = require(BotsFolder:WaitForChild("ClientBotKnife"))

local getThreadIdentity = (syn and syn.get_thread_identity) or getthreadidentity or getidentity
local setThreadIdentity = (syn and syn.set_thread_identity) or setthreadidentity or setidentity

local function withNormalIdentity(fn, ...)
    if type(getThreadIdentity) == "function" and type(setThreadIdentity) == "function" then
        local okId, oldId = pcall(getThreadIdentity)
        if okId and type(oldId) == "number" and oldId > 2 then
            pcall(setThreadIdentity, 2)
            local okCall, res = pcall(fn, ...)
            pcall(setThreadIdentity, oldId)
            return okCall, res
        end
    end
    return pcall(fn, ...)
end

local S = {
    alive = true,
    connections = {},
    presetFile = "hussvalley_saved_preset.json",
    equippedKnife = SkinCatalog.Default or "BaseDagger",
    emoteSlots = { "IdleDance", "Jumpstyle", "Shuffle", "CatDance", "Moongazer", "KnifeJuggle" },
    activeEmote = "",
    activeEmoteAt = 0,
    coins = 0,
    gems = 0,
    lastServerState = nil,
    serverOwnedKnives = {},
    serverOwnedEmotes = {},
    allOwnedKnives = {},
    allOwnedEmotes = {},
    kindFallback = {},
    dualFallback = "GrinnerBlades",
    charControllers = {},
    p2pPeers = {},
    seenIds = {},
    lastBroadcastHash = "",
    lastBroadcastTime = 0,
    applyingState = false,
    myArmoryConnFn = nil,
    myMythicConnFn = nil,
    defaultClipIds = {},
    mythicCooldowns = {},
    lastHitCatcherByPos = nil
}

local function trackConn(conn)
    if conn then
        table.insert(S.connections, conn)
    end
    return conn
end

for actionName in pairs(KnifeClips.Actions) do
    local clipId = KnifeClips.default(actionName)
    if clipId then
        S.defaultClipIds[clipId] = actionName
    end
end

local function unfreezeTable(t)
    if type(t) ~= "table" then return end
    if type(setreadonly) == "function" then
        pcall(setreadonly, t, false)
    end
end

-- ============================================================
-- 1. UNLOCK SKINCATALOG & EMOTECATALOG
-- ============================================================
do
    unfreezeTable(SkinCatalog)
    if type(SkinCatalog.Skins) == "table" then
        unfreezeTable(SkinCatalog.Skins)
    end

    for _, skinId in ipairs(SkinCatalog.Order or {}) do
        S.allOwnedKnives[skinId] = true
        local rawDef = SkinCatalog.get(skinId)
        if type(rawDef) == "table" then
            unfreezeTable(rawDef)
            pcall(function()
                rawDef.Hide = false
                rawDef.EquipReady = true
            end)

            local modelInst = rawDef.Model and WeaponModels:FindFirstChild(rawDef.Model)
            if modelInst then
                local kind = modelInst:GetAttribute("KnifeKind")
                if type(kind) == "string" and kind ~= "" and not S.kindFallback[kind] then
                    S.kindFallback[kind] = skinId
                end
                if modelInst:GetAttribute("IsDualWield") == true and S.dualFallback == "GrinnerBlades" then
                    S.dualFallback = skinId
                end
            end
        end
    end
    S.kindFallback["Karambit"] = S.kindFallback["Karambit"] or "Karambit"
    S.kindFallback["Kusarigama"] = S.kindFallback["Kusarigama"] or "VoidKusarigama"
    S.kindFallback["Kitsune"] = S.kindFallback["Kitsune"] or "ImmortalKitsune"
end

local function resolveEmotePropSkin(emoteId, equippedSkinId)
    local entry = EmoteCatalog.get(emoteId)
    if not (entry and entry.Prop) then
        return nil
    end
    local skinId = (type(equippedSkinId) == "string" and equippedSkinId ~= "" and equippedSkinId) or S.equippedKnife
    if entry.Prop ~= "Equipped" then
        return entry.Prop
    end
    if entry.Kind then
        local curKind = EmoteCatalog.knifeKind(skinId)
        local playsWithList = entry.PlaysWith or {}
        if curKind ~= entry.Kind and not table.find(playsWithList, skinId) then
            if entry.Knife and SkinCatalog.get(entry.Knife) then
                return entry.Knife
            end
            if type(entry.UnlockedBy) == "table" and entry.UnlockedBy[1] then
                return entry.UnlockedBy[1]
            end
            if S.kindFallback[entry.Kind] then
                return S.kindFallback[entry.Kind]
            end
        end
    end
    if entry.PropDual and not EmoteCatalog.dualWield(skinId) then
        return entry.Knife or S.dualFallback
    end
    return skinId
end

do
    unfreezeTable(EmoteCatalog)
    pcall(function()
        EmoteCatalog.ComingSoon = false
        EmoteCatalog.Enabled = true
    end)

    for _, entry in ipairs(EmoteCatalog.Entries or {}) do
        if type(entry) == "table" and type(entry.Id) == "string" then
            unfreezeTable(entry)
            pcall(function()
                entry.TestHidden = false
            end)
            S.allOwnedEmotes[entry.Id] = true
        end
    end

    local origEmoteAvailable = EmoteCatalog.available

    local function newEmoteOwned(emoteId, _state)
        local entry = EmoteCatalog.get(emoteId)
        if not entry or entry.Ultimate then
            return false
        end
        return true
    end

    local function newEmoteAvailable(emoteId)
        if EmoteCatalog.assetId(emoteId) ~= nil then
            return true
        end
        if type(origEmoteAvailable) == "function" then
            return origEmoteAvailable(emoteId)
        end
        return true
    end

    local function newEmotePlaysWith(emoteId, _knifeId)
        return EmoteCatalog.get(emoteId) ~= nil
    end

    local function newEmoteProp(emoteId, knifeId)
        local entry = EmoteCatalog.get(emoteId)
        if not (entry and entry.Prop) then
            return nil
        end
        return resolveEmotePropSkin(emoteId, knifeId)
    end

    pcall(function()
        EmoteCatalog.owned = newEmoteOwned
        EmoteCatalog.available = newEmoteAvailable
        EmoteCatalog.playsWith = newEmotePlaysWith
        EmoteCatalog.prop = newEmoteProp
    end)
end

-- ============================================================
-- 2. PRESET SAVE / LOAD
-- ============================================================
local function saveLocalPreset()
    if type(writefile) ~= "function" then return end
    pcall(function()
        local payload = HttpService:JSONEncode({
            knife = S.equippedKnife,
            emoteSlots = S.emoteSlots
        })
        writefile(S.presetFile, payload)
    end)
end

local function loadLocalPreset()
    if type(isfile) ~= "function" or type(readfile) ~= "function" then return end
    pcall(function()
        if not isfile(S.presetFile) then return end
        local raw = readfile(S.presetFile)
        if type(raw) ~= "string" or raw == "" then return end
        local data = HttpService:JSONDecode(raw)
        if type(data) ~= "table" then return end
        if type(data.knife) == "string" and S.allOwnedKnives[data.knife] then
            S.equippedKnife = data.knife
        end
        if type(data.emoteSlots) == "table" then
            for i = 1, 6 do
                local em = data.emoteSlots[i]
                if type(em) == "string" and (em == "" or S.allOwnedEmotes[em]) then
                    S.emoteSlots[i] = em
                end
            end
        end
    end)
end

loadLocalPreset()

-- ============================================================
-- 3. ARMORY & EMOTE WHEEL STATE INJECTION (PRESERVING ALL SERVER FIELDS)
-- ============================================================
local function patchStateTableInPlace(st)
    if type(st) ~= "table" then return st end
    unfreezeTable(st)

    if not st._ydxPatched then
        if type(st.coins) == "number" then S.coins = st.coins end
        if type(st.gems) == "number" then S.gems = st.gems end
        if type(st.owned) == "table" then
            for k, v in pairs(st.owned) do
                if v == true then S.serverOwnedKnives[k] = true end
            end
        end
        if type(st.emotes) == "table" then
            for k, v in pairs(st.emotes) do
                if v == true then S.serverOwnedEmotes[k] = true end
            end
        end
    end

    st._ydxPatched = true
    st.loaded = true
    st.pending = false
    if type(st.coins) ~= "number" then st.coins = S.coins end
    if type(st.gems) ~= "number" then st.gems = S.gems end

    if type(st.owned) ~= "table" then
        st.owned = {}
    else
        unfreezeTable(st.owned)
    end
    for k in pairs(S.allOwnedKnives) do
        st.owned[k] = true
    end

    if type(st.emotes) ~= "table" then
        st.emotes = {}
    else
        unfreezeTable(st.emotes)
    end
    for k in pairs(S.allOwnedEmotes) do
        st.emotes[k] = true
    end

    if type(st.emoteSlots) ~= "table" then
        st.emoteSlots = {}
    else
        unfreezeTable(st.emoteSlots)
    end
    for i = 1, 6 do
        st.emoteSlots[i] = S.emoteSlots[i] or ""
    end

    st.equipped = S.equippedKnife

    if type(st.knifeStacks) ~= "table" then st.knifeStacks = {} end
    if type(st.freeCrates) ~= "table" then st.freeCrates = {} end
    if type(st.abilities) ~= "table" then st.abilities = {} end
    if type(st.abilityLevels) ~= "table" then st.abilityLevels = {} end
    if type(st.abilityTokens) ~= "table" then st.abilityTokens = {} end
    if type(st.equippedAbilities) ~= "table" then st.equippedAbilities = {} end
    if type(st.gear) ~= "table" then st.gear = {} end
    if type(st.ranked) ~= "table" then st.ranked = {} end

    S.lastServerState = st
    return st
end

local function findExistingClientState()
    if type(S.lastServerState) == "table" then
        return S.lastServerState
    end
    if type(getconnections) == "function" and type(debug) == "table" and type(debug.getupvalues) == "function" then
        for _, conn in ipairs(getconnections(ArmoryEvent.OnClientEvent)) do
            if conn.Function and conn.Function ~= S.myArmoryConnFn then
                local ok, ups = pcall(debug.getupvalues, conn.Function)
                if ok and type(ups) == "table" then
                    for _, upv in pairs(ups) do
                        if type(upv) == "table" then
                            if type(upv.owned) == "table" and type(upv.emotes) == "table" and upv.loaded ~= nil then
                                return upv
                            elseif type(upv.state) == "table" and type(upv.state.owned) == "table" then
                                return upv.state
                            end
                        end
                    end
                end
            end
        end
    end
    return {}
end

local function buildPatchedState(baseState)
    local source = type(baseState) == "table" and baseState or findExistingClientState()
    local clone = {}
    if type(S.lastServerState) == "table" then
        for k, v in pairs(S.lastServerState) do
            clone[k] = v
        end
    end
    if type(source) == "table" then
        for k, v in pairs(source) do
            if k ~= "_ydxPatched" then
                clone[k] = v
            end
        end
    end
    if type(baseState) == "table" then
        patchStateTableInPlace(baseState)
    end
    return patchStateTableInPlace(clone)
end

local function pushArmoryState(baseState)
    if S.applyingState then return end
    S.applyingState = true

    local patched = buildPatchedState(baseState)

    pcall(function()
        LocalPlayer:SetAttribute("EquippedKnife", S.equippedKnife)
        LocalPlayer:SetAttribute("IceSkates", S.equippedKnife == "IceSkate")
    end)

    if type(getconnections) == "function" then
        for _, conn in ipairs(getconnections(ArmoryEvent.OnClientEvent)) do
            local fn = conn.Function
            if fn and fn ~= S.myArmoryConnFn then
                if type(debug) == "table" and type(debug.getupvalues) == "function" then
                    local ok, ups = pcall(debug.getupvalues, fn)
                    if ok and type(ups) == "table" then
                        for _, upv in pairs(ups) do
                            if type(upv) == "table" and type(upv.build) == "function" and upv.state ~= nil then
                                upv.state = patched
                                if upv.built == true and upv.live ~= true then
                                    upv.built = false
                                end
                            end
                        end
                    end
                end
                withNormalIdentity(fn, "State", patched)
            end
        end
    end

    S.applyingState = false
end

local function fireEmoteClientEvent(action, payload)
    if type(getconnections) ~= "function" then return end
    for _, conn in ipairs(getconnections(EmoteEvent.OnClientEvent)) do
        if conn.Function then
            withNormalIdentity(conn.Function, action, payload)
        end
    end
end

-- ============================================================
-- 4. 3D KNIFE, SPECIAL RIGS, COMBAT ANIMS & EMOTE ENGINE (LOCAL + P2P PEERS)
-- ============================================================
local function syncKnifeLocomotionAttributes(character, weaponModel, isHeld)
    if not character then return end
    if not weaponModel then
        character:SetAttribute("KnifeRun", nil)
        character:SetAttribute("KnifeRunDirs", nil)
        character:SetAttribute("KnifeIdle", nil)
        character:SetAttribute("KnifeDash", nil)
        character:SetAttribute("KnifeRide", nil)
        return
    end

    local matchCarry = weaponModel:GetAttribute("MatchCarry")
    local isRide = (matchCarry == "Ride")
    local isRoot = (matchCarry == "Root")
    local runWhenHeld = weaponModel:GetAttribute("RunWhenHeld") == true

    local activeForLocomotion = false
    if isRide then
        activeForLocomotion = true
    elseif isRoot then
        activeForLocomotion = not isHeld
    elseif runWhenHeld then
        activeForLocomotion = isHeld
    else
        activeForLocomotion = isHeld
    end

    local runAnim = activeForLocomotion and weaponModel:GetAttribute("RunAnim") or nil
    local runLeft = activeForLocomotion and weaponModel:GetAttribute("RunLeftAnim") or nil
    local runRight = activeForLocomotion and weaponModel:GetAttribute("RunRightAnim") or nil
    local runBack = activeForLocomotion and weaponModel:GetAttribute("RunBackAnim") or nil
    local runDirs = nil
    if type(runLeft) == "string" and runLeft ~= ""
        and type(runRight) == "string" and runRight ~= ""
        and type(runBack) == "string" and runBack ~= "" then
        runDirs = runLeft .. "|" .. runRight .. "|" .. runBack
    end

    local idleAnim = activeForLocomotion and weaponModel:GetAttribute("IdleAnim") or nil
    local dashAnim = activeForLocomotion and weaponModel:GetAttribute("DashAnim") or nil

    if character:GetAttribute("KnifeRun") ~= runAnim then
        character:SetAttribute("KnifeRun", runAnim)
    end
    if character:GetAttribute("KnifeRunDirs") ~= runDirs then
        character:SetAttribute("KnifeRunDirs", runDirs)
    end
    if character:GetAttribute("KnifeIdle") ~= idleAnim then
        character:SetAttribute("KnifeIdle", idleAnim)
    end
    if character:GetAttribute("KnifeDash") ~= dashAnim then
        character:SetAttribute("KnifeDash", dashAnim)
    end
    local rideAttr = isRide and true or nil
    if character:GetAttribute("KnifeRide") ~= rideAttr then
        character:SetAttribute("KnifeRide", rideAttr)
    end
end

local function clearCustomCombatTracks(ctrl)
    if not ctrl or type(ctrl.customTracks) ~= "table" then return end
    for _, entry in pairs(ctrl.customTracks) do
        if entry.track then
            pcall(function() entry.track:Stop(0) end)
            pcall(function() entry.track:Destroy() end)
        end
        if entry.anim then
            pcall(function() entry.anim:Destroy() end)
        end
    end
    table.clear(ctrl.customTracks)
end

local function playCustomCombatTrack(ctrl, animator, weaponModel, actionName, speedOverride)
    if not (ctrl and animator and weaponModel and actionName) then return nil end
    local customClip = KnifeClips.custom(weaponModel, actionName)
    if type(customClip) ~= "string" or customClip == "" then return nil end

    ctrl.customTracks = ctrl.customTracks or {}
    local existing = ctrl.customTracks[actionName]
    if existing and existing.clipId ~= customClip then
        if existing.track then
            pcall(function() existing.track:Stop(0) end)
            pcall(function() existing.track:Destroy() end)
        end
        if existing.anim then
            pcall(function() existing.anim:Destroy() end)
        end
        existing = nil
        ctrl.customTracks[actionName] = nil
    end

    if not existing then
        local def = KnifeClips.Actions[actionName]
        local anim = Instance.new("Animation")
        anim.Name = "YDXKnife_" .. actionName
        anim.AnimationId = customClip
        local okLoad, tr = pcall(function()
            return animator:LoadAnimation(anim)
        end)
        if not okLoad or not tr then
            anim:Destroy()
            return nil
        end
        if def then
            pcall(function()
                tr.Priority = def.Priority
                tr.Looped = def.Looped
            end)
        end
        existing = {
            clipId = customClip,
            anim = anim,
            track = tr
        }
        ctrl.customTracks[actionName] = existing
    end

    local tr = existing.track
    if tr and not tr.IsPlaying then
        local def = KnifeClips.Actions[actionName]
        local fade = (def and def.FadeIn) or 0.05
        local spd = speedOverride or (def and def.Speed) or 1
        pcall(function()
            tr:Play(fade, 1, spd)
        end)
    end
    return tr
end

local function stopCustomCombatTrack(ctrl, actionName, fadeOut)
    if not (ctrl and ctrl.customTracks and ctrl.customTracks[actionName]) then return end
    local tr = ctrl.customTracks[actionName].track
    if tr and tr.IsPlaying then
        pcall(function()
            tr:Stop(fadeOut or 0.06)
        end)
    end
end

local function getOrCreateController(plr, character)
    local ctrl = S.charControllers[character]
    if ctrl and ctrl.character == character then
        return ctrl
    end
    ctrl = {
        player = plr,
        character = character,
        botKnife = nil,
        currentModelName = nil,
        rootPart = nil,
        rootMotor = nil,
        chainFollowers = nil,
        customTracks = {},
        lastReachPhase = nil,
        lastReachStartedAt = nil,
        lastTackleStartedAt = nil,
        emoteId = "",
        emoteAt = 0,
        introTrack = nil,
        loopTrack = nil,
        emotePieces = {},
        emoteSounds = {},
        emoteConnections = {}
    }
    S.charControllers[character] = ctrl
    return ctrl
end

local function cleanupControllerWeaponExtras(ctrl)
    if not ctrl then return end
    clearCustomCombatTracks(ctrl)
    if ctrl.rootMotor then
        pcall(function() ctrl.rootMotor:Destroy() end)
        ctrl.rootMotor = nil
    end
    ctrl.rootPart = nil
    ctrl.chainFollowers = nil
end

local function clearControllerEmote(ctrl, keepAttributes)
    if not ctrl then return end
    for _, conn in ipairs(ctrl.emoteConnections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(ctrl.emoteConnections)

    if ctrl.introTrack then
        pcall(EmotePlayback.dispose, ctrl.introTrack)
        ctrl.introTrack = nil
    end
    if ctrl.loopTrack then
        pcall(EmotePlayback.dispose, ctrl.loopTrack)
        ctrl.loopTrack = nil
    end
    if #ctrl.emotePieces > 0 then
        pcall(EmotePieces.clear, ctrl.emotePieces)
    end
    for _, snd in ipairs(ctrl.emoteSounds) do
        pcall(function() snd:Destroy() end)
    end
    table.clear(ctrl.emoteSounds)

    ctrl.emoteId = ""
    ctrl.emoteAt = 0

    local character = ctrl.character
    if character and character.Parent then
        pcall(EmotePieces.strip, character)
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, ch in ipairs(hrp:GetChildren()) do
                if ch:IsA("Sound") and (ch.Name == "EmoteSound" or ch.Name == "EmoteSoundExtra") then
                    pcall(function() ch:Destroy() end)
                end
            end
        end
        if not keepAttributes then
            character:SetAttribute("EmoteId", nil)
            character:SetAttribute("EmoteStartedAt", nil)
            character:SetAttribute("EmoteProp", nil)
        end
    end
end

local function resolveDesiredStateForPlayer(plr)
    if not plr then return nil, nil, nil end
    if plr == LocalPlayer then
        return S.equippedKnife, S.activeEmote, S.activeEmoteAt
    end
    local peer = S.p2pPeers[tostring(plr.UserId)]
    if peer then
        return peer.knife, peer.emote or "", peer.emoteAt or 0
    end
    return nil, nil, nil
end

local function setupSpecialWeaponAttachments(ctrl, character, weapon)
    if not (ctrl and character and weapon) then return end

    if KnifeChains and type(KnifeChains.has) == "function" and KnifeChains.has(weapon) then
        local okF, followers = pcall(KnifeChains.followers, weapon, character)
        if okF and type(followers) == "table" then
            ctrl.chainFollowers = followers
            pcall(KnifeChains.place, followers)
        end
    end

    local rootPartName = weapon:GetAttribute("RootPart")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if type(rootPartName) == "string" and rootPartName ~= "" and hrp and hrp:IsA("BasePart") then
        local rootFolderName = weapon:GetAttribute("RootFolder")
        local container = (type(rootFolderName) == "string" and rootFolderName ~= "" and weapon:FindFirstChild(rootFolderName)) or weapon
        local rootPart = container and container:FindFirstChild(rootPartName)
        if rootPart and rootPart:IsA("BasePart") then
            local rootStow = rootPart:FindFirstChild("RootStow")
            if rootStow then
                pcall(function() rootStow:Destroy() end)
            end
            local oldMotor = hrp:FindFirstChild(rootPartName)
            if oldMotor and oldMotor:IsA("Motor6D") then
                pcall(function() oldMotor:Destroy() end)
            end

            for _, desc in ipairs(container:GetDescendants()) do
                if desc:IsA("BasePart") then
                    desc.Anchored = false
                    desc.CanCollide = false
                    desc.CanTouch = false
                    desc.CanQuery = false
                    desc.Massless = true
                end
            end

            local motor = Instance.new("Motor6D")
            motor.Name = rootPartName
            motor.Part0 = hrp
            motor.Part1 = rootPart
            local c0 = weapon:GetAttribute("RootC0")
            local c1 = weapon:GetAttribute("RootC1")
            motor.C0 = typeof(c0) == "CFrame" and c0 or CFrame.identity
            motor.C1 = typeof(c1) == "CFrame" and c1 or CFrame.identity
            local restCf = weapon:GetAttribute("RootRest")
            if typeof(restCf) == "CFrame" then
                motor:SetAttribute("Rest", restCf)
            end
            motor.Parent = hrp

            ctrl.rootPart = rootPart
            ctrl.rootMotor = motor
        end
    end
end

local function ensureCustomKnifeOnCharacter(plr, character)
    if not (plr and character and character.Parent) then return nil end
    local targetKnifeId, activeEmoteId = resolveDesiredStateForPlayer(plr)
    if not targetKnifeId or not S.allOwnedKnives[targetKnifeId] then
        return nil
    end

    local hum = character:FindFirstChildOfClass("Humanoid")
    local rightArm = character:FindFirstChild("Right Arm")
    local torso = character:FindFirstChild("Torso")
    if not (hum and rightArm and torso) then
        return nil
    end

    local effectiveSkinId = targetKnifeId
    if type(activeEmoteId) == "string" and activeEmoteId ~= "" then
        local propSkin = resolveEmotePropSkin(activeEmoteId, targetKnifeId)
        if type(propSkin) == "string" and propSkin ~= "" then
            effectiveSkinId = propSkin
        end
    end

    local skinDef = SkinCatalog.get(effectiveSkinId)
    local modelName = (skinDef and skinDef.Model) or effectiveSkinId
    if not WeaponModels:FindFirstChild(modelName) then
        modelName = SkinCatalog.Default or "BaseDagger"
    end

    pcall(function()
        if plr:GetAttribute("EquippedKnife") ~= targetKnifeId then
            plr:SetAttribute("EquippedKnife", targetKnifeId)
        end
        local wantSkates = (targetKnifeId == "IceSkate")
        if plr:GetAttribute("IceSkates") ~= wantSkates then
            plr:SetAttribute("IceSkates", wantSkates)
        end
        if character:GetAttribute("DaggerSkin") ~= effectiveSkinId then
            character:SetAttribute("DaggerSkin", effectiveSkinId)
        end
        if character:GetAttribute("DaggerEquipped") == nil then
            character:SetAttribute("DaggerEquipped", true)
        end
    end)

    for _, child in ipairs(character:GetChildren()) do
        if child.Name == "EquippedDagger" and child:GetAttribute("_YDXModel") ~= modelName then
            pcall(function() child:Destroy() end)
        end
    end

    local ctrl = getOrCreateController(plr, character)
    if ctrl.botKnife and ctrl.botKnife.weapon and ctrl.botKnife.weapon.Parent == character and ctrl.currentModelName == modelName then
        return ctrl
    end

    cleanupControllerWeaponExtras(ctrl)
    if ctrl.botKnife then
        pcall(function() ctrl.botKnife:remove() end)
        ctrl.botKnife = nil
    end

    local bk = ClientBotKnife.new(character, nil, modelName)
    local created = bk:create(modelName)
    if created and bk.weapon then
        bk.weapon:SetAttribute("_YDXModel", modelName)
        pcall(KnifeVFXSetup.apply, bk.weapon)
        ctrl.botKnife = bk
        ctrl.currentModelName = modelName
        setupSpecialWeaponAttachments(ctrl, character, bk.weapon)
    end

    return ctrl
end

local function startCharacterEmote(plr, character, emoteId, startedAt)
    if not (plr and character and character.Parent) then return end
    local entry = EmoteCatalog.get(emoteId)
    if not entry then return end

    local hum = character:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildOfClass("Animator")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not (animator and hrp) then return end

    local ctrl = getOrCreateController(plr, character)
    clearControllerEmote(ctrl, true)

    local stamp = (type(startedAt) == "number" and startedAt > 0 and startedAt) or workspace:GetServerTimeNow()
    ctrl.emoteId = emoteId
    ctrl.emoteAt = stamp

    local targetKnifeId = resolveDesiredStateForPlayer(plr)
    local propSkin = resolveEmotePropSkin(emoteId, targetKnifeId or S.equippedKnife)

    pcall(function()
        if not CollectionService:HasTag(character, "EmoteVFXRig") then
            CollectionService:AddTag(character, "EmoteVFXRig")
        end
        character:SetAttribute("EmoteProp", propSkin)
        character:SetAttribute("EmoteStartedAt", stamp)
        character:SetAttribute("EmoteId", emoteId)
    end)

    ensureCustomKnifeOnCharacter(plr, character)

    if type(entry.Pieces) == "table" and #entry.Pieces > 0 then
        local propDef = propSkin and SkinCatalog.get(propSkin)
        local propModelName = (propDef and propDef.Model) or propSkin or S.equippedKnife
        local propModel = WeaponModels:FindFirstChild(propModelName) or (ctrl.botKnife and ctrl.botKnife.weapon)
        local ok, built = pcall(EmotePieces.build, character, entry, propModel, character)
        if ok and type(built) == "table" then
            ctrl.emotePieces = built
        end
    end

    local introTrack = EmotePlayback.intro(animator, emoteId)
    local loopTrack = EmotePlayback.load(animator, emoteId)
    ctrl.introTrack = introTrack
    ctrl.loopTrack = loopTrack

    local function playExtrasForLoop()
        if ctrl.emoteId ~= emoteId or not hrp.Parent then return end
        local ids, vols, delays = EmoteCatalog.soundIds(emoteId)
        for i = 2, #ids do
            local d = delays[i]
            local sid = ids[i]
            local vol = vols[i] or 0.25
            local function spawnExtra()
                if ctrl.emoteId ~= emoteId or not hrp.Parent then return end
                local s = Instance.new("Sound")
                s.Name = "EmoteSoundExtra"
                s.SoundId = sid
                s.Volume = vol
                s:SetAttribute("EmoteBaseVolume", vol)
                s:SetAttribute("EmoteEffects", true)
                s.Looped = false
                s.RollOffMaxDistance = 80
                s.Parent = hrp
                s:Play()
                table.insert(ctrl.emoteSounds, s)
            end
            if type(d) == "number" and d > 0 then
                task.delay(d, spawnExtra)
            else
                spawnExtra()
            end
        end
    end

    local ids, vols = EmoteCatalog.soundIds(emoteId)
    local mainSound = nil
    if ids[1] then
        mainSound = Instance.new("Sound")
        mainSound.Name = "EmoteSound"
        mainSound.SoundId = ids[1]
        local baseVol = vols[1] or 0.25
        mainSound.Volume = baseVol
        mainSound:SetAttribute("EmoteBaseVolume", baseVol)
        mainSound:SetAttribute("EmoteEffects", entry.SoundEffects == true)
        mainSound.Looped = not (entry.SoundEachLoop == true)
        mainSound.RollOffMaxDistance = 80
        mainSound.Parent = hrp
        table.insert(ctrl.emoteSounds, mainSound)

        local sDelay = tonumber(entry.SoundDelay) or 0
        if sDelay > 0 then
            task.delay(sDelay, function()
                if ctrl.emoteId == emoteId and mainSound.Parent then
                    mainSound:Play()
                end
            end)
        else
            mainSound:Play()
        end
    end

    if loopTrack then
        table.insert(ctrl.emoteConnections, loopTrack.DidLoop:Connect(function()
            if ctrl.emoteId ~= emoteId then return end
            if entry.SoundEachLoop and mainSound and mainSound.Parent then
                local sDelay = tonumber(entry.SoundDelay) or 0
                if sDelay > 0 then
                    task.delay(sDelay, function()
                        if ctrl.emoteId == emoteId and mainSound.Parent then
                            mainSound.TimePosition = 0
                            mainSound:Play()
                        end
                    end)
                else
                    mainSound.TimePosition = 0
                    mainSound:Play()
                end
            end
            playExtrasForLoop()
        end))
    end

    if introTrack then
        introTrack:Play(0.12)
        playExtrasForLoop()
        table.insert(ctrl.emoteConnections, introTrack.Stopped:Connect(function()
            if ctrl.emoteId == emoteId and loopTrack then
                loopTrack:Play(0.1)
            end
        end))
    elseif loopTrack then
        loopTrack:Play(0.15)
        playExtrasForLoop()
    end

    if plr == LocalPlayer then
        fireEmoteClientEvent("Playing")
    end
end

local function stopCharacterEmote(plr, character)
    local ctrl = character and S.charControllers[character]
    if ctrl then
        clearControllerEmote(ctrl, false)
    elseif character then
        character:SetAttribute("EmoteId", nil)
        character:SetAttribute("EmoteStartedAt", nil)
        character:SetAttribute("EmoteProp", nil)
    end
    if plr and character and character.Parent then
        ensureCustomKnifeOnCharacter(plr, character)
    end
end

local function updateRemoteCombatAnims(plr, ch, ctrl, animator, weapon)
    if not (plr and ch and ctrl and animator and weapon) then return end

    for _, tr in ipairs(animator:GetPlayingAnimationTracks()) do
        local animId = tr.Animation and tr.Animation.AnimationId
        local actionName = animId and S.defaultClipIds[animId]
        if actionName then
            local customClip = KnifeClips.custom(weapon, actionName)
            if customClip and customClip ~= animId then
                local trSpd = tr.Speed
                pcall(function() tr:Stop(0) end)
                if plr ~= LocalPlayer or actionName == "Dive" then
                    playCustomCombatTrack(ctrl, animator, weapon, actionName, trSpd)
                end
            end
        end
    end

    if plr == LocalPlayer then
        return
    end

    local reachPhase = ch:GetAttribute("ReachPhase")
    local reachStartedAt = ch:GetAttribute("ReachStartedAt")
    local tackleStartedAt = ch:GetAttribute("TackleStartedAt")
    local tackleActive = ch:GetAttribute("TackleActive") == true

    if reachPhase ~= ctrl.lastReachPhase or reachStartedAt ~= ctrl.lastReachStartedAt then
        local prevPhase = ctrl.lastReachPhase
        ctrl.lastReachPhase = reachPhase
        ctrl.lastReachStartedAt = reachStartedAt

        if reachPhase == "Windup" then
            stopCustomCombatTrack(ctrl, "Stab", 0.03)
            playCustomCombatTrack(ctrl, animator, weapon, "Windup")
        elseif reachPhase == "Active" or reachPhase == "Lunge" or (prevPhase == "Windup" and reachPhase ~= nil) then
            stopCustomCombatTrack(ctrl, "Windup", 0.03)
            playCustomCombatTrack(ctrl, animator, weapon, "Stab")
        elseif reachPhase == nil and prevPhase == "Windup" then
            stopCustomCombatTrack(ctrl, "Windup", 0.04)
            playCustomCombatTrack(ctrl, animator, weapon, "Stab")
        elseif reachPhase == nil then
            stopCustomCombatTrack(ctrl, "Windup", 0.05)
        end
    end

    if tackleStartedAt ~= ctrl.lastTackleStartedAt then
        ctrl.lastTackleStartedAt = tackleStartedAt
        if tackleStartedAt ~= nil or tackleActive then
            playCustomCombatTrack(ctrl, animator, weapon, "Dive")
        end
    elseif not tackleActive then
        stopCustomCombatTrack(ctrl, "Dive", 0.1)
    end
end

trackConn(RunService.PreSimulation:Connect(function()
    if not S.alive then return end
    local now = workspace:GetServerTimeNow()

    if S.activeEmote ~= "" and LocalPlayer.Character then
        local ch = LocalPlayer.Character
        local dState = ch:GetAttribute("DaggerState")
        if ch:GetAttribute("Ragdolled") == true
            or LocalPlayer:GetAttribute("RunState") == "Caught"
            or dState == "Drawing"
            or dState == "Held" then
            S.activeEmote = ""
            S.activeEmoteAt = 0
            stopCharacterEmote(LocalPlayer, ch)
            if type(S.broadcastMyState) == "function" then
                S.broadcastMyState(true)
            end
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        local ch = plr.Character
        local targetKnifeId, targetEmoteId, targetEmoteAt = resolveDesiredStateForPlayer(plr)
        if ch and ch.Parent and targetKnifeId then
            local ctrl = ensureCustomKnifeOnCharacter(plr, ch)
            if ctrl then
                if type(targetEmoteId) == "string" and targetEmoteId ~= "" then
                    if ctrl.emoteId ~= targetEmoteId or (plr ~= LocalPlayer and math.abs((ctrl.emoteAt or 0) - (targetEmoteAt or 0)) > 0.5) then
                        startCharacterEmote(plr, ch, targetEmoteId, targetEmoteAt)
                    end
                elseif ctrl.emoteId ~= "" then
                    stopCharacterEmote(plr, ch)
                end

                local bk = ctrl.botKnife
                if bk and bk.weapon and bk.weapon.Parent == ch then
                    local matchCarry = bk.weapon:GetAttribute("MatchCarry")
                    local dState = ch:GetAttribute("DaggerState")
                    local isHeld = (dState == "Held" or dState == "Drawing")

                    if ctrl.emoteId ~= "" then
                        local entry = EmoteCatalog.get(ctrl.emoteId)
                        if entry and entry.HideProp == true then
                            bk:hide()
                        elseif entry and entry.Prop ~= nil then
                            local holdArm = not EmoteCatalog.holdsIdle(entry.Id, bk.skin) and "Right Arm" or nil
                            bk:show(true, holdArm)
                        else
                            bk:show(false)
                        end
                        if ctrl.rootPart then
                            pcall(KnifeVisibility.set, ctrl.rootPart, false)
                        end
                        syncKnifeLocomotionAttributes(ch, bk.weapon, false)
                    else
                        bk:update(now, true)
                        syncKnifeLocomotionAttributes(ch, bk.weapon, isHeld)

                        if ctrl.rootPart then
                            if matchCarry == "Ride" then
                                pcall(KnifeVisibility.set, ctrl.rootPart, true)
                                if not isHeld and bk.stowed then
                                    pcall(KnifeVisibility.set, bk.stowed, false)
                                end
                            elseif matchCarry == "Root" then
                                local showRoot = not isHeld
                                pcall(KnifeVisibility.set, ctrl.rootPart, showRoot)
                                if showRoot and bk.stowed then
                                    pcall(KnifeVisibility.set, bk.stowed, false)
                                end
                            end
                        end

                        local hum = ch:FindFirstChildOfClass("Humanoid")
                        local animator = hum and hum:FindFirstChildOfClass("Animator")
                        if animator then
                            updateRemoteCombatAnims(plr, ch, ctrl, animator, bk.weapon)
                        end
                    end

                    if ctrl.chainFollowers then
                        pcall(KnifeChains.place, ctrl.chainFollowers)
                    end
                end
            end
        end
    end

    for ch, ctrl in pairs(S.charControllers) do
        if not ch.Parent then
            clearControllerEmote(ctrl, true)
            cleanupControllerWeaponExtras(ctrl)
            if ctrl.botKnife then
                pcall(function() ctrl.botKnife:destroy() end)
            end
            S.charControllers[ch] = nil
        end
    end
end))

-- ============================================================
-- 5. MYTHIC KILL FX & CUSTOM AUDIO HIT HOOKS (LOCAL + P2P PEERS)
-- ============================================================
local function isMythicKnife(skinId)
    if type(skinId) ~= "string" or skinId == "" then return false end
    local def = SkinCatalog.get(skinId)
    if def and def.Rarity == "Mythical" then
        return true
    end
    if KillEffects and type(KillEffects.select) == "function" then
        local ok, sel = pcall(KillEffects.select, skinId)
        if ok and sel ~= nil then
            return true
        end
    end
    return false
end

local function fireLocalMythicKill(victimUserId, skinId, catcherPlr)
    if not (MythicKillEvent and type(getconnections) == "function" and victimUserId and isMythicKnife(skinId)) then
        return
    end
    local now = os.clock()
    if S.mythicCooldowns[victimUserId] and (now - S.mythicCooldowns[victimUserId]) < 2.5 then
        return
    end
    S.mythicCooldowns[victimUserId] = now

    local catcherInfo = nil
    if typeof(catcherPlr) == "Instance" and catcherPlr:IsA("Player") then
        catcherInfo = {
            name = catcherPlr.DisplayName or catcherPlr.Name,
            userId = catcherPlr.UserId
        }
    elseif type(catcherPlr) == "table" then
        catcherInfo = catcherPlr
    end

    for _, conn in ipairs(getconnections(MythicKillEvent.OnClientEvent)) do
        if conn.Function and conn.Function ~= S.myMythicConnFn then
            withNormalIdentity(conn.Function, victimUserId, skinId, catcherInfo)
        end
    end
end

if MythicKillEvent then
    local function onMythicKillClientEvent(victimUserId, serverSkinId, catcherInfo)
        if type(catcherInfo) == "table" and catcherInfo._ydxPatched then return end
        local catcherUid = type(catcherInfo) == "table" and catcherInfo.userId or nil
        local catcherPlr = catcherUid and Players:GetPlayerByUserId(catcherUid) or nil
        if not catcherPlr then return end

        local desiredKnife = resolveDesiredStateForPlayer(catcherPlr)
        if desiredKnife and desiredKnife ~= serverSkinId and isMythicKnife(desiredKnife) then
            local patchedInfo = {
                name = catcherInfo.name or catcherPlr.DisplayName,
                userId = catcherPlr.UserId,
                _ydxPatched = true
            }
            S.mythicCooldowns[victimUserId] = os.clock()
            if type(getconnections) == "function" then
                for _, conn in ipairs(getconnections(MythicKillEvent.OnClientEvent)) do
                    if conn.Function and conn.Function ~= S.myMythicConnFn then
                        withNormalIdentity(conn.Function, victimUserId, desiredKnife, patchedInfo)
                    end
                end
            end
        else
            S.mythicCooldowns[victimUserId] = os.clock()
        end
    end
    S.myMythicConnFn = onMythicKillClientEvent
    trackConn(MythicKillEvent.OnClientEvent:Connect(onMythicKillClientEvent))
end

if AudioEvents then
    trackConn(AudioEvents.OnClientEvent:Connect(function(kind, payload)
        if kind == "DaggerHit" and type(payload) == "table" and payload.catcher then
            local catcherPlr = Players:GetPlayerByUserId(payload.catcher)
            local desiredKnife = catcherPlr and resolveDesiredStateForPlayer(catcherPlr)
            if desiredKnife then
                payload.skin = desiredKnife
                S.lastHitCatcherByPos = {
                    catcher = catcherPlr,
                    skin = desiredKnife,
                    pos = payload.position,
                    at = os.clock()
                }
            end
        end
    end))
end

local function checkVictimCaughtForMythic(victimPlr, victimChar)
    if not (victimPlr and victimChar) then return end
    task.defer(function()
        local now = os.clock()
        if S.mythicCooldowns[victimPlr.UserId] and (now - S.mythicCooldowns[victimPlr.UserId]) < 2.5 then
            return
        end

        local vHrp = victimChar:FindFirstChild("HumanoidRootPart")
        local bestCatcher = nil
        local bestKnife = nil

        if S.lastHitCatcherByPos and (now - S.lastHitCatcherByPos.at) < 1.5 then
            bestCatcher = S.lastHitCatcherByPos.catcher
            bestKnife = S.lastHitCatcherByPos.skin
        end

        if not bestCatcher and vHrp then
            local bestDist = 24
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= victimPlr and plr:GetAttribute("Role") == "Catcher" and plr.Character then
                    local desiredKnife = resolveDesiredStateForPlayer(plr)
                    if desiredKnife and isMythicKnife(desiredKnife) then
                        local cHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        if cHrp then
                            local d = (cHrp.Position - vHrp.Position).Magnitude
                            if d < bestDist then
                                bestDist = d
                                bestCatcher = plr
                                bestKnife = desiredKnife
                            end
                        end
                    end
                end
            end
        end

        if bestCatcher and bestKnife and isMythicKnife(bestKnife) then
            fireLocalMythicKill(victimPlr.UserId, bestKnife, bestCatcher)
        end
    end)
end

local function hookCharacter(plr, ch)
    if not ch then return end
    trackConn(ch.ChildAdded:Connect(function(child)
        if child.Name == "EquippedDagger" then
            local targetKnifeId = resolveDesiredStateForPlayer(plr)
            if targetKnifeId then
                task.defer(function()
                    ensureCustomKnifeOnCharacter(plr, ch)
                end)
            end
        end
    end))
    trackConn(ch:GetAttributeChangedSignal("DaggerSkin"):Connect(function()
        local targetKnifeId, activeEmoteId = resolveDesiredStateForPlayer(plr)
        if not targetKnifeId then return end
        local effectiveSkinId = targetKnifeId
        if type(activeEmoteId) == "string" and activeEmoteId ~= "" then
            effectiveSkinId = resolveEmotePropSkin(activeEmoteId, targetKnifeId) or targetKnifeId
        end
        if ch:GetAttribute("DaggerSkin") ~= effectiveSkinId then
            ch:SetAttribute("DaggerSkin", effectiveSkinId)
        end
    end))
    trackConn(ch:GetAttributeChangedSignal("Ragdolled"):Connect(function()
        if ch:GetAttribute("Ragdolled") == true then
            checkVictimCaughtForMythic(plr, ch)
        end
    end))
end

local function hookPlayer(plr)
    if not plr then return end
    if plr.Character then
        hookCharacter(plr, plr.Character)
    end
    trackConn(plr.CharacterAdded:Connect(function(ch)
        hookCharacter(plr, ch)
    end))
    trackConn(plr:GetAttributeChangedSignal("EquippedKnife"):Connect(function()
        local targetKnifeId = resolveDesiredStateForPlayer(plr)
        if targetKnifeId and plr:GetAttribute("EquippedKnife") ~= targetKnifeId then
            plr:SetAttribute("EquippedKnife", targetKnifeId)
            plr:SetAttribute("IceSkates", targetKnifeId == "IceSkate")
        end
    end))
    trackConn(plr:GetAttributeChangedSignal("RunState"):Connect(function()
        if plr:GetAttribute("RunState") == "Caught" and plr.Character then
            checkVictimCaughtForMythic(plr, plr.Character)
        end
    end))
end

for _, plr in ipairs(Players:GetPlayers()) do
    hookPlayer(plr)
end
trackConn(Players.PlayerAdded:Connect(function(plr)
    hookPlayer(plr)
end))

-- ============================================================
-- 6. REAL-TIME P2P SYNC (ydx_hv1_<JobId>)
-- ============================================================
local httpRequest = (syn and syn.request)
    or (http and http.request)
    or http_request
    or (fluxus and fluxus.request)
    or request

local jobIdClean = tostring(game.JobId ~= "" and game.JobId or ("local_" .. tostring(game.PlaceId))):gsub("[^%w]", "")
local P2P_TOPIC = "ydx_hv1_" .. jobIdClean:sub(1, 24)
local P2P_URL = "https://ntfy.sh/" .. P2P_TOPIC

local function broadcastMyState(force)
    if type(httpRequest) ~= "function" then return end
    local payloadTable = {
        uid = tostring(LocalPlayer.UserId),
        name = LocalPlayer.Name,
        knife = S.equippedKnife,
        emote = S.activeEmote,
        emoteAt = math.floor((S.activeEmoteAt or 0) * 100) / 100,
        slot1 = S.emoteSlots[1] or ""
    }
    local ok, encoded = pcall(HttpService.JSONEncode, HttpService, payloadTable)
    if not ok or type(encoded) ~= "string" then return end

    local now = os.clock()
    if not force and encoded == S.lastBroadcastHash and (now - S.lastBroadcastTime) < 20 then
        return
    end
    S.lastBroadcastHash = encoded
    S.lastBroadcastTime = now

    task.spawn(function()
        pcall(function()
            httpRequest({
                Url = P2P_URL,
                Method = "POST",
                Headers = { ["Content-Type"] = "text/plain" },
                Body = encoded
            })
        end)
    end)
end
S.broadcastMyState = broadcastMyState

local function applyPeerPacket(data)
    if type(data) ~= "table" or type(data.uid) ~= "string" then return end
    if data.uid == tostring(LocalPlayer.UserId) then return end
    if type(data.knife) ~= "string" or not S.allOwnedKnives[data.knife] then return end

    local peer = S.p2pPeers[data.uid] or {}
    peer.uid = data.uid
    peer.name = data.name
    peer.knife = data.knife
    peer.emote = (type(data.emote) == "string" and S.allOwnedEmotes[data.emote] and data.emote) or ""
    peer.emoteAt = tonumber(data.emoteAt) or 0
    peer.slot1 = (type(data.slot1) == "string" and data.slot1) or ""
    S.p2pPeers[data.uid] = peer

    for _, plr in ipairs(Players:GetPlayers()) do
        if tostring(plr.UserId) == data.uid then
            pcall(function()
                plr:SetAttribute("EquippedKnife", peer.knife)
                plr:SetAttribute("IceSkates", peer.knife == "IceSkate")
            end)
            if plr.Character then
                ensureCustomKnifeOnCharacter(plr, plr.Character)
            end
        end
    end
end

local isFirstPoll = true
local function pollP2PMessages()
    if type(httpRequest) ~= "function" then return end
    local sinceWindow = isFirstPoll and "120s" or "30s"
    isFirstPoll = false
    local ok, res = pcall(function()
        return httpRequest({
            Url = P2P_URL .. "/json?poll=1&since=" .. sinceWindow,
            Method = "GET"
        })
    end)
    if not ok or type(res) ~= "table" or type(res.Body) ~= "string" then return end

    for line in res.Body:gmatch("[^\r\n]+") do
        local okLine, outer = pcall(HttpService.JSONDecode, HttpService, line)
        if okLine and type(outer) == "table" and outer.event == "message" and type(outer.message) == "string" then
            local msgId = tostring(outer.id or outer.time or "")
            if msgId == "" or not S.seenIds[msgId] then
                if msgId ~= "" then S.seenIds[msgId] = true end
                local okInner, inner = pcall(HttpService.JSONDecode, HttpService, outer.message)
                if okInner and type(inner) == "table" then
                    applyPeerPacket(inner)
                end
            end
        end
    end
end

task.spawn(function()
    task.wait(0.5)
    broadcastMyState(true)
    while S.alive do
        pollP2PMessages()
        if os.clock() - S.lastBroadcastTime >= 25 then
            broadcastMyState(false)
        end
        task.wait(1.2)
    end
end)

trackConn(Players.PlayerAdded:Connect(function()
    task.delay(1.5, function()
        if S.alive then
            broadcastMyState(true)
        end
    end)
end))

-- ============================================================
-- 7. LOADOUT CARD HOOKS (CAUGHT & SPECTATE LOADOUTS)
-- ============================================================
if CaughtLoadoutEvent then
    trackConn(CaughtLoadoutEvent.OnClientEvent:Connect(function(info)
        if type(info) ~= "table" or info._ydxPatched then return end
        local uid = tostring(info.Catcher or info.Avatar or "")
        local peer = S.p2pPeers[uid]
        if not peer and type(info.Name) == "string" then
            for _, pr in pairs(S.p2pPeers) do
                if pr.name == info.Name then
                    peer = pr
                    break
                end
            end
        end
        if peer then
            info._ydxPatched = true
            info.Knife = peer.knife
            info.Emote = (peer.emote ~= "" and peer.emote) or (peer.slot1 ~= "" and peer.slot1) or info.Emote
            info.Owned = true
            if type(getconnections) == "function" then
                for _, conn in ipairs(getconnections(CaughtLoadoutEvent.OnClientEvent)) do
                    if conn.Function then
                        withNormalIdentity(conn.Function, info)
                    end
                end
            end
        end
    end))
end

if SpectateEvent then
    trackConn(SpectateEvent.OnClientEvent:Connect(function(mode, payload)
        if mode ~= "Target" or type(payload) ~= "table" or type(payload.loadout) ~= "table" or payload._ydxPatched then
            return
        end
        local uid = tostring(payload.id or payload.loadout.Avatar or "")
        local knifeOverride, emoteOverride = nil, nil
        if uid == tostring(LocalPlayer.UserId) then
            knifeOverride = S.equippedKnife
            emoteOverride = (S.activeEmote ~= "" and S.activeEmote) or (S.emoteSlots[1] ~= "" and S.emoteSlots[1]) or payload.loadout.Emote
        elseif S.p2pPeers[uid] then
            local peer = S.p2pPeers[uid]
            knifeOverride = peer.knife
            emoteOverride = (peer.emote ~= "" and peer.emote) or (peer.slot1 ~= "" and peer.slot1) or payload.loadout.Emote
        end
        if knifeOverride then
            payload._ydxPatched = true
            payload.loadout.Knife = knifeOverride
            payload.loadout.Emote = emoteOverride
            payload.loadout.Owned = true
            if type(getconnections) == "function" then
                for _, conn in ipairs(getconnections(SpectateEvent.OnClientEvent)) do
                    if conn.Function then
                        withNormalIdentity(conn.Function, "Target", payload)
                    end
                end
            end
        end
    end))
end

-- ============================================================
-- 8. SERVER EVENT INTERCEPTION (__namecall & OnClientEvent)
-- ============================================================
local function onArmoryClientEvent(action, stateTable)
    if action == "State" and type(stateTable) == "table" and not stateTable._ydxPatched then
        patchStateTableInPlace(stateTable)
        task.defer(function()
            pushArmoryState(stateTable)
        end)
    end
end
S.myArmoryConnFn = onArmoryClientEvent
trackConn(ArmoryEvent.OnClientEvent:Connect(onArmoryClientEvent))

_G.HussValleyNamecallHandler = function(self, oldNamecall, ...)
    local method = getnamecallmethod()
    if (method == "FireServer" or method == "fireServer") and not checkcaller() then
        if self == ArmoryEvent then
            local action, a1, a2 = ...
            if (action == "Equip" or action == "Buy") and type(a1) == "string" and S.allOwnedKnives[a1] then
                S.equippedKnife = a1
                saveLocalPreset()
                task.defer(function()
                    pushArmoryState(nil)
                    if LocalPlayer.Character then
                        ensureCustomKnifeOnCharacter(LocalPlayer, LocalPlayer.Character)
                    end
                    broadcastMyState(true)
                end)
                if S.serverOwnedKnives[a1] then
                    return oldNamecall(self, "Equip", a1)
                end
                return nil
            elseif action == "EquipEmote" and type(a1) == "string" and type(a2) == "number" then
                local slotIdx = math.clamp(math.floor(a2), 1, 6)
                if a1 ~= "" then
                    for i = 1, 6 do
                        if S.emoteSlots[i] == a1 then
                            S.emoteSlots[i] = ""
                        end
                    end
                end
                S.emoteSlots[slotIdx] = a1
                saveLocalPreset()
                task.defer(function()
                    pushArmoryState(nil)
                    broadcastMyState(true)
                end)
                if a1 == "" or S.serverOwnedEmotes[a1] then
                    return oldNamecall(self, ...)
                end
                return nil
            end
        elseif self == EmoteEvent then
            local action, emoteId = ...
            if action == "Play" and type(emoteId) == "string" and EmoteCatalog.get(emoteId) then
                S.activeEmote = emoteId
                S.activeEmoteAt = workspace:GetServerTimeNow()
                task.defer(function()
                    if LocalPlayer.Character then
                        startCharacterEmote(LocalPlayer, LocalPlayer.Character, emoteId, S.activeEmoteAt)
                    end
                    broadcastMyState(true)
                end)
                return nil
            elseif action == "Stop" then
                if S.activeEmote ~= "" or (LocalPlayer.Character and LocalPlayer.Character:GetAttribute("EmoteId") ~= nil) then
                    S.activeEmote = ""
                    S.activeEmoteAt = 0
                    task.defer(function()
                        if LocalPlayer.Character then
                            stopCharacterEmote(LocalPlayer, LocalPlayer.Character)
                        end
                        broadcastMyState(true)
                    end)
                end
                return oldNamecall(self, ...)
            end
        end
    end
    return oldNamecall(self, ...)
end

if not _G.HussValleyNamecallHooked and type(hookmetamethod) == "function" and type(getnamecallmethod) == "function" then
    _G.HussValleyNamecallHooked = true
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        if type(_G.HussValleyNamecallHandler) == "function" then
            return _G.HussValleyNamecallHandler(self, oldNamecall, ...)
        end
        return oldNamecall(self, ...)
    end)
end

_G.HussValleyCleanup = function()
    S.alive = false
    for _, conn in ipairs(S.connections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(S.connections)
    for _, ctrl in pairs(S.charControllers) do
        clearControllerEmote(ctrl, true)
        cleanupControllerWeaponExtras(ctrl)
    end
    table.clear(S.charControllers)
end

_G.HussValleyForceRefresh = function()
    pushArmoryState(nil)
    if LocalPlayer.Character then
        ensureCustomKnifeOnCharacter(LocalPlayer, LocalPlayer.Character)
    end
    broadcastMyState(true)
end

task.spawn(function()
    pushArmoryState(nil)
    if LocalPlayer.Character then
        ensureCustomKnifeOnCharacter(LocalPlayer, LocalPlayer.Character)
    end
    pcall(function()
        ArmoryEvent:FireServer("Get")
    end)
    task.wait(0.8)
    pushArmoryState(nil)
    if LocalPlayer.Character then
        ensureCustomKnifeOnCharacter(LocalPlayer, LocalPlayer.Character)
    end
end)

print("[HussValleyUnlockAll v2.5] Loaded! 1:1 Knives, Special Rigs, Anims, Audio, Mythic FX & Emotes P2P Sync Active (" .. P2P_TOPIC .. ")")
