-- ============================================================================
-- RAGDOLL BOXING 3D - COMPLETE UNLOCK ALL + LIVE COSMETIC & P2P SYNC ENGINE v2.1
-- [YDX Execution Telemetry - Non-Duplicating when loaded via Universal Loader]
do
    local env = (type(getgenv) == "function" and getgenv()) or _G
    env.__YDX_EXEC_LOCKS = env.__YDX_EXEC_LOCKS or {}
    local sid = "boxing-unlock"
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
-- PlaceId: 96740842890477 | GameId: 10770779724
-- Pure ASCII | Zero Lag | 100% Trails, Hairs, Tattoos, KOFX, KO Sounds, Emotes,
-- Entrances, Titles, Name Colors, GamePasses, Story Fights, Season Pass Unlocker
-- & Automatic Real-Time P2P Sync (See Other Script Users' Equipped Cosmetics!)
-- ============================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    return
end

local Boxing = ReplicatedStorage:WaitForChild("Boxing", 15)
if not Boxing then
    warn("[BoxingUnlockAll] ReplicatedStorage.Boxing not found!")
    return
end

-- Cleanup previous instance if re-executed
if _G.__BoxingUnlockAllCleanup then
    pcall(_G.__BoxingUnlockAllCleanup)
end

local connections = {}
local function trackConn(conn)
    if conn then
        table.insert(connections, conn)
    end
    return conn
end

-- Load game modules
local ShopItems = require(Boxing:WaitForChild("ShopItems"))
local Looks = require(Boxing:WaitForChild("Looks"))
local Styles = require(Boxing:WaitForChild("Styles"))
local Boxer = require(Boxing:WaitForChild("Boxer"))
local Net = require(Boxing:WaitForChild("Net"))
local KoFx = require(Boxing:WaitForChild("KoFx"))
local Settings = require(Boxing:WaitForChild("Settings"))
local Story = require(Boxing:WaitForChild("Story"))
local Quests = require(Boxing:WaitForChild("Quests"))
local Poses = require(Boxing:WaitForChild("Poses"))
local Entrances = nil
local TrailExtras = nil
pcall(function()
    Entrances = require(Boxing:WaitForChild("Entrances", 5))
end)
pcall(function()
    TrailExtras = require(Boxing:WaitForChild("TrailExtras", 5))
end)
local CollectionService = game:GetService("CollectionService")

-- Optional client controllers
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts", 10)
local Controllers = PlayerScripts and PlayerScripts:FindFirstChild("Controllers")
local EmoteController = nil
local FightIntro = nil
pcall(function()
    if Controllers then
        EmoteController = require(Controllers:WaitForChild("EmoteController", 5))
        FightIntro = require(Controllers:WaitForChild("FightIntro", 5))
    end
end)

-- ============================================================================
-- 0B. 3D EMOTE PROP ENGINE FIX (MAKES "L", "ZZZ", AND "BELT" VISIBLE ON PEERS!)
-- ============================================================================
-- Root cause (see DUMPS_INDEX.md):
-- 1) Poses.addProp parents EmoteProp* parts directly into fighterModel.
--    For any remote player (your friend looking at you), OpponentSmoothing clones
--    all BasePart children of fighterModel into v247.copies, forces
--    LocalTransparencyModifier = 1 on the real parts, and hides v247.copies in the ring!
-- 2) Poses.placeProp uses raw fighterModel.Head.CFrame instead of Boxer.seenAt(Head),
--    which lags behind the smoothed visual puppet head of remote fighters.
-- Fix: Parent world EmoteProp* parts to workspace.__YDX_EmoteProps (leaving off-workspace
-- ViewportFrame previews untouched) and position them via Boxer.seenAt(part)!

local origAddProp = Poses.addProp
local origPlaceProp = Poses.placeProp
local emotePropsFolder = workspace:FindFirstChild("__YDX_EmoteProps")
if not emotePropsFolder then
    emotePropsFolder = Instance.new("Folder")
    emotePropsFolder.Name = "__YDX_EmoteProps"
    emotePropsFolder.Parent = workspace
end

local function getEmotePropsFolder()
    if not (emotePropsFolder and emotePropsFolder.Parent) then
        emotePropsFolder = workspace:FindFirstChild("__YDX_EmoteProps")
        if not emotePropsFolder then
            emotePropsFolder = Instance.new("Folder")
            emotePropsFolder.Name = "__YDX_EmoteProps"
            emotePropsFolder.Parent = workspace
        end
    end
    return emotePropsFolder
end

local seenProxyCache = setmetatable({}, { __mode = "k" })
local function getSeenFighterProxy(fighterModel)
    local proxy = seenProxyCache[fighterModel]
    if proxy then
        return proxy
    end
    proxy = setmetatable({}, {
        __index = function(_, k)
            if k == "FindFirstChild" then
                return function(_, partName)
                    local realPart = fighterModel:FindFirstChild(partName)
                    if not realPart then
                        return nil
                    end
                    if realPart:IsA("BasePart") then
                        local seenCf = nil
                        if Boxer and typeof(Boxer.seenAt) == "function" then
                            local okCf, cf = pcall(Boxer.seenAt, realPart)
                            if okCf and typeof(cf) == "CFrame" then
                                seenCf = cf
                            end
                        end
                        if not seenCf and Boxer and typeof(Boxer.seen) == "function" then
                            local okPart, sp = pcall(Boxer.seen, realPart)
                            if okPart and typeof(sp) == "Instance" and sp:IsA("BasePart") then
                                seenCf = sp.CFrame
                            end
                        end
                        seenCf = seenCf or realPart.CFrame
                        return {
                            CFrame = seenCf,
                            Position = seenCf.Position,
                            Size = realPart.Size,
                        }
                    end
                    return realPart
                end
            end
            return fighterModel[k]
        end,
    })
    seenProxyCache[fighterModel] = proxy
    return proxy
end

if typeof(origAddProp) == "function" and typeof(origPlaceProp) == "function" then
    Poses.addProp = function(fighterModel, emoteId, scale, ...)
        local propData = origAddProp(fighterModel, emoteId, scale, ...)
        if propData and typeof(propData.list) == "table" and typeof(fighterModel) == "Instance" then
            -- Only move props out of fighterModel when fighterModel is a live world model (in workspace.Fighters).
            -- Off-workspace models built by EmoteArt.model for ViewportFrames keep their props parented to the preview model.
            if fighterModel:IsDescendantOf(workspace) and not fighterModel:GetAttribute("InViewport") then
                local folder = getEmotePropsFolder()
                for _, entry in ipairs(propData.list) do
                    local part = entry and entry[1]
                    if typeof(part) == "Instance" and part:IsA("BasePart") then
                        part.Parent = folder
                        part.LocalTransparencyModifier = 0
                    end
                end
            end
        end
        return propData
    end

    Poses.placeProp = function(fighterModel, propData, elapsed, scale, camPos, ...)
        if typeof(fighterModel) == "Instance" and fighterModel:IsDescendantOf(workspace) and not fighterModel:GetAttribute("InViewport") then
            local proxy = getSeenFighterProxy(fighterModel)
            origPlaceProp(proxy, propData, elapsed, scale, camPos, ...)
            if propData and typeof(propData.list) == "table" then
                local folder = getEmotePropsFolder()
                local hideProp = (fighterModel:GetAttribute("EntranceHidden") == true)
                    or (LocalPlayer:GetAttribute("Replaying") == true)
                local ltm = hideProp and 1 or 0
                for _, entry in ipairs(propData.list) do
                    local part = entry and entry[1]
                    if typeof(part) == "Instance" and part:IsA("BasePart") then
                        if part.Parent ~= folder then
                            part.Parent = folder
                        end
                        if part.LocalTransparencyModifier ~= ltm then
                            part.LocalTransparencyModifier = ltm
                        end
                    end
                end
            end
            return
        end
        return origPlaceProp(fighterModel, propData, elapsed, scale, camPos, ...)
    end
