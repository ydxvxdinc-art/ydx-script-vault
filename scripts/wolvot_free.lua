--!native
--!optimize 2
-- Wolvot Free local Luau policy. Blox League and Turbo Soccer adapters.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local env = type(getgenv) == "function" and getgenv() or _G

if type(env.ExperimentalBotUnload) == "function" then pcall(env.ExperimentalBotUnload) end
if type(env.WolvotFreeUnload) == "function" then pcall(env.WolvotFreeUnload) end

local alive, enabled, ready = true, true, true
local connections = {}

----------------------------------------------------------------------
-- UI
----------------------------------------------------------------------
local ACCENT = Color3.fromRGB(88, 130, 255)
local ON_COLOR = Color3.fromRGB(52, 190, 120)
local OFF_COLOR = Color3.fromRGB(48, 52, 70)

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

local gui = Instance.new("ScreenGui")
gui.Name = "WolvotFreeBot"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 80
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LP:WaitForChild("PlayerGui")

local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.fromOffset(270, 180)
shadow.Position = UDim2.new(0, 20, .28, 5)
shadow.BackgroundColor3 = Color3.new(0, 0, 0)
shadow.BackgroundTransparency = .55
shadow.BorderSizePixel = 0
shadow.ZIndex = 1
shadow.Parent = gui
corner(shadow, 14)

local frame = Instance.new("Frame")
frame.Name = "Panel"
frame.Size = UDim2.fromOffset(270, 180)
frame.AnchorPoint = Vector2.zero
frame.Position = UDim2.new(0, 20, .28, 0)
frame.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.ZIndex = 2
frame.Parent = gui
corner(frame, 14)
strokeOf(frame, ACCENT, 1.2, .55)

local frameGradient = Instance.new("UIGradient")
frameGradient.Color = ColorSequence.new(Color3.fromRGB(34, 38, 56), Color3.fromRGB(16, 18, 27))
frameGradient.Rotation = 90
frameGradient.Parent = frame

local header = Instance.new("TextLabel")
header.Name = "DragHandle"
header.Size = UDim2.new(1, 0, 0, 36)
header.BackgroundTransparency = 1
header.Text = "WOLVOT  FREE"
header.Font = Enum.Font.GothamBlack
header.TextColor3 = Color3.fromRGB(235, 239, 250)
header.TextSize = 14
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
version.Text = "v1.3.0  |  P2P Sync  |  C preset"
version.Font = Enum.Font.Gotham
version.TextSize = 11
version.TextColor3 = Color3.fromRGB(120, 130, 160)
version.TextXAlignment = Enum.TextXAlignment.Right
version.Parent = frame

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -24, 0, 1)
divider.Position = UDim2.fromOffset(12, 36)
divider.BackgroundColor3 = ACCENT
divider.BackgroundTransparency = .8
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
strokeOf(toggle, ACCENT, 1, .75)

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
local bindStroke = strokeOf(bindBtn, ACCENT, 1, .7)

local bindPadding = Instance.new("UIPadding")
bindPadding.PaddingLeft = UDim.new(0, 5)
bindPadding.PaddingRight = UDim.new(0, 5)
bindPadding.Parent = bindBtn

local bindText = Instance.new("UITextSizeConstraint")
bindText.MaxTextSize = 14
bindText.MinTextSize = 8
bindText.Parent = bindBtn

local skinBtn = Instance.new("TextButton")
skinBtn.Name = "SkinBtn"
skinBtn.Size = UDim2.new(1, -24, 0, 34)
skinBtn.Position = UDim2.fromOffset(12, 92)
skinBtn.BackgroundColor3 = Color3.fromRGB(48, 42, 74)
skinBtn.Text = "SKIN: GARAGE UNLOCKED >"
skinBtn.Font = Enum.Font.GothamBold
skinBtn.TextSize = 12
skinBtn.TextColor3 = Color3.fromRGB(255, 215, 95)
skinBtn.BorderSizePixel = 0
skinBtn.ZIndex = 3
skinBtn.Parent = frame
corner(skinBtn, 8)
local skinBtnStroke = strokeOf(skinBtn, Color3.fromRGB(255, 200, 70), 1, .45)

local label = Instance.new("TextLabel")
label.Name = "Status"
label.Size = UDim2.new(1, -24, 0, 34)
label.Position = UDim2.fromOffset(12, 134)
label.Text = "Loading model..."
label.TextColor3 = Color3.fromRGB(150, 162, 195)
label.Font = Enum.Font.Gotham
label.TextSize = 12
label.TextWrapped = true
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextYAlignment = Enum.TextYAlignment.Top
label.BackgroundTransparency = 1
label.Parent = frame

-- Visual polish: gradients, hover/press feedback, intro animation, live status colors.
local TweenService = game:GetService("TweenService")
local function tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or .18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local toggleGrad = Instance.new("UIGradient")
toggleGrad.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(190, 190, 205))
toggleGrad.Rotation = 90
toggleGrad.Parent = toggle

local bindGrad = toggleGrad:Clone()
bindGrad.Parent = bindBtn

local skinGrad = toggleGrad:Clone()
skinGrad.Parent = skinBtn

local toggleScale = Instance.new("UIScale")
toggleScale.Parent = toggle

local function hoverable(button, scale)
    button.MouseEnter:Connect( function() tween(scale, { Scale = 1.03 }, .12) end)
    button.MouseLeave:Connect( function() tween(scale, { Scale = 1 }, .12) end)
    button.MouseButton1Down:Connect( function() tween(scale, { Scale = .96 }, .08) end)
    button.MouseButton1Up:Connect( function() tween(scale, { Scale = 1.03 }, .08) end)
end
local bindScale = Instance.new("UIScale")
bindScale.Parent = bindBtn
local skinScale = Instance.new("UIScale")
skinScale.Parent = skinBtn
hoverable(toggle, toggleScale)
hoverable(bindBtn, bindScale)
hoverable(skinBtn, skinScale)

local statusPill = Instance.new("Frame")
statusPill.Name = "StatusBar"
statusPill.Size = UDim2.new(1, -24, 0, 34)
statusPill.Position = UDim2.fromOffset(12, 134)
statusPill.BackgroundColor3 = Color3.fromRGB(30, 34, 50)
statusPill.BackgroundTransparency = 0
statusPill.ZIndex = 3
statusPill.BorderSizePixel = 0
statusPill.Parent = frame
corner(statusPill, 8)
strokeOf(statusPill, ACCENT, 1, .85)
label.Parent = statusPill
label.Position = UDim2.fromOffset(10, 0)
label.Size = UDim2.new(1, -20, 1, 0)
label.TextYAlignment = Enum.TextYAlignment.Center
label.TextSize = 12
label.ZIndex = 4
label.TextTruncate = Enum.TextTruncate.AtEnd
label.TextWrapped = false

----------------------------------------------------------------------
-- Instant Visual Skin Changer & Native Garage Unlocker (Turbo Soccer)
----------------------------------------------------------------------
local skinPanel = Instance.new("Frame")
skinPanel.Name = "SkinChangerPanel"
skinPanel.Size = UDim2.fromOffset(296, 506)
skinPanel.Position = UDim2.new(1, 12, 0, 0)
skinPanel.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
skinPanel.BorderSizePixel = 0
skinPanel.Visible = false
skinPanel.Active = true
skinPanel.ZIndex = 10
skinPanel.Parent = frame
corner(skinPanel, 14)
strokeOf(skinPanel, Color3.fromRGB(255, 200, 70), 1.2, .45)

local skinPanelGrad = Instance.new("UIGradient")
skinPanelGrad.Color = ColorSequence.new(Color3.fromRGB(34, 38, 56), Color3.fromRGB(16, 18, 27))
skinPanelGrad.Rotation = 90
skinPanelGrad.Parent = skinPanel

local skinTitle = Instance.new("TextLabel")
skinTitle.Size = UDim2.new(1, -20, 0, 28)
skinTitle.Position = UDim2.fromOffset(12, 4)
skinTitle.BackgroundTransparency = 1
skinTitle.Text = "VISUAL SKIN CHANGER (L/R CLICK)"
skinTitle.Font = Enum.Font.GothamBlack
skinTitle.TextSize = 12
skinTitle.TextColor3 = Color3.fromRGB(255, 215, 95)
skinTitle.TextXAlignment = Enum.TextXAlignment.Left
skinTitle.ZIndex = 11
skinTitle.Parent = skinPanel

local skinDivider = Instance.new("Frame")
skinDivider.Size = UDim2.new(1, -24, 0, 1)
skinDivider.Position = UDim2.fromOffset(12, 32)
skinDivider.BackgroundColor3 = Color3.fromRGB(255, 200, 70)
skinDivider.BackgroundTransparency = .75
skinDivider.BorderSizePixel = 0
skinDivider.ZIndex = 11
skinDivider.Parent = skinPanel

local skinRows = {}
local function makeSkinRow(rowIdx, titleText)
    local yPos = 38 + (rowIdx - 1) * 31
    local rowBtn = Instance.new("TextButton")
    rowBtn.Name = "Row_" .. rowIdx
    rowBtn.Size = UDim2.new(1, -24, 0, 27)
    rowBtn.Position = UDim2.fromOffset(12, yPos)
    rowBtn.BackgroundColor3 = Color3.fromRGB(28, 32, 48)
    rowBtn.Text = titleText .. ": DEFAULT"
    rowBtn.Font = Enum.Font.GothamBold
    rowBtn.TextSize = 11
    rowBtn.TextColor3 = Color3.fromRGB(230, 236, 252)
    rowBtn.TextTruncate = Enum.TextTruncate.AtEnd
    rowBtn.BorderSizePixel = 0
    rowBtn.ZIndex = 12
    rowBtn.Parent = skinPanel
    corner(rowBtn, 7)
    strokeOf(rowBtn, ACCENT, 1, .8)
    skinRows[rowIdx] = rowBtn
    return rowBtn
end

local rowPreset = makeSkinRow(1, "PRESET")
local rowCar    = makeSkinRow(2, "CAR BODY")
local rowPaint  = makeSkinRow(3, "PAINT")
local rowAccent = makeSkinRow(4, "ACCENT")
local rowFinish = makeSkinRow(5, "FINISH")
local rowDecal  = makeSkinRow(6, "DECAL")
local rowWheel  = makeSkinRow(7, "WHEELS")
local rowBoost  = makeSkinRow(8, "BOOST")
local rowTrail  = makeSkinRow(9, "TRAIL")
local rowGoal   = makeSkinRow(10, "GOAL EXP")
local rowDemo   = makeSkinRow(11, "DEMO EXP")
local rowBall   = makeSkinRow(12, "BALL & HAT")

local randomGoalBtn = Instance.new("TextButton")
randomGoalBtn.Name = "RandomGoalBtn"
randomGoalBtn.Size = UDim2.new(1, -24, 0, 26)
randomGoalBtn.Position = UDim2.fromOffset(12, 412)
randomGoalBtn.BackgroundColor3 = Color3.fromRGB(48, 52, 70)
randomGoalBtn.Text = "Random Goal: OFF (Heart Goals)"
randomGoalBtn.Font = Enum.Font.GothamBlack
randomGoalBtn.TextSize = 11
randomGoalBtn.TextColor3 = Color3.fromRGB(255, 130, 190)
randomGoalBtn.BorderSizePixel = 0
randomGoalBtn.ZIndex = 12
randomGoalBtn.Parent = skinPanel
corner(randomGoalBtn, 7)
strokeOf(randomGoalBtn, Color3.fromRGB(255, 95, 180), 1, .55)

local skinSaveBtn = Instance.new("TextButton")
skinSaveBtn.Name = "SavePresetBtn"
skinSaveBtn.Size = UDim2.new(1, -24, 0, 26)
skinSaveBtn.Position = UDim2.fromOffset(12, 442)
skinSaveBtn.BackgroundColor3 = Color3.fromRGB(230, 155, 35)
skinSaveBtn.Text = "SAVE CURRENT PRESET [FILE]"
skinSaveBtn.Font = Enum.Font.GothamBlack
skinSaveBtn.TextSize = 11
skinSaveBtn.TextColor3 = Color3.fromRGB(25, 20, 10)
skinSaveBtn.BorderSizePixel = 0
skinSaveBtn.ZIndex = 12
skinSaveBtn.Parent = skinPanel
corner(skinSaveBtn, 7)

local skinApplyBtn = Instance.new("TextButton")
skinApplyBtn.Name = "ApplyImmediate"
skinApplyBtn.Size = UDim2.new(1, -24, 0, 26)
skinApplyBtn.Position = UDim2.fromOffset(12, 472)
skinApplyBtn.BackgroundColor3 = Color3.fromRGB(52, 190, 120)
skinApplyBtn.Text = "FORCE REBUILD CAR & UNLOCK GARAGE"
skinApplyBtn.Font = Enum.Font.GothamBlack
skinApplyBtn.TextSize = 11
skinApplyBtn.TextColor3 = Color3.fromRGB(245, 250, 255)
skinApplyBtn.BorderSizePixel = 0
skinApplyBtn.ZIndex = 12
skinApplyBtn.Parent = skinPanel
corner(skinApplyBtn, 7)

-- Pulsing indicator dot while the bot is on.
task.spawn(function()
    while alive do
        if enabled then
            tween(dot, { BackgroundTransparency = .55 }, .7)
            task.wait(.7)
            tween(dot, { BackgroundTransparency = 0 }, .7)
            task.wait(.7)
        else
            dot.BackgroundTransparency = 0
            task.wait(.3)
        end
    end
end)



local message = "Loading model..."

local function connect(signal, callback)
    local c = signal:Connect(callback)
    table.insert(connections, c)
    return c
end

local function status(value)
    message = value
end

----------------------------------------------------------------------
-- Panel dragging
----------------------------------------------------------------------
local panelX, panelY, goalX, goalY, lastStep

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
    if dx * dx + dy * dy <= .01 then
        if panelX ~= goalX or panelY ~= goalY then
            panelX, panelY = goalX, goalY
            applyPanel(panelX, panelY)
        end
        return
    end
    local a = 1 - math.exp(-42 * math.clamp(dt, 0, .05))
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

local drag
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

----------------------------------------------------------------------
-- State
----------------------------------------------------------------------
local generation = 0
local action, job, pending
local nextTick, _lastTick = 0, nil
local decisions = 0
local identity, arenaIdentity, carIdentity, opponentIdentity
local centered = false
local previous = { 0, 0, 0, 0, 0, 0, 0, 0 }
local P, Input, refreshGame
local matchWaiting = "Finding game interfaces"
local blocked = false
local hooked = {}
local errorAt = 0
local trainWorldSeen, trainPads = nil, nil
local trainActive = false -- true while the single-car training world is running

local function trainControls(controls)
    local a = action
    for i = 1, 8 do previous[i] = a[i] end
    local r = table.clone(controls)
    r.throttle, r.steer, r.pitch, r.yaw, r.roll = a[1], a[2], a[3], a[4], a[5]
    r.jump, r.boost, r.handbrake = a[6] > 0, a[7] > 0, a[8] > 0
    return r
end

local function reset()
    generation += 1
    action, job, pending = nil, nil, nil
    nextTick = 0
    for i = 1, 8 do previous[i] = 0 end
end

local unload
unload = function()
    if not alive then return end
    alive, enabled = false, false
    reset()
    for _, c in connections do c:Disconnect() end
    for i = #hooked, 1, -1 do
        local h = hooked[i]
        if h.object[h.key] == h.wrapper then h.object[h.key] = h.restore end
    end
    table.clear(hooked)
    if env.WolvotFreeUnload == unload then env.WolvotFreeUnload = nil end
    gui:Destroy()
end
env.WolvotFreeUnload = unload
connect(gui.Destroying, unload)

----------------------------------------------------------------------
-- Keybinds / toggle
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
    bindStroke.Transparency = state and .35 or .7
end

local function flipToggle()
    enabled = not enabled
    reset()
    toggle.Text = enabled and "BOT ON" or "BOT OFF"
    tween(toggle, { BackgroundColor3 = enabled and ON_COLOR or OFF_COLOR }, .2)
    tween(dot, { BackgroundColor3 = enabled and ON_COLOR or ACCENT }, .2)
    status(enabled and "ON | Waiting for live match" or "OFF | Ready")
end

connect(toggle.Activated, flipToggle)
connect(bindBtn.Activated, function() setBinding(true) end)

