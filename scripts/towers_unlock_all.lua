-- [Towers of Fortune] - Unlock All Capes + Skip Spin
-- Persistent Presets + Real-Time P2P Sync + Sub-place Scanner

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local AssetService = game:GetService("AssetService")

local LocalPlayer = Players.LocalPlayer

-- ============================================================================
-- 0. SUB-PLACE SCANNER (STANDARD REQUIREMENT)
-- ============================================================================
task.spawn(function()
    local function setClipboard(text)
        if setclipboard then
            pcall(setclipboard, text)
        elseif toclipboard then
            pcall(toclipboard, text)
        end
    end

    local placeList = {}
    local currentGameId = game.PlaceId
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
-- 1. TELEMETRY + ACTIVE USERS BANNER + LIVE UPDATE WATCHER
-- ============================================================================
do
    local GAME_KEY = "towers_unlock"
    local GAME_TITLE = "Towers of Fortune"
    local COUNTER_NAMESPACE = "ydx_script_vault_v1"
    local ACTIVE_TOPIC = "ydx_active_" .. GAME_KEY
    local _req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    local _lp = Players.LocalPlayer
    local _uid = _lp and tostring(_lp.UserId) or "0"

    local function showUsersBanner(count)
        pcall(function()
            local guiParent = (gethui and gethui()) or CoreGui
            local old = guiParent:FindFirstChild("YDX_LiveUsersBanner")
            if old then
                old:Destroy()
            end

            local sg = Instance.new("ScreenGui")
            sg.Name = "YDX_LiveUsersBanner"
            sg.DisplayOrder = 999999
            sg.IgnoreGuiInset = true
            sg.ResetOnSpawn = false
            sg.Parent = guiParent

            local frame = Instance.new("Frame")
            frame.Name = "Banner"
            frame.AnchorPoint = Vector2.new(0.5, 0)
            frame.Position = UDim2.new(0.5, 0, 0, -60)
            frame.Size = UDim2.new(0, 420, 0, 40)
            frame.BackgroundColor3 = Color3.fromRGB(12, 13, 20)
            frame.BackgroundTransparency = 0.08
            frame.BorderSizePixel = 0
            frame.Parent = sg

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 12)
            corner.Parent = frame

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(0, 255, 136)
            stroke.Thickness = 1.5
            stroke.Transparency = 0.25
            stroke.Parent = frame

            local dot = Instance.new("Frame")
            dot.AnchorPoint = Vector2.new(0, 0.5)
            dot.Position = UDim2.new(0, 16, 0.5, 0)
            dot.Size = UDim2.new(0, 10, 0, 10)
            dot.BackgroundColor3 = Color3.fromRGB(0, 255, 136)
            dot.BorderSizePixel = 0
            dot.Parent = frame

            local dotCorner = Instance.new("UICorner")
            dotCorner.CornerRadius = UDim.new(1, 0)
            dotCorner.Parent = dot

            local label = Instance.new("TextLabel")
            label.AnchorPoint = Vector2.new(0, 0.5)
            label.Position = UDim2.new(0, 36, 0.5, 0)
            label.Size = UDim2.new(1, -48, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.TextSize = 14
            label.TextColor3 = Color3.fromRGB(240, 245, 255)
            label.TextXAlignment = Enum.TextXAlignment.Left
            local num = tonumber(count) or 1
            if num < 1 then
                num = 1
            end
            label.Text = string.format("%d %s using unlock all in this game", num, (num == 1) and "user" or "users")
            label.Parent = frame

            TweenService:Create(frame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 0, 14)
            }):Play()

            task.delay(6, function()
                if frame and frame.Parent then
                    local tw = TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        Position = UDim2.new(0.5, 0, 0, -60)
                    })
                    tw:Play()
                    tw.Completed:Wait()
                    if sg and sg.Parent then
                        sg:Destroy()
                    end
                end
            end)
        end)
    end

    local function countActiveUsers()
        local active = { [_uid] = true }
        if _req then
            pcall(function()
                _req({
                    Url = "https://ntfy.sh/" .. ACTIVE_TOPIC,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "text/plain" },
                    Body = "PING:" .. _uid
                })
            end)
            local ok, res = pcall(function()
                return _req({
                    Url = "https://ntfy.sh/" .. ACTIVE_TOPIC .. "/json?poll=1&since=90s",
                    Method = "GET"
                })
            end)
            if ok and res and res.Body then
                for line in string.gmatch(res.Body, "[^\r\n]+") do
                    local okJ, data = pcall(function()
                        return HttpService:JSONDecode(line)
                    end)
                    if okJ and type(data) == "table" and data.event == "message" and type(data.message) == "string" then
                        local sender = string.match(data.message, "^PING:(%d+)")
                        if sender then
                            active[sender] = true
                        end
                    end
                end
            end
        end
        local total = 0
        for _ in pairs(active) do
            total = total + 1
        end
        return math.max(1, total)
    end

    if not getgenv()._YDX_TELEMETRY_SENT then
        getgenv()._YDX_TELEMETRY_SENT = {}
    end

    task.spawn(function()
        if not getgenv()._YDX_TELEMETRY_SENT[GAME_KEY] then
            getgenv()._YDX_TELEMETRY_SENT[GAME_KEY] = true
            local _u = "https://api.counterapi.dev/v1/" .. COUNTER_NAMESPACE .. "/" .. GAME_KEY .. "/up"
            local _g = "https://api.counterapi.dev/v1/" .. COUNTER_NAMESPACE .. "/total_executions/up"
            if _req then
                pcall(_req, { Url = _u, Method = "GET" })
                pcall(_req, { Url = _g, Method = "GET" })
            else
                pcall(function() game:HttpGet(_u) end)
                pcall(function() game:HttpGet(_g) end)
            end
        end
        local activeCount = countActiveUsers()
        showUsersBanner(activeCount)
    end)

    if not getgenv()._YDX_ACTIVE_HEARTBEAT then
        getgenv()._YDX_ACTIVE_HEARTBEAT = {}
    end
    if not getgenv()._YDX_ACTIVE_HEARTBEAT[GAME_KEY] then
        getgenv()._YDX_ACTIVE_HEARTBEAT[GAME_KEY] = true
        task.spawn(function()
            while task.wait(40) do
                if _req then
                    pcall(function()
                        _req({
                            Url = "https://ntfy.sh/" .. ACTIVE_TOPIC,
                            Method = "POST",
                            Headers = { ["Content-Type"] = "text/plain" },
                            Body = "PING:" .. _uid
                        })
                    end)
                end
            end
        end)
    end

    local function startYdxUpdateWatcher(scriptFileName)
        if not getgenv()._YDX_UPDATE_WATCHERS then
            getgenv()._YDX_UPDATE_WATCHERS = {}
        end
        local oldWatcher = getgenv()._YDX_UPDATE_WATCHERS[scriptFileName]
        if oldWatcher then
            oldWatcher.active = false
        end
        local state = { active = true }
        getgenv()._YDX_UPDATE_WATCHERS[scriptFileName] = state

        pcall(function()
            local guiParent = (gethui and gethui()) or CoreGui
            local oldBanner = guiParent:FindFirstChild("YDX_ScriptUpdateBanner")
            if oldBanner then
                oldBanner:Destroy()
            end
        end)

        local function fetchBody(url)
            if _req then
                local ok, res = pcall(_req, { Url = url, Method = "GET" })
                if ok and res and (res.StatusCode == 200 or res.StatusCode == 304) and type(res.Body) == "string" and #res.Body > 32 then
                    return res.Body
                end
            end
            local ok2, body = pcall(function()
                return game:HttpGet(url)
            end)
            if ok2 and type(body) == "string" and #body > 32 then
                return body
            end
            return nil
        end

        local function normalizeHash(str)
            local h = 2166136261
            local len = #str
            for i = 1, len do
                local b = string.byte(str, i)
                if b ~= 13 then
                    h = bit32.bxor(h, b)
                    h = (h * 16777619) % 4294967296
                end
            end
            return h
        end

        local function showUpdateBanner()
            pcall(function()
                local guiParent = (gethui and gethui()) or CoreGui
                if guiParent:FindFirstChild("YDX_ScriptUpdateBanner") then
                    return
                end

                local sg = Instance.new("ScreenGui")
                sg.Name = "YDX_ScriptUpdateBanner"
                sg.DisplayOrder = 1000000
                sg.IgnoreGuiInset = true
                sg.ResetOnSpawn = false
                sg.Parent = guiParent

                local frame = Instance.new("Frame")
                frame.Name = "Banner"
                frame.AnchorPoint = Vector2.new(0.5, 0)
                frame.Position = UDim2.new(0.5, 0, 0, -70)
                frame.Size = UDim2.new(0, 520, 0, 44)
                frame.BackgroundColor3 = Color3.fromRGB(22, 16, 10)
                frame.BackgroundTransparency = 0.05
                frame.BorderSizePixel = 0
                frame.Parent = sg

                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 12)
                corner.Parent = frame

                local stroke = Instance.new("UIStroke")
                stroke.Color = Color3.fromRGB(255, 185, 0)
                stroke.Thickness = 2
                stroke.Transparency = 0.15
                stroke.Parent = frame

                local dot = Instance.new("Frame")
                dot.AnchorPoint = Vector2.new(0, 0.5)
                dot.Position = UDim2.new(0, 16, 0.5, 0)
                dot.Size = UDim2.new(0, 10, 0, 10)
                dot.BackgroundColor3 = Color3.fromRGB(255, 190, 0)
                dot.BorderSizePixel = 0
                dot.Parent = frame

                local dotCorner = Instance.new("UICorner")
                dotCorner.CornerRadius = UDim.new(1, 0)
                dotCorner.Parent = dot

                local label = Instance.new("TextLabel")
                label.AnchorPoint = Vector2.new(0, 0.5)
                label.Position = UDim2.new(0, 36, 0.5, 0)
                label.Size = UDim2.new(1, -80, 1, 0)
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.GothamBold
                label.TextSize = 13
                label.TextColor3 = Color3.fromRGB(255, 235, 175)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Text = "SCRIPT UPDATED! Please re-execute to get the latest update."
                label.Parent = frame

                local closeBtn = Instance.new("TextButton")
                closeBtn.AnchorPoint = Vector2.new(1, 0.5)
                closeBtn.Position = UDim2.new(1, -10, 0.5, 0)
                closeBtn.Size = UDim2.new(0, 26, 0, 26)
                closeBtn.BackgroundColor3 = Color3.fromRGB(45, 34, 18)
                closeBtn.BorderSizePixel = 0
                closeBtn.Font = Enum.Font.GothamBold
                closeBtn.TextSize = 12
                closeBtn.TextColor3 = Color3.fromRGB(255, 215, 110)
                closeBtn.Text = "X"
                closeBtn.Parent = frame

                local closeCorner = Instance.new("UICorner")
                closeCorner.CornerRadius = UDim.new(0, 6)
                closeCorner.Parent = closeBtn

                closeBtn.MouseButton1Click:Connect(function()
                    if sg and sg.Parent then
                        sg:Destroy()
                    end
                end)

                TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0.5, 0, 0, 62)
                }):Play()
            end)
        end

        task.spawn(function()
            local baseUrl = "https://raw.githubusercontent.com/yodavinicius-byte/script-vault/main/scripts/" .. scriptFileName
            local initialBody = fetchBody(baseUrl .. "?cb=" .. tostring(os.time()))
            local baselineHash = initialBody and normalizeHash(initialBody) or nil
            if not baselineHash then
                return
            end
            while state.active and task.wait(45) do
                if not state.active then
                    break
                end
                local latestBody = fetchBody(baseUrl .. "?cb=" .. tostring(os.time()))
                if latestBody then
                    local latestHash = normalizeHash(latestBody)
                    if latestHash ~= baselineHash then
                        showUpdateBanner()
                        break
                    end
                end
            end
        end)
    end
    startYdxUpdateWatcher("towers_unlock_all.lua")
