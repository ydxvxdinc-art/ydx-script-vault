--[[
	Chess AI
	  - Partidas: motor proprio (alpha-beta + TT + null move + LMR + quiescence), joga sozinho na sua vez
	  - Puzzles: le a solucao do puzzle aberto, joga e avanca pro proximo
	  - GUI: interruptor, modos 1/3/10 min, relogios, barra de chance de vitoria
	Secoes: config > avaliacao > zobrist > busca > GUI > puzzles > loop principal
]]
-- Motor proprio: alpha-beta + PVS + TT (zobrist) + null move + LMR + killers/history + quiescence + eval tapered
-- [YDX Execution Telemetry - Non-Duplicating when loaded via Universal Loader]
do
    local env = (type(getgenv) == "function" and getgenv()) or _G
    env.__YDX_EXEC_LOCKS = env.__YDX_EXEC_LOCKS or {}
    local sid = "chess-ai"
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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayMove = ReplicatedStorage:WaitForChild("ChessRemotes"):WaitForChild("Action")
local Engine = require(ReplicatedStorage.Chess.Engine)

local TIME_LIMIT = 3
local MAX_DEPTH = 40

local MATE, INF = 100000, 1000000
local bxor = bit32.bxor
local abs = math.abs
local isAttacked, pseudoMoves = Engine.isAttacked, Engine.pseudoMoves
local makeMove, unmakeMove = Engine.makeMove, Engine.unmakeMove

local VAL = { 100, 320, 330, 500, 900, 0 }
local PH = { 0, 1, 1, 2, 4, 0 }

-- ============================================================ PST
local PM = {}
PM[1] = {
	0, 0, 0, 0, 0, 0, 0, 0,
	50, 50, 50, 50, 50, 50, 50, 50,
	10, 10, 20, 30, 30, 20, 10, 10,
	5, 5, 10, 25, 25, 10, 5, 5,
	0, 0, 0, 20, 20, 0, 0, 0,
	5, -5, -10, 0, 0, -10, -5, 5,
	5, 10, 10, -20, -20, 10, 10, 5,
	0, 0, 0, 0, 0, 0, 0, 0,
}
PM[2] = {
	-50, -40, -30, -30, -30, -30, -40, -50,
	-40, -20, 0, 0, 0, 0, -20, -40,
	-30, 0, 10, 15, 15, 10, 0, -30,
	-30, 5, 15, 20, 20, 15, 5, -30,
	-30, 0, 15, 20, 20, 15, 0, -30,
	-30, 5, 10, 15, 15, 10, 5, -30,
	-40, -20, 0, 5, 5, 0, -20, -40,
	-50, -40, -30, -30, -30, -30, -40, -50,
}
PM[3] = {
	-20, -10, -10, -10, -10, -10, -10, -20,
	-10, 0, 0, 0, 0, 0, 0, -10,
	-10, 0, 5, 10, 10, 5, 0, -10,
	-10, 5, 5, 10, 10, 5, 5, -10,
	-10, 0, 10, 10, 10, 10, 0, -10,
	-10, 10, 10, 10, 10, 10, 10, -10,
	-10, 5, 0, 0, 0, 0, 5, -10,
	-20, -10, -10, -10, -10, -10, -10, -20,
}
PM[4] = {
	0, 0, 0, 0, 0, 0, 0, 0,
	5, 10, 10, 10, 10, 10, 10, 5,
	-5, 0, 0, 0, 0, 0, 0, -5,
	-5, 0, 0, 0, 0, 0, 0, -5,
	-5, 0, 0, 0, 0, 0, 0, -5,
	-5, 0, 0, 0, 0, 0, 0, -5,
	-5, 0, 0, 0, 0, 0, 0, -5,
	0, 0, 0, 5, 5, 0, 0, 0,
}
PM[5] = {
	-20, -10, -10, -5, -5, -10, -10, -20,
	-10, 0, 0, 0, 0, 0, 0, -10,
	-10, 0, 5, 5, 5, 5, 0, -10,
	-5, 0, 5, 5, 5, 5, 0, -5,
	0, 0, 5, 5, 5, 5, 0, -5,
	-10, 5, 5, 5, 5, 5, 0, -10,
	-10, 0, 5, 0, 0, 0, 0, -10,
	-20, -10, -10, -5, -5, -10, -10, -20,
}
PM[6] = {
	-30, -40, -40, -50, -50, -40, -40, -30,
	-30, -40, -40, -50, -50, -40, -40, -30,
	-30, -40, -40, -50, -50, -40, -40, -30,
	-30, -40, -40, -50, -50, -40, -40, -30,
	-20, -30, -30, -40, -40, -30, -30, -20,
	-10, -20, -20, -20, -20, -20, -20, -10,
	20, 20, 0, 0, 0, 0, 20, 20,
	20, 30, 10, 0, 0, 10, 30, 20,
}
local PE = {
	-50, -40, -30, -20, -20, -30, -40, -50,
	-30, -20, -10, 0, 0, -10, -20, -30,
	-30, -10, 20, 30, 30, 20, -10, -30,
	-30, -10, 30, 40, 40, 30, -10, -30,
	-30, -10, 30, 40, 40, 30, -10, -30,
	-30, -10, 20, 30, 30, 20, -10, -30,
	-30, -30, 0, 0, 0, 0, -30, -30,
	-50, -30, -30, -30, -30, -30, -30, -50,
}
local PASS = { 0, 5, 10, 20, 35, 60, 100, 0 }

-- ============================================================ eval
local wpc = { [0] = 0, 0, 0, 0, 0, 0, 0, 0 }
local bpc = { [0] = 0, 0, 0, 0, 0, 0, 0, 0 }
local wMin = { [0] = 99, 99, 99, 99, 99, 99, 99, 99 }
local bMax = { [0] = -1, -1, -1, -1, -1, -1, -1, -1 }
local wp = table.create(8)
local bp = table.create(8)
local wr = table.create(4)
local br = table.create(4)

