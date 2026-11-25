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
local CameraMod = nil
local MovementMod = nil
local BlocksMod = nil
local ViewmodelMod = nil
local UiMod = nil
local CollisionMod = MC and MC:FindFirstChild("Collision") and require(MC.Collision) or nil
local ActionRemote = MCRemotes and MCRemotes:WaitForChild("Action", 10)
local SharedFolder = ReplicatedStorage:FindFirstChild("Shared")
local PlayerPhysicsMod = nil
pcall(function()
    if SharedFolder and SharedFolder:FindFirstChild("Physics") and SharedFolder.Physics:FindFirstChild("PlayerPhysics") then
        PlayerPhysicsMod = require(SharedFolder.Physics.PlayerPhysics)
    end
end)

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
        CameraMod = safeReq("Camera")
        MovementMod = safeReq("Movement")
        BlocksMod = safeReq("Blocks")
        ViewmodelMod = safeReq("Viewmodel")
        UiMod = safeReq("Ui")
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
        local silentRot = env._YDX_TOF_SILENT_ROT
        if type(silentRot) == "table" and (os.clock() - (silentRot.t or 0)) < 0.35 then
            if type(silentRot.yaw) == "number" then
                rawYawI = math.floor(((silentRot.yaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * 10000)
            end
            if type(silentRot.pitch) == "number" then
                rawPitchI = math.floor(math.clamp(silentRot.pitch, -1.6, 1.6) * 10000)
            end
        end

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

-- ============================================================================
-- 8. VAPE V4 GUI + COMBAT / MOVEMENT / WORLD MODULES (AimAssist, KillAura, Scaffold, Fly AirWalk)
-- ============================================================================
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local BLOCK_SIZE = (Config and Config.BLOCK) or 3
local VAPE_CONFIG_FILE = "towers_vape_v4_config.json"

local VapeConfig = {
    guiOpen = true,
    toggleKey = "RightShift",
    arrayList = true,
    watermark = true,
    targetHud = true,
    AimAssist = {
        enabled = false,
        bind = "None",
        range = 6.5,
        fov = 95,
        speed = 11,
        clickOnly = false,
        inLobby = false
    },
    KillAura = {
        enabled = false,
        bind = "R",
        range = 4.2,
        fov = 360,
        mode = "1.9+ Cooldown", -- "1.9+ Cooldown" | "Spam CPS"
        cps = 12,
        autoWeapon = true,
        autoCritSprint = true,
        inLobby = false
    },
    Scaffold = {
        enabled = false,
        bind = "Z",
        autoBlock = true,
        expand = 1,
        keepY = false,
        tower = true
    },
    Fly = {
        enabled = false,
        bind = "F",
        mode = "AirWalk", -- "AirWalk" (Lock Y) | "StepUp" (Rise on Jump)
        sneakDown = true,
        autoSprint = true
    }
}

pcall(function()
    if type(isfile) == "function" and type(readfile) == "function" and isfile(VAPE_CONFIG_FILE) then
        local raw = readfile(VAPE_CONFIG_FILE)
        local ok, decoded = pcall(function()
            return HttpService:JSONDecode(raw)
        end)
        if ok and type(decoded) == "table" then
            for k, v in pairs(decoded) do
                if type(v) == "table" and type(VapeConfig[k]) == "table" then
                    for sk, sv in pairs(v) do
                        if VapeConfig[k][sk] ~= nil then
                            VapeConfig[k][sk] = sv
                        end
                    end
                elseif VapeConfig[k] ~= nil then
                    VapeConfig[k] = v
                end
            end
        end
    end
end)

local function saveVapeConfig()
    pcall(function()
        if type(writefile) == "function" then
            writefile(VAPE_CONFIG_FILE, HttpService:JSONEncode(VapeConfig))
        end
    end)
end

-- Resolve GUI parent (Safe in PlayerGui so input events never trigger Plugin capability errors)
local vapeGuiParent = LocalPlayer:WaitForChild("PlayerGui", 10)
pcall(function()
    if type(gethui) == "function" then
        local h = gethui()
        if h then
            local oldH = h:FindFirstChild("YDX_VapeV4_ToF")
            if oldH then
                oldH:Destroy()
            end
        end
    end
end)
pcall(function()
    local oldC = CoreGui:FindFirstChild("YDX_VapeV4_ToF")
    if oldC then
        oldC:Destroy()
    end
end)
if vapeGuiParent then
    local oldVape = vapeGuiParent:FindFirstChild("YDX_VapeV4_ToF")
    if oldVape then
        pcall(function()
            oldVape:Destroy()
        end)
    end
end

-- Helpers for Gameplay State
local function isActiveMatchOrAllowed(allowLobby)
    if allowLobby then
        return true
    end
    return LocalPlayer:GetAttribute("InRound") == true or LocalPlayer:GetAttribute("InTraining") == true
end

local function isLocalAlive()
    local char = LocalPlayer.Character
    if not char then
        return false
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hrp ~= nil and (not hum or hum.Health > 0)
end

local function getValidFighters(allowLobby)
    local results = {}
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then
        return results
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local c = plr.Character
            if not c:GetAttribute("Hidden") then
                if allowLobby or plr:GetAttribute("InRound") == true or LocalPlayer:GetAttribute("InTraining") == true then
                    local hrp = c:FindFirstChild("HumanoidRootPart")
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hrp and (not hum or hum.Health > 0) then
                        table.insert(results, {
                            model = c,
                            hrp = hrp,
                            hum = hum,
                            name = plr.DisplayName or plr.Name,
                            isBot = false
                        })
                    end
                end
            end
        end
    end

    local bots = workspace:FindFirstChild("Bots")
    if bots then
        for _, bot in ipairs(bots:GetChildren()) do
            if bot:IsA("Model") and not bot:GetAttribute("Hidden") then
                local hrp = bot:FindFirstChild("HumanoidRootPart")
                local hum = bot:FindFirstChildOfClass("Humanoid")
                if hrp and (not hum or hum.Health > 0) then
                    table.insert(results, {
                        model = bot,
                        hrp = hrp,
                        hum = hum,
                        name = bot.Name,
                        isBot = true
                    })
                end
            end
        end
    end

    return results
end

local function getEyePosition()
    if CameraMod and typeof(CameraMod.eye) == "Vector3" then
        return CameraMod.eye
    end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        return hrp.Position + Vector3.new(0, 2.16, 0)
    end
    return workspace.CurrentCamera and workspace.CurrentCamera.CFrame.Position or Vector3.zero
end

local function getCameraLook()
    if CameraMod and type(CameraMod.look) == "function" then
        local ok, l = pcall(CameraMod.look)
        if ok and typeof(l) == "Vector3" then
            return l
        end
    end
    return workspace.CurrentCamera and workspace.CurrentCamera.CFrame.LookVector or Vector3.new(0, 0, -1)
end

local function wrapAngleRad(a)
    return (a + math.pi) % (2 * math.pi) - math.pi
end

local function findNearestTarget(maxRangeBlocks, maxFovDeg, allowLobby)
    local eye = getEyePosition()
    local look = getCameraLook()
    local char = LocalPlayer.Character
    local myHrp = char and char:FindFirstChild("HumanoidRootPart")
    if not myHrp then
        return nil
    end

    local halfFovRad = math.rad((maxFovDeg or 360) * 0.5)
    local bestEntry = nil
    local bestDistBlocks = maxRangeBlocks + 0.001

    for _, entry in ipairs(getValidFighters(allowLobby)) do
        local targetPos = entry.hrp.Position + Vector3.new(0, -0.3, 0)
        local deltaEye = targetPos - eye
        local distBlocks = (entry.hrp.Position - myHrp.Position).Magnitude / BLOCK_SIZE
        local eyeDistBlocks = deltaEye.Magnitude / BLOCK_SIZE
        local effDist = math.min(distBlocks, eyeDistBlocks)

        if effDist <= maxRangeBlocks and deltaEye.Magnitude > 0.05 then
            local unit = deltaEye.Unit
            local dot = math.clamp(look:Dot(unit), -1, 1)
            local angle = math.acos(dot)
            if angle <= halfFovRad then
                if effDist < bestDistBlocks then
                    bestDistBlocks = effDist
                    entry.distBlocks = effDist
                    entry.aimUnit = unit
                    entry.aimYaw = math.atan2(-unit.X, -unit.Z)
                    entry.aimPitch = math.clamp(math.asin(unit.Y), -1.52, 1.52)
                    bestEntry = entry
                end
            end
        end
    end

    return bestEntry
end

-- Hotbar slot & item helpers
local WEAPON_SCORES = {
    diamond_sword = 100,
    iron_sword = 90,
    mace = 85,
    stone_sword = 80,
    wooden_sword = 70,
    knockback_stick = 65,
    iron_pickaxe = 55,
    stone_pickaxe = 45
}

local lastAutoSelectTime = 0
local function selectHotbarSlot(slotIdx)
    if not Hud or type(Hud.state) ~= "table" or type(Hud.state.inv) ~= "table" then
        return false
    end
    if Hud.state.selected == slotIdx then
        local slotEntry = Hud.state.inv[slotIdx]
        local itemId = slotEntry and slotEntry.id or nil
        if BlocksMod and type(BlocksMod.setHeld) == "function" then
            pcall(BlocksMod.setHeld, itemId, Hud.state.wool)
        end
        return true
    end
    local now = os.clock()
    if now - lastAutoSelectTime < 0.05 then
        return false
    end
    lastAutoSelectTime = now

    if ActionRemote then
        pcall(function()
            ActionRemote:FireServer("select", slotIdx)
        end)
    end
    pcall(function()
        local cloned = table.clone(Hud.state)
        cloned.selected = slotIdx
        if type(Hud.setState) == "function" then
            Hud.setState(cloned)
        else
            Hud.state.selected = slotIdx
        end
        local slotEntry = cloned.inv[slotIdx]
        local itemId = slotEntry and slotEntry.id or nil
        if BlocksMod and type(BlocksMod.setHeld) == "function" then
            BlocksMod.setHeld(itemId, cloned.wool)
        end
    end)
    return true
end

local function getHeldItemDef()
    if not Hud or type(Hud.state) ~= "table" or type(Hud.state.inv) ~= "table" then
        return nil, nil
    end
    local slot = Hud.state.inv[Hud.state.selected]
    local id = slot and slot.id or nil
    local def = (id and Config and Config.Items and Config.Items[id]) or nil
    return id, def
end

local function findBestWeaponSlot()
    if not Hud or type(Hud.state) ~= "table" or type(Hud.state.inv) ~= "table" then
        return nil
    end
    local bestSlot = nil
    local bestScore = -1
    for slotIdx = 1, 9 do
        local entry = Hud.state.inv[slotIdx]
        if entry and type(entry.id) == "string" then
            local score = WEAPON_SCORES[entry.id]
            if not score and Config and Config.Items and Config.Items[entry.id] then
                local def = Config.Items[entry.id]
                if def.kind == "melee" or def.kind == "tool" then
                    score = (def.damage or 1) * 10
                end
            end
            if score and score > bestScore then
                bestScore = score
                bestSlot = slotIdx
            end
        end
    end
    return bestSlot
end

local function isSolidBridgeBlock(itemId)
    if not itemId or not Config or not Config.Items then
        return false
    end
    local def = Config.Items[itemId]
    if not def or def.kind ~= "block" then
        return false
    end
    if def.passable or def.web or def.lucky or def.bouncy or def.generator then
        return false
    end
    return true
end

local function findBestBlockSlot()
    if not Hud or type(Hud.state) ~= "table" or type(Hud.state.inv) ~= "table" then
        return nil, nil
    end
    -- If already holding a valid solid block, keep it!
    local curSlot = Hud.state.selected
    local curEntry = curSlot and Hud.state.inv[curSlot]
    if curEntry and isSolidBridgeBlock(curEntry.id) and (curEntry.count == nil or curEntry.count > 0) then
        return curSlot, curEntry.id
    end
    local bestSlot = nil
    local bestId = nil
    local bestCount = -1
    for slotIdx = 1, 9 do
        local entry = Hud.state.inv[slotIdx]
        if entry and isSolidBridgeBlock(entry.id) then
            local cnt = tonumber(entry.count) or 1
            if cnt > bestCount then
                bestCount = cnt
                bestSlot = slotIdx
                bestId = entry.id
            end
        end
    end
    return bestSlot, bestId
end

-- ============================================================================
-- AIRWALK FLY ENGINE (Hooks PlayerPhysics.step so the player literally walks on air!)
-- ============================================================================
local airWalkY = nil
local airWalkParts = {}
local airWalkFolder = nil

local function clearAirWalkFloor()
    for k, part in pairs(airWalkParts) do
        pcall(function()
            part:Destroy()
        end)
        airWalkParts[k] = nil
    end
end

local function getFeetBlockPos()
    if MovementMod and type(MovementMod.feet) == "function" then
        local ok, f = pcall(MovementMod.feet)
        if ok and typeof(f) == "Vector3" then
            return f
        end
    end
    if MovementMod and type(MovementMod.state) == "function" then
        local ok, st = pcall(MovementMod.state)
        if ok and type(st) == "table" and typeof(st.pos) == "Vector3" then
            return st.pos
        end
    end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        return (hrp.Position - Vector3.new(0, 2.7, 0)) / BLOCK_SIZE
    end
    return nil
end

if PlayerPhysicsMod and type(PlayerPhysicsMod.step) == "function" then
    env._YDX_TOF_ORIG_PPSTEP = env._YDX_TOF_ORIG_PPSTEP or PlayerPhysicsMod.step
    local trueOrigPPStep = env._YDX_TOF_ORIG_PPSTEP

    PlayerPhysicsMod.step = function(state, input, world)
        if not watcherActive or not VapeConfig.Fly.enabled or type(state) ~= "table" or typeof(state.pos) ~= "Vector3" then
            return trueOrigPPStep(state, input, world)
        end

        if not airWalkY then
            airWalkY = state.pos.Y
        end

        local descend = VapeConfig.Fly.sneakDown and type(input) == "table" and input.sneak == true
        if descend then
            airWalkY = state.pos.Y - 0.06
            input = table.clone(input)
            input.sneak = false
            input.edgeGuard = false
        else
            if type(input) == "table" then
                input = table.clone(input)
                input.edgeGuard = false
                if VapeConfig.Fly.autoSprint and (input.forward or 0) > 0 then
                    input.sprint = true
                end
            end
            if state.pos.Y <= airWalkY + 0.05 then
                state.onGround = true
                state.fallDistance = 0
            end
        end

        local ret = trueOrigPPStep(state, input, world)

        if not descend then
            if VapeConfig.Fly.mode == "StepUp" and type(input) == "table" and input.jump and state.pos.Y > airWalkY then
                airWalkY = state.pos.Y
            end
            if state.pos.Y <= airWalkY then
                state.pos = Vector3.new(state.pos.X, airWalkY, state.pos.Z)
                state.onGround = true
                state.fallDistance = 0
                if type(PlayerPhysicsMod.getMotion) == "function" and type(PlayerPhysicsMod.setMotion) == "function" then
                    local vx, vy, vz = PlayerPhysicsMod.getMotion(state)
                    if type(vy) == "number" and vy < 0 then
                        PlayerPhysicsMod.setMotion(state, Vector3.new(vx or 0, 0, vz or 0))
                    end
                end
            end
        else
            airWalkY = state.pos.Y
        end

        return ret
    end
end

-- ============================================================================
-- SCAFFOLD ENGINE (Places blocks under feet + diagonal support neighbors)
-- ============================================================================
local scaffoldBaseY = nil
local lastScaffoldPlace = 0

local function cellIsSolid(x, y, z)
    if CollisionMod and type(CollisionMod.cellSolid) == "function" then
        return CollisionMod.cellSolid(x, y, z) == true
    end
    return false
end

local CARDINAL_OFFSETS = {
    Vector3.new(0, -1, 0),
    Vector3.new(1, 0, 0),
    Vector3.new(-1, 0, 0),
    Vector3.new(0, 0, 1),
    Vector3.new(0, 0, -1),
    Vector3.new(0, 1, 0)
}

local function cellTouchesSolid(cell)
    for _, off in ipairs(CARDINAL_OFFSETS) do
        local n = cell + off
        if cellIsSolid(n.X, n.Y, n.Z) then
            return true
        end
    end
    return false
end

local function canPlaceScaffoldCell(cell, feet)
    if Config and type(Config.inBuildArea) == "function" then
        if not Config.inBuildArea(cell.X, cell.Y, cell.Z) then
            return false
        end
    end
    if cellIsSolid(cell.X, cell.Y, cell.Z) then
        return false
    end
    -- Don't place inside the player's own body hitbox (only below feet or ahead)
    if feet then
        local overlapsXZ = (feet.X + 0.29 > cell.X) and (feet.X - 0.29 < cell.X + 1) and (feet.Z + 0.29 > cell.Z) and (feet.Z - 0.29 < cell.Z + 1)
        local overlapsY = (feet.Y + 1.75 > cell.Y) and (feet.Y < cell.Y + 0.99)
        if overlapsXZ and overlapsY then
            return false
        end
    end
    return true
end

local function placeScaffoldBlockAt(cell)
    if not BlocksMod or type(BlocksMod.placeCell) ~= "function" then
        return false
    end
    local ok, placed = pcall(BlocksMod.placeCell, cell)
    if ok and placed then
        if ViewmodelMod and type(ViewmodelMod.swing) == "function" then
            pcall(ViewmodelMod.swing)
        end
        if Chars and type(Chars.swing) == "function" and LocalPlayer.Character then
            pcall(Chars.swing, LocalPlayer.Character)
        end
        return true
    end
    return false
end

local function stepScaffold()
    if not VapeConfig.Scaffold.enabled then
        scaffoldBaseY = nil
        return
    end
    if not isActiveMatchOrAllowed(false) or not isLocalAlive() then
        return
    end
    local now = os.clock()
    if now - lastScaffoldPlace < 0.035 then
        return
    end

    local feet = getFeetBlockPos()
    if not feet then
        return
    end

    local blockSlot, blockId = findBestBlockSlot()
    if not blockSlot or not blockId then
        return
    end

    if VapeConfig.Scaffold.autoBlock then
        selectHotbarSlot(blockSlot)
    else
        local heldId, _ = getHeldItemDef()
        if not isSolidBridgeBlock(heldId) then
            return
        end
    end

    if BlocksMod and type(BlocksMod.setHeld) == "function" and Hud and type(Hud.state) == "table" then
        pcall(BlocksMod.setHeld, blockId, Hud.state.wool)
    end

    local underY = math.floor(feet.Y - 0.01)
    local jumping = UserInputService:IsKeyDown(Enum.KeyCode.Space) and UserInputService:GetFocusedTextBox() == nil

    if VapeConfig.Scaffold.keepY then
        if not scaffoldBaseY or (MovementMod and MovementMod.onGround and not jumping) then
            scaffoldBaseY = underY
        end
    else
        scaffoldBaseY = underY
    end

    local targetY = (VapeConfig.Scaffold.keepY and not (VapeConfig.Scaffold.tower and jumping)) and (scaffoldBaseY or underY) or underY

    -- Movement / look horizontal vector
    local moveDir = Vector3.zero
    if MovementMod and typeof(MovementMod.velocity) == "Vector3" then
        local v = Vector3.new(MovementMod.velocity.X, 0, MovementMod.velocity.Z)
        if v.Magnitude > 0.02 then
            moveDir = v.Unit
        end
    end
    if moveDir.Magnitude < 0.01 then
        local look = getCameraLook()
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude > 0.02 then
            moveDir = flatLook.Unit
        end
    end

    local candidateCells = {
        Vector3.new(math.floor(feet.X), targetY, math.floor(feet.Z)),
        Vector3.new(math.floor(feet.X + moveDir.X * 0.38), targetY, math.floor(feet.Z + moveDir.Z * 0.38)),
        Vector3.new(math.floor(feet.X + 0.28), targetY, math.floor(feet.Z + 0.28)),
        Vector3.new(math.floor(feet.X - 0.28), targetY, math.floor(feet.Z + 0.28)),
        Vector3.new(math.floor(feet.X + 0.28), targetY, math.floor(feet.Z - 0.28)),
        Vector3.new(math.floor(feet.X - 0.28), targetY, math.floor(feet.Z - 0.28))
    }

    local expandCount = math.clamp(math.floor(tonumber(VapeConfig.Scaffold.expand) or 1), 1, 3)
    for e = 1, expandCount do
        local ahead = feet + moveDir * (e * 0.85)
        table.insert(candidateCells, Vector3.new(math.floor(ahead.X), targetY, math.floor(ahead.Z)))
    end

    -- Tower boost when holding Space directly over a block
    if VapeConfig.Scaffold.tower and jumping and moveDir.Magnitude < 0.18 then
        local towerCell = Vector3.new(math.floor(feet.X), math.floor(feet.Y - 0.01), math.floor(feet.Z))
        if canPlaceScaffoldCell(towerCell, feet) and cellTouchesSolid(towerCell) then
            if placeScaffoldBlockAt(towerCell) then
                lastScaffoldPlace = now
                if MovementMod and type(MovementMod.state) == "function" and PlayerPhysicsMod then
                    local st = MovementMod.state()
                    if st and type(PlayerPhysicsMod.getMotion) == "function" and type(PlayerPhysicsMod.setMotion) == "function" then
                        local vx, vy, vz = PlayerPhysicsMod.getMotion(st)
                        if (vy or 0) < 0.38 then
                            PlayerPhysicsMod.setMotion(st, Vector3.new(vx or 0, 0.41, vz or 0))
                        end
                    end
                end
                return
            end
        end
    end

    for _, cell in ipairs(candidateCells) do
        if canPlaceScaffoldCell(cell, feet) then
            if cellTouchesSolid(cell) then
                if placeScaffoldBlockAt(cell) then
                    lastScaffoldPlace = now
                    return
                end
            else
                -- Diagonal bridge support: find a neighbor cell that DOES touch a solid block!
                for _, off in ipairs(CARDINAL_OFFSETS) do
                    local support = cell + off
                    if canPlaceScaffoldCell(support, feet) and cellTouchesSolid(support) then
                        if placeScaffoldBlockAt(support) then
                            lastScaffoldPlace = now
                            -- Also place the main cell right after if possible
                            if canPlaceScaffoldCell(cell, feet) and cellTouchesSolid(cell) then
                                placeScaffoldBlockAt(cell)
                            end
                            return
                        end
                    end
                end
            end
        end
    end
end

-- ============================================================================
-- KILL AURA & AIM ASSIST ENGINE
-- ============================================================================
local lastKillAuraSwing = 0
local currentAuraTarget = nil

local function getWeaponCooldownSeconds()
    local _, def = getHeldItemDef()
    local spd = (def and tonumber(def.speed)) or 4.0
    -- 1.9+ full strength charge (>92% strength in Physics.attackStrength)
    local ticksNeeded = (20 / spd) * 0.92 - 0.5
    return math.max(0.18, ticksNeeded / 20)
end

local function stepKillAura()
    if not VapeConfig.KillAura.enabled then
        currentAuraTarget = nil
        return
    end
    if not isActiveMatchOrAllowed(VapeConfig.KillAura.inLobby) or not isLocalAlive() then
        currentAuraTarget = nil
        return
    end
    if Chars and (Chars.localUsing == "eat" or Chars.localUsing == "drink") then
        return
    end

    local range = tonumber(VapeConfig.KillAura.range) or 4.2
    local fov = tonumber(VapeConfig.KillAura.fov) or 360
    local target = findNearestTarget(range, fov, VapeConfig.KillAura.inLobby)
    currentAuraTarget = target

    if not target then
        return
    end

    -- Auto-switch to best melee weapon in hotbar (unless Scaffold is actively placing blocks)
    if VapeConfig.KillAura.autoWeapon and not VapeConfig.Scaffold.enabled then
        local bestSlot = findBestWeaponSlot()
        if bestSlot then
            selectHotbarSlot(bestSlot)
        end
    end

    -- Silent server rotation toward target for 20Hz Sync packets
    env._YDX_TOF_SILENT_ROT = {
        yaw = target.aimYaw,
        pitch = target.aimPitch,
        t = os.clock()
    }

    local now = os.clock()
    local delaySec = 0.625
    if VapeConfig.KillAura.mode == "Spam CPS" then
        local cps = math.clamp(tonumber(VapeConfig.KillAura.cps) or 12, 1, 20)
        delaySec = 1 / cps
    else
        delaySec = getWeaponCooldownSeconds()
    end

    if now - lastKillAuraSwing < delaySec then
        return
    end
    lastKillAuraSwing = now

    if Hud then
        Hud.swingStart = now
    end
    if ViewmodelMod and type(ViewmodelMod.swing) == "function" then
        pcall(ViewmodelMod.swing)
    end
    if Chars and type(Chars.swing) == "function" and LocalPlayer.Character then
        pcall(Chars.swing, LocalPlayer.Character)
    end

    local sprintHit = true
    if not VapeConfig.KillAura.autoCritSprint and MovementMod then
        sprintHit = MovementMod.freshSprint == true
    elseif MovementMod then
        MovementMod.freshSprint = true
        sprintHit = true
    end

    if ActionRemote then
        pcall(function()
            ActionRemote:FireServer("attack", target.model, target.aimUnit, sprintHit)
        end)
    end
end

local function stepAimAssist(dt)
    if not VapeConfig.AimAssist.enabled then
        return
    end
    if not CameraMod or CameraMod.cursorFree or CameraMod.spectating then
        return
    end
    if not isActiveMatchOrAllowed(VapeConfig.AimAssist.inLobby) or not isLocalAlive() then
        return
    end
    if VapeConfig.AimAssist.clickOnly and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        return
    end

    local range = tonumber(VapeConfig.AimAssist.range) or 6.5
    local fov = tonumber(VapeConfig.AimAssist.fov) or 95
    local target = findNearestTarget(range, fov, VapeConfig.AimAssist.inLobby)
    if not target then
        return
    end

    local speed = math.clamp(tonumber(VapeConfig.AimAssist.speed) or 11, 1, 30)
    local alpha = 1 - math.exp(-dt * speed)

    local curYaw = tonumber(CameraMod.yaw) or 0
    local curPitch = tonumber(CameraMod.pitch) or 0
    local yawDiff = wrapAngleRad(target.aimYaw - curYaw)
    local pitchDiff = target.aimPitch - curPitch

    CameraMod.yaw = curYaw + yawDiff * alpha
    CameraMod.pitch = math.clamp(curPitch + pitchDiff * alpha, -1.52, 1.52)
    CameraMod.headYaw = CameraMod.yaw
    CameraMod.headPitch = CameraMod.pitch
    if not CameraMod.orbit then
        CameraMod.faceYaw = CameraMod.yaw
        CameraMod.faceTarget = CameraMod.yaw
    end
end

-- ============================================================================
-- VAPE V4 UI BUILDER (Dark Panels, Teal Accents, ArrayList, TargetHUD, Keybinds)
-- ============================================================================
local vapeScreen = Instance.new("ScreenGui")
vapeScreen.Name = "YDX_VapeV4_ToF"
vapeScreen.IgnoreGuiInset = true
vapeScreen.ResetOnSpawn = false
vapeScreen.DisplayOrder = 888888
vapeScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if vapeGuiParent then
    vapeScreen.Parent = vapeGuiParent
end

local VAPE_ACCENT = Color3.fromRGB(5, 213, 148)
local VAPE_ACCENT_2 = Color3.fromRGB(0, 174, 255)
local VAPE_BG = Color3.fromRGB(20, 20, 24)
local VAPE_HEADER = Color3.fromRGB(26, 26, 32)
local VAPE_MODULE_OFF = Color3.fromRGB(25, 25, 31)
local VAPE_MODULE_ON = Color3.fromRGB(5, 195, 136)
local VAPE_DRAWER_BG = Color3.fromRGB(16, 16, 20)
local VAPE_TEXT = Color3.fromRGB(238, 242, 248)
local VAPE_MUTED = Color3.fromRGB(145, 152, 166)

-- 1. Top-Right Vape V4 Watermark + ArrayList
local hudContainer = Instance.new("Frame")
hudContainer.Name = "VapeHUD"
hudContainer.AnchorPoint = Vector2.new(1, 0)
hudContainer.Position = UDim2.new(1, -16, 0, 56)
hudContainer.Size = UDim2.new(0, 240, 0, 420)
hudContainer.BackgroundTransparency = 1
hudContainer.Parent = vapeScreen

local watermarkFrame = Instance.new("Frame")
watermarkFrame.Name = "Watermark"
watermarkFrame.AnchorPoint = Vector2.new(1, 0)
watermarkFrame.Position = UDim2.new(1, 0, 0, 0)
watermarkFrame.Size = UDim2.new(0, 210, 0, 28)
watermarkFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 21)
watermarkFrame.BackgroundTransparency = 0.14
watermarkFrame.BorderSizePixel = 0
watermarkFrame.Parent = hudContainer

local wmCorner = Instance.new("UICorner")
wmCorner.CornerRadius = UDim.new(0, 5)
wmCorner.Parent = watermarkFrame

local wmBar = Instance.new("Frame")
wmBar.Size = UDim2.new(1, 0, 0, 2)
wmBar.Position = UDim2.new(0, 0, 0, 0)
wmBar.BackgroundColor3 = VAPE_ACCENT
wmBar.BorderSizePixel = 0
wmBar.Parent = watermarkFrame

local wmBarGrad = Instance.new("UIGradient")
wmBarGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, VAPE_ACCENT),
    ColorSequenceKeypoint.new(1, VAPE_ACCENT_2)
})
wmBarGrad.Parent = wmBar