end

-- ============================================================================
-- 1. COLLECT & UNHIDE 100% OF ITEMS, TRAILS, KOFX, EMOTES, SOUNDS, TITLES
-- ============================================================================

local allTrailIds = {}
local trailSeen = {}

local function addTrailId(id)
    if typeof(id) == "string" and id ~= "" and not trailSeen[id] then
        trailSeen[id] = true
        table.insert(allTrailIds, id)
    end
end

-- Promote any waiting trails that have textures and clear .legacy so hidden trails appear in CharacterMenu
if typeof(Looks.TRAILS_WAITING) == "table" then
    for _, t in ipairs(Looks.TRAILS_WAITING) do
        if typeof(t) == "table" and t.id then
            t.legacy = nil
            if typeof(t.textures) == "table" and #t.textures > 0 then
                if not Looks.TRAIL_BY_ID[t.id] then
                    Looks.TRAIL_BY_ID[t.id] = t
                    table.insert(Looks.TRAILS, t)
                end
            end
            addTrailId(t.id)
        end
    end
end

if typeof(Looks.TRAILS) == "table" then
    for _, t in ipairs(Looks.TRAILS) do
        if typeof(t) == "table" and t.id then
            t.legacy = nil
            addTrailId(t.id)
        end
    end
end

local allItemIds = {}
local itemSeen = {}

local function addItemId(id)
    if typeof(id) == "string" and id ~= "" and not itemSeen[id] then
        itemSeen[id] = true
        table.insert(allItemIds, id)
    end
end

for _, groupName in ipairs({ "HAIR", "TATTOOS", "TATTOOS_WAITING", "SOUNDS", "EMOTES", "KOFX", "ENTRANCES", "ALL" }) do
    local list = Styles[groupName]
    if typeof(list) == "table" then
        for _, item in ipairs(list) do
            if typeof(item) == "table" and item.id then
                -- Clear .legacy flag so secret Mythic KOFX (like Shadow Crow & Heavenly Ascend) show up in the menu
                item.legacy = nil
                addItemId(item.id)
            end
        end
    end
end

if typeof(Styles.BY_ID) == "table" then
    for id, item in pairs(Styles.BY_ID) do
        if typeof(item) == "table" then
            item.legacy = nil
        end
        addItemId(id)
    end
end

local allTitleIds = {}
local titleSeen = {}

local function addTitleId(id)
    if typeof(id) == "string" and id ~= "" and not titleSeen[id] then
        titleSeen[id] = true
        table.insert(allTitleIds, id)
    end
end

for _, groupName in ipairs({ "TITLES", "CODE_TITLES", "PASS_TITLES", "SEASON_TITLES", "STORY_TITLES" }) do
    local list = Looks[groupName]
    if typeof(list) == "table" then
        for _, item in ipairs(list) do
            if typeof(item) == "table" and item.id then
                addTitleId(item.id)
            end
        end
    end
end

if Looks.BY and typeof(Looks.BY.title) == "table" then
    for id, _ in pairs(Looks.BY.title) do
        addTitleId(id)
    end
end

local allPassIds = {
    "vip",
    "triple",
    "fastopen",
    "shadowtrail",
    "crowscatter",
    "nametag",
    "toxic",
    "skipspin",
}
if typeof(ShopItems.PASSES) == "table" then
    for _, p in ipairs(ShopItems.PASSES) do
        if typeof(p) == "table" and p.id and not table.find(allPassIds, p.id) then
            table.insert(allPassIds, p.id)
        end
    end
end