local function eval(g)
	local b = g.board
	local mg, eg, ph = 0, 0, 0
	for f = 0, 7 do
		wpc[f], bpc[f], wMin[f], bMax[f] = 0, 0, 99, -1
	end
	local wpN, bpN, wrN, brN = 0, 0, 0, 0
	local wB, bB = 0, 0
	local wk, bk
	for sq = 1, 64 do
		local p = b[sq]
		if p ~= 0 then
			local r = (sq - 1) // 8
			local f = (sq - 1) % 8
			if p > 0 then
				local idx = (7 - r) * 8 + f + 1
				mg = mg + VAL[p] + PM[p][idx]
				eg = eg + VAL[p] + (p == 6 and PE[idx] or PM[p][idx])
				ph = ph + PH[p]
				if p == 1 then
					wpc[f] = wpc[f] + 1
					if r < wMin[f] then wMin[f] = r end
					wpN = wpN + 1; wp[wpN] = sq
				elseif p == 3 then wB = wB + 1
				elseif p == 4 then wrN = wrN + 1; wr[wrN] = sq
				elseif p == 6 then wk = sq end
			else
				local q = -p
				local idx = r * 8 + f + 1
				mg = mg - VAL[q] - PM[q][idx]
				eg = eg - VAL[q] - (q == 6 and PE[idx] or PM[q][idx])
				ph = ph + PH[q]
				if q == 1 then
					bpc[f] = bpc[f] + 1
					if r > bMax[f] then bMax[f] = r end
					bpN = bpN + 1; bp[bpN] = sq
				elseif q == 3 then bB = bB + 1
				elseif q == 4 then brN = brN + 1; br[brN] = sq
				elseif q == 6 then bk = sq end
			end
		end
	end
	-- peoes passados
	for i = 1, wpN do
		local sq = wp[i]
		local r, f = (sq - 1) // 8, (sq - 1) % 8
		local passed = true
		for ff = f - 1, f + 1 do
			if ff >= 0 and ff <= 7 and bMax[ff] > r then passed = false end
		end
		if passed then
			local bn = PASS[r + 1]
			mg = mg + bn
			eg = eg + bn * 1.5
		end
	end
	for i = 1, bpN do
		local sq = bp[i]
		local r, f = (sq - 1) // 8, (sq - 1) % 8
		local passed = true
		for ff = f - 1, f + 1 do
			if ff >= 0 and ff <= 7 and wMin[ff] < r then passed = false end
		end
		if passed then
			local bn = PASS[8 - r]
			mg = mg - bn
			eg = eg - bn * 1.5
		end
	end
	-- dobrados / isolados
	for f = 0, 7 do
		local lw = f > 0 and wpc[f - 1] or 0
		local rw = f < 7 and wpc[f + 1] or 0
		local lb = f > 0 and bpc[f - 1] or 0
		local rb = f < 7 and bpc[f + 1] or 0
		if wpc[f] > 1 then mg = mg - 10 * (wpc[f] - 1); eg = eg - 15 * (wpc[f] - 1) end
		if bpc[f] > 1 then mg = mg + 10 * (bpc[f] - 1); eg = eg + 15 * (bpc[f] - 1) end
		if wpc[f] > 0 and lw + rw == 0 then mg = mg - 12; eg = eg - 12 end
		if bpc[f] > 0 and lb + rb == 0 then mg = mg + 12; eg = eg + 12 end
	end
	-- torres em colunas abertas
	for i = 1, wrN do
		local f = (wr[i] - 1) % 8
		if wpc[f] == 0 then
			local bn = bpc[f] == 0 and 20 or 10
			mg = mg + bn; eg = eg + bn
		end
	end
	for i = 1, brN do
		local f = (br[i] - 1) % 8
		if bpc[f] == 0 then
			local bn = wpc[f] == 0 and 20 or 10
			mg = mg - bn; eg = eg - bn
		end
	end
	if wB >= 2 then mg = mg + 30; eg = eg + 40 end
	if bB >= 2 then mg = mg - 30; eg = eg - 40 end
	-- escudo do rei (meio-jogo)
	if wk and wk <= 8 then
		for d = -1, 1 do
			local ff = (wk - 1) % 8 + d
			if ff >= 0 and ff <= 7 and b[wk + 8 + d] == 1 then mg = mg + 10 end
		end
	end
	if bk and bk >= 57 then
		for d = -1, 1 do
			local ff = (bk - 1) % 8 + d
			if ff >= 0 and ff <= 7 and b[bk - 8 + d] == -1 then mg = mg - 10 end
		end
	end
	if ph > 24 then ph = 24 end
	local score = (mg * ph + eg * (24 - ph)) / 24
	return math.floor(score) * g.turn + 10
end

-- ============================================================ zobrist
local rng = Random.new(987654321)
local Z1, Z2 = {}, {}
for i = 1, 1030 do
	Z1[i] = rng:NextInteger(1, 4294967295)
	Z2[i] = rng:NextInteger(1, 1048575)
end

local function pieceHash(g)
	local h1, h2 = 0, 0
	for sq = 1, 64 do
		local p = g.board[sq]
		if p ~= 0 then
			local i = (p + 7) * 65 + sq
			h1 = bxor(h1, Z1[i]); h2 = bxor(h2, Z2[i])
		end
	end
	g.h1, g.h2 = h1, h2
end

local function getKey(g)
	local h1, h2 = g.h1, g.h2
	local c = g.castle
	if c.wk then h1 = bxor(h1, Z1[1001]); h2 = bxor(h2, Z2[1001]) end
	if c.wq then h1 = bxor(h1, Z1[1002]); h2 = bxor(h2, Z2[1002]) end
	if c.bk then h1 = bxor(h1, Z1[1003]); h2 = bxor(h2, Z2[1003]) end
	if c.bq then h1 = bxor(h1, Z1[1004]); h2 = bxor(h2, Z2[1004]) end
	if g.ep ~= 0 then
		local i = 1010 + (g.ep - 1) % 8
		h1 = bxor(h1, Z1[i]); h2 = bxor(h2, Z2[i])
	end
	if g.turn == -1 then h1 = bxor(h1, Z1[1020]); h2 = bxor(h2, Z2[1020]) end
	return h1 + h2 * 4294967296