end

-- ============================================================================
-- 2. CLEANUP OLD INSTANCE
-- ============================================================================
if getgenv()._YDX_TOF_CLEANUP then
    pcall(getgenv()._YDX_TOF_CLEANUP)
end

local connections = {}
local watcherActive = true

-- ============================================================================
-- 3. PERSISTENT PRESET SAVING & P2P NTFY SYNC
-- ============================================================================
local SAVE_FILE = "towers_saved_preset.json"
local selectedCape = nil -- string capeId ("" = None, nil = use current/saved)
local selectedWool = nil -- string woolId
local peerCapes = {}     -- [tostring(userId)] = capeId

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
                wool = selectedWool or ""
            })
            writefile(SAVE_FILE, payload)
        end)
    end
end

loadPreset()

local _req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local cleanJobId = string.gsub(tostring(game.JobId ~= "" and game.JobId or "studio"), "[^%w]", "")
local P2P_TOPIC = "ydx_tof1_" .. string.sub(cleanJobId, 1, 24)
local lastBroadcastPayload = ""
local lastBroadcastTime = 0

local function broadcastCape(force)
    if not _req then
        return
    end
    local capeToSend = selectedCape
    if capeToSend == nil and LocalPlayer.Character then
        capeToSend = LocalPlayer.Character:GetAttribute("Cape") or ""
    end
    capeToSend = tostring(capeToSend or "")
    local payload = string.format("CAPE:%d:%s", LocalPlayer.UserId, capeToSend)
    local now = os.clock()
    if not force and payload == lastBroadcastPayload and (now - lastBroadcastTime) < 20 then
        return
    end
    lastBroadcastPayload = payload
    lastBroadcastTime = now
    task.spawn(function()
        pcall(function()
            _req({
                Url = "https://ntfy.sh/" .. P2P_TOPIC,
                Method = "POST",
                Headers = { ["Content-Type"] = "text/plain" },
                Body = payload
            })
        end)
    end)
