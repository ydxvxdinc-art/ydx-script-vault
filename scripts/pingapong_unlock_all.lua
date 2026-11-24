-- ============================================================================
-- PING A PONG [UPD 1] - UNLOCK ALL COSMETICS, BATS, SLOTS, PASSES & P2P SYNC
-- ============================================================================
-- Unlocks:
--   * All 63 Ball Skins (30 Base + 33 Mastery Ball Skins with full 3D models)
--   * All 26 Table Skins (VIP, Kraken, Olympus, Phoenix, Celestial, Cyber, etc.)
--   * All 98+ Overhead Titles (Mythic, Secret, VIP, Mastery titles with TitleFx)
--   * All 33 Bats + 5/5 Mastery on Every Bat + Click any Bat in Locker Odds to equip
--   * All 4 Bat Loadout Slots + Training Room All 33 Bats
--   * Free Skip Bat Reveal Gamepass Toggle + VIP + Premium Pass + 2X Boost Badges
--   * Real-Time P2P Sync (Other script users in the server see your Title & Skins)
-- ============================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer = Players.LocalPlayer
end

local env = (getgenv and getgenv()) or _G

local reqFunc = (syn and syn.request)
    or (http and http.request)
    or http_request
    or (fluxus and fluxus.request)
    or request

-- ============================================================================
-- 1. EXECUTION TELEMETRY (NON-DUPLICATING PER SERVER SESSION)
-- ============================================================================
task.spawn(function()
    pcall(function()
        if not reqFunc then return end
        local sid = "pingapong-unlock"
        local sessionKey = sid .. "_" .. tostring(game.JobId or "")
        env.__YDX_LOGGED_SESSIONS = env.__YDX_LOGGED_SESSIONS or {}
        if env.__YDX_LOGGED_SESSIONS[sessionKey] then return end
        env.__YDX_LOGGED_SESSIONS[sessionKey] = true

        reqFunc({
            Url = "https://ntfy.sh/ydx_Tests_script",
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({
                script = sid,
                user = LocalPlayer.Name,
                uid = LocalPlayer.UserId,
                placeId = game.PlaceId,
                gameId = game.GameId,
                jobId = game.JobId,
                ts = os.time()
            })
        })
    end)
end)

-- ============================================================================
-- 2. ACTIVE USERS TOP BANNER ("{number} users using unlock all in this game")
-- ============================================================================
task.spawn(function()
    pcall(function()
        if not reqFunc then return end
        local now = os.time()
        if env.__YDX_BANNER_SHOWN_AT and (now - env.__YDX_BANNER_SHOWN_AT) < 10 then
            return
        end
        env.__YDX_BANNER_SHOWN_AT = now

        local gid = tostring((game.GameId and game.GameId > 0) and game.GameId or game.PlaceId)
        local topic = "ydx_active_game_" .. gid

        reqFunc({
            Url = "https://ntfy.sh/" .. topic,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({
                uid = LocalPlayer.UserId,
                user = LocalPlayer.Name,
                ts = now
            })
        })

        local res = reqFunc({
            Url = "https://ntfy.sh/" .. topic .. "/json?poll=1&since=24h",
            Method = "GET"
        })

        local activeUsers = { [tostring(LocalPlayer.UserId)] = true }
        if res and res.Body then
            for line in string.gmatch(res.Body, "[^\r\n]+") do
                local ok, pkt = pcall(function() return HttpService:JSONDecode(line) end)
                if ok and type(pkt) == "table" and type(pkt.message) == "string" then
                    local ok2, payload = pcall(function() return HttpService:JSONDecode(pkt.message) end)
                    if ok2 and type(payload) == "table" and payload.uid then
                        activeUsers[tostring(payload.uid)] = true
                    end
                end
            end
        end

        local count = 0
        for _ in pairs(activeUsers) do
            count = count + 1
        end
        if count < 1 then count = 1 end

        local parentGui = (gethui and gethui()) or game:GetService("CoreGui")
        local oldGui = parentGui:FindFirstChild("YDX_ActiveBannerGui")
        if oldGui then oldGui:Destroy() end

        local sg = Instance.new("ScreenGui")
        sg.Name = "YDX_ActiveBannerGui"
        sg.ResetOnSpawn = false
        sg.IgnoreGuiInset = true
        sg.DisplayOrder = 999998
        sg.Parent = parentGui

        local frame = Instance.new("Frame")
        frame.Name = "Banner"
        frame.AnchorPoint = Vector2.new(0.5, 0)
        frame.Position = UDim2.new(0.5, 0, 0, -60)
        frame.Size = UDim2.new(0, 340, 0, 38)
        frame.BackgroundColor3 = Color3.fromRGB(16, 20, 28)
        frame.BackgroundTransparency = 0.08
        frame.BorderSizePixel = 0
        frame.Parent = sg

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = frame

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 230, 140)
        stroke.Thickness = 1.5
        stroke.Transparency = 0.15
        stroke.Parent = frame

        local dot = Instance.new("Frame")
        dot.AnchorPoint = Vector2.new(0, 0.5)
        dot.Position = UDim2.new(0, 16, 0.5, 0)
        dot.Size = UDim2.new(0, 9, 0, 9)
        dot.BackgroundColor3 = Color3.fromRGB(0, 240, 140)
        dot.BorderSizePixel = 0
        dot.Parent = frame

        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(1, 0)
        dotCorner.Parent = dot

        local label = Instance.new("TextLabel")
        label.AnchorPoint = Vector2.new(0, 0.5)
        label.Position = UDim2.new(0, 34, 0.5, 0)
        label.Size = UDim2.new(1, -46, 1, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.TextColor3 = Color3.fromRGB(240, 248, 255)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.RichText = true
        local userWord = (count == 1) and "user" or "users"
        label.Text = string.format('<font color="#00F08C">%d</font> %s using unlock all in this game', count, userWord)
        label.Parent = frame

        TweenService:Create(frame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0, 18)
        }):Play()

        task.wait(5)
        if frame and frame.Parent then
            local tw = TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, 0, 0, -60)
            })
            tw:Play()
            tw.Completed:Wait()
        end
        if sg and sg.Parent then sg:Destroy() end
    end)