end

local function make(g, m)
	local u = makeMove(g, m)
	local b = g.board
	local h1, h2 = g.h1, g.h2
	u.h1, u.h2 = h1, h2
	local i = (u.piece + 7) * 65 + m.from
	h1 = bxor(h1, Z1[i]); h2 = bxor(h2, Z2[i])
	if u.captured ~= 0 then
		i = (u.captured + 7) * 65 + u.capSq
		h1 = bxor(h1, Z1[i]); h2 = bxor(h2, Z2[i])
	end
	i = (b[m.to] + 7) * 65 + m.to
	h1 = bxor(h1, Z1[i]); h2 = bxor(h2, Z2[i])
	local k = m.kind
	if k == 3 or k == 4 then
		local r = -g.turn * 4
		local a, c
		if k == 3 then a, c = m.from + 3, m.from + 1 else a, c = m.from - 4, m.from - 1 end
		i = (r + 7) * 65 + a
		h1 = bxor(h1, Z1[i]); h2 = bxor(h2, Z2[i])
		i = (r + 7) * 65 + c
		h1 = bxor(h1, Z1[i]); h2 = bxor(h2, Z2[i])
	end
	g.h1, g.h2 = h1, h2
	return u
end

local function unmake(g, u)
	g.h1, g.h2 = u.h1, u.h2
	unmakeMove(g, u)
end

-- ============================================================ busca
local INFO = { depth = 0, score = 0, nodes = 0, wcp = 0 }
local ttD, ttF, ttS, ttM, ttN = {}, {}, {}, {}, 0
local killers, hist = {}, {}
local nodes, stop, deadline, lastY = 0, false, 0, 0
local path = {}
local rootBest

local function checkTime()
	local t = os.clock()
	if t > deadline then
		stop = true
	elseif t - lastY > 0.006 then
		task.wait()
		lastY = os.clock()
	end
end

local function sortMoves(ms)
	table.sort(ms, function(a, b) return a.sc > b.sc end)
end