----------------------------------------------------------------------
-- Skin Changer & Native Garage Unlocker Logic
----------------------------------------------------------------------
local cyclePresetByKey
do
    local ItemsMod, LoadoutMod, MatchViewMod, ProgressMod, InventoryMod
    local skinReady = false
    local customOverrideActive = false
    local desiredBlue = nil
    local desiredOrange = nil
    local desiredSplit = nil

    local SAVED_PRESET_FILE = "wolvot_saved_preset.json"
    local HttpService = game:GetService("HttpService")
    local saveCurrentPresetToFile = nil
    local randomGoalEnabled = false
    local savedFavoritesSet = {}
    local lastRolledGoalStyle = nil
    local lastMatchGoalRollClock = -999
    local lastFreeplayGoalRollClock = -999
    local ReworkLookMod = nil
    local EffectsMod = nil
    local SoundFxMod = nil
    local GoalShowsMod = nil
    local EditAuraMod = nil

    local listPresets = {
        { name = "MY SAVED PRESET", isSavedCustom = true, spec = nil },
        { name = "CURRENT GARAGE / LIVE", spec = nil },
        {
            name = "TW FENNEC (FENIX) + BETA GOLD",
            spec = {
                car = { "car_hexa2_matix_pint_branco_titanio", "car_hexa2_matix", "car_rally2_pint_branco_titanio", "car_rally2" },
                carTokens = { "hexa2_matix", "rally2", "branco" },
                paintBlueTokens = { "cobalto", "azul_escuro", "azul" },
                accentBlueTokens = { "branco" },
                paintOrangeTokens = { "carmesim", "vermelho", "laranja" },
                accentOrangeTokens = { "branco" },
                finish = "finish_anodizado_perola",
                finishAccent = "finish_anodizado",
                decalTokens = { "chama", "raio", "estrela", "bolinha" },
                wheelTokens = { "beta", "cromada_ouro", "estrela_ouro", "aco_ouro", "ouro" },
                boostTokens = { "beta", "rw_ouro", "anel_ouro", "ouro", "gemas" },
                trailTokens = { "beta", "gold", "ouro", "aurora", "raio" },
                goalTokens = { "beta", "aura", "moedas_ouro", "aneis_ouro", "estrelas" },
                demoTokens = { "buraco", "barras", "ouro", "descarga" },
                ballTokens = { "dourada", "beta", "copa" },
                hatTokens = { "coroa_dourado", "coroa", "aureola_dourado", "oculosbeta" },
            },
        },
        {
            name = "TW OCTANE (OCTA) + EDIT AURA",
            spec = {
                car = { "car_octane_pint_branco_titanio", "car_octane", "car_rally2_pint_branco_titanio" },
                carTokens = { "octane", "rally2" },
                paintBlueTokens = { "anil", "roxo", "azul" },
                accentBlueTokens = { "ciano", "azul_celeste", "branco" },
                paintOrangeTokens = { "ameixa", "rosa", "carmesim" },
                accentOrangeTokens = { "amarelo", "branco" },
                finish = "finish_anodizado_perola",
                finishAccent = "finish_gelo",
                decalTokens = { "estelar", "galax", "nuvem", "onda", "chuva" },
                wheelTokens = { "catedral_p_azul_celeste", "catedral", "disco_gelo", "estrela_gelo", "gelo" },
                boostTokens = { "rw_estelar", "upd1_aura", "rw_plasma", "estelar", "plasma" },
                trailTokens = { "aurora", "croma", "raio", "roxo" },
                goalTokens = { "aura", "edit", "estrelas", "cascata" },
                demoTokens = { "buraco", "descarga", "impacto" },
                ballTokens = { "nucleo", "planeta", "arco_iris" },
                hatTokens = { "aureola2", "aureola", "pixel" },
            },
        },
        {
            name = "BLACK DOMINUS (BULL) + REAPER",
            spec = {
                car = { "car_brutus2_pint_preto", "car_brutus2_pint_branco_titanio", "car_brutus2", "car_shade_pint_preto", "car_shade" },
                carTokens = { "brutus2", "shade", "preto" },
                paintBlueTokens = { "chumbo", "ardosia", "roxo" },
                accentBlueTokens = { "carmesim", "vermelho", "laranja" },
                paintOrangeTokens = { "carmesim", "vermelho", "abobora" },
                accentOrangeTokens = { "preto", "chumbo", "amarelo" },
                finish = "finish_metalico",
                finishAccent = "finish_anodizado",
                decalTokens = { "chama", "fogo", "raio", "sombra" },
                wheelTokens = { "shadow_sombria", "hw_raio_preto", "tridente_preto", "serra_preto", "preto" },
                boostTokens = { "shadow_night", "hw_nether", "rw_fumaca_negra", "rw_chama", "chama" },
                trailTokens = { "fogo", "roxo", "ink", "bruma" },
                goalTokens = { "ceifador", "sombrio", "chama", "explosao_fogo", "brainrot" },
                demoTokens = { "caveira", "coffin", "buraco", "nuvem" },
                ballTokens = { "vulcao", "lava", "olhao" },
                hatTokens = { "chifres_dourado", "chifres", "hw_asa", "hw_rip" },
            },
        },
        {
            name = "TW STORM (THUNDER) + APEX CHROMA",
            spec = {
                car = { "car_trovao_pint_branco_titanio", "car_trovao_pint_carmesim", "car_trovao" },
                carTokens = { "trovao", "faisca" },
                paintBlueTokens = { "azul", "cobalto" },
                accentBlueTokens = { "branco", "amarelo" },
                paintOrangeTokens = { "vermelho", "carmesim", "laranja" },
                accentOrangeTokens = { "branco", "preto" },
                finish = "finish_ceramica",
                finishAccent = "finish_anodizado_perola",
                decalTokens = { "faixa", "raio", "veloc", "chuva" },
                wheelTokens = { "cromada_ouro", "faixa_branca_ouro", "turbina", "disco_ouro", "craque_ouro" },
                boostTokens = { "rw_nitro", "rw_jato", "estrela_fogo", "ion", "poligonal" },
                trailTokens = { "croma", "raio", "estrada", "fogo" },
                goalTokens = { "estilhacos", "explosao", "estrelas", "aneis_ouro" },
                demoTokens = { "descarga", "impacto", "buraco" },
                ballTokens = { "copa", "disco", "planeta" },
                hatTokens = { "", "capacete_dourado", "trofeu_dourado" },
            },
        },
        {
            name = "TW SAMURAI (GT DRIFT) + TOKYO NEON",
            spec = {
                car = { "car_samurai_pint_branco_titanio", "car_samurai", "car_ronin_pint_branco_titanio", "car_ronin" },
                carTokens = { "samurai", "ronin", "gale" },
                paintBlueTokens = { "anil", "azul_claro", "azul" },
                accentBlueTokens = { "lima", "verde", "rosa" },
                paintOrangeTokens = { "rosa", "ameixa", "roxo" },
                accentOrangeTokens = { "azul_celeste", "amarelo", "branco" },
                finish = "finish_anodizado_perola",
                finishAccent = "finish_laminado",
                decalTokens = { "bolinhas", "onda", "chuva" },
                wheelTokens = { "dr_shuriken", "oceandrive", "catedral_p_rosa", "vinil_ouro", "malha_ouro" },
                boostTokens = { "upd1_25d", "rw_pixel", "rw_plasma", "hw_roxolaranja", "brilhos" },
                trailTokens = { "croma", "music", "aurora", "raio" },
                goalTokens = { "confete", "cascata", "aura", "brainrot" },
                demoTokens = { "impacto", "descarga", "nuvem" },
                ballTokens = { "disco_noturno", "arco_iris_noturno", "disco" },
                hatTokens = { "pixel", "gato_dourado", "unicornio_dourado" },
            },
        },
        {
            name = "TW PICO (SPARK) + SUB-ZERO ICE",
            spec = {
                car = { "car_faisca_pint_branco_titanio", "car_faisca" },
                carTokens = { "faisca", "rally2" },
                paintBlueTokens = { "azul_clarissimo", "azul_claro", "azul" },
                accentBlueTokens = { "branco" },
                paintOrangeTokens = { "anil", "roxo", "azul" },
                accentOrangeTokens = { "branco", "azul_claro" },
                finish = "finish_gelo",
                finishAccent = "finish_anodizado_perola",
                decalTokens = { "chuva", "neve", "gelo" },
                wheelTokens = { "floco_gelo", "estrela_gelo", "cromada_gelo", "aco_gelo", "gelo" },
                boostTokens = { "rw_gelo", "nevoa", "gemas", "upd1_sparkles" },
                trailTokens = { "agua", "aurora", "bolhas" },
                goalTokens = { "flocos_gelo", "granizo_gelo", "neve_gelo", "cascata" },
                demoTokens = { "descarga", "buraco" },
                ballTokens = { "neve", "nucleo", "favor" },
                hatTokens = { "viking_dourado", "viking2", "coroa" },
            },
        },
        {
            name = "TW RALLY + 24K GOLD MEME",
            spec = {
                car = { "car_rally2_pint_branco_titanio", "car_rally2", "car_merc_pint_branco_titanio", "car_merc" },
                carTokens = { "rally2", "merc" },
                paintBlueTokens = { "amarelo", "caramelo", "bronze" },
                accentBlueTokens = { "branco" },
                paintOrangeTokens = { "amarelo", "abobora", "caramelo" },
                accentOrangeTokens = { "branco", "amarelo" },
                finish = "finish_anodizado_perola",
                finishAccent = "finish_anodizado",
                decalTokens = { "" },
                wheelTokens = { "disco_ouro", "estrela_ouro", "cromada_ouro", "dr_urso", "ouro" },
                boostTokens = { "rw_confete", "rw_notas", "rw_bolhas", "rw_ouro", "hw_doces" },
                trailTokens = { "gold", "croma", "music", "bolhas" },
                goalTokens = { "brainrot", "moedas_ouro", "confete", "aneis_ouro" },
                demoTokens = { "barras", "impacto", "buraco" },
                ballTokens = { "dourada", "melancia", "cerebro", "praia" },
                hatTokens = { "chef_dourado", "batata", "burguer", "pato_dourado" },
            },
        },
    }

    local listCars, listPaints, listFinishes, listDecals, listWheels, listBoosts = {}, {}, {}, {}, {}, {}
    local listTrails, listGoals, listDemos, listBalls = {}, {}, {}, {}
    local idxPreset = 1
    local idxCar, idxPaint, idxAccent, idxFinish, idxDecal, idxWheel, idxBoost = 1, 1, 1, 1, 1, 1, 1
    local idxTrail, idxGoal, idxDemo, idxBall = 1, 1, 1, 1

    -- Zero-lag caches (prevents getgc(true) heap walks & O(N) table rebuilds on every click!)
    local cachedCleanText = {}
    local cachedDecalsByCar = {}
    local lastDecalCarId = nil
    local cachedOwnedIdsList = nil
    local cachedCopiesMap = nil
    local activeMatchViews = setmetatable({}, { __mode = "k" })
    local activeMatchSessions = setmetatable({}, { __mode = "k" })
    local lastAppliedLookByView = setmetatable({}, { __mode = "k" })
    local lastAppliedPeerLookByView = setmetatable({}, { __mode = "k" })
    local peerStates = {} -- [uidStr] = { uid = num, name = str, displayName = str, blueIds = tbl, orangeIds = tbl, split = bool, goalStyle = str, ts = num }
    local broadcastMyState = nil
    local inRebuildCarHook = false
    local lastGcScanAt = -999
    local TeamPaintModCache = nil
    local GarageMod = nil
    local ArtMod = nil
    local CarModelMod = nil
    local SettingsMod = nil
    local applyingSkinNow = false

    local function cleanText(str)
        if type(str) ~= "string" then return "DEFAULT" end
        local hit = cachedCleanText[str]
        if hit then return hit end
        local orig = str
        local map = {
            ["\195\161"] = "a", ["\195\160"] = "a", ["\195\162"] = "a", ["\195\163"] = "a",
            ["\195\129"] = "A", ["\195\128"] = "A", ["\195\130"] = "A", ["\195\131"] = "A",
            ["\195\169"] = "e", ["\195\170"] = "e", ["\195\137"] = "E", ["\195\138"] = "E",
            ["\195\173"] = "i", ["\195\141"] = "I",
            ["\195\179"] = "o", ["\195\180"] = "o", ["\195\181"] = "o", ["\195\147"] = "O", ["\195\148"] = "O", ["\195\149"] = "O",
            ["\195\186"] = "u", ["\195\154"] = "U",
            ["\195\167"] = "c", ["\195\135"] = "C",
        }
        for k, v in map do
            str = str:gsub(k, v)
        end
        str = str:gsub("[^\32-\126]", ""):upper()
        cachedCleanText[orig] = str
        return str
    end

    local function getItemObj(id)
        if not ItemsMod or type(id) ~= "string" or id == "" then return nil end
        if type(ItemsMod.get) == "function" then
            local ok, res = pcall(ItemsMod.get, id)
            if ok and type(res) == "table" then return res end
        end
        if type(ItemsMod.byId) == "table" then
            return ItemsMod.byId[id]
        elseif type(ItemsMod.byId) == "function" then
            local ok, res = pcall(ItemsMod.byId, id)
            if ok and type(res) == "table" then return res end
        end
        return nil
    end

    local getThreadIdFn = (type(getthreadidentity) == "function" and getthreadidentity)
        or (type(getidentity) == "function" and getidentity)
        or (type(syn) == "table" and type(syn.get_thread_identity) == "function" and syn.get_thread_identity)
        or nil
    local setThreadIdFn = (type(setthreadidentity) == "function" and setthreadidentity)
        or (type(setidentity) == "function" and setidentity)
        or (type(syn) == "table" and type(syn.set_thread_identity) == "function" and syn.set_thread_identity)
        or nil

    -- CRITICAL FIX: Executor threads (InputBegan, MouseButton1Click, task.spawn, task.delay) run at Thread Identity 8 (RobloxScript).
    -- Inside CarModel.new -> Art.chassisTwin -> require(ReplicatedStorage.Shared.Content), Roblox throws:
    -- "Cannot require a non-RobloxScript module from a RobloxScript" if Thread Identity > 2!
    -- Lowering Thread Identity to 2 before calling any game module function prevents CarModel.new / rebuildCar from ever failing!
    local function runAsGameScript(fn, ...)
        local prevId = nil
        if getThreadIdFn and setThreadIdFn then
            local okG, curId = pcall(getThreadIdFn)
            if okG and type(curId) == "number" and curId > 2 then
                prevId = curId
                pcall(setThreadIdFn, 2)
            end
        end
        local results = table.pack(pcall(fn, ...))
        if prevId and setThreadIdFn then
            pcall(setThreadIdFn, prevId)
        end
        if not results[1] then
            return false, results[2]
        end
        return true, table.unpack(results, 2, results.n)
    end

    local function isCarArtLoaded(itemObj)
        if type(itemObj) ~= "table" then return false end
        if itemObj.disabled == true or itemObj.retired == true or itemObj.held == true or itemObj.hold == true or itemObj.gone == true then
            return false
        end
        local id = itemObj.id
        local artName = itemObj.art
        if type(artName) ~= "string" or artName == "" then return false end
        if ItemsMod then
            if type(ItemsMod.DISABLED_CARS) == "table" and (ItemsMod.DISABLED_CARS[id] or ItemsMod.DISABLED_CARS[artName]) then
                return false
            end
            if type(ItemsMod.HELD_CARS) == "table" and (ItemsMod.HELD_CARS[id] or ItemsMod.HELD_CARS[artName]) then
                return false
            end
            if type(ItemsMod.LOCAL_ONLY_CARS) == "table" and (ItemsMod.LOCAL_ONLY_CARS[id] or ItemsMod.LOCAL_ONLY_CARS[artName]) then
                return false
            end
            if type(ItemsMod.isDisabledCar) == "function" then
                local okD, isDis = pcall(ItemsMod.isDisabledCar, id or artName)
                if okD and isDis == true then
                    return false
                end
            end
        end
        if ArtMod and type(ArtMod.folder) == "function" then
            local ok, f = pcall(ArtMod.folder, "Cars", artName)
            if ok then
                return typeof(f) == "Instance" and f:FindFirstChildWhichIsA("MeshPart", true) ~= nil
            end
        end
        local rsArt = RS:FindFirstChild("Art")
        local carsFolder = rsArt and rsArt:FindFirstChild("Cars")
        if carsFolder then
            local f = carsFolder:FindFirstChild(artName)
            return typeof(f) == "Instance" and f:FindFirstChildWhichIsA("MeshPart", true) ~= nil
        end
        return true
    end

    local function isWheelArtLoaded(itemObj)
        if type(itemObj) ~= "table" then return false end
        if itemObj.disabled == true then return false end
        local artName = itemObj.art
        if type(artName) ~= "string" or artName == "" then return true end
        if ArtMod and type(ArtMod.wheelFolder) == "function" then
            local ok, f = pcall(ArtMod.wheelFolder, artName)
            if ok then
                return typeof(f) == "Instance" and f:FindFirstChildWhichIsA("MeshPart", true) ~= nil
            end
        end
        local rsArt = RS:FindFirstChild("Art")
        local wheelsFolder = rsArt and rsArt:FindFirstChild("Wheels")
        if wheelsFolder then
            local f = wheelsFolder:FindFirstChild(artName)
            return typeof(f) == "Instance" and f:FindFirstChildWhichIsA("MeshPart", true) ~= nil
        end
        return true
    end

    local function findValidItem(kind, preferredIds, tokens, fallbackList, extraCheckFn)
        if not ItemsMod then return nil end
        local function passesAllChecks(it)
            if type(it) ~= "table" or type(it.id) ~= "string" then return false end
            if kind == "car" and not isCarArtLoaded(it) then return false end
            if kind == "wheel" and not isWheelArtLoaded(it) then return false end
            if extraCheckFn and not extraCheckFn(it) then return false end
            return true
        end

        -- 1. Check exact preferred IDs first
        if type(preferredIds) == "string" then
            if preferredIds == "" then return "" end
            local obj = getItemObj(preferredIds)
            if obj and passesAllChecks(obj) then return preferredIds end
        elseif type(preferredIds) == "table" then
            for _, pid in preferredIds do
                if pid == "" then return "" end
                local obj = getItemObj(pid)
                if obj and passesAllChecks(obj) then return pid end
            end
        end

        -- 2. Score all items of this kind against tokens (matches id, art, style, and name!)
        local all = ItemsMod.ofKind(kind) or {}
        if type(tokens) == "table" and #tokens > 0 then
            local bestId, bestScore = nil, -1
            for _, it in all do
                if passesAllChecks(it) then
                    local idLow = it.id:lower()
                    local artLow = type(it.art) == "string" and it.art:lower() or ""
                    local styleLow = type(it.style) == "string" and it.style:lower() or ""
                    local nameLow = cleanText(it.name or ""):lower()

                    local score = 0
                    for rank, tk in tokens do
                        if tk == "" then
                            return ""
                        end
                        local tkLow = tk:lower()
                        local weight = math.max(10, 100 - (rank - 1) * 18)
                        if idLow == tkLow or artLow == tkLow or styleLow == tkLow then
                            score += weight * 3
                        elseif idLow:find(tkLow, 1, true) or artLow:find(tkLow, 1, true) or styleLow:find(tkLow, 1, true) then
                            score += weight * 2
                        elseif nameLow:find(tkLow, 1, true) then
                            score += weight
                        end
                    end
                    if score > 0 then
                        if idLow:find("branco_titanio", 1, true) then score += 5 end
                        if not idLow:find("rework_", 1, true) then score += 3 end
                        if score > bestScore then
                            bestScore = score
                            bestId = it.id
                        end
                    end
                end
            end
            if bestId then return bestId end
        end

        -- 3. Fallback to filtered catalog or first valid item of kind
        if fallbackList and #fallbackList > 0 then
            for _, entry in fallbackList do
                if entry.id ~= "" then
                    local it = getItemObj(entry.id)
                    if it and passesAllChecks(it) then
                        return entry.id
                    end
                end
            end
        end
        for _, it in all do
            if passesAllChecks(it) then
                return it.id
            end
        end
        return nil
    end

    local function rebuildDecalList(carId)
        local key = carId or (LoadoutMod and LoadoutMod.ids and LoadoutMod.ids.car) or "car_octane"
        if key == lastDecalCarId and #listDecals > 0 then
            return
        end
        lastDecalCarId = key
        if cachedDecalsByCar[key] then
            listDecals = cachedDecalsByCar[key]
            if idxDecal > #listDecals then idxDecal = 1 end
            return
        end
        local built = { { id = "", label = "NONE (CLEAN PAINT)" } }
        if ItemsMod then
            local allDecals = ItemsMod.ofKind("decal") or {}
            local dummyIds = { car = key }
            for _, item in allDecals do
                if type(item) == "table" and type(item.id) == "string" then
                    local isPainted = item.id:find("_pint_", 1, true) ~= nil
                    local isTW = item.id:find("_branco_titanio", 1, true) ~= nil
                    if not isPainted or isTW then
                        local okFit, fits = pcall(ItemsMod.fits, item, "decal", dummyIds)
                        if not okFit or fits then
                            local tag = isTW and " [TW]" or (item.car and " [CAR]" or "")
                            table.insert(built, {
                                id = item.id,
                                label = cleanText(item.name or item.id) .. tag,
                            })
                        end
                    end
                end
            end
        end
        cachedDecalsByCar[key] = built
        listDecals = built
        if idxDecal > #listDecals then idxDecal = 1 end
    end

    local function populateAllOwnedSets(forceRebuild)
        if not (ItemsMod and ProgressMod) then return end
        pcall(function()
            ProgressMod.ownedSet = ProgressMod.ownedSet or {}
            ProgressMod.copiesSet = ProgressMod.copiesSet or {}
            if not cachedOwnedIdsList or forceRebuild then
                cachedOwnedIdsList = {}
                cachedCopiesMap = {}
                local allItems = type(ItemsMod.list) == "table" and ItemsMod.list or nil
                if allItems and #allItems > 0 then
                    for _, it in allItems do
                        if type(it) == "table" and type(it.id) == "string" and it.disabled ~= true and it.retired ~= true and it.held ~= true and it.hold ~= true and it.gone ~= true then
                            ProgressMod.ownedSet[it.id] = true
                            ProgressMod.copiesSet[it.id] = 1
                            cachedCopiesMap[it.id] = 1
                            table.insert(cachedOwnedIdsList, it.id)
                        end
                    end
                elseif type(ItemsMod.byId) == "table" then
                    for id, it in ItemsMod.byId do
                        if type(id) == "string" and (type(it) ~= "table" or (it.disabled ~= true and it.retired ~= true and it.held ~= true and it.hold ~= true and it.gone ~= true)) then
                            ProgressMod.ownedSet[id] = true
                            ProgressMod.copiesSet[id] = 1
                            cachedCopiesMap[id] = 1
                            table.insert(cachedOwnedIdsList, id)
                        end
                    end
                end
            else
                -- O(1) check: only re-fill if server wiped ownedSet
                local firstId = cachedOwnedIdsList[1]
                if firstId and not ProgressMod.ownedSet[firstId] then
                    for _, id in cachedOwnedIdsList do
                        ProgressMod.ownedSet[id] = true
                        ProgressMod.copiesSet[id] = 1
                    end
                end
            end
            if type(ProgressMod.state) == "table" then
                ProgressMod.state.owned = cachedOwnedIdsList
                ProgressMod.state.copies = ProgressMod.copiesSet
            end
            if type(ProgressMod.freshSet) == "table" then
                table.clear(ProgressMod.freshSet)
            end
            ProgressMod.favoriteSet = ProgressMod.favoriteSet or {}
            for favId, isFav in savedFavoritesSet do
                if isFav then
                    ProgressMod.favoriteSet[favId] = true
                end
            end
        end)
    end

    local function isGoalFavorited(itemId)
        if type(itemId) ~= "string" or itemId == "" then return false end
        if savedFavoritesSet[itemId] == true then return true end
        if ProgressMod and type(ProgressMod.favoriteSet) == "table" and ProgressMod.favoriteSet[itemId] == true then
            return true
        end
        if ReworkLookMod then
            if type(ReworkLookMod.originalOf) == "function" then
                local okO, origId = pcall(ReworkLookMod.originalOf, itemId)
                if okO and type(origId) == "string" and (savedFavoritesSet[origId] == true or (ProgressMod and ProgressMod.favoriteSet and ProgressMod.favoriteSet[origId] == true)) then
                    return true
                end
            end
            if type(ReworkLookMod.canonical) == "function" then
                local okC, canId = pcall(ReworkLookMod.canonical, itemId)
                if okC and type(canId) == "string" and (savedFavoritesSet[canId] == true or (ProgressMod and ProgressMod.favoriteSet and ProgressMod.favoriteSet[canId] == true)) then
                    return true
                end
            end
        end
        return false
    end

    local function getHeartedGoalItems()
        local out = {}
        local seenStyles = {}
        if not ItemsMod or type(ItemsMod.ofKind) ~= "function" then return out end
        for _, it in (ItemsMod.ofKind("goal") or {}) do
            if type(it) == "table" and type(it.id) == "string" and type(it.style) == "string" and it.disabled ~= true and it.hold ~= true and it.gone ~= true then
                if isGoalFavorited(it.id) and not seenStyles[it.style] then
                    seenStyles[it.style] = true
                    table.insert(out, it)
                end
            end
        end
        return out
    end

    local function updateRandomGoalBtnVisual()
        if not randomGoalBtn then return end
        local heartedCount = #getHeartedGoalItems()
        if randomGoalEnabled then
            randomGoalBtn.BackgroundColor3 = Color3.fromRGB(215, 55, 135)
            randomGoalBtn.TextColor3 = Color3.fromRGB(255, 245, 252)
            randomGoalBtn.Text = string.format("Random Goal: ON (%d Heart%s)", heartedCount, heartedCount == 1 and "" or "s")
        else
            randomGoalBtn.BackgroundColor3 = Color3.fromRGB(48, 52, 70)
            randomGoalBtn.TextColor3 = Color3.fromRGB(255, 130, 190)
            randomGoalBtn.Text = string.format("Random Goal: OFF (%d Heart%s)", heartedCount, heartedCount == 1 and "" or "s")
        end
    end

    local function rollNextRandomGoalStyle()
        local pool = getHeartedGoalItems()
        if #pool == 0 and ItemsMod and type(ItemsMod.ofKind) == "function" then
            for _, it in (ItemsMod.ofKind("goal") or {}) do
                if type(it) == "table" and type(it.style) == "string" and it.disabled ~= true and it.hold ~= true and it.gone ~= true then
                    table.insert(pool, it)
                end
            end
        end
        if #pool == 0 then return nil end
        -- Pick uniformly at random with replacement (can repeat, completely random, no fixed order!)
        local chosen = pool[math.random(1, #pool)]
        if chosen and type(chosen.style) == "string" then
            lastRolledGoalStyle = chosen.style
            runAsGameScript(function()
                if GoalShowsMod and EditAuraMod and type(GoalShowsMod.isShow) == "function" and GoalShowsMod.isShow(chosen.style) then
                    if type(EditAuraMod.warmStyle) == "function" then
                        EditAuraMod.warmStyle(chosen.style)
                    end
                end
            end)
            return chosen.style, chosen.id
        end
        return nil
    end

    local function syncProgressStateLoadout(blueTbl, orangeTbl, splitFlag)
        if not ProgressMod then return end
        pcall(function()
            if type(ProgressMod.state) == "table" then
                ProgressMod.state.loadout = table.clone(blueTbl or {})
                ProgressMod.state.loadoutOrange = table.clone(orangeTbl or {})
                if splitFlag ~= nil then
                    ProgressMod.state.teamSplit = splitFlag == true
                end
            end
        end)
    end

    local function getLocalTeamString(match, carEntry)
        if type(carEntry) ~= "table" then return "blue" end
        -- In Turbo Soccer Match.BLUE = 0, Match.ORANGE = 1!
        local t = carEntry.team
        if t == 1 or t == "orange" then
            -- Verify if 0-indexed (0 = blue, 1 = orange): if any car has team == 0, then 1 is definitely orange!
            local hasZero = false
            if type(match) == "table" and type(match.cars) == "table" then
                for _, c in match.cars do
                    if type(c) == "table" and c.team == 0 then
                        hasZero = true
                        break
                    end
                end
            end
            if hasZero or t == "orange" or t == 1 then
                return "orange"
            end
        elseif t == 2 then
            return "orange"
        end
        return "blue"
    end

    local function sanitizeLookForRebuild(lookTbl)
        if type(lookTbl) ~= "table" then return lookTbl end
        local carObj = type(lookTbl.car) == "table" and lookTbl.car or nil
        local checkObj = carObj or { id = lookTbl.art and ("car_" .. tostring(lookTbl.art)) or nil, art = lookTbl.art }
        if type(lookTbl.art) ~= "string" or not isCarArtLoaded(checkObj) then
            lookTbl.art = "rally2"
        end
        return lookTbl
    end

    local function syncMatchViewCarPose(obj, localIdx)
        if type(obj) ~= "table" then return end
        runAsGameScript(function()
            local prevSnap = rawget(obj, "prev")
            local currSnap = rawget(obj, "curr")
            if type(currSnap) == "table" and type(currSnap.cars) == "table" and type(obj.draw) == "function" then
                local wasLive = rawget(obj, "drawingLive")
                obj.drawingLive = true
                obj:draw(0, prevSnap or currSnap, currSnap, 1)
                obj.drawingLive = wasLive
            end
        end)
    end

    -- Non-destructive car rebuild: builds the new CarModel FIRST at Thread Identity 2, and ONLY destroys the old CarModel after the new one is valid!
    local function safeRebuildMatchCar(mv, carIdx, lookTbl)
        if not (MatchViewMod and type(mv) == "table" and type(carIdx) == "number" and type(lookTbl) == "table") then
            return false
        end
        local match = rawget(mv, "match")
        local cars = rawget(mv, "cars")
        local folder = rawget(mv, "folder")
        if not (type(match) == "table" and type(match.cars) == "table" and type(cars) == "table" and typeof(folder) == "Instance") then
            return false
        end
        local carSlot = match.cars[carIdx]
        if not carSlot then return false end
        local oldCarModel = cars[carIdx]
        local shouldBeVisible = true
        local currSnap = rawget(mv, "curr")
        local currCar = type(currSnap) == "table" and type(currSnap.cars) == "table" and currSnap.cars[carIdx] or nil
        if type(currCar) == "table" and currCar.demoed == true then
            shouldBeVisible = false
        end

        local okBuild, newCarModel = runAsGameScript(function()
            local gameKind = type(match.config) == "table" and match.config.game or nil
            return MatchViewMod.buildCar(folder, carSlot.car, lookTbl, carIdx, gameKind, carSlot.team)
        end)
        if not (okBuild and type(newCarModel) == "table" and typeof(rawget(newCarModel, "model")) == "Instance") then
            return false
        end

        runAsGameScript(function()
            if type(newCarModel.setHitboxVisible) == "function" then
                newCarModel:setHitboxVisible(false)
            end
            if rawget(mv, "ownersKnown") and type(newCarModel.setOther) == "function" then
                newCarModel:setOther(carIdx ~= rawget(mv, "ownIndex"))
            end
            if type(newCarModel.setVisible) == "function" then
                newCarModel:setVisible(shouldBeVisible)
            end
            cars[carIdx] = newCarModel
            if type(rawget(mv, "tags")) == "table" then
                mv.tags[carIdx] = nil
            end
            if oldCarModel and oldCarModel ~= newCarModel and type(oldCarModel.destroy) == "function" then
                pcall(function() oldCarModel:destroy() end)
            end
        end)
        return true
    end

    local function applyLookToMatchView(obj, forceFullRebuild)
        if not (LoadoutMod and type(obj) == "table") then return false end
        local match = rawget(obj, "match")
        local cars = rawget(obj, "cars")
        if type(match) ~= "table" or type(match.cars) ~= "table" or type(cars) ~= "table" then
            return false
        end
        local localIdx = rawget(obj, "ownIndex") or rawget(obj, "localIndex") or nil
        if not localIdx then
            for sess in activeMatchSessions do
                if type(sess) == "table" and rawget(sess, "view") == obj and type(rawget(sess, "index")) == "number" then
                    localIdx = rawget(sess, "index")
                    break
                end
            end
        end
        if not localIdx and P and rawget(P, "match") == match and type(P.localCarId) == "number" then
            localIdx = P.localCarId
        end
        if type(localIdx) ~= "number" then
            return false
        end
        local carEntry = match.cars[localIdx]
        local carModel = cars[localIdx]
        if not carEntry then return false end

        local teamStr = getLocalTeamString(match, carEntry)
        local okLook, newLook = runAsGameScript(LoadoutMod.look, nil, teamStr)
        if not (okLook and type(newLook) == "table") then return false end
        newLook = sanitizeLookForRebuild(newLook)
        runAsGameScript(function()
            if MatchViewMod and type(MatchViewMod.teamPaint) == "function" and type(match.config) == "table" then
                newLook.paint = MatchViewMod.teamPaint(match.config.game, carEntry.team) or newLook.paint
            end
            local scripts = LP:FindFirstChild("PlayerScripts")
            local client = scripts and scripts:FindFirstChild("Client")
            local cbMod = client and client:FindFirstChild("ClubBadge")
            if cbMod and type(match.config) == "table" then
                local ClubBadge = require(cbMod)
                for sess in activeMatchSessions do
                    if type(sess) == "table" and rawget(sess, "view") == obj and type(rawget(sess, "roster")) == "table" then
                        ClubBadge.dress(newLook, rawget(sess, "roster"), match.config.game, carEntry.team)
                        break
                    end
                end
            end
        end)

        -- Check if the current 3D CarModel is broken, destroyed (#mdl:GetChildren() == 0), or unparented
        local mdl = type(carModel) == "table" and rawget(carModel, "model") or nil
        local isCarBroken = (forceFullRebuild == true)
            or (type(carModel) ~= "table")
            or (typeof(mdl) ~= "Instance" or mdl.Parent == nil or #mdl:GetChildren() == 0)
            or ((rawget(carModel, "badFrames") or 0) > 0)

        local prevLook = lastAppliedLookByView[obj]
        local needFullRebuild = isCarBroken
        if not needFullRebuild then
            if type(prevLook) == "table" and type(obj.setLook) == "function" then
                needFullRebuild = (newLook.art ~= prevLook.art)
                    or (newLook.wheel ~= prevLook.wheel)
                    or (newLook.hat ~= prevLook.hat)
                    or (newLook.wheelTint ~= prevLook.wheelTint)
                    or (newLook.wheelFx ~= prevLook.wheelFx)
                    or (newLook.hatTint ~= prevLook.hatTint)
                    or (newLook.spoiler ~= prevLook.spoiler)
                    or (newLook.lights ~= prevLook.lights)
                    or (newLook.kitKey ~= prevLook.kitKey)
                    or (newLook.glow ~= prevLook.glow)
                    or (newLook.chassis ~= prevLook.chassis)
            else
                needFullRebuild = true
            end
        end

        if needFullRebuild then
            safeRebuildMatchCar(obj, localIdx, newLook)
            syncMatchViewCarPose(obj, localIdx)
        else
            runAsGameScript(function()
                obj:setLook(localIdx, newLook)
                if carModel and carModel.setPlate then
                    carModel:setPlate(newLook.plate)
                end
            end)
            syncMatchViewCarPose(obj, localIdx)
        end
        lastAppliedLookByView[obj] = newLook

        --Update ball skin only if ball art/tint changed or forced
        if forceFullRebuild or not prevLook or newLook.ball ~= prevLook.ball or newLook.ballTint ~= prevLook.ballTint then
            runAsGameScript(function()
                local ballModel = rawget(obj, "ball")
                if type(ballModel) == "table" and type(ballModel.setArt) == "function" then
                    ballModel:setArt(newLook.ball, newLook.ballTint)
                end
            end)
        end
        return true
    end

    local function findPeerStateForRosterEntry(rosterEntry, sessNames, carIdx)
        if next(peerStates) == nil then return nil end
        if type(rosterEntry) == "table" then
            local rUid = tonumber(rosterEntry.userId or rosterEntry.uid or (type(rosterEntry.loadout) == "table" and rosterEntry.loadout.userId))
            if rUid and rUid > 0 and rUid ~= LP.UserId then
                local st = peerStates[tostring(rUid)]
                if st then return st end
            end
            local rName = rosterEntry.name
            if type(rName) == "string" and rName ~= "" then
                for _, st in peerStates do
                    if st.uid ~= LP.UserId and (st.name == rName or st.displayName == rName) then
                        return st
                    end
                end
            end
        end
        local sName = type(sessNames) == "table" and type(carIdx) == "number" and sessNames[carIdx] or nil
        if type(sName) == "string" and sName ~= "" then
            for _, st in peerStates do
                if st.uid ~= LP.UserId and (st.name == sName or st.displayName == sName) then
                    return st
                end
            end
        end
        return nil
    end

    local function sanitizePeerLoadoutIds(idsTbl)
        local out = {}
        if type(idsTbl) == "table" then
            for k, v in idsTbl do
                if type(k) == "string" and (type(v) == "string" or type(v) == "number" or type(v) == "boolean") then
                    out[k] = v
                end
            end
        end
        if type(out.car) == "string" then
            local cObj = getItemObj(out.car)
            if not (cObj and isCarArtLoaded(cObj)) then
                out.car = "car_rally2"
            end
        else
            out.car = "car_rally2"
        end
        return out
    end

    local function computePeerLookForSlot(pState, match, carEntry, sessRoster)
        if not (LoadoutMod and type(pState) == "table" and type(carEntry) == "table") then return nil end
        local teamStr = getLocalTeamString(match, carEntry)
        local rawIds = (teamStr == "orange" and pState.split and type(pState.orangeIds) == "table" and next(pState.orangeIds) ~= nil)
            and pState.orangeIds
            or pState.blueIds
        if type(rawIds) ~= "table" or next(rawIds) == nil then return nil end
        local cleanIds = sanitizePeerLoadoutIds(rawIds)
        local okL, pLook = runAsGameScript(LoadoutMod.look, cleanIds, teamStr)
        if not (okL and type(pLook) == "table") then return nil end
        pLook = sanitizeLookForRebuild(pLook)
        if type(pState.goalStyle) == "string" and pState.goalStyle ~= "" then
            pLook.goal = pState.goalStyle
        end
        runAsGameScript(function()
            if MatchViewMod and type(MatchViewMod.teamPaint) == "function" and type(match) == "table" and type(match.config) == "table" then
                pLook.paint = MatchViewMod.teamPaint(match.config.game, carEntry.team) or pLook.paint
            end
            local scripts = LP:FindFirstChild("PlayerScripts")
            local client = scripts and scripts:FindFirstChild("Client")
            local cbMod = client and client:FindFirstChild("ClubBadge")
            if cbMod and type(match) == "table" and type(match.config) == "table" and type(sessRoster) == "table" then
                local ClubBadge = require(cbMod)
                ClubBadge.dress(pLook, sessRoster, match.config.game, carEntry.team)
            end
            if GoalShowsMod and EditAuraMod and type(pLook.goal) == "string" and type(GoalShowsMod.isShow) == "function" and GoalShowsMod.isShow(pLook.goal) then
                if type(EditAuraMod.warmStyle) == "function" then
                    EditAuraMod.warmStyle(pLook.goal)
                end
            end
        end)
        return pLook, cleanIds
    end

    local function applyPeerLooksToMatchView(obj, forceFullRebuild)
        if not (LoadoutMod and type(obj) == "table" and next(peerStates) ~= nil) then return 0 end
        local match = rawget(obj, "match")
        local cars = rawget(obj, "cars")
        if type(match) ~= "table" or type(match.cars) ~= "table" or type(cars) ~= "table" then
            return 0
        end
        local localIdx = rawget(obj, "ownIndex") or rawget(obj, "localIndex") or nil
        local linkedSess = nil
        for sess in activeMatchSessions do
            if type(sess) == "table" and rawget(sess, "view") == obj then
                linkedSess = sess
                if not localIdx and type(rawget(sess, "index")) == "number" then
                    localIdx = rawget(sess, "index")
                end
                break
            end
        end
        local roster = linkedSess and rawget(linkedSess, "roster") or nil
        local sessNames = linkedSess and rawget(linkedSess, "names") or nil
        local sessLooks = linkedSess and rawget(linkedSess, "looks") or nil

        local rosterByIndex = {}
        if type(roster) == "table" then
            for _, entry in roster do
                if type(entry) == "table" and type(entry.index) == "number" then
                    rosterByIndex[entry.index] = entry
                end
            end
        end

        local peerCache = lastAppliedPeerLookByView[obj]
        if not peerCache then
            peerCache = {}
            lastAppliedPeerLookByView[obj] = peerCache
        end

        local appliedPeers = 0
        for carIdx, carEntry in match.cars do
            if carIdx ~= localIdx then
                local rEntry = rosterByIndex[carIdx]
                local tagGui = type(rawget(obj, "tags")) == "table" and obj.tags[carIdx] or nil
                local tagNameLbl = tagGui and tagGui:FindFirstChild("Name", true)
                local fallbackNames = sessNames
                if not fallbackNames and tagNameLbl and tagNameLbl:IsA("TextLabel") then
                    fallbackNames = { [carIdx] = tagNameLbl.Text }
                end
                local pState = findPeerStateForRosterEntry(rEntry, fallbackNames, carIdx)
                if pState then
                    local peerLook, cleanIds = computePeerLookForSlot(pState, match, carEntry, roster)
                    if type(peerLook) == "table" then
                        if type(rEntry) == "table" and type(cleanIds) == "table" then
                            rEntry.loadout = table.clone(cleanIds)
                            rEntry.look = peerLook
                            rEntry.goal = peerLook.goal
                            rEntry.demo = peerLook.demo
                        end
                        if type(sessLooks) == "table" then
                            sessLooks[carIdx] = peerLook
                        end
                        local carModel = cars[carIdx]
                        local mdl = type(carModel) == "table" and rawget(carModel, "model") or nil
                        local isCarBroken = (forceFullRebuild == true)
                            or (type(carModel) ~= "table")
                            or (typeof(mdl) ~= "Instance" or mdl.Parent == nil or #mdl:GetChildren() == 0)
                            or ((rawget(carModel, "badFrames") or 0) > 0)

                        local prevLook = peerCache[carIdx]
                        local needFullRebuild = isCarBroken
                        if not needFullRebuild then
                            if type(prevLook) == "table" and type(obj.setLook) == "function" then
                                needFullRebuild = (peerLook.art ~= prevLook.art)
                                    or (peerLook.wheel ~= prevLook.wheel)
                                    or (peerLook.hat ~= prevLook.hat)
                                    or (peerLook.wheelTint ~= prevLook.wheelTint)
                                    or (peerLook.wheelFx ~= prevLook.wheelFx)
                                    or (peerLook.hatTint ~= prevLook.hatTint)
                                    or (peerLook.spoiler ~= prevLook.spoiler)
                                    or (peerLook.lights ~= prevLook.lights)
                                    or (peerLook.kitKey ~= prevLook.kitKey)
                                    or (peerLook.glow ~= prevLook.glow)
                                    or (peerLook.chassis ~= prevLook.chassis)
                            else
                                needFullRebuild = true
                            end
                        end

                        if needFullRebuild then
                            safeRebuildMatchCar(obj, carIdx, peerLook)
                            syncMatchViewCarPose(obj, carIdx)
                        else
                            runAsGameScript(function()
                                obj:setLook(carIdx, peerLook)
                                if carModel and carModel.setPlate then
                                    carModel:setPlate(peerLook.plate)
                                end
                            end)
                            syncMatchViewCarPose(obj, carIdx)
                        end
                        peerCache[carIdx] = peerLook
                        appliedPeers += 1
                    end
                end
            end
        end
        return appliedPeers
    end

    local function syncSessionLook(sess)
        if not (LoadoutMod and type(sess) == "table") then return false end
        local sessIdx = rawget(sess, "index") or (P and P.localCarId) or 1
        local match = rawget(sess, "match")
        local view = rawget(sess, "view")
        local looks = rawget(sess, "looks")
        local teamStr = "blue"
        if type(match) == "table" and type(match.cars) == "table" and match.cars[sessIdx] then
            teamStr = getLocalTeamString(match, match.cars[sessIdx])
        end
        local okL, newL = runAsGameScript(LoadoutMod.look, nil, teamStr)
        if not (okL and type(newL) == "table") then return false end
        if type(looks) == "table" then
            looks[sessIdx] = newL
        end
        -- MatchSession also stores goal explosion / demo style or roster looks if present
        local roster = rawget(sess, "roster")
        if type(roster) == "table" and type(roster[sessIdx]) == "table" then
            roster[sessIdx].look = newL
            roster[sessIdx].goal = newL.goal
            roster[sessIdx].demo = newL.demo
        end
        if type(roster) == "table" and next(peerStates) ~= nil then
            local sessNames = rawget(sess, "names")
            for _, rEntry in roster do
                if type(rEntry) == "table" and type(rEntry.index) == "number" and rEntry.index ~= sessIdx then
                    local pState = findPeerStateForRosterEntry(rEntry, sessNames, rEntry.index)
                    local carEntry = type(match) == "table" and type(match.cars) == "table" and match.cars[rEntry.index] or rEntry
                    if pState and type(carEntry) == "table" then
                        local peerLook, cleanIds = computePeerLookForSlot(pState, match, carEntry, roster)
                        if type(peerLook) == "table" then
                            if type(cleanIds) == "table" then
                                rEntry.loadout = table.clone(cleanIds)
                            end
                            rEntry.look = peerLook
                            rEntry.goal = peerLook.goal
                            rEntry.demo = peerLook.demo
                            if type(looks) == "table" then
                                looks[rEntry.index] = peerLook
                            end
                        end
                    end
                end
            end
        end
        if type(view) == "table" then
            activeMatchViews[view] = true
        end
        return true
    end

    local function refreshLiveMatchCars(forceGcScan, forceFullRebuild)
        if not LoadoutMod then return 0 end
        local rebuiltCount = 0

        -- 1. First update any tracked MatchSessions (u49) so u49.looks[localIdx] and activeMatchViews are up-to-date
        for sess in activeMatchSessions do
            if type(sess) == "table" and rawget(sess, "over") ~= true then
                syncSessionLook(sess)
            else
                activeMatchSessions[sess] = nil
            end
        end

        -- 2. O(1) instant update on already-tracked active MatchView instances (ZERO getgc lag!)
        for mv in activeMatchViews do
            if type(mv) == "table" and rawget(mv, "folder") and rawget(mv, "folder").Parent ~= nil then
                if applyLookToMatchView(mv, forceFullRebuild) then
                    rebuiltCount += 1
                end
                applyPeerLooksToMatchView(mv, forceFullRebuild)
            else
                activeMatchViews[mv] = nil
            end
        end

        -- 3. Sync Garage live instance directly via Garage.live (O(1), no getgc needed!)
        if GarageMod and type(GarageMod.live) == "table" and GarageMod.live.isOpen == true then
            runAsGameScript(function()
                local g = GarageMod.live
                g.tryId = nil
                g.tryPaint = nil
                g.tryFinish = nil
                if type(g._sync) == "function" then g:_sync() end
                if type(g._showInfo) == "function" then g:_showInfo() end
            end)
        end

        -- 4. Check if a MatchView folder exists in Workspace right now (handles late script injection or un-hooked MatchView!)
        local wsCarSoccer = workspace:FindFirstChild("CarSoccer")
        local hasLiveMatchFolder = (P ~= nil)
            or (wsCarSoccer and wsCarSoccer:FindFirstChild("MatchView") ~= nil)
            or (workspace:FindFirstChild("MatchView") ~= nil)

        local now = os.clock()
        if rebuiltCount == 0 and (forceGcScan or (hasLiveMatchFolder and now - lastGcScanAt > 1.5)) and type(getgc) == "function" then
            lastGcScanAt = now
            local okGc, items = pcall(getgc, true)
            if okGc and type(items) == "table" then
                for _, obj in items do
                    if type(obj) == "table" then
                        local cars = rawget(obj, "cars")
                        local match = rawget(obj, "match")
                        local folder = rawget(obj, "folder")
                        local isMatchView = (MatchViewMod and getmetatable(obj) == MatchViewMod)
                            or (type(cars) == "table" and type(match) == "table" and folder ~= nil and type(obj.rebuildCar) == "function")
                        if isMatchView and folder and folder.Parent ~= nil then
                            activeMatchViews[obj] = true
                            if applyLookToMatchView(obj, forceFullRebuild) then
                                rebuiltCount += 1
                            end
                            applyPeerLooksToMatchView(obj, forceFullRebuild)
                        end
                        local view = rawget(obj, "view")
                        local looks = rawget(obj, "looks")
                        local sessIdx = rawget(obj, "index")
                        if type(view) == "table" and type(looks) == "table" and type(sessIdx) == "number" then
                            activeMatchSessions[obj] = true
                            syncSessionLook(obj)
                            if rawget(view, "folder") and rawget(view, "folder").Parent ~= nil and not activeMatchViews[view] then
                                activeMatchViews[view] = true
                                if applyLookToMatchView(view, forceFullRebuild) then
                                    rebuiltCount += 1
                                end
                                applyPeerLooksToMatchView(view, forceFullRebuild)
                            end
                        end
                    end
                end
            end
        end

        return rebuiltCount
    end

    local function updateSkinRowLabels()
        if not LoadoutMod or not LoadoutMod.ids then return end
        local ids = LoadoutMod.ids
        local presetObj = listPresets[idxPreset] or listPresets[1]
        rowPreset.Text = "PRESET: " .. presetObj.name

        local function labelForId(id, list, fallback)
            if id == "" then return "NONE" end
            if type(id) == "string" then
                local it = getItemObj(id)
                if it and it.name then
                    local suffix = id:find("_branco_titanio") and " [TW]"
                        or (id:find("_preto") and " [BLK]" or "")
                    return cleanText(it.name) .. suffix
                end
            end
            for _, entry in list do
                if entry.id == id then return entry.label end
            end
            return cleanText(tostring(id or fallback or "DEFAULT"))
        end

        local carLabel = labelForId(ids.car, listCars, "OCTANE")
        rowCar.Text    = "CAR: " .. carLabel
        rowPaint.Text  = "PAINT: " .. labelForId(ids.paintBlue, listPaints, "BLUE")
        rowAccent.Text = "ACCENT: " .. labelForId(ids.accentBlue, listPaints, "WHITE")
        rowFinish.Text = "FINISH: " .. labelForId(ids.finish, listFinishes, "DEFAULT")
        rowDecal.Text  = "DECAL: " .. labelForId(ids.decal, listDecals, "NONE")
        rowWheel.Text  = "WHEELS: " .. labelForId(ids.wheel, listWheels, "DEFAULT")
        rowBoost.Text  = "BOOST: " .. labelForId(ids.boost, listBoosts, "DEFAULT")
        rowTrail.Text  = "TRAIL: " .. labelForId(ids.trail, listTrails, "DEFAULT")
        rowGoal.Text   = "GOAL: " .. labelForId(ids.goal, listGoals, "DEFAULT")
        rowDemo.Text   = "DEMO: " .. labelForId(ids.demo, listDemos, "DEFAULT")
        rowBall.Text   = "BALL: " .. labelForId(ids.ball, listBalls, "DEFAULT")
        updateRandomGoalBtnVisual()

        skinBtn.Text = "SKIN [C]: " .. carLabel .. (skinPanel.Visible and " v" or " >")
    end

    local function syncIndicesFromCurrentLoadout()
        if not LoadoutMod or not LoadoutMod.ids then return end
        local ids = LoadoutMod.ids
        local function findIdx(list, id)
            for i, entry in list do
                if entry.id == id then return i end
            end
            return 1
        end
        idxCar    = findIdx(listCars, ids.car)
        idxPaint  = findIdx(listPaints, ids.paintBlue)
        idxAccent = findIdx(listPaints, ids.accentBlue)
        idxFinish = findIdx(listFinishes, ids.finish)
        rebuildDecalList(ids.car)
        idxDecal  = findIdx(listDecals, ids.decal or "")
        idxWheel  = findIdx(listWheels, ids.wheel)
        idxBoost  = findIdx(listBoosts, ids.boost)
        idxTrail  = findIdx(listTrails, ids.trail)
        idxGoal   = findIdx(listGoals, ids.goal)
        idxDemo   = findIdx(listDemos, ids.demo)
        idxBall   = findIdx(listBalls, ids.ball)
        updateSkinRowLabels()
    end

    local function applySlotMutation(b, o, slot, itemId, team, pairSlot)
        if type(slot) ~= "string" then return end
        local function setOnTable(tbl, s, val)
            if val == nil then
                tbl[s] = ""
            else
                tbl[s] = val
            end
        end
        if team == "blue" then
            setOnTable(b, slot, itemId)
            if type(pairSlot) == "string" then setOnTable(b, pairSlot, itemId) end
        elseif team == "orange" then
            setOnTable(o, slot, itemId)
            if type(pairSlot) == "string" then setOnTable(o, pairSlot, itemId) end
        else
            setOnTable(b, slot, itemId)
            setOnTable(o, slot, itemId)
            if type(pairSlot) == "string" then
                setOnTable(b, pairSlot, itemId)
                setOnTable(o, pairSlot, itemId)
            end
        end
        if slot == "car" and ItemsMod then
            local curDecal = b.decal and getItemObj(b.decal)
            if curDecal then
                local okFit, fits = pcall(ItemsMod.fits, curDecal, "decal", b)
                if okFit and not fits then
                    b.decal = ""
                    o.decal = ""
                end
            end
        end
    end

    local function applyLoadoutInstant(mutator, forceFullRebuild)
        if not LoadoutMod or applyingSkinNow then return end
        applyingSkinNow = true
        customOverrideActive = true
        local blue = table.clone(desiredBlue or LoadoutMod.blueIds or LoadoutMod.ids or {})
        local orange = table.clone(desiredOrange or LoadoutMod.orangeIds or LoadoutMod.ids or {})
        local splitFlag = desiredSplit ~= nil and desiredSplit or LoadoutMod.split
        if type(mutator) == "function" then
            mutator(blue, orange)
        end
        -- Validate car ID before applying so we NEVER equip a disabled/unrigged car
        if type(blue.car) == "string" then
            local cObj = getItemObj(blue.car)
            if not (cObj and isCarArtLoaded(cObj)) then
                blue.car = "car_rally2"
            end
        end
        if type(orange.car) == "string" then
            local cObj = getItemObj(orange.car)
            if not (cObj and isCarArtLoaded(cObj)) then
                orange.car = blue.car or "car_rally2"
            end
        end
        desiredBlue = table.clone(blue)
        desiredOrange = table.clone(orange)
        desiredSplit = splitFlag
        syncProgressStateLoadout(desiredBlue, desiredOrange, desiredSplit)
        runAsGameScript(function()
            -- Clear any active Garage hover preview BEFORE calling Loadout.set so BindableEvent fires only ONCE!
            LoadoutMod.preview = nil
            LoadoutMod.previewMods = nil
            LoadoutMod.set(desiredBlue, desiredOrange, desiredSplit)
        end)
        refreshLiveMatchCars(false, forceFullRebuild == true)
        updateSkinRowLabels()
        applyingSkinNow = false
        if type(broadcastMyState) == "function" then
            broadcastMyState(false)
        end
    end

    local function initTurboSkinSystem()
        if skinReady then return true end
        local scripts = LP:FindFirstChild("PlayerScripts")
        local client = scripts and scripts:FindFirstChild("Client")
        local shared = RS:FindFirstChild("Shared")
        if not (client and shared) then return false end

        local itemsModule = shared:FindFirstChild("Items")
        local loadoutModule = client:FindFirstChild("Loadout")
        local matchViewModule = client:FindFirstChild("MatchView")
        local matchSessionModule = client:FindFirstChild("MatchSession")
        local progressModule = client:FindFirstChild("Progress")
        local inventoryModule = client:FindFirstChild("Inventory")
        local garageModule = client:FindFirstChild("Garage")
        local artModule = client:FindFirstChild("Art")
        local carModelModule = client:FindFirstChild("CarModel")
        local settingsModule = client:FindFirstChild("Settings")
        local teamPaintModule = shared:FindFirstChild("TeamPaint")
        if not (itemsModule and loadoutModule) then return false end

        local MatchSessionMod = nil
        local okReq = pcall(function()
            ItemsMod = require(itemsModule)
            LoadoutMod = require(loadoutModule)
            if matchViewModule then MatchViewMod = require(matchViewModule) end
            if matchSessionModule then MatchSessionMod = require(matchSessionModule) end
            if progressModule then ProgressMod = require(progressModule) end
            if inventoryModule then InventoryMod = require(inventoryModule) end
            if garageModule then GarageMod = require(garageModule) end
            if artModule then ArtMod = require(artModule) end
            if carModelModule then CarModelMod = require(carModelModule) end
            if settingsModule then SettingsMod = require(settingsModule) end
            if teamPaintModule then TeamPaintModCache = require(teamPaintModule) end
            local rwMod = shared:FindFirstChild("ReworkLook")
            if rwMod then ReworkLookMod = require(rwMod) end
            local gsMod = shared:FindFirstChild("GoalShows")
            if gsMod then GoalShowsMod = require(gsMod) end
            local efMod = client:FindFirstChild("Effects")
            if efMod then EffectsMod = require(efMod) end
            local sfxMod = client:FindFirstChild("SoundFx")
            if sfxMod then SoundFxMod = require(sfxMod) end
            local eaMod = client:FindFirstChild("EditAura")
            if eaMod then EditAuraMod = require(eaMod) end
        end)
        if not okReq or not ItemsMod or not LoadoutMod then return false end

        -- Snapshot initial loadout (keeps the player's car exactly as it currently is!)
        local initBlue = table.clone(LoadoutMod.blueIds or LoadoutMod.ids or {})
        local initOrange = table.clone((type(LoadoutMod.idsFor) == "function" and LoadoutMod.idsFor("orange")) or LoadoutMod.orangeIds or initBlue)
        desiredBlue = table.clone(initBlue)
        desiredOrange = table.clone(initOrange)
        desiredSplit = LoadoutMod.split == true
        listPresets[1].savedData = {
            blueIds = table.clone(initBlue),
            orangeIds = table.clone(initOrange),
            split = desiredSplit,
        }

        -- 1. Build clean catalog lists from Items.ofKind (filtering out any unstreamed/retired 3D car or wheel art!)
        local function buildFilteredCatalog(kind, includePaintedTW, includeGold)
            local out = {}
            for _, item in (ItemsMod.ofKind(kind) or {}) do
                if type(item) == "table" and type(item.id) == "string" then
                    local artOk = true
                    if kind == "car" then
                        artOk = isCarArtLoaded(item)
                    elseif kind == "wheel" then
                        artOk = isWheelArtLoaded(item)
                    end
                    if artOk then
                        local isPainted = item.id:find("_pint_") ~= nil
                        local isTW = item.id:find("_branco_titanio") ~= nil
                        local isBlk = item.id:find("_preto") ~= nil
                        local isOuro = includeGold and (item.id:find("ouro") ~= nil) or false
                        if not isPainted or (includePaintedTW and (isTW or isBlk)) or isOuro then
                            local suffix = isTW and " [TW]" or (isBlk and " [BLK]" or "")
                            table.insert(out, {
                                id = item.id,
                                label = cleanText(item.name or item.id) .. suffix,
                            })
                        end
                    end
                end
            end
            return out
        end

        listCars     = buildFilteredCatalog("car", true, false)
        listPaints   = buildFilteredCatalog("paint", false, true)
        listFinishes = buildFilteredCatalog("finish", false, true)
        listWheels   = buildFilteredCatalog("wheel", true, true)
        listBoosts   = buildFilteredCatalog("boost", true, true)
        listTrails   = buildFilteredCatalog("trail", true, true)
        listGoals    = buildFilteredCatalog("goal", true, true)
        listDemos    = buildFilteredCatalog("demo", true, true)
        listBalls    = buildFilteredCatalog("ball", true, true)

        rebuildDecalList(LoadoutMod.ids and LoadoutMod.ids.car)

        -- 2. Native Garage, Finishes & Inventory 100% Client-Side Unlocker
        -- Clean hook helper that saves the original game function in env._WolvotOrigSkinFuncs and registers in `hooked` for unload()
        env._WolvotOrigSkinFuncs = env._WolvotOrigSkinFuncs or setmetatable({}, { __mode = "k" })
        local origSkinFuncs = env._WolvotOrigSkinFuncs

        -- Self-heal any module methods that were corrupted by old upvalue peeling in a prior session!
        pcall(function()
            local function isCorruptedFn(fn, expectedName)
                if type(fn) ~= "function" then return true end
                if type(debug) == "table" and type(debug.getinfo) == "function" then
                    local okI, info = pcall(debug.getinfo, fn)
                    if okI and type(info) == "table" then
                        local n = tostring(info.name or "")
                        if n ~= "" and n ~= expectedName then
                            return true
                        end
                        if n == "" then
                            local src = tostring(info.short_src or info.source or "")
                            if not (src:find("PlayerScripts") or src:find("ReplicatedStorage")) then
                                -- It's an executor wrapper; inspect its direct upvalues for corrupted native functions (lookSign, of, plateFor, basis, garageLine)
                                if type(debug.getupvalues) == "function" then
                                    local okU, ups = pcall(debug.getupvalues, fn)
                                    if okU and type(ups) == "table" then
                                        for _, uv in ups do
                                            if type(uv) == "function" then
                                                local okUI, uInfo = pcall(debug.getinfo, uv)
                                                if okUI and type(uInfo) == "table" then
                                                    local uSrc = tostring(uInfo.short_src or uInfo.source or "")
                                                    local uName = tostring(uInfo.name or "")
                                                    if (uSrc:find("PlayerScripts") or uSrc:find("ReplicatedStorage")) and uName ~= "" and uName ~= expectedName then
                                                        return true
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                                return false
                            end
                        end
                    end
                end
                return false
            end

            local function checkSavedOrCurCorrupted(mod, key)
                if type(mod) ~= "table" then return false end
                local saved = origSkinFuncs[mod] and origSkinFuncs[mod][key]
                if type(saved) == "function" and isCorruptedFn(saved, key) then
                    return true
                end
                local cur = rawget(mod, key)
                if type(cur) == "function" and isCorruptedFn(cur, key) then
                    return true
                end
                return false
            end

            -- 1. Repair Progress.call if corrupted to garageLine
            if ProgressMod and checkSavedOrCurCorrupted(ProgressMod, "call") then
                local applyFn, reqRemote = nil, nil
                local progFolder = RS:FindFirstChild("Progress")
                if progFolder then reqRemote = progFolder:FindFirstChild("Request") end
                if type(getgc) == "function" then
                    local okG, gcFns = pcall(getgc, false)
                    if okG and type(gcFns) == "table" then
                        for _, f in gcFns do
                            if type(f) == "function" and type(debug) == "table" and type(debug.getinfo) == "function" then
                                local okI, info = pcall(debug.getinfo, f)
                                if okI and info and info.name == "apply" and tostring(info.short_src or info.source or ""):find("Client%.Progress$") then
                                    applyFn = f
                                    break
                                end
                            end
                        end
                    end
                end
                local LocaleMod = shared:FindFirstChild("Locale") and require(shared.Locale) or nil
                local lastCallClock = 0
                local repairedCall = function(actionName, payload)
                    if not reqRemote then
                        local rFolder = RS:FindFirstChild("Progress")
                        reqRemote = rFolder and rFolder:FindFirstChild("Request")
                    end
                    if not reqRemote then
                        return { ok = false, error = LocaleMod and LocaleMod.say("Conectando ao servidor...") or "Conectando ao servidor..." }
                    end
                    local now = os.clock()
                    local target = math.max(now, lastCallClock + 0.3)
                    lastCallClock = target
                    local waitDt = target - os.clock()
                    if waitDt > 0 then task.wait(waitDt) end
                    local okS, result = pcall(function()
                        return reqRemote:InvokeServer(actionName, payload or {})
                    end)
                    if not okS or type(result) ~= "table" then
                        return { ok = false, error = LocaleMod and LocaleMod.say("Sem resposta do servidor.") or "Sem resposta do servidor." }
                    end
                    if type(result.error) == "string" and LocaleMod then
                        result.rawError = result.error
                        if type(result.errorArgs) == "table" then
                            result.error = LocaleMod.sayf(result.error, table.unpack(result.errorArgs))
                        else
                            result.error = LocaleMod.say(result.error)
                        end
                    end
                    if type(result.message) == "string" and LocaleMod then
                        result.message = LocaleMod.say(result.message)
                    end
                    if type(result.state) == "table" and type(applyFn) == "function" then
                        pcall(applyFn, result.state)
                    end
                    if type(result.missions) == "table" and #result.missions > 0 and result.done == nil then
                        result.done = result.missions
                    end
                    return result
                end
                ProgressMod.call = repairedCall
                if origSkinFuncs[ProgressMod] then origSkinFuncs[ProgressMod].call = repairedCall end
            end

            -- 2. Repair MatchView methods if corrupted (new, record, sync, refresh, setNames, draw)
            if MatchViewMod then
                local SnapshotMod = shared:FindFirstChild("MatchSnapshot") and require(shared.MatchSnapshot) or nil
                local ofFn = SnapshotMod and SnapshotMod.of or nil
                local SimFolder = shared:FindFirstChild("Sim")
                local NetFolder = shared:FindFirstChild("Net")
                local MatchMod = SimFolder and SimFolder:FindFirstChild("Match") and require(SimFolder.Match) or nil
                local ConstMod = SimFolder and SimFolder:FindFirstChild("Const") and require(SimFolder.Const) or nil
                local GamesMod = SimFolder and SimFolder:FindFirstChild("Games") and require(SimFolder.Games) or nil
                local PredictionNet = NetFolder and NetFolder:FindFirstChild("Prediction") and require(NetFolder.Prediction) or nil
                local PastViewNet = NetFolder and NetFolder:FindFirstChild("PastView") and require(NetFolder.PastView) or nil
                local BallModelMod = client:FindFirstChild("BallModel") and require(client.BallModel) or nil
                local PadsViewMod = client:FindFirstChild("PadsView") and require(client.PadsView) or nil
                local GamePropsMod = client:FindFirstChild("GameProps") and require(client.GameProps) or nil
                local TwistPropsMod = client:FindFirstChild("TwistProps") and require(client.TwistProps) or nil
                local SeekerViewMod = client:FindFirstChild("SeekerView") and require(client.SeekerView) or nil
                local PowersViewMod = client:FindFirstChild("PowersView") and require(client.PowersView) or nil
                local KartViewMod = client:FindFirstChild("KartView") and require(client.KartView) or nil
                local KartFxMod = client:FindFirstChild("KartFx") and require(client.KartFx) or nil
                local GoalTowerViewMod = client:FindFirstChild("GoalTowerView") and require(client.GoalTowerView) or nil
                local QuadViewMod = client:FindFirstChild("QuadView") and require(client.QuadView) or nil
                local HoopsViewMod = client:FindFirstChild("HoopsView") and require(client.HoopsView) or nil
                local VolleyViewMod = client:FindFirstChild("VolleyView") and require(client.VolleyView) or nil
                local UnitsMod = client:FindFirstChild("Units") and require(client.Units) or nil
                local UiMod = client:FindFirstChild("Ui") and require(client.Ui) or nil
                local ClubBadgeMod = client:FindFirstChild("ClubBadge") and require(client.ClubBadge) or nil
                local MasteryEmblemMod = client:FindFirstChild("MasteryEmblem") and require(client.MasteryEmblem) or nil
                local CreatorViewMod = client:FindFirstChild("CreatorView") and require(client.CreatorView) or nil

                if checkSavedOrCurCorrupted(MatchViewMod, "record") and ofFn then
                    local repairedRecord = function(self)
                        local prev = self.prev
                        self.prev = self.curr
                        local spare = self.spare
                        self.spare = nil
                        if not (spare and (spare ~= self.prev and spare ~= self.curr)) then
                            spare = nil
                        end
                        if spare then
                            prev = spare
                        elseif prev == nil or prev == self.prev then
                            prev = nil
                        end
                        self.curr = ofFn(self.match, prev)
                        if self.restMask then
                            self.restMask:own(self.curr)
                        end
                    end
                    MatchViewMod.record = repairedRecord
                    if origSkinFuncs[MatchViewMod] then origSkinFuncs[MatchViewMod].record = repairedRecord end
                end

                if checkSavedOrCurCorrupted(MatchViewMod, "sync") and ofFn then
                    local repairedSync = function(self)
                        self.curr = ofFn(self.match)
                        if self.restMask then
                            self.restMask:own(self.curr)
                        end
                        self.prev = self.curr
                    end
                    MatchViewMod.sync = repairedSync
                    if origSkinFuncs[MatchViewMod] then origSkinFuncs[MatchViewMod].sync = repairedSync end
                end

                if checkSavedOrCurCorrupted(MatchViewMod, "refresh") and ofFn then
                    local repairedRefresh = function(self)
                        local curr = self.curr
                        local match = self.match
                        local spare = self.spare
                        self.spare = nil
                        if not (spare and (spare ~= self.prev and spare ~= self.curr)) then
                            spare = nil
                        end
                        local snap = ofFn(match, spare)
                        if self.restMask then
                            self.restMask:own(snap)
                        end
                        local prev = self.prev
                        if prev and curr and prev ~= curr and type(snap.cars) == "table" then
                            for i, v in snap.cars do
                                local pCar = prev.cars and prev.cars[i]
                                local cCar = curr.cars and curr.cars[i]
                                if pCar and cCar then
                                    pCar.pos = pCar.pos + (v.pos - cCar.pos)
                                    if PredictionNet then
                                        local turn = PredictionNet.turnBetween(v.fwd, v.up, cCar.fwd, cCar.up)
                                        if turn ~= Vector3.new(0, 0, 0) then
                                            pCar.fwd = PredictionNet.rotate(turn, pCar.fwd)
                                            pCar.up = PredictionNet.rotate(turn, pCar.up)
                                        end
                                    end
                                end
                            end
                            if prev.ballPos and curr.ballPos and snap.ballPos then
                                prev.ballPos = prev.ballPos + (snap.ballPos - curr.ballPos)
                            end
                        end
                        self.curr = snap
                        if curr ~= prev and curr ~= snap then
                            self.spare = curr
                        end
                    end
                    MatchViewMod.refresh = repairedRefresh
                    if origSkinFuncs[MatchViewMod] then origSkinFuncs[MatchViewMod].refresh = repairedRefresh end
                end

                if checkSavedOrCurCorrupted(MatchViewMod, "new") and ofFn then
                    local repairedMvNew = function(p49, p50, p51)
                        local Folder = Instance.new("Folder")
                        Folder.Name = "MatchView"
                        Folder.Parent = p49
                        if GamePropsMod then GamePropsMod.build(Folder, p50.config.game) end
                        if p50.track and KartViewMod then
                            KartViewMod.build(Folder, p50.track.def.key)
                        elseif p50.config.game == "tower" and GoalTowerViewMod then
                            GoalTowerViewMod.build(Folder)
                        elseif p50.config.game == "quad" and QuadViewMod then
                            QuadViewMod.build(Folder)
                        elseif p50.config.game == "hoops" and HoopsViewMod then
                            HoopsViewMod.build(Folder)
                        elseif p50.config.game == "volley" and VolleyViewMod then
                            VolleyViewMod.build(Folder)
                        elseif p50.config.game == "tennis" and client:FindFirstChild("TennisView") then
                            require(client.TennisView).build(Folder)
                        end
                        local carsList = table.create(#p50.cars)
                        local looksMap = p51 or {}
                        local blueId = MatchMod and MatchMod.BLUE or 0
                        for i, v in p50.cars do
                            local lk = looksMap[i]
                            if not lk then
                                lk = LoadoutMod.look()
                                local tc = MatchViewMod.TEAM_COLORS[v.team] or MatchViewMod.TEAM_COLORS[blueId]
                                lk.paint = MatchViewMod.teamPaint(p50.config.game, v.team) or (tc and tc.paint)
                                lk.accent = tc and tc.accent
                                lk.decal = nil
                            end
                            carsList[i] = MatchViewMod.buildCar(Folder, v.car, lk, i, p50.config.game, v.team)
                            carsList[i]:setHitboxVisible(false)
                        end
                        local myLook = LoadoutMod.look()
                        local drawnList = table.create(#p50.cars)
                        for i in p50.cars do
                            drawnList[i] = {
                                pos = Vector3.new(0, 0, 0),
                                fwd = Vector3.new(1, 0, 0),
                                up = Vector3.new(0, 0, 1),
                                vel = Vector3.new(0, 0, 0),
                                onGround = true,
                                supersonic = false,
                            }
                        end
                        local initSnap = ofFn(p50)
                        local ballRad = ConstMod and ConstMod.BALL_RADIUS or 91.25
                        local mvObj = {
                            drawnBall = Vector3.new(0, 0, 0),
                            clubs = nil,
                            verified = nil,
                            mtiers = nil,
                            vips = nil,
                            tagHidden = nil,
                            tagSunk = nil,
                            tagFade = nil,
                            drawnBallFwd = Vector3.new(1, 0, 0),
                            drawn = drawnList,
                            tags = {},
                            match = p50,
                            folder = Folder,
                            cars = carsList,
                            ball = MatchViewMod.buildBall(Folder, myLook.ball, p50.ball.body.radius / ballRad, myLook.ballTint),
                            hasBall = GamesMod and GamesMod.hasBall(p50.config.game) or true,
                        }
                        local padsParent = (p50.track or p50.config.game == "tower") and Instance.new("Folder") or Folder
                        if PadsViewMod then mvObj.pads = PadsViewMod.new(padsParent, p50.pads) end
                        if p50.track and KartFxMod then mvObj.kartFx = KartFxMod.new(Folder, p50) end
                        if TwistPropsMod then mvObj.twistProps = TwistPropsMod.new(Folder, p50) end
                        mvObj.ballRadiusDrawn = p50.ball.body.radius
                        mvObj.prev = initSnap
                        mvObj.curr = initSnap
                        local v60 = setmetatable(mvObj, MatchViewMod)
                        if p50.config.game == "seeker" and SeekerViewMod then
                            v60.seekerView = SeekerViewMod.new(v60.ball, p50)
                        end
                        if p50.config.game == "powers" and PowersViewMod then
                            v60.powersView = PowersViewMod.new(Folder, p50, v60.ball)
                        end
                        return v60
                    end
                    MatchViewMod.new = repairedMvNew
                    if origSkinFuncs[MatchViewMod] then origSkinFuncs[MatchViewMod].new = repairedMvNew end
                end

                if checkSavedOrCurCorrupted(MatchViewMod, "setNames") then
                    local darkRimColor = Color3.fromRGB(2, 11, 51)
                    local repairedSetNames = function(p68, p69, p70, p71)
                        p68.localIndex = p70
                        if p71 == nil then p71 = p70 end
                        p68.ownIndex = p71
                        p68.ownersKnown = true
                        for i, v in p68.cars do
                            v:setOther(i ~= p68.ownIndex)
                        end
                        for i, v in p68.cars do
                            local oldTag = p68.tags[i]
                            if oldTag then
                                oldTag:Destroy()
                                p68.tags[i] = nil
                                MatchViewMod._hideBack(p68, i)
                                if p68.tagParts then p68.tagParts[i] = nil end
                            end
                            local nameStr = type(p69) == "table" and p69[i] or nil
                            local myCar = p70 and p68.match.cars[p70] or nil
                            local sameTeam = (myCar ~= nil and p68.match.cars[i] ~= nil) and (p68.match.cars[i].team == myCar.team) or false
                            if nameStr and i ~= p70 then
                                local carSlot = p68.match.cars[i]
                                local blueId = MatchMod and MatchMod.BLUE or 0
                                local tc = MatchViewMod.TEAM_COLORS[carSlot.team] or MatchViewMod.TEAM_COLORS[blueId]
                                local plateCol = MatchViewMod.teamPaint(p68.match.config.game, carSlot.team) or (tc and tc.paint) or Color3.fromRGB(46, 120, 226)
                                local darkInk = (p68.match.config.game == "quad" and carSlot.team == 2)
                                if not darkInk and type(MatchViewMod.plateFor) == "function" then
                                    plateCol = MatchViewMod.plateFor(plateCol)
                                end
                                local club = p68.clubs and p68.clubs[i] or nil
                                local clubW = not club and 0 or 0.72 * ((utf8.len(club.tag) or 2) + 1.4)
                                local clubGap = club and 0.45 or 0
                                local isVer = p68.verified and p68.verified[i] == true or false
                                local verW = isVer and 1.125 or 0
                                local mtier = (p68.mtiers and MasteryEmblemMod and MasteryEmblemMod.ON_NAMES) and (p68.mtiers[i] or 0) or 0
                                local mtierW = mtier > 0 and 1.2 or 0
                                local isVip = p68.vips and p68.vips[i] == true or false
                                local vipW = isVip and 1.125 or 0
                                local totalW = 0.72 * (utf8.len(nameStr) or 0) + 1.6 + clubW + clubGap + verW + vipW + mtierW
                                local bg = Instance.new("BillboardGui")
                                bg.Name = "Nametag"
                                p68.tagCel = (UiMod and UiMod.cel and UiMod.cel()) and 0.68 or 1
                                p68.tagAspect = p68.tagAspect or {}
                                p68.tagPx = p68.tagPx or {}
                                p68.tagAspect[i] = totalW / 1.5
                                p68.tagPx[i] = 20
                                bg.Size = UDim2.fromOffset(math.round(20 * totalW / 1.5) + 4, 24)
                                bg.StudsOffset = Vector3.new(0, 5.6, 0)
                                bg.SizeOffset = Vector2.new(0, 1.15)
                                bg.AlwaysOnTop = true
                                bg.MaxDistance = math.huge
                                bg.LightInfluence = 0
                                local share = sameTeam and 0.74 or 1
                                p68.tagShare = p68.tagShare or {}
                                p68.tagShare[i] = share
                                local rim = Instance.new("Frame")
                                rim.Name = "Rim"
                                rim.Size = UDim2.new(1, 0, share, (1 - share) * 4)
                                rim.BackgroundColor3 = darkRimColor
                                rim.BackgroundTransparency = 0.1
                                rim.BorderSizePixel = 0
                                rim.ZIndex = 0
                                rim.Parent = bg
                                local rc = Instance.new("UICorner")
                                rc.CornerRadius = UDim.new(0.24, 0)
                                rc.Parent = rim
                                local plate = Instance.new("Frame")
                                plate.Name = "Plate"
                                plate.Position = UDim2.fromOffset(2, 2)
                                plate.Size = UDim2.new(1, -4, share, share * -4)
                                plate.BackgroundColor3 = plateCol
                                plate.BorderSizePixel = 0
                                plate.Parent = bg
                                local pc = Instance.new("UICorner")
                                pc.CornerRadius = UDim.new(0.2, 0)
                                pc.Parent = plate
                                local pad = Instance.new("UIPadding")
                                pad.PaddingLeft = UDim.new(0.8 / totalW, 0)
                                pad.PaddingRight = UDim.new(0.8 / totalW, 0)
                                pad.Parent = plate
                                local lbl = Instance.new("TextLabel")
                                lbl.Name = "Name"
                                lbl.Size = UDim2.fromScale(1, 1)
                                lbl.BackgroundTransparency = 1
                                lbl.Text = nameStr
                                lbl.TextScaled = true
                                if UiMod and UiMod.BODY then lbl.FontFace = UiMod.BODY end
                                lbl.TextColor3 = (darkInk and UiMod and UiMod.INK) or Color3.new(1, 1, 1)
                                lbl.TextXAlignment = Enum.TextXAlignment.Center
                                lbl.ZIndex = 2
                                lbl.Parent = plate
                                if club and ClubBadgeMod then
                                    local innerW = totalW - 1.6
                                    local cS = clubW / innerW
                                    local gS = clubGap / innerW
                                    lbl.Position = UDim2.fromScale(cS + gS, 0)
                                    lbl.Size = UDim2.fromScale(1 - cS - gS, 1)
                                    local ct = Instance.new("Frame")
                                    ct.Name = "ClubTag"
                                    ct.AnchorPoint = Vector2.new(0, 0.5)
                                    ct.Position = UDim2.fromScale(0, 0.5)
                                    ct.Size = UDim2.fromScale(cS, 0.8)
                                    ct.ZIndex = 2
                                    ct.Parent = plate
                                    ClubBadgeMod.fill(ct, club)
                                    for _, d in ct:GetDescendants() do
                                        if d:IsA("GuiObject") then d.ZIndex = 3 end
                                    end
                                end
                                if not darkInk then
                                    local sh = lbl:Clone()
                                    sh.Name = "NameShadow"
                                    sh.TextColor3 = darkRimColor
                                    sh.TextTransparency = 0.3
                                    sh.Position = lbl.Position + UDim2.fromOffset(0, 1)
                                    sh.ZIndex = 1
                                    sh.Parent = plate
                                end
                                if type(MatchViewMod._measureTagText) == "function" then
                                    MatchViewMod._measureTagText(p68, i, lbl, plate:FindFirstChild("NameShadow"), totalW, share)
                                end
                                local lag = Instance.new("Frame")
                                lag.Name = "Lag"
                                lag.AnchorPoint = Vector2.new(1, 0)
                                lag.Position = UDim2.fromScale(1, 0)
                                lag.Size = UDim2.fromScale(0.5, 0.5)
                                lag.SizeConstraint = Enum.SizeConstraint.RelativeYY
                                lag.BackgroundColor3 = Color3.fromRGB(235, 64, 52)
                                lag.BorderSizePixel = 0
                                lag.Visible = false
                                lag.ZIndex = 3
                                lag.Parent = bg
                                if sameTeam then
                                    local bst = Instance.new("Frame")
                                    bst.Name = "Boost"
                                    bst.AnchorPoint = Vector2.new(0.5, 1)
                                    bst.Position = UDim2.new(0.5, 0, 1, -2)
                                    bst.Size = UDim2.new(0.86, -3.44, 0.18, -0.72)
                                    bst.BackgroundColor3 = plateCol:Lerp(Color3.new(0, 0, 0), 0.55)
                                    bst.BorderSizePixel = 0
                                    bst.Parent = bg
                                    local bc = Instance.new("UICorner")
                                    bc.CornerRadius = UDim.new(0.5, 0)
                                    bc.Parent = bst
                                    local fl = Instance.new("Frame")
                                    fl.Name = "Fill"
                                    fl.Size = UDim2.fromScale(0.33, 1)
                                    fl.BackgroundColor3 = Color3.fromRGB(255, 196, 46)
                                    fl.BorderSizePixel = 0
                                    fl.Parent = bst
                                    local fc = Instance.new("UICorner")
                                    fc.CornerRadius = UDim.new(0.5, 0)
                                    fc.Parent = fl
                                end
                                local parts = {}
                                for _, d in bg:GetDescendants() do
                                    if d:IsA("GuiObject") then
                                        table.insert(parts, { d, "BackgroundTransparency", d.BackgroundTransparency })
                                        if d:IsA("TextLabel") then
                                            table.insert(parts, { d, "TextTransparency", d.TextTransparency })
                                        elseif d:IsA("ImageLabel") then
                                            table.insert(parts, { d, "ImageTransparency", d.ImageTransparency })
                                        end
                                    elseif d:IsA("UIStroke") then
                                        table.insert(parts, { d, "Transparency", d.Transparency })
                                    end
                                end
                                p68.tagParts = p68.tagParts or {}
                                p68.tagParts[i] = parts
                                p68.tagFade = p68.tagFade or {}
                                p68.tagFade[i] = 0
                                if p68.tagSunk then p68.tagSunk[i] = nil end
                                p68.tagFadeDrawn = p68.tagFadeDrawn or {}
                                p68.tagFadeDrawn[i] = 0
                                bg.Enabled = v.visible and not (CreatorViewMod and CreatorViewMod.namesHidden)
                                bg.Parent = v.root
                                p68.tags[i] = bg
                            end
                        end
                    end
                    MatchViewMod.setNames = repairedSetNames
                    if origSkinFuncs[MatchViewMod] then origSkinFuncs[MatchViewMod].setNames = repairedSetNames end
                end

                if checkSavedOrCurCorrupted(MatchViewMod, "draw") then
                    local function basisFn(p20, p21, p22, p23, p24)
                        local v25 = p20 + (p22 - p20) * p24
                        local m1 = vector.magnitude(v25)
                        if m1 > 1e-6 then p22 = v25 / m1 end
                        local v26 = p21 + (p23 - p21) * p24
                        local m2 = vector.magnitude(v26)
                        if m2 > 1e-6 then p23 = v26 / m2 end
                        local cr = vector.cross(p23, p22)
                        local fallback = vector.create(p22.z, 0, -p22.x)
                        local m3 = vector.magnitude(cr)
                        if m3 > 1e-6 then fallback = cr / m3 end
                        local m4 = vector.magnitude(fallback)
                        local right = m4 <= 1e-6 and Vector3.new(1, 0, 0) or fallback / m4
                        return p22, right, vector.cross(p22, right)
                    end

                    local repairedDraw = function(p134, p135, p136, p137, p138, p139, p140, p141, p142)
                        if not (p136 and p137 and p136.cars and p137.cars) then return end
                        local mark = MatchViewMod.mark
                        local cam = workspace.CurrentCamera
                        local camPos = not cam and Vector3.new(0, 0, 0) or cam.CFrame.Position
                        for i, v in p134.cars do
                            local v144 = p136.cars[i]
                            local v145 = p137.cars[i]
                            if v144 and v145 then
                                local demoed = v145.demoed
                                if not demoed then
                                    if p134.drawingLive == true and p134.serverOut ~= nil then
                                        demoed = p134.serverOut[i] == true
                                    else
                                        demoed = false
                                    end
                                end
                                if demoed then
                                    demoed = not p134:demolitionHeld(i)
                                end
                                v:setVisible(not demoed)
                                local pos = v144.pos
                                local v146 = pos + (v145.pos - pos) * p138
                                local off = p139 and p139[i] or nil
                                if off then v146 = v146 + off end
                                local pose = (p134.drawingLive and p134.pastPoses) and p134.pastPoses[i] or nil
                                if pose and pose.w > 0 and PastViewNet then
                                    v146 = PastViewNet.place(v146, pose)
                                else
                                    pose = nil
                                end
                                local v149, v150, v151 = basisFn(v144.fwd, v144.up, v145.fwd, v145.up, p138)
                                p134.bellies = p134.bellies or {}
                                local carSlot = p134.match and p134.match.cars[i]
                                local cfg = carSlot and carSlot.car and carSlot.car.config or nil
                                local belly = p134.bellies[i]
                                if belly then
                                    belly.pos, belly.fwd, belly.right, belly.up, belly.on, belly.config = v146, v149, v150, v151, not demoed, cfg
                                else
                                    p134.bellies[i] = { pos = v146, fwd = v149, right = v150, up = v151, on = not demoed, config = cfg }
                                end
                                local turn = p141 and p141[i] or nil
                                if turn and PredictionNet then
                                    v149 = PredictionNet.rotate(turn, v149)
                                    v151 = PredictionNet.rotate(turn, v151)
                                    v150 = vector.cross(v151, v149)
                                end
                                if pose and PastViewNet then
                                    v149, v151 = PastViewNet.face(v149, v151, pose)
                                    v150 = vector.cross(v151, v149)
                                end
                                p134.wheelRecs = p134.wheelRecs or {}
                                local wRec = p134.wheelRecs[i]
                                if not wRec then
                                    wRec = { {}, {}, {}, {} }
                                    p134.wheelRecs[i] = wRec
                                end
                                for i2 = 1, 4 do
                                    local w1 = v144.wheels[i2]
                                    local w2 = v145.wheels[i2]
                                    local wr = wRec[i2]
                                    wr.suspensionLength = w1.suspensionLength + (w2.suspensionLength - w1.suspensionLength) * p138
                                    wr.steerAngle = w1.steerAngle + (w2.steerAngle - w1.steerAngle) * p138
                                    wr.inContact = w2.inContact
                                end
                                local vel = v144.vel
                                local v161 = vel + (v145.vel - vel) * p138
                                local boosting = v145.boosting
                                local supersonic = v145.supersonic
                                if pose then
                                    v161 = v161 + (pose.vel - v161) * pose.w
                                    if pose.w > 0.5 then
                                        boosting = pose.boost
                                        supersonic = pose.sonic
                                    end
                                end
                                if not demoed then
                                    if v145.demoed then
                                        v:update(p135, v146, v149, v150, v151, Vector3.new(0, 0, 0), wRec, false, false)
                                    else
                                        v:update(p135, v146, v149, v150, v151, v161, wRec, boosting, supersonic, v145.idle == true)
                                    end
                                end
                                local dr = p134.drawn[i]
                                if dr then
                                    dr.pos, dr.fwd, dr.up, dr.vel, dr.onGround, dr.supersonic = v146, v149, v151, v161, v145.onGround, v145.supersonic
                                end
                            end
                        end
                        local ballPos = p136.ballPos
                        local v172 = ballPos + (p137.ballPos - ballPos) * p138
                        if p140 then v172 = v172 + p140 end
                        local v173, v174, v175 = basisFn(p136.ballFwd, p136.ballUp, p137.ballFwd, p137.ballUp, p138)
                        p134.drawnBall = v172
                        p134.drawnBallFwd = v173
                        local rad = not (p134.match and p134.match.ball) and 91.25 or p134.match.ball.body.radius
                        local v177 = v172
                        if BallModelMod and type(BallModelMod.underCar) == "function" then
                            for _, b in p134.bellies or {} do
                                if b.on then
                                    local lift = BallModelMod.underCar(v172, rad, b.pos, b.fwd, b.right, b.up, b.config)
                                    if vector.magnitude(lift) > vector.magnitude(v177 - v172) then
                                        v177 = v172 + lift
                                    end
                                end
                            end
                        end
                        if mark then mark("v.carros") end
                        local bRad = p134.match.ball.body.radius
                        local cRad = ConstMod and ConstMod.BALL_RADIUS or 91.25
                        if math.abs(bRad - p134.ballRadiusDrawn) > 0.001 then
                            p134.ballRadiusDrawn = bRad
                            p134.ball:setScale(bRad / cRad)
                        end
                        if p134.twistProps then p134.twistProps:update() end
                        if p134.seekerView then
                            p134.seekerView:update(p137.seeker)
                            p134.seekerView:frame(v172, p142 or p135, p134.ballShown ~= false)
                        end
                        p134.ball:update(v177, v173, v174, v175, p142 or p135)
                        if mark then mark("v.bola") end
                        local okC, errC = pcall(MatchViewMod._paintCovers, p134)
                        if not okC then
                            pcall(MatchViewMod._unsinkAll, p134)
                        end
                        if mark then mark("v.capas") end
                        if p134.pads then p134.pads:update(p135) end
                        if mark then mark("v.pads") end
                        if p134.kartFx then p134.kartFx:update(p134.drawn, p134.cars) end
                        if p134.powersView then
                            if p137.taped then
                                p134.powersView:replay(p137, p134.drawn, p134.cars, p134.drawnBall, p134.ownIndex)
                                return
                            end
                            p134.powersView:update(p134.drawn, p134.cars, p134.drawnBall, p134.ownIndex)
                        end
                    end
                    MatchViewMod.draw = repairedDraw
                    if origSkinFuncs[MatchViewMod] then origSkinFuncs[MatchViewMod].draw = repairedDraw end
                end
            end

            -- 3. Repair MatchSession.new if corrupted to lookSign
            if MatchSessionMod and checkSavedOrCurCorrupted(MatchSessionMod, "new") then
                local SimFolder = shared:FindFirstChild("Sim")
                local NetFolder = shared:FindFirstChild("Net")
                local MatchMod = SimFolder and require(SimFolder.Match)
                local ConstMod = SimFolder and require(SimFolder.Const)
                local GamesMod = SimFolder and require(SimFolder.Games)
                local FastPathsMod = SimFolder and SimFolder:FindFirstChild("FastPaths") and require(SimFolder.FastPaths)
                local PredictionNet = NetFolder and require(NetFolder.Prediction)
                local QualityNet = NetFolder and require(NetFolder.Quality)
                local SmoothNet = NetFolder and require(NetFolder.Smooth)
                local PastViewNet = NetFolder and require(NetFolder.PastView)
                local MidPastNet = NetFolder and require(NetFolder.MidPast)
                local PathSmoothNet = NetFolder and require(NetFolder.PathSmooth)
                local FastStatesNet = NetFolder and require(NetFolder.FastStates)
                local OwnSmoothNet = NetFolder and require(NetFolder.OwnSmooth)
                local ResetsNet = NetFolder and require(NetFolder.Resets)
                local ReplayTapeMod = shared:FindFirstChild("ReplayTape") and require(shared.ReplayTape)
                local CreatorViewMod = client:FindFirstChild("CreatorView") and require(client.CreatorView)
                local ClubBadgeMod = client:FindFirstChild("ClubBadge") and require(client.ClubBadge)
                local LocalNamesMod = client:FindFirstChild("LocalNames") and require(client.LocalNames)
                local EffectsMod = client:FindFirstChild("Effects") and require(client.Effects)

                local function lookSignFn(p12)
                    local v13 = { tostring(p12.team) }
                    if type(p12.loadout) == "table" then
                        local v14 = {}
                        for i in p12.loadout do table.insert(v14, i) end
                        table.sort(v14)
                        for _, v in v14 do
                            table.insert(v13, v .. "=" .. tostring(p12.loadout[v]))
                        end
                    end
                    return table.concat(v13, ";")
                end

                local function newNetlogFn(p11)
                    return {
                        snaps = 0, replayN = 0, replaySum = 0, replayMin = math.huge, replayMax = 0,
                        costSum = 0, costWorst = 0, leadMin = math.huge, bufferMin = math.huge, bufferMax = -math.huge,
                        rateMin = math.huge, rateMax = -math.huge, turnWorst = 0, teleports = 0, hard = 0, resyncs = 0,
                        frameWorst = 0, ticksWorst = 0, serverHz = math.huge, serverCpu = 0, serverWorst = 0, serverMatches = 0,
                        decodeN = 0, decodeSum = 0, decodeWorst = 0, since = p11,
                        mine = { n = 0, sum = 0, worst = 0 },
                        others = { n = 0, sum = 0, worst = 0 },
                        ball = { n = 0, sum = 0, worst = 0 },
                    }
                end

                local repairedMsNew = function(p16, u17, p18)
                    pcall(function()
                        local gc = RS:FindFirstChild("GameConfig")
                        local fp = gc and gc:GetAttribute("FastPhysics")
                        if FastPathsMod then FastPathsMod.set(fp ~= false) end
                    end)
                    local u19 = {
                        teamSize = u17.teamSize, duration = u17.duration, countdown = u17.countdown,
                        kickoffWait = u17.kickoffWait, goalPause = u17.goalPause, demos = u17.demos,
                        gravity = u17.gravity, ballScale = u17.ballScale, boost = u17.boost,
                        game = u17.game, goalLimit = u17.goalLimit, free = u17.free == true,
                        track = u17.track, twist = u17.twist, seed = u17.seed,
                    }
                    local v20 = MatchMod.new(u19)
                    v20.waitsForEnd = true
                    v20.lapAtEnd = MatchMod.PARTY_SECONDS
                    v20:readModsWire(u17.mods)
                    local u21 = {}
                    for _, v in u17.roster do
                        local v22 = v.team == MatchMod.ORANGE and "orange" or "blue"
                        local isOwn = (v.index == u17.index) and (not u17.spectating) or false
                        local dressedLoadout = nil
                        if not isOwn then
                            local myTeam = not u17.spectating and u17.team or nil
                            local okD, dRes = pcall(CreatorViewMod.dress, v.loadout, v.team, myTeam)
                            dressedLoadout = okD and dRes or (type(v.loadout) == "table" and v.loadout or nil)
                        end
                        if dressedLoadout or isOwn then
                            local okL, result = pcall(LoadoutMod.look, dressedLoadout, v22)
                            if not okL then
                                result = LoadoutMod.look(ItemsMod.DEFAULT_LOADOUT, v22)
                            end
                            result.paint = MatchViewMod.teamPaint(u19.game, v.team) or result.paint
                            pcall(ClubBadgeMod.dress, result, u17.roster, u19.game, v.team)
                            u21[v.index] = result
                            local hb = result.hitbox
                            local presetHb = hb
                            if v.loadout then
                                local okH, hRes = pcall(ItemsMod.hitboxOf, v.loadout)
                                if okH and hRes then presetHb = hRes end
                            end
                            v20:setCarPreset(v.index, presetHb)
                        end
                    end
                    pcall(function()
                        if EffectsMod then EffectsMod.warmLooks(u21) end
                    end)
                    local u29 = {}
                    local ownTrack = not u17.spectating and u17.index or nil
                    if LocalNamesMod then
                        LocalNamesMod.track(u17.roster, ownTrack)
                        for _, v in u17.roster do
                            if v.name then u29[v.index] = LocalNamesMod.of(v) end
                        end
                    end
                    local function applyVacancies(p31, p32)
                        local v33 = {}
                        for _, v in p32 do v33[v.index] = v.left ~= true end
                        local totalCars = (u19.teamSize or 1) * (GamesMod and GamesMod.teams(u19.game) or 2)
                        for i = 1, totalCars do
                            p31:setVacant(i, not v33[i])
                        end
                    end
                    applyVacancies(v20, u17.roster)
                    local v34 = {}
                    for _, v in u17.roster do v34[v.index] = lookSignFn(v) end
                    local ownIdx = not u17.spectating and u17.index or nil
                    local touchOnly = UIS.TouchEnabled and not UIS.KeyboardEnabled
                    local v35 = {
                        match = v20, respawnSpot = 0, respawnPick = 0, ownOutSeen = false, steerHeld = false,
                        ghost = nil, ghostRoot = nil, ghostSpot = nil, ghostZ = nil, restWarmed = nil,
                        serverOut = {}, applyVacancies = applyVacancies, remotes = p18, looks = u21,
                        lookSigns = v34, names = u29, index = u17.index, team = u17.team, roster = u17.roster,
                        spectating = u17.spectating == true, own = ownIdx,
                        creatorSeen = CreatorViewMod and CreatorViewMod.version or 0,
                        prediction = PredictionNet.new(v20, ownIdx),
                        view = MatchViewMod.new(p16, v20, u21),
                        accumulator = 0, rate = 1, lastAcked = 0, lastSyncTick = 0, ownPing = nil,
                        bufferError = 0, lastSent = 0, lastCatchUp = 0, catchUpDebt = 0,
                        offsets = {}, ballOffset = Vector3.new(0, 0, 0), springs = {},
                        quality = QualityNet.new((u17.teamSize == 1 and 2 or 4) * ConstMod.TICK_TIME),
                        frameDt = 1 / 60, pingAt = 0, tones = {}, dryBefore = {}, turnSprings = {},
                        ballSpring = SmoothNet.new(), turns = {}, pastView = PastViewNet.new(),
                        pastPoses = nil, pastAt = 0, poseSlots = {}, poseBook = {}, pastStill = { w = 0 },
                        tape = ReplayTapeMod.new(), yaws = {}, mids = MidPastNet.new(), leadFloor = nil,
                        ballPath = PathSmoothNet.newBall(), halfRate = touchOnly,
                        applyGap = touchOnly and 4 or 1, applyGapFloor = touchOnly and 4 or 1,
                        netlog = newNetlogFn(os.clock()), pings = "", starved = 0, wanted = 0, saidGo = false,
                        score = { blue = 0, orange = 0 }, phase = v20.phase, over = false,
                        corrections = 0, worstCorrection = 0,
                        tally = { snaps = 0, replays = 0, fixes = 0, sum = 0, worst = 0, since = 0, spent = 0, frames = 0 },
                        fast = FastStatesNet.new(), ownDraw = OwnSmoothNet.new(),
                        net = { snaps = 0, replays = 0, fixes = 0, mean = 0, worst = 0 },
                        replaying = false, seenFlags = {}, resets = ResetsNet.new(),
                        pendingPacket = nil, pendingTick = 0, events = {},
                    }
                    local u38 = setmetatable(v35, MatchSessionMod)
                    local cfgClone = table.clone(u19)
                    function u38.prediction.makeShadow()
                        return MatchMod.new(table.clone(cfgClone))
                    end
                    u38.connections = {
                        p18.Snapshot.OnClientEvent:Connect(function(pkt)
                            if typeof(pkt) == "buffer" then
                                QualityNet.onPacket(u38.quality, os.clock(), u38.frameDt)
                                u38:_snapshot(pkt)
                            end
                        end),
                        p18.Sync.OnClientEvent:Connect(function(pkt)
                            if typeof(pkt) == "buffer" then
                                u38:_sync(pkt)
                            end
                        end),
                    }
                    pcall(function()
                        if ClubBadgeMod then u38.view.clubs = ClubBadgeMod.byIndex(u17.roster) end
                        u38.view.verified = {}
                        for _, v in u17.roster or {} do
                            if type(v) == "table" and v.verified == true and type(v.index) == "number" then
                                u38.view.verified[v.index] = true
                            end
                        end
                        u38.view.mtiers = {}
                        u38.view.vips = {}
                        for _, v in u17.roster or {} do
                            if type(v) == "table" and type(v.index) == "number" and type(v.loadout) == "table" then
                                u38.view.mtiers[v.index] = tonumber(v.loadout.mtier) or 0
                                u38.view.vips[v.index] = v.loadout.vip == "1"
                            end
                        end
                        u38.view:setNames(u29, u17.index)
                    end)
                    return u38
                end
                MatchSessionMod.new = repairedMsNew
                if origSkinFuncs[MatchSessionMod] then origSkinFuncs[MatchSessionMod].new = repairedMsNew end
            end
        end)

        local function getTrueOrigFn(obj, key)
            if type(obj) ~= "table" then return nil end
            local cur = rawget(obj, key) or obj[key]
            if type(cur) ~= "function" then return nil end
            local byObj = origSkinFuncs[obj]
            if not byObj then
                byObj = {}
                origSkinFuncs[obj] = byObj
            end
            if type(byObj[key]) ~= "function" then
                -- NEVER blindly peel upvalues of native game functions! Only save cur directly.
                byObj[key] = cur
            end
            return byObj[key]
        end

        local function restoreTrueOrigFn(obj, key)
            local orig = getTrueOrigFn(obj, key)
            if type(orig) == "function" then
                obj[key] = orig
            end
        end

        local function hookSkinFn(obj, key, makeWrapper)
            local orig = getTrueOrigFn(obj, key)
            if type(orig) ~= "function" then return end
            local wrapper = makeWrapper(orig)
            obj[key] = wrapper
            table.insert(hooked, { object = obj, key = key, wrapper = wrapper, restore = orig })
        end

        -- Immediately strip any stacked per-frame hooks or isDisabledCar hooks left over from previous script runs!
        restoreTrueOrigFn(ItemsMod, "isDisabledCar")
        if MatchViewMod then
            for _, hotKey in { "update", "draw", "record", "sync", "refresh" } do
                restoreTrueOrigFn(MatchViewMod, hotKey)
            end
        end

        populateAllOwnedSets()

        pcall(function()
            -- NOTE: Do NOT override ItemsMod.isDisabledCar! Disabled cars have broken/missing 3D meshes and cause invisible cars!
            hookSkinFn(ItemsMod, "betaLocked", function(origBeta)
                return function(...)
                    if alive then return false end
                    return origBeta(...)
                end
            end)
            hookSkinFn(ItemsMod, "visible", function(origVis)
                return function(item, ownsFn, ...)
                    if alive then
                        if type(item) == "table" then
                            if item.disabled == true or item.retired == true or item.held == true or item.hold == true or item.gone == true then
                                return false
                            end
                            if item.kind == "car" and not isCarArtLoaded(item) then
                                return false
                            end
                        end
                        return origVis(item, function() return true end, ...)
                    end
                    return origVis(item, ownsFn, ...)
                end
            end)
        end)

        -- Unlock every Progression level/finish check in ReplicatedStorage.Shared.Progression
        pcall(function()
            local progSharedMod = shared:FindFirstChild("Progression")
            if progSharedMod then
                local ProgressionShared = require(progSharedMod)
                if type(ProgressionShared) == "table" then
                    for k, fn in ProgressionShared do
                        if type(fn) == "function" then
                            local kl = tostring(k):lower()
                            if kl:find("unlock") or kl:find("own") or kl:find("has") or kl:find("can") or kl:find("finish") or kl:find("allow") then
                                hookSkinFn(ProgressionShared, k, function(origFn)
                                    return function(...)
                                        if alive then return true end
                                        return origFn(...)
                                    end
                                end)
                            elseif kl:find("lock") then
                                hookSkinFn(ProgressionShared, k, function(origFn)
                                    return function(...)
                                        if alive then return false end
                                        return origFn(...)
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end)

        -- Hook Loadout.set so server state resyncs NEVER overwrite our custom client items
        pcall(function()
            hookSkinFn(LoadoutMod, "set", function(origLoadoutSet)
                return function(pBlue, pOrange, pSplit, ...)
                    if alive and customOverrideActive and desiredBlue then
                        return origLoadoutSet(
                            desiredBlue,
                            desiredOrange or pOrange,
                            desiredSplit ~= nil and desiredSplit or pSplit,
                            ...
                        )
                    end
                    return origLoadoutSet(pBlue, pOrange, pSplit, ...)
                end
            end)
        end)

        if ProgressMod then
            pcall(function()
                hookSkinFn(ProgressMod, "owns", function(origOwns)
                    return function(itemId, ...)
                        if alive and itemId ~= nil then
                            if type(itemId) == "string" and ItemsMod and type(ItemsMod.isDisabledCar) == "function" then
                                local okD, isDis = pcall(ItemsMod.isDisabledCar, itemId)
                                if okD and isDis == true then
                                    return false
                                end
                            end
                            return true
                        end
                        return origOwns(itemId, ...)
                    end
                end)
                hookSkinFn(ProgressMod, "copiesOf", function(origCopies)
                    return function(itemId, ...)
                        if alive and itemId ~= nil then return 1 end
                        return origCopies(itemId, ...)
                    end
                end)
                hookSkinFn(ProgressMod, "isFresh", function(origFresh)
                    return function(itemId, ...)
                        if alive then return false end
                        return origFresh(itemId, ...)
                    end
                end)
                hookSkinFn(ProgressMod, "isFavorite", function(origIsFav)
                    return function(itemId, ...)
                        if alive and type(itemId) == "string" then
                            if savedFavoritesSet[itemId] == true then return true end
                        end
                        return origIsFav(itemId, ...)
                    end
                end)
                hookSkinFn(ProgressMod, "setFavorite", function(origSetFav)
                    return function(itemId, onFlag, ...)
                        if alive and type(itemId) == "string" then
                            local isOn = onFlag == true
                            savedFavoritesSet[itemId] = isOn and true or nil
                            ProgressMod.favoriteSet = ProgressMod.favoriteSet or {}
                            ProgressMod.favoriteSet[itemId] = isOn and true or nil
                            if type(ProgressMod.state) == "table" then
                                local favList = {}
                                for k, v in ProgressMod.favoriteSet do
                                    if v then table.insert(favList, k) end
                                end
                                ProgressMod.state.favorites = favList
                            end
                            updateRandomGoalBtnVisual()
                            if type(saveCurrentPresetToFile) == "function" then
                                pcall(saveCurrentPresetToFile, true)
                            end
                            return
                        end
                        return origSetFav(itemId, onFlag, ...)
                    end
                end)
                if ProgressMod.Changed then
                    connect(ProgressMod.Changed, function()
                        if alive then
                            populateAllOwnedSets()
                            if customOverrideActive and desiredBlue then
                                syncProgressStateLoadout(desiredBlue, desiredOrange, desiredSplit)
                            end
                        end
                    end)
                end

                -- Intercept Progress.call("equip" | "teamSplit" | "presetLoad") so unowned items equip with 0 server delay and never revert!
                hookSkinFn(ProgressMod, "call", function(origCall)
                    return function(actionName, payload, ...)
                        if alive and actionName == "equip" and type(payload) == "table" then
                            customOverrideActive = true
                            local slot = payload.slot
                            local itemId = payload.id
                            local team = payload.team
                            local pairSlot = payload.pair or payload.pairSlot
                            local b = table.clone(desiredBlue or LoadoutMod.blueIds or LoadoutMod.ids or {})
                            local o = table.clone(desiredOrange or LoadoutMod.orangeIds or LoadoutMod.ids or {})
                            applySlotMutation(b, o, slot, itemId, team, pairSlot)
                            desiredBlue = b
                            desiredOrange = o
                            if desiredSplit == nil then desiredSplit = LoadoutMod.split end
                            populateAllOwnedSets(false)
                            syncProgressStateLoadout(desiredBlue, desiredOrange, desiredSplit)
                            applyingSkinNow = true
                            runAsGameScript(function()
                                LoadoutMod.preview = nil
                                LoadoutMod.previewMods = nil
                                LoadoutMod.set(desiredBlue, desiredOrange, desiredSplit)
                            end)
                            refreshLiveMatchCars(false)
                            syncIndicesFromCurrentLoadout()
                            applyingSkinNow = false
                            if type(broadcastMyState) == "function" then
                                broadcastMyState(false)
                            end
                            return { ok = true, state = ProgressMod.state }
                        elseif alive and actionName == "favorite" and type(payload) == "table" and type(payload.id) == "string" then
                            local isOn = payload.on == true
                            savedFavoritesSet[payload.id] = isOn and true or nil
                            ProgressMod.favoriteSet = ProgressMod.favoriteSet or {}
                            ProgressMod.favoriteSet[payload.id] = isOn and true or nil
                            updateRandomGoalBtnVisual()
                            return { ok = true, state = ProgressMod.state }
                        elseif alive and actionName == "teamSplit" and type(payload) == "table" then
                            customOverrideActive = true
                            desiredSplit = payload.on == true
                            if not desiredBlue then
                                desiredBlue = table.clone(LoadoutMod.blueIds or LoadoutMod.ids or {})
                            end
                            if not desiredOrange then
                                desiredOrange = table.clone(LoadoutMod.orangeIds or LoadoutMod.ids or {})
                            end
                            syncProgressStateLoadout(desiredBlue, desiredOrange, desiredSplit)
                            applyingSkinNow = true
                            runAsGameScript(function()
                                LoadoutMod.set(desiredBlue, desiredOrange, desiredSplit)
                            end)
                            refreshLiveMatchCars(false)
                            applyingSkinNow = false
                            if type(broadcastMyState) == "function" then
                                broadcastMyState(false)
                            end
                            return { ok = true, state = ProgressMod.state }
                        end
                        local res = origCall(actionName, payload, ...)
                        if alive then
                            populateAllOwnedSets(false)
                            if customOverrideActive and desiredBlue then
                                syncProgressStateLoadout(desiredBlue, desiredOrange, desiredSplit)
                                applyingSkinNow = true
                                runAsGameScript(function()
                                    LoadoutMod.set(desiredBlue, desiredOrange, desiredSplit)
                                end)
                                applyingSkinNow = false
                            end
                        end
                        return res
                    end
                end)

                -- Also wrap Progress.equip directly to ensure 100% instant local application
                hookSkinFn(ProgressMod, "equip", function(origEquip)
                    return function(slot, itemId, team, pairSlot, ...)
                        if not alive then return origEquip(slot, itemId, team, pairSlot, ...) end
                        customOverrideActive = true
                        local b = table.clone(desiredBlue or LoadoutMod.blueIds or LoadoutMod.ids or {})
                        local o = table.clone(desiredOrange or LoadoutMod.orangeIds or LoadoutMod.ids or {})
                        applySlotMutation(b, o, slot, itemId, team, pairSlot)
                        desiredBlue = b
                        desiredOrange = o
                        if desiredSplit == nil then desiredSplit = LoadoutMod.split end
                        populateAllOwnedSets(false)
                        syncProgressStateLoadout(desiredBlue, desiredOrange, desiredSplit)
                        applyingSkinNow = true
                        runAsGameScript(function()
                            LoadoutMod.preview = nil
                            LoadoutMod.previewMods = nil
                            LoadoutMod.set(desiredBlue, desiredOrange, desiredSplit)
                        end)
                        refreshLiveMatchCars(false)
                        syncIndicesFromCurrentLoadout()
                        applyingSkinNow = false
                        if type(broadcastMyState) == "function" then
                            broadcastMyState(false)
                        end
                        return { ok = true, state = ProgressMod.state }
                    end
                end)
            end)
        end

        -- 3. Hook MatchView and MatchSession creation/rebuild methods ONLY (NEVER per-frame update/draw/record/sync/refresh!)
        if MatchSessionMod then
            pcall(function()
                hookSkinFn(MatchSessionMod, "new", function(origFn)
                    return function(...)
                        local res = origFn(...)
                        if alive and type(res) == "table" then
                            activeMatchSessions[res] = true
                            if type(rawget(res, "view")) == "table" then
                                activeMatchViews[res.view] = true
                            end
                            syncSessionLook(res)
                            if type(rawget(res, "view")) == "table" then
                                if customOverrideActive then
                                    applyLookToMatchView(res.view, false)
                                end
                                applyPeerLooksToMatchView(res.view, false)
                            end
                            if type(broadcastMyState) == "function" then
                                broadcastMyState(true)
                            end
                        end
                        return res
                    end
                end)
                if type(MatchSessionMod.setRoster) == "function" then
                    hookSkinFn(MatchSessionMod, "setRoster", function(origSetRoster)
                        return function(self, newRoster, ...)
                            if alive and type(self) == "table" and type(newRoster) == "table" and next(peerStates) ~= nil then
                                local localIdx = rawget(self, "own") or rawget(self, "index")
                                local sessNames = rawget(self, "names")
                                local match = rawget(self, "match")
                                for _, rEntry in newRoster do
                                    if type(rEntry) == "table" and type(rEntry.index) == "number" and rEntry.index ~= localIdx then
                                        local pState = findPeerStateForRosterEntry(rEntry, sessNames, rEntry.index)
                                        if pState then
                                            local carEntry = type(match) == "table" and type(match.cars) == "table" and match.cars[rEntry.index] or rEntry
                                            local teamStr = getLocalTeamString(match, carEntry)
                                            local rawIds = (teamStr == "orange" and pState.split and type(pState.orangeIds) == "table" and next(pState.orangeIds) ~= nil)
                                                and pState.orangeIds
                                                or pState.blueIds
                                            if type(rawIds) == "table" and next(rawIds) ~= nil then
                                                rEntry.loadout = sanitizePeerLoadoutIds(rawIds)
                                            end
                                        end
                                    end
                                end
                            end
                            local res = origSetRoster(self, newRoster, ...)
                            if alive and type(self) == "table" then
                                syncSessionLook(self)
                                local vw = rawget(self, "view")
                                if type(vw) == "table" then
                                    applyPeerLooksToMatchView(vw, false)
                                end
                            end
                            return res
                        end
                    end)
                end
                if type(MatchSessionMod._redress) == "function" then
                    hookSkinFn(MatchSessionMod, "_redress", function(origRedress)
                        return function(self, ...)
                            local res = origRedress(self, ...)
                            if alive and type(self) == "table" then
                                syncSessionLook(self)
                                local vw = rawget(self, "view")
                                if type(vw) == "table" then
                                    applyPeerLooksToMatchView(vw, false)
                                end
                            end
                            return res
                        end
                    end)
                end
                hookSkinFn(MatchSessionMod, "goalStyleOf", function(origFn)
                    return function(self, carIdx, ...)
                        if alive and LoadoutMod and type(self) == "table" then
                            local localIdx = rawget(self, "own") or rawget(self, "index")
                            if type(localIdx) == "number" and carIdx == localIdx then
                                if randomGoalEnabled then
                                    local now = os.clock()
                                    if now - lastMatchGoalRollClock > 1.8 or not lastRolledGoalStyle then
                                        lastMatchGoalRollClock = now
                                        rollNextRandomGoalStyle()
                                        if type(broadcastMyState) == "function" then
                                            broadcastMyState(true)
                                        end
                                    end
                                    if type(lastRolledGoalStyle) == "string" and lastRolledGoalStyle ~= "" then
                                        local looks = rawget(self, "looks")
                                        if type(looks) == "table" and type(looks[localIdx]) == "table" then
                                            looks[localIdx].goal = lastRolledGoalStyle
                                        end
                                        return lastRolledGoalStyle
                                    end
                                end
                                if customOverrideActive then
                                    local okL, customLook = runAsGameScript(LoadoutMod.look)
                                    if okL and type(customLook) == "table" and customLook.goal then
                                        return customLook.goal
                                    end
                                end
                            elseif type(carIdx) == "number" and next(peerStates) ~= nil then
                                local roster = rawget(self, "roster")
                                local sessNames = rawget(self, "names")
                                local rEntry = nil
                                if type(roster) == "table" then
                                    for _, entry in roster do
                                        if type(entry) == "table" and entry.index == carIdx then
                                            rEntry = entry
                                            break
                                        end
                                    end
                                end
                                local pState = findPeerStateForRosterEntry(rEntry, sessNames, carIdx)
                                if pState then
                                    if type(pState.goalStyle) == "string" and pState.goalStyle ~= "" then
                                        local looks = rawget(self, "looks")
                                        if type(looks) == "table" and type(looks[carIdx]) == "table" then
                                            looks[carIdx].goal = pState.goalStyle
                                        end
                                        return pState.goalStyle
                                    end
                                    local looks = rawget(self, "looks")
                                    if type(looks) == "table" and type(looks[carIdx]) == "table" and type(looks[carIdx].goal) == "string" then
                                        return looks[carIdx].goal
                                    end
                                    local match = rawget(self, "match")
                                    local carEntry = type(match) == "table" and type(match.cars) == "table" and match.cars[carIdx] or rEntry
                                    local peerLook = computePeerLookForSlot(pState, match, carEntry, roster)
                                    if type(peerLook) == "table" and type(peerLook.goal) == "string" then
                                        return peerLook.goal
                                    end
                                end
                            end
                        end
                        return origFn(self, carIdx, ...)
                    end
                end)
                if type(MatchSessionMod.demoStyleOf) == "function" then
                    hookSkinFn(MatchSessionMod, "demoStyleOf", function(origDemoFn)
                        return function(self, carIdx, ...)
                            if alive and LoadoutMod and type(self) == "table" and type(carIdx) == "number" then
                                local localIdx = rawget(self, "own") or rawget(self, "index")
                                if carIdx == localIdx and customOverrideActive then
                                    local okL, customLook = runAsGameScript(LoadoutMod.look)
                                    if okL and type(customLook) == "table" and customLook.demo then
                                        return customLook.demo
                                    end
                                elseif carIdx ~= localIdx and next(peerStates) ~= nil then
                                    local roster = rawget(self, "roster")
                                    local sessNames = rawget(self, "names")
                                    local rEntry = nil
                                    if type(roster) == "table" then
                                        for _, entry in roster do
                                            if type(entry) == "table" and entry.index == carIdx then
                                                rEntry = entry
                                                break
                                            end
                                        end
                                    end
                                    local pState = findPeerStateForRosterEntry(rEntry, sessNames, carIdx)
                                    if pState then
                                        local looks = rawget(self, "looks")
                                        if type(looks) == "table" and type(looks[carIdx]) == "table" and type(looks[carIdx].demo) == "string" then
                                            return looks[carIdx].demo
                                        end
                                        local match = rawget(self, "match")
                                        local carEntry = type(match) == "table" and type(match.cars) == "table" and match.cars[carIdx] or rEntry
                                        local peerLook = computePeerLookForSlot(pState, match, carEntry, roster)
                                        if type(peerLook) == "table" and type(peerLook.demo) == "string" then
                                            return peerLook.demo
                                        end
                                    end
                                end
                            end
                            return origDemoFn(self, carIdx, ...)
                        end
                    end)
                end
            end)
        end

        -- Hook Effects.goal and SoundFx.goalStyle so Random Goal ALSO works in Freeplay / Training!
        if EffectsMod and type(EffectsMod.goal) == "function" then
            pcall(function()
                hookSkinFn(EffectsMod, "goal", function(origEffectsGoal)
                    return function(self, pos, orangeSide, style, extra, ...)
                        if alive and randomGoalEnabled then
                            local inGaragePreview = (GarageMod and type(GarageMod.live) == "table" and GarageMod.live.isOpen == true)
                            local hasActiveMatch = false
                            for sess in activeMatchSessions do
                                if type(sess) == "table" and rawget(sess, "over") ~= true then
                                    hasActiveMatch = true
                                    break
                                end
                            end
                            if not inGaragePreview and not hasActiveMatch then
                                local now = os.clock()
                                if now - lastFreeplayGoalRollClock > 1.8 or not lastRolledGoalStyle then
                                    lastFreeplayGoalRollClock = now
                                    rollNextRandomGoalStyle()
                                end
                                if type(lastRolledGoalStyle) == "string" and lastRolledGoalStyle ~= "" then
                                    style = lastRolledGoalStyle
                                end
                            end
                        end
                        return origEffectsGoal(self, pos, orangeSide, style, extra, ...)
                    end
                end)
            end)
        end

        if SoundFxMod and type(SoundFxMod.goalStyle) == "function" then
            pcall(function()
                hookSkinFn(SoundFxMod, "goalStyle", function(origGoalStyle)
                    return function(self, style, pos, ...)
                        if alive and randomGoalEnabled and type(lastRolledGoalStyle) == "string" and lastRolledGoalStyle ~= "" then
                            if os.clock() - lastFreeplayGoalRollClock < 1.8 or os.clock() - lastMatchGoalRollClock < 1.8 then
                                style = lastRolledGoalStyle
                            end
                        end
                        return origGoalStyle(self, style, pos, ...)
                    end
                end)
            end)
        end

        -- Make heart (Star) icons always visible on Garage cards so user can easily heart/unheart goals without hunting for hover!
        if GarageMod and type(GarageMod._paintMark) == "function" then
            pcall(function()
                hookSkinFn(GarageMod, "_paintMark", function(origPaintMark)
                    return function(self, card, ...)
                        local res = origPaintMark(self, card, ...)
                        if alive and type(card) == "table" and card.star and card.star.Parent then
                            local entry = card.entry
                            if not (type(entry) == "table" and entry.none == true) then
                                card.star.Parent.Visible = true
                            end
                        end
                        return res
                    end
                end)
                if type(GarageMod.live) == "table" and type(GarageMod.live.cards) == "table" then
                    for _, card in GarageMod.live.cards do
                        if type(card) == "table" and card.star and card.star.Parent then
                            local entry = card.entry
                            if not (type(entry) == "table" and entry.none == true) then
                                card.star.Parent.Visible = true
                            end
                        end
                    end
                end
            end)
        end

        if MatchViewMod then
            pcall(function()
                hookSkinFn(MatchViewMod, "new", function(origMvNew)
                    return function(folder, match, looksTbl, ...)
                        local mv = origMvNew(folder, match, looksTbl, ...)
                        if alive and type(mv) == "table" then
                            activeMatchViews[mv] = true
                            lastAppliedLookByView[mv] = nil
                        end
                        return mv
                    end
                end)
                hookSkinFn(MatchViewMod, "setNames", function(origSetNames)
                    return function(self, names, localIndex, ownIndex, ...)
                        local res = origSetNames(self, names, localIndex, ownIndex, ...)
                        if alive and type(self) == "table" then
                            activeMatchViews[self] = true
                            if customOverrideActive then
                                applyLookToMatchView(self, false)
                            end
                            applyPeerLooksToMatchView(self, false)
                        end
                        return res
                    end
                end)
                hookSkinFn(MatchViewMod, "rebuildCar", function(origRebuildCar)
                    return function(self, carIdx, look, ...)
                        if alive and LoadoutMod and type(self) == "table" then
                            local localIdx = rawget(self, "ownIndex") or rawget(self, "localIndex")
                            local linkedSess = nil
                            for sess in activeMatchSessions do
                                if type(sess) == "table" and rawget(sess, "view") == self then
                                    linkedSess = sess
                                    if not localIdx and type(rawget(sess, "index")) == "number" then
                                        localIdx = rawget(sess, "index")
                                    end
                                    break
                                end
                            end
                            if customOverrideActive and type(localIdx) == "number" and carIdx == localIdx then
                                local match = rawget(self, "match")
                                local carEntry = type(match) == "table" and type(match.cars) == "table" and match.cars[localIdx] or nil
                                local teamStr = getLocalTeamString(match, carEntry)
                                local okL, customLook = runAsGameScript(LoadoutMod.look, nil, teamStr)
                                if okL and type(customLook) == "table" then
                                    look = sanitizeLookForRebuild(customLook)
                                    if MatchViewMod and type(MatchViewMod.teamPaint) == "function" and type(match) == "table" and type(match.config) == "table" and type(carEntry) == "table" then
                                        look.paint = MatchViewMod.teamPaint(match.config.game, carEntry.team) or look.paint
                                    end
                                end
                            elseif type(carIdx) == "number" and carIdx ~= localIdx and next(peerStates) ~= nil then
                                local roster = linkedSess and rawget(linkedSess, "roster") or nil
                                local sessNames = linkedSess and rawget(linkedSess, "names") or nil
                                local rEntry = nil
                                if type(roster) == "table" then
                                    for _, entry in roster do
                                        if type(entry) == "table" and entry.index == carIdx then
                                            rEntry = entry
                                            break
                                        end
                                    end
                                end
                                local pState = findPeerStateForRosterEntry(rEntry, sessNames, carIdx)
                                if pState then
                                    local match = rawget(self, "match")
                                    local carEntry = type(match) == "table" and type(match.cars) == "table" and match.cars[carIdx] or rEntry
                                    local peerLook = computePeerLookForSlot(pState, match, carEntry, roster)
                                    if type(peerLook) == "table" then
                                        look = peerLook
                                    end
                                end
                            end
                            if safeRebuildMatchCar(self, carIdx, look) then
                                return
                            end
                        end
                        local _, res = runAsGameScript(origRebuildCar, self, carIdx, look, ...)
                        return res
                    end
                end)
                -- Restore buildCar to its true original so it never uses a stale P.localCarId during MatchView.new!
                restoreTrueOrigFn(MatchViewMod, "buildCar")
            end)
        end

        -- 4. One-time initial discovery if the script was injected while ALREADY inside a live match!
        pcall(function()
            local wsCS = workspace:FindFirstChild("CarSoccer")
            local hasLiveMvFolder = (wsCS and wsCS:FindFirstChild("MatchView") ~= nil)
                or (workspace:FindFirstChild("MatchView") ~= nil)
            if hasLiveMvFolder and type(getgc) == "function" then
                lastGcScanAt = os.clock()
                local okGc, items = pcall(getgc, true)
                if okGc and type(items) == "table" then
                    for _, obj in items do
                        if type(obj) == "table" then
                            local cars = rawget(obj, "cars")
                            local match = rawget(obj, "match")
                            local folder = rawget(obj, "folder")
                            local isMatchView = (MatchViewMod and getmetatable(obj) == MatchViewMod)
                                or (type(cars) == "table" and type(match) == "table" and folder ~= nil and type(obj.rebuildCar) == "function")
                            if isMatchView and folder and folder.Parent ~= nil then
                                activeMatchViews[obj] = true
                            end
                            local view = rawget(obj, "view")
                            local looks = rawget(obj, "looks")
                            local sessIdx = rawget(obj, "index")
                            if type(view) == "table" and type(looks) == "table" and type(sessIdx) == "number" then
                                activeMatchSessions[obj] = true
                                if rawget(view, "folder") and rawget(view, "folder").Parent ~= nil then
                                    activeMatchViews[view] = true
                                end
                            end
                        end
                    end
                end
            end
        end)

        -- Also watch Workspace.CarSoccer for any new "MatchView" folder spawning in the future
        pcall(function()
            local wsCS = workspace:FindFirstChild("CarSoccer")
            if wsCS then
                connect(wsCS.ChildAdded, function(child)
                    if alive and child.Name == "MatchView" and customOverrideActive then
                        task.delay(0.15, function()
                            if alive and customOverrideActive then
                                refreshLiveMatchCars(false, true)
                            end
                        end)
                    end
                end)
            end
        end)

        -- Listen to Loadout.Changed so our drawer labels stay synced when external events happen (without duplicate rebuilds)
        if LoadoutMod.Changed then
            pcall(function()
                connect(LoadoutMod.Changed, function()
                    if applyingSkinNow then return end
                    updateSkinRowLabels()
                end)
            end)
        end

        -- Pre-compute all 7 presets once at startup so pressing C or clicking PRESET is a 0-ms O(1) table lookup!
        local function checkBluePaint(it)
            if not TeamPaintModCache or type(TeamPaintModCache.fits) ~= "function" then
                return it.team == nil or it.team == "blue"
            end
            local ok, fits = pcall(TeamPaintModCache.fits, it.team, "paintBlue")
            return not ok or fits
        end

        local function checkOrangePaint(it)
            if not TeamPaintModCache or type(TeamPaintModCache.fits) ~= "function" then
                return it.team == nil or it.team == "orange"
            end
            local ok, fits = pcall(TeamPaintModCache.fits, it.team, "paintOrange")
            return not ok or fits
        end

        for _, preset in listPresets do
            local sp = preset.spec
            if type(sp) == "table" and not preset.resolved then
                local r = {}
                r.car = findValidItem("car", sp.car, sp.carTokens, listCars) or "car_rally2"
                local carObj = getItemObj(r.car)
                r.carArt = carObj and carObj.art or nil
                r.mods = type(sp.mods) == "table" and table.clone(sp.mods) or nil

                rebuildDecalList(r.car)
                local dummyB = { car = r.car }
                local function checkDecalFit(it)
                    local okFit, fits = pcall(ItemsMod.fits, it, "decal", dummyB)
                    return not okFit or fits
                end
                if sp.decalTokens and sp.decalTokens[1] == "" then
                    r.decal = ""
                else
                    r.decal = findValidItem("decal", sp.decal, sp.decalTokens, listDecals, checkDecalFit) or ""
                end

                r.paintBlue    = findValidItem("paint", sp.paintBlue, sp.paintBlueTokens, listPaints, checkBluePaint)
                r.accentBlue   = findValidItem("paint", sp.accentBlue, sp.accentBlueTokens, listPaints)
                r.paintOrange  = findValidItem("paint", sp.paintOrange, sp.paintOrangeTokens, listPaints, checkOrangePaint)
                r.accentOrange = findValidItem("paint", sp.accentOrange, sp.accentOrangeTokens, listPaints)
                r.finish       = findValidItem("finish", sp.finish, { "anodizado_perola", "anodizado" }, listFinishes)
                r.finishAccent = findValidItem("finish", sp.finishAccent or sp.finish, { "anodizado", "metalico" }, listFinishes)
                r.wheel        = findValidItem("wheel", sp.wheel, sp.wheelTokens, listWheels)
                r.boost        = findValidItem("boost", sp.boost, sp.boostTokens, listBoosts)
                r.trail        = findValidItem("trail", sp.trail, sp.trailTokens, listTrails)
                r.goal         = findValidItem("goal", sp.goal, sp.goalTokens, listGoals)
                r.demo         = findValidItem("demo", sp.demo, sp.demoTokens, listDemos)
                r.ball         = findValidItem("ball", sp.ball, sp.ballTokens, listBalls)
                if sp.hatTokens then
                    if sp.hatTokens[1] == "" then
                        r.hat = ""
                    else
                        r.hat = findValidItem("hat", sp.hat, sp.hatTokens, nil) or ""
                    end
                end
                preset.resolved = r
            end
        end

        -- Load user's saved custom preset from wolvot_saved_preset.json if it exists; otherwise keep their current car as-is!
        local function cleanLoadoutTable(tbl)
            local out = {}
            if type(tbl) == "table" then
                for k, v in tbl do
                    if type(k) == "string" and (type(v) == "string" or type(v) == "number" or type(v) == "boolean") then
                        out[k] = v
                    end
                end
            end
            return out
        end

        -- Sync any existing favorites from ProgressMod.favoriteSet
        if ProgressMod and type(ProgressMod.favoriteSet) == "table" then
            for k, v in ProgressMod.favoriteSet do
                if v == true and type(k) == "string" then
                    savedFavoritesSet[k] = true
                end
            end
        end

        local hasSavedFile = false
        pcall(function()
            if type(isfile) == "function" and type(readfile) == "function" and isfile(SAVED_PRESET_FILE) then
                local rawJson = readfile(SAVED_PRESET_FILE)
                if type(rawJson) == "string" and #rawJson > 2 then
                    local decoded = HttpService:JSONDecode(rawJson)
                    if type(decoded) == "table" then
                        if type(decoded.randomGoal) == "boolean" then
                            randomGoalEnabled = decoded.randomGoal
                        end
                        if type(decoded.favorites) == "table" then
                            for k, v in decoded.favorites do
                                if type(k) == "number" and type(v) == "string" then
                                    savedFavoritesSet[v] = true
                                elseif type(k) == "string" and v == true then
                                    savedFavoritesSet[k] = true
                                end
                            end
                        end
                        if ProgressMod then
                            ProgressMod.favoriteSet = ProgressMod.favoriteSet or {}
                            for favId, isFav in savedFavoritesSet do
                                if isFav then
                                    ProgressMod.favoriteSet[favId] = true
                                end
                            end
                        end
                        local sBlue = cleanLoadoutTable(decoded.blueIds or decoded.ids)
                        local sOrange = cleanLoadoutTable(decoded.orangeIds or decoded.blueIds or decoded.ids)
                        if next(sBlue) ~= nil then
                            if decoded.split ~= true then
                                -- When split is false, sync non-color slots to sOrange so both teams wear the exact same saved car/wheels/decal/goal
                                local mergedOrange = table.clone(sBlue)
                                if type(sOrange.paintOrange) == "string" and sOrange.paintOrange ~= "" then
                                    mergedOrange.paintOrange = sOrange.paintOrange
                                end
                                if type(sOrange.accentOrange) == "string" and sOrange.accentOrange ~= "" then
                                    mergedOrange.accentOrange = sOrange.accentOrange
                                end
                                sOrange = mergedOrange
                            end
                            listPresets[1].savedData = {
                                blueIds = table.clone(sBlue),
                                orangeIds = table.clone(sOrange),
                                split = decoded.split == true,
                            }
                            desiredBlue = table.clone(sBlue)
                            desiredOrange = table.clone(sOrange)
                            desiredSplit = decoded.split == true
                            hasSavedFile = true
                        end
                    end
                end
            end
        end)

        skinReady = true
        if hasSavedFile then
            idxPreset = 1
            customOverrideActive = true
            syncProgressStateLoadout(desiredBlue, desiredOrange, desiredSplit)
            applyingSkinNow = true
            runAsGameScript(function()
                LoadoutMod.preview = nil
                LoadoutMod.previewMods = nil
                LoadoutMod.set(desiredBlue, desiredOrange, desiredSplit)
            end)
            refreshLiveMatchCars(false, true)
            applyingSkinNow = false
        else
            idxPreset = 1
            -- Keep the player's current car active and protected so unlocked items don't get wiped by server resyncs
            customOverrideActive = true
            syncProgressStateLoadout(desiredBlue, desiredOrange, desiredSplit)
        end
        syncIndicesFromCurrentLoadout()
        return true
    end

    saveCurrentPresetToFile = function(silentMode)
        if not initTurboSkinSystem() then return false end
        local curBlue = table.clone(LoadoutMod.blueIds or LoadoutMod.ids or desiredBlue or {})
        local curSplit = LoadoutMod.split == true
        local curOrange
        if curSplit then
            curOrange = table.clone((type(LoadoutMod.idsFor) == "function" and LoadoutMod.idsFor("orange")) or LoadoutMod.orangeIds or desiredOrange or curBlue)
        else
            curOrange = table.clone(curBlue)
        end
        desiredBlue = table.clone(curBlue)
        desiredOrange = table.clone(curOrange)
        desiredSplit = curSplit
        customOverrideActive = true

        listPresets[1].savedData = {
            blueIds = table.clone(curBlue),
            orangeIds = table.clone(curOrange),
            split = curSplit,
        }
        if not silentMode then
            idxPreset = 1
        end

        local favList = {}
        if ProgressMod and type(ProgressMod.favoriteSet) == "table" then
            for k, v in ProgressMod.favoriteSet do
                if v == true and type(k) == "string" then
                    savedFavoritesSet[k] = true
                end
            end
        end
        for k, v in savedFavoritesSet do
            if v == true and type(k) == "string" then
                table.insert(favList, k)
            end
        end
        table.sort(favList)

        local okSave = false
        pcall(function()
            if type(writefile) == "function" then
                local payload = {
                    version = 1,
                    savedAt = os.time(),
                    team = LoadoutMod.team,
                    split = curSplit,
                    randomGoal = randomGoalEnabled,
                    favorites = favList,
                    ids = curBlue,
                    blueIds = curBlue,
                    orangeIds = curOrange,
                }
                writefile(SAVED_PRESET_FILE, HttpService:JSONEncode(payload))
                okSave = true
            end
        end)

        updateSkinRowLabels()
        if not silentMode then
            status((enabled and "ON" or "OFF") .. (okSave and " | Saved custom preset to file!" or " | Saved preset in session!"))
        end
        return okSave
    end

    local function cycleIndex(cur, total, dir)
        if total <= 0 then return 1 end
        return ((cur - 1 + dir) % total) + 1
    end

    local function onPresetStep(dir)
        if not initTurboSkinSystem() then return end
        idxPreset = cycleIndex(idxPreset, #listPresets, dir)
        local preset = listPresets[idxPreset]
        if preset and preset.isSavedCustom and type(preset.savedData) == "table" then
            local sd = preset.savedData
            desiredSplit = sd.split == true
            applyLoadoutInstant(function(b, o)
                table.clear(b)
                table.clear(o)
                for k, v in (sd.blueIds or {}) do b[k] = v end
                for k, v in (sd.orangeIds or sd.blueIds or {}) do o[k] = v end
                rebuildDecalList(b.car)
            end, true)
            syncIndicesFromCurrentLoadout()
            status((enabled and "ON" or "OFF") .. " | Preset [C]: " .. tostring(preset.name))
            return
        end
        if not preset or not preset.resolved then
            customOverrideActive = true
            desiredBlue = table.clone(LoadoutMod.blueIds or LoadoutMod.ids or {})
            desiredOrange = table.clone((type(LoadoutMod.idsFor) == "function" and LoadoutMod.idsFor("orange")) or LoadoutMod.orangeIds or desiredBlue)
            desiredSplit = LoadoutMod.split == true
            updateSkinRowLabels()
            status((enabled and "ON" or "OFF") .. " | Preset [C]: CURRENT GARAGE / LIVE")
            return
        end
        local r = preset.resolved
        applyLoadoutInstant(function(b, o)
            if r.car then b.car, o.car = r.car, r.car end
            rebuildDecalList(b.car)
            if r.paintBlue then b.paintBlue, o.paintBlue = r.paintBlue, r.paintBlue end
            if r.accentBlue then b.accentBlue, o.accentBlue = r.accentBlue, r.accentBlue end
            if r.paintOrange then b.paintOrange, o.paintOrange = r.paintOrange, r.paintOrange end
            if r.accentOrange then b.accentOrange, o.accentOrange = r.accentOrange, r.accentOrange end
            if r.finish then b.finish, o.finish = r.finish, r.finish end
            if r.finishAccent then b.finishAccent, o.finishAccent = r.finishAccent, r.finishAccent end
            if r.decal ~= nil then b.decal, o.decal = r.decal, r.decal end
            if r.wheel then b.wheel, o.wheel = r.wheel, r.wheel end
            if r.boost then b.boost, o.boost = r.boost, r.boost end
            if r.trail then b.trail, o.trail = r.trail, r.trail end
            if r.goal then b.goal, o.goal = r.goal, r.goal end
            if r.demo then b.demo, o.demo = r.demo, r.demo end
            if r.ball then b.ball, o.ball = r.ball, r.ball end
            if r.hat ~= nil then b.hat, o.hat = r.hat, r.hat end
        end, true)
        syncIndicesFromCurrentLoadout()
        status((enabled and "ON" or "OFF") .. " | Preset [C]: " .. tostring(preset.name))
    end

    cyclePresetByKey = function(dir)
        onPresetStep(dir or 1)
    end

    local function bindRowClick(btn, stepFn)
        connect(btn.MouseButton1Click, function() stepFn(1) end)
        connect(btn.MouseButton2Click, function() stepFn(-1) end)
    end

    bindRowClick(rowPreset, onPresetStep)

    bindRowClick(rowCar, function(dir)
        if not initTurboSkinSystem() or #listCars == 0 then return end
        idxCar = cycleIndex(idxCar, #listCars, dir)
        local chosen = listCars[idxCar].id
        rebuildDecalList(chosen)
        applyLoadoutInstant(function(b, o)
            b.car, o.car = chosen, chosen
            local curDecal = b.decal and getItemObj(b.decal)
            if curDecal then
                local okFit, fits = pcall(ItemsMod.fits, curDecal, "decal", b)
                if okFit and not fits then
                    b.decal, o.decal = "", ""
                    idxDecal = 1
                end
            end
        end, true)
    end)

    bindRowClick(rowPaint, function(dir)
        if not initTurboSkinSystem() or #listPaints == 0 then return end
        idxPaint = cycleIndex(idxPaint, #listPaints, dir)
        local chosen = listPaints[idxPaint].id
        applyLoadoutInstant(function(b, o)
            b.paintBlue, o.paintBlue = chosen, chosen
            b.paintOrange, o.paintOrange = chosen, chosen
        end)
    end)

    bindRowClick(rowAccent, function(dir)
        if not initTurboSkinSystem() or #listPaints == 0 then return end
        idxAccent = cycleIndex(idxAccent, #listPaints, dir)
        local chosen = listPaints[idxAccent].id
        applyLoadoutInstant(function(b, o)
            b.accentBlue, o.accentBlue = chosen, chosen
            b.accentOrange, o.accentOrange = chosen, chosen
        end)
    end)

    bindRowClick(rowFinish, function(dir)
        if not initTurboSkinSystem() or #listFinishes == 0 then return end
        idxFinish = cycleIndex(idxFinish, #listFinishes, dir)
        local chosen = listFinishes[idxFinish].id
        applyLoadoutInstant(function(b, o)
            b.finish, o.finish = chosen, chosen
            b.finishAccent, o.finishAccent = chosen, chosen
        end)
    end)

    bindRowClick(rowDecal, function(dir)
        if not initTurboSkinSystem() then return end
        rebuildDecalList(LoadoutMod and LoadoutMod.ids and LoadoutMod.ids.car)
        if #listDecals == 0 then return end
        idxDecal = cycleIndex(idxDecal, #listDecals, dir)
        local chosen = listDecals[idxDecal].id
        applyLoadoutInstant(function(b, o)
            b.decal, o.decal = chosen, chosen
        end)
    end)

    bindRowClick(rowWheel, function(dir)
        if not initTurboSkinSystem() or #listWheels == 0 then return end
        idxWheel = cycleIndex(idxWheel, #listWheels, dir)
        local chosen = listWheels[idxWheel].id
        applyLoadoutInstant(function(b, o)
            b.wheel, o.wheel = chosen, chosen
        end)
    end)

    bindRowClick(rowBoost, function(dir)
        if not initTurboSkinSystem() or #listBoosts == 0 then return end
        idxBoost = cycleIndex(idxBoost, #listBoosts, dir)
        local chosen = listBoosts[idxBoost].id
        applyLoadoutInstant(function(b, o)
            b.boost, o.boost = chosen, chosen
        end)
    end)

    bindRowClick(rowTrail, function(dir)
        if not initTurboSkinSystem() or #listTrails == 0 then return end
        idxTrail = cycleIndex(idxTrail, #listTrails, dir)
        local chosen = listTrails[idxTrail].id
        applyLoadoutInstant(function(b, o)
            b.trail, o.trail = chosen, chosen
        end)
    end)

    bindRowClick(rowGoal, function(dir)
        if not initTurboSkinSystem() or #listGoals == 0 then return end
        idxGoal = cycleIndex(idxGoal, #listGoals, dir)
        local chosen = listGoals[idxGoal].id
        applyLoadoutInstant(function(b, o)
            b.goal, o.goal = chosen, chosen
        end)
    end)

    bindRowClick(rowDemo, function(dir)
        if not initTurboSkinSystem() or #listDemos == 0 then return end
        idxDemo = cycleIndex(idxDemo, #listDemos, dir)
        local chosen = listDemos[idxDemo].id
        applyLoadoutInstant(function(b, o)
            b.demo, o.demo = chosen, chosen
        end)
    end)

    bindRowClick(rowBall, function(dir)
        if not initTurboSkinSystem() or #listBalls == 0 then return end
        idxBall = cycleIndex(idxBall, #listBalls, dir)
        local chosen = listBalls[idxBall].id
        applyLoadoutInstant(function(b, o)
            b.ball, o.ball = chosen, chosen
        end)
    end)

    connect(randomGoalBtn.Activated, function()
        if not initTurboSkinSystem() then return end
        randomGoalEnabled = not randomGoalEnabled
        updateRandomGoalBtnVisual()
        pcall(saveCurrentPresetToFile, true)
        local nHearts = #getHeartedGoalItems()
        status((enabled and "ON" or "OFF") .. string.format(" | Random Goal: %s (%d hearted)", randomGoalEnabled and "ON" or "OFF", nHearts))
    end)

    connect(skinSaveBtn.Activated, function()
        local ok = saveCurrentPresetToFile()
        skinSaveBtn.Text = ok and "PRESET SAVED TO FILE [OK]!" or "PRESET SAVED [SESSION]!"
        skinSaveBtn.BackgroundColor3 = Color3.fromRGB(52, 190, 120)
        skinSaveBtn.TextColor3 = Color3.fromRGB(245, 250, 255)
        task.delay(1.6, function()
            if alive and skinSaveBtn and skinSaveBtn.Parent then
                skinSaveBtn.Text = "SAVE CURRENT PRESET [FILE]"
                skinSaveBtn.BackgroundColor3 = Color3.fromRGB(230, 155, 35)
                skinSaveBtn.TextColor3 = Color3.fromRGB(25, 20, 10)
            end
        end)
    end)

    connect(skinApplyBtn.Activated, function()
        if initTurboSkinSystem() then
            populateAllOwnedSets(true)
            lastAppliedLookByView = setmetatable({}, { __mode = "k" })
            lastAppliedPeerLookByView = setmetatable({}, { __mode = "k" })
            applyLoadoutInstant(function() end, true)
            refreshLiveMatchCars(true, true)
            if type(broadcastMyState) == "function" then
                broadcastMyState(true)
            end
        end
    end)

    connect(skinBtn.Activated, function()
        initTurboSkinSystem()
        populateAllOwnedSets(false)
        skinPanel.Visible = not skinPanel.Visible
        updateSkinRowLabels()
    end)

    ------------------------------------------------------------------
    -- Real-Time P2P Cosmetic Sync Engine (Between Script Users in Same Server)
    ------------------------------------------------------------------
    local httpRequest = (type(request) == "function" and request)
        or (type(http_request) == "function" and http_request)
        or (type(syn) == "table" and type(syn.request) == "function" and syn.request)
        or (type(http) == "table" and type(http.request) == "function" and http.request)
        or (type(fluxus) == "table" and type(fluxus.request) == "function" and fluxus.request)

    local rawJobId = tostring(game.JobId or "studio"):gsub("[^%w]", ""):lower()
    if rawJobId == "" then
        rawJobId = "place" .. tostring(game.PlaceId)
    end
    local SYNC_TOPIC = "ydx_wv3d_" .. rawJobId:sub(1, 24)
    local SYNC_POST_URL = "https://ntfy.sh/" .. SYNC_TOPIC
    local lastSentSig = ""
    local lastSendTime = 0
    local lastPollUnix = 0

    local function buildMyP2PPayload()
        local bIds = table.clone(desiredBlue or (LoadoutMod and (LoadoutMod.blueIds or LoadoutMod.ids)) or {})
        local oIds = table.clone(desiredOrange or (LoadoutMod and (LoadoutMod.orangeIds or LoadoutMod.ids)) or bIds)
        local splitFlag = (desiredSplit ~= nil) and desiredSplit or (LoadoutMod and LoadoutMod.split == true) or false
        local activeGoalStyle = nil
        if randomGoalEnabled then
            if type(lastRolledGoalStyle) ~= "string" or lastRolledGoalStyle == "" then
                rollNextRandomGoalStyle()
            end
            activeGoalStyle = lastRolledGoalStyle
        end
        return {
            uid = LP.UserId,
            name = LP.Name,
            displayName = LP.DisplayName or LP.Name,
            blueIds = bIds,
            orangeIds = oIds,
            split = splitFlag == true,
            goalStyle = activeGoalStyle,
        }
    end

    broadcastMyState = function(force)
        if not alive or not httpRequest or not skinReady then
            return
        end
        local payloadTbl = buildMyP2PPayload()
        local okEnc, encoded = pcall(HttpService.JSONEncode, HttpService, payloadTbl)
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
                    ["Title"] = "ydx-wv3d-sync",
                },
                Body = encoded,
            })
        end)
    end

    local function handleIncomingPeerPacket(msgJson)
        if type(msgJson) ~= "string" or msgJson == "" then
            return
        end
        local ok, data = pcall(HttpService.JSONDecode, HttpService, msgJson)
        if not ok or type(data) ~= "table" then
            return
        end
        local uidNum = tonumber(data.uid)
        if not uidNum or uidNum == LP.UserId then
            return
        end
        local uidKey = tostring(uidNum)
        local bIds = type(data.blueIds) == "table" and data.blueIds or {}
        local oIds = type(data.orangeIds) == "table" and data.orangeIds or bIds
        peerStates[uidKey] = {
            uid = uidNum,
            name = type(data.name) == "string" and data.name or "",
            displayName = type(data.displayName) == "string" and data.displayName or (type(data.name) == "string" and data.name or ""),
            blueIds = bIds,
            orangeIds = oIds,
            split = data.split == true,
            goalStyle = type(data.goalStyle) == "string" and data.goalStyle or nil,
            ts = os.clock(),
        }
        if skinReady then
            refreshLiveMatchCars(false, false)
        end
    end

    local function pollPeersOnce()
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
            local okLine, envPkt = pcall(HttpService.JSONDecode, HttpService, line)
            if okLine and type(envPkt) == "table" then
                if type(envPkt.time) == "number" and envPkt.time >= lastPollUnix then
                    lastPollUnix = envPkt.time
                end
                if envPkt.event == "message" and type(envPkt.message) == "string" then
                    handleIncomingPeerPacket(envPkt.message)
                end
            end
        end
    end

    connect(Players.PlayerAdded, function()
        task.delay(2, function()
            if alive and type(broadcastMyState) == "function" then
                broadcastMyState(true)
            end
        end)
    end)

    task.spawn(function()
        for _ = 1, 15 do
            if not alive then return end
            if initTurboSkinSystem() then break end
            task.wait(1)
        end
        if not alive then return end
        broadcastMyState(true)
        task.wait(0.4)
        pollPeersOnce()
        while alive do
            task.wait(1.6)
            if not alive then break end
            pollPeersOnce()
            if os.clock() - lastSendTime > 20 then
                broadcastMyState(true)
            end
        end
    end)
end

connect(UIS.InputBegan, function(input, gpe)
    if UIS:GetFocusedTextBox() then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local code = input.KeyCode
    if code == Enum.KeyCode.Unknown then return end
    -- Right Ctrl: hide / show the whole interface.
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
        if type(cyclePresetByKey) == "function" then
            local shiftHeld = UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.RightShift)
            cyclePresetByKey(shiftHeld and -1 or 1)
        end
        return
    end
    if not gpe and code == bindKey then flipToggle() end
end)

local uiClock = 0
connect(RunService.Heartbeat, function(dt)
    uiClock += dt
    if uiClock >= .2 then
        uiClock = 0
        if label.Text ~= message then
            label.Text = message
            local color = Color3.fromRGB(150, 162, 195)
            if message:find("rror") or message:find("ailed") then
                color = Color3.fromRGB(255, 110, 110)
            elseif message:sub(1, 2) == "ON" then
                color = Color3.fromRGB(110, 230, 160)
            end
            tween(label, { TextColor3 = color }, .2)
        end
    end
end)

----------------------------------------------------------------------
-- Main loop
----------------------------------------------------------------------
task.spawn(function()
    while alive do
        local connectionStart = #connections
        local ok, err = xpcall(function()
            assert(type(vector) == "table" and type(vector.create) == "function", "This runner needs Luau vector support")
            assert(type(buffer) == "table" and type(buffer.readf32) == "function", "This runner needs Luau buffer support")

            local Policy = (function()
                local Policy = {}
                Policy.__index = Policy
                local create, zero = vector.create, vector.zero
                local specs = {
                    { 109, 1024 }, { 1024, 1024 }, { 1024, 1024 }, { 1024, 1024 }, { 1024, 1024 },
                    { 1024, 1024 }, { 1024, 1024 }, { 1024, 1024 }, { 1024, 90 },
                }
                Policy.bytes = 30273896
                Policy.actions = {}

                for _, throttle in { -1, 0, 1 } do
                    for _, steer in { -1, 0, 1 } do
                        for _, boost in { 0, 1 } do
                            for _, brake in { 0, 1 } do
                                if boost == 0 or throttle == 1 then
                                    table.insert(Policy.actions, { throttle, steer, 0, steer, 0, 0, boost, brake })
                                end
                            end
                        end
                    end
                end
                for _, pitch in { -1, 0, 1 } do
                    for _, yaw in { -1, 0, 1 } do
                        for _, roll in { -1, 0, 1 } do
                            for _, jump in { 0, 1 } do
                                for _, boost in { 0, 1 } do
                                    if not (jump == 1 and yaw ~= 0) and not (pitch == 0 and roll == 0 and jump == 0) then
                                        table.insert(Policy.actions, {
                                            boost, yaw, pitch, yaw, roll, jump, boost,
                                            (jump == 1 and (pitch ~= 0 or yaw ~= 0 or roll ~= 0)) and 1 or 0,
                                        })
                                    end
                                end
                            end
                        end
                    end
                end
                assert(#Policy.actions == 90, "Invalid action table")

                function Policy.decode(chunks, checkpoint, fastDecoder)
                    local output = buffer.create(Policy.bytes)
                    local offset = 0
                    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
                    local map = table.create(256, 0)
                    for i = 1, 64 do map[string.byte(alphabet, i)] = i - 1 end

                    for index, chunk in chunks do
                        local encoded = chunk.encoded
                        assert(type(encoded) == "string" and #encoded % 4 == 0, "Invalid model chunk")
                        local decoded
                        if fastDecoder then
                            local good, value = pcall(fastDecoder, encoded)
                            if good and type(value) == "string" and #value == chunk.bytes then decoded = value end
                        end
                        if decoded then
                            buffer.writestring(output, offset, decoded)
                            offset += #decoded
                        else
                            local finish = offset + chunk.bytes
                            for i = 1, #encoded, 4 do
                                local a, b, c, d = string.byte(encoded, i, i + 3)
                                local n = map[a] * 262144 + map[b] * 4096 + map[c] * 64 + map[d]
                                if offset < finish then
                                    buffer.writeu8(output, offset, bit32.rshift(n, 16))
                                    offset += 1
                                end
                                if offset < finish then
                                    buffer.writeu8(output, offset, bit32.band(bit32.rshift(n, 8), 255))
                                    offset += 1
                                end
                                if offset < finish then
                                    buffer.writeu8(output, offset, bit32.band(n, 255))
                                    offset += 1
                                end
                                if i % 16384 == 1 and checkpoint then
                                    checkpoint("Decoding Wolvot weights", offset / Policy.bytes)
                                end
                            end
                            assert(offset == finish, "Incomplete model chunk")
                        end
                        chunk.encoded = nil
                        if checkpoint then checkpoint("Decoded chunk " .. index .. "/" .. #chunks, offset / Policy.bytes) end
                    end
                    assert(offset == Policy.bytes, "Incomplete Wolvot model")
                    return output
                end

                function Policy.load(bytes, checkpoint)
                    assert(buffer.len(bytes) == Policy.bytes, "Model size mismatch")
                    local layers, offset = {}, 0
                    local read = buffer.readf32
                    for index, spec in specs do
                        local inputs, outputs = spec[1], spec[2]
                        local groups = math.ceil(inputs / 3)
                        local layer = {
                            inputs = inputs,
                            outputs = outputs,
                            groups = groups,
                            w = table.create(outputs * groups),
                            b = table.create(outputs),
                            packed = table.create(groups),
                            x = table.create(outputs, 0),
                        }
                        for row = 0, outputs - 1 do
                            local base = offset + row * inputs * 4
                            for group = 0, groups - 1 do
                                local col = group * 3
                                layer.w[row * groups + group + 1] = create(
                                    read(bytes, base + col * 4),
                                    col + 1 < inputs and read(bytes, base + (col + 1) * 4) or 0,
                                    col + 2 < inputs and read(bytes, base + (col + 2) * 4) or 0
                                )
                            end
                            if row % 16 == 0 and checkpoint then
                                checkpoint("Preparing layer " .. index .. "/9", (index - 1 + row / outputs) / 9)
                            end
                        end
                        offset += inputs * outputs * 4
                        for i = 1, outputs do
                            layer.b[i] = read(bytes, offset)
                            offset += 4
                        end
                        if index < #specs then
                            layer.g, layer.n = table.create(outputs), table.create(outputs)
                            for i = 1, outputs do
                                layer.g[i] = read(bytes, offset)
                                offset += 4
                            end
                            for i = 1, outputs do
                                layer.n[i] = read(bytes, offset)
                                offset += 4
                            end
                        end
                        layers[index] = layer
                    end
                    assert(offset == Policy.bytes, "Model layout mismatch")
                    return setmetatable({ layers = layers }, Policy)
                end

                function Policy:forward(observation, checkpoint)
                    assert(#observation == 109, "Expected 109 observations")
                    local x = observation
                    for _, layer in self.layers do
                        local packed, weights, groups, y = layer.packed, layer.w, layer.groups, layer.x
                        for j = 1, groups do
                            local col = (j - 1) * 3
                            packed[j] = create(
                                x[col + 1],
                                col + 2 <= layer.inputs and x[col + 2] or 0,
                                col + 3 <= layer.inputs and x[col + 3] or 0
                            )
                        end
                        for row = 0, layer.outputs - 1 do
                            local acc = zero
                            local base = row * groups
                            for j = 1, groups do acc += weights[base + j] * packed[j] end
                            y[row + 1] = acc.x + acc.y + acc.z + layer.b[row + 1]
                            if row % 16 == 15 and checkpoint then checkpoint() end
                        end
                        if layer.g then
                            local mean = 0
                            for i = 1, layer.outputs do mean += y[i] end
                            mean /= layer.outputs
                            local variance = 0
                            for i = 1, layer.outputs do
                                local d = y[i] - mean
                                variance += d * d
                            end
                            local inv = 1 / math.sqrt(variance / layer.outputs + 1e-5)
                            for i = 1, layer.outputs do
                                y[i] = math.max(0, (y[i] - mean) * inv * layer.g[i] + layer.n[i])
                            end
                        end
                        x = y
                        if checkpoint then checkpoint() end
                    end
                    return x
                end

                function Policy.select(logits)
                    local best, value = 1, -math.huge
                    for i = 1, 90 do
                        local v = logits[i]
                        assert(v == v and math.abs(v) < math.huge, "Non-finite Wolvot output")
                        if v > value then best, value = i, v end
                    end
                    return Policy.actions[best]
                end

                return Policy
            end)()

            local Controller = (function()
                -- Scheduling only. Never modifies, replaces, or reselects a policy action.
                local Controller = {}
                function Controller.budget(dt)
                    -- Match v0.1 on fast devices. Allow slightly longer slices at low FPS.
                    if dt <= 1 / 60 then return math.clamp(dt * .42, .0025, .008) end
                    return math.clamp(dt * .25, .007, .010)
                end
                return Controller
            end)()

            local Observation = (function()
                local Observation = {}
                Observation.locations = {
                    { 0, -4240, 70 }, { -1792, -4184, 70 }, { 1792, -4184, 70 }, { -3072, -4096, 73 },
                    { 3072, -4096, 73 }, { -940, -3308, 70 }, { 940, -3308, 70 }, { 0, -2816, 70 },
                    { -3584, -2484, 70 }, { 3584, -2484, 70 }, { -1788, -2300, 70 }, { 1788, -2300, 70 },
                    { -2048, -1036, 70 }, { 0, -1024, 70 }, { 2048, -1036, 70 }, { -3584, 0, 73 },
                    { -1024, 0, 70 }, { 1024, 0, 70 }, { 3584, 0, 73 }, { -2048, 1036, 70 },
                    { 0, 1024, 70 }, { 2048, 1036, 70 }, { -1788, 2300, 70 }, { 1788, 2300, 70 },
                    { -3584, 2484, 70 }, { 3584, 2484, 70 }, { 0, 2816, 70 }, { -940, 3310, 70 },
                    { 940, 3308, 70 }, { -3072, 4096, 73 }, { 3072, 4096, 73 }, { -1792, 4184, 70 },
                    { 1792, 4184, 70 }, { 0, 4240, 70 },
                }

                local function append(o, v, scale, invert)
                    local sign = invert and -scale or scale
                    o[#o + 1] = v.x * sign
                    o[#o + 1] = v.y * sign
                    o[#o + 1] = v.z * scale
                end

                local function localVec(o, v, rotation, scale)
                    o[#o + 1] = vector.dot(v, rotation.forward) * scale
                    o[#o + 1] = vector.dot(v, rotation.right) * scale
                    o[#o + 1] = vector.dot(v, rotation.up) * scale
                end

                local air = { 0, 0 }
                local lastObsTick

                function Observation.reset()
                    air = { 0, 0 }
                    lastObsTick = nil
                end

                function Observation.track(own, opponent, tick)
                    local elapsed = lastObsTick and math.max(0, tick - lastObsTick) or 0
                    if lastObsTick and tick < lastObsTick then air = { 0, 0 } end
                    lastObsTick = tick
                    for i, st in { own, opponent } do
                        air[i] = st and not st.isOnGround and (air[i] + elapsed) or 0
                    end
                end

                local function player(o, st, ball, invert, airborneTicks)
                    append(o, st.pos, 1 / 5000, invert)
                    append(o, st.rot.forward, 1, invert)
                    append(o, st.rot.up, 1, invert)
                    append(o, st.vel, 1 / 2300, invert)
                    append(o, st.angVel, 1 / 3, invert)
                    localVec(o, st.angVel, st.rot, 1 / 3)
                    localVec(o, ball.pos - st.pos, st.rot, 1 / 5000)
                    localVec(o, ball.vel - st.vel, st.rot, 1 / 2300)
                    o[#o + 1] = st.boost / 100
                    o[#o + 1] = (st.isOnGround or airborneTicks <= 6) and 1 or 0
                    o[#o + 1] = (not (st.hasDoubleJumped or st.hasFlipped) or not st.hasJumped) and 1 or 0
                    o[#o + 1] = st.isDemoed and 1 or 0
                    o[#o + 1] = st.hasJumped and 1 or 0
                end

                function Observation.mapPads(pads)
                    assert(#pads == 34, "Expected the standard 34 boost pads")
                    local result, used = {}, {}
                    for i, target in Observation.locations do
                        local chosen, best
                        for _, pad in pads do
                            if not used[pad] and pad.pos then
                                local p = pad.pos
                                local d = (p.x - target[1]) ^ 2 + (p.y - target[2]) ^ 2 + (p.z - target[3]) ^ 2
                                if not best or d < best then chosen, best = pad, d end
                            end
                        end
                        assert(chosen and best < 256, "Boost-pad coordinates do not match training")
                        result[i] = chosen
                        used[chosen] = true
                    end
                    return result
                end

                function Observation.build(ball, own, opponent, pads, prev, team)
                    local o = {}
                    local invert = team == 1
                    append(o, ball.pos, 1 / 5000, invert)
                    append(o, ball.vel, 1 / 2300, invert)
                    append(o, ball.angVel, 1 / 3, invert)
                    for i = 1, 8 do o[#o + 1] = prev[i] end
                    for i = 1, 34 do
                        local pad = pads[invert and 35 - i or i]
                        assert(type(pad.isActive) == "boolean", "Boost-pad active flag unavailable")
                        assert(pad.isActive or type(pad.cooldown) == "number", "Boost cooldown unavailable")
                        o[#o + 1] = pad.isActive and 1 or 1 / (1 + math.max(0, pad.cooldown))
                    end
                    player(o, own, ball, invert, air[1])
                    if opponent then
                        player(o, opponent, ball, invert, air[2])
                    else
                        for _ = 1, 29 do o[#o + 1] = 0 end
                    end
                    assert(#o == 109, "Invalid observation layout")
                    for _, v in o do
                        assert(type(v) == "number" and v == v and math.abs(v) < math.huge, "Non-finite observation")
                    end
                    return o
                end

                return Observation
            end)()

            local encoded = {
                { url = "https://vanta-lua.brahlamapringles.workers.dev/wolvot-free/66b5599996325f73-01.b64", bytes = 8388608, encoded_bytes = 11184812, sha256 = "e321e34cd37b3d372c55969539960a66e80afe41852b142e55a3e87d5c740673" },
                { url = "https://vanta-lua.brahlamapringles.workers.dev/wolvot-free/66b5599996325f73-02.b64", bytes = 8388608, encoded_bytes = 11184812, sha256 = "50a1bee396bbb8b8ea8de1e1412144275c6d07ba8e446ba3b08b1c990090a6e7" },
                { url = "https://vanta-lua.brahlamapringles.workers.dev/wolvot-free/66b5599996325f73-03.b64", bytes = 8388608, encoded_bytes = 11184812, sha256 = "2186e0232f00002a06a96923f35946532c4ce89cee35d73d4cbcce6da4e48fc7" },
                { url = "https://vanta-lua.brahlamapringles.workers.dev/wolvot-free/66b5599996325f73-04.b64", bytes = 5108072, encoded_bytes = 6810764, sha256 = "1db22e7663a1eaf0048b59f40128f2bdd958fb13a5f7bc7d6395ae176cd3da3f" },
            }

            -- Local model cache (needs executor file functions).
            local CACHE_DIR = "WolvotFree"
            local CACHE_FILE = CACHE_DIR .. "/model_66b5599996325f73.bin"
            local canCache = type(isfile) == "function" and type(readfile) == "function" and type(writefile) == "function"

            local function readCache()
                if not canCache then return nil end
                local good, data = pcall(function()
                    if isfile(CACHE_FILE) then return readfile(CACHE_FILE) end
                    return nil
                end)
                if good and type(data) == "string" and #data == Policy.bytes then
                    return buffer.fromstring(data)
                end
                return nil
            end

            local function writeCache(bytes)
                if not canCache then return end
                pcall(function()
                    if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder(CACHE_DIR) then
                        makefolder(CACHE_DIR)
                    end
                    writefile(CACHE_FILE, buffer.tostring(bytes))
                end)
            end

            status("Checking local model cache")
            local bytes = readCache()
            local fromCache = bytes ~= nil

            if not fromCache then
                for i, chunk in encoded do
                    status("Downloading Wolvot model " .. i .. "/" .. #encoded)
                    local body = game:HttpGet(chunk.url)
                    assert(alive, "Unloaded")
                    assert(type(body) == "string" and #body == chunk.encoded_bytes, "Incomplete Wolvot model download")
                    chunk.encoded = body
                    task.wait()
                end
            end

            local loadSlice = os.clock()
            local function loading(stage, fraction)
                if not alive then error("Unloaded", 0) end
                if os.clock() - loadSlice >= .005 then
                    status(stage .. " | " .. math.floor(fraction * 100) .. "%")
                    task.wait()
                    loadSlice = os.clock()
                end
            end

            local fastDecoder = type(crypt) == "table" and crypt.base64decode or nil
            if not fromCache then
                bytes = Policy.decode(encoded, loading, fastDecoder)
                status("Saving model to local cache")
                task.wait()
                writeCache(bytes)
            end
            encoded = nil
            local network = Policy.load(bytes, loading)
            bytes = nil
            ready = true
            status(enabled and "ON | Ready | Finding match" or "OFF | Ready | Waiting for match")

            local function warnOnce(value)
                local now = os.clock()
                if now - errorAt > 3 then
                    errorAt = now
                    warn("[Wolvot Free] " .. tostring(value))
                end
            end

            local function install(object, key, factory)
                local original = object[key]
                local restore = rawget(object, key)
                assert(type(original) == "function", "Missing " .. key .. " interface")
                local wrapper = factory(original)
                object[key] = wrapper
                table.insert(hooked, { object = object, key = key, wrapper = wrapper, original = original, restore = restore })
            end

            ------------------------------------------------------------------
            -- Turbo Soccer adapter
            ------------------------------------------------------------------
            local function attachTurbo(input, prediction, const)
                local function vec(value)
                    if typeof(value) == "vector" then return value end
                    return vector.create(value.X, value.Y, value.Z)
                end

                local proxy, sourceMatch, padSourceTurbo, livePredictor
                local probeAt, liveAdvancedAt = 0, 0
                local seen = setmetatable({}, { __mode = "k" })
                local bound = setmetatable({}, { __mode = "k" })
                local cachedTick, cachedPrint, cachedIndex
                local numericKeys = {}

                local function discover()
                    if type(getgc) ~= "function" then return end
                    for _, item in getgc(true) do
                        if type(item) == "table" and rawget(item, 1) == "boost" and rawget(item, 7) == "supersonicTime" and #item == 13 then
                            numericKeys[#numericKeys + 1] = item
                        end
                    end
                end
                discover()

                local function timer(car, index, name)
                    if type(car[name]) == "number" then return car[name] end
                    for _, keys in numericKeys do
                        if type(car[keys[2]]) == "number" and type(car[keys[3]]) == "number" and type(car[keys[4]]) == "number" then
                            return car[keys[index]]
                        end
                    end
                    return nil
                end

                local function refresh(self: any, force: boolean?)
                    local match: any = self.match
                    local snap: any = match and self.prints and self.prints[match.tick]
                    if not snap then
                        P = nil
                        matchWaiting = "Waiting for Turbo Soccer simulation"
                        return
                    end
                    -- _remember refreshes corrected data immediately. A following step
                    -- with the same snapshot can reuse it without rebuilding every table.
                    if not force and match == sourceMatch and match.tick == cachedTick
                        and snap == cachedPrint and self.localIndex == cachedIndex then
                        P = proxy
                        return
                    end
                    if match ~= sourceMatch then
                        reset()
                        sourceMatch = match
                        padSourceTurbo = nil
                        local arena: any = { cars = {}, boostPads = {}, phase = snap[1], ball = {} }
                        function arena:IsBallScored() return self.phase ~= "play" end
                        function arena.ball:GetState() return self.state end
                        proxy = { arena = arena, tick = match.tick, localCarId = self.localIndex }
                        function proxy:LocalCar() return self.localCarId and self.arena.cars[self.localCarId] end
                    end
                    proxy.tick = match.tick
                    proxy.localCarId = self.localIndex
                    local arena = proxy.arena
                    arena.phase = snap[1]
                    arena.ball.state = { pos = vec(snap[6]), vel = vec(snap[7]), angVel = vec(snap[8]) }

                    for i, record in match.cars do
                        local at = 9 + (i - 1) * 7
                        local car = arena.cars[i]
                        if not car or car.source ~= record.car then
                            car = { id = i, source = record.car }
                            function car:GetState() return self.state end
                            arena.cars[i] = car
                        end
                        car.team = record.team
                        local flags = snap[at + 6]
                        assert(type(flags) == "number", "Incomplete Turbo Soccer car snapshot")
                        local function flag(bit) return bit32.band(flags, bit) ~= 0 end
                        local forward, up = vec(snap[at + 3]), vec(snap[at + 4])
                        car.state = {
                            pos = vec(snap[at]),
                            vel = vec(snap[at + 1]),
                            angVel = vec(snap[at + 2]),
                            rot = { forward = forward, up = up, right = vector.cross(up, forward) },
                            boost = snap[at + 5],
                            isOnGround = flag(1),
                            hasJumped = flag(2),
                            hasDoubleJumped = flag(4),
                            hasFlipped = flag(8),
                            isFlipping = flag(16),
                            isJumping = flag(32),
                            isDemoed = flag(2048),
                            airTimeSinceJump = timer(record.car, 4, "airTimeSinceJump"),
                            flipTime = timer(record.car, 3, "flipTime"),
                        }
                    end
                    for i = #arena.cars, #match.cars + 1, -1 do arena.cars[i] = nil end

                    local rawPads = assert(match.pads and match.pads.pads, "Missing Turbo Soccer boost pads")
                    if padSourceTurbo ~= rawPads then
                        arena.boostPads = {}
                        padSourceTurbo = rawPads
                        local index = 0
                        for _, positions in { const.PADS_BIG, const.PADS_SMALL } do
                            for _, position in positions do
                                index += 1
                                arena.boostPads[index] = { pos = vec(position) }
                            end
                        end
                        assert(index == 34, "Unsupported Turbo Soccer boost-pad layout")
                    end
                    for i, pad in arena.boostPads do
                        local raw = assert(rawPads[i], "Missing Turbo Soccer boost pad")
                        pad.isActive = raw.isActive
                        pad.cooldown = raw.cooldown or (raw.ticks and raw.ticks * (const.TICK_TIME or 1 / 120))
                        assert(type(pad.cooldown) == "number", "Missing Turbo Soccer boost-pad timer")
                    end
                    cachedTick, cachedPrint, cachedIndex = match.tick, snap, self.localIndex
                    P = proxy
                    matchWaiting = proxy.localCarId and "Waiting for live match" or "Waiting for your car"
                    _lastTick = proxy.tick
                end

                local zapStage, zapSteps, zapCooldown, zapTick, zapGen, zapCar, wasGround, prevVelZ, zapOut = 0, 0, 0, nil, nil, nil, nil, 0, nil

                local function selectControls(controls)
                    local own = P and P:LocalCar()
                    if enabled and ready and not blocked and action and own and controls
                        and own == carIdentity and P == identity and P.arena == arenaIdentity
                        and not own.state.isDemoed and not P.arena:IsBallScored() then
                        local st, tick = own.state, P.tick
                        if zapGen ~= generation or zapCar ~= own or (zapTick and (tick < zapTick or tick - zapTick > 4)) then
                            zapStage, zapSteps, zapCooldown, zapTick, wasGround, prevVelZ, zapOut = 0, 0, 0, nil, nil, 0, nil
                            zapGen, zapCar = generation, own
                        end
                        if action[2] ~= 0 or action[8] ~= 0 then
                            zapStage, zapSteps, zapOut = 0, 0, nil
                        end
                        if tick ~= zapTick then
                            if zapCooldown > 0 then zapCooldown -= 1 end
                            local vx, vy = st.vel.x, st.vel.y
                            local fx, fy = st.rot.forward.x, st.rot.forward.y
                            local h2, f2 = vx * vx + vy * vy, fx * fx + fy * fy
                            local dotp = vx * fx + vy * fy
                            local forwardOk = h2 > 90000 and f2 > .25 and dotp > 0 and dotp * dotp > .72 * h2 * f2
                            zapOut = nil
                            if zapStage > 0 then
                                zapSteps += 1
                                if not forwardOk or st.rot.up.z < .65 or st.hasFlipped or st.hasDoubleJumped or st.isFlipping or zapSteps > 6 then
                                    zapStage, zapSteps = 0, 0
                                elseif zapStage == 1 then
                                    if st.isOnGround and zapSteps <= 1 and previous[6] > 0 then
                                        zapOut = { 1, 0, -1, 0, 0, 1, action[7], 0 }
                                    else
                                        zapStage = 2
                                        zapOut = { 1, 0, -1, 0, 0, 0, action[7], 0 }
                                    end
                                elseif zapStage == 2 then
                                    if not st.isOnGround and previous[6] == 0 then
                                        zapStage, zapSteps, zapCooldown = 0, 0, 18
                                        zapOut = { 1, 0, -1, 0, 0, 1, action[7], 0 }
                                    elseif zapSteps <= 3 then
                                        zapOut = { 1, 0, -1, 0, 0, 0, action[7], 0 }
                                    else
                                        zapStage, zapSteps = 0, 0
                                    end
                                end
                            elseif zapCooldown == 0 and st.isOnGround and not st.isFlipping and st.rot.up.z > .85
                                and previous[6] == 0 and action[2] == 0 and action[8] == 0 and forwardOk
                                and ((wasGround == false and (prevVelZ < -50 or st.vel.z < -15)) or (st.vel.z < -55 and st.rot.up.z > .88)) then
                                zapStage, zapSteps = 1, 0
                                zapOut = { 1, 0, -1, 0, 0, 1, action[7], 0 }
                            end
                            local picked = zapOut or action
                            for i = 1, 8 do previous[i] = picked[i] end
                            zapTick, wasGround, prevVelZ = tick, st.isOnGround, st.vel.z
                        end
                        local chosen = (action[2] == 0 and action[8] == 0 and zapOut) or action
                        if chosen == action and zapOut then
                            for i = 1, 8 do previous[i] = action[i] end
                            zapOut = nil
                        end
                        local result = table.clone(controls)
                        result.throttle, result.steer, result.pitch, result.yaw, result.roll = chosen[1], chosen[2], chosen[3], chosen[4], chosen[5]
                        result.jump, result.boost, result.handbrake = chosen[6] > 0, chosen[7] > 0, chosen[8] > 0
                        return result
                    end
                    zapStage, zapSteps, zapOut, wasGround = 0, 0, nil, nil
                    return controls
                end

                local function refreshLive(self, force)
                    if livePredictor ~= self or not proxy or proxy.tick ~= (self.match and self.match.tick) then
                        liveAdvancedAt = os.clock()
                    end
                    livePredictor = self
                    return refresh(self, force)
                end

                local function dataError(why)
                    reset()
                    P = nil
                    matchWaiting = "Turbo data | " .. tostring(why):sub(1, 100)
                    warnOnce(why)
                end

                local function wrapStep(original)
                    return function(self, controls, ...)
                        if alive and type(self.localIndex) == "number" then
                            local good, why = pcall(refreshLive, self)
                            if good then controls = selectControls(controls) else dataError(why) end
                        end
                        return original(self, controls, ...)
                    end
                end

                local function wrapRemember(original)
                    return function(self, ...)
                        local result = table.pack(original(self, ...))
                        if alive and self.localIndex then
                            local good, why = pcall(refreshLive, self, true)
                            if not good then dataError(why) end
                        end
                        return table.unpack(result, 1, result.n)
                    end
                end

                local function bindInstance(instance)
                    if bound[instance] then return end
                    bound[instance] = true
                    -- A live object can use a different loaded copy of Prediction, or
                    -- hide its metatable. Hook that object instead of requiring identity.
                    if type(instance.step) == "function" and instance.step ~= prediction.step then install(instance, "step", wrapStep) end
                    if type(instance._remember) == "function" and instance._remember ~= prediction._remember then install(instance, "_remember", wrapRemember) end
                end

                local function reacquire()
                    if type(getgc) ~= "function" or os.clock() < probeAt or trainActive then return end
                    probeAt = os.clock() + 4
                    local best, bestScore
                    local got, items = pcall(getgc, true)
                    if not got or type(items) ~= "table" then return end
                    for _, candidate in items do
                        if type(candidate) == "table" then
                            local match, prints, index = rawget(candidate, "match"), rawget(candidate, "prints"), rawget(candidate, "localIndex")
                            if type(match) == "table" and type(prints) == "table" and type(index) == "number"
                                and type(match.tick) == "number" and type(match.cars) == "table" and match.cars[index]
                                and type(prints[match.tick]) == "table" then
                                local changed = seen[candidate] ~= nil and seen[candidate] ~= match.tick
                                seen[candidate] = match.tick
                                local phase = prints[match.tick][1]
                                local score = (phase == "play" and 10000 or 0) + (changed and 100000 or 0) + (candidate == livePredictor and 100 or 0)
                                if not bestScore or score > bestScore then best, bestScore = candidate, score end
                            end
                        end
                    end
                    if best then
                        local good = pcall(function()
                            bindInstance(best)
                            refreshLive(best, true)
                        end)
                        if not good then P = nil end
                    end
                end

                refreshGame = function()
                    if livePredictor then
                        local good = pcall(refreshLive, livePredictor)
                        if not good then P = nil end
                    end
                    if not P or not livePredictor or os.clock() - liveAdvancedAt > 2 then reacquire() end
                end

                install(input, "read", function(original)
                    return function(controls, camera, allowed, ...)
                        if alive then
                            local nextBlocked = allowed ~= true
                            if nextBlocked ~= blocked then reset() end
                            blocked = nextBlocked
                        end
                        local result = table.pack(original(controls, camera, allowed, ...))
                        if alive and controls and allowed == true then
                            -- Also support clients that cached their step function
                            -- before this script was loaded. Keep input's return values.
                            if refreshGame then pcall(refreshGame) end
                            local selected = (trainActive and enabled and action) and trainControls(controls) or selectControls(controls)
                            if selected ~= controls then
                                for key, value in selected do controls[key] = value end
                            end
                        end
                        return table.unpack(result, 1, result.n)
                    end
                end)
                install(prediction, "step", wrapStep)
                if type(prediction._remember) == "function" then install(prediction, "_remember", wrapRemember) end
                if type(prediction.reset) == "function" then
                    install(prediction, "reset", function(original)
                        return function(self, ...)
                            if alive then
                                reset()
                                P = nil
                                sourceMatch = nil
                                identity = nil
                            end
                            return original(self, ...)
                        end
                    end)
                end
                Input = input
                matchWaiting = "Waiting for Turbo Soccer simulation"
                reacquire()
                status(enabled and "ON | Waiting for car" or "OFF | Ready | Turbo Soccer")
            end

            ------------------------------------------------------------------
            -- Blox League adapter
            ------------------------------------------------------------------
            local function attach(input, prediction)
                Input = input
                install(prediction, "Step", function(original)
                    return function(self, ...)
                        if alive then
                            P = self
                            _lastTick = self.tick or 0
                        end
                        return original(self, ...)
                    end
                end)
                if type(prediction.Clear) == "function" then
                    install(prediction, "Clear", function(original)
                        return function(self, ...)
                            if alive and self == P then
                                reset()
                                P = nil
                                identity = nil
                            end
                            return original(self, ...)
                        end
                    end)
                end
                if type(input.Gate) == "function" then
                    install(input, "Gate", function(original)
                        return function(value, ...)
                            if alive then
                                local nextBlocked = value == true
                                if nextBlocked ~= blocked then reset() end
                                blocked = nextBlocked
                            end
                            return original(value, ...)
                        end
                    end)
                end
                install(input, "Read", function(original)
                    return function(...)
                        local controls = original(...)
                        if not alive or not enabled or not ready or blocked or not P or not P.localCarId then return controls end
                        local own = P:LocalCar()
                        if not own or own ~= carIdentity or P ~= identity or P.arena ~= arenaIdentity or (own.state and own.state.isDemoed) then
                            return controls
                        end
                        local selected = action
                        if not selected then return controls end
                        local result = table.clone(controls)
                        result.throttle, result.steer, result.pitch, result.yaw, result.roll = selected[1], selected[2], selected[3], selected[4], selected[5]
                        -- Keep each policy action's jump duration; never add alternating jump pulses.
                        result.jump, result.boost, result.handbrake = selected[6] > 0, selected[7] > 0, selected[8] > 0
                        for i = 1, 8 do previous[i] = selected[i] end
                        return result
                    end
                end)
                if type(getgc) == "function" then
                    pcall(function()
                        for _, item in getgc(true) do
                            if type(item) == "table" and rawget(item, "shadow") and rawget(item, "carsById") and rawget(item, "arena") then
                                local mt = getmetatable(item)
                                if mt == prediction or (type(mt) == "table" and mt.__index == prediction) then
                                    P = item
                                    _lastTick = item.tick
                                    break
                                end
                            end
                        end
                    end)
                end
                status(enabled and "ON | Waiting for car" or "OFF | Ready | Blox League")
            end

            ------------------------------------------------------------------
            -- Interface acquisition
            ------------------------------------------------------------------
            local acquisitionAt, acquiring = 0, false

            local function modules(holder, clientOverride)
                local shared = holder and holder:FindFirstChild("Shared")
                local client = clientOverride or (holder and holder:FindFirstChild("Client"))
                local net = shared and shared:FindFirstChild("Net")
                local sim = shared and shared:FindFirstChild("Sim")
                local im = client and client:FindFirstChild("Input")
                local pm = net and net:FindFirstChild("Prediction")
                local cm = sim and sim:FindFirstChild("Const")
                if im and pm and cm then return im, pm, cm end
                return nil, nil, nil
            end

            local function acquire()
                if Input or acquiring or os.clock() < acquisitionAt then return end
                acquisitionAt = os.clock() + 2
                acquiring = true
                task.spawn(function()
                    local good, why = pcall(function()
                        if game.PlaceId == 101880234193261 then
                            local scripts = LP:FindFirstChild("PlayerScripts")
                            local im, pm, cm = modules(scripts)
                            if not im and scripts then
                                for _, holder in scripts:GetDescendants() do
                                    im, pm, cm = modules(holder)
                                    if im then break end
                                end
                            end
                            if not im and not (scripts and scripts:FindFirstChild("PrivateLiveHost")) then
                                im, pm, cm = modules(RS, RS:FindFirstChild("Client") or (scripts and scripts:FindFirstChild("Client")))
                            end
                            if im then
                                local input, prediction, const = require(im), require(pm), require(cm)
                                if alive and not Input then attachTurbo(input, prediction, const) end
                            end
                            return
                        end
                        local shared = RS:FindFirstChild("Shared")
                        local playerScripts = LP:FindFirstChild("PlayerScripts")
                        local client = playerScripts and playerScripts:FindFirstChild("Client")
                        local net = shared and shared:FindFirstChild("Net")
                        local inputModule = client and client:FindFirstChild("Input")
                        local predictionModule = net and net:FindFirstChild("Prediction")
                        if not (inputModule and predictionModule) then return end
                        local input, prediction = require(inputModule), require(predictionModule)
                        if alive and not Input then attach(input, prediction) end
                    end)
                    acquiring = false
                    if not good then
                        matchWaiting = "Interface unavailable | " .. tostring(why):sub(1, 75)
                        status(matchWaiting)
                        warnOnce(why)
                    end
                end)
            end

            ------------------------------------------------------------------
            -- Match snapshot + inference loop
            ------------------------------------------------------------------
            local padArena, padSource, pads

            local function snapshot()
                if refreshGame then refreshGame() end
                if not P or not P.tick or not P.localCarId then return nil, matchWaiting end
                local arena = P.arena
                local car = P:LocalCar()
                if not arena or not car then return nil, "Waiting for your car" end
                if blocked then return nil, "Game controls paused" end
                if arena:IsBallScored() then return nil, "Goal | Waiting for kickoff" end
                local st = car:GetState()
                if st.isDemoed then return nil, "Respawning" end
                if padArena ~= arena or padSource ~= arena.boostPads then
                    pads = Observation.mapPads(arena.boostPads)
                    padArena, padSource = arena, arena.boostPads
                end
                local opponent
                for _, other in arena.cars do
                    if other ~= car and other.team ~= car.team and (not opponent or other.id < opponent.id) then
                        opponent = other
                    end
                end
                local ball = arena.ball:GetState()
                local isCenter = math.abs(ball.pos.x) < 1 and math.abs(ball.pos.y) < 1
                    and vector.magnitude(ball.vel) < 1 and st.isOnGround
                    and vector.magnitude(st.vel) < 10 and vector.magnitude(st.pos - ball.pos) > 1000
                local changed = P ~= identity or arena ~= arenaIdentity or car ~= carIdentity
                    or opponent ~= opponentIdentity or (P.tick < (nextTick - 16))
                if changed or (isCenter and not centered) then
                    reset()
                    Observation.reset()
                end
                identity, arenaIdentity, carIdentity, opponentIdentity = P, arena, car, opponent
                centered = isCenter
                return {
                    tick = P.tick,
                    ball = ball,
                    own = st,
                    opponent = opponent and opponent:GetState(),
                    team = car.team,
                }
            end

            -- Training ("treino") runs a separate single-car World, not the Prediction match.
            local tw, twTick, twAt, twCheck = nil, nil, 0, 0
            local function v3(value)
                if typeof(value) == "vector" then return value end
                return vector.create(value.X, value.Y, value.Z)
            end
            local pTick, pTickAt = nil, 0
            local function trainWorldActive()
                local now = os.clock()
                -- Is an online match simulation actually advancing? Then there is no training world: never scan.
                local ptk = P and P.tick
                if ptk ~= pTick then pTick, pTickAt = ptk, now end
                local matchLive = P ~= nil and now - pTickAt < 1.5
                if tw then
                    -- Cheap validity check each frame: the world must keep advancing.
                    if tw.tick ~= twTick then twTick, twAt = tw.tick, now end
                    if now - twAt < 1 then return tw end
                    tw, twTick = nil, nil
                end
                if matchLive or now < twCheck or type(getgc) ~= "function" then return nil end
                twCheck = now + 5 -- getgc(true) walks the whole heap (frame spike): scan rarely
                local found
                for _, it in getgc(true) do
                    if type(it) == "table" and rawget(it, "ballFrozen") ~= nil and type(rawget(it, "events")) == "table" then
                        local c, b = rawget(it, "car"), rawget(it, "ball")
                        if type(c) == "table" and type(c.body) == "table" and type(b) == "table" and type(b.body) == "table"
                            and type(rawget(it, "tick")) == "number" and (not found or it.tick > found.tick) then
                            found = it
                        end
                    end
                end
                if found then
                    tw, twTick, twAt = found, found.tick, now
                    return tw
                end
                return nil
            end
            -- Latency compensation. The policy was trained with zero delay between observing and acting,
            -- but here inference takes ~50 ms. Predict the state forward by the measured delay before
            -- feeding it to the network (ball: the game's own BallPrediction; car: kinematics).
            env.WolvotTune = env.WolvotTune or { comp = true, extra = 0.03, interval = 8 }
            local tune = env.WolvotTune
            local latencySec = 0.05
            local simBall, simPredictor
            pcall(function()
                local sim = RS.Shared.Sim
                simBall, simPredictor = require(sim.Ball).new(), require(sim.BallPrediction).new()
            end)

            local function rotate(v, w, angle)
                -- Rodrigues rotation of v around axis w (unit) by angle.
                local c, s = math.cos(angle), math.sin(angle)
                return v * c + vector.cross(w, v) * s + w * (vector.dot(w, v) * (1 - c))
            end

            local function lookahead(ball, own, dt)
                local g = -650
                local newBall = ball
                if simBall then
                    local ok = pcall(function()
                        simBall:reset(ball.pos, ball.vel, ball.angVel)
                        simPredictor:run(simBall, dt, 1)
                        local b = simPredictor.ghost.body
                        newBall = { pos = v3(b.pos), vel = v3(b.vel), angVel = v3(b.angVel) }
                    end)
                    if not ok then newBall = ball end
                end
                if newBall == ball then
                    newBall = {
                        pos = ball.pos + ball.vel * dt + vector.create(0, 0, .5 * g * dt * dt),
                        vel = ball.vel + vector.create(0, 0, g * dt), angVel = ball.angVel,
                    }
                end
                local newOwn = table.clone(own)
                local air = not own.isOnGround
                newOwn.pos = own.pos + own.vel * dt + (air and vector.create(0, 0, .5 * g * dt * dt) or vector.zero)
                newOwn.vel = air and (own.vel + vector.create(0, 0, g * dt)) or own.vel
                if air then
                    local w = vector.magnitude(own.angVel)
                    if w > 1e-3 then
                        local axis = own.angVel / w
                        local f, u = rotate(own.rot.forward, axis, w * dt), rotate(own.rot.up, axis, w * dt)
                        newOwn.rot = { forward = f, up = u, right = vector.cross(u, f) }
                    end
                end
                return newBall, newOwn
            end

            local averageFrame = 1 / 60
            local function publish()
                if not pending then return end
                local result = pending
                pending = nil
                if result.generation == generation then
                    action = Policy.select(result.logits)
                    decisions += 1
                    local latencyMs = (os.clock() - result.started) * 1000
                    latencySec = latencySec * .8 + math.min(latencyMs / 1000, .15) * .2
                    status(string.format("ON | Playing | %.0f FPS | %.0f ms", 1 / math.max(averageFrame, .001), latencyMs))
                end
            end

            connect(RunService.Heartbeat, function(dt)
                if not alive then return end
                averageFrame = averageFrame * .9 + math.min(dt, .1) * .1
                acquire()
                if not enabled then return end
                local worked, why = pcall(function()
                    local world = trainWorldActive()
                    local frameData, waiting
                    if world then
                        if not trainActive or trainWorldSeen ~= world then
                            trainActive, trainWorldSeen = true, world
                            reset()
                            Observation.reset()
                            trainPads = nil
                        end
                        local car, body, ballBody = world.car, world.car.body, world.ball.body
                        local own = {
                            pos = v3(body.pos), vel = v3(body.vel), angVel = v3(body.angVel),
                            rot = { forward = v3(body.fwd), up = v3(body.up), right = v3(body.right) },
                            boost = car.boost or 100,
                            isOnGround = car.isOnGround == true,
                            hasJumped = car.hasJumped == true,
                            hasDoubleJumped = car.hasDoubleJumped == true,
                            hasFlipped = car.hasFlipped == true,
                            isDemoed = car.isDemoed == true,
                        }
                        local ballState = { pos = v3(ballBody.pos), vel = v3(ballBody.vel), angVel = v3(ballBody.angVel) }
                        -- Default: the Wolvot policy plays the training world.
                        if not trainPads then
                            local raw = {}
                            for i, pad in world.pads.pads do
                                raw[i] = { pos = v3(pad.pos), isActive = pad.isActive, cooldown = pad.cooldown or 0 }
                            end
                            trainPads = { source = world.pads.pads, list = raw }
                            pads = Observation.mapPads(raw)
                            trainPads.mapped = pads
                        end
                        for i, pad in world.pads.pads do
                            local proxy = trainPads.list[i]
                            proxy.isActive, proxy.cooldown = pad.isActive, pad.cooldown or 0
                        end
                        pads = trainPads.mapped
                        if world.tick < nextTick - 16 then reset() Observation.reset() end
                        frameData = { tick = world.tick, ball = ballState, own = own, opponent = nil, team = 0 }
                        waiting = nil
                    else
                        if trainActive then
                            trainActive = false
                                reset()
                        end
                        frameData, waiting = snapshot()
                    end
                    if not frameData then
                        if job or action or pending then reset() end
                        centered = false
                        status("ON | " .. tostring(waiting))
                        return
                    end
                    Observation.track(frameData.own, frameData.opponent, frameData.tick)
                    publish()
                    if not job and frameData.tick >= nextTick then
                        local obsBall, obsOwn = frameData.ball, frameData.own
                        if tune.comp then
                            local okLook, lb, lo = pcall(lookahead, obsBall, obsOwn, math.clamp(latencySec + (tune.extra or 0), 0, .2))
                            if okLook then obsBall, obsOwn = lb, lo end
                        end
                        local obs = Observation.build(obsBall, obsOwn, frameData.opponent, pads, previous, frameData.team)
                        local requestedGeneration, requestedTick = generation, frameData.tick
                        local began = os.clock()
                        nextTick = frameData.tick + (tune.interval or 8)
                        job = coroutine.create(function()
                            local sliceStart = os.clock()
                            local compute = 0
                            local function checkpoint()
                                if not alive or not enabled or generation ~= requestedGeneration then error("cancelled", 0) end
                                local duration = os.clock() - sliceStart
                                if duration >= Controller.budget(averageFrame) then
                                    compute += duration
                                    coroutine.yield()
                                    sliceStart = os.clock()
                                end
                            end
                            local logits = network:forward(obs, checkpoint)
                            compute += os.clock() - sliceStart
                            return {
                                generation = requestedGeneration,
                                tick = requestedTick,
                                started = began,
                                logits = table.clone(logits),
                                compute = compute,
                            }
                        end)
                    end
                    if job then
                        local current = job
                        local success, result = coroutine.resume(current)
                        if not success then
                            job = nil
                            error(result, 0)
                        end
                        if coroutine.status(current) == "dead" then
                            job = nil
                            pending = result
                            publish()
                        end
                    end
                end)
                if not worked then
                    job, pending = nil, nil
                    status("ON | Data error | " .. tostring(why):sub(1, 60))
                    warnOnce(why)
                end
            end)
            acquire()
        end, function(problem) return tostring(problem) end)

        if ok then break end
        if alive then
            ready = false
            reset()
            for i = #connections, connectionStart + 1, -1 do
                connections[i]:Disconnect()
                connections[i] = nil
            end
            for i = #hooked, 1, -1 do
                local h = hooked[i]
                if h.object[h.key] == h.wrapper then h.object[h.key] = h.restore end
                hooked[i] = nil
            end
            P, Input, refreshGame = nil, nil, nil
            status((enabled and "ON" or "OFF") .. " | Retrying setup | " .. tostring(err):sub(1, 75))
            warn("[Wolvot Free] " .. tostring(err))
            task.wait(2)
        end
    end
end)