local wmLabel = Instance.new("TextLabel")
wmLabel.Size = UDim2.new(1, -16, 1, 0)
wmLabel.Position = UDim2.new(0, 10, 0, 1)
wmLabel.BackgroundTransparency = 1
wmLabel.Font = Enum.Font.GothamBold
wmLabel.TextSize = 13
wmLabel.TextColor3 = VAPE_TEXT
wmLabel.TextXAlignment = Enum.TextXAlignment.Left
wmLabel.RichText = true
wmLabel.Text = "<font color='#05d594'>VAPE</font> v4 <font color='#7d8597'>|</font> Towers of Fortune"
wmLabel.Parent = watermarkFrame

local arrayListFrame = Instance.new("Frame")
arrayListFrame.Name = "ArrayList"
arrayListFrame.AnchorPoint = Vector2.new(1, 0)
arrayListFrame.Position = UDim2.new(1, 0, 0, 34)
arrayListFrame.Size = UDim2.new(0, 220, 0, 340)
arrayListFrame.BackgroundTransparency = 1
arrayListFrame.Parent = hudContainer

local arrayLayout = Instance.new("UIListLayout")
arrayLayout.FillDirection = Enum.FillDirection.Vertical
arrayLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
arrayLayout.SortOrder = Enum.SortOrder.LayoutOrder
arrayLayout.Padding = UDim.new(0, 2)
arrayLayout.Parent = arrayListFrame