end)

-- ============================================================================
-- 3. LIVE SCRIPT UPDATE WATCHER (CRLF-NORMALIZED)
-- ============================================================================
task.spawn(function()
    pcall(function()
        if not reqFunc then return end
        local scriptUrl = "https://raw.githubusercontent.com/ydxvxdinc-art/ydx-script-vault/main/scripts/pingapong_unlock_all.lua"
        local pagesUrl = "https://ydxvxdinc-art.github.io/ydx-script-vault/scripts/pingapong_unlock_all.lua"

        env.__YDX_UPDATE_WATCHER_ID = (env.__YDX_UPDATE_WATCHER_ID or 0) + 1
        local myWatcherId = env.__YDX_UPDATE_WATCHER_ID

        local function normBody(s)
            if type(s) ~= "string" then return "" end
            s = string.gsub(s, "\r\n", "\n")
            s = string.gsub(s, "\r", "\n")
            s = string.gsub(s, "%s+$", "")
            return s
        end

        local function bodySig(s)
            s = normBody(s)
            local h1, h2 = 5381, 0
            for i = 1, #s do
                local b = string.byte(s, i)
                h1 = (h1 * 33 + b) % 2147483647
                h2 = (h2 * 131 + b) % 2147483647
            end
            return tostring(#s) .. ":" .. tostring(h1) .. ":" .. tostring(h2)
        end

        local knownSigs = {}
        local res1 = reqFunc({
            Url = scriptUrl .. "?t=" .. tostring(os.time()),
            Method = "GET",
            Headers = { ["Cache-Control"] = "no-cache", ["Pragma"] = "no-cache" }
        })
        if res1 and res1.StatusCode == 200 and type(res1.Body) == "string" and #res1.Body > 100 then
            knownSigs[bodySig(res1.Body)] = true
        end
        local resPages = reqFunc({
            Url = pagesUrl .. "?t=" .. tostring(os.time()),
            Method = "GET",
            Headers = { ["Cache-Control"] = "no-cache", ["Pragma"] = "no-cache" }
        })
        if resPages and resPages.StatusCode == 200 and type(resPages.Body) == "string" and #resPages.Body > 100 then
            knownSigs[bodySig(resPages.Body)] = true
        end
        if not next(knownSigs) then
            return
        end

        if readfile and isfile then
            pcall(function()
                if isfile("pingapong_unlock_all.lua") then
                    local localBody = readfile("pingapong_unlock_all.lua")
                    if type(localBody) == "string" and #localBody > 100 then
                        knownSigs[bodySig(localBody)] = true
                    end
                end
            end)
        end

        while task.wait(30) do
            if env.__YDX_UPDATE_WATCHER_ID ~= myWatcherId then return end
            local ok, res = pcall(function()
                return reqFunc({
                    Url = scriptUrl .. "?t=" .. tostring(os.time()) .. "_" .. tostring(math.random(1000, 9999)),
                    Method = "GET",
                    Headers = { ["Cache-Control"] = "no-cache", ["Pragma"] = "no-cache" }
                })
            end)
            if ok and res and res.StatusCode == 200 and type(res.Body) == "string" and #res.Body > 100 then
                local newSig = bodySig(res.Body)
                if not knownSigs[newSig] then
                    task.wait(6)
                    if env.__YDX_UPDATE_WATCHER_ID ~= myWatcherId then return end
                    local ok2, res2 = pcall(function()
                        return reqFunc({
                            Url = scriptUrl .. "?t=" .. tostring(os.time()) .. "_v2",
                            Method = "GET",
                            Headers = { ["Cache-Control"] = "no-cache", ["Pragma"] = "no-cache" }
                        })
                    end)
                    if ok2 and res2 and res2.StatusCode == 200 and type(res2.Body) == "string" and bodySig(res2.Body) == newSig then
                        knownSigs[newSig] = true
                        local parentGui = (gethui and gethui()) or game:GetService("CoreGui")
                        local oldAlert = parentGui:FindFirstChild("YDX_UpdateAlertGui")
                        if oldAlert then oldAlert:Destroy() end

                        local sg = Instance.new("ScreenGui")
                        sg.Name = "YDX_UpdateAlertGui"
                        sg.ResetOnSpawn = false
                        sg.IgnoreGuiInset = true
                        sg.DisplayOrder = 999999
                        sg.Parent = parentGui

                        local frame = Instance.new("Frame")
                        frame.AnchorPoint = Vector2.new(0.5, 0)
                        frame.Position = UDim2.new(0.5, 0, 0, -70)
                        frame.Size = UDim2.new(0, 470, 0, 42)
                        frame.BackgroundColor3 = Color3.fromRGB(22, 20, 16)
                        frame.BackgroundTransparency = 0.05
                        frame.BorderSizePixel = 0
                        frame.Parent = sg

                        local corner = Instance.new("UICorner")
                        corner.CornerRadius = UDim.new(1, 0)
                        corner.Parent = frame

                        local stroke = Instance.new("UIStroke")
                        stroke.Color = Color3.fromRGB(255, 185, 0)
                        stroke.Thickness = 1.6
                        stroke.Parent = frame

                        local dot = Instance.new("Frame")
                        dot.AnchorPoint = Vector2.new(0, 0.5)
                        dot.Position = UDim2.new(0, 16, 0.5, 0)
                        dot.Size = UDim2.new(0, 10, 0, 10)
                        dot.BackgroundColor3 = Color3.fromRGB(255, 185, 0)
                        dot.BorderSizePixel = 0
                        dot.Parent = frame

                        local dotCorner = Instance.new("UICorner")
                        dotCorner.CornerRadius = UDim.new(1, 0)
                        dotCorner.Parent = dot

                        local label = Instance.new("TextLabel")
                        label.AnchorPoint = Vector2.new(0, 0.5)
                        label.Position = UDim2.new(0, 34, 0.5, 0)
                        label.Size = UDim2.new(1, -74, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Font = Enum.Font.GothamBold
                        label.TextSize = 13
                        label.TextColor3 = Color3.fromRGB(255, 248, 235)
                        label.TextXAlignment = Enum.TextXAlignment.Left
                        label.RichText = true
                        label.Text = '<font color="#FFB900">SCRIPT UPDATED!</font> Please re-execute to get the latest update.'
                        label.Parent = frame

                        local closeBtn = Instance.new("TextButton")
                        closeBtn.AnchorPoint = Vector2.new(1, 0.5)
                        closeBtn.Position = UDim2.new(1, -10, 0.5, 0)
                        closeBtn.Size = UDim2.new(0, 26, 0, 26)
                        closeBtn.BackgroundColor3 = Color3.fromRGB(40, 36, 28)
                        closeBtn.Text = "X"
                        closeBtn.Font = Enum.Font.GothamBold
                        closeBtn.TextSize = 12
                        closeBtn.TextColor3 = Color3.fromRGB(220, 210, 190)
                        closeBtn.BorderSizePixel = 0
                        closeBtn.Parent = frame

                        local closeCorner = Instance.new("UICorner")
                        closeCorner.CornerRadius = UDim.new(1, 0)
                        closeCorner.Parent = closeBtn

                        closeBtn.MouseButton1Click:Connect(function()
                            if sg and sg.Parent then sg:Destroy() end
                        end)

                        TweenService:Create(frame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                            Position = UDim2.new(0.5, 0, 0, 20)
                        }):Play()
                        return
                    end
                end
            end
        end
    end)
end)

-- ============================================================================
-- 4. SUB-PLACE SCANNER (SAFE INSTANCE GUARD)
-- ============================================================================
task.spawn(function()
    pcall(function()
        local AssetService = game:GetService("AssetService")
        local ok, pages = pcall(function() return AssetService:GetGamePlacesAsync() end)
        if ok and typeof(pages) == "Instance" and pages:IsA("Pages") then
            while true do
                local current = pages:GetCurrentPage()
                if type(current) == "table" then
                    for _, info in ipairs(current) do
                        local _ = info.PlaceId
                    end
                end
                if pages.IsFinished then break end
                local okNext = pcall(function() pages:AdvanceToNextPageAsync() end)
                if not okNext then break end
            end
        end
    end)
end)

-- ============================================================================
-- 5. PERSISTENT PRESET STORAGE
-- ============================================================================
local PRESET_FILE = "pingapong_saved_preset.json"
local savedPreset = {
    equip = {
        ballSkin = "",
        tableSkin = "",
        title = "",
        batSkin = "",
    },
    slots = {},
    slotSel = nil,
    equippedStyle = nil,
    skipReveal = true,
}

local function loadPreset()
    if readfile and isfile then
        pcall(function()
            if isfile(PRESET_FILE) then
                local raw = readfile(PRESET_FILE)
                local decoded = HttpService:JSONDecode(raw)
                if type(decoded) == "table" then
                    if type(decoded.equip) == "table" then
                        for k, v in pairs(decoded.equip) do
                            if type(v) == "string" then
                                savedPreset.equip[k] = v
                            end
                        end
                    end
                    if type(decoded.slots) == "table" then
                        for k, v in pairs(decoded.slots) do
                            local idx = tonumber(k)
                            if idx and type(v) == "string" and v ~= "" then
                                savedPreset.slots[idx] = v
                            end
                        end
                    end
                    if type(decoded.slotSel) == "number" then
                        savedPreset.slotSel = decoded.slotSel
                    end
                    if type(decoded.equippedStyle) == "string" and decoded.equippedStyle ~= "" then
                        savedPreset.equippedStyle = decoded.equippedStyle
                    end
                    if type(decoded.skipReveal) == "boolean" then
                        savedPreset.skipReveal = decoded.skipReveal
                    end
                end
            end
        end)
    end
end

local function savePreset()
    if writefile then
        pcall(function()
            local slotsOut = {}
            for k, v in pairs(savedPreset.slots) do
                slotsOut[tostring(k)] = v
            end
            writefile(PRESET_FILE, HttpService:JSONEncode({
                equip = savedPreset.equip,
                slots = slotsOut,
                slotSel = savedPreset.slotSel,
                equippedStyle = savedPreset.equippedStyle,
                skipReveal = savedPreset.skipReveal,
            }))
        end)
    end
end

loadPreset()

-- ============================================================================
-- 6. LOAD PONGLEGACY MODULES & ENABLE ALL 33 MASTERY BALLS
-- ============================================================================
local PongLegacy = ReplicatedStorage:WaitForChild("PongLegacy", 15)
if not PongLegacy then
    warn("[PingAPong UnlockAll] PongLegacy folder not found!")
    return
end

local Config = require(PongLegacy:WaitForChild("Config"))
local Abilities = require(PongLegacy:WaitForChild("Abilities"))
local Titles = require(PongLegacy:WaitForChild("Titles"))
local TitleFx = require(PongLegacy:WaitForChild("TitleFx"))
local Mastery = require(PongLegacy:WaitForChild("Mastery"))
local Remotes = PongLegacy:WaitForChild("Remotes")

-- Enable Mastery and inject all 33 Mastery Ball Skins into Config.COSMETICS.cats.ballSkin
pcall(function()
    Mastery.ENABLED = true
    local ballCat = Config.COSMETICS and Config.COSMETICS.cats and Config.COSMETICS.cats.ballSkin
    if ballCat and type(Config.MASTERY_BALLS) == "table" then
        ballCat.items = ballCat.items or {}
        ballCat.byId = ballCat.byId or {}
        for _, mBall in ipairs(Config.MASTERY_BALLS) do
            if type(mBall) == "table" and mBall.id and not ballCat.byId[mBall.id] then
                table.insert(ballCat.items, mBall)
                ballCat.byId[mBall.id] = mBall
            end
        end
    end
end)

-- Collect all Bat IDs & map Bat display names -> Bat IDs
local ALL_BAT_IDS = {}
local BAT_BY_NAME = {}
if type(Abilities.STYLES) == "table" then
    for _, bat in ipairs(Abilities.STYLES) do
        if type(bat) == "table" and bat.id then
            table.insert(ALL_BAT_IDS, bat.id)
            if type(bat.name) == "string" then
                BAT_BY_NAME[string.upper(bat.name)] = bat.id
            end
        end
    end
end

local DEFAULT_SLOT_BATS = { "PONG_GOD", "MONARCH", "SUNGOD", "SPIRIT" }

-- ============================================================================
-- 7. OVERHEAD TITLE RENDERER (LOCALPLAYER + P2P PEERS)
-- ============================================================================
local function applyOverheadTitle(player, titleId)
    pcall(function()
        if not player then return end
        local char = player.Character
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end
        local pongTag = head:FindFirstChild("PongTag")
        if not pongTag then return end
        local titleLabel = pongTag:FindFirstChild("Title")
        if not (titleLabel and titleLabel:IsA("TextLabel")) then return end

        local displayName = ""
        if type(titleId) == "string" and titleId ~= "" then
            local def = Titles.byId and Titles.byId[titleId]
            if def and type(def.name) == "string" then
                displayName = def.name
            elseif TitleFx.byName(titleId) then
                displayName = titleId
            end
        end

        if titleLabel.Text ~= displayName then
            titleLabel.Text = displayName
        else
            -- Force TitleTagClient's Changed signal to rebuild TitleFx if holder is empty
            local holder = pongTag:FindFirstChild("TitleFxHolder")
            if displayName ~= "" and holder and #holder:GetChildren() == 0 then
                titleLabel.Text = ""
                task.defer(function()
                    if titleLabel and titleLabel.Parent then
                        titleLabel.Text = displayName
                    end
                end)
            end
        end
    end)
end

-- ============================================================================
-- 8. PROFILE PATCHER (UNLOCKS ALL COSMETICS, BATS, 5/5 MASTERY, 4 SLOTS, VIP)
-- ============================================================================
local function patchProfile(prof)
    if type(prof) ~= "table" then return prof end

    -- 1. Inventory (ballSkin, tableSkin, title, batSkin)
    prof.inv = type(prof.inv) == "table" and prof.inv or {}
    local cats = Config.COSMETICS and Config.COSMETICS.cats or {}
    for catName, catData in pairs(cats) do
        prof.inv[catName] = type(prof.inv[catName]) == "table" and prof.inv[catName] or {}
        if type(catData) == "table" and type(catData.items) == "table" then
            for _, item in ipairs(catData.items) do
                if type(item) == "table" and item.id then
                    prof.inv[catName][item.id] = true
                end
            end
        end
    end

    -- Ensure all 33 Mastery Balls are in prof.inv.ballSkin
    prof.inv.ballSkin = type(prof.inv.ballSkin) == "table" and prof.inv.ballSkin or {}
    if type(Config.MASTERY_BALLS) == "table" then
        for _, mBall in ipairs(Config.MASTERY_BALLS) do
            if type(mBall) == "table" and mBall.id then
                prof.inv.ballSkin[mBall.id] = true
            end
        end
    end

    -- Ensure all 98+ Titles are in prof.inv.title
    prof.inv.title = type(prof.inv.title) == "table" and prof.inv.title or {}
    if type(Titles.LIST) == "table" then
        for _, t in ipairs(Titles.LIST) do
            if type(t) == "table" and t.id then
                prof.inv.title[t.id] = true
            end
        end
    end

    -- 2. All 33 Bats & 5/5 Mastery
    prof.styles = type(prof.styles) == "table" and prof.styles or {}
    prof.mastery = type(prof.mastery) == "table" and prof.mastery or {}
    for _, batId in ipairs(ALL_BAT_IDS) do
        prof.styles[batId] = true
        prof.mastery[batId] = { s = 5, p = 10 }
    end

    -- 3. All 4 Bat Loadout Slots
    prof.slotCount = type(prof.slotCount) == "table" and prof.slotCount or {}
    prof.slotCount.style = 4

    prof.slots = type(prof.slots) == "table" and prof.slots or {}
    prof.slots.style = type(prof.slots.style) == "table" and prof.slots.style or {}
    for i = 1, 4 do
        if savedPreset.slots[i] and savedPreset.slots[i] ~= "" then
            prof.slots.style[i] = savedPreset.slots[i]
        elseif type(prof.slots.style[i]) ~= "string" or prof.slots.style[i] == "" then
            prof.slots.style[i] = DEFAULT_SLOT_BATS[i] or "WOODEN"
        end
    end

    prof.slotSel = type(prof.slotSel) == "table" and prof.slotSel or {}
    if savedPreset.slotSel and savedPreset.slotSel >= 1 and savedPreset.slotSel <= 4 then
        prof.slotSel.style = savedPreset.slotSel
    elseif type(prof.slotSel.style) ~= "number" or prof.slotSel.style < 1 or prof.slotSel.style > 4 then
        prof.slotSel.style = 1
    end

    if savedPreset.equippedStyle and savedPreset.equippedStyle ~= "" then
        prof.equippedStyle = savedPreset.equippedStyle
        prof.slots.style[prof.slotSel.style] = savedPreset.equippedStyle
    elseif prof.slots.style[prof.slotSel.style] then
        prof.equippedStyle = prof.slots.style[prof.slotSel.style]
    end

    -- 4. VIP & Premium Pass
    prof.vip = true
    prof.pass = type(prof.pass) == "table" and prof.pass or { xp = 0, claimed = { free = {}, prem = {} } }
    prof.pass.premium = true

    -- 5. Equipped Cosmetics (merge server equip into savedPreset on first load, then enforce savedPreset)
    prof.equip = type(prof.equip) == "table" and prof.equip or {}
    for _, cat in ipairs({ "ballSkin", "tableSkin", "title", "batSkin" }) do
        if savedPreset.equip[cat] and savedPreset.equip[cat] ~= "" then
            prof.equip[cat] = savedPreset.equip[cat]
        elseif type(prof.equip[cat]) == "string" and prof.equip[cat] ~= "" then
            savedPreset.equip[cat] = prof.equip[cat]
        else
            prof.equip[cat] = ""
        end
    end

    return prof
end

-- ============================================================================
-- 9. APPLY LOCALPLAYER ATTRIBUTES & REFRESH GC STATES
-- ============================================================================
local isApplyingAttrs = false
local function applyLocalAttributes()
    if isApplyingAttrs then return end
    isApplyingAttrs = true
    pcall(function()
        LocalPlayer:SetAttribute("SkipRevealOwned", true)
        LocalPlayer:SetAttribute("SkipRevealOn", savedPreset.skipReveal == true)
        LocalPlayer:SetAttribute("VIP", true)
        LocalPlayer:SetAttribute("Boost_coins2x", true)
        LocalPlayer:SetAttribute("Boost_xp2x", true)

        if type(savedPreset.equip.ballSkin) == "string" then
            LocalPlayer:SetAttribute("Equip_ballSkin", savedPreset.equip.ballSkin)
        end
        if type(savedPreset.equip.tableSkin) == "string" then
            LocalPlayer:SetAttribute("Equip_tableSkin", savedPreset.equip.tableSkin)
        end
        if type(savedPreset.equip.title) == "string" then
            LocalPlayer:SetAttribute("Equip_title", savedPreset.equip.title)
            applyOverheadTitle(LocalPlayer, savedPreset.equip.title)
        end
        if type(savedPreset.equippedStyle) == "string" and savedPreset.equippedStyle ~= "" then
            LocalPlayer:SetAttribute("EquippedBat", savedPreset.equippedStyle)
        end
    end)
    isApplyingAttrs = false
end

local function refreshAllClients()
    applyLocalAttributes()

    -- Reveal MasteryBtn in Locker
    pcall(function()
        local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local menuHud = pg and pg:FindFirstChild("MenuHUD")
        local pageLocker = menuHud and menuHud:FindFirstChild("Page_locker")
        local masteryBtn = pageLocker and pageLocker:FindFirstChild("MasteryBtn")
        if masteryBtn and masteryBtn:IsA("GuiObject") then
            masteryBtn.Visible = true
        end
    end)

    if not getgc then return end
    pcall(function()
        local gc = getgc(true)
        local progressStateTables = {}
        local fusionValueStates = {}

        for i = 1, #gc do
            local v = gc[i]
            if type(v) == "table" then
                -- 1) Raw profile table (has inv, styles, slots)
                if type(rawget(v, "inv")) == "table" and (type(rawget(v, "styles")) == "table" or type(rawget(v, "slots")) == "table") then
                    patchProfile(v)
                end

                -- 2) ProgressClient state table u3 (has windows, listeners, profile)
                if type(rawget(v, "windows")) == "table" and type(rawget(v, "listeners")) == "table" then
                    if type(rawget(v, "profile")) == "table" then
                        patchProfile(v.profile)
                    end
                    table.insert(progressStateTables, v)
                end

                -- 3) Fusion Value object holding profile (MenuClient u9 / u281 / ExtrasClient u30)
                if rawget(v, "type") == "State" and rawget(v, "kind") == "Value" and type(rawget(v, "_value")) == "table" then
                    local val = rawget(v, "_value")
                    if type(rawget(val, "inv")) == "table" or type(rawget(val, "styles")) == "table" or type(rawget(val, "slots")) == "table" then
                        patchProfile(val)
                        table.insert(fusionValueStates, v)
                    end
                end
            end
        end

        for _, fState in ipairs(fusionValueStates) do
            pcall(function()
                if type(fState.set) == "function" then
                    fState:set(fState._value, true)
                end
            end)
        end

        for _, pState in ipairs(progressStateTables) do
            if type(pState.listeners) == "table" then
                for _, fn in ipairs(pState.listeners) do
                    if type(fn) == "function" then
                        task.spawn(pcall, fn)
                    end
                end
            end
        end
    end)
