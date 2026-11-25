-- ============================================================================
-- [Towers of Fortune] - COMPLETE UNLOCK ALL CAPES + FAST SKIP SPIN + P2P SYNC
-- [YDX Execution Telemetry - Non-Duplicating when loaded via Universal Loader]
do
    local env = (type(getgenv) == "function" and getgenv()) or _G
    env.__YDX_EXEC_LOCKS = env.__YDX_EXEC_LOCKS or {}
    local sid = "towers-unlock"
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
                ["towers-unlock"]     = "scripts/towers_unlock_all.lua",
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
-- PlaceId: 108114331578868 | GameId: 10773001670
-- Pure ASCII | All 37 Capes + All 14 Kill FX + All 13 Win FX + Skin + Fast Skip Spin + Custom Wool
-- + Persistent Preset Saving + Real-Time 20Hz P2P Sync (Everyone With Script Sees Capes!)
-- ============================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local AssetService = game:GetService("AssetService")

local LocalPlayer = Players.LocalPlayer

-- ============================================================================
-- 0. SUB-PLACE SCANNER (STANDARD REQUIREMENT)
-- ============================================================================
task.spawn(function()
    local placeList = {}
    local success, pages = pcall(function()
        return AssetService:GetGamePlacesAsync()
    end)

    if success and typeof(pages) == "Instance" and pages:IsA("Pages") then
        while true do
            local okPage, currentPage = pcall(function()
                return pages:GetCurrentPage()
            end)
            if okPage and type(currentPage) == "table" then
                for _, place in pairs(currentPage) do
                    table.insert(placeList, string.format("%s | ID: %d", tostring(place.Name), tonumber(place.PlaceId) or 0))
                end
            end
            local okFin, isFin = pcall(function()
                return pages.IsFinished
            end)
            if not okFin or isFin then
                break
            end
            local advanceOk = pcall(function()
                pages:AdvanceToNextPageAsync()
            end)
            if not advanceOk then
                break
            end
            task.wait(0.1)
        end
    end
end)

-- ============================================================================
-- 1. CLEANUP OLD INSTANCE & DISABLE ANY PREVIOUS __NAMECALL HANDLER
-- ============================================================================
local env = (type(getgenv) == "function" and getgenv()) or _G
env._YDX_TOF_SHOP_HANDLER = nil

if env._YDX_TOF_CLEANUP then
    pcall(env._YDX_TOF_CLEANUP)
end

local connections = {}
local watcherActive = true

-- ============================================================================
-- 2. PERSISTENT PRESET SAVING & REAL-TIME P2P SYNC
-- ============================================================================
local SAVE_FILE = "towers_saved_preset.json"
local selectedCape = nil -- string capeId ("" = None, "random" = Random, nil = use current/saved)
local selectedWool = nil -- string woolId
local selectedKillFx = nil -- string killFxId ("" = None, "random" = Random)
local selectedWinFx = nil -- string winFxId ("" = None, "random" = Random)
local selectedLook = nil -- table { style = ..., hair = ..., eyes = ..., skin = ... }
local peerCapes = env._YDX_TOF_PEER_CAPES or {}
env._YDX_TOF_PEER_CAPES = peerCapes

local function loadPreset()
    if isfile and readfile then
        local ok, exists = pcall(isfile, SAVE_FILE)
        if ok and exists then
            local okR, raw = pcall(readfile, SAVE_FILE)
            if okR and type(raw) == "string" and #raw > 0 then
                local okJ, data = pcall(function()
                    return HttpService:JSONDecode(raw)
                end)
                if okJ and type(data) == "table" then
                    if type(data.cape) == "string" then
                        selectedCape = data.cape
                    end
                    if type(data.wool) == "string" and data.wool ~= "" then
                        selectedWool = data.wool
                    end
                    if type(data.killFx) == "string" then
                        selectedKillFx = data.killFx
                    end
                    if type(data.winFx) == "string" then
                        selectedWinFx = data.winFx
                    end
                    if type(data.look) == "table" then
                        selectedLook = data.look
                    end
                end
            end
        end
    end
end

local function savePreset()
    if writefile then
        pcall(function()
            local payload = HttpService:JSONEncode({
                cape = selectedCape or "",
                wool = selectedWool or "",
                killFx = selectedKillFx or "",
                winFx = selectedWinFx or "",
                look = selectedLook
            })
            writefile(SAVE_FILE, payload)
        end)
    end
end

loadPreset()

local function broadcastCape(_)
    -- P2P Cape Sync runs natively at 20Hz (50ms) via MCRemotes.Sync buffer replication!
end

-- ============================================================================
-- 3. LOCATE GAME MODULES (MC.Config, PoFClient.LobbyUi, InventoryUi, DeathFx, WinFx, Victory)
-- ============================================================================
local MC = ReplicatedStorage:WaitForChild("MC", 15)
local MCRemotes = ReplicatedStorage:WaitForChild("MCRemotes", 15)
local Config = MC and require(MC:WaitForChild("Config", 10))
local ShopRemote = MCRemotes and MCRemotes:WaitForChild("Shop", 10)
local FxRemote = MCRemotes and MCRemotes:WaitForChild("Fx", 10)
local SyncRemote = MCRemotes and MCRemotes:WaitForChild("Sync", 10)
local Sfx = MC and MC:FindFirstChild("Sfx") and require(MC.Sfx) or nil

local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts", 15)
local PoFClient = PlayerScripts and PlayerScripts:WaitForChild("PoFClient", 15)

