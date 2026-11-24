-- ============================================================================
-- [UPD] VOLLEYBALL LEGENDS - UNLOCK ALL + REAL-TIME P2P SYNC
-- [YDX Execution Telemetry - Non-Duplicating when loaded via Universal Loader]
do
    local env = (type(getgenv) == "function" and getgenv()) or _G
    env.__YDX_EXEC_LOCKS = env.__YDX_EXEC_LOCKS or {}
    local sid = "volleyball-unlock"
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
                local h = 2166136261
                local len = #s
                local step = math.max(1, math.floor(len / 512))
                for i = 1, len, step do
                    h = (h * 16777619 + string.byte(s, i)) % 4294967296
                end
                return tostring(len) .. ":" .. tostring(h)
            end

            local rawBase = "https://raw.githubusercontent.com/ydxvxdinc-art/ydx-script-vault/main/"
            local ghBase = "https://ydxvxdinc-art.github.io/ydx-script-vault/"
            local function fetchRemoteSig()
                if not rPath then return nil end
                local cb = "?cb=" .. tostring(os.time()) .. "_" .. tostring(math.random(1000, 9999))
                local okR, body = pcall(function() return game:HttpGet(rawBase .. rPath .. cb) end)
                if not okR or type(body) ~= "string" or #body < 64 then
                    okR, body = pcall(function() return game:HttpGet(ghBase .. rPath .. cb) end)
                end
                if okR and type(body) == "string" and #body >= 64 then
                    return computeSig(body)
                end
                return nil
            end

            local startUnix = os.time()
            local baseSig = fetchRemoteSig()
            local ntfyUpdUrl = "https://ntfy.sh/ydx_vault_updates_7c9e2a4b/json?poll=1&since="

            while env.__YDX_UPDATE_WATCH_GEN[sid] == myGen do
                task.wait(20)
                if env.__YDX_UPDATE_WATCH_GEN[sid] ~= myGen then break end
                local updated = false
                local okN, nBody = pcall(function() return game:HttpGet(ntfyUpdUrl .. tostring(startUnix + 1)) end)
                if okN and type(nBody) == "string" and #nBody > 0 then
                    for line in nBody:gmatch("[^\r\n]+") do
                        local okJ, obj = pcall(function() return HttpService:JSONDecode(line) end)
                        if okJ and type(obj) == "table" and obj.event == "message" and type(obj.message) == "string" then
                            local msg = obj.message:lower()
                            local sidLow = sid:lower()
                            if msg == "all" or msg == sidLow or msg:sub(1, #sidLow + 1) == (sidLow .. ":") then
                                if type(obj.time) ~= "number" or obj.time > startUnix then
                                    updated = true
                                    break
                                end
                            end
                        end
                    end
                end
                if not updated and rPath then
                    local curSig = fetchRemoteSig()
                    if curSig then
                        if not baseSig then baseSig = curSig
                        elseif curSig ~= baseSig then updated = true end
                    end
                end
                if updated then
                    showUpdateBanner()
                    break
                end
            end
        end)
    end