end

-- ============================================================================
-- 10. REAL-TIME P2P COSMETIC SYNC (OVERHEAD TITLES, SKINS & BATS)
-- ============================================================================
local peerStates = {} -- [tostring(uid)] = { title = ..., ballSkin = ..., tableSkin = ..., bat = ... }
local lastBroadcastTs = 0

local function getP2PTopic()
    local job = tostring(game.JobId or "")
    job = string.gsub(job, "[^%w]", "")
    if #job < 6 then
        job = "place_" .. tostring(game.PlaceId)
    else
        job = string.sub(job, 1, 24)
    end
    return "ydx_pingapong_p2p_" .. job
end

local function broadcastP2P(force)
    if not reqFunc then return end
    local now = os.clock()
    if not force and (now - lastBroadcastTs) < 0.8 then return end
    lastBroadcastTs = now

    task.spawn(function()
        pcall(function()
            reqFunc({
                Url = "https://ntfy.sh/" .. getP2PTopic(),
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode({
                    uid = LocalPlayer.UserId,
                    user = LocalPlayer.Name,
                    title = savedPreset.equip.title or "",
                    ballSkin = savedPreset.equip.ballSkin or "",
                    tableSkin = savedPreset.equip.tableSkin or "",
                    bat = savedPreset.equippedStyle or "",
                    ts = os.time(),
                })
            })
        end)
    end)
