-- [YDX Execution Telemetry - Non-Duplicating when loaded via Universal Loader]
do
    local env = (type(getgenv) == "function" and getgenv()) or _G
    env.__YDX_EXEC_LOCKS = env.__YDX_EXEC_LOCKS or {}
    local sid = "bladeball-unlock"
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
end
-- ============================================================
-- BLADE BALL - UNLOCK ALL + REAL-TIME P2P SYNC (v1.0)
-- PlaceId: 13772394625 | GameId: 4777817887
-- Unlocks All Swords, Finishers, Sword Accessories, Animation
-- Styles, Explosions, Emotes & Booths + 1:1 P2P Sync
-- ============================================================

if not game:IsLoaded() then
    game.Loaded:Wait()
end

if _G.__bladeball_unlock_cleanup then
    pcall(_G.__bladeball_unlock_cleanup)
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer = Players.LocalPlayer
end

while not workspace:GetAttribute("ClientModulesLoaded") do
    workspace:GetAttributeChangedSignal("ClientModulesLoaded"):Wait()
end

-- ============================================================
-- 1. CORE MODULES
-- ============================================================
local ControllerRunners = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("ClientLoader"):WaitForChild("ControllerRunners")

local function requireMod(name, directParent)
    if directParent then
        local direct = directParent:FindFirstChild(name)
        if direct and direct:IsA("ModuleScript") then
            return require(direct)
        end
    end
    local runner = ControllerRunners:FindFirstChild(name)
    if runner then
        local targetObj = runner:FindFirstChild("Target")
        if targetObj and targetObj.Value and targetObj.Value:IsA("ModuleScript") then
            return require(targetObj.Value)
        end
        local subMod = runner:FindFirstChildWhichIsA("ModuleScript")
        if subMod then
            return require(subMod)
        end
    end
    local found = ReplicatedStorage:FindFirstChild(name, true)
    if found and found:IsA("ModuleScript") then
        return require(found)
    end
    return nil
end

local Replion = requireMod("Replion", ReplicatedStorage.Packages)
local Net = requireMod("Net", ReplicatedStorage.Packages)
local Trove = requireMod("Trove", ReplicatedStorage.Packages)
local InventoryMod = requireMod("Inventory", ReplicatedStorage.Shared)
local InventoryClient = InventoryMod.Client
local ItemInfo = requireMod("ItemInfo", ReplicatedStorage.Shared)
local Swords = requireMod("Swords", ReplicatedStorage.Shared.ReplicatedInstances)
local SwordAPI = requireMod("SwordAPI", ReplicatedStorage.Shared)
local SwordAccessories = requireMod("SwordAccessories", ReplicatedStorage.Shared.ReplicatedInstances)
local SwordFX = requireMod("SwordFX", ReplicatedStorage.Shared.ReplicatedInstances)
local Explosions = requireMod("Explosions", ReplicatedStorage.Shared.ReplicatedInstances)
local Finishers = requireMod("Finishers", ReplicatedStorage.Shared.ReplicatedInstances)
local EmotesShared = requireMod("EmotesShared", ReplicatedStorage.Shared)
local SwordsController = requireMod("SwordsController", ReplicatedStorage.Controllers)
local VFXController = requireMod("VFXController", ReplicatedStorage.Controllers)
local FinishersController = requireMod("FinishersController", ReplicatedStorage.Controllers)
local EmoteController = requireMod("EmoteController", ReplicatedStorage.Controllers)
local EmoteWheelController = requireMod("EmoteWheelController", ReplicatedStorage.Controllers)
local ShopController = requireMod("ShopController", ReplicatedStorage.Controllers:FindFirstChild("UI"))

local invRep = Replion.Client:WaitReplion("Inventory", 30)
local dataRep = Replion.Client:WaitReplion("Data", 30)
if not invRep or not dataRep then
    warn("[BladeBall UnlockAll] Failed to acquire Inventory/Data Replion")
    return
end

-- ============================================================
-- 2. STATE & PERSISTENCE
-- ============================================================
local SAVE_FILE = "bladeball_saved_preset.json"

local S = {
    alive = true,
    conns = {},
    charGuards = {},
    origHooks = {},
    realOwnedIds = {
        Sword = {},
        Explosion = {},
        Emote = {},
        Booth = {},
    },
    itemIds = {
        Sword = {},
        Explosion = {},
        Emote = {},
        Booth = {},
    },
    equippedSword = "Base Sword",
    equippedSwordId = nil,
    showAccessory = true,
    animStyle = "Default",
    finishersEquipped = {},
    equippedExplosion = "Explosion Normal",
    equippedExplosionId = nil,
    emoteSlots = {},
    currentEmote = "",
    currentEmoteAt = 0,
    pushState = nil,
}

do
    local eqSword = invRep:Get({ "Equipped", "Sword" })
    if type(eqSword) == "table" and type(eqSword.Name) == "string" then
        S.equippedSword = eqSword.Name
        S.equippedSwordId = eqSword.Id
    elseif type(LocalPlayer:GetAttribute("CurrentlyEquippedSword")) == "string" then
        S.equippedSword = LocalPlayer:GetAttribute("CurrentlyEquippedSword")
    end

    local eqExp = invRep:Get({ "Equipped", "Explosion" })
    if type(eqExp) == "table" and type(eqExp.Name) == "string" then
        S.equippedExplosion = eqExp.Name
        S.equippedExplosionId = eqExp.Id
    end

    if LocalPlayer:GetAttribute("ShowSwordAccessory") ~= nil then
        S.showAccessory = LocalPlayer:GetAttribute("ShowSwordAccessory") == true
    end
    if type(LocalPlayer:GetAttribute("AnimationStyle")) == "string" then
        S.animStyle = LocalPlayer:GetAttribute("AnimationStyle")
    end

    local eqEmotes = invRep:Get({ "EquippedList", "Emote" })
    if type(eqEmotes) == "table" then
        for k, v in pairs(eqEmotes) do
            if type(v) == "table" and type(v.Name) == "string" then
                S.emoteSlots[tostring(k)] = v.Name
            end
        end
    end