local function qs(g, alpha, beta, ply)
	nodes = nodes + 1
	if nodes % 128 == 0 then checkTime() end
	if stop then return 0 end
	local turn = g.turn
	local b = g.board
	local inChk = isAttacked(g, g.kings[turn], -turn)
	local sp = eval(g)
	if not inChk then
		if sp >= beta then return sp end
		if sp > alpha then alpha = sp end
	end
	if ply >= 60 then return sp end
	local caps = {}
	for _, m in pseudoMoves(g) do
		if inChk or m.cap ~= 0 or m.promo == 5 then
			if inChk or m.cap == 0 or m.promo ~= 0 or sp + VAL[m.cap] + 200 >= alpha then
				m.sc = (m.cap ~= 0 and VAL[m.cap] * 16 - abs(b[m.from]) or 0) + (m.promo == 5 and 8000 or 0)
				caps[#caps + 1] = m
			end
		end
	end
	sortMoves(caps)
	local nLegal = 0
	for i = 1, #caps do
		local u = make(g, caps[i])
		if isAttacked(g, g.kings[turn], -turn) then
			unmake(g, u)
		else
			nLegal = nLegal + 1
			local s = -qs(g, -beta, -alpha, ply + 1)
			unmake(g, u)
			if stop then return 0 end
			if s >= beta then return s end
			if s > alpha then alpha = s end
		end
	end
	if inChk and nLegal == 0 then return -MATE + ply end
	return alpha
end

local function hasPieces(g, turn)
	local b = g.board
	for i = 1, 64 do
		local p = b[i] * turn
		if p >= 2 and p <= 5 then return true end
	end
	return false
end

local function search(g, depth, alpha, beta, ply, nullOK)
	nodes = nodes + 1
	if nodes % 128 == 0 then checkTime() end
	if stop then return 0 end
	local turn = g.turn
	local inChk = isAttacked(g, g.kings[turn], -turn)
	if inChk and ply < 60 then depth = depth + 1 end
	if depth <= 0 then return qs(g, alpha, beta, ply) end

	local key = getKey(g)
	path[ply] = key
	if ply > 0 then
		if g.half >= 100 then return 0 end
		for i = ply - 2, 0, -2 do
			if path[i] == key then return 0 end
		end
		-- mate distance pruning
		if alpha < -MATE + ply then alpha = -MATE + ply end
		if beta > MATE - ply - 1 then beta = MATE - ply - 1 end
		if alpha >= beta then return alpha end
	end

	local ttm
	local td = ttD[key]
	if td then
		ttm = ttM[key]
		if ply > 0 and td >= depth then
			local s = ttS[key]
			if s > MATE - 300 then s = s - ply elseif s < -MATE + 300 then s = s + ply end
			local f = ttF[key]
			if f == 1 then return s end
			if f == 2 and s > alpha then alpha = s elseif f == 3 and s < beta then beta = s end
			if alpha >= beta then return s end
		end
	end

	local pv = beta - alpha > 1
	-- null move
	if nullOK and not inChk and not pv and depth >= 3 and beta < MATE - 300 and hasPieces(g, turn) then
		if eval(g) >= beta then
			local sep = g.ep
			g.ep = 0
			g.turn = -turn
			local R = depth > 6 and 3 or 2
			local s = -search(g, depth - 1 - R, -beta, -beta + 1, ply + 1, false)
			g.turn = turn
			g.ep = sep
			if stop then return 0 end
			if s >= beta then
				if s > MATE - 300 then s = beta end
				return s
			end
		end
	end

	local moves = pseudoMoves(g)
	local b = g.board
	local kl = killers[ply]
	local k1, k2 = kl and kl[1], kl and kl[2]
	for i = 1, #moves do
		local m = moves[i]
		local s
		if ttm and m.from == ttm.from and m.to == ttm.to and m.promo == ttm.promo then
			s = 1e9
		elseif m.cap ~= 0 then
			s = 1e6 + VAL[m.cap] * 16 - abs(b[m.from])
		elseif m.promo == 5 then
			s = 1.5e6
		else
			local mk = m.from * 65 + m.to
			if mk == k1 then s = 9e5
			elseif mk == k2 then s = 8e5
			else s = hist[mk] or 0 end
		end
		m.sc = s
	end
	sortMoves(moves)

	local legal = 0
	local best = -INF
	local bestMove
	local origAlpha = alpha
	for i = 1, #moves do
		local m = moves[i]
		local u = make(g, m)
		if isAttacked(g, g.kings[turn], -turn) then
			unmake(g, u)
		else
			legal = legal + 1
			local quiet = m.cap == 0 and m.promo == 0
			local gives = isAttacked(g, g.kings[-turn], turn)
			local s
			if legal == 1 then
				s = -search(g, depth - 1, -beta, -alpha, ply + 1, true)
			else
				local r = 0
				if depth >= 3 and legal > 4 and quiet and not inChk and not gives then
					r = (legal > 10 and depth > 5) and 2 or 1
				end
				s = -search(g, depth - 1 - r, -alpha - 1, -alpha, ply + 1, true)
				if s > alpha and r > 0 then
					s = -search(g, depth - 1, -alpha - 1, -alpha, ply + 1, true)
				end
				if s > alpha and s < beta then
					s = -search(g, depth - 1, -beta, -alpha, ply + 1, true)
				end
			end
			unmake(g, u)
			if stop then return 0 end
			if s > best then
				best = s
				bestMove = m
				if s > alpha then
					alpha = s
					if ply == 0 then rootBest = m end
					if alpha >= beta then
						if quiet then
							local mk = m.from * 65 + m.to
							local kk = killers[ply]
							if not kk then kk = {}; killers[ply] = kk end
							if kk[1] ~= mk then kk[2] = kk[1]; kk[1] = mk end
							local hv = (hist[mk] or 0) + depth * depth
							hist[mk] = hv > 700000 and 700000 or hv
						end
						break
					end
				end
			end
		end
	end

	if legal == 0 then
		return inChk and (-MATE + ply) or 0
	end

	local flag = best >= beta and 2 or (best > origAlpha and 1 or 3)
	local sv = best
	if sv > MATE - 300 then sv = sv + ply elseif sv < -MATE + 300 then sv = sv - ply end
	if not ttD[key] then
		ttN = ttN + 1
	end
	if not ttD[key] or ttD[key] <= depth then
		ttD[key], ttF[key], ttS[key], ttM[key] = depth, flag, sv, bestMove
	end
	return best
end

local function think(g0)
	local g = Engine.clone(g0)
	pieceHash(g)
	local legal = Engine.legalMoves(g)
	if #legal == 0 then return nil end
	if #legal == 1 then return legal[1] end
	if ttN > 150000 then ttD, ttF, ttS, ttM, ttN = {}, {}, {}, {}, 0 end
	killers, hist, path = {}, {}, {}
	deadline = os.clock() + TIME_LIMIT
	stop = false
	nodes = 0
	lastY = os.clock()
	local best = legal[1]
	local t0 = os.clock()
	for d = 1, MAX_DEPTH do
		rootBest = nil
		local s = search(g, d, -INF, INF, 0, false)
		if rootBest then best = rootBest end
		if stop then break end
		INFO.depth, INFO.score, INFO.nodes, INFO.wcp = d, s, nodes, s * g.turn
		print(("depth %d score %d nodes %d best %s"):format(d, s, nodes, Engine.uci(best)))
		if abs(s) > MATE - 300 then break end
		if os.clock() - t0 > TIME_LIMIT * 0.6 then break end
	end
	return best
end

-- ============================================================ gui + loop
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

if getgenv then
	local old = getgenv().ChessGui
	if old then pcall(function() old.gui:Destroy() end); old.dead = true end
end
local Ctl = { enabled = false, dead = false }
if getgenv then getgenv().ChessGui = Ctl end

local C = {
	bg = Color3.fromRGB(17, 18, 26), card = Color3.fromRGB(27, 29, 41), line = Color3.fromRGB(48, 52, 72),
	text = Color3.fromRGB(235, 237, 245), dim = Color3.fromRGB(135, 140, 165),
	acc = Color3.fromRGB(99, 132, 255), on = Color3.fromRGB(52, 211, 120), off = Color3.fromRGB(90, 94, 115),
	warn = Color3.fromRGB(255, 99, 99), amber = Color3.fromRGB(255, 190, 70),
}
local function new(class, props, parent)
	local o = Instance.new(class)
	for k, v in props do o[k] = v end
	o.Parent = parent
	return o
end
local function round(o, r) new("UICorner", { CornerRadius = UDim.new(0, r) }, o) end
local function stroke(o, col, th) return new("UIStroke", { Color = col, Thickness = th or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, o) end
local function tween(o, props, t) TweenService:Create(o, TweenInfo.new(t or 0.18, Enum.EasingStyle.Quad), props):Play() end

local gui = new("ScreenGui", { Name = "ChessAI", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling },
	(gethui and gethui()) or game:GetService("CoreGui"))
Ctl.gui = gui

local frame = new("Frame", {
	Size = UDim2.fromOffset(250, 326), Position = UDim2.new(0, 24, 0.5, -163),
	BackgroundColor3 = C.bg, BorderSizePixel = 0, Active = true,
}, gui)
round(frame, 14); stroke(frame, C.line, 1)
new("UIGradient", { Rotation = 90, Color = ColorSequence.new(Color3.fromRGB(26, 28, 42), Color3.fromRGB(14, 15, 22)) }, frame)

-- drag leve (sem CanvasGroups de motion blur que pesam o RenderStepped)
frame.Draggable = false
frame.ZIndex = 5
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local dragHandle = new("TextButton", { Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Text = "", ZIndex = 20, AutoButtonColor = false }, frame)
local sx, sy = frame.Position.X.Scale, frame.Position.Y.Scale
local cx, cy = frame.Position.X.Offset, frame.Position.Y.Offset
local tx, ty = cx, cy
local dragging, mx0, my0, tx0, ty0 = false, 0, 0, 0, 0

dragHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		mx0, my0, tx0, ty0 = input.Position.X, input.Position.Y, tx, ty
	end
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)
UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		tx = tx0 + (input.Position.X - mx0)
		ty = ty0 + (input.Position.Y - my0)
	end
end)

