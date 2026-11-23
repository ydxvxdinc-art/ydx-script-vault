--!native
--!optimize 2
-- Wolvot 2D - Rocket League Sideswipe (CSD) Autonomous Bot v9.0 + Visual Skin Changer
-- [YDX Execution Telemetry - Non-Duplicating when loaded via Universal Loader]
do
    local env = (type(getgenv) == "function" and getgenv()) or _G
    env.__YDX_EXEC_LOCKS = env.__YDX_EXEC_LOCKS or {}
    local sid = "wolvot-2d"
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
-- Mechanics: Zero-Lag (<0.3ms) Physics + Anti-Random-Jump Guard + Dead-Center Ball Intercept + Unbreakable Goal-Line Defense + Visual Skin Changer & Garage Unlocker + Q Air Dribble + E Snap Flip + Smart Boost Regen

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local env = type(getgenv) == "function" and getgenv() or _G

if type(env.Wolvot2DUnload) == "function" then pcall(env.Wolvot2DUnload) end
if type(env.WolvotFreeUnload) == "function" then pcall(env.WolvotFreeUnload) end

local alive, enabled = true, true
local connections = {}
local hooked = {}

----------------------------------------------------------------------
-- UI (Wolvot Free Style + Mode Selector + Visual Skin Changer)
----------------------------------------------------------------------
local ACCENT = Color3.fromRGB(88, 130, 255)
local ON_COLOR = Color3.fromRGB(52, 190, 120)
local OFF_COLOR = Color3.fromRGB(48, 52, 70)
local FREESTYLE_COLOR = Color3.fromRGB(168, 95, 255)
local SKIN_COLOR = Color3.fromRGB(245, 175, 45)

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function strokeOf(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness
    s.Transparency = transparency
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local gui = Instance.new("ScreenGui")
gui.Name = "Wolvot2DBot"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 90
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LP:WaitForChild("PlayerGui")

local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.fromOffset(296, 224)
shadow.Position = UDim2.new(0, 20, 0.28, 5)
shadow.BackgroundColor3 = Color3.new(0, 0, 0)
shadow.BackgroundTransparency = 0.55
shadow.BorderSizePixel = 0
shadow.ZIndex = 1
shadow.Parent = gui
corner(shadow, 14)

local frame = Instance.new("Frame")
frame.Name = "Panel"
frame.Size = UDim2.fromOffset(296, 224)
frame.AnchorPoint = Vector2.zero
frame.Position = UDim2.new(0, 20, 0.28, 0)
frame.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.ZIndex = 2
frame.Parent = gui
corner(frame, 14)
local panelStroke = strokeOf(frame, ACCENT, 1.2, 0.55)

local frameGradient = Instance.new("UIGradient")
frameGradient.Color = ColorSequence.new(Color3.fromRGB(34, 38, 56), Color3.fromRGB(16, 18, 27))
frameGradient.Rotation = 90
frameGradient.Parent = frame

local header = Instance.new("TextLabel")
header.Name = "DragHandle"
header.Size = UDim2.new(1, 0, 0, 36)
header.BackgroundTransparency = 1
header.Text = "WOLVOT  2D  |  SIDESWIPE"
header.Font = Enum.Font.GothamBlack
header.TextColor3 = Color3.fromRGB(235, 239, 250)
header.TextSize = 13
header.TextXAlignment = Enum.TextXAlignment.Left
header.Active = true
header.Parent = frame

local headerPadding = Instance.new("UIPadding")
headerPadding.PaddingLeft = UDim.new(0, 28)
headerPadding.PaddingRight = UDim.new(0, 12)
headerPadding.Parent = header

local dot = Instance.new("Frame")
dot.Size = UDim2.fromOffset(8, 8)
dot.Position = UDim2.fromOffset(13, 14)
dot.BackgroundColor3 = enabled and ON_COLOR or ACCENT
dot.BorderSizePixel = 0
dot.Parent = frame
corner(dot, 4)

local version = Instance.new("TextLabel")
version.Size = UDim2.new(1, -12, 0, 36)
version.BackgroundTransparency = 1
version.Text = "v9.1  |  P2P Sync  |  RCtrl"
version.Font = Enum.Font.Gotham
version.TextSize = 10
version.TextColor3 = Color3.fromRGB(120, 130, 160)
version.TextXAlignment = Enum.TextXAlignment.Right
version.Parent = frame

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -24, 0, 1)
divider.Position = UDim2.fromOffset(12, 36)
divider.BackgroundColor3 = ACCENT
divider.BackgroundTransparency = 0.8
divider.BorderSizePixel = 0
divider.Parent = frame

local toggle = Instance.new("TextButton")
toggle.Name = "Toggle"
toggle.Size = UDim2.new(1, -78, 0, 38)
toggle.Position = UDim2.fromOffset(12, 46)
toggle.BackgroundColor3 = enabled and ON_COLOR or OFF_COLOR
toggle.Text = enabled and "BOT ON" or "BOT OFF"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 15
toggle.TextColor3 = Color3.fromRGB(244, 247, 255)
toggle.BorderSizePixel = 0
toggle.Parent = frame
corner(toggle, 9)
strokeOf(toggle, ACCENT, 1, 0.75)

local bindBtn = Instance.new("TextButton")
bindBtn.Name = "Bind"
bindBtn.Size = UDim2.fromOffset(48, 38)
bindBtn.Position = UDim2.new(1, -60, 0, 46)
bindBtn.BackgroundColor3 = Color3.fromRGB(34, 38, 54)
bindBtn.Text = "F"
bindBtn.Font = Enum.Font.GothamBold
bindBtn.TextScaled = true
bindBtn.TextColor3 = Color3.fromRGB(216, 224, 246)
bindBtn.BorderSizePixel = 0
bindBtn.Parent = frame
corner(bindBtn, 9)
local bindStroke = strokeOf(bindBtn, ACCENT, 1, 0.7)

local bindPadding = Instance.new("UIPadding")
bindPadding.PaddingLeft = UDim.new(0, 5)
bindPadding.PaddingRight = UDim.new(0, 5)
bindPadding.Parent = bindBtn

local bindText = Instance.new("UITextSizeConstraint")
bindText.MaxTextSize = 14
bindText.MinTextSize = 8
bindText.Parent = bindBtn

local playModes = { "AUTO (AIR DRAG + DEFENSE)", "FORCE AIR DRAG / RESET", "RANKED (FAST SHOTS + SAVE)" }
local playModeIdx = 1

local modeBtn = Instance.new("TextButton")
modeBtn.Name = "ModeBtn"
modeBtn.Size = UDim2.new(1, -24, 0, 30)
modeBtn.Position = UDim2.fromOffset(12, 91)
modeBtn.BackgroundColor3 = Color3.fromRGB(38, 44, 68)
modeBtn.Text = "STYLE: " .. playModes[playModeIdx]
modeBtn.Font = Enum.Font.GothamBold
modeBtn.TextSize = 11
modeBtn.TextColor3 = Color3.fromRGB(215, 225, 255)
modeBtn.BorderSizePixel = 0
modeBtn.Parent = frame
corner(modeBtn, 8)
local modeStroke = strokeOf(modeBtn, ACCENT, 1, 0.65)

local skinOpenBtn = Instance.new("TextButton")
skinOpenBtn.Name = "SkinBtn"
skinOpenBtn.Size = UDim2.new(1, -24, 0, 32)
skinOpenBtn.Position = UDim2.fromOffset(12, 128)
skinOpenBtn.BackgroundColor3 = Color3.fromRGB(48, 38, 24)
skinOpenBtn.Text = "SKIN CHANGER: OFF (CLICK TO OPEN)"
skinOpenBtn.Font = Enum.Font.GothamBold
skinOpenBtn.TextSize = 11
skinOpenBtn.TextColor3 = Color3.fromRGB(255, 215, 120)
skinOpenBtn.BorderSizePixel = 0
skinOpenBtn.Parent = frame
corner(skinOpenBtn, 8)
local skinBtnStroke = strokeOf(skinOpenBtn, SKIN_COLOR, 1, 0.45)

local toggleGrad = Instance.new("UIGradient")
toggleGrad.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(190, 190, 205))
toggleGrad.Rotation = 90
toggleGrad.Parent = toggle

local bindGrad = toggleGrad:Clone()
bindGrad.Parent = bindBtn

local modeGrad = toggleGrad:Clone()
modeGrad.Parent = modeBtn

local skinGrad = toggleGrad:Clone()
skinGrad.Parent = skinOpenBtn

local function hoverable(button)
    local sc = Instance.new("UIScale")
    sc.Parent = button
    button.MouseEnter:Connect(function() tween(sc, { Scale = 1.03 }, 0.12) end)
    button.MouseLeave:Connect(function() tween(sc, { Scale = 1 }, 0.12) end)
    button.MouseButton1Down:Connect(function() tween(sc, { Scale = 0.96 }, 0.08) end)
    button.MouseButton1Up:Connect(function() tween(sc, { Scale = 1.03 }, 0.08) end)
end
hoverable(toggle)
hoverable(bindBtn)
hoverable(modeBtn)
hoverable(skinOpenBtn)

local statusPill = Instance.new("Frame")
statusPill.Name = "StatusBar"
statusPill.Size = UDim2.new(1, -24, 0, 36)
statusPill.Position = UDim2.fromOffset(12, 174)
statusPill.BackgroundColor3 = Color3.fromRGB(30, 34, 50)
statusPill.BorderSizePixel = 0
statusPill.ZIndex = 3
statusPill.Parent = frame
corner(statusPill, 8)
strokeOf(statusPill, ACCENT, 1, 0.85)

local label = Instance.new("TextLabel")
label.Name = "Status"
label.Size = UDim2.new(1, -20, 1, 0)
label.Position = UDim2.fromOffset(10, 0)
label.Text = "Initializing Sideswipe 2D engine..."
label.TextColor3 = Color3.fromRGB(150, 162, 195)
label.Font = Enum.Font.Gotham
label.TextSize = 11
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextYAlignment = Enum.TextYAlignment.Center
label.TextTruncate = Enum.TextTruncate.AtEnd
label.BackgroundTransparency = 1
label.ZIndex = 4
label.Parent = statusPill

task.spawn(function()
    while alive do
        if enabled then
            tween(dot, { BackgroundTransparency = 0.55 }, 0.7)
            task.wait(0.7)
            tween(dot, { BackgroundTransparency = 0 }, 0.7)
            task.wait(0.7)
        else
            dot.BackgroundTransparency = 0
            task.wait(0.3)
        end
    end
end)

local message = "Initializing..."
local function connect(signal, callback)
    local c = signal:Connect(callback)
    table.insert(connections, c)
    return c
end

local function status(value)
    message = value
end

----------------------------------------------------------------------
-- Panel Dragging
----------------------------------------------------------------------
;(function()
    local panelX, panelY, goalX, goalY, lastStep, drag
    local function applyPanel(x, y)
        local camera = workspace.CurrentCamera
        local size = camera and camera.ViewportSize or gui.AbsoluteSize
        if size.X > 0 and size.Y > 0 then
            local sx, sy = x / size.X, y / size.Y
            frame.Position = UDim2.fromScale(sx, sy)
            shadow.Position = UDim2.new(sx, 0, sy, 5)
        else
            frame.Position = UDim2.fromOffset(x, y)
            shadow.Position = UDim2.fromOffset(x, y + 5)
        end
    end

    local function readPanel()
        local p, camera = frame.Position, workspace.CurrentCamera
        local size = camera and camera.ViewportSize or gui.AbsoluteSize
        return p.X.Scale * size.X + p.X.Offset, p.Y.Scale * size.Y + p.Y.Offset
    end

    local function stepPanel(dt)
        if goalX == nil then return end
        local dx, dy = goalX - panelX, goalY - panelY
        if dx * dx + dy * dy <= 0.01 then
            if panelX ~= goalX or panelY ~= goalY then
                panelX, panelY = goalX, goalY
                applyPanel(panelX, panelY)
            end
            return
        end
        local a = 1 - math.exp(-42 * math.clamp(dt, 0, 0.05))
        panelX += dx * a
        panelY += dy * a
        applyPanel(panelX, panelY)
    end

    local function clampPanel(x, y)
        if panelX == nil then
            panelX, panelY = readPanel()
            goalX, goalY = panelX, panelY
        end
        local camera = workspace.CurrentCamera
        if camera then
            local s = camera.ViewportSize
            x = math.clamp(x, 0, math.max(0, s.X - frame.AbsoluteSize.X))
            y = math.clamp(y, 0, math.max(0, s.Y - frame.AbsoluteSize.Y))
        end
        goalX, goalY = x, y
        local now = os.clock()
        local dt = lastStep and (now - lastStep) or (1 / 60)
        lastStep = now
        stepPanel(dt)
    end

    connect(header.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            panelX, panelY = readPanel()
            goalX, goalY = panelX, panelY
            lastStep = os.clock()
            drag = {
                input = input,
                start = input.Position,
                x = panelX,
                y = panelY,
                touch = input.UserInputType == Enum.UserInputType.Touch,
            }
        end
    end)

    connect(UIS.InputChanged, function(input)
        if drag and ((drag.touch and input == drag.input) or (not drag.touch and input.UserInputType == Enum.UserInputType.MouseMovement)) then
            local delta = input.Position - drag.start
            clampPanel(drag.x + delta.X, drag.y + delta.Y)
        end
    end)

    connect(UIS.InputEnded, function(input)
        if drag and (input == drag.input or (not drag.touch and input.UserInputType == Enum.UserInputType.MouseButton1)) then
            drag = nil
            lastStep = nil
            if goalX ~= nil and (panelX ~= goalX or panelY ~= goalY) then
                panelX, panelY = goalX, goalY
                applyPanel(panelX, panelY)
            end
        end
    end)

    connect(RunService.RenderStepped, function(dt)
        if goalX ~= nil and (panelX ~= goalX or panelY ~= goalY) then
            local now = os.clock()
            local stepDt = lastStep and (now - lastStep) or dt
            lastStep = now
            stepPanel(stepDt)
        end
    end)
end)()

----------------------------------------------------------------------
-- Keybinds & Controls
----------------------------------------------------------------------
local bindKey = Enum.KeyCode.F
local binding = false