local encodedTrails = HttpService:JSONEncode(allTrailIds)
local encodedItems = HttpService:JSONEncode(allItemIds)
local encodedTitles = HttpService:JSONEncode(allTitleIds)
local maxStoryAt = (typeof(Story.FIGHTS) == "table" and (#Story.FIGHTS + 1)) or 25
local encodedStory = HttpService:JSONEncode({
    at = maxStoryAt,
    losses = 0,
    seen = true,
})

-- Hook Boxer.dressStyle so any call to Boxer.recolor from our thread (or CharacterMenu) calls our cached Styles.dress directly without triggering "Cannot require a non-RobloxScript module from a RobloxScript"
pcall(function()
    Boxer.dressStyle = function(model, colors)
        return Styles.dress(model, colors)
    end
end)

-- Hook ShopItems.has so every GamePass check returns true for LocalPlayer
local origShopHas = ShopItems.has
ShopItems.has = function(plr, id, ...)
    if plr == LocalPlayer or plr == nil then
        return true
    end
    if origShopHas then
        return origShopHas(plr, id, ...)
    end
    return true
end

-- ============================================================================
-- 2. AUTHORITATIVE CLIENT STATE + PERSISTENT PRESET + P2P SYNC STATE
-- ============================================================================

local PRESET_FILE = "boxing_saved_preset.json"
local updatingAttr = false
local customLook = nil
local customLookJson = nil
local customTags = {
    NameColor = LocalPlayer:GetAttribute("NameColor") or "",
    Title = LocalPlayer:GetAttribute("Title") or "",
    Pose = LocalPlayer:GetAttribute("Pose") or "",
}
local currentEmote = ""
local peerStates = {} -- [userIdStr] = { look = tbl, lookJson = str, tags = tbl, emote = str, ts = num }
local broadcastMyState = nil

-- Initialize customLook from current Look attribute
pcall(function()
    local raw = LocalPlayer:GetAttribute("Look")
    if typeof(raw) == "string" and raw ~= "" then
        local decoded = HttpService:JSONDecode(raw)
        if typeof(decoded) == "table" then
            customLook = Looks.clean(decoded)
            customLookJson = HttpService:JSONEncode(customLook)
        end
    end
end)
if not customLook then
    customLook = Looks.clean({})
    customLookJson = HttpService:JSONEncode(customLook)
end

-- Load saved preset from disk if available
local function loadSavedPreset()
    if typeof(isfile) ~= "function" or typeof(readfile) ~= "function" then
        return
    end
    local ok, raw = pcall(function()
        if isfile(PRESET_FILE) then
            return readfile(PRESET_FILE)
        end
        return nil
    end)
    if not ok or typeof(raw) ~= "string" or raw == "" then
        return
    end
    local okDec, data = pcall(HttpService.JSONDecode, HttpService, raw)
    if not okDec or typeof(data) ~= "table" then
        return
    end
    if typeof(data.look) == "table" then
        customLook = Looks.clean(data.look)
        customLookJson = HttpService:JSONEncode(customLook)
    end
    if typeof(data.tags) == "table" then
        for _, k in ipairs({ "NameColor", "Title", "Pose" }) do
            if typeof(data.tags[k]) == "string" then
                customTags[k] = data.tags[k]
            end
        end
    end
end

local function saveCurrentPreset()
    if typeof(writefile) ~= "function" then
        return
    end
    pcall(function()
        local payload = HttpService:JSONEncode({
            look = customLook,
            tags = customTags,
        })
        writefile(PRESET_FILE, payload)
    end)
end

loadSavedPreset()

local function applyLookToCharacter(char, lookTbl)
    if not char or typeof(lookTbl) ~= "table" then
        return
    end
    pcall(function()
        local colors = Looks.colors(lookTbl)
        -- Color body parts & gloves directly so we never fail on Boxer.dressStyle's internal require(Styles)
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("BasePart") then
                local tone = child:GetAttribute("Tone")
                if (tone == "cuff" or tone == "gloves") and colors.gloves then
                    pcall(Boxer.dressGlove, child, tone, colors)
                elseif tone and colors[tone] then
                    child.Color = colors[tone]
                end
            end
        end
        if colors.trail ~= nil then
            pcall(Boxer.dressTrail, char, colors.trail)
        end
        if colors.tattoos ~= nil then
            pcall(Styles.dress, char, colors)
        end
    end)
    pcall(function()
        local koId = lookTbl.ko
        local koDef = koId and Styles.BY_ID[koId]
        if koDef and koDef.kind == "sound" then
            char:SetAttribute("KoSound", koDef.sound or "")
            char:SetAttribute("KoSoundMix", koDef.withKnockout == true)
        else
            char:SetAttribute("KoSound", nil)
            char:SetAttribute("KoSoundMix", nil)
        end
    end)
    pcall(function()
        if lookTbl.kofx and lookTbl.kofx ~= "" then
            char:SetAttribute("KoFx", lookTbl.kofx)
        else
            char:SetAttribute("KoFx", nil)
        end
        if lookTbl.intro and lookTbl.intro ~= "" then
            char:SetAttribute("IntroEmote", lookTbl.intro)
        else
            char:SetAttribute("IntroEmote", nil)
        end
        if lookTbl.entrance and lookTbl.entrance ~= "" then
            char:SetAttribute("Entrance", lookTbl.entrance)
        else
            char:SetAttribute("Entrance", nil)
        end
        if lookTbl.trail and lookTbl.trail ~= "" then
            char:SetAttribute("__YDX_TrailId", lookTbl.trail)
        else
            char:SetAttribute("__YDX_TrailId", nil)
        end
        local ownerPlr = Players:GetPlayerFromCharacter(char)
        if ownerPlr then
            char:SetAttribute("__YDX_OwnerUid", ownerPlr.UserId)
        end
    end)
end

local function applyCharacterCosmetics(char)
    char = char or LocalPlayer.Character
    if not char or not customLook then
        return
    end
    applyLookToCharacter(char, customLook)
end

local function applyPeerCosmetics(plr, state)
    if not plr or plr == LocalPlayer or typeof(state) ~= "table" then
        return
    end
    pcall(function()
        if state.lookJson and plr:GetAttribute("Look") ~= state.lookJson then
            plr:SetAttribute("Look", state.lookJson)
        end
        if typeof(state.tags) == "table" then
            for _, attrName in ipairs({ "NameColor", "Title", "Pose" }) do
                local v = state.tags[attrName]
                if typeof(v) == "string" and plr:GetAttribute(attrName) ~= v then
                    plr:SetAttribute(attrName, v)
                end
            end
        end
        if plr:GetAttribute("Pass_vip") ~= true then
            plr:SetAttribute("Pass_vip", true)
        end
        if plr:GetAttribute("Pass_nametag") ~= true then
            plr:SetAttribute("Pass_nametag", true)
        end
    end)
    local char = plr.Character
    if char then
        if typeof(state.look) == "table" then
            applyLookToCharacter(char, state.look)
        end
        if typeof(state.emote) == "string" then
            local wantEmote = state.emote ~= "" and state.emote or nil
            if char:GetAttribute("Emote") ~= wantEmote then
                pcall(function()
                    char:SetAttribute("Emote", wantEmote)
                end)
            end
        end
    end
end

local function enforceUnlockAttributes()
    if updatingAttr then
        return
    end
    updatingAttr = true
    pcall(function()
        if LocalPlayer:GetAttribute("Trails") ~= encodedTrails then
            LocalPlayer:SetAttribute("Trails", encodedTrails)
        end
        if LocalPlayer:GetAttribute("Items") ~= encodedItems then
            LocalPlayer:SetAttribute("Items", encodedItems)
        end
        if LocalPlayer:GetAttribute("Titles") ~= encodedTitles then
            LocalPlayer:SetAttribute("Titles", encodedTitles)
        end
        for _, passId in ipairs(allPassIds) do
            local attrName = "Pass_" .. passId
            if LocalPlayer:GetAttribute(attrName) ~= true then
                LocalPlayer:SetAttribute(attrName, true)
            end
        end
        if LocalPlayer:GetAttribute("PacksBlocked") ~= false then
            LocalPlayer:SetAttribute("PacksBlocked", false)
        end
        if LocalPlayer:GetAttribute("Story") ~= encodedStory then
            LocalPlayer:SetAttribute("Story", encodedStory)
        end

        -- Ensure Season Pass premium is unlocked locally
        local rawSeason = LocalPlayer:GetAttribute("Season")
        if typeof(rawSeason) == "string" and rawSeason ~= "" then
            local okS, sTbl = pcall(HttpService.JSONDecode, HttpService, rawSeason)
            if okS and typeof(sTbl) == "table" and sTbl.premium ~= true then
                sTbl.premium = true
                LocalPlayer:SetAttribute("Season", HttpService:JSONEncode(sTbl))
            end
        end

        -- Enforce customLook if server tried to strip unowned items
        if customLookJson and LocalPlayer:GetAttribute("Look") ~= customLookJson then
            LocalPlayer:SetAttribute("Look", customLookJson)
        end

        -- Enforce custom NameColor, Title, Pose
        for attrName, val in pairs(customTags) do
            if val ~= nil and val ~= "" and LocalPlayer:GetAttribute(attrName) ~= val then
                LocalPlayer:SetAttribute(attrName, val)
            end
        end
    end)
    updatingAttr = false
end

-- Apply immediately
enforceUnlockAttributes()
applyCharacterCosmetics(LocalPlayer.Character)

-- Watch attributes for server overwrites
for _, attrName in ipairs({
    "Trails",
    "Items",
    "Titles",
    "Story",
    "PacksBlocked",
    "Season",
    "Look",
    "NameColor",
    "Title",
    "Pose",
}) do
    trackConn(LocalPlayer:GetAttributeChangedSignal(attrName):Connect(function()
        if updatingAttr then
            return
        end
        task.defer(function()
            enforceUnlockAttributes()
            if attrName == "Look" then
                applyCharacterCosmetics(LocalPlayer.Character)
            end
        end)
    end))
end

for _, passId in ipairs(allPassIds) do
    trackConn(LocalPlayer:GetAttributeChangedSignal("Pass_" .. passId):Connect(function()
        if not updatingAttr then
            task.defer(enforceUnlockAttributes)
        end
    end))
end

-- ============================================================================
-- 3. HOOK Net.fire("look", ...) & SetTag:FireServer(...) & Emotes
-- ============================================================================

local function cloneLook(tbl)
    if typeof(tbl) ~= "table" then
        return Looks.clean({})
    end
    local copy = table.clone(tbl)
    if typeof(tbl.tattoos) == "table" then
        copy.tattoos = table.clone(tbl.tattoos)
    end
    return Looks.clean(copy)
end

local origNetFire = Net.fire
Net.fire = function(topic, a, b, ...)
    if topic == "look" and typeof(a) == "table" then
        customLook = cloneLook(a)
        customLookJson = HttpService:JSONEncode(customLook)
        updatingAttr = true
        pcall(function()
            LocalPlayer:SetAttribute("Look", customLookJson)
        end)
        updatingAttr = false
        saveCurrentPreset()
        applyCharacterCosmetics(LocalPlayer.Character)
        if broadcastMyState then
            task.defer(broadcastMyState, false)
        end
        task.delay(0.15, function()
            enforceUnlockAttributes()
            applyCharacterCosmetics(LocalPlayer.Character)
        end)
        task.delay(0.5, function()
            enforceUnlockAttributes()
            applyCharacterCosmetics(LocalPlayer.Character)
        end)
    elseif topic == "emote" and typeof(a) == "string" then
        currentEmote = a
        local char = LocalPlayer.Character
        if char then
            pcall(function()
                char:SetAttribute("Emote", a ~= "" and a or nil)
            end)
        end
        if broadcastMyState then
            task.defer(broadcastMyState, true)
        end
    end
    return origNetFire(topic, a, b, ...)
end

-- Hook SetTag:FireServer via __namecall so NameColor, Title, and Profile Pose equip locally even without server ownership
local SetTagRemote = Boxing:FindFirstChild("SetTag")
local tagAttrMap = {
    nameColor = "NameColor",
    title = "Title",
    pose = "Pose",
}

if hookmetamethod and getnamecallmethod and SetTagRemote then
    pcall(function()
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if self == SetTagRemote and (method == "FireServer" or method == "fireServer") then
                local kind, tagVal = ...
                local attrName = tagAttrMap[tostring(kind)]
                if attrName and typeof(tagVal) == "string" then
                    customTags[attrName] = tagVal
                    saveCurrentPreset()
                    task.defer(function()
                        updatingAttr = true
                        pcall(function()
                            LocalPlayer:SetAttribute(attrName, tagVal)
                        end)
                        updatingAttr = false
                        if broadcastMyState then
                            broadcastMyState(false)
                        end
                    end)
                end
            end
            return oldNamecall(self, ...)
        end)
    end)
end

-- ============================================================================
-- 4. LIVE CUSTOM KO EFFECTS (KOFX) & INTRO EMOTE ENGINE IN FIGHTS
-- ============================================================================

local activeKoFxList = {}
local koEffectsFolder = nil
local savedExposure = nil
local Lighting = game:GetService("Lighting")

local function getKoEffectsFolder()
    if not (koEffectsFolder and koEffectsFolder.Parent) then
        koEffectsFolder = workspace:FindFirstChild("KoEffects")
        if not koEffectsFolder then
            koEffectsFolder = Instance.new("Folder")
            koEffectsFolder.Name = "KoEffects"
            koEffectsFolder.Parent = workspace
        end
    end
    return koEffectsFolder
end

local function triggerClientKoFx(victimModel, kofxId)
    if typeof(victimModel) ~= "Instance" or not victimModel:IsDescendantOf(workspace) then
        return
    end
    if typeof(kofxId) ~= "string" or kofxId == "" then
        return
    end

    -- Avoid duplicate trigger on same victim within 3 seconds
    local now = os.clock()
    if victimModel:GetAttribute("__ClientKoFxAt") and (now - victimModel:GetAttribute("__ClientKoFxAt")) < 3 then
        return
    end
    victimModel:SetAttribute("__ClientKoFxAt", now)

    local serverNow = workspace:GetServerTimeNow()
    local folder = getKoEffectsFolder()

    local part = Instance.new("Part")
    part.Name = "KoFxSound"
    part.Anchored = true
    part.CanCollide = false
    part.CanQuery = false
    part.CanTouch = false
    part.Transparency = 1
    part.Size = Vector3.new(0.2, 0.2, 0.2)
    part.CFrame = CFrame.new()
    part.Parent = folder

    local attach = Instance.new("Attachment")
    attach.Parent = part
    local pelvis = victimModel:FindFirstChild("Pelvis")
    attach.WorldPosition = pelvis and pelvis.Position or Vector3.new(0, 0, 0)

    local entry = {
        model = victimModel,
        id = kofxId,
        at = serverNow,
        spot = attach,
        anchor = part,
        sounds = {},
        shakes = {},
    }

    local ctx = {
        fake = false,
        world = true,
        model = victimModel,
        id = kofxId,
        parent = folder,
        data = {},
    }

    function ctx.sound(soundName, delaySec, vol, speed, looped)
        local soundsFolder = Boxing:FindFirstChild("Sounds")
        local template = soundsFolder and soundsFolder:FindFirstChild(soundName)
        if not template or template.SoundId == "" then
            return nil
        end
        local snd = template:Clone()
        snd.Volume = (vol or 1) * (Settings.get("effects") or 1)
        snd.PlaybackSpeed = speed or 1
        snd.Looped = looped == true
        snd.RollOffMode = Enum.RollOffMode.InverseTapered
        snd.RollOffMinDistance = 90
        snd.RollOffMaxDistance = 900
        snd.Parent = entry.spot

        local function playNow()
            if snd.Parent then
                entry.spot.WorldPosition = (entry.fx and entry.fx.focus and entry.fx.focus()) or entry.spot.WorldPosition
                snd:Play()
                if not snd.Looped then
                    snd.Ended:Once(function()
                        pcall(function() snd:Destroy() end)
                    end)
                    task.delay(12, function()
                        if snd.Parent then
                            pcall(function() snd:Destroy() end)
                        end
                    end)
                end
            end
        end

        local waitTime = (delaySec or 0) - (workspace:GetServerTimeNow() - entry.at)
        if waitTime > 0.01 then
            task.delay(waitTime, playNow)
        else
            playNow()
        end
        table.insert(entry.sounds, snd)
        return snd
    end

    function ctx.shake(amp, whenSec)
        table.insert(entry.shakes, { amp, whenSec })
    end

    local okStart, fxObj = pcall(KoFx.start, ctx)
    if okStart and fxObj then
        entry.fx = fxObj
        table.insert(activeKoFxList, entry)
    else
        part:Destroy()
    end
end

-- Step any client-spawned custom KOFX on RenderStepped
trackConn(RunService.RenderStepped:Connect(function(dt)
    if #activeKoFxList == 0 then
        return
    end
    local serverNow = workspace:GetServerTimeNow()
    for i = #activeKoFxList, 1, -1 do
        local item = activeKoFxList[i]
        local elapsed = serverNow - item.at
        local duration = (KoFx.TIME and KoFx.TIME[item.id]) or 4
        if elapsed > duration + 0.3 or not item.model:IsDescendantOf(workspace) then
            if item.fx and item.fx.destroy then
                pcall(item.fx.destroy)
            end
            for _, s in ipairs(item.sounds) do
                pcall(function() s:Destroy() end)
            end
            pcall(function() item.anchor:Destroy() end)
            table.remove(activeKoFxList, i)
        elseif elapsed >= 0 and item.fx and item.fx.step then
            pcall(item.fx.step, elapsed, dt)
            if item.fx.focus then
                local okF, pos = pcall(item.fx.focus)
                if okF and typeof(pos) == "Vector3" then
                    item.spot.WorldPosition = pos
                end
            end
        end
    end
end))

-- Watch fighters in our ring (and peer rings!) so custom KOFX & KO Sounds play for both us and other script users!
local watchedFighters = setmetatable({}, { __mode = "k" })

local function findRingAttacker(victimFighter)
    local ring = victimFighter and (victimFighter:GetAttribute("Ring") or "") or ""
    if ring == "" then
        return nil
    end
    local victimTeam = victimFighter:GetAttribute("Team")
    local folder = workspace:FindFirstChild("Fighters")
    if not folder then
        return nil
    end
    for _, f in ipairs(folder:GetChildren()) do
        if f ~= victimFighter and f:GetAttribute("Ring") == ring and not f:GetAttribute("Bench") then
            if victimTeam == nil or f:GetAttribute("Team") ~= victimTeam then
                return f
            end
        end
    end
    return nil
end

local function hookFighterModel(fighter)
    if not fighter or watchedFighters[fighter] then
        return
    end
    watchedFighters[fighter] = true

    if fighter == LocalPlayer.Character then
        applyCharacterCosmetics(fighter)
    else
        local plr = Players:GetPlayerFromCharacter(fighter)
        if plr then
            local pState = peerStates[tostring(plr.UserId)]
            if pState then
                applyPeerCosmetics(plr, pState)
            end
        end
    end

    local function checkFighterKO()
        local isDown = fighter:GetAttribute("Down") == true
        local headHp = fighter:GetAttribute("Head") or 100
        local koClock = fighter:GetAttribute("KoClock")
        if not (isDown and (headHp <= 0 or (koClock and os.clock() - koClock < 1.5))) then
            return
        end

        local attackerModel = findRingAttacker(fighter)
        if not attackerModel then
            return
        end

        local kofxId = nil
        if attackerModel == LocalPlayer.Character then
            kofxId = customLook and customLook.kofx
        else
            local attackerPlr = Players:GetPlayerFromCharacter(attackerModel)
            local pState = attackerPlr and peerStates[tostring(attackerPlr.UserId)]
            if pState and typeof(pState.look) == "table" then
                kofxId = pState.look.kofx
            end
            if (not kofxId or kofxId == "") then
                kofxId = attackerModel:GetAttribute("KoFx")
            end
        end

        if typeof(kofxId) == "string" and kofxId ~= "" then
            -- Wait a tiny moment to see if the server already spawned KoFxPlaying
            task.delay(0.08, function()
                if not fighter:GetAttribute("KoFxPlaying") then
                    triggerClientKoFx(fighter, kofxId)
                end
            end)
        end
    end

    trackConn(fighter:GetAttributeChangedSignal("Down"):Connect(checkFighterKO))
    trackConn(fighter:GetAttributeChangedSignal("KoClock"):Connect(checkFighterKO))
    trackConn(fighter:GetAttributeChangedSignal("IntroAt"):Connect(function()
        local introAt = fighter:GetAttribute("IntroAt")
        if typeof(introAt) ~= "number" then
            return
        end
        if fighter == LocalPlayer.Character then
            task.defer(applyCharacterCosmetics, fighter)
        else
            local plr = Players:GetPlayerFromCharacter(fighter)
            local pState = plr and peerStates[tostring(plr.UserId)]
            if plr and pState then
                task.defer(applyPeerCosmetics, plr, pState)
            end
        end
    end))
    trackConn(fighter:GetAttributeChangedSignal("Ring"):Connect(function()
        if fighter == LocalPlayer.Character then
            task.defer(applyCharacterCosmetics, fighter)
            task.delay(0.25, applyCharacterCosmetics, fighter)
        else
            local plr = Players:GetPlayerFromCharacter(fighter)
            local pState = plr and peerStates[tostring(plr.UserId)]
            if plr and pState then
                task.defer(applyPeerCosmetics, plr, pState)
                task.delay(0.25, applyPeerCosmetics, plr, pState)
            end
        end
    end))
end

local FightersFolder = workspace:FindFirstChild("Fighters")
if FightersFolder then
    for _, child in ipairs(FightersFolder:GetChildren()) do
        hookFighterModel(child)
    end
    trackConn(FightersFolder.ChildAdded:Connect(function(child)
        task.defer(hookFighterModel, child)
    end))
end

trackConn(LocalPlayer:GetPropertyChangedSignal("Character"):Connect(function()
    local char = LocalPlayer.Character
    if char then
        hookFighterModel(char)
        task.defer(applyCharacterCosmetics, char)
        task.delay(0.2, applyCharacterCosmetics, char)
        task.delay(0.6, applyCharacterCosmetics, char)
    end
end))

-- ============================================================================
-- 4B. REAL-TIME P2P COSMETIC SYNC ENGINE (BETWEEN SCRIPT USERS IN SAME SERVER)
-- ============================================================================

local syncRunning = true
local httpRequest = (typeof(request) == "function" and request)
    or (typeof(http_request) == "function" and http_request)
    or (typeof(syn) == "table" and typeof(syn.request) == "function" and syn.request)
    or (typeof(http) == "table" and typeof(http.request) == "function" and http.request)
    or (typeof(fluxus) == "table" and typeof(fluxus.request) == "function" and fluxus.request)

local rawJobId = tostring(game.JobId or "studio"):gsub("[^%w]", ""):lower()
if rawJobId == "" then
    rawJobId = "place" .. tostring(game.PlaceId)
end
local SYNC_TOPIC = "ydx_bx2_" .. rawJobId:sub(1, 24)
local SYNC_POST_URL = "https://ntfy.sh/" .. SYNC_TOPIC

local lastSentSig = ""
local lastSendTime = 0
local lastPollUnix = 0

local function buildMyPayload()
    local char = LocalPlayer.Character
    local liveEmote = (char and char:GetAttribute("Emote")) or currentEmote or ""
    return {
        uid = LocalPlayer.UserId,
        name = LocalPlayer.Name,
        look = customLook,
        tags = customTags,
        emote = tostring(liveEmote),
    }
end

broadcastMyState = function(force)
    if not syncRunning or not httpRequest then
        return
    end
    local payloadTbl = buildMyPayload()
    local okEnc, encoded = pcall(HttpService.JSONEncode, HttpService, payloadTbl)
    if not okEnc or typeof(encoded) ~= "string" then
        return
    end
    local now = os.clock()
    if not force and encoded == lastSentSig and (now - lastSendTime) < 18 then
        return
    end
    if not force and (now - lastSendTime) < 0.35 then
        return
    end
    lastSentSig = encoded
    lastSendTime = now
    task.spawn(function()
        pcall(httpRequest, {
            Url = SYNC_POST_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "text/plain",
                ["Title"] = "ydx-sync",
            },
            Body = encoded,
        })
    end)