-- 2. Target HUD Card (Bottom-Center above Hotbar when KillAura locks a target)
local targetHudCard = Instance.new("Frame")
targetHudCard.Name = "TargetHUD"
targetHudCard.AnchorPoint = Vector2.new(0.5, 1)
targetHudCard.Position = UDim2.new(0.5, 150, 1, -110)
targetHudCard.Size = UDim2.new(0, 210, 0, 58)
targetHudCard.BackgroundColor3 = Color3.fromRGB(18, 19, 25)
targetHudCard.BackgroundTransparency = 0.1
targetHudCard.BorderSizePixel = 0
targetHudCard.Visible = false
targetHudCard.Parent = vapeScreen

local thCorner = Instance.new("UICorner")
thCorner.CornerRadius = UDim.new(0, 7)
thCorner.Parent = targetHudCard

local thStroke = Instance.new("UIStroke")
thStroke.Color = VAPE_ACCENT
thStroke.Thickness = 1.3
thStroke.Transparency = 0.25
thStroke.Parent = targetHudCard

local thTitle = Instance.new("TextLabel")
thTitle.Position = UDim2.new(0, 12, 0, 7)
thTitle.Size = UDim2.new(1, -24, 0, 18)
thTitle.BackgroundTransparency = 1
thTitle.Font = Enum.Font.GothamBold
thTitle.TextSize = 13
thTitle.TextColor3 = VAPE_TEXT
thTitle.TextXAlignment = Enum.TextXAlignment.Left
thTitle.Text = "Target"
thTitle.Parent = targetHudCard