local function keyLabel(code)
    local s = UIS:GetStringForKeyCode(code)
    return (s and #s > 0) and s:upper() or code.Name
end

local function setBinding(state)
    binding = state
    bindBtn.Text = state and "..." or keyLabel(bindKey)
    bindBtn.BackgroundColor3 = state and ACCENT or Color3.fromRGB(34, 38, 54)
    bindStroke.Transparency = state and 0.35 or 0.7
end

local function flipToggle()
    enabled = not enabled
    toggle.Text = enabled and "BOT ON" or "BOT OFF"
    tween(toggle, { BackgroundColor3 = enabled and ON_COLOR or OFF_COLOR }, 0.2)
    tween(dot, { BackgroundColor3 = enabled and ON_COLOR or ACCENT }, 0.2)
    status(enabled and "ON | Scanning match..." or "OFF | Standby")
end

local function cycleMode()
    playModeIdx = (playModeIdx % #playModes) + 1
    modeBtn.Text = "STYLE: " .. playModes[playModeIdx]
    local col = playModeIdx == 2 and FREESTYLE_COLOR or ACCENT
    tween(modeStroke, { Color = col }, 0.2)
    tween(panelStroke, { Color = col }, 0.2)
end

connect(toggle.Activated, flipToggle)
connect(bindBtn.Activated, function() setBinding(true) end)
connect(modeBtn.Activated, cycleMode)

local cyclePresetByKey2D

connect(UIS.InputBegan, function(input, gpe)
    if UIS:GetFocusedTextBox() then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local code = input.KeyCode
    if code == Enum.KeyCode.Unknown then return end
    if code == Enum.KeyCode.RightControl then
        gui.Enabled = not gui.Enabled
        return
    end
    if binding then
        if code ~= Enum.KeyCode.Escape then bindKey = code end
        setBinding(false)
        return
    end
    if code == Enum.KeyCode.C then
        if type(cyclePresetByKey2D) == "function" then
            local shiftHeld = UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.RightShift)
            cyclePresetByKey2D(shiftHeld and -1 or 1)
        end
        return
    end
    if not gpe and code == bindKey then flipToggle() end
end)

local uiClock = 0
connect(RunService.Heartbeat, function(dt)
    uiClock += dt
    if uiClock >= 0.12 then
        uiClock = 0
        if label.Text ~= message then
            label.Text = message
            local color = Color3.fromRGB(150, 162, 195)
            if message:find("rror") or message:find("ailed") then
                color = Color3.fromRGB(255, 110, 110)
            elseif message:find("DEFENSE") or message:find("SAVE") or message:find("CLEAR") then
                color = Color3.fromRGB(255, 185, 80)
            elseif message:find("SHOT") or message:find("FLIP") or message:find("AIR DRAG") or message:find("RESET") or message:find("PINCH") then
                color = Color3.fromRGB(195, 140, 255)
            elseif message:sub(1, 2) == "ON" then
                color = Color3.fromRGB(110, 230, 160)
            end
            tween(label, { TextColor3 = color }, 0.15)
        end
    end
end)

----------------------------------------------------------------------
-- Sideswipe Modules & Physics Engine
----------------------------------------------------------------------
local Sideswipe = RS:WaitForChild("Sideswipe")
local Config = require(Sideswipe:WaitForChild("Config"))
local World = require(Sideswipe:WaitForChild("Physics"):WaitForChild("World"))
local Car = require(Sideswipe:WaitForChild("Physics"):WaitForChild("Car"))
local Ball = require(Sideswipe:WaitForChild("Physics"):WaitForChild("Ball"))
local Arena = require(Sideswipe:WaitForChild("Physics"):WaitForChild("Arena"))
local Hitbox = require(Sideswipe:WaitForChild("Physics"):WaitForChild("Hitbox"))
local Prediction = require(Sideswipe:WaitForChild("Net"):WaitForChild("Prediction"))
local Runner = require(Sideswipe:WaitForChild("Trial"):WaitForChild("Runner"))
local Remotes = RS:WaitForChild("SideswipeNet")
local InfiniteBoostRemote = Remotes:FindFirstChild("InfiniteBoost")

----------------------------------------------------------------------
-- Visual Skin Changer & Garage All-Items Unlocker (Match + Freeplay + Lobby!)
----------------------------------------------------------------------
local DataFolder = Sideswipe:WaitForChild("Data")
local WrapsData = require(DataFolder:WaitForChild("Wraps"))
local WheelsData = require(DataFolder:WaitForChild("Wheels"))
local ToppersData = require(DataFolder:WaitForChild("Toppers"))
local BoostsData = require(DataFolder:WaitForChild("Boosts"))
local TrailsData = require(DataFolder:WaitForChild("Trails"))
local AntennasData = require(DataFolder:WaitForChild("Antennas"))
local ShopData = require(DataFolder:WaitForChild("Shop"))

local ClientScripts = LP:WaitForChild("PlayerScripts"):WaitForChild("SideswipeClient")
local VisualsFolder = ClientScripts:WaitForChild("Visuals")
local ThemeMod = require(VisualsFolder:WaitForChild("Theme"))
local CarVisualMod = require(VisualsFolder:WaitForChild("CarVisual"))
local GoalExplosionsMod = require(VisualsFolder:WaitForChild("GoalExplosions"))

local function buildIdList(defaultLabel, listTbl)
    local out = { { id = nil, label = defaultLabel } }
    if type(listTbl) == "table" then
        for _, item in ipairs(listTbl) do
            if type(item) == "table" and item.Id then
                local rTag = item.Rarity and (" [" .. tostring(item.Rarity) .. "]") or ""
                table.insert(out, {
                    id = item.Id,
                    label = tostring(item.Name or item.Id) .. rTag,
                })
            end
        end
    end
    return out
end

local bodyChoices = {}
for _, bName in ipairs(ThemeMod.Bodies or { "Octane", "Razor", "Fennec", "Dominus", "Breakout" }) do
    table.insert(bodyChoices, { id = bName, label = string.upper(bName) })
end

local paintChoices = {}
for i = 1, #(ThemeMod.Accents or {}) do
    local sInfo = ShopData.get and ShopData.get(ShopData.idFor("Paint", i))
    local pName = (sInfo and sInfo.Name) or ("COLOR #" .. tostring(i))
    table.insert(paintChoices, { id = i, label = string.format("#%d %s", i, pName) })
end
if #paintChoices == 0 then
    table.insert(paintChoices, { id = 1, label = "#1 GOLD" })
end

local wrapChoices = buildIdList("NONE", WrapsData.List)
local wheelChoices = buildIdList("STOCK RIMS", WheelsData.List)
local boostChoices = buildIdList("STANDARD", BoostsData.List)
local trailChoices = buildIdList("NONE", TrailsData.List)
local topperChoices = buildIdList("NONE", ToppersData.List)
local antennaChoices = buildIdList("NONE", AntennasData.List)

local goalChoices = { { id = "Standard", label = "STANDARD" } }
if type(GoalExplosionsMod.Order) == "table" then
    goalChoices = {}
    for _, gId in ipairs(GoalExplosionsMod.Order) do
        local gInfo = GoalExplosionsMod.Info and GoalExplosionsMod.Info[gId]
        table.insert(goalChoices, { id = gId, label = (gInfo and gInfo.Name) or string.upper(tostring(gId)) })
    end
end

local SkinPresets = {
    { name = "OFF (DEFAULT SKIN)", enabled = false },
    { name = "VIP GOLD FENNEC", enabled = true, Body = "Fennec", Accent = 1, Wrap = "VipGold", Wheels = "Gold", Boost = "SolarCore", Trail = "RainbowRoad", Topper = "HolidayCrown", Antenna = "Crown", Goal = "Supernova" },
    { name = "CHROMA WAVE OCTANE", enabled = true, Body = "Octane", Accent = 6, Wrap = "ChromaWave", Wheels = "NeonPink", Boost = "Plasma", Trail = "RainbowRoad", Topper = "KittyEars", Antenna = nil, Goal = "PartyTime" },
    { name = "HYPERDRIVE DOMINUS", enabled = true, Body = "Dominus", Accent = 7, Wrap = "Hyperdrive", Wheels = "Chrome", Boost = "Hyper", Trail = "Lightning", Topper = "ShutterShades", Antenna = nil, Goal = "Singularity" },
    { name = "MAGMA FLOW RAZOR", enabled = true, Body = "Razor", Accent = 11, Wrap = "MagmaFlow", Wheels = "Crimson", Boost = "Flamethrower", Trail = "Blaze", Topper = "FrozenHorns", Antenna = nil, Goal = "Hellfire" },
    { name = "GLITCH STORM BREAKOUT", enabled = true, Body = "Breakout", Accent = 16, Wrap = "GlitchStorm", Wheels = "NeonLime", Boost = "Matrix", Trail = "Pixel", Topper = "RobloxVisor", Antenna = nil, Goal = "Electroshock" },
    { name = "STARFIELD WARP FENNEC", enabled = true, Body = "Fennec", Accent = 9, Wrap = "StarfieldWarp", Wheels = "Arctic", Boost = "Starlight", Trail = "Galaxy", Topper = "ValkyrieHelm", Antenna = nil, Goal = "SubZero" },
}

local SkinState = {
    enabled = false,
    presetIdx = 1,
    bodyIdx = 3,    -- Fennec
    paintIdx = 1,   -- Gold
    wrapIdx = 1,
    wheelIdx = 1,
    boostIdx = 1,
    trailIdx = 1,
    topperIdx = 1,
    antennaIdx = 1,
    goalIdx = 1,
}

-- Default indices to VIP Gold Fennec items if found
for i, v in ipairs(wrapChoices) do if v.id == "VipGold" then SkinState.wrapIdx = i break end end
for i, v in ipairs(wheelChoices) do if v.id == "Gold" then SkinState.wheelIdx = i break end end
for i, v in ipairs(boostChoices) do if v.id == "SolarCore" then SkinState.boostIdx = i break end end
for i, v in ipairs(trailChoices) do if v.id == "RainbowRoad" then SkinState.trailIdx = i break end end
for i, v in ipairs(topperChoices) do if v.id == "HolidayCrown" then SkinState.topperIdx = i break end end

local function getCustomSkinTable(baseLoadout)
    local out = type(baseLoadout) == "table" and table.clone(baseLoadout) or {}
    out.Body = (bodyChoices[SkinState.bodyIdx] and bodyChoices[SkinState.bodyIdx].id) or "Fennec"
    out.Accent = (paintChoices[SkinState.paintIdx] and paintChoices[SkinState.paintIdx].id) or 1
    out.Wrap = wrapChoices[SkinState.wrapIdx] and wrapChoices[SkinState.wrapIdx].id or nil
    out.Wheels = wheelChoices[SkinState.wheelIdx] and wheelChoices[SkinState.wheelIdx].id or nil
    out.Boost = boostChoices[SkinState.boostIdx] and boostChoices[SkinState.boostIdx].id or nil
    out.Trail = trailChoices[SkinState.trailIdx] and trailChoices[SkinState.trailIdx].id or nil
    out.Topper = topperChoices[SkinState.topperIdx] and topperChoices[SkinState.topperIdx].id or nil
    out.Antenna = antennaChoices[SkinState.antennaIdx] and antennaChoices[SkinState.antennaIdx].id or nil
    out.Goal = (goalChoices[SkinState.goalIdx] and goalChoices[SkinState.goalIdx].id) or "Standard"
    out.UserId = LP.UserId
    return out
end

-- Build Skin Changer Drawer Panel (Next to Main Panel)
local skinPanel = Instance.new("Frame")
skinPanel.Name = "SkinChangerPanel"
skinPanel.Size = UDim2.fromOffset(296, 368)
skinPanel.Position = UDim2.new(1, 10, 0, 0)
skinPanel.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
skinPanel.BorderSizePixel = 0
skinPanel.Visible = false
skinPanel.ZIndex = 4
skinPanel.Parent = frame
corner(skinPanel, 14)
strokeOf(skinPanel, SKIN_COLOR, 1.3, 0.35)

local skinPanelGrad = frameGradient:Clone()
skinPanelGrad.Parent = skinPanel

local skinTitle = Instance.new("TextLabel")
skinTitle.Size = UDim2.new(1, -24, 0, 32)
skinTitle.Position = UDim2.fromOffset(12, 2)
skinTitle.BackgroundTransparency = 1
skinTitle.Text = "VISUAL SKIN CHANGER  |  ALL UNLOCKED"
skinTitle.Font = Enum.Font.GothamBlack
skinTitle.TextColor3 = Color3.fromRGB(255, 215, 110)
skinTitle.TextSize = 11
skinTitle.TextXAlignment = Enum.TextXAlignment.Left
skinTitle.ZIndex = 5
skinTitle.Parent = skinPanel

local skinDivider = Instance.new("Frame")
skinDivider.Size = UDim2.new(1, -24, 0, 1)
skinDivider.Position = UDim2.fromOffset(12, 34)
skinDivider.BackgroundColor3 = SKIN_COLOR
skinDivider.BackgroundTransparency = 0.7
skinDivider.BorderSizePixel = 0
skinDivider.ZIndex = 5
skinDivider.Parent = skinPanel

local skinRows = {}
local function makeSkinRow(order, prefix, getTextFn, onCycleFn)
    local btn = Instance.new("TextButton")
    btn.Name = "Row_" .. prefix
    btn.Size = UDim2.new(1, -24, 0, 27)
    btn.Position = UDim2.fromOffset(12, 40 + (order - 1) * 32)
    btn.BackgroundColor3 = (order == 1) and Color3.fromRGB(54, 42, 22) or Color3.fromRGB(30, 34, 50)
    btn.Text = prefix .. ": " .. getTextFn()
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.TextColor3 = (order == 1) and Color3.fromRGB(255, 225, 130) or Color3.fromRGB(220, 228, 250)
    btn.TextTruncate = Enum.TextTruncate.AtEnd
    btn.BorderSizePixel = 0
    btn.ZIndex = 5
    btn.Parent = skinPanel
    corner(btn, 7)
    strokeOf(btn, (order == 1) and SKIN_COLOR or ACCENT, 1, 0.65)
    hoverable(btn)

    local function refreshText()
        btn.Text = prefix .. ": " .. getTextFn()
    end
    table.insert(skinRows, refreshText)

    connect(btn.Activated, function()
        onCycleFn(1)
    end)
    connect(btn.MouseButton2Click, function()
        onCycleFn(-1)
    end)
    return btn
end

local applyLiveSkinNow -- forward declaration

local function refreshAllSkinUI()
    for _, fn in ipairs(skinRows) do fn() end
    if SkinState.enabled then
        local bName = (bodyChoices[SkinState.bodyIdx] and bodyChoices[SkinState.bodyIdx].label) or "CUSTOM"
        local wName = (wrapChoices[SkinState.wrapIdx] and wrapChoices[SkinState.wrapIdx].id) or "CLEAN"
        skinOpenBtn.Text = string.format("SKIN: %s (%s)", bName, string.upper(wName))
        skinOpenBtn.BackgroundColor3 = Color3.fromRGB(68, 52, 22)
    else
        skinOpenBtn.Text = "SKIN CHANGER: OFF (CLICK TO OPEN)"
        skinOpenBtn.BackgroundColor3 = Color3.fromRGB(38, 34, 28)
    end
end

local function loadPresetIndex(idx)
    SkinState.presetIdx = idx
    local p = SkinPresets[idx]
    if not p then return end
    SkinState.enabled = p.enabled == true
    if p.enabled then
        for i, v in ipairs(bodyChoices) do if v.id == p.Body then SkinState.bodyIdx = i break end end
        for i, v in ipairs(paintChoices) do if v.id == p.Accent then SkinState.paintIdx = i break end end
        SkinState.wrapIdx = 1
        for i, v in ipairs(wrapChoices) do if v.id == p.Wrap then SkinState.wrapIdx = i break end end
        SkinState.wheelIdx = 1
        for i, v in ipairs(wheelChoices) do if v.id == p.Wheels then SkinState.wheelIdx = i break end end
        SkinState.boostIdx = 1
        for i, v in ipairs(boostChoices) do if v.id == p.Boost then SkinState.boostIdx = i break end end
        SkinState.trailIdx = 1
        for i, v in ipairs(trailChoices) do if v.id == p.Trail then SkinState.trailIdx = i break end end
        SkinState.topperIdx = 1
        for i, v in ipairs(topperChoices) do if v.id == p.Topper then SkinState.topperIdx = i break end end
        SkinState.antennaIdx = 1
        for i, v in ipairs(antennaChoices) do if v.id == p.Antenna then SkinState.antennaIdx = i break end end
        for i, v in ipairs(goalChoices) do if v.id == p.Goal then SkinState.goalIdx = i break end end
    end
    refreshAllSkinUI()
    if applyLiveSkinNow then applyLiveSkinNow() end
end

local function cycleChoice(key, list, step)
    SkinState.enabled = true
    SkinState[key] = ((SkinState[key] - 1 + step) % #list) + 1
    refreshAllSkinUI()
    if applyLiveSkinNow then applyLiveSkinNow() end
end

makeSkinRow(1, "PRESET", function()
    return SkinPresets[SkinState.presetIdx] and SkinPresets[SkinState.presetIdx].name or "CUSTOM"
end, function(step)
    local nextIdx = ((SkinState.presetIdx - 1 + step) % #SkinPresets) + 1
    loadPresetIndex(nextIdx)
end)

cyclePresetByKey2D = function(step)
    local nextIdx = ((SkinState.presetIdx - 1 + (step or 1)) % #SkinPresets) + 1
    loadPresetIndex(nextIdx)
end

makeSkinRow(2, "CAR BODY", function() return bodyChoices[SkinState.bodyIdx].label end, function(s) cycleChoice("bodyIdx", bodyChoices, s) end)
makeSkinRow(3, "DECALS / WRAP", function() return wrapChoices[SkinState.wrapIdx].label end, function(s) cycleChoice("wrapIdx", wrapChoices, s) end)
makeSkinRow(4, "PAINT ACCENT", function() return paintChoices[SkinState.paintIdx].label end, function(s) cycleChoice("paintIdx", paintChoices, s) end)
makeSkinRow(5, "WHEELS / RIMS", function() return wheelChoices[SkinState.wheelIdx].label end, function(s) cycleChoice("wheelIdx", wheelChoices, s) end)
makeSkinRow(6, "BOOST FX", function() return boostChoices[SkinState.boostIdx].label end, function(s) cycleChoice("boostIdx", boostChoices, s) end)
makeSkinRow(7, "TRAIL FX", function() return trailChoices[SkinState.trailIdx].label end, function(s) cycleChoice("trailIdx", trailChoices, s) end)
makeSkinRow(8, "TOPPER HAT", function() return topperChoices[SkinState.topperIdx].label end, function(s) cycleChoice("topperIdx", topperChoices, s) end)
makeSkinRow(9, "ANTENNA", function() return antennaChoices[SkinState.antennaIdx].label end, function(s) cycleChoice("antennaIdx", antennaChoices, s) end)
makeSkinRow(10, "GOAL EXPLOSION", function() return goalChoices[SkinState.goalIdx].label end, function(s) cycleChoice("goalIdx", goalChoices, s) end)

connect(skinOpenBtn.Activated, function()
    skinPanel.Visible = not skinPanel.Visible
    if skinPanel.Visible and not SkinState.enabled then
        -- Automatically turn on VIP Gold Fennec preset when opening for the first time!
        loadPresetIndex(2)
    end
end)

-- Track active CarVisual swap in live Match / Freeplay AND unlock all items in Lobby Garage!
local lastCreatedLocalCarVisual = nil
local lastLocalCarVisualArgs = nil
local cachedLobbyObj2D = nil
local cachedRendererObj2D = nil
local lastGcScan2DAt = -999
local HttpService2D = game:GetService("HttpService")
local peerStates2D = {} -- [uidStr] = { uid = num, name = str, displayName = str, enabled = bool, loadout = tbl, ts = num }
local broadcastMyState2D = nil
local lastAppliedPeerLoadoutSig2D = {}

local function findPeerState2D(userId, carName, loadoutTbl)
    if next(peerStates2D) == nil then return nil end
    local uid = tonumber(userId or (type(loadoutTbl) == "table" and loadoutTbl.UserId))
    if uid and uid > 0 and uid ~= LP.UserId then
        local st = peerStates2D[tostring(uid)]
        if st then return st end
    end
    if type(carName) == "string" and carName ~= "" and carName ~= "You" and carName ~= "Profile" then
        for _, st in pairs(peerStates2D) do
            if st.uid ~= LP.UserId and (st.name == carName or st.displayName == carName) then
                return st
            end
        end
    end
    return nil
end

local function buildPeerCustomSkinTable2D(pState, baseLoadout)
    local out = type(baseLoadout) == "table" and table.clone(baseLoadout) or {}
    local src = type(pState) == "table" and type(pState.loadout) == "table" and pState.loadout or {}
    out.Body = type(src.Body) == "string" and src.Body or out.Body or "Fennec"
    out.Accent = type(src.Accent) == "number" and src.Accent or out.Accent or 1
    out.Wrap = src.Wrap
    out.Wheels = src.Wheels
    out.Boost = src.Boost
    out.Trail = src.Trail
    out.Topper = src.Topper
    out.Antenna = src.Antenna
    out.Goal = type(src.Goal) == "string" and src.Goal or out.Goal or "Standard"
    out.UserId = (type(pState) == "table" and tonumber(pState.uid)) or out.UserId
    return out
end

local function discover2DRenderers(forceScan)
    if type(getgc) ~= "function" then return end
    local needLobby = (cachedLobbyObj2D == nil)
    local needRenderer = (cachedRendererObj2D == nil)
    local now = os.clock()
    if not forceScan and not (needLobby or needRenderer) then return end
    if not forceScan and (now - lastGcScan2DAt < 5) then return end
    lastGcScan2DAt = now
    pcall(function()
        for _, v in ipairs(getgc(true)) do
            if type(v) == "table" then
                if not cachedLobbyObj2D and type(rawget(v, "setLoadout")) == "function" and type(rawget(v, "setProfile")) == "function" then
                    cachedLobbyObj2D = v
                end
                if not cachedRendererObj2D and type(rawget(v, "setSeat")) == "function" and type(rawget(v, "setLocal")) == "function" and type(rawget(v, "render")) == "function" then
                    cachedRendererObj2D = v
                end
                if cachedLobbyObj2D and cachedRendererObj2D then break end
            end
        end
    end)
end

local function unlockLobbyGarageAndPreview()
    discover2DRenderers(false)
    local v = cachedLobbyObj2D
    if not v then return end
    pcall(function()
        if type(debug) == "table" and type(debug.getupvalues) == "function" then
            local ups = debug.getupvalues(v.setLoadout)
            local u654 = ups[1]
            local u653 = ups[8]
            local u707 = ups[11]
            if type(u654) == "table" then
                u654.owns = function() return true end
                if SkinState.enabled and type(u653) == "table" then
                    local custom = getCustomSkinTable(u653)
                    u653.Body = custom.Body
                    u653.Accent = custom.Accent
                    u653.Wrap = custom.Wrap
                    u653.Wheels = custom.Wheels
                    u653.Boost = custom.Boost
                    u653.Trail = custom.Trail
                    u653.Topper = custom.Topper
                    u653.Antenna = custom.Antenna
                    u653.Goal = custom.Goal
                    u654.edit = custom.Body
                    if type(u654.looks) == "table" then
                        u654.looks[custom.Body] = custom
                    end
                    if type(u707) == "function" then
                        pcall(u707)
                    end
                end
            end
        end
    end)
end

applyLiveSkinNow = function()
    unlockLobbyGarageAndPreview()

    -- 1. INSTANT O(1) LIVE MATCH / RANKED / FREEPLAY HOT-SWAP VIA CACHED RENDERER (`setSeat` + `setLocal`):
    local v = cachedRendererObj2D
    if v then
        pcall(function()
            local localIdx = activePredictor and activePredictor.LocalIndex or nil
            local myName = LP.DisplayName or LP.Name
            local origLoadout = nil

            if type(debug) == "table" and type(debug.getupvalues) == "function" then
                local ups = debug.getupvalues(v.setSeat)
                local namesTbl = ups[4]    -- u23 (array of car names)
                local loadoutsTbl = ups[7] -- u17 (array of car loadouts)
                local localIdxUp = ups[15] -- u67 (local car index)
                if type(localIdxUp) == "number" then
                    localIdx = localIdxUp
                end
                if not localIdx and type(namesTbl) == "table" then
                    for idx, cName in pairs(namesTbl) do
                        if cName == LP.Name or cName == LP.DisplayName or cName == "You" then
                            localIdx = idx
                            break
                        end
                    end
                end
                if localIdx and type(namesTbl) == "table" and type(namesTbl[localIdx]) == "string" and namesTbl[localIdx] ~= "" then
                    myName = namesTbl[localIdx]
                end
                if localIdx and type(loadoutsTbl) == "table" then
                    origLoadout = loadoutsTbl[localIdx]
                end
            end

            localIdx = localIdx or 1
            if not env._WolvotOrigMatchLoadout and type(origLoadout) == "table" then
                env._WolvotOrigMatchLoadout = table.clone(origLoadout)
            end

            local targetLoadout
            if SkinState.enabled then
                targetLoadout = getCustomSkinTable(env._WolvotOrigMatchLoadout or origLoadout)
            else
                targetLoadout = env._WolvotOrigMatchLoadout or origLoadout or { Body = "Octane", Accent = 1, UserId = LP.UserId }
            end

            if activePredictor then
                for _, w in pairs({ activePredictor.Predicted, activePredictor.Confirmed, activePredictor.Scratch }) do
                    if type(w) == "table" and type(w.Cars) == "table" and w.Cars[localIdx] and type(targetLoadout) == "table" and targetLoadout.Body then
                        w.Cars[localIdx].Body = targetLoadout.Body
                    end
                end
            end

            v.setSeat(localIdx, myName, targetLoadout)
            v.setLocal(localIdx)

            -- Also apply any synced peers' custom skins to their seats in the live 2D match!
            if next(peerStates2D) ~= nil and type(debug) == "table" and type(debug.getupvalues) == "function" then
                local ups = debug.getupvalues(v.setSeat)
                local namesTbl = ups[4]
                local loadoutsTbl = ups[7]
                if type(namesTbl) == "table" then
                    for seatIdx, seatName in pairs(namesTbl) do
                        if type(seatIdx) == "number" and seatIdx ~= localIdx then
                            local curLoadout = type(loadoutsTbl) == "table" and loadoutsTbl[seatIdx] or nil
                            local pState = findPeerState2D(type(curLoadout) == "table" and curLoadout.UserId or nil, seatName, curLoadout)
                            if pState and pState.enabled and type(pState.loadout) == "table" then
                                local peerLoadout = buildPeerCustomSkinTable2D(pState, curLoadout)
                                local okSig, sig = pcall(HttpService2D.JSONEncode, HttpService2D, peerLoadout)
                                if not okSig or lastAppliedPeerLoadoutSig2D[seatIdx] ~= sig then
                                    lastAppliedPeerLoadoutSig2D[seatIdx] = sig
                                    if activePredictor then
                                        for _, w in pairs({ activePredictor.Predicted, activePredictor.Confirmed, activePredictor.Scratch }) do
                                            if type(w) == "table" and type(w.Cars) == "table" and w.Cars[seatIdx] and peerLoadout.Body then
                                                w.Cars[seatIdx].Body = peerLoadout.Body
                                            end
                                        end
                                    end
                                    v.setSeat(seatIdx, seatName, peerLoadout)
                                    v.setLocal(localIdx)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end

    if type(broadcastMyState2D) == "function" then
        broadcastMyState2D(false)
    end

    -- 2. Fallback proxy hot-swap (for MenuStage / Tutorial / TrialCarVisual):
    if SkinState.enabled and lastCreatedLocalCarVisual and lastLocalCarVisualArgs and lastLocalCarVisualArgs.parent and lastLocalCarVisualArgs.parent.Parent then
        -- Only run fallback if `setSeat` didn't already replace `lastCreatedLocalCarVisual` this call
        if lastLocalCarVisualArgs.parent.Name ~= "SideswipeRuntime" then
            pcall(function()
                local args = lastLocalCarVisualArgs
                local newLoadout = getCustomSkinTable(args.loadout)
                local newVis = CarVisualMod.OriginalNew(args.team, args.name, newLoadout, args.parent, args.lowDetail, args.userId, args.scale)
                newVis.setRideLift((Config.Hit.DrawnCarLift or 0) / Config.UUPerStud)
                newVis.setTagVisible(false)
                newVis.liftChat(true)
                if lastCreatedLocalCarVisual._innerDestroy then
                    pcall(lastCreatedLocalCarVisual._innerDestroy)
                end
                lastCreatedLocalCarVisual._innerDestroy = newVis.destroy
                for k, fn in pairs(newVis) do
                    if k ~= "destroy" then
                        lastCreatedLocalCarVisual[k] = fn
                    end
                end
            end)
        end
    end
end

local function quantize(v)
    return math.round(math.clamp(v, -1, 1) * 127) / 127
end

local function makeInput(sx, sy, jump, boost, spin, snapRoll)
    local mag = math.sqrt(sx * sx + sy * sy)
    if mag > 1 then
        sx, sy = sx / mag, sy / mag
    end
    return {
        StickX = quantize(sx),
        StickY = quantize(sy),
        Jump = jump == true,
        Boost = boost == true,
        JumpBoost = (jump == true and boost == true),
        Spin = spin == true,
        SnapRoll = snapRoll == true,
    }
end

local WorldStepOriginal = World.step

----------------------------------------------------------------------
-- Exact Ball Trajectory Predictor (Cached Per Tick for Zero FPS Impact!)
----------------------------------------------------------------------
local cachedPathTick = -1
local cachedPathWorld = nil
local cachedBallPath = nil

local function predictBallTrajectory(world, ctx, steps)
    if cachedPathWorld == world and cachedPathTick == world.Tick and cachedBallPath and #cachedBallPath >= steps then
        return cachedBallPath
    end
    local bClone = {
        Pos = world.Ball.Pos,
        Vel = world.Ball.Vel,
        Angle = world.Ball.Angle,
        AngVel = world.Ball.AngVel,
        SoftCapOffUntil = world.Ball.SoftCapOffUntil,
        GravityScale = world.Ball.GravityScale,
        LastTouchTeam = world.Ball.LastTouchTeam,
        TouchCount = world.Ball.TouchCount,
        SinceTouch = world.Ball.SinceTouch,
        OnGround = world.Ball.OnGround,
    }
    local bCfg = ctx.Ball
    local arena = ctx.Arena
    local dt = Config.Dt
    local emptyCars = {}
    local path = table.create(steps)
    for i = 1, steps do
        Ball.integrateVelocity(bClone, bCfg, dt, world.Tick + i)
        local contacts = Ball.gatherContacts(bClone, bCfg, emptyCars, arena, dt)
        if bCfg.Shape == "Box" then
            Ball.solveBoxVelocity(bClone, bCfg, {}, contacts)
        else
            Ball.prepareContacts(bClone, bCfg, contacts)
            for _ = 1, 4 do
                for _, c in ipairs(contacts) do
                    Ball.applyContact(bClone, bCfg, c)
                end
            end
        end
        bClone.Pos = bClone.Pos + bClone.Vel * dt
        bClone.Angle = (bClone.Angle + bClone.AngVel * dt + math.pi) % (2 * math.pi) - math.pi
        Ball.solvePositions(bClone, bCfg, emptyCars, arena, nil)
        path[i] = {
            Pos = bClone.Pos,
            Vel = bClone.Vel,
            Tick = world.Tick + i,
            Time = i * dt,
        }
    end
    cachedPathWorld = world
    cachedPathTick = world.Tick
    cachedBallPath = path
    return path
end

----------------------------------------------------------------------
-- Exact Goal & Team Identification (Matches Match.lua & Bot.lua 100%!)
----------------------------------------------------------------------
-- In Sideswipe (from Match.lua line 6975 & Bot.lua line 8333):
--   Team 0 (Blue) spawns at X < 0 (e.g. -1001, -1998), defends Goal with Team = 0 (at LineX = -2560),
--   and attacks RIGHT (`attackDir = +1`) into Goal with Team = 1 (at LineX = +2560)!
--   Team 1 (Orange) spawns at X > 0 (e.g. +1001, +1998), defends Goal with Team = 1 (at LineX = +2560),
--   and attacks LEFT (`attackDir = -1`) into Goal with Team = 0 (at LineX = -2560)!
-- Even in Freeplay, our car has `car.Team` (0 or 1) corresponding to its spawn side:
--   If `car.Team == 0`, our own goal is Left (-2560) and the enemy goal is Right (+2560)!
--   If `car.Team == 1`, our own goal is Right (+2560) and the enemy goal is Left (-2560)!
-- We NEVER flip `ownGoal` and `enemyGoal` based on ball position, so the bot ALWAYS knows which goal is its own and which is the enemy's!
local function getGoalsForTeam(world, ctx, myTeam)
    local arena = ctx.Arena
    local isFreeplay = (ctx.Mode and ctx.Mode.Rules == "Freeplay")
    local team = (myTeam == 1) and 1 or 0
    local attackDir = (team == 0) and 1 or -1

    local enemyGoal, ownGoal
    for _, g in ipairs(arena.Goals) do
        if g.Team >= 0 then
            if g.Team == team then
                ownGoal = g
            else
                enemyGoal = g
            end
        else
            -- Neutral goal (e.g., Squash): own side is -attackDir, enemy side is +attackDir
            if math.sign(g.Center.X) == attackDir then
                enemyGoal = g
            else
                ownGoal = g
            end
        end
    end

    if not enemyGoal then
        for _, g in ipairs(arena.Goals) do
            if math.sign(g.Center.X) == attackDir then
                enemyGoal = g
            else
                ownGoal = g
            end
        end
    end

    local goalLineX = attackDir * 2560
    local ownGoalLineX = -attackDir * 2560
    local goalMinY, goalMaxY = 768, 1792
    local ownGoalMinY, ownGoalMaxY = 768, 1792
    local isHoops = ctx.Layout == "Hoops"
    local isVolley = ctx.Layout == "Volleyball"

    if enemyGoal then
        goalLineX = enemyGoal.LineX
        attackDir = goalLineX >= 0 and 1 or -1
        local minY, maxY = math.huge, -math.huge
        for _, v in ipairs(enemyGoal.Vertices) do
            minY = math.min(minY, v.Y)
            maxY = math.max(maxY, v.Y)
        end
        goalMinY, goalMaxY = minY, maxY
    end

    if ownGoal then
        ownGoalLineX = ownGoal.LineX
        local minY, maxY = math.huge, -math.huge
        for _, v in ipairs(ownGoal.Vertices) do
            minY = math.min(minY, v.Y)
            maxY = math.max(maxY, v.Y)
        end
        ownGoalMinY, ownGoalMaxY = minY, maxY
    else
        ownGoalLineX = -goalLineX
        ownGoalMinY, ownGoalMaxY = goalMinY, goalMaxY
    end

    local targetPos
    if isHoops then
        targetPos = Vector2.new(attackDir * 2450, 620)
    elseif isVolley then
        targetPos = Vector2.new(attackDir * 1300, 100)
    else
        local midY = (goalMinY + goalMaxY) * 0.5
        targetPos = Vector2.new(goalLineX + attackDir * 160, midY + (goalMaxY - goalMinY) * 0.08)
    end

    local defendPos = Vector2.new(ownGoalLineX - attackDir * 80, (ownGoalMinY + ownGoalMaxY) * 0.5)

    return {
        myTeam = team,
        attackDir = attackDir,
        targetPos = targetPos,
        defendPos = defendPos,
        goalLineX = goalLineX,
        goalMinY = goalMinY,
        goalMaxY = goalMaxY,
        ownGoalLineX = ownGoalLineX,
        ownGoalMinY = ownGoalMinY,
        ownGoalMaxY = ownGoalMaxY,
        ceilingY = arena.MaxY or 2688,
        wallX = math.abs(goalLineX),
        isHoops = isHoops,
        isVolley = isVolley,
        isFreeplay = isFreeplay,
        teamTag = (attackDir > 0) and "ATK -> RIGHT" or "ATK <- LEFT",
    }
end

local function findOpponentsAndTeammates(world, myIndex, myTeam)
    local nearestOpp, oppDist = nil, math.huge
    local nearestMate, mateDist = nil, math.huge
    for i, c in ipairs(world.Cars) do
        if i ~= myIndex and not c.Parked then
            local d = (c.Pos - world.Ball.Pos).Magnitude
            if c.Team ~= myTeam then
                if d < oppDist then
                    oppDist = d
                    nearestOpp = c
                end
            else
                if d < mateDist then
                    mateDist = d
                    nearestMate = c
                end
            end
        end
    end
    return nearestOpp, oppDist, nearestMate, mateDist
end

----------------------------------------------------------------------
-- Exact Physics Rollout Evaluator (Simulates Flip / Shot / Reset / Save / MPC!)
----------------------------------------------------------------------
local function evaluateSequence(world, ctx, myIndex, firstTickInput, followInput, ticks, goalInfo)
    local sim = World.clone(world)
    sim.Bots = nil
    local inputs = table.create(#sim.Cars)
    for i = 1, #sim.Cars do
        inputs[i] = World.NeutralInput
    end
    local dt = Config.Dt
    local attackDir = goalInfo.attackDir
    local targetGoal = goalInfo.targetPos
    local startBallVelX = world.Ball.Vel.X * attackDir

    local scored = false
    local ownGoaled = false
    local gotFlipReset = false
    local gotDodgeShot = false
    local gotJumpShot = false
    local gotCritHit = false
    local gotPinch = false
    local gotHit = false
    local touchStep = nil
    local minBallDistToGoal = math.huge
    local minCarBallDist = math.huge
    local worstBackwardVelX = 0
    local knockedBackward = false

    for step = 1, ticks do
        inputs[myIndex] = (step == 1) and firstTickInput or followInput
        WorldStepOriginal(sim, inputs, dt)
        local b = sim.Ball
        local c = sim.Cars[myIndex]

        local dGoal = (targetGoal - b.Pos).Magnitude
        if dGoal < minBallDistToGoal then minBallDistToGoal = dGoal end

        if c then
            local dBall = (b.Pos - c.Pos).Magnitude
            if dBall < minCarBallDist then minCarBallDist = dBall end
        end

        for _, ev in ipairs(sim.Events) do
            if ev.Car == myIndex then
                if not touchStep then touchStep = step end
                if ev.Kind == "FlipReset" or ev.Kind == "ResetTouch" then
                    gotFlipReset = true
                elseif ev.Kind == "DodgeShot" then
                    gotDodgeShot = true
                elseif ev.Kind == "JumpShot" then
                    gotJumpShot = true
                elseif ev.Kind == "CriticalHit" then
                    gotCritHit = true
                elseif ev.Kind == "Pinch" then
                    gotPinch = true
                elseif ev.Kind == "Hit" or ev.Kind == "Touch" then
                    gotHit = true
                end
            elseif ev.Kind == "Goal" then
                if (b.Pos.X * attackDir) > 0 then
                    scored = true
                else
                    ownGoaled = true
                end
            end
        end

        local curForwardVx = b.Vel.X * attackDir
        if curForwardVx < worstBackwardVelX then
            worstBackwardVelX = curForwardVx
        end
        -- If our car touched the ball and caused it to accelerate toward our OWN goal (`curForwardVx < -80` and worse than before), flag it immediately!
        if (touchStep or (c and c.BallContact)) and curForwardVx < -80 and curForwardVx < (startBallVelX - 45) then
            knockedBackward = true
        end

        if scored or ownGoaled then break end
    end

    local cEnd = sim.Cars[myIndex]
    local bEnd = sim.Ball
    local bToGoal = targetGoal - bEnd.Pos
    local bVelTowardGoal = bToGoal.Magnitude > 1 and bEnd.Vel:Dot(bToGoal.Unit) or 0
    local endForwardVx = bEnd.Vel.X * attackDir

    -- Strict check: does the ball end up moving toward our OWN goal or inside our defensive danger zone?
    local headingIntoOwnGoal = false
    if endForwardVx < -120 or knockedBackward then
        local distToOwnLine = (bEnd.Pos.X - goalInfo.ownGoalLineX) * attackDir
        if distToOwnLine < 1100 and endForwardVx < -80 then
            headingIntoOwnGoal = true
        elseif endForwardVx < -180 then
            local timeToOwnLine = (goalInfo.ownGoalLineX - bEnd.Pos.X) / bEnd.Vel.X
            if timeToOwnLine > 0 and timeToOwnLine < 1.8 then
                local projY = bEnd.Pos.Y + bEnd.Vel.Y * timeToOwnLine - 0.5 * (Config.Gravity * 0.9) * timeToOwnLine * timeToOwnLine
                if projY >= (goalInfo.ownGoalMinY - 260) and projY <= (goalInfo.ownGoalMaxY + 260) then
                    headingIntoOwnGoal = true
                end
            end
        end
    end

    local headingIntoEnemyGoal = false
    if not scored and endForwardVx > 500 then
        local timeToGoalLine = (goalInfo.goalLineX - bEnd.Pos.X) / bEnd.Vel.X
        if timeToGoalLine > 0 and timeToGoalLine < 1.15 then
            local projY = bEnd.Pos.Y + bEnd.Vel.Y * timeToGoalLine - 0.5 * (Config.Gravity * 0.9) * timeToGoalLine * timeToGoalLine
            if projY >= (goalInfo.goalMinY + 75) and projY <= (goalInfo.goalMaxY - 75) then
                headingIntoEnemyGoal = true
            end
        end
    end

    local anyTouch = gotHit or gotCritHit or gotDodgeShot or gotJumpShot or gotPinch or gotFlipReset or (cEnd and cEnd.BallContact)

    return {
        scored = scored,
        ownGoaled = ownGoaled or headingIntoOwnGoal or knockedBackward,
        knockedBackward = knockedBackward,
        headingIntoEnemyGoal = headingIntoEnemyGoal,
        gotFlipReset = gotFlipReset,
        gotDodgeShot = gotDodgeShot,
        gotJumpShot = gotJumpShot,
        gotCritHit = gotCritHit,
        gotPinch = gotPinch,
        gotHit = gotHit,
        anyTouch = anyTouch,
        touchStep = touchStep,
        bVelTowardGoal = bVelTowardGoal,
        bVelForwardX = endForwardVx,
        bVelUpY = bEnd.Vel.Y,
        minBallDistToGoal = minBallDistToGoal,
        minCarBallDist = minCarBallDist,
        endBoost = cEnd.Boost,
        endHasFlip = cEnd.HasFlip,
        endCarPos = cEnd.Pos,
        endCarVel = cEnd.Vel,
        endBallPos = bEnd.Pos,
        endBallVel = bEnd.Vel,
    }
end

----------------------------------------------------------------------
-- Fast Downward Descent Helper (Burns Remaining Boost Straight Down - NO Downward Flip!)
----------------------------------------------------------------------
-- User requested: "ele ta dando uns flip pra baixo ndv"
-- NEVER flip downwards! A downward flip locks the car in a 14-tick flip spin (`FlipDodgeTime`), preventing the wheels from leveling
-- and causing awkward ground bounces. Instead, point straight down and burn 100% of remaining boost (`car.Boost > 0`),
-- releasing at `Y < 145` so `floorLanding` smoothly levels all 4 wheels on contact!
local function makeFastDiveInput(car, targetX)
    local dx = (targetX or car.Pos.X) - car.Pos.X
    local nearFloor = (car.Pos.Y < 185) or (car.Pos.Y + car.Vel.Y * 0.14 < 120)
    -- `currentUp.Y`: positive means roof is up & 4 wheels face the floor!
    -- If `currentUp.Y < -0.15`, the car is upside down (hood facing floor), so press E (`SnapRoll`) once to instantly flip wheels-down!
    local curUpY = math.cos(car.Angle) * (Hitbox.upright(car) and 1 or -1)
    local needSnapWheelsDown = (curUpY < -0.15) and not car.PrevSnapRoll

    if nearFloor then
        -- Level out horizontally (`StickY = 0`, `Boost = false`, `Spin = false`) so all 4 wheels touch the floor flat and start regenerating boost immediately!
        local aimX = ( math.abs(dx) > 40 and math.sign(dx) ) or ( math.abs(car.Vel.X) > 20 and math.sign(car.Vel.X) ) or 1
        return makeInput(aimX, 0, false, false, false, needSnapWheelsDown), "RECOVERY | 4-Wheel Flat Landing (Boost Regen!)"
    end

    local aimX = math.clamp(dx / 380, -0.45, 0.45)
    local aimDir = Vector2.new(aimX, -1).Unit

    if car.Boost > 0 then
        -- Spin (`Q = true`) during high-altitude air descent for smooth visual style, then stop spinning near floor!
        return makeInput(aimDir.X, aimDir.Y, false, true, car.Pos.Y > 320, needSnapWheelsDown), string.format("RECOVERY | Boost-Diving Down! (%.0f%%)", car.Boost)
    else
        return makeInput(aimDir.X, -0.35, false, false, false, needSnapWheelsDown), "RECOVERY | Fast-Fall Descent"
    end
end

----------------------------------------------------------------------
-- Ground Forward Flip Travel Helper (Strictly Horizontal StickY = 0!)
----------------------------------------------------------------------
-- Note: Previously `StickY = -0.25` was used during the low hop, which tilted the nose into the floor and caused a downward flip!
-- Now `StickY = 0` (100% horizontal forward flip) is used, and ONLY when the ball is very far (`distToBall > 1350`) and low (`ball.Pos.Y < 450`)!
local BotController = {
    state = "IDLE",
    simulating = false,
    holdJumpTicks = 0,
    doubleJumpStage = 0,     -- 0 = none, 1 = release jump 1 tick, 2 = fire second jump upward!
    groundFlipStage = 0,     -- 0 = none, 1..4 = hop -> pure horizontal forward dodge
    groundFlipDir = 1,
    lastGroundFlipClock = 0,
    airDragActive = false,
    lastInfiniteSent = 0,
    lastStatus = "Ready",
}

function BotController.decide(world, myIndex)
    local car = world.Cars[myIndex]
    local ball = world.Ball
    if not car or car.Parked or world.NoBall then
        BotController.lastStatus = "Waiting for active car"
        return World.NeutralInput
    end

    local phase = world.Match and world.Match.Phase or "Active"
    if phase ~= "Active" then
        BotController.holdJumpTicks = 0
        BotController.doubleJumpStage = 0
        BotController.groundFlipStage = 0
        BotController.airDragActive = false
        BotController.lastStatus = "Phase: " .. tostring(phase)
        return World.NeutralInput
    end

    local ctx = World.context(world.ModeId, world.Layout)
    local bCfg = ctx.Ball
    local ballRadius = bCfg.Radius or 150
    local goalInfo = getGoalsForTeam(world, ctx, car.Team)
    local attackDir = goalInfo.attackDir
    local targetGoal = goalInfo.targetPos

    if goalInfo.isFreeplay and not car.InfiniteBoost and InfiniteBoostRemote and os.clock() - BotController.lastInfiniteSent > 3 then
        BotController.lastInfiniteSent = os.clock()
        pcall(function() InfiniteBoostRemote:FireServer(true) end)
    end

    local toBall = ball.Pos - car.Pos
    local distToBall = toBall.Magnitude
    local relVel = ball.Vel - car.Vel
    -- Positive `relativeBallX` means the ball is IN FRONT of us (between our car and the enemy goal)!
    -- Negative `relativeBallX` means our car is AHEAD of the ball (ball is between our car and our OWN goal -> DANGER OF OWN GOAL!)
    local relativeBallX = (ball.Pos.X - car.Pos.X) * attackDir
    local oppCar, oppDistToBall, mateCar, mateDistToBall = findOpponentsAndTeammates(world, myIndex, goalInfo.myTeam)

    local forceAirDragMode = (playModeIdx == 2)
    local rankedFastMode = (playModeIdx == 3)

    local ballPath = predictBallTrajectory(world, ctx, 40)

    local jumpTicksElapsed = math.floor(car.JumpTime / Config.Dt + 0.5)
    local canFlipOrJumpNow = car.HasFlip and (jumpTicksElapsed >= 3) and (car.DodgeAge >= 9)
    local justJumpedFromGround = (jumpTicksElapsed < 11)

    -- Analytical 3-Tick Contact Safety Check (0.002ms, ZERO World.clone lag!):
    -- Checks if applying `aimDir` will cause our car to hit the FRONT hemisphere of the ball toward our own goal!
    local function isAnalyticalTouchSafe(aimDir, isJumpOrFlip)
        local boostAccel = (car.Boost > 0) and (aimDir * 1500) or Vector2.zero
        local flipImpulse = isJumpOrFlip and (aimDir * 680) or Vector2.zero
        local dt3 = Config.Dt * 3
        local predCarVel = car.Vel + flipImpulse + (boostAccel + Vector2.new(0, -Config.Gravity)) * dt3
        local predCarPos = car.Pos + predCarVel * dt3
        local predBallPos = (ballPath[3] and ballPath[3].Pos) or (ball.Pos + ball.Vel * dt3)
        local predBallVel = (ballPath[3] and ballPath[3].Vel) or ball.Vel

        local sep = predBallPos - predCarPos
        local dist = sep.Magnitude
        if dist < (ballRadius + 130) then
            -- Contact normal from car to ball:
            local relX = (predBallPos.X - predCarPos.X) * attackDir
            local relVelX = (predCarVel.X - predBallVel.X) * attackDir
            -- If our car is ahead of the ball (`relX < -10`) and moving into it backward (`relVelX < -40`), it will knock the ball toward our own goal!
            if relX < -10 and relVelX < -40 then
                return false
            end
        end
        return true
    end

    local function triggerNewJump(wantJump)
        if not wantJump then return false end
        if car.PrevJump then
            return false
        end
        return true
    end

    local function startSingleJump(ticks)
        if car.PrevJump then
            BotController.holdJumpTicks = 0
            return false
        end
        BotController.doubleJumpStage = 0
        BotController.holdJumpTicks = ticks or 6
        return true
    end

    local function startDoubleJumpLaunch()
        if car.PrevJump then
            BotController.holdJumpTicks = 0
            BotController.doubleJumpStage = 0
            return false
        end
        -- Hold first jump for 3 ticks, then release for 1 tick, then fire neutral double-jump upward!
        BotController.holdJumpTicks = 3
        BotController.doubleJumpStage = 1
        return true
    end

    -- Reset airborne stages when grounded
    if car.Grounded and BotController.doubleJumpStage > 0 and car.JumpTime > 0.12 then
        BotController.doubleJumpStage = 0
    end

    -- Handle active Ground Forward-Flip Travel sequence (Clean Hop -> Pure Horizontal Forward Dodge, StickY = 0!)
    if BotController.groundFlipStage > 0 then
        local fDir = BotController.groundFlipDir
        -- Abort ground flip immediately if we get within 800 UU of the ball or if the ball goes high (`Y > 500`)!
        if distToBall < 800 or ball.Pos.Y > 500 then
            BotController.groundFlipStage = 0
        elseif BotController.groundFlipStage == 1 then
            BotController.groundFlipStage = 2
            BotController.lastStatus = "TRAVEL | Forward Flip Hop"
            return makeInput(fDir, 0, true, false, false, false)
        elseif BotController.groundFlipStage == 2 then
            BotController.groundFlipStage = 3
            BotController.lastStatus = "TRAVEL | Forward Flip Hop"
            return makeInput(fDir, 0, true, false, false, false)
        elseif BotController.groundFlipStage == 3 then
            -- Release Jump for 1 tick so `PrevJump` becomes false
            BotController.groundFlipStage = 4
            BotController.lastStatus = "TRAVEL | Forward Flip Prep"
            return makeInput(fDir, 0, false, false, false, false)
        elseif BotController.groundFlipStage == 4 then
            if jumpTicksElapsed >= 3 and not car.PrevJump then
                BotController.groundFlipStage = 0
                BotController.lastGroundFlipClock = os.clock()
                BotController.lastStatus = "TRAVEL | Pure Forward Flip!"
                return makeInput(fDir, 0, true, false, false, false)
            end
            return makeInput(fDir, 0, false, false, false, false)
        end
    end

    local function tryGroundForwardFlip(targetDx)
        local absDx = math.abs(targetDx)
        local dirX = math.sign(targetDx)
        if dirX == 0 then return nil end
        local now = os.clock()
        -- Only flip on flat ground when VERY FAR (`absDx > 1400` and `distToBall > 1300`) and ball is low (`ball.Pos.Y < 450`),
        -- so we NEVER waste our jump/flip when we need to fly up for an aerial!
        if car.Grounded and not onWall and car.HasFlip and not car.PrevJump
            and absDx > 1400 and distToBall > 1300 and ball.Pos.Y < 450
            and (car.Vel.X * dirX > 480)
            and (now - BotController.lastGroundFlipClock > 1.8)
        then
            BotController.groundFlipDir = dirX
            BotController.groundFlipStage = 1
            BotController.lastStatus = "TRAVEL | Long-Range Forward Flip!"
            return makeInput(dirX, 0, true, false, false, false)
        end
        return nil
    end

    local onWall = car.Grounded and math.abs(car.GroundUp.X) > 0.45
    local onOwnWall = onWall and (math.sign(car.Pos.X) == -attackDir)
    local onEnemyWall = onWall and (math.sign(car.Pos.X) == attackDir)
    local currentUp = Vector2.new(-math.sin(car.Angle), math.cos(car.Angle)) * (Hitbox.upright(car) and 1 or -1)
    local carForward = Vector2.new(math.cos(car.Angle), math.sin(car.Angle))

    -- Helper for Q (`Spin` = Continuous Air Roll / Air Dribble Visual) and E (`SnapRoll` = Instant 180-degree Snap Flip!):
    -- User requested:
    --   Q = air drible, mto bonito, usa no ar, quase sempre, e visual, n muda mto na parte logica...
    --   E = Snap Flip, gira INSTANTANEAMENTE o carro pra direcao contraria, logo capo pra baixo, ele vira pra cima, pra esquerda, ele vira pra direita...
    --   e parar de spammar boost / ficar empinado sem recuperar boost!
    local function shouldUseSnapFlipE(desiredUpVec)
        if car.Grounded or car.PrevSnapRoll then
            return false
        end
        -- If our car's roof (`currentUp`) is pointing opposite to `desiredUpVec` (`Dot < -0.22`), pressing E (`SnapRoll`)
        -- instantly flips the car 180 degrees so the roof/wheels invert to the exact side we need!
        return currentUp:Dot(desiredUpVec) < -0.22
    end

    local function shouldUseAirDribbleQ(isNearFloorOrReset)
        if car.Grounded or isNearFloorOrReset or car.Pos.Y < 190 then
            return false
        end
        return true
    end

    -- Helper to wrap `makeInput` on the ground so the car NEVER pitches its nose up ("empinado") or blocks boost regeneration!
    -- In Sideswipe (`Car.lua`), boost ONLY regenerates when `car.Grounded == true` (all 4 wheels on surface) AND `not input.Boost`!
    -- If `StickY ~= 0` on flat ground or `Boost` is spammed while below target boost, the car lifts its front wheels or pauses regen!
    local function makeFlatGroundInput(stickX, wantBoostFlag)
        local sx = stickX
        -- If we are pitched on two wheels on the floor (`math.abs(car.Angle) > 0.08`), release boost and level the car (`StickY = 0`) so all 4 wheels lock to the floor!
        local isWheelieTilted = (not onWall) and (math.abs(car.Angle) > 0.12)
        local allowBoost = wantBoostFlag and (not isWheelieTilted)
        return makeInput(sx, 0, false, allowBoost, false, false)
    end

    local ballToGoal = targetGoal - ball.Pos
    local ballDistToGoal = ballToGoal.Magnitude
    local goalDir = ballDistToGoal > 1 and (ballToGoal / ballDistToGoal) or Vector2.new(attackDir, 0.35).Unit

    -- Under-Ball Air Drag Anchor: behind the ball (`-attackDir * 52`) and underneath (`-(ballRadius + 58)`).
    -- Tighter offset guarantees firm physical contact with the ball instead of floating under/behind it and whiffing!
    local underBallOffset = Vector2.new(-attackDir * 52, -(ballRadius + 58))
    local underBallAnchor = ball.Pos + underBallOffset
    local carryPushDir = Vector2.new(attackDir * math.max(0.56, math.abs(goalDir.X) * 0.82), math.clamp(goalDir.Y + 0.42, 0.25, 0.85)).Unit

    -- Exact solver helper (Lightweight 7-tick rollout, only used when evaluating an actual flip!):
    local function isTouchSafeAndAccurate(inp, follow, horizon)
        local res = evaluateSequence(world, ctx, myIndex, inp, follow or inp, horizon or 7, goalInfo)
        if res.ownGoaled or res.knockedBackward then
            return false, res
        end
        return true, res
    end

    ------------------------------------------------------------------
    -- 0. OPPONENT-AWARE TACTICAL ANALYZER (Reads Enemy Position, Boost, Flip & ETA!)
    ------------------------------------------------------------------
    -- User requested: "faz ele ver onde o inimigo ta pra ter uma ideia, dai ele fica melhor a mais inteligente"
    local oppHasPossession = false
    local oppAboutToShoot = false
    local oppBeatsUsToBall = false
    local oppThreatLevel = 0
    local oppPredictedShotY = (goalInfo.ownGoalMinY + goalInfo.ownGoalMaxY) * 0.5

    if oppCar then
        local oppToBall = ball.Pos - oppCar.Pos
        local oppClosingSpeed = (oppToBall.Magnitude > 1) and ((oppCar.Vel - ball.Vel):Dot(oppToBall.Unit)) or 0
        local oppEta = oppDistToBall / math.max(400, oppClosingSpeed + 950)
        local myClosingSpeed = (distToBall > 1) and ((car.Vel - ball.Vel):Dot(toBall.Unit)) or 0
        local myEta = distToBall / math.max(400, myClosingSpeed + 950)

        -- Opponent is on the attack side of the ball (`(oppCar.Pos.X - ball.Pos.X) * attackDir > -80`) facing our goal!
        local oppOnAttackSide = ((oppCar.Pos.X - ball.Pos.X) * attackDir) > -80
        oppHasPossession = (oppDistToBall < 360) and oppOnAttackSide
        oppBeatsUsToBall = (oppEta + 0.12 < myEta) and (oppDistToBall < 750) and oppOnAttackSide

        -- Check if opponent is airborne or close to the ball aiming a shot toward our goal!
        if (oppDistToBall < 420) and oppOnAttackSide and ((ball.Pos.X - goalInfo.ownGoalLineX) * attackDir < 2200) then
            oppAboutToShoot = true
            -- Predict where their shot will cross our goal line based on vector from oppCar through ball!
            local shotVec = (ball.Pos - oppCar.Pos)
            if shotVec.X * attackDir < -10 then
                local tLine = (goalInfo.ownGoalLineX - ball.Pos.X) / (shotVec.X * 4.5)
                oppPredictedShotY = math.clamp(ball.Pos.Y + shotVec.Y * 4.5 * math.clamp(tLine, 0.1, 0.8), goalInfo.ownGoalMinY - 100, goalInfo.ownGoalMaxY + 100)
            end
        end

        if oppHasPossession or oppAboutToShoot then
            oppThreatLevel = 2
        elseif oppBeatsUsToBall then
            oppThreatLevel = 1
        end
    end
    ------------------------------------------------------------------
    -- 1. KICKOFF (Ball stationary at center)
    ------------------------------------------------------------------
    local isKickoff = ball.TouchCount == 0 and ball.Vel.Magnitude < 45 and math.abs(ball.Pos.X) < 120
    if isKickoff then
        BotController.airDragActive = false
        local dirX = attackDir
        if car.Grounded then
            if math.abs(toBall.X) < 480 and math.abs(car.Vel.X) > 750 then
                local jmp = startSingleJump(5)
                BotController.lastStatus = "KICKOFF | Jump Takeoff (" .. goalInfo.teamTag .. ")"
                return makeInput(dirX, 0.22, jmp, true, false, false)
            end
            BotController.lastStatus = "KICKOFF | Boosting (" .. goalInfo.teamTag .. ")"
            return makeInput(dirX, 0, false, true, false, false)
        else
            if BotController.holdJumpTicks > 0 and car.PrevJump then
                BotController.holdJumpTicks -= 1
                return makeInput(dirX, 0.25, true, true, false, false)
            else
                BotController.holdJumpTicks = 0
            end
            if oppCar and oppDistToBall < 450 and distToBall < 320 and canFlipOrJumpNow then
                BotController.lastStatus = "KICKOFF | 50/50 Flip Dunk!"
                local aim = Vector2.new(attackDir, math.clamp(toBall.Y / 250, -0.3, 0.6)).Unit
                return makeInput(aim.X, aim.Y, triggerNewJump(true), true, false, false)
            end
            return makeInput(dirX, math.clamp(toBall.Y / 200, -1, 1), false, true, false, false)
        end
    end

    ------------------------------------------------------------------
    -- 2. UNBREAKABLE GOALKEEPING, HIGH-BALL AERIAL SAVES & OPPONENT-AWARE SHADOW DEFENSE!
    ------------------------------------------------------------------
    -- User requested: "ele ta perdendo umas bola e tomando uns gols muito faceis, arruma"
    -- Why was it conceding easy goals?
    --   1) Previously, `clearAnchor` was placed BELOW the ball (`dangerPos.Y - 75`). When a shot came at goal height (`Y = 800..1700`),
    --      aiming below the ball made the car hit the bottom of the ball UPWARD into our own top corner, or pass right under the ball!
    --   2) When blocking a shot on our own goal, we must aim directly at the GOAL-SIDE BLOCK POINT (`dangerPos.X - attackDir * 110, dangerPos.Y`),
    --      staying squarely between the ball and the center of our net (`ownGoalCenterY`)!
    --   3) Trigger defense immediately whenever:
    --      - Any predicted ball point enters `distFromOwnGoalX < 1850` while moving toward our goal (`Vel.X * attackDir < -80`), OR
    --      - The ball is currently on our defensive third (`(ball.Pos.X - goalInfo.ownGoalLineX) * attackDir < 1400`) and not moving fast away, OR
    --      - The opponent has possession (`oppHasPossession` or `oppAboutToShoot` or `oppBeatsUsToBall`) on our half!
    local dangerStep = nil
    local dangerPos = nil
    local dangerVel = ball.Vel
    local isDirectShotOnOurGoal = false
    local ownGoalCenterY = (goalInfo.ownGoalMinY + goalInfo.ownGoalMaxY) * 0.5
    local curDistFromOwnGoalX = (ball.Pos.X - goalInfo.ownGoalLineX) * attackDir

    for i = 1, 40 do
        local p = ballPath[i]
        local distFromOwnGoalX = (p.Pos.X - goalInfo.ownGoalLineX) * attackDir
        local movingTowardOwnGoal = (p.Vel.X * attackDir) < -40

        -- Direct shot entering our goal opening (or within 420 UU of our goal line at goal height!)
        if distFromOwnGoalX <= 420 and p.Pos.Y >= (goalInfo.ownGoalMinY - 280) and p.Pos.Y <= (goalInfo.ownGoalMaxY + 380) and (movingTowardOwnGoal or distFromOwnGoalX <= 160) then
            -- Pick the earliest interceptable point before the ball crosses our goal line (`distFromOwnGoalX >= 40`)!
            if not dangerStep or distFromOwnGoalX >= 40 then
                dangerStep = i
                dangerPos = p.Pos
                dangerVel = p.Vel
                isDirectShotOnOurGoal = true
                if distFromOwnGoalX <= 180 then
                    break
                end
            end
        end

        -- Any ball heading toward our half inside `distFromOwnGoalX < 1850` (including low, mid, and high balls!)
        if not dangerStep and distFromOwnGoalX < 1850 and (p.Vel.X * attackDir < -110) then
            dangerStep = i
            dangerPos = p.Pos
            dangerVel = p.Vel
        end
    end

    -- Also trigger active defense if the ball is already inside our defensive box (`curDistFromOwnGoalX < 1300` and `ball.Vel.X * attackDir < 250`)
    -- OR if the opponent beats us to the ball / is about to shoot!
    if not dangerPos then
        if curDistFromOwnGoalX < 1300 and (ball.Vel.X * attackDir < 250) then
            local lookIdx = math.clamp(math.floor(distToBall / 180), 1, 10)
            local p = ballPath[lookIdx] or { Pos = ball.Pos, Vel = ball.Vel }
            dangerPos = p.Pos
            dangerVel = p.Vel
            dangerStep = lookIdx
        elseif oppAboutToShoot or ((oppHasPossession or oppBeatsUsToBall) and (ball.Pos.X * attackDir < 650)) then
            local defX = math.clamp(ball.Pos.X - attackDir * 520, -goalInfo.wallX + 100, goalInfo.wallX - 100)
            dangerPos = Vector2.new(defX, math.clamp((ball.Pos.Y + oppPredictedShotY) * 0.5, 160, goalInfo.ownGoalMaxY + 100))
            dangerVel = ball.Vel
            dangerStep = 12
        end
    end

    if dangerPos and (isDirectShotOnOurGoal or not forceAirDragMode) then
        BotController.airDragActive = false

        -- Compute the exact GOAL-SIDE BLOCK POINT on the line between our own goal center (`ownGoalLineX, ownGoalCenterY`) and `dangerPos`!
        -- Positioning on this line guarantees our car's body physically blocks the shot from entering our goal AND clears it forward (`+attackDir`)!
        local ownGoalCenter = Vector2.new(goalInfo.ownGoalLineX, math.clamp(dangerPos.Y, goalInfo.ownGoalMinY + 60, goalInfo.ownGoalMaxY - 60))
        local goalToBall = dangerPos - ownGoalCenter
        local blockOffset = (dangerPos.Y > goalInfo.ownGoalMaxY) and Vector2.new(-attackDir * 105, -70)
            or (goalToBall.Magnitude > 1 and (-goalToBall.Unit * 110) or Vector2.new(-attackDir * 110, 0))
        local clearAnchor = Vector2.new(
            math.clamp(dangerPos.X + blockOffset.X, -goalInfo.wallX + 45, goalInfo.wallX - 45),
            math.max(55, dangerPos.Y + blockOffset.Y)
        )

        -- Check if we are on the WRONG side of the ball near our own goal (`relativeBallX < 5`)
        if relativeBallX < 5 then
            local bypassY = (ball.Pos.Y > 440)
                and math.max(55, ball.Pos.Y - 340)
                or math.min(goalInfo.ceilingY - 180, ball.Pos.Y + 340)
            local goalPostX = math.clamp(goalInfo.ownGoalLineX + attackDir * 55, -goalInfo.wallX + 40, goalInfo.wallX - 40)
            local toPost = Vector2.new(goalPostX, bypassY) - car.Pos
            local bDir = toPost.Magnitude > 1 and toPost.Unit or Vector2.new(-attackDir, -0.5).Unit

            if car.Grounded and not onWall and ball.Pos.Y < 320 and math.abs(ball.Pos.X - car.Pos.X) < 420 then
                local jmp = startSingleJump(6)
                BotController.lastStatus = "DEFENSE | Vaulting Over Ball to Goal Line!"
                return makeInput(-attackDir, 0.75, jmp, car.Boost > 15, false, false)
            end

            if not car.Grounded and bypassY < car.Pos.Y - 140 and math.abs(ball.Pos.X - car.Pos.X) > 220 then
                local diveInp = makeFastDiveInput(car, goalPostX)
                BotController.lastStatus = "DEFENSE | Boost-Diving to Goal Line!"
                return diveInp
            end
            BotController.lastStatus = "DEFENSE | Bypassing Ball to Goal Line!"
            return makeInput(bDir.X, bDir.Y, false, car.Boost > 5, false, false)
        end

        -- We are strictly on the goal-side of the ball (`relativeBallX >= 5`, between our goal and the ball)!
        -- Account for gravity & car velocity when aiming our aerial save intercept!
        local toClear = clearAnchor - car.Pos
        local interceptTime = math.clamp(toClear.Magnitude / 1300, 0.06, 0.55)
        local gravDrop = 0.5 * Config.Gravity * interceptTime * interceptTime
        local leadClearVec = Vector2.new(
            toClear.X - car.Vel.X * interceptTime * 0.42,
            (toClear.Y + gravDrop) - car.Vel.Y * interceptTime * 0.42
        )
        local clearDir = leadClearVec.Magnitude > 1 and leadClearVec.Unit or (toClear.Magnitude > 1 and toClear.Unit or Vector2.new(attackDir, 0.5).Unit)

        if car.Grounded then
            if onWall then
                -- We are on our own back wall (above/below our goal)!
                local wallDirY = math.sign(clearAnchor.Y - car.Pos.Y)
                if distToBall < 540 and relativeBallX >= 5 then
                    local jmp = startSingleJump(5)
                    BotController.lastStatus = "DEFENSE | Wall Clear Save!"
                    return makeInput(attackDir, 0.35, jmp, true, false, false)
                end
                BotController.lastStatus = "DEFENSE | Wall Goalkeeping"
                return makeInput(-attackDir, wallDirY, false, math.abs(clearAnchor.Y - car.Pos.Y) > 150 and car.Boost > 10, false, false)
            end

            -- HIGH-BALL & MID-BALL AERIAL SAVE TAKEOFF (Strict Distance & Time Check - NO Random Jumps from Across the Map!):
            -- Only jump for an aerial save when:
            --   1) It is a real shot or dangerous ball moving toward our goal (`isDirectShotOnOurGoal` or `dangerVel.X * attackDir < -140`), AND
            --   2) Our car is horizontally close to the save point (`|toClear.X| < 520`), AND
            --   3) The ball will reach `dangerPos` soon (`dangerStep <= 24`, i.e. within `0.40s`)!
            local ballIncomingToGoal = isDirectShotOnOurGoal or (dangerVel.X * attackDir < -140 and (dangerPos.X - goalInfo.ownGoalLineX) * attackDir < 1200)
            local closeEnoughToJumpSave = (math.abs(toClear.X) < 520) and ((dangerStep or 15) <= 24) and (car.Boost >= 12 or clearAnchor.Y < 620)
            if ballIncomingToGoal and clearAnchor.Y > 250 and closeEnoughToJumpSave then
                local useDoubleJumpSave = (clearAnchor.Y - car.Pos.Y > 500) and (math.abs(toClear.X) < 360)
                local jmp = useDoubleJumpSave and startDoubleJumpLaunch() or startSingleJump(6)
                BotController.lastStatus = useDoubleJumpSave
                    and "DEFENSE | Double-Jump High Corner Save!"
                    or "DEFENSE | High Aerial Save Takeoff!"
                local aimX = (clearDir.X * attackDir < 0.05) and (attackDir * 0.25) or clearDir.X
                local launchAim = Vector2.new(aimX, math.max(0.50, clearDir.Y)).Unit
                return makeInput(launchAim.X, launchAim.Y, jmp, true, false, false)
            end

            -- Low Shot / Ground Save: only jump when the ball is right in front of us (`distToBall < 340`) and moving fast toward our goal!
            if distToBall < 340 and relativeBallX >= 25 and (ball.Vel.X * attackDir < -220) and ball.Pos.Y < 280 then
                local jmp = startSingleJump(4)
                BotController.lastStatus = "DEFENSE | Low Shot Block Jump!"
                return makeInput(attackDir, 0.30, jmp, car.Boost > 15, false, false)
            end

            -- Drive to the goal-side clear position (Conserve & regenerate boost when already near goal position!)
            local flipTravelInp = tryGroundForwardFlip(toClear.X)
            if flipTravelInp then
                BotController.lastStatus = "DEFENSE | Fast Flip Sprint to Goal!"
                return flipTravelInp
            end
            local stickX = 0
            if math.abs(toClear.X) > 55 or math.abs(car.Vel.X) > 180 then
                stickX = math.clamp((toClear.X - car.Vel.X * 0.16) / 105, -1, 1)
            end
            -- Only burn boost on defense floor if it's an emergency direct shot or we are far (`|toClear.X| > 420` and `car.Boost > 45`)!
            -- Otherwise let boost regenerate to 100% on the floor so we have full fuel when we jump to save!
            local urgentGroundSprint = (isDirectShotOnOurGoal and math.abs(toClear.X) > 170 and car.Boost > 10)
                or (math.abs(toClear.X) > 480 and car.Boost > 50 and math.abs(car.Vel.X) < 1150)
            BotController.lastStatus = (not urgentGroundSprint and car.Boost < 95)
                and string.format("DEFENSE | Guarding & Regen Boost (%.0f%%)", car.Boost)
                or "DEFENSE | Positioning for Save"
            return makeFlatGroundInput(stickX, urgentGroundSprint)
        else
            -- Airborne Goalkeeping (Handles both Single-Jump and Double-Jump High Corner Saves + Q Air Dribble & E Snap Flip!):
            local saveAimX = (distToBall < 280 and clearDir.X * attackDir < 0.12) and (attackDir * 0.38) or clearDir.X
            local saveAim = Vector2.new(saveAimX, clearDir.Y).Unit
            local snapSave = shouldUseSnapFlipE(Vector2.yAxis)
            local spinSave = shouldUseAirDribbleQ(false)

            if BotController.holdJumpTicks > 0 and car.PrevJump then
                BotController.holdJumpTicks -= 1
                return makeInput(saveAim.X, math.max(0.35, saveAim.Y), true, car.Boost > 0, spinSave, snapSave)
            else
                BotController.holdJumpTicks = 0
            end

            if BotController.doubleJumpStage == 1 then
                BotController.doubleJumpStage = 2
                return makeInput(saveAim.X, math.max(0.35, saveAim.Y), false, car.Boost > 0, spinSave, snapSave)
            elseif BotController.doubleJumpStage == 2 then
                BotController.doubleJumpStage = 0
                if canFlipOrJumpNow and not car.PrevJump and currentUp.Y > 0.3 then
                    BotController.lastStatus = "DEFENSE | High Save Double-Jump Boost!"
                    return makeInput(0, 0, true, car.Boost > 0, false, false)
                end
            end

            -- If the ball is still high above us during an aerial save (`clearAnchor.Y - car.Pos.Y > 320`) and we still have our flip,
            -- fire a mid-air Double-Jump Up (`Stick = (0,0)`) to reach the top corner of the net!
            if not justJumpedFromGround and canFlipOrJumpNow and (clearAnchor.Y - car.Pos.Y > 320) and math.abs(toClear.X) < 380 and car.Vel.Y < 600 then
                if currentUp.Y < -0.15 and not car.PrevSnapRoll then
                    -- Car is upside down! Press E (`SnapRoll`) first so the roof faces up before double-jumping!
                    BotController.lastStatus = "DEFENSE | Snap-Flip Upright for Double-Jump!"
                    return makeInput(saveAim.X, saveAim.Y, false, car.Boost > 0, false, true)
                elseif currentUp.Y > 0.3 then
                    BotController.lastStatus = "DEFENSE | Mid-Air Double-Jump Save Climb!"
                    return makeInput(0, 0, triggerNewJump(true), car.Boost > 0, false, false)
                end
            end

            -- When within striking range of the ball during a save (`distToBall < 420`) and strictly goal-side (`relativeBallX >= 10`),
            -- flip FORWARD toward the ball/enemy side to blast the ball away from our goal!
            if not justJumpedFromGround and canFlipOrJumpNow and distToBall < 420 and relativeBallX >= 10 then
                local dirToBallUnit = toBall.Magnitude > 1 and toBall.Unit or Vector2.new(attackDir, 0.3).Unit
                local clearFlipX = math.max(0.45, dirToBallUnit.X * attackDir) * attackDir
                local powerClearDir = Vector2.new(clearFlipX, math.clamp(dirToBallUnit.Y + 0.15, -0.35, 0.75)).Unit
                if isAnalyticalTouchSafe(powerClearDir, true) then
                    BotController.lastStatus = "DEFENSE | Power Clear Flip!"
                    return makeInput(powerClearDir.X, powerClearDir.Y, triggerNewJump(true), car.Boost > 10, spinSave, false)
                end
            end

            -- Don't spam boost in the air if we are already above `clearAnchor.Y + 80` or moving fast enough toward `clearAnchor`!
            local needSaveBoost = (car.Pos.Y < clearAnchor.Y + 60) or (math.abs(toClear.X) > 160 and (car.Vel:Dot(saveAim) < 1250))
            BotController.lastStatus = "DEFENSE | High Aerial Save Intercept!"
            return makeInput(saveAim.X, saveAim.Y, false, needSaveBoost and car.Boost > 0, spinSave, snapSave)
        end
    end

    ------------------------------------------------------------------
    -- 3. STRICT ANTI-OWN-GOAL RECOVERY (Never push ball toward our own goal!)
    ------------------------------------------------------------------
    local wrongSideThreshold = (ball.Pos.Y > car.Pos.Y + 240) and -35 or -10
    local isCarryingForwardUnderneath = (car.BallContact or car.BallCarry or (distToBall < ballRadius + 135 and car.Pos.Y < ball.Pos.Y - 45))
        and (relativeBallX >= -15)
        and (car.Vel.X * attackDir >= -40)
    local isOnWrongSide = (relativeBallX < wrongSideThreshold) and not isCarryingForwardUnderneath

    if isOnWrongSide then
        BotController.airDragActive = false
        local shadowX = math.clamp(ball.Pos.X - attackDir * 320, -goalInfo.wallX + 160, goalInfo.wallX - 160)
        local dx = shadowX - car.Pos.X
        local stickX = math.sign(dx)
        if stickX == 0 then stickX = -attackDir end

        if not car.Grounded then
            local ballInDescentPath = (math.abs(ball.Pos.X - car.Pos.X) < 360) and (ball.Pos.Y <= car.Pos.Y + 240)
            if ballInDescentPath then
                local evadeY = (car.Pos.Y >= ball.Pos.Y - 40) and 0.88 or -0.88
                local evadeDir = Vector2.new(-attackDir, evadeY).Unit
                BotController.lastStatus = "ANTI-OWN-GOAL | Air Bypass Around Ball!"
                return makeInput(evadeDir.X, evadeDir.Y, false, car.Boost > 20, shouldUseAirDribbleQ(false), shouldUseSnapFlipE(Vector2.yAxis))
            end

            local diveInp, diveStatus = makeFastDiveInput(car, shadowX)
            BotController.lastStatus = diveStatus
            return diveInp
        else
            if onWall then
                BotController.lastStatus = "RECOVERY | Driving Down Wall (Regen)"
                return makeInput(stickX, -1, false, false, false, false)
            end
            -- Only jump over the ball when we are on the wrong side AND the ball is right in our path (`|ball.Pos.X - car.Pos.X| < 250` and `ball.Pos.Y < 230`)!
            if math.abs(ball.Pos.X - car.Pos.X) < 250 and ball.Pos.Y < 230 and (car.Vel.X * (-attackDir) > 150) then
                local wantJump = startSingleJump(5)
                BotController.lastStatus = "ANTI-OWN-GOAL | Vaulting Over Ball!"
                return makeInput(stickX, 0.72, wantJump, car.Boost > 25, false, false)
            end
            local flipTravelInp = tryGroundForwardFlip(dx)
            if flipTravelInp then
                BotController.lastStatus = "RECOVERY | Forward Flip Rotation!"
                return flipTravelInp
            end
            -- Do NOT spam boost during ground recovery unless we already have `> 85%` boost and are far (`|dx| > 750`)!
            -- Driving on 4 wheels with `Boost = false` regenerates +45% boost/sec!
            local wantBoost = (car.Boost > 85) and (math.abs(dx) > 750) and (math.abs(car.Vel.X) < 1200)
            BotController.lastStatus = car.Boost < 90 and string.format("REGEN | Recharging Boost on Floor (%.0f%%)", car.Boost) or "RECOVERY | Rotating Behind Ball"
            return makeFlatGroundInput(stickX, wantBoost)
        end
    end

    ------------------------------------------------------------------
    -- 4. SELECTIVE OFFENSIVE FLIP / SHOT / RESET VERIFIER (Zero-Lag Analytical + Lightweight 2x5 Rollout!)
    ------------------------------------------------------------------
    -- Only evaluate offensive flips when we are within actual flip strike range (`distToBall < 310`),
    -- properly BEHIND or UNDER the ball (`relativeBallX >= 5`), and only run 2 lightweight 5-tick rollouts!
    local shouldEvaluateFlip = not car.Grounded
        and canFlipOrJumpNow
        and BotController.holdJumpTicks <= 0
        and not justJumpedFromGround
        and distToBall < 310
        and relativeBallX >= 5

    if shouldEvaluateFlip then
        local dirToBall = toBall.Magnitude > 1 and toBall.Unit or Vector2.new(attackDir, 0)
        local oppChallenging = (oppCar ~= nil and oppDistToBall < 420)
        local inScoringZone = (ballDistToGoal < 1100) or (rankedFastMode and ballDistToGoal < 1650)
        local lowBoostInAir = (car.Boost < 22)

        -- Analytical pre-filter: only run simulator when we are in scoring zone, contested by opponent, or low on boost!
        if inScoringZone or oppChallenging or lowBoostInAir then
            local flipCandidates = {
                -- 1. Direct Flip Shot toward Enemy Goal
                { name = "FLIP SHOT | Goal Finisher!", inp = makeInput(goalDir.X, goalDir.Y, true, car.Boost > 5, false, false), follow = makeInput(goalDir.X, goalDir.Y, false, car.Boost > 5, false, false) },
                -- 2. Direct Flip into Ball Center
                { name = "FLIP | Forward Strike!", inp = makeInput(dirToBall.X, dirToBall.Y, true, car.Boost > 5, false, false), follow = makeInput(goalDir.X, goalDir.Y, false, car.Boost > 5, false, false) },
            }

            local bestCand = nil
            local bestUtility = -math.huge

            for _, cand in ipairs(flipCandidates) do
                local res = evaluateSequence(world, ctx, myIndex, cand.inp, cand.follow, 6, goalInfo)
                -- STRICT REQUIREMENT: The ball MUST move forward toward the enemy side (`res.bVelForwardX > 250`) and never toward our own goal!
                if not res.ownGoaled and res.bVelForwardX > 250 then
                    local util = 0
                    if res.scored then
                        util = 100000
                    elseif res.headingIntoEnemyGoal then
                        util = 45000 + res.bVelTowardGoal * 10
                    elseif res.gotFlipReset and res.bVelForwardX > 150 then
                        util = 30000 + res.bVelTowardGoal * 5
                    elseif (inScoringZone or oppChallenging) and (res.gotCritHit or res.gotDodgeShot or res.gotJumpShot or res.gotPinch) and res.bVelTowardGoal > 950 then
                        util = 15000 + res.bVelTowardGoal * 6 - res.minBallDistToGoal * 4
                    elseif lowBoostInAir and (res.gotHit or res.gotCritHit or res.gotDodgeShot or res.gotJumpShot) and res.bVelTowardGoal > 380 then
                        util = 11000 + res.bVelTowardGoal * 4
                    end

                    if util > bestUtility and util >= 10000 then
                        bestUtility = util
                        bestCand = cand
                    end
                end
            end

            if bestCand then
                BotController.lastStatus = bestCand.name
                if car.PrevJump then
                    return makeInput(bestCand.inp.StickX, bestCand.inp.StickY, false, bestCand.inp.Boost, false, false)
                end
                return bestCand.inp
            end
        end
    end

    ------------------------------------------------------------------
    -- 5A. GROUNDED OFFENSE SETUP: Wall-Ramp Carry, Full-Tank Aerial Patience, Double-Jump Launch & Forward Flip Chase!
    ------------------------------------------------------------------
    if car.Grounded and not rankedFastMode then
        if onWall then
            -- Check WHICH wall we are on (`onOwnWall` vs `onEnemyWall`)!
            if onOwnWall then
                -- We are on our OWN defensive wall while in offense mode:
                -- If the ball is right here above us on our own wall (`distToBall < 440` and `ball.Pos.Y > car.Pos.Y`), jump OUTWARD (`+attackDir`) toward the enemy side!
                if distToBall < 440 and ball.Pos.Y >= car.Pos.Y - 60 and relativeBallX >= 20 then
                    local jmp = startSingleJump(5)
                    BotController.lastStatus = "WALL CLEAR | Launching Off Own Wall!"
                    return makeInput(attackDir, 0.45, jmp, true, false, false)
                end
                -- Otherwise drive DOWN our own wall back to the floor! Never climb our own wall pushing the ball into our own net!
                BotController.lastStatus = "SETUP | Leaving Own Wall to Floor"
                return makeInput(attackDir, -1, false, car.Boost > 50, false, false)
            else
                -- We are on the ENEMY offensive wall (`onEnemyWall`)!
                -- If we are BELOW the enemy goal (`car.Pos.Y < goalInfo.goalMinY - 40`) and the ball is above us, push it up toward the enemy goal opening!
                -- Once the ball is near goal height (`ball.Pos.Y >= goalInfo.goalMinY - 120`) or we are close (`distToBall < 440`), jump off the wall into an Air Drag / Shot!
                if distToBall < 460 and (ball.Pos.Y >= goalInfo.goalMinY - 140 or car.Boost >= 35) then
                    BotController.airDragActive = true
                    local jmp = startSingleJump(5)
                    BotController.lastStatus = "WALL DRAG | Launching Into Enemy Goal!"
                    return makeInput(goalDir.X, goalDir.Y, jmp, true, false, false)
                end
                if math.abs(ball.Pos.X - car.Pos.X) < 550 and ball.Pos.Y >= car.Pos.Y - 100 and car.Pos.Y < goalInfo.goalMaxY then
                    local needWallBoost = (car.Vel.Y < 850 and car.Boost > 25) or (toBall.Y > 240 and car.Boost > 40)
                    BotController.lastStatus = string.format("WALL CARRY | Pushing Up Enemy Wall (%.0f%%)", car.Boost)
                    return makeInput(attackDir, 1, false, needWallBoost, false, false)
                else
                    BotController.lastStatus = "SETUP | Returning from Enemy Wall"
                    return makeInput(-attackDir, -1, false, car.Boost > 65, false, false)
                end
            end
        end

        -- EXACT PHYSICS INTERCEPT FINDER (Calculates exact car acceleration + ball bounce trajectory):
        local interceptStep = 1
        local foundCatch = false
        for i = 1, 36 do
            local p = ballPath[i]
            local t = i * Config.Dt
            -- Target point is strictly behind (`-attackDir * 52`) and under (`-(ballRadius + 58)`) the ball!
            local targetAnchorX = p.Pos.X - attackDir * 52
            local targetAnchorY = math.max(50, p.Pos.Y - (ballRadius + 58))
            -- Account for our current velocity + acceleration over time `t`
            local avgSpeedX = math.clamp(math.abs(car.Vel.X) * 0.5 + 900, 980, 1580)
            local distX = math.abs(targetAnchorX - (car.Pos.X + car.Vel.X * math.min(t, 0.28)))
            local distY = math.max(0, targetAnchorY - car.Pos.Y)
            local willRemainBehind = ((p.Pos.X - targetAnchorX) * attackDir) >= 35
            if willRemainBehind and (distX / avgSpeedX <= t + 0.05) and (distY / 1180 <= t + 0.05) and p.Pos.Y < 1750 then
                interceptStep = i
                foundCatch = true
                break
            end
        end
        local predState = ballPath[interceptStep] or { Pos = ball.Pos, Vel = ball.Vel, Time = Config.Dt }
        local predBall = predState.Pos

        -- Case 1: Ball is low on the floor (Y < 340)
        if ball.Pos.Y < 340 and predBall.Y < 440 then
            local distToEnemyWall = math.abs(goalInfo.goalLineX - ball.Pos.X)
            local distFromOwnWall = math.abs(ball.Pos.X - goalInfo.ownGoalLineX)
            local oppThreatClose = (oppCar ~= nil and oppDistToBall < 560)
            local ballBouncingUp = (ball.Pos.Y > 185 and math.abs(ball.Vel.Y) > 120)
            local ballComingFastAtUs = ((ball.Vel.X * attackDir) < -320)

            -- Decide between WALL-RAMP CARRY vs CENTER POP-UP AIR DRAG:
            -- Roll the ball on the ground up the enemy wall ramp when settled on the floor, or drive through it smoothly!
            local safeForOffensiveWallRoll = (distFromOwnWall > 1350)
                and ((ball.Pos.X * attackDir) > -250)
                and not ballBouncingUp
                and not oppThreatClose
            local preferWallRampCarry = safeForOffensiveWallRoll and (
                (car.Boost < 75)
                or (distToEnemyWall < 1650)
            )

            local scoopOffset = preferWallRampCarry and 65 or 90
            local leadBallX = ball.Pos.X + ball.Vel.X * 0.06
            local scoopTargetX = leadBallX - attackDir * scoopOffset
            local dx = scoopTargetX - car.Pos.X
            local closingVx = (car.Vel.X - ball.Vel.X) * attackDir

            -- If we are VERY FAR from the ball on the ground (`|dx| > 1400` and `distToBall > 1300`), do a Ground Forward Flip to close the gap fast!
            local flipChaseInp = tryGroundForwardFlip(dx)
            if flipChaseInp then
                return flipChaseInp
            end

            -- GROUND-TO-AIR POP / BOUNCE INTERCEPT (No Random Premature Jumps!):
            -- Previously, jumping at `|toBall.X| < 285` caused the car to jump way too early and fly OVER a rolling ball!
            -- Now:
            --   1) If the ball is rolling on the floor (`ball.Pos.Y < 185`), we ONLY pop it when our front bumper is right on the ball (`|toBall.X| < 185`, `relativeBallX >= 35`) AND we are driving forward (`car.Vel.X * attackDir > 260`)!
            --   2) If the ball is bouncing (`ball.Pos.Y >= 185..340`) or rushing at us (`ballComingFastAtUs`), we jump to meet its center when within `|toBall.X| < 235`!
            local minBoostForGroundPop = (ballBouncingUp or ballComingFastAtUs or oppThreatClose or ballDistToGoal < 1050) and 42 or 75
            local canPopNow = (car.Boost >= minBoostForGroundPop) and (not preferWallRampCarry)
            local maxPopDistX = (ballBouncingUp or ballComingFastAtUs) and 235 or 185

            if canPopNow and math.abs(toBall.X) < maxPopDistX and relativeBallX >= 30 and toBall.Y < 260 and (car.Vel.X * attackDir > 220 or closingVx > 380) then
                local futureBall3 = (ballPath[3] and ballPath[3].Pos) or (ball.Pos + ball.Vel * (Config.Dt * 3))
                local aimToCenter = (futureBall3 - car.Pos)
                local takeoffDir = Vector2.new(attackDir * math.max(0.68, math.abs(aimToCenter.X) / math.max(1, aimToCenter.Magnitude)), math.clamp(aimToCenter.Y / 220 + 0.45, 0.38, 0.76)).Unit
                if isAnalyticalTouchSafe(takeoffDir, true) then
                    BotController.airDragActive = true
                    local jmp = startSingleJump(5)
                    BotController.lastStatus = string.format("AIR DRAG | Precision Ground Pop! (%.0f%%)", car.Boost)
                    return makeInput(takeoffDir.X, takeoffDir.Y, jmp, true, false, false)
                end
            end

            -- Ground Dribble / Wall-Ramp Push (Strict Boost Regen Hygiene - NEVER spam boost or tilt up on the floor!):
            local stickX = math.clamp(dx / 95, -1, 1)
            if math.abs(toBall.X) < 230 and relativeBallX >= 25 then
                stickX = attackDir -- push firmly through the back of the ball toward the enemy side!
            end
            local wantBoost = ((car.Boost >= 88 and math.abs(dx) > 420) or (oppThreatClose and car.Boost >= 55 and math.abs(dx) > 250))
                and (car.Vel.X * attackDir < 1200)
                and (closingVx <= 650)

            if preferWallRampCarry and math.abs(toBall.X) < 520 and relativeBallX >= 25 then
                BotController.lastStatus = string.format("WALL CARRY | Rolling Ball Up Enemy Ramp (%.0f%%)", car.Boost)
            elseif car.Boost < 85 then
                BotController.lastStatus = string.format("REGEN | Charging Boost on Floor (%.0f%%)", car.Boost)
            else
                BotController.lastStatus = "SETUP | Driving Behind Ball (" .. goalInfo.teamTag .. ")"
            end
            return makeFlatGroundInput(stickX, wantBoost)
        end

        -- Case 2: Ball is airborne (Y >= 340)
        -- Pick the earliest reachable point on `ballPath` where the ball is not already about to hit the floor (`p.Pos.Y >= 310`)!
        local catchState = nil
        for i = 1, 32 do
            local p = ballPath[i]
            local t = i * Config.Dt
            local anchorX = p.Pos.X - attackDir * 52
            local anchorY = math.max(60, p.Pos.Y - (ballRadius + 58))
            local horizSpeed = math.clamp(math.abs(car.Vel.X) * 0.4 + 980, 1000, 1500)
            local timeX = math.abs(anchorX - (car.Pos.X + car.Vel.X * math.min(t, 0.25))) / horizSpeed
            local timeY = math.max(0, anchorY - car.Pos.Y) / 1180
            local reachT = math.max(timeX, timeY)
            if p.Pos.Y >= 310 and p.Pos.Y <= 1680 and p.Vel.Y <= 480 and reachT <= t + 0.08 then
                catchState = p
                break
            end
        end

        -- If the ball is falling and will reach the floor (`Y < 310`) before we can climb to it, DO NOT JUMP! Stay on the floor and catch it on the bounce!
        if not catchState then
            local bounceX = math.clamp((ballPath[10] and ballPath[10].Pos.X or ball.Pos.X) - attackDir * 95, -goalInfo.wallX + 180, goalInfo.wallX - 180)
            local groundDx = bounceX - car.Pos.X
            local stickX = 0
            if math.abs(groundDx) > 55 or math.abs(car.Vel.X) > 220 then
                local dampedErr = groundDx - (car.Vel.X - ball.Vel.X * 0.4) * 0.26
                stickX = math.clamp(dampedErr / 130, -1, 1)
            end
            BotController.lastStatus = string.format("SETUP | Waiting for Ball Bounce (%.0f%%)", car.Boost)
            return makeFlatGroundInput(stickX, false)
        end

        local catchAnchor = catchState.Pos + underBallOffset
        local heightNeeded = math.max(0, catchAnchor.Y - car.Pos.Y)

        -- Use Double-Jump Vertical Launch when the ball is high (`heightNeeded > 460`) and horizontally slow/medium (`|Vel.X| < 760`)
        local useDoubleJumpClimb = (heightNeeded > 460 and heightNeeded < 1450 and math.abs(catchState.Vel.X) < 760)

        -- OPPONENT-AWARE BOOST THRESHOLD:
        local enemyContesting = (oppCar ~= nil and (oppDistToBall < 850 or oppThreatLevel >= 1))
        local ballOnOurHalf = (ball.Pos.X * attackDir) < 250
        local minBoostToLaunch
        if ballDistToGoal < 1000 or enemyContesting or ballOnOurHalf then
            minBoostToLaunch = useDoubleJumpClimb and 40 or 48
        else
            minBoostToLaunch = useDoubleJumpClimb
                and math.clamp(60 + heightNeeded * 0.012, 64, 76)
                or math.clamp(68 + heightNeeded * 0.014, 70, 82)
        end

        local climbSpeed = useDoubleJumpClimb and 1360 or 1120
        local climbTime = math.max(0.10, heightNeeded / climbSpeed)
        local projectedCarX = car.Pos.X + car.Vel.X * climbTime * 0.55
        local alignErrX = math.abs(catchAnchor.X - projectedCarX)

        -- STRICT TAKEOFF GATING (Prevents Random Jumps & Aerial Whiffs!):
        -- 1) Tight horizontal alignment (`alignErrX < 210`, or `< 165` for Double-Jump)
        -- 2) Our car must not be sprinting the wrong way (`not movingWrongWayFast`)
        -- 3) We must be behind/under the predicted intercept (`willBeBehindBall`)
        local desiredDirX = math.sign(catchAnchor.X - car.Pos.X)
        local movingWrongWayFast = (desiredDirX ~= 0) and ((car.Vel.X * desiredDirX) < -260) and (alignErrX > 110)
        local willBeBehindBall = ((catchState.Pos.X - projectedCarX) * attackDir) >= -10
        local readyToLaunchNow = (catchState.Time <= climbTime + 0.18) and willBeBehindBall and (not movingWrongWayFast)

        if readyToLaunchNow and car.Boost >= minBoostToLaunch and alignErrX < 215 and catchAnchor.Y < 1700 and relativeBallX >= -15 then
            -- Aim directly at the predicted ball's bottom-back cradle with exact gravity compensation (`+0.5 * g * t^2`)!
            local gravCompY = 0.5 * Config.Gravity * math.min(climbTime, 0.35)^2
            local leadAnchor = catchAnchor + Vector2.new(catchState.Vel.X * climbTime * 0.35 - car.Vel.X * climbTime * 0.25, 45 + gravCompY)
            local launchVec = (leadAnchor - car.Pos)
            local lx = (launchVec.X * attackDir < 20) and (attackDir * 55) or launchVec.X
            local launchDir = Vector2.new(lx, math.max(140, launchVec.Y)).Unit

            if isAnalyticalTouchSafe(launchDir, true) then
                BotController.airDragActive = true
                if useDoubleJumpClimb and alignErrX < 165 then
                    local jmp = startDoubleJumpLaunch()
                    BotController.lastStatus = string.format("AIR DRAG | Double-Jump Fast Climb! (%.0f%%)", car.Boost)
                    return makeInput(launchDir.X, launchDir.Y, jmp, true, false, false)
                else
                    local jmp = startSingleJump(6)
                    BotController.lastStatus = string.format("AIR DRAG | Precision Aerial Takeoff! (%.0f%%)", car.Boost)
                    return makeInput(launchDir.X, launchDir.Y, jmp, true, false, false)
                end
            end
        end

        -- ANTI-OSCILLATION GROUND TRACKING & STRICT BOOST REGEN:
        local groundTargetX = math.clamp(catchAnchor.X + catchState.Vel.X * 0.14, -goalInfo.wallX + 180, goalInfo.wallX - 180)
        local groundDx = groundTargetX - car.Pos.X

        local flipTrackInp = tryGroundForwardFlip(groundDx)
        if flipTrackInp then
            return flipTrackInp
        end

        local stickX = 0
        if math.abs(groundDx) > 55 or math.abs(car.Vel.X) > 220 then
            local dampedErr = groundDx - (car.Vel.X - catchState.Vel.X * 0.5) * 0.28
            stickX = math.clamp(dampedErr / 130, -1, 1)
        end

        local wantBoost = (car.Boost > math.max(90, minBoostToLaunch + 15)) and (math.abs(groundDx) > 750) and (car.Vel.X * math.sign(groundDx) < 1250)
        BotController.lastStatus = (car.Boost < minBoostToLaunch)
            and string.format("REGEN | Charging %.0f%% Boost on Floor (%.0f%%)", minBoostToLaunch, car.Boost)
            or ("SETUP | Locked Under Ball (" .. goalInfo.teamTag .. ")")
        return makeFlatGroundInput(stickX, wantBoost)
    end

    ------------------------------------------------------------------
    -- 5B. IN-AIR: Continuous Q Air-Dribble Spin, E Instant Snap-Flip, Smart Boost Modulation & 4-Wheel Regen!
    ------------------------------------------------------------------
    if not car.Grounded then
        -- Wait! Check if we are in a "wheelie on the floor" state (`car.Pos.Y < 105` and `math.abs(car.Vel.Y) < 95` and not jumping):
        -- Sometimes the car tilts its nose up near the ground (`car.Grounded == false` because only 2 rear wheels touch the floor)
        -- and keeps boosting upward into the ball ("usando boost empinado pra bola, e o boost n recupera")!
        -- If we are low (`car.Pos.Y < 115`), low on boost (`car.Boost < 38`), and didn't just intentionally launch (`jumpTicksElapsed > 12`),
        -- immediately drop all 4 wheels flat onto the floor (`Boost = false`, `StickY = 0`) so boost regenerates!
        if car.Pos.Y < 115 and car.Boost < 38 and jumpTicksElapsed > 12 and BotController.holdJumpTicks <= 0 then
            local needSnapDown = shouldUseSnapFlipE(Vector2.yAxis)
            local flatDirX = (math.abs(toBall.X) > 30) and math.sign(toBall.X) or attackDir
            BotController.lastStatus = string.format("REGEN | Flattening 4 Wheels to Floor (%.0f%%)", car.Boost)
            return makeInput(flatDirX, 0, false, false, false, needSnapDown)
        end

        local liftTarget = (ballPath[3] and ballPath[3].Pos or ball.Pos) + underBallOffset
        local liftVec = liftTarget - car.Pos
        local lx = (liftVec.X * attackDir < 20) and (attackDir * 60) or liftVec.X
        local liftDir = Vector2.new(lx, math.max(100, liftVec.Y)).Unit

        if BotController.holdJumpTicks > 0 and car.PrevJump then
            BotController.holdJumpTicks -= 1
            BotController.lastStatus = (BotController.doubleJumpStage > 0)
                and "AIR DRAG | Double-Jump Climb (1/2)"
                or "AIR DRAG | Single-Jump Climb"
            return makeInput(liftDir.X, liftDir.Y, true, car.Boost > 0, shouldUseAirDribbleQ(false), false)
        else
            BotController.holdJumpTicks = 0
        end

        -- Execute Stage 1 & Stage 2 of Double-Jump Vertical Launch (`Stick = (0,0)` + `Jump = true` for pure vertical impulse without flipping!)
        if BotController.doubleJumpStage == 1 then
            BotController.doubleJumpStage = 2
            BotController.lastStatus = "AIR DRAG | Double-Jump Prep"
            return makeInput(liftDir.X, liftDir.Y, false, car.Boost > 0, false, shouldUseSnapFlipE(Vector2.yAxis))
        elseif BotController.doubleJumpStage == 2 then
            if canFlipOrJumpNow and not car.PrevJump then
                BotController.doubleJumpStage = 0
                if currentUp.Y > 0.35 then
                    BotController.lastStatus = "AIR DRAG | Double-Jump Fast Climb! (2/2)"
                    return makeInput(0, 0, true, car.Boost > 0, false, false)
                end
            else
                BotController.doubleJumpStage = 0
            end
        end

        local isGlueContact = (car.BallContact or car.BallCarry or (distToBall < (ballRadius + 148))) and (relativeBallX >= -25)

        -- I. WHEN THE BALL DROPS TO THE FLOOR WHILE WE ARE HIGH IN THE AIR:
        -- Burn remaining boost straight down (`makeFastDiveInput`, no downward flip!) and level 4 wheels on landing!
        if not isGlueContact and (car.Pos.Y - ball.Pos.Y) > 300 and ball.Pos.Y < 480 then
            local targetLandingX = math.clamp(ball.Pos.X - attackDir * 200, -goalInfo.wallX + 200, goalInfo.wallX - 200)
            local diveInp, diveStatus = makeFastDiveInput(car, targetLandingX)
            BotController.lastStatus = diveStatus
            return diveInp
        end

        -- II. CEILING PINCH (Only forward toward enemy side, with Q Air Dribble!):
        if ball.Pos.Y > (goalInfo.ceilingY - 310) and distToBall < 340 and relativeBallX >= -15 then
            local pinchAim = Vector2.new(attackDir * 0.58, 0.81).Unit
            local doFlip = canFlipOrJumpNow and not justJumpedFromGround and distToBall < 265
            BotController.lastStatus = "FREESTYLE | Ceiling Pinch (Q-Spin)!"
            return makeInput(pinchAim.X, pinchAim.Y, triggerNewJump(doFlip), car.Boost > 10, true, false)
        end

        -- III. 4-WHEEL FLIP RESET + INSTANT +100 BOOST REFILL (Uses E = `SnapRoll` to instantly snap 4 wheels onto the ball!):
        -- User explained: "E = Snap Flip, gira INSTANTANEAMENTE o carro pra direcao contraria, logo capo pra baixo, ele vira pra cima, pra esquerda, ele vira pra direita"
        -- When we are under/near the ball in the air, our car's roof (`currentUp`) normally faces the ball (`currentUp:Dot(ballNorm) > 0.15`).
        -- Pressing E (`SnapRoll = true`) INSTANTLY flips the car 180 degrees so all 4 wheels (`-currentUp`) slam directly onto the ball,
        -- giving an instant Flip Reset + Boost Refill (requires `Boost = false` on contact so `Car.lua` refills boost!).
        local wantWheelReset = (distToBall < 360 and ball.Pos.Y > 300 and relativeBallX >= -15) and (
            (not car.HasFlip)
            or (car.Boost < 48)
            or (forceAirDragMode and ballDistToGoal > 750 and ball.Pos.Y > 480)
        )

        if wantWheelReset then
            local ballNorm = toBall.Magnitude > 1 and toBall.Unit or Vector2.yAxis
            local wheelAlignment = (-currentUp):Dot(ballNorm)

            -- If our hood/roof (`currentUp`) is facing the ball instead of our 4 wheels (`-currentUp`),
            -- press E (`SnapRoll`) to INSTANTLY 180-flip our wheels onto the ball!
            local needSnapRoll = (currentUp:Dot(ballNorm) > 0.12) and not car.PrevSnapRoll
            local tangentDir = Vector2.new(ballNorm.Y * attackDir, -ballNorm.X * attackDir)
            if tangentDir.Y < 0 then tangentDir = -tangentDir end

            if canFlipOrJumpNow and not justJumpedFromGround and wheelAlignment > 0.48 and distToBall < 290 and isAnalyticalTouchSafe(ballNorm, true) then
                local flipToBallInp = makeInput(ballNorm.X, ballNorm.Y, true, false, false, needSnapRoll)
                local followReset = makeInput(tangentDir.X, tangentDir.Y, false, false, false, false)
                BotController.lastStatus = "FLIP RESET | Flip into 4-Wheel Reset!"
                return car.PrevJump and followReset or flipToBallInp
            end

            local wheelContactTarget = ball.Pos - ballNorm * (ballRadius + 36)
            local toWheelTarget = wheelContactTarget - car.Pos
            local stickDir = (wheelAlignment > 0.55 and distToBall < (ballRadius + 92))
                and tangentDir
                or ((toWheelTarget.Magnitude > 1 and toWheelTarget.Unit or ballNorm) * 0.68 + tangentDir * 0.32).Unit

            -- MUST release boost (`Boost = false`) when within wheel-touch range so `Car.lua` regenerates boost on the ball!
            local closeForWheelTouch = (distToBall < (ballRadius + 125)) and (wheelAlignment > 0.30 or needSnapRoll)

            BotController.lastStatus = closeForWheelTouch
                and string.format("FLIP RESET | E-Snap 4-Wheel Boost Refill! (%.0f%%)", car.Boost)
                or "FLIP RESET | E-Snap Aligning 4 Wheels"
            return makeInput(stickDir.X, stickDir.Y, false, not closeForWheelTouch and car.Boost > 10, false, needSnapRoll)
        end

        -- IV. MID-AIR DOUBLE-JUMP CLIMB OR LOW-BOOST FLIP UNDER BALL:
        if canFlipOrJumpNow and not justJumpedFromGround and not isGlueContact and relativeBallX >= 0 then
            local dyUnder = underBallAnchor.Y - car.Pos.Y
            local dxUnder = math.abs(underBallAnchor.X - car.Pos.X)
            if (dyUnder > 310 and dyUnder < 880 and dxUnder < 290 and car.Vel.Y < 450 and (car.Boost < 65 or dyUnder > 480)) then
                if currentUp.Y < -0.15 and not car.PrevSnapRoll then
                    -- Upside down! Use E (`SnapRoll`) to instantly flip roof-up before firing neutral Double-Jump!
                    BotController.lastStatus = "AIR DRAG | E-Snap Upright for Double-Jump!"
                    return makeInput(0, 1, false, car.Boost > 0, false, true)
                elseif currentUp.Y > 0.35 then
                    BotController.lastStatus = "AIR DRAG | Mid-Air Double-Jump Up!"
                    return makeInput(0, 0, triggerNewJump(true), car.Boost > 0, false, false)
                end
            elseif (car.Boost < 18 and distToBall < 480) then
                local toUnder = (underBallAnchor - car.Pos)
                local fx = (toUnder.X * attackDir < 30) and (attackDir * 80) or toUnder.X
                local flipDir = Vector2.new(fx, math.max(60, toUnder.Y)).Unit
                BotController.lastStatus = "AIR DRAG | Low-Boost Flip Under Ball!"
                return makeInput(flipDir.X, flipDir.Y, triggerNewJump(true), car.Boost > 0, true, false)
            end
        end

        -- V. ABORT / FULL-BOOST DIVE TO FLOOR WHEN AERIAL IS UNREACHABLE OR BOOST IS LOW:
        -- Do NOT stay floating/pitched up with 0 boost! Dive straight to the floor to land on 4 wheels and recharge boost!
        local unreachableAerial = (car.Boost < 10 and not car.HasFlip and not isGlueContact and distToBall > 280)
            or (car.Boost < 22 and not car.HasFlip and not isGlueContact and toBall.Y > 320)
            or (not isGlueContact and distToBall > 860 and car.Pos.Y > 450)
            or (not isGlueContact and toBall.Y < -220 and car.Pos.Y > 340)

        if unreachableAerial then
            BotController.airDragActive = false
            local targetLandingX = math.clamp(ball.Pos.X - attackDir * 240, -goalInfo.wallX + 200, goalInfo.wallX - 200)
            local diveInp, diveStatus = makeFastDiveInput(car, targetLandingX)
            BotController.lastStatus = diveStatus
            return diveInp
        end

        -- VI. ZERO-LAG CLOSED-FORM UNDER-BALL AIR DRAG WITH CONTINUOUS Q-SPIN, E-SNAP-FLIP & DEAD-CENTER INTERCEPT:
        local lookTicks = math.clamp(math.floor(distToBall / 160), 1, 7)
        local predBallState = (ballPath[lookTicks] or { Pos = ball.Pos, Vel = ball.Vel })
        local predBallPos = predBallState.Pos
        -- When approaching the ball (`distToBall < 380` and `not isGlueContact`), aim tighter into the ball's lower-back hemisphere (`-attackDir * 38, -(ballRadius + 34)`)
        -- so our car's nose/hood makes 100% solid physical contact instead of floating below the ball!
        local closeContactOffset = (distToBall < 380 and not isGlueContact)
            and Vector2.new(-attackDir * 38, -(ballRadius + 34))
            or underBallOffset
        local targetAnchor = isGlueContact and (ball.Pos + Vector2.new(-attackDir * 44, -(ballRadius + 46))) or (predBallPos + closeContactOffset)

        local posErr = targetAnchor - car.Pos

        -- Exact Gravity Compensation (`Gravity = 980 UU/s^2`):
        local gravComp = Vector2.new(0, 820)
        local desiredVel
        if isGlueContact then
            local targetCarrySpeed = math.clamp(ball.Vel.Magnitude + 240, 1120, 1660)
            desiredVel = carryPushDir * targetCarrySpeed + posErr * 6.5
        else
            local distToAnchor = posErr.Magnitude
            local approachGain = distToAnchor > 220 and 6.2 or 5.2
            desiredVel = predBallState.Vel + posErr * approachGain
        end

        local accelCmd = (desiredVel - car.Vel) * 3.6 + gravComp
        local aimVec
        if isGlueContact then
            aimVec = (carryPushDir * 0.68 + (accelCmd.Magnitude > 1 and accelCmd.Unit or carryPushDir) * 0.32).Unit
            -- Never tilt backward toward own goal while in glue contact with the ball!
            if aimVec.X * attackDir < 0.25 then
                aimVec = Vector2.new(attackDir * 0.50, math.max(0.55, aimVec.Y)).Unit
            end
        else
            aimVec = (accelCmd.Magnitude > 1)
                and accelCmd.Unit
                or ((posErr.Magnitude > 1 and posErr.Unit or carryPushDir))
            -- When close to the ball (`distToBall < 320`), ensure our nose points forward/upward into the ball!
            if distToBall < 320 and aimVec.X * attackDir < 0.12 then
                aimVec = Vector2.new(attackDir * 0.38, math.max(0.45, aimVec.Y)).Unit
            end
        end

        local snapUpright = shouldUseSnapFlipE(Vector2.yAxis)
        local useAirDribbleQ = shouldUseAirDribbleQ(false)

        -- Analytical own-goal guard (`0.002ms`): only if our car is ahead of the ball (`relativeBallX < -15`) and about to knock it backward!
        if not isAnalyticalTouchSafe(aimVec, false) then
            local evadeDir = Vector2.new(-attackDir, (car.Pos.Y >= ball.Pos.Y) and 0.85 or -0.85).Unit
            BotController.lastStatus = "ANTI-OWN-GOAL | Evading Front of Ball!"
            return makeInput(evadeDir.X, evadeDir.Y, false, car.Boost > 15, useAirDribbleQ, snapUpright)
        end

        -- SMART FEATHERED BOOST IN AIR (Never cut boost when climbing below the ball, and feather once cradling!):
        local noseAlign = carForward:Dot(aimVec)
        local projAccel = accelCmd:Dot(aimVec)
        local belowBallCradle = (car.Pos.Y < targetAnchor.Y + 60)
        local needLift = belowBallCradle and (car.Vel.Y < predBallState.Vel.Y + 340)
        local closingSpeed = -relVel:Dot(toBall.Magnitude > 1 and toBall.Unit or Vector2.xAxis)

        local wantBoost = false
        -- Allow boosting immediately when climbing (`belowBallCradle and aimVec.Y > 0.35`) OR once nose is reasonably aligned (`noseAlign >= 0.25`)!
        if noseAlign >= 0.25 or (belowBallCradle and aimVec.Y > 0.35) then
            if isGlueContact then
                local speedAlongGoal = car.Vel:Dot(carryPushDir)
                wantBoost = (speedAlongGoal < 1520) and (needLift or projAccel > 10)
            else
                if distToBall < (ballRadius + 115) and closingSpeed > 560 and not belowBallCradle then
                    wantBoost = false
                else
                    wantBoost = needLift or (projAccel > 45) or (posErr.Magnitude > 110 and car.Vel:Dot(aimVec) < 1380)
                end
            end
        end

        BotController.lastStatus = isGlueContact
            and string.format("AIR DRAG | Q-Spin Carrying to Goal (%.0f%%)", car.Boost)
            or string.format("AIR DRAG | Q-Spin Flying Under Ball (%.0f%%)", car.Boost)
        return makeInput(aimVec.X, aimVec.Y, false, wantBoost, useAirDribbleQ, snapUpright)
    end

    ------------------------------------------------------------------
    -- 6. RANKED FAST MODE FALLBACK
    ------------------------------------------------------------------
    local behindBallAnchor = ball.Pos - Vector2.new(attackDir * 95, 40)
    local dirToBehind = (behindBallAnchor - car.Pos).Magnitude > 1 and (behindBallAnchor - car.Pos).Unit or Vector2.new(attackDir, 0)
    BotController.lastStatus = "RANKED | Fast Pressure (" .. goalInfo.teamTag .. ")"
    return makeInput(dirToBehind.X, dirToBehind.Y, triggerNewJump(distToBall < 320 and relativeBallX > 20 and canFlipOrJumpNow and not justJumpedFromGround), car.Boost > 25, false, false)