end

local function handleIncomingPeerPacket(msgJson)
    if typeof(msgJson) ~= "string" or msgJson == "" then
        return
    end
    local ok, data = pcall(HttpService.JSONDecode, HttpService, msgJson)
    if not ok or typeof(data) ~= "table" then
        return
    end
    local uidNum = tonumber(data.uid)
    if not uidNum or uidNum == LocalPlayer.UserId then
        return
    end
    local uidKey = tostring(uidNum)
    local cleanedLook = typeof(data.look) == "table" and cloneLook(data.look) or Looks.clean({})
    local cleanedLookJson = HttpService:JSONEncode(cleanedLook)
    local cleanedTags = {
        NameColor = (typeof(data.tags) == "table" and typeof(data.tags.NameColor) == "string") and data.tags.NameColor or "",
        Title = (typeof(data.tags) == "table" and typeof(data.tags.Title) == "string") and data.tags.Title or "",
        Pose = (typeof(data.tags) == "table" and typeof(data.tags.Pose) == "string") and data.tags.Pose or "",
    }
    local state = {
        uid = uidNum,
        look = cleanedLook,
        lookJson = cleanedLookJson,
        tags = cleanedTags,
        emote = typeof(data.emote) == "string" and data.emote or "",
        ts = os.clock(),
    }
    peerStates[uidKey] = state

    local plr = Players:GetPlayerByUserId(uidNum)
    if plr then
        applyPeerCosmetics(plr, state)
    end