end

local function loadSavedPreset()
    if type(isfile) ~= "function" or type(readfile) ~= "function" then
        return
    end
    local ok, raw = pcall(function()
        if isfile(SAVE_FILE) then
            return readfile(SAVE_FILE)
        end
        return nil
    end)
    if not ok or type(raw) ~= "string" or #raw == 0 then
        return
    end
    local dok, decoded = pcall(function()
        return HttpService:JSONDecode(raw)
    end)
    if not dok or type(decoded) ~= "table" then
        return
    end
    if type(decoded.equippedSword) == "string" and #decoded.equippedSword > 0 then
        S.equippedSword = decoded.equippedSword
    end
    if type(decoded.showAccessory) == "boolean" then
        S.showAccessory = decoded.showAccessory
    end
    if type(decoded.animStyle) == "string" and #decoded.animStyle > 0 then
        S.animStyle = decoded.animStyle
    end
    if type(decoded.equippedExplosion) == "string" and #decoded.equippedExplosion > 0 then
        S.equippedExplosion = decoded.equippedExplosion
    end
    if type(decoded.finishersEquipped) == "table" then
        for k, v in pairs(decoded.finishersEquipped) do
            if v == true then
                S.finishersEquipped[tostring(k)] = true
            end
        end
    end
    if type(decoded.emoteSlots) == "table" then
        for k, v in pairs(decoded.emoteSlots) do
            if type(v) == "string" and #v > 0 then
                S.emoteSlots[tostring(k)] = v
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
            equippedSword = S.equippedSword,
            showAccessory = S.showAccessory,
            animStyle = S.animStyle,
            equippedExplosion = S.equippedExplosion,
            finishersEquipped = S.finishersEquipped,
            emoteSlots = S.emoteSlots,
        })
        writefile(SAVE_FILE, payload)
    end)
end

loadSavedPreset()