local thSub = Instance.new("TextLabel")
thSub.Position = UDim2.new(0, 12, 0, 24)
thSub.Size = UDim2.new(1, -24, 0, 14)
thSub.BackgroundTransparency = 1
thSub.Font = Enum.Font.GothamMedium
thSub.TextSize = 11
thSub.TextColor3 = VAPE_MUTED
thSub.TextXAlignment = Enum.TextXAlignment.Left
thSub.Text = "20.0 HP | 3.2m"
thSub.Parent = targetHudCard

local thBarBg = Instance.new("Frame")
thBarBg.Position = UDim2.new(0, 12, 1, -12)
thBarBg.Size = UDim2.new(1, -24, 0, 5)
thBarBg.BackgroundColor3 = Color3.fromRGB(36, 38, 48)
thBarBg.BorderSizePixel = 0
thBarBg.Parent = targetHudCard

local thBarCorner = Instance.new("UICorner")
thBarCorner.CornerRadius = UDim.new(1, 0)
thBarCorner.Parent = thBarBg

local thBarFill = Instance.new("Frame")
thBarFill.Size = UDim2.new(1, 0, 1, 0)
thBarFill.BackgroundColor3 = VAPE_ACCENT
thBarFill.BorderSizePixel = 0
thBarFill.Parent = thBarBg