end

local function pollPeersOnce()
    if not syncRunning then
        return
    end
    local sinceParam = (lastPollUnix > 0) and tostring(lastPollUnix) or "25m"
    local pollUrl = SYNC_POST_URL .. "/json?poll=1&since=" .. sinceParam
    local body = nil

    if httpRequest then
        local okReq, res = pcall(httpRequest, {
            Url = pollUrl,
            Method = "GET",
        })
        if okReq and typeof(res) == "table" and typeof(res.Body) == "string" then
            body = res.Body
        end
    end
    if not body then
        local okGet, resGet = pcall(game.HttpGet, game, pollUrl)
        if okGet and typeof(resGet) == "string" then
            body = resGet
        end
    end
    if typeof(body) ~= "string" or body == "" then
        return
    end

    for line in body:gmatch("[^\r\n]+") do
        local okLine, env = pcall(HttpService.JSONDecode, HttpService, line)
        if okLine and typeof(env) == "table" then
            if typeof(env.time) == "number" and env.time >= lastPollUnix then
                lastPollUnix = env.time
            end
            if env.event == "message" and typeof(env.message) == "string" then
                handleIncomingPeerPacket(env.message)
            end
        end
    end
end

-- Hook existing and newly joining players so when a peer joins, we broadcast our state and apply theirs
local function hookPeerPlayer(plr)
    if not plr or plr == LocalPlayer then
        return
    end
    local uidKey = tostring(plr.UserId)
    trackConn(plr.CharacterAdded:Connect(function(char)
        task.defer(hookFighterModel, char)
        local pState = peerStates[uidKey]
        if pState then
            task.defer(applyPeerCosmetics, plr, pState)
            task.delay(0.25, applyPeerCosmetics, plr, pState)
            task.delay(0.7, applyPeerCosmetics, plr, pState)
        end
    end))
    for _, attrName in ipairs({ "Look", "NameColor", "Title", "Pose" }) do
        trackConn(plr:GetAttributeChangedSignal(attrName):Connect(function()
            local pState = peerStates[uidKey]
            if pState then
                task.defer(applyPeerCosmetics, plr, pState)
            end
        end))
    end
    if peerStates[uidKey] then
        task.defer(applyPeerCosmetics, plr, peerStates[uidKey])
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    hookPeerPlayer(plr)
end
trackConn(Players.PlayerAdded:Connect(function(plr)
    hookPeerPlayer(plr)
    -- Re-broadcast our state so the newly joined friend immediately receives our cosmetics
    task.delay(2, function()
        if broadcastMyState then
            broadcastMyState(true)
        end
    end)
end))