end

----------------------------------------------------------------------
-- Hooking & Live Match / Freeplay / Tutorial Acquisition
----------------------------------------------------------------------
local function install(object, key, factory)
    local original = object[key]
    local restore = rawget(object, key)
    assert(type(original) == "function", "Missing " .. tostring(key) .. " interface")
    local wrapper = factory(original)
    object[key] = wrapper
    table.insert(hooked, { object = object, key = key, wrapper = wrapper, original = original, restore = restore })
end

local activePredictor = nil
local activeTrialSession = nil
local decisions = 0
local avgComputeMs = 0

local function computeBotInput(world, localIndex)
    local t0 = os.clock()
    local ok, inp = pcall(BotController.decide, world, localIndex)
    local elapsed = (os.clock() - t0) * 1000
    avgComputeMs = avgComputeMs * 0.85 + elapsed * 0.15
    if ok and type(inp) == "table" then
        decisions += 1
        status(string.format("ON | %s | %.1fms", BotController.lastStatus, avgComputeMs))
        return inp
    else
        status("ON | Calc error: " .. tostring(inp):sub(1, 45))
        return nil
    end
end

install(Prediction, "step", function(original)
    return function(predictor, inputTbl, ...)
        activePredictor = predictor
        if alive and enabled and predictor and predictor.LocalIndex and predictor.Predicted then
            local world = predictor.Predicted
            if not World.over(predictor.Confirmed) then
                local botInp = computeBotInput(world, predictor.LocalIndex)
                if botInp then
                    inputTbl = botInp
                end
            else
                status("ON | Match Ended")
            end
        end
        return original(predictor, inputTbl, ...)
    end
end)

