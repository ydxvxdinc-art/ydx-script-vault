-- [ BACKROOMS ] Sidespin | 8 Ball Pool & Sinuca - Unlock All + P2P Sync + Full Table Guide Lines v1.1
-- [YDX Execution Telemetry - Non-Duplicating when loaded via Universal Loader]
do
    local env = (type(getgenv) == "function" and getgenv()) or _G
    env.__YDX_EXEC_LOCKS = env.__YDX_EXEC_LOCKS or {}
    local sid = "sidespin-unlock"
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
end
-- Unlocks all 46 Cues (Tacos), 14 Tables (Mesas), 10 3D Scenes (Cenarios), and all Insignias/Badges
-- Infinite/Full-Table Aim & Trajectory Lines (clamped strictly to the table bounds/pockets)
-- Pure ASCII, < 200 locals, Real-Time 3D Cue/Table/Scene Rendering & P2P Sync

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local lp = Players.LocalPlayer
while not lp do
    Players.PlayerAdded:Wait()
    lp = Players.LocalPlayer
end

local Sinuca = ReplicatedStorage:WaitForChild("Sinuca", 15)
if not Sinuca then
    warn("[Sidespin UnlockAll] ReplicatedStorage.Sinuca not found!")
    return
end

local function safeRequire(mod)
    if not mod then return nil end
    local ok, res = pcall(require, mod)
    return ok and res or nil
end

local Config = safeRequire(Sinuca:FindFirstChild("Config"))
local ShotGuide = safeRequire(Sinuca:FindFirstChild("ShotGuide"))
local BallPhysics = safeRequire(Sinuca:FindFirstChild("BallPhysics"))
local ShotMath = safeRequire(Sinuca:FindFirstChild("ShotMath"))
local MatchRules = safeRequire(Sinuca:FindFirstChild("MatchRules"))
local BotBrain = safeRequire(Sinuca:FindFirstChild("BotBrain"))