end
-- Categories Unlocked:
--   * Balls (213+ Balls including Secret, Godly, Season, Ranked, Bundle, VIP)
--   * Score Effects / Score FX (185+ Score Effects + Random Favorite)
--   * Titles (654+ Titles including Owner, Developer, VIP, Season & Tournament #1)
--   * Emotes (93+ Emotes + Props + Sounds + Walkable Emotes + All 8 Wheel Slots)
--   * Player Cards (123+ Cards + FlashCard on Point Scored & MVP + Random Favorite)
--   * Chat Bubbles (All Chat Bubbles + All 8 Wheel Slots)
--   * Misc / Jerseys / Profile Art / Win Screens (All Jerseys, Profile Arts, Win Cutscenes)
--   * Profile Inspect Showcase (Equip any Title, Profile Art, Jersey, Card on Profile)
--   * Real-Time P2P Sync (Everyone using this script in the same server sees each
--     other's equipped Ball skin in live play + Replay, Score FX, FlashCard, Title,
--     Jersey, Emote + 3D Prop + Sound, Chat Bubble, Win Cutscene, and Profile Inspect!)
-- ============================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer = Players.LocalPlayer
end

-- Wait for core packages and data load
local Packages = ReplicatedStorage:WaitForChild("Packages", 15)
local Content = ReplicatedStorage:WaitForChild("Content", 15)
if not Packages or not Content then
    warn("[VolleyballUnlockAll] Failed to locate ReplicatedStorage.Packages/Content!")
    return
end

local Knit = require(Packages:WaitForChild("Knit"))
pcall(function()
    Knit.OnStart():expect()
end)

local Promise = require(Packages:WaitForChild("Promise"))
local Item = require(Content:WaitForChild("Item"))
local GamepassesList = nil
pcall(function()
    GamepassesList = require(Content:WaitForChild("Monetization"):WaitForChild("Gamepasses"))
end)

local StyleContent = nil
pcall(function()
    StyleContent = require(Content:WaitForChild("Style", 5))
end)

local JerseyTool = nil
pcall(function()
    JerseyTool = require(ReplicatedStorage:WaitForChild("Tools", 5):WaitForChild("Jersey", 5))
end)

local SoundTool = nil
pcall(function()
    SoundTool = require(ReplicatedStorage:WaitForChild("Tools", 5):WaitForChild("Sound", 5))
end)

local ChatBubbleComponent = nil
pcall(function()
    ChatBubbleComponent = require(ReplicatedFirst:WaitForChild("Components", 5):WaitForChild("ChatBubble", 5))
end)

local Persistence = nil
pcall(function()
    Persistence = require(ReplicatedFirst:WaitForChild("Components", 5):WaitForChild("Persistence", 5))
end)

local InventoryState = require(ReplicatedFirst:WaitForChild("UI"):WaitForChild("Screens"):WaitForChild("Inventory"):WaitForChild("State"))
local InspectState = nil
pcall(function()
    InspectState = require(ReplicatedFirst:WaitForChild("UI"):WaitForChild("Screens"):WaitForChild("PlayerInspect"):WaitForChild("State"))
end)

local InventoryController = nil
local EmoteController = nil
local ChatBubbleController = nil
local BallController = nil
local EffectController = nil
local PlayerCardController = nil
local AnimationController = nil

local StyleController = nil

pcall(function() InventoryController = Knit.GetController("InventoryController") end)
pcall(function() EmoteController = Knit.GetController("EmoteController") end)
pcall(function() ChatBubbleController = Knit.GetController("ChatBubbleController") end)
pcall(function() BallController = Knit.GetController("BallController") end)
pcall(function() EffectController = Knit.GetController("EffectController") end)
pcall(function() PlayerCardController = Knit.GetController("PlayerCardController") end)
pcall(function() AnimationController = Knit.GetController("AnimationController") end)
pcall(function() StyleController = Knit.GetController("StyleController") end)

local InventoryService = nil
local DataService = nil
local BallService = nil
local GameService = nil
local PlayerCardService = nil
local PlayerInspectService = nil

pcall(function() InventoryService = Knit.GetService("InventoryService") end)
pcall(function() DataService = Knit.GetService("DataService") end)
pcall(function() BallService = Knit.GetService("BallService") end)
pcall(function() GameService = Knit.GetService("GameService") end)
pcall(function() PlayerCardService = Knit.GetService("PlayerCardService") end)
pcall(function() PlayerInspectService = Knit.GetService("PlayerInspectService") end)

-- If already loaded, clean up previous listeners/loops and hot-reload cleanly
if type(_G.__VolleyballUnlockAllCleanup) == "function" then
    pcall(_G.__VolleyballUnlockAllCleanup)
end
local scriptRunToken = os.clock()
_G.__VolleyballUnlockAllToken = scriptRunToken
_G.__VolleyballUnlockAllLoaded = true

local scriptConnections = {}
local function trackConn(conn)
    if conn then
        table.insert(scriptConnections, conn)
    end
    return conn
end
_G.__VolleyballUnlockAllCleanup = function()
    for _, conn in ipairs(scriptConnections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(scriptConnections)
end

local BallLib = nil
pcall(function()
    BallLib = require(ReplicatedStorage:WaitForChild("Common", 5):WaitForChild("BallLib", 5))
end)

local BallModule = nil
pcall(function()
    BallModule = require(ReplicatedFirst:WaitForChild("Controllers", 5):WaitForChild("BallController", 5):WaitForChild("Ball", 5))
end)

-- ============================================================================
-- 1. STATE & PRESET PERSISTENCE
-- ============================================================================
local SAVE_FILE = "volleyball_saved_preset.json"
local realServerInventory = {}
local realServerGamepasses = {}

-- Build valid default lists for all 8 Emote slots and all 12 ChatBubble slots
-- so unequipped slots NEVER contain "" (which DisplayItem renders as "Unknown"!).
local VALID_EMOTE_IDS = {}
local VALID_CHATBUBBLE_IDS = {}
pcall(function()
    for _, item in pairs(Item:GetAll()) do
        if type(item) == "table" and type(item.Id) == "string" and item.Id ~= "" then
            if item.Type == Item.Type.Emote then
                table.insert(VALID_EMOTE_IDS, item.Id)
            elseif item.Type == Item.Type.ChatBubble then
                table.insert(VALID_CHATBUBBLE_IDS, item.Id)
            end
        end
    end
    table.sort(VALID_EMOTE_IDS)
    table.sort(VALID_CHATBUBBLE_IDS)
end)

local PREFERRED_DEFAULT_EMOTES = {
    "WaveEmote",
    "GriddyEmote",
    "SkiEmote",
    "VolcanoEmote",
    "TrickOrTreatEmote",
    "CoinFlipEmote",
    "CrabRaveEmote",
    "SantaSledEmote"
}
local PREFERRED_DEFAULT_BUBBLES = {
    "YesChatBubble",
    "SetMeChatBubble",
    "CalculatedChatBubble",
    "SpikeChatBubble",
    "RefChatBubble",
    "LagChatBubble",
    "AngryRobuxChatBubble",
    "NoChatBubble",
    "NiceChatBubble",
    "SorryChatBubble",
    "GGChatBubble",
    "BlockChatBubble"
}

local function normalizeWheelSlots(tbl, targetCount, expectedType, preferredDefaults, fallbackPool)
    local out = {}
    local src = type(tbl) == "table" and tbl or {}
    local validDefaults = {}
    for _, id in ipairs(preferredDefaults) do
        local it = Item:Get(id)
        if it and it.Type == expectedType then
            table.insert(validDefaults, id)
        end
    end
    for _, id in ipairs(fallbackPool) do
        if #validDefaults >= targetCount then
            break
        end
        if not table.find(validDefaults, id) then
            local it = Item:Get(id)
            if it and it.Type == expectedType then
                table.insert(validDefaults, id)
            end
        end
    end
    local firstFallback = validDefaults[1] or fallbackPool[1] or ""
    for i = 1, targetCount do
        local candidate = src[i]
        if type(candidate) == "string" and candidate ~= "" then
            local it = Item:Get(candidate)
            if it and it.Type == expectedType then
                out[i] = candidate
            end
        end
        if not out[i] then
            out[i] = validDefaults[((i - 1) % math.max(#validDefaults, 1)) + 1] or firstFallback
        end
    end
    return out
end

local customEquipped = {
    Ball = "ClassicBall",
    ScoreEffect = "ClassicScoreEffect",
    Title = "",
    PlayerCard = "Classic1PlayerCard",
    Jersey = "ClassicJersey",
    ProfileArt = "ClassicProfileArt",
    WinScreen = "ClassicWinScreen",
    Emotes = {},
    ChatBubbles = {}
}
local customFavorited = {}
local customShowcaseItems = { "Classic1PlayerCard", "", "", "" }

-- Snapshot existing server inventory, gamepasses & equipped items first
pcall(function()
    local curInv = InventoryState.inventory()
    if type(curInv) == "table" then
        for k, v in pairs(curInv) do
            if type(k) == "string" and type(v) == "number" and v > 0 then
                realServerInventory[k] = v
            end
        end
    end
end)

pcall(function()
    if Persistence and type(Persistence.bindToData) == "function" then
        local gpCell = Persistence.bindToData("Gamepasses")
        local curGp = gpCell and gpCell()
        if type(curGp) == "table" then
            for k, v in pairs(curGp) do
                if v == true then
                    realServerGamepasses[tostring(k)] = true
                    realServerGamepasses[k] = true
                end
            end
        end
    end
end)

pcall(function()
    local curEq = InventoryState.equipped()
    if type(curEq) == "table" then
        for k, v in pairs(curEq) do
            if type(v) == "table" then
                customEquipped[k] = table.clone(v)
            elseif v ~= nil then
                customEquipped[k] = v
            end
        end
    end
end)

pcall(function()
    local curFav = InventoryState.favorited()
    if type(curFav) == "table" then
        for k, v in pairs(curFav) do
            if v then
                customFavorited[k] = true
            end
        end
    end
end)

customEquipped.Emotes = normalizeWheelSlots(customEquipped.Emotes, 8, Item.Type.Emote, PREFERRED_DEFAULT_EMOTES, VALID_EMOTE_IDS)
customEquipped.ChatBubbles = normalizeWheelSlots(customEquipped.ChatBubbles, 12, Item.Type.ChatBubble, PREFERRED_DEFAULT_BUBBLES, VALID_CHATBUBBLE_IDS)

local function loadSavedPreset()
    if type(isfile) ~= "function" or type(readfile) ~= "function" then
        return
    end
    local ok, exists = pcall(isfile, SAVE_FILE)
    if not ok or not exists then
        return
    end
    local okRead, raw = pcall(readfile, SAVE_FILE)
    if not okRead or type(raw) ~= "string" or #raw == 0 then
        return
    end
    local okDec, data = pcall(function()
        return HttpService:JSONDecode(raw)
    end)
    if not okDec or type(data) ~= "table" then
        return
    end
    if type(data.equipped) == "table" then
        for k, v in pairs(data.equipped) do
            if type(v) == "table" then
                customEquipped[k] = table.clone(v)
            elseif type(v) == "string" then
                customEquipped[k] = v
            end
        end
        customEquipped.Emotes = normalizeWheelSlots(customEquipped.Emotes, 8, Item.Type.Emote, PREFERRED_DEFAULT_EMOTES, VALID_EMOTE_IDS)
        customEquipped.ChatBubbles = normalizeWheelSlots(customEquipped.ChatBubbles, 12, Item.Type.ChatBubble, PREFERRED_DEFAULT_BUBBLES, VALID_CHATBUBBLE_IDS)
    end
    if type(data.favorited) == "table" then
        for k, v in pairs(data.favorited) do
            if v == true then
                customFavorited[k] = true
            else
                customFavorited[k] = nil
            end
        end
    end
    if type(data.showcaseItems) == "table" then
        for i = 1, 4 do
            if type(data.showcaseItems[i]) == "string" then
                customShowcaseItems[i] = data.showcaseItems[i]
            end
        end
    end
end

local function savePreset()
    if type(writefile) ~= "function" then
        return
    end
    pcall(function()
        local payload = HttpService:JSONEncode({
            equipped = customEquipped,
            favorited = customFavorited,
            showcaseItems = customShowcaseItems
        })
        writefile(SAVE_FILE, payload)
    end)
end

loadSavedPreset()
savePreset()

local function withNormalIdentity(fn)
    local setId = setthreadidentity or setidentity or (syn and syn.set_thread_identity)
    local getId = getthreadidentity or getidentity or (syn and syn.get_thread_identity)
    local prevId = nil
    if type(getId) == "function" and type(setId) == "function" then
        local ok, id = pcall(getId)
        if ok and type(id) == "number" and id > 2 then
            prevId = id
            pcall(setId, 2)
        end
    end
    local okRun, errRun = pcall(fn)
    if prevId and type(setId) == "function" then
        pcall(setId, prevId)
    end
    return okRun, errRun
end

-- ============================================================================
-- 2. TITLE, JERSEY, CHAT BUBBLE & RANDOM FAVORITE HELPERS
-- ============================================================================
local function formatTitleRichText(titleId)
    if type(titleId) ~= "string" or titleId == "" then
        return ""
    end
    local item = Item:Get(titleId)
    if not item or item.Type ~= Item.Type.Title then
        return ""
    end
    local display = item.DisplayName or titleId
    if item.Metadata and item.Metadata.SeasonId then
        display = string.format("S%s Ultimate Champion", tostring(item.Metadata.SeasonId))
    end
    local col = (item.Metadata and item.Metadata.Color) or item.Color or Color3.new(1, 1, 1)
    local hex = "ffffff"
    if typeof(col) == "Color3" then
        hex = col:ToHex()
    elseif type(col) == "string" then
        hex = col:gsub("^#", "")
    end
    return string.format("<font color='#%s'>[%s]</font>", hex, display)
end

local function applyTitleToPlayer(player, titleId)
    if not player then
        return
    end
    pcall(function()
        local formatted = formatTitleRichText(titleId)
        player:SetAttribute("User_Title", formatted)
    end)
end

local isApplyingCustomJersey = false
local hookedJerseyChars = setmetatable({}, { __mode = "k" })

local function resolveJerseyStyleNameAndNumber(player, character, propsName, propsNumber)
    local resolvedName = (type(propsName) == "string" and propsName ~= "" and propsName ~= "SHOYO") and propsName:upper() or nil
    local resolvedNumber = (propsNumber ~= nil and tostring(propsNumber) ~= "" and tostring(propsNumber) ~= "0") and tostring(propsNumber) or nil

    -- 1. Check Player's Gameplay_ForcedStyle / Gameplay_Style / Game_Style attributes first
    if player and StyleContent and type(StyleContent.Get) == "function" then
        local styleId = player:GetAttribute("Gameplay_ForcedStyle")
            or player:GetAttribute("Gameplay_Style")
            or player:GetAttribute("Game_Style")
        if (not styleId or styleId == "") and player == LocalPlayer and StyleController then
            pcall(function()
                if type(StyleController.ForcedStyle) == "function" and StyleController.ForcedStyle() then
                    styleId = StyleController.ForcedStyle()
                elseif type(StyleController.Styles) == "function" and type(StyleController.CurrentStyleSlot) == "function" then
                    local styles = StyleController.Styles()
                    local slot = StyleController.CurrentStyleSlot() or 1
                    if type(styles) == "table" then
                        styleId = styles[slot]
                    end
                end
            end)
        end
        if type(styleId) == "string" and styleId ~= "" then
            local okS, st = pcall(function() return StyleContent:Get(styleId) end)
            if okS and type(st) == "table" then
                if st.DisplayName then
                    resolvedName = tostring(st.DisplayName):upper()
                end
                if st.Number ~= nil then
                    resolvedNumber = tostring(st.Number)
                end
            end
        end
    end

    -- 2. Fallback: read from existing server-created JerseyBack SurfaceGui on character before it gets cleared
    if (not resolvedName or not resolvedNumber) and character then
        for _, child in ipairs(character:GetChildren()) do
            if child:IsA("SurfaceGui") and child.Name == "JerseyBack" then
                local sn = child:FindFirstChild("StyleName")
                local pn = child:FindFirstChild("PlayerNumber")
                local sText = sn and sn:IsA("TextLabel") and sn.Text or nil
                local pText = pn and pn:IsA("TextLabel") and pn.Text or nil
                if sText and sText ~= "" and (not resolvedName or sText ~= "SHOYO") then
                    resolvedName = sText:upper()
                end
                if pText and pText ~= "" and (not resolvedNumber or pText ~= "0") then
                    resolvedNumber = pText
                end
            end
        end
    end

    return resolvedName, resolvedNumber
end

local function sanitizeCharacterJerseyDuplicates(player, character)
    if not character or not character.Parent then
        return
    end
    local backs = {}
    local fronts = {}
    local shirts = {}
    local pants = {}
    local instances = {}
    for _, child in ipairs(character:GetChildren()) do
        if child.Name == "JerseyBack" and child:IsA("SurfaceGui") then
            table.insert(backs, child)
        elseif child.Name == "JerseyFront" and child:IsA("SurfaceGui") then
            table.insert(fronts, child)
        elseif child:IsA("Shirt") then
            table.insert(shirts, child)
        elseif child:IsA("Pants") then
            table.insert(pants, child)
        elseif child.Name == "_jerseyInstances" then
            table.insert(instances, child)
        end
    end

    local resolvedName, resolvedNumber = resolveJerseyStyleNameAndNumber(player, character, nil, nil)

    -- Keep only the newest instance of each jersey element and destroy any older duplicates
    local function keepNewestOnly(list)
        if #list > 1 then
            for i = 1, #list - 1 do
                pcall(function() list[i]:Destroy() end)
            end
        end
        return list[#list]
    end

    local activeBack = keepNewestOnly(backs)
    local activeFront = keepNewestOnly(fronts)
    keepNewestOnly(shirts)
    keepNewestOnly(pants)
    keepNewestOnly(instances)

    -- Update the surviving SurfaceGuis with the player's true style Name & Number
    if activeBack and activeBack.Parent then
        local sn = activeBack:FindFirstChild("StyleName")
        local pn = activeBack:FindFirstChild("PlayerNumber")
        if sn and sn:IsA("TextLabel") and resolvedName then
            sn.Text = resolvedName
        end
        if pn and pn:IsA("TextLabel") and resolvedNumber then
            pn.Text = resolvedNumber
        end
    end
    if activeFront and activeFront.Parent then
        local pn = activeFront:FindFirstChild("PlayerNumber")
        if pn and pn:IsA("TextLabel") and resolvedNumber then
            pn.Text = resolvedNumber
        end
    end
end

local applyJerseyToCharacter

local function hookCharacterForJerseySanitizer(player, character)
    if not character or hookedJerseyChars[character] then
        return
    end
    hookedJerseyChars[character] = true
    trackConn(character.ChildAdded:Connect(function(child)
        if isApplyingCustomJersey then
            return
        end
        if child.Name == "JerseyBack" or child.Name == "JerseyFront" or child:IsA("Clothing") or child.Name == "_jerseyInstances" then
            task.defer(function()
                if not character or not character.Parent or isApplyingCustomJersey then
                    return
                end
                local desiredJersey = nil
                if player == LocalPlayer then
                    desiredJersey = customEquipped.Jersey
                elseif player then
                    local peer = peerCosmetics and peerCosmetics[tostring(player.UserId)]
                    if peer and peer.equipped and peer.equipped.Jersey then
                        desiredJersey = peer.equipped.Jersey
                    end
                end
                if desiredJersey and desiredJersey ~= "" and child:GetAttribute("_VBLCustomJersey") ~= true then
                    applyJerseyToCharacter(player, character, desiredJersey)
                else
                    sanitizeCharacterJerseyDuplicates(player, character)
                end
            end)
        end
    end))
end

applyJerseyToCharacter = function(player, character, jerseyId)
    if not player or not character or not JerseyTool then
        return
    end
    hookCharacterForJerseySanitizer(player, character)
    if type(jerseyId) ~= "string" or jerseyId == "" then
        jerseyId = "ClassicJersey"
    end
    local item = Item:Get(jerseyId)
    if not item or item.Type ~= Item.Type.Jersey then
        jerseyId = "ClassicJersey"
    end
    task.spawn(function()
        pcall(function()
            local teamName = nil
            if player.Team then
                teamName = player.Team.Name
            end
            local resolvedName, resolvedNumber = resolveJerseyStyleNameAndNumber(player, character, nil, nil)
            isApplyingCustomJersey = true
            JerseyTool.set({
                Id = jerseyId,
                Player = player,
                Character = character,
                TeamName = teamName,
                Name = resolvedName,
                Number = resolvedNumber
            })
            for _, child in ipairs(character:GetChildren()) do
                if child.Name == "JerseyBack" or child.Name == "JerseyFront" or child:IsA("Clothing") or child.Name == "_jerseyInstances" then
                    child:SetAttribute("_VBLCustomJersey", true)
                end
            end
            sanitizeCharacterJerseyDuplicates(player, character)
            isApplyingCustomJersey = false
        end)
    end)
end

local function showChatBubbleOnPlayer(player, itemId)
    if not player or type(itemId) ~= "string" or itemId == "" then
        return
    end
    local item = Item:Get(itemId)
    if not item or item.Type ~= Item.Type.ChatBubble then
        return
    end
    withNormalIdentity(function()
        if ChatBubbleComponent and type(ChatBubbleComponent.new) == "function" then
            ChatBubbleComponent.new({
                Player = player,
                ItemId = itemId
            })
        end
    end)
end

local function pickResolvedScoreEffect(effectId, favMap, detSeed)
    if effectId == "RandomFavoriteScoreEffect" then
        local pool = {}
        for id, isFav in pairs(favMap or customFavorited) do
            if isFav then
                local it = Item:Get(id)
                if it and it.Type == Item.Type.ScoreEffect and id ~= "RandomFavoriteScoreEffect" then
                    table.insert(pool, id)
                end
            end
        end
        if #pool > 0 then
            table.sort(pool)
            if type(detSeed) == "number" then
                local idx = (math.floor(math.abs(detSeed)) % #pool) + 1
                return pool[idx]
            end
            return pool[math.random(1, #pool)]
        end
        return "ClassicScoreEffect"
    end
    if type(effectId) == "string" and effectId ~= "" and Item:Get(effectId) then
        return effectId
    end
    return "ClassicScoreEffect"
end

local function pickResolvedPlayerCard(cardId, favMap, detSeed)
    if cardId == "RandomFavoritePlayerCard" then
        local pool = {}
        for id, isFav in pairs(favMap or customFavorited) do
            if isFav then
                local it = Item:Get(id)
                if it and it.Type == Item.Type.PlayerCard and id ~= "RandomFavoritePlayerCard" then
                    table.insert(pool, id)
                end
            end
        end
        if #pool > 0 then
            table.sort(pool)
            if type(detSeed) == "number" then
                local idx = (math.floor(math.abs(detSeed)) % #pool) + 1
                return pool[idx]
            end
            return pool[math.random(1, #pool)]
        end
        return "Classic1PlayerCard"
    end
    if type(cardId) == "string" and cardId ~= "" and Item:Get(cardId) then
        return cardId
    end
    return "Classic1PlayerCard"
end

-- ============================================================================
-- 3. UNLOCK ALL INVENTORY, GAMEPASSES & REACTIVE STATE
-- ============================================================================
local UNLOCK_TYPES = {
    [Item.Type.Ball] = true,
    [Item.Type.ScoreEffect] = true,
    [Item.Type.Title] = true,
    [Item.Type.Emote] = true,
    [Item.Type.PlayerCard] = true,
    [Item.Type.ChatBubble] = true,
    [Item.Type.Jersey] = true,
    [Item.Type.ProfileArt] = true,
    [Item.Type.WinScreen] = true
}

local unlockedCountsByType = {}

local function buildFullInventoryTable(baseInv)
    local full = {}
    if type(baseInv) == "table" then
        for k, v in pairs(baseInv) do
            if type(k) == "string" then
                full[k] = v
            end
        end
    end
    table.clear(unlockedCountsByType)
    for _, item in pairs(Item:GetAll()) do
        if type(item) == "table" and type(item.Id) == "string" and UNLOCK_TYPES[item.Type] then
            local itemId = item.Id
            if type(full[itemId]) ~= "number" or full[itemId] < 1 then
                full[itemId] = 1
            end
            unlockedCountsByType[item.Type] = (unlockedCountsByType[item.Type] or 0) + 1
        end
    end
    return full
end

local function buildFullGamepassesTable(baseGp)
    local gp = {}
    if type(baseGp) == "table" then
        for k, v in pairs(baseGp) do
            gp[k] = v
        end
    end
    if type(GamepassesList) == "table" then
        for _, entry in ipairs(GamepassesList) do
            if type(entry) == "table" and entry.Id then
                local name = tostring(entry.Name or "")
                if name == "VIP" or name == "DoubleEmotes" or name == "DoubleChatBubbles" or name == "StyleSkip" or name == "CrabRaveEmote" then
                    gp[tostring(entry.Id)] = true
                    gp[entry.Id] = true
                end
            end
        end
    end
    return gp
end

local isUpdatingCells = false

local function pushStateToUI()
    if isUpdatingCells then
        return
    end
    isUpdatingCells = true
    withNormalIdentity(function()
        pcall(function()
            local fullInv = buildFullInventoryTable(realServerInventory)
            InventoryState.inventory(fullInv)
            if Persistence and Persistence.Data and Persistence.Data["Inventory"] then
                Persistence.Data["Inventory"](fullInv)
            end
        end)
        pcall(function()
            customEquipped.Emotes = normalizeWheelSlots(customEquipped.Emotes, 8, Item.Type.Emote, PREFERRED_DEFAULT_EMOTES, VALID_EMOTE_IDS)
            customEquipped.ChatBubbles = normalizeWheelSlots(customEquipped.ChatBubbles, 12, Item.Type.ChatBubble, PREFERRED_DEFAULT_BUBBLES, VALID_CHATBUBBLE_IDS)
            local eqClone = table.clone(customEquipped)
            eqClone.Emotes = table.clone(customEquipped.Emotes)
            eqClone.ChatBubbles = table.clone(customEquipped.ChatBubbles)
            InventoryState.equipped(eqClone)
            if Persistence and Persistence.Data and Persistence.Data["Equipped"] then
                Persistence.Data["Equipped"](eqClone)
            end
            if Persistence and type(Persistence.bindToData) == "function" then
                local eqCell = Persistence.bindToData("Equipped")
                if eqCell then
                    eqCell(eqClone)
                end
            end
            if EmoteController and EmoteController.Emotes then
                EmoteController.Emotes(table.clone(customEquipped.Emotes))
            end
        end)
        pcall(function()
            local favClone = table.clone(customFavorited)
            InventoryState.favorited(favClone)
            if Persistence and Persistence.Data and Persistence.Data["Favorited"] then
                Persistence.Data["Favorited"](favClone)
            end
        end)
        pcall(function()
            if Persistence and type(Persistence.bindToData) == "function" then
                local gpCell = Persistence.bindToData("Gamepasses")
                if gpCell then
                    gpCell(buildFullGamepassesTable(gpCell()))
                end
            end
            LocalPlayer:SetAttribute("User_IsVIP", true)
            LocalPlayer:SetAttribute("User_CanSkip", true)
        end)
        pcall(function()
            applyTitleToPlayer(LocalPlayer, customEquipped.Title)
            if LocalPlayer.Character then
                applyJerseyToCharacter(LocalPlayer, LocalPlayer.Character, customEquipped.Jersey)
            end
        end)
        pcall(function()
            if InspectState and InspectState.isCustomizing and InspectState.isCustomizing() then
                InspectState.title(customEquipped.Title)
                InspectState.art(customEquipped.ProfileArt)
                InspectState.jersey(customEquipped.Jersey)
                InspectState.items(table.clone(customShowcaseItems))
            end
        end)
    end)
    isUpdatingCells = false
end

_G.__VolleyballUnlockAllRefresh = pushStateToUI
pushStateToUI()

-- ============================================================================
-- 3.5. SCORE FX FAVORITES PRESET IMPORTER & EXPORTER ("COPY FX PRESET" BUTTON)
-- ============================================================================
local Notify = nil
pcall(function()
    Notify = require(ReplicatedFirst:WaitForChild("Components", 5):WaitForChild("Notify", 5))
end)
local Palette = nil
pcall(function()
    Palette = require(ReplicatedStorage:WaitForChild("Configuration", 5):WaitForChild("Palette", 5))
end)
local InventoryActions = nil
pcall(function()
    InventoryActions = require(ReplicatedFirst:WaitForChild("UI", 5):WaitForChild("Screens", 5):WaitForChild("Inventory", 5):WaitForChild("Actions", 5))
end)

local function copyToClipboard(str)
    local fn = setclipboard or toclipboard or (Clipboard and Clipboard.set)
    if type(fn) == "function" then
        pcall(fn, str)
        return true
    end
    return false
end

local function importScoreFxPreset(fxList, replaceExisting)
    if type(fxList) ~= "table" then
        return 0
    end
    if replaceExisting then
        for id in pairs(customFavorited) do
            local it = Item:Get(id)
            if it and it.Type == Item.Type.ScoreEffect then
                customFavorited[id] = nil
            end
        end
    end
    local count = 0
    for _, id in ipairs(fxList) do
        if type(id) == "string" then
            local it = Item:Get(id)
            if it and it.Type == Item.Type.ScoreEffect and id ~= "RandomFavoriteScoreEffect" then
                customFavorited[id] = true
                count = count + 1
            end
        end
    end
    if count > 0 and Item:Get("RandomFavoriteScoreEffect") then
        customEquipped.ScoreEffect = "RandomFavoriteScoreEffect"
    end
    if type(rollNextRandomCosmetics) == "function" then
        pcall(rollNextRandomCosmetics)
    end
    pushStateToUI()
    savePreset()
    if type(_G.__VolleyballUnlockAllBroadcast) == "function" then
        pcall(_G.__VolleyballUnlockAllBroadcast, true)
    end
    if Notify and type(Notify.send) == "function" then
        pcall(Notify.send, {
            Body = string.format("Preset de Score FX aplicado! (%d efeitos favoritados + Random Favorite equipado)", count),
            Color = (Palette and Palette.Notification and Palette.Notification.Green) or Color3.fromRGB(46, 204, 113)
        })
    end
    return count
end

_G.__VolleyballImportScoreFxPreset = importScoreFxPreset

-- Apply any pending preset executed before the script finished loading
do
    local env = (type(getgenv) == "function" and getgenv()) or _G
    local pending = env.__VBL_PENDING_FX_PRESET or _G.__VBL_PENDING_FX_PRESET
    if type(pending) == "table" then
        env.__VBL_PENDING_FX_PRESET = nil
        _G.__VBL_PENDING_FX_PRESET = nil
        task.defer(importScoreFxPreset, pending, true)
    end
end

local function exportScoreFxPresetToClipboard()
    local fxIds = {}
    for id, isFav in pairs(customFavorited) do
        if isFav then
            local it = Item:Get(id)
            if it and it.Type == Item.Type.ScoreEffect and id ~= "RandomFavoriteScoreEffect" then
                table.insert(fxIds, id)
            end
        end
    end
    table.sort(fxIds)
    local quoted = {}
    for _, id in ipairs(fxIds) do
        table.insert(quoted, string.format("%q", id))
    end
    local scriptText = string.format(
        '-- Volleyball Legends - Score FX Favorites Preset (%d FX)\nlocal fxPreset = { %s }\nif type(_G.__VolleyballImportScoreFxPreset) == "function" then\n    _G.__VolleyballImportScoreFxPreset(fxPreset, true)\nelse\n    local env = (type(getgenv) == "function" and getgenv()) or _G\n    env.__VBL_PENDING_FX_PRESET = fxPreset\n    loadstring(game:HttpGet("https://ydxvxdinc-art.github.io/ydx-script-vault/scripts/volleyball_unlock_all.lua"))()\nend',
        #fxIds,
        table.concat(quoted, ", ")
    )
    local okCopy = copyToClipboard(scriptText)
    if Notify and type(Notify.send) == "function" then
        pcall(Notify.send, {
            Body = okCopy
                and string.format("Script do Preset copiado! (%d Score FX favoritados prontos para enviar ao seu amigo)", #fxIds)
                or "Seu executor nao suporta setclipboard/toclipboard.",
            Color = (Palette and Palette.Notification and (okCopy and Palette.Notification.Green or Palette.Notification.Red)) or Color3.fromRGB(46, 204, 113)
        })
    end
    return scriptText, #fxIds
end

_G.__VolleyballExportScoreFxPreset = exportScoreFxPresetToClipboard

-- Inject "COPY FX PRESET" pill button inside the Inventory Score FX tab (InfoContainer)
task.spawn(function()
    local function attachCopyFxButtonToInfoContainer(infoContainer)
        if not infoContainer or infoContainer:FindFirstChild("CopyFxPresetBtn") then
            return
        end
        local previewBtn = infoContainer:FindFirstChild("PreviewBtn")
        local copyBtn = nil
        if previewBtn and previewBtn:IsA("GuiButton") then
            copyBtn = previewBtn:Clone()
            copyBtn.Name = "CopyFxPresetBtn"
            copyBtn.LayoutOrder = 12
            copyBtn.ImageColor3 = Color3.fromRGB(0, 195, 255)
            for _, d in ipairs(copyBtn:GetDescendants()) do
                if d:IsA("TextLabel") then
                    d.Text = "COPY FX PRESET"
                    d.TextColor3 = Color3.fromRGB(235, 252, 255)
                elseif d:IsA("UIGradient") then
                    d.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 175, 255)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 175, 255))
                    })
                end
            end
        else
            copyBtn = Instance.new("TextButton")
            copyBtn.Name = "CopyFxPresetBtn"
            copyBtn.LayoutOrder = 12
            copyBtn.Size = UDim2.fromScale(0.975, 0.08)
            copyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 245)
            copyBtn.Font = Enum.Font.GothamBlack
            copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            copyBtn.TextScaled = true
            copyBtn.Text = "COPY FX PRESET"
            copyBtn.ZIndex = 99
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0.3, 0)
            corner.Parent = copyBtn
        end

        local function setBtnLabel(txt)
            if copyBtn:IsA("TextButton") then
                copyBtn.Text = txt
            end
            for _, d in ipairs(copyBtn:GetDescendants()) do
                if d:IsA("TextLabel") then
                    d.Text = txt
                end
            end
        end

        local function countFavFx()
            local n = 0
            for id, isFav in pairs(customFavorited) do
                if isFav then
                    local it = Item:Get(id)
                    if it and it.Type == Item.Type.ScoreEffect and id ~= "RandomFavoriteScoreEffect" then
                        n = n + 1
                    end
                end
            end
            return n
        end

        local function updateVisibility()
            local isScoreFxTab = false
            pcall(function()
                if InventoryActions and type(InventoryActions.page) == "function" then
                    if InventoryActions.page() == Item.Type.ScoreEffect then
                        isScoreFxTab = true
                    end
                end
                if not isScoreFxTab and InventoryState and type(InventoryState.selected) == "function" then
                    local sel = InventoryState.selected()
                    local it = sel and Item:Get(sel)
                    if it and it.Type == Item.Type.ScoreEffect then
                        isScoreFxTab = true
                    end
                end
            end)
            local pendingSlot = nil
            pcall(function()
                if InventoryActions and type(InventoryActions.pendingSlot) == "function" then
                    pendingSlot = InventoryActions.pendingSlot()
                end
            end)
            copyBtn.Visible = isScoreFxTab and (pendingSlot == nil)
            if copyBtn.Visible and not copyBtn:GetAttribute("_CopyingPulse") then
                setBtnLabel(string.format("COPY FX PRESET (%d)", countFavFx()))
            end
        end

        copyBtn.Activated:Connect(function()
            local _, count = exportScoreFxPresetToClipboard()
            copyBtn:SetAttribute("_CopyingPulse", true)
            setBtnLabel(string.format("COPIED %d FX! [OK]", count))
            task.delay(1.6, function()
                if copyBtn and copyBtn.Parent then
                    copyBtn:SetAttribute("_CopyingPulse", nil)
                    updateVisibility()
                end
            end)
        end)

        copyBtn.Parent = infoContainer
        updateVisibility()

        local visConn = RunService.Heartbeat:Connect(function()
            if not copyBtn or not copyBtn.Parent or _G.__VolleyballUnlockAllToken ~= scriptRunToken then
                return
            end
            updateVisibility()
        end)
        trackConn(visConn)
    end

    local pgui = LocalPlayer:WaitForChild("PlayerGui", 15)
    if not pgui then return end

    local function scanForInfoContainer(root)
        for _, inst in ipairs(root:GetDescendants()) do
            if inst:IsA("Frame") and inst.Name == "InfoContainer" and inst:FindFirstChild("ActionBtns") then
                attachCopyFxButtonToInfoContainer(inst)
            end
        end
    end

    scanForInfoContainer(pgui)
    trackConn(pgui.DescendantAdded:Connect(function(inst)
        if inst:IsA("Frame") and inst.Name == "ActionBtns" and inst.Parent and inst.Parent.Name == "InfoContainer" then
            task.defer(attachCopyFxButtonToInfoContainer, inst.Parent)
        elseif inst:IsA("Frame") and inst.Name == "InfoContainer" then
            task.delay(0.1, function()
                if inst.Parent and inst:FindFirstChild("ActionBtns") then
                    attachCopyFxButtonToInfoContainer(inst)
                end
            end)
        end
    end))
end)

trackConn(LocalPlayer:GetAttributeChangedSignal("User_Title"):Connect(function()
    if isUpdatingCells then
        return
    end
    local expected = formatTitleRichText(customEquipped.Title)
    if LocalPlayer:GetAttribute("User_Title") ~= expected then
        isUpdatingCells = true
        LocalPlayer:SetAttribute("User_Title", expected)
        isUpdatingCells = false
    end
end))

trackConn(LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.25)
    applyTitleToPlayer(LocalPlayer, customEquipped.Title)
    applyJerseyToCharacter(LocalPlayer, char, customEquipped.Jersey)
end))

trackConn(LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
    if LocalPlayer.Character then
        task.wait(0.15)
        applyJerseyToCharacter(LocalPlayer, LocalPlayer.Character, customEquipped.Jersey)
    end
end))

trackConn(LocalPlayer:GetAttributeChangedSignal("Gameplay_Style"):Connect(function()
    if LocalPlayer.Character then
        task.wait(0.1)
        applyJerseyToCharacter(LocalPlayer, LocalPlayer.Character, customEquipped.Jersey)
    end
end))

trackConn(LocalPlayer:GetAttributeChangedSignal("Gameplay_ForcedStyle"):Connect(function()
    if LocalPlayer.Character then
        task.wait(0.1)
        applyJerseyToCharacter(LocalPlayer, LocalPlayer.Character, customEquipped.Jersey)
    end
end))

if DataService and DataService.ProfileUpdated then
    pcall(function()
        trackConn(DataService.ProfileUpdated:Connect(function(key, val)
            if key == "Inventory" and type(val) == "table" then
                for k, v in pairs(val) do
                    if type(k) == "string" and type(v) == "number" and v > 0 then
                        realServerInventory[k] = v
                    end
                end
                task.defer(pushStateToUI)
            elseif key == "Equipped" or key == "Favorited" or key == "Gamepasses" then
                task.defer(pushStateToUI)
            end
        end))
    end)
end

-- ============================================================================
-- 4. CLIENT EMOTE PROP & SOUND RUNNER (FOR UNOWNED EMOTES & P2P PEERS)
-- ============================================================================
local activeEmoteCleanups = {} -- [Player] = { cleanupFn, soundInst, track, walkTrack, walkConn }

local function stopCustomEmoteOnPlayer(player)
    local state = activeEmoteCleanups[player]
    if not state then
        return
    end
    activeEmoteCleanups[player] = nil
    if state.walkConn then
        pcall(function() state.walkConn:Disconnect() end)
    end
    if state.cleanupFn then
        pcall(state.cleanupFn)
    end
    if state.soundInst then
        pcall(function()
            if type(state.soundInst) == "table" and state.soundInst.Destroy then
                state.soundInst:Destroy()
            elseif typeof(state.soundInst) == "Instance" then
                state.soundInst:Stop()
                state.soundInst:Destroy()
            end
        end)
    end
    if state.track then
        pcall(function()
            state.track:Stop(0.15)
            state.track:Destroy()
        end)
    end
    if state.walkTrack then
        pcall(function()
            state.walkTrack:Stop(0.15)
            state.walkTrack:Destroy()
        end)
    end
end

local function playCustomEmoteOnPlayer(player, itemId, isLocal)
    if not player or not player.Character then
        return
    end
    local item = Item:Get(itemId)
    if not item or item.Type ~= Item.Type.Emote then
        return
    end

    stopCustomEmoteOnPlayer(player)

    local char = player.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildOfClass("Animator")
    local state = {}
    activeEmoteCleanups[player] = state

    -- For remote P2P peers, also load & play the emote animation on their character
    if not isLocal and animator and item.Asset then
        pcall(function()
            local anim = item.Asset:Clone()
            local track = animator:LoadAnimation(anim)
            track.Priority = Enum.AnimationPriority.Action
            track.Looped = (item.Metadata and item.Metadata.Looped == true) or false
            track:Play(0.15)
            state.track = track

            if item.Metadata and item.Metadata.WalkAsset then
                local walkAnim = item.Metadata.WalkAsset:Clone()
                local walkTrack = animator:LoadAnimation(walkAnim)
                walkTrack.Priority = Enum.AnimationPriority.Movement
                walkTrack.Looped = true
                state.walkTrack = walkTrack
            end
        end)
    end

    -- Spawn 3D Emote Prop via item.Metadata.Handler.run
    if item.Metadata and item.Metadata.Handler and type(item.Metadata.Handler.run) == "function" then
        local ok, cleanup = pcall(item.Metadata.Handler.run, {
            Character = char
        })
        if ok and type(cleanup) == "function" then
            state.cleanupFn = cleanup
        end
    end

    -- Play Emote Sound
    if item.Metadata and item.Metadata.Sound then
        pcall(function()
            if SoundTool and type(SoundTool.new) == "function" then
                state.soundInst = SoundTool.new({
                    Id = item.Metadata.Sound,
                    Parent = char.PrimaryPart or char,
                    Volume = 0.4,
                    IsEmote = true,
                    RollOffMaxDistance = 60,
                    Looped = item.Metadata.Looped
                })
            else
                local snd = Instance.new("Sound")
                snd.SoundId = tostring(item.Metadata.Sound)
                snd.Volume = 0.4
                snd.Looped = (item.Metadata.Looped == true)
                snd.RollOffMaxDistance = 60
                snd.Parent = char.PrimaryPart or char
                snd:Play()
                state.soundInst = snd
            end
        end)
    end

    -- Auto-cleanup if non-walkable and character walks/jumps
    if hum then
        local startTime = os.clock()
        state.walkConn = RunService.Heartbeat:Connect(function()
            if not char.Parent or hum.Health <= 0 then
                stopCustomEmoteOnPlayer(player)
                return
            end
            if os.clock() - startTime < 0.25 then
                return
            end
            local isMoving = hum.MoveDirection.Magnitude > 0.05 or char:GetAttribute("Jumping") == true
            local isWalkable = item.Metadata and (item.Metadata.IsWalkable or item.Metadata.WalkAsset)
            if isMoving and not isWalkable then
                stopCustomEmoteOnPlayer(player)
            elseif not isLocal and state.walkTrack then
                if hum.MoveDirection.Magnitude > 0.05 then
                    if not state.walkTrack.IsPlaying then
                        state.walkTrack:Play(0.15)
                    end
                else
                    if state.walkTrack.IsPlaying then
                        state.walkTrack:Stop(0.15)
                    end
                end
            end
        end)
    end
end

if AnimationController and type(AnimationController.StopAllEmotes) == "function" then
    AnimationController.__vblOrigStopAll = AnimationController.__vblOrigStopAll or AnimationController.StopAllEmotes
    local origStopAll = AnimationController.__vblOrigStopAll
    AnimationController.StopAllEmotes = function(self, ...)
        stopCustomEmoteOnPlayer(LocalPlayer)
        return origStopAll(self, ...)
    end
end

-- ============================================================================
-- 5. REAL-TIME P2P SYNC (NTFY.SH)
-- ============================================================================
local peerCosmetics = {} -- [userIdStr] = { equipped = {...}, favorited = {...}, showcaseItems = {...}, emote = ..., emoteSeq = ..., bubble = ..., bubbleSeq = ..., serveSeq = ..., serveAt = ..., serveSkin = ... }
local lastPeerSeq = {}
local mySeq = 0
local currentEmoteId = ""
local currentEmoteSeq = 0
local currentBubbleId = ""
local currentBubbleSeq = 0
local currentServeSeq = 0
local currentServeSkin = ""
local lastKnownBallOwner = nil
local lastKnownBallSkin = nil
local localServeAt = 0
local nextResolvedScoreEffect = nil
local nextResolvedPlayerCard = nil
local lastReplayPointScoreEffect = {} -- [pointKey] = resolvedScoreEffectId

local function rollNextRandomCosmetics()
    nextResolvedScoreEffect = pickResolvedScoreEffect(customEquipped.ScoreEffect, customFavorited)
    nextResolvedPlayerCard = pickResolvedPlayerCard(customEquipped.PlayerCard, customFavorited)
end

rollNextRandomCosmetics()

local httpRequest = (syn and syn.request)
    or (http and http.request)
    or http_request
    or (fluxus and fluxus.request)
    or request

local jobClean = (game.JobId ~= "" and game.JobId or ("local_" .. tostring(game.PlaceId))):gsub("[^%w]", ""):sub(1, 24)
local P2P_TOPIC = "ydx_vbl1_" .. jobClean
local P2P_URL = "https://ntfy.sh/" .. P2P_TOPIC

local lastBroadcastHash = ""
local lastBroadcastTime = 0

local function buildP2PPayload()
    mySeq = mySeq + 1
    local favList = {}
    for id, isFav in pairs(customFavorited) do
        if isFav then
            table.insert(favList, id)
        end
    end
    table.sort(favList)
    if not nextResolvedScoreEffect or customEquipped.ScoreEffect ~= "RandomFavoriteScoreEffect" then
        nextResolvedScoreEffect = pickResolvedScoreEffect(customEquipped.ScoreEffect, customFavorited)
    end
    if not nextResolvedPlayerCard or customEquipped.PlayerCard ~= "RandomFavoritePlayerCard" then
        nextResolvedPlayerCard = pickResolvedPlayerCard(customEquipped.PlayerCard, customFavorited)
    end
    return {
        uid = tostring(LocalPlayer.UserId),
        name = LocalPlayer.Name,
        seq = mySeq,
        eq = {
            Ball = customEquipped.Ball,
            ScoreEffect = customEquipped.ScoreEffect,
            Title = customEquipped.Title,
            PlayerCard = customEquipped.PlayerCard,
            Jersey = customEquipped.Jersey,
            ProfileArt = customEquipped.ProfileArt,
            WinScreen = customEquipped.WinScreen
        },
        res = {
            ScoreEffect = nextResolvedScoreEffect,
            PlayerCard = nextResolvedPlayerCard
        },
        fav = favList,
        shw = customShowcaseItems,
        em = currentEmoteId,
        emSeq = currentEmoteSeq,
        cb = currentBubbleId,
        cbSeq = currentBubbleSeq,
        svSeq = currentServeSeq,
        svSkin = currentServeSkin
    }
end

local function broadcastP2P(force)
    if type(httpRequest) ~= "function" then
        return
    end
    local payload = buildP2PPayload()
    local ok, encoded = pcall(function()
        return HttpService:JSONEncode(payload)
    end)
    if not ok or type(encoded) ~= "string" then
        return
    end
    local stateKey = table.concat({
        tostring(payload.eq.Ball),
        tostring(payload.eq.ScoreEffect),
        tostring(payload.eq.Title),
        tostring(payload.eq.PlayerCard),
        tostring(payload.eq.Jersey),
        tostring(payload.eq.ProfileArt),
        tostring(payload.eq.WinScreen),
        tostring(payload.res.ScoreEffect),
        tostring(payload.res.PlayerCard),
        tostring(payload.em),
        tostring(payload.emSeq),
        tostring(payload.cb),
        tostring(payload.cbSeq),
        tostring(payload.svSeq),
        tostring(payload.svSkin)
    }, "|")
    local now = os.clock()
    if not force and stateKey == lastBroadcastHash and (now - lastBroadcastTime) < 5 then
        return
    end
    lastBroadcastHash = stateKey
    lastBroadcastTime = now

    task.spawn(function()
        pcall(httpRequest, {
            Url = P2P_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "text/plain",
                ["Title"] = "vbl_sync"
            },
            Body = encoded
        })
    end)
end

_G.__VolleyballUnlockAllBroadcast = broadcastP2P

-- Sweep any orphaned ball models or shadow indicators in workspace that are no longer in ActiveBalls / BallModule.All
local function cleanupOrphanedBalls()
    pcall(function()
        local liveModels = {}
        local liveShadows = {}
        if BallController and type(BallController.ActiveBalls) == "table" then
            for _, b in pairs(BallController.ActiveBalls) do
                if type(b) == "table" then
                    if b.Ball then liveModels[b.Ball] = true end
                    if b.Shadow then liveShadows[b.Shadow] = true end
                end
            end
        end
        if BallModule and type(BallModule.All) == "table" then
            for _, b in pairs(BallModule.All) do
                if type(b) == "table" then
                    if b.Ball then liveModels[b.Ball] = true end
                    if b.Shadow then liveShadows[b.Shadow] = true end
                end
            end
        end
        local ballAssets = ReplicatedStorage:FindFirstChild("Assets")
            and ReplicatedStorage.Assets:FindFirstChild("Ball")
        for _, child in ipairs(workspace:GetChildren()) do
            if child:IsA("Model") and not liveModels[child] then
                local isOrphanBall = child.Name:match("^CLIENT_BALL_") ~= nil
                    or child:HasTag("Ball")
                    or child:GetAttribute("_VBLSwappedBall") == true
                    or (ballAssets and ballAssets:FindFirstChild(child.Name) ~= nil and Item:Get(child.Name) and Item:Get(child.Name).Type == Item.Type.Ball)
                if isOrphanBall then
                    child:Destroy()
                end
            elseif child.Name == "BallShadowIndicator" and not liveShadows[child] then
                child:Destroy()
            end
        end
    end)
end

-- Helper to swap an already-spawned active ball's visual mesh in live play (preserving Maid cleanup & tags!)
local function replaceLiveActiveBallSkin(desiredSkin)
    if type(desiredSkin) ~= "string" or desiredSkin == "" then
        return
    end
    local newItem = Item:Get(desiredSkin)
    local template = ReplicatedStorage:FindFirstChild("Assets")
        and ReplicatedStorage.Assets:FindFirstChild("Ball")
        and ReplicatedStorage.Assets.Ball:FindFirstChild(desiredSkin)
    if not newItem or not template then
        return
    end
    pcall(function()
        if BallController and type(BallController.ActiveBalls) == "table" then
            local activeId = ReplicatedStorage:GetAttribute("ActiveBall")
            for id, ballObj in pairs(BallController.ActiveBalls) do
                if activeId == nil or id == activeId then
                    if type(ballObj) == "table" and ballObj.Ball and ballObj.Ball.Parent then
                        local curSkinId = (ballObj.Item and ballObj.Item.Id) or ballObj.Ball:GetAttribute("_VBLSkin")
                        if curSkinId ~= desiredSkin then
                            local oldModel = ballObj.Ball
                            local newModel = template:Clone()
                            for _, desc in ipairs(newModel:GetDescendants()) do
                                if desc:IsA("BasePart") then
                                    desc.CastShadow = false
                                end
                            end
                            local oldAssetScale = (ballObj.Item and ballObj.Item.Asset and ballObj.Item.Asset:GetScale()) or oldModel:GetScale()
                            local scaleMult = (oldAssetScale > 0) and (oldModel:GetScale() / oldAssetScale) or 1
                            newModel:ScaleTo(newModel:GetScale() * scaleMult)
                            newModel:PivotTo(oldModel:GetPivot())
                            newModel.Name = oldModel.Name
                            newModel:AddTag("Ball")
                            newModel:SetAttribute("Id", ballObj.ID or oldModel:GetAttribute("Id"))
                            newModel:SetAttribute("ServerId", oldModel:GetAttribute("ServerId") or id)
                            newModel:SetAttribute("_VBLSkin", desiredSkin)
                            newModel:SetAttribute("_VBLSwappedBall", true)

                            local existingHighlight = oldModel:FindFirstChildOfClass("Highlight")
                            if existingHighlight then
                                existingHighlight.Parent = newModel
                            else
                                local hl = Instance.new("Highlight")
                                hl.FillTransparency = 1
                                hl.OutlineColor = Color3.new()
                                hl.OutlineTransparency = 0
                                hl.DepthMode = Enum.HighlightDepthMode.Occluded
                                hl.Parent = newModel
                            end

                            newModel.Parent = oldModel.Parent
                            ballObj.Ball = newModel
                            ballObj.Item = newItem

                            if ballObj.maid and type(ballObj.maid.GiveTask) == "function" then
                                ballObj.maid:GiveTask(newModel)
                            end
                            if BallLib and type(BallLib.setup) == "function" and ballObj.maid then
                                local okStep, stepFn = pcall(BallLib.setup, {
                                    Item = newItem,
                                    Ball = newModel,
                                    Maid = ballObj.maid
                                })
                                if okStep then
                                    ballObj.Step = stepFn
                                end
                            end

                            oldModel:Destroy()
                        end
                    end
                end
            end
        end
    end)
end

-- Resolve desired ball skin for any player (LocalPlayer or P2P peer)
local function resolveDesiredBallSkinForPlayer(player)
    if not player then
        return nil
    end
    if player == LocalPlayer then
        return customEquipped.Ball
    end
    local peer = peerCosmetics[tostring(player.UserId)]
    if peer and peer.equipped and type(peer.equipped.Ball) == "string" and peer.equipped.Ball ~= "" then
        return peer.equipped.Ball
    end
    return nil
end

-- Swap the serve ball held in the player's hand ("WeldedBall") before tossing!
local weldedBallDescConns = setmetatable({}, { __mode = "k" })

local function applyCustomSkinToWeldedBall(inst, explicitOwner)
    if not inst or not inst:IsA("Model") or inst.Name == "_VBLCustomWeldedBall" then
        return
    end
    task.spawn(function()
        local t0 = os.clock()
        while inst.Parent and not inst.PrimaryPart and not inst:FindFirstChildWhichIsA("BasePart", true) and (os.clock() - t0) < 0.6 do
            task.wait()
        end
        if not inst.Parent then
            return
        end

        local ownerPlayer = explicitOwner
        if not ownerPlayer and inst.Parent then
            ownerPlayer = Players:GetPlayerFromCharacter(inst.Parent)
        end
        if not ownerPlayer then
            for _, d in ipairs(inst:GetDescendants()) do
                if d:IsA("JointInstance") or d:IsA("WeldConstraint") then
                    local p0, p1 = d.Part0, d.Part1
                    local pl0 = p0 and p0.Parent and Players:GetPlayerFromCharacter(p0.Parent)
                    local pl1 = p1 and p1.Parent and Players:GetPlayerFromCharacter(p1.Parent)
                    ownerPlayer = pl0 or pl1
                    if ownerPlayer then break end
                end
            end
        end

        local desiredSkin = resolveDesiredBallSkinForPlayer(ownerPlayer)
        if type(desiredSkin) ~= "string" or desiredSkin == "" then
            return
        end
        local newItem = Item:Get(desiredSkin)
        local template = ReplicatedStorage:FindFirstChild("Assets")
            and ReplicatedStorage.Assets:FindFirstChild("Ball")
            and ReplicatedStorage.Assets.Ball:FindFirstChild(desiredSkin)
        if not newItem or not template then
            return
        end

        local existingCustom = inst:FindFirstChild("_VBLCustomWeldedBall")
        if inst:GetAttribute("_VBLWeldedSkin") == desiredSkin and existingCustom then
            return
        end

        local char = (ownerPlayer and ownerPlayer.Character) or inst.Parent
        local rightHand = char and char:FindFirstChild("RightHand")

        local charJoint = nil
        local function findCharJoint()
            for _, d in ipairs(inst:GetDescendants()) do
                if (d:IsA("JointInstance") or d:IsA("WeldConstraint")) and d.Name ~= "VBLWeldedBallJoint" then
                    if char and ((d.Part1 and d.Part1:IsDescendantOf(char) and not d.Part1:IsDescendantOf(inst))
                        or (d.Part0 and d.Part0:IsDescendantOf(char) and not d.Part0:IsDescendantOf(inst))) then
                        return d
                    end
                end
            end
            return nil
        end

        charJoint = findCharJoint()
        if not charJoint and rightHand then
            local t1 = os.clock()
            while inst.Parent and not charJoint and (os.clock() - t1) < 0.25 do
                task.wait()
                charJoint = findCharJoint()
            end
        end
        if not inst.Parent then
            return
        end

        local anchorPart = inst.PrimaryPart or inst:FindFirstChild("BoundingBox") or inst:FindFirstChildWhichIsA("BasePart")
        local targetPart1 = rightHand or anchorPart
        local c0 = CFrame.identity
        local c1 = CFrame.identity
        if charJoint then
            if char and charJoint.Part1 and charJoint.Part1:IsDescendantOf(char) and not charJoint.Part1:IsDescendantOf(inst) then
                targetPart1 = charJoint.Part1
                if charJoint:IsA("JointInstance") then
                    c0 = charJoint.C0
                    c1 = charJoint.C1
                end
            elseif anchorPart then
                targetPart1 = anchorPart
            end
        end
        if not targetPart1 then
            return
        end

        if existingCustom then
            pcall(function() existingCustom:Destroy() end)
        end

        local customClone = template:Clone()
        customClone.Name = "_VBLCustomWeldedBall"
        local mult = ReplicatedStorage:GetAttribute("Modifier_BallSizeMultiplier") or 1
        pcall(function()
            customClone:ScaleTo(template:GetScale() * mult)
        end)

        local clonePrimary = customClone.PrimaryPart or customClone:FindFirstChildWhichIsA("BasePart")
        if not clonePrimary then
            customClone:Destroy()
            return
        end

        for _, d in ipairs(customClone:GetDescendants()) do
            if d:IsA("BasePart") then
                if d ~= clonePrimary then
                    local wc = Instance.new("WeldConstraint")
                    wc.Name = "VBLPartWeld"
                    wc.Part0 = clonePrimary
                    wc.Part1 = d
                    wc.Parent = d
                end
                d.Anchored = false
                d.CanCollide = false
                d.CanTouch = false
                d.CanQuery = false
                d.Massless = true
                d.CastShadow = false
            end
        end

        pcall(function()
            customClone:PivotTo(targetPart1.CFrame)
        end)

        local weld = Instance.new("Motor6D")
        weld.Name = "VBLWeldedBallJoint"
        weld.Part0 = clonePrimary
        weld.Part1 = targetPart1
        weld.C0 = c0
        weld.C1 = c1
        weld.Parent = clonePrimary

        local function hideOriginalDescendant(d)
            if not d or d == customClone or d:IsDescendantOf(customClone) then
                return
            end
            if d:IsA("BasePart") then
                if d == anchorPart or d == inst.PrimaryPart then
                    d.Transparency = 1
                    d.LocalTransparencyModifier = 1
                    d.CanCollide = false
                    d.CanTouch = false
                    d.CanQuery = false
                    d.CastShadow = false
                else
                    pcall(function() d:Destroy() end)
                end
            elseif d:IsA("SurfaceAppearance")
                or d:IsA("Decal")
                or d:IsA("Texture")
                or d:IsA("SpecialMesh")
                or d:IsA("ParticleEmitter")
                or d:IsA("Trail")
                or d:IsA("Beam")
                or d:IsA("Light") then
                pcall(function() d:Destroy() end)
            elseif d:IsA("Highlight") then
                local curCustom = inst:FindFirstChild("_VBLCustomWeldedBall")
                if curCustom then
                    d.Adornee = curCustom
                end
            end
        end

        for _, d in ipairs(inst:GetDescendants()) do
            hideOriginalDescendant(d)
        end

        if not weldedBallDescConns[inst] then
            weldedBallDescConns[inst] = trackConn(inst.DescendantAdded:Connect(function(d)
                task.defer(hideOriginalDescendant, d)
            end))
        end

        customClone.Parent = inst
        inst:SetAttribute("_VBLWeldedSkin", desiredSkin)

        local hl = inst:FindFirstChildOfClass("Highlight")
        if not hl then
            hl = Instance.new("Highlight")
            hl.FillTransparency = 1
            hl.OutlineColor = Color3.new()
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.Occluded
            hl.Parent = inst
        end
        hl.Adornee = customClone

        if BallLib and type(BallLib.display) == "function" then
            pcall(BallLib.display, {
                Item = newItem,
                Ball = customClone
            })
        end
    end)
end

local function refreshWeldedBallsForCharacter(player, char)
    if not char then return end
    local ballAssets = ReplicatedStorage:FindFirstChild("Assets")
        and ReplicatedStorage.Assets:FindFirstChild("Ball")
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Model") and child.Name ~= "_VBLCustomWeldedBall" then
            if child:HasTag("WeldedBall") or (ballAssets and ballAssets:FindFirstChild(child.Name) ~= nil) then
                applyCustomSkinToWeldedBall(child, player)
            end
        end
    end
end

local function refreshAllWeldedBalls()
    pcall(function()
        for _, inst in ipairs(CollectionService:GetTagged("WeldedBall")) do
            applyCustomSkinToWeldedBall(inst, nil)
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then
                refreshWeldedBallsForCharacter(p, p.Character)
            end
        end
    end)
end

local function hookCharacterForWeldedBall(player, char)
    if not char then return end
    refreshWeldedBallsForCharacter(player, char)
    trackConn(char.ChildAdded:Connect(function(child)
        if child:IsA("Model") and child.Name ~= "_VBLCustomWeldedBall" then
            local ballAssets = ReplicatedStorage:FindFirstChild("Assets")
                and ReplicatedStorage.Assets:FindFirstChild("Ball")
            if child:HasTag("WeldedBall") or (ballAssets and ballAssets:FindFirstChild(child.Name) ~= nil) then
                applyCustomSkinToWeldedBall(child, player)
            end
        end
    end))
end

trackConn(CollectionService:GetInstanceAddedSignal("WeldedBall"):Connect(function(inst)
    applyCustomSkinToWeldedBall(inst, nil)
end))

if LocalPlayer.Character then
    hookCharacterForWeldedBall(LocalPlayer, LocalPlayer.Character)
end
trackConn(LocalPlayer.CharacterAdded:Connect(function(char)
    hookCharacterForWeldedBall(LocalPlayer, char)
end))

cleanupOrphanedBalls()
refreshAllWeldedBalls()

local function applyPeerData(data)
    if type(data) ~= "table" or not data.uid then
        return
    end
    local uidStr = tostring(data.uid)
    if uidStr == tostring(LocalPlayer.UserId) then
        return
    end
    local seq = tonumber(data.seq) or 0
    if lastPeerSeq[uidStr] and seq < lastPeerSeq[uidStr] then
        return
    end
    local isFirstSeenPeer = (peerCosmetics[uidStr] == nil)
    lastPeerSeq[uidStr] = seq

    local prev = peerCosmetics[uidStr] or {}
    local favMap = {}
    if type(data.fav) == "table" then
        for _, id in ipairs(data.fav) do
            favMap[id] = true
        end
    end

    local peerState = {
        equipped = type(data.eq) == "table" and data.eq or (prev.equipped or {}),
        resolved = type(data.res) == "table" and data.res or (prev.resolved or {}),
        favorited = favMap,
        showcaseItems = type(data.shw) == "table" and data.shw or (prev.showcaseItems or {}),
        emote = data.em or "",
        emoteSeq = tonumber(data.emSeq) or 0,
        bubble = data.cb or "",
        bubbleSeq = tonumber(data.cbSeq) or 0,
        serveSeq = tonumber(data.svSeq) or (prev.serveSeq or 0),
        serveSkin = data.svSkin or (prev.serveSkin or ""),
        serveAt = prev.serveAt or 0
    }

    local peerPlayer = Players:GetPlayerByUserId(tonumber(uidStr) or 0)

    if peerState.serveSeq > (prev.serveSeq or 0) then
        peerState.serveAt = os.clock()
        if peerPlayer then
            lastKnownBallOwner = peerPlayer
            lastKnownBallSkin = peerState.serveSkin ~= "" and peerState.serveSkin or peerState.equipped.Ball
            if lastKnownBallSkin then
                replaceLiveActiveBallSkin(lastKnownBallSkin)
            end
        end
    end

    peerCosmetics[uidStr] = peerState

    -- Reply once when discovering a new peer so both sides immediately have each other's loadout
    if isFirstSeenPeer then
        task.delay(0.4, function()
            broadcastP2P(true)
        end)
    end

    if not peerPlayer then
        return
    end

    -- 1. Apply Title
    if peerState.equipped.Title ~= nil then
        applyTitleToPlayer(peerPlayer, peerState.equipped.Title)
    end

    -- 2. Apply Jersey
    if peerPlayer.Character and peerState.equipped.Jersey then
        applyJerseyToCharacter(peerPlayer, peerPlayer.Character, peerState.equipped.Jersey)
    end

    -- 3. Trigger Emote if new emoteSeq (or if first seen while playing an emote)
    if peerState.emoteSeq > (prev.emoteSeq or 0) then
        if peerState.emote == "" or peerState.emote == "__STOP__" then
            stopCustomEmoteOnPlayer(peerPlayer)
        else
            playCustomEmoteOnPlayer(peerPlayer, peerState.emote, false)
        end
    end

    -- 4. Trigger ChatBubble if new bubbleSeq
    if peerState.bubbleSeq > (prev.bubbleSeq or 0) and peerState.bubble ~= "" then
        showChatBubbleOnPlayer(peerPlayer, peerState.bubble)
    end

    -- 5. Update active ball skin & welded serve ball skin if this peer is serving/owning the ball
    if peerPlayer.Character and peerState.equipped.Ball then
        refreshWeldedBallsForCharacter(peerPlayer, peerPlayer.Character)
    end
    local servedBy = ReplicatedStorage:GetAttribute("ServedByPlayer")
    if (servedBy == peerPlayer.Name or lastKnownBallOwner == peerPlayer) and peerState.equipped.Ball then
        lastKnownBallSkin = peerState.equipped.Ball
        replaceLiveActiveBallSkin(peerState.equipped.Ball)
    end
end

local function hookPeerPlayer(player)
    if player == LocalPlayer then
        return
    end
    if player.Character then
        hookCharacterForWeldedBall(player, player.Character)
    end
    trackConn(player.CharacterAdded:Connect(function(char)
        hookCharacterForWeldedBall(player, char)
        task.wait(0.25)
        local peer = peerCosmetics[tostring(player.UserId)]
        if peer and peer.equipped then
            if peer.equipped.Title then
                applyTitleToPlayer(player, peer.equipped.Title)
            end
            if peer.equipped.Jersey then
                applyJerseyToCharacter(player, char, peer.equipped.Jersey)
            end
            if peer.equipped.Ball then
                refreshWeldedBallsForCharacter(player, char)
            end
        end
    end))
    trackConn(player:GetPropertyChangedSignal("Team"):Connect(function()
        task.wait(0.15)
        local peer = peerCosmetics[tostring(player.UserId)]
        if peer and peer.equipped and peer.equipped.Jersey and player.Character then
            applyJerseyToCharacter(player, player.Character, peer.equipped.Jersey)
        end
    end))
    trackConn(player:GetAttributeChangedSignal("Gameplay_Style"):Connect(function()
        task.wait(0.1)
        local peer = peerCosmetics[tostring(player.UserId)]
        if peer and peer.equipped and peer.equipped.Jersey and player.Character then
            applyJerseyToCharacter(player, player.Character, peer.equipped.Jersey)
        end
    end))
    trackConn(player:GetAttributeChangedSignal("Gameplay_ForcedStyle"):Connect(function()
        task.wait(0.1)
        local peer = peerCosmetics[tostring(player.UserId)]
        if peer and peer.equipped and peer.equipped.Jersey and player.Character then
            applyJerseyToCharacter(player, player.Character, peer.equipped.Jersey)
        end
    end))
    trackConn(player:GetAttributeChangedSignal("User_Title"):Connect(function()
        local peer = peerCosmetics[tostring(player.UserId)]
        if peer and peer.equipped and peer.equipped.Title and peer.equipped.Title ~= "" then
            local expected = formatTitleRichText(peer.equipped.Title)
            if player:GetAttribute("User_Title") ~= expected then
                player:SetAttribute("User_Title", expected)
            end
        end
    end))
    trackConn(player:GetAttributeChangedSignal("Context_IsServing"):Connect(function()
        if player:GetAttribute("Context_IsServing") == true then
            lastKnownBallOwner = player
            local peer = peerCosmetics[tostring(player.UserId)]
            if peer and peer.equipped and peer.equipped.Ball then
                lastKnownBallSkin = peer.equipped.Ball
            else
                lastKnownBallSkin = nil
            end
            if player.Character then
                refreshWeldedBallsForCharacter(player, player.Character)
            end
        end
    end))
end

for _, p in ipairs(Players:GetPlayers()) do
    hookPeerPlayer(p)
end
trackConn(Players.PlayerAdded:Connect(function(p)
    hookPeerPlayer(p)
    task.delay(1.5, function()
        broadcastP2P(true)
    end)
end))

-- Track ServedByPlayer attribute changes on ReplicatedStorage
trackConn(ReplicatedStorage:GetAttributeChangedSignal("ServedByPlayer"):Connect(function()
    local servedBy = ReplicatedStorage:GetAttribute("ServedByPlayer")
    if type(servedBy) == "string" and servedBy ~= "" then
        local serverPlayer = Players:FindFirstChild(servedBy)
        if serverPlayer then
            lastKnownBallOwner = serverPlayer
            if serverPlayer == LocalPlayer then
                lastKnownBallSkin = customEquipped.Ball
                replaceLiveActiveBallSkin(customEquipped.Ball)
            else
                local peer = peerCosmetics[tostring(serverPlayer.UserId)]
                if peer and peer.equipped and peer.equipped.Ball then
                    lastKnownBallSkin = peer.equipped.Ball
                    replaceLiveActiveBallSkin(peer.equipped.Ball)
                else
                    lastKnownBallSkin = nil
                end
            end
        else
            lastKnownBallOwner = nil
            lastKnownBallSkin = nil
        end
    end
end))

trackConn(ReplicatedStorage:GetAttributeChangedSignal("RoundState"):Connect(function()
    task.defer(cleanupOrphanedBalls)
end))

trackConn(LocalPlayer:GetAttributeChangedSignal("Context_IsServing"):Connect(function()
    if LocalPlayer:GetAttribute("Context_IsServing") == true then
        lastKnownBallOwner = LocalPlayer
        lastKnownBallSkin = customEquipped.Ball
        localServeAt = os.clock()
        currentServeSkin = customEquipped.Ball
        currentServeSeq = currentServeSeq + 1
        if LocalPlayer.Character then
            refreshWeldedBallsForCharacter(LocalPlayer, LocalPlayer.Character)
        end
        broadcastP2P(true)
    end
end))

-- Hook BallService:SpawnBall & SpawnServeBall & OnBallDestroyed & GameService:Serve
if BallService then
    pcall(function()
        if BallService.OnBallDestroyed then
            trackConn(BallService.OnBallDestroyed:Connect(function()
                task.defer(cleanupOrphanedBalls)
                task.delay(0.15, cleanupOrphanedBalls)
            end))
        end
        BallService.__vblOrigSpawnBall = BallService.__vblOrigSpawnBall or BallService.SpawnBall
        local origSpawnBall = BallService.__vblOrigSpawnBall
        if type(origSpawnBall) == "function" then
            BallService.SpawnBall = function(self, ...)
                lastKnownBallOwner = LocalPlayer
                lastKnownBallSkin = customEquipped.Ball
                localServeAt = os.clock()
                currentServeSkin = customEquipped.Ball
                currentServeSeq = currentServeSeq + 1
                broadcastP2P(true)
                return origSpawnBall(self, ...)
            end
        end
        BallService.__vblOrigSpawnServeBall = BallService.__vblOrigSpawnServeBall or BallService.SpawnServeBall
        local origSpawnServeBall = BallService.__vblOrigSpawnServeBall
        if type(origSpawnServeBall) == "function" then
            BallService.SpawnServeBall = function(self, ...)
                lastKnownBallOwner = LocalPlayer
                lastKnownBallSkin = customEquipped.Ball
                localServeAt = os.clock()
                currentServeSkin = customEquipped.Ball
                currentServeSeq = currentServeSeq + 1
                broadcastP2P(true)
                return origSpawnServeBall(self, ...)
            end
        end
    end)
end

if GameService then
    pcall(function()
        GameService.__vblOrigServe = GameService.__vblOrigServe or GameService.Serve
        local origServe = GameService.__vblOrigServe
        if type(origServe) == "function" then
            GameService.Serve = function(self, ...)
                lastKnownBallOwner = LocalPlayer
                lastKnownBallSkin = customEquipped.Ball
                localServeAt = os.clock()
                currentServeSkin = customEquipped.Ball
                currentServeSeq = currentServeSeq + 1
                broadcastP2P(true)
                return origServe(self, ...)
            end
        end
    end)
end

-- Hook JerseyTool.set so whenever the game re-applies jerseys (e.g. Style roll or match start), custom P2P jerseys and real Style Name/Number are preserved
if JerseyTool and type(JerseyTool.set) == "function" then
    JerseyTool.__vblOrigSet = JerseyTool.__vblOrigSet or JerseyTool.set
    local origJerseySet = JerseyTool.__vblOrigSet
    JerseyTool.set = function(props, ...)
        local targetPlayer = nil
        local targetChar = nil
        if type(props) == "table" then
            pcall(function()
                targetPlayer = props.Player
                targetChar = props.Character
                if not targetPlayer and targetChar then
                    targetPlayer = Players:GetPlayerFromCharacter(targetChar)
                end
                if targetChar then
                    hookCharacterForJerseySanitizer(targetPlayer, targetChar)
                end
                if not isApplyingCustomJersey then
                    if targetPlayer == LocalPlayer and targetChar == LocalPlayer.Character then
                        if customEquipped.Jersey and customEquipped.Jersey ~= "" then
                            props.Id = customEquipped.Jersey
                        end
                    elseif targetPlayer then
                        local peer = peerCosmetics[tostring(targetPlayer.UserId)]
                        if peer and peer.equipped and peer.equipped.Jersey and peer.equipped.Jersey ~= "" then
                            props.Id = peer.equipped.Jersey
                        end
                    end
                end
                local resolvedName, resolvedNumber = resolveJerseyStyleNameAndNumber(targetPlayer, targetChar, props.Name, props.Number)
                if resolvedName then
                    props.Name = resolvedName
                end
                if resolvedNumber then
                    props.Number = resolvedNumber
                end
            end)
        end
        local res = origJerseySet(props, ...)
        if targetChar then
            pcall(function()
                for _, child in ipairs(targetChar:GetChildren()) do
                    if child.Name == "JerseyBack" or child.Name == "JerseyFront" or child:IsA("Clothing") or child.Name == "_jerseyInstances" then
                        child:SetAttribute("_VBLCustomJersey", true)
                    end
                end
                sanitizeCharacterJerseyDuplicates(targetPlayer, targetChar)
            end)
        end
        return res
    end
end

-- Poll P2P messages from ntfy.sh + periodic heartbeat every 15s
if type(httpRequest) == "function" then
    task.spawn(function()
        broadcastP2P(true)
        local sinceParam = "45s"
        local lastHeartbeat = os.clock()
        while _G.__VolleyballUnlockAllToken == scriptRunToken do
            local ok, resp = pcall(httpRequest, {
                Url = P2P_URL .. "/json?poll=1&since=" .. sinceParam,
                Method = "GET"
            })
            if ok and type(resp) == "table" and type(resp.Body) == "string" and #resp.Body > 0 then
                for line in resp.Body:gmatch("[^\r\n]+") do
                    local okLine, env = pcall(function()
                        return HttpService:JSONDecode(line)
                    end)
                    if okLine and type(env) == "table" then
                        if env.id then
                            sinceParam = tostring(env.id)
                        end
                        if env.event == "message" and type(env.message) == "string" then
                            local okMsg, msgData = pcall(function()
                                return HttpService:JSONDecode(env.message)
                            end)
                            if okMsg and type(msgData) == "table" then
                                applyPeerData(msgData)
                            end
                        end
                    end
                end
            end
            if os.clock() - lastHeartbeat >= 15 then
                lastHeartbeat = os.clock()
                broadcastP2P(true)
            end
            task.wait(1.0)
        end
    end)
end

-- ============================================================================
-- 6. HOOK INVENTORYSERVICE (EQUIP, TOGGLEFAVORITE, USE, STOPEMOTES)
-- ============================================================================
if InventoryService then
    InventoryService.__vblOrigEquip = InventoryService.__vblOrigEquip or InventoryService.Equip
    InventoryService.__vblOrigToggleFavorite = InventoryService.__vblOrigToggleFavorite or InventoryService.ToggleFavorite
    InventoryService.__vblOrigUse = InventoryService.__vblOrigUse or InventoryService.Use
    InventoryService.__vblOrigStopEmotes = InventoryService.__vblOrigStopEmotes or InventoryService.StopEmotes
    local origEquip = InventoryService.__vblOrigEquip
    local origToggleFavorite = InventoryService.__vblOrigToggleFavorite
    local origUse = InventoryService.__vblOrigUse
    local origStopEmotes = InventoryService.__vblOrigStopEmotes

    InventoryService.Equip = function(self, itemId, slotIndex, ...)
        local item = Item:Get(itemId)
        if item then
            if item.Type == Item.Type.Emote then
                local slot = tonumber(slotIndex) or 1
                customEquipped.Emotes = normalizeWheelSlots(customEquipped.Emotes, 8, Item.Type.Emote, PREFERRED_DEFAULT_EMOTES, VALID_EMOTE_IDS)
                customEquipped.Emotes[slot] = itemId
            elseif item.Type == Item.Type.ChatBubble then
                local slot = tonumber(slotIndex) or 1
                customEquipped.ChatBubbles = normalizeWheelSlots(customEquipped.ChatBubbles, 12, Item.Type.ChatBubble, PREFERRED_DEFAULT_BUBBLES, VALID_CHATBUBBLE_IDS)
                customEquipped.ChatBubbles[slot] = itemId
            elseif item.Type == Item.Type.Title then
                if customEquipped.Title == itemId then
                    customEquipped.Title = ""
                else
                    customEquipped.Title = itemId
                end
            elseif item.Type == Item.Type.PlayerCard then
                if customEquipped.PlayerCard == itemId then
                    customEquipped.PlayerCard = "Classic1PlayerCard"
                else
                    customEquipped.PlayerCard = itemId
                end
            elseif UNLOCK_TYPES[item.Type] then
                local defaultId = "Classic" .. tostring(item.Type)
                if customEquipped[item.Type] == itemId and Item:Get(defaultId) then
                    customEquipped[item.Type] = defaultId
                else
                    customEquipped[item.Type] = itemId
                end
            end

            if item.Type == Item.Type.Ball then
                if lastKnownBallOwner == LocalPlayer then
                    lastKnownBallSkin = customEquipped.Ball
                    replaceLiveActiveBallSkin(customEquipped.Ball)
                end
                if LocalPlayer.Character then
                    refreshWeldedBallsForCharacter(LocalPlayer, LocalPlayer.Character)
                end
            end

            rollNextRandomCosmetics()
            pushStateToUI()
            savePreset()
            broadcastP2P(true)

            -- Only forward Equip to the server if the player genuinely owns the item AND (for slots > 4 / > 6) genuinely owns the 2x Slots Gamepass on the server.
            -- Otherwise the server rejects the Equip and fires DataService.ProfileUpdated("Equipped") with the old server table, wiping out our client-equipped Emotes!
            local canForwardToServer = (realServerInventory[itemId] and realServerInventory[itemId] > 0) and true or false
            if canForwardToServer and item.Type == Item.Type.Emote then
                local slot = tonumber(slotIndex) or 1
                if slot > 4 and not (realServerGamepasses["1966614287"] or realServerGamepasses["3710770149"]) then
                    canForwardToServer = false
                end
            elseif canForwardToServer and item.Type == Item.Type.ChatBubble then
                local slot = tonumber(slotIndex) or 1
                if slot > 6 and not (realServerGamepasses["2081834450"] or realServerGamepasses["3730641443"]) then
                    canForwardToServer = false
                end
            end

            if canForwardToServer and type(origEquip) == "function" then
                pcall(origEquip, self, itemId, slotIndex, ...)
            end
            return Promise.resolve(nil)
        end
        if type(origEquip) == "function" then
            return origEquip(self, itemId, slotIndex, ...)
        end
        return Promise.resolve(nil)
    end

    InventoryService.ToggleFavorite = function(self, itemId, ...)
        if type(itemId) == "string" and Item:Get(itemId) then
            if customFavorited[itemId] then
                customFavorited[itemId] = nil
            else
                customFavorited[itemId] = true
            end
            rollNextRandomCosmetics()
            pushStateToUI()
            savePreset()
            broadcastP2P(true)

            if realServerInventory[itemId] and realServerInventory[itemId] > 0 and type(origToggleFavorite) == "function" then
                pcall(origToggleFavorite, self, itemId, ...)
            end
            return Promise.resolve(nil)
        end
        if type(origToggleFavorite) == "function" then
            return origToggleFavorite(self, itemId, ...)
        end
        return Promise.resolve(nil)
    end

    InventoryService.Use = function(self, itemId, ...)
        local item = Item:Get(itemId)
        if item then
            if item.Type == Item.Type.Emote then
                currentEmoteId = itemId
                currentEmoteSeq = currentEmoteSeq + 1
                broadcastP2P(true)

                if realServerInventory[itemId] and realServerInventory[itemId] > 0 and type(origUse) == "function" then
                    stopCustomEmoteOnPlayer(LocalPlayer)
                    return origUse(self, itemId, ...)
                else
                    playCustomEmoteOnPlayer(LocalPlayer, itemId, true)
                    return Promise.resolve(nil)
                end
            elseif item.Type == Item.Type.ChatBubble then
                currentBubbleId = itemId
                currentBubbleSeq = currentBubbleSeq + 1
                broadcastP2P(true)

                if realServerInventory[itemId] and realServerInventory[itemId] > 0 and type(origUse) == "function" then
                    return origUse(self, itemId, ...)
                else
                    showChatBubbleOnPlayer(LocalPlayer, itemId)
                    return Promise.resolve(nil)
                end
            end
        end
        if type(origUse) == "function" then
            return origUse(self, itemId, ...)
        end
        return Promise.resolve(nil)
    end

    InventoryService.StopEmotes = function(self, ...)
        stopCustomEmoteOnPlayer(LocalPlayer)
        if currentEmoteId ~= "" then
            currentEmoteId = "__STOP__"
            currentEmoteSeq = currentEmoteSeq + 1
            broadcastP2P(true)
        end
        if type(origStopEmotes) == "function" then
            return origStopEmotes(self, ...)
        end
        return Promise.resolve(nil)
    end
end

-- ============================================================================
-- 7. HOOK PLAYERINSPECTSERVICE (PROFILE ART, SHOWCASE CARDS, PEER PROFILE)
-- ============================================================================
if PlayerInspectService then
    PlayerInspectService.__vblOrigGetInspectData = PlayerInspectService.__vblOrigGetInspectData or PlayerInspectService.GetInspectData
    PlayerInspectService.__vblOrigSetInspectField = PlayerInspectService.__vblOrigSetInspectField or PlayerInspectService.SetInspectField
    local origGetInspectData = PlayerInspectService.__vblOrigGetInspectData
    local origSetInspectField = PlayerInspectService.__vblOrigSetInspectField

    PlayerInspectService.GetInspectData = function(self, targetUserId, ...)
        if type(origGetInspectData) ~= "function" then
            return Promise.resolve(nil)
        end
        return origGetInspectData(self, targetUserId, ...):andThen(function(ok, result)
            if ok and type(result) == "table" then
                if tonumber(targetUserId) == LocalPlayer.UserId then
                    result.Title = customEquipped.Title
                    result.Art = customEquipped.ProfileArt
                    result.Jersey = customEquipped.Jersey
                    if type(result.Items) == "table" then
                        for i = 1, 4 do
                            if customShowcaseItems[i] and customShowcaseItems[i] ~= "" then
                                result.Items[i] = customShowcaseItems[i]
                            end
                        end
                    end
                else
                    local peer = peerCosmetics[tostring(targetUserId)]
                    if peer and peer.equipped then
                        if peer.equipped.Title and peer.equipped.Title ~= "" then
                            result.Title = peer.equipped.Title
                        end
                        if peer.equipped.ProfileArt and peer.equipped.ProfileArt ~= "" then
                            result.Art = peer.equipped.ProfileArt
                        end
                        if peer.equipped.Jersey and peer.equipped.Jersey ~= "" then
                            result.Jersey = peer.equipped.Jersey
                        end
                        if type(peer.showcaseItems) == "table" and type(result.Items) == "table" then
                            for i = 1, 4 do
                                if type(peer.showcaseItems[i]) == "string" and peer.showcaseItems[i] ~= "" then
                                    result.Items[i] = peer.showcaseItems[i]
                                end
                            end
                        end
                    end
                end
            end
            return ok, result
        end)
    end

    PlayerInspectService.SetInspectField = function(self, kind, index, value, ...)
        if kind == "Item" and type(index) == "number" then
            customShowcaseItems[index] = type(value) == "string" and value or ""
            savePreset()
            broadcastP2P(false)
            if InspectState and InspectState.items then
                withNormalIdentity(function()
                    local clone = table.clone(InspectState.items() or customShowcaseItems)
                    clone[index] = customShowcaseItems[index]
                    InspectState.items(clone)
                end)
            end
            if value == nil or value == "" or (realServerInventory[value] and realServerInventory[value] > 0) then
                if type(origSetInspectField) == "function" then
                    return origSetInspectField(self, kind, index, value, ...)
                end
            end
            return Promise.resolve(true)
        end
        if type(origSetInspectField) == "function" then
            return origSetInspectField(self, kind, index, value, ...)
        end
        return Promise.resolve(true)
    end
end

-- ============================================================================
-- 8. RESOLVE ACTIVE BALL SKIN FOR LOCALPLAYER & P2P PEERS (LIVE & REPLAY)
-- ============================================================================
local function resolveActiveBallSkin(spawnPos)
    -- 1. Check ReplicatedStorage:GetAttribute("ServedByPlayer") first (match play)
    local servedBy = ReplicatedStorage:GetAttribute("ServedByPlayer")
    if type(servedBy) == "string" and servedBy ~= "" then
        if servedBy == LocalPlayer.Name then
            lastKnownBallOwner = LocalPlayer
            lastKnownBallSkin = customEquipped.Ball
            return customEquipped.Ball
        end
        local serverPlayer = Players:FindFirstChild(servedBy)
        if serverPlayer then
            lastKnownBallOwner = serverPlayer
            local peer = peerCosmetics[tostring(serverPlayer.UserId)]
            if peer and peer.equipped and peer.equipped.Ball then
                lastKnownBallSkin = peer.equipped.Ball
                return peer.equipped.Ball
            end
        end
        -- Another non-script player served: keep their original server ball skin!
        lastKnownBallSkin = nil
        return nil
    end

    -- 2. Check if any player currently has Context_IsServing == true
    for _, p in ipairs(Players:GetPlayers()) do
        if p:GetAttribute("Context_IsServing") == true then
            lastKnownBallOwner = p
            if p == LocalPlayer then
                lastKnownBallSkin = customEquipped.Ball
                return customEquipped.Ball
            else
                local peer = peerCosmetics[tostring(p.UserId)]
                if peer and peer.equipped and peer.equipped.Ball then
                    lastKnownBallSkin = peer.equipped.Ball
                    return peer.equipped.Ball
                end
                -- Normal non-script player is serving: keep their original ball skin!
                lastKnownBallSkin = nil
                return nil
            end
        end
    end

    -- 3. Check if LocalPlayer or a P2P peer explicitly spawned/served in the last 3 seconds
    local now = os.clock()
    if localServeAt and (now - localServeAt) < 3.0 then
        lastKnownBallOwner = LocalPlayer
        lastKnownBallSkin = customEquipped.Ball
        return customEquipped.Ball
    end
    local recentPeerSkin = nil
    local recentPeerPlayer = nil
    local recentTime = 0
    for uidStr, peer in pairs(peerCosmetics) do
        if peer.serveAt and (now - peer.serveAt) < 3.0 and peer.serveAt > recentTime then
            recentTime = peer.serveAt
            recentPeerSkin = (peer.serveSkin ~= "" and peer.serveSkin) or (peer.equipped and peer.equipped.Ball)
            recentPeerPlayer = Players:GetPlayerByUserId(tonumber(uidStr) or 0)
        end
    end
    if recentPeerSkin then
        lastKnownBallOwner = recentPeerPlayer
        lastKnownBallSkin = recentPeerSkin
        return recentPeerSkin
    end

    -- 4. Fallback for Training / free-spawn: find the closest player among ALL players to spawnPos.
    -- Only override the ball skin if that closest player is LocalPlayer or a P2P peer!
    if typeof(spawnPos) == "Vector3" then
        local closestDist = 25
        local closestPlayer = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and p.Character.PrimaryPart then
                local d = (p.Character.PrimaryPart.Position - spawnPos).Magnitude
                if d < closestDist then
                    closestDist = d
                    closestPlayer = p
                end
            end
        end
        if closestPlayer then
            lastKnownBallOwner = closestPlayer
            if closestPlayer == LocalPlayer then
                lastKnownBallSkin = customEquipped.Ball
                return customEquipped.Ball
            else
                local peer = peerCosmetics[tostring(closestPlayer.UserId)]
                if peer and peer.equipped and peer.equipped.Ball then
                    lastKnownBallSkin = peer.equipped.Ball
                    return peer.equipped.Ball
                end
            end
            lastKnownBallSkin = nil
            return nil
        end
    end

    -- If the owner is unknown or a regular player, do NOT overwrite with LocalPlayer's ball!
    return nil
end

pcall(function()
    local bm = BallModule or require(ReplicatedFirst:WaitForChild("Controllers"):WaitForChild("BallController"):WaitForChild("Ball"))
    if type(bm) == "table" and type(bm.new) == "function" then
        bm.__vblOrigNew = bm.__vblOrigNew or bm.new
        local origBallNew = bm.__vblOrigNew
        bm.new = function(ballModel, cframe, ballId, itemEntity, ...)
            pcall(function()
                local spawnPos = (typeof(cframe) == "CFrame" and cframe.Position) or nil
                local desiredSkin = resolveActiveBallSkin(spawnPos)

                if type(desiredSkin) == "string" and desiredSkin ~= "" then
                    local newItem = Item:Get(desiredSkin)
                    local template = ReplicatedStorage:FindFirstChild("Assets")
                        and ReplicatedStorage.Assets:FindFirstChild("Ball")
                        and ReplicatedStorage.Assets.Ball:FindFirstChild(desiredSkin)

                    if newItem and template and ballModel then
                        if ballModel.Name ~= desiredSkin then
                            local parent = ballModel.Parent
                            local replacement = template:Clone()
                            for _, desc in ipairs(replacement:GetDescendants()) do
                                if desc:IsA("BasePart") then
                                    desc.CastShadow = false
                                end
                            end
                            replacement:SetAttribute("_VBLSkin", desiredSkin)
                            replacement:SetAttribute("_VBLSwappedBall", true)
                            replacement.Parent = parent
                            ballModel:Destroy()
                            ballModel = replacement
                            itemEntity = newItem
                        else
                            ballModel:SetAttribute("_VBLSkin", desiredSkin)
                        end
                    end
                end
            end)
            return origBallNew(ballModel, cframe, ballId, itemEntity, ...)
        end

        if type(bm.Destroy) == "function" then
            bm.__vblOrigDestroy = bm.__vblOrigDestroy or bm.Destroy
            local origBallDestroy = bm.__vblOrigDestroy
            bm.Destroy = function(self, ...)
                local curBall = type(self) == "table" and self.Ball or nil
                local curShadow = type(self) == "table" and self.Shadow or nil
                local res = origBallDestroy(self, ...)
                if curBall and curBall.Parent then
                    pcall(function() curBall:Destroy() end)
                end
                if curShadow and curShadow.Parent then
                    pcall(function() curShadow:Destroy() end)
                end
                task.defer(cleanupOrphanedBalls)
                return res
            end
        end
    end
end)

-- Also hook Replay GhostBall.new so replays & MVP reels show the P2P synced ball skin!
pcall(function()
    local GhostBall = require(
        ReplicatedFirst:WaitForChild("Controllers")
            :WaitForChild("ReplayController")
            :WaitForChild("Stage")
            :WaitForChild("GhostBall")
    )
    if type(GhostBall) == "table" and type(GhostBall.new) == "function" then
        GhostBall.__vblOrigNew = GhostBall.__vblOrigNew or GhostBall.new
        local origGhostBallNew = GhostBall.__vblOrigNew
        GhostBall.new = function(clip, skinName, folder, ...)
            if lastKnownBallSkin and Item:Get(lastKnownBallSkin) then
                skinName = lastKnownBallSkin
            end
            return origGhostBallNew(clip, skinName, folder, ...)
        end
    end
end)

-- ============================================================================
-- 9. HOOK SCORE EFFECT (HITGROUND.PLAY IN LIVE PLAY & REPLAYS)
-- ============================================================================
local function computeLandingSeed(pos, scorerUserId)
    if typeof(pos) == "Vector3" then
        local qx = math.floor(pos.X * 2 + 0.5)
        local qy = math.floor(pos.Y * 2 + 0.5)
        local qz = math.floor(pos.Z * 2 + 0.5)
        return math.abs(qx * 73856093 + qy * 19349663 + qz * 83492791 + (tonumber(scorerUserId) or 0) * 1013)
    end
    return math.floor(workspace:GetServerTimeNow()) + (tonumber(scorerUserId) or 0)
end

pcall(function()
    local HitGround = require(
        ReplicatedFirst:WaitForChild("Controllers")
            :WaitForChild("GameController")
            :WaitForChild("Effects")
            :WaitForChild("Registry")
            :WaitForChild("HitGround")
    )
    if type(HitGround) == "table" and type(HitGround.play) == "function" then
        HitGround.__vblOrigPlay = HitGround.__vblOrigPlay or HitGround.play
        local origHitGroundPlay = HitGround.__vblOrigPlay
        HitGround.play = function(props, ...)
            if type(props) == "table" then
                pcall(function()
                    local scorerPlayer = nil
                    if typeof(props.Character) == "Instance" then
                        scorerPlayer = Players:GetPlayerFromCharacter(props.Character)
                        if not scorerPlayer and type(props.Character.Name) == "string" then
                            local cleanName = props.Character.Name:gsub("_Replay$", ""):gsub("#Clone%d+$", "")
                            scorerPlayer = Players:FindFirstChild(cleanName)
                        end
                    end
                    if not scorerPlayer then
                        local lastHitter = ReplicatedStorage:GetAttribute("LastHitter")
                        if type(lastHitter) == "string" and lastHitter ~= "" then
                            scorerPlayer = Players:FindFirstChild(lastHitter)
                        end
                    end
                    if not scorerPlayer then
                        scorerPlayer = lastKnownBallOwner
                    end

                    if props.ScoreEffect ~= nil or (scorerPlayer and props.IsOutOfBounds == false) then
                        local posKey = nil
                        if typeof(props.Position) == "Vector3" then
                            posKey = string.format("%d_%d_%d", math.floor(props.Position.X + 0.5), math.floor(props.Position.Y + 0.5), math.floor(props.Position.Z + 0.5))
                        end

                        if props.IsReplay and posKey and lastReplayPointScoreEffect[posKey] then
                            -- Use the exact same ScoreEffect that played during the live point!
                            props.ScoreEffect = lastReplayPointScoreEffect[posKey]
                        elseif scorerPlayer == LocalPlayer then
                            local chosen = nextResolvedScoreEffect
                            if not chosen or not Item:Get(chosen) or customEquipped.ScoreEffect ~= "RandomFavoriteScoreEffect" then
                                local detSeed = computeLandingSeed(props.Position, LocalPlayer.UserId)
                                chosen = pickResolvedScoreEffect(customEquipped.ScoreEffect, customFavorited, detSeed)
                            end
                            props.ScoreEffect = chosen
                            props.Character = props.Character or LocalPlayer.Character
                            if posKey then
                                lastReplayPointScoreEffect[posKey] = chosen
                            end
                            -- Pre-roll and broadcast the next random ScoreEffect so all peers stay 100% in sync!
                            if not props.IsReplay and customEquipped.ScoreEffect == "RandomFavoriteScoreEffect" then
                                nextResolvedScoreEffect = pickResolvedScoreEffect(customEquipped.ScoreEffect, customFavorited)
                                broadcastP2P(true)
                            end
                        elseif scorerPlayer then
                            local peer = peerCosmetics[tostring(scorerPlayer.UserId)]
                            if peer and peer.equipped and peer.equipped.ScoreEffect then
                                local chosen = nil
                                if peer.equipped.ScoreEffect == "RandomFavoriteScoreEffect" then
                                    if peer.resolved and type(peer.resolved.ScoreEffect) == "string" and Item:Get(peer.resolved.ScoreEffect) then
                                        chosen = peer.resolved.ScoreEffect
                                    else
                                        local detSeed = computeLandingSeed(props.Position, scorerPlayer.UserId)
                                        chosen = pickResolvedScoreEffect(peer.equipped.ScoreEffect, peer.favorited, detSeed)
                                    end
                                else
                                    chosen = pickResolvedScoreEffect(peer.equipped.ScoreEffect, peer.favorited)
                                end
                                props.ScoreEffect = chosen
                                props.Character = props.Character or scorerPlayer.Character
                                if posKey then
                                    lastReplayPointScoreEffect[posKey] = chosen
                                end
                            end
                        end
                    end
                end)
            end
            return origHitGroundPlay(props, ...)
        end
    end
end)

-- ============================================================================
-- 10. HOOK PLAYER CARD FLASHCARD & WIN CUTSCENE (LOCAL & P2P MVP)
-- ============================================================================
if PlayerCardController and type(PlayerCardController.DisplayFlashCard) == "function" then
    PlayerCardController.__vblOrigDisplayFlashCard = PlayerCardController.__vblOrigDisplayFlashCard or PlayerCardController.DisplayFlashCard
    local origDisplayFlashCard = PlayerCardController.__vblOrigDisplayFlashCard
    PlayerCardController.DisplayFlashCard = function(self, data, ...)
        if type(data) == "table" and data.Player then
            pcall(function()
                local statVal = (type(data.Context) == "table" and type(data.Context.SingleStat) == "table" and tonumber(data.Context.SingleStat.Value)) or 0
                local detSeed = statVal * 997 + data.Player.UserId
                if data.Player == LocalPlayer then
                    local chosen = nextResolvedPlayerCard
                    if not chosen or not Item:Get(chosen) or customEquipped.PlayerCard ~= "RandomFavoritePlayerCard" then
                        chosen = pickResolvedPlayerCard(customEquipped.PlayerCard, customFavorited, detSeed)
                    end
                    data.PlayerCardItemId = chosen
                    if customEquipped.PlayerCard == "RandomFavoritePlayerCard" then
                        nextResolvedPlayerCard = pickResolvedPlayerCard(customEquipped.PlayerCard, customFavorited)
                        broadcastP2P(true)
                    end
                else
                    local peer = peerCosmetics[tostring(data.Player.UserId)]
                    if peer and peer.equipped and peer.equipped.PlayerCard then
                        local chosen = nil
                        if peer.equipped.PlayerCard == "RandomFavoritePlayerCard" then
                            if peer.resolved and type(peer.resolved.PlayerCard) == "string" and Item:Get(peer.resolved.PlayerCard) then
                                chosen = peer.resolved.PlayerCard
                            else
                                chosen = pickResolvedPlayerCard(peer.equipped.PlayerCard, peer.favorited, detSeed)
                            end
                        else
                            chosen = pickResolvedPlayerCard(peer.equipped.PlayerCard, peer.favorited)
                        end
                        data.PlayerCardItemId = chosen
                    end
                end
            end)
        end
        return origDisplayFlashCard(self, data, ...)
    end
end

pcall(function()
    local WinCutscene = require(
        ReplicatedFirst:WaitForChild("Controllers")
            :WaitForChild("GameController")
            :WaitForChild("Components")
            :WaitForChild("Screens")
            :WaitForChild("WinCutscene")
    )
    if type(WinCutscene) == "table" and type(WinCutscene.play) == "function" then
        WinCutscene.__vblOrigPlay = WinCutscene.__vblOrigPlay or WinCutscene.play
        local origWinPlay = WinCutscene.__vblOrigPlay
        WinCutscene.play = function(data, callback, ...)
            if type(data) == "table" then
                pcall(function()
                    local mvpPlayer = type(data.Cutscene) == "table" and data.Cutscene[1] or nil
                    if mvpPlayer == LocalPlayer then
                        if customEquipped.WinScreen and customEquipped.WinScreen ~= "" and Item:Get(customEquipped.WinScreen) then
                            data.CutsceneId = customEquipped.WinScreen
                        end
                    elseif typeof(mvpPlayer) == "Instance" and mvpPlayer:IsA("Player") then
                        local peer = peerCosmetics[tostring(mvpPlayer.UserId)]
                        if peer and peer.equipped and peer.equipped.WinScreen and Item:Get(peer.equipped.WinScreen) then
                            data.CutsceneId = peer.equipped.WinScreen
                        else
                            if customEquipped.WinScreen and customEquipped.WinScreen ~= "" and Item:Get(customEquipped.WinScreen) then
                                data.CutsceneId = customEquipped.WinScreen
                            end
                        end
                    elseif customEquipped.WinScreen and customEquipped.WinScreen ~= "" and Item:Get(customEquipped.WinScreen) then
                        data.CutsceneId = customEquipped.WinScreen
                    end
                end)
            end
            return origWinPlay(data, callback, ...)
        end
    end
end)

print(string.format(
    "[VolleyballUnlockAll v2.0] Loaded! Balls=%d | ScoreFX=%d | Titles=%d | Emotes=%d | Cards=%d | Bubbles=%d | Jerseys=%d | Art=%d | WinScreens=%d | P2P=%s",
    unlockedCountsByType[Item.Type.Ball] or 0,
    unlockedCountsByType[Item.Type.ScoreEffect] or 0,
    unlockedCountsByType[Item.Type.Title] or 0,
    unlockedCountsByType[Item.Type.Emote] or 0,
    unlockedCountsByType[Item.Type.PlayerCard] or 0,
    unlockedCountsByType[Item.Type.ChatBubble] or 0,
    unlockedCountsByType[Item.Type.Jersey] or 0,
    unlockedCountsByType[Item.Type.ProfileArt] or 0,
    unlockedCountsByType[Item.Type.WinScreen] or 0,
    P2P_TOPIC
))