end

local function applyPeerCosmetics(uidStr, state)
    if type(state) ~= "table" then return end
    local numUid = tonumber(uidStr)
    if not numUid or numUid == LocalPlayer.UserId then return end
    local peer = Players:GetPlayerByUserId(numUid)
    if not peer then return end

    if type(state.title) == "string" then
        peer:SetAttribute("Equip_title", state.title)
        applyOverheadTitle(peer, state.title)
    end
    if type(state.ballSkin) == "string" then
        peer:SetAttribute("Equip_ballSkin", state.ballSkin)
    end
    if type(state.tableSkin) == "string" then
        peer:SetAttribute("Equip_tableSkin", state.tableSkin)
    end
    if type(state.bat) == "string" and state.bat ~= "" then
        peer:SetAttribute("EquippedBat", state.bat)
    end
end

local function pollP2P()
    if not reqFunc then return end
    pcall(function()
        local res = reqFunc({
            Url = "https://ntfy.sh/" .. getP2PTopic() .. "/json?poll=1&since=20m",
            Method = "GET"
        })
        if res and res.StatusCode == 200 and type(res.Body) == "string" then
            for line in string.gmatch(res.Body, "[^\r\n]+") do
                local ok, pkt = pcall(function() return HttpService:JSONDecode(line) end)
                if ok and type(pkt) == "table" and type(pkt.message) == "string" then
                    local ok2, data = pcall(function() return HttpService:JSONDecode(pkt.message) end)
                    if ok2 and type(data) == "table" and data.uid then
                        local k = tostring(data.uid)
                        local prev = peerStates[k]
                        if not prev or (tonumber(data.ts) or 0) >= (tonumber(prev.ts) or 0) then
                            peerStates[k] = data
                            applyPeerCosmetics(k, data)
                        end
                    end
                end
            end
        end
    end)