local conn
conn = RunService.RenderStepped:Connect(function(dt)
	if Ctl.dead or not gui.Parent then
		conn:Disconnect()
		return
	end
	if not dragging and math.abs(tx - cx) < 0.2 and math.abs(ty - cy) < 0.2 then
		return
	end
	local k = 1 - math.exp(-dt * 30)
	cx, cy = cx + (tx - cx) * k, cy + (ty - cy) * k
	frame.Position = UDim2.new(sx, cx, sy, cy)
end)
-- header
new("TextLabel", { Size = UDim2.new(1, -60, 0, 30), Position = UDim2.fromOffset(14, 8), BackgroundTransparency = 1,
	Text = "Chess AI", TextColor3 = C.text, Font = Enum.Font.GothamBold, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left }, frame)
local dot = new("Frame", { Size = UDim2.fromOffset(10, 10), Position = UDim2.new(1, -26, 0, 18), BackgroundColor3 = C.off, BorderSizePixel = 0 }, frame)
round(dot, 5)

-- toggle
local tgl = new("TextButton", { Size = UDim2.new(1, -28, 0, 40), Position = UDim2.fromOffset(14, 44), BackgroundColor3 = C.card,
	Text = "", AutoButtonColor = false }, frame)
round(tgl, 10); local tglStroke = stroke(tgl, C.line, 1)
local tglText = new("TextLabel", { Size = UDim2.new(1, -70, 1, 0), Position = UDim2.fromOffset(14, 0), BackgroundTransparency = 1,
	Text = "DISABLED", TextColor3 = C.dim, Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left }, tgl)
local track = new("Frame", { Size = UDim2.fromOffset(44, 22), Position = UDim2.new(1, -56, 0.5, -11), BackgroundColor3 = C.off, BorderSizePixel = 0 }, tgl)
round(track, 11)
local knob = new("Frame", { Size = UDim2.fromOffset(16, 16), Position = UDim2.fromOffset(3, 3), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0 }, track)
round(knob, 8)

-- modos
local MODES = {
	{ name = "1 min", max = 0.6, div = 40 },
	{ name = "3 min", max = 2.2, div = 28 },
	{ name = "10 min", max = 6, div = 20 },
}
local mode = MODES[1] -- padrao: 1 min
local mbtns = {}
local seg = new("Frame", { Size = UDim2.new(1, -28, 0, 30), Position = UDim2.fromOffset(14, 94), BackgroundColor3 = C.card, BorderSizePixel = 0 }, frame)
round(seg, 8)
local function refreshModes()
	for i, b in mbtns do
		local sel = MODES[i] == mode
		tween(b, { BackgroundColor3 = sel and C.acc or C.card, TextColor3 = sel and Color3.new(1, 1, 1) or C.dim })
	end
end
for i, m in MODES do
	local b = new("TextButton", { Size = UDim2.new(1 / 3, -6, 1, -6), Position = UDim2.new((i - 1) / 3, 3, 0, 3), BackgroundColor3 = C.card,
		Text = m.name, TextColor3 = C.dim, Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false }, seg)
	round(b, 6)
	b.MouseButton1Click:Connect(function() mode = m; refreshModes() end)
	mbtns[i] = b
end
refreshModes()

-- relogios
local function clockBox(x, label)
	local box = new("Frame", { Size = UDim2.new(0.5, -19, 0, 52), Position = UDim2.new(x, x == 0 and 14 or 5, 0, 134), BackgroundColor3 = C.card, BorderSizePixel = 0 }, frame)
	round(box, 10)
	new("TextLabel", { Size = UDim2.new(1, 0, 0, 16), Position = UDim2.fromOffset(0, 6), BackgroundTransparency = 1, Text = label,
		TextColor3 = C.dim, Font = Enum.Font.Gotham, TextSize = 11 }, box)
	return new("TextLabel", { Size = UDim2.new(1, 0, 0, 26), Position = UDim2.fromOffset(0, 22), BackgroundTransparency = 1, Text = "--:--",
		TextColor3 = C.text, Font = Enum.Font.GothamBold, TextSize = 20 }, box)
end
local myClock = clockBox(0, "YOU")
local opClock = clockBox(0.5, "OPONENTE")

-- infos
-- Win Chance (do SEU lado): verde = bem, amarelo = equilibrado, vermelho = mal
local mySide = 1
local barBg = new("Frame", { Size = UDim2.new(1, -28, 0, 18), Position = UDim2.fromOffset(14, 194), BackgroundColor3 = Color3.fromRGB(35, 35, 40), BorderSizePixel = 0, ClipsDescendants = true }, frame)
round(barBg, 9); stroke(barBg, C.line, 1)
local barW = new("Frame", { Size = UDim2.new(0.5, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(240, 200, 60), BorderSizePixel = 0 }, barBg)
round(barW, 9)
local barTxt = new("TextLabel", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "Win Chance: --", TextColor3 = Color3.new(1, 1, 1),
	Font = Enum.Font.GothamBold, TextSize = 11, ZIndex = 3 }, barBg)
