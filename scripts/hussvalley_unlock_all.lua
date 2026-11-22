-- Huss Valley: Knife & Emote Unlock All + Real-Time P2P Sync
-- Scope: All Knives + All Emotes (Local + P2P Script Users Only)

if _G.HussValleyUnlockAllLoaded then
    warn("[HussValleyUnlockAll] Already loaded! Refreshing state...")
    if type(_G.HussValleyForceRefresh) == "function" then
        pcall(_G.HussValleyForceRefresh)
    end
    return
end
_G.HussValleyUnlockAllLoaded = true

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    Players.PlayerAdded:Wait()
    LocalPlayer = Players.LocalPlayer
end

local ChickenOrHero = ReplicatedStorage:WaitForChild("ChickenOrHero", 30)
if not ChickenOrHero then
    warn("[HussValleyUnlockAll] ChickenOrHero not found!")
    return
end

local WeaponsFolder = ChickenOrHero:WaitForChild("Weapons", 20)
local EmotesFolder = ChickenOrHero:WaitForChild("Emotes", 20)
local BotsFolder = ChickenOrHero:WaitForChild("Bots", 20)
local PresentationFolder = ChickenOrHero:WaitForChild("Presentation", 20)

local ArmoryEvent = WeaponsFolder:WaitForChild("ArmoryEvent", 20)
local WeaponModels = WeaponsFolder:WaitForChild("Models", 20)
local EmoteEvent = EmotesFolder:WaitForChild("EmoteEvent", 20)
local CaughtLoadoutEvent = PresentationFolder and PresentationFolder:FindFirstChild("CaughtLoadoutEvent")
local SpectateEvent = PresentationFolder and PresentationFolder:FindFirstChild("SpectateEvent")

local SkinCatalog = require(WeaponsFolder:WaitForChild("SkinCatalog"))
local KnifeVFXSetup = require(WeaponsFolder:WaitForChild("KnifeVFXSetup"))
local KnifeClips = require(WeaponsFolder:WaitForChild("KnifeClips"))
local EmoteCatalog = require(EmotesFolder:WaitForChild("EmoteCatalog"))
local EmotePlayback = require(EmotesFolder:WaitForChild("EmotePlayback"))
local EmotePieces = require(EmotesFolder:WaitForChild("EmotePieces"))
local ClientBotKnife = require(BotsFolder:WaitForChild("ClientBotKnife"))

local S = {
    presetFile = "hussvalley_saved_preset.json",
    equippedKnife = SkinCatalog.Default or "ButterflyKnife",
    emoteSlots = { "IdleDance", "Jumpstyle", "Shuffle", "CatDance", "Moongazer", "KnifeJuggle" },
    activeEmote = "",
    activeEmoteAt = 0,
    coins = 0,
    gems = 0,
    serverOwnedKnives = {},
    serverOwnedEmotes = {},
    allOwnedKnives = {},
    allOwnedEmotes = {},
    patchedSkins = {},
    kindFallback = {},
    dualFallback = "GrinnerBlades",
    charControllers = {},
    p2pPeers = {},
    seenIds = {},
    lastBroadcastHash = "",
    lastBroadcastTime = 0,
    applyingState = false,
    defaultClipIds = {}
}

for actionName in pairs(KnifeClips.Actions) do
    local clipId = KnifeClips.default(actionName)
    if clipId then
        S.defaultClipIds[clipId] = actionName
    end
end

local function unfreezeTable(t)
    if type(t) ~= "table" then return end
    if type(setreadonly) == "function" then
        pcall(setreadonly, t, false)
    end
end

-- ============================================================
-- 1. UNLOCK SKINCATALOG & EMOTECATALOG
-- ============================================================
do
    unfreezeTable(SkinCatalog)
    local origSkinGet = SkinCatalog.get

    for _, skinId in ipairs(SkinCatalog.Order or {}) do
        S.allOwnedKnives[skinId] = true
        local rawDef = origSkinGet(skinId)
        if type(rawDef) == "table" then
            unfreezeTable(rawDef)
            pcall(function()
                rawDef.Hide = false
                rawDef.HideOwned = false
                rawDef.EquipReady = true
            end)
            local copyDef = {}
            for k, v in pairs(rawDef) do
                copyDef[k] = v
            end
            copyDef.Hide = false
            copyDef.HideOwned = false
            copyDef.EquipReady = true
            S.patchedSkins[skinId] = copyDef

            local modelInst = rawDef.Model and WeaponModels:FindFirstChild(rawDef.Model)
            if modelInst then
                local kind = modelInst:GetAttribute("KnifeKind")
                if type(kind) == "string" and kind ~= "" and not S.kindFallback[kind] then
                    S.kindFallback[kind] = skinId
                end
                if modelInst:GetAttribute("IsDualWield") == true and S.dualFallback == "GrinnerBlades" then
                    S.dualFallback = skinId
                end
            end
        end
    end
    S.kindFallback["Karambit"] = S.kindFallback["Karambit"] or "Karambit"
    S.kindFallback["Kusarigama"] = S.kindFallback["Kusarigama"] or "VoidKusarigama"
    S.kindFallback["Kitsune"] = S.kindFallback["Kitsune"] or "ImmortalKitsune"

    local function patchedSkinGet(skinId)
        if S.patchedSkins[skinId] then
            return S.patchedSkins[skinId]
        end
        local res = origSkinGet(skinId)
        if type(res) == "table" then
            local c = {}
            for k, v in pairs(res) do c[k] = v end
            c.Hide = false
            c.HideOwned = false
            c.EquipReady = true
            S.patchedSkins[skinId] = c
            return c
        end
        return res
    end

    pcall(function() SkinCatalog.get = patchedSkinGet end)
    if type(hookfunction) == "function" then
        pcall(function()
            hookfunction(origSkinGet, function(skinId)
                return patchedSkinGet(skinId)
            end)
        end)
    end