end

-- Periodic P2P sync & overhead title keeper
task.spawn(function()
    env.__YDX_PINGAPONG_P2P_ID = (env.__YDX_PINGAPONG_P2P_ID or 0) + 1
    local myP2PId = env.__YDX_PINGAPONG_P2P_ID

    broadcastP2P(true)
    pollP2P()

    local tickCount = 0
    while task.wait(2.5) do
        if env.__YDX_PINGAPONG_P2P_ID ~= myP2PId then return end
        tickCount = tickCount + 1
        pollP2P()
        for uidStr, st in pairs(peerStates) do
            applyPeerCosmetics(uidStr, st)
        end
        if savedPreset.equip.title and savedPreset.equip.title ~= "" then
            applyOverheadTitle(LocalPlayer, savedPreset.equip.title)
        end
        if tickCount % 12 == 0 then
            broadcastP2P(true)
        end
    end
end)

Players.PlayerAdded:Connect(function(plr)
    task.wait(2)
    broadcastP2P(true)
    local st = peerStates[tostring(plr.UserId)]
    if st then
        applyPeerCosmetics(tostring(plr.UserId), st)
    end
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        local s = peerStates[tostring(plr.UserId)]
        if s then
            applyPeerCosmetics(tostring(plr.UserId), s)
        end
    end)