local LobbyUi = nil
local InventoryUi = nil
local Chars = nil
local Hud = nil
local ShopMod = nil
local SyncMod = nil
local SettingsMod = nil
local DeathFxMod = nil
local WinFxMod = nil
local VictoryMod = nil

pcall(function()
    if PoFClient then
        local function safeReq(name)
            local m = PoFClient:FindFirstChild(name)
            if m then
                local ok, mod = pcall(require, m)
                if ok then
                    return mod
                end
            end
            return nil
        end
        LobbyUi = safeReq("LobbyUi")
        InventoryUi = safeReq("InventoryUi")
        Chars = safeReq("Chars")
        Hud = safeReq("Hud")
        ShopMod = safeReq("Shop")
        SyncMod = safeReq("Sync")
        SettingsMod = safeReq("Settings")
        DeathFxMod = safeReq("DeathFx")
        WinFxMod = safeReq("WinFx")
        VictoryMod = safeReq("Victory")
    end
end)

local function applyPeerCapeToPlayer(player, capeId)
    if not player or player == LocalPlayer then
        return
    end
    local char = player.Character
    if not char then
        return
    end
    if Chars and type(Chars.track) == "function" then
        pcall(Chars.track, char)
    end
    if char:GetAttribute("Cape") ~= capeId then
        pcall(function()
            char:SetAttribute("Cape", capeId)
        end)
    end
end

-- Build deterministic Cape <-> Code (1..38) tables for 20Hz native MCRemotes.Sync replication
local CAPE_TO_CODE = { [""] = 1 }
local CODE_TO_CAPE = { [1] = "" }
local CAPE_LIST = {}
if Config and type(Config.CapeOrder) == "table" then
    for idx, capeId in ipairs(Config.CapeOrder) do
        local code = idx + 1
        CAPE_TO_CODE[capeId] = code
        CODE_TO_CAPE[code] = capeId
        table.insert(CAPE_LIST, capeId)
    end
end

