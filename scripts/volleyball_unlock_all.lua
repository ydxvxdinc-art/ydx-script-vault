-- ============================================================================
-- [UPD] VOLLEYBALL LEGENDS - UNLOCK ALL + REAL-TIME P2P SYNC
-- Categories Unlocked:
--   * Balls (210+ Balls including Secret, Godly, Season, Ranked, Bundle, VIP)
--   * Score Effects / Score FX (185+ Score Effects + Random Favorite)
--   * Titles (650+ Titles including Owner, Developer, VIP, Season & Tournament #1)
--   * Emotes (90+ Emotes + Props + Sounds + Walkable Emotes + All 8 Wheel Slots)
--   * Player Cards (120+ Cards + FlashCard on Point Scored & MVP + Random Favorite)
--   * Chat Bubbles (All Chat Bubbles + All 8 Wheel Slots)
--   * Misc / Jerseys / Profile Art / Win Screens (All Jerseys, Profile Arts, Win Cutscenes)
--   * Profile Inspect Showcase (Equip any Title, Profile Art, Jersey, Card on Profile)
--   * Real-Time P2P Sync (Other script users in the same server see your equipped
--     Ball skin, Score FX, FlashCard, Title, Jersey, Emote + 3D Prop, and Chat Bubble)
-- ============================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer = Players.LocalPlayer
end

-- Wait for core packages and data load
local Packages = ReplicatedStorage:WaitForChild("Packages", 15)
local Content = ReplicatedStorage:WaitForChild("Content", 15)
if not Packages or not Content then
    warn("[VolleyballUnlockAll] Failed to locate ReplicatedStorage.Packages/Content!")
    return
end

local Knit = require(Packages:WaitForChild("Knit"))
pcall(function()
    Knit.OnStart():expect()
end)

local Promise = require(Packages:WaitForChild("Promise"))
local Item = require(Content:WaitForChild("Item"))
local GamepassesList = nil
pcall(function()
    GamepassesList = require(Content:WaitForChild("Monetization"):WaitForChild("Gamepasses"))
end)

local JerseyTool = nil
pcall(function()
    JerseyTool = require(ReplicatedStorage:WaitForChild("Tools"):WaitForChild("Jersey"))
end)

local SoundTool = nil
pcall(function()
    SoundTool = require(ReplicatedStorage:WaitForChild("Tools", 5):WaitForChild("Sound", 5))
end)

local Persistence = nil
pcall(function()
    Persistence = require(ReplicatedFirst:WaitForChild("Components", 5):WaitForChild("Persistence", 5))
end)

local InventoryState = require(ReplicatedFirst:WaitForChild("UI"):WaitForChild("Screens"):WaitForChild("Inventory"):WaitForChild("State"))
local InspectState = nil
pcall(function()
    InspectState = require(ReplicatedFirst:WaitForChild("UI"):WaitForChild("Screens"):WaitForChild("PlayerInspect"):WaitForChild("State"))
end)

local InventoryController = nil
local EmoteController = nil
local ChatBubbleController = nil
local BallController = nil
local EffectController = nil
local PlayerCardController = nil
local AnimationController = nil

pcall(function() InventoryController = Knit.GetController("InventoryController") end)
pcall(function() EmoteController = Knit.GetController("EmoteController") end)
pcall(function() ChatBubbleController = Knit.GetController("ChatBubbleController") end)
pcall(function() BallController = Knit.GetController("BallController") end)
pcall(function() EffectController = Knit.GetController("EffectController") end)
pcall(function() PlayerCardController = Knit.GetController("PlayerCardController") end)
pcall(function() AnimationController = Knit.GetController("AnimationController") end)

local InventoryService = nil
local DataService = nil
local BallService = nil
local GameService = nil
local PlayerCardService = nil
local PlayerInspectService = nil

pcall(function() InventoryService = Knit.GetService("InventoryService") end)
pcall(function() DataService = Knit.GetService("DataService") end)
pcall(function() BallService = Knit.GetService("BallService") end)
pcall(function() GameService = Knit.GetService("GameService") end)
pcall(function() PlayerCardService = Knit.GetService("PlayerCardService") end)
pcall(function() PlayerInspectService = Knit.GetService("PlayerInspectService") end)

-- If already loaded, just re-unlock and refresh
if _G.__VolleyballUnlockAllLoaded then
    if type(_G.__VolleyballUnlockAllRefresh) == "function" then
        _G.__VolleyballUnlockAllRefresh()
    end
    warn("[VolleyballUnlockAll] Already loaded! Refreshed all unlocked items.")
    return
end
_G.__VolleyballUnlockAllLoaded = true

-- ============================================================================
-- 1. STATE & PRESET PERSISTENCE
-- ============================================================================
local SAVE_FILE = "volleyball_saved_preset.json"
local realServerInventory = {}
local customEquipped = {
    Ball = "ClassicBall",
    ScoreEffect = "ClassicScoreEffect",
    Title = "",
    PlayerCard = "Classic1PlayerCard",
    Jersey = "ClassicJersey",
    ProfileArt = "ClassicProfileArt",
    WinScreen = "ClassicWinScreen",
    Emotes = { "WaveEmote", "", "", "", "", "", "", "" },
    ChatBubbles = { "AngryRobuxChatBubble", "", "", "", "", "", "", "" }
}
local customFavorited = {}
local customShowcaseItems = { "Classic1PlayerCard", "", "", "" }

-- Snapshot existing server inventory & equipped items first
pcall(function()
    local curInv = InventoryState.inventory()
    if type(curInv) == "table" then
        for k, v in pairs(curInv) do
            if type(k) == "string" and type(v) == "number" and v > 0 then
                realServerInventory[k] = v
            end
        end
    end
end)

pcall(function()
    local curEq = InventoryState.equipped()
    if type(curEq) == "table" then
        for k, v in pairs(curEq) do
            if type(v) == "table" then
                customEquipped[k] = table.clone(v)
            elseif v ~= nil then
                customEquipped[k] = v
            end
        end
    end
end)

pcall(function()
    local curFav = InventoryState.favorited()
    if type(curFav) == "table" then
        for k, v in pairs(curFav) do
            if v then
                customFavorited[k] = true
            end
        end
    end
end)

local function ensureEightSlots(tbl, defaultFirst)
    if type(tbl) ~= "table" then
        tbl = {}
    end
    for i = 1, 8 do
        if type(tbl[i]) ~= "string" then
            tbl[i] = (i == 1 and defaultFirst) or ""
        end
    end
    return tbl
end

customEquipped.Emotes = ensureEightSlots(customEquipped.Emotes, "WaveEmote")
customEquipped.ChatBubbles = ensureEightSlots(customEquipped.ChatBubbles, "AngryRobuxChatBubble")

local function loadSavedPreset()
    if type(isfile) ~= "function" or type(readfile) ~= "function" then
        return
    end
    local ok, exists = pcall(isfile, SAVE_FILE)
    if not ok or not exists then
        return
    end
    local okRead, raw = pcall(readfile, SAVE_FILE)
    if not okRead or type(raw) ~= "string" or #raw == 0 then
        return
    end
    local okDec, data = pcall(function()
        return HttpService:JSONDecode(raw)
    end)
    if not okDec or type(data) ~= "table" then
        return
    end
    if type(data.equipped) == "table" then
        for k, v in pairs(data.equipped) do
            if type(v) == "table" then
                customEquipped[k] = table.clone(v)
            elseif type(v) == "string" then
                customEquipped[k] = v
            end
        end
        customEquipped.Emotes = ensureEightSlots(customEquipped.Emotes, "WaveEmote")
        customEquipped.ChatBubbles = ensureEightSlots(customEquipped.ChatBubbles, "AngryRobuxChatBubble")
    end
    if type(data.favorited) == "table" then
        for k, v in pairs(data.favorited) do
            if v == true then
                customFavorited[k] = true
            else
                customFavorited[k] = nil
            end
        end
    end
    if type(data.showcaseItems) == "table" then
        for i = 1, 4 do
            if type(data.showcaseItems[i]) == "string" then
                customShowcaseItems[i] = data.showcaseItems[i]
            end
        end
    end
end

local function savePreset()
    if type(writefile) ~= "function" then
        return
    end
    pcall(function()
        local payload = HttpService:JSONEncode({
            equipped = customEquipped,
            favorited = customFavorited,
            showcaseItems = customShowcaseItems
        })
        writefile(SAVE_FILE, payload)
    end)
end

loadSavedPreset()

-- ============================================================================
-- 2. TITLE & JERSEY HELPERS
-- ============================================================================
local function formatTitleRichText(titleId)
    if type(titleId) ~= "string" or titleId == "" then
        return ""
    end
    local item = Item:Get(titleId)
    if not item or item.Type ~= Item.Type.Title then
        return ""
    end
    local display = item.DisplayName or titleId
    if item.Metadata and item.Metadata.SeasonId then
        display = string.format("S%s Ultimate Champion", tostring(item.Metadata.SeasonId))
    end
    local col = (item.Metadata and item.Metadata.Color) or item.Color or Color3.new(1, 1, 1)
    local hex = "ffffff"
    if typeof(col) == "Color3" then
        hex = col:ToHex()
    elseif type(col) == "string" then
        hex = col:gsub("^#", "")
    end
    return string.format("<font color='#%s'>[%s]</font>", hex, display)
end

local function applyTitleToPlayer(player, titleId)
    if not player then
        return
    end
    pcall(function()
        local formatted = formatTitleRichText(titleId)
        player:SetAttribute("User_Title", formatted)
    end)
end

local function applyJerseyToCharacter(player, character, jerseyId)
    if not player or not character or not JerseyTool then
        return
    end
    if type(jerseyId) ~= "string" or jerseyId == "" then
        jerseyId = "ClassicJersey"
    end
    local item = Item:Get(jerseyId)
    if not item or item.Type ~= Item.Type.Jersey then
        jerseyId = "ClassicJersey"
    end
    task.spawn(function()
        pcall(function()
            local teamName = nil
            if player.Team then
                teamName = player.Team.Name
            end
            JerseyTool.set({
                Id = jerseyId,
                Player = player,
                Character = character,
                TeamName = teamName
            })
        end)
    end)
end

local function pickResolvedScoreEffect(effectId, favMap)
    if effectId == "RandomFavoriteScoreEffect" then
        local pool = {}
        for id, isFav in pairs(favMap or customFavorited) do
            if isFav then
                local it = Item:Get(id)
                if it and it.Type == Item.Type.ScoreEffect and id ~= "RandomFavoriteScoreEffect" then
                    table.insert(pool, id)
                end
            end
        end
        if #pool > 0 then
            return pool[math.random(1, #pool)]
        end
        return "ClassicScoreEffect"
    end
    if type(effectId) == "string" and effectId ~= "" and Item:Get(effectId) then
        return effectId
    end
    return "ClassicScoreEffect"
end

local function pickResolvedPlayerCard(cardId, favMap)
    if cardId == "RandomFavoritePlayerCard" then
        local pool = {}
        for id, isFav in pairs(favMap or customFavorited) do
            if isFav then
                local it = Item:Get(id)
                if it and it.Type == Item.Type.PlayerCard and id ~= "RandomFavoritePlayerCard" then
                    table.insert(pool, id)
                end
            end
        end
        if #pool > 0 then
            return pool[math.random(1, #pool)]
        end
        return "Classic1PlayerCard"
    end
    if type(cardId) == "string" and cardId ~= "" and Item:Get(cardId) then
        return cardId
    end
    return "Classic1PlayerCard"
end

-- ============================================================================
-- 3. UNLOCK ALL INVENTORY, GAMEPASSES & REACTIVE STATE
-- ============================================================================
local UNLOCK_TYPES = {
    [Item.Type.Ball] = true,
    [Item.Type.ScoreEffect] = true,
    [Item.Type.Title] = true,
    [Item.Type.Emote] = true,
    [Item.Type.PlayerCard] = true,
    [Item.Type.ChatBubble] = true,
    [Item.Type.Jersey] = true,
    [Item.Type.ProfileArt] = true,
    [Item.Type.WinScreen] = true
}

local unlockedCountsByType = {}

local function buildFullInventoryTable(baseInv)
    local full = {}
    if type(baseInv) == "table" then
        for k, v in pairs(baseInv) do
            if type(k) == "string" then
                full[k] = v
            end
        end
    end
    table.clear(unlockedCountsByType)
    for _, item in pairs(Item:GetAll()) do
        if type(item) == "table" and type(item.Id) == "string" and UNLOCK_TYPES[item.Type] then
            local itemId = item.Id
            if type(full[itemId]) ~= "number" or full[itemId] < 1 then
                full[itemId] = 1
            end
            unlockedCountsByType[item.Type] = (unlockedCountsByType[item.Type] or 0) + 1
        end
    end
    return full
end

local function buildFullGamepassesTable(baseGp)
    local gp = {}
    if type(baseGp) == "table" then
        for k, v in pairs(baseGp) do
            gp[k] = v
        end
    end
    if type(GamepassesList) == "table" then
        for _, entry in ipairs(GamepassesList) do
            if type(entry) == "table" and entry.Id then
                -- Unlock cosmetic & utility gamepasses (VIP, DoubleEmotes, DoubleChatBubbles, StyleSkip, CrabRaveEmote)
                local name = tostring(entry.Name or "")
                if name == "VIP" or name == "DoubleEmotes" or name == "DoubleChatBubbles" or name == "StyleSkip" or name == "CrabRaveEmote" then
                    gp[tostring(entry.Id)] = true
                    gp[entry.Id] = true
                end
            end
        end
    end
    return gp
end

local isUpdatingCells = false

local function withNormalIdentity(fn)
    local setId = setthreadidentity or setidentity or (syn and syn.set_thread_identity)
    local getId = getthreadidentity or getidentity or (syn and syn.get_thread_identity)
    local prevId = nil
    if type(getId) == "function" and type(setId) == "function" then
        local ok, id = pcall(getId)
        if ok and type(id) == "number" and id > 2 then
            prevId = id
            pcall(setId, 2)
        end
    end
    local okRun, errRun = pcall(fn)
    if prevId and type(setId) == "function" then
        pcall(setId, prevId)
    end
    return okRun, errRun
end

local function pushStateToUI()
    if isUpdatingCells then
        return
    end
    isUpdatingCells = true
    withNormalIdentity(function()
        pcall(function()
            local fullInv = buildFullInventoryTable(realServerInventory)
            InventoryState.inventory(fullInv)
            if Persistence and Persistence.Data and Persistence.Data["Inventory"] then
                Persistence.Data["Inventory"](fullInv)
            end
        end)
        pcall(function()
            local eqClone = table.clone(customEquipped)
            eqClone.Emotes = table.clone(customEquipped.Emotes)
            eqClone.ChatBubbles = table.clone(customEquipped.ChatBubbles)
            InventoryState.equipped(eqClone)
            if Persistence and Persistence.Data and Persistence.Data["Equipped"] then
                Persistence.Data["Equipped"](eqClone)
            end
            if EmoteController and EmoteController.Emotes then
                EmoteController.Emotes(table.clone(customEquipped.Emotes))
            end
        end)
        pcall(function()
            local favClone = table.clone(customFavorited)
            InventoryState.favorited(favClone)
            if Persistence and Persistence.Data and Persistence.Data["Favorited"] then
                Persistence.Data["Favorited"](favClone)
            end
        end)
        pcall(function()
            if Persistence and type(Persistence.bindToData) == "function" then
                local gpCell = Persistence.bindToData("Gamepasses")
                if gpCell then
                    gpCell(buildFullGamepassesTable(gpCell()))
                end
            end
            LocalPlayer:SetAttribute("User_IsVIP", true)
            LocalPlayer:SetAttribute("User_CanSkip", true)
        end)
        pcall(function()
            applyTitleToPlayer(LocalPlayer, customEquipped.Title)
            if LocalPlayer.Character then
                applyJerseyToCharacter(LocalPlayer, LocalPlayer.Character, customEquipped.Jersey)
            end
        end)
        pcall(function()
            if InspectState and InspectState.isCustomizing and InspectState.isCustomizing() then
                InspectState.title(customEquipped.Title)
                InspectState.art(customEquipped.ProfileArt)
                InspectState.jersey(customEquipped.Jersey)
                InspectState.items(table.clone(customShowcaseItems))
            end
        end)
    end)
    isUpdatingCells = false
end

_G.__VolleyballUnlockAllRefresh = pushStateToUI
pushStateToUI()

-- Keep User_Title & Jersey applied on LocalPlayer when server attributes or character change
LocalPlayer:GetAttributeChangedSignal("User_Title"):Connect(function()
    if isUpdatingCells then
        return
    end
    local expected = formatTitleRichText(customEquipped.Title)
    if LocalPlayer:GetAttribute("User_Title") ~= expected then
        isUpdatingCells = true
        LocalPlayer:SetAttribute("User_Title", expected)
        isUpdatingCells = false
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.25)
    applyTitleToPlayer(LocalPlayer, customEquipped.Title)
    applyJerseyToCharacter(LocalPlayer, char, customEquipped.Jersey)
end)

-- If DataService.ProfileUpdated fires from server, merge real inventory and re-apply unlocked state
if DataService and DataService.ProfileUpdated then
    pcall(function()
        DataService.ProfileUpdated:Connect(function(key, val)
            if key == "Inventory" and type(val) == "table" then
                for k, v in pairs(val) do
                    if type(v) == "number" and v > 0 then
                        realServerInventory[k] = v
                    end
                end
                task.defer(pushStateToUI)
            elseif key == "Equipped" or key == "Favorited" or key == "Gamepasses" then
                task.defer(pushStateToUI)
            end
        end)
    end)
end

-- ============================================================================
-- 4. CLIENT EMOTE PROP & SOUND RUNNER (FOR UNOWNED EMOTES & P2P PEERS)
-- ============================================================================
local activeEmoteCleanups = {} -- [Player] = { cleanupFn, soundInst, track, walkConn }

local function stopCustomEmoteOnPlayer(player)
    local state = activeEmoteCleanups[player]
    if not state then
        return
    end
    activeEmoteCleanups[player] = nil
    if state.walkConn then
        pcall(function() state.walkConn:Disconnect() end)
    end
    if state.cleanupFn then
        pcall(state.cleanupFn)
    end
    if state.soundInst then
        pcall(function()
            if type(state.soundInst) == "table" and state.soundInst.Destroy then
                state.soundInst:Destroy()
            elseif typeof(state.soundInst) == "Instance" then
                state.soundInst:Stop()
                state.soundInst:Destroy()
            end
        end)
    end
    if state.track then
        pcall(function()
            state.track:Stop(0.15)
            state.track:Destroy()
        end)
    end
    if state.walkTrack then
        pcall(function()
            state.walkTrack:Stop(0.15)
            state.walkTrack:Destroy()
        end)
    end
end

local function playCustomEmoteOnPlayer(player, itemId, isLocal)
    if not player or not player.Character then
        return
    end
    local item = Item:Get(itemId)
    if not item or item.Type ~= Item.Type.Emote then
        return
    end

    stopCustomEmoteOnPlayer(player)

    local char = player.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildOfClass("Animator")
    local state = {}
    activeEmoteCleanups[player] = state

    -- For remote P2P peers, also load & play the emote animation on their character
    if not isLocal and animator and item.Asset then
        pcall(function()
            local anim = item.Asset:Clone()
            local track = animator:LoadAnimation(anim)
            track.Priority = Enum.AnimationPriority.Action
            track.Looped = (item.Metadata and item.Metadata.Looped == true) or false
            track:Play(0.15)
            state.track = track

            if item.Metadata and item.Metadata.WalkAsset then
                local walkAnim = item.Metadata.WalkAsset:Clone()
                local walkTrack = animator:LoadAnimation(walkAnim)
                walkTrack.Priority = Enum.AnimationPriority.Movement
                walkTrack.Looped = true
                state.walkTrack = walkTrack
            end
        end)
    end

    -- Spawn 3D Emote Prop via item.Metadata.Handler.run
    if item.Metadata and item.Metadata.Handler and type(item.Metadata.Handler.run) == "function" then
        local ok, cleanup = pcall(item.Metadata.Handler.run, {
            Character = char
        })
        if ok and type(cleanup) == "function" then
            state.cleanupFn = cleanup
        end
    end

    -- Play Emote Sound
    if item.Metadata and item.Metadata.Sound then
        pcall(function()
            if SoundTool and type(SoundTool.new) == "function" then
                state.soundInst = SoundTool.new({
                    Id = item.Metadata.Sound,
                    Parent = char.PrimaryPart or char,
                    Volume = 0.4,
                    IsEmote = true,
                    RollOffMaxDistance = 60,
                    Looped = item.Metadata.Looped
                })
            else
                local snd = Instance.new("Sound")
                snd.SoundId = tostring(item.Metadata.Sound)
                snd.Volume = 0.4
                snd.Looped = (item.Metadata.Looped == true)
                snd.RollOffMaxDistance = 60
                snd.Parent = char.PrimaryPart or char
                snd:Play()
                state.soundInst = snd
            end
        end)
    end

    -- Auto-cleanup if non-walkable and character walks/jumps
    if hum then
        local startTime = os.clock()
        state.walkConn = RunService.Heartbeat:Connect(function()
            if not char.Parent or hum.Health <= 0 then
                stopCustomEmoteOnPlayer(player)
                return
            end
            if os.clock() - startTime < 0.25 then
                return
            end
            local isMoving = hum.MoveDirection.Magnitude > 0.05 or char:GetAttribute("Jumping") == true
            local isWalkable = item.Metadata and (item.Metadata.IsWalkable or item.Metadata.WalkAsset)
            if isMoving and not isWalkable then
                stopCustomEmoteOnPlayer(player)
            elseif not isLocal and state.walkTrack then
                if hum.MoveDirection.Magnitude > 0.05 then
                    if not state.walkTrack.IsPlaying then
                        state.walkTrack:Play(0.15)
                    end
                else
                    if state.walkTrack.IsPlaying then
                        state.walkTrack:Stop(0.15)
                    end
                end
            end
        end)
    end
end

-- Also hook AnimationController.StopAllEmotes so local emote prop cleans up immediately
if AnimationController and type(AnimationController.StopAllEmotes) == "function" then
    local origStopAll = AnimationController.StopAllEmotes
    AnimationController.StopAllEmotes = function(self, ...)
        stopCustomEmoteOnPlayer(LocalPlayer)
        return origStopAll(self, ...)
    end
end

-- ============================================================================
-- 5. REAL-TIME P2P SYNC (NTFY.SH)
-- ============================================================================
local peerCosmetics = {} -- [userIdStr] = { equipped = {...}, favorited = {...}, emote = ..., emoteSeq = ..., bubble = ..., bubbleSeq = ... }
local lastPeerSeq = {}
local mySeq = 0
local currentEmoteId = ""
local currentEmoteSeq = 0
local currentBubbleId = ""
local currentBubbleSeq = 0

local httpRequest = (syn and syn.request)
    or (http and http.request)
    or http_request
    or (fluxus and fluxus.request)
    or request

local jobClean = (game.JobId ~= "" and game.JobId or ("local_" .. tostring(game.PlaceId))):gsub("[^%w]", ""):sub(1, 24)
local P2P_TOPIC = "ydx_vbl1_" .. jobClean
local P2P_URL = "https://ntfy.sh/" .. P2P_TOPIC

local lastBroadcastHash = ""
local lastBroadcastTime = 0

local function buildP2PPayload()
    mySeq = mySeq + 1
    local favList = {}
    for id, isFav in pairs(customFavorited) do
        if isFav then
            table.insert(favList, id)
        end
    end
    return {
        uid = tostring(LocalPlayer.UserId),
        name = LocalPlayer.Name,
        seq = mySeq,
        eq = {
            Ball = customEquipped.Ball,
            ScoreEffect = customEquipped.ScoreEffect,
            Title = customEquipped.Title,
            PlayerCard = customEquipped.PlayerCard,
            Jersey = customEquipped.Jersey,
            ProfileArt = customEquipped.ProfileArt,
            WinScreen = customEquipped.WinScreen
        },
        fav = favList,
        shw = customShowcaseItems,
        em = currentEmoteId,
        emSeq = currentEmoteSeq,
        cb = currentBubbleId,
        cbSeq = currentBubbleSeq
    }
end

local function broadcastP2P(force)
    if type(httpRequest) ~= "function" then
        return
    end
    local payload = buildP2PPayload()
    local ok, encoded = pcall(function()
        return HttpService:JSONEncode(payload)
    end)
    if not ok or type(encoded) ~= "string" then
        return
    end
    local stateKey = table.concat({
        tostring(payload.eq.Ball),
        tostring(payload.eq.ScoreEffect),
        tostring(payload.eq.Title),
        tostring(payload.eq.PlayerCard),
        tostring(payload.eq.Jersey),
        tostring(payload.eq.ProfileArt),
        tostring(payload.eq.WinScreen),
        tostring(payload.em),
        tostring(payload.emSeq),
        tostring(payload.cb),
        tostring(payload.cbSeq)
    }, "|")
    local now = os.clock()
    if not force and stateKey == lastBroadcastHash and (now - lastBroadcastTime) < 5 then
        return
    end
    lastBroadcastHash = stateKey
    lastBroadcastTime = now

    task.spawn(function()
        pcall(httpRequest, {
            Url = P2P_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "text/plain",
                ["Title"] = "vbl_sync"
            },
            Body = encoded
        })
    end)
end

local function applyPeerData(data)
    if type(data) ~= "table" or not data.uid then
        return
    end
    local uidStr = tostring(data.uid)
    if uidStr == tostring(LocalPlayer.UserId) then
        return
    end
    local seq = tonumber(data.seq) or 0
    if lastPeerSeq[uidStr] and seq < lastPeerSeq[uidStr] then
        return
    end
    lastPeerSeq[uidStr] = seq

    local prev = peerCosmetics[uidStr] or {}
    local favMap = {}
    if type(data.fav) == "table" then
        for _, id in ipairs(data.fav) do
            favMap[id] = true
        end
    end

    local peerState = {
        equipped = type(data.eq) == "table" and data.eq or (prev.equipped or {}),
        favorited = favMap,
        showcaseItems = type(data.shw) == "table" and data.shw or (prev.showcaseItems or {}),
        emote = data.em or "",
        emoteSeq = tonumber(data.emSeq) or 0,
        bubble = data.cb or "",
        bubbleSeq = tonumber(data.cbSeq) or 0
    }
    peerCosmetics[uidStr] = peerState

    local peerPlayer = Players:GetPlayerByUserId(tonumber(uidStr) or 0)
    if not peerPlayer then
        return
    end

    -- 1. Apply Title
    if peerState.equipped.Title ~= nil then
        applyTitleToPlayer(peerPlayer, peerState.equipped.Title)
    end

    -- 2. Apply Jersey
    if peerPlayer.Character and peerState.equipped.Jersey then
        if not prev.equipped or prev.equipped.Jersey ~= peerState.equipped.Jersey then
            applyJerseyToCharacter(peerPlayer, peerPlayer.Character, peerState.equipped.Jersey)
        end
    end

    -- 3. Trigger Emote if new emoteSeq
    if peerState.emoteSeq > (prev.emoteSeq or 0) then
        if peerState.emote == "" or peerState.emote == "__STOP__" then
            stopCustomEmoteOnPlayer(peerPlayer)
        else
            playCustomEmoteOnPlayer(peerPlayer, peerState.emote, false)
        end
    end

    -- 4. Trigger ChatBubble if new bubbleSeq
    if peerState.bubbleSeq > (prev.bubbleSeq or 0) and peerState.bubble ~= "" then
        if ChatBubbleController and type(ChatBubbleController.DisplayChatBubble) == "function" then
            pcall(function()
                ChatBubbleController:DisplayChatBubble(peerPlayer, peerState.bubble)
            end)
        end
    end
end

local function hookPeerPlayer(player)
    if player == LocalPlayer then
        return
    end
    player.CharacterAdded:Connect(function(char)
        task.wait(0.25)
        local peer = peerCosmetics[tostring(player.UserId)]
        if peer and peer.equipped then
            if peer.equipped.Title then
                applyTitleToPlayer(player, peer.equipped.Title)
            end
            if peer.equipped.Jersey then
                applyJerseyToCharacter(player, char, peer.equipped.Jersey)
            end
        end
    end)
    player:GetAttributeChangedSignal("User_Title"):Connect(function()
        local peer = peerCosmetics[tostring(player.UserId)]
        if peer and peer.equipped and peer.equipped.Title and peer.equipped.Title ~= "" then
            local expected = formatTitleRichText(peer.equipped.Title)
            if player:GetAttribute("User_Title") ~= expected then
                player:SetAttribute("User_Title", expected)
            end
        end
    end)
end

for _, p in ipairs(Players:GetPlayers()) do
    hookPeerPlayer(p)
end
Players.PlayerAdded:Connect(function(p)
    hookPeerPlayer(p)
    task.delay(2, function()
        broadcastP2P(true)
    end)
end)

-- Poll P2P messages from ntfy.sh
if type(httpRequest) == "function" then
    task.spawn(function()
        broadcastP2P(true)
        local sinceParam = "30s"
        while _G.__VolleyballUnlockAllLoaded do
            local ok, resp = pcall(httpRequest, {
                Url = P2P_URL .. "/json?poll=1&since=" .. sinceParam,
                Method = "GET"
            })
            if ok and type(resp) == "table" and type(resp.Body) == "string" and #resp.Body > 0 then
                for line in resp.Body:gmatch("[^\r\n]+") do
                    local okLine, env = pcall(function()
                        return HttpService:JSONDecode(line)
                    end)
                    if okLine and type(env) == "table" then
                        if env.id then
                            sinceParam = tostring(env.id)
                        end
                        if env.event == "message" and type(env.message) == "string" then
                            local okMsg, msgData = pcall(function()
                                return HttpService:JSONDecode(env.message)
                            end)
                            if okMsg and type(msgData) == "table" then
                                applyPeerData(msgData)
                            end
                        end
                    end
                end
            end
            task.wait(1.5)
        end
    end)
end

-- ============================================================================
-- 6. HOOK INVENTORYSERVICE (EQUIP, TOGGLEFAVORITE, USE, STOPEMOTES)
-- ============================================================================
if InventoryService then
    local origEquip = InventoryService.Equip
    local origToggleFavorite = InventoryService.ToggleFavorite
    local origUse = InventoryService.Use
    local origStopEmotes = InventoryService.StopEmotes

    InventoryService.Equip = function(self, itemId, slotIndex, ...)
        local item = Item:Get(itemId)
        if item then
            if item.Type == Item.Type.Emote then
                local slot = tonumber(slotIndex) or 1
                customEquipped.Emotes[slot] = itemId
            elseif item.Type == Item.Type.ChatBubble then
                local slot = tonumber(slotIndex) or 1
                customEquipped.ChatBubbles[slot] = itemId
            elseif item.Type == Item.Type.Title then
                if customEquipped.Title == itemId then
                    customEquipped.Title = ""
                else
                    customEquipped.Title = itemId
                end
            elseif item.Type == Item.Type.PlayerCard then
                if customEquipped.PlayerCard == itemId then
                    customEquipped.PlayerCard = "Classic1PlayerCard"
                else
                    customEquipped.PlayerCard = itemId
                end
            elseif UNLOCK_TYPES[item.Type] then
                local defaultId = "Classic" .. tostring(item.Type)
                if customEquipped[item.Type] == itemId and Item:Get(defaultId) then
                    customEquipped[item.Type] = defaultId
                else
                    customEquipped[item.Type] = itemId
                end
            end

            pushStateToUI()
            savePreset()
            broadcastP2P(true)

            -- If truly owned on server, also let server know
            if realServerInventory[itemId] and realServerInventory[itemId] > 0 and type(origEquip) == "function" then
                pcall(origEquip, self, itemId, slotIndex, ...)
            end
            return Promise.resolve(nil)
        end
        if type(origEquip) == "function" then
            return origEquip(self, itemId, slotIndex, ...)
        end
        return Promise.resolve(nil)
    end

    InventoryService.ToggleFavorite = function(self, itemId, ...)
        if type(itemId) == "string" and Item:Get(itemId) then
            if customFavorited[itemId] then
                customFavorited[itemId] = nil
            else
                customFavorited[itemId] = true
            end
            pushStateToUI()
            savePreset()
            broadcastP2P(false)

            if realServerInventory[itemId] and realServerInventory[itemId] > 0 and type(origToggleFavorite) == "function" then
                pcall(origToggleFavorite, self, itemId, ...)
            end
            return Promise.resolve(nil)
        end
        if type(origToggleFavorite) == "function" then
            return origToggleFavorite(self, itemId, ...)
        end
        return Promise.resolve(nil)
    end

    InventoryService.Use = function(self, itemId, ...)
        local item = Item:Get(itemId)
        if item then
            if item.Type == Item.Type.Emote then
                currentEmoteId = itemId
                currentEmoteSeq = currentEmoteSeq + 1
                broadcastP2P(true)

                if realServerInventory[itemId] and realServerInventory[itemId] > 0 and type(origUse) == "function" then
                    stopCustomEmoteOnPlayer(LocalPlayer)
                    return origUse(self, itemId, ...)
                else
                    playCustomEmoteOnPlayer(LocalPlayer, itemId, true)
                    return Promise.resolve(nil)
                end
            elseif item.Type == Item.Type.ChatBubble then
                currentBubbleId = itemId
                currentBubbleSeq = currentBubbleSeq + 1
                broadcastP2P(true)

                if realServerInventory[itemId] and realServerInventory[itemId] > 0 and type(origUse) == "function" then
                    return origUse(self, itemId, ...)
                else
                    if ChatBubbleController and type(ChatBubbleController.DisplayChatBubble) == "function" then
                        pcall(function()
                            ChatBubbleController:DisplayChatBubble(LocalPlayer, itemId)
                        end)
                    end
                    return Promise.resolve(nil)
                end
            end
        end
        if type(origUse) == "function" then
            return origUse(self, itemId, ...)
        end
        return Promise.resolve(nil)
    end

    InventoryService.StopEmotes = function(self, ...)
        stopCustomEmoteOnPlayer(LocalPlayer)
        if currentEmoteId ~= "" then
            currentEmoteId = "__STOP__"
            currentEmoteSeq = currentEmoteSeq + 1
            broadcastP2P(true)
        end
        if type(origStopEmotes) == "function" then
            return origStopEmotes(self, ...)
        end
        return Promise.resolve(nil)
    end
end

-- ============================================================================
-- 7. HOOK PLAYERINSPECTSERVICE (PROFILE ART, SHOWCASE CARDS, PEER PROFILE)
-- ============================================================================
if PlayerInspectService then
    local origGetInspectData = PlayerInspectService.GetInspectData
    local origSetInspectField = PlayerInspectService.SetInspectField

    PlayerInspectService.GetInspectData = function(self, targetUserId, ...)
        if type(origGetInspectData) ~= "function" then
            return Promise.resolve(nil)
        end
        return origGetInspectData(self, targetUserId, ...):andThen(function(ok, result)
            if ok and type(result) == "table" then
                if tonumber(targetUserId) == LocalPlayer.UserId then
                    result.Title = customEquipped.Title
                    result.Art = customEquipped.ProfileArt
                    result.Jersey = customEquipped.Jersey
                    if type(result.Items) == "table" then
                        for i = 1, 4 do
                            if customShowcaseItems[i] and customShowcaseItems[i] ~= "" then
                                result.Items[i] = customShowcaseItems[i]
                            end
                        end
                    end
                else
                    local peer = peerCosmetics[tostring(targetUserId)]
                    if peer and peer.equipped then
                        if peer.equipped.Title and peer.equipped.Title ~= "" then
                            result.Title = peer.equipped.Title
                        end
                        if peer.equipped.ProfileArt and peer.equipped.ProfileArt ~= "" then
                            result.Art = peer.equipped.ProfileArt
                        end
                        if peer.equipped.Jersey and peer.equipped.Jersey ~= "" then
                            result.Jersey = peer.equipped.Jersey
                        end
                        if type(peer.showcaseItems) == "table" and type(result.Items) == "table" then
                            for i = 1, 4 do
                                if type(peer.showcaseItems[i]) == "string" and peer.showcaseItems[i] ~= "" then
                                    result.Items[i] = peer.showcaseItems[i]
                                end
                            end
                        end
                    end
                end
            end
            return ok, result
        end)
    end

    PlayerInspectService.SetInspectField = function(self, kind, index, value, ...)
        if kind == "Item" and type(index) == "number" then
            customShowcaseItems[index] = type(value) == "string" and value or ""
            savePreset()
            broadcastP2P(false)
            if InspectState and InspectState.items then
                local clone = table.clone(InspectState.items() or customShowcaseItems)
                clone[index] = customShowcaseItems[index]
                InspectState.items(clone)
            end
            if value == nil or value == "" or (realServerInventory[value] and realServerInventory[value] > 0) then
                if type(origSetInspectField) == "function" then
                    return origSetInspectField(self, kind, index, value, ...)
                end
            end
            return Promise.resolve(true)
        end
        if type(origSetInspectField) == "function" then
            return origSetInspectField(self, kind, index, value, ...)
        end
        return Promise.resolve(true)
    end
end

-- ============================================================================
-- 8. HOOK BALL SKIN IN GAMEPLAY (BALLCONTROLLER / BALL.NEW)
-- ============================================================================
pcall(function()
    local BallModule = require(ReplicatedFirst:WaitForChild("Controllers"):WaitForChild("BallController"):WaitForChild("Ball"))
    if type(BallModule) == "table" and type(BallModule.new) == "function" and not BallModule.__vblHooked then
        BallModule.__vblHooked = true
        local origBallNew = BallModule.new
        BallModule.new = function(ballModel, cframe, ballId, itemEntity, ...)
            pcall(function()
                local servedBy = ReplicatedStorage:GetAttribute("ServedByPlayer")
                local desiredSkin = nil

                if type(servedBy) == "string" and servedBy ~= "" then
                    if servedBy == LocalPlayer.Name then
                        desiredSkin = customEquipped.Ball
                    else
                        local serverPlayer = Players:FindFirstChild(servedBy)
                        if serverPlayer then
                            local peer = peerCosmetics[tostring(serverPlayer.UserId)]
                            if peer and peer.equipped and peer.equipped.Ball then
                                desiredSkin = peer.equipped.Ball
                            end
                        end
                    end
                else
                    -- In training mode / local serve fallback
                    desiredSkin = customEquipped.Ball
                end

                if type(desiredSkin) == "string" and desiredSkin ~= "" then
                    local newItem = Item:Get(desiredSkin)
                    local template = ReplicatedStorage:FindFirstChild("Assets")
                        and ReplicatedStorage.Assets:FindFirstChild("Ball")
                        and ReplicatedStorage.Assets.Ball:FindFirstChild(desiredSkin)

                    if newItem and template and ballModel and ballModel.Name ~= desiredSkin then
                        local parent = ballModel.Parent
                        local replacement = template:Clone()
                        replacement.Parent = parent
                        ballModel:Destroy()
                        ballModel = replacement
                        itemEntity = newItem
                    end
                end
            end)
            return origBallNew(ballModel, cframe, ballId, itemEntity, ...)
        end
    end
end)

-- ============================================================================
-- 9. HOOK SCORE EFFECT (HITGROUND.PLAY)
-- ============================================================================
pcall(function()
    local HitGround = require(
        ReplicatedFirst:WaitForChild("Controllers")
            :WaitForChild("GameController")
            :WaitForChild("Effects")
            :WaitForChild("Registry")
            :WaitForChild("HitGround")
    )
    if type(HitGround) == "table" and type(HitGround.play) == "function" and not HitGround.__vblHooked then
        HitGround.__vblHooked = true
        local origHitGroundPlay = HitGround.play
        HitGround.play = function(props, ...)
            if type(props) == "table" then
                pcall(function()
                    -- Resolve who scored or hit the ball last
                    local scorerPlayer = nil
                    if props.Character then
                        scorerPlayer = Players:GetPlayerFromCharacter(props.Character)
                    end
                    if not scorerPlayer then
                        local lastHitter = ReplicatedStorage:GetAttribute("LastHitter")
                        if type(lastHitter) == "string" and lastHitter ~= "" then
                            scorerPlayer = Players:FindFirstChild(lastHitter)
                        end
                    end

                    -- Only replace ScoreEffect when a ScoreEffect was triggered (point scored) or in training/bounds hit by scorer
                    if props.ScoreEffect ~= nil or (scorerPlayer == LocalPlayer and props.IsOutOfBounds == false) then
                        if scorerPlayer == LocalPlayer then
                            props.ScoreEffect = pickResolvedScoreEffect(customEquipped.ScoreEffect, customFavorited)
                            props.Character = props.Character or LocalPlayer.Character
                        elseif scorerPlayer then
                            local peer = peerCosmetics[tostring(scorerPlayer.UserId)]
                            if peer and peer.equipped and peer.equipped.ScoreEffect then
                                props.ScoreEffect = pickResolvedScoreEffect(peer.equipped.ScoreEffect, peer.favorited)
                                props.Character = props.Character or scorerPlayer.Character
                            end
                        end
                    end
                end)
            end
            return origHitGroundPlay(props, ...)
        end
    end
end)

-- ============================================================================
-- 10. HOOK PLAYER CARD FLASHCARD & WIN CUTSCENE
-- ============================================================================
if PlayerCardController and type(PlayerCardController.DisplayFlashCard) == "function" and not PlayerCardController.__vblHooked then
    PlayerCardController.__vblHooked = true
    local origDisplayFlashCard = PlayerCardController.DisplayFlashCard
    PlayerCardController.DisplayFlashCard = function(self, data, ...)
        if type(data) == "table" and data.Player then
            pcall(function()
                if data.Player == LocalPlayer then
                    data.PlayerCardItemId = pickResolvedPlayerCard(customEquipped.PlayerCard, customFavorited)
                else
                    local peer = peerCosmetics[tostring(data.Player.UserId)]
                    if peer and peer.equipped and peer.equipped.PlayerCard then
                        data.PlayerCardItemId = pickResolvedPlayerCard(peer.equipped.PlayerCard, peer.favorited)
                    end
                end
            end)
        end
        return origDisplayFlashCard(self, data, ...)
    end
end

pcall(function()
    local WinCutscene = require(
        ReplicatedFirst:WaitForChild("Controllers")
            :WaitForChild("GameController")
            :WaitForChild("Components")
            :WaitForChild("Screens")
            :WaitForChild("WinCutscene")
    )
    if type(WinCutscene) == "table" and type(WinCutscene.play) == "function" and not WinCutscene.__vblHooked then
        WinCutscene.__vblHooked = true
        local origWinPlay = WinCutscene.play
        WinCutscene.play = function(data, callback, ...)
            if type(data) == "table" then
                pcall(function()
                    if customEquipped.WinScreen and customEquipped.WinScreen ~= "" and Item:Get(customEquipped.WinScreen) then
                        data.CutsceneId = customEquipped.WinScreen
                    end
                end)
            end
            return origWinPlay(data, callback, ...)
        end
    end
end)

print(string.format(
    "[VolleyballUnlockAll] Loaded! Balls=%d | ScoreFX=%d | Titles=%d | Emotes=%d | Cards=%d | Bubbles=%d | Jerseys=%d | Art=%d | WinScreens=%d | P2P=%s",
    unlockedCountsByType[Item.Type.Ball] or 0,
    unlockedCountsByType[Item.Type.ScoreEffect] or 0,
    unlockedCountsByType[Item.Type.Title] or 0,
    unlockedCountsByType[Item.Type.Emote] or 0,
    unlockedCountsByType[Item.Type.PlayerCard] or 0,
    unlockedCountsByType[Item.Type.ChatBubble] or 0,
    unlockedCountsByType[Item.Type.Jersey] or 0,
    unlockedCountsByType[Item.Type.ProfileArt] or 0,
    unlockedCountsByType[Item.Type.WinScreen] or 0,
    P2P_TOPIC
))