new("UIStroke", { Color = Color3.new(0, 0, 0), Thickness = 1, Transparency = 0.55 }, barTxt)
local RED, YEL, GRN = Color3.fromRGB(235, 70, 70), Color3.fromRGB(240, 200, 60), Color3.fromRGB(60, 205, 110)
local lastBarWcp = nil
local function setBar(wcp)
	if lastBarWcp and math.abs(wcp - lastBarWcp) < 5 then return end
	lastBarWcp = wcp
	local c = math.clamp(wcp * mySide, -2000, 2000) -- avaliacao do seu ponto de vista
	local p = 1 / (1 + 10 ^ (-c / 400))               -- sua chance de vencer
	local col
	if p < 0.5 then col = RED:Lerp(YEL, p / 0.5) else col = YEL:Lerp(GRN, (p - 0.5) / 0.5) end
	tween(barW, { Size = UDim2.new(math.max(p, 0.04), 0, 1, 0), BackgroundColor3 = col }, 0.35)
	barTxt.Text = ("Win Chance: %d%%"):format(math.floor(p * 100 + 0.5))
end
local status = new("TextLabel", { Size = UDim2.new(1, -28, 0, 18), Position = UDim2.fromOffset(14, 220), BackgroundTransparency = 1,
	Text = "disabled", TextColor3 = C.text, Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left }, frame)
local sub = new("TextLabel", { Size = UDim2.new(1, -28, 0, 16), Position = UDim2.fromOffset(14, 240), BackgroundTransparency = 1,
	Text = "", TextColor3 = C.dim, Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left }, frame)
local sub2 = new("TextLabel", { Size = UDim2.new(1, -28, 0, 16), Position = UDim2.fromOffset(14, 260), BackgroundTransparency = 1,
	Text = "", TextColor3 = C.dim, Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left }, frame)

local dotColor = C.off
local function setStatus(txt, col, s1, s2)
	status.Text = txt
	if col and col ~= dotColor then
		dotColor = col
		dot.BackgroundColor3 = col
	end
	if s1 then sub.Text = s1 end
	if s2 then sub2.Text = s2 end
end

local function setEnabled(v)
	Ctl.enabled = v
	tglText.Text = v and "ENABLED" or "DISABLED"
	tween(tglText, { TextColor3 = v and C.on or C.dim })
	tween(track, { BackgroundColor3 = v and C.on or C.off })
	tween(knob, { Position = v and UDim2.fromOffset(25, 3) or UDim2.fromOffset(3, 3) })
	tglStroke.Color = v and C.on or C.line
	if v then setStatus("searching for match...", C.amber) else setStatus("disabled", C.off, "", "") end
end
tgl.MouseButton1Click:Connect(function() setEnabled(not Ctl.enabled) end)
setEnabled(true) -- ja inicia ativado

task.spawn(function() -- pulso do indicador
	if dot.BackgroundColor3 ~= dotColor then
		dot.BackgroundColor3 = dotColor
	end
end)