end

local function applyPeerCapeToPlayer(player, capeId)
    if not player or player == LocalPlayer then
        return
    end
    local char = player.Character
    if char and char:GetAttribute("Cape") ~= capeId then
        pcall(function()
            char:SetAttribute("Cape", capeId)
        end)
    end
end

local function pollPeerCapes()
    if not _req then
        return
    end
    local ok, res = pcall(function()
        return _req({
            Url = "https://ntfy.sh/" .. P2P_TOPIC .. "/json?poll=1&since=120s",
            Method = "GET"
        })
    end)
    if ok and res and type(res.Body) == "string" then
        for line in string.gmatch(res.Body, "[^\r\n]+") do
            local okJ, msg = pcall(function()
                return HttpService:JSONDecode(line)
            end)
            if okJ and type(msg) == "table" and msg.event == "message" and type(msg.message) == "string" then
                local uidStr, capeId = string.match(msg.message, "^CAPE:(%d+):(.*)$")
                if uidStr and uidStr ~= tostring(LocalPlayer.UserId) then
                    peerCapes[uidStr] = capeId or ""
                    local plr = Players:GetPlayerByUserId(tonumber(uidStr) or 0)
                    if plr then
                        applyPeerCapeToPlayer(plr, capeId or "")
                    end
                end
            end
        end
    end