-- Start background P2P sync loop
task.spawn(function()
    broadcastMyState(true)
    task.wait(0.35)
    pollPeersOnce()
    while syncRunning do
        task.wait(1.0)
        if not syncRunning then
            break
        end
        pollPeersOnce()
        -- Heartbeat re-broadcast every ~18 seconds in case a friend just executed the script
        if os.clock() - lastSendTime > 18 then
            broadcastMyState(true)
        end
    end
end)

-- ============================================================================
-- 4C. LIVE FIGHT INTRO EMOTE, VICTORY ENDPOSE & REPLAY PUNCH TRAILS ENGINE
-- ============================================================================
-- 1) FightIntro.emote() in the game only checks v35.model == LocalPlayer.Character,
--    and the server rejects Net.fire("emote", ...) for unowned emotes, so your friend's
--    client never sees your Character:GetAttribute("Emote") set during Fight Intro or Victory Pose!
-- 2) During KnockoutReplay (LocalPlayer:GetAttribute("Replaying") == true), replay fighter parts
--    are Anchored and moved via .CFrame in slow-motion, so AssemblyLinearVelocity is (0, 0, 0)
--    and PlayerScripts.GloveTrails keeps all punch trails disabled.

local activeIntroEmotes = setmetatable({}, { __mode = "k" })
local activeEndPoseEmotes = setmetatable({}, { __mode = "k" })
local replayGloveTracker = setmetatable({}, { __mode = "k" })
local replayDressedModels = setmetatable({}, { __mode = "k" })
local lastReplayScanAt = 0

local function resolveFighterLookAndPose(fighter)
    if not fighter then
        return nil, nil
    end
    if fighter == LocalPlayer.Character then
        local poseId = (customTags and customTags.Pose ~= "" and customTags.Pose) or LocalPlayer:GetAttribute("Pose")
        return customLook, poseId
    end
    local plr = Players:GetPlayerFromCharacter(fighter)
    if not plr then
        local uidAttr = fighter:GetAttribute("__YDX_OwnerUid")
        if typeof(uidAttr) == "number" then
            plr = Players:GetPlayerByUserId(uidAttr)
        end
    end
    if plr then
        if plr == LocalPlayer then
            local poseId = (customTags and customTags.Pose ~= "" and customTags.Pose) or LocalPlayer:GetAttribute("Pose")
            return customLook, poseId
        end
        local pState = peerStates[tostring(plr.UserId)]
        if pState then
            local poseId = (pState.tags and pState.tags.Pose ~= "" and pState.tags.Pose) or plr:GetAttribute("Pose")
            return pState.look, poseId
        end
        local rawLook = plr:GetAttribute("Look")
        if typeof(rawLook) == "string" and rawLook ~= "" then
            local okL, decL = pcall(HttpService.JSONDecode, HttpService, rawLook)
            if okL and typeof(decL) == "table" then
                return decL, plr:GetAttribute("Pose")
            end
        end
    end
    return nil, nil
end