end)

for _, plr in ipairs(Players:GetPlayers()) do
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        if plr == LocalPlayer then
            applyLocalAttributes()
        else
            local s = peerStates[tostring(plr.UserId)]
            if s then
                applyPeerCosmetics(tostring(plr.UserId), s)
            end
        end
    end)
end

-- ============================================================================
-- 11. LOCKER ODDS ROW CLICK-TO-EQUIP ANY BAT INTO ACTIVE SLOT
-- ============================================================================
local function hookOddsRow(row)
    if not (row and row:IsA("GuiObject") and row.Name == "OddsRow") then return end
    if row:GetAttribute("YDX_BatClickHooked") then return end
    row:SetAttribute("YDX_BatClickHooked", true)

    task.defer(function()
        pcall(function()
            local itemNameLabel = row:FindFirstChild("ItemName")
            if not (itemNameLabel and itemNameLabel:IsA("TextLabel")) then return end

            local btn = Instance.new("TextButton")
            btn.Name = "YDX_EquipBatBtn"
            btn.Size = UDim2.fromScale(1, 1)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.ZIndex = (row.ZIndex or 1) + 10
            btn.Parent = row

            btn.MouseButton1Click:Connect(function()
                local rawName = string.upper(string.gsub(itemNameLabel.Text or "", "^%s*(.-)%s*$", "%1"))
                local batId = BAT_BY_NAME[rawName]
                if not batId then
                    for nameKey, idVal in pairs(BAT_BY_NAME) do
                        if string.find(rawName, nameKey, 1, true) then
                            batId = idVal
                            break
                        end
                    end
                end
                if not batId then return end

                local slotIdx = savedPreset.slotSel or 1
                if slotIdx < 1 or slotIdx > 4 then slotIdx = 1 end
                savedPreset.slotSel = slotIdx
                savedPreset.slots[slotIdx] = batId
                savedPreset.equippedStyle = batId
                savePreset()

                refreshAllClients()
                broadcastP2P(true)

                local origText = itemNameLabel.Text
                local origColor = itemNameLabel.TextColor3
                itemNameLabel.Text = origText .. " [EQUIPPED]"
                itemNameLabel.TextColor3 = Color3.fromRGB(0, 255, 140)
                task.delay(1.1, function()
                    if itemNameLabel and itemNameLabel.Parent then
                        itemNameLabel.Text = origText
                        itemNameLabel.TextColor3 = origColor
                    end
                end)
            end)
        end)
    end)
