-- ============================================================================
-- RAGDOLL BOXING 3D - COMPLETE UNLOCK ALL + LIVE COSMETIC & KOFX ENGINE v1.0
-- PlaceId: 96740842890477 | GameId: 10770779724
-- Pure ASCII | Zero Lag | 100% Trails, Hairs, Tattoos, KOFX, KO Sounds, Emotes,
-- Titles, Name Colors, GamePasses, Story Fights & Season Pass Unlocker
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

for _, groupName in ipairs({ "HAIR", "TATTOOS", "SOUNDS", "EMOTES", "KOFX", "ALL" }) do
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
-- 2. AUTHORITATIVE CLIENT STATE (LOOK, NAME COLOR, TITLE, POSE, EMOTE)
-- ============================================================================

local updatingAttr = false
local customLook = nil
local customLookJson = nil
local customTags = {
    NameColor = LocalPlayer:GetAttribute("NameColor") or "",
    Title = LocalPlayer:GetAttribute("Title") or "",
    Pose = LocalPlayer:GetAttribute("Pose") or "",
}

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

local function applyCharacterCosmetics(char)
    char = char or LocalPlayer.Character
    if not char or not customLook then
        return
    end
    pcall(function()
        local colors = Looks.colors(customLook)
        Boxer.recolor(char, colors)
    end)
    pcall(function()
        local koId = customLook.ko
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
        if customLook.kofx and customLook.kofx ~= "" then
            char:SetAttribute("KoFx", customLook.kofx)
        end
        if customLook.intro and customLook.intro ~= "" then
            char:SetAttribute("IntroEmote", customLook.intro)
        end
    end)
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
        applyCharacterCosmetics(LocalPlayer.Character)
        task.delay(0.15, function()
            enforceUnlockAttributes()
            applyCharacterCosmetics(LocalPlayer.Character)
        end)
        task.delay(0.5, function()
            enforceUnlockAttributes()
            applyCharacterCosmetics(LocalPlayer.Character)
        end)
    elseif topic == "emote" and typeof(a) == "string" then
        local char = LocalPlayer.Character
        if char then
            pcall(function()
                char:SetAttribute("Emote", a ~= "" and a or nil)
            end)
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
                    task.defer(function()
                        updatingAttr = true
                        pcall(function()
                            LocalPlayer:SetAttribute(attrName, tagVal)
                        end)
                        updatingAttr = false
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

-- Watch fighters in our ring so when we knock out an opponent, our equipped customLook.kofx plays!
local watchedFighters = setmetatable({}, { __mode = "k" })

local function hookFighterModel(fighter)
    if not fighter or watchedFighters[fighter] then
        return
    end
    watchedFighters[fighter] = true

    if fighter == LocalPlayer.Character then
        applyCharacterCosmetics(fighter)
    end

    local function checkOpponentKO()
        local myChar = LocalPlayer.Character
        if not myChar or fighter == myChar then
            return
        end
        local myRing = myChar:GetAttribute("Ring") or ""
        if myRing == "" or fighter:GetAttribute("Ring") ~= myRing then
            return
        end
        local isDown = fighter:GetAttribute("Down") == true
        local headHp = fighter:GetAttribute("Head") or 100
        local koClock = fighter:GetAttribute("KoClock")
        if isDown and (headHp <= 0 or (koClock and os.clock() - koClock < 1.5)) then
            local kofxId = customLook and customLook.kofx
            if typeof(kofxId) == "string" and kofxId ~= "" then
                -- Wait a tiny moment to see if the server already spawned KoFxPlaying
                task.delay(0.08, function()
                    if not fighter:GetAttribute("KoFxPlaying") then
                        triggerClientKoFx(fighter, kofxId)
                    end
                end)
            end
        end
    end

    trackConn(fighter:GetAttributeChangedSignal("Down"):Connect(checkOpponentKO))
    trackConn(fighter:GetAttributeChangedSignal("KoClock"):Connect(checkOpponentKO))
    trackConn(fighter:GetAttributeChangedSignal("Ring"):Connect(function()
        if fighter == LocalPlayer.Character then
            task.defer(applyCharacterCosmetics, fighter)
            task.delay(0.25, applyCharacterCosmetics, fighter)
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

-- Periodic lightweight sync (every 0.5s) to keep character cosmetics, KoSound, and attributes intact
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
        elseif customLook.hair and customLook.hair ~= "" and not char:FindFirstChild("Hair") then
            applyCharacterCosmetics(char)
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
end

print(string.format(
    "[BoxingUnlockAll]UNLOCKED 100%%! Trails=%d | Items=%d | Titles=%d | Passes=%d | Story=%d",
    #allTrailIds,
    #allItemIds,
    #allTitleIds,
    #allPassIds,
    maxStoryAt - 1
))
