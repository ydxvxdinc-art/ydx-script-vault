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
-- Pure ASCII | All 44 Capes (37 Base + 7 Custom GIF Capes) + All 14 Kill FX + All 13 Win FX + Skin + Fast Skip Spin
-- + 0-Damage Multi-Layer NoFall + Anti-Rollback AirWalk Fly + AutoMace + Persistent Preset Saving + 20Hz P2P Sync
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
local PhysicsMod = MC and MC:FindFirstChild("Physics") and require(MC.Physics) or nil
local AssetsMod = MC and MC:FindFirstChild("Assets") and require(MC.Assets) or nil
local PixelsMod = MC and MC:FindFirstChild("Pixels") and require(MC.Pixels) or nil
local ActionRemote = MCRemotes and MCRemotes:WaitForChild("Action", 10)
local MotionRemote = MCRemotes and MCRemotes:FindFirstChild("Motion") or nil
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

-- ============================================================================
-- 3B. REGISTER 7 CUSTOM ANIMATED GIF CAPES (NATIVE 6-FACE ATLASES + PARTICLES + GLOW)
-- ============================================================================
local CUSTOM_GIF_CAPES = {
    {
        id = "starlight_moon",
        name = "Starlight Moon",
        rarity = "mythic",
        sheet = 4,
        fps = 10,
        rect = { 0, 0 },
        frames = { { 0, 0 }, { 22, 0 }, { 44, 0 }, { 66, 0 }, { 88, 0 }, { 110, 0 }, { 132, 0 }, { 0, 17 }, { 22, 17 } },
        glow = { brightness = 2.0, rect = { 1, 1, 8, 14 } },
        fx = {
            rate = 7,
            lifetime = NumberRange.new(0.6, 1.2),
            speed = NumberRange.new(0.3, 1.1),
            size = 0.22,
            light = 1,
            accel = Vector3.new(0, 0.4, 0),
            colors = { Color3.fromRGB(215, 140, 255), Color3.fromRGB(255, 225, 255) }
        }
    },
    {
        id = "sakura_moon",
        name = "Moonlit Sakura",
        rarity = "mythic",
        sheet = 4,
        fps = 10,
        rect = { 44, 17 },
        frames = { { 44, 17 }, { 66, 17 }, { 88, 17 }, { 110, 17 }, { 132, 17 }, { 0, 34 }, { 22, 34 }, { 44, 34 }, { 66, 34 }, { 88, 34 }, { 110, 34 }, { 132, 34 }, { 0, 51 }, { 22, 51 } },
        glow = { brightness = 2.0, rect = { 1, 1, 8, 14 } },
        fx = {
            rate = 8,
            lifetime = NumberRange.new(0.7, 1.35),
            speed = NumberRange.new(0.4, 1.2),
            size = 0.24,
            light = 0.9,
            accel = Vector3.new(0.3, -0.5, 0),
            colors = { Color3.fromRGB(255, 150, 215), Color3.fromRGB(255, 220, 245) }
        }
    },
    {
        id = "pastel_clouds",
        name = "Pastel Dawn",
        rarity = "legendary",
        sheet = 4,
        fps = 10,
        rect = { 44, 51 },
        frames = { { 44, 51 }, { 66, 51 }, { 88, 51 }, { 110, 51 }, { 132, 51 }, { 0, 68 }, { 22, 68 }, { 44, 68 }, { 66, 68 }, { 88, 68 }, { 110, 68 }, { 132, 68 }, { 0, 85 }, { 22, 85 } },
        glow = { brightness = 1.85, rect = { 1, 1, 8, 14 } },
        fx = {
            rate = 6,
            lifetime = NumberRange.new(0.6, 1.1),
            speed = NumberRange.new(0.3, 0.9),
            size = 0.22,
            light = 0.85,
            accel = Vector3.new(0, 0.3, 0),
            colors = { Color3.fromRGB(255, 175, 220), Color3.fromRGB(190, 165, 255) }
        }
    },
    {
        id = "shenron_dragon",
        name = "Dragon God",
        rarity = "limited",
        sheet = 4,
        fps = 10,
        rect = { 44, 85 },
        frames = { { 44, 85 }, { 66, 85 }, { 88, 85 }, { 110, 85 }, { 132, 85 }, { 0, 102 }, { 22, 102 } },
        glow = { brightness = 2.2, rect = { 1, 1, 8, 14 } },
        fx = {
            rate = 9,
            lifetime = NumberRange.new(0.55, 1.05),
            speed = NumberRange.new(0.5, 1.4),
            size = 0.25,
            light = 1,
            accel = Vector3.new(0, 0.8, 0),
            colors = { Color3.fromRGB(255, 200, 50), Color3.fromRGB(255, 70, 35) }
        }
    },
    {
        id = "neon_cash",
        name = "Neon Cash",
        rarity = "limited",
        sheet = 4,
        fps = 14,
        rect = { 44, 102 },
        frames = { { 44, 102 }, { 66, 102 }, { 88, 102 }, { 110, 102 }, { 132, 102 }, { 0, 119 }, { 22, 119 }, { 44, 119 }, { 66, 119 }, { 88, 119 }, { 110, 119 }, { 132, 119 }, { 0, 136 }, { 22, 136 }, { 44, 136 } },
        glow = { brightness = 2.3, rect = { 1, 1, 8, 14 } },
        fx = {
            rate = 9,
            lifetime = NumberRange.new(0.5, 1.0),
            speed = NumberRange.new(0.5, 1.3),
            size = 0.24,
            light = 1,
            accel = Vector3.new(0, 0.6, 0),
            colors = { Color3.fromRGB(35, 255, 100), Color3.fromRGB(255, 45, 75) }
        }
    },
    {
        id = "nuclear_core",
        name = "Nuclear Core",
        rarity = "mythic",
        sheet = 5,
        fps = 14,
        rect = { 0, 0 },
        frames = { { 0, 0 }, { 22, 0 }, { 44, 0 }, { 66, 0 }, { 88, 0 }, { 110, 0 }, { 132, 0 }, { 0, 17 }, { 22, 17 }, { 44, 17 }, { 66, 17 }, { 88, 17 }, { 110, 17 }, { 132, 17 } },
        glow = { brightness = 2.25, rect = { 1, 1, 8, 14 } },
        fx = {
            rate = 8,
            lifetime = NumberRange.new(0.5, 1.0),
            speed = NumberRange.new(0.5, 1.3),
            size = 0.24,
            light = 1,
            accel = Vector3.new(0, 0.7, 0),
            colors = { Color3.fromRGB(255, 230, 35), Color3.fromRGB(255, 45, 25) }
        }
    },
    {
        id = "phantom_grave",
        name = "Grave Phantom",
        rarity = "mythic",
        sheet = 5,
        fps = 14,
        rect = { 0, 34 },
        frames = { { 0, 34 }, { 22, 34 }, { 44, 34 }, { 66, 34 }, { 88, 34 }, { 110, 34 }, { 132, 34 }, { 0, 51 }, { 22, 51 }, { 44, 51 }, { 66, 51 }, { 88, 51 }, { 110, 51 }, { 132, 51 }, { 0, 68 }, { 22, 68 }, { 44, 68 }, { 66, 68 }, { 88, 68 }, { 110, 68 }, { 132, 68 }, { 0, 85 }, { 22, 85 }, { 44, 85 } },
        glow = { brightness = 1.95, rect = { 1, 1, 8, 14 } },
        fx = {
            rate = 7,
            lifetime = NumberRange.new(0.65, 1.25),
            speed = NumberRange.new(0.3, 1.0),
            size = 0.23,
            light = 0.9,
            accel = Vector3.new(0, 0.45, 0),
            colors = { Color3.fromRGB(165, 220, 255), Color3.fromRGB(120, 95, 200) }
        }
    }
}

local CUSTOM_CAPE_BY_ID = {}
local CUSTOM_CAPE_SCALED_ORIGIN = {}
local CUSTOM_CAPE_SCALED_FRAMES = {}
local customSheetContents = env._YDX_TOF_CUSTOM_SHEET_CONTENTS or {}
env._YDX_TOF_CUSTOM_SHEET_CONTENTS = customSheetContents

local capeScaleFactor = (AssetsMod and tonumber(AssetsMod.capeScale)) or 6

for _, cDef in ipairs(CUSTOM_GIF_CAPES) do
    CUSTOM_CAPE_BY_ID[cDef.id] = cDef
    CUSTOM_CAPE_SCALED_ORIGIN[cDef.id] = Vector2.new(cDef.rect[1], cDef.rect[2]) * capeScaleFactor
    local scaledList = {}
    for _, fr in ipairs(cDef.frames) do
        table.insert(scaledList, Vector2.new(fr[1], fr[2]) * capeScaleFactor)
    end
    CUSTOM_CAPE_SCALED_FRAMES[cDef.id] = scaledList

    if Config then
        if type(Config.Capes) == "table" then
            Config.Capes[cDef.id] = {
                name = cDef.name,
                rarity = cDef.rarity
            }
        end
        if type(Config.CapeOrder) == "table" and not table.find(Config.CapeOrder, cDef.id) then
            table.insert(Config.CapeOrder, cDef.id)
        end
    end
end

-- Download & cache custom_capes_4.png and custom_capes_5.png locally via getcustomasset
local getcustomassetFn = (type(getcustomasset) == "function" and getcustomasset) or (type(getsynasset) == "function" and getsynasset) or nil

local function ensureCustomCapeSheetLoaded(sheetNum, localFileName, remotePath)
    if customSheetContents[sheetNum] then
        return customSheetContents[sheetNum]
    end
    if not getcustomassetFn or type(writefile) ~= "function" then
        return nil
    end
    local hasFile = false
    if type(isfile) == "function" then
        local okF, ex = pcall(isfile, localFileName)
        if okF and ex then
            local okR, raw = pcall(readfile, localFileName)
            if okR and type(raw) == "string" and #raw > 1024 and raw:sub(2, 4) == "PNG" then
                hasFile = true
            end
        end
    end
    if not hasFile then
        local urls = {
            "https://ydx-script-vault.pages.dev/" .. remotePath,
            "https://raw.githubusercontent.com/ydxvxdinc-art/ydx-script-vault/main/" .. remotePath,
            "https://ydxvxdinc-art.github.io/ydx-script-vault/" .. remotePath
        }
        for _, u in ipairs(urls) do
            local okH, body = pcall(function()
                return game:HttpGet(u)
            end)
            if okH and type(body) == "string" and #body > 1024 and body:sub(2, 4) == "PNG" then
                pcall(writefile, localFileName, body)
                hasFile = true
                break
            end
        end
    end
    if hasFile then
        local okA, assetUri = pcall(getcustomassetFn, localFileName)
        if okA and type(assetUri) == "string" and #assetUri > 0 then
            local okC, contentObj = pcall(Content.fromUri, assetUri)
            if okC and contentObj then
                customSheetContents[sheetNum] = contentObj
                return contentObj
            end
        end
    end
    return nil
end

-- Load cached custom cape sheets immediately if present, and fetch in background if not yet cached
pcall(function()
    if type(isfile) == "function" and isfile("ydx_tof_capes_4.png") then
        ensureCustomCapeSheetLoaded(4, "ydx_tof_capes_4.png", "assets/custom_capes_4.png")
    end
    if type(isfile) == "function" and isfile("ydx_tof_capes_5.png") then
        ensureCustomCapeSheetLoaded(5, "ydx_tof_capes_5.png", "assets/custom_capes_5.png")
    end
end)

-- Hook ReplicatedStorage.MC.Assets so InventoryUi, Shop, LobbyUi.H.capeImage, Chars.preview & Chars.setCape render all 7 custom GIF capes natively!
if AssetsMod then
    env._YDX_TOF_ORIG_CAPEATLAS = env._YDX_TOF_ORIG_CAPEATLAS or AssetsMod.capeAtlas
    env._YDX_TOF_ORIG_CAPEATLASSIZE = env._YDX_TOF_ORIG_CAPEATLASSIZE or AssetsMod.capeAtlasSize
    env._YDX_TOF_ORIG_CAPEORIGIN = env._YDX_TOF_ORIG_CAPEORIGIN or AssetsMod.capeOrigin
    env._YDX_TOF_ORIG_CAPEFRAMES = env._YDX_TOF_ORIG_CAPEFRAMES or AssetsMod.capeFrames

    local origCapeAtlas = env._YDX_TOF_ORIG_CAPEATLAS
    local origCapeAtlasSize = env._YDX_TOF_ORIG_CAPEATLASSIZE
    local origCapeOrigin = env._YDX_TOF_ORIG_CAPEORIGIN
    local origCapeFrames = env._YDX_TOF_ORIG_CAPEFRAMES
    local customAtlasSizeVec = Vector2.new(924, 1020)

    AssetsMod.capeAtlas = function(capeId)
        local cDef = capeId and CUSTOM_CAPE_BY_ID[capeId]
        if cDef then
            local cObj = customSheetContents[cDef.sheet]
            if cObj then
                return cObj
            end
            return origCapeAtlas("portal")
        end
        return origCapeAtlas(capeId)
    end

    AssetsMod.capeAtlasSize = function(capeId)
        if capeId and CUSTOM_CAPE_BY_ID[capeId] then
            return customAtlasSizeVec
        end
        return origCapeAtlasSize(capeId)
    end

    AssetsMod.capeOrigin = function(capeId)
        local sc = capeId and CUSTOM_CAPE_SCALED_ORIGIN[capeId]
        if sc then
            return sc
        end
        return origCapeOrigin(capeId)
    end

    AssetsMod.capeFrames = function(capeId)
        local fr = capeId and CUSTOM_CAPE_SCALED_FRAMES[capeId]
        if fr then
            return fr
        end
        return origCapeFrames(capeId)
    end
end

-- Patch Chars internal upvalue tables (u83 CapeFx particles, u84 CapeGlow emissive overlay, u85 capeFps)
if Chars and debug and debug.getupvalues then
    local visitedCharFns = {}
    local function patchCharsUpvalues(fn, depth)
        if type(fn) ~= "function" or visitedCharFns[fn] or depth > 4 then
            return
        end
        visitedCharFns[fn] = true
        local okU, ups = pcall(debug.getupvalues, fn)
        if not okU or type(ups) ~= "table" then
            return
        end
        for _, val in pairs(ups) do
            if type(val) == "table" then
                -- Detect u83 (particle table: has galaxy.rate and galaxy.colors)
                if type(val.galaxy) == "table" and val.galaxy.rate ~= nil and val.galaxy.colors ~= nil then
                    for _, cDef in ipairs(CUSTOM_GIF_CAPES) do
                        if cDef.fx then
                            val[cDef.id] = cDef.fx
                        end
                    end
                -- Detect u84 (CapeGlow table: has galaxy.brightness and galaxy.rect)
                elseif type(val.galaxy) == "table" and val.galaxy.brightness ~= nil and type(val.galaxy.rect) == "table" then
                    for _, cDef in ipairs(CUSTOM_GIF_CAPES) do
                        if cDef.glow then
                            val[cDef.id] = cDef.glow
                        end
                    end
                -- Detect u85 (capeFps table: has galaxy == 6 and matrix == 12)
                elseif type(val.galaxy) == "number" and (val.matrix ~= nil or val.glitch ~= nil) then
                    for _, cDef in ipairs(CUSTOM_GIF_CAPES) do
                        val[cDef.id] = cDef.fps or 10
                    end
                end
            elseif type(val) == "function" then
                patchCharsUpvalues(val, depth + 1)
            end
        end
    end
    for _, fn in pairs(Chars) do
        if type(fn) == "function" then
            patchCharsUpvalues(fn, 1)
        end
    end
end

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

-- Hook PoFClient.Sync.send & MCRemotes.Sync.OnClientEvent for zero-latency (50ms) in-server P2P cape sync + 0-Damage Multi-Step NoFall!
local lastServerGroundWorldY = nil
local lastSentSyncState = { x = 0, y = 0, z = 0, taggedYaw = 0, taggedPitch = 0, sneak = false }

local function buildAndDispatchSyncBuffer(worldX, worldY, worldZ, taggedYaw, taggedPitch, sneakBool, onGroundBool)
    local b = buffer.create(17)
    buffer.writef32(b, 0, worldX)
    buffer.writef32(b, 4, worldY)
    buffer.writef32(b, 8, worldZ)
    buffer.writei16(b, 12, taggedYaw)
    buffer.writei16(b, 14, taggedPitch)
    buffer.writeu8(b, 16, (sneakBool and 1 or 0) + (onGroundBool and 2 or 0))

    local posVec = Vector3.new(worldX, worldY, worldZ)
    local fakeLagHandler = env._YDX_TOF_FAKELAG_SEND
    if type(fakeLagHandler) == "function" then
        if fakeLagHandler(b, posVec) == true then
            return
        end
    end
    if SyncRemote then
        SyncRemote:FireServer(b)
    end
end

-- Flushes intermediate onGround=true step-down packets every 3.5 studs (1.16 blocks < SafeFallDistance 3.0 blocks)
-- so the server's tracked fallStartY (p86) and fallDistance (p84) never exceed 1.16 blocks and always compute 0 damage!
local function flushNoFallGroundStepsTo(worldX, targetWorldY, worldZ, taggedYaw, taggedPitch, sneakBool)
    local prevY = lastServerGroundWorldY
    if not prevY or targetWorldY >= prevY then
        lastServerGroundWorldY = targetWorldY
        return
    end
    local dropStuds = prevY - targetWorldY
    -- Step down in 3.5-stud (1.16-block) increments if drop > 3.5 studs and <= 120 studs (40 blocks, i.e. not an arena spawn teleport)
    if dropStuds > 3.5 and dropStuds <= 120.0 then
        local stepStuds = 3.5
        local numSteps = math.min(28, math.floor((dropStuds - 0.3) / stepStuds))
        for s = 1, numSteps do
            local interY = prevY - s * stepStuds
            if interY > targetWorldY + 0.3 then
                buildAndDispatchSyncBuffer(worldX, interY, worldZ, taggedYaw, taggedPitch, sneakBool, true)
            end
        end
    end
    lastServerGroundWorldY = targetWorldY
end

env._YDX_TOF_FLUSH_NOFALL_NOW = function(worldPosOverride)
    if not SyncRemote then
        return
    end
    local wx = (worldPosOverride and worldPosOverride.X) or lastSentSyncState.x
    local wy = (worldPosOverride and worldPosOverride.Y) or lastSentSyncState.y
    local wz = (worldPosOverride and worldPosOverride.Z) or lastSentSyncState.z
    flushNoFallGroundStepsTo(wx, wy, wz, lastSentSyncState.taggedYaw, lastSentSyncState.taggedPitch, lastSentSyncState.sneak)
    buildAndDispatchSyncBuffer(wx, wy, wz, lastSentSyncState.taggedYaw, lastSentSyncState.taggedPitch, lastSentSyncState.sneak, true)
end

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
        local capeCode = (activeCape ~= nil) and CAPE_TO_CODE[tostring(activeCape)] or 1

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

        local pitchMod = 50 + capeCode -- 51..95 (supports all 37 base + 7 custom GIF capes)
        local yawMod = (capeCode * 7 + 13) % 50 -- 0..49 checksum

        local clampedPitch = math.clamp(rawPitchI, -15800, 15800)
        local taggedPitch = math.floor(clampedPitch / 100) * 100 + pitchMod

        local clampedYaw = math.clamp(rawYawI, -31350, 31300)
        local taggedYaw = math.floor(clampedYaw / 50) * 50 + yawMod

        local onGroundSpoof = p14
        if type(env._YDX_TOF_SPOOF_ONGROUND) == "function" then
            local okSpoof, spoofVal = pcall(env._YDX_TOF_SPOOF_ONGROUND, p10, p14)
            if okSpoof and type(spoofVal) == "boolean" then
                onGroundSpoof = spoofVal
            end
        end

        lastSentSyncState.x = p10.X
        lastSentSyncState.y = p10.Y
        lastSentSyncState.z = p10.Z
        lastSentSyncState.taggedYaw = taggedYaw
        lastSentSyncState.taggedPitch = taggedPitch
        lastSentSyncState.sneak = (p13 == true)

        if onGroundSpoof then
            flushNoFallGroundStepsTo(p10.X, p10.Y, p10.Z, taggedYaw, taggedPitch, p13 == true)
        elseif not lastServerGroundWorldY then
            lastServerGroundWorldY = p10.Y
        end

        buildAndDispatchSyncBuffer(p10.X, p10.Y, p10.Z, taggedYaw, taggedPitch, p13 == true, onGroundSpoof)
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
                if pMod >= 51 and pMod <= 96 then
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
-- 8. OFFICIAL VAPE V4 GUI + COMBAT / BLATANT / WORLD MODULES
--    (AimAssist [Require Sword/Mace], KillAura, AutoClicker, Backtrack, FakeLag, Fly AirWalk, Scaffold, FastPlace)
-- ============================================================================
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Clean up any previous Vape V4 or old custom GUI instance
pcall(function()
    if shared and shared.vape and type(shared.vape.Uninject) == "function" then
        shared.vape:Uninject()
    end
end)
pcall(function()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        local oldCustom = pg:FindFirstChild("YDX_VapeV4_ToF")
        if oldCustom then
            oldCustom:Destroy()
        end
    end
end)
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

local vape = (function()
local vape = {
	ActiveBinds = {},
	Categories = {},
	GUIColor = {
		Hue = 0.46,
		Sat = 0.96,
		Value = 0.52
	},
	HeldKeybinds = {},
	Loaded = false,
	Libraries = {},
	Modules = {},
	Place = game.PlaceId,
	Profile = 'default',
	RainbowSliders = {},
	Settings = {},
	SettingToggleNotifications = {},
	ThreadFix = false,
	ToggleNotifications = {},
	Version = '4.22',
	Windows = {}
}

local run = function(func)
	func()
end
local cloneref = cloneref or function(obj)
	return obj
end
local tweenService = cloneref(game:GetService('TweenService'))
local inputService = cloneref(game:GetService('UserInputService'))
local textService = cloneref(game:GetService('TextService'))
local guiService = cloneref(game:GetService('GuiService'))
local runService = cloneref(game:GetService('RunService'))
local httpService = cloneref(game:GetService('HttpService'))
local playersService = cloneref(game:GetService('Players'))

local fontsize = Instance.new('GetTextBoundsParams')
fontsize.Width = math.huge
local notifications
local getvapeasset
local components
local clickgui
local scaledgui
local toolblur
local tooltip
local TextGUI
local scale = {Scale = 1}
local gui

local isfile = isfile or function(file)
	local success, data = pcall(function()
		return readfile(file)
	end)

	return success and data ~= nil and data ~= ''
end

local function loadJson(path)
	local success, data = pcall(function()
		return httpService:JSONDecode(readfile(path))
	end)

	return success and type(data) == 'table' and data or nil
end

local color = {}
local uipallet = {}
do
	function color.Dark(col, num)
		local h, s, v = col:ToHSV()
		return Color3.fromHSV(h, s, math.clamp(select(3, uipallet.Main:ToHSV()) > 0.5 and v + num or v - num, 0, 1))
	end

	function color.Light(col, num)
		local h, s, v = col:ToHSV()
		return Color3.fromHSV(h, s, math.clamp(select(3, uipallet.Main:ToHSV()) > 0.5 and v - num or v + num, 0, 1))
	end

	function vape:Color(h)
		local s = 0.74 + (0.26 * math.min(h / 0.045, 1))

		if h > 0.577 then
			s = 1 - (0.48 * math.min((h - 0.577) / 0.088, 1))
		end

		if h > 0.674 then
			s = 0.52 + (0.48 * math.min((h - 0.674) / 0.149, 1))
		end

		if h > 0.869 then
			s = 1 - (0.26 * math.min((h - 0.869) / 0.131, 1))
		end

		return h, s, 1
	end

	function vape:TextColor(h, s, v)
		if v >= 0.7 and (s < 0.6 or h > 0.04 and h < 0.56) then
			return Color3.new(0.19, 0.19, 0.19)
		end

		return Color3.new(1, 1, 1)
	end
end

local function getfontbounds(text, size, font)
	fontsize.Text = text
	fontsize.Size = size
	if typeof(font) == 'Font' then
		fontsize.Font = font
	end

	return textService:GetTextBoundsAsync(fontsize)
end

do
	local vapeAssets = {
		['newvape/assets/new/add.png'] = 'rbxassetid://121642387707174',
		['newvape/assets/new/aim.png'] = 'rbxassetid://122207028123421',
		['newvape/assets/new/allowedicon.png'] = 'rbxassetid://112336790299036',
		['newvape/assets/new/allowediconmini.png'] = 'rbxassetid://90142384730147',
		['newvape/assets/new/back.png'] = 'rbxassetid://80523803497740',
		['newvape/assets/new/backmini.png'] = 'rbxassetid://85859225495272',
		['newvape/assets/new/bind.png'] = 'rbxassetid://81399857677684',
		['newvape/assets/new/bindbkg.png'] = 'rbxassetid://101996225428926',
		['newvape/assets/new/blatant.png'] = 'rbxassetid://126929923309265',
		['newvape/assets/new/blur.png'] = 'rbxassetid://79246816170155',
		['newvape/assets/new/blurnoti.png'] = 'rbxassetid://124705876663719',
		['newvape/assets/new/close.png'] = 'rbxassetid://121816018671466',
		['newvape/assets/new/closemini.png'] = 'rbxassetid://108320409341289',
		['newvape/assets/new/closetiny.png'] = 'rbxassetid://71393233149714',
		['newvape/assets/new/colorpreview.png'] = 'rbxassetid://140438628568318',
		['newvape/assets/new/combat.png'] = 'rbxassetid://94762732349053',
		['newvape/assets/new/customtheme.png'] = 'rbxassetid://91756736022800',
		['newvape/assets/new/discord.png'] = 'rbxassetid://99871463341003',
		['newvape/assets/new/downexpand.png'] = 'rbxassetid://94197751291504',
		['newvape/assets/new/downexpandslider.png'] = 'rbxassetid://90289944682645',
		['newvape/assets/new/edit.png'] = 'rbxassetid://105801951237137',
		['newvape/assets/new/editlarge.png'] = 'rbxassetid://119233876755282',
		['newvape/assets/new/expandarrow.png'] = 'rbxassetid://86360332526471',
		['newvape/assets/new/friends.png'] = 'rbxassetid://92957214042038',
		['newvape/assets/new/inventory.png'] = 'rbxassetid://93264756888499',
		['newvape/assets/new/legit_mode_icon.png'] = 'rbxassetid://102858626075156',
		['newvape/assets/new/legit_switch.png'] = 'rbxassetid://127508881124779',
		['newvape/assets/new/min.png'] = 'rbxassetid://82175054487146',
		['newvape/assets/new/noti_alert.png'] = 'rbxassetid://82356478726846',
		['newvape/assets/new/noti_info.png'] = 'rbxassetid://102614825645099',
		['newvape/assets/new/noti_warning.png'] = 'rbxassetid://119631730212167',
		['newvape/assets/new/notification.png'] = 'rbxassetid://90300780458781',
		['newvape/assets/new/npcs.png'] = 'rbxassetid://104434365485227',
		['newvape/assets/new/overlaydots.png'] = 'rbxassetid://78012624671930',
		['newvape/assets/new/overlays.png'] = 'rbxassetid://136535637407545',
		['newvape/assets/new/overlayslarge.png'] = 'rbxassetid://127574141208160',
		['newvape/assets/new/pin.png'] = 'rbxassetid://92459145800579',
		['newvape/assets/new/players.png'] = 'rbxassetid://105137446428129',
		['newvape/assets/new/profiles.png'] = 'rbxassetid://126051451865127',
		['newvape/assets/new/radar.png'] = 'rbxassetid://97983828696086',
		['newvape/assets/new/rainbow_1.png'] = 'rbxassetid://101329996188554',
		['newvape/assets/new/rainbow_2.png'] = 'rbxassetid://72739074644654',
		['newvape/assets/new/rainbow_3.png'] = 'rbxassetid://100716555253397',
		['newvape/assets/new/rainbow_4.png'] = 'rbxassetid://133424174227092',
		['newvape/assets/new/range.png'] = 'rbxassetid://107794917650053',
		['newvape/assets/new/rangeindicator.png'] = 'rbxassetid://107038094175283',
		['newvape/assets/new/render.png'] = 'rbxassetid://125472576898654',
		['newvape/assets/new/search.png'] = 'rbxassetid://115611852955611',
		['newvape/assets/new/settingdots.png'] = 'rbxassetid://130896840048276',
		['newvape/assets/new/settings.png'] = 'rbxassetid://73820177347303',
		['newvape/assets/new/settingsmini.png'] = 'rbxassetid://115732118290997',
		['newvape/assets/new/targetinfo.png'] = 'rbxassetid://121604266095276',
		['newvape/assets/new/textgui.png'] = 'rbxassetid://99438663817412',
		['newvape/assets/new/theme.png'] = 'rbxassetid://111525258317113',
		['newvape/assets/new/utility.png'] = 'rbxassetid://108303206513893',
		['newvape/assets/new/vape.png'] = 'rbxassetid://92153855792786',
		['newvape/assets/new/vapelogo.png'] = 'rbxassetid://126205920310261',
		['newvape/assets/new/vapelogomini.png'] = 'rbxassetid://109041903452149',
		['newvape/assets/new/v4.png'] = 'rbxassetid://102549752760489',
		['newvape/assets/new/v4mini.png'] = 'rbxassetid://115213099001611',
		['newvape/assets/new/world.png'] = 'rbxassetid://118917453153459'
	}

	local function createDownloader(text)
		if vape.Loaded ~= true then
			local downloader = vape.Downloader
			if not downloader then
				downloader = Instance.new('TextLabel')
				downloader.BackgroundTransparency = 1
				downloader.FontFace = uipallet.Font
				downloader.Size = UDim2.new(1, 0, 0, 40)
				downloader.TextColor3 = Color3.new(1, 1, 1)
				downloader.TextSize = 20
				downloader.TextStrokeTransparency = 0
				downloader.Parent = vape.gui
				vape.Downloader = downloader
			end

			downloader.Text = 'Downloading '..text
		end
	end

	local function downloadFile(path, callback)
		if not isfile(path) then
			createDownloader(path)

			local success, data = pcall(function()
				return game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeCompiled/'..readfile('newvape/profiles/commit.txt')..'/'..select(1, path:gsub('newvape/', '')), true)
			end)

			if not success or data == '404: Not Found' then
				error(data)
			end

			if path:find('.lua') then
				data = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..data
			end

			writefile(path, data)
		end

		return (callback or readfile)(path)
	end

	getvapeasset = function(path)
		return vapeAssets[path] or ''
	end
end

local tween = setmetatable({}, {
	__index = function()
		return {}
	end
})

do
	function tween:Tween(obj, info, goal, index)
		index = self[index or 'tweens']
		if index[obj] then
			index[obj]:Cancel()
			index[obj] = nil
		end

		if obj.Parent and (obj:IsA('UIStroke') or obj.Visible) then
			index[obj] = tweenService:Create(obj, info, goal)
			index[obj].Completed:Once(function()
				if index then
					index[obj] = nil
					index = nil
				end
			end)

			index[obj]:Play()
		else
			for prop, value in goal do
				obj[prop] = value
			end
		end
	end

	function tween:Cancel(obj, index)
		index = self[index or 'tweens']

		if index[obj] then
			index[obj]:Cancel()
			index[obj] = nil
		end
	end
end

uipallet = {
	Main = Color3.fromRGB(26, 25, 26),
	Text = Color3.fromRGB(200, 200, 200),
	Font = Font.fromEnum(Enum.Font.Arial),
	FontSemiBold = Font.fromEnum(Enum.Font.Arial, Enum.FontWeight.SemiBold),
	Tween = TweenInfo.new(0.15, Enum.EasingStyle.Linear)
}

do
	local data = isfile('newvape/profiles/color.txt') and loadJson('newvape/profiles/color.txt')
	if data then
		uipallet.Main = data.Main and Color3.fromRGB(unpack(data.Main)) or uipallet.Main
		uipallet.Text = data.Text and Color3.fromRGB(unpack(data.Text)) or uipallet.Text
		uipallet.Font = data.Font and Font.new(
			data.Font:find('rbxasset') and data.Font
			or string.format('rbxasset://fonts/families/%s.json', data.Font)
		) or uipallet.Font
		uipallet.FontSemiBold = Font.new(uipallet.Font.Family, Enum.FontWeight.SemiBold)
	end

	fontsize.Font = uipallet.Font
end

vape.Libraries = {
	color = color,
	getfontbounds = getfontbounds,
	getvapeasset = getvapeasset,
	tween = tween,
	uipallet = uipallet,
}

local function addBlur(parent, notif, old)
	local blur
	if old then
		blur = Instance.new('ImageLabel')
		blur.Name = 'Blur'
		blur.Size = UDim2.new(1, 89, 1, 52)
		blur.Position = UDim2.fromOffset(-48, -31)
		blur.BackgroundTransparency = 1
		blur.Image = getvapeasset('newvape/assets/new/'..(notif and 'blurnoti' or 'blur')..'.png')
		blur.ScaleType = Enum.ScaleType.Slice
		blur.SliceCenter = Rect.new(52, 31, 261, 502)
		blur.Parent = parent
		else
		local okS, sh = pcall(Instance.new, 'UIShadow')
		if okS and sh then
			blur = sh
			pcall(function() blur.BlurRadius = UDim.new(0, 13) end)
			pcall(function() blur.Transparency = 0.25 end)
			blur.Parent = parent
		else
			blur = Instance.new('ImageLabel')
			blur.Name = 'Blur'
			blur.Size = UDim2.new(1, 89, 1, 52)
			blur.Position = UDim2.fromOffset(-48, -31)
			blur.BackgroundTransparency = 1
			blur.Image = getvapeasset('newvape/assets/new/'..(notif and 'blurnoti' or 'blur')..'.png')
			blur.ScaleType = Enum.ScaleType.Slice
			blur.SliceCenter = Rect.new(52, 31, 261, 502)
			blur.Parent = parent
		end
	end

	return blur
end

local function addCorner(parent, radius)
	local corner = Instance.new('UICorner')
	corner.CornerRadius = radius or UDim.new(0, 5)
	corner.Parent = parent

	return corner
end

local function addCloseButton(parent, mini, offset)
	local close = Instance.new('ImageButton')
	close.AutoButtonColor = false
	close.BackgroundColor3 = Color3.new(1, 1, 1)
	close.BackgroundTransparency = 1
	close.Image = getvapeasset('newvape/assets/new/'..(mini and 'closemini' or 'close')..'.png')
	close.ImageColor3 = color.Light(uipallet.Text, 0.2)
	close.ImageTransparency = 0.5
	close.Name = 'Close'
	close.Position = offset or (mini and UDim2.new(1, -28, 0, 11) or UDim2.new(1, -35, 0, 9))
	close.Size = mini and UDim2.fromOffset(20, 20) or UDim2.fromOffset(24, 24)
	close.Parent = parent
	addCorner(close, UDim.new(1, 0))

	close.MouseEnter:Connect(function()
		close.ImageTransparency = 0.3
		tween:Tween(close, uipallet.Tween, {
			BackgroundTransparency = 0.6
		})
	end)

	close.MouseLeave:Connect(function()
		close.ImageTransparency = 0.5
		tween:Tween(close, uipallet.Tween, {
			BackgroundTransparency = 1
		})
	end)

	return close
end

local function addDragHandler(gui, window)
	gui.InputBegan:Connect(function(input)
		if window and not window.Visible then return end

		if
			(input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
			and (input.Position.Y - gui.AbsolutePosition.Y < 40 or window)
		then
			local dragPosition = Vector2.new(
				gui.AbsolutePosition.X - input.Position.X,
				gui.AbsolutePosition.Y - input.Position.Y + guiService:GetGuiInset().Y
			) / scale.Scale

			local releaseConnection
			local moveConnection = inputService.InputChanged:Connect(function(newInput)
				if newInput.UserInputType == (input.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
					local position = newInput.Position
					if inputService:IsKeyDown(Enum.KeyCode.LeftShift) then
						dragPosition = (dragPosition // 3) * 3
						position = (position // 3) * 3
					end

					gui.Position = UDim2.fromOffset((position.X / scale.Scale) + dragPosition.X, (position.Y / scale.Scale) + dragPosition.Y)
				end
			end)

			releaseConnection = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					moveConnection:Disconnect()
					releaseConnection:Disconnect()
					if vape and type(vape.ScheduleSave) == 'function' then
						vape:ScheduleSave()
					end
				end
			end)
		end
	end)
end

local function addMaid(obj)
	obj.Connections = {}

	function obj:Clean(callback)
		if typeof(callback) == 'Instance' then
			table.insert(self.Connections, {
				Disconnect = function()
					callback:ClearAllChildren()
					callback:Destroy()
				end
			})
		elseif type(callback) == 'thread' then
			table.insert(self.Connections, {
				Disconnect = function()
					if coroutine.status(callback) ~= 'dead' then
						task.cancel(callback)
					end
				end
			})
		elseif type(callback) == 'function' then
			table.insert(self.Connections, {
				Disconnect = callback
			})
		else
			table.insert(self.Connections, callback)
		end
	end
end

local activeTooltipOwner = nil
local tooltipEntryByGui = setmetatable({}, { __mode = 'k' })

local function isGuiActuallyVisible(g)
	if not g or not g.Parent then
		return false
	end
	if clickgui and not clickgui.Visible and (not vape.Legit or not vape.Legit.Window or not vape.Legit.Window.Visible) then
		return false
	end
	local cur = g
	while cur and cur ~= gui do
		if cur:IsA('GuiObject') and not cur.Visible then
			return false
		end
		cur = cur.Parent
	end
	return true
end

local function isMouseInsideGui(g)
	if not isGuiActuallyVisible(g) then
		return false
	end
	local mousePos = inputService:GetMouseLocation() - guiService:GetGuiInset()
	local pos = g.AbsolutePosition
	local sz = g.AbsoluteSize
	return mousePos.X >= pos.X and mousePos.X <= (pos.X + sz.X) and mousePos.Y >= pos.Y and mousePos.Y <= (pos.Y + sz.Y)
end

local function applyTooltipOwner(owner)
	if not owner or not isGuiActuallyVisible(owner) then
		activeTooltipOwner = nil
		tooltip.Visible = false
		vape.CurrentTooltip = nil
		return
	end
	local entry = tooltipEntryByGui[owner]
	if not entry or (entry.visCheck and entry.visCheck()) or (entry.text == '' and not entry.customText) then
		activeTooltipOwner = nil
		tooltip.Visible = false
		vape.CurrentTooltip = nil
		return
	end

	activeTooltipOwner = owner
	tooltip.Text = entry.text or ''
	local tooltipSize = getfontbounds(tooltip.ContentText, tooltip.TextSize, uipallet.Font)
	tooltip.Size = UDim2.fromOffset(tooltipSize.X + 10, tooltipSize.Y + 10)

	if entry.customText then
		vape.CurrentTooltip = entry.callback
		entry.callback()
	else
		vape.CurrentTooltip = nil
	end

	local mousePos = inputService:GetMouseLocation()
	entry.moved(mousePos.X, mousePos.Y)
end

local function addTooltip(gui, text, customText, visCheck)
	if not text and not customText then return end

	local function tooltipMoved(x, y)
		if activeTooltipOwner ~= gui then
			return
		end
		if (visCheck and visCheck()) or not isGuiActuallyVisible(gui) then
			tooltip.Visible = false
			return
		end

		local isRight = x + 16 + tooltip.Size.X.Offset > (scale.Scale * 1920)
		tooltip.Position = UDim2.fromOffset(
			(isRight and x - (tooltip.Size.X.Offset * scale.Scale) - 16 or x + 16) / scale.Scale,
			((y + 11) - (tooltip.Size.Y.Offset / 2)) / scale.Scale
		)

		tooltip.Visible = toolblur.Enabled
	end

	local function callback()
		if activeTooltipOwner ~= gui then
			return
		end
		local newText = customText()
		tooltip.Text = newText
		local tooltipSize = getfontbounds(tooltip.ContentText, tooltip.TextSize, uipallet.Font)
		tooltip.Size = UDim2.fromOffset(tooltipSize.X + 10, tooltipSize.Y + 10)
	end

	tooltipEntryByGui[gui] = {
		text = text,
		customText = customText,
		visCheck = visCheck,
		moved = tooltipMoved,
		callback = callback
	}

	local function releaseOwner()
		if activeTooltipOwner ~= gui then
			return
		end
		local p = gui.Parent
		while p and p ~= scaledgui and p ~= gui do
			if tooltipEntryByGui[p] and isMouseInsideGui(p) then
				applyTooltipOwner(p)
				return
			end
			p = p.Parent
		end
		activeTooltipOwner = nil
		tooltip.Visible = false
		vape.CurrentTooltip = nil
	end

	gui.MouseEnter:Connect(function(x, y)
		if (visCheck and visCheck()) or not isGuiActuallyVisible(gui) then
			return
		end
		if activeTooltipOwner and activeTooltipOwner ~= gui and activeTooltipOwner:IsDescendantOf(gui) and isMouseInsideGui(activeTooltipOwner) then
			return
		end
		applyTooltipOwner(gui)
		tooltipMoved(x, y)
	end)
	gui.MouseMoved:Connect(tooltipMoved)
	gui.MouseLeave:Connect(function()
		releaseOwner()
	end)
	gui:GetPropertyChangedSignal('Visible'):Connect(function()
		if not gui.Visible then
			releaseOwner()
		end
	end)
end

local function createSignal()
	local signal = {
		Connections = {}
	}

	function signal:Connect(callback)
		table.insert(self.Connections, callback)

		return {
			Disconnect = function()
				local index = table.find(signal.Connections, callback)
				if index then
					table.remove(signal.Connections, index)
				end
			end
		}
	end

	function signal:Fire(...)
		for _, callback in self.Connections do
			task.spawn(callback, ...)
		end
	end

	return signal
end

local function checkKeybinds(compare, target, key)
	if type(target) == 'table' then
		if table.find(target, key) then
			for _, key in target do
				if not table.find(compare, key) then
					return false
				end
			end

			return true
		end
	end

	return false
end

local function getPlayerFromText(text)
	if text ~= '' then
		for _, plr in playersService:GetPlayers() do
			if plr.Name:sub(1, #text):lower() == text:lower() then
				return plr.Name
			end
		end
	end
end

local function getTableSize(dict)
	local size = 0
	for _ in dict do
		size += 1
	end

	return size
end

local function loopClean(obj)
	for index, value in obj do
		if type(value) == 'table' then
			loopClean(value)
		end

		obj[index] = nil
	end
end

local function randomString()
	local array = {}
	for i = 1, math.random(10, 100) do
		array[i] = string.char(math.random(32, 126))
	end

	return table.concat(array)
end

local function removeTags(text)
	text = text:gsub('<br%s*/>', '\n')
	return text:gsub('<[^<>]->', '')
end

function vape:BlurCheck()
	if self.ThreadFix then
		setthreadidentity(8)
		runService:SetRobloxGuiFocused((clickgui.Visible or guiService:GetErrorType() ~= Enum.ConnectionError.OK) and self.Blur.Enabled)
	end
end

function vape:CreateCategory(props)
	return components.Category(props)
end

function vape:CreateCategoryList(props)
	return components.CategoryList(props)
end

function vape:CreateNotification(title, text, duration, type)
	if not self.Notifications.Enabled then
		return
	end

	task.delay(0, function()
		if self.ThreadFix then
			setthreadidentity(8)
		end

		local index = #notifications:GetChildren() + 1
		local notification = Instance.new('ImageLabel')
		notification.BackgroundTransparency = 1
		notification.Position = UDim2.new(1, 0, 1, -(29 + (78 * index)))
		notification.Image = getvapeasset('newvape/assets/new/notification.png')
		notification.ScaleType = Enum.ScaleType.Slice
		notification.SliceCenter = Rect.new(7, 7, 9, 9)
		notification.ZIndex = 5
		notification.Parent = notifications
		addBlur(notification, true, true)
		local iconshadow = Instance.new('ImageLabel')
		iconshadow.BackgroundTransparency = 1
		iconshadow.Image = getvapeasset('newvape/assets/new/noti_'..(type or 'info')..'.png')
		iconshadow.ImageColor3 = Color3.new()
		iconshadow.ImageTransparency = 0.5
		iconshadow.Position = UDim2.fromOffset(-5, -8)
		iconshadow.Size = UDim2.fromOffset(60, 60)
		iconshadow.ZIndex = 5
		iconshadow.Parent = notification
		local icon = iconshadow:Clone()
		icon.ImageColor3 = Color3.new(1, 1, 1)
		icon.ImageTransparency = 0
		icon.Position = UDim2.fromOffset(-1, -1)
		icon.Parent = iconshadow
		local label = Instance.new('TextLabel')
		label.AutoLocalize = false
		label.BackgroundTransparency = 1
		label.FontFace = uipallet.FontSemiBold
		label.Position = UDim2.fromOffset(46, 16)
		label.RichText = true
		label.Size = UDim2.new(1, -56, 0, 20)
		label.Text = "<stroke joins='round' thickness='0.3' transparency='0.5'>"..title..'</stroke>'
		label.TextColor3 = type == 'alert' and Color3.fromRGB(250, 50, 56) or Color3.new(1, 1, 1)
		label.TextSize = 14
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextYAlignment = Enum.TextYAlignment.Top
		label.ZIndex = 5
		label.Parent = notification
		local textshadow = Instance.fromExisting(label)
		textshadow.FontFace = uipallet.Font
		textshadow.Position = UDim2.fromOffset(47, 44)
		textshadow.RichText = false
		textshadow.Text = removeTags(text)
		textshadow.TextColor3 = Color3.new()
		textshadow.TextTransparency = 0.5
		textshadow.Parent = notification
		notification.Size = UDim2.fromOffset(math.max(getfontbounds(textshadow.Text, 14, uipallet.Font).X + 80, 266), 75)
		local textlabel = Instance.fromExisting(textshadow)
		textlabel.Position = UDim2.fromOffset(-1, -1)
		textlabel.RichText = true
		textlabel.Text = text
		textlabel.TextColor3 = Color3.fromRGB(170, 170, 170)
		textlabel.TextTransparency = 0
		textlabel.Parent = textshadow
		local progress = Instance.new('Frame')
		progress.BackgroundColor3 =
			type == 'alert' and Color3.fromRGB(250, 50, 56)
			or type == 'warning' and Color3.fromRGB(236, 129, 44)
			or Color3.new(1, 1, 1)
		progress.BorderSizePixel = 0
		progress.Position = UDim2.new(0, 3, 1, -4)
		progress.Size = UDim2.new(1, -13, 0, 1)
		progress.ZIndex = 5
		progress.Parent = notification

		if tween.Tween then
			tween:Tween(notification, TweenInfo.new(0.326, Enum.EasingStyle.Exponential), {
				AnchorPoint = Vector2.new(1, 0)
			}, 'tweenstwo')

			tween:Tween(progress, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
				Size = UDim2.fromOffset(0, 1)
			})
		end

		task.delay(duration, function()
			if tween.Tween then
				tween:Tween(notification, TweenInfo.new(0.326, Enum.EasingStyle.Exponential), {
					AnchorPoint = Vector2.new(0, 0)
				}, 'tweenstwo')
			end

			task.wait(0.2)
			notification:ClearAllChildren()
			notification:Destroy()
		end)
	end)
end

function vape:CreateOverlay(props)
	return components.Overlay(props)
end

function vape:Load(skipgui, profile)
	pcall(function() if makefolder then pcall(makefolder, 'newvape'); pcall(makefolder, 'newvape/profiles') end end)
	local guiData = {Categories = {}}
	local oldProfile = self.Profile
	local canSave = true
	local toggleCount = 0

	if isfile('newvape/profiles/'..game.GameId..'.gui.txt') then
		guiData = loadJson('newvape/profiles/'..game.GameId..'.gui.txt')
		if not guiData then
			guiData = {Categories = {}}
			self:CreateNotification('Vape', 'Failed to load GUI settings.', 10, 'alert')
			canSave = false
		end

		if guiData.v ~= 1 then
			guiData.Categories.Main = nil
		end

		self.Profile = profile or guiData.Profile or 'default'
		if self.ProfileLabel then
			self.ProfileLabel.Text = #self.Profile > 10 and self.Profile:sub(1, 10)..'...' or self.Profile
			self.ProfileLabel.Size = UDim2.fromOffset(getfontbounds(self.ProfileLabel.Text, self.ProfileLabel.TextSize, self.ProfileLabel.Font).X + 16, 24)
		end

		if not skipgui then
			for name, data in guiData.Categories do
				local category = self.Categories[name]
				if category then
					category:Load(data)
				end
			end
		end
	end

	if not self.Categories.Profiles:GetValue('default') then
		self.Categories.Profiles:ChangeValue('default', true)
	end

	if isfile('newvape/profiles/'..self.Profile..self.Place..'.txt') then
		local mainData = loadJson('newvape/profiles/'..self.Profile..self.Place..'.txt')
		if not mainData then
			mainData = {Categories = {}, Modules = {}, Legit = {}}
			self:CreateNotification('Vape', 'Failed to load '..self.Profile..' profile.', 10, 'alert')
			canSave = false
		end

		if mainData.v ~= 1 then
			for _, data in mainData.Modules do
				data.Bind = {Keys = data.Bind}
				data.Visible = true
			end
		end

		for name, data in mainData.Categories do
			local category = self.Categories[name]
			if category then
				category:Load(data)
			end
		end

		for name, data in mainData.Modules do
			local module = self.Modules[name]
			if module then
				module:Load(data)
				toggleCount += module.Enabled and 1 or 0
			end
		end

		for name, data in mainData.Legit do
			local module = self.Legit.Modules[name]
			if module then
				module:Load(data)
			end
		end

		self:UpdateTextGUI(true)
	else
		self:Save()
	end

	if self.Profile ~= oldProfile and skipgui then
		self:CreateNotification('Profile swap to <font color="#FFAA00">'..self.Profile..'</font>', toggleCount..' modules enabled', 3)
	end

	if self.Downloader then
		self.Downloader:Destroy()
		self.Downloader = nil
	end

	self.Loaded = canSave
	if not isfile('newvape/profiles/'..self.Profile..self.Place..'.txt') then
		self:Save()
	end

	if inputService.TouchEnabled and not skipgui then
		local button = Instance.new('TextButton')
		button.BackgroundColor3 = Color3.new()
		button.BackgroundTransparency = 0.2
		button.Position = UDim2.new(1, -90, 0, 4)
		button.Size = UDim2.fromOffset(32, 32)
		button.Text = ''
		button.Parent = gui
		local image = Instance.new('ImageLabel')
		image.BackgroundTransparency = 1
		image.Image = getvapeasset('newvape/assets/new/vape.png')
		image.Position = UDim2.fromOffset(6, 6)
		image.Size = UDim2.fromOffset(20, 20)
		image.Parent = button
		addCorner(button, UDim.new(1, 0))

		button.MouseButton1Click:Connect(function()
			self.GUIBind.Triggered:Fire(true)
		end)
	end

	return toggleData
end

function vape:LoadOptions(obj, data)
	for name, componentData in data do
		local component = obj.Options[name]

		if component then
			component:Load(componentData)
		end
	end
end

function vape:LoadGUI()
	addMaid(vape)
	gui = Instance.new('ScreenGui')
	gui.Name = randomString()
	gui.DisplayOrder = 9999999
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	gui.IgnoreGuiInset = true
	
	if vape.ThreadFix then
		local holder = Instance.new('Folder')
		holder.Parent = cloneref(game:GetService('CoreGui'))
		gui.OnTopOfCoreBlur = true
		gui.Parent = (gethui and gethui()) or cloneref(game:GetService('CoreGui'))
		vape.holder = holder
	else
		gui.Parent = cloneref(game:GetService('Players')).LocalPlayer.PlayerGui
		gui.ResetOnSpawn = false
		vape.holder = gui
	end
	vape.gui = gui
	
	scaledgui = Instance.new('Frame')
	scaledgui.BackgroundTransparency = 1
	scaledgui.Name = 'ScaledGui'
	scaledgui.Size = UDim2.fromScale(1, 1)
	scaledgui.Parent = gui
	clickgui = Instance.new('Frame')
	clickgui.BackgroundTransparency = 1
	clickgui.Name = 'ClickGui'
	clickgui.Size = UDim2.fromScale(1, 1)
	clickgui.Visible = false
	clickgui.Parent = scaledgui
	local scarcitybanner = Instance.new('TextLabel')
	scarcitybanner.BackgroundTransparency = 1
	scarcitybanner.FontFace = uipallet.Font
	scarcitybanner.Position = UDim2.fromScale(0, 0.97)
	scarcitybanner.Size = UDim2.fromScale(1, 0.018)
	scarcitybanner.Text = 'All update logs and game support are found in the discord, click the discord icon to join.'
	scarcitybanner.TextColor3 = Color3.new(1, 1, 1)
	scarcitybanner.TextScaled = true
	scarcitybanner.TextStrokeTransparency = 0.5
	scarcitybanner.Parent = clickgui
	local modal = Instance.new('TextButton')
	modal.BackgroundTransparency = 1
	modal.Modal = true
	modal.Text = ''
	modal.Parent = clickgui
	local cursor = Instance.new('ImageLabel')
	cursor.BackgroundTransparency = 1
	cursor.Image = 'rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png'
	cursor.Size = UDim2.fromOffset(64, 64)
	cursor.Visible = false
	cursor.Parent = gui
	notifications = Instance.new('Folder')
	notifications.Name = 'Notifications'
	notifications.Parent = scaledgui
	tooltip = Instance.new('TextLabel')
	tooltip.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
	tooltip.FontFace = uipallet.Font
	tooltip.Position = UDim2.fromScale(-1, -1)
	tooltip.RichText = true
	tooltip.Text = ''
	tooltip.TextColor3 = color.Dark(uipallet.Text, 0.16)
	tooltip.TextSize = 12
	tooltip.Visible = false
	tooltip.ZIndex = 5
	tooltip.Parent = scaledgui
	toolblur = addBlur(tooltip)
	addCorner(tooltip)
	scale = Instance.new('UIScale')
	scale.Scale = math.max(gui.AbsoluteSize.X / 1920, 0.6)
	scale.Parent = scaledgui
	scaledgui.Size = UDim2.fromScale(1 / scale.Scale, 1 / scale.Scale)
	components.GUI({})
	
	vape:CreateCategory({
		Name = 'Combat',
		Icon = getvapeasset('newvape/assets/new/combat.png'),
		Size = UDim2.fromOffset(13, 14)
	})
	vape:CreateCategory({
		Name = 'Blatant',
		Icon = getvapeasset('newvape/assets/new/blatant.png'),
		Size = UDim2.fromOffset(14, 14)
	})
	vape:CreateCategory({
		Name = 'Render',
		Icon = getvapeasset('newvape/assets/new/render.png'),
		Size = UDim2.fromOffset(15, 14)
	})
	vape:CreateCategory({
		Name = 'Utility',
		Icon = getvapeasset('newvape/assets/new/utility.png'),
		Size = UDim2.fromOffset(15, 14)
	})
	vape:CreateCategory({
		Name = 'World',
		Icon = getvapeasset('newvape/assets/new/world.png'),
		Size = UDim2.fromOffset(14, 14)
	})
	vape:CreateCategory({
		Name = 'Inventory',
		Icon = getvapeasset('newvape/assets/new/inventory.png'),
		Size = UDim2.fromOffset(15, 14)
	})
	vape.Categories.Main:CreateDivider({
		Text = 'misc'
	})
	
	--[[
		Friends
	]]
	do
		local friends
		local friendscolor = {
			Hue = 1,
			Sat = 1,
			Value = 1
		}
	
		friends = vape:CreateCategoryList({
			Name = 'Friends',
			Icon = getvapeasset('newvape/assets/new/friends.png'),
			Size = UDim2.fromOffset(17, 16),
			Placeholder = 'Roblox username',
			Color = Color3.fromRGB(5, 134, 105),
			Player = true,
			Function = function()
				friends.Update:Fire()
				friends.ColorUpdate:Fire(friendscolor.Hue, friendscolor.Sat, friendscolor.Value)
			end
		})
		friends.Update = Instance.new('BindableEvent')
		friends.ColorUpdate = Instance.new('BindableEvent')
		friends:CreateToggle({
			Name = 'Recolor visuals',
			Darker = true,
			Default = true,
			Function = function()
				friends.Update:Fire()
				friends.ColorUpdate:Fire(friendscolor.Hue, friendscolor.Sat, friendscolor.Value)
			end
		})
		friendscolor = friends:CreateColorSlider({
			Name = 'Friends color',
			Darker = true,
			Function = function(hue, sat, val)
				for _, v in friends.Object.Children:GetChildren() do
					local dot = v:FindFirstChild('Dot')
					if dot and dot.BackgroundColor3 ~= color.Light(uipallet.Main, 0.37) then
						dot.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
						dot.Dot.BackgroundColor3 = dot.BackgroundColor3
					end
				end
	
				friends.ColorUpdate:Fire(hue, sat, val)
			end
		})
		friends:CreateToggle({
			Name = 'Use friends',
			Darker = true,
			Default = true,
			Function = function()
				friends.Update:Fire()
				friends.ColorUpdate:Fire(friendscolor.Hue, friendscolor.Sat, friendscolor.Value)
			end
		})
		vape:Clean(friends.Update)
		vape:Clean(friends.ColorUpdate)
	end
	
	--[[
		Profiles
	]]
	vape:CreateCategoryList({
		Name = 'Profiles',
		Icon = getvapeasset('newvape/assets/new/profiles.png'),
		Size = UDim2.fromOffset(17, 10),
		Position = UDim2.fromOffset(12, 16),
		Placeholder = 'Type name',
		Profiles = true
	})
	
	--[[
		Targets
	]]
	local targets
	targets = vape:CreateCategoryList({
		Name = 'Targets',
		Icon = getvapeasset('newvape/assets/new/friends.png'),
		Size = UDim2.fromOffset(17, 16),
		Placeholder = 'Roblox username',
		Player = true,
		Function = function()
			targets.Update:Fire()
		end
	})
	targets.Update = Instance.new('BindableEvent')
	vape:Clean(targets.Update)
	
	components.LegitWindow()
	vape.SearchBar = components.SearchBar()
	vape.Categories.Main:CreateOverlayBar()
	
	--[[
		General Settings
	]]
	
	local general = vape.Categories.Main.Settings:CreateSettingsPane({Name = 'General'})
	local settingConnections = {}
	vape.MultiKeybind = general:CreateToggle({
		Name = 'Enable Multi-Keybinding',
		Tooltip = 'Allows multiple keys to be bound to a module (eg. G + H)'
	})
	general:CreateToggle({
		Name = 'Allow setting keybinds',
		Function = function(callback)
			if callback then
				for _, container in {vape.Modules, vape.Legit.Modules} do
					for _, module in container do
						for _, component in module.Options do
							if component.Type == 'Toggle' then
								local bind = components.Bind({
									Module = true
								}, nil, component)
								bind.Object.Position = UDim2.new(1, -40, 0, 5)
	
								table.insert(settingConnections, bind.Triggered:Connect(function(isDown)
									if bind.Hold then
										if component.Enabled ~= isDown then
											if vape.SettingToggleNotifications.Enabled then
												vape:CreateNotification(module.Name, component.Name..' '..(not component.Enabled and "<font color='#00AA00'>ON</font>" or "<font color='#FF5A5A'>OFF</font>"), 1.5)
											end
	
											component:Toggle()
										end
									else
										if vape.SettingToggleNotifications.Enabled then
											vape:CreateNotification(module.Name, component.Name..' '..(not component.Enabled and "<font color='#00AA00'>ON</font>" or "<font color='#FF5A5A'>OFF</font>"), 1.5)
										end
	
										component:Toggle()
									end
								end))
	
								table.insert(settingConnections, component.Object.MouseEnter:Connect(function()
									bind:SetVisible(true)
								end))
	
								table.insert(settingConnections, component.Object.MouseLeave:Connect(function()
									bind:SetVisible(false)
								end))
							end
						end
					end
				end
			else
				for _, container in {vape.Modules, vape.Legit.Modules} do
					for _, module in container do
						for _, component in module.Options do
							if component.Bind then
								component.Bind:Destroy()
							end
						end
					end
				end
	
				for _, connection in settingConnections do
					connection:Disconnect()
				end
				table.clear(settingConnections)
			end
		end,
		Tooltip = 'Hover a toggle setting to bind it to a key'
	})
	
	general:CreateButton({
		Name = 'Reset current profile',
		Function = function()
		vape.Save = function() end
			if isfile('newvape/profiles/'..vape.Profile..vape.Place..'.txt') and delfile then
				delfile('newvape/profiles/'..vape.Profile..vape.Place..'.txt')
			end
	
			shared.vapereload = true
			if shared.VapeDeveloper then
				loadstring(readfile('newvape/loader.lua'), 'loader')()
			else
				loadstring(game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeCompiled/'..readfile('newvape/profiles/commit.txt')..'/loader.lua', true))()
			end
		end,
		Tooltip = 'This will set your profile to the default settings of Vape'
	})
	
	general:CreateButton({
		Name = 'Self destruct',
		Function = function()
			vape:Uninject()
		end,
		Tooltip = 'Removes vape from the current game'
	})
	
	general:CreateButton({
		Name = 'Reinject',
		Function = function()
			shared.vapereload = true
			if shared.VapeDeveloper then
				loadstring(readfile('newvape/loader.lua'), 'loader')()
			else
				loadstring(game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeCompiled/'..readfile('newvape/profiles/commit.txt')..'/loader.lua', true))()
			end
		end,
		Tooltip = 'Reloads vape for debugging purposes'
	})
	
	--[[
		Module Settings
	]]
	
	local modules = vape.Categories.Main.Settings:CreateSettingsPane({Name = 'Modules'})
	modules:CreateToggle({
		Name = 'Teams by server',
		Tooltip = 'Ignore players on your team designated by the server',
		Default = true,
		Function = function()
			if vape.Libraries.entity and vape.Libraries.entity.Running then
				vape.Libraries.entity.refresh()
			end
		end
	})
	
	modules:CreateToggle({
		Name = 'Use team color',
		Tooltip = 'Uses the TeamColor property on players for render modules',
		Default = true,
		Function = function()
			if vape.Libraries.entity and vape.Libraries.entity.Running then
				vape.Libraries.entity.refresh()
			end
		end
	})
	
	--[[
		GUI Settings
	]]
	
	local guipane = vape.Categories.Main.Settings:CreateSettingsPane({Name = 'GUI'})
	vape.Blur = guipane:CreateToggle({
		Name = 'Blur background',
		Function = function()
			vape:BlurCheck()
		end,
		Default = true,
		Tooltip = 'Blur the background of the GUI'
	})
	
	guipane:CreateToggle({
		Name = 'GUI bind indicator',
		Default = true,
		Tooltip = "Displays a message indicating your GUI upon injecting.\nI.E. 'Press RSHIFT to open GUI'"
	})
	
	guipane:CreateToggle({
		Name = 'Show tooltips',
		Function = function(enabled)
			tooltip.Visible = false
			toolblur.Enabled = enabled
		end,
		Default = true,
		Tooltip = 'Toggles visibility of these'
	})
	
	guipane:CreateToggle({
		Name = 'Show legit mode',
		Function = function(enabled)
			clickgui.Search.Legit.Visible = enabled
			clickgui.Search.LegitDivider.Visible = enabled
			clickgui.Search.TextBox.Size = UDim2.new(1, enabled and -50 or -10, 0, 37)
			clickgui.Search.TextBox.Position = UDim2.fromOffset(enabled and 50 or 10, 0)
		end,
		Default = true,
		Tooltip = 'Shows the button to switch to the legit mod menu'
	})
	
	local ScaleSlider = {Object = {}, Value = 1}
	vape.Scale = guipane:CreateToggle({
		Name = 'Auto rescale',
		Default = true,
		Function = function(callback)
			ScaleSlider.Object.Visible = not callback
			if callback then
				--scale.Scale = math.max(gui.AbsoluteSize.X / 1920, 0.6)
			else
				scale.Scale = ScaleSlider.Value
			end
		end,
		Tooltip = 'Automatically rescales the gui using the screens resolution'
	})
	
	ScaleSlider = guipane:CreateSlider({
		Name = 'Scale',
		Min = 0.1,
		Max = 2,
		Decimal = 10,
		Function = function(val, final)
			if final and not vape.Scale.Enabled then
				scale.Scale = val
			end
		end,
		Default = 1,
		Darker = true,
		Visible = false
	})
	
	vape.RainbowSpeed = guipane:CreateSlider({
		Name = 'Rainbow speed',
		Min = 0.1,
		Max = 10,
		Decimal = 10,
		Default = 1,
		Tooltip = 'Adjusts the speed of rainbow values'
	})
	
	vape.RainbowUpdateSpeed = guipane:CreateSlider({
		Name = 'Rainbow update rate',
		Min = 1,
		Max = 144,
		Default = 60,
		Tooltip = 'Adjusts the update rate of rainbow values',
		Suffix = 'hz'
	})
	
	--[[guipane:CreateDropdown({
		Name = 'GUI Theme',
		List = inputService.TouchEnabled and {'new', 'old'} or {'new', 'old', 'rise'},
		Function = function(val, mouse)
			if mouse then
				writefile('newvape/profiles/gui.txt', val)
				shared.vapereload = true
				if shared.VapeDeveloper then
					loadstring(readfile('newvape/loader.lua'), 'loader')()
				else
					loadstring(game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeCompiled/'..readfile('newvape/profiles/commit.txt')..'/loader.lua', true))()
				end
			end
		end,
		Tooltip = 'new - The newest vape theme to since v4.05\nold - The vape theme pre v4.05\nrise - Rise 6.0'
	})]]
	
	guipane:CreateDropdown({
		Name = 'Search bar style',
		List = {'Floating', 'None'},
		Default = 'Floating',
		Function = function(value)
			vape.SearchBar.Object.Visible = value == 'Floating'
		end,
		Tooltip = 'Switch between search bar styles'
	})
	
	vape.RainbowMode = guipane:CreateDropdown({
		Name = 'Rainbow Mode',
		List = {'Normal', 'Gradient', 'Retro'},
		Tooltip = 'Normal - Smooth color fade\nGradient - Gradient color fade\nRetro - Static color'
	})
	
	guipane:CreateButton({
		Name = 'Reset GUI positions',
		Function = function()
			for _, category in vape.Categories do
				category.Object.Position = UDim2.fromOffset(6, 42)
			end
		end,
		Tooltip = 'This will reset your GUI back to the default'
	})
	
	guipane:CreateButton({
		Name = 'Sort GUI',
		Function = function()
			local priority = {
				GUICategory = 1,
				CombatCategory = 2,
				BlatantCategory = 3,
				RenderCategory = 4,
				UtilityCategory = 5,
				WorldCategory = 6,
				InventoryCategory = 7,
				FriendsCategory = 8,
				ProfilesCategory = 9
			}
	
			local categories = {}
			for _, category in vape.Categories do
				if category.Type ~= 'Overlay' then
					table.insert(categories, category)
				end
			end
	
			table.sort(categories, function(a, b)
				return (priority[a.Object.Name] or 99) < (priority[b.Object.Name] or 99)
			end)
	
			local index = 0
			for _, category in categories do
				if category.Object.Visible then
					category.Object.Position = UDim2.fromOffset(6 + (index % 8 * 230), 60 + (index > 7 and 360 or 0))
					index += 1
				end
			end
		end,
		Tooltip = 'Sorts GUI by category order'
	})
	
	--[[
		Notification Settings
	]]
	
	local notifpane = vape.Categories.Main.Settings:CreateSettingsPane({Name = 'Notifications'})
	vape.Notifications = notifpane:CreateToggle({
		Name = 'Notifications',
		Function = function(enabled)
			if vape.ToggleNotifications.Object then
				vape.ToggleNotifications.Object.Visible = enabled
			end
	
			if vape.SettingToggleNotifications.Object then
				vape.SettingToggleNotifications.Object.Visible = enabled
			end
		end,
		Tooltip = 'Shows notifications',
		Default = true
	})
	
	vape.ToggleNotifications = notifpane:CreateToggle({
		Name = 'Toggle alert',
		Tooltip = 'Notifies you if a module is enabled/disabled.',
		Default = true,
		Darker = true
	})
	vape.SettingToggleNotifications = notifpane:CreateToggle({
		Name = 'Setting toggle alert',
		Tooltip = 'Notifies you when a bound setting is toggled.',
		Default = true,
		Darker = true
	})
	
	vape.GUIColor = vape.Categories.Main.Settings:CreateGUISlider({
		Name = 'GUI Theme',
		Function = function(h, s, v)
			vape:UpdateGUI()
		end
	})
	
	vape.GUIBind = vape.Categories.Main.Settings:CreateBind({
		Name = 'Rebind GUI',
		Default = {'RightShift'},
		NoRemove = true,
		Tooltip = 'Change the bind of the GUI'
	})
	
	run(function()
		local Sort
		local FontOption
		local ColorSlider
		local ColorMode
		local Scale
		local Shadow
		local Gradient
		local GradientV4
		local Animations
		local Watermark
		local Background
		local BackgroundTransparency
		local BackgroundTint
		local HideModules
		local HideModulesList
		local HideRender
		local CustomText
		local CustomTextBox
		local CustomTextFont
		local CustomTextColor
		local CustomTextColorSlider
		local Labels = {}
		local info = TweenInfo.new(0.3, Enum.EasingStyle.Exponential)
		
		local function findValidLabel(labels, index, dir)
			local label = labels[index + dir]
			if label then
				if label.Size ~= UDim2.fromOffset() then
					return label
				else
					return findValidLabel(labels, index + dir, dir)
				end
			end
		end
		
		TextGUI = vape:CreateOverlay({
			Name = 'Text GUI',
			Icon = getvapeasset('newvape/assets/new/textgui.png'),
			Size = UDim2.fromOffset(16, 12),
			Position = UDim2.fromOffset(12, 14),
			Function = function()
				vape:UpdateTextGUI()
			end
		})
		Sort = TextGUI:CreateDropdown({
			Name = 'Sort',
			List = {'Alphabetical', 'Length'},
			Function = function()
				vape:UpdateTextGUI()
			end
		})
		FontOption = TextGUI:CreateFont({
			Name = 'Font',
			Default = 'Arial',
			Function = function()
				vape:UpdateTextGUI()
			end
		})
		ColorMode = TextGUI:CreateDropdown({
			Name = 'Color Mode',
			List = {'Match GUI color', 'Custom color'},
			Function = function(value)
				ColorSlider.Object.Visible = value == 'Custom color'
				vape:UpdateTextGUI()
			end
		})
		ColorSlider = TextGUI:CreateColorSlider({
			Name = 'Text GUI color',
			Function = function()
				vape:UpdateGUI()
			end,
			Darker = true,
			Visible = false
		})
		TextGUI:CreateSlider({
			Name = 'Scale',
			Min = 0,
			Max = 2,
			Decimal = 10,
			Default = 1,
			Function = function(val)
				Scale.Scale = val
				vape:UpdateTextGUI()
			end
		})
		Shadow = TextGUI:CreateToggle({
			Name = 'Shadow',
			Tooltip = 'Renders shadowed text.',
			Function = function()
				vape:UpdateTextGUI()
			end
		})
		Gradient = TextGUI:CreateToggle({
			Name = 'Gradient',
			Tooltip = 'Renders a gradient',
			Function = function(callback)
				GradientV4.Object.Visible = callback
				vape:UpdateTextGUI()
			end
		})
		GradientV4 = TextGUI:CreateToggle({
			Name = 'V4 Gradient',
			Function = function()
				vape:UpdateTextGUI()
			end,
			Darker = true,
			Visible = false
		})
		Animations = TextGUI:CreateToggle({
			Name = 'Animations',
			Tooltip = 'Use animations on text gui',
			Function = function()
				vape:UpdateTextGUI()
			end
		})
		Watermark = TextGUI:CreateToggle({
			Name = 'Watermark',
			Tooltip = 'Renders a vape watermark',
			Function = function()
				vape:UpdateTextGUI()
			end
		})
		Background = TextGUI:CreateToggle({
			Name = 'Render background',
			Function = function(callback)
				BackgroundTransparency.Object.Visible = callback
				BackgroundTint.Object.Visible = callback
				vape:UpdateTextGUI()
			end
		})
		BackgroundTransparency = TextGUI:CreateSlider({
			Name = 'Transparency',
			Min = 0,
			Max = 1,
			Default = 0.5,
			Decimal = 10,
			Function = function()
				vape:UpdateTextGUI()
			end,
			Darker = true,
			Visible = false
		})
		BackgroundTint = TextGUI:CreateToggle({
			Name = 'Tint',
			Function = function()
				vape:UpdateTextGUI()
			end,
			Darker = true,
			Visible = false
		})
		HideModules = TextGUI:CreateToggle({
			Name = 'Hide modules',
			Tooltip = 'Allows you to blacklist certain modules from being shown.',
			Function = function(enabled)
				HideModulesList.Object.Visible = enabled
				vape:UpdateTextGUI()
			end
		})
		HideModulesList = TextGUI:CreateTextList({
			Name = 'Blacklist',
			Tooltip = 'Name of module to hide.',
			Color = Color3.fromRGB(250, 50, 56),
			Function = function()
				vape:UpdateTextGUI()
			end,
			Visible = false,
			Darker = true
		})
		HideRender = TextGUI:CreateToggle({
			Name = 'Hide render',
			Function = function()
				vape:UpdateTextGUI()
			end
		})
		CustomText = TextGUI:CreateToggle({
			Name = 'Add custom text',
			Function = function(enabled)
				CustomTextBox.Object.Visible = enabled
				CustomTextFont.Object.Visible = enabled
				CustomTextColor.Object.Visible = enabled
				CustomTextColorSlider.Object.Visible = CustomTextColor.Enabled and enabled
				vape:UpdateTextGUI()
			end
		})
		CustomTextBox = TextGUI:CreateTextBox({
			Name = 'Custom text',
			Function = function()
				vape:UpdateTextGUI()
			end,
			Darker = true,
			Visible = false
		})
		CustomTextFont = TextGUI:CreateFont({
			Name = 'Custom Font',
			Default = 'Arial',
			Function = function()
				vape:UpdateTextGUI()
			end,
			Darker = true,
			Visible = false
		})
		CustomTextColor = TextGUI:CreateToggle({
			Name = 'Set custom text color',
			Function = function(enabled)
				CustomTextColorSlider.Object.Visible = enabled
				vape:UpdateGUI()
			end,
			Darker = true,
			Visible = false
		})
		CustomTextColorSlider = TextGUI:CreateColorSlider({
			Name = 'Color of custom text',
			Function = function(afterload)
				vape:UpdateGUI()
			end,
			Darker = true,
			Visible = false
		})
		
		
		--[[
			Text GUI Objects
		]]
		
		Scale = Instance.new('UIScale')
		Scale.Parent = TextGUI.Children
		local Logo = Instance.new('ImageLabel')
		Logo.BackgroundColor3 = Color3.new()
		Logo.BackgroundTransparency = 1
		Logo.BorderSizePixel = 0
		Logo.Image = getvapeasset('newvape/assets/new/vapelogo.png')
		Logo.Name = 'Logo'
		Logo.Position = UDim2.new(1, -142, 0, 3)
		Logo.Size = UDim2.fromOffset(81, 24)
		Logo.Visible = false
		Logo.Parent = TextGUI.Children
		local LogoV4 = Instance.new('ImageLabel')
		LogoV4.BackgroundColor3 = Color3.new()
		LogoV4.BackgroundTransparency = 1
		LogoV4.BorderSizePixel = 0
		LogoV4.Image = getvapeasset('newvape/assets/new/v4.png')
		LogoV4.Name = 'Logo2'
		LogoV4.Position = UDim2.new(1, -1, 0, 0)
		LogoV4.Size = UDim2.fromOffset(35, 24)
		LogoV4.Parent = Logo
		local LogoShadow = Logo:Clone()
		LogoShadow.ImageColor3 = Color3.new()
		LogoShadow.ImageTransparency = 0.65
		LogoShadow.Position = UDim2.fromOffset(1, 1)
		LogoShadow.Visible = true
		LogoShadow.ZIndex = 0
		LogoShadow.Parent = Logo
		LogoShadow.Logo2.ImageColor3 = Color3.new()
		LogoShadow.Logo2.ImageTransparency = 0.65
		LogoShadow.Logo2.ZIndex = 0
		local LogoGradient = Instance.new('UIGradient')
		LogoGradient.Rotation = 90
		LogoGradient.Parent = Logo
		local LogoGradient2 = Instance.new('UIGradient')
		LogoGradient2.Rotation = 90
		LogoGradient2.Parent = LogoV4
		local LabelCustom = Instance.new('TextLabel')
		LabelCustom.BackgroundTransparency = 1
		LabelCustom.BorderSizePixel = 0
		LabelCustom.FontFace = CustomTextFont.Value
		LabelCustom.Position = UDim2.fromOffset(5, 2)
		LabelCustom.Text = ''
		LabelCustom.TextSize = 25
		LabelCustom.Visible = false
		LabelCustom.RichText = true
		local LabelCustomShadow = LabelCustom:Clone()
		LabelCustomShadow.TextColor3 = Color3.new()
		LabelCustomShadow.TextTransparency = 0.65
		LabelCustomShadow.Parent = TextGUI.Children
		LabelCustom.Parent = TextGUI.Children
		local LabelHolder = Instance.new('Frame')
		LabelHolder.Name = 'Holder'
		LabelHolder.Size = UDim2.fromScale(1, 1)
		LabelHolder.Position = UDim2.fromOffset(5, 37)
		LabelHolder.BackgroundTransparency = 1
		LabelHolder.Parent = TextGUI.Children
		local ListLayout = Instance.new('UIListLayout')
		ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		ListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
		ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ListLayout.Parent = LabelHolder
		
		LabelCustom:GetPropertyChangedSignal('Position'):Connect(function()
			LabelCustomShadow.Position = UDim2.new(
				LabelCustom.Position.X.Scale,
				LabelCustom.Position.X.Offset + 1,
				0,
				LabelCustom.Position.Y.Offset + 1
			)
		end)
		
		LabelCustom:GetPropertyChangedSignal('FontFace'):Connect(function()
			LabelCustomShadow.FontFace = LabelCustom.FontFace
		end)
		
		LabelCustom:GetPropertyChangedSignal('Text'):Connect(function()
			LabelCustomShadow.Text = LabelCustom.ContentText
		end)
		
		LabelCustom:GetPropertyChangedSignal('Size'):Connect(function()
			LabelCustomShadow.Size = LabelCustom.Size
		end)
		
		local oldRight = TextGUI.Children.AbsolutePosition.X > (gui.AbsoluteSize.X / 2)
		vape:Clean(TextGUI.Children:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
			if vape.ThreadFix then
				setthreadidentity(8)
			end
		
			local isRight = TextGUI.Children.AbsolutePosition.X > (gui.AbsoluteSize.X / 2)
			if oldRight ~= isRight then
				vape:UpdateTextGUI()
				oldRight = isRight
			end
		end))
		
		function vape:UpdateTextGUI(afterload)
			if not afterload and not vape.Loaded then return end
			if TextGUI.Button.Enabled then
				local isRight = TextGUI.Children.AbsolutePosition.X > (gui.AbsoluteSize.X / 2)
		
				Logo.Visible = Watermark.Enabled
				Logo.Position = isRight and UDim2.new(1 / Scale.Scale, -113, 0, 6) or UDim2.fromOffset(0, 6)
				LogoShadow.Visible = Shadow.Enabled
				LabelCustom.Text = CustomTextBox.Value
				LabelCustom.FontFace = CustomTextFont.Value
				LabelCustom.Visible = LabelCustom.Text ~= '' and CustomText.Enabled
				LabelCustomShadow.Visible = LabelCustom.Visible and Shadow.Enabled
				ListLayout.HorizontalAlignment = isRight and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left
				LabelHolder.Size = UDim2.fromScale(1 / Scale.Scale, 1)
				LabelHolder.Position = UDim2.fromOffset(isRight and 3 or 0, 11 + (Logo.Visible and Logo.Size.Y.Offset or 0) + (LabelCustom.Visible and 28 or 0) + (Background.Enabled and 3 or 0))
		
				if LabelCustom.Visible then
					local size = getfontbounds(LabelCustom.ContentText, LabelCustom.TextSize, LabelCustom.FontFace)
					LabelCustom.Size = UDim2.fromOffset(size.X, size.Y)
					LabelCustom.Position = UDim2.new(isRight and 1 / Scale.Scale or 0, isRight and -size.X or 0, 0, (Logo.Visible and 34 or 8))
				end
		
				local Previous = {}
				for _, label in Labels do
					if label.Enabled then
						table.insert(Previous, label.Object.Name)
					end
		
					label.Object:Destroy()
				end
				table.clear(Labels)
		
				for name, module in vape.Modules do
					if HideModules.Enabled and table.find(HideModulesList.ListEnabled, name) then
						continue
					end
		
					if HideRender.Enabled and module.Category == 'Render' then
						continue
					end
		
					if module.Enabled or table.find(Previous, name) then
						local bkg, colorline
						local holder = Instance.new('Frame')
						holder.BackgroundTransparency = 1
						holder.ClipsDescendants = true
						holder.Name = name
						holder.Size = UDim2.fromOffset()
						holder.Parent = LabelHolder
		
						if Background.Enabled then
							bkg = Instance.new('Frame')
							bkg.BackgroundColor3 = color.Dark(uipallet.Main, 0.15)
							bkg.BackgroundTransparency = BackgroundTransparency.Value
							bkg.BorderSizePixel = 0
							bkg.Size = UDim2.new(1, 0, 1, 0)
							bkg.Parent = holder
							local corner = Instance.new('UICorner')
							corner.Parent = bkg
							local line = Instance.new('Frame')
							line.BackgroundColor3 = Color3.new()
							line.BackgroundTransparency = 0.928 + (0.072 * math.clamp((BackgroundTransparency.Value - 0.5) / 0.5, 0, 1))
							line.BorderSizePixel = 0
							line.Position = UDim2.new(0, 0, 1, -1)
							line.Size = UDim2.new(1, 0, 0, 1)
							line.Parent = bkg
							local line2 = line:Clone()
							line2.Position = UDim2.new()
							line2.Name = 'Line'
							line2.Parent = bkg
							local clip = Instance.new('Frame')
							clip.BackgroundTransparency = 1
							clip.ClipsDescendants = true
							clip.Position = isRight and UDim2.new(1, -2, 0, 0) or UDim2.new()
							clip.Size = UDim2.new(0, 2, 1, 0)
							clip.Parent = bkg
							colorline = Instance.new('Frame')
							colorline.Position = isRight and UDim2.new(1, -8, 0, 0) or UDim2.new()
							colorline.Size = UDim2.new(0, 8, 1, 0)
							colorline.Parent = clip
							local colorcorner = Instance.new('UICorner')
							colorcorner.CornerRadius = UDim.new()
							colorcorner.Parent = colorline
						end
		
						local label = Instance.new('TextLabel')
						label.AutoLocalize = false
						label.BackgroundTransparency = 1
						label.BorderSizePixel = 0
						label.FontFace = FontOption.Value
						label.Position = UDim2.fromOffset(isRight and 6 or 9, 2)
						label.Text = name..(module.ExtraText and " <font color='#A8A8A8'>"..module.ExtraText()..'</font>' or '')
						label.TextSize = 18
						label.RichText = true
		
						local size = getfontbounds(label.ContentText, label.TextSize, label.FontFace)
						label.Size = UDim2.fromOffset(size.X, size.Y)
		
						if Shadow.Enabled then
							local shadowlabel = Instance.fromExisting(label)
							shadowlabel.Position = UDim2.fromOffset(label.Position.X.Offset + 1, label.Position.Y.Offset + 1)
							shadowlabel.Text = label.ContentText
							shadowlabel.TextColor3 = Color3.new()
							shadowlabel.Parent = holder
						end
		
						label.Parent = holder
		
						local tweenSize = UDim2.fromOffset(size.X + 16, size.Y + 6)
						if Animations.Enabled then
							if not table.find(Previous, name) then
								tween:Tween(holder, info, {
									Size = tweenSize
								})
							else
								holder.Size = tweenSize
								if not module.Enabled then
									tween:Tween(holder, info, {
										Size = UDim2.fromOffset()
									})
								end
							end
						else
							holder.Size = module.Enabled and tweenSize or UDim2.fromOffset()
						end
		
						table.insert(Labels, {
							Background = bkg,
							Color = colorline,
							Enabled = module.Enabled,
							Object = holder,
							Text = label,
							Size = module.Enabled and tweenSize or UDim2.fromOffset()
						})
					end
				end
		
				if Sort.Value == 'Alphabetical' then
					table.sort(Labels, function(a, b)
						return a.Text.Text < b.Text.Text
					end)
				else
					table.sort(Labels, function(a, b)
						return a.Text.Size.X.Offset > b.Text.Size.X.Offset
					end)
				end
		
				local firstIndex
				local lastIndex
		
				for index, label in Labels do
					if label.Enabled then
						firstIndex = firstIndex or index
						lastIndex = index
					end
				end
		
				for index, label in Labels do
					if label.Color then
						local topLabel = findValidLabel(Labels, index, -1)
						local bottomLabel = findValidLabel(Labels, index, 1)
						local top = (not topLabel or (topLabel.Size.X.Offset < label.Size.X.Offset)) and 4 or 0
						local bottom = (not bottomLabel or (bottomLabel.Size.X.Offset < label.Size.X.Offset)) and 4 or 0
		
						label.Color.Parent.Parent.Line.Visible = index ~= firstIndex
						label.Color.UICorner.TopLeftRadius = isRight and UDim.new() or UDim.new(0, index == firstIndex and 4 or 0)
						label.Color.UICorner.TopRightRadius = isRight and UDim.new(0, index == firstIndex and 4 or 0) or UDim.new()
						label.Color.UICorner.BottomLeftRadius = isRight and UDim.new() or UDim.new(0, index == lastIndex and 4 or 0)
						label.Color.UICorner.BottomRightRadius = isRight and UDim.new(0, index == lastIndex and 4 or 0) or UDim.new()
		
						label.Background.UICorner.TopLeftRadius = UDim.new(0, top)
						label.Background.UICorner.TopRightRadius = UDim.new(0, top)
						label.Background.UICorner.BottomLeftRadius = UDim.new(0, bottom)
						label.Background.UICorner.BottomRightRadius = UDim.new(0, bottom)
					end
		
					label.Object.LayoutOrder = index
				end
			end
		
			self:UpdateGUI()
		end
		
		function TextGUI:UpdateColor(hue, sat, val, default)
			LogoGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, sat, val)),
				ColorSequenceKeypoint.new(1, Gradient.Enabled and Color3.fromHSV(vape:Color((hue - 0.05) % 1)) or Color3.fromHSV(hue, sat, val))
			})
			LogoGradient2.Color = Gradient.Enabled and GradientV4.Enabled and LogoGradient.Color or ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
			})
			LabelCustom.TextColor3 = CustomTextColor.Enabled and Color3.fromHSV(CustomTextColorSlider.Hue, CustomTextColorSlider.Sat, CustomTextColorSlider.Value) or LogoGradient.Color.Keypoints[2].Value
		
			local isCustom = ColorMode.Value == 'Custom color' and Color3.fromHSV(ColorSlider.Hue, ColorSlider.Sat, ColorSlider.Value) or nil
			for index, label in Labels do
				label.Text.TextColor3 = isCustom or (vape.GUIColor.Rainbow and Color3.fromHSV(vape:Color((hue - ((Gradient.Enabled and index + 2 or index) * 0.025)) % 1)) or LogoGradient.Color.Keypoints[2].Value)
		
				if label.Color then
					label.Color.BackgroundColor3 = label.Text.TextColor3
				end
		
				if BackgroundTint.Enabled and label.Background then
					label.Background.BackgroundColor3 = color.Dark(label.Text.TextColor3, 0.75)
				end
			end
		end
	end)
	
	run(function()
		--[[
			Target Info
		]]
		
		local targetinfo = {
			Targets = {},
			Object = Holder,
			Health = 0,
			MaxHealth = 0
		}
		local TargetInfoOverlay
		local BackgroundTransparency = {
			Value = 0.5,
			Object = {Visible = {}}
		}
		local BorderColor
		local BKGColor
		local CustomColor
		local DisplayName
		
		TargetInfoOverlay = vape:CreateOverlay({
			Name = 'Target Info',
			Icon = getvapeasset('newvape/assets/new/targetinfo.png'),
			Size = UDim2.fromOffset(14, 14),
			Position = UDim2.fromOffset(12, 14),
			CategorySize = 240,
			Function = function(callback)
				if callback then
					TargetInfoOverlay:Clean(runService.RenderStepped:Connect(function()
						targetinfo:Update()
					end))
				end
			end
		})
		
		local Holder = Instance.new('Frame')
		Holder.Size = UDim2.fromOffset(240, 89)
		Holder.BackgroundColor3 = color.Dark(uipallet.Main, 0.1)
		Holder.BackgroundTransparency = 0.5
		Holder.Parent = TargetInfoOverlay.Children
		local BlurHolder = addBlur(Holder, nil, true)
		BlurHolder.Visible = false
		addCorner(Holder)
		local Headshot = Instance.new('ImageLabel')
		Headshot.Size = UDim2.fromOffset(26, 27)
		Headshot.Position = UDim2.fromOffset(19, 17)
		Headshot.BackgroundColor3 = uipallet.Main
		Headshot.Image = 'rbxthumb://type=AvatarHeadShot&id=1&w=420&h=420'
		Headshot.Parent = Holder
		addCorner(Headshot)
		local HurtFlash = Instance.new('Frame')
		HurtFlash.Size = UDim2.fromScale(1, 1)
		HurtFlash.BackgroundTransparency = 1
		HurtFlash.BackgroundColor3 = Color3.new(1, 0, 0)
		HurtFlash.Parent = Headshot
		addCorner(HurtFlash)
		local HeadshotBlur = addBlur(Headshot)
		HeadshotBlur.Enabled = false
		local Name = Instance.new('TextLabel')
		Name.Size = UDim2.fromOffset(145, 20)
		Name.Position = UDim2.fromOffset(54, 20)
		Name.BackgroundTransparency = 1
		Name.Text = 'Target name'
		Name.TextXAlignment = Enum.TextXAlignment.Left
		Name.TextYAlignment = Enum.TextYAlignment.Top
		Name.TextScaled = true
		Name.TextColor3 = color.Light(uipallet.Text, 0.4)
		Name.TextStrokeTransparency = 1
		Name.FontFace = uipallet.Font
		local NameShadow = Name:Clone()
		NameShadow.Position = UDim2.fromOffset(55, 21)
		NameShadow.TextColor3 = Color3.new()
		NameShadow.TextTransparency = 0.65
		NameShadow.Visible = false
		NameShadow.Parent = Holder
		for _, prop in {'Size', 'Text', 'FontFace'} do
			Name:GetPropertyChangedSignal(prop):Connect(function()
				NameShadow[prop] = Name[prop]
			end)
		end
		Name.Parent = Holder
		local HealthBKG = Instance.new('Frame')
		HealthBKG.Name = 'HealthBKG'
		HealthBKG.Size = UDim2.fromOffset(200, 9)
		HealthBKG.Position = UDim2.fromOffset(20, 56)
		HealthBKG.BackgroundColor3 = uipallet.Main
		HealthBKG.BorderSizePixel = 0
		HealthBKG.Parent = Holder
		addCorner(HealthBKG, UDim.new(1, 0))
		local Health = HealthBKG:Clone()
		Health.Size = UDim2.fromScale(0.8, 1)
		Health.Position = UDim2.new()
		Health.BackgroundColor3 = Color3.fromHSV(1 / 2.5, 0.89, 0.75)
		Health.Parent = HealthBKG
		Health:GetPropertyChangedSignal('Size'):Connect(function()
			Health.Visible = Health.Size.X.Scale > 0.01
		end)
		local Armor = Health:Clone()
		Armor.Size = UDim2.new()
		Armor.Position = UDim2.fromScale(1, 0)
		Armor.AnchorPoint = Vector2.new(1, 0)
		Armor.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
		Armor.Visible = false
		Armor.Parent = HealthBKG
		Armor:GetPropertyChangedSignal('Size'):Connect(function()
			Armor.Visible = Armor.Size.X.Scale > 0.01
		end)
		local HealthBlur = addBlur(HealthBKG)
		HealthBlur.Enabled = false
		local Stroke = Instance.new('UIStroke')
		Stroke.Enabled = false
		Stroke.Color = Color3.fromHSV(0.44, 1, 1)
		Stroke.Parent = Holder
		
		TargetInfoOverlay:CreateFont({
			Name = 'Font',
			Default = 'Arial',
			Function = function(val)
				Name.FontFace = val
			end
		})
		DisplayName = TargetInfoOverlay:CreateToggle({
			Name = 'Use Displayname',
			Default = true
		})
		TargetInfoOverlay:CreateToggle({
			Name = 'Render Background',
			Function = function(callback)
				Holder.BackgroundTransparency = callback and BackgroundTransparency.Value or 1
				NameShadow.Visible = not callback
				BlurHolder.Visible = callback
				HealthBlur.Enabled = not callback
				HeadshotBlur.Enabled = not callback
				BackgroundTransparency.Object.Visible = callback
			end,
			Default = true
		})
		BackgroundTransparency = TargetInfoOverlay:CreateSlider({
			Name = 'Transparency',
			Min = 0,
			Max = 1,
			Default = 0.5,
			Decimal = 10,
			Function = function(val)
				Holder.BackgroundTransparency = val
			end,
			Darker = true
		})
		CustomColor = TargetInfoOverlay:CreateToggle({
			Name = 'Custom Color',
			Function = function(callback)
				BKGColor.Object.Visible = callback
				if callback then
					Holder.BackgroundColor3 = Color3.fromHSV(BKGColor.Hue, BKGColor.Sat, BKGColor.Value)
					Headshot.BackgroundColor3 = Color3.fromHSV(BKGColor.Hue, BKGColor.Sat, math.max(BKGColor.Value - 0.1, 0.075))
					HealthBKG.BackgroundColor3 = Headshot.BackgroundColor3
				else
					Holder.BackgroundColor3 = color.Dark(uipallet.Main, 0.1)
					Headshot.BackgroundColor3 = uipallet.Main
					HealthBKG.BackgroundColor3 = uipallet.Main
				end
			end
		})
		BKGColor = TargetInfoOverlay:CreateColorSlider({
			Name = 'Color',
			Function = function(hue, sat, val)
				if CustomColor.Enabled then
					Holder.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
					Headshot.BackgroundColor3 = Color3.fromHSV(hue, sat, math.max(val - 0.1, 0))
					HealthBKG.BackgroundColor3 = Headshot.BackgroundColor3
				end
			end,
			Darker = true,
			Visible = false
		})
		TargetInfoOverlay:CreateToggle({
			Name = 'Border',
			Function = function(callback)
				Stroke.Enabled = callback
				BorderColor.Object.Visible = callback
			end
		})
		BorderColor = TargetInfoOverlay:CreateColorSlider({
			Name = 'Border Color',
			Function = function(hue, sat, val, opacity)
				Stroke.Color = Color3.fromHSV(hue, sat, val)
				Stroke.Transparency = 1 - opacity
			end,
			Darker = true,
			Visible = false
		})
		
		function targetinfo:Update()
			local entitylib = vape.Libraries
			if not entitylib then return end
		
			local cloned = table.clone(self.Targets)
			for index, expire in cloned do
				if expire < os.clock() then
					self.Targets[index] = nil
				end
			end
			table.clear(cloned)
		
			local entity, highest = nil, os.clock()
			for index, level in self.Targets do
				if level > highest then
					entity = index
					highest = level
				end
			end
		
			Holder.Visible = entity ~= nil or clickgui.Visible
			if entity then
				Name.Text = entity.Player and (DisplayName.Enabled and entity.Player.DisplayName or entity.Player.Name) or entity.Character and entity.Character.Name or Name.Text
				Headshot.Image = 'rbxthumb://type=AvatarHeadShot&id='..(entity.Player and entity.Player.UserId or 1)..'&w=420&h=420'
		
				if not entity.Character then
					entity.Health = entity.Health or 0
					entity.MaxHealth = entity.MaxHealth or 100
				end
		
				if entity.Health ~= self.Health or entity.MaxHealth ~= self.MaxHealth then
					local percent = math.max(entity.Health / entity.MaxHealth, 0)
		
					tween:Tween(Health, TweenInfo.new(0.3), {
						Size = UDim2.fromScale(math.min(percent, 1), 1), BackgroundColor3 = Color3.fromHSV(math.clamp(percent / 2.5, 0, 1), 0.89, 0.75)
					})
		
					tween:Tween(Armor, TweenInfo.new(0.3), {
						Size = UDim2.fromScale(math.clamp(percent - 1, 0, 0.8), 1)
					})
		
					if self.Health > entity.Health and self.LastTarget == entity then
						tween:Cancel(HurtFlash)
						HurtFlash.BackgroundTransparency = 0.3
						tween:Tween(HurtFlash, TweenInfo.new(0.5), {
							BackgroundTransparency = 1
						})
					end
		
					self.Health = entity.Health
					self.MaxHealth = entity.MaxHealth
				end
		
				if not entity.Character then
					table.clear(entity)
				end
		
				self.LastTarget = entity
			end
		end
		
		vape.Libraries.targetinfo = targetinfo
	end)
	
	vape:Clean(task.spawn(function()
		local hue = 0
		repeat
			for _, component in vape.RainbowSliders do
				if component.Type == 'GUISlider' then
					component:SetValue(vape:Color(hue))
				else
					component:SetValue(hue)
				end
			end
	
			local delta = task.wait(1 / vape.RainbowUpdateSpeed.Value)
			hue = (hue + (delta * (0.2 * vape.RainbowSpeed.Value))) % 1
		until false
	end))
	
	local cursorConnection
	vape:Clean(clickgui:GetPropertyChangedSignal('Visible'):Connect(function()
		vape:UpdateGUI()
	
		if clickgui.Visible and inputService.MouseEnabled then
			if cursorConnection then
				cursorConnection:Disconnect()
			end
	
			cursorConnection = runService.RenderStepped:Connect(function()
				local isVisible = clickgui.Visible
				for _, window in vape.Windows do
					isVisible = isVisible or window.Visible
				end
	
				if not isVisible then
					cursor.Visible = false
					cursorConnection:Disconnect()
					cursorConnection = nil
					return
				end
	
				cursor.Visible = not inputService.MouseIconEnabled
				if cursor.Visible then
					local mouseLocation = inputService:GetMouseLocation()
					cursor.Position = UDim2.fromOffset(mouseLocation.X - 31, mouseLocation.Y - 32)
				end
			end)
		end
	end))
	
	vape:Clean(function()
		if cursorConnection then
			cursorConnection:Disconnect()
		end
	end)
	
	vape:Clean(gui:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
		if vape.Scale.Enabled then
			scale.Scale = math.max(gui.AbsoluteSize.X / 1920, 0.6)
		end
	end))
	
	vape:Clean(notifications.ChildRemoved:Connect(function()
		for index, notif in notifications:GetChildren() do
			if tween.Tween then
				tween:Tween(notif, TweenInfo.new(0.326, Enum.EasingStyle.Exponential), {
					Position = UDim2.new(1, 0, 1, -(29 + (78 * index)))
				})
			end
		end
	end))
	
	vape:Clean(scale:GetPropertyChangedSignal('Scale'):Connect(function()
		scaledgui.Size = UDim2.fromScale(1 / scale.Scale, 1 / scale.Scale)
	
		for _, obj in (scaledgui.QueryDescendants and scaledgui:QueryDescendants('GuiObject >> [Visible = true]') or {}) do
			obj.Visible = false
			obj.Visible = true
		end
	end))
	
	vape:Clean(vape.GUIBind.Triggered:Connect(function()
		if vape.ThreadFix then
			setthreadidentity(8)
		end
	
		for _, window in self.Windows do
			window.Visible = false
		end
	
		for _, module in self.Modules do
			if module.Bind.Mobile then
				module.Bind.Mobile.Visible = clickgui.Visible
			end
		end
	
		clickgui.Visible = not clickgui.Visible
		if not clickgui.Visible then
			tooltip.Visible = false
			vape.CurrentTooltip = nil
			activeTooltipOwner = nil
		end
		vape:BlurCheck()
	end))
	
	vape:Clean(inputService.InputBegan:Connect(function(input)
		if vape.CurrentTooltip and input.KeyCode == Enum.KeyCode.LeftShift then
			vape.CurrentTooltip()
		end
	
		if vape.Autocomplete and input.KeyCode == Enum.KeyCode.Tab then
			vape.Autocomplete()
		end
	
		if not inputService:GetFocusedTextBox() and input.KeyCode ~= Enum.KeyCode.Unknown then
			table.insert(vape.HeldKeybinds, input.KeyCode.Name)
			if vape.Binding then return end
	
			for _, bind in vape.ActiveBinds do
				if checkKeybinds(vape.HeldKeybinds, bind.Keys, input.KeyCode.Name) then
					bind.Triggered:Fire(true)
				end
			end
		end
	end))
	
	vape:Clean(inputService.InputEnded:Connect(function(input)
		if vape.CurrentTooltip and input.KeyCode == Enum.KeyCode.LeftShift then
			vape.CurrentTooltip()
		end
	
		if not inputService:GetFocusedTextBox() and input.KeyCode ~= Enum.KeyCode.Unknown then
			if vape.Binding then
				if not vape.MultiKeybind.Enabled then
					vape.HeldKeybinds = {input.KeyCode.Name}
				end
	
				vape.Binding:SetBind(vape.HeldKeybinds, true)
				vape.Binding = nil
			else
				for _, bind in vape.ActiveBinds do
					if bind.Hold and checkKeybinds(vape.HeldKeybinds, bind.Keys, input.KeyCode.Name) then
						bind.Triggered:Fire(false)
					end
				end
			end
		end
	
		local index = table.find(vape.HeldKeybinds, input.KeyCode.Name)
		if index then
			table.remove(vape.HeldKeybinds, index)
		end
	end))
end

function vape:Remove(obj)
	local container = (self.Modules[obj] and self.Modules or self.Legit.Modules[obj] and self.Legit.Modules or self.Categories)
	if container and container[obj] then
		local component = container[obj]
		local isModule = component.Type == 'Module'
		if self.ThreadFix then
			setthreadidentity(8)
		end

		if component.Destroy then
			component:Destroy()
		end

		for _, child in {'Object', 'Children', 'Toggle', 'Button'} do
			child = typeof(component[child]) == 'table' and component[child].Object or component[child]

			if typeof(child) == 'Instance' then
				child:Destroy()
				child:ClearAllChildren()
			end
		end

		loopClean(component)
		container[obj] = nil

		if isModule then
			self:SortCategories()
		end
	end
end

function vape:Save(newProfile)
	if not self.Loaded then
		return
	end

	local guiData = {
		Categories = {},
		Profile = newProfile or self.Profile,
		v = 1
	}

	local mainData = {
		Modules = {},
		Categories = {},
		Legit = {},
		v = 1
	}

	for name, category in self.Categories do
		category:Save((category.Type == 'Overlay' and mainData or guiData).Categories)
	end

	for _, module in self.Modules do
		module:Save(mainData.Modules)
	end

	for _, module in self.Legit.Modules do
		module:Save(mainData.Legit)
	end

	pcall(function() if makefolder then pcall(makefolder, 'newvape'); pcall(makefolder, 'newvape/profiles') end end)
	pcall(writefile, 'newvape/profiles/'..game.GameId..'.gui.txt', httpService:JSONEncode(guiData))
	pcall(writefile, 'newvape/profiles/'..self.Profile..self.Place..'.txt', httpService:JSONEncode(mainData))
end

local pendingAutoSaveThread = nil
function vape:ScheduleSave()
	if not self.Loaded then
		return
	end
	if pendingAutoSaveThread then
		return
	end
	pendingAutoSaveThread = task.delay(0.15, function()
		pendingAutoSaveThread = nil
		if self.Loaded then
			pcall(function()
				self:Save()
			end)
		end
	end)
end

function vape:SaveOptions(obj)
	local data = {}
	for _, component in obj.Options do
		if not component.Save then
			continue
		end

		component:Save(data)
	end

	return data
end

function vape:SortCategories()
	local sorting = {}
	for _, module in self.Modules do
		sorting[module.Category] = sorting[module.Category] or {}
		table.insert(sorting[module.Category], module.Name)
	end

	for _, sort in sorting do
		table.sort(sort)

		local index = 2
		for _, name in sort do
			self.Modules[name].Index = index / 2
			self.Modules[name].Object.LayoutOrder = index
			self.Modules[name].Children.LayoutOrder = index + 1
			index += 2
		end
	end
end

function vape:Uninject()
	self:Save()
	self.Loaded = nil

	for _, module in self.Modules do
		if module.Enabled then
			module:Toggle()
		end
	end

	for _, module in self.Legit.Modules do
		if module.Enabled then
			module:Toggle()
		end
	end

	for _, category in self.Categories do
		if category.Type == 'Overlay' and category.Button.Enabled then
			category.Button:Toggle()
		end
	end

	for _, connection in self.Connections do
		pcall(function()
			connection:Disconnect()
		end)
	end

	if self.ThreadFix then
		setthreadidentity(8)
		clickgui.Visible = false
		self:BlurCheck()
	end

	gui:ClearAllChildren()
	gui:Destroy()
	table.clear(self.Connections)
	table.clear(self.Libraries)
	loopClean(self)

	shared.vape = nil
	shared.vapereload = nil
	shared.VapeIndependent = nil
end

local guiUpdate
function vape:UpdateGUI()
	if guiUpdate then
		return
	end

	guiUpdate = runService.RenderStepped:Once(function()
		if vape.Loaded ~= nil then
			vape:UpdateGUIQueue(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value)
		end

		guiUpdate = nil
	end)
end

function vape:UpdateGUIQueue(hue, sat, val)
	if TextGUI.Button.Enabled then
		TextGUI:UpdateColor(hue, sat, val, default)
	end

	if not clickgui.Visible and not vape.Legit.Window.Visible then return end
	local isRainbow = vape.GUIColor.Rainbow and vape.RainbowMode.Value ~= 'Retro'

	for name, component in vape.Categories do
		component:Color(hue, sat, val, isRainbow)
	end

	for _, component in vape.Modules do
		component:Color(hue, sat, val, isRainbow)
	end

	for _, component in vape.Overlays.Options do
		if component.Color then
			component:Color(hue, sat, val, isRainbow)
		end
	end

	for _, pane in vape.Settings do
		for _, component in pane.Options do
			if component.Color then
				component:Color(hue, sat, val, isRainbow)
			end
		end
	end

	if vape.Legit.Window.Visible then
		for _, component in vape.Legit.Modules do
			component:Color(hue, sat, val, isRainbow)
		end
	end
end

components = {
	Bind = function(props, children, api)
		local component = {
			Hold = props.Hold or false,
			Keys = {},
			Triggered = createSignal(),
			Type = 'Bind'
		}
		
		local bind = Instance.new('TextButton')
		bind.AnchorPoint = Vector2.new(1, 0)
		bind.AutoButtonColor = false
		bind.BackgroundColor3 = Color3.new(1, 1, 1)
		bind.BackgroundTransparency = 0.92
		bind.BorderSizePixel = 0
		bind.Name = 'Bind'
		bind.Size = UDim2.fromOffset(20, 20)
		bind.Visible = false
		bind.Text = ''
		addCorner(bind, UDim.new(0, 4))
		addTooltip(bind, '', function()
			local holdText = 'Bind functionality = '..(component.Hold and 'Enable while held' or 'Toggle')
			if inputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				holdText = "<font color='#FF5A5A'>"..holdText.."</font>"
			end
		
			return 'Click to bind\nShift click to modify bind functionality\n'..holdText
		end)
		local icon = Instance.new('ImageLabel')
		icon.BackgroundTransparency = 1
		icon.Image = getvapeasset('newvape/assets/new/bind.png')
		icon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
		icon.Name = 'Icon'
		icon.Position = UDim2.new(0.5, -5, 0, 5)
		icon.Size = UDim2.fromOffset(10, 10)
		icon.Parent = bind
		local label = Instance.new('TextLabel')
		label.BackgroundTransparency = 1
		label.FontFace = uipallet.Font
		label.Position = UDim2.fromOffset(-1, 0)
		label.Size = UDim2.fromScale(1, 1)
		label.Text = ''
		label.TextColor3 = color.Dark(uipallet.Text, 0.43)
		label.TextSize = 12
		label.Visible = false
		label.Parent = bind
		local cover
		local coverlabel
		
		if props.Module then
			if props.Cover then
				cover = Instance.new('ImageLabel')
				cover.BackgroundTransparency = 1
				cover.Image = getvapeasset('newvape/assets/new/bindbkg.png')
				cover.Name = 'Cover'
				cover.ScaleType = Enum.ScaleType.Slice
				cover.SliceCenter = Rect.new(0, 0, 141, 40)
				cover.Size = UDim2.fromOffset(154, 40)
				cover.Visible = false
				cover.Parent = api.Object
				coverlabel = Instance.new('TextLabel')
				coverlabel.BackgroundTransparency = 1
				coverlabel.FontFace = uipallet.Font
				coverlabel.Name = 'Text'
				coverlabel.Size = UDim2.new(1, -10, 1, -3)
				coverlabel.Text = 'PRESS A KEY TO BIND'
				coverlabel.TextColor3 = uipallet.Text
				coverlabel.TextSize = 11
				coverlabel.Parent = cover
			end
		
			bind.Position = UDim2.new(1, -36, 0, 10)
			bind.Parent = api.Object
			component.Object = bind
		else
			local holder = Instance.new('TextButton')
			holder.AutoButtonColor = false
			holder.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
			holder.BorderSizePixel = 0
			holder.FontFace = uipallet.Font
			holder.Size = UDim2.new(1, 0, 0, 40)
			holder.Text = '\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138'..props.Name
			holder.TextColor3 = color.Dark(uipallet.Text, 0.16)
			holder.TextSize = 14
			holder.TextXAlignment = Enum.TextXAlignment.Left
			holder.Visible = props.Visible == nil or props.Visible
			holder.Parent = children
			addTooltip(holder, props.Tooltip)
			bind.Position = UDim2.new(1, -10, 0, 10)
			bind.Visible = true
			bind.Parent = holder
			component.Object = holder
		end
		
		function component:CreateMobileButton(position)
			self:DestroyMobileButton()
		
			local isHeld = false
			local button = Instance.new('TextButton')
			button.AnchorPoint = Vector2.new(0.5, 0.5)
			button.BackgroundColor3 = api.Enabled and Color3.new(0, 0.7, 0) or Color3.new()
			button.BackgroundTransparency = 0.5
			button.Font = Enum.Font.Gotham
			button.Position = UDim2.fromOffset(position.X, position.Y)
			button.Size = UDim2.fromOffset(40, 40)
			button.Text = api.Name or 'Button'
			button.TextColor3 = Color3.new(1, 1, 1)
			button.TextScaled = true
			button.Parent = gui
			local constraint = Instance.new('UITextSizeConstraint')
			constraint.MaxTextSize = 16
			constraint.Parent = button
			addCorner(button, UDim.new(1, 0))
		
			button.MouseButton1Down:Connect(function()
				isHeld = true
		
				local holdtime, holdPos = os.clock(), inputService:GetMouseLocation()
				repeat
					isHeld = (inputService:GetMouseLocation() - holdPos).Magnitude < 6
		
					task.wait()
				until (os.clock() - holdtime) > 1 or not isHeld
		
				if isHeld then
					self:DestroyMobileButton()
				end
			end)
		
			button.MouseButton1Up:Connect(function()
				isHeld = false
			end)
		
			button.MouseButton1Click:Connect(function()
				self.Triggered:Fire(true)
				button.BackgroundColor3 = api.Enabled and Color3.new(0, 0.7, 0) or Color3.new()
			end)
		
			self.Mobile = button
		end
		
		function component:Destroy()
			bind:Destroy()
			bind:ClearAllChildren()
		
			if self.Object then
				self.Object:Destroy()
				self.Object:ClearAllChildren()
			end
		
			if self.Mobile then
				self.Mobile:Destroy()
				self.Mobile = nil
			end
		
			local index = table.find(vape.ActiveBinds, self)
			if index then
				table.remove(vape.ActiveBinds, index)
			end
		end
		
		function component:DestroyMobileButton()
			if self.Mobile then
				self.Mobile:Destroy()
				self.Mobile = nil
			end
		end
		
		function component:Load(data)
			self.Hold = data.Hold
			self:SetBind(data.Keys)
		
			if data.Mobile then
				self:CreateMobileButton(Vector2.new(data.Mobile.X, data.Mobile.Y))
			end
		end
		
		function component:Save(data)
			data[props and props.Name or 'Bind'] = {
				Keys = self.Keys,
				Mobile = self.Mobile and {
					X = self.Mobile.Position.X.Offset,
					Y = self.Mobile.Position.Y.Offset
				},
				Hold = self.Hold
			}
		end
		
		function component:SetBind(keys, mouse)
			if props and props.NoRemove and #keys <= 0 then
				keys = props.Default
			end
		
			self.Binding = nil
			self.Keys = table.clone(keys)
		
			if mouse then
				icon.Image = getvapeasset('newvape/assets/new/edit.png')
		
				if cover then
					coverlabel.Text = #keys <= 0 and 'BIND REMOVED' or 'BOUND TO'
					cover.Size = UDim2.fromOffset(getfontbounds(coverlabel.Text, coverlabel.TextSize, coverlabel.FontFace).X + 20, 40)
		
					task.delay(1, function()
						cover.Visible = false
					end)
				end
			end
		
			if #keys <= 0 then
				label.Visible = false
				icon.Visible = true
				bind.Size = UDim2.fromOffset(20, 20)
		
				local index = table.find(vape.ActiveBinds, component)
				if index then
					table.remove(vape.ActiveBinds, index)
				end
			else
				bind.Visible = true
				label.Visible = true
				icon.Visible = false
				label.Text = table.concat(keys, ' + '):upper()
				bind.Size = UDim2.fromOffset(math.max(getfontbounds(label.Text, label.TextSize, label.FontFace).X + 10, 20), 20)
		
				if not table.find(vape.ActiveBinds, component) then
					table.insert(vape.ActiveBinds, component)
				end
			end

			if vape and type(vape.ScheduleSave) == 'function' then
				vape:ScheduleSave()
			end
		end
		
		function component:SetColor(newColor)
			icon.ImageColor3 = newColor
			label.TextColor3 = newColor
		end
		
		function component:SetParent(parent)
			bind.Parent = parent
		
			if cover then
				cover.Parent = parent
			end
		end
		
		function component:SetVisible(visible)
			bind.Visible = #self.Keys > 0 or visible
		end
		
		bind.MouseEnter:Connect(function()
			label.Visible = false
			icon.Visible = not label.Visible
			icon.Image = getvapeasset(component.Binding and 'newvape/assets/new/close.png' or 'newvape/assets/new/edit.png')
		
			if not props.Cover or not api.Enabled then
				icon.ImageColor3 = color.Dark(uipallet.Text, 0.16)
			end
		end)
		
		bind.MouseLeave:Connect(function()
			label.Visible = #component.Keys > 0
			icon.Visible = not label.Visible
			icon.Image = getvapeasset(component.Binding and 'newvape/assets/new/close.png' or 'newvape/assets/new/bind.png')
		
			if not props.Cover or not api.Enabled then
				icon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
			end
		end)
		
		bind.MouseButton1Click:Connect(function()
			if vape.Binding then
				if vape.Binding == component then
					component:SetBind({}, true)
					vape.Binding = nil
				end
		
				return
			end
		
			if props.Module and inputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				component.Hold = not component.Hold
				if vape.CurrentTooltip then
					vape.CurrentTooltip()
				end
				if vape and type(vape.ScheduleSave) == 'function' then
					vape:ScheduleSave()
				end
		
				return
			end
		
			if cover then
				coverlabel.Text = 'PRESS A KEY TO BIND'
				cover.Size = UDim2.fromOffset(getfontbounds(coverlabel.Text, coverlabel.TextSize, coverlabel.FontFace).X + 20, 40)
				cover.Visible = true
			end
		
			component.Binding = true
			icon.Image = getvapeasset('newvape/assets/new/close.png')
			vape.Binding = component
		end)
		
		if props.Module then
			api.Bind = component
		else
			if props.Default then
				component:SetBind(props.Default)
			end
		
			api.Options[props.Name] = component
		end
		
		return component
	end,
	Button = function(props, children, api)
		local button = Instance.new('TextButton')
		button.AutoButtonColor = false
		button.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
		button.BorderSizePixel = 0
		button.Size = UDim2.new(1, 0, 0, 31)
		button.Text = ''
		button.Parent = children
		addTooltip(button, props.Tooltip)
		local holder = Instance.new('Frame')
		holder.BackgroundColor3 = color.Light(uipallet.Main, 0.05)
		holder.Position = UDim2.fromOffset(10, 2)
		holder.Size = UDim2.fromOffset(200, 27)
		holder.Parent = button
		addCorner(holder)
		local title = Instance.new('TextLabel')
		title.BackgroundColor3 = uipallet.Main
		title.FontFace = uipallet.Font
		title.Position = UDim2.fromOffset(2, 2)
		title.Size = UDim2.new(1, -4, 1, -4)
		title.Text = props.Name
		title.TextColor3 = color.Dark(uipallet.Text, 0.16)
		title.TextSize = 14
		title.Parent = holder
		addCorner(title, UDim.new(0, 4))
		props.Function = props.Function or function() end
		
		button.MouseEnter:Connect(function()
			tween:Tween(holder, uipallet.Tween, {
				BackgroundColor3 = color.Light(uipallet.Main, 0.0875)
			})
		end)
		
		button.MouseLeave:Connect(function()
			tween:Tween(holder, uipallet.Tween, {
				BackgroundColor3 = color.Light(uipallet.Main, 0.05)
			})
		end)
		
		button.MouseButton1Click:Connect(props.Function)
	end,
	Category = function(props, children, api)
		local component = {
			Expanded = false,
			Name = props.Name,
			Type = 'Category'
		}
		
		local window = Instance.new('TextButton')
		window.AutoButtonColor = false
		window.BackgroundColor3 = uipallet.Main
		window.Name = props.Name..'Category'
		window.Position = UDim2.fromOffset(236, 60)
		window.Size = UDim2.fromOffset(220, 41)
		window.Text = ''
		window.Visible = false
		window.Parent = clickgui
		addBlur(window)
		addCorner(window)
		addDragHandler(window)
		local icon = Instance.new('ImageLabel')
		icon.BackgroundTransparency = 1
		icon.Image = props.Icon
		icon.ImageColor3 = uipallet.Text
		icon.Position = UDim2.fromOffset(12, (icon.Size.X.Offset > 20 and 14 or 13))
		icon.Size = props.Size
		icon.Parent = window
		local title = Instance.new('TextLabel')
		title.BackgroundTransparency = 1
		title.FontFace = uipallet.Font
		title.Size = UDim2.new(1, -(props.Size.X.Offset > 18 and 40 or 33), 0, 41)
		title.Position = UDim2.fromOffset(math.abs(title.Size.X.Offset), 0)
		title.Text = props.Name
		title.TextColor3 = uipallet.Text
		title.TextSize = 13
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = window
		local pencilbutton = Instance.new('TextButton')
		pencilbutton.BackgroundTransparency = 1
		pencilbutton.Position = UDim2.new(1, -49, 0, 0)
		pencilbutton.Size = UDim2.fromOffset(20, 40)
		pencilbutton.Text = ''
		pencilbutton.Visible = false
		pencilbutton.Parent = window
		addTooltip(pencilbutton, 'Edit hidden modules')
		local pencil = Instance.new('ImageLabel')
		pencil.BackgroundTransparency = 1
		pencil.Image = getvapeasset('newvape/assets/new/editlarge.png')
		pencil.ImageColor3 = Color3.fromRGB(140, 140, 140)
		pencil.Size = UDim2.fromOffset(12, 12)
		pencil.Position = UDim2.fromOffset(4, 14)
		pencil.Parent = pencilbutton
		local arrowbutton = Instance.new('TextButton')
		arrowbutton.BackgroundTransparency = 1
		arrowbutton.Position = UDim2.new(1, -29, 0, 0)
		arrowbutton.Size = UDim2.fromOffset(27, 40)
		arrowbutton.Text = ''
		arrowbutton.Parent = window
		local arrow = Instance.new('ImageLabel')
		arrow.BackgroundTransparency = 1
		arrow.Image = getvapeasset('newvape/assets/new/downexpand.png')
		arrow.ImageColor3 = Color3.fromRGB(140, 140, 140)
		arrow.Size = UDim2.fromOffset(9, 4)
		arrow.Position = UDim2.fromOffset(9, 18)
		arrow.Rotation = 180
		arrow.Parent = arrowbutton
		local done = Instance.new('TextButton')
		done.BackgroundTransparency = 1
		done.FontFace = uipallet.Font
		done.Position = UDim2.new(1, -73, 0, 0)
		done.Size = UDim2.fromOffset(42, 40)
		done.Text = 'DONE'
		done.TextColor3 = Color3.fromRGB(140, 140, 140)
		done.TextSize = 12
		done.Visible = false
		done.Parent = window
		component.Done = done
		local children = Instance.new('ScrollingFrame')
		children.BackgroundTransparency = 1
		children.BorderSizePixel = 0
		children.CanvasSize = UDim2.new()
		children.Name = 'Children'
		children.Position = UDim2.fromOffset(0, 37)
		children.ScrollBarThickness = 2
		children.ScrollBarImageTransparency = 0.75
		children.Size = UDim2.new(1, 0, 1, -41)
		children.Visible = false
		children.Parent = window
		local divider = Instance.new('Frame')
		divider.BackgroundColor3 = Color3.new(1, 1, 1)
		divider.BackgroundTransparency = 0.928
		divider.BorderSizePixel = 0
		divider.Position = UDim2.fromOffset(0, 37)
		divider.Size = UDim2.new(1, 0, 0, 1)
		divider.Visible = false
		divider.Parent = window
		local stroke = Instance.new('UIStroke')
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Color = Color3.fromRGB(85, 85, 85)
		stroke.Transparency = 0.8
		stroke.Parent = window
		local windowlist = Instance.new('UIListLayout')
		windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
		windowlist.SortOrder = Enum.SortOrder.LayoutOrder
		windowlist.Parent = children
		
		function component:Color(hue, sat, val, isRainbow) end
		
		function component:Expand()
			self.Expanded = not self.Expanded
			children.Visible = self.Expanded
			arrow.Rotation = self.Expanded and 0 or 180
			window.Size = UDim2.fromOffset(220, self.Expanded and math.min(41 + windowlist.AbsoluteContentSize.Y / scale.Scale, 601) or 41)
			divider.Visible = children.CanvasPosition.Y > 10 and children.Visible
			if vape and type(vape.ScheduleSave) == 'function' then
				vape:ScheduleSave()
			end
		end
		
		function component:Load(data)
			if data.Enabled then
				self.Button:Toggle()
			end
		
			if data.Expanded then
				self:Expand()
			end
		
			if data.Position then
				window.Position = UDim2.fromOffset(data.Position.X, data.Position.Y)
			end
		end
		
		function component:Save(data)
			data[props.Name] = {
				Enabled = self.Button.Enabled,
				Expanded = self.Expanded,
				Position = {
					X = window.Position.X.Offset,
					Y = window.Position.Y.Offset
				}
			}
		end
		
		for index, comp in components do
			component['Create'..index] = function(_, props)
				return comp(props, children, component)
			end
		end
		
		arrowbutton.MouseButton1Click:Connect(function()
			component:Expand()
		end)
		
		arrowbutton.MouseButton2Click:Connect(function()
			component:Expand()
		end)
		
		arrowbutton.MouseEnter:Connect(function()
			arrow.ImageColor3 = Color3.fromRGB(220, 220, 220)
		end)
		
		arrowbutton.MouseLeave:Connect(function()
			arrow.ImageColor3 = Color3.fromRGB(140, 140, 140)
		end)
		
		done.MouseButton1Click:Connect(function()
			vape.EditGUI = false
			pencilbutton.Visible = true
		
			for _, category in vape.Categories do
				if category.Type == 'Category' then
					category.Done.Visible = false
				end
			end
		
			for _, module in vape.Modules do
				module.Object.Visible = module.Visible
				module.Object.Text = string.rep('\226\128\138', 12)..module.Name
				module.Edit.Visible = false
			end
		end)
		
		done.MouseEnter:Connect(function()
			done.TextColor3 = Color3.fromRGB(220, 220, 220)
		end)
		
		done.MouseLeave:Connect(function()
			done.TextColor3 = Color3.fromRGB(140, 140, 140)
		end)
		
		pencilbutton.MouseButton1Click:Connect(function()
			vape.EditGUI = true
			pencilbutton.Visible = false
		
			for _, category in vape.Categories do
				if category.Type == 'Category' then
					category.Done.Visible = true
				end
			end
		
			for _, module in vape.Modules do
				module.Object.Visible = true
				module.Object.Text = string.rep('\226\128\138', 50)..module.Name
				module.Edit.Visible = true
			end
		end)
		
		pencilbutton.MouseButton2Click:Connect(function()
			component:Expand()
		end)
		
		pencilbutton.MouseEnter:Connect(function()
			pencil.ImageColor3 = Color3.fromRGB(220, 220, 220)
		end)
		
		pencilbutton.MouseLeave:Connect(function()
			pencil.ImageColor3 = Color3.fromRGB(140, 140, 140)
		end)
		
		window.MouseEnter:Connect(function()
			pencilbutton.Visible = not vape.EditGUI
		end)
		
		window.MouseLeave:Connect(function()
			pencilbutton.Visible = false
		end)
		
		window.InputBegan:Connect(function(input)
			if input.Position.Y < window.AbsolutePosition.Y + 41 and input.UserInputType == Enum.UserInputType.MouseButton2 then
				component:Expand()
			end
		end)
		
		children:GetPropertyChangedSignal('CanvasPosition'):Connect(function()
			if vape.ThreadFix then
				setthreadidentity(8)
			end
		
			divider.Visible = children.CanvasPosition.Y > 10 and children.Visible
		end)
		
		windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			if vape.ThreadFix then
				setthreadidentity(8)
			end
		
			children.CanvasSize = UDim2.fromOffset(0, windowlist.AbsoluteContentSize.Y / scale.Scale)
			if component.Expanded then
				window.Size = UDim2.fromOffset(220, math.min(41 + windowlist.AbsoluteContentSize.Y / scale.Scale, 601))
			end
		end)
		
		component.Button = vape.Categories.Main:CreateGUIButton({
			Name = props.Name,
			Icon = props.Icon,
			Size = props.Size,
			Window = window
		})
		
		component.Object = window
		vape.Categories[props.Name] = component
		
		return component
	end,
	CategoryList = function(props, children, api)
		local component = {
			Expanded = false,
			List = {},
			ListEnabled = {},
			Objects = {},
			Options = {},
			Type = 'CategoryList'
		}
		props.Color = props.Color or Color3.fromRGB(5, 134, 105)
		
		local window = Instance.new('TextButton')
		window.AutoButtonColor = false
		window.BackgroundColor3 = uipallet.Main
		window.Name = props.Name..'CategoryList'
		window.Position = UDim2.fromOffset(240, 46)
		window.Size = UDim2.fromOffset(220, 45)
		window.Text = ''
		window.Visible = false
		window.Parent = clickgui
		addBlur(window)
		addCorner(window)
		addDragHandler(window)
		local icon = Instance.new('ImageLabel')
		icon.BackgroundTransparency = 1
		icon.Image = props.Icon
		icon.ImageColor3 = uipallet.Text
		icon.Name = 'Icon'
		icon.Size = props.Size
		icon.Position = props.Position or UDim2.fromOffset(12, (props.Size.X.Offset > 20 and 13 or 12))
		icon.Parent = window
		local title = Instance.new('TextLabel')
		title.BackgroundTransparency = 1
		title.FontFace = uipallet.Font
		title.Name = 'Title'
		title.Size = UDim2.new(1, -(props.Size.X.Offset > 20 and 44 or 36), 0, 20)
		title.Position = UDim2.fromOffset(math.abs(title.Size.X.Offset), 12)
		title.Text = props.Name
		title.TextColor3 = uipallet.Text
		title.TextSize = 13
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = window
		local arrowbutton = Instance.new('TextButton')
		arrowbutton.BackgroundTransparency = 1
		arrowbutton.Name = 'Arrow'
		arrowbutton.Position = UDim2.new(1, -40, 0, 0)
		arrowbutton.Size = UDim2.fromOffset(40, 40)
		arrowbutton.Text = ''
		arrowbutton.Parent = window
		local arrow = Instance.new('ImageLabel')
		arrow.Name = 'Arrow'
		arrow.Size = UDim2.fromOffset(9, 4)
		arrow.Position = UDim2.fromOffset(15, 20)
		arrow.BackgroundTransparency = 1
		arrow.Image = getvapeasset('newvape/assets/new/downexpand.png')
		arrow.ImageColor3 = Color3.fromRGB(140, 140, 140)
		arrow.Rotation = 180
		arrow.Parent = arrowbutton
		local children = Instance.new('ScrollingFrame')
		children.Name = 'Children'
		children.Size = UDim2.new(1, 0, 1, -45)
		children.Position = UDim2.fromOffset(0, 45)
		children.BackgroundTransparency = 1
		children.BorderSizePixel = 0
		children.Visible = false
		children.ScrollBarThickness = 2
		children.ScrollBarImageTransparency = 0.75
		children.CanvasSize = UDim2.new()
		children.Parent = window
		local childrentwo = Instance.new('Frame')
		childrentwo.BackgroundTransparency = 1
		childrentwo.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
		childrentwo.Visible = false
		childrentwo.Parent = children
		local settings = Instance.new('ImageButton')
		settings.AutoButtonColor = false
		settings.BackgroundTransparency = 1
		settings.Image = getvapeasset('newvape/assets/new/settings.png')
		settings.ImageColor3 = color.Dark(uipallet.Text, 0.43)
		settings.Name = 'Settings'
		settings.Position = UDim2.new(1, -56, 0, 15)
		settings.Size = UDim2.fromOffset(14, 14)
		settings.Parent = window
		local divider = Instance.new('Frame')
		divider.BackgroundColor3 = Color3.new(1, 1, 1)
		divider.BackgroundTransparency = 0.928
		divider.BorderSizePixel = 0
		divider.Name = 'Divider'
		divider.Position = UDim2.fromOffset(0, 41)
		divider.Size = UDim2.new(1, 0, 0, 1)
		divider.Visible = false
		divider.Parent = window
		local stroke = Instance.new('UIStroke')
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Color = Color3.fromRGB(85, 85, 85)
		stroke.Transparency = 0.8
		stroke.Parent = window
		local windowlist = Instance.new('UIListLayout')
		windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
		windowlist.Padding = UDim.new(0, 4)
		windowlist.SortOrder = Enum.SortOrder.LayoutOrder
		windowlist.Parent = children
		local windowlisttwo = Instance.new('UIListLayout')
		windowlisttwo.HorizontalAlignment = Enum.HorizontalAlignment.Center
		windowlisttwo.SortOrder = Enum.SortOrder.LayoutOrder
		windowlisttwo.Parent = childrentwo
		local addbkg = Instance.new('Frame')
		addbkg.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
		addbkg.Position = UDim2.fromOffset(10, 45)
		addbkg.Size = UDim2.fromOffset(200, 31)
		addbkg.Parent = children
		addCorner(addbkg)
		local addbox = addbkg:Clone()
		addbox.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
		addbox.Position = UDim2.fromOffset(1, 1)
		addbox.Size = UDim2.new(1, -2, 1, -2)
		addbox.Parent = addbkg
		local addvalue = Instance.new('TextBox')
		addvalue.BackgroundTransparency = 1
		addvalue.ClearTextOnFocus = false
		addvalue.FontFace = uipallet.Font
		addvalue.PlaceholderText = props.Placeholder or 'Add entry...'
		addvalue.PlaceholderColor3 = Color3.new(0.8, 0.8, 0.8)
		addvalue.Position = UDim2.fromOffset(10, 0)
		addvalue.Size = UDim2.new(1, -35, 1, 0)
		addvalue.Text = ''
		addvalue.TextColor3 = Color3.new(1, 1, 1)
		addvalue.TextSize = 13
		addvalue.TextXAlignment = Enum.TextXAlignment.Left
		addvalue.Parent = addbkg
		local autocomplete
		if props.Player then
			addvalue.ZIndex = 2
			autocomplete = Instance.new('TextLabel')
			autocomplete.BackgroundTransparency = 1
			autocomplete.FontFace = uipallet.Font
			autocomplete.Position = UDim2.fromOffset(10, 0)
			autocomplete.Size = UDim2.new(1, -35, 1, 0)
			autocomplete.Text = ''
			autocomplete.TextColor3 = Color3.new(0.6, 0.6, 0.6)
			autocomplete.TextSize = 13
			autocomplete.TextXAlignment = Enum.TextXAlignment.Left
			autocomplete.Parent = addbkg
		end
		local addbutton = Instance.new('ImageButton')
		addbutton.BackgroundTransparency = 1
		addbutton.Image = getvapeasset('newvape/assets/new/add.png')
		addbutton.ImageColor3 = props.Color
		addbutton.ImageTransparency = 0.3
		addbutton.Position = UDim2.new(1, -26, 0, 8)
		addbutton.Size = UDim2.fromOffset(16, 16)
		addbutton.Parent = addbkg
		local cursedpadding = Instance.new('Frame')
		cursedpadding.BackgroundTransparency = 1
		cursedpadding.Size = UDim2.fromOffset()
		cursedpadding.Parent = children
		props.Function = props.Function or function() end
		
		function component:CreateProfile(value, data)
			local profile = {
				Name = value
			}
		
			profile.Bind = components.Bind({
				Module = true,
				Cover = true
			}, nil, profile)
			profile.Bind.Object.Position = UDim2.new(1, -30, 0, 7)
			profile.Bind.Triggered:Connect(function(isPressed)
				if isPressed and vape.Profile ~= value then
					vape:Save(value)
					vape:Load(true)
					self:ChangeValue()
				end
			end)
		
			if data then
				profile.Bind:Load(data)
			end
		
			table.insert(self.List, profile)
		end
		
		function component:ChangeValue(value, skipGUI)
			if value then
				if props.Profiles then
					local index, profile = self:GetValue(value)
					if index then
						if value ~= 'default' then
							profile.Bind:Destroy()
							table.remove(self.List, index)
		
							if isfile('newvape/profiles/'..value..vape.Place..'.txt') and delfile then
								delfile('newvape/profiles/'..value..vape.Place..'.txt')
							end
						end
					else
						self:CreateProfile(value)
					end
				else
					local index = table.find(self.List, value)
					if index then
						table.remove(self.List, index)
		
						index = table.find(self.ListEnabled, value)
						if index then
							table.remove(self.ListEnabled, index)
						end
					else
						table.insert(self.List, value)
						table.insert(self.ListEnabled, value)
					end
				end
			end
		
			props.Function()
			for _, obj in self.Objects do
				obj:Destroy()
			end
			table.clear(self.Objects)
			self.Selected = nil
		
			if vape.ThreadFix then
				setthreadidentity(8)
			end
		
			for _, name in self.List do
				if props.Profiles then
					local obj = Instance.new('TextButton')
					obj.Name = name.Name
					obj.Size = UDim2.fromOffset(200, 32)
					obj.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
					obj.AutoButtonColor = false
					obj.Text = ''
					obj.Parent = children
					addCorner(obj)
					local stroke = Instance.new('UIStroke')
					stroke.Color = color.Light(uipallet.Main, 0.1)
					stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					stroke.Enabled = false
					stroke.Parent = obj
					local label = Instance.new('TextLabel')
					label.Name = 'Title'
					label.Size = UDim2.new(1, -10, 1, 0)
					label.Position = UDim2.fromOffset(10, 0)
					label.BackgroundTransparency = 1
					label.Text = name.Name
					label.TextXAlignment = Enum.TextXAlignment.Left
					label.TextColor3 = color.Dark(uipallet.Text, 0.4)
					label.TextSize = 15
					label.FontFace = uipallet.Font
					label.Parent = obj
					local dotsbutton = Instance.new('TextButton')
					dotsbutton.BackgroundTransparency = 1
					dotsbutton.Name = 'Dots'
					dotsbutton.Position = UDim2.new(1, -25, 0, 0)
					dotsbutton.Size = UDim2.fromOffset(25, 32)
					dotsbutton.Text = ''
					dotsbutton.Parent = obj
					local dots = Instance.new('ImageLabel')
					dots.BackgroundTransparency = 1
					dots.Image = getvapeasset('newvape/assets/new/settingdots.png')
					dots.ImageColor3 = color.Light(uipallet.Main, 0.37)
					dots.Name = 'Dots'
					dots.Position = UDim2.fromOffset(11, 9)
					dots.Size = UDim2.fromOffset(3, 16)
					dots.Parent = dotsbutton
					name.Bind:SetParent(obj)
					name.Enabled = name.Name == vape.Profile
		
					dotsbutton.MouseButton1Click:Connect(function()
						if not name.Enabled then
							component:ChangeValue(name.Name)
						end
					end)
		
					dotsbutton.MouseEnter:Connect(function()
						if not name.Enabled then
							dots.ImageColor3 = uipallet.Text
						end
					end)
		
					dotsbutton.MouseLeave:Connect(function()
						if not name.Enabled then
							dots.ImageColor3 = color.Light(uipallet.Main, 0.37)
						end
					end)
		
		
					obj.MouseButton1Click:Connect(function()
						vape:Save(name.Name)
						vape:Load(true)
						self:ChangeValue()
					end)
		
					obj.MouseEnter:Connect(function()
						name.Bind:SetVisible(true)
					end)
		
					obj.MouseLeave:Connect(function()
						name.Bind:SetVisible(false)
					end)
		
					if name.Enabled then
						self.Selected = obj
					else
						name.Bind:SetColor(color.Dark(uipallet.Text, 0.43))
					end
		
					table.insert(self.Objects, {
						Destroy = function()
							name.Bind:SetParent(nil)
							obj:Destroy()
						end
					})
				else
					local isEnabled = table.find(self.ListEnabled, name)
					local obj = Instance.new('TextButton')
					obj.Name = name
					obj.Size = UDim2.fromOffset(200, 31)
					obj.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
					obj.AutoButtonColor = false
					obj.Text = ''
					obj.Parent = children
					addCorner(obj)
					local bkg = Instance.new('Frame')
					bkg.BackgroundColor3 = uipallet.Main
					bkg.Position = UDim2.fromOffset(1, 1)
					bkg.Size = UDim2.new(1, -2, 1, -2)
					bkg.Visible = false
					bkg.Parent = obj
					addCorner(bkg)
					local dot = Instance.new('Frame')
					dot.BackgroundColor3 = isEnabled and props.Color or color.Light(uipallet.Main, 0.37)
					dot.Position = UDim2.fromOffset(10, 12)
					dot.Size = UDim2.fromOffset(10, 11)
					dot.Parent = obj
					addCorner(dot, UDim.new(1, 0))
					local dotin = dot:Clone()
					dotin.BackgroundColor3 = isEnabled and props.Color or color.Light(uipallet.Main, 0.02)
					dotin.Position = UDim2.fromOffset(1, 1)
					dotin.Size = UDim2.fromOffset(8, 9)
					dotin.Parent = dot
					local label = Instance.new('TextLabel')
					label.BackgroundTransparency = 1
					label.FontFace = uipallet.Font
					label.Position = UDim2.fromOffset(30, 0)
					label.Size = UDim2.new(1, -30, 1, 0)
					label.Text = name
					label.TextColor3 = color.Dark(uipallet.Text, 0.16)
					label.TextSize = 15
					label.TextXAlignment = Enum.TextXAlignment.Left
					label.Parent = obj
					local close = Instance.new('ImageButton')
					close.AutoButtonColor = false
					close.BackgroundColor3 = Color3.new(1, 1, 1)
					close.BackgroundTransparency = 1
					close.Image = getvapeasset('newvape/assets/new/closetiny.png')
					close.ImageColor3 = color.Light(uipallet.Text, 0.2)
					close.ImageTransparency = 0.5
					close.Position = UDim2.new(1, -27, 0, 8)
					close.Size = UDim2.fromOffset(18, 17)
					close.Parent = obj
					addCorner(close, UDim.new(1, 0))
		
					close.MouseEnter:Connect(function()
						close.ImageTransparency = 0.3
						tween:Tween(close, uipallet.Tween, {
							BackgroundTransparency = 0.6
						})
					end)
		
					close.MouseLeave:Connect(function()
						close.ImageTransparency = 0.5
						tween:Tween(close, uipallet.Tween, {
							BackgroundTransparency = 1
						})
					end)
		
					close.MouseButton1Click:Connect(function()
						component:ChangeValue(name)
					end)
		
					obj.MouseEnter:Connect(function()
						bkg.Visible = true
					end)
		
					obj.MouseLeave:Connect(function()
						bkg.Visible = false
					end)
		
					obj.MouseButton1Click:Connect(function()
						local index = table.find(self.ListEnabled, name)
						if index then
							table.remove(self.ListEnabled, index)
							dot.BackgroundColor3 = color.Light(uipallet.Main, 0.37)
							dotin.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
						else
							table.insert(self.ListEnabled, name)
							dot.BackgroundColor3 = props.Color
							dotin.BackgroundColor3 = props.Color
						end
		
						props.Function()
					end)
		
					table.insert(self.Objects, obj)
				end
			end
		
			if not skipGUI then
				vape:UpdateGUI()
			end
			if vape and type(vape.ScheduleSave) == 'function' then
				vape:ScheduleSave()
			end
		end
		
		function component:Color(hue, sat, val, isRainbow)
			for _, component in self.Options do
				if component.Color then
					component:Color(hue, sat, val, isRainbow)
				end
			end
		
			addbutton.ImageColor3 = isRainbow and Color3.fromHSV(vape:Color(hue % 1)) or Color3.fromHSV(hue, sat, val)
		
			if self.Selected then
				self.Selected.BackgroundColor3 = isRainbow and Color3.fromHSV(vape:Color(hue % 1)) or Color3.fromHSV(hue, sat, val)
				self.Selected.Title.TextColor3 = vape.GUIColor.Rainbow and Color3.new(0.19, 0.19, 0.19) or vape:TextColor(hue, sat, val)
				self.Selected.Dots.Dots.ImageColor3 = self.Selected.Title.TextColor3
				self.Selected.Bind.Icon.ImageColor3 = self.Selected.Title.TextColor3
				self.Selected.Bind.TextLabel.TextColor3 = self.Selected.Title.TextColor3
			end
		end
		
		function component:Expand()
			self.Expanded = not self.Expanded
			children.Visible = self.Expanded
			arrow.Rotation = self.Expanded and 0 or 180
			window.Size = UDim2.fromOffset(220, self.Expanded and math.min(51 + windowlist.AbsoluteContentSize.Y / scale.Scale, 611) or 45)
			divider.Visible = children.CanvasPosition.Y > 10 and children.Visible
		end
		
		function component:GetValue(name)
			for index, profile in self.List do
				if profile.Name == name then
					return index, profile
				end
			end
		end
		
		function component:Load(data)
			vape:LoadOptions(self, data.Options)
		
			if data.Enabled then
				self.Button:Toggle()
			end
		
			if data.Expanded then
				self:Expand()
			end
		
			if props.Profiles then
				for _, profile in data.List do
					self:CreateProfile(profile.Name, profile.Bind)
				end
		
				self:ChangeValue(nil, true)
			else
				if data.List and (#self.List > 0 or #data.List > 0) then
					self.List = data.List or {}
					self.ListEnabled = data.ListEnabled or {}
					self:ChangeValue(nil, true)
				end
			end
		
			if data.Position then
				window.Position = UDim2.fromOffset(data.Position.X, data.Position.Y)
			end
		end
		
		function component:Save(data)
			data[props.Name] = {
				Enabled = self.Button.Enabled,
				Expanded = self.Expanded,
				List = self.List,
				ListEnabled = self.ListEnabled,
				Options = vape:SaveOptions(self),
				Position = {
					X = window.Position.X.Offset,
					Y = window.Position.Y.Offset
				}
			}
		
			if props.Profiles then
				local newList = {}
		
				for _, profile in self.List do
					local entry = {
						Name = profile.Name
					}
		
					profile.Bind:Save(entry)
					table.insert(newList, entry)
				end
		
				data[props.Name].List = newList
			end
		end
		
		for index, comp in components do
			component['Create'..index] = function(_, props)
				return comp(props, childrentwo, component)
			end
		end
		
		addbutton.MouseEnter:Connect(function()
			addbutton.ImageTransparency = 0
		end)
		
		addbutton.MouseLeave:Connect(function()
			addbutton.ImageTransparency = 0.3
		end)
		
		addbutton.MouseButton1Click:Connect(function()
			if not table.find(component.List, addvalue.Text) then
				component:ChangeValue(addvalue.Text)
				addvalue.Text = ''
			end
		end)
		
		arrowbutton.MouseEnter:Connect(function()
			arrow.ImageColor3 = Color3.fromRGB(220, 220, 220)
		end)
		
		arrowbutton.MouseLeave:Connect(function()
			arrow.ImageColor3 = Color3.fromRGB(140, 140, 140)
		end)
		
		arrowbutton.MouseButton1Click:Connect(function()
			component:Expand()
		end)
		
		arrowbutton.MouseButton2Click:Connect(function()
			component:Expand()
		end)
		
		if autocomplete then
			addvalue:GetPropertyChangedSignal('Text'):Connect(function()
				local plr = getPlayerFromText(addvalue.Text)
				autocomplete.Text = plr and addvalue.Text..(plr:sub(#addvalue.Text + 1, #plr)) or ''
			end)
		
			addvalue.Focused:Connect(function()
				vape.Autocomplete = function()
					local newText = getPlayerFromText(addvalue.Text) or addvalue.Text
					task.spawn(function()
						addvalue:GetPropertyChangedSignal('Text'):Wait()
						addvalue.Text = newText
						addvalue.CursorPosition = #newText + 1
					end)
				end
			end)
		end
		
		addvalue.FocusLost:Connect(function(enter)
			if enter and not table.find(component.List, addvalue.Text) then
				component:ChangeValue(addvalue.Text)
				addvalue.Text = ''
			end
		
			vape.Autocomplete = nil
		end)
		
		addvalue.MouseEnter:Connect(function()
			tween:Tween(addbkg, uipallet.Tween, {
				BackgroundColor3 = color.Light(uipallet.Main, 0.14)
			})
		end)
		
		addvalue.MouseLeave:Connect(function()
			tween:Tween(addbkg, uipallet.Tween, {
				BackgroundColor3 = color.Light(uipallet.Main, 0.02)
			})
		end)
		
		children:GetPropertyChangedSignal('CanvasPosition'):Connect(function()
			divider.Visible = children.CanvasPosition.Y > 10 and children.Visible
		end)
		
		settings.MouseEnter:Connect(function()
			settings.ImageColor3 = uipallet.Text
		end)
		
		settings.MouseLeave:Connect(function()
			settings.ImageColor3 = color.Light(uipallet.Main, 0.37)
		end)
		
		settings.MouseButton1Click:Connect(function()
			childrentwo.Visible = not childrentwo.Visible
		end)
		
		window.InputBegan:Connect(function(input)
			if input.Position.Y < window.AbsolutePosition.Y + 41 and input.UserInputType == Enum.UserInputType.MouseButton2 then
				component:Expand()
			end
		end)
		
		windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			if vape.ThreadFix then
				setthreadidentity(8)
			end
		
			children.CanvasSize = UDim2.fromOffset(0, windowlist.AbsoluteContentSize.Y / scale.Scale)
			if component.Expanded then
				window.Size = UDim2.fromOffset(220, math.min(51 + windowlist.AbsoluteContentSize.Y / scale.Scale, 611))
			end
		end)
		
		windowlisttwo:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			if vape.ThreadFix then
				setthreadidentity(8)
			end
		
			childrentwo.Size = UDim2.fromOffset(220, windowlisttwo.AbsoluteContentSize.Y / scale.Scale)
		end)
		
		component.Button = vape.Categories.Main:CreateGUIButton({
			Name = props.Name,
			Icon = props.CategoryIcon,
			Size = props.CategorySize,
			Window = window
		})
		
		component.Object = window
		vape.Categories[props.Name] = component
		
		return component
	end,
	ColorSlider = function(props, children, api)
		local component = {
			Type = 'ColorSlider',
			Hue = props.DefaultHue or 0.44,
			Sat = props.DefaultSat or 1,
			Value = props.DefaultValue or 1,
			Opacity = props.DefaultOpacity or 1,
			Rainbow = false,
			Index = 0
		}
		
		local function createExtraSlider(name, gradientColor)
			local colorslidercustom = Instance.new('TextButton')
			colorslidercustom.AutoButtonColor = false
			colorslidercustom.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
			colorslidercustom.BorderSizePixel = 0
			colorslidercustom.Size = UDim2.new(1, 0, 0, 50)
			colorslidercustom.Text = ''
			colorslidercustom.Visible = false
			colorslidercustom.Parent = children
			local title = Instance.new('TextLabel')
			title.BackgroundTransparency = 1
			title.FontFace = uipallet.Font
			title.Position = UDim2.fromOffset(10, 2)
			title.Size = UDim2.fromOffset(60, 30)
			title.Text = name
			title.TextColor3 = color.Dark(uipallet.Text, 0.16)
			title.TextSize = 11
			title.TextXAlignment = Enum.TextXAlignment.Left
			title.Parent = colorslidercustom
			local holder = Instance.new('Frame')
			holder.BackgroundColor3 = Color3.new(1, 1, 1)
			holder.BorderSizePixel = 0
			holder.Name = 'Holder'
			holder.Position = UDim2.fromOffset(10, 37)
			holder.Size = UDim2.new(1, -20, 0, 2)
			holder.Parent = colorslidercustom
			local uigradient = Instance.new('UIGradient')
			uigradient.Color = gradientColor
			uigradient.Parent = holder
			local fill = Instance.new('Frame')
			fill.BackgroundTransparency = 1
			fill.Name = 'Fill'
			fill.Size = UDim2.fromScale(math.clamp(name == 'Saturation' and component.Sat or name == 'Vibrance' and component.Value or component.Opacity, 0.04, 0.96), 1)
			fill.Parent = holder
			local knobholder = Instance.new('Frame')
			knobholder.AnchorPoint = Vector2.new(0.5, 0.5)
			knobholder.BackgroundColor3 = colorslidercustom.BackgroundColor3
			knobholder.BorderSizePixel = 0
			knobholder.Position = UDim2.fromScale(1, 0.5)
			knobholder.Size = UDim2.fromOffset(24, 4)
			knobholder.Parent = fill
			local knob = Instance.new('Frame')
			knob.AnchorPoint = Vector2.new(0.5, 0.5)
			knob.BackgroundColor3 = uipallet.Text
			knob.Position = UDim2.fromScale(0.5, 0.5)
			knob.Size = UDim2.fromOffset(14, 14)
			knob.Parent = knobholder
			addCorner(knob, UDim.new(1, 0))
		
			colorslidercustom.InputBegan:Connect(function(input)
				if
					(input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
					and (input.Position.Y - colorslidercustom.AbsolutePosition.Y) > (20 * scale.Scale)
				then
					local releaseConnection
					local moveConnection = inputService.InputChanged:Connect(function(newInput)
						if newInput.UserInputType == (input.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
							local newValue = math.clamp((newInput.Position.X - holder.AbsolutePosition.X) / holder.AbsoluteSize.X, 0, 1)
							component:SetValue(nil, name == 'Saturation' and newValue or nil, name == 'Vibrance' and newValue or nil, name == 'Opacity' and newValue or nil)
						end
					end)
		
					releaseConnection = input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							moveConnection:Disconnect()
							releaseConnection:Disconnect()
						end
					end)
				end
			end)
		
			colorslidercustom.MouseEnter:Connect(function()
				tween:Tween(knob, uipallet.Tween, {
					Size = UDim2.fromOffset(16, 16)
				})
			end)
		
			colorslidercustom.MouseLeave:Connect(function()
				tween:Tween(knob, uipallet.Tween, {
					Size = UDim2.fromOffset(14, 14)
				})
			end)
		
			return colorslidercustom
		end
		
		local colorslider = Instance.new('TextButton')
		colorslider.AutoButtonColor = false
		colorslider.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
		colorslider.BorderSizePixel = 0
		colorslider.Size = UDim2.new(1, 0, 0, 50)
		colorslider.Text = ''
		colorslider.Visible = props.Visible == nil or props.Visible
		colorslider.Parent = children
		component.Object = colorslider
		addTooltip(colorslider, props.Tooltip)
		local title = Instance.new('TextLabel')
		title.BackgroundTransparency = 1
		title.FontFace = uipallet.Font
		title.Position = UDim2.fromOffset(10, 2)
		title.Size = UDim2.fromOffset(60, 30)
		title.Text = props.Name
		title.TextColor3 = color.Dark(uipallet.Text, 0.16)
		title.TextSize = 11
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = colorslider
		local custombox = Instance.new('TextBox')
		custombox.BackgroundTransparency = 1
		custombox.FontFace = uipallet.Font
		custombox.Position = UDim2.new(1, -69, 0, 9)
		custombox.Size = UDim2.fromOffset(60, 15)
		custombox.Text = ''
		custombox.TextColor3 = color.Dark(uipallet.Text, 0.16)
		custombox.TextSize = 11
		custombox.TextXAlignment = Enum.TextXAlignment.Right
		custombox.Visible = false
		custombox.Parent = colorslider
		local holder = Instance.new('Frame')
		holder.BackgroundColor3 = Color3.new(1, 1, 1)
		holder.BorderSizePixel = 0
		holder.Position = UDim2.fromOffset(10, 39)
		holder.Size = UDim2.new(1, -20, 0, 2)
		holder.Parent = colorslider
		local rainbowTable = {}
		for i = 0, 1, 0.1 do
			table.insert(rainbowTable, ColorSequenceKeypoint.new(i, Color3.fromHSV(i, 1, 1)))
		end
		local uigradient = Instance.new('UIGradient')
		uigradient.Color = ColorSequence.new(rainbowTable)
		uigradient.Parent = holder
		local fill = Instance.new('Frame')
		fill.BackgroundTransparency = 1
		fill.Size = UDim2.fromScale(math.clamp(component.Hue, 0.04, 0.96), 1)
		fill.Parent = holder
		local knobholder = Instance.new('Frame')
		knobholder.AnchorPoint = Vector2.new(0.5, 0.5)
		knobholder.BackgroundColor3 = colorslider.BackgroundColor3
		knobholder.BorderSizePixel = 0
		knobholder.Position = UDim2.fromScale(1, 0.5)
		knobholder.Size = UDim2.fromOffset(24, 4)
		knobholder.Parent = fill
		local knob = Instance.new('Frame')
		knob.AnchorPoint = Vector2.new(0.5, 0.5)
		knob.BackgroundColor3 = uipallet.Text
		knob.Position = UDim2.fromScale(0.5, 0.5)
		knob.Size = UDim2.fromOffset(14, 14)
		knob.Parent = knobholder
		addCorner(knob, UDim.new(1, 0))
		local preview = Instance.new('ImageButton')
		preview.BackgroundTransparency = 1
		preview.Image = getvapeasset('newvape/assets/new/colorpreview.png')
		preview.ImageColor3 = Color3.fromHSV(component.Hue, component.Sat, component.Value)
		preview.ImageTransparency = 1 - component.Opacity
		preview.Position = UDim2.new(1, -22, 0, 10)
		preview.Size = UDim2.fromOffset(12, 12)
		preview.Parent = colorslider
		local expand = Instance.new('TextButton')
		expand.BackgroundTransparency = 1
		expand.Position = UDim2.fromOffset(getfontbounds(title.Text, title.TextSize, title.FontFace).X + 11, 7)
		expand.Size = UDim2.fromOffset(17, 13)
		expand.Text = ''
		expand.Parent = colorslider
		local icon = Instance.new('ImageLabel')
		icon.BackgroundTransparency = 1
		icon.Image = getvapeasset('newvape/assets/new/downexpandslider.png')
		icon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
		icon.Position = UDim2.fromOffset(4, 4)
		icon.Size = UDim2.fromOffset(10, 5)
		icon.Parent = expand
		local rainbow = Instance.new('TextButton')
		rainbow.BackgroundTransparency = 1
		rainbow.Position = UDim2.new(1, -42, 0, 10)
		rainbow.Size = UDim2.fromOffset(12, 12)
		rainbow.Text = ''
		rainbow.Parent = colorslider
		local ring1 = Instance.new('ImageLabel')
		ring1.BackgroundTransparency = 1
		ring1.Image = getvapeasset('newvape/assets/new/rainbow_1.png')
		ring1.ImageColor3 = color.Light(uipallet.Main, 0.37)
		ring1.Size = UDim2.fromOffset(12, 12)
		ring1.Parent = rainbow
		local ring2 = Instance.fromExisting(ring1)
		ring2.Image = getvapeasset('newvape/assets/new/rainbow_2.png')
		ring2.Parent = rainbow
		local ring3 = Instance.fromExisting(ring1)
		ring3.Image = getvapeasset('newvape/assets/new/rainbow_3.png')
		ring3.Parent = rainbow
		local ring4 = Instance.fromExisting(ring1)
		ring4.Image = getvapeasset('newvape/assets/new/rainbow_4.png')
		ring4.Parent = rainbow
		props.Function = props.Function or function() end
		
		local satSlider = createExtraSlider('Saturation', ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, component.Value)),
			ColorSequenceKeypoint.new(1, Color3.fromHSV(component.Hue, 1, component.Value))
		}))
		
		local vibSlider = createExtraSlider('Vibrance', ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromHSV(component.Hue, component.Sat, 1))
		}))
		
		local opSlider = createExtraSlider('Opacity', ColorSequence.new({
			ColorSequenceKeypoint.new(0, color.Dark(uipallet.Main, 0.02)),
			ColorSequenceKeypoint.new(1, Color3.fromHSV(component.Hue, component.Sat, component.Value))
		}))
		
		function component:Load(data)
			if data.Rainbow ~= self.Rainbow then
				self:Toggle()
			end
		
			if self.Hue ~= data.Hue or self.Sat ~= data.Sat or self.Value ~= data.Value or self.Opacity ~= data.Opacity then
				self:SetValue(data.Hue, data.Sat, data.Value, data.Opacity)
			end
		end
		
		function component:Save(data)
			data[props.Name] = {
				Hue = self.Hue,
				Sat = self.Sat,
				Value = self.Value,
				Opacity = self.Opacity,
				Rainbow = self.Rainbow
			}
		end
		
		function component:SetValue(h, s, v, o)
			self.Hue = h or self.Hue
			self.Sat = s or self.Sat
			self.Value = v or self.Value
			self.Opacity = o or self.Opacity
			preview.ImageColor3 = Color3.fromHSV(self.Hue, self.Sat, self.Value)
			preview.ImageTransparency = 1 - self.Opacity
		
			satSlider.Holder.UIGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, self.Value)),
				ColorSequenceKeypoint.new(1, Color3.fromHSV(self.Hue, 1, self.Value))
			})
		
			vibSlider.Holder.UIGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 0)),
				ColorSequenceKeypoint.new(1, Color3.fromHSV(self.Hue, self.Sat, 1))
			})
		
			opSlider.Holder.UIGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, color.Dark(uipallet.Main, 0.02)),
				ColorSequenceKeypoint.new(1, Color3.fromHSV(self.Hue, self.Sat, self.Value))
			})
		
			if self.Rainbow then
				fill.Size = UDim2.fromScale(math.clamp(self.Hue, 0.04, 0.96), 1)
			else
				tween:Tween(fill, uipallet.Tween, {
					Size = UDim2.fromScale(math.clamp(self.Hue, 0.04, 0.96), 1)
				})
			end
		
			if s then
				tween:Tween(satSlider.Holder.Fill, uipallet.Tween, {
					Size = UDim2.fromScale(math.clamp(self.Sat, 0.04, 0.96), 1)
				})
			end
		
			if v then
				tween:Tween(vibSlider.Holder.Fill, uipallet.Tween, {
					Size = UDim2.fromScale(math.clamp(self.Value, 0.04, 0.96), 1)
				})
			end
		
			if o then
				tween:Tween(opSlider.Holder.Fill, uipallet.Tween, {
					Size = UDim2.fromScale(math.clamp(self.Opacity, 0.04, 0.96), 1)
				})
			end
		
			props.Function(self.Hue, self.Sat, self.Value, self.Opacity)
			if not self.Rainbow and vape and type(vape.ScheduleSave) == 'function' then
				vape:ScheduleSave()
			end
		end
		
		function component:Toggle()
			self.Rainbow = not self.Rainbow
		
			if self.Rainbow then
				table.insert(vape.RainbowSliders, self)
		
				ring1.ImageColor3 = Color3.fromRGB(5, 127, 100)
				task.delay(0.1, function()
					if not self.Rainbow then return end
					ring2.ImageColor3 = Color3.fromRGB(228, 125, 43)
					task.delay(0.1, function()
						if not self.Rainbow then return end
						ring3.ImageColor3 = Color3.fromRGB(225, 46, 52)
					end)
				end)
			else
				local index = table.find(vape.RainbowSliders, self)
				if index then
					table.remove(vape.RainbowSliders, index)
				end
		
				ring3.ImageColor3 = color.Light(uipallet.Main, 0.37)
				task.delay(0.1, function()
					if self.Rainbow then return end
					ring2.ImageColor3 = color.Light(uipallet.Main, 0.37)
					task.delay(0.1, function()
						if self.Rainbow then return end
						ring1.ImageColor3 = color.Light(uipallet.Main, 0.37)
					end)
				end)
			end
			if vape and type(vape.ScheduleSave) == 'function' then
				vape:ScheduleSave()
			end
		end
		
		preview.MouseButton1Click:Connect(function()
			preview.Visible = false
			custombox.Visible = true
			custombox:CaptureFocus()
		
			local text = Color3.fromHSV(component.Hue, component.Sat, component.Value)
			custombox.Text = math.round(text.R * 255)..', '..math.round(text.G * 255)..', '..math.round(text.B * 255)
		end)
		
		local doubleClick = os.clock()
		colorslider.InputBegan:Connect(function(input)
			if
				(input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
				and (input.Position.Y - colorslider.AbsolutePosition.Y) > (20 * scale.Scale)
			then
				local releaseConnection
				local moveConnection = inputService.InputChanged:Connect(function(newInput)
					if newInput.UserInputType == (input.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
						component:SetValue(math.clamp((newInput.Position.X - holder.AbsolutePosition.X) / holder.AbsoluteSize.X, 0, 1))
					end
				end)
		
				releaseConnection = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						moveConnection:Disconnect()
						releaseConnection:Disconnect()
					end
				end)
		
				if doubleClick > os.clock() then
					component:Toggle()
				else
					component:SetValue(math.clamp((input.Position.X - holder.AbsolutePosition.X) / holder.AbsoluteSize.X, 0, 1))
				end
		
				doubleClick = os.clock() + 0.3
			end
		end)
		
		colorslider.MouseEnter:Connect(function()
			tween:Tween(knob, uipallet.Tween, {
				Size = UDim2.fromOffset(16, 16)
			})
		end)
		
		colorslider.MouseLeave:Connect(function()
			tween:Tween(knob, uipallet.Tween, {
				Size = UDim2.fromOffset(14, 14)
			})
		end)
		
		colorslider:GetPropertyChangedSignal('Visible'):Connect(function()
			satSlider.Visible = icon.Rotation == 180 and colorslider.Visible
			vibSlider.Visible = satSlider.Visible
			opSlider.Visible = satSlider.Visible
		end)
		
		expand.MouseEnter:Connect(function()
			icon.ImageColor3 = color.Dark(uipallet.Text, 0.16)
		end)
		
		expand.MouseLeave:Connect(function()
			icon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
		end)
		
		expand.MouseButton1Click:Connect(function()
			satSlider.Visible = not satSlider.Visible
			vibSlider.Visible = satSlider.Visible
			opSlider.Visible = satSlider.Visible
			icon.Rotation = satSlider.Visible and 180 or 0
		end)
		
		rainbow.MouseButton1Click:Connect(function()
			component:Toggle()
		end)
		
		custombox.FocusLost:Connect(function(enter)
			preview.Visible = true
			custombox.Visible = false
		
			if enter then
				local success, parsed = pcall(function()
					local commas = custombox.Text:split(',')
					return tonumber(commas[1]) and Color3.fromRGB(tonumber(commas[1]), tonumber(commas[2]), tonumber(commas[3])) or Color3.fromHex(valuebox.Text)
				end)
		
				if success then
					if component.Rainbow then
						component:Toggle()
					end
		
					component:SetValue(parsed:ToHSV())
				end
			end
		end)
		
		api.Options[props.Name] = component
		
		return component
	end,
	Divider = function(props, children, api)
		local divider = Instance.new('Frame')
		divider.Size = UDim2.new(1, 0, 0, 1)
		divider.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
		divider.BorderSizePixel = 0
		divider.Parent = children
		
		if props and props.Text then
			local label = Instance.new('TextLabel')
			label.Size = UDim2.fromOffset(218, 27)
			label.BackgroundTransparency = 1
			label.Text = '\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138'..props.Text:upper()
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.TextColor3 = color.Dark(uipallet.Text, 0.43)
			label.TextSize = 9
			label.FontFace = uipallet.Font
			label.Parent = children
			divider.BackgroundTransparency = 1
			--divider.Position = UDim2.fromOffset(0, 26)
			divider.Parent = label
		end
	end,
	Dropdown = function(props, children, api)
		local component = {
			Index = 0,
			Type = 'Dropdown',
			Value = props.List[1] or 'None'
		}
		
		local dropdown = Instance.new('TextButton')
		dropdown.AutoButtonColor = false
		dropdown.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
		dropdown.BorderSizePixel = 0
		dropdown.Size = UDim2.new(1, 0, 0, 40)
		dropdown.Text = ''
		dropdown.Visible = props.Visible == nil or props.Visible
		dropdown.Parent = children
		component.Object = dropdown
		local dropdownchildren
		addTooltip(dropdown, props.Tooltip or props.Name, nil, function()
			return dropdownchildren ~= nil
		end)
		local holder = Instance.new('Frame')
		holder.BackgroundColor3 = color.Light(uipallet.Main, 0.034)
		holder.Position = UDim2.fromOffset(10, 4)
		holder.Size = UDim2.new(1, -20, 1, -11)
		holder.Parent = dropdown
		addCorner(holder, UDim.new(0, 6))
		local button = Instance.new('TextButton')
		button.AutoButtonColor = false
		button.BackgroundColor3 = uipallet.Main
		button.Position = UDim2.fromOffset(1, 1)
		button.Size = UDim2.new(1, -2, 1, -2)
		button.Text = ''
		button.Parent = holder
		local title = Instance.new('TextLabel')
		title.BackgroundTransparency = 1
		title.FontFace = uipallet.Font
		title.Size = UDim2.new(1, 0, 0, 29)
		title.Text = '\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138'..props.Name..' - '..component.Value
		title.TextColor3 = color.Dark(uipallet.Text, 0.16)
		title.TextSize = 13
		title.TextTruncate = Enum.TextTruncate.AtEnd
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = button
		addCorner(button, UDim.new(0, 6))
		local arrow = Instance.new('ImageLabel')
		arrow.BackgroundTransparency = 1
		arrow.Image = getvapeasset('newvape/assets/new/expandarrow.png')
		arrow.ImageColor3 = Color3.fromRGB(140, 140, 140)
		arrow.Position = UDim2.new(1, -17, 0, 11)
		arrow.Rotation = 90
		arrow.Size = UDim2.fromOffset(4, 8)
		arrow.Parent = button
		props.Function = props.Function or function() end
		
		function component:Change(list)
			props.List = list or {}
			if not table.find(props.List, self.Value) then
				self:SetValue(self.Value)
			end
		end
		
		function component:Load(data)
			if self.Value ~= data.Value then
				self:SetValue(data.Value)
			end
		end
		
		function component:Save(data)
			data[props.Name] = {
				Value = self.Value
			}
		end
		
		function component:SetValue(value, isClick)
			self.Value = table.find(props.List, value) and value or props.List[1] or 'None'
			title.Text = '\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138'..props.Name..' - '..self.Value
		
			if dropdownchildren then
				arrow.Rotation = 90
				dropdownchildren:Destroy()
				dropdownchildren = nil
				dropdown.Size = UDim2.new(1, 0, 0, 40)
			end
		
			props.Function(self.Value, isClick)
			if vape and type(vape.ScheduleSave) == 'function' then
				vape:ScheduleSave()
			end
		end
		
		button.MouseButton1Click:Connect(function()
			if not dropdownchildren then
				tooltip.Visible = false
				arrow.Rotation = 270
				dropdown.Size = UDim2.new(1, 0, 0, 43 + (#props.List - 1) * 26)
				dropdownchildren = Instance.new('Frame')
				dropdownchildren.BackgroundTransparency = 1
				dropdownchildren.Position = UDim2.fromOffset(0, 27)
				dropdownchildren.Size = UDim2.new(1, 0, 0, (#props.List - 1) * 26)
				dropdownchildren.Parent = button
		
				local index = 0
				for _, v in props.List do
					if v == component.Value then continue end
					local entry = Instance.new('TextButton')
					entry.AutoButtonColor = false
					entry.BackgroundColor3 = uipallet.Main
					entry.BorderSizePixel = 0
					entry.FontFace = uipallet.Font
					entry.Position = UDim2.fromOffset(0, index * 26)
					entry.Size = UDim2.new(1, 0, 0, 26)
					entry.Text = '\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138'..v
					entry.TextColor3 = color.Dark(uipallet.Text, 0.16)
					entry.TextSize = 13
					entry.TextTruncate = Enum.TextTruncate.AtEnd
					entry.TextXAlignment = Enum.TextXAlignment.Left
					entry.Parent = dropdownchildren
		
					entry.MouseEnter:Connect(function()
						entry.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
						entry.TextColor3 = uipallet.Text
					end)
		
					entry.MouseLeave:Connect(function()
						entry.BackgroundColor3 = uipallet.Main
						entry.TextColor3 = color.Dark(uipallet.Text, 0.16)
					end)
		
					entry.MouseButton1Click:Connect(function()
						component:SetValue(v, true)
					end)
		
					index += 1
				end
			else
				component:SetValue(component.Value, true)
			end
		end)
		
		dropdown.MouseEnter:Connect(function()
			tween:Tween(holder, uipallet.Tween, {
				BackgroundColor3 = color.Light(uipallet.Main, 0.0875)
			})
		end)
		
		dropdown.MouseLeave:Connect(function()
			tween:Tween(holder, uipallet.Tween, {
				BackgroundColor3 = color.Light(uipallet.Main, 0.034)
			})
		end)
		
		api.Options[props.Name] = component
		
		return component
	end,
	Font = function(props, children, api)
		local fonts = {
			props.Default,
			'Custom'
		}
		
		for _, v in Enum.Font:GetEnumItems() do
			if not table.find(fonts, v.Name) then
				table.insert(fonts, v.Name)
			end
		end
		
		local component = {
			Value = Font.fromEnum(Enum.Font[fonts[1]])
		}
		local fontdropdown
		local fontbox
		props.Function = props.Function or function() end
		
		fontdropdown = components.Dropdown({
			Name = props.Name,
			List = fonts,
			Function = function(val)
				fontbox.Object.Visible = val == 'Custom' and fontdropdown.Object.Visible
				if val ~= 'Custom' then
					component.Value = Font.fromEnum(Enum.Font[val])
					props.Function(component.Value)
				else
					pcall(function()
						component.Value = Font.fromId(tonumber(fontbox.Value))
					end)
		
					props.Function(component.Value)
				end
			end,
			Darker = props.Darker,
			Visible = props.Visible
		}, children, api)
		component.Object = fontdropdown.Object
		
		fontbox = components.TextBox({
			Name = props.Name..' Asset',
			Placeholder = 'font (rbxasset)',
			Function = function()
				if fontdropdown.Value == 'Custom' then
					pcall(function()
						component.Value = Font.fromId(tonumber(fontbox.Value))
					end)
		
					props.Function(component.Value)
				end
			end,
			Visible = false,
			Darker = true
		}, children, api)
		
		fontdropdown.Object:GetPropertyChangedSignal('Visible'):Connect(function()
			fontbox.Object.Visible = fontdropdown.Object.Visible and fontdropdown.Value == 'Custom'
		end)
		
		return component
	end,
	GUI = function(props, children, api)
		local component = {
			Buttons = {},
			Type = 'MainWindow'
		}
		
		local window = Instance.new('TextButton')
		window.AutoButtonColor = false
		window.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
		window.Name = 'GUICategory'
		window.Position = UDim2.fromOffset(6, 60)
		window.Text = ''
		window.Parent = clickgui
		component.Object = window
		addBlur(window)
		addCorner(window)
		addDragHandler(window)
		local logo = Instance.new('ImageLabel')
		logo.BackgroundTransparency = 1
		logo.Image = getvapeasset('newvape/assets/new/vapelogomini.png')
		logo.ImageColor3 = select(3, uipallet.Main:ToHSV()) > 0.5 and uipallet.Text or Color3.new(1, 1, 1)
		logo.Name = 'VapeLogo'
		logo.Position = UDim2.fromOffset(12, 11)
		logo.Size = UDim2.fromOffset(55, 16)
		logo.Parent = window
		local v4logo = Instance.new('ImageLabel')
		v4logo.BackgroundTransparency = 1
		v4logo.Image = getvapeasset('newvape/assets/new/v4mini.png')
		v4logo.Name = 'V4Logo'
		v4logo.Position = UDim2.new(1, -1, 0, 0)
		v4logo.Size = UDim2.fromOffset(23, 16)
		v4logo.Parent = logo
		local children = Instance.new('Frame')
		children.BackgroundTransparency = 1
		children.Position = UDim2.fromOffset(0, 37)
		children.Size = UDim2.new(1, 0, 1, -33)
		children.Parent = window
		local windowlist = Instance.new('UIListLayout')
		windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
		windowlist.SortOrder = Enum.SortOrder.LayoutOrder
		windowlist.Parent = children
		local settingsbutton = Instance.new('TextButton')
		settingsbutton.BackgroundTransparency = 1
		settingsbutton.Position = UDim2.new(1, -40, 0, 0)
		settingsbutton.Size = UDim2.fromOffset(40, 40)
		settingsbutton.Text = ''
		settingsbutton.Parent = window
		addTooltip(settingsbutton, 'Open settings')
		local settingsicon = Instance.new('ImageLabel')
		settingsicon.BackgroundTransparency = 1
		settingsicon.Image = getvapeasset('newvape/assets/new/settings.png')
		settingsicon.ImageColor3 = color.Light(uipallet.Main, 0.37)
		settingsicon.Position = UDim2.fromOffset(15, 12)
		settingsicon.Size = UDim2.fromOffset(14, 14)
		settingsicon.Parent = settingsbutton
		local discord = Instance.new('ImageButton')
		discord.BackgroundTransparency = 1
		discord.Image = getvapeasset('newvape/assets/new/discord.png')
		discord.Position = UDim2.new(1, -56, 0, 11)
		discord.Size = UDim2.fromOffset(16, 16)
		discord.Parent = window
		addTooltip(discord, 'Join discord')
		local stroke = Instance.new('UIStroke')
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Color = Color3.fromRGB(85, 85, 85)
		stroke.Transparency = 0.8
		stroke.Parent = window
		local settingspane = components.SettingsPane({
			Name = 'Settings',
			Main = true
		}, window, component)
		component.Settings = settingspane
		
		function component:Color(hue, sat, val, isRainbow)
			v4logo.ImageColor3 = Color3.fromHSV(hue, sat, val)
		
			for _, button in self.Buttons do
				if button.Enabled then
					button.Object.TextColor3 = isRainbow and Color3.fromHSV(vape:Color((hue - (button.Index * 0.025)) % 1)) or Color3.fromHSV(hue, sat, val)
		
					if button.Icon then
						button.Icon.ImageColor3 = button.Object.TextColor3
					end
				end
			end
		end
		
		function component:Load(data)
			for name, paneData in data.Settings do
				local pane = vape.Settings[name]
				if pane then
					pane:Load(paneData)
				end
			end
		
			if data.Position then
				window.Position = UDim2.fromOffset(data.Position.X, data.Position.Y)
			end
		end
		
		function component:Save(data)
			data.Main = {
				Position = {
					X = window.Position.X.Offset,
					Y = window.Position.Y.Offset
				},
				Settings = {}
			}
		
			for name, pane in vape.Settings do
				pane:Save(data.Main.Settings)
			end
		end
		
		for index, comp in components do
			component['Create'..index] = function(_, props)
				return comp(props, children, component)
			end
		end
		
		discord.MouseButton1Click:Connect(function()
			task.spawn(function()
				local body = httpService:JSONEncode({
					nonce = httpService:GenerateGUID(false),
					args = {
						invite = {code = 'VZEQJxMSnG'},
						code = 'VZEQJxMSnG'
					},
					cmd = 'INVITE_BROWSER'
				})
		
				for i = 1, 14 do
					task.spawn(function()
						pcall(function()
							request({
								Method = 'POST',
								Url = 'http://127.0.0.1:64'..(53 + i)..'/rpc?v=1',
								Headers = {
									['Content-Type'] = 'application/json',
									Origin = 'https://discord.com'
								},
								Body = body
							})
						end)
					end)
				end
			end)
		
			task.spawn(function()
				tooltip.Text = 'Copied!'
				setclipboard('https://discord.gg/VZEQJxMSnG')
			end)
		end)
		
		settingsbutton.MouseEnter:Connect(function()
			settingsicon.ImageColor3 = uipallet.Text
		end)
		
		settingsbutton.MouseLeave:Connect(function()
			settingsicon.ImageColor3 = color.Light(uipallet.Main, 0.37)
		end)
		
		settingsbutton.MouseButton1Click:Connect(function()
			settingspane.Object.Visible = true
		end)
		
		windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			if vape.ThreadFix then
				setthreadidentity(8)
			end
		
			window.Size = UDim2.fromOffset(220, 42 + windowlist.AbsoluteContentSize.Y / scale.Scale)
			for _, button in component.Buttons do
				if button.Icon then
					button.Object.Text = string.rep('\226\128\138', 39 * scale.Scale)..button.Name
				end
			end
		end)
		
		vape.Categories.Main = component
		
		return component
	end,
	GUIButton = function(props, children, api)
		local component = {
			Enabled = false,
			Index = getTableSize(api.Buttons),
			Name = props.Name
		}
		
		local button = Instance.new('TextButton')
		button.AutoButtonColor = false
		button.BackgroundColor3 = uipallet.Main
		button.BorderSizePixel = 0
		button.FontFace = uipallet.Font
		button.Name = props.Name
		button.Size = UDim2.fromOffset(220, 40)
		button.Text = (props.Icon and string.rep('\226\128\138', 39) or props.Window and string.rep('\226\128\138', 17) or string.rep('\226\128\138', 10))..props.Name
		button.TextColor3 = color.Dark(uipallet.Text, 0.16)
		button.TextSize = 14
		button.TextXAlignment = Enum.TextXAlignment.Left
		button.Parent = children
		component.Object = button
		
		local icon
		if props.Icon then
			icon = Instance.new('ImageLabel')
			icon.BackgroundTransparency = 1
			icon.Image = props.Icon
			icon.ImageColor3 = color.Dark(uipallet.Text, 0.16)
			icon.Position = UDim2.fromOffset(16, 13)
			icon.Size = props.Size
			icon.Parent = button
			component.Icon = icon
		end
		
		if props.Name == 'Profiles' then
			local label = Instance.new('TextLabel')
			label.AnchorPoint = Vector2.new(1, 0)
			label.BackgroundColor3 = color.Light(uipallet.Main, 0.04)
			label.FontFace = uipallet.Font
			label.Position = UDim2.new(1, -36, 0, 8)
			label.Size = UDim2.fromOffset(53, 24)
			label.Text = 'default'
			label.TextColor3 = color.Dark(uipallet.Text, 0.29)
			label.TextSize = 12
			label.Parent = button
			addCorner(label)
			vape.ProfileLabel = label
		end
		
		local arrow = Instance.new('ImageLabel')
		arrow.BackgroundTransparency = 1
		arrow.Image = getvapeasset('newvape/assets/new/expandarrow.png')
		arrow.ImageColor3 = color.Light(uipallet.Main, 0.37)
		arrow.Name = 'Arrow'
		arrow.Position = UDim2.new(1, -20, 0, 16)
		arrow.Size = UDim2.fromOffset(4, 8)
		arrow.Parent = button
		
		function component:Destroy()
			button:Destroy()
			button:ClearAllChildren()
		end
		
		function component:Toggle()
			if props.Window then
				self.Enabled = not self.Enabled
				tween:Tween(arrow, uipallet.Tween, {
					Position = UDim2.new(1, self.Enabled and -14 or -20, 0, 16)
				})
		
				button.TextColor3 = self.Enabled and Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value) or uipallet.Text
				if icon then
					icon.ImageColor3 = button.TextColor3
				end
		
				button.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
				props.Window.Visible = self.Enabled
			else
				props.Function()
			end
		end
		
		button.MouseEnter:Connect(function()
			if not component.Enabled then
				button.TextColor3 = uipallet.Text
				if buttonicon then
					buttonicon.ImageColor3 = uipallet.Text
				end
		
				button.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
			end
		end)
		
		button.MouseLeave:Connect(function()
			if not component.Enabled then
				button.TextColor3 = color.Dark(uipallet.Text, 0.16)
				if buttonicon then
					buttonicon.ImageColor3 = color.Dark(uipallet.Text, 0.16)
				end
		
				button.BackgroundColor3 = uipallet.Main
			end
		end)
		
		button.MouseButton1Click:Connect(function()
			component:Toggle()
		end)
		
		api.Buttons[props.Name] = component
		
		return component
	end,
	GUISlider = function(props, children, api)
		local component = {
			CustomColor = false,
			Hue = 0.46,
			Notch = 4,
			Rainbow = false,
			Sat = 0.96,
			Type = 'GUISlider',
			Value = 0.52
		}
		local colors = {
			Color3.fromRGB(250, 50, 56),
			Color3.fromRGB(242, 99, 33),
			Color3.fromRGB(252, 179, 22),
			Color3.fromRGB(5, 133, 104),
			Color3.fromRGB(47, 122, 229),
			Color3.fromRGB(126, 84, 217),
			Color3.fromRGB(232, 96, 152)
		}
		local colorPositions = {
			4,
			33,
			62,
			90,
			119,
			148,
			177
		}
		
		local function createSlider(name, gradientColor)
			local slider = Instance.new('TextButton')
			slider.Name = props.Name..'Slider'..name
			slider.Size = UDim2.fromOffset(220, 50)
			slider.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
			slider.BorderSizePixel = 0
			slider.AutoButtonColor = false
			slider.Visible = false
			slider.Text = ''
			slider.Parent = children
			local title = Instance.new('TextLabel')
			title.BackgroundTransparency = 1
			title.FontFace = uipallet.Font
			title.Position = UDim2.fromOffset(10, 2)
			title.Size = UDim2.fromOffset(60, 30)
			title.Text = name
			title.TextColor3 = color.Dark(uipallet.Text, 0.16)
			title.TextSize = 11
			title.TextXAlignment = Enum.TextXAlignment.Left
			title.Parent = slider
			local holder = Instance.new('Frame')
			holder.BackgroundColor3 = Color3.new(1, 1, 1)
			holder.BorderSizePixel = 0
			holder.Name = 'Holder'
			holder.Position = UDim2.fromOffset(10, 37)
			holder.Size = UDim2.new(1, -20, 0, 2)
			holder.Parent = slider
			local uigradient = Instance.new('UIGradient')
			uigradient.Color = gradientColor
			uigradient.Parent = holder
			local fill = Instance.new('Frame')
			fill.BackgroundTransparency = 1
			fill.Name = 'Fill'
			fill.Size = UDim2.fromScale(math.clamp(1, 0.04, 0.96), 1)
			fill.Parent = holder
			local knobholder = Instance.new('Frame')
			knobholder.AnchorPoint = Vector2.new(0.5, 0.5)
			knobholder.BackgroundColor3 = slider.BackgroundColor3
			knobholder.BorderSizePixel = 0
			knobholder.Position = UDim2.fromScale(1, 0.5)
			knobholder.Size = UDim2.fromOffset(24, 4)
			knobholder.Parent = fill
			local knob = Instance.new('Frame')
			knob.AnchorPoint = Vector2.new(0.5, 0.5)
			knob.BackgroundColor3 = uipallet.Text
			knob.Position = UDim2.fromScale(0.5, 0.5)
			knob.Size = UDim2.fromOffset(14, 14)
			knob.Parent = knobholder
			addCorner(knob, UDim.new(1, 0))
		
			if name == 'Custom color' then
				local reset = Instance.new('TextButton')
				reset.BackgroundTransparency = 1
				reset.FontFace = uipallet.Font
				reset.Position = UDim2.new(1, -52, 0, 5)
				reset.Size = UDim2.fromOffset(45, 20)
				reset.Text = 'RESET'
				reset.TextColor3 = color.Dark(uipallet.Text, 0.16)
				reset.TextSize = 11
				reset.Parent = slider
		
				reset.MouseButton1Click:Connect(function()
					component:SetValue(nil, nil, nil, 4)
				end)
			end
		
			slider.InputBegan:Connect(function(input)
				if
					(input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
					and (input.Position.Y - slider.AbsolutePosition.Y) > (20 * scale.Scale)
				then
					local releaseConnection
					local moveConnection = inputService.InputChanged:Connect(function(newInput)
						if newInput.UserInputType == (input.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
							local value = math.clamp((newInput.Position.X - holder.AbsolutePosition.X) / holder.AbsoluteSize.X, 0, 1)
							component:SetValue(
								name == 'Custom color' and value or nil,
								name == 'Saturation' and value or nil,
								name == 'Vibrance' and value or nil,
								name == 'Opacity' and value or nil
							)
						end
					end)
		
					releaseConnection = input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							moveConnection:Disconnect()
							releaseConnection:Disconnect()
						end
					end)
				end
			end)
		
			slider.MouseEnter:Connect(function()
				tween:Tween(knob, uipallet.Tween, {
					Size = UDim2.fromOffset(16, 16)
				})
			end)
		
			slider.MouseLeave:Connect(function()
				tween:Tween(knob, uipallet.Tween, {
					Size = UDim2.fromOffset(14, 14)
				})
			end)
		
			return slider
		end
		
		local slider = Instance.new('TextButton')
		slider.AutoButtonColor = false
		slider.BackgroundTransparency = 1
		slider.Name = props.Name..'Slider'
		slider.Size = UDim2.fromOffset(220, 50)
		slider.Text = ''
		slider.Parent = children
		component.Object = slider
		local title = Instance.new('TextLabel')
		title.BackgroundTransparency = 1
		title.FontFace = uipallet.Font
		title.Name = 'Title'
		title.Position = UDim2.fromOffset(10, 2)
		title.Size = UDim2.fromOffset(60, 30)
		title.Text = props.Name
		title.TextColor3 = color.Dark(uipallet.Text, 0.16)
		title.TextSize = 11
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = slider
		local holder = Instance.new('Frame')
		holder.BackgroundTransparency = 1
		holder.BorderSizePixel = 0
		holder.Name = 'Slider'
		holder.Position = UDim2.fromOffset(10, 37)
		holder.Size = UDim2.fromOffset(200, 2)
		holder.Parent = slider
		local colorXPos = 0
		for index, colorValue in colors do
			local colorframe = Instance.new('Frame')
			colorframe.BackgroundColor3 = colorValue
			colorframe.BorderSizePixel = 0
			colorframe.Position = UDim2.fromOffset(colorXPos, 0)
			colorframe.Size = UDim2.fromOffset(27 + (((index + 1) % 2) == 0 and 1 or 0), 2)
			colorframe.Parent = holder
			colorXPos += (colorframe.Size.X.Offset + 1)
		end
		local preview = Instance.new('ImageButton')
		preview.BackgroundTransparency = 1
		preview.Image = getvapeasset('newvape/assets/new/colorpreview.png')
		preview.ImageColor3 = Color3.fromHSV(component.Hue, component.Sat, component.Value)
		preview.Position = UDim2.new(1, -22, 0, 10)
		preview.Size = UDim2.fromOffset(12, 12)
		preview.Parent = slider
		local custombox = Instance.new('TextBox')
		custombox.BackgroundTransparency = 1
		custombox.FontFace = uipallet.Font
		custombox.Position = UDim2.new(1, -69, 0, 9)
		custombox.Size = UDim2.fromOffset(60, 15)
		custombox.Text = ''
		custombox.TextColor3 = color.Dark(uipallet.Text, 0.16)
		custombox.TextSize = 11
		custombox.TextXAlignment = Enum.TextXAlignment.Right
		custombox.Visible = false
		custombox.Parent = slider
		local expand = Instance.new('TextButton')
		expand.BackgroundTransparency = 1
		expand.Position = UDim2.new(0, getfontbounds(title.Text, title.TextSize, title.Font).X + 11, 0, 7)
		expand.Size = UDim2.fromOffset(17, 13)
		expand.Text = ''
		expand.Parent = slider
		local icon = Instance.new('ImageLabel')
		icon.BackgroundTransparency = 1
		icon.Image = getvapeasset('newvape/assets/new/downexpandslider.png')
		icon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
		icon.Position = UDim2.fromOffset(4, 4)
		icon.Size = UDim2.fromOffset(10, 5)
		icon.Parent = expand
		local rainbow = Instance.new('TextButton')
		rainbow.BackgroundTransparency = 1
		rainbow.Position = UDim2.new(1, -42, 0, 10)
		rainbow.Size = UDim2.fromOffset(12, 12)
		rainbow.Text = ''
		rainbow.Parent = slider
		local ring1 = Instance.new('ImageLabel')
		ring1.BackgroundTransparency = 1
		ring1.Image = getvapeasset('newvape/assets/new/rainbow_1.png')
		ring1.ImageColor3 = color.Light(uipallet.Main, 0.37)
		ring1.Size = UDim2.fromOffset(12, 12)
		ring1.Parent = rainbow
		local ring2 = Instance.fromExisting(ring1)
		ring2.Image = getvapeasset('newvape/assets/new/rainbow_2.png')
		ring2.Parent = rainbow
		local ring3 = Instance.fromExisting(ring1)
		ring3.Image = getvapeasset('newvape/assets/new/rainbow_3.png')
		ring3.Parent = rainbow
		local ring4 = Instance.fromExisting(ring1)
		ring4.Image = getvapeasset('newvape/assets/new/rainbow_4.png')
		ring4.Parent = rainbow
		local knob = Instance.new('ImageLabel')
		knob.BackgroundTransparency = 1
		knob.Image = getvapeasset('newvape/assets/new/theme.png')
		knob.ImageColor3 = colors[4]
		knob.Name = 'Knob'
		knob.Position = UDim2.fromOffset(colorPositions[4] - 3, -5)
		knob.Size = UDim2.fromOffset(26, 12)
		knob.Parent = holder
		props.Function = props.Function or function() end
		local rainbowTable = {}
		for i = 0, 1, 0.1 do
			table.insert(rainbowTable, ColorSequenceKeypoint.new(i, Color3.fromHSV(i, 1, 1)))
		end
		
		local colorSlider = createSlider('Custom color', ColorSequence.new(rainbowTable))
		local satSlider = createSlider('Saturation', ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, component.Value)),
			ColorSequenceKeypoint.new(1, Color3.fromHSV(component.Hue, 1, component.Value))
		}))
		
		local vibSlider = createSlider('Vibrance', ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromHSV(component.Hue, component.Sat, 1))
		}))
		
		local normalknob = getvapeasset('newvape/assets/new/theme.png')
		local rainbowknob = getvapeasset('newvape/assets/new/customtheme.png')
		local rainbowthread
		local currentNotch
		
		function component:Load(data)
			if data.Rainbow then
				self:Toggle()
			end
		
			if self.Rainbow or data.CustomColor then
				self:SetValue(data.Hue, data.Sat, data.Value)
			else
				self:SetValue(nil, nil, nil, data.Notch)
			end
		end
		
		function component:Save(data)
			data[props.Name] = {
				Hue = self.Hue,
				Sat = self.Sat,
				Value = self.Value,
				Notch = self.Notch,
				CustomColor = self.CustomColor,
				Rainbow = self.Rainbow
			}
		end
		
		function component:SetValue(h, s, v, n)
			if n then
				if self.Rainbow then
					self:Toggle()
				end
		
				self.CustomColor = false
				h, s, v = colors[n]:ToHSV()
			else
				self.CustomColor = true
			end
		
			self.Hue = h or self.Hue
			self.Sat = s or self.Sat
			self.Value = v or self.Value
			self.Notch = n
			preview.ImageColor3 = Color3.fromHSV(self.Hue, self.Sat, self.Value)
		
			satSlider.Holder.UIGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, self.Value)),
				ColorSequenceKeypoint.new(1, Color3.fromHSV(self.Hue, 1, self.Value))
			})
		
			vibSlider.Holder.UIGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 0)),
				ColorSequenceKeypoint.new(1, Color3.fromHSV(self.Hue, self.Sat, 1))
			})
		
			local newNotch = (self.Rainbow or self.CustomColor) and 4 or n or currentNotch
			if self.Rainbow or self.CustomColor then
				knob.Image = rainbowknob
				knob.ImageColor3 = Color3.new(1, 1, 1)
		
				if newNotch ~= currentNotch then
					tween:Tween(knob, uipallet.Tween, {
						Position = UDim2.fromOffset(colorPositions[4] - 3, -5)
					})
				end
			else
				knob.Image = normalknob
				knob.ImageColor3 = Color3.fromHSV(self.Hue, self.Sat, self.Value)
		
				if newNotch ~= currentNotch then
					tween:Tween(knob, uipallet.Tween, {
						Position = UDim2.fromOffset(colorPositions[n or 4] - 3, -5)
					})
				end
			end
		
			currentNotch = newNotch
			if self.Rainbow then
				if h then
					colorSlider.Holder.Fill.Size = UDim2.fromScale(math.clamp(self.Hue, 0.04, 0.96), 1)
				end
		
				if s then
					satSlider.Holder.Fill.Size = UDim2.fromScale(math.clamp(self.Sat, 0.04, 0.96), 1)
				end
		
				if v then
					vibSlider.Holder.Fill.Size = UDim2.fromScale(math.clamp(self.Value, 0.04, 0.96), 1)
				end
			else
				if h then
					tween:Tween(colorSlider.Holder.Fill, uipallet.Tween, {
						Size = UDim2.fromScale(math.clamp(self.Hue, 0.04, 0.96), 1)
					})
				end
		
				if s then
					tween:Tween(satSlider.Holder.Fill, uipallet.Tween, {
						Size = UDim2.fromScale(math.clamp(self.Sat, 0.04, 0.96), 1)
					})
				end
		
				if v then
					tween:Tween(vibSlider.Holder.Fill, uipallet.Tween, {
						Size = UDim2.fromScale(math.clamp(self.Value, 0.04, 0.96), 1)
					})
				end
			end
		
			props.Function(self.Hue, self.Sat, self.Value)
		end
		
		function component:Toggle()
			self.Rainbow = not self.Rainbow
			if rainbowthread then
				task.cancel(rainbowthread)
			end
		
			if self.Rainbow then
				knob.Image = rainbowknob
				table.insert(vape.RainbowSliders, self)
		
				ring1.ImageColor3 = Color3.fromRGB(5, 127, 100)
				rainbowthread = task.delay(0.1, function()
					ring2.ImageColor3 = Color3.fromRGB(228, 125, 43)
					rainbowthread = task.delay(0.1, function()
						ring3.ImageColor3 = Color3.fromRGB(225, 46, 52)
						rainbowthread = nil
					end)
				end)
			else
				self:SetValue(nil, nil, nil, 4)
				knob.Image = normalknob
				local index = table.find(vape.RainbowSliders, self)
				if index then
					table.remove(vape.RainbowSliders, index)
				end
		
				ring3.ImageColor3 = color.Light(uipallet.Main, 0.37)
				rainbowthread = task.delay(0.1, function()
					ring2.ImageColor3 = color.Light(uipallet.Main, 0.37)
					rainbowthread = task.delay(0.1, function()
						ring1.ImageColor3 = color.Light(uipallet.Main, 0.37)
						rainbowthread = nil
					end)
				end)
			end
		end
		
		expand.MouseEnter:Connect(function()
			icon.ImageColor3 = color.Dark(uipallet.Text, 0.16)
		end)
		
		expand.MouseLeave:Connect(function()
			icon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
		end)
		
		expand.MouseButton1Click:Connect(function()
			colorSlider.Visible = not colorSlider.Visible
			satSlider.Visible = colorSlider.Visible
			vibSlider.Visible = satSlider.Visible
			icon.Rotation = satSlider.Visible and 180 or 0
		end)
		
		preview.MouseButton1Click:Connect(function()
			preview.Visible = false
			custombox.Visible = true
			custombox:CaptureFocus()
			local text = Color3.fromHSV(component.Hue, component.Sat, component.Value)
			custombox.Text = math.round(text.R * 255)..', '..math.round(text.G * 255)..', '..math.round(text.B * 255)
		end)
		
		slider.InputBegan:Connect(function(input)
			if
				(input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
				and (input.Position.Y - slider.AbsolutePosition.Y) > (20 * scale.Scale)
			then
				local releaseConnection
				local moveConnection = inputService.InputChanged:Connect(function(newInput)
					if newInput.UserInputType == (input.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
						component:SetValue(nil, nil, nil, math.clamp(math.round((newInput.Position.X - holder.AbsolutePosition.X) / scale.Scale / 27), 1, 7))
					end
				end)
		
				releaseConnection = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						moveConnection:Disconnect()
						releaseConnection:Disconnect()
					end
				end)
		
				component:SetValue(nil, nil, nil, math.clamp(math.round((input.Position.X - holder.AbsolutePosition.X) / scale.Scale / 27), 1, 7))
			end
		end)
		
		rainbow.MouseButton1Click:Connect(function()
			component:Toggle()
		end)
		
		custombox.FocusLost:Connect(function(enter)
			preview.Visible = true
			custombox.Visible = false
		
			if enter then
				local success, parsed = pcall(function()
					local commas = custombox.Text:split(',')
					return tonumber(commas[1]) and Color3.fromRGB(tonumber(commas[1]), tonumber(commas[2]), tonumber(commas[3])) or Color3.fromHex(custombox.Text)
				end)
		
				if success then
					if component.Rainbow then
						component:Toggle()
					end
		
					component:SetValue(parsed:ToHSV())
				end
			end
		end)
		
		api.Options[props.Name] = component
		
		return component
	end,
	ImageToggle = function(props, children, api)
		local component = {
			Enabled = false,
			Index = getTableSize(api.Options),
			Type = 'ImageToggle'
		}
		
		local isHover = false
		local toggle = Instance.new('TextButton')
		toggle.AutoButtonColor = false
		toggle.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
		toggle.BorderSizePixel = 0
		toggle.FontFace = uipallet.Font
		toggle.Size = UDim2.new(1, 0, 0, 40)
		toggle.Text = string.rep('\226\128\138', 33 * scale.Scale)..props.Name
		toggle.TextColor3 = color.Dark(uipallet.Text, 0.16)
		toggle.TextSize = 14
		toggle.TextXAlignment = Enum.TextXAlignment.Left
		toggle.Visible = props.Visible == nil or props.Visible
		toggle.Parent = children
		component.Object = toggle
		local icon = Instance.new('ImageLabel')
		icon.BackgroundTransparency = 1
		icon.Image = props.Icon
		icon.ImageColor3 = uipallet.Text
		icon.Name = 'Icon'
		icon.Position = props.Position
		icon.Size = props.Size
		icon.Parent = toggle
		local holder = Instance.new('Frame')
		holder.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
		holder.Name = 'Knob'
		holder.Position = UDim2.new(1, -30, 0, 14)
		holder.Size = UDim2.fromOffset(22, 12)
		holder.Parent = toggle
		addCorner(holder, UDim.new(1, 0))
		local knob = Instance.new('Frame')
		knob.BackgroundColor3 = uipallet.Main
		knob.Position = UDim2.fromOffset(2, 2)
		knob.Size = UDim2.fromOffset(8, 8)
		knob.Parent = holder
		addCorner(knob, UDim.new(1, 0))
		props.Function = props.Function or function() end
		
		function component:Color(hue, sat, val, isRainbow)
			if self.Enabled then
				tween:Cancel(holder)
				holder.BackgroundColor3 = isRainbow and Color3.fromHSV(vape:Color((hue - (self.Index * 0.075)) % 1)) or Color3.fromHSV(hue, sat, val)
			end
		end
		
		function component:Toggle()
			local isRainbow = vape.GUIColor.Rainbow and vape.RainbowMode.Value ~= 'Retro'
			self.Enabled = not self.Enabled
		
			tween:Tween(holder, uipallet.Tween, {
				BackgroundColor3 = self.Enabled and (isRainbow and Color3.fromHSV(vape:Color((vape.GUIColor.Hue - (self.Index * 0.075)) % 1)) or Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value)) or (isHover and color.Light(uipallet.Main, 0.37) or color.Light(uipallet.Main, 0.14))
			})
		
			tween:Tween(knob, uipallet.Tween, {
				Position = UDim2.fromOffset(self.Enabled and 12 or 2, 2)
			})
		
			props.Function(self.Enabled)
			if vape and type(vape.ScheduleSave) == 'function' then
				vape:ScheduleSave()
			end
		end
		
		scale:GetPropertyChangedSignal('Scale'):Connect(function()
			toggle.Text = string.rep('\226\128\138', 33 * scale.Scale)..props.Name
		end)
		
		toggle.MouseEnter:Connect(function()
			isHover = true
		
			if not component.Enabled then
				tween:Tween(holder, uipallet.Tween, {
					BackgroundColor3 = color.Light(uipallet.Main, 0.37)
				})
			end
		end)
		
		toggle.MouseLeave:Connect(function()
			isHover = false
		
			if not component.Enabled then
				tween:Tween(holder, uipallet.Tween, {
					BackgroundColor3 = color.Light(uipallet.Main, 0.14)
				})
			end
		end)
		
		toggle.MouseButton1Click:Connect(function()
			component:Toggle()
		end)
		
		if props.Default then
			component:Toggle()
		end
		
		api.Options[props.Name] = component
		
		return component
	end,
	LegitModule = function(props, children, api)
		vape:Remove(props.Name)
		local component = {
			Enabled = false,
			Legit = true,
			Name = props.Name,
			Options = {},
			Type = 'LegitModule'
		}
		
		local button = Instance.new('TextButton')
		button.AutoButtonColor = false
		button.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
		button.Name = props.Name
		button.Text = ''
		button.Parent = children
		component.Object = button
		addTooltip(button, props.Tooltip, nil, function()
			return vape.LegitVisible
		end)
		addCorner(button)
		local title = Instance.new('TextLabel')
		title.BackgroundTransparency = 1
		title.FontFace = uipallet.Font
		title.Position = UDim2.fromOffset(16, 81)
		title.Size = UDim2.new(1, -16, 0, 20)
		title.Text = props.Name
		title.TextColor3 = color.Dark(uipallet.Text, 0.31)
		title.TextSize = 13
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = button
		local holder = Instance.new('Frame')
		holder.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
		holder.Position = UDim2.new(1, -57, 0, 15)
		holder.Size = UDim2.fromOffset(22, 12)
		holder.Parent = button
		addCorner(holder, UDim.new(1, 0))
		local knob = Instance.new('Frame')
		knob.BackgroundColor3 = uipallet.Main
		knob.Position = UDim2.fromOffset(2, 2)
		knob.Size = UDim2.fromOffset(8, 8)
		knob.Parent = holder
		addCorner(knob, UDim.new(1, 0))
		local dotsbutton = Instance.new('TextButton')
		dotsbutton.BackgroundTransparency = 1
		dotsbutton.Name = 'Dots'
		dotsbutton.Position = UDim2.new(1, -27, 0, 9)
		dotsbutton.Size = UDim2.fromOffset(14, 24)
		dotsbutton.Text = ''
		dotsbutton.Parent = button
		local dots = Instance.new('ImageLabel')
		dots.BackgroundTransparency = 1
		dots.Image = getvapeasset('newvape/assets/new/overlaydots.png')
		dots.ImageColor3 = color.Light(uipallet.Main, 0.37)
		dots.Name = 'Dots'
		dots.Position = UDim2.fromOffset(6, 6)
		dots.Size = UDim2.fromOffset(2, 12)
		dots.Parent = dotsbutton
		local shadow = Instance.new('TextButton')
		shadow.Name = 'Shadow'
		shadow.Size = UDim2.new(1, 0, 1, -5)
		shadow.BackgroundColor3 = Color3.new()
		shadow.BackgroundTransparency = 1
		shadow.AutoButtonColor = false
		shadow.ClipsDescendants = true
		shadow.Visible = false
		shadow.Text = ''
		shadow.Parent = api.Window
		addCorner(shadow)
		local settingspane = Instance.new('TextButton')
		settingspane.Size = UDim2.new(0, 220, 1, 0)
		settingspane.Position = UDim2.fromScale(1, 0)
		settingspane.BackgroundColor3 = uipallet.Main
		settingspane.AutoButtonColor = false
		settingspane.Text = ''
		settingspane.Parent = shadow
		local settingstitle = Instance.new('TextLabel')
		settingstitle.Name = 'Title'
		settingstitle.Size = UDim2.new(1, -36, 0, 20)
		settingstitle.Position = UDim2.fromOffset(36, 12)
		settingstitle.BackgroundTransparency = 1
		settingstitle.Text = props.Name
		settingstitle.TextXAlignment = Enum.TextXAlignment.Left
		settingstitle.TextColor3 = color.Dark(uipallet.Text, 0.16)
		settingstitle.TextSize = 13
		settingstitle.FontFace = uipallet.Font
		settingstitle.Parent = settingspane
		local back = Instance.new('ImageButton')
		back.Name = 'Back'
		back.Size = UDim2.fromOffset(16, 16)
		back.Position = UDim2.fromOffset(11, 13)
		back.BackgroundTransparency = 1
		back.Image = getvapeasset('newvape/assets/new/back.png')
		back.ImageColor3 = color.Light(uipallet.Main, 0.37)
		back.Parent = settingspane
		addCorner(settingspane)
		local settingschildren = Instance.new('ScrollingFrame')
		settingschildren.BackgroundColor3 = uipallet.Main
		settingschildren.BorderSizePixel = 0
		settingschildren.CanvasSize = UDim2.new()
		settingschildren.Name = 'Children'
		settingschildren.Position = UDim2.fromOffset(0, 41)
		settingschildren.ScrollBarThickness = 2
		settingschildren.ScrollBarImageTransparency = 0.75
		settingschildren.Size = UDim2.new(1, 0, 1, -45)
		settingschildren.Parent = settingspane
		local windowlist = Instance.new('UIListLayout')
		windowlist.SortOrder = Enum.SortOrder.LayoutOrder
		windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
		windowlist.Parent = settingschildren
		if props.Size then
			local modulechildren = Instance.new('Frame')
			modulechildren.Size = props.Size
			modulechildren.BackgroundTransparency = 1
			modulechildren.Visible = false
			modulechildren.Parent = scaledgui
			addDragHandler(modulechildren, api.Window)
			local objectstroke = Instance.new('UIStroke')
			objectstroke.Color = Color3.fromRGB(5, 134, 105)
			objectstroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			objectstroke.Thickness = 0
			objectstroke.Parent = modulechildren
			component.Children = modulechildren
		end
		props.Function = props.Function or function() end
		addMaid(component)
		
		function component:Color(hue, sat, val, isRainbow)
			if self.Enabled then
				tween:Cancel(holder)
				holder.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
			end
		
			for _, component in self.Options do
				if component.Color then
					component:Color(hue, sat, val, isRainbow)
				end
			end
		end
		
		function component:Load(data)
			vape:LoadOptions(self, data.Options)
		
			if self.Enabled ~= data.Enabled then
				self:Toggle()
			end
		
			if data.Position and self.Children then
				self.Children.Position = UDim2.fromOffset(data.Position.X, data.Position.Y)
			end
		end
		
		function component:Save(data)
			data[props.Name] = {
				Enabled = self.Enabled,
				Options = vape:SaveOptions(self),
				Position = self.Children and {
					X = self.Children.Position.X.Offset,
					Y = self.Children.Position.Y.Offset
				} or nil
			}
		end
		
		function component:Toggle()
			self.Enabled = not self.Enabled
			if self.Children then
				self.Children.Visible = self.Enabled
			end
		
			title.TextColor3 = self.Enabled and color.Light(uipallet.Text, 0.2) or color.Dark(uipallet.Text, 0.31)
			button.BackgroundColor3 = self.Enabled and color.Light(uipallet.Main, 0.05) or button.BackgroundColor3
		
			tween:Tween(holder, uipallet.Tween, {
				BackgroundColor3 = self.Enabled and Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value) or color.Light(uipallet.Main, 0.14)
			})
		
			tween:Tween(knob, uipallet.Tween, {
				Position = UDim2.fromOffset(self.Enabled and 12 or 2, 2)
			})
		
			if not self.Enabled then
				for _, v in self.Connections do
					v:Disconnect()
				end
				table.clear(self.Connections)
			end
		
			task.spawn(props.Function, self.Enabled)
			if vape and type(vape.ScheduleSave) == 'function' then
				vape:ScheduleSave()
			end
		end
		
		for index, comp in components do
			component['Create'..index] = function(_, props)
				return comp(props, settingschildren, component)
			end
		end
		
		back.MouseEnter:Connect(function()
			back.ImageColor3 = uipallet.Text
		end)
		
		back.MouseLeave:Connect(function()
			back.ImageColor3 = color.Light(uipallet.Main, 0.37)
		end)
		
		back.MouseButton1Click:Connect(function()
			tween:Tween(shadow, uipallet.Tween, {
				BackgroundTransparency = 1
			})
		
			tween:Tween(settingspane, uipallet.Tween, {
				Position = UDim2.fromScale(1, 0)
			})
		
			task.delay(0.2, function()
				shadow.Visible = false
			end)
		end)
		
		button.MouseEnter:Connect(function()
			if not component.Enabled then
				button.BackgroundColor3 = color.Light(uipallet.Main, 0.05)
			end
		end)
		
		button.MouseLeave:Connect(function()
			if not component.Enabled then
				button.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
			end
		end)
		
		button.MouseButton1Click:Connect(function()
			component:Toggle()
		end)
		
		button.MouseButton2Click:Connect(function()
			shadow.Visible = true
		
			tween:Tween(shadow, uipallet.Tween, {
				BackgroundTransparency = 0.5
			})
		
			tween:Tween(settingspane, uipallet.Tween, {
				Position = UDim2.new(1, -220, 0, 0)
			})
		end)
		
		dotsbutton.MouseButton1Click:Connect(function()
			shadow.Visible = true
		
			tween:Tween(shadow, uipallet.Tween, {
				BackgroundTransparency = 0.5
			})
		
			tween:Tween(settingspane, uipallet.Tween, {
				Position = UDim2.new(1, -220, 0, 0)
			})
		end)
		
		dotsbutton.MouseEnter:Connect(function()
			dots.ImageColor3 = uipallet.Text
		end)
		
		dotsbutton.MouseLeave:Connect(function()
			dots.ImageColor3 = color.Light(uipallet.Main, 0.37)
		end)
		
		shadow.MouseButton1Click:Connect(function()
			tween:Tween(shadow, uipallet.Tween, {
				BackgroundTransparency = 1
			})
		
			tween:Tween(settingspane, uipallet.Tween, {
				Position = UDim2.fromScale(1, 0)
			})
		
			task.delay(0.2, function()
				shadow.Visible = false
			end)
		end)
		
		shadow:GetPropertyChangedSignal('Visible'):Connect(function()
			tooltip.Visible = false
			vape.LegitVisible = shadow.Visible
		end)
		
		windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			if vape.ThreadFix then
				setthreadidentity(8)
			end
		
			settingschildren.CanvasSize = UDim2.fromOffset(0, windowlist.AbsoluteContentSize.Y / scale.Scale)
		end)
		
		api.Modules[props.Name] = component
		
		local sorting = {}
		for _, mod in api.Modules do
			table.insert(sorting, mod.Name)
		end
		table.sort(sorting)
		
		for index, name in sorting do
			api.Modules[name].Object.LayoutOrder = index
		end
		
		return component
	end,
	LegitWindow = function(props, children, api)
		local component = {
			Modules = {}
		}
		
		local window = Instance.new('Frame')
		window.BackgroundColor3 = uipallet.Main
		window.Position = UDim2.new(0.5, -350, 0.5, -190)
		window.Size = UDim2.fromOffset(700, 380)
		window.Name = 'LegitGUI'
		window.Visible = false
		window.Parent = scaledgui
		table.insert(vape.Windows, window)
		component.Window = window
		addBlur(window)
		addCorner(window)
		addDragHandler(window)
		local modal = Instance.new('TextButton')
		modal.BackgroundTransparency = 1
		modal.Modal = true
		modal.Text = ''
		modal.Parent = window
		local icon = Instance.new('ImageLabel')
		icon.BackgroundTransparency = 1
		icon.Image = getvapeasset('newvape/assets/new/legit_mode_icon.png')
		icon.ImageColor3 = uipallet.Text
		icon.Position = UDim2.fromOffset(18, 11)
		icon.Size = UDim2.fromOffset(16, 16)
		icon.Parent = window
		local close = Instance.new('ImageButton')
		close.BackgroundTransparency = 1
		close.Image = getvapeasset('newvape/assets/new/min.png')
		close.ImageColor3 = color.Light(uipallet.Main, 0.24)
		close.Position = UDim2.new(1, -31, 0, 11)
		close.Size = UDim2.fromOffset(16, 16)
		close.Parent = window
		local holder = Instance.new('Frame')
		holder.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
		holder.Position = UDim2.new(1, -253, 0, 42)
		holder.Size = UDim2.fromOffset(242, 29)
		holder.Parent = window
		addCorner(holder, UDim.new(0, 4))
		local stroke = Instance.new('UIStroke')
		stroke.Color = color.Light(uipallet.Main, 0.02)
		stroke.Parent = holder
		local searchicon = Instance.new('ImageLabel')
		searchicon.BackgroundTransparency = 1
		searchicon.Image = getvapeasset('newvape/assets/new/search.png')
		searchicon.ImageColor3 = color.Light(uipallet.Main, 0.42)
		searchicon.Position = UDim2.new(1, -25, 0, 9)
		searchicon.Size = UDim2.fromOffset(12, 12)
		searchicon.Parent = holder
		local box = Instance.new('TextBox')
		box.BackgroundTransparency = 1
		box.ClearTextOnFocus = false
		box.FontFace = uipallet.Font
		box.PlaceholderColor3 = color.Dark(uipallet.Text, 0.16)
		box.PlaceholderText = 'Search mods'
		box.Position = UDim2.fromOffset(8, 0)
		box.Size = UDim2.new(1, -8, 1, 0)
		box.Text = ''
		box.TextColor3 = color.Dark(uipallet.Text, 0.16)
		box.TextSize = 14
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.Parent = holder
		local children = Instance.new('ScrollingFrame')
		children.BackgroundTransparency = 1
		children.BorderSizePixel = 0
		children.CanvasSize = UDim2.new()
		children.Position = UDim2.fromOffset(14, 76)
		children.ScrollBarThickness = 2
		children.ScrollBarImageTransparency = 0.75
		children.Size = UDim2.fromOffset(684, 301)
		children.Parent = window
		local windowlist = Instance.new('UIGridLayout')
		windowlist.CellSize = UDim2.fromOffset(163, 114)
		windowlist.CellPadding = UDim2.fromOffset(6, 6)
		windowlist.FillDirectionMaxCells = 4
		windowlist.SortOrder = Enum.SortOrder.LayoutOrder
		windowlist.Parent = children
		
		for index, comp in components do
			component['Create'..index] = function(_, props)
				return comp(props, children, component)
			end
		end
		
		function component:CreateModule(props)
			return components.LegitModule(props, children, component)
		end
		
		local function visibleCheck()
			for _, module in component.Modules do
				if module.Children then
					local visible = clickgui.Visible
					--[[for _, v2 in self.Windows do
						visible = visible or v2.Visible
					end]]
		
					module.Children.Visible = (not visible or window.Visible) and module.Enabled
				end
			end
		end
		
		box:GetPropertyChangedSignal('Text'):Connect(function()
			for name, module in component.Modules do
				module.Object.Visible = (box.Text == '' or name:lower():find(box.Text:lower())) and true or false
			end
		end)
		
		close.MouseButton1Click:Connect(function()
			window.Visible = false
			clickgui.Visible = true
		end)
		
		close.MouseEnter:Connect(function()
			close.ImageColor3 = color.Light(uipallet.Main, 0.37)
		end)
		
		close.MouseLeave:Connect(function()
			close.ImageColor3 = color.Light(uipallet.Main, 0.24)
		end)
		
		vape:Clean(clickgui:GetPropertyChangedSignal('Visible'):Connect(visibleCheck))
		
		holder.MouseEnter:Connect(function()
			tween:Tween(stroke, uipallet.Tween, {
				Color = color.Light(uipallet.Main, 0.0875)
			})
		end)
		
		holder.MouseLeave:Connect(function()
			tween:Tween(stroke, uipallet.Tween, {
				Color = color.Light(uipallet.Main, 0.02)
			})
		end)
		
		window:GetPropertyChangedSignal('Visible'):Connect(function()
			vape:UpdateGUI()
			visibleCheck()
		end)
		
		windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			if vape.ThreadFix then
				setthreadidentity(8)
			end
		
			children.CanvasSize = UDim2.fromOffset(0, windowlist.AbsoluteContentSize.Y / scale.Scale)
		end)
		
		vape.Legit = component
		
		return component
	end,
	Module = function(props, children, api)
		vape:Remove(props.Name)
		local component = {
			Category = api.Name,
			Enabled = false,
			ExtraText = props.ExtraText,
			Index = getTableSize(vape.Modules),
			Name = props.Name,
			Options = {},
			Visible = true
		}
		
		local isHover = false
		local button = Instance.new('TextButton')
		button.AutoButtonColor = false
		button.BackgroundColor3 = uipallet.Main
		button.BorderSizePixel = 0
		button.FontFace = uipallet.Font
		button.Name = props.Name
		button.Size = UDim2.fromOffset(220, 40)
		button.Text = string.rep('\226\128\138', 12)..props.Name
		button.TextColor3 = color.Dark(uipallet.Text, 0.16)
		button.TextSize = 14
		button.TextXAlignment = Enum.TextXAlignment.Left
		button.Parent = children
		component.Object = button
		addTooltip(button, props.Tooltip)
		local gradient = Instance.new('UIGradient')
		gradient.Enabled = false
		gradient.Rotation = 90
		gradient.Parent = button
		local modulechildren = Instance.new('Frame')
		modulechildren.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
		modulechildren.BorderSizePixel = 0
		modulechildren.Name = props.Name..'Children'
		modulechildren.Size = UDim2.new(1, 0, 0, 0)
		modulechildren.Visible = false
		modulechildren.Parent = children
		local windowlist = Instance.new('UIListLayout')
		windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
		windowlist.SortOrder = Enum.SortOrder.LayoutOrder
		windowlist.Parent = modulechildren
		local dotsbutton = Instance.new('TextButton')
		dotsbutton.BackgroundTransparency = 1
		dotsbutton.Name = 'Dots'
		dotsbutton.Position = UDim2.new(1, -25, 0, 0)
		dotsbutton.Size = UDim2.fromOffset(25, 40)
		dotsbutton.Text = ''
		dotsbutton.Parent = button
		local dots = Instance.new('ImageLabel')
		dots.BackgroundTransparency = 1
		dots.Image = getvapeasset('newvape/assets/new/settingdots.png')
		dots.ImageColor3 = color.Light(uipallet.Main, 0.37)
		dots.Name = 'Dots'
		dots.Position = UDim2.fromOffset(4, 12)
		dots.Size = UDim2.fromOffset(3, 16)
		dots.Parent = dotsbutton
		local divider = Instance.new('Frame')
		divider.BackgroundColor3 = Color3.new(0.19, 0.19, 0.19)
		divider.BackgroundTransparency = 0.52
		divider.BorderSizePixel = 0
		divider.Name = 'Divider'
		divider.Position = UDim2.new(0, 0, 1, -1)
		divider.Size = UDim2.new(1, 0, 0, 1)
		divider.Visible = false
		divider.Parent = button
		local edit = Instance.new('TextButton')
		edit.AutoButtonColor = false
		edit.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
		edit.BorderSizePixel = 0
		edit.Size = UDim2.fromOffset(40, 40)
		edit.Text = ''
		edit.Visible = false
		edit.Parent = button
		local editbox = Instance.new('Frame')
		editbox.BorderSizePixel = 0
		editbox.Position = UDim2.fromOffset(16, 16)
		editbox.Size = UDim2.fromOffset(8, 8)
		editbox.Parent = edit
		local editborder = Instance.new('UIStroke')
		editborder.BorderOffset = UDim.new(0, 1)
		editborder.LineJoinMode = Enum.LineJoinMode.Miter
		editborder.Parent = editbox
		props.Function = props.Function or function() end
		component.Edit = edit
		component.Children = modulechildren
		addMaid(component)
		
		function component:Color(hue, sat, val, isRainbow)
			if self.Enabled then
				button.BackgroundColor3 = isRainbow and Color3.fromHSV(vape:Color((hue - (self.Index * 0.025)) % 1)) or Color3.fromHSV(hue, sat, val)
				button.TextColor3 = vape.GUIColor.Rainbow and Color3.new(0.19, 0.19, 0.19) or vape:TextColor(hue, sat, val)
				button.UIGradient.Enabled = isRainbow and vape.RainbowMode.Value == 'Gradient'
		
				if button.UIGradient.Enabled then
					button.BackgroundColor3 = Color3.new(1, 1, 1)
					button.UIGradient.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromHSV(vape:Color((hue - (self.Index * 0.025)) % 1))),
						ColorSequenceKeypoint.new(1, Color3.fromHSV(vape:Color((hue - ((self.Index + 1) * 0.025)) % 1)))
					})
				end
		
				self.Bind:SetColor(self.Object.TextColor3)
				dots.ImageColor3 = self.Object.TextColor3
			end
		
			if self.Visible then
				editbox.BackgroundColor3 = isRainbow and Color3.fromHSV(vape:Color((hue - (self.Index * 0.025)) % 1)) or Color3.fromHSV(hue, sat, val)
				editborder.Color = editbox.BackgroundColor3
			end
		
			for _, component in self.Options do
				if component.Color then
					component:Color(hue, sat, val, isRainbow)
				end
			end
		end
		
		function component:Destroy()
			self.Bind:Destroy()
		
			for _, option in self.Options do
				if option.Type == 'Bind' then
					option:Destroy()
				end
			end
		end
		
		function component:Load(data)
			vape:LoadOptions(self, data.Options)
			self.Bind:Load(data.Bind)
		
			if self.Enabled ~= (data.Enabled and not self.Bind.Hold) then
				self:Toggle(true)
		
				if self.Bind.Mobile then
					self.Bind.Mobile.BackgroundColor3 = self.Enabled and Color3.new(0, 0.7, 0) or Color3.new()
				end
			end
		
			if self.Visible ~= data.Visible then
				self:SetVisible(data.Visible, true)
			end
		end
		
		function component:Save(data)
			data[props.Name] = {
				Enabled = self.Enabled,
				Options = vape:SaveOptions(self),
				Visible = self.Visible
			}
		
			self.Bind:Save(data[props.Name])
		end
		
		function component:SetVisible(isVisible, isLoad)
			self.Visible = isVisible
			editbox.BackgroundTransparency = isVisible and 0 or 1
			editborder.Color = isVisible and editbox.BackgroundColor3 or color.Light(uipallet.Main, 0.37)
		
			if isLoad and not vape.EditGUI then
				button.Visible = isVisible
			end
			if not isLoad and vape and type(vape.ScheduleSave) == 'function' then
				vape:ScheduleSave()
			end
		end
		
		function component:Toggle(multiple)
			if vape.ThreadFix then
				setthreadidentity(8)
			end
		
			self.Enabled = not self.Enabled
			divider.Visible = self.Enabled
			gradient.Enabled = self.Enabled
			button.TextColor3 = (isHover or modulechildren.Visible) and uipallet.Text or color.Dark(uipallet.Text, 0.16)
			button.BackgroundColor3 = (isHover or modulechildren.Visible) and color.Light(uipallet.Main, 0.02) or uipallet.Main
			dots.ImageColor3 = self.Enabled and Color3.fromRGB(50, 50, 50) or color.Light(uipallet.Main, 0.37)
			component.Bind:SetColor(color.Dark(uipallet.Text, 0.43))
		
			if not self.Enabled then
				for _, v in self.Connections do
					v:Disconnect()
				end
				table.clear(self.Connections)
			end
		
			if multiple then
				if not vape.TextGUIThread then
					vape.TextGUIThread = task.defer(function()
						if vape.Loaded ~= nil then
							vape:UpdateTextGUI()
						end
		
						vape.TextGUIThread = nil
					end)
				end
			else
				vape:UpdateTextGUI()
			end
		
			task.spawn(props.Function, self.Enabled)
			if vape and type(vape.ScheduleSave) == 'function' then
				vape:ScheduleSave()
			end
		end
		
		for index, comp in components do
			component['Create'..index] = function(_, props)
				return comp(props, modulechildren, component)
			end
		end
		
		button.MouseEnter:Connect(function()
			isHover = true
			if not component.Enabled and not modulechildren.Visible then
				button.TextColor3 = uipallet.Text
				button.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
			end
		
			component.Bind:SetVisible(isHover or modulechildren.Visible)
		end)
		
		button.MouseLeave:Connect(function()
			isHover = false
			if not component.Enabled and not modulechildren.Visible then
				button.TextColor3 = color.Dark(uipallet.Text, 0.16)
				button.BackgroundColor3 = uipallet.Main
			end
		
			component.Bind:SetVisible(isHover or modulechildren.Visible)
		end)
		
		button.MouseButton1Click:Connect(function()
			if vape.EditGUI then
				return
			end
		
			component:Toggle()
		end)
		
		button.MouseButton2Click:Connect(function()
			modulechildren.Visible = not modulechildren.Visible
		end)
		
		dotsbutton.MouseButton1Click:Connect(function()
			modulechildren.Visible = not modulechildren.Visible
		end)
		
		dotsbutton.MouseButton2Click:Connect(function()
			modulechildren.Visible = not modulechildren.Visible
		end)
		
		dotsbutton.MouseEnter:Connect(function()
			if not component.Enabled then
				dots.ImageColor3 = uipallet.Text
			end
		end)
		
		dotsbutton.MouseLeave:Connect(function()
			if not component.Enabled then
				dots.ImageColor3 = color.Light(uipallet.Main, 0.37)
			end
		end)
		
		edit.MouseButton1Click:Connect(function()
			component:SetVisible(not component.Visible)
		end)
		
		windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			if vape.ThreadFix then
				setthreadidentity(8)
			end
		
			modulechildren.Size = UDim2.new(1, 0, 0, windowlist.AbsoluteContentSize.Y / scale.Scale)
		end)
		
		local bind = component:CreateBind({
			Module = true,
			Cover = true
		})
		
		bind.Triggered:Connect(function(isDown)
			if bind.Hold then
				if component.Enabled ~= isDown then
					if vape.ToggleNotifications.Enabled then
						vape:CreateNotification(props.Name, (not component.Enabled and "<font color='#00AA00'>Enabled</font>" or "<font color='#FF5A5A'>Disabled</font>"), 1.5)
					end
		
					component:Toggle(true)
				end
			else
				if vape.ToggleNotifications.Enabled then
					vape:CreateNotification(props.Name, (not component.Enabled and "<font color='#00AA00'>Enabled</font>" or "<font color='#FF5A5A'>Disabled</font>"), 1.5)
				end
		
				component:Toggle(true)
			end
		end)
		
		if inputService.TouchEnabled then
			local isHeld = false
		
			button.MouseButton1Down:Connect(function()
				isHeld = true
				local holdtime, holdPos = os.clock(), inputService:GetMouseLocation()
				repeat
					isHeld = (inputService:GetMouseLocation() - holdPos).Magnitude < 3
					task.wait()
				until (os.clock() - holdtime) > 1 or not isHeld or not clickgui.Visible
		
				if isHeld and clickgui.Visible then
					if vape.ThreadFix then
						setthreadidentity(8)
					end
		
					clickgui.Visible = false
					tooltip.Visible = false
					vape:BlurCheck()
					for _, module in vape.Modules do
						if module.Bind.Mobile then
							module.Bind.Mobile.Visible = true
						end
					end
		
					local connection
					connection = inputService.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.Touch then
							if vape.ThreadFix then
								setthreadidentity(8)
							end
		
							bind:CreateMobileButton(input.Position + Vector3.new(0, guiService:GetGuiInset().Y, 0))
							clickgui.Visible = true
							vape:BlurCheck()
		
							for _, module in vape.Modules do
								if module.Bind.Mobile then
									module.Bind.Mobile.Visible = false
								end
							end
		
							connection:Disconnect()
						end
					end)
				end
			end)
		
			button.MouseButton1Up:Connect(function()
				isHeld = false
			end)
		end
		
		vape.Modules[props.Name] = component
		vape:SortCategories()
		
		return component
	end,
	Overlay = function(props, children, api)
		local window
		local component
		component = {
			Button = vape.Overlays:CreateImageToggle({
				Name = props.Name,
				Function = function(callback)
					window.Visible = callback and (clickgui.Visible or component.Pinned)
		
					if not callback then
						for _, v in component.Connections do
							v:Disconnect()
						end
						table.clear(component.Connections)
					end
		
					if props.Function then
						task.spawn(props.Function, callback)
					end
				end,
				Icon = props.Icon,
				Size = props.Size,
				Position = props.Position
			}),
			Expanded = false,
			Pinned = false,
			Options = {},
			Type = 'Overlay'
		}
		
		window = Instance.new('TextButton')
		window.AutoButtonColor = false
		window.BackgroundColor3 = uipallet.Main
		window.Name = props.Name..'Overlay'
		window.Position = UDim2.fromOffset(240, 46)
		window.Size = UDim2.fromOffset(props.CategorySize or 220, 41)
		window.Text = ''
		window.Visible = false
		window.Parent = scaledgui
		component.Object = window
		local blur = addBlur(window)
		addCorner(window)
		addDragHandler(window)
		local icon = Instance.new('ImageLabel')
		icon.BackgroundTransparency = 1
		icon.Image = props.Icon
		icon.ImageColor3 = uipallet.Text
		icon.Position = UDim2.fromOffset(12, (icon.Size.X.Offset > 14 and 14 or 13))
		icon.Size = props.Size
		icon.Parent = window
		local title = Instance.new('TextLabel')
		title.BackgroundTransparency = 1
		title.FontFace = uipallet.Font
		title.Size = UDim2.new(1, -32, 0, 41)
		title.Position = UDim2.fromOffset(math.abs(title.Size.X.Offset), 0)
		title.Text = props.Name
		title.TextColor3 = uipallet.Text
		title.TextSize = 13
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = window
		local pin = Instance.new('ImageButton')
		pin.Name = 'Pin'
		pin.Size = UDim2.fromOffset(14, 14)
		pin.Position = UDim2.new(1, -37, 0, 14)
		pin.BackgroundTransparency = 1
		pin.AutoButtonColor = false
		pin.Image = getvapeasset('newvape/assets/new/pin.png')
		pin.ImageColor3 = color.Dark(uipallet.Text, 0.43)
		pin.Parent = window
		local dotsbutton = Instance.new('TextButton')
		dotsbutton.Name = 'Dots'
		dotsbutton.Size = UDim2.fromOffset(17, 40)
		dotsbutton.Position = UDim2.new(1, -17, 0, 0)
		dotsbutton.BackgroundTransparency = 1
		dotsbutton.Text = ''
		dotsbutton.Parent = window
		local dots = Instance.new('ImageLabel')
		dots.BackgroundTransparency = 1
		dots.Image = getvapeasset('newvape/assets/new/overlaydots.png')
		dots.ImageColor3 = color.Light(uipallet.Main, 0.37)
		dots.Position = UDim2.fromOffset(5, 15)
		dots.Size = UDim2.fromOffset(2, 12)
		dots.Parent = dotsbutton
		local customchildren = Instance.new('Frame')
		customchildren.BackgroundTransparency = 1
		customchildren.Position = UDim2.fromScale(0, 1)
		customchildren.Size = UDim2.new(1, 0, 0, 200)
		customchildren.Parent = window
		local children = Instance.new('ScrollingFrame')
		children.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
		children.BorderSizePixel = 0
		children.CanvasSize = UDim2.new()
		children.Position = UDim2.fromOffset(0, 37)
		children.Size = UDim2.new(1, 0, 1, -41)
		children.ScrollBarThickness = 2
		children.ScrollBarImageTransparency = 0.75
		children.Visible = false
		children.Parent = window
		local stroke = Instance.new('UIStroke')
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Color = Color3.fromRGB(85, 85, 85)
		stroke.Transparency = 0.8
		stroke.Parent = window
		local windowlist = Instance.new('UIListLayout')
		windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
		windowlist.SortOrder = Enum.SortOrder.LayoutOrder
		windowlist.Parent = children
		addMaid(component)
		
		function component:Color(hue, sat, val, isRainbow)
			for _, component in self.Options do
				if component.Color then
					component:Color(hue, sat, val, isRainbow)
				end
			end
		end
		
		function component:Expand(visCheck)
			if visCheck and not blur.Enabled then return end
		
			self.Expanded = not self.Expanded
			children.Visible = self.Expanded
			dots.ImageColor3 = self.Expanded and uipallet.Text or color.Light(uipallet.Main, 0.37)
		
			if self.Expanded then
				window.Size = UDim2.fromOffset(window.Size.X.Offset, math.min(41 + windowlist.AbsoluteContentSize.Y / scale.Scale, 601))
			else
				window.Size = UDim2.fromOffset(window.Size.X.Offset, 41)
			end
		end
		
		function component:Load(data)
			vape:LoadOptions(self, data.Options)
		
			if self.Button.Enabled ~= data.Enabled then
				self.Button:Toggle()
			end
		
			if self.Pinned ~= data.Pinned then
				self:Pin()
				self:Update()
			end
		
			if data.Position then
				window.Position = UDim2.fromOffset(data.Position.X, data.Position.Y)
			end
		end
		
		function component:Pin()
			self.Pinned = not self.Pinned
			pin.ImageColor3 = self.Pinned and uipallet.Text or color.Dark(uipallet.Text, 0.43)
			if vape and type(vape.ScheduleSave) == 'function' then
				vape:ScheduleSave()
			end
		end
		
		function component:Save(data)
			data[props.Name] = {
				Enabled = self.Button.Enabled,
				Options = vape:SaveOptions(self),
				Pinned = self.Pinned,
				Position = {
					X = window.Position.X.Offset,
					Y = window.Position.Y.Offset
				}
			}
		end
		
		function component:Update()
			window.Visible = self.Button.Enabled and (clickgui.Visible or self.Pinned)
			if self.Expanded then
				self:Expand()
			end
		
			if clickgui.Visible then
				window.Size = UDim2.fromOffset(window.Size.X.Offset, 41)
				window.BackgroundTransparency = 0
				blur.Enabled = true
				stroke.Enabled = true
				icon.Visible = true
				title.Visible = true
				pin.Visible = true
				dotsbutton.Visible = true
			else
				window.Size = UDim2.fromOffset(window.Size.X.Offset, 0)
				window.BackgroundTransparency = 1
				blur.Enabled = false
				stroke.Enabled = false
				icon.Visible = false
				title.Visible = false
				pin.Visible = false
				dotsbutton.Visible = false
			end
		end
		
		for index, comp in components do
			component['Create'..index] = function(_, props)
				return comp(props, children, component)
			end
		end
		
		vape:Clean(clickgui:GetPropertyChangedSignal('Visible'):Connect(function()
			component:Update()
		end))
		
		dotsbutton.MouseEnter:Connect(function()
			if not children.Visible then
				dots.ImageColor3 = uipallet.Text
			end
		end)
		
		dotsbutton.MouseLeave:Connect(function()
			if not children.Visible then
				dots.ImageColor3 = color.Light(uipallet.Main, 0.37)
			end
		end)
		
		dotsbutton.MouseButton1Click:Connect(function()
			component:Expand(true)
		end)
		
		dotsbutton.MouseButton2Click:Connect(function()
			component:Expand(true)
		end)
		
		pin.MouseButton1Click:Connect(function()
			component:Pin()
		end)
		
		window.MouseButton2Click:Connect(function()
			component:Expand(true)
		end)
		
		windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			if vape.ThreadFix then
				setthreadidentity(8)
			end
		
			children.CanvasSize = UDim2.fromOffset(0, windowlist.AbsoluteContentSize.Y / scale.Scale)
			if component.Expanded then
				window.Size = UDim2.fromOffset(window.Size.X.Offset, math.min(41 + windowlist.AbsoluteContentSize.Y / scale.Scale, 601))
			end
		end)
		
		component.Children = customchildren
		vape.Categories[props.Name] = component
		
		return component
	end,
	OverlayBar = function(props, children, api)
		local component = {
			Options = {},
			Type = 'OverlayBar'
		}
		
		local bar = Instance.new('Frame')
		bar.Name = 'Overlays'
		bar.Size = UDim2.fromOffset(220, 36)
		bar.BackgroundColor3 = uipallet.Main
		bar.BorderSizePixel = 0
		bar.Parent = children
		components.Divider(nil, bar)
		local button = Instance.new('ImageButton')
		button.AutoButtonColor = false
		button.BackgroundTransparency = 1
		button.Image = getvapeasset('newvape/assets/new/overlays.png')
		button.ImageColor3 = color.Light(uipallet.Main, 0.37)
		button.Position = UDim2.new(1, -34, 0, 7)
		button.Size = UDim2.fromOffset(24, 24)
		button.Parent = bar
		addCorner(button, UDim.new(1, 0))
		addTooltip(button, 'Open overlays menu')
		local shadow = Instance.new('TextButton')
		shadow.AutoButtonColor = false
		shadow.BackgroundColor3 = Color3.new()
		shadow.BackgroundTransparency = 1
		shadow.ClipsDescendants = true
		shadow.Name = 'Shadow'
		shadow.Size = UDim2.new(1, 0, 1, -5)
		shadow.Text = ''
		shadow.Visible = false
		shadow.Parent = api.Object
		addCorner(shadow)
		local window = Instance.new('Frame')
		window.BackgroundColor3 = uipallet.Main
		window.Position = UDim2.fromScale(0, 1)
		window.Size = UDim2.fromOffset(220, 42)
		window.Parent = shadow
		addCorner(window)
		local icon = Instance.new('ImageLabel')
		icon.BackgroundTransparency = 1
		icon.Image = getvapeasset('newvape/assets/new/overlayslarge.png')
		icon.ImageColor3 = uipallet.Text
		icon.Position = UDim2.fromOffset(10, 13)
		icon.Size = UDim2.fromOffset(14, 12)
		icon.Parent = window
		local title = Instance.new('TextLabel')
		title.BackgroundTransparency = 1
		title.FontFace = uipallet.Font
		title.Position = UDim2.fromOffset(36, 0)
		title.Size = UDim2.new(1, -36, 0, 38)
		title.Text = 'Overlays'
		title.TextColor3 = uipallet.Text
		title.TextSize = 15
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = window
		local close = addCloseButton(window, false, UDim2.new(1, -35, 0, 7))
		local divider = Instance.new('Frame')
		divider.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
		divider.BorderSizePixel = 0
		divider.Position = UDim2.fromOffset(0, 37)
		divider.Size = UDim2.new(1, 0, 0, 1)
		divider.Parent = window
		local childrentoggle = Instance.new('Frame')
		childrentoggle.BackgroundColor3 = uipallet.Main
		childrentoggle.BackgroundTransparency = 1
		childrentoggle.Position = UDim2.fromOffset(0, 38)
		childrentoggle.Parent = window
		local windowlist = Instance.new('UIListLayout')
		windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
		windowlist.SortOrder = Enum.SortOrder.LayoutOrder
		windowlist.Parent = childrentoggle
		
		for index, comp in components do
			component['Create'..index] = function(_, props)
				return comp(props, childrentoggle, component)
			end
		end
		
		button.MouseEnter:Connect(function()
			button.ImageColor3 = uipallet.Text
			tween:Tween(button, uipallet.Tween, {
				BackgroundTransparency = 0.9
			})
		end)
		
		button.MouseLeave:Connect(function()
			button.ImageColor3 = color.Light(uipallet.Main, 0.37)
			tween:Tween(button, uipallet.Tween, {
				BackgroundTransparency = 1
			})
		end)
		
		button.MouseButton1Click:Connect(function()
			shadow.Visible = true
			tween:Tween(shadow, uipallet.Tween, {
				BackgroundTransparency = 0.5
			})
		
			tween:Tween(window, uipallet.Tween, {
				Position = UDim2.new(0, 0, 1, -(window.Size.Y.Offset))
			})
		end)
		
		close.MouseButton1Click:Connect(function()
			tween:Tween(shadow, uipallet.Tween, {
				BackgroundTransparency = 1
			})
		
			tween:Tween(window, uipallet.Tween, {
				Position = UDim2.fromScale(0, 1)
			})
		
			task.delay(0.2, function()
				shadow.Visible = false
			end)
		end)
		
		shadow.MouseButton1Click:Connect(function()
			tween:Tween(shadow, uipallet.Tween, {
				BackgroundTransparency = 1
			})
		
			tween:Tween(window, uipallet.Tween, {
				Position = UDim2.fromScale(0, 1)
			})
		
			task.delay(0.2, function()
				shadow.Visible = false
			end)
		end)
		
		windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			if vape.ThreadFix then
				setthreadidentity(8)
			end
		
			window.Size = UDim2.fromOffset(220, math.min(37 + windowlist.AbsoluteContentSize.Y / scale.Scale, 605))
			childrentoggle.Size = UDim2.fromOffset(220, window.Size.Y.Offset - 5)
		end)
		
		vape.Overlays = component
		
		return component
	end,
	SearchBar = function(props, children, api)
		local component = {
			Type = 'SearchBar'
		}
		
		local function listenProperty(src, dest, prop, obj)
			dest[prop] = src[prop]
			local connection = src:GetPropertyChangedSignal(prop):Connect(function()
				dest[prop] = src[prop]
			end)
		
			obj.Destroying:Once(function()
				connection:Disconnect()
			end)
		end
		
		local search = Instance.new('Frame')
		search.AnchorPoint = Vector2.new(0.5, 0)
		search.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
		search.Name = 'Search'
		search.Position = UDim2.new(0.5, 0, 0, 13)
		search.Size = UDim2.fromOffset(220, 37)
		search.Parent = clickgui
		component.Object = search
		addBlur(search)
		addCorner(search)
		local icon = Instance.new('ImageLabel')
		icon.BackgroundTransparency = 1
		icon.Image = getvapeasset('newvape/assets/new/search.png')
		icon.ImageColor3 = color.Light(uipallet.Main, 0.37)
		icon.Position = UDim2.new(1, -25, 0, 11)
		icon.Size = UDim2.fromOffset(14, 14)
		icon.Parent = search
		local legiticon = Instance.new('ImageButton')
		legiticon.BackgroundTransparency = 1
		legiticon.Image = getvapeasset('newvape/assets/new/legit_switch.png')
		legiticon.Name = 'Legit'
		legiticon.Position = UDim2.fromOffset(8, 11)
		legiticon.Size = UDim2.fromOffset(29, 16)
		legiticon.Parent = search
		listenProperty(vape.Categories.Main.Object.VapeLogo.V4Logo, legiticon, 'ImageColor3', legiticon)
		local legitdivider = Instance.new('Frame')
		legitdivider.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
		legitdivider.BorderSizePixel = 0
		legitdivider.Name = 'LegitDivider'
		legitdivider.Position = UDim2.fromOffset(43, 13)
		legitdivider.Size = UDim2.fromOffset(2, 12)
		legitdivider.Parent = search
		local box = Instance.new('TextBox')
		box.BackgroundTransparency = 1
		box.ClearTextOnFocus = false
		box.FontFace = uipallet.Font
		box.PlaceholderText = ''
		box.Position = UDim2.fromOffset(50, 0)
		box.Size = UDim2.new(1, -50, 0, 37)
		box.Text = ''
		box.TextColor3 = uipallet.Text
		box.TextSize = 12
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.Parent = search
		local children = Instance.new('ScrollingFrame')
		children.BackgroundTransparency = 1
		children.BorderSizePixel = 0
		children.CanvasSize = UDim2.new()
		children.Position = UDim2.fromOffset(0, 34)
		children.ScrollBarThickness = 2
		children.ScrollBarImageTransparency = 0.75
		children.Size = UDim2.new(1, 0, 1, -37)
		children.Parent = search
		local divider = Instance.new('Frame')
		divider.BackgroundColor3 = Color3.new(1, 1, 1)
		divider.BackgroundTransparency = 0.928
		divider.BorderSizePixel = 0
		divider.Position = UDim2.fromOffset(0, 33)
		divider.Size = UDim2.new(1, 0, 0, 1)
		divider.Visible = false
		divider.Parent = search
		local stroke = Instance.new('UIStroke')
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Color = Color3.fromRGB(85, 85, 85)
		stroke.Transparency = 0.8
		stroke.Parent = search
		local windowlist = Instance.new('UIListLayout')
		windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
		windowlist.SortOrder = Enum.SortOrder.LayoutOrder
		windowlist.Parent = children
		
		box:GetPropertyChangedSignal('Text'):Connect(function()
			for _, obj in children:GetChildren() do
				if obj:IsA('TextButton') then
					obj:Destroy()
				end
			end
		
			if box.Text == '' then return end
		
			for name, module in vape.Modules do
				if name:lower():find(box.Text:lower()) then
					local button = module.Object:Clone()
					button.Bind:Destroy()
		
					button.MouseButton1Click:Connect(function()
						module:Toggle()
					end)
		
					button.MouseButton2Click:Connect(function()
						module.Object.Parent.Parent.Visible = true
						local frame = module.Object.Parent
						local highlight = Instance.new('Frame')
						highlight.Size = UDim2.fromScale(1, 1)
						highlight.BackgroundColor3 = Color3.new(1, 1, 1)
						highlight.BackgroundTransparency = 0.6
						highlight.BorderSizePixel = 0
						highlight.Parent = module.Object
		
						tween:Tween(highlight, TweenInfo.new(0.5), {
							BackgroundTransparency = 1
						})
						task.delay(0.5, highlight.Destroy, highlight)
						frame.CanvasPosition = Vector2.new(0, (module.Object.LayoutOrder * 40) - (math.min(frame.CanvasSize.Y.Offset, 600) / 2))
					end)
		
					for _, prop in {'Text', 'TextColor3', 'BackgroundColor3'} do
						listenProperty(module.Object, button, prop, button)
					end
		
					listenProperty(module.Object.UIGradient, button.UIGradient, 'Color', button)
					listenProperty(module.Object.UIGradient, button.UIGradient, 'Enabled', button)
					listenProperty(module.Object.Dots.Dots, button.Dots.Dots, 'ImageColor3', button)
		
					button.Parent = children
				end
			end
		end)
		
		children:GetPropertyChangedSignal('CanvasPosition'):Connect(function()
			divider.Visible = children.CanvasPosition.Y > 10 and children.Visible
		end)
		
		legiticon.MouseButton1Click:Connect(function()
			clickgui.Visible = false
			vape.Legit.Window.Visible = true
			vape.Legit.Window.Position = UDim2.new(0.5, -350, 0.5, -194)
		end)
		
		windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			if vape.ThreadFix then
				setthreadidentity(8)
			end
		
			children.CanvasSize = UDim2.fromOffset(0, windowlist.AbsoluteContentSize.Y / scale.Scale)
			search.Size = UDim2.fromOffset(220, math.min(37 + windowlist.AbsoluteContentSize.Y / scale.Scale, 437))
		end)
		
		return component
	end,
	SettingsPane = function(props, children, api)
		local component = {
			Buttons = {},
			Options = {},
			Parent = api.Parent or children,
			Type = 'SettingsPane'
		}
		
		local pane = Instance.new('TextButton')
		pane.AutoButtonColor = false
		pane.BackgroundColor3 = props.Main and color.Dark(uipallet.Main, 0.02) or uipallet.Main
		pane.Size = UDim2.fromScale(1, 1)
		pane.Text = ''
		pane.Visible = false
		pane.Parent = component.Parent
		local title = Instance.new('TextLabel')
		title.BackgroundTransparency = 1
		title.FontFace = uipallet.Font
		title.Name = 'Title'
		title.Size = UDim2.new(1, -36, 0, 20)
		title.Position = UDim2.fromOffset(math.abs(title.Size.X.Offset), 11)
		title.Text = props.Name
		title.TextColor3 = uipallet.Text
		title.TextSize = 13
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = pane
		local close = addCloseButton(pane, true)
		local back = Instance.new('ImageButton')
		back.BackgroundTransparency = 1
		back.Image = getvapeasset('newvape/assets/new/backmini.png')
		back.ImageColor3 = color.Light(uipallet.Main, 0.37)
		back.Position = UDim2.fromOffset(12, 14)
		back.Size = UDim2.fromOffset(14, 14)
		back.Parent = pane
		addCorner(pane)
		local settingschildren = Instance.new('Frame')
		settingschildren.BackgroundColor3 = uipallet.Main
		settingschildren.BorderSizePixel = 0
		settingschildren.Name = 'Children'
		settingschildren.Position = UDim2.fromOffset(0, 41)
		settingschildren.Size = UDim2.new(1, 0, 1, -57)
		settingschildren.Parent = pane
		local divider = Instance.new('Frame')
		divider.BackgroundColor3 = Color3.new(1, 1, 1)
		divider.BackgroundTransparency = 0.928
		divider.BorderSizePixel = 0
		divider.Name = 'Divider'
		divider.Size = UDim2.new(1, 0, 0, 1)
		divider.Parent = settingschildren
		local listlayout = Instance.new('UIListLayout')
		listlayout.SortOrder = Enum.SortOrder.LayoutOrder
		listlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		listlayout.Parent = settingschildren
		if props.Main then
			local versionlabel = Instance.new('TextLabel')
			versionlabel.BackgroundTransparency = 1
			versionlabel.FontFace = uipallet.Font
			versionlabel.Name = 'Version'
			versionlabel.Position = UDim2.new(0, 0, 1, -16)
			versionlabel.Size = UDim2.new(1, 0, 0, 16)
			versionlabel.Text = 'Vape '..vape.Version..' '..(
				isfile('newvape/profiles/commit.txt') and readfile('newvape/profiles/commit.txt'):sub(1, 6) or ''
			)..' '
			versionlabel.TextColor3 = color.Dark(uipallet.Text, 0.43)
			versionlabel.TextSize = 10
			versionlabel.TextXAlignment = Enum.TextXAlignment.Right
			versionlabel.Parent = pane
		else
			api:CreateGUIButton({
				Name = props.Name,
				Function = function()
					pane.Visible = true
				end
			})
		end
		
		function component:Load(data)
			vape:LoadOptions(self, data)
		end
		
		function component:Save(data)
			data[props.Name] = vape:SaveOptions(self)
		end
		
		for index, comp in components do
			component['Create'..index] = function(_, props)
				return comp(props, settingschildren, component)
			end
		end
		
		back.MouseEnter:Connect(function()
			back.ImageColor3 = uipallet.Text
		end)
		
		back.MouseLeave:Connect(function()
			back.ImageColor3 = color.Light(uipallet.Main, 0.37)
		end)
		
		back.MouseButton1Click:Connect(function()
			pane.Visible = false
		end)
		
		close.MouseButton1Click:Connect(function()
			pane.Visible = false
		end)
		
		listlayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			if vape.ThreadFix then
				setthreadidentity(8)
			end
		
			pane.Size = UDim2.new(1, 0, 0, math.max(45 + listlayout.AbsoluteContentSize.Y, component.Parent.AbsoluteSize.Y) / scale.Scale)
		end)
		
		component.Object = pane
		vape.Settings[props.Name] = component
		
		return component
	end,
	Slider = function(props, children, api)
		local component = {
			Index = getTableSize(api.Options),
			Max = props.Max,
			Type = 'Slider',
			Value = props.Default or props.Min,
		}
		
		local slider = Instance.new('TextButton')
		slider.AutoButtonColor = false
		slider.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
		slider.BorderSizePixel = 0
		slider.Size = UDim2.new(1, 0, 0, 50)
		slider.Text = ''
		slider.Visible = props.Visible == nil or props.Visible
		slider.Parent = children
		component.Object = slider
		addTooltip(slider, props.Tooltip)
		local title = Instance.new('TextLabel')
		title.BackgroundTransparency = 1
		title.FontFace = uipallet.Font
		title.Position = UDim2.fromOffset(10, 2)
		title.Size = UDim2.fromOffset(60, 30)
		title.Text = props.Name
		title.TextColor3 = color.Dark(uipallet.Text, 0.16)
		title.TextSize = 11
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = slider
		local valuelabel = Instance.new('TextButton')
		valuelabel.BackgroundTransparency = 1
		valuelabel.FontFace = uipallet.Font
		valuelabel.Position = UDim2.new(1, -69, 0, 9)
		valuelabel.Size = UDim2.fromOffset(60, 15)
		valuelabel.Text = component.Value..(props.Suffix and ' '..(type(props.Suffix) == 'function' and props.Suffix(component.Value) or props.Suffix) or '')
		valuelabel.TextColor3 = color.Dark(uipallet.Text, 0.16)
		valuelabel.TextSize = 11
		valuelabel.TextXAlignment = Enum.TextXAlignment.Right
		valuelabel.Parent = slider
		local custombox = Instance.new('TextBox')
		custombox.BackgroundTransparency = 1
		custombox.ClearTextOnFocus = false
		custombox.FontFace = uipallet.Font
		custombox.Position = valuelabel.Position
		custombox.Size = valuelabel.Size
		custombox.Text = component.Value
		custombox.TextColor3 = color.Dark(uipallet.Text, 0.16)
		custombox.TextSize = 11
		custombox.TextXAlignment = Enum.TextXAlignment.Right
		custombox.Visible = false
		custombox.Parent = slider
		local holder = Instance.new('Frame')
		holder.BackgroundColor3 = color.Light(uipallet.Main, 0.034)
		holder.BorderSizePixel = 0
		holder.Position = UDim2.fromOffset(10, 37)
		holder.Size = UDim2.new(1, -20, 0, 2)
		holder.Parent = slider
		local fill = Instance.new('Frame')
		fill.BackgroundColor3 = Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value)
		fill.BorderSizePixel = 0
		fill.Size = UDim2.fromScale(math.clamp((component.Value - props.Min) / (props.Max - props.Min), 0.04, 0.96), 1)
		fill.Parent = holder
		local knobholder = Instance.new('Frame')
		knobholder.AnchorPoint = Vector2.new(0.5, 0.5)
		knobholder.BackgroundColor3 = slider.BackgroundColor3
		knobholder.BorderSizePixel = 0
		knobholder.Position = UDim2.fromScale(1, 0.5)
		knobholder.Size = UDim2.fromOffset(24, 4)
		knobholder.Parent = fill
		local knob = Instance.new('Frame')
		knob.AnchorPoint = Vector2.new(0.5, 0.5)
		knob.BackgroundColor3 = Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value)
		knob.Position = UDim2.fromScale(0.5, 0.5)
		knob.Size = UDim2.fromOffset(14, 14)
		knob.Parent = knobholder
		addCorner(knob, UDim.new(1, 0))
		props.Function = props.Function or function() end
		props.Decimal = props.Decimal or 1
		
		function component:Color(hue, sat, val, isRainbow)
			fill.BackgroundColor3 = isRainbow and Color3.fromHSV(vape:Color((hue - (self.Index * 0.075)) % 1)) or Color3.fromHSV(hue, sat, val)
			knob.BackgroundColor3 = fill.BackgroundColor3
		end
		
		function component:Load(data)
			local newValue = data.Value == data.Max and data.Max ~= self.Max and self.Max or data.Value
			if self.Value ~= newValue then
				self:SetValue(newValue, nil, true)
			end
		end
		
		function component:Save(data)
			data[props.Name] = {
				Value = self.Value,
				Max = self.Max
			}
		end
		
		function component:SetValue(value, position, wasReleased)
			if not math.isfinite(value) then
				return
			end
		
			tween:Tween(fill, uipallet.Tween, {
				Size = UDim2.fromScale(math.clamp(position or math.clamp((value - props.Min) / (props.Max - props.Min), 0, 1), 0.04, 0.96), 1)
			})
		
			if self.Value ~= value or wasReleased then
				self.Value = value
				valuelabel.Text = self.Value..(props.Suffix and ' '..(type(props.Suffix) == 'function' and props.Suffix(self.Value) or props.Suffix) or '')
				props.Function(value, wasReleased)
				if vape and type(vape.ScheduleSave) == 'function' then
					vape:ScheduleSave()
				end
			end
		end
		
		slider.InputBegan:Connect(function(input)
			if
				(input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
				and (input.Position.Y - slider.AbsolutePosition.Y) > (20 * scale.Scale)
			then
				local newPosition = math.clamp((input.Position.X - holder.AbsolutePosition.X) / holder.AbsoluteSize.X, 0, 1)
				local lastPosition = newPosition
		
				local releaseConnection
				local moveConnection = inputService.InputChanged:Connect(function(newInput)
					if newInput.UserInputType == (input.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
						local newPosition = math.clamp((newInput.Position.X - holder.AbsolutePosition.X) / holder.AbsoluteSize.X, 0, 1)
						component:SetValue(math.floor((props.Min + (props.Max - props.Min) * newPosition) * props.Decimal) / props.Decimal, newPosition)
						lastPosition = newPosition
					end
				end)
		
				releaseConnection = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						moveConnection:Disconnect()
						releaseConnection:Disconnect()
						component:SetValue(component.Value, lastPosition, true)
					end
				end)
		
				component:SetValue(math.floor((props.Min + (props.Max - props.Min) * newPosition) * props.Decimal) / props.Decimal, newPosition)
			end
		end)
		
		slider.MouseEnter:Connect(function()
			tween:Tween(knob, uipallet.Tween, {
				Size = UDim2.fromOffset(16, 16)
			})
		end)
		
		slider.MouseLeave:Connect(function()
			tween:Tween(knob, uipallet.Tween, {
				Size = UDim2.fromOffset(14, 14)
			})
		end)
		
		valuelabel.MouseButton1Click:Connect(function()
			valuelabel.Visible = false
			custombox.Visible = true
			custombox.Text = component.Value
			custombox:CaptureFocus()
		end)
		
		custombox.FocusLost:Connect(function(enter)
			valuelabel.Visible = true
			custombox.Visible = false
		
			if enter and tonumber(custombox.Text) then
				component:SetValue(tonumber(custombox.Text), nil, true)
			end
		end)
		
		api.Options[props.Name] = component
		
		return component
	end,
	Targets = function(props, children, api)
		local component = {
			Index = getTableSize(api.Options),
			Type = 'Targets'
		}
		
		local targets = Instance.new('TextButton')
		targets.AutoButtonColor = false
		targets.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
		targets.BorderSizePixel = 0
		targets.Size = UDim2.new(1, 0, 0, 50)
		targets.Text = ''
		targets.Visible = props.Visible == nil or props.Visible
		targets.Parent = children
		component.Object = targets
		addTooltip(targets, props.Tooltip)
		local holder = Instance.new('Frame')
		holder.BackgroundColor3 = color.Light(uipallet.Main, 0.034)
		holder.Position = UDim2.fromOffset(10, 4)
		holder.Size = UDim2.new(1, -20, 1, -9)
		holder.Parent = targets
		addCorner(holder, UDim.new(0, 4))
		local button = Instance.new('TextButton')
		button.AutoButtonColor = false
		button.BackgroundColor3 = uipallet.Main
		button.Position = UDim2.fromOffset(1, 1)
		button.Size = UDim2.new(1, -2, 1, -2)
		button.Text = ''
		button.Parent = holder
		local title = Instance.new('TextLabel')
		title.BackgroundTransparency = 1
		title.FontFace = uipallet.Font
		title.Position = UDim2.fromOffset(5, 6)
		title.Size = UDim2.new(1, -5, 0, 15)
		title.Text = 'Target:'
		title.TextColor3 = color.Dark(uipallet.Text, 0.16)
		title.TextSize = 15
		title.TextTruncate = Enum.TextTruncate.AtEnd
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = button
		local items = Instance.new('TextLabel')
		items.BackgroundTransparency = 1
		items.FontFace = uipallet.Font
		items.Position = UDim2.fromOffset(5, 21)
		items.Size = UDim2.new(1, -5, 0, 15)
		items.Text = 'Ignore none'
		items.TextColor3 = color.Dark(uipallet.Text, 0.16)
		items.TextSize = 11
		items.TextTruncate = Enum.TextTruncate.AtEnd
		items.TextXAlignment = Enum.TextXAlignment.Left
		items.Parent = button
		addCorner(button, UDim.new(0, 4))
		local iconholder = Instance.new('Frame')
		iconholder.BackgroundTransparency = 1
		iconholder.Position = UDim2.fromOffset(52, 8)
		iconholder.Size = UDim2.fromOffset(65, 12)
		iconholder.Parent = button
		local layout = Instance.new('UIListLayout')
		layout.FillDirection = Enum.FillDirection.Horizontal
		layout.Padding = UDim.new(0, 6)
		layout.Parent = iconholder
		local targetswindow = Instance.new('TextButton')
		targetswindow.AutoButtonColor = false
		targetswindow.BackgroundColor3 = uipallet.Main
		targetswindow.BorderSizePixel = 0
		targetswindow.Position = UDim2.fromOffset(456, 139)
		targetswindow.Size = UDim2.fromOffset(220, 145)
		targetswindow.Text = ''
		targetswindow.Visible = false
		targetswindow.Parent = clickgui
		component.Window = targetswindow
		addBlur(targetswindow)
		addCorner(targetswindow)
		local icon = Instance.new('ImageLabel')
		icon.BackgroundTransparency = 1
		icon.Image = getvapeasset('newvape/assets/new/aim.png')
		icon.Position = UDim2.fromOffset(10, 15)
		icon.Size = UDim2.fromOffset(18, 12)
		icon.Parent = targetswindow
		local windowtitle = Instance.new('TextLabel')
		windowtitle.BackgroundTransparency = 1
		windowtitle.FontFace = uipallet.Font
		windowtitle.Size = UDim2.new(1, -36, 0, 20)
		windowtitle.Position = UDim2.fromOffset(math.abs(windowtitle.Size.X.Offset), 11)
		windowtitle.Text = 'Target settings'
		windowtitle.TextColor3 = uipallet.Text
		windowtitle.TextSize = 13
		windowtitle.TextXAlignment = Enum.TextXAlignment.Left
		windowtitle.Parent = targetswindow
		local close = addCloseButton(targetswindow)
		props.Function = props.Function or function() end
		
		function component:Color(hue, sat, val, isRainbow)
			if targetswindow.Visible then
				holder.BackgroundColor3 = isRainbow and Color3.fromHSV(vape:Color((hue - (self.Index * 0.075)) % 1)) or Color3.fromHSV(hue, sat, val)
			end
		
			if self.Players.Enabled then
				tween:Cancel(self.Players.Object.Frame)
				self.Players.Object.Frame.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
			end
		
			if self.NPCs.Enabled then
				tween:Cancel(self.NPCs.Object.Frame)
				self.NPCs.Object.Frame.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
			end
		
			if self.Invisible.Enabled then
				tween:Cancel(self.Invisible.Object.Holder)
				self.Invisible.Object.Holder.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
			end
		
			if self.Walls.Enabled then
				tween:Cancel(self.Walls.Object.Holder)
				self.Walls.Object.Holder.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
			end
		end
		
		function component:Load(data)
			if self.Players.Enabled ~= data.Players then
				self.Players:Toggle()
			end
		
			if self.NPCs.Enabled ~= data.NPCs then
				self.NPCs:Toggle()
			end
		
			if self.Invisible.Enabled ~= data.Invisible then
				self.Invisible:Toggle()
			end
		
			if self.Walls.Enabled ~= data.Walls then
				self.Walls:Toggle()
			end
		end
		
		function component:Save(data)
			data.Targets = {
				Players = self.Players.Enabled,
				NPCs = self.NPCs.Enabled,
				Invisible = self.Invisible.Enabled,
				Walls = self.Walls.Enabled
			}
		end
		
		function component:UpdateText()
			local newText = {}
		
			if self.Players.Enabled then
				table.insert(newText, 'Players')
			end
		
			if self.NPCs.Enabled then
				table.insert(newText, 'NPCs')
			end
		
			title.Text = 'Target: '..(#newText > 0 and table.concat(newText, ', ') or 'Nothing')
			title.TextColor3 = #newText > 0 and uipallet.Text or Color3.fromRGB(255, 90, 90)
		end
		
		component.Players = components.TargetsButton({
			Position = UDim2.fromOffset(11, 45),
			Icon = getvapeasset('newvape/assets/new/players.png'),
			IconSize = UDim2.fromOffset(16, 16),
			IconParent = iconholder,
			Targets = component,
			Tooltip = 'Target players',
			Function = props.Function
		}, targetswindow, iconholder)
		
		component.NPCs = components.TargetsButton({
			Position = UDim2.fromOffset(112, 45),
			Icon = getvapeasset('newvape/assets/new/npcs.png'),
			IconSize = UDim2.fromOffset(12, 16),
			IconParent = iconholder,
			Targets = component,
			Tooltip = 'Target NPCs',
			Function = props.Function
		}, targetswindow, iconholder)
		
		component.Invisible = components.Toggle({
			Name = 'Ignore invisible',
			Function = function()
				local newText = {}
		
				if component.Invisible.Enabled then
					table.insert(newText, 'invisible')
				end
		
				if component.Walls.Enabled then
					table.insert(newText, 'behind walls')
				end
		
				items.Text = 'Ignore '..(#newText > 0 and table.concat(newText, ', ') or 'none')
				props.Function()
			end
		}, targetswindow, {Options = {}})
		component.Invisible.Object.Position = UDim2.fromOffset(0, 81)
		
		component.Walls = components.Toggle({
			Name = 'Ignore behind walls',
			Function = function()
				local newText = {}
		
				if component.Invisible.Enabled then
					table.insert(newText, 'invisible')
				end
		
				if component.Walls.Enabled then
					table.insert(newText, 'behind walls')
				end
		
				items.Text = 'Ignore '..(#newText > 0 and table.concat(newText, ', ') or 'none')
				props.Function()
			end
		}, targetswindow, {Options = {}})
		component.Walls.Object.Position = UDim2.fromOffset(0, 111)
		
		if props.Players then
			component.Players:Toggle()
		end
		
		if props.NPCs then
			component.NPCs:Toggle()
		end
		
		if props.Invisible then
			component.Invisible:Toggle()
		end
		
		if props.Walls then
			component.Walls:Toggle()
		end
		
		close.MouseButton1Click:Connect(function()
			targetswindow.Visible = false
		end)
		
		button.MouseButton1Click:Connect(function()
			targetswindow.Visible = not targetswindow.Visible
			tween:Cancel(holder)
		
			holder.BackgroundColor3 = targetswindow.Visible and Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value) or color.Light(uipallet.Main, 0.37)
		end)
		
		targets.MouseEnter:Connect(function()
			if not targetswindow.Visible then
				tween:Tween(holder, uipallet.Tween, {
					BackgroundColor3 = color.Light(uipallet.Main, 0.37)
				})
			end
		end)
		
		targets.MouseLeave:Connect(function()
			if not targetswindow.Visible then
				tween:Tween(holder, uipallet.Tween, {
					BackgroundColor3 = color.Light(uipallet.Main, 0.034)
				})
			end
		end)
		
		targets:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
			if vape.ThreadFix then
				setthreadidentity(8)
			end
		
			local actualPosition = (targets.AbsolutePosition + Vector2.new(0, 60)) / scale.Scale
			targetswindow.Position = UDim2.fromOffset(actualPosition.X + 223, actualPosition.Y)
		end)
		
		api.Options.Targets = component
		
		return component
	end,
	TargetsButton = function(props, children, api)
		local component = {
			Enabled = false,
			Type = 'TargetsButton'
		}
		
		local targetsbutton = Instance.new('TextButton')
		targetsbutton.AutoButtonColor = false
		targetsbutton.BackgroundColor3 = color.Light(uipallet.Main, 0.05)
		targetsbutton.Position = props.Position
		targetsbutton.Size = UDim2.fromOffset(98, 31)
		targetsbutton.Text = ''
		targetsbutton.Visible = props.Visible == nil or props.Visible
		targetsbutton.Parent = children
		component.Object = targetsbutton
		addCorner(targetsbutton)
		addTooltip(targetsbutton, props.Tooltip)
		local holder = Instance.new('Frame')
		holder.BackgroundColor3 = uipallet.Main
		holder.Position = UDim2.fromOffset(1, 1)
		holder.Size = UDim2.new(1, -2, 1, -2)
		holder.Parent = targetsbutton
		addCorner(holder)
		local icon = Instance.new('ImageLabel')
		icon.AnchorPoint = Vector2.new(0.5, 0.5)
		icon.BackgroundTransparency = 1
		icon.Image = props.Icon
		icon.ImageColor3 = color.Light(uipallet.Main, 0.37)
		icon.Position = UDim2.fromScale(0.5, 0.5)
		icon.Size = props.IconSize
		icon.Parent = holder
		props.Function = props.Function or function() end
		
		function component:Toggle()
			self.Enabled = not self.Enabled
		
			tween:Tween(holder, uipallet.Tween, {
				BackgroundColor3 = self.Enabled and Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value) or uipallet.Main
			})
		
			tween:Tween(icon, uipallet.Tween, {
				ImageColor3 = self.Enabled and Color3.new(1, 1, 1) or color.Light(uipallet.Main, 0.37)
			})
		
			props.Targets:UpdateText()
			props.Function(self.Enabled)
			if vape and type(vape.ScheduleSave) == 'function' then
				vape:ScheduleSave()
			end
		end
		
		targetsbutton.MouseEnter:Connect(function()
			if not component.Enabled then
				tween:Tween(holder, uipallet.Tween, {
					BackgroundColor3 = Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value - 0.25)
				})
		
				tween:Tween(icon, uipallet.Tween, {
					ImageColor3 = Color3.new(1, 1, 1)
				})
			end
		end)
		
		targetsbutton.MouseLeave:Connect(function()
			if not component.Enabled then
				tween:Tween(holder, uipallet.Tween, {
					BackgroundColor3 = uipallet.Main
				})
		
				tween:Tween(icon, uipallet.Tween, {
					ImageColor3 = color.Light(uipallet.Main, 0.37)
				})
			end
		end)
		
		targetsbutton.MouseButton1Click:Connect(function()
			component:Toggle()
		end)
		
		return component
	end,
	TextBox = function(props, children, api)
		local component = {
			Index = 0,
			Type = 'TextBox',
			Value = props.Default or ''
		}
		
		local textbox = Instance.new('TextButton')
		textbox.AutoButtonColor = false
		textbox.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
		textbox.BorderSizePixel = 0
		textbox.Size = UDim2.new(1, 0, 0, 58)
		textbox.Text = ''
		textbox.Visible = props.Visible == nil or props.Visible
		textbox.Parent = children
		component.Object = textbox
		addTooltip(textbox, props.Tooltip)
		local title = Instance.new('TextLabel')
		title.BackgroundTransparency = 1
		title.FontFace = uipallet.Font
		title.Position = UDim2.fromOffset(10, 3)
		title.Size = UDim2.new(1, -10, 0, 20)
		title.Text = props.Name
		title.TextColor3 = uipallet.Text
		title.TextSize = 12
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = textbox
		local holder = Instance.new('Frame')
		holder.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
		holder.Position = UDim2.fromOffset(10, 23)
		holder.Size = UDim2.new(1, -20, 0, 29)
		holder.Parent = textbox
		addCorner(holder, UDim.new(0, 4))
		local inputbox = Instance.new('TextBox')
		inputbox.BackgroundTransparency = 1
		inputbox.ClearTextOnFocus = false
		inputbox.FontFace = uipallet.Font
		inputbox.PlaceholderColor3 = color.Dark(uipallet.Text, 0.31)
		inputbox.PlaceholderText = props.Placeholder or 'Click to set'
		inputbox.Position = UDim2.fromOffset(8, 0)
		inputbox.Size = UDim2.new(1, -8, 1, 0)
		inputbox.Text = props.Default or ''
		inputbox.TextColor3 = color.Dark(uipallet.Text, 0.16)
		inputbox.TextSize = 12
		inputbox.TextXAlignment = Enum.TextXAlignment.Left
		inputbox.Parent = holder
		local autocomplete
		if props.Player then
			inputbox.ZIndex = 2
			autocomplete = Instance.new('TextLabel')
			autocomplete.BackgroundTransparency = 1
			autocomplete.FontFace = uipallet.Font
			autocomplete.Position = UDim2.fromOffset(8, 0)
			autocomplete.Size = UDim2.new(1, -8, 1, 0)
			autocomplete.Text = ''
			autocomplete.TextColor3 = Color3.new(0.6, 0.6, 0.6)
			autocomplete.TextSize = 12
			autocomplete.TextXAlignment = Enum.TextXAlignment.Left
			autocomplete.Parent = holder
		end
		props.Function = props.Function or function() end
		
		function component:Load(data)
			if self.Value ~= data.Value then
				self:SetValue(data.Value)
			end
		end
		
		function component:Save(data)
			data[props.Name] = {
				Value = self.Value
			}
		end
		
		function component:SetValue(val, enter)
			self.Value = val
			inputbox.Text = val
			props.Function(enter)
			if vape and type(vape.ScheduleSave) == 'function' then
				vape:ScheduleSave()
			end
		end
		
		textbox.MouseButton1Click:Connect(function()
			inputbox:CaptureFocus()
		end)
		
		if autocomplete then
			inputbox:GetPropertyChangedSignal('Text'):Connect(function()
				local plr = getPlayerFromText(inputbox.Text)
				autocomplete.Text = plr and inputbox.Text..(plr:sub(#inputbox.Text + 1, #plr)) or ''
			end)
		
			inputbox.Focused:Connect(function()
				vape.Autocomplete = function()
					local newText = getPlayerFromText(inputbox.Text) or inputbox.Text
					task.spawn(function()
						inputbox:GetPropertyChangedSignal('Text'):Wait()
						inputbox.Text = newText
						inputbox.CursorPosition = #newText + 1
					end)
				end
			end)
		end
		
		inputbox.FocusLost:Connect(function(enter)
			component:SetValue(inputbox.Text, enter)
		end)
		
		inputbox:GetPropertyChangedSignal('Text'):Connect(function()
			component:SetValue(inputbox.Text)
		end)
		
		api.Options[props.Name] = component
		
		return component
	end,
	TextList = function(props, children, api)
		local component = {
			Index = getTableSize(api.Options),
			List = props.Default and table.clone(props.Default) or {},
			ListEnabled = props.Default and table.clone(props.Default) or {},
			Objects = {},
			Type = 'TextList',
			Window = {Visible = false}
		}
		
		props.Color = props.Color or Color3.fromRGB(5, 134, 105)
		local textlist = Instance.new('TextButton')
		textlist.AutoButtonColor = false
		textlist.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
		textlist.BorderSizePixel = 0
		textlist.Size = UDim2.new(1, 0, 0, 50)
		textlist.Text = ''
		textlist.Visible = props.Visible == nil or props.Visible
		textlist.Parent = children
		component.Object = textlist
		addTooltip(textlist, props.Tooltip)
		local holder = Instance.new('Frame')
		holder.BackgroundColor3 = color.Light(uipallet.Main, 0.034)
		holder.Position = UDim2.fromOffset(10, 4)
		holder.Size = UDim2.new(1, -20, 1, -9)
		holder.Parent = textlist
		addCorner(holder, UDim.new(0, 4))
		local button = Instance.new('TextButton')
		button.AutoButtonColor = false
		button.BackgroundColor3 = uipallet.Main
		button.Position = UDim2.fromOffset(1, 1)
		button.Size = UDim2.new(1, -2, 1, -2)
		button.Text = ''
		button.Parent = holder
		local icon = Instance.new('ImageLabel')
		icon.BackgroundTransparency = 1
		icon.Image = getvapeasset('newvape/assets/new/allowediconmini.png')
		icon.Position = UDim2.fromOffset(10, 14)
		icon.Size = UDim2.fromOffset(14, 12)
		icon.Parent = button
		local title = Instance.new('TextLabel')
		title.BackgroundTransparency = 1
		title.FontFace = uipallet.Font
		title.Position = UDim2.fromOffset(35, 6)
		title.Size = UDim2.new(1, -35, 0, 15)
		title.Text = props.Name
		title.TextColor3 = color.Dark(uipallet.Text, 0.16)
		title.TextSize = 15
		title.TextTruncate = Enum.TextTruncate.AtEnd
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = button
		local amount = Instance.fromExisting(title)
		amount.Position = UDim2.fromOffset(0, 6)
		amount.Size = UDim2.new(1, -13, 0, 15)
		amount.Text = '0'
		amount.TextXAlignment = Enum.TextXAlignment.Right
		amount.Parent = button
		local items = Instance.fromExisting(title)
		items.Position = UDim2.fromOffset(35, 21)
		items.Text = 'None'
		items.TextColor3 = color.Dark(uipallet.Text, 0.43)
		items.TextSize = 11
		items.Parent = button
		addCorner(button, UDim.new(0, 4))
		local textlistwindow = Instance.new('TextButton')
		textlistwindow.AutoButtonColor = false
		textlistwindow.BackgroundColor3 = uipallet.Main
		textlistwindow.BorderSizePixel = 0
		textlistwindow.Position = UDim2.fromOffset(456, 227)
		textlistwindow.Size = UDim2.fromOffset(220, 85)
		textlistwindow.Text = ''
		textlistwindow.Visible = false
		textlistwindow.Parent = api.Legit and vape.Legit.Window or clickgui
		component.Window = textlistwindow
		addBlur(textlistwindow)
		addCorner(textlistwindow)
		local icon = Instance.new('ImageLabel')
		icon.BackgroundTransparency = 1
		icon.Image = getvapeasset('newvape/assets/new/allowedicon.png')
		icon.Position = UDim2.fromOffset(10, 13)
		icon.Size = UDim2.fromOffset(19, 16)
		icon.Parent = textlistwindow
		local title = Instance.new('TextLabel')
		title.BackgroundTransparency = 1
		title.FontFace = uipallet.Font
		title.Position = UDim2.fromOffset(36, 11)
		title.Size = UDim2.new(1, -36, 0, 20)
		title.Text = props.Name
		title.TextColor3 = uipallet.Text
		title.TextSize = 13
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = textlistwindow
		local close = addCloseButton(textlistwindow)
		local boxholder = Instance.new('Frame')
		boxholder.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
		boxholder.Position = UDim2.fromOffset(10, 45)
		boxholder.Size = UDim2.fromOffset(200, 31)
		boxholder.Parent = textlistwindow
		addCorner(boxholder)
		local boxinner = Instance.new('Frame')
		boxinner.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
		boxinner.Position = UDim2.fromOffset(1, 1)
		boxinner.Size = UDim2.new(1, -2, 1, -2)
		boxinner.Parent = boxholder
		addCorner(boxinner)
		local textbox = Instance.new('TextBox')
		textbox.BackgroundTransparency = 1
		textbox.ClearTextOnFocus = false
		textbox.FontFace = uipallet.Font
		textbox.PlaceholderText = props.Placeholder or 'Add entry...'
		textbox.PlaceholderColor3 = Color3.new(0.8, 0.8, 0.8)
		textbox.Position = UDim2.fromOffset(10, 0)
		textbox.Size = UDim2.new(1, -35, 1, 0)
		textbox.Text = ''
		textbox.TextColor3 = Color3.new(1, 1, 1)
		textbox.TextSize = 13
		textbox.TextXAlignment = Enum.TextXAlignment.Left
		textbox.Parent = boxholder
		local autocomplete
		if props.Player then
			textbox.ZIndex = 2
			autocomplete = Instance.new('TextLabel')
			autocomplete.BackgroundTransparency = 1
			autocomplete.FontFace = uipallet.Font
			autocomplete.Position = UDim2.fromOffset(10, 0)
			autocomplete.Size = UDim2.new(1, -35, 1, 0)
			autocomplete.Text = ''
			autocomplete.TextColor3 = Color3.new(0.6, 0.6, 0.6)
			autocomplete.TextSize = 13
			autocomplete.TextXAlignment = Enum.TextXAlignment.Left
			autocomplete.Parent = boxholder
		end
		local add = Instance.new('ImageButton')
		add.BackgroundTransparency = 1
		add.Image = getvapeasset('newvape/assets/new/add.png')
		add.ImageColor3 = props.Color
		add.ImageTransparency = 0.3
		add.Position = UDim2.new(1, -26, 0, 8)
		add.Size = UDim2.fromOffset(16, 16)
		add.Parent = boxholder
		props.Function = props.Function or function() end
		
		function component:Color(hue, sat, val, isRainbow)
			if textlistwindow.Visible then
				holder.BackgroundColor3 = isRainbow and Color3.fromHSV(vape:Color((hue - (self.Index * 0.075)) % 1)) or Color3.fromHSV(hue, sat, val)
			end
		end
		
		function component:ChangeValue(value)
			if value then
				local index = table.find(self.List, value)
				if index then
					table.remove(self.List, index)
		
					index = table.find(self.ListEnabled, value)
					if index then
						table.remove(self.ListEnabled, index)
					end
				else
					table.insert(self.List, value)
					table.insert(self.ListEnabled, value)
				end
			end
		
			props.Function(self.List)
			for _, v in self.Objects do
				v:Destroy()
			end
			table.clear(self.Objects)
			textlistwindow.Size = UDim2.fromOffset(220, 85 + (#self.List * 35))
			amount.Text = #self.List
			items.Text = #self.ListEnabled > 0 and table.concat(self.ListEnabled, ', ') or 'None'
		
			for index, value in self.List do
				local isEnabled = table.find(self.ListEnabled, value)
				local obj = Instance.new('TextButton')
				obj.AutoButtonColor = false
				obj.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
				obj.Position = UDim2.fromOffset(10, 47 + (index * 35))
				obj.Size = UDim2.fromOffset(200, 31)
				obj.Text = ''
				obj.Parent = textlistwindow
				addCorner(obj)
				local bkg = Instance.new('Frame')
				bkg.BackgroundColor3 = uipallet.Main
				bkg.Position = UDim2.fromOffset(1, 1)
				bkg.Size = UDim2.new(1, -2, 1, -2)
				bkg.Visible = false
				bkg.Parent = obj
				addCorner(bkg)
				local dot = Instance.new('Frame')
				dot.BackgroundColor3 = isEnabled and props.Color or color.Light(uipallet.Main, 0.37)
				dot.Position = UDim2.fromOffset(10, 12)
				dot.Size = UDim2.fromOffset(10, 11)
				dot.Parent = obj
				addCorner(dot, UDim.new(1, 0))
				local dotin = dot:Clone()
				dotin.BackgroundColor3 = isEnabled and props.Color or color.Light(uipallet.Main, 0.02)
				dotin.Position = UDim2.fromOffset(1, 1)
				dotin.Size = UDim2.fromOffset(8, 9)
				dotin.Parent = dot
				local label = Instance.new('TextLabel')
				label.BackgroundTransparency = 1
				label.FontFace = uipallet.Font
				label.Position = UDim2.fromOffset(30, 0)
				label.Size = UDim2.new(1, -30, 1, 0)
				label.Text = value
				label.TextColor3 = color.Dark(uipallet.Text, 0.16)
				label.TextSize = 15
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = obj
				local close = Instance.new('ImageButton')
				close.AutoButtonColor = false
				close.BackgroundColor3 = Color3.new(1, 1, 1)
				close.BackgroundTransparency = 1
				close.Image = getvapeasset('newvape/assets/new/closetiny.png')
				close.ImageColor3 = color.Light(uipallet.Text, 0.2)
				close.ImageTransparency = 0.5
				close.Position = UDim2.new(1, -27, 0, 8)
				close.Size = UDim2.fromOffset(18, 17)
				close.Parent = obj
				addCorner(close, UDim.new(1, 0))
		
				close.MouseEnter:Connect(function()
					close.ImageTransparency = 0.3
					tween:Tween(close, uipallet.Tween, {
						BackgroundTransparency = 0.6
					})
				end)
		
				close.MouseLeave:Connect(function()
					close.ImageTransparency = 0.5
					tween:Tween(close, uipallet.Tween, {
						BackgroundTransparency = 1
					})
				end)
		
				close.MouseButton1Click:Connect(function()
					self:ChangeValue(value)
				end)
		
				obj.MouseEnter:Connect(function()
					bkg.Visible = true
				end)
		
				obj.MouseLeave:Connect(function()
					bkg.Visible = false
				end)
		
				obj.MouseButton1Click:Connect(function()
					local index = table.find(self.ListEnabled, value)
					if index then
						table.remove(self.ListEnabled, index)
						dot.BackgroundColor3 = color.Light(uipallet.Main, 0.37)
						dotin.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
					else
						table.insert(self.ListEnabled, value)
						dot.BackgroundColor3 = props.Color
						dotin.BackgroundColor3 = props.Color
					end
		
					items.Text = #self.ListEnabled > 0 and table.concat(self.ListEnabled, ', ') or 'None'
					props.Function(self.List)
					if vape and type(vape.ScheduleSave) == 'function' then
						vape:ScheduleSave()
					end
				end)
		
				table.insert(self.Objects, obj)
			end
			if vape and type(vape.ScheduleSave) == 'function' then
				vape:ScheduleSave()
			end
		end
		
		function component:Load(data)
			self.List = data.List or {}
			self.ListEnabled = data.ListEnabled or {}
			self:ChangeValue()
		end
		
		function component:Save(data)
			data[props.Name] = {
				List = self.List,
				ListEnabled = self.ListEnabled
			}
		end
		
		add.MouseEnter:Connect(function()
			add.ImageTransparency = 0
		end)
		
		add.MouseLeave:Connect(function()
			add.ImageTransparency = 0.3
		end)
		
		add.MouseButton1Click:Connect(function()
			local newText = props.TextFunction and props.TextFunction(textbox.Text) or textbox.Text
			if not table.find(component.List, newText) then
				component:ChangeValue(newText)
				textbox.Text = ''
			end
		end)
		
		if autocomplete then
			textbox:GetPropertyChangedSignal('Text'):Connect(function()
				local plr = getPlayerFromText(textbox.Text)
				autocomplete.Text = plr and textbox.Text..(plr:sub(#textbox.Text + 1, #plr)) or ''
			end)
		
			textbox.Focused:Connect(function()
				vape.Autocomplete = function()
					local newText = getPlayerFromText(textbox.Text) or textbox.Text
					task.spawn(function()
						textbox:GetPropertyChangedSignal('Text'):Wait()
						textbox.Text = newText
						textbox.CursorPosition = #newText + 1
					end)
				end
			end)
		end
		
		textbox.FocusLost:Connect(function(enter)
			local newText = props.TextFunction and props.TextFunction(textbox.Text) or textbox.Text
			if enter and not table.find(component.List, newText) then
				component:ChangeValue(newText)
				textbox.Text = ''
			end
		
			vape.Autocomplete = nil
		end)
		
		textbox.MouseEnter:Connect(function()
			tween:Tween(boxholder, uipallet.Tween, {
				BackgroundColor3 = color.Light(uipallet.Main, 0.14)
			})
		end)
		
		textbox.MouseLeave:Connect(function()
			tween:Tween(boxholder, uipallet.Tween, {
				BackgroundColor3 = color.Light(uipallet.Main, 0.02)
			})
		end)
		
		close.MouseButton1Click:Connect(function()
			textlistwindow.Visible = false
		end)
		
		button.MouseButton1Click:Connect(function()
			textlistwindow.Visible = not textlistwindow.Visible
		
			tween:Cancel(holder)
			holder.BackgroundColor3 = textlistwindow.Visible and Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value) or color.Light(uipallet.Main, 0.37)
		end)
		
		textlist.MouseEnter:Connect(function()
			if not textlistwindow.Visible then
				tween:Tween(holder, uipallet.Tween, {
					BackgroundColor3 = color.Light(uipallet.Main, 0.37)
				})
			end
		end)
		
		textlist.MouseLeave:Connect(function()
			if not textlistwindow.Visible then
				tween:Tween(holder, uipallet.Tween, {
					BackgroundColor3 = color.Light(uipallet.Main, 0.034)
				})
			end
		end)
		
		textlist:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
			if vape.ThreadFix then
				setthreadidentity(8)
			end
		
			local actualPosition = (textlist.AbsolutePosition - (api.Legit and vape.Legit.Window.AbsolutePosition or -guiService:GetGuiInset())) / scale.Scale
			textlistwindow.Position = UDim2.fromOffset(actualPosition.X + 223, actualPosition.Y)
		end)
		
		if props.Default then
			component:ChangeValue()
		end
		
		api.Options[props.Name] = component
		
		return component
	end,
	Toggle = function(props, children, api)
		local component = {
			Enabled = false,
			Index = getTableSize(api.Options),
			Name = props.Name,
			Type = 'Toggle'
		}
		
		local isHover = false
		local toggle = Instance.new('TextButton')
		toggle.AutoButtonColor = false
		toggle.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
		toggle.BorderSizePixel = 0
		toggle.FontFace = uipallet.Font
		toggle.Size = UDim2.new(1, 0, 0, 30)
		toggle.Text = '\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138\226\128\138'..props.Name
		toggle.TextColor3 = color.Dark(uipallet.Text, 0.16)
		toggle.TextSize = 14
		toggle.TextXAlignment = Enum.TextXAlignment.Left
		toggle.Visible = props.Visible == nil or props.Visible
		toggle.Parent = children
		component.Object = toggle
		addTooltip(toggle, props.Tooltip)
		local holder = Instance.new('Frame')
		holder.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
		holder.Name = 'Holder'
		holder.Position = UDim2.new(1, -30, 0, 9)
		holder.Size = UDim2.fromOffset(22, 12)
		holder.Parent = toggle
		addCorner(holder, UDim.new(1, 0))
		local knob = Instance.new('Frame')
		knob.BackgroundColor3 = uipallet.Main
		knob.Position = UDim2.fromOffset(2, 2)
		knob.Size = UDim2.fromOffset(8, 8)
		knob.Parent = holder
		addCorner(knob, UDim.new(1, 0))
		props.Function = props.Function or function() end
		
		function component:Color(hue, sat, val, isRainbow)
			if self.Enabled then
				tween:Cancel(holder)
				holder.BackgroundColor3 = isRainbow and Color3.fromHSV(vape:Color((hue - (self.Index * 0.075)) % 1)) or Color3.fromHSV(hue, sat, val)
			end
		end
		
		function component:Load(data)
			if self.Enabled ~= data.Enabled then
				self:Toggle()
			end
		
			if self.Bind and data.Bind then
				self.Bind:Load(data.Bind)
			end
		end
		
		function component:Save(data)
			data[props.Name] = {
				Enabled = self.Enabled
			}
		
			if self.Bind then
				self.Bind:Save(data[props.Name])
			end
		end
		
		function component:Toggle()
			local isRainbow = vape.GUIColor.Rainbow and vape.RainbowMode.Value ~= 'Retro'
			self.Enabled = not self.Enabled
		
			tween:Tween(holder, uipallet.Tween, {
				BackgroundColor3 = self.Enabled and (isRainbow and Color3.fromHSV(vape:Color((vape.GUIColor.Hue - (self.Index * 0.075)) % 1)) or Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value)) or (isHover and color.Light(uipallet.Main, 0.37) or color.Light(uipallet.Main, 0.14))
			})
		
			tween:Tween(knob, uipallet.Tween, {
				Position = UDim2.fromOffset(self.Enabled and 12 or 2, 2)
			})
		
			props.Function(self.Enabled)
			if vape and type(vape.ScheduleSave) == 'function' then
				vape:ScheduleSave()
			end
		end
		
		toggle.MouseEnter:Connect(function()
			isHover = true
		
			if not component.Enabled then
				tween:Tween(holder, uipallet.Tween, {
					BackgroundColor3 = color.Light(uipallet.Main, 0.37)
				})
			end
		end)
		
		toggle.MouseLeave:Connect(function()
			isHover = false
		
			if not component.Enabled then
				tween:Tween(holder, uipallet.Tween, {
					BackgroundColor3 = color.Light(uipallet.Main, 0.14)
				})
			end
		end)
		
		toggle.MouseButton1Click:Connect(function()
			component:Toggle()
		end)
		
		if props.Default then
			component:Toggle()
		end
		
		api.Options[props.Name] = component
		
		return component
	end,
	TwoSlider = function(props, children, api)
		local component = {
			Index = getTableSize(api.Options),
			Max = props.Max,
			Type = 'TwoSlider',
			ValueMin = props.DefaultMin or props.Min,
			ValueMax = props.DefaultMax or 10
		}
		
		local twoslider = Instance.new('TextButton')
		twoslider.AutoButtonColor = false
		twoslider.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
		twoslider.BorderSizePixel = 0
		twoslider.Size = UDim2.new(1, 0, 0, 50)
		twoslider.Text = ''
		twoslider.Visible = props.Visible == nil or props.Visible
		twoslider.Parent = children
		component.Object = twoslider
		addTooltip(twoslider, props.Tooltip)
		local title = Instance.new('TextLabel')
		title.BackgroundTransparency = 1
		title.FontFace = uipallet.Font
		title.Position = UDim2.fromOffset(10, 2)
		title.Size = UDim2.fromOffset(60, 30)
		title.Text = props.Name
		title.TextColor3 = color.Dark(uipallet.Text, 0.16)
		title.TextSize = 11
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = twoslider
		local maxvalue = Instance.new('TextButton')
		maxvalue.BackgroundTransparency = 1
		maxvalue.FontFace = uipallet.Font
		maxvalue.Position = UDim2.new(1, -69, 0, 9)
		maxvalue.Size = UDim2.fromOffset(60, 15)
		maxvalue.Text = component.ValueMax
		maxvalue.TextColor3 = color.Dark(uipallet.Text, 0.16)
		maxvalue.TextSize = 11
		maxvalue.TextXAlignment = Enum.TextXAlignment.Right
		maxvalue.Parent = twoslider
		local minvalue = maxvalue:Clone()
		minvalue.Position = UDim2.new(1, -125, 0, 9)
		minvalue.Text = component.ValueMin
		minvalue.Parent = twoslider
		local custommax = Instance.new('TextBox')
		custommax.BackgroundTransparency = 1
		custommax.ClearTextOnFocus = false
		custommax.FontFace = uipallet.Font
		custommax.Position = maxvalue.Position
		custommax.Size = UDim2.fromOffset(60, 15)
		custommax.Text = component.ValueMax
		custommax.TextColor3 = color.Dark(uipallet.Text, 0.16)
		custommax.TextSize = 11
		custommax.TextXAlignment = Enum.TextXAlignment.Right
		custommax.Visible = false
		custommax.Parent = twoslider
		local custommin = custommax:Clone()
		custommin.Position = minvalue.Position
		custommin.Parent = twoslider
		local holder = Instance.new('Frame')
		holder.BackgroundColor3 = color.Light(uipallet.Main, 0.034)
		holder.BorderSizePixel = 0
		holder.Position = UDim2.fromOffset(10, 37)
		holder.Size = UDim2.new(1, -20, 0, 2)
		holder.Parent = twoslider
		local fill = Instance.new('Frame')
		fill.BackgroundColor3 = Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value)
		fill.BorderSizePixel = 0
		fill.Position = UDim2.fromScale(math.clamp((component.ValueMin - props.Min) / (props.Max - props.Min), 0.04, 0.96), 0)
		fill.Size = UDim2.fromScale(math.clamp(math.clamp((component.ValueMax - props.Min) / (props.Max - props.Min), 0, 1), 0.04, 0.96) - fill.Position.X.Scale, 1)
		fill.Parent = holder
		local knob = Instance.new('Frame')
		knob.AnchorPoint = Vector2.new(0.5, 0.5)
		knob.BackgroundColor3 = twoslider.BackgroundColor3
		knob.BorderSizePixel = 0
		knob.Position = UDim2.fromScale(0, 0.5)
		knob.Size = UDim2.fromOffset(16, 4)
		knob.Parent = fill
		local knobknob = Instance.new('ImageLabel')
		knobknob.AnchorPoint = Vector2.new(0.5, 0.5)
		knobknob.BackgroundTransparency = 1
		knobknob.Image = getvapeasset('newvape/assets/new/range.png')
		knobknob.ImageColor3 = Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value)
		knobknob.Position = UDim2.fromScale(0.5, 0.5)
		knobknob.Size = UDim2.fromOffset(9, 16)
		knobknob.Parent = knob
		local knobmax = knob:Clone()
		knobmax.Position = UDim2.fromScale(1, 0.5)
		knobmax.Parent = fill
		local knobmaxknob = knobmax.ImageLabel
		knobmaxknob.Rotation = 180
		local arrow = Instance.new('ImageLabel')
		arrow.BackgroundTransparency = 1
		arrow.Image = getvapeasset('newvape/assets/new/rangeindicator.png')
		arrow.ImageColor3 = color.Light(uipallet.Main, 0.14)
		arrow.Position = UDim2.new(1, -56, 0, 10)
		arrow.Size = UDim2.fromOffset(12, 6)
		arrow.Parent = twoslider
		props.Function = props.Function or function() end
		props.Decimal = props.Decimal or 1
		local random = Random.new()
		
		function component:Color(hue, sat, val, isRainbow)
			fill.BackgroundColor3 = isRainbow and Color3.fromHSV(vape:Color((hue - (self.Index * 0.075)) % 1)) or Color3.fromHSV(hue, sat, val)
			knobknob.ImageColor3 = fill.BackgroundColor3
			knobmaxknob.ImageColor3 = fill.BackgroundColor3
		end
		
		function component:GetRandomValue()
			return random:NextNumber(component.ValueMin, component.ValueMax)
		end
		
		function component:Load(data)
			if self.ValueMin ~= data.ValueMin then
				self:SetValue(false, data.ValueMin)
			end
		
			if self.ValueMax ~= data.ValueMax then
				self:SetValue(true, data.ValueMax)
			end
		end
		
		function component:Save(data)
			data[props.Name] = {
				ValueMin = self.ValueMin,
				ValueMax = self.ValueMax
			}
		end
		
		function component:SetValue(isMax, value)
			if not math.isfinite(value) then
				return
			end
		
			self[isMax and 'ValueMax' or 'ValueMin'] = value
			maxvalue.Text = self.ValueMax
			minvalue.Text = self.ValueMin
		
			local size = math.clamp(math.clamp((self.ValueMin - props.Min) / (props.Max - props.Min), 0, 1), 0.04, 0.96)
			tween:Tween(fill, TweenInfo.new(0.1), {
				Position = UDim2.fromScale(size, 0),
				Size = UDim2.fromScale(math.clamp(math.clamp((self.ValueMax - props.Min) / (props.Max - props.Min), 0.04, 0.96) - size, 0, 1), 1)
			})
			if vape and type(vape.ScheduleSave) == 'function' then
				vape:ScheduleSave()
			end
		end
		
		knob.MouseEnter:Connect(function()
			tween:Tween(knobknob, uipallet.Tween, {
				Size = UDim2.fromOffset(11, 18)
			})
		end)
		
		knob.MouseLeave:Connect(function()
			tween:Tween(knobknob, uipallet.Tween, {
				Size = UDim2.fromOffset(9, 16)
			})
		end)
		
		knobmax.MouseEnter:Connect(function()
			tween:Tween(knobmaxknob, uipallet.Tween, {
				Size = UDim2.fromOffset(11, 18)
			})
		end)
		
		knobmax.MouseLeave:Connect(function()
			tween:Tween(knobmaxknob, uipallet.Tween, {
				Size = UDim2.fromOffset(9, 16)
			})
		end)
		
		twoslider.InputBegan:Connect(function(input)
			if
				(input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
				and (input.Position.Y - twoslider.AbsolutePosition.Y) > (20 * scale.Scale)
			then
				local maxCheck = (input.Position.X - knobmax.AbsolutePosition.X) > -10
				local newPosition = math.clamp((input.Position.X - holder.AbsolutePosition.X) / holder.AbsoluteSize.X, 0, 1)
		
				local releaseConnection
				local moveConnection = inputService.InputChanged:Connect(function(newInput)
					if newInput.UserInputType == (input.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
						local newPosition = math.clamp((newInput.Position.X - holder.AbsolutePosition.X) / holder.AbsoluteSize.X, 0, 1)
						component:SetValue(maxCheck, math.floor((props.Min + (props.Max - props.Min) * newPosition) * props.Decimal) / props.Decimal, newPosition)
					end
				end)
		
				releaseConnection = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						moveConnection:Disconnect()
						releaseConnection:Disconnect()
					end
				end)
		
				component:SetValue(maxCheck, math.floor((props.Min + (props.Max - props.Min) * newPosition) * props.Decimal) / props.Decimal, newPosition)
			end
		end)
		
		maxvalue.MouseButton1Click:Connect(function()
			maxvalue.Visible = false
			custommax.Visible = true
			custommax.Text = component.ValueMax
			custommax:CaptureFocus()
		end)
		
		minvalue.MouseButton1Click:Connect(function()
			minvalue.Visible = false
			custommin.Visible = true
			custommin.Text = component.ValueMin
			custommin:CaptureFocus()
		end)
		
		custommax.FocusLost:Connect(function(enter)
			maxvalue.Visible = true
			custommax.Visible = false
		
			if enter and tonumber(custommax.Text) then
				component:SetValue(true, tonumber(custommax.Text))
			end
		end)
		
		custommin.FocusLost:Connect(function(enter)
			minvalue.Visible = true
			custommin.Visible = false
		
			if enter and tonumber(custommin.Text) then
				component:SetValue(false, tonumber(custommin.Text))
			end
		end)
		
		api.Options[props.Name] = component
		
		return component
	end,
}

vape.Components = setmetatable(components, {
	__newindex = function(_, index, callback)
		for _, module in vape.Modules do
			rawset(module, 'Create'..index, function(_, props)
				return callback(props, module.Children, module)
			end)
		end

		if vape.Legit then
			for _, module in vape.Legit.Modules do
				rawset(module, 'Create'..index, function(_, props)
					return callback(props, module.Children, module)
				end)
			end
		end

		rawset(components, index, callback)
	end
})

vape:LoadGUI()

return vape
end)()

shared.vape = vape

local BLOCK_SIZE = (Config and Config.BLOCK) or 3

local VapeConfig = {
    AimAssist = {
        enabled = false,
        range = 6.5,
        fov = 95,
        speed = 11,
        requireWeapon = true, -- Require Sword / Mace / Melee Weapon!
        clickOnly = false,
        inLobby = false
    },
    KillAura = {
        enabled = false,
        range = 4.2,
        fov = 360,
        mode = "1.9+ Cooldown", -- "1.9+ Cooldown" | "Spam CPS"
        cps = 12,
        autoWeapon = true,
        autoCritSprint = true,
        inLobby = false
    },
    AutoClicker = {
        enabled = false,
        mode = "1.9+ Cooldown", -- "1.9+ Cooldown" | "Spam CPS"
        cps = 14,
        requireWeapon = false,
        breakBlocks = true
    },
    Backtrack = {
        enabled = false,
        delayMs = 250, -- 50..450ms
        maxRange = 6.5,
        showGhost = true
    },
    FakeLag = {
        enabled = false,
        chokeMs = 300, -- 100..650ms
        mode = "Blink Pulse", -- "Blink Pulse" | "Latency Queue"
        flushOnAttack = true,
        showServerGhost = true
    },
    Scaffold = {
        enabled = false,
        autoBlock = true,
        expand = 1,
        keepY = false,
        tower = true
    },
    FastPlace = {
        enabled = false,
        cps = 25 -- 10..60 blocks/sec
    },
    Fly = {
        enabled = false,
        mode = "AirWalk", -- "AirWalk" (Lock Y) | "StepUp" (Rise on Jump)
        sneakDown = true,
        autoSprint = true,
        antiRollback = true
    },
    NoFall = {
        enabled = true,
        mode = "Spoof Ground" -- "Spoof Ground" | "Pre-Land Spoof"
    },
    ThirdPerson = {
        enabled = false,
        view = "Back (2nd)", -- "Back (2nd)" | "Front (3rd)"
        distance = 4.5, -- 2..14 blocks
        freeZoom = true
    },
    AutoMace = {
        enabled = false,
        mode = "Auto (Wind/Step)", -- "Auto (Wind/Step)" | "Multi-Step" | "High Jump"
        height = 9, -- 4..20 blocks
        autoSelectMace = true,
        autoSlamAttack = true,
        antiRollback = true,
        inLobby = true
    },
    Velocity = {
        enabled = false,
        mode = "Low KB", -- "Low KB" | "No KB (0%)"
        horizontal = 25, -- 0..100%
        vertical = 50, -- 0..100%
        explosionKb = true
    },
    ESP = {
        enabled = false,
        box = true,
        corner = true,
        nametags = true,
        nametagScale = 1.45, -- 0.8..3.0x
        itemsBar = true,
        itemsScale = 1.05, -- 0.7..2.0x
        showBots = true,
        inLobby = false
    },
    AutoOrganize = {
        enabled = false,
        swordSlot = 1,
        maceSlot = 2,
        appleSlot = 3,
        blockSlot = 4,
        bowSlot = 5,
        utilitySlot = 6,
        pickaxeSlot = 7,
        autoArmor = true,
        dropWorseGear = true,
        dropCustomTrash = false,
        trashList = { "dirt", "rotten_flesh", "wooden_sword" }
    }
}

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

local function canPlayerActInGame()
    if not isActiveMatchOrAllowed(false) or not isLocalAlive() then
        return false
    end
    if CameraMod and (CameraMod.spectating or CameraMod.cursorFree or CameraMod.uiOpen) then
        return false
    end
    if UiMod and type(UiMod.isOpen) == "function" and UiMod.isOpen() == true then
        return false
    end
    if MovementMod and type(MovementMod.isFrozen) == "function" and MovementMod.isFrozen() == true then
        return false
    end
    return true
end

local function isFriendsListPlayer(plr)
    if not plr or not vape or not vape.Categories or not vape.Categories.Friends then
        return false
    end
    local friendsCat = vape.Categories.Friends
    if friendsCat.Options and friendsCat.Options["Use friends"] and not friendsCat.Options["Use friends"].Enabled then
        return false
    end
    if type(friendsCat.ListEnabled) == "table" then
        for _, fName in ipairs(friendsCat.ListEnabled) do
            if type(fName) == "string" and (fName:lower() == plr.Name:lower() or fName:lower() == plr.DisplayName:lower()) then
                return true
            end
        end
    end
    return false
end

local function getValidFighters(allowLobby)
    local results = {}
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then
        return results
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and not isFriendsListPlayer(plr) then
            local c = plr.Character
            if not c:GetAttribute("Hidden") then
                if allowLobby or plr:GetAttribute("InRound") == true or LocalPlayer:GetAttribute("InTraining") == true then
                    local hrp = c:FindFirstChild("HumanoidRootPart")
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hrp and (not hum or hum.Health > 0) then
                        table.insert(results, {
                            model = c,
                            player = plr,
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
                        player = nil,
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

-- ============================================================================
-- BACKTRACK ENGINE (Rewind History + Physical Hitbox Rewind + Neon Ghost Box)
-- ============================================================================
local backtrackHistory = {} -- [model] = { { t = number, cf = CFrame, pos = Vector3 } }
local backtrackGhostPart = nil

local function clearBacktrackGhost()
    if backtrackGhostPart then
        pcall(function()
            backtrackGhostPart:Destroy()
        end)
        backtrackGhostPart = nil
    end
end

local function updateBacktrackGhost(cf, show)
    if not show or not cf then
        if backtrackGhostPart then
            backtrackGhostPart.Parent = nil
        end
        return
    end
    if not backtrackGhostPart then
        local p = Instance.new("Part")
        p.Name = "YDX_BacktrackGhost"
        p.Anchored = true
        p.CanCollide = false
        p.CanQuery = false
        p.CanTouch = false
        p.CastShadow = false
        p.Material = Enum.Material.Neon
        p.Color = Color3.fromRGB(5, 213, 148)
        p.Transparency = 0.62
        p.Size = Vector3.new(2.2, 5.2, 1.4)
        backtrackGhostPart = p
    end
    backtrackGhostPart.CFrame = cf
    local folder = (workspace:FindFirstChild("MCLocal")) or workspace
    if backtrackGhostPart.Parent ~= folder then
        backtrackGhostPart.Parent = folder
    end
end

local function recordBacktrackPositions()
    local now = os.clock()
    local seen = {}
    for _, entry in ipairs(getValidFighters(true)) do
        local m = entry.model
        seen[m] = true
        local hist = backtrackHistory[m]
        if not hist then
            hist = {}
            backtrackHistory[m] = hist
        end
        local last = hist[#hist]
        if not last or (now - last.t) >= 0.025 then
            table.insert(hist, {
                t = now,
                cf = entry.hrp.CFrame,
                pos = entry.hrp.Position
            })
        end
        while #hist > 1 and (now - hist[1].t) > 0.85 do
            table.remove(hist, 1)
        end
    end
    for m in pairs(backtrackHistory) do
        if not seen[m] or not m.Parent then
            backtrackHistory[m] = nil
        end
    end
end

local function getBacktrackedPositionForFighter(entry, eye, myHrpPos)
    local livePos = entry.hrp.Position
    local liveCf = entry.hrp.CFrame
    local liveDist = math.min((livePos - myHrpPos).Magnitude, ((livePos + Vector3.new(0, -0.3, 0)) - eye).Magnitude) / BLOCK_SIZE

    if not VapeConfig.Backtrack.enabled then
        return livePos, liveCf, liveDist, false
    end

    local hist = backtrackHistory[entry.model]
    if not hist or #hist == 0 then
        return livePos, liveCf, liveDist, false
    end

    local now = os.clock()
    local maxWindowSec = math.clamp((tonumber(VapeConfig.Backtrack.delayMs) or 250) / 1000, 0.05, 0.48)
    local bestPos = livePos
    local bestCf = liveCf
    local bestDist = liveDist
    local usedRewind = false

    -- Find the closest historical snapshot within the server rewind window (or the snapshot closest to delayMs when retreating)
    for i = #hist, 1, -1 do
        local snap = hist[i]
        local age = now - snap.t
        if age <= maxWindowSec then
            local d1 = (snap.pos - myHrpPos).Magnitude / BLOCK_SIZE
            local d2 = ((snap.pos + Vector3.new(0, -0.3, 0)) - eye).Magnitude / BLOCK_SIZE
            local d = math.min(d1, d2)
            if d + 0.08 < bestDist then
                bestDist = d
                bestPos = snap.pos
                bestCf = snap.cf
                usedRewind = (snap.pos - livePos).Magnitude > 0.35
            end
        end
    end

    return bestPos, bestCf, bestDist, usedRewind
end

-- Ray-Box intersection in block coordinates (matches PoFClient.targetCharacter)
local function rayBoxIntersect(rayOriginBlocks, rayDir, boxMin, boxMax, maxReach)
    local tMin = 0
    local tMax = maxReach
    for _, axis in ipairs({ "X", "Y", "Z" }) do
        local o = rayOriginBlocks[axis]
        local d = rayDir[axis]
        local bMin = boxMin[axis]
        local bMax = boxMax[axis]
        if math.abs(d) < 1e-9 then
            if o < bMin or o > bMax then
                return nil
            end
        else
            local t1 = (bMin - o) / d
            local t2 = (bMax - o) / d
            if t1 > t2 then
                t1, t2 = t2, t1
            end
            tMin = math.max(tMin, t1)
            tMax = math.min(tMax, t2)
            if tMax < tMin then
                return nil
            end
        end
    end
    return tMin
end

local function stepBacktrackHitboxApply()
    if not VapeConfig.Backtrack.enabled or not isActiveMatchOrAllowed(true) or not isLocalAlive() then
        updateBacktrackGhost(nil, false)
        return
    end
    local char = LocalPlayer.Character
    local myHrp = char and char:FindFirstChild("HumanoidRootPart")
    if not myHrp then
        updateBacktrackGhost(nil, false)
        return
    end

    local eye = getEyePosition()
    local look = getCameraLook()
    local eyeBlocks = eye / BLOCK_SIZE
    local maxBtRange = tonumber(VapeConfig.Backtrack.maxRange) or 6.5

    local bestGhostCf = nil
    local bestGhostDist = maxBtRange + 1

    for _, entry in ipairs(getValidFighters(true)) do
        local btPos, btCf, btDist, isRewound = getBacktrackedPositionForFighter(entry, eye, myHrp.Position)
        if isRewound and btDist <= maxBtRange then
            if btDist < bestGhostDist then
                bestGhostDist = btDist
                bestGhostCf = btCf
            end
            -- Check if player's crosshair ray hits the backtracked AABB (so manual Left-Clicks & AutoClicker hit via native PoFClient.attack()!)
            local feetBlocks = (btPos - Vector3.new(0, 2.7, 0)) / BLOCK_SIZE
            local height = entry.model:GetAttribute("Sneaking") and 1.5 or 1.8
            local bMin = feetBlocks - Vector3.new(0.45, 0.12, 0.45)
            local bMax = feetBlocks + Vector3.new(0.45, height + 0.12, 0.45)
            local hitT = rayBoxIntersect(eyeBlocks, look, bMin, bMax, 4.5)
            if hitT and btDist <= 4.35 then
                -- Move enemy HRP to the backtracked CFrame for this frame so native targetCharacter() rayBox hits it!
                entry.hrp.CFrame = btCf
            end
        end
    end

    updateBacktrackGhost(bestGhostCf, VapeConfig.Backtrack.showGhost and bestGhostCf ~= nil)
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
        local evalPos, evalCf, effDist, isRewound = getBacktrackedPositionForFighter(entry, eye, myHrp.Position)
        local targetPos = evalPos + Vector3.new(0, -0.3, 0)
        local deltaEye = targetPos - eye

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
                    entry.btCf = evalCf
                    entry.isRewound = isRewound
                    bestEntry = entry
                end
            end
        end
    end

    return bestEntry
end

-- ============================================================================
-- FAKE LAG ENGINE (Chokes / Delays 20Hz MCRemotes.Sync packets + Server Ghost)
-- ============================================================================
local fakeLagQueue = {} -- { { t = number, buf = buffer, pos = Vector3 } }
local fakeLagLastFlush = os.clock()
local fakeLagServerPos = nil
local fakeLagGhostPart = nil

local function clearFakeLagGhost()
    if fakeLagGhostPart then
        pcall(function()
            fakeLagGhostPart:Destroy()
        end)
        fakeLagGhostPart = nil
    end
end

local function updateFakeLagGhost(pos, show)
    if not show or not pos then
        if fakeLagGhostPart then
            fakeLagGhostPart.Parent = nil
        end
        return
    end
    if not fakeLagGhostPart then
        local p = Instance.new("Part")
        p.Name = "YDX_FakeLagServerGhost"
        p.Anchored = true
        p.CanCollide = false
        p.CanQuery = false
        p.CanTouch = false
        p.CastShadow = false
        p.Material = Enum.Material.Neon
        p.Color = Color3.fromRGB(0, 174, 255)
        p.Transparency = 0.65
        p.Size = Vector3.new(2.0, 5.1, 1.2)
        fakeLagGhostPart = p
    end
    local yaw = (CameraMod and tonumber(CameraMod.faceYaw)) or 0
    fakeLagGhostPart.CFrame = CFrame.new(pos) * CFrame.Angles(0, yaw, 0)
    local folder = (workspace:FindFirstChild("MCLocal")) or workspace
    if fakeLagGhostPart.Parent ~= folder then
        fakeLagGhostPart.Parent = folder
    end
end

local function flushFakeLagPackets(onlyLatest)
    if #fakeLagQueue == 0 then
        fakeLagLastFlush = os.clock()
        return
    end
    if onlyLatest then
        local newest = fakeLagQueue[#fakeLagQueue]
        table.clear(fakeLagQueue)
        if newest and SyncRemote then
            fakeLagServerPos = newest.pos
            pcall(function()
                SyncRemote:FireServer(newest.buf)
            end)
        end
    else
        for _, pkt in ipairs(fakeLagQueue) do
            fakeLagServerPos = pkt.pos
            if SyncRemote then
                pcall(function()
                    SyncRemote:FireServer(pkt.buf)
                end)
            end
        end
        table.clear(fakeLagQueue)
    end
    fakeLagLastFlush = os.clock()
end

env._YDX_TOF_FAKELAG_SEND = function(buf, worldPos)
    if not watcherActive or not VapeConfig.FakeLag.enabled or not isLocalAlive() then
        if #fakeLagQueue > 0 then
            flushFakeLagPackets(true)
        end
        fakeLagServerPos = worldPos
        updateFakeLagGhost(nil, false)
        return false
    end

    local now = os.clock()
    local chokeSec = math.clamp((tonumber(VapeConfig.FakeLag.chokeMs) or 300) / 1000, 0.08, 0.70)
    table.insert(fakeLagQueue, {
        t = now,
        buf = buf,
        pos = worldPos
    })
    if #fakeLagQueue > 30 then
        table.remove(fakeLagQueue, 1)
    end

    if VapeConfig.FakeLag.mode == "Latency Queue" then
        -- Continuously delay every packet by chokeSec (constant high-ping jitter look)
        while #fakeLagQueue > 0 and (now - fakeLagQueue[1].t) >= chokeSec do
            local pkt = table.remove(fakeLagQueue, 1)
            fakeLagServerPos = pkt.pos
            if SyncRemote then
                pcall(function()
                    SyncRemote:FireServer(pkt.buf)
                end)
            end
        end
    else
        -- "Blink Pulse": freeze on other players' screens for chokeSec, then teleport!
        if (now - fakeLagLastFlush) >= chokeSec then
            flushFakeLagPackets(true)
        end
    end

    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local showGhost = VapeConfig.FakeLag.showServerGhost and fakeLagServerPos ~= nil and myHrp ~= nil and (fakeLagServerPos - myHrp.Position).Magnitude > 1.2
    updateFakeLagGhost(fakeLagServerPos, showGhost)

    return true
end

-- Hotbar slot & weapon helpers
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

local MELEE_SWORD_MACE_IDS = {
    wooden_sword = true,
    stone_sword = true,
    iron_sword = true,
    diamond_sword = true,
    mace = true,
    knockback_stick = true
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

local function isHoldingSwordOrMace()
    local id, def = getHeldItemDef()
    if not id then
        return false
    end
    if MELEE_SWORD_MACE_IDS[id] then
        return true
    end
    if def and def.kind == "melee" then
        return true
    end
    if id:find("sword") or id:find("mace") then
        return true
    end
    return false
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

local function findMaceSlot()
    if not Hud or type(Hud.state) ~= "table" or type(Hud.state.inv) ~= "table" then
        return nil
    end
    for slotIdx = 1, 9 do
        local entry = Hud.state.inv[slotIdx]
        if entry and type(entry.id) == "string" and (entry.id == "mace" or entry.id:lower():find("mace")) then
            return slotIdx
        end
    end
    return nil
end

local function findWindChargeSlot()
    if not Hud or type(Hud.state) ~= "table" or type(Hud.state.inv) ~= "table" then
        return nil
    end
    for slotIdx = 1, 9 do
        local entry = Hud.state.inv[slotIdx]
        if entry and type(entry.id) == "string" and entry.id == "wind_charge" and (entry.count == nil or entry.count > 0) then
            return slotIdx
        end
    end
    return nil
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
-- AIRWALK FLY & AUTO-MACE LAUNCH ENGINE (Hooks PlayerPhysics.step + Anti-Rollback)
-- ============================================================================
local airWalkY = nil
local autoMaceState = {
    pendingLaunch = false,
    activeDive = false,
    launchStartTime = 0,
    peakY = 0,
    startY = 0,
    targetPeakY = 0,
    climbPhase = false,
    usedRealWindCharge = false,
    hasSlammed = false,
    modRef = nil
}

-- Hook Character TeleportN to cancel server rollback snaps while Fly (AirWalk) or AutoMace is active!
local hookedTeleportChars = setmetatable({}, { __mode = "k" })
local lastForcedRollbackTime = 0

local function shouldSuppressServerRollback(char)
    if not watcherActive or not char then
        return false
    end
    local flyProtect = VapeConfig.Fly.enabled and VapeConfig.Fly.antiRollback
    local maceProtect = autoMaceState.activeDive and (VapeConfig.AutoMace.antiRollback ~= false)
    if not flyProtect and not maceProtect then
        return false
    end

    -- Allow legitimate arena round-start cage spawns & lobby death teleports (> 24 blocks away)
    local tpCf = char:GetAttribute("Teleport")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if typeof(tpCf) == "CFrame" and hrp then
        local distBlocks = (tpCf.Position - hrp.Position).Magnitude / BLOCK_SIZE
        if distBlocks > 24 then
            return false
        end
    end
    return true
end

local function installAntiRollbackOnCharacter(char)
    if not char or hookedTeleportChars[char] then
        return
    end
    hookedTeleportChars[char] = true

    -- Disable existing Movement.lua TeleportN connection and wrap it with our filter!
    if type(getconnections) == "function" then
        local ok, conns = pcall(getconnections, char:GetAttributeChangedSignal("TeleportN"))
        if ok and type(conns) == "table" then
            for _, c in ipairs(conns) do
                local fn = c.Function
                if type(fn) == "function" then
                    pcall(function()
                        c:Disable()
                    end)
                    table.insert(connections, char:GetAttributeChangedSignal("TeleportN"):Connect(function()
                        if shouldSuppressServerRollback(char) then
                            -- Ignore the server rollback snap and re-assert our current position packet!
                            local st = (MovementMod and type(MovementMod.state) == "function" and MovementMod.state()) or nil
                            if st and typeof(st.pos) == "Vector3" and SyncMod and type(SyncMod.send) == "function" then
                                local yaw = (CameraMod and tonumber(CameraMod.headYaw)) or 0
                                local pitch = (CameraMod and tonumber(CameraMod.headPitch)) or 0
                                pcall(SyncMod.send, st.pos * BLOCK_SIZE + Vector3.new(0, 2.7, 0), yaw, pitch, st.sneaking == true, true)
                            end
                            return
                        end
                        fn()
                    end))
                end
            end
        end
    end
end

if LocalPlayer.Character then
    task.defer(installAntiRollbackOnCharacter, LocalPlayer.Character)
end
table.insert(connections, LocalPlayer.CharacterAdded:Connect(function(c)
    task.delay(0.15, function()
        installAntiRollbackOnCharacter(c)
    end)
    task.delay(0.6, function()
        installAntiRollbackOnCharacter(c)
    end)
end))

local function computeImpulseVelocityForBlocks(heightBlocks)
    local h = math.clamp(tonumber(heightBlocks) or 9, 3, 25)
    -- In PlayerPhysics (vy = (vy - 0.08) * 0.98 per tick), vy = 0.24 + sqrt(h * 0.178) reaches ~h blocks peak
    return math.clamp(0.24 + math.sqrt(h * 0.178), 0.85, 2.45)
end

local function triggerAutoMaceLaunch()
    if not isLocalAlive() then
        return
    end
    installAntiRollbackOnCharacter(LocalPlayer.Character)

    -- Temporarily suspend AirWalk floor lock while diving with AutoMace
    if VapeConfig.Fly.enabled then
        airWalkY = nil
    end

    local now = os.clock()
    local hBlocks = math.clamp(tonumber(VapeConfig.AutoMace.height) or 9, 4, 20)
    autoMaceState.activeDive = true
    autoMaceState.launchStartTime = now
    autoMaceState.hasSlammed = false
    autoMaceState.usedRealWindCharge = false

    local st = (MovementMod and type(MovementMod.state) == "function" and MovementMod.state()) or nil
    local startFeet = (st and typeof(st.pos) == "Vector3" and st.pos) or getFeetBlockPos() or Vector3.zero
    autoMaceState.startY = startFeet.Y
    autoMaceState.peakY = startFeet.Y
    autoMaceState.targetPeakY = startFeet.Y + hBlocks

    -- Check if we should fire a real Wind Charge downward first (grants server IMPULSE_GRACE_TICKS = 40!)
    local windSlot = (VapeConfig.AutoMace.mode == "Auto (Wind/Step)") and findWindChargeSlot() or nil
    if windSlot and ActionRemote then
        autoMaceState.usedRealWindCharge = true
        lastSelfWindChargeThrowTime = now
        selectHotbarSlot(windSlot)
        -- Jump + throw wind_charge straight down at our feet so the server explodes it and grants 40 ticks of impulse grace!
        if st then
            st.onGround = false
            st.fallDistance = 0
            if PlayerPhysicsMod and type(PlayerPhysicsMod.getMotion) == "function" and type(PlayerPhysicsMod.setMotion) == "function" then
                local vx, _, vz = PlayerPhysicsMod.getMotion(st)
                PlayerPhysicsMod.setMotion(st, Vector3.new(vx or 0, 0.42, vz or 0))
            end
        end
        pcall(function()
            ActionRemote:FireServer("use", Vector3.new(0, -1, 0), startFeet)
        end)
        -- Switch back to Mace right after throwing Wind Charge and boost climb to targetPeakY
        task.delay(0.06, function()
            if VapeConfig.AutoMace.autoSelectMace then
                local maceSlot = findMaceSlot() or findBestWeaponSlot()
                if maceSlot then
                    selectHotbarSlot(maceSlot)
                end
            end
        end)
        autoMaceState.climbPhase = true
        autoMaceState.pendingLaunch = true
        return
    end

    -- Equip Mace (or best weapon) immediately
    if VapeConfig.AutoMace.autoSelectMace then
        local maceSlot = findMaceSlot() or findBestWeaponSlot()
        if maceSlot then
            selectHotbarSlot(maceSlot)
        end
    end

    if VapeConfig.AutoMace.mode == "High Jump" then
        autoMaceState.climbPhase = false
        autoMaceState.pendingLaunch = true
        if st then
            local vy = computeImpulseVelocityForBlocks(hBlocks)
            st.onGround = false
            st.fallDistance = 0
            if PlayerPhysicsMod and type(PlayerPhysicsMod.getMotion) == "function" and type(PlayerPhysicsMod.setMotion) == "function" then
                local vx, _, vz = PlayerPhysicsMod.getMotion(st)
                PlayerPhysicsMod.setMotion(st, Vector3.new(vx or 0, vy, vz or 0))
                autoMaceState.pendingLaunch = false
            end
        end
    else
        -- "Auto (Wind/Step)" (without wind_charge) or "Multi-Step":
        -- Climb using server-valid step jumps (vy = 0.42 per tick with onGround=true spoofed on climb ticks)
        -- so the server validates every upward step as a normal block/stair jump and NEVER rolls back!
        autoMaceState.climbPhase = true
        autoMaceState.pendingLaunch = true
        if st then
            st.onGround = false
            st.fallDistance = 0
            if PlayerPhysicsMod and type(PlayerPhysicsMod.getMotion) == "function" and type(PlayerPhysicsMod.setMotion) == "function" then
                local vx, _, vz = PlayerPhysicsMod.getMotion(st)
                PlayerPhysicsMod.setMotion(st, Vector3.new(vx or 0, 0.42, vz or 0))
            end
        end
    end
end

local function stepAutoMaceSlam()
    if not autoMaceState.activeDive then
        return
    end
    local now = os.clock()
    if (now - autoMaceState.launchStartTime) > 3.5 or not isLocalAlive() then
        autoMaceState.activeDive = false
        autoMaceState.pendingLaunch = false
        autoMaceState.climbPhase = false
        return
    end

    local st = (MovementMod and type(MovementMod.state) == "function" and MovementMod.state()) or nil
    if type(st) == "table" and typeof(st.pos) == "Vector3" then
        if st.pos.Y > autoMaceState.peakY then
            autoMaceState.peakY = st.pos.Y
        end
        local vy = 0
        if PlayerPhysicsMod and type(PlayerPhysicsMod.getMotion) == "function" then
            local _, my, _ = PlayerPhysicsMod.getMotion(st)
            vy = tonumber(my) or 0
        end

        -- Once we reach targetPeakY (or after 0.65s of climbing), transition from climbPhase to pure free-fall!
        if autoMaceState.climbPhase then
            if st.pos.Y >= autoMaceState.targetPeakY - 0.15 or (now - autoMaceState.launchStartTime) > 0.65 then
                autoMaceState.climbPhase = false
                autoMaceState.peakY = math.max(autoMaceState.peakY, st.pos.Y)
            end
        end

        -- Once we are falling downward (vy < -0.04) and have fallen at least 1.6 blocks (SMASH_FALL_THRESHOLD = 1.5)
        local fallenBlocks = math.max(tonumber(st.fallDistance) or 0, autoMaceState.peakY - st.pos.Y)
        if not autoMaceState.climbPhase and vy < -0.04 and fallenBlocks >= 1.6 then
            st.fallDistance = math.max(tonumber(st.fallDistance) or 0, fallenBlocks)
            if VapeConfig.AutoMace.autoSelectMace then
                local maceSlot = findMaceSlot() or findBestWeaponSlot()
                if maceSlot then
                    selectHotbarSlot(maceSlot)
                end
            end

            if VapeConfig.AutoMace.autoSlamAttack then
                local target = findNearestTarget(4.7, 360, VapeConfig.AutoMace.inLobby)
                if target then
                    pushTargetToVapeTargetInfo(target)
                    env._YDX_TOF_SILENT_ROT = {
                        yaw = target.aimYaw,
                        pitch = target.aimPitch,
                        t = now
                    }
                    -- Attack on the way down when within smash reach (4.4 blocks)
                    if target.distBlocks <= 4.4 and (not autoMaceState.hasSlammed or (now - lastKillAuraSwing) >= 0.20) then
                        autoMaceState.hasSlammed = true
                        lastKillAuraSwing = now
                        if VapeConfig.FakeLag.enabled and VapeConfig.FakeLag.flushOnAttack then
                            flushFakeLagPackets(true)
                        end
                        if Hud then
                            Hud.swingStart = now
                        end
                        if ViewmodelMod and type(ViewmodelMod.swing) == "function" then
                            pcall(ViewmodelMod.swing)
                        end
                        if Chars and type(Chars.swing) == "function" and LocalPlayer.Character then
                            pcall(Chars.swing, LocalPlayer.Character)
                        end
                        if MovementMod then
                            MovementMod.freshSprint = true
                        end
                        if ActionRemote then
                            pcall(function()
                                ActionRemote:FireServer("attack", target.model, target.aimUnit, true)
                            end)
                        end
                        -- Immediately reset server fallDistance right after the Mace strike so landing deals 0 fall damage!
                        if VapeConfig.NoFall.enabled and type(env._YDX_TOF_FLUSH_NOFALL_NOW) == "function" then
                            local curWorldPos = st.pos * BLOCK_SIZE + Vector3.new(0, 2.7, 0)
                            pcall(env._YDX_TOF_FLUSH_NOFALL_NOW, curWorldPos)
                        end
                    end
                end
            end
        end

        -- End dive cycle once back on ground after descending
        if not autoMaceState.climbPhase and st.onGround and (now - autoMaceState.launchStartTime) > 0.30 then
            autoMaceState.activeDive = false
            autoMaceState.pendingLaunch = false
        end
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

-- ============================================================================
-- ANTI-ROLLBACK AIRWALK PLATFORM + NOFALL + THIRD PERSON ENGINE
-- ============================================================================
local airWalkPlatformPart = nil
local airWalkTickCounter = 0

local function clearAirWalkPlatform()
    if airWalkPlatformPart then
        local oldPart = airWalkPlatformPart
        airWalkPlatformPart = nil
        pcall(function()
            if CollisionMod and type(CollisionMod.removePart) == "function" then
                CollisionMod.removePart(oldPart)
            end
            oldPart:Destroy()
        end)
    end
end

local function updateAirWalkPlatform(feetX, floorY, feetZ)
    if not VapeConfig.Fly.enabled or autoMaceState.activeDive or not floorY then
        clearAirWalkPlatform()
        return
    end
    local snapY = math.floor(floorY * 16 + 0.5) / 16
    local snapX = math.floor(feetX * 2 + 0.5) / 2
    local snapZ = math.floor(feetZ * 2 + 0.5) / 2

    -- Place a real voxel-registered 5x1x5 invisible platform inside workspace.MCLocal
    -- whose top face is at exact block Y = snapY so PlayerPhysics.moveEntity &sync(state).box
    -- collide naturally on the platform with zero AABB desync!
    local partSize = Vector3.new(5 * BLOCK_SIZE, 1 * BLOCK_SIZE, 5 * BLOCK_SIZE)
    local partPos = Vector3.new(snapX * BLOCK_SIZE, (snapY - 0.5) * BLOCK_SIZE, snapZ * BLOCK_SIZE)

    local folder = workspace:FindFirstChild("MCLocal")
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = "MCLocal"
        folder.Parent = workspace
        if CollisionMod and type(CollisionMod.watch) == "function" then
            pcall(CollisionMod.watch, folder)
        end
    end

    if not airWalkPlatformPart or not airWalkPlatformPart.Parent then
        local p = Instance.new("Part")
        p.Name = "YDX_AirWalkPlatform"
        p.Anchored = true
        p.CanCollide = true
        p.CanQuery = false
        p.CanTouch = false
        p.CastShadow = false
        p.Transparency = 1
        p.Size = partSize
        p.Position = partPos
        p.Parent = folder
        airWalkPlatformPart = p
        if CollisionMod and type(CollisionMod.addPart) == "function" then
            pcall(CollisionMod.addPart, p)
        end
    else
        if (airWalkPlatformPart.Position - partPos).Magnitude > 0.05 then
            if CollisionMod and type(CollisionMod.removePart) == "function" then
                pcall(CollisionMod.removePart, airWalkPlatformPart)
            end
            airWalkPlatformPart.Size = partSize
            airWalkPlatformPart.Position = partPos
            if CollisionMod and type(CollisionMod.addPart) == "function" then
                pcall(CollisionMod.addPart, airWalkPlatformPart)
            end
        end
    end
end

-- Check if there is a real solid map block directly underneath the player's feet
local function isOnRealMapGround(feetPos)
    if not feetPos or not CollisionMod or type(CollisionMod.cellSolid) ~= "function" then
        return false
    end
    -- Temporarily ignore our airWalkPlatformPart when checking real ground
    local checkY = math.floor(feetPos.Y - 0.06)
    for _, off in ipairs({
        Vector2.zero,
        Vector2.new(0.28, 0.28),
        Vector2.new(-0.28, 0.28),
        Vector2.new(0.28, -0.28),
        Vector2.new(-0.28, -0.28)
    }) do
        local cx = math.floor(feetPos.X + off.X)
        local cz = math.floor(feetPos.Z + off.Y)
        if CollisionMod.cellSolid(cx, checkY, cz) then
            -- Make sure it's not ONLY our AirWalk platform
            if not airWalkPlatformPart then
                return true
            end
            local platTopY = (airWalkPlatformPart.Position.Y + airWalkPlatformPart.Size.Y * 0.5) / BLOCK_SIZE
            if math.abs((checkY + 1) - platTopY) > 0.15 then
                return true
            end
        end
    end
    return false
end

-- Check if there is solid map ground within `maxDepthBlocks` below `feetPos`
local function hasGroundWithinBlocks(feetPos, maxDepthBlocks)
    if not feetPos or not CollisionMod or type(CollisionMod.cellSolid) ~= "function" then
        return false
    end
    local startY = math.floor(feetPos.Y - 0.04)
    local endY = math.floor(feetPos.Y - (maxDepthBlocks or 1.6))
    for cy = startY, endY, -1 do
        for _, off in ipairs({
            Vector2.zero,
            Vector2.new(0.28, 0.28),
            Vector2.new(-0.28, 0.28),
            Vector2.new(0.28, -0.28),
            Vector2.new(-0.28, -0.28)
        }) do
            local cx = math.floor(feetPos.X + off.X)
            local cz = math.floor(feetPos.Z + off.Y)
            if CollisionMod.cellSolid(cx, cy, cz) then
                if not airWalkPlatformPart then
                    return true
                end
                local platTopY = (airWalkPlatformPart.Position.Y + airWalkPlatformPart.Size.Y * 0.5) / BLOCK_SIZE
                if math.abs((cy + 1) - platTopY) > 0.15 then
                    return true
                end
            end
        end
    end
    return false
end

-- Server onGround Spoofer for 0-Damage NoFall, Anti-Rollback AirWalk Fly & Multi-Step AutoMace
env._YDX_TOF_SPOOF_ONGROUND = function(worldPos, clientOnGround)
    if not watcherActive then
        return clientOnGround
    end
    local feetPos = (worldPos - Vector3.new(0, 2.7, 0)) / BLOCK_SIZE

    -- During AutoMace:
    -- 1) While climbing in Multi-Step mode (without a Wind Charge), spoof onGround = true so each 0.42 step jump is server-legal!
    -- 2) While descending BEFORE the Mace hit, send onGround = false so the server accumulates full fallDistance for Mace Smash damage.
    -- 3) The instant the Mace hit lands (hasSlammed == true) OR when within 1.55 blocks of hitting the floor with no target left,
    --    if NoFall is enabled, switch to onGround = true (which triggers flushNoFallGroundStepsTo) so landing deals 0 fall damage!
    if autoMaceState.activeDive then
        if autoMaceState.climbPhase and not autoMaceState.usedRealWindCharge then
            return true
        end
        if VapeConfig.NoFall.enabled then
            if autoMaceState.hasSlammed or clientOnGround or hasGroundWithinBlocks(feetPos, 1.55) then
                return true
            end
        end
        return false
    end

    -- 1) If AirWalk Fly is active with Anti-Rollback:
    if VapeConfig.Fly.enabled and VapeConfig.Fly.antiRollback then
        if isOnRealMapGround(feetPos) or VapeConfig.NoFall.enabled then
            return true
        end
        airWalkTickCounter = (airWalkTickCounter + 1) % 6
        return (airWalkTickCounter == 0)
    end

    -- 2) If NoFall is active: always spoof onGround = true (coupled with 1.66-block step-down packets in Sync.send for 100% 0 fall damage!)
    if VapeConfig.NoFall.enabled then
        return true
    end

    return clientOnGround
end

-- Third Person Camera Distance Upvalue Patcher
local cameraConstantsTable = nil
pcall(function()
    if CameraMod and type(CameraMod.init) == "function" and debug and debug.getupvalues then
        local ok, ups = pcall(debug.getupvalues, CameraMod.init)
        if ok and type(ups) == "table" then
            for _, v in pairs(ups) do
                if type(v) == "table" and v.ThirdPersonDistance ~= nil and v.OrbitMax ~= nil then
                    cameraConstantsTable = v
                    break
                end
            end
        end
    end
end)

local function applyThirdPersonState()
    if not CameraMod then
        return
    end
    local dist = math.clamp(tonumber(VapeConfig.ThirdPerson.distance) or 4.5, 2, 16)
    if cameraConstantsTable then
        cameraConstantsTable.ThirdPersonDistance = dist
        cameraConstantsTable.OrbitMax = math.max(16, dist + 4)
    end
    if VapeConfig.ThirdPerson.enabled then
        local desiredMode = (VapeConfig.ThirdPerson.view == "Front (3rd)") and 3 or 2
        CameraMod.forceThird = false -- Keep forceThird false so mode 3 (front view) also works and V/F5 can still cycle!
        if CameraMod.mode == 1 then
            CameraMod.mode = desiredMode
        end
    end
end

-- Allow mouse wheel zooming in Third Person inside matches when Free Zoom is enabled
table.insert(connections, UserInputService.InputChanged:Connect(function(input, gp)
    if gp or not watcherActive then
        return
    end
    if input.UserInputType == Enum.UserInputType.MouseWheel and VapeConfig.ThirdPerson.enabled and VapeConfig.ThirdPerson.freeZoom then
        if CameraMod and not CameraMod.orbit and not CameraMod.spectating and not CameraMod.uiOpen and CameraMod.mode ~= 1 then
            -- Only zoom when holding RightAlt / FreeMouse or when ThirdPerson is active and Ctrl is held
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) then
                local z = input.Position.Z
                local curDist = tonumber(VapeConfig.ThirdPerson.distance) or 4.5
                local newDist = math.clamp(curDist - z * 0.75, 2, 14)
                VapeConfig.ThirdPerson.distance = newDist
                if cameraConstantsTable then
                    cameraConstantsTable.ThirdPersonDistance = newDist
                end
            end
        end
    end
end))

if PlayerPhysicsMod and type(PlayerPhysicsMod.step) == "function" then
    env._YDX_TOF_ORIG_PPSTEP = env._YDX_TOF_ORIG_PPSTEP or PlayerPhysicsMod.step
    local trueOrigPPStep = env._YDX_TOF_ORIG_PPSTEP

    PlayerPhysicsMod.step = function(state, input, world)
        if watcherActive and autoMaceState.activeDive and type(state) == "table" and typeof(state.pos) == "Vector3" then
            clearAirWalkPlatform()
            if autoMaceState.climbPhase then
                -- Multi-Step climb: sustain server-legal JumpVelocity (0.42 blocks/tick) until reaching targetPeakY!
                if state.pos.Y < autoMaceState.targetPeakY - 0.15 and (os.clock() - autoMaceState.launchStartTime) <= 0.65 then
                    state.onGround = false
                    state.fallDistance = 0
                    if type(PlayerPhysicsMod.getMotion) == "function" and type(PlayerPhysicsMod.setMotion) == "function" then
                        local vx, vy, vz = PlayerPhysicsMod.getMotion(state)
                        local stepVy = math.max(tonumber(vy) or 0, 0.42)
                        PlayerPhysicsMod.setMotion(state, Vector3.new(vx or 0, stepVy, vz or 0))
                    end
                else
                    autoMaceState.climbPhase = false
                    autoMaceState.peakY = math.max(autoMaceState.peakY, state.pos.Y)
                end
                autoMaceState.pendingLaunch = false
            elseif autoMaceState.pendingLaunch then
                autoMaceState.pendingLaunch = false
                local hBlocks = math.clamp(tonumber(VapeConfig.AutoMace.height) or 9, 4, 20)
                autoMaceState.startY = state.pos.Y
                autoMaceState.peakY = state.pos.Y + hBlocks
                local vy = computeImpulseVelocityForBlocks(hBlocks)
                state.onGround = false
                state.fallDistance = 0
                if type(PlayerPhysicsMod.getMotion) == "function" and type(PlayerPhysicsMod.setMotion) == "function" then
                    local vx, _, vz = PlayerPhysicsMod.getMotion(state)
                    PlayerPhysicsMod.setMotion(state, Vector3.new(vx or 0, vy, vz or 0))
                end
            end
        end

        -- NoFall enforcement inside PlayerPhysics.step (when not diving with AutoMace)
        if watcherActive and VapeConfig.NoFall.enabled and not autoMaceState.activeDive and type(state) == "table" then
            state.fallDistance = 0
            -- Also clamp downward vertical velocity to a safe speed (vy >= -0.46 blocks/tick = 2.3 blocks per 50ms Sync packet < 3.0 SafeFallDistance)
            -- and trigger a micro ground-cushion reset right before impact so the server's server-side fall tracker ALWAYS computes 0 damage!
            if not VapeConfig.Fly.enabled and typeof(state.pos) == "Vector3" and type(PlayerPhysicsMod.getMotion) == "function" and type(PlayerPhysicsMod.setMotion) == "function" then
                local vx, vy, vz = PlayerPhysicsMod.getMotion(state)
                local curVy = tonumber(vy) or 0
                if curVy < 0 and not state.onGround then
                    if hasGroundWithinBlocks(state.pos, 2.2) then
                        -- Cushion impact speed right above real ground so landing delta-Y is < 0.35 blocks
                        if curVy < -0.24 then
                            PlayerPhysicsMod.setMotion(state, Vector3.new(vx or 0, -0.22, vz or 0))
                        end
                    elseif curVy < -0.46 then
                        -- Cap terminal fall speed so each 20Hz Sync packet steps down by < 2.3 blocks (< 3.0 SafeFallDistance)
                        PlayerPhysicsMod.setMotion(state, Vector3.new(vx or 0, -0.46, vz or 0))
                    end
                end
            end
        end

        if not watcherActive or not VapeConfig.Fly.enabled or autoMaceState.activeDive or type(state) ~= "table" or typeof(state.pos) ~= "Vector3" then
            if not (VapeConfig.Fly.enabled and not autoMaceState.activeDive) then
                clearAirWalkPlatform()
            end
            local res = trueOrigPPStep(state, input, world)
            if watcherActive and VapeConfig.NoFall.enabled and not autoMaceState.activeDive and type(state) == "table" then
                state.fallDistance = 0
                if type(res) == "table" then
                    res.fallDistance = 0
                end
            end
            return res
        end

        if not airWalkY then
            airWalkY = math.floor(state.pos.Y * 16 + 0.5) / 16
        end

        local descend = VapeConfig.Fly.sneakDown and type(input) == "table" and input.sneak == true
        if descend then
            airWalkY = math.floor((state.pos.Y - 0.12) * 16 + 0.5) / 16
            input = table.clone(input)
            input.sneak = false
            input.edgeGuard = false
        else
            if type(input) == "table" then
                input = table.clone(input)
                input.edgeGuard = false
                -- Anti-Rollback speed cap: over void air, normal walk speed (or controlled sprint-jump) prevents server speed rollback!
                if VapeConfig.Fly.antiRollback and not isOnRealMapGround(state.pos) then
                    if not input.jump then
                        input.sprint = false
                        state.sprinting = false
                    end
                elseif VapeConfig.Fly.autoSprint and (input.forward or 0) > 0 then
                    input.sprint = true
                end
            end
        end

        -- Update the physical MCLocal collision platform under the player BEFORE trueOrigPPStep
        -- so PlayerPhysics.moveEntity & sync(state).box land on the platform naturally!
        updateAirWalkPlatform(state.pos.X, airWalkY, state.pos.Z)
        state.fallDistance = 0

        local ret = trueOrigPPStep(state, input, world)

        state.fallDistance = 0
        if type(ret) == "table" then
            ret.fallDistance = 0
        end

        if not descend then
            if VapeConfig.Fly.mode == "StepUp" and type(input) == "table" and input.jump and state.pos.Y > airWalkY + 0.25 then
                airWalkY = math.floor(state.pos.Y * 16 + 0.5) / 16
                updateAirWalkPlatform(state.pos.X, airWalkY, state.pos.Z)
            end
        else
            airWalkY = math.floor(state.pos.Y * 16 + 0.5) / 16
            updateAirWalkPlatform(state.pos.X, airWalkY, state.pos.Z)
        end

        return ret
    end
end

-- ============================================================================
-- VELOCITY / KNOCKBACK ENGINE (No KB 0% & Low KB Horizontal/Vertical Scaling)
-- ============================================================================
local lastSelfWindChargeThrowTime = 0

local function getActiveKnockbackScales()
    if not watcherActive or not VapeConfig.Velocity.enabled then
        return 1, 1, false
    end
    if VapeConfig.Velocity.mode == "No KB (0%)" then
        return 0, 0, true
    end
    local hScale = math.clamp((tonumber(VapeConfig.Velocity.horizontal) or 25) / 100, 0, 1)
    local vScale = math.clamp((tonumber(VapeConfig.Velocity.vertical) or 50) / 100, 0, 1)
    return hScale, vScale, true
end

if PhysicsMod and type(PhysicsMod.knockback) == "function" then
    env._YDX_TOF_ORIG_KNOCKBACK = env._YDX_TOF_ORIG_KNOCKBACK or PhysicsMod.knockback
    local origKnockback = env._YDX_TOF_ORIG_KNOCKBACK

    PhysicsMod.knockback = function(motionVec, onGround, power, dx, dz, resist)
        local kbVec = origKnockback(motionVec, onGround, power, dx, dz, resist)
        local hScale, vScale, active = getActiveKnockbackScales()
        if not active or typeof(motionVec) ~= "Vector3" or typeof(kbVec) ~= "Vector3" then
            return kbVec
        end
        if hScale <= 0.001 and vScale <= 0.001 then
            return motionVec
        end
        local newX = motionVec.X + (kbVec.X - motionVec.X) * hScale
        local newY = motionVec.Y + (kbVec.Y - motionVec.Y) * vScale
        local newZ = motionVec.Z + (kbVec.Z - motionVec.Z) * hScale
        return Vector3.new(newX, newY, newZ)
    end
end

-- Also intercept MCRemotes.Motion ("kb", "add", "set", "setY") so explosion/Mace/knockback impulses respect NoKB & Low KB!
if MotionRemote and type(getconnections) == "function" then
    local okM, mConns = pcall(getconnections, MotionRemote.OnClientEvent)
    if okM and type(mConns) == "table" then
        for _, c in ipairs(mConns) do
            local fn = c.Function
            if type(fn) == "function" and not env._YDX_TOF_HOOKED_MOTION_FN then
                env._YDX_TOF_HOOKED_MOTION_FN = fn
                pcall(function()
                    c:Disable()
                end)
                table.insert(connections, MotionRemote.OnClientEvent:Connect(function(kind, a, b, d)
                    if not watcherActive or not VapeConfig.Velocity.enabled then
                        return fn(kind, a, b, d)
                    end
                    local hScale, vScale, active = getActiveKnockbackScales()
                    if not active then
                        return fn(kind, a, b, d)
                    end
                    -- Allow own AutoMace wind charge jump impulse
                    if autoMaceState.activeDive or (os.clock() - lastSelfWindChargeThrowTime) < 0.45 then
                        return fn(kind, a, b, d)
                    end
                    if kind == "kb" then
                        if hScale <= 0.001 and vScale <= 0.001 then
                            return
                        end
                        return fn(kind, a, b, d)
                    elseif VapeConfig.Velocity.explosionKb and (kind == "add" or kind == "set" or kind == "setY") then
                        if hScale <= 0.001 and vScale <= 0.001 then
                            return
                        end
                        if kind == "add" and typeof(a) == "Vector3" then
                            return fn(kind, Vector3.new(a.X * hScale, a.Y * vScale, a.Z * hScale), b, d)
                        elseif kind == "set" and typeof(a) == "Vector3" then
                            local st = (MovementMod and type(MovementMod.state) == "function" and MovementMod.state()) or nil
                            if st and PlayerPhysicsMod and type(PlayerPhysicsMod.getMotion) == "function" then
                                local mx, my, mz = PlayerPhysicsMod.getMotion(st)
                                local curM = Vector3.new(mx or 0, my or 0, mz or 0)
                                local scaled = Vector3.new(
                                    curM.X + (a.X - curM.X) * hScale,
                                    curM.Y + (a.Y - curM.Y) * vScale,
                                    curM.Z + (a.Z - curM.Z) * hScale
                                )
                                return fn(kind, scaled, b, d)
                            end
                        elseif kind == "setY" and type(a) == "number" then
                            return fn(kind, a * vScale, b, d)
                        end
                    end
                    return fn(kind, a, b, d)
                end))
            end
        end
    end
end

-- ============================================================================
-- AUTO ORGANIZE (INV MANAGER - Sorts Hotbar, Equips Best Armor & Drops Trash Silently)
-- ============================================================================
local lastAutoOrganizeActTime = 0

local SWORD_TIER_SCORE = {
    diamond_sword = 400,
    iron_sword = 300,
    stone_sword = 200,
    wooden_sword = 100
}

local PICKAXE_TIER_SCORE = {
    iron_pickaxe = 200,
    stone_pickaxe = 100
}

local ARMOR_TIER_SCORE = {
    diamond_chestplate = 300,
    iron_chestplate = 200,
    chain_chestplate = 100
}

local MACE_UTILITY_WEAPON_SCORE = {
    mace = 300,
    knockback_stick = 150
}

local HEAL_FOOD_SCORE = {
    enchanted_apple = 400,
    golden_apple = 300,
    potion_heal = 250,
    potion_speed = 180,
    potion_jump = 160,
    potion_slowfall = 140
}

local RANGED_BOW_SCORE = {
    bow = 400,
    fire_charge = 300,
    snowball = 200,
    egg = 190,
    fishing_rod = 150
}

local UTILITY_PEARL_SCORE = {
    wind_charge = 400,
    ender_pearl = 380,
    totem = 350,
    water_bucket = 250,
    lava_bucket = 220,
    tnt = 200,
    cobweb = 180
}

local function isItemInCustomTrashList(itemId)
    if not itemId or not VapeConfig.AutoOrganize.dropCustomTrash then
        return false
    end
    local list = VapeConfig.AutoOrganize.trashList
    if type(list) ~= "table" then
        return false
    end
    local lowerId = itemId:lower()
    local def = Config and Config.Items and Config.Items[itemId]
    local lowerName = (def and type(def.name) == "string" and def.name:lower()) or ""
    for _, raw in ipairs(list) do
        if type(raw) == "string" and #raw > 0 then
            local q = raw:lower():gsub("^%s+", ""):gsub("%s+$", "")
            if q ~= "" then
                if lowerId == q or lowerName == q or lowerId:find(q, 1, true) or (lowerName ~= "" and lowerName:find(q, 1, true)) then
                    return true
                end
            end
        end
    end
    return false
end

local function stepAutoOrganize()
    if not VapeConfig.AutoOrganize.enabled then
        return
    end
    if not isActiveMatchOrAllowed(false) or not isLocalAlive() then
        return
    end
    if not Hud or type(Hud.state) ~= "table" or type(Hud.state.inv) ~= "table" or not ActionRemote then
        return
    end
    -- Don't interfere while player is eating/drinking or actively swinging/bridging
    if Chars and (Chars.localUsing == "eat" or Chars.localUsing == "drink" or Chars.localUsing == "bow") then
        return
    end
    local now = os.clock()
    if (now - lastAutoOrganizeActTime) < 0.13 then
        return
    end

    local inv = Hud.state.inv
    local curArmorId = Hud.state.armorItem
    local curArmorScore = (curArmorId and ARMOR_TIER_SCORE[curArmorId]) or 0

    -- 1. AUTO ARMOR: check if there is a strictly better chestplate in hotbar slots 1..9
    if VapeConfig.AutoOrganize.autoArmor then
        local bestArmorSlot = nil
        local bestArmorScore = curArmorScore
        for slot = 1, 9 do
            local st = inv[slot]
            local id = st and st.id
            local aScore = id and ARMOR_TIER_SCORE[id]
            if aScore and aScore > bestArmorScore then
                bestArmorScore = aScore
                bestArmorSlot = slot
            end
        end
        if bestArmorSlot then
            lastAutoOrganizeActTime = now
            local equippedId = inv[bestArmorSlot].id
            pcall(function()
                ActionRemote:FireServer("equipSlot", bestArmorSlot)
            end)
            -- Optimistic client state update so we don't fire twice
            if curArmorId and curArmorId ~= "" then
                inv[bestArmorSlot] = { id = curArmorId, count = 1 }
            else
                inv[bestArmorSlot] = nil
            end
            Hud.state.armorItem = equippedId
            return
        end
    end

    -- Find the single best sword & best pickaxe currently in hotbar
    local bestSwordSlot, bestSwordScore = nil, -1
    local bestPickSlot, bestPickScore = nil, -1
    for slot = 1, 9 do
        local st = inv[slot]
        local id = st and st.id
        if id then
            local sScore = SWORD_TIER_SCORE[id]
            if sScore and sScore > bestSwordScore then
                bestSwordScore = sScore
                bestSwordSlot = slot
            end
            local pScore = PICKAXE_TIER_SCORE[id]
            if pScore and pScore > bestPickScore then
                bestPickScore = pScore
                bestPickSlot = slot
            end
        end
    end

    -- 2. AUTO DROP WORSE GEAR & CUSTOM TRASH (without opening inventory!)
    if VapeConfig.AutoOrganize.dropWorseGear or VapeConfig.AutoOrganize.dropCustomTrash then
        for slot = 1, 9 do
            local st = inv[slot]
            local id = st and st.id
            if id then
                local shouldDrop = false
                if VapeConfig.AutoOrganize.dropWorseGear then
                    -- Worse or duplicate sword
                    if SWORD_TIER_SCORE[id] and bestSwordSlot and slot ~= bestSwordSlot then
                        shouldDrop = true
                    -- Worse or duplicate pickaxe
                    elseif PICKAXE_TIER_SCORE[id] and bestPickSlot and slot ~= bestPickSlot then
                        shouldDrop = true
                    -- Worse or duplicate armor piece than currently worn armor
                    elseif ARMOR_TIER_SCORE[id] and ARMOR_TIER_SCORE[id] <= curArmorScore then
                        shouldDrop = true
                    end
                end
                if not shouldDrop and isItemInCustomTrashList(id) then
                    -- Never drop our only sword if it happens to be in custom trash list unless we have a better sword!
                    if not (SWORD_TIER_SCORE[id] and slot == bestSwordSlot and bestSwordScore <= 100 and not findMaceSlot()) then
                        shouldDrop = true
                    end
                end
                if shouldDrop then
                    lastAutoOrganizeActTime = now
                    pcall(function()
                        ActionRemote:FireServer("dropSlot", slot, true)
                    end)
                    inv[slot] = nil
                    return
                end
            end
        end
    end

    -- 3. AUTO SORT HOTBAR SLOTS (Swap items into user's configured target slots!)
    local lockedSlots = {}
    local categoriesOrder = {
        {
            targetSlot = math.floor(tonumber(VapeConfig.AutoOrganize.swordSlot) or 1),
            scoreFn = function(st)
                return (st and st.id and SWORD_TIER_SCORE[st.id]) or -1
            end
        },
        {
            targetSlot = math.floor(tonumber(VapeConfig.AutoOrganize.maceSlot) or 2),
            scoreFn = function(st)
                return (st and st.id and MACE_UTILITY_WEAPON_SCORE[st.id]) or -1
            end
        },
        {
            targetSlot = math.floor(tonumber(VapeConfig.AutoOrganize.appleSlot) or 3),
            scoreFn = function(st)
                if not st or not st.id then return -1 end
                local base = HEAL_FOOD_SCORE[st.id]
                if not base then return -1 end
                return base + math.min(99, tonumber(st.count) or 1)
            end
        },
        {
            targetSlot = math.floor(tonumber(VapeConfig.AutoOrganize.blockSlot) or 4),
            scoreFn = function(st)
                if not st or not st.id then return -1 end
                if not isSolidBridgeBlock(st.id) then return -1 end
                local cnt = tonumber(st.count) or 1
                local woolBonus = (st.id == "wool") and 100 or 0
                return 200 + woolBonus + cnt
            end
        },
        {
            targetSlot = math.floor(tonumber(VapeConfig.AutoOrganize.bowSlot) or 5),
            scoreFn = function(st)
                if not st or not st.id then return -1 end
                local base = RANGED_BOW_SCORE[st.id]
                if not base then return -1 end
                return base + math.min(50, tonumber(st.count) or 1)
            end
        },
        {
            targetSlot = math.floor(tonumber(VapeConfig.AutoOrganize.utilitySlot) or 6),
            scoreFn = function(st)
                if not st or not st.id then return -1 end
                local base = UTILITY_PEARL_SCORE[st.id]
                if not base then return -1 end
                return base + math.min(50, tonumber(st.count) or 1)
            end
        },
        {
            targetSlot = math.floor(tonumber(VapeConfig.AutoOrganize.pickaxeSlot) or 7),
            scoreFn = function(st)
                return (st and st.id and PICKAXE_TIER_SCORE[st.id]) or -1
            end
        }
    }

    for _, catRule in ipairs(categoriesOrder) do
        local dst = catRule.targetSlot
        if dst >= 1 and dst <= 9 and not lockedSlots[dst] then
            local bestSlotForCat = nil
            local bestCatScore = -1
            for s = 1, 9 do
                if not lockedSlots[s] or s == dst then
                    local sc = catRule.scoreFn(inv[s])
                    if sc > bestCatScore then
                        bestCatScore = sc
                        bestSlotForCat = s
                    end
                end
            end
            if bestSlotForCat and bestCatScore > 0 then
                lockedSlots[dst] = true
                local curDstScore = catRule.scoreFn(inv[dst])
                if bestSlotForCat ~= dst and bestCatScore > curDstScore then
                    lastAutoOrganizeActTime = now
                    pcall(function()
                        ActionRemote:FireServer("swap", bestSlotForCat, dst)
                    end)
                    inv[bestSlotForCat], inv[dst] = inv[dst], inv[bestSlotForCat]
                    return
                end
            end
        end
    end
end

-- ============================================================================
-- 2D ESP ENGINE (ESP Box, ESP Corner, Scalable Nametags & 9-Slot Item Hotbar!)
-- ============================================================================
local espScreenGui = nil
local espCardsByModel = {} -- [model] = { rootFrame, boxFrame, corners = {}, nameLabel, hpText, hpBarBg, hpBarFill, hotbarFrame, armorSlot, slots = { [1..9] = { frame, itemHolder, stroke, lastItemId, lastWool } } }
local enemySeenHotbar = setmetatable({}, { __mode = "k" }) -- [model] = { slots = { [1..9] = { id = string, wool = string? } }, activeSlot = number }

local function getPreferredEnemySlotForItem(itemId)
    if not itemId then return 9 end
    if SWORD_TIER_SCORE[itemId] then return 1 end
    if MACE_UTILITY_WEAPON_SCORE[itemId] then return 2 end
    if HEAL_FOOD_SCORE[itemId] then return 3 end
    if isSolidBridgeBlock(itemId) then return 4 end
    if RANGED_BOW_SCORE[itemId] then return 5 end
    if UTILITY_PEARL_SCORE[itemId] then return 6 end
    if PICKAXE_TIER_SCORE[itemId] then return 7 end
    if ARMOR_TIER_SCORE[itemId] then return 8 end
    return 9
end

local function updateEnemySeenHotbar(model)
    local tracker = enemySeenHotbar[model]
    if not tracker then
        tracker = {
            slots = {},
            activeSlot = nil,
            lastHeld = nil
        }
        enemySeenHotbar[model] = tracker
    end

    local heldId = model:GetAttribute("Held")
    local heldWool = model:GetAttribute("HeldWool")
    if type(heldId) == "string" and heldId ~= "" and Config and Config.Items and Config.Items[heldId] then
        -- Check if item is already in one of the 9 slots
        local existingSlot = nil
        for s = 1, 9 do
            local entry = tracker.slots[s]
            if entry and entry.id == heldId then
                existingSlot = s
                entry.wool = heldWool or entry.wool
                break
            end
        end
        if not existingSlot then
            local pref = getPreferredEnemySlotForItem(heldId)
            if not tracker.slots[pref] then
                existingSlot = pref
            elseif SWORD_TIER_SCORE[heldId] and tracker.slots[1] and (SWORD_TIER_SCORE[heldId] > (SWORD_TIER_SCORE[tracker.slots[1].id] or 0)) then
                -- Move old sword to a free slot and put stronger sword in slot 1
                for s = 8, 9 do
                    if not tracker.slots[s] then
                        tracker.slots[s] = tracker.slots[1]
                        break
                    end
                end
                existingSlot = 1
            else
                for s = 1, 9 do
                    if not tracker.slots[s] then
                        existingSlot = s
                        break
                    end
                end
                existingSlot = existingSlot or pref
            end
            tracker.slots[existingSlot] = {
                id = heldId,
                wool = heldWool
            }
        end
        tracker.activeSlot = existingSlot
    else
        tracker.activeSlot = nil
    end

    return tracker
end

local SHORT_ITEM_LABELS = {
    diamond_sword = "DIA",
    iron_sword = "IRN",
    stone_sword = "STN",
    wooden_sword = "WD",
    mace = "MCE",
    knockback_stick = "KB",
    golden_apple = "GAP",
    enchanted_apple = "EGA",
    wool = "WL",
    planks = "PLK",
    cobblestone = "COB",
    end_stone = "END",
    obsidian = "OBS",
    bow = "BOW",
    wind_charge = "WND",
    ender_pearl = "PRL",
    fire_charge = "FIR",
    snowball = "SNW",
    egg = "EGG",
    totem = "TOT",
    iron_pickaxe = "IPK",
    stone_pickaxe = "SPK",
    diamond_chestplate = "DCH",
    iron_chestplate = "ICH",
    chain_chestplate = "CCH",
    tnt = "TNT",
    cobweb = "WEB"
}

local function renderItemIntoEspSlot(itemHolder, itemId, woolColor, slotPixelSize)
    itemHolder:ClearAllChildren()
    if not itemId or itemId == "" then
        return
    end
    local drewIcon = false
    if UiMod and type(UiMod.iconFit) == "function" and Config and Config.Items and Config.Items[itemId] then
        local ok, iconObj = pcall(function()
            local def = Config.Items[itemId]
            local iconName = def.icon or ("item_" .. itemId)
            if itemId == "wool" and type(woolColor) == "string" and woolColor ~= "" then
                iconName = "item_" .. woolColor
            end
            local img = UiMod.icon(itemHolder, iconName, 1)
            if img then
                img.AnchorPoint = Vector2.new(0.5, 0.5)
                img.Position = UDim2.fromScale(0.5, 0.5)
                img.Size = UDim2.new(1, -2, 1, -2)
                img.ZIndex = itemHolder.ZIndex + 1
                return img
            end
            return nil
        end)
        if ok and iconObj then
            drewIcon = true
        end
    end
    if not drewIcon then
        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.Size = UDim2.fromScale(1, 1)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextScaled = true
        lbl.TextColor3 = Color3.fromRGB(245, 245, 255)
        lbl.TextStrokeTransparency = 0.2
        lbl.Text = SHORT_ITEM_LABELS[itemId] or itemId:sub(1, 3):upper()
        lbl.ZIndex = itemHolder.ZIndex + 1
        lbl.Parent = itemHolder
    end
end

local function ensureEspScreenGui()
    if espScreenGui and espScreenGui.Parent then
        return espScreenGui
    end
    local parentGui = nil
    pcall(function()
        if type(gethui) == "function" then
            parentGui = gethui()
        end
    end)
    if not parentGui then
        pcall(function()
            local cg = game:GetService("CoreGui")
            if cg:FindFirstChild("RobloxGui") then
                parentGui = cg
            end
        end)
    end
    if not parentGui and LocalPlayer then
        parentGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    end
    if not parentGui then
        return nil
    end

    local old = parentGui:FindFirstChild("YDX_TOF_ESP_Overlay")
    if old then
        pcall(function()
            old:Destroy()
        end)
    end

    local sg = Instance.new("ScreenGui")
    sg.Name = "YDX_TOF_ESP_Overlay"
    sg.IgnoreGuiInset = true
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 999985
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent = parentGui
    espScreenGui = sg
    return sg
end

local function destroyAllEspCards()
    for m, card in pairs(espCardsByModel) do
        if card.rootFrame then
            pcall(function()
                card.rootFrame:Destroy()
            end)
        end
        -- Restore native MCNametag if we hid it
        if m and m.Parent then
            local head = m:FindFirstChild("Head")
            local nativeTag = (head and head:FindFirstChild("MCNametag")) or m:FindFirstChild("MCNametag", true)
            if nativeTag and nativeTag:IsA("BillboardGui") then
                nativeTag.Enabled = true
            end
        end
        espCardsByModel[m] = nil
    end
    if espScreenGui then
        pcall(function()
            espScreenGui:Destroy()
        end)
        espScreenGui = nil
    end
end

local function createEspCardForModel(model, sg)
    local root = Instance.new("Frame")
    root.Name = "ESPCard_" .. tostring(model.Name)
    root.BackgroundTransparency = 1
    root.BorderSizePixel = 0
    root.Visible = false
    root.ZIndex = 10
    root.Parent = sg

    -- 1. Full 2D ESP Box (with dark outer stroke + colored inner stroke)
    local boxOuter = Instance.new("Frame")
    boxOuter.Name = "BoxOuter"
    boxOuter.BackgroundTransparency = 1
    boxOuter.Position = UDim2.fromOffset(-1, -1)
    boxOuter.Size = UDim2.new(1, 2, 1, 2)
    boxOuter.ZIndex = 11
    boxOuter.Parent = root
    local boxOuterStroke = Instance.new("UIStroke")
    boxOuterStroke.Color = Color3.new(0, 0, 0)
    boxOuterStroke.Thickness = 2.4
    boxOuterStroke.Transparency = 0.15
    boxOuterStroke.LineJoinMode = Enum.LineJoinMode.Miter
    boxOuterStroke.Parent = boxOuter

    local boxInner = Instance.new("Frame")
    boxInner.Name = "BoxInner"
    boxInner.BackgroundTransparency = 1
    boxInner.Size = UDim2.fromScale(1, 1)
    boxInner.ZIndex = 12
    boxInner.Parent = root
    local boxInnerStroke = Instance.new("UIStroke")
    boxInnerStroke.Color = Color3.fromRGB(0, 240, 155)
    boxInnerStroke.Thickness = 1.3
    boxInnerStroke.LineJoinMode = Enum.LineJoinMode.Miter
    boxInnerStroke.Parent = boxInner

    -- 2. ESP Corner Brackets (8 segments: TL_H, TL_V, TR_H, TR_V, BL_H, BL_V, BR_H, BR_V)
    local cornerFolder = Instance.new("Frame")
    cornerFolder.Name = "Corners"
    cornerFolder.BackgroundTransparency = 1
    cornerFolder.Size = UDim2.fromScale(1, 1)
    cornerFolder.ZIndex = 13
    cornerFolder.Parent = root

    local corners = {}
    local cornerSpecs = {
        { ax = 0, ay = 0, px = 0, py = 0, horiz = true },
        { ax = 0, ay = 0, px = 0, py = 0, horiz = false },
        { ax = 1, ay = 0, px = 1, py = 0, horiz = true },
        { ax = 1, ay = 0, px = 1, py = 0, horiz = false },
        { ax = 0, ay = 1, px = 0, py = 1, horiz = true },
        { ax = 0, ay = 1, px = 0, py = 1, horiz = false },
        { ax = 1, ay = 1, px = 1, py = 1, horiz = true },
        { ax = 1, ay = 1, px = 1, py = 1, horiz = false }
    }
    for idx, sp in ipairs(cornerSpecs) do
        local seg = Instance.new("Frame")
        seg.AnchorPoint = Vector2.new(sp.ax, sp.ay)
        seg.Position = UDim2.fromScale(sp.px, sp.py)
        seg.BackgroundColor3 = Color3.fromRGB(0, 245, 165)
        seg.BorderSizePixel = 1
        seg.BorderColor3 = Color3.new(0, 0, 0)
        seg.ZIndex = 14
        seg.Parent = cornerFolder
        corners[idx] = { frame = seg, horiz = sp.horiz }
    end

    -- 3. Left Vertical Health Bar
    local hpBarBg = Instance.new("Frame")
    hpBarBg.Name = "HPBarBg"
    hpBarBg.AnchorPoint = Vector2.new(1, 0)
    hpBarBg.Position = UDim2.new(0, -4, 0, 0)
    hpBarBg.Size = UDim2.new(0, 4, 1, 0)
    hpBarBg.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    hpBarBg.BackgroundTransparency = 0.15
    hpBarBg.BorderSizePixel = 1
    hpBarBg.BorderColor3 = Color3.new(0, 0, 0)
    hpBarBg.ZIndex = 13
    hpBarBg.Parent = root

    local hpBarFill = Instance.new("Frame")
    hpBarFill.Name = "Fill"
    hpBarFill.AnchorPoint = Vector2.new(0, 1)
    hpBarFill.Position = UDim2.fromScale(0, 1)
    hpBarFill.Size = UDim2.fromScale(1, 1)
    hpBarFill.BackgroundColor3 = Color3.fromRGB(50, 235, 100)
    hpBarFill.BorderSizePixel = 0
    hpBarFill.ZIndex = 14
    hpBarFill.Parent = hpBarBg

    -- 4. Scalable Nametag Header above ESP Box
    local tagHolder = Instance.new("Frame")
    tagHolder.Name = "NametagHolder"
    tagHolder.AnchorPoint = Vector2.new(0.5, 1)
    tagHolder.Position = UDim2.new(0.5, 0, 0, -6)
    tagHolder.Size = UDim2.fromOffset(170, 24)
    tagHolder.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
    tagHolder.BackgroundTransparency = 0.22
    tagHolder.BorderSizePixel = 0
    tagHolder.ZIndex = 16
    tagHolder.Parent = root

    local tagCorner = Instance.new("UICorner")
    tagCorner.CornerRadius = UDim.new(0, 4)
    tagCorner.Parent = tagHolder

    local tagStroke = Instance.new("UIStroke")
    tagStroke.Color = Color3.fromRGB(0, 0, 0)
    tagStroke.Thickness = 1.2
    tagStroke.Transparency = 0.25
    tagStroke.Parent = tagHolder

    local tagScale = Instance.new("UIScale")
    tagScale.Scale = 1.45
    tagScale.Parent = tagHolder

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.fromOffset(5, 0)
    nameLabel.Size = UDim2.new(1, -10, 1, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0.15
    nameLabel.RichText = true
    nameLabel.Text = ""
    nameLabel.ZIndex = 17
    nameLabel.Parent = tagHolder

    -- 5. 9-Slot Hotbar Strip (+1 Armor Square on Left) below ESP Box!
    local hotbarFrame = Instance.new("Frame")
    hotbarFrame.Name = "Hotbar9Slots"
    hotbarFrame.AnchorPoint = Vector2.new(0.5, 0)
    hotbarFrame.Position = UDim2.new(0.5, 0, 1, 5)
    hotbarFrame.Size = UDim2.fromOffset(9 * 20 + 24, 22)
    hotbarFrame.BackgroundColor3 = Color3.fromRGB(16, 18, 24)
    hotbarFrame.BackgroundTransparency = 0.18
    hotbarFrame.BorderSizePixel = 0
    hotbarFrame.ZIndex = 16
    hotbarFrame.Parent = root

    local hbCorner = Instance.new("UICorner")
    hbCorner.CornerRadius = UDim.new(0, 4)
    hbCorner.Parent = hotbarFrame

    local hbStroke = Instance.new("UIStroke")
    hbStroke.Color = Color3.fromRGB(0, 0, 0)
    hbStroke.Thickness = 1.2
    hbStroke.Transparency = 0.2
    hbStroke.Parent = hotbarFrame

    local hbScale = Instance.new("UIScale")
    hbScale.Scale = 1.05
    hbScale.Parent = hotbarFrame

    local function makeHotbarSquare(parent, xOffset, isArmor)
        local sq = Instance.new("Frame")
        sq.Position = UDim2.fromOffset(xOffset, 2)
        sq.Size = UDim2.fromOffset(18, 18)
        sq.BackgroundColor3 = isArmor and Color3.fromRGB(36, 44, 62) or Color3.fromRGB(48, 50, 58)
        sq.BackgroundTransparency = 0.1
        sq.BorderSizePixel = 0
        sq.ZIndex = 17
        sq.Parent = parent

        local sqCorner = Instance.new("UICorner")
        sqCorner.CornerRadius = UDim.new(0, 3)
        sqCorner.Parent = sq

        local sqStroke = Instance.new("UIStroke")
        sqStroke.Color = isArmor and Color3.fromRGB(90, 170, 255) or Color3.fromRGB(82, 86, 98)
        sqStroke.Thickness = 1.1
        sqStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        sqStroke.Parent = sq

        local itemHolder = Instance.new("Frame")
        itemHolder.Name = "ItemHolder"
        itemHolder.BackgroundTransparency = 1
        itemHolder.Position = UDim2.fromOffset(1, 1)
        itemHolder.Size = UDim2.new(1, -2, 1, -2)
        itemHolder.ZIndex = 18
        itemHolder.Parent = sq

        return {
            frame = sq,
            itemHolder = itemHolder,
            stroke = sqStroke,
            lastItemId = nil,
            lastWool = nil
        }
    end

    local armorSlot = makeHotbarSquare(hotbarFrame, 2, true)
    local slots = {}
    for s = 1, 9 do
        slots[s] = makeHotbarSquare(hotbarFrame, 22 + (s - 1) * 20, false)
    end

    local card = {
        rootFrame = root,
        boxOuter = boxOuter,
        boxInner = boxInner,
        boxInnerStroke = boxInnerStroke,
        cornerFolder = cornerFolder,
        corners = corners,
        hpBarBg = hpBarBg,
        hpBarFill = hpBarFill,
        tagHolder = tagHolder,
        tagScale = tagScale,
        nameLabel = nameLabel,
        hotbarFrame = hotbarFrame,
        hbScale = hbScale,
        armorSlot = armorSlot,
        slots = slots
    }
    espCardsByModel[model] = card
    return card
end

local function stepEspRender()
    if not VapeConfig.ESP.enabled then
        if espScreenGui then
            destroyAllEspCards()
        end
        return
    end
    local cam = workspace.CurrentCamera
    if not cam then
        return
    end
    local sg = ensureEspScreenGui()
    if not sg then
        return
    end

    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myPos = (myHrp and myHrp.Position) or cam.CFrame.Position

    local fighters = getValidFighters(VapeConfig.ESP.inLobby)
    local activeModels = {}

    local themeColor = Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value)

    for _, entry in ipairs(fighters) do
        if not entry.isBot or VapeConfig.ESP.showBots then
            local model = entry.model
            local hrp = entry.hrp
            local hum = entry.hum
            activeModels[model] = true

            -- Always track enemy held items into their 9-slot hotbar state
            local hotbarTracker = updateEnemySeenHotbar(model)

            -- Project 3D character bounding box to 2D viewport coordinates
            local pos = hrp.Position
            local topWorld = pos + Vector3.new(0, 2.85, 0)
            local botWorld = pos - Vector3.new(0, 2.85, 0)
            local topVp, topOnScreen = cam:WorldToViewportPoint(topWorld)
            local botVp, botOnScreen = cam:WorldToViewportPoint(botWorld)
            local centerVp, centerOnScreen = cam:WorldToViewportPoint(pos)

            local card = espCardsByModel[model] or createEspCardForModel(model, sg)

            -- Manage native MCNametag visibility when our custom large ESP Nametags are enabled
            local head = model:FindFirstChild("Head")
            local nativeTag = (head and head:FindFirstChild("MCNametag")) or model:FindFirstChild("MCNametag", true)
            if nativeTag and nativeTag:IsA("BillboardGui") then
                nativeTag.Enabled = not VapeConfig.ESP.nametags
            end

            if (topOnScreen or botOnScreen or centerOnScreen) and centerVp.Z > 0.5 then
                local boxH = math.clamp(math.abs(botVp.Y - topVp.Y), 18, 900)
                local boxW = math.clamp(boxH * 0.58, 12, 540)
                local boxX = centerVp.X - boxW * 0.5
                local boxY = math.min(topVp.Y, botVp.Y)

                card.rootFrame.Position = UDim2.fromOffset(math.floor(boxX + 0.5), math.floor(boxY + 0.5))
                card.rootFrame.Size = UDim2.fromOffset(math.floor(boxW + 0.5), math.floor(boxH + 0.5))
                card.rootFrame.Visible = true

                -- 1. ESP Box
                local showBox = VapeConfig.ESP.box == true
                card.boxOuter.Visible = showBox
                card.boxInner.Visible = showBox
                card.boxInnerStroke.Color = themeColor

                -- 2. ESP Corner
                local showCorner = VapeConfig.ESP.corner == true
                card.cornerFolder.Visible = showCorner
                if showCorner then
                    local cLen = math.clamp(math.floor(math.min(boxW, boxH) * 0.26), 4, 22)
                    local cThick = 2
                    for _, segInfo in ipairs(card.corners) do
                        segInfo.frame.BackgroundColor3 = themeColor
                        if segInfo.horiz then
                            segInfo.frame.Size = UDim2.fromOffset(cLen, cThick)
                        else
                            segInfo.frame.Size = UDim2.fromOffset(cThick, cLen)
                        end
                    end
                end

                -- 3. Health Bar & HP calculation
                local hp = (hum and hum.Health) or 20
                local maxHp = (hum and hum.MaxHealth > 0 and hum.MaxHealth) or 20
                local absorp = tonumber(model:GetAttribute("Absorption")) or 0
                local hpPct = math.clamp(hp / maxHp, 0, 1)
                local hpColor = Color3.fromHSV(math.clamp(hpPct * 0.33, 0, 0.33), 0.9, 0.95)
                card.hpBarBg.Visible = (showBox or showCorner)
                card.hpBarFill.Size = UDim2.fromScale(1, hpPct)
                card.hpBarFill.BackgroundColor3 = hpColor

                -- 4. ESP Nametags (with Nametag Scale slider!)
                local showNametag = VapeConfig.ESP.nametags == true
                card.tagHolder.Visible = showNametag
                if showNametag then
                    local nScale = math.clamp(tonumber(VapeConfig.ESP.nametagScale) or 1.45, 0.8, 3.0)
                    card.tagScale.Scale = nScale
                    local distBlocks = math.floor((pos - myPos).Magnitude / BLOCK_SIZE + 0.5)
                    local hpDisp = math.ceil(hp)
                    local absStr = (absorp > 0) and string.format(" <font color='#FFD94A'>+%d</font>", math.ceil(absorp)) or ""
                    local hpHex = string.format("#%02X%02X%02X", math.floor(hpColor.R * 255), math.floor(hpColor.G * 255), math.floor(hpColor.B * 255))
                    local tagText = string.format(
                        "%s <font color='%s'>%d HP</font>%s <font color='#9AA8C7'>[%dm]</font>",
                        entry.name,
                        hpHex,
                        hpDisp,
                        absStr,
                        distBlocks
                    )
                    card.nameLabel.Text = tagText
                    local boundsX = card.nameLabel.TextBounds.X
                    if boundsX > 0 then
                        card.tagHolder.Size = UDim2.fromOffset(math.clamp(boundsX + 16, 90, 340), 22)
                    end
                end

                -- 5. ESP Items (9-Slot Hotbar Strip + Equipped Armor Square!)
                local showItems = VapeConfig.ESP.itemsBar == true
                card.hotbarFrame.Visible = showItems
                if showItems then
                    local iScale = math.clamp(tonumber(VapeConfig.ESP.itemsScale) or 1.05, 0.7, 2.0)
                    card.hbScale.Scale = iScale

                    -- Equipped Armor square on left
                    local armorId = model:GetAttribute("Armor")
                    if type(armorId) ~= "string" then
                        armorId = ""
                    end
                    if card.armorSlot.lastItemId ~= armorId then
                        card.armorSlot.lastItemId = armorId
                        renderItemIntoEspSlot(card.armorSlot.itemHolder, armorId, nil, 16)
                    end

                    -- 9 Hotbar squares
                    for s = 1, 9 do
                        local slotUi = card.slots[s]
                        local slotData = hotbarTracker.slots[s]
                        local itemId = (slotData and slotData.id) or ""
                        local woolCol = (slotData and slotData.wool) or ""

                        if slotUi.lastItemId ~= itemId or slotUi.lastWool ~= woolCol then
                            slotUi.lastItemId = itemId
                            slotUi.lastWool = woolCol
                            renderItemIntoEspSlot(slotUi.itemHolder, itemId, woolCol, 16)
                        end

                        if hotbarTracker.activeSlot == s and itemId ~= "" then
                            slotUi.stroke.Color = Color3.fromRGB(255, 215, 55)
                            slotUi.stroke.Thickness = 1.8
                            slotUi.frame.BackgroundColor3 = Color3.fromRGB(72, 66, 42)
                        else
                            slotUi.stroke.Color = Color3.fromRGB(82, 86, 98)
                            slotUi.stroke.Thickness = 1.1
                            slotUi.frame.BackgroundColor3 = Color3.fromRGB(48, 50, 58)
                        end
                    end
                end
            else
                card.rootFrame.Visible = false
            end
        end
    end

    -- Cleanup cards for models that left or died
    for m, card in pairs(espCardsByModel) do
        if not activeModels[m] then
            if card.rootFrame then
                pcall(function()
                    card.rootFrame:Destroy()
                end)
            end
            if m and m.Parent then
                local head = m:FindFirstChild("Head")
                local nativeTag = (head and head:FindFirstChild("MCNametag")) or m:FindFirstChild("MCNametag", true)
                if nativeTag and nativeTag:IsA("BillboardGui") then
                    nativeTag.Enabled = true
                end
            end
            espCardsByModel[m] = nil
        end
    end
end

-- ============================================================================
-- SCAFFOLD & FAST PLACE ENGINE
-- ============================================================================
local scaffoldBaseY = nil
local lastScaffoldPlace = 0
local lastFastPlaceTime = 0

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

local function stepFastPlace()
    if not VapeConfig.FastPlace.enabled then
        return
    end
    if not canPlayerActInGame() then
        return
    end
    if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        return
    end

    local heldId, heldDef = getHeldItemDef()
    if not heldId or not heldDef then
        return
    end

    local now = os.clock()
    local delaySec = 1 / math.clamp(tonumber(VapeConfig.FastPlace.cps) or 25, 5, 60)
    if now - lastFastPlaceTime < delaySec then
        return
    end

    if heldDef.kind == "block" then
        if BlocksMod and type(BlocksMod.setHeld) == "function" and Hud and type(Hud.state) == "table" then
            pcall(BlocksMod.setHeld, heldId, Hud.state.wool)
        end
        if BlocksMod and type(BlocksMod.update) == "function" then
            pcall(BlocksMod.update, true)
        end
        if BlocksMod and type(BlocksMod.tryPlace) == "function" then
            local ok, placed = pcall(BlocksMod.tryPlace)
            if ok and placed then
                lastFastPlaceTime = now
                if ViewmodelMod and type(ViewmodelMod.swing) == "function" then
                    pcall(ViewmodelMod.swing)
                end
                if Chars and type(Chars.swing) == "function" and LocalPlayer.Character then
                    pcall(Chars.swing, LocalPlayer.Character)
                end
            end
        end
    elseif heldDef.kind == "throw" then
        lastFastPlaceTime = now
        if heldId == "wind_charge" then
            lastSelfWindChargeThrowTime = now
        end
        if ViewmodelMod and type(ViewmodelMod.swing) == "function" then
            pcall(ViewmodelMod.swing)
        end
        if Chars and type(Chars.swing) == "function" and LocalPlayer.Character then
            pcall(Chars.swing, LocalPlayer.Character)
        end
        if ActionRemote then
            pcall(function()
                ActionRemote:FireServer("use", getCameraLook(), getFeetBlockPos())
            end)
        end
    end
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
    local hasBox = false
    pcall(function()
        hasBox = UserInputService:GetFocusedTextBox() ~= nil
    end)
    local jumping = UserInputService:IsKeyDown(Enum.KeyCode.Space) and not hasBox

    if VapeConfig.Scaffold.keepY then
        if not scaffoldBaseY or (MovementMod and MovementMod.onGround and not jumping) then
            scaffoldBaseY = underY
        end
    else
        scaffoldBaseY = underY
    end

    local targetY = (VapeConfig.Scaffold.keepY and not (VapeConfig.Scaffold.tower and jumping)) and (scaffoldBaseY or underY) or underY

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
                for _, off in ipairs(CARDINAL_OFFSETS) do
                    local support = cell + off
                    if canPlaceScaffoldCell(support, feet) and cellTouchesSolid(support) then
                        if placeScaffoldBlockAt(support) then
                            lastScaffoldPlace = now
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
-- KILL AURA, AUTO CLICKER (LEFT) & AIM ASSIST ENGINE
-- ============================================================================
local lastKillAuraSwing = 0
local lastAutoClickerSwing = 0
local currentAuraTarget = nil
local targetInfoEntities = {}

local function pushTargetToVapeTargetInfo(target)
    if not target or not vape or not vape.Libraries or not vape.Libraries.targetinfo then
        return
    end
    local tInfo = vape.Libraries.targetinfo
    local key = target.model
    local entry = targetInfoEntities[key]
    if not entry then
        entry = {}
        targetInfoEntities[key] = entry
    end
    entry.Player = target.player
    entry.Character = target.model
    entry.Health = (target.hum and target.hum.Health) or 20
    entry.MaxHealth = (target.hum and target.hum.MaxHealth) or 20
    tInfo.Targets[entry] = os.clock() + 1.0
end

local function getWeaponCooldownSeconds()
    local _, def = getHeldItemDef()
    local spd = (def and tonumber(def.speed)) or 4.0
    local ticksNeeded = (20 / spd) * 0.92 - 0.5
    return math.max(0.18, ticksNeeded / 20)
end

-- Exact raycast target solver matching PoFClient.targetCharacter() (plus Backtrack rewind support!)
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

local function getCrosshairTargetCharacter()
    local myChar = LocalPlayer.Character
    if not myChar then
        return nil
    end
    local eye = getEyePosition()
    local eyeBlocks = eye / BLOCK_SIZE
    local look = getCameraLook()
    local reach = (Config and tonumber(Config.REACH)) or 3.5
    if VapeConfig.Backtrack.enabled then
        reach = math.max(reach, 4.15)
    end

    rayParams.FilterDescendantsInstances = {
        myChar,
        workspace:FindFirstChild("Drops"),
        workspace:FindFirstChild("Bots")
    }
    local mapHit = workspace:Raycast(eye, look * reach * BLOCK_SIZE, rayParams)
    if mapHit and mapHit.Instance and mapHit.Instance:IsDescendantOf(workspace:FindFirstChild("Map") or workspace) then
        reach = math.min(reach, (mapHit.Position - eye).Magnitude / BLOCK_SIZE)
    end

    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    local myPos = (myHrp and myHrp.Position) or eye
    local bestT = math.huge
    local bestEntry = nil

    for _, entry in ipairs(getValidFighters(true)) do
        local btPos, _, _, _ = getBacktrackedPositionForFighter(entry, eye, myPos)
        for _, candidatePos in ipairs({ entry.hrp.Position, btPos }) do
            local feetBlocks = (candidatePos - Vector3.new(0, 2.7, 0)) / BLOCK_SIZE
            local h = entry.model:GetAttribute("Sneaking") and 1.5 or 1.8
            local bMin = feetBlocks - Vector3.new(0.4, 0.1, 0.4)
            local bMax = feetBlocks + Vector3.new(0.4, h + 0.1, 0.4)
            local inside = (eyeBlocks.X >= bMin.X and eyeBlocks.X <= bMax.X and eyeBlocks.Y >= bMin.Y and eyeBlocks.Y <= bMax.Y and eyeBlocks.Z >= bMin.Z and eyeBlocks.Z <= bMax.Z)
            local hitT = inside and 0 or rayBoxIntersect(eyeBlocks, look, bMin, bMax, reach)
            if hitT and hitT < bestT then
                bestT = hitT
                bestEntry = entry
            end
        end
    end

    return bestEntry
end

local function stepAutoClicker()
    if not VapeConfig.AutoClicker.enabled then
        return
    end
    if not canPlayerActInGame() then
        return
    end
    if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        return
    end
    if Chars and (Chars.localUsing == "eat" or Chars.localUsing == "drink") then
        return
    end
    if VapeConfig.AutoClicker.requireWeapon and not isHoldingSwordOrMace() then
        return
    end
    -- Don't interrupt block digging if looking at a breakable block with no enemy in crosshair
    local targetEntry = getCrosshairTargetCharacter()
    if not targetEntry and BlocksMod and BlocksMod.digging then
        return
    end

    local now = os.clock()
    local delaySec = 0.625
    if VapeConfig.AutoClicker.mode == "Spam CPS" then
        local cps = math.clamp(tonumber(VapeConfig.AutoClicker.cps) or 14, 1, 25)
        delaySec = 1 / cps
    else
        delaySec = getWeaponCooldownSeconds()
    end

    if now - lastAutoClickerSwing < delaySec then
        return
    end

    -- If looking at a breakable block and no fighter is in crosshair, start digging
    if not targetEntry and VapeConfig.AutoClicker.breakBlocks and BlocksMod and type(BlocksMod.canBreakTarget) == "function" and BlocksMod.canBreakTarget() then
        if type(BlocksMod.startDig) == "function" and BlocksMod.startDig() then
            lastAutoClickerSwing = now
            if ViewmodelMod and type(ViewmodelMod.swing) == "function" then
                pcall(ViewmodelMod.swing)
            end
            if Chars and type(Chars.swing) == "function" and LocalPlayer.Character then
                pcall(Chars.swing, LocalPlayer.Character)
            end
            return
        end
    end

    lastAutoClickerSwing = now

    if Hud then
        Hud.swingStart = now
    end
    if ViewmodelMod and type(ViewmodelMod.swing) == "function" then
        pcall(ViewmodelMod.swing)
    end
    if Chars and type(Chars.swing) == "function" and LocalPlayer.Character then
        pcall(Chars.swing, LocalPlayer.Character)
    end

    local look = getCameraLook()
    local sprintFlag = (MovementMod and MovementMod.freshSprint) or false

    if targetEntry then
        pushTargetToVapeTargetInfo(targetEntry)
        if VapeConfig.FakeLag.enabled and VapeConfig.FakeLag.flushOnAttack then
            flushFakeLagPackets(true)
        end
        if ActionRemote then
            pcall(function()
                ActionRemote:FireServer("attack", targetEntry.model, look, sprintFlag)
            end)
        end
    else
        if ActionRemote then
            pcall(function()
                ActionRemote:FireServer("swing", nil, look, sprintFlag)
            end)
        end
    end
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

    pushTargetToVapeTargetInfo(target)

    if VapeConfig.KillAura.autoWeapon and not VapeConfig.Scaffold.enabled then
        local bestSlot = findBestWeaponSlot()
        if bestSlot then
            selectHotbarSlot(bestSlot)
        end
    end

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

    if VapeConfig.FakeLag.enabled and VapeConfig.FakeLag.flushOnAttack then
        flushFakeLagPackets(true)
    end

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
    -- Require Sword / Mace check so it NEVER pulls camera while bridging / holding blocks!
    if VapeConfig.AimAssist.requireWeapon and not isHoldingSwordOrMace() then
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

    pushTargetToVapeTargetInfo(target)

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
-- REGISTER MODULES IN OFFICIAL VAPE V4 CATEGORIES (Combat, Blatant, World)
-- ============================================================================
do
    -- 1. AimAssist (Combat)
    local AimAssistMod = vape.Categories.Combat:CreateModule({
        Name = "AimAssist",
        Tooltip = "Smoothly aims camera toward the nearest fighter (Require Sword/Mace prevents pulling while bridging)",
        ExtraText = function()
            return string.format("%d", math.floor(tonumber(VapeConfig.AimAssist.fov) or 95))
        end,
        Function = function(callback)
            VapeConfig.AimAssist.enabled = callback
        end
    })
    AimAssistMod:CreateToggle({
        Name = "Require Sword/Mace",
        Tooltip = "Only assists aim when holding a Sword, Mace or Knockback Stick (stops pulling while bridging with blocks)",
        Default = true,
        Function = function(val)
            VapeConfig.AimAssist.requireWeapon = val
        end
    })
    AimAssistMod:CreateToggle({
        Name = "Click Only",
        Tooltip = "Only assists aim while holding Left Click",
        Default = false,
        Function = function(val)
            VapeConfig.AimAssist.clickOnly = val
        end
    })
    AimAssistMod:CreateSlider({
        Name = "Range",
        Min = 3,
        Max = 10,
        Default = 6.5,
        Decimal = 10,
        Suffix = "m",
        Function = function(val)
            VapeConfig.AimAssist.range = val
        end
    })
    AimAssistMod:CreateSlider({
        Name = "FOV",
        Min = 15,
        Max = 180,
        Default = 95,
        Decimal = 1,
        Suffix = "deg",
        Function = function(val)
            VapeConfig.AimAssist.fov = val
            vape:UpdateTextGUI()
        end
    })
    AimAssistMod:CreateSlider({
        Name = "Smooth Speed",
        Min = 2,
        Max = 25,
        Default = 11,
        Decimal = 1,
        Function = function(val)
            VapeConfig.AimAssist.speed = val
        end
    })
    AimAssistMod:CreateToggle({
        Name = "Active in Lobby",
        Tooltip = "Allow AimAssist to target characters in the lobby",
        Default = false,
        Function = function(val)
            VapeConfig.AimAssist.inLobby = val
        end
    })

    -- 2. AutoClicker (Combat)
    local AutoClickerMod = vape.Categories.Combat:CreateModule({
        Name = "AutoClicker",
        Tooltip = "Hold Left-Click to automatically attack at 1.9+ full crit cooldown or high CPS",
        ExtraText = function()
            return VapeConfig.AutoClicker.mode == "1.9+ Cooldown" and "Cooldown" or (tostring(VapeConfig.AutoClicker.cps) .. " CPS")
        end,
        Function = function(callback)
            VapeConfig.AutoClicker.enabled = callback
        end
    })
    AutoClickerMod:CreateDropdown({
        Name = "Mode",
        List = { "1.9+ Cooldown", "Spam CPS" },
        Function = function(val)
            VapeConfig.AutoClicker.mode = val
            vape:UpdateTextGUI()
        end
    })
    AutoClickerMod:CreateSlider({
        Name = "CPS",
        Min = 4,
        Max = 25,
        Default = 14,
        Decimal = 1,
        Function = function(val)
            VapeConfig.AutoClicker.cps = val
            vape:UpdateTextGUI()
        end
    })
    AutoClickerMod:CreateToggle({
        Name = "Require Sword/Mace",
        Tooltip = "Only auto-clicks when holding a Sword, Mace or Knockback Stick",
        Default = false,
        Function = function(val)
            VapeConfig.AutoClicker.requireWeapon = val
        end
    })
    AutoClickerMod:CreateToggle({
        Name = "Break Blocks",
        Tooltip = "Allows mining blocks normally when holding Left-Click on a block",
        Default = true,
        Function = function(val)
            VapeConfig.AutoClicker.breakBlocks = val
        end
    })

    -- 3. Backtrack (Combat)
    local BacktrackMod = vape.Categories.Combat:CreateModule({
        Name = "Backtrack",
        Tooltip = "Rewinds enemy hitboxes up to 450ms into the past so you can hit retreating targets from further away",
        ExtraText = function()
            return tostring(math.floor(tonumber(VapeConfig.Backtrack.delayMs) or 250)) .. "ms"
        end,
        Function = function(callback)
            VapeConfig.Backtrack.enabled = callback
            if not callback then
                clearBacktrackGhost()
            end
        end
    })
    BacktrackMod:CreateSlider({
        Name = "Delay",
        Min = 50,
        Max = 450,
        Default = 250,
        Decimal = 1,
        Suffix = "ms",
        Function = function(val)
            VapeConfig.Backtrack.delayMs = val
            vape:UpdateTextGUI()
        end
    })
    BacktrackMod:CreateSlider({
        Name = "Max Range",
        Min = 3.5,
        Max = 8.0,
        Default = 6.5,
        Decimal = 10,
        Suffix = "m",
        Function = function(val)
            VapeConfig.Backtrack.maxRange = val
        end
    })
    BacktrackMod:CreateToggle({
        Name = "Show Ghost Box",
        Tooltip = "Renders a translucent neon box at the enemy's backtracked hitbox position",
        Default = true,
        Function = function(val)
            VapeConfig.Backtrack.showGhost = val
            if not val then
                updateBacktrackGhost(nil, false)
            end
        end
    })

    -- 4. KillAura (Combat)
    local KillAuraMod = vape.Categories.Combat:CreateModule({
        Name = "KillAura",
        Tooltip = "Automatically attacks enemies in reach with 20Hz silent rotation and 1.9+ crit timing",
        ExtraText = function()
            return VapeConfig.KillAura.mode == "1.9+ Cooldown" and "Cooldown" or (tostring(VapeConfig.KillAura.cps) .. " CPS")
        end,
        Function = function(callback)
            VapeConfig.KillAura.enabled = callback
            if not callback then
                currentAuraTarget = nil
            end
        end
    })
    KillAuraMod:CreateDropdown({
        Name = "Attack Mode",
        List = { "1.9+ Cooldown", "Spam CPS" },
        Function = function(val)
            VapeConfig.KillAura.mode = val
            vape:UpdateTextGUI()
        end
    })
    KillAuraMod:CreateSlider({
        Name = "Reach",
        Min = 3,
        Max = 4.8,
        Default = 4.2,
        Decimal = 10,
        Suffix = "m",
        Function = function(val)
            VapeConfig.KillAura.range = val
        end
    })
    KillAuraMod:CreateSlider({
        Name = "Max Angle",
        Min = 45,
        Max = 360,
        Default = 360,
        Decimal = 1,
        Suffix = "deg",
        Function = function(val)
            VapeConfig.KillAura.fov = val
        end
    })
    KillAuraMod:CreateSlider({
        Name = "CPS",
        Min = 4,
        Max = 20,
        Default = 12,
        Decimal = 1,
        Function = function(val)
            VapeConfig.KillAura.cps = val
            vape:UpdateTextGUI()
        end
    })
    KillAuraMod:CreateToggle({
        Name = "Auto Switch Weapon",
        Tooltip = "Automatically switches to your best Sword or Mace when an enemy enters reach",
        Default = true,
        Function = function(val)
            VapeConfig.KillAura.autoWeapon = val
        end
    })
    KillAuraMod:CreateToggle({
        Name = "Force Sprint Knockback",
        Tooltip = "Sends sprint flag on every hit for maximum knockback",
        Default = true,
        Function = function(val)
            VapeConfig.KillAura.autoCritSprint = val
        end
    })
    KillAuraMod:CreateToggle({
        Name = "Active in Lobby",
        Default = false,
        Function = function(val)
            VapeConfig.KillAura.inLobby = val
        end
    })

    -- 5. FakeLag (Blatant)
    local FakeLagMod = vape.Categories.Blatant:CreateModule({
        Name = "FakeLag",
        Tooltip = "Chokes or delays 20Hz position packets so you appear laggy/teleporting to other players",
        ExtraText = function()
            return tostring(math.floor(tonumber(VapeConfig.FakeLag.chokeMs) or 300)) .. "ms"
        end,
        Function = function(callback)
            VapeConfig.FakeLag.enabled = callback
            if not callback then
                flushFakeLagPackets(true)
                clearFakeLagGhost()
            end
        end
    })
    FakeLagMod:CreateDropdown({
        Name = "Mode",
        List = { "Blink Pulse", "Latency Queue" },
        Tooltip = "Blink Pulse: freezes your character on enemy screens then teleports\nLatency Queue: delays all packets by Choke ms",
        Function = function(val)
            VapeConfig.FakeLag.mode = val
        end
    })
    FakeLagMod:CreateSlider({
        Name = "Choke Time",
        Min = 100,
        Max = 650,
        Default = 300,
        Decimal = 1,
        Suffix = "ms",
        Function = function(val)
            VapeConfig.FakeLag.chokeMs = val
            vape:UpdateTextGUI()
        end
    })
    FakeLagMod:CreateToggle({
        Name = "Flush on Attack",
        Tooltip = "Immediately syncs your position when you attack so your hits always register full reach",
        Default = true,
        Function = function(val)
            VapeConfig.FakeLag.flushOnAttack = val
        end
    })
    FakeLagMod:CreateToggle({
        Name = "Show Server Ghost",
        Tooltip = "Shows a blue neon ghost where other players currently see your lagged character",
        Default = true,
        Function = function(val)
            VapeConfig.FakeLag.showServerGhost = val
            if not val then
                updateFakeLagGhost(nil, false)
            end
        end
    })

    -- 6. Fly (AirWalk) (Blatant)
    local FlyMod = vape.Categories.Blatant:CreateModule({
        Name = "Fly",
        Tooltip = "Walk and jump on thin air using a real local voxel collision platform (AirWalk with Anti-Rollback)",
        ExtraText = function()
            return VapeConfig.Fly.mode
        end,
        Function = function(callback)
            VapeConfig.Fly.enabled = callback
            if callback then
                local f = getFeetBlockPos()
                airWalkY = f and (math.floor(f.Y * 16 + 0.5) / 16) or nil
            else
                airWalkY = nil
                clearAirWalkPlatform()
            end
        end
    })
    FlyMod:CreateDropdown({
        Name = "Mode",
        List = { "AirWalk", "StepUp" },
        Function = function(val)
            VapeConfig.Fly.mode = val
            vape:UpdateTextGUI()
        end
    })
    FlyMod:CreateToggle({
        Name = "Anti Rollback",
        Tooltip = "Uses a real MCLocal collision platform + server ground pulsing & void speed regulation to prevent server lagbacks",
        Default = true,
        Function = function(val)
            VapeConfig.Fly.antiRollback = val
        end
    })
    FlyMod:CreateToggle({
        Name = "Sneak to Descend",
        Tooltip = "Hold LeftShift (Sneak) to walk downward in the air",
        Default = true,
        Function = function(val)
            VapeConfig.Fly.sneakDown = val
        end
    })
    FlyMod:CreateToggle({
        Name = "Auto Sprint on Air",
        Default = true,
        Function = function(val)
            VapeConfig.Fly.autoSprint = val
        end
    })

    -- 7. NoFall (Blatant) - Enabled by default for guaranteed 0 fall damage!
    local NoFallMod = vape.Categories.Blatant:CreateModule({
        Name = "NoFall",
        Default = true,
        Tooltip = "100% 0 Fall Damage: zeroes fallDistance, spoofs ground state, and injects 1.66-block step-down ground packets on high falls & after AutoMace slams",
        ExtraText = function()
            return "0 DMG"
        end,
        Function = function(callback)
            VapeConfig.NoFall.enabled = callback
        end
    })
    NoFallMod:CreateDropdown({
        Name = "Mode",
        List = { "Spoof Ground", "Pre-Land Spoof" },
        Tooltip = "Both modes use multi-step ground packet segmentation so you take 0 fall damage from any height",
        Function = function(val)
            VapeConfig.NoFall.mode = val
            vape:UpdateTextGUI()
        end
    })

    -- 8. ThirdPerson (Render)
    local ThirdPersonMod = vape.Categories.Render:CreateModule({
        Name = "ThirdPerson",
        Tooltip = "Unlocks Third Person camera view inside rounds with customizable camera distance (also toggleable with V / F5)",
        ExtraText = function()
            return string.format("%.1fm", tonumber(VapeConfig.ThirdPerson.distance) or 4.5)
        end,
        Function = function(callback)
            VapeConfig.ThirdPerson.enabled = callback
            if CameraMod then
                if callback then
                    CameraMod.mode = (VapeConfig.ThirdPerson.view == "Front (3rd)") and 3 or 2
                    applyThirdPersonState()
                else
                    CameraMod.forceThird = false
                    CameraMod.mode = 1
                end
            end
        end
    })
    ThirdPersonMod:CreateDropdown({
        Name = "View Mode",
        List = { "Back (2nd)", "Front (3rd)" },
        Function = function(val)
            VapeConfig.ThirdPerson.view = val
            if VapeConfig.ThirdPerson.enabled and CameraMod then
                CameraMod.mode = (val == "Front (3rd)") and 3 or 2
            end
        end
    })
    ThirdPersonMod:CreateSlider({
        Name = "Distance",
        Min = 2,
        Max = 14,
        Default = 4.5,
        Decimal = 10,
        Suffix = "m",
        Function = function(val)
            VapeConfig.ThirdPerson.distance = val
            applyThirdPersonState()
            vape:UpdateTextGUI()
        end
    })
    ThirdPersonMod:CreateToggle({
        Name = "Ctrl+Scroll Zoom",
        Tooltip = "Hold LeftCtrl or LeftAlt and scroll the mouse wheel to zoom Third Person distance in/out mid-game",
        Default = true,
        Function = function(val)
            VapeConfig.ThirdPerson.freeZoom = val
        end
    })

    -- 7. FastPlace (World)
    local FastPlaceMod = vape.Categories.World:CreateModule({
        Name = "FastPlace",
        Tooltip = "Removes the 0.20s right-click placement delay so you can place blocks & throw items at high speed",
        ExtraText = function()
            return tostring(math.floor(tonumber(VapeConfig.FastPlace.cps) or 25)) .. " CPS"
        end,
        Function = function(callback)
            VapeConfig.FastPlace.enabled = callback
        end
    })
    FastPlaceMod:CreateSlider({
        Name = "Place Speed",
        Min = 10,
        Max = 60,
        Default = 25,
        Decimal = 1,
        Suffix = "CPS",
        Function = function(val)
            VapeConfig.FastPlace.cps = val
            vape:UpdateTextGUI()
        end
    })

    -- 8. Scaffold (World)
    local ScaffoldMod = vape.Categories.World:CreateModule({
        Name = "Scaffold",
        Tooltip = "Automatically places blocks underneath your feet with diagonal support & instant client ghost blocks",
        ExtraText = function()
            return VapeConfig.Scaffold.keepY and "KeepY" or "Normal"
        end,
        Function = function(callback)
            VapeConfig.Scaffold.enabled = callback
            if callback then
                local f = getFeetBlockPos()
                scaffoldBaseY = f and math.floor(f.Y - 0.01) or nil
            else
                scaffoldBaseY = nil
            end
        end
    })
    ScaffoldMod:CreateToggle({
        Name = "Auto Select Block",
        Tooltip = "Automatically selects a solid block slot in your hotbar",
        Default = true,
        Function = function(val)
            VapeConfig.Scaffold.autoBlock = val
        end
    })
    ScaffoldMod:CreateSlider({
        Name = "Expand",
        Min = 1,
        Max = 3,
        Default = 1,
        Decimal = 1,
        Suffix = "blocks",
        Function = function(val)
            VapeConfig.Scaffold.expand = val
        end
    })
    ScaffoldMod:CreateToggle({
        Name = "Keep Y",
        Tooltip = "Keeps bridge at the same Y height while sprint-jumping",
        Default = false,
        Function = function(val)
            VapeConfig.Scaffold.keepY = val
            vape:UpdateTextGUI()
        end
    })
    ScaffoldMod:CreateToggle({
        Name = "Tower",
        Tooltip = "Builds upward rapidly when holding Space while standing still",
        Default = true,
        Function = function(val)
            VapeConfig.Scaffold.tower = val
        end
    })

    -- 9. AutoMace (Combat)
    local AutoMaceMod
    AutoMaceMod = vape.Categories.Combat:CreateModule({
        Name = "AutoMace",
        Tooltip = "Bind a key: launches you several blocks into the air and auto-slams enemies on descent for massive Mace Smash damage!",
        ExtraText = function()
            return tostring(math.floor(tonumber(VapeConfig.AutoMace.height) or 9)) .. "m"
        end,
        Function = function(callback)
            VapeConfig.AutoMace.enabled = callback
            if callback then
                task.spawn(triggerAutoMaceLaunch)
                -- Auto-untoggle after firing so each press of the keybind triggers a fresh launch!
                task.delay(0.08, function()
                    if AutoMaceMod and AutoMaceMod.Enabled then
                        AutoMaceMod:Toggle()
                    end
                end)
            end
        end
    })
    autoMaceState.modRef = AutoMaceMod
    AutoMaceMod:CreateDropdown({
        Name = "Launch Mode",
        List = { "Auto (Wind/Step)", "Multi-Step", "High Jump" },
        Tooltip = "Auto (Wind/Step): uses a real Wind Charge if in hotbar, otherwise climbs via server-legal 0.42 step jumps\nMulti-Step: climbs via server-legal 0.42 step jumps (zero rollback)\nHigh Jump: single vertical impulse",
        Function = function(val)
            VapeConfig.AutoMace.mode = val
        end
    })
    AutoMaceMod:CreateSlider({
        Name = "Height",
        Min = 4,
        Max = 20,
        Default = 9,
        Decimal = 1,
        Suffix = "blocks",
        Function = function(val)
            VapeConfig.AutoMace.height = val
            vape:UpdateTextGUI()
        end
    })
    AutoMaceMod:CreateToggle({
        Name = "Anti Rollback",
        Tooltip = "Blocks server TeleportN rollback snaps during Mace launch & slam",
        Default = true,
        Function = function(val)
            VapeConfig.AutoMace.antiRollback = val
        end
    })
    AutoMaceMod:CreateToggle({
        Name = "Auto Select Mace",
        Tooltip = "Automatically switches your hotbar to the Mace when launching and slamming",
        Default = true,
        Function = function(val)
            VapeConfig.AutoMace.autoSelectMace = val
        end
    })
    AutoMaceMod:CreateToggle({
        Name = "Auto Slam on Fall",
        Tooltip = "Automatically aims and strikes the target as you fall into reach for guaranteed Smash damage",
        Default = true,
        Function = function(val)
            VapeConfig.AutoMace.autoSlamAttack = val
        end
    })
    AutoMaceMod:CreateToggle({
        Name = "Active in Lobby",
        Default = true,
        Function = function(val)
            VapeConfig.AutoMace.inLobby = val
        end
    })

    -- 10. Velocity (NoKB & Low KB) (Combat)
    local VelocityMod = vape.Categories.Combat:CreateModule({
        Name = "Velocity",
        Tooltip = "Reduces or completely cancels knockback taken from attacks, Mace smashes and explosions (NoKB / Low KB)",
        ExtraText = function()
            if VapeConfig.Velocity.mode == "No KB (0%)" then
                return "0% 0%"
            end
            return string.format("%d%% %d%%", math.floor(tonumber(VapeConfig.Velocity.horizontal) or 25), math.floor(tonumber(VapeConfig.Velocity.vertical) or 50))
        end,
        Function = function(callback)
            VapeConfig.Velocity.enabled = callback
        end
    })
    VelocityMod:CreateDropdown({
        Name = "Mode",
        List = { "Low KB", "No KB (0%)" },
        Tooltip = "Low KB: pushes you slightly backward using Horizontal % and Vertical %\nNo KB (0%): completely cancels all knockback",
        Function = function(val)
            VapeConfig.Velocity.mode = val
            vape:UpdateTextGUI()
        end
    })
    VelocityMod:CreateSlider({
        Name = "Horizontal",
        Min = 0,
        Max = 100,
        Default = 25,
        Decimal = 1,
        Suffix = "%",
        Tooltip = "Percentage of horizontal knockback taken in Low KB mode (25% = pushed slightly back)",
        Function = function(val)
            VapeConfig.Velocity.horizontal = val
            vape:UpdateTextGUI()
        end
    })
    VelocityMod:CreateSlider({
        Name = "Vertical",
        Min = 0,
        Max = 100,
        Default = 50,
        Decimal = 1,
        Suffix = "%",
        Tooltip = "Percentage of vertical knockback taken in Low KB mode",
        Function = function(val)
            VapeConfig.Velocity.vertical = val
            vape:UpdateTextGUI()
        end
    })
    VelocityMod:CreateToggle({
        Name = "Affect Explosions/Smash",
        Tooltip = "Also scales knockback from TNT, Fireballs, Wind Charges and enemy Mace Smashes",
        Default = true,
        Function = function(val)
            VapeConfig.Velocity.explosionKb = val
        end
    })

    -- 11. ESP (Box, Corner, Large Nametags & 9-Slot Hotbar Items) (Render)
    local ESPMod = vape.Categories.Render:CreateModule({
        Name = "ESP",
        Tooltip = "2D ESP Box, ESP Corner, Scalable Large Nametags (HP + Distance), and 9-Slot Enemy Hotbar Items Bar",
        ExtraText = function()
            if VapeConfig.ESP.corner and not VapeConfig.ESP.box then
                return "Corner"
            elseif VapeConfig.ESP.box then
                return "Box"
            end
            return "2D"
        end,
        Function = function(callback)
            VapeConfig.ESP.enabled = callback
            if not callback then
                destroyAllEspCards()
            end
        end
    })
    ESPMod:CreateToggle({
        Name = "ESP Box",
        Tooltip = "Draws a full 2D bounding box + vertical health bar around enemies",
        Default = true,
        Function = function(val)
            VapeConfig.ESP.box = val
            vape:UpdateTextGUI()
        end
    })
    ESPMod:CreateToggle({
        Name = "ESP Corner",
        Tooltip = "Draws 2D corner brackets around enemies",
        Default = true,
        Function = function(val)
            VapeConfig.ESP.corner = val
            vape:UpdateTextGUI()
        end
    })
    ESPMod:CreateToggle({
        Name = "ESP Nametags",
        Tooltip = "Draws high-visibility scalable nametags showing Name, HP, Absorption and Distance across the whole map",
        Default = true,
        Function = function(val)
            VapeConfig.ESP.nametags = val
        end
    })
    ESPMod:CreateSlider({
        Name = "Nametag Scale",
        Min = 0.8,
        Max = 3.0,
        Default = 1.45,
        Decimal = 10,
        Suffix = "x",
        Tooltip = "Makes enemy nametags larger and easier to read from far away",
        Function = function(val)
            VapeConfig.ESP.nametagScale = val
        end
    })
    ESPMod:CreateToggle({
        Name = "ESP Items (9 Slots)",
        Tooltip = "Renders 9 hotbar squares (+ armor square) below each enemy showing their equipped/seen items with a gold border on their held slot",
        Default = true,
        Function = function(val)
            VapeConfig.ESP.itemsBar = val
        end
    })
    ESPMod:CreateSlider({
        Name = "Items Bar Scale",
        Min = 0.7,
        Max = 2.0,
        Default = 1.05,
        Decimal = 10,
        Suffix = "x",
        Tooltip = "Adjusts the size of the 9-slot enemy hotbar strip",
        Function = function(val)
            VapeConfig.ESP.itemsScale = val
        end
    })
    ESPMod:CreateToggle({
        Name = "Show Bots",
        Tooltip = "Include training/match bots in ESP",
        Default = true,
        Function = function(val)
            VapeConfig.ESP.showBots = val
        end
    })
    ESPMod:CreateToggle({
        Name = "Active in Lobby",
        Tooltip = "Render ESP on players while in the lobby",
        Default = false,
        Function = function(val)
            VapeConfig.ESP.inLobby = val
        end
    })

    -- 12. AutoOrganize / InvManager (Inventory)
    local AutoOrganizeMod = vape.Categories.Inventory:CreateModule({
        Name = "AutoOrganize",
        Tooltip = "Automatically sorts your 9-slot hotbar (Sword, Mace, Apple, Blocks, Bow, Utility), equips better Armor, and drops worse/trash items without opening the inventory!",
        ExtraText = function()
            return "Silent"
        end,
        Function = function(callback)
            VapeConfig.AutoOrganize.enabled = callback
        end
    })
    AutoOrganizeMod:CreateToggle({
        Name = "Auto Armor",
        Tooltip = "Automatically equips better chestplates (Diamond > Iron > Chain) from your hotbar without opening the inventory",
        Default = true,
        Function = function(val)
            VapeConfig.AutoOrganize.autoArmor = val
        end
    })
    AutoOrganizeMod:CreateToggle({
        Name = "Drop Worse Gear",
        Tooltip = "Automatically drops duplicate or lower-tier Swords, Pickaxes, and worse Chestplates without opening the inventory",
        Default = true,
        Function = function(val)
            VapeConfig.AutoOrganize.dropWorseGear = val
        end
    })
    AutoOrganizeMod:CreateSlider({
        Name = "Sword Slot",
        Min = 0,
        Max = 9,
        Default = 1,
        Decimal = 1,
        Tooltip = "Hotbar slot (1-9) for your best Sword (0 = Off)",
        Function = function(val)
            VapeConfig.AutoOrganize.swordSlot = val
        end
    })
    AutoOrganizeMod:CreateSlider({
        Name = "Mace Slot",
        Min = 0,
        Max = 9,
        Default = 2,
        Decimal = 1,
        Tooltip = "Hotbar slot (1-9) for your Mace or Knockback Stick (0 = Off)",
        Function = function(val)
            VapeConfig.AutoOrganize.maceSlot = val
        end
    })
    AutoOrganizeMod:CreateSlider({
        Name = "Apple / Heal Slot",
        Min = 0,
        Max = 9,
        Default = 3,
        Decimal = 1,
        Tooltip = "Hotbar slot (1-9) for Golden Apples / Enchanted Apples / Healing Potions (0 = Off)",
        Function = function(val)
            VapeConfig.AutoOrganize.appleSlot = val
        end
    })
    AutoOrganizeMod:CreateSlider({
        Name = "Blocks Slot",
        Min = 0,
        Max = 9,
        Default = 4,
        Decimal = 1,
        Tooltip = "Hotbar slot (1-9) for your main Wool / Planks / Solid Blocks stack (0 = Off)",
        Function = function(val)
            VapeConfig.AutoOrganize.blockSlot = val
        end
    })
    AutoOrganizeMod:CreateSlider({
        Name = "Bow / Ranged Slot",
        Min = 0,
        Max = 9,
        Default = 5,
        Decimal = 1,
        Tooltip = "Hotbar slot (1-9) for Bow, Fireballs, Snowballs or Eggs (0 = Off)",
        Function = function(val)
            VapeConfig.AutoOrganize.bowSlot = val
        end
    })
    AutoOrganizeMod:CreateSlider({
        Name = "Utility / Pearl Slot",
        Min = 0,
        Max = 9,
        Default = 6,
        Decimal = 1,
        Tooltip = "Hotbar slot (1-9) for Wind Charges, Ender Pearls, Totem or Buckets (0 = Off)",
        Function = function(val)
            VapeConfig.AutoOrganize.utilitySlot = val
        end
    })
    AutoOrganizeMod:CreateSlider({
        Name = "Pickaxe Slot",
        Min = 0,
        Max = 9,
        Default = 7,
        Decimal = 1,
        Tooltip = "Hotbar slot (1-9) for your best Pickaxe (0 = Off)",
        Function = function(val)
            VapeConfig.AutoOrganize.pickaxeSlot = val
        end
    })
    AutoOrganizeMod:CreateToggle({
        Name = "Drop Custom Trash",
        Tooltip = "Automatically drops any item matching the Trash List below",
        Default = false,
        Function = function(val)
            VapeConfig.AutoOrganize.dropCustomTrash = val
        end
    })
    local TrashTextList
    TrashTextList = AutoOrganizeMod:CreateTextList({
        Name = "Trash Items",
        Placeholder = "item id/name (ex: dirt, snowball)",
        Default = { "dirt", "wooden_sword" },
        Tooltip = "Add item names or IDs to automatically drop from your hotbar",
        Function = function(list)
            if TrashTextList and type(TrashTextList.ListEnabled) == "table" then
                VapeConfig.AutoOrganize.trashList = table.clone(TrashTextList.ListEnabled)
            elseif type(list) == "table" then
                VapeConfig.AutoOrganize.trashList = table.clone(list)
            end
        end
    })
end

-- Load saved Vape V4 profiles & position categories cleanly on first run
pcall(function()
    local hadGuiProfile = isfile("newvape/profiles/" .. tostring(game.GameId) .. ".gui.txt")
    vape:Load()

    -- Ensure NoFall is always active after loading any older saved Vape profile so the user takes 0 fall damage!
    if vape.Modules and vape.Modules.NoFall and not vape.Modules.NoFall.Enabled then
        vape.Modules.NoFall:Toggle()
    end

    local textGuiCat = vape.Categories["Text GUI"]
    if textGuiCat and textGuiCat.Object then
        -- Ensure Text GUI doesn't sit on top of the game's top-right Premium / Presente lobby buttons (y < 115)
        if not hadGuiProfile or (textGuiCat.Object.Position.X.Offset >= 1500 and textGuiCat.Object.Position.Y.Offset < 115) then
            textGuiCat.Object.Position = UDim2.fromOffset(1650, 132)
        end
    end

    if not hadGuiProfile then
        for _, catInfo in ipairs({
            { name = "Combat", x = 236, y = 60 },
            { name = "Blatant", x = 466, y = 60 },
            { name = "Render", x = 696, y = 60 },
            { name = "World", x = 926, y = 60 },
            { name = "Inventory", x = 1156, y = 60 }
        }) do
            local cat = vape.Categories[catInfo.name]
            if cat then
                cat.Object.Position = UDim2.fromOffset(catInfo.x, catInfo.y)
                if not cat.Button.Enabled then
                    cat.Button:Toggle()
                end
                if not cat.Expanded then
                    cat:Expand()
                end
            end
        end

        if textGuiCat then
            textGuiCat.Object.Position = UDim2.fromOffset(1650, 132)
            if not textGuiCat.Button.Enabled then
                textGuiCat.Button:Toggle()
            end
            if not textGuiCat.Pinned then
                textGuiCat:Pin()
                textGuiCat:Update()
            end
            if textGuiCat.Options["Watermark"] and not textGuiCat.Options["Watermark"].Enabled then
                textGuiCat.Options["Watermark"]:Toggle()
            end
            if textGuiCat.Options["Shadow"] and not textGuiCat.Options["Shadow"].Enabled then
                textGuiCat.Options["Shadow"]:Toggle()
            end
            if textGuiCat.Options["Render background"] and not textGuiCat.Options["Render background"].Enabled then
                textGuiCat.Options["Render background"]:Toggle()
            end
        end

        local targetInfoCat = vape.Categories["Target Info"]
        if targetInfoCat then
            targetInfoCat.Object.Position = UDim2.fromOffset(930, 540)
            if not targetInfoCat.Button.Enabled then
                targetInfoCat.Button:Toggle()
            end
            if not targetInfoCat.Pinned then
                targetInfoCat:Pin()
                targetInfoCat:Update()
            end
        end

        vape:UpdateTextGUI(true)
        vape:Save()
    else
        -- Ensure the Inventory category window is positioned cleanly if upgrading from an older GUI profile where Inventory was never opened
        local invCat = vape.Categories["Inventory"]
        if invCat and invCat.Object.Position.X.Offset == 236 and invCat.Object.Position.Y.Offset == 60 then
            invCat.Object.Position = UDim2.fromOffset(1156, 60)
            if not invCat.Button.Enabled then
                invCat.Button:Toggle()
            end
            if not invCat.Expanded then
                invCat:Expand()
            end
        end
        vape:ScheduleSave()
    end
end)

-- Show a crisp, high-contrast startup notification card + Vape notification (instead of the oversized game bitmap banner!)
local startupBannerGui = nil
local function showCleanStartupNotification()
    pcall(function()
        if vape and type(vape.CreateNotification) == "function" then
            vape:CreateNotification("Vape V4 + Unlock All", "Press <font color=\"#05D594\"><b>RightShift</b></font> for GUI | 44 Capes (7 GIF) + 0-DMG NoFall", 6)
        end
    end)
    pcall(function()
        local parentGui = (type(gethui) == "function" and gethui()) or game:GetService("CoreGui")
        local sg = Instance.new("ScreenGui")
        sg.Name = "YDX_ToF_StartupCard"
        sg.DisplayOrder = 10000000
        sg.IgnoreGuiInset = true
        sg.ResetOnSpawn = false
        sg.Parent = parentGui
        startupBannerGui = sg

        local card = Instance.new("Frame")
        card.Name = "Card"
        card.AnchorPoint = Vector2.new(0.5, 0)
        card.Position = UDim2.new(0.5, 0, 0, -90)
        card.Size = UDim2.fromOffset(420, 68)
        card.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
        card.BackgroundTransparency = 0.06
        card.BorderSizePixel = 0
        card.Parent = sg

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = card

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(5, 213, 148)
        stroke.Thickness = 1.8
        stroke.Transparency = 0.15
        stroke.Parent = card

        local accentBar = Instance.new("Frame")
        accentBar.Size = UDim2.new(0, 4, 1, -16)
        accentBar.Position = UDim2.fromOffset(10, 8)
        accentBar.BackgroundColor3 = Color3.fromRGB(5, 213, 148)
        accentBar.BorderSizePixel = 0
        accentBar.Parent = card
        local abCorner = Instance.new("UICorner")
        abCorner.CornerRadius = UDim.new(1, 0)
        abCorner.Parent = accentBar

        local titleLbl = Instance.new("TextLabel")
        titleLbl.BackgroundTransparency = 1
        titleLbl.Position = UDim2.fromOffset(24, 9)
        titleLbl.Size = UDim2.new(1, -34, 0, 22)
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.RichText = true
        titleLbl.Text = "<font color=\"#05D594\">VAPE V4</font>  <font color=\"#FFFFFF\">//  TOWERS OF FORTUNE</font>  <font color=\"#FFD740\">[RightShift]</font>"
        titleLbl.TextSize = 14
        titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.Parent = card

        local subLbl = Instance.new("TextLabel")
        subLbl.BackgroundTransparency = 1
        subLbl.Position = UDim2.fromOffset(24, 31)
        subLbl.Size = UDim2.new(1, -34, 0, 28)
        subLbl.Font = Enum.Font.GothamMedium
        subLbl.RichText = true
        subLbl.Text = "44 Capes (<font color=\"#E088FF\">7 Custom GIF</font>) + <font color=\"#55FF88\">0-DMG NoFall</font> + <font color=\"#55D4FF\">ESP 9-Slot &amp; AutoOrganize</font>\n<font color=\"#AAAAAA\">P2P Sync 20Hz Active  |  Auto-Save Profile Loaded</font>"
        subLbl.TextSize = 11
        subLbl.TextColor3 = Color3.fromRGB(210, 215, 225)
        subLbl.TextXAlignment = Enum.TextXAlignment.Left
        subLbl.TextYAlignment = Enum.TextYAlignment.Top
        subLbl.Parent = card

        local ts = game:GetService("TweenService")
        ts:Create(card, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0, 18)
        }):Play()

        task.delay(5.2, function()
            if card and card.Parent then
                local outTw = ts:Create(card, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Position = UDim2.new(0.5, 0, 0, -90),
                    BackgroundTransparency = 1
                })
                outTw:Play()
                task.wait(0.35)
            end
            if sg and sg.Parent then
                sg:Destroy()
            end
        end)
    end)
end
showCleanStartupNotification()

-- Main RenderStepped Loop: sync Camera cursor with Vape ClickGui & run all 8 modules
local clickGuiRef = vape.gui and vape.gui:FindFirstChild("ScaledGui") and vape.gui.ScaledGui:FindFirstChild("ClickGui")
local legitGuiRef = vape.Legit and vape.Legit.Window
local wasVapeOpen = false

table.insert(connections, RunService.RenderStepped:Connect(function(dt)
    if not watcherActive then
        return
    end

    local isVapeOpen = (clickGuiRef and clickGuiRef.Visible) or (legitGuiRef and legitGuiRef.Visible) or false
    if isVapeOpen then
        wasVapeOpen = true
        if CameraMod then
            CameraMod.uiOpen = true
            CameraMod.cursorFree = true
        end
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    elseif wasVapeOpen then
        wasVapeOpen = false
        if CameraMod then
            CameraMod.uiOpen = (UiMod and type(UiMod.isOpen) == "function" and UiMod.isOpen() == true) or false
        end
    end

    -- 1. Record Backtrack History & apply Backtrack hitbox rewind
    pcall(recordBacktrackPositions)
    pcall(stepBacktrackHitboxApply)

    -- 2. AimAssist (with Require Sword/Mace check!)
    pcall(stepAimAssist, dt)

    -- 3. ThirdPerson camera enforcement & NoFall / AirWalk Fly fallback
    if VapeConfig.ThirdPerson.enabled then
        pcall(applyThirdPersonState)
    end
    if VapeConfig.NoFall.enabled and not autoMaceState.activeDive and isLocalAlive() then
        if MovementMod and type(MovementMod.state) == "function" then
            local st = MovementMod.state()
            if type(st) == "table" then
                st.fallDistance = 0
            end
        end
    end

    -- 4. AutoMace Slam, KillAura, AutoClicker (Left), FastPlace, Scaffold, AutoOrganize & 2D ESP
    pcall(stepAutoMaceSlam)
    pcall(stepKillAura)
    pcall(stepAutoClicker)
    pcall(stepFastPlace)
    pcall(stepScaffold)
    pcall(stepAutoOrganize)
    pcall(stepEspRender)
end))

-- Download custom GIF cape sprite sheets in background if not cached yet, then refresh UI & character cape
local function forceRebuildCharacterCape()
    local char = LocalPlayer.Character
    if not char then
        return
    end
    local activeCape = resolveActiveVisualCape()
    if not activeCape or activeCape == "" then
        activeCape = char:GetAttribute("Cape")
    end
    if activeCape and activeCape ~= "" then
        pcall(function()
            if Chars and type(Chars.track) == "function" then
                Chars.track(char)
            end
            char:SetAttribute("Cape", "")
            char:SetAttribute("Cape", activeCape)
        end)
    end
end

-- Rebuild character cape immediately on startup (fixes already-equipped custom GIF capes!)
task.defer(forceRebuildCharacterCape)

task.spawn(function()
    local c4 = ensureCustomCapeSheetLoaded(4, "ydx_tof_capes_4.png", "assets/custom_capes_4.png")
    local c5 = ensureCustomCapeSheetLoaded(5, "ydx_tof_capes_5.png", "assets/custom_capes_5.png")
    if c4 or c5 then
        fireProfileListeners()
        forceRebuildCharacterCape()
    end
end)

env._YDX_TOF_CLEANUP = function()
    watcherActive = false
    env._YDX_TOF_SHOP_HANDLER = nil
    env._YDX_TOF_SILENT_ROT = nil
    env._YDX_TOF_FAKELAG_SEND = nil
    env._YDX_TOF_SPOOF_ONGROUND = nil
    env._YDX_TOF_FLUSH_NOFALL_NOW = nil
    if startupBannerGui then
        pcall(function()
            startupBannerGui:Destroy()
        end)
        startupBannerGui = nil
    end
    flushFakeLagPackets(true)
    clearBacktrackGhost()
    clearFakeLagGhost()
    clearAirWalkPlatform()
    destroyAllEspCards()
    if PhysicsMod and env._YDX_TOF_ORIG_KNOCKBACK then
        PhysicsMod.knockback = env._YDX_TOF_ORIG_KNOCKBACK
    end
    if CameraMod then
        CameraMod.uiOpen = false
    end
    pcall(function()
        if vape and type(vape.Uninject) == "function" then
            vape:Uninject()
        end
    end)
    if AssetsMod then
        if env._YDX_TOF_ORIG_CAPEATLAS then AssetsMod.capeAtlas = env._YDX_TOF_ORIG_CAPEATLAS end
        if env._YDX_TOF_ORIG_CAPEATLASSIZE then AssetsMod.capeAtlasSize = env._YDX_TOF_ORIG_CAPEATLASSIZE end
        if env._YDX_TOF_ORIG_CAPEORIGIN then AssetsMod.capeOrigin = env._YDX_TOF_ORIG_CAPEORIGIN end
        if env._YDX_TOF_ORIG_CAPEFRAMES then AssetsMod.capeFrames = env._YDX_TOF_ORIG_CAPEFRAMES end
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