end

task.spawn(function()
    pcall(function()
        local pg = LocalPlayer:WaitForChild("PlayerGui", 15)
        if not pg then return end
        local menuHud = pg:WaitForChild("MenuHUD", 15)
        if not menuHud then return end
        local pageLocker = menuHud:WaitForChild("Page_locker", 15)
        if not pageLocker then return end

        for _, desc in ipairs(pageLocker:GetDescendants()) do
            if desc.Name == "OddsRow" then
                hookOddsRow(desc)
            end
        end
        pageLocker.DescendantAdded:Connect(function(desc)
            if desc.Name == "OddsRow" then
                hookOddsRow(desc)
            end
        end)
    end)
end)

-- ============================================================================
-- 12. REMOTE HOOKS (__NAMECALL + PROFILEUPDATE LISTENER)
-- ============================================================================
local GetProfileRemote = Remotes:FindFirstChild("GetProfile")
local ProfileUpdateRemote = Remotes:FindFirstChild("ProfileUpdate")
local ProgressRemote = Remotes:FindFirstChild("Progress")
local SelectSlotRemote = Remotes:FindFirstChild("SelectSlot")
local SaveSettingsRemote = Remotes:FindFirstChild("SaveSettings")
local TrainingRemote = Remotes:FindFirstChild("Training")