local currentVisualCape = nil
local function resolveActiveVisualCape()
    if selectedCape == "random" then
        if not currentVisualCape or currentVisualCape == "" or currentVisualCape == "random" then
            if #CAPE_LIST > 0 then
                currentVisualCape = CAPE_LIST[math.random(1, #CAPE_LIST)]
            else
                currentVisualCape = "galaxy"
            end
        end
        return currentVisualCape
    end
    currentVisualCape = selectedCape
    return selectedCape
end

-- Hook PoFClient.Sync.send & MCRemotes.Sync.OnClientEvent for zero-latency (50ms) in-server P2P cape sync!
if SyncMod and type(SyncMod.send) == "function" and SyncRemote then
    env._YDX_TOF_ORIG_SYNCSEND = env._YDX_TOF_ORIG_SYNCSEND or SyncMod.send
    local trueOrigSyncSend = env._YDX_TOF_ORIG_SYNCSEND

    SyncMod.send = function(p10, p11, p12, p13, p14)
        if not watcherActive then
            return trueOrigSyncSend(p10, p11, p12, p13, p14)
        end
        local activeCape = resolveActiveVisualCape()
        if activeCape == nil and LocalPlayer.Character then
            activeCape = LocalPlayer.Character:GetAttribute("Cape")
        end
        local capeCode = (activeCape ~= nil) and CAPE_TO_CODE[tostring(activeCape)] or nil
        if not capeCode then
            return trueOrigSyncSend(p10, p11, p12, p13, p14)
        end

        local buf = buffer.create(17)
        buffer.writef32(buf, 0, p10.X)
        buffer.writef32(buf, 4, p10.Y)
        buffer.writef32(buf, 8, p10.Z)

        local rawYawI = math.floor(((p11 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * 10000)
        local rawPitchI = math.floor(math.clamp(p12, -1.6, 1.6) * 10000)

        local pitchMod = 50 + capeCode -- 51..88
        local yawMod = (capeCode * 7 + 13) % 50 -- 0..49 checksum

        local clampedPitch = math.clamp(rawPitchI, -15800, 15800)
        local taggedPitch = math.floor(clampedPitch / 100) * 100 + pitchMod

        local clampedYaw = math.clamp(rawYawI, -31350, 31300)
        local taggedYaw = math.floor(clampedYaw / 50) * 50 + yawMod

        buffer.writei16(buf, 12, taggedYaw)
        buffer.writei16(buf, 14, taggedPitch)
        buffer.writeu8(buf, 16, (p13 and 1 or 0) + (p14 and 2 or 0))
        SyncRemote:FireServer(buf)
    end

    local peerStreaks = {} -- [eid] = { code = number, hits = number }
    table.insert(connections, SyncRemote.OnClientEvent:Connect(function(buf)
        if not watcherActive or typeof(buf) ~= "buffer" or buffer.len(buf) < 5 then
            return
        end
        local myEid = LocalPlayer.Character and LocalPlayer.Character:GetAttribute("Eid")
        local n = buffer.readu8(buf, 4)
        for i = 0, n - 1 do
            local off = i * 19 + 5
            if off + 19 > buffer.len(buf) then
                break
            end
            local eid = buffer.readu16(buf, off)
            if eid ~= myEid then
                local yawI = buffer.readi16(buf, off + 14)
                local pitchI = buffer.readi16(buf, off + 16)
                local pMod = pitchI % 100
                if pMod >= 51 and pMod <= 88 then
                    local code = pMod - 50
                    local expectedYawMod = (code * 7 + 13) % 50
                    if (yawI % 50) == expectedYawMod and CODE_TO_CAPE[code] ~= nil then
                        local st = peerStreaks[eid]
                        if not st then
                            st = { code = code, hits = 1 }
                            peerStreaks[eid] = st
                        elseif st.code == code then
                            st.hits = st.hits + 1
                        else
                            st.code = code
                            st.hits = 1
                        end
                        if st.hits >= 2 then
                            local capeId = CODE_TO_CAPE[code]
                            for _, plr in ipairs(Players:GetPlayers()) do
                                if plr ~= LocalPlayer and plr.Character and plr.Character:GetAttribute("Eid") == eid then
                                    peerCapes[tostring(plr.UserId)] = capeId
                                    applyPeerCapeToPlayer(plr, capeId)
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end))
end

-- Collect all 37 Cape IDs, 14 Kill FX IDs, and 13 Win FX IDs
local ALL_CAPES = {}
local ALL_KILL_FX = {}
local ALL_KILL_FX_LIST = {}
local ALL_WIN_FX = {}
local ALL_WIN_FX_LIST = {}

local DEFAULT_KILL_FX = {
    "redstone", "confetti", "xp", "petals", "firework", "tombstone", "tnt",
    "anvil", "soul", "frozen", "lucky", "lightning", "ender", "beacon"
}
local DEFAULT_WIN_FX = {
    "nightshift", "anvilrain", "clones", "leaps", "tide", "blade", "sandy",
    "storm", "comet", "frost", "rift", "drake", "chrono"
}

for _, id in ipairs(DEFAULT_KILL_FX) do
    ALL_KILL_FX[id] = true
    table.insert(ALL_KILL_FX_LIST, id)
end
for _, id in ipairs(DEFAULT_WIN_FX) do
    ALL_WIN_FX[id] = true
    table.insert(ALL_WIN_FX_LIST, id)
end

if Config then
    if type(Config.CapeOrder) == "table" then
        for _, capeId in ipairs(Config.CapeOrder) do
            ALL_CAPES[capeId] = true
        end
    end
    if type(Config.Capes) == "table" then
        for capeId, _ in pairs(Config.Capes) do
            ALL_CAPES[capeId] = true
        end
    end
    if type(Config.DEATH_EFFECTS) == "table" then
        for _, entry in ipairs(Config.DEATH_EFFECTS) do
            if type(entry) == "table" and type(entry.id) == "string" and not ALL_KILL_FX[entry.id] then
                ALL_KILL_FX[entry.id] = true
                table.insert(ALL_KILL_FX_LIST, entry.id)
            end
        end
    end
    if type(Config.Effects) == "table" then
        for _, kind in ipairs({ "kill", "death" }) do
            if type(Config.Effects[kind]) == "table" then
                for _, entry in ipairs(Config.Effects[kind]) do
                    if type(entry) == "table" and type(entry.id) == "string" and not ALL_KILL_FX[entry.id] then
                        ALL_KILL_FX[entry.id] = true
                        table.insert(ALL_KILL_FX_LIST, entry.id)
                    end
                end
            end
        end
        if type(Config.Effects.win) == "table" then
            for _, entry in ipairs(Config.Effects.win) do
                if type(entry) == "table" and type(entry.id) == "string" and not ALL_WIN_FX[entry.id] then
                    ALL_WIN_FX[entry.id] = true
                    table.insert(ALL_WIN_FX_LIST, entry.id)
                end
            end
        end
    end
end

-- ============================================================================
-- 4. HOOK Config.capeVisible, Config.visibleCapes & Config.ownsEffect
-- ============================================================================
if Config then
    env._YDX_TOF_ORIG_CAPEVISIBLE = env._YDX_TOF_ORIG_CAPEVISIBLE or Config.capeVisible
    env._YDX_TOF_ORIG_VISIBLECAPES = env._YDX_TOF_ORIG_VISIBLECAPES or Config.visibleCapes
    env._YDX_TOF_ORIG_OWNSEFFECT = env._YDX_TOF_ORIG_OWNSEFFECT or Config.ownsEffect

    Config.capeVisible = function(capeId, _)
        if Config.Capes and Config.Capes[capeId] ~= nil then
            return true
        end
        if env._YDX_TOF_ORIG_CAPEVISIBLE then
            return env._YDX_TOF_ORIG_CAPEVISIBLE(capeId, math.huge)
        end
        return true
    end

    Config.visibleCapes = function(_)
        local list = {}
        if type(Config.CapeOrder) == "table" then
            for _, v in ipairs(Config.CapeOrder) do
                table.insert(list, v)
            end
        end
        return list
    end

    Config.ownsEffect = function(p8, p9, p10)
        if watcherActive then
            if type(p10) == "string" and p10 ~= "" then
                return true
            end
        end
        if env._YDX_TOF_ORIG_OWNSEFFECT then
            return env._YDX_TOF_ORIG_OWNSEFFECT(p8, p9, p10)
        end
        return true
    end
end

-- ============================================================================
-- 5. UNSTICK ROLL UI (u480.spinning) & UNLOCK PROFILE (CAPES + KILL FX + WIN FX + PASSES)
-- ============================================================================
local rollStateTable = nil
if LobbyUi and type(LobbyUi.openRoll) == "function" and debug and debug.getupvalues then
    local okU, ups = pcall(debug.getupvalues, LobbyUi.openRoll)
    if okU and type(ups) == "table" then
        for _, v in pairs(ups) do
            if type(v) == "table" and v.spinning ~= nil then
                rollStateTable = v
                if v.spinning == true and v.onSkip == nil then
                    v.spinning = false
                end
                break
            end
        end
    end
end

local function patchProfileTable(profile)
    if type(profile) ~= "table" then
        return
    end

    -- Snapshot original server-owned capes & fxOwned ONCE across all executions
    if not env._YDX_TOF_SERVER_CAPES and type(profile.capes) == "table" then
        env._YDX_TOF_SERVER_CAPES = {}
        for k, v in pairs(profile.capes) do
            if v == true then
                env._YDX_TOF_SERVER_CAPES[k] = true
            end
        end
    end
    if not env._YDX_TOF_SERVER_FX and type(profile.fxOwned) == "table" then
        env._YDX_TOF_SERVER_FX = {}
        for k, v in pairs(profile.fxOwned) do
            if v == true then
                env._YDX_TOF_SERVER_FX[k] = true
            end
        end
    end

    -- 1) Unlock Skip Spin (fastspin), Custom Wool (wool), and 2x Coins (coins2x) in profile.passes
    if type(profile.passes) ~= "table" then
        profile.passes = {}
    end
    profile.passes.fastspin = true
    profile.passes.wool = true

    -- 2) Unlock all 37 Capes in profile.capes
    if type(profile.capes) ~= "table" then
        profile.capes = {}
    end
    for capeId, _ in pairs(ALL_CAPES) do
        profile.capes[capeId] = true
    end

    -- Numbered Limited serial badge
    if not profile.limitedSerial or profile.limitedSerial <= 0 then
        profile.limitedSerial = 1
    end

    -- 3) Unlock all 14 Kill Effects & all 13 Win Effects in profile.fxOwned & profile.effects
    if type(profile.fxOwned) ~= "table" then
        profile.fxOwned = {}
    end
    if type(profile.effects) ~= "table" then
        profile.effects = {}
    end
    for fxId, _ in pairs(ALL_KILL_FX) do
        profile.fxOwned["kill:" .. fxId] = true
        profile.fxOwned["death:" .. fxId] = true
        profile.effects[fxId] = true
    end
    for fxId, _ in pairs(ALL_WIN_FX) do
        profile.fxOwned["win:" .. fxId] = true
        profile.effects[fxId] = true
    end

    -- 4) Preserve or initialize equipped Cape, Kill FX, Win FX, Wool & Look
    if selectedCape == nil then
        if type(profile.cape) == "string" and profile.cape ~= "" then
            selectedCape = profile.cape
        else
            local charCape = LocalPlayer.Character and LocalPlayer.Character:GetAttribute("Cape")
            if type(charCape) == "string" and charCape ~= "" then
                selectedCape = charCape
            end
        end
    end
    if selectedCape ~= nil then
        profile.cape = selectedCape
    end

    if selectedKillFx == nil then
        if type(profile.killFx) == "string" and profile.killFx ~= "" then
            selectedKillFx = profile.killFx
        elseif type(profile.deathFx) == "string" and profile.deathFx ~= "" then
            selectedKillFx = profile.deathFx
        end
    end
    if selectedKillFx ~= nil then
        profile.killFx = selectedKillFx
        profile.deathFx = selectedKillFx
    end

    if selectedWinFx == nil then
        if type(profile.winFx) == "string" and profile.winFx ~= "" then
            selectedWinFx = profile.winFx
        end
    end
    if selectedWinFx ~= nil then
        profile.winFx = selectedWinFx
    end

    if selectedWool ~= nil and selectedWool ~= "" then
        profile.woolPick = selectedWool
    end

    if type(selectedLook) == "table" then
        if type(profile.look) ~= "table" then
            profile.look = {}
        end
        for k, v in pairs(selectedLook) do
            profile.look[k] = v
        end
    elseif type(profile.look) == "table" then
        selectedLook = table.clone(profile.look)
    end