local thBarFillCorner = Instance.new("UICorner")
thBarFillCorner.CornerRadius = UDim.new(1, 0)
thBarFillCorner.Parent = thBarFill

-- 3. Floating Toggle Pill Button (Mobile + PC Quick Toggle)
local togglePill = Instance.new("TextButton")
togglePill.Name = "VapeTogglePill"
togglePill.AnchorPoint = Vector2.new(0, 0.5)
togglePill.Position = UDim2.new(0, 14, 0.5, -120)
togglePill.Size = UDim2.new(0, 96, 0, 32)
togglePill.BackgroundColor3 = Color3.fromRGB(18, 19, 24)
togglePill.BackgroundTransparency = 0.08
togglePill.BorderSizePixel = 0
togglePill.Font = Enum.Font.GothamBold
togglePill.TextSize = 12
togglePill.TextColor3 = VAPE_TEXT
togglePill.RichText = true
togglePill.Text = "<font color='#05d594'>VAPE</font> V4 [RShift]"
togglePill.AutoButtonColor = true
togglePill.Parent = vapeScreen

local pillCorner = Instance.new("UICorner")
pillCorner.CornerRadius = UDim.new(1, 0)
pillCorner.Parent = togglePill

local pillStroke = Instance.new("UIStroke")
pillStroke.Color = VAPE_ACCENT
pillStroke.Thickness = 1.3
pillStroke.Transparency = 0.2
pillStroke.Parent = togglePill

-- 4. Click-GUI Container (Holds Vape V4 Category Columns)
local clickGuiFrame = Instance.new("Frame")
clickGuiFrame.Name = "ClickGUI"
clickGuiFrame.Size = UDim2.fromScale(1, 1)
clickGuiFrame.BackgroundColor3 = Color3.fromRGB(6, 7, 10)
clickGuiFrame.BackgroundTransparency = 0.45
clickGuiFrame.BorderSizePixel = 0
clickGuiFrame.Visible = VapeConfig.guiOpen
clickGuiFrame.Parent = vapeScreen

local topHint = Instance.new("TextLabel")
topHint.AnchorPoint = Vector2.new(0.5, 0)
topHint.Position = UDim2.new(0.5, 0, 0, 16)
topHint.Size = UDim2.new(0, 460, 0, 22)
topHint.BackgroundTransparency = 1
topHint.Font = Enum.Font.GothamBold
topHint.TextSize = 12
topHint.TextColor3 = Color3.fromRGB(190, 200, 215)
topHint.RichText = true
topHint.Text = "<font color='#05d594'>VAPE V4</font>  |  Left-Click: Toggle  |  Right-Click / Gear: Settings  |  [RightShift]: Hide GUI"
topHint.Parent = clickGuiFrame

local moduleRefreshCallbacks = {}
local activeBindListening = nil

