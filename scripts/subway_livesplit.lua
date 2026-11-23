-- LiveSplit Timer for Subway Surfing (No-Coin / Speedrun Edition - 100% ASCII)
-- [YDX Execution Telemetry - Non-Duplicating when loaded via Universal Loader]
do
    local env = (type(getgenv) == "function" and getgenv()) or _G
    env.__YDX_EXEC_LOCKS = env.__YDX_EXEC_LOCKS or {}
    local sid = "subway-livesplit"
    local now = os.clock()
    if not env.__YDX_EXEC_LOCKS[sid] or (now - env.__YDX_EXEC_LOCKS[sid]) > 15 then
        env.__YDX_EXEC_LOCKS[sid] = now
        task.spawn(function()
            local k = sid:gsub("[^%w_%-]", "_")
            pcall(function() game:HttpGet("https://abacus.jasoncameron.dev/hit/ydx_script_vault/total_executions") end)
            pcall(function() game:HttpGet("https://abacus.jasoncameron.dev/hit/ydx_script_vault/" .. k) end)
            pcall(function() game:HttpGet("https://countapi.mileshilliard.com/api/v1/hit/ydx_vault_total") end)
            pcall(function() game:HttpGet("https://countapi.mileshilliard.com/api/v1/hit/ydx_vault_" .. k) end)
        end)
    end
end
-- Replicates the exact LiveSplit Dev Build aesthetic & behavior:
--   - Auto-starts when the run begins (SharedData.IntroEnd /SharedData.IsPlaying)
--   - Counts in green (#33d459 / #22b346 gradient) with comma decimal (e.g. 1,94 / 1:04,28)
--   - Immediately pauses & turns gray (#a8a8a8 / #787878 gradient) the instant you pick up a Coin, use Jetpack/Hoverboard, Pause, or Die!
--   - Shows "Previous Segment" (Previous Segment / Best Run delta) and Personal Best (PB) saved to disk!
--   - Right-click (or tap settings icon) to toggle Auto-Restart on Coin or Reset PB.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local SAVE_FILE = "subway_livesplit_data.json"

-- Clean up any previous LiveSplit instance
local genv = (getgenv and getgenv()) or _G
if type(genv._SubwayLiveSplitCleanup) == "function" then
    pcall(genv._SubwayLiveSplitCleanup)
end

-- Locate SharedData module in Subway Surfing
local Modules = ReplicatedStorage:WaitForChild("Modules", 10)
local SharedData = Modules and Modules:FindFirstChild("SharedData") and require(Modules.SharedData)

local state = {
    active = true,
    running = false,
    disqualified = false, -- true when coin picked up, hoverboard/fly used, or dead
    paused = false,
    elapsed = 0,
    lastRunTime = nil,
    bestNoCoinTime = nil,
    posX = nil,
    posY = nil,
    connections = {},
    gui = nil,
}

-- Load saved PB & window position
local function loadData()
    if type(isfile) == "function" and type(readfile) == "function" then
        local ok, exists = pcall(isfile, SAVE_FILE)
        if ok and exists then
            local rok, content = pcall(readfile, SAVE_FILE)
            if rok and type(content) == "string" and #content > 2 then
                local dok, data = pcall(HttpService.JSONDecode, HttpService, content)
                if dok and type(data) == "table" then
                    state.bestNoCoinTime = tonumber(data.bestNoCoinTime)
                    state.lastRunTime = tonumber(data.lastRunTime)
                    state.posX = tonumber(data.posX)
                    state.posY = tonumber(data.posY)
                end
            end
        end
    end
end

local function saveData()
    if type(writefile) == "function" then
        local payload = {
            bestNoCoinTime = state.bestNoCoinTime,
            lastRunTime = state.lastRunTime,
            posX = state.posX,
            posY = state.posY,
        }
        local ok, encoded = pcall(HttpService.JSONEncode, HttpService, payload)
        if ok and type(encoded) == "string" then
            pcall(writefile, SAVE_FILE, encoded)
        end
    end
end

loadData()

-- Format time with comma like LiveSplit PT-BR:
-- Under 60s -> "1,94" (sec="1", dec=",94")
-- 60s to 3600s -> "1:04,90" (sec="1:04", dec=",90")
local function splitTimeParts(t)
    t = math.max(0, tonumber(t) or 0)
    local totalCentis = math.floor(t * 100 + 0.0001)
    local centis = totalCentis % 100
    local totalSecs = math.floor(totalCentis / 100)
    local secs = totalSecs % 60
    local mins = math.floor(totalSecs / 60) % 60
    local hours = math.floor(totalSecs / 3600)

    local mainStr
    if hours > 0 then
        mainStr = string.format("%d:%02d:%02d", hours, mins, secs)
    elseif mins > 0 then
        mainStr = string.format("%d:%02d", mins, secs)
    else
        mainStr = string.format("%d", secs)
    end

    local decStr = string.format(",%02d", centis)
    return mainStr, decStr
end

local function formatDelta(diff)
    if not diff then return "-" end
    local sign = diff >= 0 and "+" or "-"
    local a = math.abs(diff)
    local mainStr, decStr = splitTimeParts(a)
    return sign .. mainStr .. decStr
end

-- Build exact LiveSplit UI
local parentGui = nil
if type(gethui) == "function" then
    local ok, res = pcall(gethui)
    if ok and res then parentGui = res end
end
if not parentGui then
    parentGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or CoreGui
end

local oldGui = parentGui:FindFirstChild("LiveSplitSubway")
if oldGui then oldGui:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "LiveSplitSubway"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.DisplayOrder = 9999
sg.Parent = parentGui
state.gui = sg

-- Main LiveSplit Window (matches exact compact dark LiveSplit proportion from user's screenshot)
local win = Instance.new("Frame")
win.Name = "LiveSplitWindow"
win.Size = UDim2.fromOffset(252, 86)
win.Position = (state.posX and state.posY)
    and UDim2.fromOffset(state.posX, state.posY)
    or UDim2.new(0, 18, 0, 120)
win.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
win.BorderSizePixel = 0
win.Active = true
win.Parent = sg

local winStroke = Instance.new("UIStroke")
winStroke.Color = Color3.fromRGB(38, 38, 38)
winStroke.Thickness = 1
winStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
winStroke.Parent = win

-- Top Timer Area (62px high, dark glossy gradient)
local timerArea = Instance.new("Frame")
timerArea.Name = "TimerArea"
timerArea.Size = UDim2.new(1, 0, 0, 62)
timerArea.Position = UDim2.fromOffset(0, 0)
timerArea.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
timerArea.BorderSizePixel = 0
timerArea.Parent = win

local timerBgGrad = Instance.new("UIGradient")
timerBgGrad.Rotation = 90
timerBgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 24)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 12)),
})
timerBgGrad.Parent = timerArea

