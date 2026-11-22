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
version.Text = "v1.2.0  |  RCtrl"
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
skinBtn.BackgroundColor3 = Color3.fromRGB(36, 32, 28)
skinBtn.Text = "SKIN & UNLOCK ALL: FIXING"
skinBtn.AutoButtonColor = false
skinBtn.Active = false
skinBtn.Font = Enum.Font.GothamBold
skinBtn.TextSize = 12
skinBtn.TextColor3 = Color3.fromRGB(165, 145, 115)
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
-- skinBtn disabled (FIXING)

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
-- Skin Changer UI & Unlock All stripped (FIXING)

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
-- Skin Changer & Unlock All logic stripped (FIXING)
local cyclePresetByKey = nil


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