local function matchReplayModelLook(replayModel)
    -- 1. Direct owner uid or trail attribute copied on clone
    local uidAttr = replayModel:GetAttribute("__YDX_OwnerUid")
    if typeof(uidAttr) == "number" then
        if uidAttr == LocalPlayer.UserId then
            return customLook
        end
        local pState = peerStates[tostring(uidAttr)]
        if pState and typeof(pState.look) == "table" then
            return pState.look
        end
    end
    local trailAttr = replayModel:GetAttribute("__YDX_TrailId")
    if typeof(trailAttr) == "string" and trailAttr ~= "" then
        return { trail = trailAttr }
    end

    -- 2. Match by model Name
    local mName = replayModel.Name
    if mName == LocalPlayer.Name or mName:find(LocalPlayer.Name, 1, true) then
        return customLook
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and (mName == plr.Name or mName:find(plr.Name, 1, true)) then
            local pState = peerStates[tostring(plr.UserId)]
            if pState and typeof(pState.look) == "table" then
                return pState.look
            end
        end
    end

    -- 3. Match by Glove + Trunks (Pelvis) + Skin (Head) colors against fighters in the same ring
    local rGlove = replayModel:FindFirstChild("LeftGlove") or replayModel:FindFirstChild("RightGlove")
    local rPelvis = replayModel:FindFirstChild("Pelvis")
    local rHead = replayModel:FindFirstChild("Head")
    local fFolder = workspace:FindFirstChild("Fighters")
    if fFolder and rGlove and rPelvis then
        local bestFighter = nil
        local bestScore = -1
        for _, f in ipairs(fFolder:GetChildren()) do
            local fGlove = f:FindFirstChild("LeftGlove") or f:FindFirstChild("RightGlove")
            local fPelvis = f:FindFirstChild("Pelvis")
            local fHead = f:FindFirstChild("Head")
            if fGlove and fPelvis then
                local score = 0
                if (fGlove.Color.R - rGlove.Color.R)^2 + (fGlove.Color.G - rGlove.Color.G)^2 + (fGlove.Color.B - rGlove.Color.B)^2 < 0.002 then
                    score = score + 3
                end
                if (fPelvis.Color.R - rPelvis.Color.R)^2 + (fPelvis.Color.G - rPelvis.Color.G)^2 + (fPelvis.Color.B - rPelvis.Color.B)^2 < 0.002 then
                    score = score + 2
                end
                if rHead and fHead and ((fHead.Color.R - rHead.Color.R)^2 + (fHead.Color.G - rHead.Color.G)^2 + (fHead.Color.B - rHead.Color.B)^2 < 0.002) then
                    score = score + 1
                end
                if score > bestScore then
                    bestScore = score
                    bestFighter = f
                end
            end
        end
        if bestFighter and bestScore >= 3 then
            local lookTbl = resolveFighterLookAndPose(bestFighter)
            if lookTbl then
                return lookTbl
            end
        end
    end

    return customLook
end

local function dressReplayRigIfNeeded(m)
    if not m or replayDressedModels[m] or not m:IsA("Model") then
        return
    end
    local lGlove = m:FindFirstChild("LeftGlove")
    local rGlove = m:FindFirstChild("RightGlove")
    local pelvis = m:FindFirstChild("Pelvis")
    if not (lGlove and rGlove and pelvis) then
        return
    end
    replayDressedModels[m] = true

    -- Clear Down attribute on replay clone so GloveTrails never blocks trail rendering
    if m:GetAttribute("Down") == true then
        pcall(function()
            m:SetAttribute("Down", false)
        end)
    end

    local lookTbl = matchReplayModelLook(m)
    if typeof(lookTbl) == "table" and typeof(lookTbl.trail) == "string" and lookTbl.trail ~= "" then
        pcall(function()
            local colors = Looks.colors(lookTbl)
            if colors and colors.trail then
                if not lGlove:FindFirstChild("GloveTrail") or not rGlove:FindFirstChild("GloveTrail") then
                    Boxer.dressTrail(m, colors.trail)
                end
            end
        end)
    end

    for _, g in ipairs({ lGlove, rGlove }) do
        local gt = g:FindFirstChild("GloveTrail")
        if gt and gt:IsA("Trail") and not CollectionService:HasTag(gt, "GloveTrail") then
            pcall(function()
                CollectionService:AddTag(gt, "GloveTrail")
            end)
        end
    end
end

local function scanAndStepReplayTrails(now)
    local isReplaying = LocalPlayer:GetAttribute("Replaying") == true
    if not isReplaying then
        return
    end

    if now - lastReplayScanAt >= 0.12 then
        lastReplayScanAt = now
        local fFolder = workspace:FindFirstChild("Fighters")
        local oFolder = workspace:FindFirstChild("OpponentBodies")
        local gymFolder = workspace:FindFirstChild("Gym")
        local cam = workspace.CurrentCamera

        for _, root in ipairs({ workspace, cam }) do
            if root then
                for _, child in ipairs(root:GetChildren()) do
                    if child ~= fFolder and child ~= oFolder and child ~= gymFolder then
                        if child:IsA("Model") then
                            dressReplayRigIfNeeded(child)
                        elseif child:IsA("Folder") or child:IsA("WorldModel") then
                            for _, sub in ipairs(child:GetChildren()) do
                                if sub:IsA("Model") then
                                    dressReplayRigIfNeeded(sub)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- Drive CFrame-delta relative velocity on all visible GloveTrails during Replay
    for _, trail in ipairs(CollectionService:GetTagged("GloveTrail")) do
        local glove = trail.Parent
        local model = glove and glove.Parent
        local pelvis = model and model:FindFirstChild("Pelvis")
        if glove and model and pelvis and glove:IsA("BasePart") and pelvis:IsA("BasePart") then
            local gPart = (Boxer and typeof(Boxer.seen) == "function" and Boxer.seen(glove)) or glove
            local pPart = (Boxer and typeof(Boxer.seen) == "function" and Boxer.seen(pelvis)) or pelvis
            if gPart.LocalTransparencyModifier < 0.95 then
                local relPos = gPart.Position - pPart.Position
                local st = replayGloveTracker[trail]
                if not st then
                    st = {
                        relPos = relPos,
                        t = now,
                        activeUntil = 0,
                    }
                    replayGloveTracker[trail] = st
                else
                    local dt = now - st.t
                    if dt >= 0.004 then
                        local delta = relPos - st.relPos
                        local relSpeed = delta.Magnitude / math.clamp(dt, 0.004, 0.25)
                        st.relPos = relPos
                        st.t = now
                        -- In slow-motion KO Replay (~0.25x-0.4x speed), a punch swing exceeds ~5.2 studs/s relative to Pelvis
                        if relSpeed > (trail.Enabled and 3.8 or 5.5) then
                            st.activeUntil = now + 0.22
                            local dir = delta.Magnitude > 0.001 and delta.Unit or gPart.CFrame.LookVector
                            pcall(function()
                                gPart.AssemblyLinearVelocity = pPart.AssemblyLinearVelocity + dir * 48
                            end)
                        end
                    end
                end

                local active = now < (st.activeUntil or 0)
                if active then
                    if model:GetAttribute("Down") == true then
                        pcall(function()
                            model:SetAttribute("Down", false)
                        end)
                    end
                    if not trail.Enabled then
                        trail.Enabled = true
                    end
                    local sparks = glove:FindFirstChild("TrailSparks")
                    if sparks and sparks:IsA("ParticleEmitter") and not sparks.Enabled then
                        sparks.Enabled = true
                    end
                    if TrailExtras and typeof(TrailExtras.step) == "function" then
                        pcall(TrailExtras.step, glove, true, false)
                    end
                end
            end
        end
    end
end

trackConn(RunService.RenderStepped:Connect(function()
    local now = os.clock()
    scanAndStepReplayTrails(now)
end))