local function updateArrayList()
    for _, ch in ipairs(arrayListFrame:GetChildren()) do
        if ch:IsA("Frame") then
            ch:Destroy()
        end
    end
    if not VapeConfig.arrayList then
        return
    end

    local activeMods = {}
    if VapeConfig.KillAura.enabled then
        table.insert(activeMods, {
            name = "KillAura",
            suffix = string.format("%.1fm", tonumber(VapeConfig.KillAura.range) or 4.2)
        })
    end
    if VapeConfig.Scaffold.enabled then
        table.insert(activeMods, {
            name = "Scaffold",
            suffix = VapeConfig.Scaffold.keepY and "KeepY" or "Normal"
        })
    end
    if VapeConfig.Fly.enabled then
        table.insert(activeMods, {
            name = "Fly",
            suffix = VapeConfig.Fly.mode or "AirWalk"
        })
    end
    if VapeConfig.AimAssist.enabled then
        table.insert(activeMods, {
            name = "AimAssist",
            suffix = string.format("%d deg", math.floor(tonumber(VapeConfig.AimAssist.fov) or 95))
        })
    end

    table.sort(activeMods, function(a, b)
        return #(a.name .. " " .. a.suffix) > #(b.name .. " " .. b.suffix)
    end)

    for idx, m in ipairs(activeMods) do
        local fullStr = string.format("<font color='#05d594'>%s</font> <font color='#a0a8b8'>%s</font>", m.name, m.suffix)
        local rawLen = #m.name + #m.suffix + 1
        local rowW = math.clamp(rawLen * 7 + 22, 85, 220)

        local row = Instance.new("Frame")
        row.Name = m.name
        row.LayoutOrder = idx
        row.Size = UDim2.new(0, rowW, 0, 22)
        row.BackgroundColor3 = Color3.fromRGB(16, 17, 22)
        row.BackgroundTransparency = 0.16
        row.BorderSizePixel = 0
        row.Parent = arrayListFrame

        local rCorner = Instance.new("UICorner")
        rCorner.CornerRadius = UDim.new(0, 4)
        rCorner.Parent = row

        local sideBar = Instance.new("Frame")
        sideBar.AnchorPoint = Vector2.new(1, 0)
        sideBar.Position = UDim2.new(1, 0, 0, 0)
        sideBar.Size = UDim2.new(0, 3, 1, 0)
        sideBar.BackgroundColor3 = VAPE_ACCENT
        sideBar.BorderSizePixel = 0
        sideBar.Parent = row

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -12, 1, 0)
        lbl.Position = UDim2.new(0, 4, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 12
        lbl.TextColor3 = VAPE_TEXT
        lbl.TextXAlignment = Enum.TextXAlignment.Right
        lbl.RichText = true
        lbl.Text = fullStr
        lbl.Parent = row
    end
end

local function makeDraggableWindow(winFrame, dragHandle)
    local dragging = false
    local dragStart = nil
    local startPos = nil

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = winFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            winFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local function createVapeCategoryWindow(title, iconTag, posX)
    local panel = Instance.new("Frame")
    panel.Name = "Panel_" .. title
    panel.Position = UDim2.new(0, posX, 0, 62)
    panel.Size = UDim2.new(0, 215, 0, 36)
    panel.AutomaticSize = Enum.AutomaticSize.Y
    panel.BackgroundColor3 = VAPE_BG
    panel.BackgroundTransparency = 0.04
    panel.BorderSizePixel = 0
    panel.Parent = clickGuiFrame

    local pCorner = Instance.new("UICorner")
    pCorner.CornerRadius = UDim.new(0, 6)
    pCorner.Parent = panel

    local pStroke = Instance.new("UIStroke")
    pStroke.Color = Color3.fromRGB(38, 41, 52)
    pStroke.Thickness = 1
    pStroke.Parent = panel

    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 34)
    header.BackgroundColor3 = VAPE_HEADER
    header.BorderSizePixel = 0
    header.Parent = panel

    local hCorner = Instance.new("UICorner")
    hCorner.CornerRadius = UDim.new(0, 6)
    hCorner.Parent = header

    local accentTop = Instance.new("Frame")
    accentTop.Size = UDim2.new(1, 0, 0, 2)
    accentTop.Position = UDim2.new(0, 0, 0, 0)
    accentTop.BackgroundColor3 = VAPE_ACCENT
    accentTop.BorderSizePixel = 0
    accentTop.Parent = header

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Position = UDim2.new(0, 12, 0, 0)
    titleLbl.Size = UDim2.new(1, -40, 1, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextColor3 = VAPE_TEXT
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.RichText = true
    titleLbl.Text = string.format("<font color='#05d594'>%s</font>  %s", iconTag, title)
    titleLbl.Parent = header

    local body = Instance.new("Frame")
    body.Name = "Body"
    body.Position = UDim2.new(0, 0, 0, 34)
    body.Size = UDim2.new(1, 0, 0, 0)
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.BackgroundTransparency = 1
    body.Parent = panel

    local bodyLayout = Instance.new("UIListLayout")
    bodyLayout.FillDirection = Enum.FillDirection.Vertical
    bodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
    bodyLayout.Padding = UDim.new(0, 1)
    bodyLayout.Parent = body

    local bodyPad = Instance.new("UIPadding")
    bodyPad.PaddingBottom = UDim.new(0, 6)
    bodyPad.Parent = body

    makeDraggableWindow(panel, header)
    return body
end

local modOrderCounter = 0
local function createVapeModule(parentBody, modKey, displayName, description, onToggleCallback)
    modOrderCounter = modOrderCounter + 1
    local cfg = VapeConfig[modKey]

    local wrap = Instance.new("Frame")
    wrap.Name = "Mod_" .. modKey
    wrap.LayoutOrder = modOrderCounter
    wrap.Size = UDim2.new(1, 0, 0, 34)
    wrap.AutomaticSize = Enum.AutomaticSize.Y
    wrap.BackgroundTransparency = 1
    wrap.Parent = parentBody

    local wrapLayout = Instance.new("UIListLayout")
    wrapLayout.FillDirection = Enum.FillDirection.Vertical
    wrapLayout.SortOrder = Enum.SortOrder.LayoutOrder
    wrapLayout.Parent = wrap

    local modBtn = Instance.new("TextButton")
    modBtn.Name = "ToggleBtn"
    modBtn.LayoutOrder = 1
    modBtn.Size = UDim2.new(1, 0, 0, 34)
    modBtn.BorderSizePixel = 0
    modBtn.Text = ""
    modBtn.AutoButtonColor = false
    modBtn.Parent = wrap

    local modNameLbl = Instance.new("TextLabel")
    modNameLbl.Position = UDim2.new(0, 12, 0, 0)
    modNameLbl.Size = UDim2.new(1, -86, 1, 0)
    modNameLbl.BackgroundTransparency = 1
    modNameLbl.Font = Enum.Font.GothamSemibold
    modNameLbl.TextSize = 13
    modNameLbl.TextXAlignment = Enum.TextXAlignment.Left
    modNameLbl.Text = displayName
    modNameLbl.Parent = modBtn

    local bindBtn = Instance.new("TextButton")
    bindBtn.Name = "BindBtn"
    bindBtn.AnchorPoint = Vector2.new(1, 0.5)
    bindBtn.Position = UDim2.new(1, -30, 0.5, 0)
    bindBtn.Size = UDim2.new(0, 44, 0, 20)
    bindBtn.BackgroundColor3 = Color3.fromRGB(14, 15, 19)
    bindBtn.BackgroundTransparency = 0.2
    bindBtn.BorderSizePixel = 0
    bindBtn.Font = Enum.Font.GothamBold
    bindBtn.TextSize = 10
    bindBtn.TextColor3 = VAPE_MUTED
    bindBtn.Text = "[" .. tostring(cfg.bind or "None") .. "]"
    bindBtn.Parent = modBtn

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 4)
    bCorner.Parent = bindBtn

    local gearBtn = Instance.new("TextButton")
    gearBtn.Name = "GearBtn"
    gearBtn.AnchorPoint = Vector2.new(1, 0.5)
    gearBtn.Position = UDim2.new(1, -6, 0.5, 0)
    gearBtn.Size = UDim2.new(0, 20, 0, 20)
    gearBtn.BackgroundTransparency = 1
    gearBtn.Font = Enum.Font.GothamBold
    gearBtn.TextSize = 12
    gearBtn.TextColor3 = VAPE_MUTED
    gearBtn.Text = "+"
    gearBtn.Parent = modBtn

    local drawer = Instance.new("Frame")
    drawer.Name = "SettingsDrawer"
    drawer.LayoutOrder = 2
    drawer.Size = UDim2.new(1, 0, 0, 0)
    drawer.AutomaticSize = Enum.AutomaticSize.Y
    drawer.BackgroundColor3 = VAPE_DRAWER_BG
    drawer.BorderSizePixel = 0
    drawer.Visible = false
    drawer.Parent = wrap

    local dLayout = Instance.new("UIListLayout")
    dLayout.FillDirection = Enum.FillDirection.Vertical
    dLayout.SortOrder = Enum.SortOrder.LayoutOrder
    dLayout.Padding = UDim.new(0, 6)
    dLayout.Parent = drawer

    local dPad = Instance.new("UIPadding")
    dPad.PaddingTop = UDim.new(0, 8)
    dPad.PaddingBottom = UDim.new(0, 8)
    dPad.PaddingLeft = UDim.new(0, 12)
    dPad.PaddingRight = UDim.new(0, 12)
    dPad.Parent = drawer

    local descLbl = Instance.new("TextLabel")
    descLbl.LayoutOrder = 0
    descLbl.Size = UDim2.new(1, 0, 0, 14)
    descLbl.BackgroundTransparency = 1
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 10
    descLbl.TextColor3 = VAPE_MUTED
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.Text = description
    descLbl.Parent = drawer

    local function refreshVisual()
        local on = cfg.enabled == true
        TweenService:Create(modBtn, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = on and VAPE_MODULE_ON or VAPE_MODULE_OFF
        }):Play()
        modNameLbl.TextColor3 = on and Color3.fromRGB(12, 16, 18) or VAPE_TEXT
        gearBtn.TextColor3 = on and Color3.fromRGB(16, 22, 24) or VAPE_MUTED
        bindBtn.Text = "[" .. tostring(cfg.bind or "None") .. "]"
        updateArrayList()
    end

    local function toggleModule(forceState)
        if type(forceState) == "boolean" then
            cfg.enabled = forceState
        else
            cfg.enabled = not cfg.enabled
        end
        if onToggleCallback then
            pcall(onToggleCallback, cfg.enabled)
        end
        refreshVisual()
        saveVapeConfig()
    end

    moduleRefreshCallbacks[modKey] = {
        toggle = toggleModule,
        refresh = refreshVisual
    }

    modBtn.MouseButton1Click:Connect(function()
        toggleModule()
    end)

    local function toggleDrawer()
        drawer.Visible = not drawer.Visible
        gearBtn.Text = drawer.Visible and "-" or "+"
    end

    modBtn.MouseButton2Click:Connect(toggleDrawer)
    gearBtn.MouseButton1Click:Connect(toggleDrawer)

    bindBtn.MouseButton1Click:Connect(function()
        bindBtn.Text = "[...]"
        bindBtn.TextColor3 = VAPE_ACCENT
        activeBindListening = {
            modKey = modKey,
            cfg = cfg,
            btn = bindBtn,
            refresh = refreshVisual
        }
    end)

    refreshVisual()
    return drawer