end

local function resolveEmotePropSkin(emoteId, equippedSkinId)
    local entry = EmoteCatalog.get(emoteId)
    if not (entry and entry.Prop) then
        return nil
    end
    local skinId = ( type(equippedSkinId) == "string" and equippedSkinId ~= "" and equippedSkinId ) or S.equippedKnife
    if entry.Prop ~= "Equipped" then
        return entry.Prop
    end
    if entry.Kind then
        local curKind = EmoteCatalog.knifeKind(skinId)
        local playsWithList = entry.PlaysWith or {}
        if curKind ~= entry.Kind and not table.find(playsWithList, skinId) then
            if entry.Knife and SkinCatalog.get(entry.Knife) then
                return entry.Knife
            end
            if type(entry.UnlockedBy) == "table" and entry.UnlockedBy[1] then
                return entry.UnlockedBy[1]
            end
            if S.kindFallback[entry.Kind] then
                return S.kindFallback[entry.Kind]
            end
        end
    end
    if entry.PropDual and not EmoteCatalog.dualWield(skinId) then
        return entry.Knife or S.dualFallback
    end
    return skinId
end

do
    unfreezeTable(EmoteCatalog)
    pcall(function()
        EmoteCatalog.ComingSoon = false
        EmoteCatalog.Enabled = true
    end)

    for _, entry in ipairs(EmoteCatalog.Entries or {}) do
        if type(entry) == "table" and type(entry.Id) == "string" then
            unfreezeTable(entry)
            pcall(function()
                entry.TestHidden = false
            end)
            S.allOwnedEmotes[entry.Id] = true
        end
    end

    local origEmoteOwned = EmoteCatalog.owned
    local origEmoteAvailable = EmoteCatalog.available
    local origEmotePlaysWith = EmoteCatalog.playsWith
    local origEmoteProp = EmoteCatalog.prop

    local function newEmoteOwned(emoteId, _state)
        local entry = EmoteCatalog.get(emoteId)
        if not entry or entry.Ultimate then
            return false
        end
        return true
    end

    local function newEmoteAvailable(emoteId)
        if EmoteCatalog.assetId(emoteId) ~= nil then
            return true
        end
        return origEmoteAvailable(emoteId)
    end

    local function newEmotePlaysWith(emoteId, _knifeId)
        return EmoteCatalog.get(emoteId) ~= nil
    end

    local function newEmoteProp(emoteId, knifeId)
        local entry = EmoteCatalog.get(emoteId)
        if not (entry and entry.Prop) then
            return nil
        end
        return resolveEmotePropSkin(emoteId, knifeId)
    end

    pcall(function()
        EmoteCatalog.owned = newEmoteOwned
        EmoteCatalog.available = newEmoteAvailable
        EmoteCatalog.playsWith = newEmotePlaysWith
        EmoteCatalog.prop = newEmoteProp
    end)
    if type(hookfunction) == "function" then
        pcall(function() hookfunction(origEmoteOwned, newEmoteOwned) end)
        pcall(function() hookfunction(origEmoteAvailable, newEmoteAvailable) end)
        pcall(function() hookfunction(origEmotePlaysWith, newEmotePlaysWith) end)
        pcall(function() hookfunction(origEmoteProp, newEmoteProp) end)
    end
end

-- ============================================================
-- 2. PRESET SAVE / LOAD
-- ============================================================
local function saveLocalPreset()
    if type(writefile) ~= "function" then return end
    pcall(function()
        local payload = HttpService:JSONEncode({
            knife = S.equippedKnife,
            emoteSlots = S.emoteSlots
        })
        writefile(S.presetFile, payload)
    end)
end

local function loadLocalPreset()
    if type(isfile) ~= "function" or type(readfile) ~= "function" then return end
    pcall(function()
        if not isfile(S.presetFile) then return end
        local raw = readfile(S.presetFile)
        if type(raw) ~= "string" or raw == "" then return end
        local data = HttpService:JSONDecode(raw)
        if type(data) ~= "table" then return end
        if type(data.knife) == "string" and S.allOwnedKnives[data.knife] then
            S.equippedKnife = data.knife
        end
        if type(data.emoteSlots) == "table" then
            for i = 1, 6 do
                local em = data.emoteSlots[i]
                if type(em) == "string" and (em == "" or S.allOwnedEmotes[em]) then
                    S.emoteSlots[i] = em
                end
            end
        end
    end)
