-- YDX Script Vault - Universal Loader (100% ASCII)
-- Detects current game PlaceId (including all match/tournament/sub-places) and Universe GameId automatically!
-- Also hooks queue_on_teleport so when a game teleports you from Lobby to a Match sub-place, the script reloads automatically!
-- Usage:
--   getgenv().YDX_SCRIPT = "volleyball-unlock" -- optional: force a specific script id
--   loadstring(game:HttpGet("https://ydxvxdinc-art.github.io/ydx-script-vault/loader.lua"))()

local BASE_URL = (getgenv and getgenv().YDX_BASE_URL) or "https://ydxvxdinc-art.github.io/ydx-script-vault"
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
    ["towers-unlock"]     = "scripts/towers_unlock_all.lua",
    ["pingapong-unlock"]  = "scripts/pingapong_unlock_all.lua",
}

local PLACE_TO_SCRIPT = {
    -- Subway Surfing
    [110677803091411] = "subway-livesplit",  -- Subway Surfing

    -- Chess Duels
    [89083628291452]  = "chessduels-unlock", -- Chess Duels

    -- Turbo Soccer
    [101880234193261] = "wolvot-3d",         -- Turbo Soccer [BETA]
    [122784052290072] = "wolvot-3d",         -- LAB SERVER
    [134237737907091] = "wolvot-3d",         -- TEST SERVER

    -- Car Soccer / Sideswipe
    [135911523189225] = "wolvot-2d",         -- Car Soccer
    [98614543820076]  = "wolvot-2d",         -- SOCCAR DUEL

    -- Prime Dash
    [74231131119820]  = "primedash-unlock",  -- [FPS UPDATE] Prime Dash
    [96664545014524]  = "primedash-unlock",  -- Partida Torneio 3v3
    [98644144049591]  = "primedash-unlock",  -- Partida Torneio 2v2
    [107035605132511] = "primedash-unlock",  -- Salas (grupo e AFK)
    [110577909469596] = "primedash-unlock",  -- Partida Torneio 4v4
    [114589577715213] = "primedash-unlock",  -- Partida Torneio 1v1

    -- Ragdoll Boxing 3D
    [96740842890477]  = "boxing-unlock",     -- [STYLES] Ragdoll Boxing 3D

    -- Huss Valley
    [107535308163741] = "hussvalley-unlock", -- Huss Valley

    -- Volleyball Legends (10 Official Sub-Places + Additional Match Servers)
    [73956553001240]  = "volleyball-unlock", -- [UPD] Volleyball Legends
    [74691681039273]  = "volleyball-unlock", -- Volleyball Legends: Starter
    [85395484560711]  = "volleyball-unlock", -- Volleyball Legends: Tutorial
    [86789627188240]  = "volleyball-unlock", -- Volleyball Legends: Idle
    [96802054849934]  = "volleyball-unlock", -- Volleyball Legends: Training
    [102580589030177] = "volleyball-unlock", -- Volleyball Legends: Intermediate
    [103521881639626] = "volleyball-unlock", -- Volleyball Legends: Hardcore
    [109684591839194] = "volleyball-unlock", -- Volleyball Legends: Classic Pro
    [117134837736236] = "volleyball-unlock", -- Volleyball Legends: Sandbox
    [134314141048307] = "volleyball-unlock", -- Volleyball Legends: Pro
    [74340544405190]  = "volleyball-unlock",
    [75040427940838]  = "volleyball-unlock",
    [79136731857959]  = "volleyball-unlock",
    [81895645060208]  = "volleyball-unlock",
    [86783053375709]  = "volleyball-unlock",
    [90380040747314]  = "volleyball-unlock",
    [94599491166169]  = "volleyball-unlock",
    [122069199001617] = "volleyball-unlock",
    [122273223414774] = "volleyball-unlock",
    [123319941977842] = "volleyball-unlock",
    [123612633203731] = "volleyball-unlock",
    [128017040519391] = "volleyball-unlock",
    [132469448336101] = "volleyball-unlock",

    -- Sidespin | 8 Ball Pool & Sinuca
    [99800377290157]  = "sidespin-unlock",   -- Sidespin | Realistic 3D Pool / Billiards

    -- Towers of Fortune
    [108114331578868] = "towers-unlock",     -- Towers of Fortune

    -- PING A PONG [UPD 1]
    [80454787540545]  = "pingapong-unlock",  -- PING A PONG [UPD 1]
    [101010704658437] = "pingapong-unlock",  -- AFK Lobby
    [108891632460750] = "pingapong-unlock",  -- PONG Dev
    [118630959216600] = "pingapong-unlock",  -- Map
}