-- ============================================================
-- 3. UNHIDE & UNLOCK ALL COSMETICS IN REPLION + SHOP + EMOTES
-- ============================================================
local function unlockAllCosmetics()
    -- Unhide all definitions
    local swordCollection = Swords:GetCollection()
    local accCollection = SwordAccessories:GetCollection()
    local dataFinishers = ReplicatedStorage.Misc:FindFirstChild("DataFinishers")
    local dataExplosions = ReplicatedStorage.Misc:FindFirstChild("DataExplosions")
    local miscEmotes = ReplicatedStorage.Misc:FindFirstChild("Emotes")

    for _, swordDef in pairs(swordCollection) do
        if type(swordDef) == "table" then
            swordDef.Hidden = false
            swordDef.AlwaysVisible = true
        end
    end

    for _, catName in ipairs({ "Sword", "Explosion", "Emote", "Booth" }) do
        local catTable = ItemInfo[catName]
        if type(catTable) == "table" then
            for _, info in pairs(catTable) do
                if type(info) == "table" then
                    info.Hidden = false
                    info.AlwaysVisible = true
                end
            end
        end
    end

    if dataExplosions then
        for _, child in ipairs(dataExplosions:GetChildren()) do
            child:SetAttribute("Hidden", false)
            child:SetAttribute("AlwaysVisible", true)
        end
    end

    if miscEmotes then
        for _, child in ipairs(miscEmotes:GetChildren()) do
            child:SetAttribute("Hidden", false)
            child:SetAttribute("AlwaysShow", true)
        end
    end

    -- Build unlocked Inventory tables
    local curInv = invRep.Data and invRep.Data.Inventory or {}

    -- Swords
    local newSwords = {}
    if type(curInv.Sword) == "table" then
        for id, item in pairs(curInv.Sword) do
            if type(item) == "table" and type(item.Name) == "string" then
                if not tostring(id):find("^bb_u_") then
                    S.realOwnedIds.Sword[item.Name] = id
                end
                local cloned = table.clone(item)
                local sDef = swordCollection[item.Name]
                local hasFin = (sDef and sDef.HasFinisher == true) or (dataFinishers and dataFinishers:FindFirstChild(item.Name) ~= nil)
                local hasAcc = (sDef and (sDef.AccessoryToggleable == true or sDef.AccessoryUnlockable == true)) or (accCollection and accCollection[item.Name] ~= nil)
                if hasFin then cloned.Finisher = true end
                if hasAcc then cloned.Accessory = true end
                newSwords[id] = cloned
                S.itemIds.Sword[item.Name] = id
            end
        end
    end

    local swordCount = 0
    for swordName, sDef in pairs(swordCollection) do
        if type(swordName) == "string" then
            swordCount = swordCount + 1
            if not S.itemIds.Sword[swordName] then
                local id = "bb_u_sword_" .. swordName
                local hasFin = (type(sDef) == "table" and sDef.HasFinisher == true) or (dataFinishers and dataFinishers:FindFirstChild(swordName) ~= nil)
                local hasAcc = (type(sDef) == "table" and (sDef.AccessoryToggleable == true or sDef.AccessoryUnlockable == true)) or (accCollection and accCollection[swordName] ~= nil)
                newSwords[id] = {
                    Name = swordName,
                    Finisher = hasFin and true or nil,
                    Accessory = hasAcc and true or nil,
                }
                S.itemIds.Sword[swordName] = id
            end
        end
    end

    -- Explosions
    local newExplosions = {}
    if type(curInv.Explosion) == "table" then
        for id, item in pairs(curInv.Explosion) do
            if type(item) == "table" and type(item.Name) == "string" then
                if not tostring(id):find("^bb_u_") then
                    S.realOwnedIds.Explosion[item.Name] = id
                end
                newExplosions[id] = table.clone(item)
                S.itemIds.Explosion[item.Name] = id
            end
        end
    end

    local expCount = 0
    if dataExplosions then
        for _, child in ipairs(dataExplosions:GetChildren()) do
            expCount = expCount + 1
            if not S.itemIds.Explosion[child.Name] then
                local id = "bb_u_exp_" .. child.Name
                newExplosions[id] = { Name = child.Name }
                S.itemIds.Explosion[child.Name] = id
            end
        end
    end

    -- Emotes
    local newEmotes = {}
    if type(curInv.Emote) == "table" then
        for id, item in pairs(curInv.Emote) do
            if type(item) == "table" and type(item.Name) == "string" then
                if not tostring(id):find("^bb_u_") then
                    S.realOwnedIds.Emote[item.Name] = id
                end
                newEmotes[id] = table.clone(item)
                S.itemIds.Emote[item.Name] = id
            end
        end
    end

    local emoteCount = 0
    if miscEmotes then
        for _, child in ipairs(miscEmotes:GetChildren()) do
            emoteCount = emoteCount + 1
            if not S.itemIds.Emote[child.Name] then
                local id = "bb_u_emote_" .. child.Name
                newEmotes[id] = { Name = child.Name }
                S.itemIds.Emote[child.Name] = id
            end
        end
    end

    -- Booths
    local newBooths = {}
    if type(curInv.Booth) == "table" then
        for id, item in pairs(curInv.Booth) do
            if type(item) == "table" and type(item.Name) == "string" then
                if not tostring(id):find("^bb_u_") then
                    S.realOwnedIds.Booth[item.Name] = id
                end
                newBooths[id] = table.clone(item)
                S.itemIds.Booth[item.Name] = id
            end
        end
    end
    if type(ItemInfo.Booth) == "table" then
        for boothName, _ in pairs(ItemInfo.Booth) do
            if not S.itemIds.Booth[boothName] then
                local id = "bb_u_booth_" .. boothName
                newBooths[id] = { Name = boothName }
                S.itemIds.Booth[boothName] = id
            end
        end
    end

    -- Ensure Finishers equipped/unlocked in Data Replion
    local finUnlocked = {}
    local finEquipped = {}
    if dataFinishers then
        for _, child in ipairs(dataFinishers:GetChildren()) do
            table.insert(finUnlocked, child.Name)
            if S.finishersEquipped[child.Name] == nil then
                S.finishersEquipped[child.Name] = true
            end
        end
    end
    for k, v in pairs(S.finishersEquipped) do
        if v == true then
            finEquipped[k] = true
        end
    end

    -- Batch ShopController pages during Replion update
    local pages = type(ShopController) == "table" and ShopController._inventoryPages or nil
    if type(pages) == "table" then
        for _, p in pairs(pages) do
            if type(p) == "table" and type(p.BeginBatch) == "function" then
                pcall(p.BeginBatch)
            end
        end
    end

    S.equippedSwordId = S.itemIds.Sword[S.equippedSword] or S.equippedSwordId or ("bb_u_sword_" .. S.equippedSword)
    S.equippedExplosionId = S.itemIds.Explosion[S.equippedExplosion] or S.equippedExplosionId or ("bb_u_exp_" .. S.equippedExplosion)

    local eqEmoteTable = {}
    for slotStr, emoteName in pairs(S.emoteSlots) do
        local eid = S.itemIds.Emote[emoteName] or ("bb_u_emote_" .. emoteName)
        eqEmoteTable[tostring(slotStr)] = {
            Id = eid,
            Name = emoteName,
        }
    end

    pcall(function() invRep:_set({ "Inventory", "Sword" }, newSwords) end)
    pcall(function() invRep:_set({ "Inventory", "Explosion" }, newExplosions) end)
    pcall(function() invRep:_set({ "Inventory", "Emote" }, newEmotes) end)
    pcall(function() invRep:_set({ "Inventory", "Booth" }, newBooths) end)
    pcall(function()
        invRep:_set({ "Equipped", "Sword" }, {
            Id = S.equippedSwordId,
            Name = S.equippedSword,
        })
    end)
    pcall(function()
        invRep:_set({ "Equipped", "Explosion" }, {
            Id = S.equippedExplosionId,
            Name = S.equippedExplosion,
        })
    end)
    if next(eqEmoteTable) ~= nil then
        pcall(function() invRep:_set({ "EquippedList", "Emote" }, eqEmoteTable) end)
    end

    pcall(function() dataRep:_set({ "Finishers", "Unlocked" }, finUnlocked) end)
    pcall(function() dataRep:_set({ "Finishers", "Equipped" }, finEquipped) end)
    pcall(function() dataRep:_set({ "SwordSkins", "CurrentlySelected" }, S.equippedSword) end)
    pcall(function() dataRep:_set({ "ExplosionSkins", "CurrentlySelected" }, S.equippedExplosion) end)

    if type(pages) == "table" then
        for _, p in pairs(pages) do
            if type(p) == "table" and type(p.EndBatch) == "function" then
                pcall(p.EndBatch)
            end
        end
    end

    pcall(function()
        EmoteWheelController:updatePage()
    end)

    print(string.format("[BladeBall UnlockAll] Unlocked %d Swords, %d Explosions, %d Emotes", swordCount, expCount, emoteCount))
