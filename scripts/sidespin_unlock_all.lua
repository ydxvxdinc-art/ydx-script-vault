-- [ BACKROOMS ] Sidespin | 8 Ball Pool & Sinuca - Unlock All + P2P Sync + Full Table Guide Lines v1.1
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
    local MAX_OBJECT_WALLS = 2
    local MAX_CUE_AFTER_WALLS = 1
    local MAX_AFTER_SECONDS = 1.35

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
        local cfg = guide.config or Config
        local balls = guide.world.balls
        local parked = guide.parked
        if not parked then
            parked = {}
            guide.parked = parked
        end
        local r = cfg.BallRadius or 0.12
        local stepDt = cfg.PhysicsStep or (1 / 120)
        local moving = {}
        local maxSpeedSq = 0
        for _, b in ipairs(balls) do
            if not b.removed then
                local vSq = b.v:Dot(b.v)
                local wSq = b.w:Dot(b.w)
                if vSq > 0 or wSq > 0 then
                    maxSpeedSq = maxSpeedSq + vSq + 0.4 * r * r * wSq
                    table.insert(moving, b)
                end
            end
        end
        local horizon = math.sqrt(maxSpeedSq) * 1.35 * math.max(0.025, stepDt) + 2 * r + 0.06
        local objIdx = (guide.objectNumber or -1) + 1
        for i = 2, #balls do
            local b = balls[i]
            local isParked = parked[i] == true
            if i ~= objIdx and (isParked or not b.removed) and b.v.Magnitude == 0 and b.w.Magnitude == 0 then
                local near = false
                for _, mb in ipairs(moving) do
                    if (mb.p - b.p).Magnitude <= horizon then
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
        local maxSteps = math.max(steps or 12, 160)

        local function isBallSliding(b)
            if not b or b.removed then return false end
            if b.curve ~= nil or math.abs(b.v.Y) > 1e-5 then return true end
            local sx = b.v.X + r * b.w.Z
            local sz = b.v.Z - r * b.w.X
            return (sx * sx + sz * sz) > 0.002
        end

        for stepIdx = 1, maxSteps do
            local stepDt = baseStepDt
            if guide.phase == "approach" then
                if not isBallSliding(cueBall) then
                    stepDt = baseStepDt * 3
                end
            elseif guide.phase == "after" then
                if stepIdx % 3 == 1 then
                    reduceParkBalls(guide)
                end
                local elapsedAfter = guide.time - (guide.afterStart or guide.time)
                if elapsedAfter >= 0.85 and not guide.cueAfterDone then
                    if result.cueAfter and not result.cueAfter.closed then
                        closePath(result.cueAfter)
                    end
                    guide.cueAfterDone = true
                end
                if elapsedAfter >= MAX_AFTER_SECONDS then
                    guide.phase = "done"
                    break
                end
                if guide.cueAfterDone and not cueBall.removed then
                    local ob = guide.objectNumber and balls[guide.objectNumber + 1]
                    if not ob or ob.removed or (cueBall.p - ob.p).Magnitude > soloProximity * 1.5 then
                        cueBall.removed = true
                    end
                end
                if guide.objectDone and guide.objectNumber then
                    local ob = balls[guide.objectNumber + 1]
                    if ob and not ob.removed then
                        if cueBall.removed or (cueBall.p - ob.p).Magnitude > soloProximity * 1.5 then
                            ob.removed = true
                        end
                    end
                end
                local ob = guide.objectNumber and balls[guide.objectNumber + 1]
                if not isBallSliding(cueBall) and not isBallSliding(ob) then
                    stepDt = baseStepDt * 4
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
_G.SidespinUnlockAllVersion = "1.4"

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
    "[Sidespin UnlockAll v1.4] Loaded! Unlocks: %d Cues, %d Tables, %d Scenes + Insignias + P2P Sync + High-FPS Exact Guide Lines",
    #State.allItems.cues,
    #State.allItems.tables,
    #State.allItems.scenes
))