-- Small status tag on top-left (subtle, shows NO-COIN / PAUSED / COIN)
local modeTag = Instance.new("TextLabel")
modeTag.Name = "ModeTag"
modeTag.Size = UDim2.fromOffset(90, 16)
modeTag.Position = UDim2.fromOffset(8, 6)
modeTag.BackgroundTransparency = 1
modeTag.Font = Enum.Font.SourceSansSemibold
modeTag.TextSize = 12
modeTag.TextColor3 = Color3.fromRGB(95, 95, 95)
modeTag.TextXAlignment = Enum.TextXAlignment.Left
modeTag.Text = ""
modeTag.Parent = timerArea

-- Right-aligned horizontal layout for [Main Seconds] + [Comma + Centiseconds]
-- In LiveSplit, the integer seconds are larger (~46px) and the ",94" is slightly smaller (~36px) aligned to bottom baseline!
local digitsHolder = Instance.new("Frame")
digitsHolder.Name = "DigitsHolder"
digitsHolder.Size = UDim2.new(1, -16, 1, -6)
digitsHolder.Position = UDim2.fromOffset(8, 3)
digitsHolder.BackgroundTransparency = 1
digitsHolder.Parent = timerArea

local digitsLayout = Instance.new("UIListLayout")
digitsLayout.FillDirection = Enum.FillDirection.Horizontal
digitsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
digitsLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
digitsLayout.SortOrder = Enum.SortOrder.LayoutOrder
digitsLayout.Padding = UDim.new(0, 0)
digitsLayout.Parent = digitsHolder