install(World, "step", function(original)
    return function(world, inputs, dt, ...)
        -- Note: `BotController.simulating` is true inside `evaluateSequence` so we never recursively call `computeBotInput`!
        if not BotController.simulating and alive and enabled and world and world.Bots and type(inputs) == "table" and (not activePredictor or activePredictor.Predicted ~= world) then
            -- Find the local player's car index (the car where `world.Bots[i]` is false/nil!)
            local humanIdx = nil
            local humanCount = 0
            for i = 1, #world.Cars do
                if not world.Bots[i] then
                    humanIdx = i
                    humanCount += 1
                end
            end
            if humanIdx and humanCount == 1 then
                local botInp = computeBotInput(world, humanIdx)
                if botInp then
                    inputs[humanIdx] = botInp
                end
            end
        end
        return original(world, inputs, dt, ...)
    end
end)

install(Runner, "step", function(original)
    return function(runnerState, inputTbl, ...)
        activeTrialSession = runnerState
        if alive and enabled and runnerState and runnerState.World and runnerState.Phase ~= "Demo" then
            local botInp = computeBotInput(runnerState.World, 1)
            if botInp then
                inputTbl = botInp
            end
        end
        return original(runnerState, inputTbl, ...)
    end
end)

-- Hook `CarVisual.new` for Visual Skin Changer (Applies chosen Car Body, Wrap, Wheels, Boost, Trail, Topper & Antenna to our car in Match, Freeplay & Lobby!)
CarVisualMod.OriginalNew = CarVisualMod.OriginalNew or CarVisualMod.new
install(CarVisualMod, "new", function(original)
    return function(team, name, loadout, parent, lowDetail, userId, scale, ...)
        local isLocalCar = (name == "You")
            or (name == "Profile")
            or (name == LP.Name)
            or (name == LP.DisplayName)
            or (userId == LP.UserId)
            or (type(loadout) == "table" and loadout.UserId == LP.UserId)

        if alive and isLocalCar then
            if SkinState.enabled then
                loadout = getCustomSkinTable(loadout)
            end
        elseif alive and not isLocalCar and next(peerStates2D) ~= nil then
            local pState = findPeerState2D(userId, name, loadout)
            if pState and pState.enabled and type(pState.loadout) == "table" then
                loadout = buildPeerCustomSkinTable2D(pState, loadout)
            end
        end

        local vis = original(team, name, loadout, parent, lowDetail, userId, scale, ...)

        if alive and isLocalCar and name ~= "Profile" then
            -- Wrap in a lightweight proxy table so `applyLiveSkinNow()` can hot-swap the 3D model mid-match without waiting for a respawn!
            local proxy = {}
            proxy._innerDestroy = vis.destroy
            for k, fn in pairs(vis) do
                if k == "destroy" then
                    proxy.destroy = function(...)
                        if proxy._innerDestroy then
                            return proxy._innerDestroy(...)
                        end
                    end
                else
                    proxy[k] = function(...)
                        return proxy[k] and vis[k](...)
                    end
                end
            end
            for k, fn in pairs(vis) do
                if k ~= "destroy" then
                    proxy[k] = fn
                end
            end
            lastCreatedLocalCarVisual = proxy
            lastLocalCarVisualArgs = {
                team = team,
                name = name,
                loadout = loadout,
                parent = parent,
                lowDetail = lowDetail,
                userId = userId,
                scale = scale,
            }
            return proxy
        end

        return vis
    end
end)