local function fmt(s)
	if not s then return "--:--" end
	if s < 10 then return ("%.1f"):format(s) end
	return ("%d:%02d"):format(s // 60, s % 60)
end

-- deteccao da partida: reprocura os closures `current` ate achar uma partida rodando
local curFn, lastScan = nil, 0
local function tryFn(f)
	local ok, g = pcall(f)
	if ok and type(g) == "table" and g.state and g.you and (g.running or (g.ply or 0) <= 1) then return g end
	return nil
end
-- o closure `current` do GameView existe o tempo todo e devolve a partida atual a cada chamada.
-- Entao acha-se ele UMA vez (mesmo sem partida) e depois so se chama: deteccao instantanea.
local function findCurrentFn()
	if curFn then return curFn end
	if os.clock() - lastScan < 3 then return nil end
	lastScan = os.clock()
	local fs = filtergc("function", { Name = "current" }, false)
	curFn = fs and fs[1]
	return curFn
end
local function getGame()
	local f = findCurrentFn()
	if not f then return nil end
	return tryFn(f)
end
local function buildPos(State)
	local wk, bk = 5, 61
	for i = 1, 64 do
		if State.board[i] == 6 then wk = i elseif State.board[i] == -6 then bk = i end
	end
	return {
		board = table.clone(State.board), turn = State.turn, castle = table.clone(State.castle),
		ep = State.ep, half = State.half, full = State.full, kings = { [1] = wk, [-1] = bk },
	}
end

-- puzzles: le o estado do PuzzleView (upvalues) e joga a solucao guardada no proprio puzzle
local pzFn, pzScan, pzDone = nil, 0, {}
local function findPuzzleFn()
	if os.clock() - pzScan < 5 then return nil end
	pzScan = os.clock()
	for _, f in filtergc("function", { Name = "onMove" }, false) or {} do
		local env = getfenv(f)
		local sc = env and env.script
		if sc and sc.Name == "PuzzleView" then return f end
	end
	return nil
end
local function solvePuzzle()
	if not pzFn then pzFn = findPuzzleFn() end
	if not pzFn then return false end
	local locked, done, pz, pos, ui
	local okU, ups = pcall(debug.getupvalues, pzFn)
	if not okU or type(ups) ~= "table" then
		pzFn = nil
		return false
	end
	locked, done, pz, pos = ups[1], ups[2], ups[3], ups[6]
	for _, v in ups do
		if type(v) == "table" and rawget(v, "endRush") then ui = v end
	end
	if type(pz) ~= "table" or type(pos) ~= "table" or not pz.moves or not ui then return false end
	local visible = false
	pcall(function() visible = ui.frame and ui.frame.Visible and ui.frame:IsDescendantOf(game) end)
	if not visible then return false end
	if done then
		local mode = nil
		for _, v in ups do
			if v == "rated" or v == "rush" or v == "daily" then mode = v end
		end
		setStatus("puzzle: solved", C.on, mode == "rated" and "going to next..." or "waiting for next...", "")
		local key = "next:" .. tostring(pz.id)
		if mode == "rated" and not pzDone[key] then
			pzDone[key] = os.clock()
			task.wait(0.5)
			pcall(ui.next)
		end
		return true
	end
	if locked then
		setStatus("puzzle: waiting", C.amber, "rating " .. tostring(pz.rating), "")
		return true
	end
	-- descobre quantos lances do puzzle ja foram jogados comparando posicoes
	local cur = Engine.toFEN(pos)
	local sim = Engine.fromFEN(pz.fen)
	local k = -1
	for i = 1, #pz.moves + 1 do
		if Engine.toFEN(sim) == cur then
			k = i - 1
			break
		end
		local m = pz.moves[i] and Engine.fromUci(sim, pz.moves[i])
		if not m then break end
		Engine.makeMove(sim, m)
	end
	if k < 0 or k % 2 ~= 1 then return true end
	local uci = pz.moves[k + 1]
	local key = tostring(pz.id) .. ":" .. k
	if not uci or pzDone[key] and os.clock() - pzDone[key] < 1.5 then return true end
	local mv = Engine.fromUci(pos, uci)
	if not mv then return true end
	pzDone[key] = os.clock()
	setStatus("puzzle: " .. uci, C.on, "rating " .. tostring(pz.rating), "move " .. ((k + 1) // 2) .. "/" .. (#pz.moves // 2))
	task.wait(0.3)
	pcall(pzFn, mv, false)
	return true
end
-- le os relogios reais direto da interface do jogo (BottomBar = voce, TopBar = oponente)
local function parseClock(s)
	if type(s) ~= "string" then return nil end
	local m, sec = s:match("^(%d+):(%d%d)$")
	if m then return (tonumber(m) or 0) * 60 + (tonumber(sec) or 0) end
	local d = s:match("^(%d+%.%d)$")
	if d then return tonumber(d) or 0 end
	return nil
end
local function readUiClocks()
	local ok, mine, theirs = pcall(function()
		local duel = Players.LocalPlayer.PlayerGui.ChessUI.Screen.Root.Panel.Duel
		return parseClock(duel.BottomBar.Clock.Time.Text), parseClock(duel.TopBar.Clock.Time.Text)
	end)
	if ok then return mine, theirs end
	return nil, nil
end
findCurrentFn()
-- fim de partida: entra na fila de uma nova 1 min (bullet), igual ao botao "New Game"
local lastQueue = 0
local ggSent = {}
local function maybeRequeue()
	if not curFn then return false end
	local ok, g = pcall(curFn)
	if not ok or type(g) ~= "table" or g.running or (g.ply or 0) < 2 then return false end
	if g.id and not ggSent[g.id] then
		ggSent[g.id] = true -- manda GG (reacao 6) uma vez por partida, ganhando ou perdendo
		PlayMove:FireServer("react", { idx = 6 })
	end
	if os.clock() - lastQueue < 25 then
		setStatus("in queue: bullet 1 min", C.amber, "searching for opponent...", "")
		return true
	end
	lastQueue = os.clock()
	setStatus("game over", C.amber, "joining 1 min queue...", "")
	task.wait(0.8)
	PlayMove:FireServer("queue", { tc = "bullet" })
	return true
end
-- ===== estatisticas da sessao =====
local Stats = { win = 0, loss = 0, draw = 0, started = os.time(), counted = {}, latest = {} }

local profFn
local function readProfile()
	if not profFn then
		local fs = filtergc("function", { Name = "profileReady" }, false)
		profFn = fs and fs[1]
	end
	if not profFn then return nil, nil end
	local ok, ups = pcall(debug.getupvalues, profFn)
	if not ok or type(ups) ~= "table" then return nil, nil end
	for _, v in ups do
		if type(v) == "table" and type(rawget(v, "profile")) == "table" then
			local p = v.profile
			local r = {}
			for mode, x in p.ratings or {} do r[mode] = x.rating end
			return r, p.lastMode
		end
	end
	return nil, nil
end
Stats.startRatings = readProfile() or {} -- rating de cada modo ao executar o script
local function fillBaseline()
	local now = readProfile()
	if now then
		for mode, r in now do
			if Stats.startRatings[mode] == nil then Stats.startRatings[mode] = r end
		end
	end
end
local function dialogOutcome()
	return nil
end

local function outcomeOf(g)
	local o = g.over or g.result
	local me = g.you
	local function fromResult(r)
		if r == "1-0" then return me == 1 and "win" or "loss" end
		if r == "0-1" then return me == -1 and "win" or "loss" end
		if r == "1/2-1/2" or r == "draw" then return "draw" end
		return nil
	end
	if type(o) == "string" then
		local r = fromResult(o)
		if r then return r end
	elseif type(o) == "table" then
		for _, v in o do
			if type(v) == "string" then
				local r = fromResult(v)
				if r then return r end
			end
		end
		local w = o.winner or o.won
		if type(w) == "number" then
			if w == 0 then return "draw" end
			return w == me and "win" or "loss"
		end
	end
	return dialogOutcome()
end

local pendingSince = {}
local function trackResult()
	if not curFn then return end
	local ok, g = pcall(curFn)
	if not ok or type(g) ~= "table" or g.running or (g.ply or 0) < 2 or not g.id then return end
	if Stats.counted[g.id] then return end
	pendingSince[g.id] = pendingSince[g.id] or os.clock()
	local r = outcomeOf(g)
	if not r then
		if os.clock() - pendingSince[g.id] > 4 then Stats.counted[g.id] = "?" end -- nao deu pra saber
		return
	end
	Stats.counted[g.id] = r
	Stats[r] = Stats[r] + 1
	local side = g.you == 1 and g.white or g.black
	if side and side.rating and g.tc and Stats.startRatings[g.tc] == nil then
		Stats.startRatings[g.tc] = side.rating -- rating de antes dessa partida
	end

	print(("[ChessAI] game %s: %s (W %d / L %d / D %d)"):format(tostring(g.id), r, Stats.win, Stats.loss, Stats.draw))
end

-- oponente nao carregou: clica em "Find a new opponent" quando o botao aparece
local lastRetryScan, lastRetryClick = 0, 0
local function fullyVisible(o)
	local cur = o
	while cur and cur:IsA("GuiObject") do
		if not cur.Visible then return false end
		cur = cur.Parent
	end
	return o.AbsoluteSize.X > 0
end
local function autoRetry()
	local now = os.clock()
	if now - lastRetryScan < 2.5 or now - lastRetryClick < 5 then return end
	lastRetryScan = now
	if curFn then
		local ok, g = pcall(curFn)
		if ok and type(g) == "table" and g.running then return end
	end
	local root = Players.LocalPlayer.PlayerGui
	if not root then return end
	local mf = root:FindFirstChild("MatchFound", true) or root
	for _, d in mf:GetDescendants() do
		if (d:IsA("TextButton") or d:IsA("TextLabel")) and d.Text == "Find a new opponent" and fullyVisible(d) then
			local btn = d
			while btn and not btn:IsA("GuiButton") do btn = btn.Parent end
			d = btn or d
			lastRetryClick = now
			setStatus("opponent failed to load", C.warn, "looking for another...", "")
			for _, sig in { d.MouseButton1Click, d.Activated, d.MouseButton1Up } do
				pcall(function()
					for _, c in getconnections(sig) do c:Fire() end
				end)
			end
			return
		end
	end
end
local lastReact = 0
local lastPly, lastSent, lastId = -1, 0, nil
local lastSentAt, lastClockId, clockBase = nil, nil, 0
task.spawn(function()
	while not Ctl.dead do
		task.wait(0.1)
		local ok, err = pcall(function()
			if Ctl.enabled and solvePuzzle() then return end
			if Ctl.enabled then autoRetry() end
			trackResult()
			if Ctl.enabled and maybeRequeue() then return end
			local g = getGame()
			if not g or not g.you or g.you == 0 then
				myClock.Text, opClock.Text = "--:--", "--:--"
				if Ctl.enabled then setStatus("searching for match...", C.amber, "", "") end
				return
			end
			mySide = g.you
			local ck = g.clock or {}
			local my = ck[g.you == 1 and "w" or "b"]
			local opp = ck[g.you == 1 and "b" or "w"]
			-- relogio de quem esta jogando continua descendo desde o ultimo update
			local myTurn = g.state.turn == g.you
			if g.sentAt ~= lastSentAt or g.id ~= lastClockId then
				lastSentAt, lastClockId, clockBase = g.sentAt, g.id, os.clock()
			end
			local el = os.clock() - clockBase
			if g.ply and g.ply >= 2 then
				if myTurn and my then my = math.max(0, my - el) elseif opp then opp = math.max(0, opp - el) end
			end
			local uiMy, uiOpp = readUiClocks()
			my, opp = uiMy or my, uiOpp or opp
			setBar(INFO.wcp)
			myClock.Text, opClock.Text = fmt(my), fmt(opp)
			myClock.TextColor3 = (my and my < 10) and C.warn or C.text
			opClock.TextColor3 = (opp and opp < 10) and C.warn or C.text
			do
				local me = g.you == 1 and g.white or g.black
				if me and me.rating and g.tc and (g.ply or 0) <= 3 then Stats.latest[g.tc] = me.rating end
			end
			if g.id ~= lastId then
				lastId, lastPly = g.id, -1
				local idx = ({ bullet = 1, blitz = 2, rapid = 3 })[tostring(g.tc):lower()]
				local top = math.max(ck.w or 0, ck.b or 0)
				if (g.ply or 0) <= 2 and top > 0 then idx = top <= 90 and 1 or (top <= 300 and 2 or 3) end
				if idx then mode = MODES[idx]; refreshModes() end
				if Ctl.enabled and (g.ply or 0) <= 2 then -- so cumprimenta se a partida acabou de comecar
					lastReact = os.time()
					local pick = math.random(1, 2) -- 1 = Have fun, 2 = Good luck
					task.delay(0.6, function() PlayMove:FireServer("react", { idx = pick }) end)
				end
			end
			if not Ctl.enabled then return end
			local colorName = g.you == 1 and "white" or "black"
			if not myTurn then
				setStatus("opponent turn", C.amber, "playing as " .. colorName, ("last analysis: depth %d"):format(INFO.depth))
				return
			end
			if g.ply == lastPly and os.clock() - lastSent < 3 then return end
			my, opp = my or 60, opp or 60
			local base = math.min(mode.max, my / mode.div)
			local tl, why = base, "normal"
			if my < 8 then tl, why = 0.06, "time critical"
			elseif my < 20 then tl, why = math.min(base, 0.2), "low time"
			elseif opp < 15 and opp < my then tl, why = math.min(base, 0.3), "pressuring"
			elseif my > opp * 2 and my > 60 then tl, why = math.min(mode.max * 1.5, base * 1.4), "spare time: thinks longer"
			end
			TIME_LIMIT = math.max(0.05, tl)
			setStatus("thinking...", C.on, "playing as " .. colorName, "style: " .. why)
			local ply = g.ply
			local best = think(buildPos(g.state))
			if not Ctl.enabled or Ctl.dead then return end
			local g2 = getGame()
			if best and g2 and g2.ply == ply and g2.state.turn == g2.you then
				PlayMove:FireServer("move", { from = best.from, to = best.to, promo = best.promo or 0 })
				lastPly, lastSent = ply, os.clock()
				setStatus("played " .. Engine.uci(best), C.on, ("depth %d  eval %+.2f"):format(INFO.depth, INFO.score / 100 * (g.you == g.state.turn and 1 or -1)), "style: " .. why)
			end
		end)
		if not ok then setStatus("error", C.warn, tostring(err):sub(1, 45)) end
	end
end)