end

-- ============================================================================
-- 4. LOCATE GAME MODULES (MC.Config, PoFClient.LobbyUi, PoFClient.Chars, etc.)
-- ============================================================================
local MC = ReplicatedStorage:WaitForChild("MC", 15)
local MCRemotes = ReplicatedStorage:WaitForChild("MCRemotes", 15)
local Config = MC and require(MC:WaitForChild("Config", 10))

local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts", 15)
local PoFClient = PlayerScripts and PlayerScripts:WaitForChild("PoFClient", 15)

local LobbyUi = nil
local Chars = nil
local Hud = nil
local Sfx = MC and MC:FindFirstChild("Sfx") and require(MC.Sfx) or nil

pcall(function()
    if PoFClient then
        local lobbyMod = PoFClient:FindFirstChild("LobbyUi")
        if lobbyMod then
            LobbyUi = require(lobbyMod)
        end
        local charsMod = PoFClient:FindFirstChild("Chars")
        if charsMod then
            Chars = require(charsMod)
        end
        local hudMod = PoFClient:FindFirstChild("Hud")
        if hudMod then
            Hud = require(hudMod)
        end
    end
end)

-- Collect all Cape IDs from Config.CapeOrder & Config.Capes
local ALL_CAPES = {}
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
end

-- All Victory Effect styles
local ALL_EFFECTS = {
    leaps = true,
    tide = true,
    blade = true,
    sandy = true,
    drake = true,
    storm = true,
    rift = true,
    comet = true,
    frost = true,
    chrono = true
}

-- ============================================================================
-- 5. HOOK Config.capeVisible & Config.visibleCapes (Show Season 1-3 & Limiteds)
-- ============================================================================
local origCapeVisible = Config and Config.capeVisible
local origVisibleCapes = Config and Config.visibleCapes

if Config then
    Config.capeVisible = function(capeId, _)
        if Config.Capes and Config.Capes[capeId] ~= nil then
            return true
        end
        if origCapeVisible then
            return origCapeVisible(capeId, math.huge)
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
end