-- Universe GameId fallback (detects any future sub-place created inside the same game universe!)
local GAME_TO_SCRIPT = {
    [8799094487]  = "subway-livesplit",  -- Subway Surfing Universe
    [10773277140] = "chessduels-unlock", -- Chess Duels Universe
    [10767012496] = "wolvot-3d",         -- Turbo Soccer Universe
    [10770924827] = "wolvot-2d",         -- Car Soccer / Sideswipe Universe
    [10773109486] = "primedash-unlock",  -- Prime Dash Universe
    [10770779724] = "boxing-unlock",     -- Ragdoll Boxing 3D Universe
    [10764627709] = "hussvalley-unlock", -- Huss Valley Universe
    [6931042565]  = "volleyball-unlock", -- Volleyball Legends Universe
    [10771094670] = "sidespin-unlock",   -- Sidespin 8 Ball Pool & Sinuca Universe
    [10773001670] = "towers-unlock",     -- Towers of Fortune Universe
    [10768996872] = "pingapong-unlock",  -- PING A PONG Universe
}

local forcedId = (getgenv and getgenv().YDX_SCRIPT) or _G.YDX_SCRIPT
local targetId = forcedId or PLACE_TO_SCRIPT[game.PlaceId] or GAME_TO_SCRIPT[game.GameId]

-- Fallback: Dynamically scan all sub-places of the current game via AssetService:GetGamePlacesAsync()
-- so even if the game added a brand-new sub-place ID that isn't in PLACE_TO_SCRIPT yet, it matches any sibling place in the same universe!
if not targetId then
    pcall(function()
        local AssetService = game:GetService("AssetService")
        local okPages, pages = pcall(function()
            return AssetService:GetGamePlacesAsync()
        end)
        if okPages and typeof(pages) == "Instance" and pages:IsA("Pages") then
            while not targetId do
                local okCur, curPage = pcall(function()
                    return pages:GetCurrentPage()
                end)
                if okCur and type(curPage) == "table" then
                    for _, place in pairs(curPage) do
                        local pid = tonumber(place.PlaceId)
                        if pid and PLACE_TO_SCRIPT[pid] then
                            targetId = PLACE_TO_SCRIPT[pid]
                            PLACE_TO_SCRIPT[game.PlaceId] = targetId
                            break
                        end
                    end
                end
                local okFin, isFin = pcall(function()
                    return pages.IsFinished
                end)
                if targetId or not okFin or isFin then break end
                local advanceOk = pcall(function()
                    pages:AdvanceToNextPageAsync()
                end)
                if not advanceOk then break end
                task.wait(0.05)
            end
        end
    end)
end

local relPath = targetId and SCRIPTS_BY_ID[targetId] or nil

if not relPath then
    warn("[YDX Loader] No script registered for PlaceId=" .. tostring(game.PlaceId) .. " GameId=" .. tostring(game.GameId))
    return
end

-- [YDX Execution Telemetry + Live Active Users Top Banner - Non-Duplicating]
-- Records the execution right here in the loader and sets the lock for `targetId` so the child script will NOT double-count!
do
    local env = (type(getgenv) == "function" and getgenv()) or _G
    env.__YDX_EXEC_LOCKS = env.__YDX_EXEC_LOCKS or {}
    local now = os.clock()
    if not env.__YDX_EXEC_LOCKS[targetId] or (now - env.__YDX_EXEC_LOCKS[targetId]) > 15 then
        env.__YDX_EXEC_LOCKS[targetId] = now
        task.spawn(function()
            local key = tostring(targetId):gsub("[^%w_%-]", "_")
            pcall(function() game:HttpGet("https://ntfy.sh/ydx_vault_telemetry_7c9e2a4b/publish?message=loader:" .. key) end)
            pcall(function() game:HttpGet("https://abacus.jasoncameron.dev/hit/ydx_script_vault/total_executions") end)
            pcall(function() game:HttpGet("https://abacus.jasoncameron.dev/hit/ydx_script_vault/loader_executions") end)
            pcall(function() game:HttpGet("https://abacus.jasoncameron.dev/hit/ydx_script_vault/" .. key) end)
        end)
    else
        env.__YDX_EXEC_LOCKS[targetId] = now
    end
end