end

local function applyLocalCharacterCosmetics()
    local char = LocalPlayer.Character
    local visCape = resolveActiveVisualCape()
    if char and visCape ~= nil then
        if Chars and type(Chars.track) == "function" then
            pcall(Chars.track, char)
        end
        if char:GetAttribute("Cape") ~= visCape then
            pcall(function()
                char:SetAttribute("Cape", visCape)
            end)
        end
    end
    if LocalPlayer:GetAttribute("WoolPass") ~= true then
        pcall(function()
            LocalPlayer:SetAttribute("WoolPass", true)
        end)
    end
    if selectedWinFx ~= nil then
        local curPick = LocalPlayer:GetAttribute("WinFxPick")
        if curPick ~= selectedWinFx then
            pcall(function()
                LocalPlayer:SetAttribute("WinFxPick", selectedWinFx)
            end)
        end
    end
end

local function fireProfileListeners()
    local called = {}
    local function runList(list)
        if type(list) ~= "table" then
            return
        end
        for _, fn in ipairs(list) do
            if type(fn) == "function" and not called[fn] then
                called[fn] = true
                task.defer(pcall, fn)
            end
        end
    end
    if LobbyUi then
        if LobbyUi.H then
            runList(LobbyUi.H.profileListeners)
        end
        if LobbyUi._inv then
            runList(LobbyUi._inv.listeners)
        end
    end
    if rollStateTable and type(rollStateTable.drawSkip) == "function" then
        task.defer(pcall, rollStateTable.drawSkip)
    end
end