end

-- ============================================================
-- 4. 3D SWORD, ACCESSORY, ANIMATION & EMOTE APPLICATION
-- ============================================================
local applyingChar = {}

local function getTargetAppearanceForPlayer(player)
    if player == LocalPlayer then
        return {
            sword = S.equippedSword,
            showAccessory = S.showAccessory,
            animStyle = S.animStyle,
            explosion = S.equippedExplosion,
            finisher = S.finishersEquipped[S.equippedSword] == true,
            emote = S.currentEmote,
            emoteAt = S.currentEmoteAt,
        }
    end
    local peer = S.peers and S.peers[tostring(player.UserId)]
    if peer and type(peer.sword) == "string" and #peer.sword > 0 then
        return peer
    end
    return nil
end

local function applyCharacterSword(player, character, appearance)
    if not S.alive or not player or not character or not character.Parent then
        return
    end
    appearance = appearance or getTargetAppearanceForPlayer(player)
    if not appearance or type(appearance.sword) ~= "string" or #appearance.sword == 0 then
        return
    end
    if applyingChar[character] then
        return
    end
    applyingChar[character] = true

    task.spawn(function()
        local ok, err = pcall(function()
            local swordName = appearance.sword
            local showAcc = appearance.showAccessory ~= false
            local animStyle = type(appearance.animStyle) == "string" and appearance.animStyle or "Default"

            player:SetAttribute("CurrentlyEquippedSword", swordName)
            player:SetAttribute("ShowSwordAccessory", showAcc)
            player:SetAttribute("AnimationStyle", animStyle)

            character:SetAttribute("CurrentlyEquippedSword", swordName)
            character:SetAttribute("ShowSwordAccessory", showAcc)
            character:SetAttribute("AnimationStyle", animStyle)

            Swords:ForceEquipSwordTo(character, swordName, nil, not showAcc)

            for _, child in ipairs(character:GetChildren()) do
                if child:GetAttribute("_equippedSword") then
                    child:SetAttribute("_bbCustomSword", swordName)
                end
            end

            if player == LocalPlayer then
                pcall(function()
                    SwordsController:SetSword(swordName)
                end)
            else
                pcall(function()
                    SwordsController:UpdateSwordFor(character)
                end)
            end
        end)
        applyingChar[character] = nil
        if not ok then
            warn("[BladeBall UnlockAll] applyCharacterSword error:", err)
        end
    end)
end

local replicateEmoteRemote = Net:RemoteEvent("ReplicateEmote")