-- [YDX Live Users Top Banner] Shows "{number} users using unlock all in this game" at the top of the screen
do
    local env = (type(getgenv) == "function" and getgenv()) or _G
    local function showYdxUsersBanner(scriptKey)
        local now = os.clock()
        if env.__YDX_BANNER_SHOWN_AT and (now - env.__YDX_BANNER_SHOWN_AT) < 5 then
            return
        end
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
            pcall(function()
                if type(gethui) == "function" then parentGui = gethui() end
            end)
            if not parentGui then
                pcall(function()
                    if CoreGui:FindFirstChild("RobloxGui") then parentGui = CoreGui end
                end)
            end
            if not parentGui and lp then
                parentGui = lp:WaitForChild("PlayerGui", 10)
            end
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

            -- Announce & count active users in the same game (PlaceId/JobId + game presence topic)
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

    local function startYdxUpdateWatcher(scriptKey)
        local sid = tostring(scriptKey or "unknown")
        local rPath = SCRIPTS_BY_ID[sid]
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

            local function showUpdateBanner()
                if env.__YDX_UPDATE_WATCH_GEN[sid] ~= myGen then return end
                if not parentGui then return end
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
                local function dismiss()
                    if dismissed then return end
                    dismissed = true
                    if not card or not card.Parent then return end
                    local outTw = TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                        Position = UDim2.new(0.5, 0, 0, -80)
                    })
                    outTw:Play()
                    outTw.Completed:Wait()
                    if sg and sg.Parent then
                        pcall(function() sg:Destroy() end)
                    end
                end
                closeBtn.MouseButton1Click:Connect(dismiss)

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
            local function fetchSigFrom(baseUrl)
                if not rPath then return nil end
                local cb = "?cb=" .. tostring(os.time()) .. "_" .. tostring(math.random(1000, 9999))
                local okR, body = pcall(function() return game:HttpGet(baseUrl .. rPath .. cb) end)
                if okR and type(body) == "string" and #body >= 64 then
                    return computeSig(body)
                end
                return nil
            end

            -- Share knownSigs across getgenv(), _G, and shared so stale CDN POP nodes never trigger false alerts
            local rootStore = (type(shared) == "table" and shared) or _G
            rootStore.__YDX_KNOWN_SIGS = rootStore.__YDX_KNOWN_SIGS or {}
            env.__YDX_KNOWN_SIGS = rootStore.__YDX_KNOWN_SIGS
            local knownSigs = rootStore.__YDX_KNOWN_SIGS[sid] or {}
            rootStore.__YDX_KNOWN_SIGS[sid] = knownSigs

            -- Record both GitHub Pages and GitHub Raw CDN signatures at startup so POP cache differences are ignored
            local initGhSig = fetchSigFrom(BASE_URL .. "/")
            local initRawSig = fetchSigFrom(rawBase)
            if initGhSig then knownSigs[initGhSig] = true end
            if initRawSig then knownSigs[initRawSig] = true end

            local candidateSig = nil
            local candidateHits = 0

            while env.__YDX_UPDATE_WATCH_GEN[sid] == myGen do
                task.wait(30)
                if env.__YDX_UPDATE_WATCH_GEN[sid] ~= myGen then break end

                local ghSig = fetchSigFrom(BASE_URL .. "/")
                local rawSig = fetchSigFrom(rawBase)

                -- Only trigger if BOTH endpoints (or 2 consecutive checks) return a genuinely brand-new signature never seen before
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

    env.__YDX_SHOW_USERS_BANNER = showYdxUsersBanner
    env.__YDX_START_UPDATE_WATCHER = startYdxUpdateWatcher
    showYdxUsersBanner(targetId)
    startYdxUpdateWatcher(targetId)
end

-- Auto-requeue loader on sub-place teleport (e.g. Lobby -> Match Server)
pcall(function()
    if _G.YDX_TELEPORT_HOOKED then return end
    _G.YDX_TELEPORT_HOOKED = true
    local qot = (type(queue_on_teleport) == "function" and queue_on_teleport)
        or (syn and type(syn.queue_on_teleport) == "function" and syn.queue_on_teleport)
        or (fluxus and type(fluxus.queue_on_teleport) == "function" and fluxus.queue_on_teleport)
    if type(qot) == "function" then
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer
        if lp then
            lp.OnTeleport:Connect(function(state)
                if not _G.YDX_TELEPORT_QUEUED then
                    _G.YDX_TELEPORT_QUEUED = true
                    pcall(qot, string.format('loadstring(game:HttpGet("%s/loader.lua"))()', BASE_URL))
                end
            end)
        end
    end
end)

local cbSuffix = "?cb=" .. tostring(os.time()) .. "_" .. tostring(math.random(1000, 9999))
local url = BASE_URL .. "/" .. relPath
print("[YDX Loader] Detected " .. tostring(targetId) .. " (PlaceId: " .. tostring(game.PlaceId) .. ") -> Fetching: " .. url)
local ok, src = pcall(function()
    return game:HttpGet(url .. cbSuffix)
end)
if not ok or type(src) ~= "string" or #src < 10 then
    ok, src = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/ydxvxdinc-art/ydx-script-vault/main/" .. relPath .. cbSuffix)
    end)
end

if not ok or type(src) ~= "string" or #src < 10 then
    warn("[YDX Loader] Failed to download script from: " .. url)
    return
end

-- Record the signature of the exact loaded source so the update watcher never flags the version already running
pcall(function()
    local clean = src:gsub("\r\n", "\n")
    local h = 2166136261
    local len = #clean
    local step = math.max(1, math.floor(len / 512))
    for i = 1, len, step do
        h = (h * 16777619 + string.byte(clean, i)) % 4294967296
    end
    local loadedSig = tostring(len) .. ":" .. tostring(h)
    local rootStore = (type(shared) == "table" and shared) or _G
    rootStore.__YDX_KNOWN_SIGS = rootStore.__YDX_KNOWN_SIGS or {}
    rootStore.__YDX_KNOWN_SIGS[targetId] = rootStore.__YDX_KNOWN_SIGS[targetId] or {}
    rootStore.__YDX_KNOWN_SIGS[targetId][loadedSig] = true
end)

local fn, err = loadstring(src)
if not fn then
    warn("[YDX Loader] Compile error: " .. tostring(err))
    return
end

return fn()