trackConn(RunService.Heartbeat:Connect(function()
    local now = os.clock()
    scanAndStepReplayTrails(now)

    -- 1. Enforce FightIntro Emote attribute on BOTH LocalPlayer and Peer fighters in real-time (0ms latency)
    local introNow = nil
    if FightIntro and typeof(FightIntro.now) == "function" then
        local okI, resI = pcall(FightIntro.now)
        if okI and typeof(resI) == "table" then
            introNow = resI
        end
    end

    local activeIntroModel = nil
    local emoteEnd = (FightIntro and FightIntro.EMOTE_END) or 0.9
    if introNow and typeof(introNow.model) == "Instance" and (introNow.t or 1) < emoteEnd then
        local fModel = introNow.model
        local entId = (Entrances and typeof(Entrances.of) == "function" and Entrances.of(fModel)) or fModel:GetAttribute("Entrance")
        local revealTime = (entId and Entrances and Entrances.REVEAL and Entrances.REVEAL[entId]) or 0
        local isRevealed = (not entId or entId == "") or ((introNow.secs or 0) >= (revealTime + 0.15))
        if isRevealed then
            local lookTbl = resolveFighterLookAndPose(fModel)
            local introEmote = (typeof(lookTbl) == "table" and lookTbl.intro) or fModel:GetAttribute("IntroEmote")
            if typeof(introEmote) == "string" and introEmote ~= "" then
                activeIntroModel = fModel
                activeIntroEmotes[fModel] = introEmote
                if fModel:GetAttribute("Emote") ~= introEmote then
                    pcall(function()
                        fModel:SetAttribute("Emote", introEmote)
                    end)
                end
            end
        end
    end

    for fModel, introEm in pairs(activeIntroEmotes) do
        if fModel ~= activeIntroModel then
            activeIntroEmotes[fModel] = nil
            if fModel and fModel.Parent and fModel:GetAttribute("Emote") == introEm then
                pcall(function()
                    fModel:SetAttribute("Emote", nil)
                end)
            end
        end
    end

    -- 2. Enforce Victory EndPose & Live Emote Wheel prop attributes on all fighters in workspace.Fighters
    local fFolder = workspace:FindFirstChild("Fighters")
    if fFolder then
        for _, fModel in ipairs(fFolder:GetChildren()) do
            local endPose = fModel:GetAttribute("EndPose")
            if typeof(endPose) == "string" and endPose ~= "" then
                local _, customPose = resolveFighterLookAndPose(fModel)
                if typeof(customPose) == "string" and customPose ~= "" and endPose ~= customPose then
                    endPose = customPose
                    pcall(function()
                        fModel:SetAttribute("EndPose", customPose)
                    end)
                end
                if Poses.PROPS and Poses.PROPS[endPose] then
                    activeEndPoseEmotes[fModel] = endPose
                    if fModel:GetAttribute("Emote") ~= endPose then
                        pcall(function()
                            fModel:SetAttribute("Emote", endPose)
                        end)
                    end
                end
            elseif activeEndPoseEmotes[fModel] then
                local prevEnd = activeEndPoseEmotes[fModel]
                activeEndPoseEmotes[fModel] = nil
                if fModel:GetAttribute("Emote") == prevEnd then
                    pcall(function()
                        fModel:SetAttribute("Emote", nil)
                    end)
                end
            end

            -- Prevent server from wiping LocalPlayer's active Emote Wheel emote if unowned on server
            if fModel == LocalPlayer.Character and fModel ~= activeIntroModel and not activeEndPoseEmotes[fModel] then
                local wheelPlaying = EmoteController and typeof(EmoteController.playing) == "function" and EmoteController.playing()
                if typeof(wheelPlaying) == "string" and wheelPlaying ~= "" then
                    if fModel:GetAttribute("Emote") ~= wheelPlaying then
                        pcall(function()
                            fModel:SetAttribute("Emote", wheelPlaying)
                        end)
                    end
                end
            end

            -- Keep peer live emote synced while not in intro/endpose
            if fModel ~= LocalPlayer.Character and fModel ~= activeIntroModel and not activeEndPoseEmotes[fModel] then
                local plr = Players:GetPlayerFromCharacter(fModel)
                local pState = plr and peerStates[tostring(plr.UserId)]
                if pState and typeof(pState.emote) == "string" then
                    local wantEmote = pState.emote ~= "" and pState.emote or nil
                    if fModel:GetAttribute("Emote") ~= wantEmote then
                        pcall(function()
                            fModel:SetAttribute("Emote", wantEmote)
                        end)
                    end
                end
            end
        end
    end
end))

-- Periodic lightweight sync (every 0.5s) to keep local & peer character cosmetics, KoSound, and attributes intact
local lastSync = 0
trackConn(RunService.Heartbeat:Connect(function()
    local now = os.clock()
    if now - lastSync < 0.5 then
        return
    end
    lastSync = now
    enforceUnlockAttributes()
    local char = LocalPlayer.Character
    if char and customLook then
        -- Check if trail or hair got stripped by server respawn/round reset
        local leftGlove = char:FindFirstChild("LeftGlove")
        if customLook.trail and customLook.trail ~= "" and leftGlove and not leftGlove:FindFirstChild("GloveTrail") then
            applyCharacterCosmetics(char)
        elseif customLook.hair and customLook.hair ~= "" and customLook.hair ~= "classic" and not char:FindFirstChild("HairBit1") then
            applyCharacterCosmetics(char)
        end
    end
    -- Also keep synced peers' trails/hairs/attributes intact after round resets
    for uidKey, pState in pairs(peerStates) do
        local plr = Players:GetPlayerByUserId(tonumber(uidKey) or 0)
        if plr and plr ~= LocalPlayer then
            local pChar = plr.Character
            local pLook = pState.look
            if pChar and typeof(pLook) == "table" then
                local pGlove = pChar:FindFirstChild("LeftGlove")
                if pLook.trail and pLook.trail ~= "" and pGlove and not pGlove:FindFirstChild("GloveTrail") then
                    applyPeerCosmetics(plr, pState)
                elseif pLook.hair and pLook.hair ~= "" and pLook.hair ~= "classic" and not pChar:FindFirstChild("HairBit1") then
                    applyPeerCosmetics(plr, pState)
                elseif pState.lookJson and plr:GetAttribute("Look") ~= pState.lookJson then
                    applyPeerCosmetics(plr, pState)
                end
            end
        end
    end
end))

-- ============================================================================
-- 5. FORCE REFRESH CHARACTER MENU & EMOTE WHEEL UI RIGHT NOW
-- ============================================================================

pcall(function()
    -- Toggle Pass_vip false -> true to trigger CharacterMenu & PlayerCards attribute listeners immediately
    updatingAttr = true
    LocalPlayer:SetAttribute("Pass_vip", false)
    LocalPlayer:SetAttribute("Pass_vip", true)
    updatingAttr = false
end)

_G.__BoxingUnlockAllCleanup = function()
    syncRunning = false
    for _, c in ipairs(connections) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(connections)
    if origNetFire then
        Net.fire = origNetFire
    end
    if origShopHas then
        ShopItems.has = origShopHas
    end
    if origAddProp then
        Poses.addProp = origAddProp
    end
    if origPlaceProp then
        Poses.placeProp = origPlaceProp
    end
end

print(string.format(
    "[BoxingUnlockAll v2.1] UNLOCKED 100%% + P2P SYNC ACTIVE (%s)! Trails=%d | Items=%d | Titles=%d | Passes=%d | Story=%d",
    SYNC_TOPIC,
    #allTrailIds,
    #allItemIds,
    #allTitleIds,
    #allPassIds,
    maxStoryAt - 1
))