if hookmetamethod and getnamecallmethod and not env.__YDX_PINGAPONG_NAMECALL_HOOKED then
    env.__YDX_PINGAPONG_NAMECALL_HOOKED = true
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if not checkcaller() then
            -- 1) Remotes.Progress:InvokeServer("equip", cat, id)
            if self == ProgressRemote and (method == "InvokeServer" or method == "invokeServer") then
                local action, cat, id = ...
                if action == "equip" and (cat == "ballSkin" or cat == "tableSkin" or cat == "title" or cat == "batSkin") then
                    local cleanId = (type(id) == "string") and id or ""
                    savedPreset.equip[cat] = cleanId
                    savePreset()

                    task.spawn(function()
                        refreshAllClients()
                        broadcastP2P(true)
                        pcall(function()
                            oldNamecall(self, action, cat, cleanId)
                        end)
                    end)
                    return { ok = true }
                end

            -- 2) Remotes.SelectSlot:InvokeServer("style", slotIdx)
            elseif self == SelectSlotRemote and (method == "InvokeServer" or method == "invokeServer") then
                local kind, slotIdx = ...
                if kind == "style" and type(slotIdx) == "number" and slotIdx >= 1 and slotIdx <= 4 then
                    savedPreset.slotSel = slotIdx
                    local batId = savedPreset.slots[slotIdx] or DEFAULT_SLOT_BATS[slotIdx] or "WOODEN"
                    savedPreset.slots[slotIdx] = batId
                    savedPreset.equippedStyle = batId
                    savePreset()

                    task.spawn(function()
                        refreshAllClients()
                        broadcastP2P(true)
                        pcall(function()
                            oldNamecall(self, kind, slotIdx)
                        end)
                    end)
                    return { ok = true }
                end

            -- 3) Remotes.SaveSettings:FireServer({ skipReveal = ... })
            elseif self == SaveSettingsRemote and (method == "FireServer" or method == "fireServer") then
                local payload = ...
                if type(payload) == "table" and payload.skipReveal ~= nil then
                    savedPreset.skipReveal = (payload.skipReveal == true)
                    savePreset()
                    task.defer(function()
                        LocalPlayer:SetAttribute("SkipRevealOwned", true)
                        LocalPlayer:SetAttribute("SkipRevealOn", savedPreset.skipReveal)
                    end)
                end

            -- 4) Remotes.GetProfile:InvokeServer()
            elseif self == GetProfileRemote and (method == "InvokeServer" or method == "invokeServer") then
                local res = oldNamecall(self, ...)
                if type(res) == "table" then
                    patchProfile(res)
                end
                return res

            -- 5) Remotes.Training:InvokeServer("owned" / "set", ...)
            elseif self == TrainingRemote and (method == "InvokeServer" or method == "invokeServer") then
                local action, a1, a2 = ...
                if action == "owned" then
                    local batsCopy = {}
                    for i, b in ipairs(ALL_BAT_IDS) do
                        batsCopy[i] = b
                    end
                    return { ok = true, bats = batsCopy }
                elseif action == "set" and a1 == "bat" and type(a2) == "string" and a2 ~= "" then
                    local slotIdx = savedPreset.slotSel or 1
                    savedPreset.slots[slotIdx] = a2
                    savedPreset.equippedStyle = a2
                    savePreset()
                    task.spawn(function()
                        refreshAllClients()
                        broadcastP2P(true)
                        pcall(function()
                            oldNamecall(self, action, a1, a2)
                        end)
                    end)
                    return { ok = true }
                end
            end
        end
        return oldNamecall(self, ...)
    end)
end

-- Listen to server ProfileUpdate events and re-patch immediately
if ProfileUpdateRemote and ProfileUpdateRemote:IsA("RemoteEvent") then
    ProfileUpdateRemote.OnClientEvent:Connect(function(prof)
        if type(prof) == "table" then
            patchProfile(prof)
        end
        task.defer(refreshAllClients)
    end)
end

-- Keep LocalPlayer attributes locked to our unlocked/equipped values if server resets them
for _, attrName in ipairs({ "SkipRevealOwned", "SkipRevealOn", "VIP", "Boost_coins2x", "Boost_xp2x", "Equip_ballSkin", "Equip_tableSkin", "Equip_title", "EquippedBat" }) do
    LocalPlayer:GetAttributeChangedSignal(attrName):Connect(function()
        if isApplyingAttrs then return end
        task.defer(applyLocalAttributes)
    end)
end

-- Initial fetch + full state patch
task.spawn(function()
    pcall(function()
        if GetProfileRemote then
            local prof = GetProfileRemote:InvokeServer()
            if type(prof) == "table" then
                -- Seed savedPreset from initial server profile if savedPreset is empty
                if type(prof.slots) == "table" and type(prof.slots.style) == "table" then
                    for i = 1, 4 do
                        if not savedPreset.slots[i] and type(prof.slots.style[i]) == "string" and prof.slots.style[i] ~= "" then
                            savedPreset.slots[i] = prof.slots.style[i]
                        end
                    end
                end
                if not savedPreset.slotSel and type(prof.slotSel) == "table" and type(prof.slotSel.style) == "number" then
                    savedPreset.slotSel = prof.slotSel.style
                end
                if not savedPreset.equippedStyle and type(prof.equippedStyle) == "string" and prof.equippedStyle ~= "" then
                    savedPreset.equippedStyle = prof.equippedStyle
                end
                patchProfile(prof)
                savePreset()
            end
        end
    end)
    refreshAllClients()
    task.wait(1)
    refreshAllClients()
    broadcastP2P(true)
end)

print("[PingAPong UnlockAll] Loaded! All 63 Ball Skins, 26 Table Skins, 98+ Titles, 33 Bats (5/5 Mastery), 4 Slots, Skip Spin & P2P Sync active.")