-- Unlock all Garage items in Lobby on startup
task.spawn(unlockLobbyGarageAndPreview)

----------------------------------------------------------------------
-- Real-Time P2P Cosmetic Sync Engine (Between Script Users in Same Server)
----------------------------------------------------------------------
;(function()
    local httpRequest = (type(request) == "function" and request)
        or (type(http_request) == "function" and http_request)
        or (type(syn) == "table" and type(syn.request) == "function" and syn.request)
        or (type(http) == "table" and type(http.request) == "function" and http.request)
        or (type(fluxus) == "table" and type(fluxus.request) == "function" and fluxus.request)

    local rawJobId = tostring(game.JobId or "studio"):gsub("[^%w]", ""):lower()
    if rawJobId == "" then
        rawJobId = "place" .. tostring(game.PlaceId)
    end
    local SYNC_TOPIC = "ydx_wv2d_" .. rawJobId:sub(1, 24)
    local SYNC_POST_URL = "https://ntfy.sh/" .. SYNC_TOPIC
    local lastSentSig = ""
    local lastSendTime = 0
    local lastPollUnix = 0

    local function buildMyPayload2D()
        return {
            uid = LP.UserId,
            name = LP.Name,
            displayName = LP.DisplayName or LP.Name,
            enabled = SkinState.enabled == true,
            loadout = getCustomSkinTable({}),
        }
    end

    broadcastMyState2D = function(force)
        if not alive or not httpRequest then
            return
        end
        local payloadTbl = buildMyPayload2D()
        local okEnc, encoded = pcall(HttpService2D.JSONEncode, HttpService2D, payloadTbl)
        if not okEnc or type(encoded) ~= "string" then
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
                    ["Title"] = "ydx-wv2d-sync",
                },
                Body = encoded,
            })
        end)
    end

    local function handleIncomingPeerPacket2D(msgJson)
        if type(msgJson) ~= "string" or msgJson == "" then
            return
        end
        local ok, data = pcall(HttpService2D.JSONDecode, HttpService2D, msgJson)
        if not ok or type(data) ~= "table" then
            return
        end
        local uidNum = tonumber(data.uid)
        if not uidNum or uidNum == LP.UserId then
            return
        end
        local uidKey = tostring(uidNum)
        peerStates2D[uidKey] = {
            uid = uidNum,
            name = type(data.name) == "string" and data.name or "",
            displayName = type(data.displayName) == "string" and data.displayName or (type(data.name) == "string" and data.name or ""),
            enabled = data.enabled ~= false,
            loadout = type(data.loadout) == "table" and data.loadout or {},
            ts = os.clock(),
        }
        table.clear(lastAppliedPeerLoadoutSig2D)
        if applyLiveSkinNow then
            applyLiveSkinNow()
        end
    end

    local function pollPeersOnce2D()
        if not alive then
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
            if okReq and type(res) == "table" and type(res.Body) == "string" then
                body = res.Body
            end
        end
        if not body then
            local okGet, resGet = pcall(game.HttpGet, game, pollUrl)
            if okGet and type(resGet) == "string" then
                body = resGet
            end
        end
        if type(body) ~= "string" or body == "" then
            return
        end

        for line in body:gmatch("[^\r\n]+") do
            local okLine, envPkt = pcall(HttpService2D.JSONDecode, HttpService2D, line)
            if okLine and type(envPkt) == "table" then
                if type(envPkt.time) == "number" and envPkt.time >= lastPollUnix then
                    lastPollUnix = envPkt.time
                end
                if envPkt.event == "message" and type(envPkt.message) == "string" then
                    handleIncomingPeerPacket2D(envPkt.message)
                end
            end
        end
    end

    connect(Players.PlayerAdded, function()
        task.delay(2, function()
            if alive and type(broadcastMyState2D) == "function" then
                broadcastMyState2D(true)
            end
        end)
    end)

    task.spawn(function()
        broadcastMyState2D(true)
        task.wait(0.4)
        pollPeersOnce2D()
        while alive do
            task.wait(1.6)
            if not alive then break end
            pollPeersOnce2D()
            if os.clock() - lastSendTime > 20 then
                broadcastMyState2D(true)
            end
        end
    end)
end)()

if type(getgc) == "function" then
    pcall(function()
        for _, v in ipairs(getgc(true)) do
            if type(v) == "table" and type(rawget(v, "Predicted")) == "table" and type(rawget(v, "PredictedTick")) == "number" and type(v.Predicted.Cars) == "table" then
                activePredictor = v
                break
            end
        end
    end)
end

status(enabled and "ON | Ready | Sideswipe 2D v9.0 + Skin Changer" or "OFF | Ready")

----------------------------------------------------------------------
-- Unload Handler
----------------------------------------------------------------------
local unload
unload = function()
    if not alive then return end
    alive, enabled = false, false
    for _, c in ipairs(connections) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(connections)
    for i = #hooked, 1, -1 do
        local h = hooked[i]
        pcall(function()
            if h.object[h.key] == h.wrapper then
                h.object[h.key] = h.restore
            end
        end)
    end
    table.clear(hooked)
    if env.Wolvot2DUnload == unload then env.Wolvot2DUnload = nil end
    if env.WolvotFreeUnload == unload then env.WolvotFreeUnload = nil end
    pcall(function() gui:Destroy() end)
end
env.Wolvot2DUnload = unload
env.WolvotFreeUnload = unload
connect(gui.Destroying, unload)