end

loadLocalPreset()

-- ============================================================
-- 3. ARMORY & EMOTE WHEEL STATE INJECTION
-- ============================================================
local function buildPatchedState(baseState)
    if type(baseState) == "table" and not baseState._ydxPatched then
        if type(baseState.coins) == "number" then S.coins = baseState.coins end
        if type(baseState.gems) == "number" then S.gems = baseState.gems end
        if type(baseState.owned) == "table" then
            for k, v in pairs(baseState.owned) do
                if v == true then S.serverOwnedKnives[k] = true end
            end
        end
        if type(baseState.emotes) == "table" then
            for k, v in pairs(baseState.emotes) do
                if v == true then S.serverOwnedEmotes[k] = true end
            end
        end
    end

    local ownedCopy = {}
    for k in pairs(S.allOwnedKnives) do
        ownedCopy[k] = true
    end
    local emotesCopy = {}
    for k in pairs(S.allOwnedEmotes) do
        emotesCopy[k] = true
    end
    local slotsCopy = {}
    for i = 1, 6 do
        slotsCopy[i] = S.emoteSlots[i] or ""
    end

    local st = {
        _ydxPatched = true,
        loaded = true,
        pending = false,
        coins = S.coins,
        gems = S.gems,
        owned = ownedCopy,
        equipped = S.equippedKnife,
        emotes = emotesCopy,
        emoteSlots = slotsCopy
    }
    return st
end