local function playCharacterEmote(character, emoteId, isPlaying, timestamp)
    if not character or not character.Parent then
        return
    end
    local ts = timestamp or workspace:GetServerTimeNow()
    local activeId = (isPlaying and type(emoteId) == "string" and #emoteId > 0) and emoteId or nil

    character:SetAttribute("CurrentEmote", activeId)
    character:SetAttribute("CurrentEmoteTime", activeId and ts or nil)

    local firedViaConn = false
    if type(getconnections) == "function" and replicateEmoteRemote then
        local ok, conns = pcall(getconnections, replicateEmoteRemote.OnClientEvent)
        if ok and type(conns) == "table" then
            for _, c in ipairs(conns) do
                if type(c.Function) == "function" then
                    firedViaConn = true
                    task.spawn(c.Function, character, emoteId, isPlaying == true, ts)
                end
            end
        end
    end

    if not firedViaConn then
        if not S.emoteTroves then
            S.emoteTroves = {}
        end
        if S.emoteTroves[character] then
            pcall(function() S.emoteTroves[character]:Destroy() end)
            S.emoteTroves[character] = nil
        end
        if activeId then
            local tr = Trove.new()
            S.emoteTroves[character] = tr
            task.spawn(function()
                pcall(function()
                    EmotesShared:Play(character, tr, activeId, true, ts)
                end)
            end)
        end
    end
end

local function attachCharacterGuard(player, character)
    if not character then
        return
    end
    if S.charGuards[character] then
        for _, c in ipairs(S.charGuards[character]) do
            pcall(function() c:Disconnect() end)
        end
    end
    local gConns = {}
    S.charGuards[character] = gConns

    table.insert(gConns, character:GetAttributeChangedSignal("CurrentlyEquippedSword"):Connect(function()
        if not S.alive or applyingChar[character] then
            return
        end
        local app = getTargetAppearanceForPlayer(player)
        if app and character:GetAttribute("CurrentlyEquippedSword") ~= app.sword then
            applyCharacterSword(player, character, app)
        end
    end))

    table.insert(gConns, character.ChildAdded:Connect(function(child)
        if not S.alive or applyingChar[character] then
            return
        end
        task.defer(function()
            if not S.alive or applyingChar[character] or not child.Parent then
                return
            end
            if child:GetAttribute("_equippedSword") then
                local app = getTargetAppearanceForPlayer(player)
                if app and child:GetAttribute("_bbCustomSword") ~= app.sword then
                    applyCharacterSword(player, character, app)
                end
            end
        end)
    end))

    if player == LocalPlayer then
        local hum = character:WaitForChild("Humanoid", 10)
        if hum then
            table.insert(gConns, hum.Running:Connect(function(speed)
                if not S.alive or #S.currentEmote == 0 or speed <= 1 then
                    return
                end
                local emFolder = ReplicatedStorage.Misc:FindFirstChild("Emotes")
                local emObj = emFolder and emFolder:FindFirstChild(S.currentEmote)
                if emObj and emObj:GetAttribute("Walkable") then
                    return
                end
                if os.clock() - (S.lastLocalEmoteTick or 0) < 0.35 then
                    return
                end
                S.currentEmote = ""
                playCharacterEmote(character, nil, false, workspace:GetServerTimeNow())
                if S.pushState then S.pushState(true) end
            end))

            table.insert(gConns, hum.Jumping:Connect(function(isJumping)
                if not S.alive or not isJumping or #S.currentEmote == 0 then
                    return
                end
                S.currentEmote = ""
                playCharacterEmote(character, nil, false, workspace:GetServerTimeNow())
                if S.pushState then S.pushState(true) end
            end))
        end
    end

    local app = getTargetAppearanceForPlayer(player)
    if app then
        applyCharacterSword(player, character, app)
        if type(app.emote) == "string" and #app.emote > 0 then
            playCharacterEmote(character, app.emote, true, app.emoteAt)
        end
    end
end

-- ============================================================
-- 5. PARRY SLASH VFX, EXPLOSION & FINISHER HOOKS (LOCAL + P2P)
-- ============================================================
local wrappedParryCallbacks = setmetatable({}, { __mode = "k" })

local function makeParryWrapper(origFn)
    return function(slashName, slashPart, swordName, playerOrBot, ballId, seed, ...)
        if S.alive then
            local plr = nil
            if typeof(playerOrBot) == "Instance" and playerOrBot:IsA("Player") then
                plr = playerOrBot
            elseif typeof(slashPart) == "Instance" and slashPart.Parent then
                plr = Players:GetPlayerFromCharacter(slashPart.Parent)
            end
            if plr then
                local app = getTargetAppearanceForPlayer(plr)
                if app and type(app.sword) == "string" and #app.sword > 0 then
                    local sDef = Swords:GetSword(app.sword)
                    if sDef then
                        swordName = app.sword
                        slashName = SwordAPI:GetSlashName(app.sword, sDef.SlashName) or sDef.SlashName or slashName
                    end
                    if plr ~= LocalPlayer and plr.Character then
                        plr.Character:SetAttribute("Parrying", true)
                        task.delay(0.35, function()
                            if plr.Character then
                                plr.Character:SetAttribute("Parrying", false)
                            end
                        end)
                    end
                end
            end
        end
        return origFn(slashName, slashPart, swordName, playerOrBot, ballId, seed, ...)
    end
end

local function hookParryConnections()
    if type(getconnections) ~= "function" then
        return
    end
    local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotesFolder then
        return
    end
    for _, remName in ipairs({ "ParrySuccessAll", "ParrySuccessClient" }) do
        local rem = remotesFolder:FindFirstChild(remName)
        local sig = rem and (rem:IsA("RemoteEvent") and rem.OnClientEvent or (rem:IsA("BindableEvent") and rem.Event))
        if sig then
            local ok, conns = pcall(getconnections, sig)
            if ok and type(conns) == "table" then
                for _, conn in ipairs(conns) do
                    local fn = conn.Function
                    if type(fn) == "function" and not wrappedParryCallbacks[fn] then
                        local wrapper = makeParryWrapper(fn)
                        wrappedParryCallbacks[fn] = true
                        wrappedParryCallbacks[wrapper] = true
                        pcall(function() conn:Disable() end)
                        local newConn = sig:Connect(wrapper)
                        table.insert(S.conns, newConn)
                        table.insert(S.origHooks, function()
                            pcall(function() newConn:Disconnect() end)
                            pcall(function() conn:Enable() end)
                        end)
                    end
                end
            end
        end
    end
end

local function hookExplosionsAndFinishers()
    if type(VFXController) == "table" and type(VFXController.PlayExplosion) == "function" then
        local origPlayExplosion = VFXController.PlayExplosion
        VFXController.PlayExplosion = function(self, explosionName, pos, ball, victimChar, attributionChar, killCount, ...)
            if S.alive and typeof(attributionChar) == "Instance" then
                local killerPlr = Players:GetPlayerFromCharacter(attributionChar)
                if killerPlr then
                    local app = getTargetAppearanceForPlayer(killerPlr)
                    if app then
                        if type(app.explosion) == "string" and #app.explosion > 0 then
                            explosionName = app.explosion
                        end
                        if app.finisher and type(app.sword) == "string" and typeof(victimChar) == "Instance" then
                            local aliveCount = workspace:FindFirstChild("Alive") and #workspace.Alive:GetChildren() or 0
                            if aliveCount <= 2 and FinishersController and FinishersController._finishers and FinishersController._finishers[app.sword] then
                                task.spawn(function()
                                    pcall(function()
                                        FinishersController:PlayFinisher(app.sword, attributionChar, victimChar)
                                    end)
                                end)
                            end
                        end
                    end
                end
            end
            return origPlayExplosion(self, explosionName, pos, ball, victimChar, attributionChar, killCount, ...)
        end
        table.insert(S.origHooks, function()
            VFXController.PlayExplosion = origPlayExplosion
        end)
    end
end

-- ============================================================
-- 6. EQUIP & EMOTE REMOTE INTERCEPTION (__namecall)
-- ============================================================
local function resolveItemNameFromArg(invType, arg)
    if type(arg) ~= "string" or #arg == 0 then
        return nil
    end
    local invDict = invRep.Data and invRep.Data.Inventory and invRep.Data.Inventory[invType]
    if type(invDict) == "table" and invDict[arg] and type(invDict[arg].Name) == "string" then
        return invDict[arg].Name
    end
    local ok, parsed = pcall(function()
        return InventoryClient:KeyToItem(arg)
    end)
    if ok and type(parsed) == "table" and type(parsed.Name) == "string" then
        return parsed.Name
    end
    return arg
end

local function refreshShopSelection()
    task.defer(function()
        if type(ShopController) == "table" and ShopController._selectedItem then
            pcall(function()
                ShopController:Select(ShopController._selectedItem, true)
            end)
        end
    end)
end

local function handleEquipSword(arg)
    local swordName = resolveItemNameFromArg("Sword", arg)
    if not swordName or not Swords:GetSword(swordName) then
        if type(ShopController) == "table" and ShopController._selectedItem and ShopController._selectedItem.type == "Sword" then
            swordName = ShopController._selectedItem.name
        end
    end
    if not swordName or not Swords:GetSword(swordName) then
        return
    end

    S.equippedSword = swordName
    S.equippedSwordId = S.itemIds.Sword[swordName] or ("bb_u_sword_" .. swordName)

    local sDef = Swords:GetSword(swordName)
    local styles = sDef and sDef.AnimationStyles and sDef.AnimationStyles[S.showAccessory and "Accessory" or "Base"]
    if type(styles) == "table" and #styles > 0 then
        if not table.find(styles, S.animStyle) then
            S.animStyle = styles[1]
        end
    else
        S.animStyle = "Default"
    end

    pcall(function()
        invRep:_set({ "Equipped", "Sword" }, {
            Id = S.equippedSwordId,
            Name = swordName,
        })
    end)
    pcall(function()
        dataRep:_set({ "SwordSkins", "CurrentlySelected" }, swordName)
    end)

    if LocalPlayer.Character then
        applyCharacterSword(LocalPlayer, LocalPlayer.Character)
    else
        LocalPlayer:SetAttribute("CurrentlyEquippedSword", swordName)
    end

    refreshShopSelection()
    savePreset()
    if S.pushState then S.pushState(true) end
end

local function handleToggleAccessory()
    S.showAccessory = not S.showAccessory
    local sDef = Swords:GetSword(S.equippedSword)
    local styles = sDef and sDef.AnimationStyles and sDef.AnimationStyles[S.showAccessory and "Accessory" or "Base"]
    if type(styles) == "table" and #styles > 0 and not table.find(styles, S.animStyle) then
        S.animStyle = styles[1]
    end
    LocalPlayer:SetAttribute("ShowSwordAccessory", S.showAccessory)
    LocalPlayer:SetAttribute("AnimationStyle", S.animStyle)
    if LocalPlayer.Character then
        applyCharacterSword(LocalPlayer, LocalPlayer.Character)
    end
    refreshShopSelection()
    savePreset()
    if S.pushState then S.pushState(true) end
end

local function handleCycleAnimStyle()
    local sDef = Swords:GetSword(S.equippedSword)
    local styles = sDef and sDef.AnimationStyles and sDef.AnimationStyles[S.showAccessory and "Accessory" or "Base"]
    if type(styles) == "table" and #styles > 1 then
        local idx = table.find(styles, S.animStyle) or 1
        local nextStyle = styles[(idx % #styles) + 1] or styles[1]
        S.animStyle = nextStyle
        LocalPlayer:SetAttribute("AnimationStyle", S.animStyle)
        if LocalPlayer.Character then
            applyCharacterSword(LocalPlayer, LocalPlayer.Character)
        end
        refreshShopSelection()
        savePreset()
        if S.pushState then S.pushState(true) end
    end
end

local function handleToggleFinisher(swordName)
    swordName = type(swordName) == "string" and swordName or S.equippedSword
    local newState = not (S.finishersEquipped[swordName] == true)
    if newState then
        S.finishersEquipped[swordName] = true
    else
        S.finishersEquipped[swordName] = nil
    end
    pcall(function()
        dataRep:_set({ "Finishers", "Equipped", swordName }, newState and true or nil)
    end)
    refreshShopSelection()
    savePreset()
    if S.pushState then S.pushState(true) end
end

local function handleEquipExplosion(arg)
    local expName = resolveItemNameFromArg("Explosion", arg)
    if not expName and type(ShopController) == "table" and ShopController._selectedItem and ShopController._selectedItem.type == "Explosion" then
        expName = ShopController._selectedItem.name
    end
    if not expName then
        return
    end
    S.equippedExplosion = expName
    S.equippedExplosionId = S.itemIds.Explosion[expName] or ("bb_u_exp_" .. expName)

    pcall(function()
        invRep:_set({ "Equipped", "Explosion" }, {
            Id = S.equippedExplosionId,
            Name = expName,
        })
    end)
    pcall(function()
        dataRep:_set({ "ExplosionSkins", "CurrentlySelected" }, expName)
    end)

    refreshShopSelection()
    savePreset()
    if S.pushState then S.pushState(true) end
end

local function handleChangeEmoteSlot(slotIdx, itemId)
    local slotNum = tonumber(slotIdx)
    if not slotNum or slotNum < 1 or slotNum > 40 then
        return
    end
    local emoteName = resolveItemNameFromArg("Emote", itemId)
    if not emoteName then
        return
    end
    local slotStr = tostring(slotNum)
    S.emoteSlots[slotStr] = emoteName
    local eid = S.itemIds.Emote[emoteName] or ("bb_u_emote_" .. emoteName)

    local curList = table.clone(invRep:Get({ "EquippedList", "Emote" }) or {})
    curList[slotStr] = {
        Id = eid,
        Name = emoteName,
    }
    pcall(function()
        invRep:_set({ "EquippedList", "Emote" }, curList)
    end)
    pcall(function()
        EmoteWheelController:updatePage()
    end)
    savePreset()
end

local function handleCustomEmote(isPlaying, emoteId, timestamp)
    local ts = tonumber(timestamp) or workspace:GetServerTimeNow()
    if isPlaying and type(emoteId) == "string" and #emoteId > 0 then
        S.currentEmote = emoteId
        S.currentEmoteAt = ts
        S.lastLocalEmoteTick = os.clock()
        if LocalPlayer.Character then
            playCharacterEmote(LocalPlayer.Character, emoteId, true, ts)
        end
    else
        S.currentEmote = ""
        S.currentEmoteAt = ts
        if LocalPlayer.Character then
            playCharacterEmote(LocalPlayer.Character, nil, false, ts)
        end
    end
    if S.pushState then S.pushState(true) end
end

local function installNamecallHook()
    if type(hookmetamethod) ~= "function" or type(getnamecallmethod) ~= "function" then
        return
    end
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        if not S.alive then
            return oldNamecall(self, ...)
        end
        local method = getnamecallmethod()
        if (method == "InvokeServer" or method == "FireServer") and typeof(self) == "Instance" then
            local name = self.Name
            if method == "InvokeServer" then
                if name == "RF/RequestEquipSword" or name == "RequestEquipSword" then
                    local arg1 = ...
                    task.spawn(handleEquipSword, arg1)
                    local realId = S.realOwnedIds.Sword[S.equippedSword]
                    if realId then
                        return oldNamecall(self, realId)
                    end
                    return true
                elseif name == "RF/RequestEquipExplosion" or name == "RequestEquipExplosion" then
                    local arg1 = ...
                    task.spawn(handleEquipExplosion, arg1)
                    local realId = S.realOwnedIds.Explosion[S.equippedExplosion]
                    if realId then
                        return oldNamecall(self, realId)
                    end
                    return true
                elseif name == "RF/RequestEquipFinisher" or name == "RequestEquipFinisher" then
                    local arg1 = ...
                    task.spawn(handleToggleFinisher, arg1)
                    return true
                end
            elseif method == "FireServer" then
                if name == "RE/EquipSwordAccessory" or name == "EquipSwordAccessory" then
                    task.spawn(handleToggleAccessory)
                    return nil
                elseif name == "RE/RequestChangeAnimationStyle" or name == "RequestChangeAnimationStyle" then
                    task.spawn(handleCycleAnimStyle)
                    return nil
                elseif name == "ChangeEmotes" then
                    local slotIdx, itemId = ...
                    task.spawn(handleChangeEmoteSlot, slotIdx, itemId)
                    local emName = resolveItemNameFromArg("Emote", itemId)
                    local realId = emName and S.realOwnedIds.Emote[emName]
                    if realId then
                        return oldNamecall(self, slotIdx, realId)
                    end
                    return nil
                elseif name == "CustomEmote" then
                    local isPlaying, emoteId, ts, slot = ...
                    task.spawn(handleCustomEmote, isPlaying, emoteId, ts)
                    local realId = type(emoteId) == "string" and S.realOwnedIds.Emote[emoteId]
                    if realId then
                        return oldNamecall(self, isPlaying, emoteId, ts, slot)
                    end
                    return nil
                elseif name == "ParryAttempt" then
                    if #S.currentEmote > 0 then
                        task.spawn(handleCustomEmote, false, nil, workspace:GetServerTimeNow())
                    end
                end
            end
        end
        return oldNamecall(self, ...)
    end)

    table.insert(S.origHooks, function()
        pcall(hookmetamethod, game, "__namecall", oldNamecall)
    end)
end

-- ============================================================
-- 7. REAL-TIME P2P SYNC (NTFY.SH RELAY)
-- ============================================================
local function startP2PSync()
    local reqFn = (type(request) == "function" and request)
        or (type(http_request) == "function" and http_request)
        or (type(syn) == "table" and type(syn.request) == "function" and syn.request)
        or (type(http) == "table" and type(http.request) == "function" and http.request)
    if not reqFn then
        warn("[BladeBall UnlockAll] No HTTP request function available for P2P sync")
        return
    end

    S.peers = {}
    local rawJob = (type(game.JobId) == "string" and #game.JobId > 0) and game.JobId or ("studio_" .. tostring(game.PlaceId))
    local cleanJob = rawJob:gsub("[^%w]", ""):lower():sub(1, 24)
    local topic = "ydx_bb1_" .. cleanJob
    local postUrl = "https://ntfy.sh/" .. topic
    local pollUrl = "https://ntfy.sh/" .. topic .. "/json?poll=1&since=20s"

    local lastHash = ""
    local lastPostAt = 0
    local dirty = false

    local function buildPayload()
        return {
            uid = tostring(LocalPlayer.UserId),
            sword = S.equippedSword,
            acc = S.showAccessory,
            style = S.animStyle,
            exp = S.equippedExplosion,
            fin = S.finishersEquipped[S.equippedSword] == true,
            emote = S.currentEmote,
            emoteAt = S.currentEmoteAt,
        }
    end

    local function stateHash(p)
        return table.concat({
            tostring(p.sword),
            tostring(p.acc),
            tostring(p.style),
            tostring(p.exp),
            tostring(p.fin),
            tostring(p.emote),
            tostring(p.emoteAt),
        }, "|")
    end

    S.pushState = function(immediate)
        dirty = true
        if immediate then
            lastPostAt = 0
        end
    end

    local function applyPeerData(data)
        if type(data) ~= "table" or type(data.uid) ~= "string" then
            return
        end
        if data.uid == tostring(LocalPlayer.UserId) then
            return
        end
        local prev = S.peers[data.uid]
        local peer = {
            uid = data.uid,
            sword = type(data.sword) == "string" and data.sword or "Base Sword",
            showAccessory = data.acc ~= false,
            animStyle = type(data.style) == "string" and data.style or "Default",
            explosion = type(data.exp) == "string" and data.exp or "Explosion Normal",
            finisher = data.fin == true,
            emote = type(data.emote) == "string" and data.emote or "",
            emoteAt = tonumber(data.emoteAt) or workspace:GetServerTimeNow(),
        }
        S.peers[data.uid] = peer

        local targetPlr = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if tostring(p.UserId) == data.uid then
                targetPlr = p
                break
            end
        end
        if not targetPlr then
            return
        end

        local swordChanged = not prev
            or prev.sword ~= peer.sword
            or prev.showAccessory ~= peer.showAccessory
            or prev.animStyle ~= peer.animStyle

        if swordChanged then
            if targetPlr.Character then
                applyCharacterSword(targetPlr, targetPlr.Character, peer)
            else
                targetPlr:SetAttribute("CurrentlyEquippedSword", peer.sword)
                targetPlr:SetAttribute("ShowSwordAccessory", peer.showAccessory)
                targetPlr:SetAttribute("AnimationStyle", peer.animStyle)
            end
        end

        local emoteChanged = not prev or prev.emote ~= peer.emote or prev.emoteAt ~= peer.emoteAt
        if emoteChanged and targetPlr.Character then
            if #peer.emote > 0 then
                playCharacterEmote(targetPlr.Character, peer.emote, true, peer.emoteAt)
            else
                playCharacterEmote(targetPlr.Character, nil, false, peer.emoteAt)
            end
        end
    end

    -- Background poster loop
    task.spawn(function()
        S.pushState(true)
        while S.alive do
            local now = os.clock()
            local p = buildPayload()
            local h = stateHash(p)
            if dirty or h ~= lastHash or (now - lastPostAt) >= 12 then
                dirty = false
                lastHash = h
                lastPostAt = now
                pcall(function()
                    reqFn({
                        Url = postUrl,
                        Method = "POST",
                        Headers = { ["Content-Type"] = "text/plain" },
                        Body = HttpService:JSONEncode(p),
                    })
                end)
            end
            task.wait(0.25)
        end
    end)

    -- Background poller loop
    local seenMsgIds = {}
    task.spawn(function()
        while S.alive do
            pcall(function()
                local res = reqFn({
                    Url = pollUrl,
                    Method = "GET",
                })
                if type(res) == "table" and type(res.Body) == "string" and #res.Body > 0 then
                    for line in res.Body:gmatch("[^\r\n]+") do
                        local ok, env = pcall(function()
                            return HttpService:JSONDecode(line)
                        end)
                        if ok and type(env) == "table" and env.event == "message" and type(env.message) == "string" then
                            local msgId = tostring(env.id or "")
                            if #msgId == 0 or not seenMsgIds[msgId] then
                                if #msgId > 0 then
                                    seenMsgIds[msgId] = true
                                end
                                local dok, data = pcall(function()
                                    return HttpService:JSONDecode(env.message)
                                end)
                                if dok and type(data) == "table" then
                                    applyPeerData(data)
                                end
                            end
                        end
                    end
                end
            end)
            task.wait(1.2)
        end
    end)
end

-- ============================================================
-- 8. INITIALIZE & CHARACTER LIFECYCLE
-- ============================================================
unlockAllCosmetics()
installNamecallHook()
hookParryConnections()
hookExplosionsAndFinishers()
startP2PSync()

local function bindPlayer(plr)
    if plr.Character then
        attachCharacterGuard(plr, plr.Character)
    end
    table.insert(S.conns, plr.CharacterAdded:Connect(function(char)
        if not S.alive then return end
        task.wait(0.1)
        attachCharacterGuard(plr, char)
    end))
end

for _, plr in ipairs(Players:GetPlayers()) do
    bindPlayer(plr)
end

table.insert(S.conns, Players.PlayerAdded:Connect(function(plr)
    if not S.alive then return end
    bindPlayer(plr)
    if S.pushState then
        S.pushState(true)
    end
end))

if workspace:FindFirstChild("Alive") then
    table.insert(S.conns, workspace.Alive.ChildAdded:Connect(function(char)
        if not S.alive then return end
        local plr = Players:GetPlayerFromCharacter(char)
        if plr then
            task.delay(0.1, function()
                if S.alive and char.Parent then
                    attachCharacterGuard(plr, char)
                end
            end)
        end
    end))
end

_G.__bladeball_unlock_cleanup = function()
    S.alive = false
    for _, c in ipairs(S.conns) do
        pcall(function() c:Disconnect() end)
    end
    for _, gList in pairs(S.charGuards) do
        for _, c in ipairs(gList) do
            pcall(function() c:Disconnect() end)
        end
    end
    for i = #S.origHooks, 1, -1 do
        pcall(S.origHooks[i])
    end
end

print("[BladeBall UnlockAll] v1.0 Ready! Equipped Sword:", S.equippedSword, "| Explosion:", S.equippedExplosion)