local function equipCapeLocally(capeId, showToast)
    capeId = tostring(capeId or "")
    selectedCape = capeId
    if capeId == "random" then
        if #CAPE_LIST > 0 then
            currentVisualCape = CAPE_LIST[math.random(1, #CAPE_LIST)]
        else
            currentVisualCape = "galaxy"
        end
    else
        currentVisualCape = capeId
    end
    savePreset()

    if LobbyUi and type(LobbyUi.profile) == "table" then
        patchProfileTable(LobbyUi.profile)
        LobbyUi.profile.cape = capeId
    end

    applyLocalCharacterCosmetics()
    fireProfileListeners()
    broadcastCape(true)

    if showToast and LobbyUi and type(LobbyUi.notify) == "function" then
        if capeId == "" then
            pcall(LobbyUi.notify, "\194\1677Cape unequipped.")
        elseif capeId == "random" then
            pcall(LobbyUi.notify, "\194\167dRandom cape! \194\1677A different one of yours every spawn.")
        else
            local cInfo = Config and Config.Capes and Config.Capes[capeId]
            local cName = (cInfo and cInfo.name) or capeId
            pcall(LobbyUi.notify, "\194\167aEquipped \194\167f" .. tostring(cName) .. " Cape\194\167a!")
        end
    end
end

local function equipFxLocally(kind, fxId, showToast)
    kind = tostring(kind or "kill")
    fxId = tostring(fxId or "")
    if kind == "kill" or kind == "death" then
        selectedKillFx = fxId
    elseif kind == "win" then
        selectedWinFx = fxId
        pcall(function()
            LocalPlayer:SetAttribute("WinFxPick", fxId)
        end)
        if SettingsMod and type(SettingsMod.set) == "function" then
            local fxDef = Config and type(Config.effect) == "function" and Config.effect("win", fxId)
            if fxId == "random" or (fxDef and fxDef.move) then
                pcall(SettingsMod.set, "victoryFx", fxId)
            end
        end
    end
    savePreset()

    if LobbyUi and type(LobbyUi.profile) == "table" then
        patchProfileTable(LobbyUi.profile)
        if kind == "kill" or kind == "death" then
            LobbyUi.profile.killFx = fxId
            LobbyUi.profile.deathFx = fxId
        elseif kind == "win" then
            LobbyUi.profile.winFx = fxId
        end
    end

    applyLocalCharacterCosmetics()
    fireProfileListeners()

    if showToast and LobbyUi and type(LobbyUi.notify) == "function" then
        if fxId == "" then
            pcall(LobbyUi.notify, "\194\1677Effect unequipped.")
        elseif fxId ~= "random" then
            local fxDef = Config and type(Config.effect) == "function" and Config.effect(kind == "death" and "kill" or kind, fxId)
            local fxName = (fxDef and fxDef.name) or fxId
            pcall(LobbyUi.notify, "\194\167a" .. tostring(fxName) .. " \194\1677equipped!")
        end
    end
end

local function equipWoolLocally(woolId)
    woolId = tostring(woolId or "")
    selectedWool = woolId
    savePreset()

    if LobbyUi and type(LobbyUi.profile) == "table" then
        patchProfileTable(LobbyUi.profile)
        LobbyUi.profile.woolPick = woolId
    end

    fireProfileListeners()
end

-- Patch existing profile immediately
if LobbyUi and type(LobbyUi.profile) == "table" then
    patchProfileTable(LobbyUi.profile)
    applyLocalCharacterCosmetics()
    fireProfileListeners()
end

-- Hook LobbyUi.setProfile idempotently
if LobbyUi and type(LobbyUi.setProfile) == "function" then
    env._YDX_TOF_ORIG_SETPROFILE = env._YDX_TOF_ORIG_SETPROFILE or LobbyUi.setProfile
    local trueOrigSetProfile = env._YDX_TOF_ORIG_SETPROFILE
    LobbyUi.setProfile = function(p464, ...)
        if watcherActive then
            patchProfileTable(p464)
        end
        local ret = trueOrigSetProfile(p464, ...)
        if watcherActive then
            applyLocalCharacterCosmetics()
        end
        return ret
    end
end

-- ============================================================================
-- 6. DIRECT NON-RECURSIVE invoke Hook (LobbyUi, LobbyUi.H, LobbyUi._inv, InventoryUi, Shop)
-- ============================================================================
local function rawServerInvoke(action, arg1, ...)
    if not ShopRemote then
        return {
            ok = false,
            err = "Couldn't reach the server."
        }
    end
    local extraArgs = { ... }
    local ok, result = pcall(function()
        return ShopRemote:InvokeServer(action, arg1, table.unpack(extraArgs))
    end)
    if not ok or type(result) ~= "table" then
        return {
            ok = false,
            err = "Couldn't reach the server."
        }
    end
    return result
end

local function handleShopAction(action, arg1)
    if action == "equipCape" then
        local capeId = tostring(arg1 or "")
        equipCapeLocally(capeId, capeId ~= "random")
        -- Only notify server if unequipping ("") or server actually owns this cape
        local serverCapes = env._YDX_TOF_SERVER_CAPES
        if ShopRemote and (capeId == "" or (type(serverCapes) == "table" and serverCapes[capeId] == true)) then
            task.spawn(function()
                pcall(function()
                    ShopRemote:InvokeServer("equipCape", capeId)
                end)
            end)
        end
        return true, { ok = true, cape = capeId }
    elseif action == "equipFx" or action == "buyFx" then
        local kind = (type(arg1) == "table" and tostring(arg1.kind or "kill")) or "kill"
        local fxId = (type(arg1) == "table" and tostring(arg1.id or "")) or ""
        local showToast = (action == "buyFx") or (fxId ~= "" and fxId ~= "random")
        equipFxLocally(kind, fxId, showToast)
        local serverFx = env._YDX_TOF_SERVER_FX
        local fxKey = (kind == "death" and "kill" or kind) .. ":" .. fxId
        if ShopRemote and (fxId == "" or (type(serverFx) == "table" and serverFx[fxKey] == true)) then
            task.spawn(function()
                pcall(function()
                    ShopRemote:InvokeServer("equipFx", { kind = kind, id = fxId })
                end)
            end)
        end
        return true, { ok = true, kind = kind, id = fxId }
    elseif action == "setLook" and type(arg1) == "table" then
        selectedLook = selectedLook or {}
        for k, v in pairs(arg1) do
            if k == "skin" and v == 0 then
                selectedLook[k] = nil
            else
                selectedLook[k] = v
            end
        end
        savePreset()
        if LobbyUi and type(LobbyUi.profile) == "table" then
            LobbyUi.profile.look = LobbyUi.profile.look or {}
            for k, v in pairs(arg1) do
                if k == "skin" and v == 0 then
                    LobbyUi.profile.look[k] = nil
                else
                    LobbyUi.profile.look[k] = v
                end
            end
        end
        if ShopRemote then
            task.spawn(function()
                pcall(function()
                    ShopRemote:InvokeServer("setLook", arg1)
                end)
            end)
        end
        return true, { ok = true }
    elseif action == "buyPass" and (arg1 == "fastspin" or arg1 == "wool") then
        if LobbyUi and type(LobbyUi.profile) == "table" then
            patchProfileTable(LobbyUi.profile)
        end
        fireProfileListeners()
        if arg1 == "fastspin" and rollStateTable and type(rollStateTable.onSkip) == "function" then
            task.defer(pcall, rollStateTable.onSkip)
        end
        if Sfx and type(Sfx.ui) == "function" then
            pcall(Sfx.ui, "levelup")
        end
        if LobbyUi and type(LobbyUi.notify) == "function" then
            if arg1 == "fastspin" then
                pcall(LobbyUi.notify, "\194\167aFast Spins \194\1677unlocked! Press \194\167fSKIP >> \194\1677during any roll.")
            else
                pcall(LobbyUi.notify, "\194\167aCustom Wool \194\1677unlocked! Pick any wool color.")
            end
        end
        return true, { ok = true, studio = true }
    elseif action == "pickWool" and type(arg1) == "string" then
        equipWoolLocally(arg1)
        if ShopRemote then
            task.spawn(function()
                pcall(function()
                    ShopRemote:InvokeServer("pickWool", arg1)
                end)
            end)
        end
        return true, { ok = true, wool = arg1 }
    end
    return false, nil
end

local function hookedInvoke(action, arg1, ...)
    if watcherActive then
        local handled, fakeResult = handleShopAction(action, arg1)
        if handled then
            return fakeResult
        end
        if action == "roll" and LobbyUi and type(LobbyUi.profile) == "table" then
            patchProfileTable(LobbyUi.profile)
        end
    end
    local res = rawServerInvoke(action, arg1, ...)
    if watcherActive then
        if LobbyUi and type(LobbyUi.profile) == "table" then
            patchProfileTable(LobbyUi.profile)
        end
        if action == "roll" and (type(res) ~= "table" or not res.ok) then
            if rollStateTable then
                rollStateTable.spinning = false
            end
        end
    end
    return res
end

if LobbyUi then
    local prevInvoke = LobbyUi.invoke
    local prevHInvoke = LobbyUi.H and LobbyUi.H.invoke
    local prevInvInvoke = LobbyUi._inv and LobbyUi._inv.invoke
    local oldTrackedInvoke = env._YDX_TOF_CURRENT_INVOKE
    env._YDX_TOF_CURRENT_INVOKE = hookedInvoke

    LobbyUi.invoke = hookedInvoke
    if type(LobbyUi.H) == "table" then
        LobbyUi.H.invoke = hookedInvoke
    end
    if type(LobbyUi._inv) == "table" then
        LobbyUi._inv.invoke = hookedInvoke
    end

    -- Update `invoke` upvalue in all LobbyUi, InventoryUi, ShopMod functions & active listener closures
    if debug and debug.getupvalues and debug.setupvalue then
        local visitedFns = {}
        local function patchFunctionUpvalues(fn, depth)
            if type(fn) ~= "function" or visitedFns[fn] or depth > 5 then
                return
            end
            visitedFns[fn] = true
            local okU, ups = pcall(debug.getupvalues, fn)
            if not okU or type(ups) ~= "table" then
                return
            end
            for idx, val in pairs(ups) do
                if type(val) == "function" then
                    local isInvokeUpval = (val == prevInvoke) or (val == prevHInvoke) or (val == prevInvInvoke) or (val == oldTrackedInvoke)
                    if not isInvokeUpval and debug.getupvalue then
                        local okN, upName = pcall(debug.getupvalue, fn, idx)
                        if okN and upName == "invoke" then
                            isInvokeUpval = true
                        end
                    end
                    if isInvokeUpval then
                        pcall(debug.setupvalue, fn, idx, hookedInvoke)
                    else
                        patchFunctionUpvalues(val, depth + 1)
                    end
                elseif type(val) == "table" and depth <= 2 then
                    if rawget(val, "invoke") ~= nil then
                        rawset(val, "invoke", hookedInvoke)
                    end
                end
            end
        end

        for _, mod in ipairs({ LobbyUi, InventoryUi, ShopMod }) do
            if type(mod) == "table" then
                for _, fn in pairs(mod) do
                    if type(fn) == "function" then
                        patchFunctionUpvalues(fn, 1)
                    end
                end
            end
        end
        if LobbyUi.H and type(LobbyUi.H.profileListeners) == "table" then
            for _, fn in ipairs(LobbyUi.H.profileListeners) do
                if type(fn) == "function" then
                    patchFunctionUpvalues(fn, 1)
                end
            end
        end
        if LobbyUi._inv and type(LobbyUi._inv.listeners) == "table" then
            for _, fn in ipairs(LobbyUi._inv.listeners) do
                if type(fn) == "function" then
                    patchFunctionUpvalues(fn, 1)
                end
            end
        end
    end

    -- Refresh any currently open Inventory / Capes / Shop / Roll modal immediately
    fireProfileListeners()
end

-- Also hook Shop showcase preview so clicking any cape in Shop -> Capes carousel equips it!
if ShopMod and type(ShopMod.open) == "function" and debug and debug.getupvalues and debug.setupvalue then
    local okU, ups = pcall(debug.getupvalues, ShopMod.open)
    if okU and type(ups) == "table" then
        for idx, val in pairs(ups) do
            if type(val) == "function" then
                local isBuildShowcase = false
                if debug.getupvalue then
                    local okN, upName = pcall(debug.getupvalue, ShopMod.open, idx)
                    if okN and upName == "buildShowcase" then
                        isBuildShowcase = true
                    end
                end
                if not isBuildShowcase and debug.getinfo then
                    local okI, info = pcall(debug.getinfo, val)
                    if okI and type(info) == "table" and info.name == "buildShowcase" then
                        isBuildShowcase = true
                    end
                end
                if isBuildShowcase then
                    env._YDX_TOF_ORIG_BUILDSHOWCASE = env._YDX_TOF_ORIG_BUILDSHOWCASE or val
                    local origBuildShowcase = env._YDX_TOF_ORIG_BUILDSHOWCASE
                    local function hookedBuildShowcase(...)
                        local showcaseObj, h = origBuildShowcase(...)
                        if type(showcaseObj) == "table" and type(showcaseObj.preview) == "function" then
                            local origPreview = showcaseObj.preview
                            showcaseObj.preview = function(kind, id, ...)
                                if watcherActive and kind == "cape" and type(id) == "string" and id ~= "" then
                                    equipCapeLocally(id, true)
                                    if Sfx and type(Sfx.ui) == "function" then
                                        pcall(Sfx.ui, "armor")
                                    end
                                end
                                return origPreview(kind, id, ...)
                            end
                        end
                        return showcaseObj, h
                    end
                    pcall(debug.setupvalue, ShopMod.open, idx, hookedBuildShowcase)
                    break
                end
            end
        end
    end
end

-- ============================================================================
-- 6B. IN-GAME KILL FX & WIN FX PLAYBACK ENGINE (PLAYS UNLOCKED FX IN MATCHES!)
-- ============================================================================
local recentDeaths = {} -- [displayName / Name] = { pos = Vector3, char = Model, t = number, played = boolean }
local recentLocalKills = {} -- [victimDisplayName] = number

local function resolveActiveKillFx()
    local pick = selectedKillFx
    if (pick == nil or pick == "") and LobbyUi and type(LobbyUi.profile) == "table" then
        pick = LobbyUi.profile.killFx or LobbyUi.profile.deathFx
    end
    if not pick or pick == "" then
        return nil
    end
    if pick == "random" then
        if #ALL_KILL_FX_LIST > 0 then
            return ALL_KILL_FX_LIST[math.random(1, #ALL_KILL_FX_LIST)]
        end
        return "lightning"
    end
    return pick
end

local function resolveActiveWinFx()
    local pick = selectedWinFx
    if (pick == nil or pick == "") and LobbyUi and type(LobbyUi.profile) == "table" then
        pick = LobbyUi.profile.winFx
    end
    if not pick or pick == "" then
        return nil
    end
    if pick == "random" then
        if #ALL_WIN_FX_LIST > 0 then
            return ALL_WIN_FX_LIST[math.random(1, #ALL_WIN_FX_LIST)]
        end
        return "blade"
    end
    return pick
end

local function triggerKillFxForVictim(victimKey)
    local entry = recentDeaths[victimKey]
    if not entry or entry.played or (os.clock() - entry.t) > 2.5 then
        return
    end
    local fxId = resolveActiveKillFx()
    if not fxId or fxId == "" then
        return
    end
    entry.played = true
    if not DeathFxMod and PoFClient then
        pcall(function()
            DeathFxMod = require(PoFClient:FindFirstChild("DeathFx"))
        end)
    end
    if DeathFxMod and type(DeathFxMod.play) == "function" then
        task.spawn(function()
            pcall(DeathFxMod.play, fxId, entry.pos, entry.char)
        end)
    end
end

if FxRemote then
    table.insert(connections, FxRemote.OnClientEvent:Connect(function(kind, a1, a2, _)
        if not watcherActive then
            return
        end
        local now = os.clock()
        if kind == "deathFx" then
            -- Server already played a deathFx for this victim; mark as played so we don't double-play
            if typeof(a2) == "Vector3" then
                for _, d in pairs(recentDeaths) do
                    if (d.pos - a2).Magnitude < 6 then
                        d.played = true
                    end
                end
            end
        elseif kind == "death" and typeof(a1) == "Instance" then
            local hrp = a1:FindFirstChild("HumanoidRootPart")
            local pos = (hrp and hrp.Position) or (a1:IsA("Model") and a1:GetPivot().Position) or nil
            if pos then
                local plr = Players:GetPlayerFromCharacter(a1)
                local dName = (plr and plr.DisplayName) or a1.Name
                local uName = (plr and plr.Name) or a1.Name
                local info = { pos = pos, char = a1, t = now, played = false }
                recentDeaths[dName] = info
                recentDeaths[uName] = info
                if recentLocalKills[dName] and (now - recentLocalKills[dName]) <= 1.5 then
                    task.defer(triggerKillFxForVictim, dName)
                elseif recentLocalKills[uName] and (now - recentLocalKills[uName]) <= 1.5 then
                    task.defer(triggerKillFxForVictim, uName)
                end
            end
        elseif kind == "killfeed" and type(a1) == "table" then
            local myDisplay = LocalPlayer.DisplayName
            local myName = LocalPlayer.Name
            if (a1.killer == myDisplay or a1.killer == myName) and type(a1.victim) == "string" then
                recentLocalKills[a1.victim] = now
                task.defer(triggerKillFxForVictim, a1.victim)
            end
        elseif kind == "roundEnd" then
            local myDisplay = LocalPlayer.DisplayName
            local myChar = LocalPlayer.Character
            if a2 == myDisplay or (a1 ~= nil and a1 == myChar) then
                local winFxId = resolveActiveWinFx()
                if winFxId and winFxId ~= "" then
                    local fxDef = Config and type(Config.effect) == "function" and Config.effect("win", winFxId)
                    if fxDef and fxDef.move then
                        pcall(function()
                            LocalPlayer:SetAttribute("WinFxPick", winFxId)
                        end)
                    else
                        -- Arena WinFx (nightshift, anvilrain, clones)
                        if not WinFxMod and PoFClient then
                            pcall(function()
                                WinFxMod = require(PoFClient:FindFirstChild("WinFx"))
                            end)
                        end
                        if WinFxMod and type(WinFxMod.play) == "function" then
                            task.delay(0.15, function()
                                if watcherActive then
                                    pcall(WinFxMod.play, winFxId, LocalPlayer.Character or a1)
                                end
                            end)
                        end
                    end
                end
            end
        end
    end))
end

-- ============================================================================
-- 7. CHARACTER & HEARTBEAT ENFORCEMENT + P2P SYNC LOOP
-- ============================================================================
local function hookCharacter(char)
    if not char then
        return
    end
    if selectedCape == "random" and #CAPE_LIST > 0 then
        currentVisualCape = CAPE_LIST[math.random(1, #CAPE_LIST)]
    end
    local visCape = resolveActiveVisualCape()
    if visCape ~= nil then
        if Chars and type(Chars.track) == "function" then
            pcall(Chars.track, char)
        end
        pcall(function()
            char:SetAttribute("Cape", visCape)
        end)
    end
    table.insert(connections, char:GetAttributeChangedSignal("Cape"):Connect(function()
        if not watcherActive then
            return
        end
        local activeVis = resolveActiveVisualCape()
        if activeVis ~= nil and char:GetAttribute("Cape") ~= activeVis then
            pcall(function()
                char:SetAttribute("Cape", activeVis)
            end)
        end
    end))
end

if LocalPlayer.Character then
    hookCharacter(LocalPlayer.Character)
end
table.insert(connections, LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.05)
    hookCharacter(char)
end))

local lastCheck = 0
table.insert(connections, RunService.Heartbeat:Connect(function()
    if not watcherActive then
        return
    end
    local now = os.clock()
    if now - lastCheck < 0.15 then
        return
    end
    lastCheck = now

    if LobbyUi and type(LobbyUi.profile) == "table" then
        patchProfileTable(LobbyUi.profile)
    end
    applyLocalCharacterCosmetics()

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local peerCape = peerCapes[tostring(plr.UserId)]
            if peerCape ~= nil then
                applyPeerCapeToPlayer(plr, peerCape)
            end
        end
    end
end))

-- Native 20Hz MCRemotes.Sync handles real-time P2P cape sync automatically with zero HTTP delay!

-- Notify user in-game
pcall(function()
    if Hud and type(Hud.notify) == "function" then
        Hud.notify("\194\167a\194\167lUNLOCK ALL READY! \194\167f37 Capes + 14 Kill FX + 13 Win FX + Fast Spin!", 4)
    elseif LobbyUi and type(LobbyUi.notify) == "function" then
        LobbyUi.notify("\194\167a\194\167lUNLOCK ALL READY! \194\167f37 Capes + 14 Kill FX + 13 Win FX + Fast Spin!")
    end
end)

env._YDX_TOF_CLEANUP = function()
    watcherActive = false
    env._YDX_TOF_SHOP_HANDLER = nil
    if SyncMod and env._YDX_TOF_ORIG_SYNCSEND then
        SyncMod.send = env._YDX_TOF_ORIG_SYNCSEND
    end
    if Config and env._YDX_TOF_ORIG_OWNSEFFECT then
        Config.ownsEffect = env._YDX_TOF_ORIG_OWNSEFFECT
    end
    for _, conn in ipairs(connections) do
        pcall(function()
            conn:Disconnect()
        end)
    end
    table.clear(connections)
end