-- ============================================================================
-- 6. UNLOCK PROFILE (Skip Spin + All Capes + Custom Wool + Victory Effects)
-- ============================================================================
local serverOwnedCapes = nil

local function patchProfileTable(profile)
    if type(profile) ~= "table" then
        return
    end

    -- Snapshot original server-owned capes once so we know which ones server actually owns
    if not serverOwnedCapes and type(profile.capes) == "table" then
        serverOwnedCapes = {}
        for k, v in pairs(profile.capes) do
            if v == true then
                serverOwnedCapes[k] = true
            end
        end
    end

    -- 1) Unlock Skip Spin (fastspin) & Custom Wool (wool) in profile.passes
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

    -- 3) Unlock all Victory Effects in Settings
    if type(profile.effects) ~= "table" then
        profile.effects = {}
    end
    for fxId, _ in pairs(ALL_EFFECTS) do
        profile.effects[fxId] = true
    end

    -- 4) Preserve or initialize equipped Cape & Wool
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

    if selectedWool ~= nil and selectedWool ~= "" then
        profile.woolPick = selectedWool
    end
end

local function applyLocalCharacterCosmetics()
    local char = LocalPlayer.Character
    if char and selectedCape ~= nil then
        if char:GetAttribute("Cape") ~= selectedCape then
            pcall(function()
                char:SetAttribute("Cape", selectedCape)
            end)
        end
        if Chars and type(Chars.track) == "function" then
            pcall(Chars.track, char)
        end
    end
    if LocalPlayer:GetAttribute("WoolPass") ~= true then
        pcall(function()
            LocalPlayer:SetAttribute("WoolPass", true)
        end)
    end
end

local function fireProfileListeners()
    if LobbyUi and LobbyUi.H and type(LobbyUi.H.profileListeners) == "table" then
        for _, fn in ipairs(LobbyUi.H.profileListeners) do
            if type(fn) == "function" then
                task.spawn(pcall, fn)
            end
        end
    end
end

local function equipCapeLocally(capeId)
    capeId = tostring(capeId or "")
    selectedCape = capeId
    savePreset()

    if LobbyUi and type(LobbyUi.profile) == "table" then
        patchProfileTable(LobbyUi.profile)
        LobbyUi.profile.cape = capeId
    end

    applyLocalCharacterCosmetics()
    fireProfileListeners()
    broadcastCape(true)
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

-- Hook LobbyUi.setProfile so future server profile syncs keep everything unlocked
local origSetProfile = LobbyUi and LobbyUi.setProfile
if LobbyUi and type(origSetProfile) == "function" then
    LobbyUi.setProfile = function(p464, ...)
        patchProfileTable(p464)
        local ret = origSetProfile(p464, ...)
        applyLocalCharacterCosmetics()
        return ret
    end
end

-- ============================================================================
-- 7. HOOK Shop Remote & LobbyUi.invoke FOR EQUIPPING CAPES & SKIP SPIN
-- ============================================================================
local ShopRemote = MCRemotes and MCRemotes:FindFirstChild("Shop")

local function handleShopAction(action, arg1)
    if action == "equipCape" then
        local capeId = tostring(arg1 or "")
        equipCapeLocally(capeId)
        -- If server also owns this cape (or unequipping ""), notify server asynchronously
        if ShopRemote and (capeId == "" or (serverOwnedCapes and serverOwnedCapes[capeId])) then
            task.spawn(function()
                pcall(function()
                    ShopRemote:InvokeServer("equipCape", capeId)
                end)
            end)
        end
        return true, { ok = true, cape = capeId }
    elseif action == "buyPass" and arg1 == "fastspin" then
        if LobbyUi and type(LobbyUi.profile) == "table" then
            patchProfileTable(LobbyUi.profile)
        end
        fireProfileListeners()
        if Sfx and type(Sfx.ui) == "function" then
            pcall(Sfx.ui, "levelup")
        end
        if LobbyUi and type(LobbyUi.notify) == "function" then
            pcall(LobbyUi.notify, "\194\167aFast Spins \194\1677unlocked! Press \194\167fSKIP >> \194\1677during any roll.")
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