end

local settingOrder = 0
local function addVapeSlider(drawer, cfgTable, key, labelText, minVal, maxVal, stepVal, suffix)
    settingOrder = settingOrder + 1
    local row = Instance.new("Frame")
    row.LayoutOrder = settingOrder
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundTransparency = 1
    row.Parent = drawer

    local topLbl = Instance.new("TextLabel")
    topLbl.Size = UDim2.new(1, 0, 0, 14)
    topLbl.BackgroundTransparency = 1
    topLbl.Font = Enum.Font.GothamMedium
    topLbl.TextSize = 11
    topLbl.TextColor3 = VAPE_TEXT
    topLbl.TextXAlignment = Enum.TextXAlignment.Left
    topLbl.Parent = row

    local barBg = Instance.new("TextButton")
    barBg.Position = UDim2.new(0, 0, 0, 19)
    barBg.Size = UDim2.new(1, 0, 0, 7)
    barBg.BackgroundColor3 = Color3.fromRGB(32, 34, 44)
    barBg.BorderSizePixel = 0
    barBg.Text = ""
    barBg.AutoButtonColor = false
    barBg.Parent = row

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(1, 0)
    bCorner.Parent = barBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0.5, 0, 1, 0)
    fill.BackgroundColor3 = VAPE_ACCENT
    fill.BorderSizePixel = 0
    fill.Parent = barBg

    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(1, 0)
    fCorner.Parent = fill

    local function setValue(v)
        local snapped = math.floor((v - minVal) / stepVal + 0.5) * stepVal + minVal
        snapped = math.clamp(snapped, minVal, maxVal)
        if stepVal >= 1 then
            snapped = math.floor(snapped + 0.5)
            topLbl.Text = string.format("%s: %d%s", labelText, snapped, suffix or "")
        else
            snapped = tonumber(string.format("%.2f", snapped)) or snapped
            topLbl.Text = string.format("%s: %.1f%s", labelText, snapped, suffix or "")
        end
        cfgTable[key] = snapped
        local pct = math.clamp((snapped - minVal) / math.max(0.0001, maxVal - minVal), 0, 1)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        updateArrayList()
        saveVapeConfig()
    end

    setValue(tonumber(cfgTable[key]) or minVal)

    local sliding = false
    local function updateFromInput(input)
        local absPos = barBg.AbsolutePosition.X
        local absSize = math.max(1, barBg.AbsoluteSize.X)
        local rel = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
        setValue(minVal + rel * (maxVal - minVal))
    end

    barBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            updateFromInput(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromInput(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
end

local function addVapeToggleOption(drawer, cfgTable, key, labelText, onChanged)
    settingOrder = settingOrder + 1
    local btn = Instance.new("TextButton")
    btn.LayoutOrder = settingOrder
    btn.Size = UDim2.new(1, 0, 0, 22)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = drawer

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -38, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.TextColor3 = VAPE_TEXT
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = labelText
    lbl.Parent = btn

    local box = Instance.new("Frame")
    box.AnchorPoint = Vector2.new(1, 0.5)
    box.Position = UDim2.new(1, 0, 0.5, 0)
    box.Size = UDim2.new(0, 28, 0, 14)
    box.BorderSizePixel = 0
    box.Parent = btn

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(1, 0)
    bCorner.Parent = box

    local knob = Instance.new("Frame")
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.BackgroundColor3 = Color3.fromRGB(245, 248, 255)
    knob.BorderSizePixel = 0
    knob.Parent = box

    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(1, 0)
    kCorner.Parent = knob

    local function refresh()
        local on = cfgTable[key] == true
        box.BackgroundColor3 = on and VAPE_ACCENT or Color3.fromRGB(40, 42, 54)
        knob.Position = on and UDim2.new(1, -12, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
    end

    btn.MouseButton1Click:Connect(function()
        cfgTable[key] = not cfgTable[key]
        refresh()
        if onChanged then
            pcall(onChanged, cfgTable[key])
        end
        updateArrayList()
        saveVapeConfig()
    end)

    refresh()
end

local function addVapeModeSelector(drawer, cfgTable, key, labelText, modesList)
    settingOrder = settingOrder + 1
    local btn = Instance.new("TextButton")
    btn.LayoutOrder = settingOrder
    btn.Size = UDim2.new(1, 0, 0, 24)
    btn.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    btn.TextColor3 = VAPE_TEXT
    btn.RichText = true
    btn.Parent = drawer

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 4)
    bCorner.Parent = btn

    local function refresh()
        btn.Text = string.format("%s: <font color='#05d594'>%s</font>", labelText, tostring(cfgTable[key]))
    end

    btn.MouseButton1Click:Connect(function()
        local cur = cfgTable[key]
        local idx = table.find(modesList, cur) or 1
        local nextIdx = (idx % #modesList) + 1
        cfgTable[key] = modesList[nextIdx]
        refresh()
        updateArrayList()
        saveVapeConfig()
    end)

    refresh()
end

-- Build the 3 Vape V4 Category Panels: COMBAT, BLATANT, WORLD
local combatBody = createVapeCategoryWindow("Combat", "[C]", 60)
local blatantBody = createVapeCategoryWindow("Blatant", "[B]", 290)
local worldBody = createVapeCategoryWindow("World", "[W]", 520)

-- Module 1: AimAssist (Combat)
local aimDrawer = createVapeModule(combatBody, "AimAssist", "AimAssist", "Smoothly aims camera toward nearest fighter", nil)
addVapeSlider(aimDrawer, VapeConfig.AimAssist, "range", "Range", 3.0, 10.0, 0.5, "m")
addVapeSlider(aimDrawer, VapeConfig.AimAssist, "fov", "FOV Angle", 15, 180, 5, " deg")
addVapeSlider(aimDrawer, VapeConfig.AimAssist, "speed", "Smooth Speed", 2, 25, 1, "")
addVapeToggleOption(aimDrawer, VapeConfig.AimAssist, "clickOnly", "Require Mouse Down")
addVapeToggleOption(aimDrawer, VapeConfig.AimAssist, "inLobby", "Active in Lobby")

-- Module 2: KillAura (Combat)
local kaDrawer = createVapeModule(combatBody, "KillAura", "KillAura", "Auto-attacks enemies in reach with silent aim", function(on)
    if not on then
        currentAuraTarget = nil
        targetHudCard.Visible = false
    end
end)
addVapeSlider(kaDrawer, VapeConfig.KillAura, "range", "Reach", 3.0, 4.8, 0.1, "m")
addVapeSlider(kaDrawer, VapeConfig.KillAura, "fov", "Max Angle", 45, 360, 15, " deg")
addVapeModeSelector(kaDrawer, VapeConfig.KillAura, "mode", "Attack Mode", { "1.9+ Cooldown", "Spam CPS" })
addVapeSlider(kaDrawer, VapeConfig.KillAura, "cps", "Spam CPS", 4, 20, 1, " CPS")
addVapeToggleOption(kaDrawer, VapeConfig.KillAura, "autoWeapon", "Auto-Switch Best Sword")
addVapeToggleOption(kaDrawer, VapeConfig.KillAura, "autoCritSprint", "Force Sprint Knockback")
addVapeToggleOption(kaDrawer, VapeConfig.KillAura, "inLobby", "Active in Lobby")

-- Module 3: Fly AirWalk (Blatant)
local flyDrawer = createVapeModule(blatantBody, "Fly", "Fly (AirWalk)", "Walk, sprint & jump on air without falling", function(on)
    if on then
        local f = getFeetBlockPos()
        airWalkY = f and f.Y or nil
    else
        airWalkY = nil
        clearAirWalkFloor()
    end
end)
addVapeModeSelector(flyDrawer, VapeConfig.Fly, "mode", "Y-Level Mode", { "AirWalk", "StepUp" })
addVapeToggleOption(flyDrawer, VapeConfig.Fly, "sneakDown", "Sneak (Shift) to Descend")
addVapeToggleOption(flyDrawer, VapeConfig.Fly, "autoSprint", "Auto-Sprint on Air")

-- Module 4: Scaffold (World)
local scafDrawer = createVapeModule(worldBody, "Scaffold", "Scaffold", "Automatically places blocks below your feet", function(on)
    if on then
        local f = getFeetBlockPos()
        scaffoldBaseY = f and math.floor(f.Y - 0.01) or nil
    else
        scaffoldBaseY = nil
    end
end)
addVapeToggleOption(scafDrawer, VapeConfig.Scaffold, "autoBlock", "Auto-Select Block Slot")
addVapeSlider(scafDrawer, VapeConfig.Scaffold, "expand", "Look-Ahead Blocks", 1, 3, 1, "")
addVapeToggleOption(scafDrawer, VapeConfig.Scaffold, "keepY", "Keep-Y (Speed Telly/Flat)")
addVapeToggleOption(scafDrawer, VapeConfig.Scaffold, "tower", "Fast Tower on Jump")

-- Sync Click-GUI visibility & mouse unlock
local function setVapeGuiOpen(openState)
    VapeConfig.guiOpen = openState == true
    clickGuiFrame.Visible = VapeConfig.guiOpen
    if CameraMod then
        CameraMod.uiOpen = VapeConfig.guiOpen or (UiMod and type(UiMod.isOpen) == "function" and UiMod.isOpen() == true)
    end
    saveVapeConfig()
end

setVapeGuiOpen(VapeConfig.guiOpen)

togglePill.MouseButton1Click:Connect(function()
    setVapeGuiOpen(not VapeConfig.guiOpen)
end)

-- Keybind handler for GUI toggle & Module binds
table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not watcherActive then
        return
    end
    local hasFocusedBox = false
    pcall(function()
        hasFocusedBox = UserInputService:GetFocusedTextBox() ~= nil
    end)
    if hasFocusedBox then
        return
    end

    local uType = nil
    local kName = nil
    pcall(function()
        uType = input.UserInputType
        kName = input.KeyCode and input.KeyCode.Name or nil
    end)

    if activeBindListening and uType == Enum.UserInputType.Keyboard and kName then
        if kName == "Escape" or kName == "Backspace" or kName == "Delete" then
            activeBindListening.cfg.bind = "None"
        else
            activeBindListening.cfg.bind = kName
        end
        activeBindListening.btn.TextColor3 = VAPE_MUTED
        activeBindListening.refresh()
        activeBindListening = nil
        saveVapeConfig()
        return
    end

    if uType == Enum.UserInputType.Keyboard and kName then
        if kName == (VapeConfig.toggleKey or "RightShift") then
            setVapeGuiOpen(not VapeConfig.guiOpen)
            return
        end

        if not gameProcessed then
            for modKey, cb in pairs(moduleRefreshCallbacks) do
                local cfg = VapeConfig[modKey]
                if cfg and type(cfg.bind) == "string" and cfg.bind ~= "None" and cfg.bind == kName then
                    cb.toggle()
                end
            end
        end
    end
end))

-- Main RenderStepped & Heartbeat Loop for AimAssist, KillAura, Scaffold, AirWalk Fallback & TargetHUD
table.insert(connections, RunService.RenderStepped:Connect(function(dt)
    if not watcherActive then
        return
    end

    -- Keep cursor unlocked while Vape V4 ClickGUI is open
    if VapeConfig.guiOpen then
        if CameraMod then
            CameraMod.uiOpen = true
            CameraMod.cursorFree = true
        end
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    end

    -- 1. AimAssist
    pcall(stepAimAssist, dt)

    -- 2. AirWalk Fly backup enforcement (in case PlayerPhysics.step hook wasn't loaded yet)
    if VapeConfig.Fly.enabled and isLocalAlive() then
        if MovementMod and type(MovementMod.state) == "function" then
            local st = MovementMod.state()
            if type(st) == "table" and typeof(st.pos) == "Vector3" then
                if not airWalkY then
                    airWalkY = st.pos.Y
                end
                local hasBox = false
                pcall(function()
                    hasBox = UserInputService:GetFocusedTextBox() ~= nil
                end)
                local sneaking = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and not hasBox
                if not (VapeConfig.Fly.sneakDown and sneaking) then
                    if st.pos.Y < airWalkY then
                        st.pos = Vector3.new(st.pos.X, airWalkY, st.pos.Z)
                        st.onGround = true
                        st.fallDistance = 0
                    end
                else
                    airWalkY = st.pos.Y
                end
            end
        end
    end

    -- 3. KillAura & Scaffold
    pcall(stepKillAura)
    pcall(stepScaffold)

    -- 4. Update Target HUD
    pcall(function()
        if VapeConfig.targetHud and VapeConfig.KillAura.enabled and currentAuraTarget and currentAuraTarget.hrp and currentAuraTarget.hrp.Parent then
            targetHudCard.Visible = true
            thTitle.Text = tostring(currentAuraTarget.name or "Fighter")
            local hp = (currentAuraTarget.hum and currentAuraTarget.hum.Health) or 20
            local maxHp = (currentAuraTarget.hum and currentAuraTarget.hum.MaxHealth) or 20
            if maxHp <= 0 then
                maxHp = 20
            end
            local pct = math.clamp(hp / maxHp, 0, 1)
            thSub.Text = string.format("%.1f / %.0f HP  |  %.1fm", hp, maxHp, tonumber(currentAuraTarget.distBlocks) or 0)
            thBarFill.Size = UDim2.new(pct, 0, 1, 0)
        else
            targetHudCard.Visible = false
        end
    end)
end))

-- Notify user in-game
pcall(function()
    if Hud and type(Hud.notify) == "function" then
        Hud.notify("\194\167a\194\167lVAPE V4 + UNLOCK ALL READY! \194\167f[RightShift] GUI | 37 Capes + 14 Kill FX + 13 Win FX!", 5)
    elseif LobbyUi and type(LobbyUi.notify) == "function" then
        LobbyUi.notify("\194\167a\194\167lVAPE V4 + UNLOCK ALL READY! \194\167f[RightShift] GUI | 37 Capes + 14 Kill FX + 13 Win FX!")
    end
end)

env._YDX_TOF_CLEANUP = function()
    watcherActive = false
    env._YDX_TOF_SHOP_HANDLER = nil
    env._YDX_TOF_SILENT_ROT = nil
    clearAirWalkFloor()
    if CameraMod then
        CameraMod.uiOpen = false
    end
    if vapeScreen and vapeScreen.Parent then
        pcall(function()
            vapeScreen:Destroy()
        end)
    end
    if PlayerPhysicsMod and env._YDX_TOF_ORIG_PPSTEP then
        PlayerPhysicsMod.step = env._YDX_TOF_ORIG_PPSTEP
    end
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