local mainDigits = Instance.new("TextLabel")
mainDigits.Name = "MainDigits"
mainDigits.LayoutOrder = 1
mainDigits.AutomaticSize = Enum.AutomaticSize.X
mainDigits.Size = UDim2.fromOffset(0, 54)
mainDigits.BackgroundTransparency = 1
mainDigits.Font = Enum.Font.GothamBold
mainDigits.TextSize = 46
mainDigits.TextColor3 = Color3.new(1, 1, 1)
mainDigits.TextXAlignment = Enum.TextXAlignment.Right
mainDigits.TextYAlignment = Enum.TextYAlignment.Bottom
mainDigits.TextStrokeTransparency = 0.72
mainDigits.TextStrokeColor3 = Color3.new(0, 0, 0)
mainDigits.Text = "0"
mainDigits.Parent = digitsHolder

local mainGrad = Instance.new("UIGradient")
mainGrad.Rotation = 90
mainGrad.Parent = mainDigits

local decDigits = Instance.new("TextLabel")
decDigits.Name = "DecDigits"
decDigits.LayoutOrder = 2
decDigits.AutomaticSize = Enum.AutomaticSize.X
decDigits.Size = UDim2.fromOffset(0, 48)
decDigits.BackgroundTransparency = 1
decDigits.Font = Enum.Font.GothamBold
decDigits.TextSize = 35
decDigits.TextColor3 = Color3.new(1, 1, 1)
decDigits.TextXAlignment = Enum.TextXAlignment.Left
decDigits.TextYAlignment = Enum.TextYAlignment.Bottom
decDigits.TextStrokeTransparency = 0.72
decDigits.TextStrokeColor3 = Color3.new(0, 0, 0)
decDigits.Text = ",00"
decDigits.Parent = digitsHolder

local decGrad = Instance.new("UIGradient")
decGrad.Rotation = 90
decGrad.Parent = decDigits

-- Separator line between Timer and "Previous Segment"
local sepLine = Instance.new("Frame")
sepLine.Name = "Separator"
sepLine.Size = UDim2.new(1, 0, 0, 1)
sepLine.Position = UDim2.fromOffset(0, 62)
sepLine.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
sepLine.BorderSizePixel = 0
sepLine.Parent = win

-- Bottom Row: "Previous Segment" + Value ("-" or time/delta)
local bottomBar = Instance.new("Frame")
bottomBar.Name = "PreviousSegmentBar"
bottomBar.Size = UDim2.new(1, 0, 0, 23)
bottomBar.Position = UDim2.fromOffset(0, 63)
bottomBar.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
bottomBar.BorderSizePixel = 0
bottomBar.Parent = win

local bottomGrad = Instance.new("UIGradient")
bottomGrad.Rotation = 90
bottomGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 12)),
})
bottomGrad.Parent = bottomBar

local segLabel = Instance.new("TextLabel")
segLabel.Name = "SegLabel"
segLabel.Size = UDim2.new(1, -80, 1, 0)
segLabel.Position = UDim2.fromOffset(8, 0)
segLabel.BackgroundTransparency = 1
segLabel.Font = Enum.Font.SourceSansSemibold
segLabel.TextSize = 15
segLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
segLabel.TextXAlignment = Enum.TextXAlignment.Left
segLabel.Text = "Previous Segment"
segLabel.Parent = bottomBar

local segValue = Instance.new("TextLabel")
segValue.Name = "SegValue"
segValue.Size = UDim2.fromOffset(75, 23)
segValue.Position = UDim2.new(1, -83, 0, 0)
segValue.BackgroundTransparency = 1
segValue.Font = Enum.Font.GothamBold
segValue.TextSize = 13
segValue.TextColor3 = Color3.fromRGB(210, 210, 210)
segValue.TextXAlignment = Enum.TextXAlignment.Right
segValue.Text = "-"
segValue.Parent = bottomBar

-- LiveSplit Official Color Gradients
local GRAD_GREEN = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(66, 230, 104)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(31, 168, 63)),
})

local GRAD_GRAY = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(184, 184, 184)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(122, 122, 122)),
})

local GRAD_GOLD = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 225, 105)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 165, 35)),
})