-- Hook LobbyUi.invoke and LobbyUi.H.invoke
local origLobbyInvoke = LobbyUi and LobbyUi.invoke
if LobbyUi and type(origLobbyInvoke) == "function" then
    local function hookedInvoke(action, arg1, ...)
        if watcherActive then
            local handled, fakeResult = handleShopAction(action, arg1)
            if handled then
                return fakeResult
            end
        end
        local res = origLobbyInvoke(action, arg1, ...)
        if watcherActive and LobbyUi and type(LobbyUi.profile) == "table" then
            patchProfileTable(LobbyUi.profile)
        end
        return res
    end
    LobbyUi.invoke = hookedInvoke
    if type(LobbyUi.H) == "table" then
        LobbyUi.H.invoke = hookedInvoke
    end
end

-- Also hook upvalues named `invoke` inside LobbyUi functions (openCapes, openRoll, openLimited, etc.)
if LobbyUi and debug and debug.getupvalues and debug.setupvalue then
    for _, fn in pairs(LobbyUi) do
        if type(fn) == "function" then
            local okU, ups = pcall(debug.getupvalues, fn)
            if okU and type(ups) == "table" then
                for idx, val in pairs(ups) do
                    if type(val) == "function" and origLobbyInvoke and val == origLobbyInvoke then
                        pcall(debug.setupvalue, fn, idx, LobbyUi.invoke)
                    end
                end
            end
        end
    end
end

-- Hook MCRemotes.Shop.InvokeServer via __namecall so any direct InvokeServer("equipCape", ...) is intercepted
if ShopRemote and hookmetamethod and getnamecallmethod and not getgenv()._YDX_TOF_NAMECALL_HOOKED then
    getgenv()._YDX_TOF_NAMECALL_HOOKED = true
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if self == ShopRemote and (method == "InvokeServer" or method == "invokeServer") then
            local handler = getgenv()._YDX_TOF_SHOP_HANDLER
            if handler then
                local handled, res = handler(...)
                if handled then
                    return res
                end
            end
        end
        return oldNamecall(self, ...)
    end)
end

getgenv()._YDX_TOF_SHOP_HANDLER = function(action, arg1)
    if not watcherActive then
        return false, nil
    end
    return handleShopAction(action, arg1)
end

-- ============================================================================
-- 8. CHARACTER & HEARTBEAT ENFORCEMENT + P2P SYNC LOOP
-- ============================================================================
local function hookCharacter(char)
    if not char then
        return
    end
    if selectedCape ~= nil then
        pcall(function()
            char:SetAttribute("Cape", selectedCape)
        end)
    end
    table.insert(connections, char:GetAttributeChangedSignal("Cape"):Connect(function()
        if not watcherActive then
            return
        end
        if selectedCape ~= nil and char:GetAttribute("Cape") ~= selectedCape then
            pcall(function()
                char:SetAttribute("Cape", selectedCape)
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

-- P2P background polling & heartbeat broadcast
task.spawn(function()
    task.wait(0.5)
    broadcastCape(true)
    pollPeerCapes()
    while watcherActive and task.wait(6) do
        if not watcherActive then
            break
        end
        broadcastCape(false)
        pollPeerCapes()
    end
end)

-- Notify user in-game
pcall(function()
    if Hud and type(Hud.notify) == "function" then
        Hud.notify("\194\167a\194\167lUNLOCK ALL READY! \194\167f37 Capes + Fast Skip Spin unlocked!", 4)
    elseif LobbyUi and type(LobbyUi.notify) == "function" then
        LobbyUi.notify("\194\167a\194\167lUNLOCK ALL READY! \194\167f37 Capes + Fast Skip Spin unlocked!")
    end
end)

getgenv()._YDX_TOF_CLEANUP = function()
    watcherActive = false
    getgenv()._YDX_TOF_SHOP_HANDLER = nil
    for _, conn in ipairs(connections) do
        pcall(function()
            conn:Disconnect()
        end)
    end
    table.clear(connections)
    if Config then
        if origCapeVisible then
            Config.capeVisible = origCapeVisible
        end
        if origVisibleCapes then
            Config.visibleCapes = origVisibleCapes
        end
    end
    if LobbyUi then
        if origSetProfile then
            LobbyUi.setProfile = origSetProfile
        end
        if origLobbyInvoke then
            LobbyUi.invoke = origLobbyInvoke
            if type(LobbyUi.H) == "table" then
                LobbyUi.H.invoke = origLobbyInvoke
            end
        end
    end
end