-- 0. Full-Table Infinite Guide Lines (Strictly Bounded to Table Surface & Pockets)
local function installInfiniteGuideLines()
    if not ShotGuide or not BallPhysics or not Config then return end

    ShotGuide.StubLength = 1000
    ShotGuide.RankedStubLength = 1000
    ShotGuide.StubSeconds = 12
    ShotGuide.MaxSeconds = 12
    ShotGuide.CueAfterLength = 1000

    local function newPath(p, cfg)
        return {
            length = 0,
            pending = nil,
            points = { p },
            last = p,
            config = cfg,
        }
    end

    local function clampPointToTable(pt, cfg)
        cfg = cfg or Config
        local halfW = (cfg.TableWidth or 7) / 2
        local halfL = (cfg.TableLength or 14) / 2
        local surfY = (cfg.SurfaceY or 2.6) + (cfg.BallRadius or 0.12)

        if math.abs(pt.X) <= halfW and math.abs(pt.Z) <= halfL then
            return Vector3.new(pt.X, surfY, pt.Z), false
        end

        if cfg.PocketsEnabled ~= false and type(BallPhysics.pocketList) == "function" then
            for _, pck in ipairs(BallPhysics.pocketList(cfg)) do
                local dx = pt.X - pck.center.X
                local dz = pt.Z - pck.center.Z
                local maxR = (pck.radius or 0.28) + (cfg.BallRadius or 0.12) * 0.5
                local distSq = dx * dx + dz * dz
                if distSq <= maxR * maxR then
                    return Vector3.new(pt.X, surfY, pt.Z), false
                end
            end
        end

        return Vector3.new(
            math.clamp(pt.X, -halfW, halfW),
            surfY,
            math.clamp(pt.Z, -halfL, halfL)
        ), true
    end

    local function clipSegmentToTable(p1, p2, cfg)
        cfg = cfg or Config
        local halfW = (cfg.TableWidth or 7) / 2
        local halfL = (cfg.TableLength or 14) / 2
        local surfY = (cfg.SurfaceY or 2.6) + (cfg.BallRadius or 0.12)

        local _, out2 = clampPointToTable(p2, cfg)
        if not out2 then
            return Vector3.new(p2.X, surfY, p2.Z), false
        end

        local dx = p2.X - p1.X
        local dz = p2.Z - p1.Z
        local tMax = 1

        if dx > 1e-8 and p2.X > halfW then
            tMax = math.min(tMax, math.clamp((halfW - p1.X) / dx, 0, 1))
        elseif dx < -1e-8 and p2.X < -halfW then
            tMax = math.min(tMax, math.clamp((-halfW - p1.X) / dx, 0, 1))
        end

        if dz > 1e-8 and p2.Z > halfL then
            tMax = math.min(tMax, math.clamp((halfL - p1.Z) / dz, 0, 1))
        elseif dz < -1e-8 and p2.Z < -halfL then
            tMax = math.min(tMax, math.clamp((-halfL - p1.Z) / dz, 0, 1))
        end

        return Vector3.new(
            math.clamp(p1.X + dx * tMax, -halfW, halfW),
            surfY,
            math.clamp(p1.Z + dz * tMax, -halfL, halfL)
        ), true
    end

    local function clampPolylineToTable(pts, cfg)
        if type(pts) ~= "table" or #pts == 0 then return {} end
        cfg = cfg or Config
        local firstPt = clampPointToTable(pts[1], cfg)
        local out = { firstPt }
        for i = 2, #pts do
            local prev = out[#out]
            local clipped, hitBoundary = clipSegmentToTable(prev, pts[i], cfg)
            local dx = clipped.X - prev.X
            local dz = clipped.Z - prev.Z
            if (dx * dx + dz * dz) > 1e-10 then
                table.insert(out, clipped)
            end
            if hitBoundary then
                break
            end
        end
        return out
    end

    local function pushPoint(path, pt)
        if not path then return end
        local last = path.last
        local dx = pt.X - last.X
        local dz = pt.Z - last.Z
        if math.sqrt(dx * dx + dz * dz) < 0.00001 then
            return
        end

        local anchor = path.points[#path.points]
        local ax = pt.X - anchor.X
        local az = pt.Z - anchor.Z
        local aDist = math.sqrt(ax * ax + az * az)
        local turnAngle = 0.14

        if path.pending and aDist > 0.05 then
            local dirStep = Vector3.new(dx, 0, dz).Unit
            local dirAnchor = Vector3.new(ax, 0, az).Unit
            if dirStep:Dot(dirAnchor) < math.cos(turnAngle) then
                table.insert(path.points, path.pending)
                local pend = path.pending
                local px = pend.X - anchor.X
                local pz = pend.Z - anchor.Z
                path.length = path.length + math.sqrt(px * px + pz * pz)
            end
        end

        path.pending = pt
        path.last = pt
    end

    local function closePath(path)
        if not path or path.closed then return path end
        if path.pending then
            table.insert(path.points, path.pending)
            local pend = path.pending
            local prev = path.points[#path.points - 1]
            if prev then
                local dx = pend.X - prev.X
                local dz = pend.Z - prev.Z
                path.length = path.length + math.sqrt(dx * dx + dz * dz)
            end
            path.pending = nil
        end
        path.closed = true
        return path
    end

    local function commitVertex(path, pt)
        if not path or path.closed then return 0 end
        local prevAnchor = path.points[#path.points]
        local segDist = 0
        if prevAnchor then
            local dx = pt.X - prevAnchor.X
            local dz = pt.Z - prevAnchor.Z
            segDist = math.sqrt(dx * dx + dz * dz)
        end
        pushPoint(path, pt)
        if path.pending then
            local prev = path.points[#path.points]
            local dx = path.pending.X - prev.X
            local dz = path.pending.Z - prev.Z
            local d = math.sqrt(dx * dx + dz * dz)
            if d > 1e-5 then
                table.insert(path.points, path.pending)
                path.length = path.length + d
            end
            path.pending = nil
        end
        return segDist
    end

    local MAX_APPROACH_WALLS = 2
    local MAX_OBJECT_WALLS = 3
    local MAX_CUE_AFTER_WALLS = 2
    local MAX_AFTER_SECONDS = 8.0

    local cfgCache = setmetatable({}, { __mode = "k" })
    local function getGuideConfig(baseCfg)
        baseCfg = baseCfg or Config
        local c = cfgCache[baseCfg]
        if not c then
            c = setmetatable({
                PhysicsStep = ShotGuide.Step or (1 / 120),
            }, { __index = baseCfg })
            cfgCache[baseCfg] = c
        end
        return c
    end

    local function copyBallState(b)
        local t = {}
        for k, v in pairs(b) do
            t[k] = v
        end
        return t
    end

    local function restoreBallState(b, snap)
        for k in pairs(b) do
            if snap[k] == nil then
                b[k] = nil
            end
        end
        for k, v in pairs(snap) do
            b[k] = v
        end
    end

    local function reduceParkBalls(guide)
        local balls = guide.world.balls
        local parked = guide.parked
        if not parked then
            parked = {}
            guide.parked = parked
        end
        local moving = {}
        for _, b in ipairs(balls) do
            if not b.removed and (b.v.Magnitude > 0.01 or b.w.Magnitude > 0.01) then
                table.insert(moving, b)
            end
        end
        local objIdx = (guide.objectNumber or -1) + 1
        for i = 2, #balls do
            local b = balls[i]
            local isParked = parked[i] == true
            if i ~= objIdx and (isParked or not b.removed) and b.v.Magnitude <= 0.01 and b.w.Magnitude <= 0.01 then
                local near = false
                for _, mb in ipairs(moving) do
                    if (mb.p - b.p).Magnitude <= 2.8 then
                        near = true
                        break
                    end
                end
                if near and isParked then
                    parked[i] = nil
                    b.removed = false
                elseif not near and not isParked then
                    parked[i] = true
                    b.removed = true
                end
            end
        end
    end

    ShotGuide.layers = function()
        return {
            cue = true,
            contact = true,
            object = true,
            cueAfter = true,
            full = true,
            hideObject = false,
            stubLength = 1000,
        }
    end

    ShotGuide.objectLength = function()
        return 1000
    end

    ShotGuide.points = function(path)
        if not path then return {} end
        local raw
        if not path.pending then
            raw = path.points
        else
            raw = table.clone(path.points)
            table.insert(raw, path.pending)
        end
        return clampPolylineToTable(raw, path.config or Config)
    end

    ShotGuide.objectPoints = function(objPath, cfg)
        if objPath and cfg and not objPath.config then
            objPath.config = cfg
        end
        return ShotGuide.points(objPath)
    end

    ShotGuide.clip = function(pts)
        return clampPolylineToTable(pts, Config)
    end

    ShotGuide.stubReady = function(guide)
        if not guide then return false end
        return guide.done == true or guide.phase ~= "approach"
    end

    local origPlaceGhost = ShotGuide._origPlaceGhost or ShotGuide.placeGhost
    ShotGuide._origPlaceGhost = origPlaceGhost
    ShotGuide.placeGhost = function(ghostPart, tracadoFolder, res, cfg)
        local ret = false
        if type(origPlaceGhost) == "function" then
            ret = origPlaceGhost(ghostPart, tracadoFolder, res, cfg)
        end
        if res and tracadoFolder then
            local ancora = tracadoFolder:FindFirstChild("Ancora")
            if ancora then
                local r = (cfg and cfg.BallRadius) or (Config and Config.BallRadius) or 0.12
                for _, ch in ipairs(ancora:GetChildren()) do
                    if ch:IsA("Beam") and ch.Enabled then
                        if string.sub(ch.Name, 1, 5) == "Faixa" then
                            local w = math.max(ch.Width0, r * 1.1)
                            ch.Width0 = w
                            ch.Width1 = w
                            ch.Transparency = NumberSequence.new(0.14)
                        elseif string.sub(ch.Name, 1, 6) == "Nucleo" then
                            local w = math.max(ch.Width0, r * 0.38)
                            ch.Width0 = w
                            ch.Width1 = w
                            ch.Transparency = NumberSequence.new(0.22)
                        end
                    end
                end
            end
        end
        return ret
    end

    local function isBallStopped(b, cfg)
        if not b or b.removed then return true end
        local stopSpd = (cfg and cfg.StopSpeed) or 0.03
        local spinStop = (cfg and cfg.SpinStopSpeed) or 0.25
        return b.v.Magnitude <= stopSpd and b.w.Magnitude <= spinStop
    end

    ShotGuide.new = function(opts)
        local baseCfg = opts.config or Config
        local gCfg = getGuideConfig(baseCfg)
        local restY = baseCfg.SurfaceY + baseCfg.BallRadius
        local awayH = ShotGuide.AwayHeight or 0.02
        local balls = {}

        for i = 1, 16 do
            local pos = opts.balls and opts.balls[i]
            local b = BallPhysics.ball(pos or Vector3.new(1000, restY, 1000))
            if not (pos and (i <= 1 or math.abs(pos.Y - restY) <= awayH)) then
                b.removed = true
            end
            balls[i] = b
        end

        BallPhysics.strike(
            balls[1],
            opts.direction,
            opts.speed,
            opts.height or 0,
            opts.side or 0,
            baseCfg,
            opts.elevation or 0
        )

        local world = BallPhysics.world(balls, gCfg)
        world.ready = false
        local solo = BallPhysics.world({ balls[1] }, gCfg)
        solo.ready = false
        local soloEvCount = 0
        solo.onEvent = function()
            soloEvCount = soloEvCount + 1
        end

        local guide = {
            time = 0,
            phase = "approach",
            done = false,
            objectNumber = nil,
            world = world,
            solo = solo,
            config = gCfg,
            full = true,
            hideObject = false,
            stubLength = 1000,
            cueBounces = 0,
            objBounces = 0,
            cueAfterBounces = 0,
            cueAfterDone = false,
            objectDone = false,
            result = {
                cue = newPath(balls[1].p, gCfg),
            },
            popSoloEvents = function()
                local c = soloEvCount
                soloEvCount = 0
                return c
            end,
        }

        world.onEvent = function(ev)
            if guide.phase == "approach" then
                if ev.kind == "Contact" then
                    commitVertex(guide.result.cue, balls[1].p)
                    closePath(guide.result.cue)
                    guide.phase = "after"
                    guide.objectNumber = ev.number
                    guide.result.contact = {
                        position = balls[1].p,
                        number = ev.number,
                    }
                    local objBall = balls[ev.number + 1]
                    if objBall then
                        guide.result.object = newPath(objBall.p, gCfg)
                        local cDir = Vector3.new(objBall.p.X - balls[1].p.X, 0, objBall.p.Z - balls[1].p.Z)
                        if cDir.Magnitude > 1e-6 then
                            guide.lastObjDir = cDir.Unit
                        end
                    end
                    guide.result.cueAfter = newPath(balls[1].p, gCfg)
                    guide.afterStart = guide.time
                elseif ev.number == 0 then
                    if ev.kind == "Pocketed" then
                        commitVertex(guide.result.cue, balls[1].p)
                        closePath(guide.result.cue)
                        guide.result.pocket = {
                            position = balls[1].p,
                            id = ev.pocket,
                        }
                        guide.phase = "done"
                        return
                    elseif ev.kind == "Rail" then
                        local segDist = commitVertex(guide.result.cue, balls[1].p)
                        if not guide.result.rail then
                            guide.result.rail = {
                                position = balls[1].p,
                                jaw = ev.jaw == true,
                            }
                        end
                        if segDist >= 0.08 then
                            guide.cueBounces = guide.cueBounces + 1
                        end
                        if guide.cueBounces >= MAX_APPROACH_WALLS then
                            closePath(guide.result.cue)
                            guide.phase = "done"
                        end
                        return
                    else
                        commitVertex(guide.result.cue, balls[1].p)
                        closePath(guide.result.cue)
                        guide.phase = "done"
                        return
                    end
                end
            elseif guide.phase == "after" then
                local cueAfter = guide.result.cueAfter
                if cueAfter and not cueAfter.closed and ev.number == 0 then
                    if ev.kind == "Pocketed" or ev.kind == "OutOfBounds" then
                        commitVertex(cueAfter, balls[1].p)
                        closePath(cueAfter)
                        guide.cueAfterDone = true
                    elseif ev.kind == "Rail" then
                        local segDist = commitVertex(cueAfter, balls[1].p)
                        if segDist >= 0.08 then
                            guide.cueAfterBounces = guide.cueAfterBounces + 1
                        end
                        if guide.cueAfterBounces >= MAX_CUE_AFTER_WALLS then
                            closePath(cueAfter)
                            guide.cueAfterDone = true
                        end
                    end
                end

                local objPath = guide.result.object
                if objPath and not objPath.closed and guide.objectNumber and ev.number == guide.objectNumber then
                    local objBall = balls[guide.objectNumber + 1]
                    if ev.kind == "Pocketed" or ev.kind == "OutOfBounds" then
                        if objBall then
                            commitVertex(objPath, objBall.p)
                        end
                        closePath(objPath)
                        objPath.pocketed = (ev.kind == "Pocketed")
                        objPath.pocket = ev.pocket
                        guide.objectDone = true
                    elseif ev.kind == "Rail" then
                        local segDist = objBall and commitVertex(objPath, objBall.p) or 1
                        if segDist >= 0.08 then
                            guide.objBounces = guide.objBounces + 1
                        end
                        if guide.objBounces >= MAX_OBJECT_WALLS then
                            closePath(objPath)
                            guide.objectDone = true
                        end
                    end
                end
            end
        end

        world.onImpact = function(kind, i1, i2)
            if kind ~= "Ball" or guide.phase ~= "after" then return end
            guide.lastBallImpactTime = guide.time
            local cueAfter = guide.result.cueAfter
            if (i1 == 1 or i2 == 1) and cueAfter and not cueAfter.closed then
                commitVertex(cueAfter, balls[1].p)
                guide.lastCueAfterDir = nil
            end
            local objPath = guide.result.object
            local targetIdx = guide.objectNumber and (guide.objectNumber + 1) or -1
            if (i1 == targetIdx or i2 == targetIdx) and objPath and not objPath.closed then
                local objBall = balls[targetIdx]
                if objBall then
                    commitVertex(objPath, objBall.p)
                end
                guide.lastObjDir = nil
            end
        end

        return guide
    end

    ShotGuide.advance = function(guide, steps)
        if not guide then return true end
        guide.direction = nil
        if guide.done then return true end

        local world = guide.world
        local cfg = guide.config or Config
        local result = guide.result
        local balls = world.balls
        local cueBall = balls[1]
        local baseStepDt = cfg.PhysicsStep or (1 / 120)
        local r = cfg.BallRadius or 0.12
        local soloProximity = 2 * r + (ShotGuide.SoloMargin or 0.03)
        local maxSteps = math.max(steps or 12, 260)

        local function isBallSliding(b)
            if not b or b.removed then return false end
            if b.curve ~= nil or math.abs(b.v.Y) > 1e-5 then return true end
            local sx = b.v.X + r * b.w.Z
            local sz = b.v.Z - r * b.w.X
            return (sx * sx + sz * sz) > 0.002
        end

        local function keepPureRollAlive(b, minSpeed, targetSpeed)
            if not b or b.removed then return end
            if guide.lastBallImpactTime and (guide.time - guide.lastBallImpactTime) < 0.12 then
                return
            end
            local hv = Vector3.new(b.v.X, 0, b.v.Z)
            local hvMag = hv.Magnitude
            if hvMag <= 0.12 then
                return
            end
            if isBallSliding(b) and hvMag >= 1.0 then
                return
            end
            if hvMag < minSpeed then
                local dir = hv.Unit
                b.v = Vector3.new(dir.X * targetSpeed, 0, dir.Z * targetSpeed)
                local rw = Vector3.new(0, 1, 0):Cross(b.v) / r
                b.w = Vector3.new(rw.X, 0, rw.Z)
            end
        end

        for stepIdx = 1, maxSteps do
            local stepDt = baseStepDt
            if guide.phase == "approach" then
                if not cueBall.removed then
                    keepPureRollAlive(cueBall, 8.0, 14.0)
                end
                if not isBallSliding(cueBall) then
                    stepDt = baseStepDt * 2
                end
            elseif guide.phase == "after" then
                if stepIdx % 2 == 1 then
                    reduceParkBalls(guide)
                end
                local elapsedAfter = guide.time - (guide.afterStart or guide.time)
                if elapsedAfter >= MAX_AFTER_SECONDS then
                    guide.phase = "done"
                    break
                end
                if not cueBall.removed and result.cueAfter and not result.cueAfter.closed then
                    keepPureRollAlive(cueBall, 6.0, 12.0)
                end
                local ob = guide.objectNumber and balls[guide.objectNumber + 1]
                if ob and not ob.removed and result.object and not result.object.closed then
                    keepPureRollAlive(ob, 6.0, 12.0)
                end
                if not isBallSliding(cueBall) and not isBallSliding(ob) then
                    stepDt = baseStepDt * 3
                end
            end

            local solo = guide.solo
            if solo and guide.phase == "approach" then
                local snap = copyBallState(cueBall)
                local p0 = cueBall.p
                guide.popSoloEvents()
                BallPhysics.step(solo.balls, stepDt, cfg, nil, solo.onEvent, solo.onImpact)
                local hitSomething = (guide.popSoloEvents() > 0) or (cueBall.removed == true)

                if not hitSomething then
                    local seg = cueBall.p - p0
                    local segLenSq = seg:Dot(seg)
                    for i2 = 2, #balls do
                        local b2 = balls[i2]
                        if not b2.removed then
                            local t = 0
                            if segLenSq > 1e-12 then
                                t = math.clamp((b2.p - p0):Dot(seg) / segLenSq, 0, 1)
                            end
                            if (p0 + seg * t - b2.p).Magnitude <= soloProximity then
                                hitSomething = true
                                break
                            end
                        end
                    end
                end

                if hitSomething then
                    restoreBallState(cueBall, snap)
                    BallPhysics.step(world.balls, baseStepDt, cfg, nil, world.onEvent, world.onImpact)
                    stepDt = baseStepDt
                    if guide.phase ~= "approach" then
                        guide.solo = nil
                    end
                end
            else
                BallPhysics.step(world.balls, stepDt, cfg, nil, world.onEvent, world.onImpact)
            end

            guide.time = guide.time + stepDt

            if not cueBall.removed then
                local hv = Vector3.new(cueBall.v.X, 0, cueBall.v.Z)
                if hv.Magnitude > 0.08 then
                    if guide.phase == "approach" then
                        guide.lastCueDir = hv.Unit
                    else
                        guide.lastCueAfterDir = hv.Unit
                    end
                end
            end
            if guide.objectNumber then
                local ob = balls[guide.objectNumber + 1]
                if ob and not ob.removed then
                    local hv = Vector3.new(ob.v.X, 0, ob.v.Z)
                    if hv.Magnitude > 0.08 then
                        guide.lastObjDir = hv.Unit
                    end
                end
            end

            if guide.phase == "approach" then
                pushPoint(result.cue, cueBall.p)
                local _, outOfTable = clampPointToTable(cueBall.p, cfg)
                if cueBall.removed or world.ready or isBallStopped(cueBall, cfg) or outOfTable or guide.time >= (ShotGuide.MaxSeconds or 12) then
                    guide.phase = "done"
                end
            elseif guide.phase == "after" then
                local cueAfter = result.cueAfter
                local cueStillRunning = false
                if cueAfter and not cueAfter.closed then
                    if not cueBall.removed then
                        pushPoint(cueAfter, cueBall.p)
                    end
                    local _, outOfTable = clampPointToTable(cueBall.p, cfg)
                    if cueBall.removed or guide.cueAfterDone or isBallStopped(cueBall, cfg) or outOfTable then
                        closePath(cueAfter)
                        guide.cueAfterDone = true
                    else
                        cueStillRunning = true
                    end
                end

                local objPath = result.object
                local objStillRunning = false
                if objPath and not objPath.closed and guide.objectNumber then
                    local objBall = balls[guide.objectNumber + 1]
                    if objBall then
                        if not objBall.removed then
                            pushPoint(objPath, objBall.p)
                        end
                        local _, outOfTable = clampPointToTable(objBall.p, cfg)
                        if objBall.removed or guide.objectDone or isBallStopped(objBall, cfg) or outOfTable then
                            closePath(objPath)
                            guide.objectDone = true
                        else
                            objStillRunning = true
                        end
                    else
                        closePath(objPath)
                        guide.objectDone = true
                    end
                end

                if (not objStillRunning and not cueStillRunning) or world.ready or guide.time >= (ShotGuide.MaxSeconds or 12) then
                    guide.phase = "done"
                end
            end

            if guide.phase == "done" then
                break
            end
        end

        if guide.phase == "done" then
            guide.done = true
            closePath(result.cue)
            if result.cueAfter then
                closePath(result.cueAfter)
            end
            if result.object then
                closePath(result.object)
            end
        end

        return guide.done
    end

    pcall(function()
        local proto = workspace:FindFirstChild("SinucaPrototype")
        if proto and proto:GetAttribute("RoomTrajectory") == false then
            proto:SetAttribute("RoomTrajectory", true)
        end
        if type(getgc) ~= "function" then return end
        local getUpvals = (debug and debug.getupvalues) or getupvalues
        local setUpval = (debug and debug.setupvalue) or setupvalue
        for _, obj in ipairs(getgc(true)) do
            if type(obj) == "table" then
                if type(rawget(obj, "assistOn")) == "function" and type(rawget(obj, "startGuide")) == "function" then
                    local origAssistOn = rawget(obj, "_origAssistOn") or rawget(obj, "assistOn")
                    rawset(obj, "_origAssistOn", origAssistOn)
                    rawset(obj, "assistOn", function(kind)
                        if kind == "trajectory" then
                            return true
                        end
                        return origAssistOn(kind)
                    end)
                    rawset(obj, "paintedGuide", nil)
                    rawset(obj, "paintedTime", nil)
                    local sg = rawget(obj, "startGuide")
                    if type(sg) == "function" and type(getUpvals) == "function" and type(setUpval) == "function" then
                        local ok, ups = pcall(getUpvals, sg)
                        if ok and type(ups) == "table" then
                            for idx, val in pairs(ups) do
                                if type(val) == "string" and string.find(val, "|", 1, true) then
                                    pcall(setUpval, sg, idx, "")
                                end
                            end
                        end
                    end
                elseif rawget(obj, "trajectory") ~= nil and rawget(obj, "whiteAssist") ~= nil and rawget(obj, "cameraSens") ~= nil then
                    rawset(obj, "trajectory", true)
                end
            end
        end
    end)
end

installInfiniteGuideLines()

-- 0.5. Superhuman Auto-Play Bot + Interactive GUI
local function installAutoPlayBot()
    if not BotBrain or not MatchRules or not BallPhysics or not ShotMath or not Config then
        return
    end

    if type(_G.SidespinAutoBotCleanup) == "function" then
        pcall(_G.SidespinAutoBotCleanup)
    end

    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local RemotesFolder = Sinuca:FindFirstChild("Remotes")
    local CueAction = RemotesFolder and RemotesFolder:FindFirstChild("CueAction")
    if not CueAction then return end

    local BotState = {
        running = true,
        autoPlay = false,
        busy = false,
        fastMode = true,
        statusText = "Pronto (Aguardando)",
        groupText = "-",
        planText = "Nenhuma tacada calculada",
        powerText = "Forca: - | Efeito: Centro",
        lastActionClock = 0,
        lastShotEpoch = -1,
        u6 = nil,
        selectBallFn = nil,
    }

    local POCKET_NAMES = {
        [1] = "Canto Sup. Esq.",
        [2] = "Canto Sup. Dir.",
        [3] = "Meio Esq.",
        [4] = "Meio Dir.",
        [5] = "Canto Inf. Esq.",
        [6] = "Canto Inf. Dir.",
    }

    local SPIN_PROFILES = {
        { h = 0, s = 0, m = 1.0, name = "Centro" },
        { h = 0.42, s = 0, m = 1.0, name = "Efeito Topo (Follow)" },
        { h = -0.45, s = 0, m = 1.15, name = "Efeito Baixo (Draw)" },
        { h = 0, s = 0, m = 1.32, name = "Centro Forte" },
        { h = 0, s = 0, m = 0.85, name = "Centro Suave" },
        { h = 0.25, s = -0.32, m = 1.08, name = "Efeito Esq." },
        { h = 0.25, s = 0.32, m = 1.08, name = "Efeito Dir." },
        { h = -0.58, s = 0, m = 1.35, name = "Super Draw" },
    }

    local function findClientHooks()
        if BotState.u6 and BotState.selectBallFn then
            return BotState.u6, BotState.selectBallFn
        end
        if type(getgc) ~= "function" then return nil, nil end
        local getUpvals = (debug and debug.getupvalues) or getupvalues
        local getInfo = (debug and debug.getinfo) or getinfo
        if type(getUpvals) ~= "function" then return nil, nil end

        for _, obj in ipairs(getgc(true)) do
            if type(obj) == "table" and type(rawget(obj, "aimCommand")) == "function" and type(rawget(obj, "startGuide")) == "function" then
                BotState.u6 = obj
                local ok, ups = pcall(getUpvals, obj.aimCommand)
                if ok and type(ups) == "table" then
                    for _, val in pairs(ups) do
                        if type(val) == "function" then
                            local okI, info = pcall(getInfo, val)
                            if okI and info and (info.nups or 0) >= 20 then
                                BotState.selectBallFn = val
                                break
                            end
                        end
                    end
                end
                break
            end
        end
        return BotState.u6, BotState.selectBallFn
    end

    local function getBallGroup(num)
        if num >= 1 and num <= 7 then return "Lisas" end
        if num >= 9 and num <= 15 then return "Listradas" end
        return nil
    end

    local function readLiveTableState()
        local proto = workspace:FindFirstChild("SinucaPrototype")
        if not proto then return nil end
        local cueBallPart = proto:FindFirstChild("CueBall")
        if not cueBallPart then return nil end

        local u6 = findClientHooks()
        local cfg = (u6 and u6.fun and type(u6.fun.config) == "function" and u6.fun.config()) or Config
        local restY = cfg.SurfaceY + cfg.BallRadius

        local balls = {}
        balls[1] = BallPhysics.ball(cueBallPart.Position)
        if cueBallPart.Transparency >= 1 then
            balls[1].removed = true
        end

        local activeBalls = 0
        for i = 1, 15 do
            local ob = proto:FindFirstChild("ObjectBall" .. i)
            local b = BallPhysics.ball(ob and ob.Position or Vector3.new(1000, restY, 1000))
            if not (ob and ob.Transparency < 1 and not ob:GetAttribute("Pocketed") and math.abs(ob.Position.Y - restY) <= 0.12) then
                b.removed = true
            else
                activeBalls = activeBalls + 1
            end
            balls[i + 1] = b
        end

        local rawMode = proto:GetAttribute("PlayMode") or "Practice"
        local localDuel = proto:GetAttribute("LocalDuel") == true
        local turnSeat = proto:GetAttribute("TurnSeat") or 1
        local mySeat = lp:GetAttribute("PoolSeat") or 1
        if mySeat <= 0 then mySeat = 1 end
        if localDuel then
            mySeat = turnSeat
        end

        local isSinglePlayer = (rawMode == "Practice" or rawMode == "Solo")
        local solverMode = (rawMode == "Practice") and "Solo" or rawMode
        local solverSeat = isSinglePlayer and 1 or mySeat
        local seatCount = proto:GetAttribute("SeatCount") or 2

        local match = MatchRules.new(solverSeat, solverMode, seatCount)
        local matchPhase = proto:GetAttribute("MatchPhase") or "Ready"
        match.phase = matchPhase
        match.turn = isSinglePlayer and 1 or turnSeat
        match.breaking = (proto:GetAttribute("OpeningRequired") == true or proto:GetAttribute("FreshRack") == true)
        match.kitchen = (proto:GetAttribute("KitchenOnly") == true or proto:GetAttribute("KitchenPlace") == true) or nil

        if proto:GetAttribute("BallInHand") == true or proto:GetAttribute("KitchenPlace") == true then
            match.phase = "BallInHand"
        end
        if matchPhase == "Penalty" then
            match.phase = "Penalty"
            match.penaltySeat = proto:GetAttribute("PenaltySeat") or solverSeat
        end

        for s = 1, 4 do
            local g = proto:GetAttribute("Seat" .. s .. "Group")
            if g == "Lisas" or g == "Listradas" then
                match.groups[s] = g
            end
        end

        local myGroup = match.groups[solverSeat]
        local legalList = {}
        local groupLabel = "Mesa Aberta"

        if isSinglePlayer or solverMode == "Individual" or match.breaking then
            for i = 1, 15 do
                if not balls[i + 1].removed then
                    table.insert(legalList, i)
                end
            end
            groupLabel = (rawMode == "Practice" and "Treino (Todas)" or (match.breaking and "Saida (Break)" or "Livre (Todas)"))
        elseif not myGroup then
            for i = 1, 15 do
                if i ~= 8 and not balls[i + 1].removed then
                    table.insert(legalList, i)
                end
            end
            if #legalList == 0 and not balls[9].removed then
                table.insert(legalList, 8)
                groupLabel = "Bola 8 (Final)"
            else
                groupLabel = "Mesa Aberta (1-7 / 9-15)"
            end
        else
            for i = 1, 15 do
                if getBallGroup(i) == myGroup and not balls[i + 1].removed then
                    table.insert(legalList, i)
                end
            end
            if #legalList == 0 then
                if not balls[9].removed then
                    table.insert(legalList, 8)
                end
                groupLabel = "Bola 8 (Final)"
            else
                groupLabel = myGroup .. " (" .. tostring(#legalList) .. " restantes)"
            end
        end

        local isMyTurn = false
        if lp:GetAttribute("PoolAtTable") == true and not proto:GetAttribute("MatchFinished") then
            if matchPhase == "Penalty" then
                isMyTurn = localDuel or (mySeat == proto:GetAttribute("PenaltySeat"))
            else
                isMyTurn = isSinglePlayer or localDuel or (mySeat == turnSeat)
            end
        end

        return {
            proto = proto,
            cueBallPart = cueBallPart,
            cfg = cfg,
            balls = balls,
            activeBalls = activeBalls,
            rawMode = rawMode,
            solverMode = solverMode,
            solverSeat = solverSeat,
            mySeat = mySeat,
            match = match,
            legalList = legalList,
            groupLabel = groupLabel,
            isMyTurn = isMyTurn,
            allStopped = (proto:GetAttribute("AllStopped") == true and cueBallPart:GetAttribute("Moving") ~= true),
        }
    end

    -- Hook CueAction:FireServer via __namecall once so server always receives exact locked bot shot parameters
    if not _G.SidespinCueActionHooked then
        _G.SidespinCueActionHooked = true
        pcall(function()
            if type(hookmetamethod) ~= "function" or type(getnamecallmethod) ~= "function" then return end
            local oldNc
            oldNc = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                if self == CueAction and (method == "FireServer" or method == "fireServer") then
                    local locked = _G.SidespinLockedShot
                    if type(locked) == "table" and os.clock() < (locked.expiresAt or 0) then
                        local action, sessionId, arg3 = ...
                        if action == "Begin" then
                            return oldNc(self, "Begin", sessionId, locked.dir, "classic")
                        elseif action == "Release" then
                            _G.SidespinLockedShot = nil
                            return oldNc(self, "Release", sessionId, {
                                power = locked.power,
                                yaw = locked.yaw,
                                elevation = locked.elevation,
                                hitHeight = locked.hitHeight,
                                hitSide = locked.hitSide,
                            })
                        end
                    end
                end
                return oldNc(self, ...)
            end)
        end)
    end

    local function isPathClear(balls, x1, z1, x2, z2, ignoreA, ignoreB, clearance)
        local dx = x2 - x1
        local dz = z2 - z1
        local lenSq = dx * dx + dz * dz
        if lenSq < 1e-9 then return true end
        local clearSq = clearance * clearance
        for i, b in ipairs(balls) do
            if i ~= ignoreA and i ~= ignoreB and not b.removed then
                local bx = b.p.X - x1
                local bz = b.p.Z - z1
                local proj = (bx * dx + bz * dz) / lenSq
                -- Ignore balls sitting behind the starting ball center (proj <= 0.02)
                if proj > 0.02 and proj < 1.0 then
                    local t = math.clamp(proj, 0, 1)
                    local px = bx - dx * t
                    local pz = bz - dz * t
                    if (px * px + pz * pz) < clearSq then
                        return false
                    end
                end
            end
        end
        return true
    end

    local function hasGluedNeighbor(balls, bIdx, radius)
        local ob = balls[bIdx]
        if not ob or ob.removed then return false, nil end
        local rSq = radius * radius
        for i = 2, #balls do
            if i ~= bIdx then
                local other = balls[i]
                if other and not other.removed then
                    local dx = other.p.X - ob.p.X
                    local dz = other.p.Z - ob.p.Z
                    if (dx * dx + dz * dz) <= rSq then
                        return true, i - 1
                    end
                end
            end
        end
        return false, nil
    end

    local function getPocketTargets(cfg)
        local list = {}
        for i, v in ipairs(BallPhysics.pocketList(cfg)) do
            local cx = v.center.X
            local cz = v.center.Z
            local fx, fz, inset
            if v.kind == "Side" then
                fx = cx > 0 and -1 or 1
                fz = 0
                inset = 0.11
            else
                fx = (cx > 0 and -1 or 1) * 0.70710678
                fz = (cz > 0 and -1 or 1) * 0.70710678
                inset = 0.14
            end
            list[i] = {
                x = cx + fx * inset,
                z = cz + fz * inset,
                cx = cx,
                cz = cz,
                fx = fx,
                fz = fz,
                kind = v.kind,
            }
        end
        return list
    end

    local function computeThrowAdjustedAim(cueP, obP, targetX, targetZ, cfg, desiredObjSpeed)
        local r = cfg.BallRadius or 0.12
        local twoR = 2 * r
        local toTx = targetX - obP.X
        local toTz = targetZ - obP.Z
        local distT = math.sqrt(toTx * toTx + toTz * toTz)
        if distT < 1e-4 then return nil end

        local dirTx = toTx / distT
        local dirTz = toTz / distT
        local gx = obP.X - dirTx * twoR
        local gz = obP.Z - dirTz * twoR
        local toGx = gx - cueP.X
        local toGz = gz - cueP.Z
        local distG = math.sqrt(toGx * toGx + toGz * toGz)
        if distG < twoR * 0.95 then return nil end

        local dirGx = toGx / distG
        local dirGz = toGz / distG
        local cosCut = dirGx * dirTx + dirGz * dirTz
        if cosCut < 0.08 then return nil end

        local sinCut = math.sqrt(math.max(0, 1 - cosCut * cosCut))
        local rest = cfg.BallRestitution or 0.97
        local spd = (desiredObjSpeed or 6.5) / math.max(0.15, cosCut * (1 + rest) / 2)

        if sinCut > 0.001 then
            local fric = (cfg.BallFrictionA or 0) + (cfg.BallFrictionB or 0.025) * math.exp(-(cfg.BallFrictionC or 1.088) * (spd * sinCut * (cfg.MetersPerStud or 0.238125)))
            local tanThrow = math.min(fric, sinCut / cosCut / (3.5 * (1 + rest)))
            local throwAng = math.atan(tanThrow)
            if (dirGx * dirTz - dirGz * dirTx) <= 0 then
                throwAng = -throwAng
            end
            local ca = math.cos(throwAng)
            local sa = math.sin(throwAng)
            local adjTx = dirTx * ca - dirTz * sa
            local adjTz = dirTx * sa + dirTz * ca
            gx = obP.X - adjTx * twoR
            gz = obP.Z - adjTz * twoR
            toGx = gx - cueP.X
            toGz = gz - cueP.Z
            distG = math.sqrt(toGx * toGx + toGz * toGz)
            if distG < 1e-4 then return nil end
            dirGx = toGx / distG
            dirGz = toGz / distG
        end

        local v49 = (cfg.SlidingFriction or 0.2) * (cfg.Gravity or 41.2)
        local v50 = (cfg.RollingResistance or 0.015) * (cfg.Gravity or 41.2)
        local launchObjSq = math.max(0, (distT + 5.5 / (2 * v50)) / (0.4898 / (2 * v49) + 0.5102 / (2 * v50)))
        local launchObj = math.sqrt(launchObjSq) / math.max(0.18, cosCut * (1 + rest) / 2)
        local launchCueSq = math.max(0, (distG + launchObj * launchObj / (2 * v50)) / (0.4898 / (2 * v49) + 0.5102 / (2 * v50)))
        local launchCue = math.sqrt(launchCueSq)
        local power = math.clamp(ShotMath.powerOf(launchCue, cfg, false), math.max(cfg.MinShotPower or 0.025, 0.14), 0.96)

        return math.atan2(dirGx, -dirGz), power, distG, distT, cosCut, gx, gz
    end

    local function evaluateNextPositionQuality(ballsAfter, legalList, cfg)
        local cueAfter = ballsAfter[1]
        if not cueAfter or cueAfter.removed then return 0 end
        local pocketTargets = getPocketTargets(cfg)
        local twoR = 2 * cfg.BallRadius
        local bestQ = 0

        for _, bNum in ipairs(legalList) do
            local ob = ballsAfter[bNum + 1]
            if ob and not ob.removed then
                for _, pck in ipairs(pocketTargets) do
                    local toPx = pck.x - ob.p.X
                    local toPz = pck.z - ob.p.Z
                    local distP = math.sqrt(toPx * toPx + toPz * toPz)
                    if distP > 1e-4 then
                        local dirPx = toPx / distP
                        local dirPz = toPz / distP
                        local gx = ob.p.X - dirPx * twoR
                        local gz = ob.p.Z - dirPz * twoR
                        local toGx = gx - cueAfter.p.X
                        local toGz = gz - cueAfter.p.Z
                        local distG = math.sqrt(toGx * toGx + toGz * toGz)
                        if distG > twoR then
                            local cosCut = (toGx / distG) * dirPx + (toGz / distG) * dirPz
                            if cosCut > 0.22 then
                                if isPathClear(ballsAfter, cueAfter.p.X, cueAfter.p.Z, gx, gz, 1, bNum + 1, twoR * 0.94)
                                    and isPathClear(ballsAfter, ob.p.X, ob.p.Z, pck.x, pck.z, 1, bNum + 1, twoR * 0.94) then
                                    local q = (cosCut ^ 1.3) / (1 + distG * 0.12 + distP * 0.15)
                                    if q > bestQ then
                                        bestQ = q
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        return bestQ
    end

    local function simulateShotExact(st, yaw, power, h, s, exact240)
        local cfg = st.cfg
        local cuePos = st.balls[1].p
        local effS, effH = ShotMath.effectiveContact(s or 0, h or 0, cfg)
        local elev = ShotMath.autoElevation(cuePos, yaw, effH, effS, cfg)
        if not ShotMath.cueAllowed(cuePos, yaw, elev, effH, effS, cfg) then
            return nil
        end

        local step = exact240 and (cfg.PhysicsStep or (1 / 240)) or (1 / 120)
        local botInput = {
            balls = st.balls,
            match = st.match,
            seat = st.solverSeat,
            config = cfg,
            mode = st.solverMode,
        }
        local simRes = BotBrain.simulate(botInput, {
            Physics = BallPhysics,
            ShotMath = ShotMath,
            Match = MatchRules,
            Config = cfg,
            simStep = step,
            yield = task.wait,
            yieldEvery = 0.0035,
        }, {
            yaw = yaw,
            power = power,
            height = effH,
            side = effS,
            elevation = elev,
        })
        if not simRes then return nil end
        return simRes, elev, effH, effS
    end

    local function generateAllShotCandidates(st)
        local directList = {}
        local clusterList = {}
        local comboList = {}
        local bankList = {}
        local kickList = {}

        local balls = st.balls
        local cue = balls[1]
        if not cue or cue.removed then
            return directList, clusterList, comboList, bankList, kickList
        end

        local cfg = st.cfg
        local r = cfg.BallRadius or 0.12
        local twoR = 2 * r
        local halfW = cfg.TableWidth / 2 - r
        local halfL = cfg.TableLength / 2 - r
        local pocketTargets = getPocketTargets(cfg)
        local kitchenRestricted = (st.match.placedKitchen == true)
        local headZ = MatchRules.headString(cfg.TableLength)

        -- 1. ALL Direct Shots (every legal ball x all 6 pockets) + Cluster/Glued Ball Detection
        for _, bNum in ipairs(st.legalList) do
            local ob = balls[bNum + 1]
            if ob and not ob.removed and not (kitchenRestricted and ob.p.Z > headZ) then
                local isGlued, gluedOther = hasGluedNeighbor(balls, bNum + 1, twoR * 1.45)

                for pIdx, pck in ipairs(pocketTargets) do
                    local yaw, pwr, d1, d2, cosCut, gx, gz = computeThrowAdjustedAim(cue.p, ob.p, pck.x, pck.z, cfg, 6.2)
                    if yaw then
                        local cueClear = isPathClear(balls, cue.p.X, cue.p.Z, gx, gz, 1, bNum + 1, twoR * 0.93)
                        local objClear = isPathClear(balls, ob.p.X, ob.p.Z, pck.x, pck.z, 1, bNum + 1, twoR * 0.92)
                        local mouthDot = -((pck.x - ob.p.X) * pck.fx + (pck.z - ob.p.Z) * pck.fz) / math.max(0.01, d2)

                        if cueClear and objClear and mouthDot > 0.12 then
                            local ease = (cosCut ^ 1.4) * (mouthDot ^ 0.8) / (1 + d1 * 0.12 + d2 * 0.18)
                            table.insert(directList, {
                                yaw = yaw,
                                power = pwr,
                                height = 0,
                                side = 0,
                                target = bNum,
                                pocket = pIdx,
                                isGlued = isGlued,
                                note = "Bola " .. tostring(bNum) .. " -> " .. (POCKET_NAMES[pIdx] or ("Cacapa " .. pIdx)),
                                spinName = "Centro",
                                priority = ease,
                            })
                        elseif cueClear and isGlued and mouthDot > 0.10 then
                            -- Glued ball near pocket line: test in clusterList with angle fan!
                            table.insert(clusterList, {
                                yaw = yaw,
                                power = math.clamp(pwr * 1.15, 0.25, 0.88),
                                height = 0,
                                side = 0,
                                target = bNum,
                                pocket = pIdx,
                                note = "Descolar Bola " .. tostring(bNum) .. " -> " .. (POCKET_NAMES[pIdx] or ("Cacapa " .. pIdx)),
                                spinName = "Centro (Colada)",
                                priority = cosCut / (1 + d1 * 0.15 + d2 * 0.2),
                            })
                        end
                    end
                end

                -- 2. Glued / Cluster Carom Fan (when 2 balls are glued together, test hitting our legal ball at multiple angles to carom/combo!)
                if isGlued then
                    local toObX = ob.p.X - cue.p.X
                    local toObZ = ob.p.Z - cue.p.Z
                    local dOb = math.sqrt(toObX * toObX + toObZ * toObZ)
                    if dOb > twoR and isPathClear(balls, cue.p.X, cue.p.Z, ob.p.X, ob.p.Z, 1, bNum + 1, twoR * 0.90) then
                        local centerYaw = math.atan2(toObX / dOb, -toObZ / dOb)
                        local maxCutAng = math.asin(math.min(0.92, twoR / dOb))
                        for _, frac in ipairs({ -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75 }) do
                            table.insert(clusterList, {
                                yaw = centerYaw + maxCutAng * frac,
                                power = 0.52,
                                height = 0,
                                side = 0,
                                target = bNum,
                                pocket = nil,
                                note = "Bola Colada " .. tostring(bNum) .. (gluedOther and (" + Bola " .. tostring(gluedOther)) or ""),
                                spinName = "Carambola / Descolar",
                                priority = 0.25 / (1 + dOb * 0.1),
                            })
                        end
                    end
                end
            end
        end

        -- 3. Two-Ball Combination Shots (Nossa Bola A -> Nossa Bola B -> Cacapa, e Carambola via qualquer bola!)
        if #st.legalList >= 2 then
            for _, bA in ipairs(st.legalList) do
                local obA = balls[bA + 1]
                if obA and not obA.removed and not (kitchenRestricted and obA.p.Z > headZ) then
                    for _, bB in ipairs(st.legalList) do
                        if bA ~= bB then
                            local obB = balls[bB + 1]
                            if obB and not obB.removed then
                                for pIdx, pck in ipairs(pocketTargets) do
                                    local bToPx = pck.x - obB.p.X
                                    local bToPz = pck.z - obB.p.Z
                                    local dBP = math.sqrt(bToPx * bToPx + bToPz * bToPz)
                                    if dBP > 0.08 and dBP < 7.5 then
                                        local dirBPx = bToPx / dBP
                                        local dirBPz = bToPz / dBP
                                        local gBx = obB.p.X - dirBPx * twoR
                                        local gBz = obB.p.Z - dirBPz * twoR
                                        local yawA, pwrA, dCG, dAG, cosCA, gAx, gAz = computeThrowAdjustedAim(cue.p, obA.p, gBx, gBz, cfg, 7.0)
                                        if yawA and dAG < 6.0 then
                                            local cosAB = ((gBx - obA.p.X) / math.max(0.01, dAG)) * dirBPx + ((gBz - obA.p.Z) / math.max(0.01, dAG)) * dirBPz
                                            if cosAB > 0.35 and cosCA > 0.30
                                                and isPathClear(balls, cue.p.X, cue.p.Z, gAx, gAz, 1, bA + 1, twoR * 0.92)
                                                and isPathClear(balls, obA.p.X, obA.p.Z, gBx, gBz, bA + 1, bB + 1, twoR * 0.90)
                                                and isPathClear(balls, obB.p.X, obB.p.Z, pck.x, pck.z, bA + 1, bB + 1, twoR * 0.92) then
                                                table.insert(comboList, {
                                                    yaw = yawA,
                                                    power = math.clamp(pwrA * 1.15, 0.28, 0.88),
                                                    height = 0,
                                                    side = 0,
                                                    target = bA,
                                                    pocket = pIdx,
                                                    note = "Combinada Bola " .. tostring(bA) .. " -> Bola " .. tostring(bB) .. " (" .. (POCKET_NAMES[pIdx] or ("Cacapa " .. pIdx)) .. ")",
                                                    spinName = "Centro (Combo)",
                                                    priority = (cosCA * cosAB) / (1 + dCG * 0.1 + dAG * 0.2 + dBP * 0.15),
                                                })
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        -- 4. 1-Rail Bank Shots (Tabelada na Bola Alvo: Nossa Bola -> Parede -> Cacapa)
        local walls = {
            { axis = "X", bound = halfW },
            { axis = "X", bound = -halfW },
            { axis = "Z", bound = halfL },
            { axis = "Z", bound = -halfL },
        }
        local reboundFactor = 1 / 0.82 -- Cushion restitution compensation

        for _, bNum in ipairs(st.legalList) do
            local ob = balls[bNum + 1]
            if ob and not ob.removed and not (kitchenRestricted and ob.p.Z > headZ) then
                for pIdx, pck in ipairs(pocketTargets) do
                    for _, w in ipairs(walls) do
                        local mirrorX, mirrorZ
                        if w.axis == "X" then
                            mirrorX = w.bound + (w.bound - pck.x) * reboundFactor
                            mirrorZ = pck.z
                        else
                            mirrorX = pck.x
                            mirrorZ = w.bound + (w.bound - pck.z) * reboundFactor
                        end
                        local dx = mirrorX - ob.p.X
                        local dz = mirrorZ - ob.p.Z
                        local d = math.sqrt(dx * dx + dz * dz)
                        if d > 0.2 then
                            local tWall = (w.axis == "X") and ((w.bound - ob.p.X) / dx) or ((w.bound - ob.p.Z) / dz)
                            if tWall > 0.08 and tWall < 0.92 then
                                local wx = ob.p.X + dx * tWall
                                local wz = ob.p.Z + dz * tWall
                                -- Ensure wall contact point isn't inside a side/corner pocket opening
                                local nearPocketOnWall = false
                                for _, p2 in ipairs(pocketTargets) do
                                    local pdx = wx - p2.cx
                                    local pdz = wz - p2.cz
                                    if (pdx * pdx + pdz * pdz) < 0.42 * 0.42 then
                                        nearPocketOnWall = true
                                        break
                                    end
                                end
                                if not nearPocketOnWall and math.abs(wx) <= halfW + 0.03 and math.abs(wz) <= halfL + 0.03 then
                                    local yaw, pwr, d1, _, cosCut, gx, gz = computeThrowAdjustedAim(cue.p, ob.p, wx, wz, cfg, 8.5)
                                    if yaw and cosCut > 0.28
                                        and isPathClear(balls, cue.p.X, cue.p.Z, gx, gz, 1, bNum + 1, twoR * 0.93)
                                        and isPathClear(balls, ob.p.X, ob.p.Z, wx, wz, 1, bNum + 1, twoR * 0.92)
                                        and isPathClear(balls, wx, wz, pck.x, pck.z, 1, bNum + 1, twoR * 0.92) then
                                        table.insert(bankList, {
                                            yaw = yaw,
                                            power = math.clamp(pwr * 1.18, 0.34, 0.90),
                                            height = 0,
                                            side = 0,
                                            target = bNum,
                                            pocket = pIdx,
                                            note = "Tabelada Bola " .. tostring(bNum) .. " -> " .. (POCKET_NAMES[pIdx] or ("Cacapa " .. pIdx)),
                                            spinName = "Centro (Tabela)",
                                            priority = cosCut / (1 + d1 * 0.12 + d * 0.18),
                                        })
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        -- 5. 1-Rail Kick Shots (Tabelada com a Branca: Branca -> Parede -> Nossa Bola -> Cacapa)
        for _, bNum in ipairs(st.legalList) do
            local ob = balls[bNum + 1]
            if ob and not ob.removed then
                for pIdx, pck in ipairs(pocketTargets) do
                    local toPx = pck.x - ob.p.X
                    local toPz = pck.z - ob.p.Z
                    local dP = math.sqrt(toPx * toPx + toPz * toPz)
                    if dP > 0.1 and isPathClear(balls, ob.p.X, ob.p.Z, pck.x, pck.z, 1, bNum + 1, twoR * 0.90) then
                        local gx = ob.p.X - (toPx / dP) * twoR
                        local gz = ob.p.Z - (toPz / dP) * twoR
                        for _, w in ipairs(walls) do
                            local mirrorGx, mirrorGz
                            if w.axis == "X" then
                                mirrorGx = w.bound + (w.bound - gx) * reboundFactor
                                mirrorGz = gz
                            else
                                mirrorGx = gx
                                mirrorGz = w.bound + (w.bound - gz) * reboundFactor
                            end
                            local dx = mirrorGx - cue.p.X
                            local dz = mirrorGz - cue.p.Z
                            local d = math.sqrt(dx * dx + dz * dz)
                            if d > 0.2 then
                                local tWall = (w.axis == "X") and ((w.bound - cue.p.X) / dx) or ((w.bound - cue.p.Z) / dz)
                                if tWall > 0.08 and tWall < 0.92 then
                                    local wx = cue.p.X + dx * tWall
                                    local wz = cue.p.Z + dz * tWall
                                    if math.abs(wx) <= halfW + 0.03 and math.abs(wz) <= halfL + 0.03
                                        and isPathClear(balls, cue.p.X, cue.p.Z, wx, wz, 1, nil, twoR * 0.92)
                                        and isPathClear(balls, wx, wz, gx, gz, 1, bNum + 1, twoR * 0.90) then
                                        local kickDirX = (gx - wx)
                                        local kickDirZ = (gz - wz)
                                        local kd = math.sqrt(kickDirX * kickDirX + kickDirZ * kickDirZ)
                                        local cosKickCut = kd > 1e-4 and ((kickDirX / kd) * (toPx / dP) + (kickDirZ / kd) * (toPz / dP)) or 0
                                        if cosKickCut > 0.15 then
                                            local yaw = math.atan2(dx / d, -dz / d)
                                            local pwr = math.clamp(0.42 + (d + dP) * 0.032, 0.35, 0.90)
                                            table.insert(kickList, {
                                                yaw = yaw,
                                                power = pwr,
                                                height = 0,
                                                side = 0,
                                                target = bNum,
                                                pocket = pIdx,
                                                note = "Tabela Branca -> Bola " .. tostring(bNum) .. " (" .. (POCKET_NAMES[pIdx] or ("Cacapa " .. pIdx)) .. ")",
                                                spinName = "Tabela na Branca",
                                                priority = cosKickCut / (1 + d * 0.15 + dP * 0.15),
                                            })
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        local function sortByPriority(t)
            table.sort(t, function(a, b)
                return (a.priority or 0) > (b.priority or 0)
            end)
        end
        sortByPriority(directList)
        sortByPriority(clusterList)
        sortByPriority(comboList)
        sortByPriority(bankList)
        sortByPriority(kickList)

        return directList, clusterList, comboList, bankList, kickList
    end

    local function solveBestShot(st)
        local botInput = {
            balls = st.balls,
            match = st.match,
            seat = st.solverSeat,
            config = st.cfg,
            mode = st.solverMode,
        }
        local zeroNoiseRng = function()
            return 0.25
        end

        local lastYieldClock = os.clock()
        local function checkYield()
            local now = os.clock()
            if (now - lastYieldClock) >= 0.0035 then
                task.wait()
                lastYieldClock = os.clock()
            end
        end

        -- Handle Penalty, BallInHand, or Opening Break first
        if st.match.phase == "Penalty" or st.match.phase == "BallInHand" or st.balls[1].removed or st.match.breaking then
            local basePlan = BotBrain.plan(botInput, {
                Physics = BallPhysics,
                ShotMath = ShotMath,
                Match = MatchRules,
                Config = st.cfg,
                rng = zeroNoiseRng,
                skill = 1,
                simStep = st.cfg.PhysicsStep or (1 / 240),
                maxSims = 28,
                timeBudget = 0.28,
                yield = task.wait,
                yieldEvery = 0.0035,
                params = {
                    aimSigmaDeg = 0.0005,
                    powerSigma = 0,
                    spinSigma = 0,
                    blunder = 0,
                    sims = 24,
                    positional = 1,
                    safety = 1,
                },
            })
            if basePlan and st.match.breaking and basePlan.kind == "shot" then
                basePlan.power = 0.98
                basePlan.hitHeight = 0.15
                basePlan.hitSide = 0
                basePlan.spinName = "Saida Maxima"
                basePlan.pottedCount = 1
            end
            return basePlan
        end

        local directList, clusterList, comboList, bankList, kickList = generateAllShotCandidates(st)
        local bestPotCandidate = nil
        local bestPotScore = -1e9
        local bestSafeCandidate = nil
        local bestSafeScore = -1e9

        local function evaluateAndRecord(yaw, power, h, s, targetNum, pocketIdx, labelNote, spinLabel, exact240)
            checkYield()
            local simRes, elev, effH, effS = simulateShotExact(st, yaw, power, h, s, exact240)
            lastYieldClock = os.clock()
            if not simRes then return nil, false end

            if simRes.foul or (simRes.finished and not simRes.won) then
                return simRes, false
            end

            local potted = simRes.potted or 0
            local isPot = (simRes.won == true) or (simRes.continues == true and potted >= 1)

            if isPot then
                -- If screened at 1/120, MUST re-verify at exact 1/240 server physics before accepting!
                if not exact240 then
                    checkYield()
                    local exactRes, exactElev, exactH, exactS = simulateShotExact(st, yaw, power, h, s, true)
                    lastYieldClock = os.clock()
                    if not exactRes or exactRes.foul or not (exactRes.won or (exactRes.continues and (exactRes.potted or 0) >= 1)) then
                        return exactRes, false
                    end
                    simRes, elev, effH, effS = exactRes, exactElev, exactH, exactS
                    potted = simRes.potted or 0
                end

                local nextQ = evaluateNextPositionQuality(simRes.balls, st.legalList, st.cfg)
                local score = (simRes.won and 10000 or 500)
                    + (potted * 95)
                    + (nextQ * 55)
                    - (power * 4)

                if score > bestPotScore then
                    bestPotScore = score
                    bestPotCandidate = {
                        kind = "shot",
                        yaw = yaw,
                        power = power,
                        elevation = elev,
                        hitHeight = effH,
                        hitSide = effS,
                        target = targetNum or simRes.first,
                        pocket = pocketIdx,
                        pottedCount = potted,
                        continues = true,
                        foul = false,
                        won = simRes.won,
                        note = labelNote,
                        spinName = spinLabel or "Centro",
                        score = score,
                    }
                end
                return simRes, true
            else
                -- Legal safety/contact shot (no foul, didn't pot)
                local nextQ = evaluateNextPositionQuality(simRes.balls, st.legalList, st.cfg)
                local safeScore = 10 - (power * 3) + (nextQ * 5)
                if safeScore > bestSafeScore then
                    bestSafeScore = safeScore
                    bestSafeCandidate = {
                        kind = "shot",
                        yaw = yaw,
                        power = power,
                        elevation = elev,
                        hitHeight = effH,
                        hitSide = effS,
                        target = targetNum or simRes.first,
                        pocket = pocketIdx,
                        pottedCount = 0,
                        continues = false,
                        foul = false,
                        won = false,
                        note = "Defesa / Descolar: " .. tostring(labelNote),
                        spinName = spinLabel or "Seguranca",
                        score = safeScore,
                    }
                end
                return simRes, false
            end
        end

        -- Phase 1: Test Direct Shots (non-blocking with smart early exit once best direct pots are confirmed)
        local directAngles = { 0, -0.0022, 0.0022, -0.005, 0.005, -0.009, 0.009 }
        local confirmedDirectPots = 0
        local bestDirectAngle = nil
        local bestDirectPower = nil
        local bestDirectCand = nil

        for i = 1, math.min(#directList, 9) do
            local c = directList[i]
            local angles = c.isGlued and { 0, -0.003, 0.003, -0.007, 0.007, -0.014, 0.014 } or directAngles
            local foundAngle = nil
            local foundPwr = c.power
            for _, dYaw in ipairs(angles) do
                local _, potted = evaluateAndRecord(c.yaw + dYaw, c.power, 0, 0, c.target, c.pocket, c.note, c.spinName, false)
                if potted then
                    foundAngle = c.yaw + dYaw
                    break
                end
                local pwr2 = math.clamp(c.power * 1.22, st.cfg.MinShotPower, 0.95)
                local _, potted2 = evaluateAndRecord(c.yaw + dYaw, pwr2, 0, 0, c.target, c.pocket, c.note, c.spinName, false)
                if potted2 then
                    foundAngle = c.yaw + dYaw
                    foundPwr = pwr2
                    break
                end
            end

            if foundAngle then
                confirmedDirectPots = confirmedDirectPots + 1
                if not bestDirectAngle then
                    bestDirectAngle = foundAngle
                    bestDirectPower = foundPwr
                    bestDirectCand = c
                end
                -- Early stop once we have 2 confirmed direct pots or 1 high-priority easy pot
                if confirmedDirectPots >= 2 or (c.priority or 0) >= 0.22 then
                    break
                end
            end
        end

        -- Optimize Spin & Next-Ball Position only on the best confirmed direct pot (4 key spins)
        if bestDirectAngle and bestDirectCand then
            for sIdx = 2, math.min(#SPIN_PROFILES, 5) do
                local sp = SPIN_PROFILES[sIdx]
                local pwr = math.clamp(bestDirectPower * sp.m, st.cfg.MinShotPower, 0.96)
                evaluateAndRecord(bestDirectAngle, pwr, sp.h, sp.s, bestDirectCand.target, bestDirectCand.pocket, bestDirectCand.note, sp.name, true)
            end
        end

        -- Phase 2: Test Two-Ball Combinations (check top 3 for multi-ball combos if direct pot exists, or top 10 if no pot yet)
        local maxCombos = bestPotCandidate and 3 or 10
        for i = 1, math.min(#comboList, maxCombos) do
            local c = comboList[i]
            for _, dYaw in ipairs({ 0, -0.003, 0.003, -0.007, 0.007 }) do
                local _, potted = evaluateAndRecord(c.yaw + dYaw, c.power, 0, 0, c.target, c.pocket, c.note, c.spinName, false)
                if potted then break end
            end
        end

        -- Phase 3: Test Glued / Cluster Carom Shots ("2 bola colada") when no clean direct/combo pot was found
        if not bestPotCandidate then
            for i = 1, math.min(#clusterList, 14) do
                local c = clusterList[i]
                for _, dYaw in ipairs({ 0, -0.005, 0.005, -0.012, 0.012 }) do
                    for _, pMult in ipairs({ 1.0, 1.28 }) do
                        local pwr = math.clamp(c.power * pMult, 0.25, 0.92)
                        local _, potted = evaluateAndRecord(c.yaw + dYaw, pwr, 0, 0, c.target, c.pocket, c.note, c.spinName, false)
                        if potted then break end
                    end
                end
                if bestPotCandidate then break end
            end
        end

        -- Phase 4: Test 1-Rail Bank Shots ("Tabelada na Bola Alvo") when no direct/combo/cluster pot was found
        if not bestPotCandidate then
            for i = 1, math.min(#bankList, 14) do
                local c = bankList[i]
                for _, dYaw in ipairs({ 0, -0.005, 0.005, -0.012, 0.012, -0.022, 0.022 }) do
                    for _, pMult in ipairs({ 1.0, 1.18, 0.86 }) do
                        local pwr = math.clamp(c.power * pMult, 0.28, 0.92)
                        local _, potted = evaluateAndRecord(c.yaw + dYaw, pwr, 0, 0, c.target, c.pocket, c.note, c.spinName, false)
                        if potted then break end
                    end
                end
                if bestPotCandidate then break end
            end
        end

        -- Phase 5: Test 1-Rail Kick Shots ("Tabelada com a Branca") when snookered or no pot found yet
        if not bestPotCandidate then
            for i = 1, math.min(#kickList, 16) do
                local c = kickList[i]
                for _, dYaw in ipairs({ 0, -0.006, 0.006, -0.014, 0.014, -0.025, 0.025 }) do
                    for _, pMult in ipairs({ 1.0, 1.20 }) do
                        local pwr = math.clamp(c.power * pMult, 0.30, 0.92)
                        local _, potted = evaluateAndRecord(c.yaw + dYaw, pwr, 0, 0, c.target, c.pocket, c.note, c.spinName, false)
                        if potted then break end
                    end
                end
                if bestPotCandidate then break end
            end
        end

        if bestPotCandidate then
            return bestPotCandidate
        end

        -- Phase 6: Fallback to BotBrain's safety/kick planner if completely snookered
        local fallbackPlan = BotBrain.plan(botInput, {
            Physics = BallPhysics,
            ShotMath = ShotMath,
            Match = MatchRules,
            Config = st.cfg,
            rng = zeroNoiseRng,
            skill = 1,
            simStep = st.cfg.PhysicsStep or (1 / 240),
            maxSims = 24,
            timeBudget = 0.25,
            yield = task.wait,
            yieldEvery = 0.0035,
            params = {
                aimSigmaDeg = 0.0005,
                powerSigma = 0,
                spinSigma = 0,
                blunder = 0,
                sims = 22,
                positional = 1,
                safety = 1,
            },
        })
        if fallbackPlan and fallbackPlan.kind == "shot" then
            evaluateAndRecord(
                fallbackPlan.yaw,
                fallbackPlan.power,
                fallbackPlan.hitHeight or 0,
                fallbackPlan.hitSide or 0,
                fallbackPlan.target,
                fallbackPlan.pocket,
                fallbackPlan.note or "Tacada de Seguranca",
                "Defesa",
                true
            )
        end

        return bestPotCandidate or bestSafeCandidate or fallbackPlan
    end

    -- GUI Construction
    local guiParent = (type(gethui) == "function" and gethui())
        or (pcall(function() return CoreGui.Name end) and CoreGui)
        or lp:WaitForChild("PlayerGui")

    local oldGui = guiParent:FindFirstChild("SidespinAutoBotGui")
    if oldGui then oldGui:Destroy() end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SidespinAutoBotGui"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999
    screenGui.Parent = guiParent

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.fromOffset(290, 238)
    mainFrame.Position = UDim2.new(1, -310, 0, 70)
    mainFrame.BackgroundColor3 = Color3.fromRGB(16, 18, 24)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Parent = screenGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainFrame

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(218, 175, 72)
    mainStroke.Thickness = 1.6
    mainStroke.Transparency = 0.15
    mainStroke.Parent = mainFrame

    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 32)
    topBar.BackgroundColor3 = Color3.fromRGB(24, 28, 36)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame

    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 10)
    topCorner.Parent = topBar

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -44, 1, 0)
    titleLbl.Position = UDim2.fromOffset(12, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextColor3 = Color3.fromRGB(245, 208, 96)
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Text = "SIDESPIN AUTO-BOT v2.2"
    titleLbl.Parent = topBar

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.fromOffset(26, 24)
    minBtn.Position = UDim2.new(1, -30, 0, 4)
    minBtn.BackgroundColor3 = Color3.fromRGB(36, 42, 54)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 14
    minBtn.TextColor3 = Color3.fromRGB(220, 225, 235)
    minBtn.Text = "-"
    minBtn.Parent = topBar
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 6)
    minCorner.Parent = minBtn

    local bodyFrame = Instance.new("Frame")
    bodyFrame.Name = "Body"
    bodyFrame.Size = UDim2.new(1, -20, 1, -40)
    bodyFrame.Position = UDim2.fromOffset(10, 36)
    bodyFrame.BackgroundTransparency = 1
    bodyFrame.Parent = mainFrame

    local function makeInfoRow(yPos, text, color, bold)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 18)
        lbl.Position = UDim2.fromOffset(0, yPos)
        lbl.BackgroundTransparency = 1
        lbl.Font = bold and Enum.Font.GothamBold or Enum.Font.GothamMedium
        lbl.TextSize = 12
        lbl.TextColor3 = color
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextTruncate = Enum.TextTruncate.AtEnd
        lbl.Text = text
        lbl.Parent = bodyFrame
        return lbl
    end

    local statusLbl = makeInfoRow(0, "Status: Pronto", Color3.fromRGB(130, 230, 155), true)
    local groupLbl = makeInfoRow(20, "Nosso Grupo: -", Color3.fromRGB(215, 222, 235), false)
    local planLbl = makeInfoRow(40, "Alvo: -", Color3.fromRGB(250, 210, 95), true)
    local powerLbl = makeInfoRow(60, "Forca: - | Efeito: Centro", Color3.fromRGB(180, 195, 215), false)

    local function makeButton(yPos, xScale, wScale, height, text, bgCol)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(wScale, -4, 0, height)
        btn.Position = UDim2.new(xScale, xScale > 0 and 4 or 0, 0, yPos)
        btn.BackgroundColor3 = bgCol
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = text
        btn.AutoButtonColor = true
        btn.Parent = bodyFrame
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 7)
        c.Parent = btn
        return btn
    end

    local autoBtn = makeButton(86, 0, 1, 34, "AUTO PLAY BOT: OFF", Color3.fromRGB(170, 52, 58))
    local aimBtn = makeButton(126, 0, 0.5, 32, "SO MIRAR", Color3.fromRGB(48, 108, 185))
    local shootBtn = makeButton(126, 0.5, 0.5, 32, "TACAR 1X", Color3.fromRGB(195, 142, 42))
    local speedBtn = makeButton(164, 0, 1, 26, "MODO: DEUS (RAPIDO & PERFEITO)", Color3.fromRGB(45, 52, 68))

    -- Dragging support
    local dragging = false
    local dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        bodyFrame.Visible = not minimized
        mainFrame.Size = minimized and UDim2.fromOffset(290, 32) or UDim2.fromOffset(290, 238)
        minBtn.Text = minimized and "+" or "-"
    end)

    local function refreshGuiLabels()
        if not screenGui.Parent then return end
        statusLbl.Text = "Status: " .. tostring(BotState.statusText)
        groupLbl.Text = "Nosso Grupo: " .. tostring(BotState.groupText)
        planLbl.Text = tostring(BotState.planText)
        powerLbl.Text = tostring(BotState.powerText)
    end

    local function applyAimOrShoot(aimOnly)
        if BotState.busy then return false end
        local st = readLiveTableState()
        if not st then
            BotState.statusText = "Sem mesa ativa"
            refreshGuiLabels()
            return false
        end

        BotState.groupText = st.groupLabel
        if not st.isMyTurn then
            BotState.statusText = "Aguardando nossa vez..."
            refreshGuiLabels()
            return false
        end
        if not st.allStopped and st.match.phase ~= "Penalty" then
            BotState.statusText = "Bolas em movimento..."
            refreshGuiLabels()
            return false
        end

        BotState.busy = true
        BotState.statusText = "Calculando jogada perfeita..."
        refreshGuiLabels()

        local okSolve, plan = pcall(solveBestShot, st)
        if not okSolve or not plan then
            BotState.statusText = "Erro no calculo"
            BotState.busy = false
            refreshGuiLabels()
            return false
        end

        if plan.kind == "penalty" and plan.ball then
            BotState.planText = "Penalidade: Escolhendo Bola " .. tostring(plan.ball)
            BotState.statusText = "Retirando bola de penalidade..."
            refreshGuiLabels()
            if not aimOnly then
                CueAction:FireServer("Penalty", 0, plan.ball)
                task.wait(0.6)
            end
            BotState.busy = false
            return true
        elseif plan.kind == "place" and plan.position then
            BotState.planText = string.format("Posicionar Branca: (%.2f, %.2f)", plan.position.X, plan.position.Z)
            BotState.statusText = "Posicionando bola branca..."
            refreshGuiLabels()
            CueAction:FireServer("PlaceWhite", 0, plan.position)
            task.wait(0.55)
            BotState.busy = false
            return true
        elseif plan.kind == "shot" then
            local pwrPct = math.floor((plan.power or 0.5) * 100 + 0.5)
            local pottedInfo = (plan.pottedCount and plan.pottedCount >= 2)
                and (" [COMBO " .. tostring(plan.pottedCount) .. " BOLAS!]")
                or ""
            BotState.planText = tostring(plan.note or "Tacada") .. pottedInfo
            BotState.powerText = string.format("Forca: %d%% | %s (H:%.2f S:%.2f)", pwrPct, tostring(plan.spinName or "Centro"), plan.hitHeight or 0, plan.hitSide or 0)
            BotState.statusText = aimOnly and "Mira travada no alvo!" or "Mirando e tacando..."
            refreshGuiLabels()

            local u6, selectBallFn = findClientHooks()
            if selectBallFn and u6 then
                local dirVec = ShotMath.horizontalDirection(plan.yaw)
                local targetH = plan.hitHeight or 0
                local targetS = plan.hitSide or 0
                local defaultElev = ShotMath.autoElevation(st.balls[1].p, plan.yaw, 0, 0, st.cfg)
                local targetElev = plan.elevation or defaultElev

                _G.SidespinLockedShot = {
                    dir = dirVec,
                    power = plan.power,
                    yaw = plan.yaw,
                    elevation = targetElev,
                    hitHeight = targetH,
                    hitSide = targetS,
                    expiresAt = os.clock() + 6.5,
                }

                local curState = debug.getupvalue(selectBallFn, 3)
                local prevYaw = debug.getupvalue(selectBallFn, 20)
                if curState ~= "Idle" then
                    local curSession = debug.getupvalue(selectBallFn, 11)
                    if curSession then
                        CueAction:FireServer("Cancel", curSession)
                    end
                    debug.setupvalue(selectBallFn, 3, "Idle")
                end
                debug.setupvalue(selectBallFn, 4, 0)

                -- Determine starting angle for smooth Legit cue movement
                local startYaw = plan.yaw
                if not BotState.fastMode and not aimOnly then
                    if type(prevYaw) == "number" then
                        local diff = ((plan.yaw - prevYaw + math.pi) % (2 * math.pi)) - math.pi
                        if math.abs(diff) > 0.08 and math.abs(diff) < 1.35 then
                            startYaw = prevYaw
                        else
                            startYaw = plan.yaw + (diff >= 0 and -1 or 1) * 0.48
                        end
                    else
                        local cam = workspace.CurrentCamera
                        if cam and st.cueBallPart then
                            local camToCue = st.cueBallPart.Position - cam.CFrame.Position
                            if camToCue.Magnitude > 0.1 then
                                local camYaw = math.atan2(camToCue.X, -camToCue.Z)
                                local diff = ((plan.yaw - camYaw + math.pi) % (2 * math.pi)) - math.pi
                                if math.abs(diff) > 0.08 and math.abs(diff) < 1.35 then
                                    startYaw = camYaw
                                else
                                    startYaw = plan.yaw + (math.random() < 0.5 and -1 or 1) * 0.45
                                end
                            else
                                startYaw = plan.yaw + 0.42
                            end
                        else
                            startYaw = plan.yaw + 0.42
                        end
                    end
                end

                local initDir = ShotMath.horizontalDirection(startYaw)
                local char = lp.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and st.cueBallPart then
                    local standPos = st.cueBallPart.Position - initDir * 3.2
                    hrp.CFrame = CFrame.lookAt(
                        Vector3.new(standPos.X, hrp.Position.Y, standPos.Z),
                        Vector3.new(st.cueBallPart.Position.X, hrp.Position.Y, st.cueBallPart.Position.Z)
                    )
                end

                selectBallFn(initDir)

                local newSession = debug.getupvalue(selectBallFn, 11)
                if newSession then
                    local animYaw = startYaw
                    local animDir = initDir
                    local animPower = (BotState.fastMode or aimOnly) and plan.power or 0
                    local animH = (BotState.fastMode or aimOnly) and targetH or 0
                    local animS = (BotState.fastMode or aimOnly) and targetS or 0
                    local animElev = (BotState.fastMode or aimOnly) and targetElev or defaultElev
                    local animState = nil

                    local function enforceAimUpvalues()
                        if animState then
                            debug.setupvalue(selectBallFn, 3, animState)
                        end
                        debug.setupvalue(selectBallFn, 15, animDir)
                        debug.setupvalue(selectBallFn, 16, animPower)
                        debug.setupvalue(selectBallFn, 20, animYaw)
                        debug.setupvalue(selectBallFn, 21, animElev)
                        debug.setupvalue(selectBallFn, 23, animElev)
                        debug.setupvalue(selectBallFn, 24, animH)
                        debug.setupvalue(selectBallFn, 25, animS)
                    end

                    enforceAimUpvalues()
                    rawset(u6, "paintedGuide", nil)
                    rawset(u6, "paintedTime", nil)

                    if aimOnly then
                        _G.SidespinLockedShot = nil
                    elseif BotState.fastMode then
                        -- MODO: DEUS (Instant & Perfect)
                        local lockConn = RunService.RenderStepped:Connect(function()
                            if debug.getupvalue(selectBallFn, 11) == newSession then
                                enforceAimUpvalues()
                            end
                        end)
                        task.wait(0.22)
                        if lockConn then lockConn:Disconnect() end

                        if debug.getupvalue(selectBallFn, 11) == newSession then
                            enforceAimUpvalues()
                            debug.setupvalue(selectBallFn, 3, "AwaitingStrike")
                            if u6.optimistic == newSession then
                                u6.pendingRelease = newSession
                            else
                                CueAction:FireServer("Release", newSession, {
                                    power = plan.power,
                                    yaw = plan.yaw,
                                    elevation = targetElev,
                                    hitHeight = targetH,
                                    hitSide = targetS,
                                })
                            end
                            BotState.statusText = "Tacada enviada!"
                            refreshGuiLabels()
                            task.wait(0.8)
                        end
                    else
                        -- MODO: LEGIT (Full Humanized Cue Aiming + Contact Spin + Power Pullback)
                        local lockConn = RunService.RenderStepped:Connect(function()
                            if debug.getupvalue(selectBallFn, 11) == newSession then
                                enforceAimUpvalues()
                            end
                        end)

                        -- Stage 1: Smoothly move cue stick & character around the table to the target aim angle
                        BotState.statusText = "Legit: Movendo taco para a mira..."
                        refreshGuiLabels()
                        local yawDiff = ((plan.yaw - startYaw + math.pi) % (2 * math.pi)) - math.pi
                        local aimDuration = math.clamp(0.48 + math.abs(yawDiff) * 0.45, 0.52, 0.92)
                        local t0 = os.clock()
                        while (os.clock() - t0) < aimDuration and debug.getupvalue(selectBallFn, 11) == newSession do
                            local alpha = math.clamp((os.clock() - t0) / aimDuration, 0, 1)
                            local smooth = alpha * alpha * (3 - 2 * alpha)
                            animYaw = startYaw + yawDiff * smooth
                            animDir = ShotMath.horizontalDirection(animYaw)
                            if hrp and st.cueBallPart then
                                local standPos = st.cueBallPart.Position - animDir * 3.2
                                hrp.CFrame = CFrame.lookAt(
                                    Vector3.new(standPos.X, hrp.Position.Y, standPos.Z),
                                    Vector3.new(st.cueBallPart.Position.X, hrp.Position.Y, st.cueBallPart.Position.Z)
                                )
                            end
                            rawset(u6, "paintedGuide", nil)
                            rawset(u6, "paintedTime", nil)
                            RunService.RenderStepped:Wait()
                        end
                        animYaw = plan.yaw
                        animDir = dirVec
                        rawset(u6, "paintedGuide", nil)
                        rawset(u6, "paintedTime", nil)
                        task.wait(0.12)

                        -- Stage 2: Smoothly adjust contact point (spin dot on cue ball) & cue elevation
                        if (math.abs(targetH) > 0.005 or math.abs(targetS) > 0.005 or math.abs(targetElev - defaultElev) > 0.005)
                            and debug.getupvalue(selectBallFn, 11) == newSession then
                            BotState.statusText = "Legit: Ajustando efeito na branca..."
                            refreshGuiLabels()
                            local spinDuration = 0.36
                            local ts = os.clock()
                            while (os.clock() - ts) < spinDuration and debug.getupvalue(selectBallFn, 11) == newSession do
                                local alpha = math.clamp((os.clock() - ts) / spinDuration, 0, 1)
                                local smooth = alpha * alpha * (3 - 2 * alpha)
                                animH = targetH * smooth
                                animS = targetS * smooth
                                animElev = defaultElev + (targetElev - defaultElev) * smooth
                                rawset(u6, "paintedGuide", nil)
                                rawset(u6, "paintedTime", nil)
                                RunService.RenderStepped:Wait()
                            end
                        end
                        animH = targetH
                        animS = targetS
                        animElev = targetElev
                        rawset(u6, "paintedGuide", nil)
                        rawset(u6, "paintedTime", nil)
                        task.wait(0.10)

                        -- Stage 3: Wait briefly if server hasn't confirmed "Ready" yet, then smoothly pull back cue & fill power bar
                        local waitReadyStart = os.clock()
                        while u6.optimistic == newSession and (os.clock() - waitReadyStart) < 0.45 do
                            RunService.RenderStepped:Wait()
                        end

                        if debug.getupvalue(selectBallFn, 11) == newSession then
                            BotState.statusText = string.format("Legit: Ajustando forca (%d%%)...", pwrPct)
                            refreshGuiLabels()
                            animState = "Charging"
                            debug.setupvalue(selectBallFn, 19, os.clock())
                            local chargeDuration = math.clamp(0.45 + plan.power * 0.35, 0.50, 0.82)
                            local tc = os.clock()
                            while (os.clock() - tc) < chargeDuration and debug.getupvalue(selectBallFn, 11) == newSession do
                                local alpha = math.clamp((os.clock() - tc) / chargeDuration, 0, 1)
                                local smooth = 1 - ((1 - alpha) ^ 2.2)
                                animPower = plan.power * smooth
                                RunService.RenderStepped:Wait()
                            end
                            animPower = plan.power
                            task.wait(0.14)
                        end

                        if lockConn then lockConn:Disconnect() end

                        if debug.getupvalue(selectBallFn, 11) == newSession then
                            animState = nil
                            enforceAimUpvalues()
                            debug.setupvalue(selectBallFn, 3, "AwaitingStrike")
                            if u6.optimistic == newSession then
                                u6.pendingRelease = newSession
                            else
                                CueAction:FireServer("Release", newSession, {
                                    power = plan.power,
                                    yaw = plan.yaw,
                                    elevation = targetElev,
                                    hitHeight = targetH,
                                    hitSide = targetS,
                                })
                            end
                            BotState.statusText = "Tacada enviada!"
                            refreshGuiLabels()
                            task.wait(0.8)
                        end
                    end
                else
                    _G.SidespinLockedShot = nil
                end
            end
            BotState.busy = false
            return true
        end

        BotState.statusText = tostring(plan.note or "Aguardando")
        refreshGuiLabels()
        BotState.busy = false
        return false
    end

    autoBtn.MouseButton1Click:Connect(function()
        BotState.autoPlay = not BotState.autoPlay
        if BotState.autoPlay then
            autoBtn.Text = "AUTO PLAY BOT: ON"
            autoBtn.BackgroundColor3 = Color3.fromRGB(46, 155, 82)
            BotState.statusText = "Auto-Play Ativado!"
        else
            autoBtn.Text = "AUTO PLAY BOT: OFF"
            autoBtn.BackgroundColor3 = Color3.fromRGB(170, 52, 58)
            BotState.statusText = "Auto-Play Pausado"
        end
        refreshGuiLabels()
    end)

    aimBtn.MouseButton1Click:Connect(function()
        task.spawn(applyAimOrShoot, true)
    end)

    shootBtn.MouseButton1Click:Connect(function()
        task.spawn(applyAimOrShoot, false)
    end)

    speedBtn.MouseButton1Click:Connect(function()
        BotState.fastMode = not BotState.fastMode
        if BotState.fastMode then
            speedBtn.Text = "MODO: DEUS (RAPIDO & PERFEITO)"
            speedBtn.BackgroundColor3 = Color3.fromRGB(45, 52, 68)
        else
            speedBtn.Text = "MODO: LEGIT (DELAY HUMANIZADO)"
            speedBtn.BackgroundColor3 = Color3.fromRGB(78, 65, 42)
        end
    end)

    _G.SidespinAutoBotCleanup = function()
        BotState.running = false
        BotState.autoPlay = false
        if screenGui and screenGui.Parent then
            screenGui:Destroy()
        end
    end

    _G.SidespinBotShootOnce = function(aimOnly)
        return applyAimOrShoot(aimOnly == true)
    end

    _G.SidespinBotSetAuto = function(enabled)
        BotState.autoPlay = (enabled == true)
        if BotState.autoPlay then
            autoBtn.Text = "AUTO PLAY BOT: ON"
            autoBtn.BackgroundColor3 = Color3.fromRGB(46, 155, 82)
        else
            autoBtn.Text = "AUTO PLAY BOT: OFF"
            autoBtn.BackgroundColor3 = Color3.fromRGB(170, 52, 58)
        end
        refreshGuiLabels()
    end

    task.spawn(function()
        while BotState.running do
            task.wait(0.35)
            pcall(function()
                if not BotState.busy then
                    local st = readLiveTableState()
                    if st then
                        BotState.groupText = st.groupLabel
                        if BotState.autoPlay then
                            if st.isMyTurn and (st.allStopped or st.match.phase == "Penalty") and st.activeBalls > 0 then
                                applyAimOrShoot(false)
                            elseif not st.isMyTurn then
                                BotState.statusText = "Vez do adversario..."
                            elseif not st.allStopped then
                                BotState.statusText = "Aguardando bolas pararem..."
                            end
                        end
                        refreshGuiLabels()
                    end
                end
            end)
        end
    end)
end

installAutoPlayBot()
_G.SidespinUnlockAllVersion = "2.2"

if _G.SidespinUnlockAllLoaded then
    if type(_G.SidespinForceSync) == "function" then
        pcall(_G.SidespinForceSync)
    end
    return
end
_G.SidespinUnlockAllLoaded = true

local Remotes = Sinuca:WaitForChild("Remotes", 10)
local ProgressRequest = Remotes and Remotes:FindFirstChild("ProgressRequest")
local LobbyRequest = Remotes and Remotes:FindFirstChild("LobbyRequest")

local Catalog = safeRequire(Sinuca:FindFirstChild("Catalog"))
local TableSkins = safeRequire(Sinuca:FindFirstChild("TableSkins"))
local CueSkins = safeRequire(Sinuca:FindFirstChild("CueSkins"))
local SceneSkins = safeRequire(Sinuca:FindFirstChild("SceneSkins"))
local SceneRuntime = safeRequire(Sinuca:FindFirstChild("SceneRuntime"))
local TableMorph = safeRequire(Sinuca:FindFirstChild("TableMorph"))

local SAVE_FILE = "sidespin_saved_preset.json"

local State = {
    allItems = {
        tables = {},
        cues = {},
        scenes = {},
    },
    allMaps = {
        tables = {},
        cues = {},
        scenes = {},
    },
    serverOwned = {
        tables = { Classic = true },
        cues = { Classic = true },
        scenes = { Classic = true },
    },
    customEquipped = {
        tables = lp:GetAttribute("TableSkin") or "Classic",
        cues = lp:GetAttribute("EquippedCue") or "Classic",
        scenes = lp:GetAttribute("EquippedScene") or "Classic",
        title = "",
    },
    progressClients = {},
    mainMenus = {},
    peerConfigs = {},
    peerSeq = {},
    mySeq = 0,
    lastBroadcastHash = "",
    lastBroadcastTime = 0,
    applyingAttrs = false,
}

-- 1. Build complete item lists from Catalog & Skins modules
local function buildCatalogLists()
    local kinds = {
        { key = "tables", mod = TableSkins },
        { key = "cues", mod = CueSkins },
        { key = "scenes", mod = SceneSkins },
    }
    for _, info in ipairs(kinds) do
        local kind = info.key
        local list = {}
        local map = {}
        local function addId(id)
            if type(id) == "string" and id ~= "" and not map[id] then
                map[id] = true
                table.insert(list, id)
            end
        end
        addId("Classic")
        if info.mod and type(info.mod.list) == "table" then
            for _, entry in ipairs(info.mod.list) do
                if type(entry) == "table" and entry.id then
                    addId(entry.id)
                end
            end
        end
        if Catalog and type(Catalog.looks) == "table" and Catalog.looks[kind] and type(Catalog.looks[kind].list) == "table" then
            for _, entry in ipairs(Catalog.looks[kind].list) do
                if type(entry) == "table" and entry.id then
                    addId(entry.id)
                end
            end
        end
        State.allItems[kind] = list
        State.allMaps[kind] = map
    end
end

buildCatalogLists()

-- 2. Save / Load persistent preset
local function loadSavedPreset()
    pcall(function()
        if type(isfile) == "function" and type(readfile) == "function" and isfile(SAVE_FILE) then
            local raw = readfile(SAVE_FILE)
            local data = HttpService:JSONDecode(raw)
            if type(data) == "table" then
                for _, kind in ipairs({ "tables", "cues", "scenes" }) do
                    if type(data[kind]) == "string" and State.allMaps[kind][data[kind]] then
                        State.customEquipped[kind] = data[kind]
                    end
                end
                if type(data.title) == "string" then
                    State.customEquipped.title = data.title
                end
            end
        end
    end)
end

local function savePreset()
    pcall(function()
        if type(writefile) == "function" then
            writefile(SAVE_FILE, HttpService:JSONEncode(State.customEquipped))
        end
    end)
end

loadSavedPreset()

-- 3. Patch Catalog ownership & availability functions
if Catalog then
    if not Catalog._origOwned then
        Catalog._origOwned = Catalog.owned
        Catalog._origAvailable = Catalog.available
        Catalog._origIsWithdrawn = Catalog.isWithdrawn
    end
    Catalog.owned = function(state, kind, id)
        if type(kind) == "string" and type(id) == "string" and State.allMaps[kind] and State.allMaps[kind][id] then
            return true
        end
        if Catalog._origOwned then
            return Catalog._origOwned(state, kind, id)
        end
        return true
    end
    Catalog.available = function(kind, id, now)
        if type(kind) == "string" and type(id) == "string" and State.allMaps[kind] and State.allMaps[kind][id] then
            return true
        end
        if Catalog._origAvailable then
            return Catalog._origAvailable(kind, id, now)
        end
        return true
    end
    Catalog.isWithdrawn = function(kind, id)
        return false
    end
end

-- 4. Patch a ProgressClient state table in-place
local function patchStateTable(st)
    if type(st) ~= "table" then return st end
    st.all = true

    if type(st.owned) ~= "table" then
        st.owned = {}
    end

    for _, kind in ipairs({ "tables", "cues", "scenes" }) do
        local cur = st.owned[kind]
        if type(cur) == "table" and not cur._sidespinPatched then
            for _, v in ipairs(cur) do
                if type(v) == "string" then
                    State.serverOwned[kind][v] = true
                end
            end
            for k, v in pairs(cur) do
                if type(k) == "string" and v == true and k ~= "_sidespinPatched" then
                    State.serverOwned[kind][k] = true
                end
            end
        end

        local hybrid = {}
        for idx, id in ipairs(State.allItems[kind]) do
            hybrid[idx] = id
            hybrid[id] = true
        end
        hybrid._sidespinPatched = true
        st.owned[kind] = hybrid
    end

    -- Clear rental/trial flags so MainMenu's strict owns(kind, id, true) returns true in Shop too
    if type(st.promo) == "table" then
        st.promo = {}
    end
    if type(st.clube) == "table" and type(st.clube.alugados) == "table" then
        st.clube.alugados = {}
    end
    if type(st.teste) == "table" and type(st.teste.itens) == "table" then
        st.teste.itens = {}
    end

    -- Sync equipped items
    if type(st.equipped) ~= "table" then
        st.equipped = {}
    end
    for _, kind in ipairs({ "tables", "cues", "scenes" }) do
        local eq = State.customEquipped[kind]
        if type(eq) == "string" and State.allMaps[kind][eq] then
            st.equipped[kind] = eq
        elseif type(st.equipped[kind]) == "string" and State.allMaps[kind][st.equipped[kind]] then
            State.customEquipped[kind] = st.equipped[kind]
        else
            st.equipped[kind] = "Classic"
        end
    end

    -- Unlock all achievements & insigniaGuide badges
    if type(st.achievements) == "table" then
        for _, ach in ipairs(st.achievements) do
            if type(ach) == "table" then
                ach.unlocked = true
                if State.customEquipped.title ~= "" and ach.id == State.customEquipped.title then
                    st.title = ach.id
                    st.insigniaId = ach.id
                    st.titleText = ach.badgeText or ach.title or st.titleText
                end
            end
        end
    end

    if type(st.insigniaGuide) == "table" then
        local nowTs = os.time()
        for _, grp in ipairs(st.insigniaGuide) do
            if type(grp) == "table" and type(grp.items) == "table" then
                grp.owned = #grp.items
                for _, item in ipairs(grp.items) do
                    if type(item) == "table" then
                        item.unlocked = true
                        if not item.date or item.date == 0 then
                            item.date = nowTs
                        end
                    end
                end
            end
        end
    end

    return st
end

-- 5. Sync MainMenu selection & redraw
local function syncMenus(shouldRedraw)
    for pc in pairs(State.progressClients) do
        if type(pc) == "table" and type(pc.state) == "table" then
            patchStateTable(pc.state)
        end
    end
    for mm in pairs(State.mainMenus) do
        if type(mm) == "table" and type(mm.selection) == "table" then
            for _, kind in ipairs({ "tables", "cues", "scenes" }) do
                local eq = State.customEquipped[kind]
                if type(eq) == "string" and State.allMaps[kind][eq] then
                    mm.selection[kind] = eq
                end
            end
            if shouldRedraw then
                pcall(function()
                    if type(mm.refreshFigure) == "function" then
                        mm:refreshFigure()
                    end
                    if mm.visible and type(mm.redraw) == "function" then
                        mm:redraw()
                    end
                end)
            end
        end
    end
end

-- 6. Apply 3D Cue, Table, and Scene to LocalPlayer, P2P Peers, and workspace.SinucaPrototype
local function getDesiredTableForPlayer(plr)
    if not plr then return nil end
    if plr == lp then
        return State.customEquipped.tables
    end
    local cfg = State.peerConfigs[tostring(plr.UserId)]
    if cfg and type(cfg.table) == "string" and State.allMaps.tables[cfg.table] then
        return cfg.table
    end
    return nil
end

local function apply3DVisuals(forceTableMorph, forceSceneRefresh)
    if State.applyingAttrs then return end
    State.applyingAttrs = true

    pcall(function()
        local myCue = State.customEquipped.cues or "Classic"
        local myTable = State.customEquipped.tables or "Classic"
        local myScene = State.customEquipped.scenes or "Classic"

        if lp:GetAttribute("EquippedCue") ~= myCue then
            lp:SetAttribute("EquippedCue", myCue)
        end
        if lp:GetAttribute("TableSkin") ~= myTable then
            lp:SetAttribute("TableSkin", myTable)
        end
        if lp:GetAttribute("EquippedScene") ~= myScene then
            lp:SetAttribute("EquippedScene", myScene)
        end

        -- Apply P2P peer attributes
        for uidStr, cfg in pairs(State.peerConfigs) do
            local uid = tonumber(uidStr)
            local peer = uid and Players:GetPlayerByUserId(uid)
            if peer and peer ~= lp then
                if type(cfg.cue) == "string" and State.allMaps.cues[cfg.cue] then
                    if peer:GetAttribute("EquippedCue") ~= cfg.cue then
                        peer:SetAttribute("EquippedCue", cfg.cue)
                    end
                end
                if type(cfg.table) == "string" and State.allMaps.tables[cfg.table] then
                    if peer:GetAttribute("TableSkin") ~= cfg.table then
                        peer:SetAttribute("TableSkin", cfg.table)
                    end
                end
                if type(cfg.scene) == "string" and State.allMaps.scenes[cfg.scene] then
                    if peer:GetAttribute("EquippedScene") ~= cfg.scene then
                        peer:SetAttribute("EquippedScene", cfg.scene)
                    end
                end
            end
        end

        local proto = workspace:FindFirstChild("SinucaPrototype")
        if proto then
            -- 1. SceneSkin on SinucaPrototype (always local player's equipped scene)
            if proto:GetAttribute("SceneSkin") ~= myScene then
                proto:SetAttribute("SceneSkin", myScene)
                forceSceneRefresh = true
            end
            if forceSceneRefresh and SceneRuntime and SceneRuntime.current and SceneRuntime.current.id ~= myScene then
                pcall(function()
                    SceneRuntime.current:set(myScene)
                end)
            end

            -- 2. Seat1TableSkin..Seat4TableSkin & active TableSkin on SinucaPrototype
            local turnSeat = proto:GetAttribute("TurnSeat")
            local activeDesiredTable = nil
            local localSeated = false

            for i = 1, 4 do
                local seatUid = proto:GetAttribute("Seat" .. i .. "UserId")
                if type(seatUid) == "number" and seatUid ~= 0 then
                    local seatPlr = Players:GetPlayerByUserId(seatUid)
                    if seatPlr == lp then
                        localSeated = true
                    end
                    local desiredSeatTable = getDesiredTableForPlayer(seatPlr)
                    if desiredSeatTable then
                        if proto:GetAttribute("Seat" .. i .. "TableSkin") ~= desiredSeatTable then
                            proto:SetAttribute("Seat" .. i .. "TableSkin", desiredSeatTable)
                        end
                        if turnSeat == i then
                            activeDesiredTable = desiredSeatTable
                        end
                    end
                end
            end

            if not activeDesiredTable then
                local ownerName = proto:GetAttribute("TableOwnerName")
                if type(ownerName) == "string" and ownerName ~= "" then
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if string.upper(plr.DisplayName) == string.upper(ownerName) or string.upper(plr.Name) == string.upper(ownerName) then
                            activeDesiredTable = getDesiredTableForPlayer(plr)
                            break
                        end
                    end
                end
            end

            if not activeDesiredTable and (localSeated or lp:GetAttribute("PoolAtTable") == true or proto:GetAttribute("ServerRole") ~= "Table") then
                activeDesiredTable = myTable
            end

            if activeDesiredTable and proto:GetAttribute("TableSkin") ~= activeDesiredTable then
                proto:SetAttribute("TableSkin", activeDesiredTable)
                proto:SetAttribute("TableMorphRevision", (proto:GetAttribute("TableMorphRevision") or 0) + 1)
            elseif forceTableMorph and activeDesiredTable then
                proto:SetAttribute("TableSkin", activeDesiredTable)
                proto:SetAttribute("TableMorphRevision", (proto:GetAttribute("TableMorphRevision") or 0) + 1)
                if TableMorph and type(TableMorph.get) == "function" then
                    local tm = TableMorph.get(proto)
                    if tm and type(tm.request) == "function" then
                        pcall(function() tm:request(true) end)
                    end
                end
            end
        end
    end)

    State.applyingAttrs = false
end

-- 7. P2P Real-Time Sync via ntfy.sh
local doRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local function getTopicName()
    local jid = game.JobId
    if not jid or jid == "" then
        jid = "studio_" .. tostring(game.PlaceId)
    else
        jid = string.gsub(jid, "[^%w]", "")
    end
    return "ydx_sinuca1_" .. string.sub(jid, 1, 24)
end

local function broadcastLoadout(force)
    if not doRequest then return end
    local c = State.customEquipped
    local hash = table.concat({
        tostring(c.cues or "Classic"),
        tostring(c.tables or "Classic"),
        tostring(c.scenes or "Classic"),
        tostring(c.title or ""),
    }, "|")

    local now = os.clock()
    if not force and hash == State.lastBroadcastHash and (now - State.lastBroadcastTime) < 20 then
        return
    end
    State.lastBroadcastHash = hash
    State.lastBroadcastTime = now
    State.mySeq = State.mySeq + 1

    local payload = HttpService:JSONEncode({
        uid = tostring(lp.UserId),
        name = lp.Name,
        seq = State.mySeq,
        cue = c.cues or "Classic",
        table = c.tables or "Classic",
        scene = c.scenes or "Classic",
        title = c.title or "",
    })

    task.spawn(function()
        pcall(doRequest, {
            Url = "https://ntfy.sh/" .. getTopicName(),
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = payload,
        })
    end)
end

local function applyPeerPacket(data)
    if type(data) ~= "table" or not data.uid then return end
    local uidStr = tostring(data.uid)
    if uidStr == tostring(lp.UserId) then return end

    local seq = tonumber(data.seq) or 0
    local prevSeq = State.peerSeq[uidStr] or -1
    if seq > 0 and seq < prevSeq then return end
    State.peerSeq[uidStr] = seq

    State.peerConfigs[uidStr] = {
        cue = type(data.cue) == "string" and data.cue or "Classic",
        table = type(data.table) == "string" and data.table or "Classic",
        scene = type(data.scene) == "string" and data.scene or "Classic",
        title = type(data.title) == "string" and data.title or "",
    }
    apply3DVisuals(false, false)
end

local function pollPeers()
    if not doRequest then return end
    local ok, resp = pcall(doRequest, {
        Url = "https://ntfy.sh/" .. getTopicName() .. "/json?poll=1&since=45s",
        Method = "GET",
    })
    if not ok or type(resp) ~= "table" or type(resp.Body) ~= "string" then return end
    for line in string.gmatch(resp.Body, "[^\r\n]+") do
        local ok1, outer = pcall(HttpService.JSONDecode, HttpService, line)
        if ok1 and type(outer) == "table" and type(outer.message) == "string" then
            local ok2, inner = pcall(HttpService.JSONDecode, HttpService, outer.message)
            if ok2 and type(inner) == "table" then
                applyPeerPacket(inner)
            end
        end
    end
end

-- 8. Equip handler (local + 3D + save + P2P broadcast)
local function handleLocalEquip(kind, id)
    if type(kind) ~= "string" or type(id) ~= "string" then return false end
    if not State.allMaps[kind] or not State.allMaps[kind][id] then return false end

    State.customEquipped[kind] = id
    savePreset()
    syncMenus(true)
    apply3DVisuals(kind == "tables", kind == "scenes")
    broadcastLoadout(true)
    return true
end

local function handleLocalTitle(achId)
    if type(achId) ~= "string" then return false end
    State.customEquipped.title = achId
    savePreset()
    for pc in pairs(State.progressClients) do
        if type(pc) == "table" and type(pc.state) == "table" then
            pc.state.title = achId ~= "" and achId or nil
            pc.state.insigniaId = achId ~= "" and achId or nil
            patchStateTable(pc.state)
        end
    end
    syncMenus(true)
    broadcastLoadout(true)
    return true
end

-- 9. Scan GC for ProgressClient and MainMenu instances & hook their methods
local function hookProgressClient(pc)
    if State.progressClients[pc] then return end
    State.progressClients[pc] = true

    if type(pc.state) == "table" then
        patchStateTable(pc.state)
    end

    local origCall = rawget(pc, "call")
    if type(origCall) == "function" and not rawget(pc, "_sidespinHooked") then
        rawset(pc, "_sidespinHooked", true)
        rawset(pc, "call", function(self, action, payload)
            if action == "Equip" and type(payload) == "table" and type(payload.kind) == "string" and type(payload.id) == "string" then
                local kind = payload.kind
                local id = payload.id
                handleLocalEquip(kind, id)
                if State.serverOwned[kind] and State.serverOwned[kind][id] then
                    local res = origCall(self, action, payload)
                    if type(self.state) == "table" then
                        patchStateTable(self.state)
                    end
                    syncMenus(false)
                    apply3DVisuals(false, false)
                    return res
                end
                if type(self.state) == "table" then
                    patchStateTable(self.state)
                end
                return {
                    ok = true,
                    state = self.state,
                    meta = self.meta,
                }
            elseif action == "Buy" and type(payload) == "table" and type(payload.kind) == "string" and type(payload.id) == "string" then
                handleLocalEquip(payload.kind, payload.id)
                if type(self.state) == "table" then
                    patchStateTable(self.state)
                end
                return {
                    ok = true,
                    state = self.state,
                    meta = self.meta,
                    message = "Item desbloqueado e equipado!",
                }
            elseif action == "Title" and type(payload) == "table" and type(payload.achievement) == "string" then
                handleLocalTitle(payload.achievement)
                local res = origCall(self, action, payload)
                if type(self.state) == "table" then
                    patchStateTable(self.state)
                end
                if type(res) == "table" and res.ok == false then
                    return {
                        ok = true,
                        state = self.state,
                        meta = self.meta,
                    }
                end
                return res
            end

            local res = origCall(self, action, payload)
            if type(self.state) == "table" then
                patchStateTable(self.state)
            end
            syncMenus(false)
            apply3DVisuals(false, false)
            return res
        end)
    end
end

local function hookMainMenu(mm)
    if State.mainMenus[mm] then return end
    State.mainMenus[mm] = true

    if type(mm.selection) == "table" then
        for _, kind in ipairs({ "tables", "cues", "scenes" }) do
            local eq = State.customEquipped[kind]
            if type(eq) == "string" and State.allMaps[kind][eq] then
                mm.selection[kind] = eq
            end
        end
    end

    local origChooseTable = rawget(mm, "chooseTable")
    if type(origChooseTable) == "function" and not rawget(mm, "_sidespinHooked") then
        rawset(mm, "_sidespinHooked", true)
        rawset(mm, "chooseTable", function(tableId)
            if type(tableId) == "string" and State.allMaps.tables[tableId] then
                handleLocalEquip("tables", tableId)
                if State.serverOwned.tables[tableId] then
                    pcall(origChooseTable, tableId)
                end
                return
            end
            return origChooseTable(tableId)
        end)
    end
end

local function scanGC()
    if type(getgc) ~= "function" then return end
    for _, obj in ipairs(getgc(true)) do
        if type(obj) == "table" then
            if rawget(obj, "noticeQueue") ~= nil and type(rawget(obj, "call")) == "function" and rawget(obj, "rewards") ~= nil then
                hookProgressClient(obj)
            elseif type(rawget(obj, "selection")) == "table" and type(rawget(obj, "chooseTable")) == "function" and type(rawget(obj, "redraw")) == "function" then
                hookMainMenu(obj)
            end
        end
    end
end

-- 10. Hook __namecall for ProgressRequest & LobbyRequest (covers MainMenu local chooseTable & equipItem upvalues)
pcall(function()
    if type(hookmetamethod) ~= "function" or type(getnamecallmethod) ~= "function" then return end
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if (method == "InvokeServer" or method == "invokeServer") and not checkcaller() then
            if self == LobbyRequest then
                local action, payload = ...
                if action == "Table" and type(payload) == "table" and type(payload.id) == "string" then
                    local tableId = payload.id
                    if State.allMaps.tables[tableId] then
                        task.defer(handleLocalEquip, "tables", tableId)
                        if not State.serverOwned.tables[tableId] then
                            return { ok = true, id = tableId }
                        end
                    end
                end
            elseif self == ProgressRequest then
                local action, payload = ...
                if action == "Equip" and type(payload) == "table" and type(payload.kind) == "string" and type(payload.id) == "string" then
                    local kind = payload.kind
                    local id = payload.id
                    if State.allMaps[kind] and State.allMaps[kind][id] then
                        task.defer(handleLocalEquip, kind, id)
                        if not (State.serverOwned[kind] and State.serverOwned[kind][id]) then
                            local st = nil
                            for pc in pairs(State.progressClients) do
                                if type(pc) == "table" and type(pc.state) == "table" then
                                    st = patchStateTable(pc.state)
                                    break
                                end
                            end
                            return { ok = true, state = st }
                        end
                    end
                elseif action == "Buy" and type(payload) == "table" and type(payload.kind) == "string" and type(payload.id) == "string" then
                    local kind = payload.kind
                    local id = payload.id
                    if State.allMaps[kind] and State.allMaps[kind][id] then
                        task.defer(handleLocalEquip, kind, id)
                        local st = nil
                        for pc in pairs(State.progressClients) do
                            if type(pc) == "table" and type(pc.state) == "table" then
                                st = patchStateTable(pc.state)
                                break
                            end
                        end
                        return { ok = true, state = st, message = "Item equipado!" }
                    end
                elseif action == "Title" and type(payload) == "table" and type(payload.achievement) == "string" then
                    task.defer(handleLocalTitle, payload.achievement)
                end
            end
        end
        return oldNamecall(self, ...)
    end)
end)

-- 11. Connect attribute & remote watchers to keep custom skins active even after server updates
local function bindWatchers()
    if Remotes then
        local ProgressChanged = Remotes:FindFirstChild("ProgressChanged")
        if ProgressChanged and ProgressChanged:IsA("RemoteEvent") then
            ProgressChanged.OnClientEvent:Connect(function()
                task.defer(function()
                    syncMenus(true)
                    apply3DVisuals(false, false)
                end)
            end)
        end
        local LobbyChanged = Remotes:FindFirstChild("LobbyChanged")
        if LobbyChanged and LobbyChanged:IsA("RemoteEvent") then
            LobbyChanged.OnClientEvent:Connect(function()
                task.defer(function()
                    syncMenus(false)
                    apply3DVisuals(false, false)
                end)
            end)
        end
    end

    for _, attr in ipairs({ "EquippedCue", "TableSkin", "EquippedScene", "PoolAtTable", "PoolSeat" }) do
        lp:GetAttributeChangedSignal(attr):Connect(function()
            if State.applyingAttrs then return end
            task.defer(apply3DVisuals, false, attr == "PoolAtTable")
        end)
    end

    local function watchProto(proto)
        if not proto then return end
        for _, attr in ipairs({
            "TableSkin",
            "SceneSkin",
            "TurnSeat",
            "TableOwnerName",
            "ServerRole",
            "Seat1UserId",
            "Seat2UserId",
            "Seat3UserId",
            "Seat4UserId",
            "Seat1TableSkin",
            "Seat2TableSkin",
            "Seat3TableSkin",
            "Seat4TableSkin",
        }) do
            proto:GetAttributeChangedSignal(attr):Connect(function()
                if State.applyingAttrs then return end
                task.defer(apply3DVisuals, false, attr == "SceneSkin")
            end)
        end
    end

    local proto = workspace:FindFirstChild("SinucaPrototype")
    if proto then
        watchProto(proto)
    end
    workspace.ChildAdded:Connect(function(child)
        if child.Name == "SinucaPrototype" then
            watchProto(child)
            task.defer(apply3DVisuals, true, true)
        end
    end)
end

-- 12. Initialize & run background sync loop
_G.SidespinForceSync = function()
    scanGC()
    syncMenus(true)
    apply3DVisuals(true, true)
    broadcastLoadout(true)
end

scanGC()
bindWatchers()
syncMenus(true)
apply3DVisuals(true, true)
broadcastLoadout(true)

task.spawn(function()
    while true do
        task.wait(2.5)
        pcall(function()
            scanGC()
            syncMenus(false)
            apply3DVisuals(false, false)
            broadcastLoadout(false)
            pollPeers()
        end)
    end
end)

print(string.format(
    "[Sidespin UnlockAll v2.1] Loaded! Unlocks: %d Cues, %d Tables, %d Scenes + Insignias + P2P Sync + Infinite Guide Lines + 1/240s Exact Auto-Play Bot GUI",
    #State.allItems.cues,
    #State.allItems.tables,
    #State.allItems.scenes
))