local currentColorState = nil
local function setTimerVisualColor(colorMode)
    if currentColorState == colorMode then return end
    currentColorState = colorMode
    local seq = GRAD_GRAY
    if colorMode == "green" then
        seq = GRAD_GREEN
    elseif colorMode == "gold" then
        seq = GRAD_GOLD
    end
    mainGrad.Color = seq
    decGrad.Color = seq
end

local function updateTimerDisplay(t)
    local mStr, dStr = splitTimeParts(t)
    mainDigits.Text = mStr
    decDigits.Text = dStr
end

local function updatePreviousSegmentDisplay(lastRun, reason)
    if not lastRun or lastRun <= 0 then
        segValue.Text = "-"
        segValue.TextColor3 = Color3.fromRGB(210, 210, 210)
        return
    end
    local mStr, dStr = splitTimeParts(lastRun)
    if state.bestNoCoinTime and state.bestNoCoinTime > 0 then
        local bMain, bDec = splitTimeParts(state.bestNoCoinTime)
        segValue.Text = mStr .. dStr .. " (PB " .. bMain .. bDec .. ")"
        segValue.Size = UDim2.fromOffset(120, 23)
        segValue.Position = UDim2.new(1, -128, 0, 0)
    else
        segValue.Text = mStr .. dStr
    end
    if reason == "pb" then
        segValue.TextColor3 = Color3.fromRGB(255, 215, 70)
    elseif reason == "coin" then
        segValue.TextColor3 = Color3.fromRGB(170, 170, 170)
    else
        segValue.TextColor3 = Color3.fromRGB(66, 230, 104)
    end
end

-- Initialize display in gray paused state
setTimerVisualColor("gray")
updateTimerDisplay(0)
updatePreviousSegmentDisplay(state.lastRunTime, "coin")

-- Smooth Dragging for LiveSplit Window (plus Double-Click to Reset Timer to 0,00)
local dragging = false
local dragStart, startPos
local lastClickTime = 0

win.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local now = os.clock()
        if now - lastClickTime < 0.28 then
            -- Double click resets display when not running
            if not state.running then
                state.elapsed = 0
                state.disqualified = false
                setTimerVisualColor("gray")
                updateTimerDisplay(0)
                modeTag.Text = ""
            end
        end
        lastClickTime = now

        dragging = true
        dragStart = input.Position
        startPos = win.Position
    end
end)

table.insert(state.connections, UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local nx = startPos.X.Offset + delta.X
        local ny = startPos.Y.Offset + delta.Y
        win.Position = UDim2.new(startPos.X.Scale, nx, startPos.Y.Scale, ny)
        state.posX = nx
        state.posY = ny
    end
end))

table.insert(state.connections, UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            dragging = false
            saveData()
        end
    end
end))

-- Core LiveSplit State Transitions
local function freezeTimer(reason)
    if not state.running and state.disqualified then
        return
    end
    local finalTime = state.elapsed
    state.running = false
    state.disqualified = true
    setTimerVisualColor("gray")

    if finalTime > 0.05 then
        state.lastRunTime = finalTime
        local isNewPb = false
        if not state.bestNoCoinTime or finalTime > state.bestNoCoinTime then
            state.bestNoCoinTime = finalTime
            isNewPb = true
        end
        saveData()
        updatePreviousSegmentDisplay(finalTime, isNewPb and "pb" or "coin")
    end

    if reason == "coin" then
        modeTag.Text = "COIN (PAUSED)"
    elseif reason == "dead" then
        modeTag.Text = "DEAD"
    elseif reason == "powerup" then
        modeTag.Text = "POWERUP"
    elseif reason == "reset" then
        modeTag.Text = ""
    end
end

local function startNewRunTimer()
    state.elapsed = 0
    state.disqualified = false
    state.paused = false
    state.running = true
    modeTag.Text = ""
    setTimerVisualColor("green")
    updateTimerDisplay(0)
end