local function ensureArmoryBuiltAndPushState(baseState)
    if S.applyingState then return end
    S.applyingState = true
    local patched = buildPatchedState(baseState)

    pcall(function()
        LocalPlayer:SetAttribute("EquippedKnife", S.equippedKnife)
    end)

    if type(getconnections) == "function" then
        for _, conn in ipairs(getconnections(ArmoryEvent.OnClientEvent)) do
            if conn.Function then
                -- Check if this is ArmoryClient's initial pre-build listener with upvalue u1
                if type(debug) == "table" and type(debug.getupvalues) == "function" then
                    local ok, ups = pcall(debug.getupvalues, conn.Function)
                    if ok and type(ups) == "table" then
                        for _, upv in pairs(ups) do
                            if type(upv) == "table" and type(upv.build) == "function" and upv.state ~= nil then
                                upv.state = patched
                                if not upv.built and not upv.live then
                                    task.spawn(function()
                                        pcall(upv.build)
                                        task.wait(0.05)
                                        if type(getconnections) == "function" then
                                            for _, c2 in ipairs(getconnections(ArmoryEvent.OnClientEvent)) do
                                                if c2.Function then
                                                    pcall(c2.Function, "State", patched)
                                                end
                                            end
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end
                pcall(conn.Function, "State", patched)
            end
        end
    end

    S.applyingState = false
end

local function fireEmoteClientEvent(action, payload)
    if type(getconnections) ~= "function" then return end
    for _, conn in ipairs(getconnections(EmoteEvent.OnClientEvent)) do
        if conn.Function then
            pcall(conn.Function, action, payload)
        end
    end
end

-- ============================================================
-- 4. 3D KNIFE & EMOTE PLAYBACK ENGINE (LOCAL + P2P PEERS)
-- ============================================================
local function syncKnifeLocomotionAttributes(character, weaponModel, isHeld)
    if not character then return end
    if not weaponModel then
        character:SetAttribute("KnifeRun", nil)
        character:SetAttribute("KnifeRunDirs", nil)
        character:SetAttribute("KnifeIdle", nil)
        character:SetAttribute("KnifeDash", nil)
        character:SetAttribute("KnifeRide", nil)
        return
    end

    local isRide = weaponModel:GetAttribute("MatchCarry") == "Ride"
    local runWhenHeld = weaponModel:GetAttribute("RunWhenHeld") == true
    local activeForLocomotion = isHeld or isRide
    if runWhenHeld and not isHeld then
        activeForLocomotion = false
    end

    local runAnim = activeForLocomotion and weaponModel:GetAttribute("RunAnim") or nil
    local hasDirAnims = activeForLocomotion and (weaponModel:GetAttribute("RunLeftAnim") ~= nil) or nil
    local idleAnim = activeForLocomotion and weaponModel:GetAttribute("IdleAnim") or nil
    local dashAnim = activeForLocomotion and weaponModel:GetAttribute("DashAnim") or nil

    character:SetAttribute("KnifeRun", runAnim)
    character:SetAttribute("KnifeRunDirs", hasDirAnims and true or nil)
    character:SetAttribute("KnifeIdle", idleAnim)
    character:SetAttribute("KnifeDash", dashAnim)
    character:SetAttribute("KnifeRide", (isRide and isHeld) and true or nil)
end

local function getOrCreateController(plr, character)
    local ctrl = S.charControllers[character]
    if ctrl and ctrl.character == character then
        return ctrl
    end
    ctrl = {
        player = plr,
        character = character,
        botKnife = nil,
        currentModelName = nil,
        emoteId = "",
        emoteAt = 0,
        introTrack = nil,
        loopTrack = nil,
        emotePieces = {},
        emoteSounds = {},
        emoteConnections = {}
    }
    S.charControllers[character] = ctrl
    return ctrl
end

local function clearControllerEmote(ctrl, keepAttributes)
    if not ctrl then return end
    for _, conn in ipairs(ctrl.emoteConnections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(ctrl.emoteConnections)

    if ctrl.introTrack then
        pcall(EmotePlayback.dispose, ctrl.introTrack)
        ctrl.introTrack = nil
    end
    if ctrl.loopTrack then
        pcall(EmotePlayback.dispose, ctrl.loopTrack)
        ctrl.loopTrack = nil
    end
    if #ctrl.emotePieces > 0 then
        pcall(EmotePieces.clear, ctrl.emotePieces)
    end
    for _, snd in ipairs(ctrl.emoteSounds) do
        pcall(function() snd:Destroy() end)
    end
    table.clear(ctrl.emoteSounds)

    ctrl.emoteId = ""
    ctrl.emoteAt = 0

    local character = ctrl.character
    if character and character.Parent then
        pcall(EmotePieces.strip, character)
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, ch in ipairs(hrp:GetChildren()) do
                if ch:IsA("Sound") and (ch.Name == "EmoteSound" or ch.Name == "EmoteSoundExtra") then
                    pcall(function() ch:Destroy() end)
                end
            end
        end
        if not keepAttributes then
            character:SetAttribute("EmoteId", nil)
            character:SetAttribute("EmoteStartedAt", nil)
            character:SetAttribute("EmoteProp", nil)
        end
    end
end

local function resolveDesiredStateForPlayer(plr)
    if plr == LocalPlayer then
        return S.equippedKnife, S.activeEmote, S.activeEmoteAt
    end
    local peer = S.p2pPeers[tostring(plr.UserId)]
    if peer then
        return peer.knife, peer.emote or "", peer.emoteAt or 0
    end
    return nil, nil, nil
end

local function ensureCustomKnifeOnCharacter(plr, character)
    if not (plr and character and character.Parent) then return nil end
    local targetKnifeId, activeEmoteId = resolveDesiredStateForPlayer(plr)
    if not targetKnifeId or not S.allOwnedKnives[targetKnifeId] then
        return nil
    end

    local hum = character:FindFirstChildOfClass("Humanoid")
    local rightArm = character:FindFirstChild("Right Arm")
    local torso = character:FindFirstChild("Torso")
    if not (hum and rightArm and torso) then
        return nil
    end

    local effectiveSkinId = targetKnifeId
    if type(activeEmoteId) == "string" and activeEmoteId ~= "" then
        local propSkin = resolveEmotePropSkin(activeEmoteId, targetKnifeId)
        if type(propSkin) == "string" and propSkin ~= "" then
            effectiveSkinId = propSkin
        end
    end

    local skinDef = SkinCatalog.get(effectiveSkinId)
    local modelName = (skinDef and skinDef.Model) or effectiveSkinId
    if not WeaponModels:FindFirstChild(modelName) then
        modelName = SkinCatalog.Default or "ButterflyKnife"
    end

    pcall(function()
        plr:SetAttribute("EquippedKnife", targetKnifeId)
        character:SetAttribute("DaggerSkin", effectiveSkinId)
        if character:GetAttribute("DaggerEquipped") == nil then
            character:SetAttribute("DaggerEquipped", true)
        end
    end)

    -- Remove any server EquippedDagger that wasn't created by us for this modelName
    for _, child in ipairs(character:GetChildren()) do
        if child.Name == "EquippedDagger" and child:GetAttribute("_YDXModel") ~= modelName then
            pcall(function() child:Destroy() end)
        end
    end

    local ctrl = getOrCreateController(plr, character)
    if ctrl.botKnife and ctrl.botKnife.weapon and ctrl.botKnife.weapon.Parent == character and ctrl.currentModelName == modelName then
        return ctrl
    end

    if ctrl.botKnife then
        pcall(function() ctrl.botKnife:remove() end)
        ctrl.botKnife = nil
    end

    local bk = ClientBotKnife.new(character, nil, modelName)
    local created = bk:create(modelName)
    if created and bk.weapon then
        bk.weapon:SetAttribute("_YDXModel", modelName)
        pcall(KnifeVFXSetup.apply, bk.weapon)
        ctrl.botKnife = bk
        ctrl.currentModelName = modelName
    end

    return ctrl
end

local function startCharacterEmote(plr, character, emoteId, startedAt)
    if not (plr and character and character.Parent) then return end
    local entry = EmoteCatalog.get(emoteId)
    if not entry then return end

    local hum = character:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildOfClass("Animator")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not (animator and hrp) then return end

    local ctrl = getOrCreateController(plr, character)
    clearControllerEmote(ctrl, true)

    local stamp = (type(startedAt) == "number" and startedAt > 0 and startedAt) or workspace:GetServerTimeNow()
    ctrl.emoteId = emoteId
    ctrl.emoteAt = stamp

    local targetKnifeId = resolveDesiredStateForPlayer(plr)
    local propSkin = resolveEmotePropSkin(emoteId, targetKnifeId or S.equippedKnife)

    pcall(function()
        if not CollectionService:HasTag(character, "EmoteVFXRig") then
            CollectionService:AddTag(character, "EmoteVFXRig")
        end
        character:SetAttribute("EmoteProp", propSkin)
        character:SetAttribute("EmoteStartedAt", stamp)
        character:SetAttribute("EmoteId", emoteId)
    end)

    ensureCustomKnifeOnCharacter(plr, character)

    -- Build EmotePieces if present
    if type(entry.Pieces) == "table" and #entry.Pieces > 0 then
        local propDef = propSkin and SkinCatalog.get(propSkin)
        local propModelName = (propDef and propDef.Model) or propSkin or S.equippedKnife
        local propModel = WeaponModels:FindFirstChild(propModelName) or (ctrl.botKnife and ctrl.botKnife.weapon)
        local ok, built = pcall(EmotePieces.build, character, entry, propModel, character)
        if ok and type(built) == "table" then
            ctrl.emotePieces = built
        end
    end

    -- Play Intro -> Loop Animation
    local introTrack = EmotePlayback.intro(animator, emoteId)
    local loopTrack = EmotePlayback.load(animator, emoteId)
    ctrl.introTrack = introTrack
    ctrl.loopTrack = loopTrack

    local function playExtrasForLoop()
        if ctrl.emoteId ~= emoteId or not hrp.Parent then return end
        local ids, vols, delays = EmoteCatalog.soundIds(emoteId)
        for i = 2, #ids do
            local d = delays[i]
            local sid = ids[i]
            local vol = vols[i] or 0.25
            local function spawnExtra()
                if ctrl.emoteId ~= emoteId or not hrp.Parent then return end
                local s = Instance.new("Sound")
                s.Name = "EmoteSoundExtra"
                s.SoundId = sid
                s.Volume = vol
                s:SetAttribute("EmoteBaseVolume", vol)
                s:SetAttribute("EmoteEffects", true)
                s.Looped = false
                s.RollOffMaxDistance = 80
                s.Parent = hrp
                s:Play()
                table.insert(ctrl.emoteSounds, s)
            end
            if type(d) == "number" and d > 0 then
                task.delay(d, spawnExtra)
            else
                spawnExtra()
            end
        end
    end

    -- Primary EmoteSound
    local ids, vols = EmoteCatalog.soundIds(emoteId)
    local mainSound = nil
    if ids[1] then
        mainSound = Instance.new("Sound")
        mainSound.Name = "EmoteSound"
        mainSound.SoundId = ids[1]
        local baseVol = vols[1] or 0.25
        mainSound.Volume = baseVol
        mainSound:SetAttribute("EmoteBaseVolume", baseVol)
        mainSound:SetAttribute("EmoteEffects", entry.SoundEffects == true)
        mainSound.Looped = not (entry.SoundEachLoop == true)
        mainSound.RollOffMaxDistance = 80
        mainSound.Parent = hrp
        table.insert(ctrl.emoteSounds, mainSound)

        local sDelay = tonumber(entry.SoundDelay) or 0
        if sDelay > 0 then
            task.delay(sDelay, function()
                if ctrl.emoteId == emoteId and mainSound.Parent then
                    mainSound:Play()
                end
            end)
        else
            mainSound:Play()
        end
    end

    if loopTrack then
        table.insert(ctrl.emoteConnections, loopTrack.DidLoop:Connect(function()
            if ctrl.emoteId ~= emoteId then return end
            if entry.SoundEachLoop and mainSound and mainSound.Parent then
                local sDelay = tonumber(entry.SoundDelay) or 0
                if sDelay > 0 then
                    task.delay(sDelay, function()
                        if ctrl.emoteId == emoteId and mainSound.Parent then
                            mainSound.TimePosition = 0
                            mainSound:Play()
                        end
                    end)
                else
                    mainSound.TimePosition = 0
                    mainSound:Play()
                end
            end
            playExtrasForLoop()
        end))
    end

    if introTrack then
        introTrack:Play(0.12)
        playExtrasForLoop()
        table.insert(ctrl.emoteConnections, introTrack.Stopped:Connect(function()
            if ctrl.emoteId == emoteId and loopTrack then
                loopTrack:Play(0.1)
            end
        end))
    elseif loopTrack then
        loopTrack:Play(0.15)
        playExtrasForLoop()
    end

    if plr == LocalPlayer then
        fireEmoteClientEvent("Playing")
    end
end

local function stopCharacterEmote(plr, character)
    local ctrl = character and S.charControllers[character]
    if ctrl then
        clearControllerEmote(ctrl, false)
    elseif character then
        character:SetAttribute("EmoteId", nil)
        character:SetAttribute("EmoteStartedAt", nil)
        character:SetAttribute("EmoteProp", nil)
    end
    if plr and character and character.Parent then
        ensureCustomKnifeOnCharacter(plr, character)
    end
end

-- Frame-by-frame update for LocalPlayer and all P2P peers
RunService.PreSimulation:Connect(function()
    local now = workspace:GetServerTimeNow()

    -- Check if LocalPlayer emote should auto-cancel due to match state / drawing knife / ragdoll
    if S.activeEmote ~= "" and LocalPlayer.Character then
        local ch = LocalPlayer.Character
        local dState = ch:GetAttribute("DaggerState")
        if ch:GetAttribute("Ragdolled") == true
            or LocalPlayer:GetAttribute("RunState") == "Caught"
            or dState == "Drawing"
            or dState == "Held" then
            S.activeEmote = ""
            S.activeEmoteAt = 0
            stopCharacterEmote(LocalPlayer, ch)
            if type(S.broadcastMyState) == "function" then
                S.broadcastMyState(true)
            end
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        local ch = plr.Character
        local targetKnifeId, targetEmoteId, targetEmoteAt = resolveDesiredStateForPlayer(plr)
        if ch and ch.Parent and targetKnifeId then
            local ctrl = ensureCustomKnifeOnCharacter(plr, ch)
            if ctrl then
                -- Sync emote start/stop for P2P peers (and respawned LocalPlayer)
                if type(targetEmoteId) == "string" and targetEmoteId ~= "" then
                    if ctrl.emoteId ~= targetEmoteId or (plr ~= LocalPlayer and math.abs((ctrl.emoteAt or 0) - (targetEmoteAt or 0)) > 0.5) then
                        startCharacterEmote(plr, ch, targetEmoteId, targetEmoteAt)
                    end
                elseif ctrl.emoteId ~= "" then
                    stopCharacterEmote(plr, ch)
                end

                local bk = ctrl.botKnife
                if bk and bk.weapon and bk.weapon.Parent == ch then
                    if ctrl.emoteId ~= "" then
                        local entry = EmoteCatalog.get(ctrl.emoteId)
                        if entry and entry.HideProp == true then
                            bk:hide()
                        elseif entry and entry.Prop ~= nil then
                            local holdArm = not EmoteCatalog.holdsIdle(entry.Id, bk.skin) and "Right Arm" or nil
                            bk:show(true, holdArm)
                        else
                            bk:show(false)
                        end
                        syncKnifeLocomotionAttributes(ch, bk.weapon, false)
                    else
                        bk:update(now, true)
                        local dState = ch:GetAttribute("DaggerState")
                        local isHeld = (dState == "Held" or dState == "Drawing")
                        syncKnifeLocomotionAttributes(ch, bk.weapon, isHeld)

                        -- Clean up any server default knife animation track that conflicts with custom knife clips
                        local hum = ch:FindFirstChildOfClass("Humanoid")
                        local animator = hum and hum:FindFirstChildOfClass("Animator")
                        if animator then
                            for _, tr in ipairs(animator:GetPlayingAnimationTracks()) do
                                local animId = tr.Animation and tr.Animation.AnimationId
                                local actionName = animId and S.defaultClipIds[animId]
                                if actionName then
                                    local customClip = KnifeClips.custom(bk.weapon, actionName)
                                    if customClip and customClip ~= animId then
                                        pcall(function() tr:Stop(0) end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    for ch, ctrl in pairs(S.charControllers) do
        if not ch.Parent then
            clearControllerEmote(ctrl, true)
            if ctrl.botKnife then
                pcall(function() ctrl.botKnife:destroy() end)
            end
            S.charControllers[ch] = nil
        end
    end
end)

local function hookCharacter(plr, ch)
    if not ch then return end
    ch.ChildAdded:Connect(function(child)
        if child.Name == "EquippedDagger" then
            local targetKnifeId = resolveDesiredStateForPlayer(plr)
            if targetKnifeId then
                task.defer(function()
                    ensureCustomKnifeOnCharacter(plr, ch)
                end)
            end
        end
    end)
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr.Character then
        hookCharacter(plr, plr.Character)
    end
    plr.CharacterAdded:Connect(function(ch)
        hookCharacter(plr, ch)
    end)
end
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(ch)
        hookCharacter(plr, ch)
    end)
end)

-- ============================================================
-- 5. REAL-TIME P2P SYNC (ydx_hv1_<JobId>)
-- ============================================================
local httpRequest = (syn and syn.request)
    or (http and http.request)
    or http_request
    or (fluxus and fluxus.request)
    or request

local jobIdClean = tostring(game.JobId ~= "" and game.JobId or ("local_" .. tostring(game.PlaceId))):gsub("[^%w]", "")
local P2P_TOPIC = "ydx_hv1_" .. jobIdClean:sub(1, 24)
local P2P_URL = "https://ntfy.sh/" .. P2P_TOPIC

local function broadcastMyState(force)
    if type(httpRequest) ~= "function" then return end
    local payloadTable = {
        uid = tostring(LocalPlayer.UserId),
        name = LocalPlayer.Name,
        knife = S.equippedKnife,
        emote = S.activeEmote,
        emoteAt = math.floor((S.activeEmoteAt or 0) * 100) / 100,
        slot1 = S.emoteSlots[1] or ""
    }
    local ok, encoded = pcall(HttpService.JSONEncode, HttpService, payloadTable)
    if not ok or type(encoded) ~= "string" then return end

    local now = os.clock()
    if not force and encoded == S.lastBroadcastHash and (now - S.lastBroadcastTime) < 25 then
        return
    end
    S.lastBroadcastHash = encoded
    S.lastBroadcastTime = now

    task.spawn(function()
        pcall(function()
            httpRequest({
                Url = P2P_URL,
                Method = "POST",
                Headers = { ["Content-Type"] = "text/plain" },
                Body = encoded
            })
        end)
    end)
end
S.broadcastMyState = broadcastMyState

local function applyPeerPacket(data)
    if type(data) ~= "table" or type(data.uid) ~= "string" then return end
    if data.uid == tostring(LocalPlayer.UserId) then return end
    if type(data.knife) ~= "string" or not S.allOwnedKnives[data.knife] then return end

    local peer = S.p2pPeers[data.uid] or {}
    peer.uid = data.uid
    peer.name = data.name
    peer.knife = data.knife
    peer.emote = (type(data.emote) == "string" and S.allOwnedEmotes[data.emote] and data.emote) or ""
    peer.emoteAt = tonumber(data.emoteAt) or 0
    peer.slot1 = (type(data.slot1) == "string" and data.slot1) or ""
    S.p2pPeers[data.uid] = peer

    for _, plr in ipairs(Players:GetPlayers()) do
        if tostring(plr.UserId) == data.uid and plr.Character then
            ensureCustomKnifeOnCharacter(plr, plr.Character)
        end
    end
end

local function pollP2PMessages()
    if type(httpRequest) ~= "function" then return end
    local ok, res = pcall(function()
        return httpRequest({
            Url = P2P_URL .. "/json?poll=1&since=45s",
            Method = "GET"
        })
    end)
    if not ok or type(res) ~= "table" or type(res.Body) ~= "string" then return end

    for line in res.Body:gmatch("[^\r\n]+") do
        local okLine, outer = pcall(HttpService.JSONDecode, HttpService, line)
        if okLine and type(outer) == "table" and outer.event == "message" and type(outer.message) == "string" then
            local msgId = tostring(outer.id or outer.time or "")
            if msgId == "" or not S.seenIds[msgId] then
                if msgId ~= "" then S.seenIds[msgId] = true end
                local okInner, inner = pcall(HttpService.JSONDecode, HttpService, outer.message)
                if okInner and type(inner) == "table" then
                    applyPeerPacket(inner)
                end
            end
        end
    end
end

task.spawn(function()
    task.wait(1)
    broadcastMyState(true)
    while true do
        pollP2PMessages()
        if os.clock() - S.lastBroadcastTime >= 35 then
            broadcastMyState(false)
        end
        task.wait(2.5)
    end
end)

Players.PlayerAdded:Connect(function()
    task.delay(2, function()
        broadcastMyState(true)
    end)
end)

-- ============================================================
-- 6. LOADOUT CARD HOOKS (CAUGHT & SPECTATE LOADOUTS)
-- ============================================================
if CaughtLoadoutEvent then
    CaughtLoadoutEvent.OnClientEvent:Connect(function(info)
        if type(info) ~= "table" or info._ydxPatched then return end
        local uid = tostring(info.Catcher or info.Avatar or "")
        local peer = S.p2pPeers[uid]
        if not peer and type(info.Name) == "string" then
            for _, pr in pairs(S.p2pPeers) do
                if pr.name == info.Name then
                    peer = pr
                    break
                end
            end
        end
        if peer then
            info._ydxPatched = true
            info.Knife = peer.knife
            info.Emote = (peer.emote ~= "" and peer.emote) or (peer.slot1 ~= "" and peer.slot1) or info.Emote
            info.Owned = true
            if type(getconnections) == "function" then
                for _, conn in ipairs(getconnections(CaughtLoadoutEvent.OnClientEvent)) do
                    if conn.Function then
                        pcall(conn.Function, info)
                    end
                end
            end
        end
    end)
end

if SpectateEvent then
    SpectateEvent.OnClientEvent:Connect(function(mode, payload)
        if mode ~= "Target" or type(payload) ~= "table" or type(payload.loadout) ~= "table" or payload._ydxPatched then
            return
        end
        local uid = tostring(payload.id or payload.loadout.Avatar or "")
        local knifeOverride, emoteOverride = nil, nil
        if uid == tostring(LocalPlayer.UserId) then
            knifeOverride = S.equippedKnife
            emoteOverride = (S.activeEmote ~= "" and S.activeEmote) or (S.emoteSlots[1] ~= "" and S.emoteSlots[1]) or payload.loadout.Emote
        elseif S.p2pPeers[uid] then
            local peer = S.p2pPeers[uid]
            knifeOverride = peer.knife
            emoteOverride = (peer.emote ~= "" and peer.emote) or (peer.slot1 ~= "" and peer.slot1) or payload.loadout.Emote
        end
        if knifeOverride then
            payload._ydxPatched = true
            payload.loadout.Knife = knifeOverride
            payload.loadout.Emote = emoteOverride
            payload.loadout.Owned = true
            if type(getconnections) == "function" then
                for _, conn in ipairs(getconnections(SpectateEvent.OnClientEvent)) do
                    if conn.Function then
                        pcall(conn.Function, "Target", payload)
                    end
                end
            end
        end
    end)
end

-- ============================================================
-- 7. SERVER EVENT INTERCEPTION (__namecall & OnClientEvent)
-- ============================================================
ArmoryEvent.OnClientEvent:Connect(function(action, stateTable)
    if action == "State" and type(stateTable) == "table" and not stateTable._ydxPatched then
        task.defer(function()
            ensureArmoryBuiltAndPushState(stateTable)
        end)
    end
end)

if type(hookmetamethod) == "function" and type(getnamecallmethod) == "function" then
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if (method == "FireServer" or method == "fireServer") and not checkcaller() then
            if self == ArmoryEvent then
                local action, a1, a2 = ...
                if (action == "Equip" or action == "Buy") and type(a1) == "string" and S.allOwnedKnives[a1] then
                    S.equippedKnife = a1
                    saveLocalPreset()
                    task.defer(function()
                        ensureArmoryBuiltAndPushState(nil)
                        if LocalPlayer.Character then
                            ensureCustomKnifeOnCharacter(LocalPlayer, LocalPlayer.Character)
                        end
                        broadcastMyState(true)
                    end)
                    if S.serverOwnedKnives[a1] then
                        return oldNamecall(self, "Equip", a1)
                    end
                    return nil
                elseif action == "EquipEmote" and type(a1) == "string" and type(a2) == "number" then
                    local slotIdx = math.clamp(math.floor(a2), 1, 6)
                    if a1 ~= "" then
                        for i = 1, 6 do
                            if S.emoteSlots[i] == a1 then
                                S.emoteSlots[i] = ""
                            end
                        end
                    end
                    S.emoteSlots[slotIdx] = a1
                    saveLocalPreset()
                    task.defer(function()
                        ensureArmoryBuiltAndPushState(nil)
                        broadcastMyState(true)
                    end)
                    if a1 == "" or S.serverOwnedEmotes[a1] then
                        return oldNamecall(self, ...)
                    end
                    return nil
                end
            elseif self == EmoteEvent then
                local action, emoteId = ...
                if action == "Play" and type(emoteId) == "string" and EmoteCatalog.get(emoteId) then
                    S.activeEmote = emoteId
                    S.activeEmoteAt = workspace:GetServerTimeNow()
                    task.defer(function()
                        if LocalPlayer.Character then
                            startCharacterEmote(LocalPlayer, LocalPlayer.Character, emoteId, S.activeEmoteAt)
                        end
                        broadcastMyState(true)
                    end)
                    return nil
                elseif action == "Stop" then
                    if S.activeEmote ~= "" or (LocalPlayer.Character and LocalPlayer.Character:GetAttribute("EmoteId") ~= nil) then
                        S.activeEmote = ""
                        S.activeEmoteAt = 0
                        task.defer(function()
                            if LocalPlayer.Character then
                                stopCharacterEmote(LocalPlayer, LocalPlayer.Character)
                            end
                            broadcastMyState(true)
                        end)
                    end
                    return oldNamecall(self, ...)
                end
            end
        end
        return oldNamecall(self, ...)
    end)
end

_G.HussValleyForceRefresh = function()
    ensureArmoryBuiltAndPushState(nil)
    if LocalPlayer.Character then
        ensureCustomKnifeOnCharacter(LocalPlayer, LocalPlayer.Character)
    end
    broadcastMyState(true)
end

-- Initial state push & request server wallet/owned snapshot
task.spawn(function()
    ensureArmoryBuiltAndPushState(nil)
    if LocalPlayer.Character then
        ensureCustomKnifeOnCharacter(LocalPlayer, LocalPlayer.Character)
    end
    pcall(function()
        ArmoryEvent:FireServer("Get")
    end)
    task.wait(0.8)
    ensureArmoryBuiltAndPushState(nil)
    if LocalPlayer.Character then
        ensureCustomKnifeOnCharacter(LocalPlayer, LocalPlayer.Character)
    end
end)

print("[HussValleyUnlockAll] Loaded! All Knives & Emotes Unlocked + P2P Sync Active (" .. P2P_TOPIC .. ")")