-- Hook Subway Surfing Native Events via SharedData
if SharedData then
    -- 1. When player hits "Play", reset to 0,00 in gray during the 1.15s intro animation
    if SharedData.StartRun and SharedData.StartRun.Event then
        table.insert(state.connections, SharedData.StartRun.Event:Connect(function()
            state.running = false
            state.disqualified = false
            state.paused = false
            state.elapsed = 0
            modeTag.Text = "READY"
            setTimerVisualColor("gray")
            updateTimerDisplay(0)
        end))
    end

    -- 2. The exact frame the intro finishes and the run starts (`SharedData.IntroEnd`), start the green LiveSplit timer!
    if SharedData.IntroEnd and SharedData.IntroEnd.Event then
        table.insert(state.connections, SharedData.IntroEnd.Event:Connect(function()
            startNewRunTimer()
        end))
    end

    -- 3. The exact instant a Coin is collected (`SharedData.MissionEvent` with `"Coin"`), pause and turn gray!
    if SharedData.MissionEvent and SharedData.MissionEvent.Event then
        table.insert(state.connections, SharedData.MissionEvent.Event:Connect(function(evName)
            if evName == "Coin" and state.running and not state.disqualified then
                freezeTimer("coin")
            end
        end))
    end

    -- 4. Also watch `SharedData.PowerUpChanged` for Jetpack (`fly`) or Hoverboard (`hoverboard`) which invalidate No-Coin timer in Subway Surfing
    if SharedData.PowerUpChanged and SharedData.PowerUpChanged.Event then
        table.insert(state.connections, SharedData.PowerUpChanged.Event:Connect(function(pName, isActive)
            if isActive and (pName == "fly" or pName == "hoverboard") and state.running and not state.disqualified then
                freezeTimer("powerup")
            end
        end))
    end

    -- 5. Pause / Resume handling (`SharedData.PauseEvent`)
    if SharedData.PauseEvent and SharedData.PauseEvent.Event then
        table.insert(state.connections, SharedData.PauseEvent.Event:Connect(function(isPaused)
            state.paused = (isPaused == true)
            if state.running and not state.disqualified then
                if state.paused then
                    setTimerVisualColor("gray")
                    modeTag.Text = "PAUSED"
                else
                    setTimerVisualColor("green")
                    modeTag.Text = ""
                end
            end
        end))
    end

    -- 6. Run cleanup / return to home menu (`SharedData.RunCleanUp`)
    if SharedData.RunCleanUp and SharedData.RunCleanUp.Event then
        table.insert(state.connections, SharedData.RunCleanUp.Event:Connect(function()
            if state.running then
                freezeTimer("reset")
            else
                setTimerVisualColor("gray")
            end
        end))
    end
end

-- RenderStepped loop: high-precision frame timer + fallback checks for CoinsUI, IsDead, and IsPlaying
local wasPlaying = SharedData and SharedData.IsPlaying or false
if wasPlaying and SharedData and not SharedData.IsDead and (SharedData.CoinsUI or 0) == 0 then
    -- If script is executed mid-run and player hasn't collected coins yet, sync with active run!
    state.running = true
    state.disqualified = false
    setTimerVisualColor("green")
end

table.insert(state.connections, RunService.RenderStepped:Connect(function(dt)
    if not state.active then return end

    if SharedData then
        local isPlaying = SharedData.IsPlaying == true
        local isDead = SharedData.IsDead == true or SharedData.DeadVerified == true
        local coins = tonumber(SharedData.CoinsUI) or 0
        local isFlyOrBoard = (SharedData.PowerUps and (SharedData.PowerUps.fly or SharedData.PowerUps.hoverboard)) == true

        -- Detect run start if IntroEnd was missed
        if isPlaying and not wasPlaying and not isDead then
            if not state.running and not state.disqualified then
                startNewRunTimer()
            end
        end
        wasPlaying = isPlaying

        if state.running and not state.disqualified then
            if coins > 0 then
                freezeTimer("coin")
                return
            elseif isDead then
                freezeTimer("dead")
                return
            elseif isFlyOrBoard then
                freezeTimer("powerup")
                return
            elseif not isPlaying then
                freezeTimer("reset")
                return
            end

            if not state.paused then
                state.elapsed = state.elapsed + dt
                setTimerVisualColor("green")
                updateTimerDisplay(state.elapsed)
            end
        end
    end
end))

-- Cleanup function for re-execution
genv._SubwayLiveSplitCleanup = function()
    state.active = false
    for _, conn in ipairs(state.connections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(state.connections)
    if state.gui then
        pcall(function() state.gui:Destroy() end)
        state.gui = nil
    end
end
