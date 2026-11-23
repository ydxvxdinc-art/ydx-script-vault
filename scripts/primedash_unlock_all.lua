-- ============================================================================
-- PRIME DASH - UNLOCK ALL + LIVE COSMETIC & PROFILE ENFORCER (ZERO-LAG)
-- [YDX Execution Telemetry - Non-Duplicating when loaded via Universal Loader]
do
    local env = (type(getgenv) == "function" and getgenv()) or _G
    env.__YDX_EXEC_LOCKS = env.__YDX_EXEC_LOCKS or {}
    local sid = "primedash-unlock"
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
-- ============================================================================
-- * Desbloqueia 100% das Skins (36+ skins, incluindo as skins de Teste/Studio:
--   Policial, Bombeiro, Papai Noel, Lenco V1, V23 Teste, V23 Vestido, etc.)
-- * Desbloqueia todas as 12 Cores de Pele na aba CORES (em vez de apenas 5)
-- * Desbloqueia as abas secretas SOCOS (Soco Padrao, Soco de Agua com FX 3D)
--   e RASTROS (Fumaca, Pegadas de Agua 3D, Areia Dourada 3D)
-- * Desbloqueia todos os Emotes (Floss / Danca) e Pacotes da Loja
-- * Desbloqueia 100% do Perfil: 38 Medalhas, 25 Titulos e 27 Banners
-- * Aplica e mantem a Skin, Cor, Rastro, Soco, Emote, Titulo, Banner e Medalhas
--   equipados ao vivo no Lobby, no Perfil e dentro das Partidas!
-- ============================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    return
end

if _G.__PrimeDashUnlockAllCleanup then
    pcall(_G.__PrimeDashUnlockAllCleanup)
end

local connections = {}
local function trackConn(c)
    if c then
        table.insert(connections, c)
    end
    return c
end

local function safeRequire(inst)
    if not inst then
        return nil
    end
    local ok, mod = pcall(require, inst)
    if ok then
        return mod
    end
    return nil
end

local Factory = ReplicatedStorage:WaitForChild("StumbleOriginal056Factory", 10)
local CharacterCatalog = Factory and safeRequire(Factory:FindFirstChild("CharacterCatalog"))
local CharacterAppearance = Factory and safeRequire(Factory:FindFirstChild("CharacterAppearance"))
local CharacterPreview = Factory and safeRequire(Factory:FindFirstChild("CharacterPreview"))
local ScreenRouter = Factory and safeRequire(Factory:FindFirstChild("ScreenRouter"))
local UIKit = Factory and safeRequire(Factory:FindFirstChild("UIKit"))
local MenuArt = Factory and safeRequire(Factory:FindFirstChild("MenuArt"))

local SkinUIAssets = safeRequire(ReplicatedStorage:FindFirstChild("SkinUIAssets"))
local SkinShopConfig = safeRequire(ReplicatedStorage:FindFirstChild("SkinShopConfig"))
local ShopCatalog = safeRequire(ReplicatedStorage:FindFirstChild("ShopCatalog"))
local SkinRarity = safeRequire(ReplicatedStorage:FindFirstChild("SkinRarity"))
local TrailCatalog = safeRequire(ReplicatedStorage:FindFirstChild("TrailCatalog"))
local PunchCatalog = safeRequire(ReplicatedStorage:FindFirstChild("PunchCatalog"))
local EmoteCatalog = safeRequire(ReplicatedStorage:FindFirstChild("EmoteCatalog"))
local ProfileCatalog = safeRequire(ReplicatedStorage:FindFirstChild("ProfileCatalog"))
local ShopAssets = safeRequire(ReplicatedStorage:FindFirstChild("ShopAssets"))

-- ============================================================================
-- 1. REGISTER HIDDEN STUDIO & TEMPLATE SKINS INTO CHARACTERCATALOG
-- ============================================================================
local extraSkins = {
    { id = "BonecoPolicial",   name = "POLICE",         footLift = 0.035, rarityId = "epic",    origin = "Christmas Pack / Studio" },
    { id = "BonecoBombeiro",   name = "FIREFIGHTER",    footLift = 0.035, rarityId = "epic",    origin = "Christmas Pack / Studio" },
    { id = "BonecoPapaiNoel",  name = "SANTA CLAUS",    footLift = 0.035, rarityId = "mythic",  origin = "Christmas Pack / Studio" },
    { id = "BonecoLencoV1",    name = "SCARF V1",       footLift = 0.035, rarityId = "special", origin = "Secret File (Studio)" },
    { id = "BonecoV23Teste",   name = "V23 TEST",       footLift = 0.035, rarityId = "rare",    origin = "Secret File (Studio)" },
    { id = "BonecoV23Vestido", name = "V23 DRESS",      footLift = 0.035, rarityId = "epic",    origin = "Secret File (Studio)" }
}

if CharacterCatalog and type(CharacterCatalog.skins) == "table" then
    local existing = {}
    for _, s in ipairs(CharacterCatalog.skins) do
        if type(s) == "table" and s.id then
            existing[s.id] = true
        end
    end
    local slimMesh = Factory and Factory:FindFirstChild("SlimCharacterMesh")
    for _, ex in ipairs(extraSkins) do
        local hasMesh = not slimMesh or slimMesh:FindFirstChild(ex.id .. "Data") ~= nil
        if not existing[ex.id] and hasMesh then
            table.insert(CharacterCatalog.skins, {
                id = ex.id,
                name = ex.name,
                footLift = ex.footLift
            })
            existing[ex.id] = true
        end
        if SkinRarity and type(SkinRarity.Skins) == "table" and not SkinRarity.Skins[ex.id] then
            SkinRarity.Skins[ex.id] = {
                rarityId = ex.rarityId,
                origin = ex.origin
            }
        end
    end
end

-- ============================================================================
-- 2. COLLECT ALL ITEM IDS & PATCH CATALOG MODULE FUNCTIONS
-- ============================================================================
local allSkinIds = {}
local skinSeen = {}
local function addSkinId(id)
    if type(id) == "string" and id ~= "" and not skinSeen[id] then
        skinSeen[id] = true
        table.insert(allSkinIds, id)
    end
end

if CharacterCatalog and type(CharacterCatalog.skins) == "table" then
    for _, s in ipairs(CharacterCatalog.skins) do
        if type(s) == "table" then
            addSkinId(s.id)
        end
    end
end
if SkinRarity and type(SkinRarity.Skins) == "table" then
    for id, _ in pairs(SkinRarity.Skins) do
        addSkinId(id)
    end
end
if SkinShopConfig then
    if type(SkinShopConfig.PaidSkins) == "table" then
        for id, _ in pairs(SkinShopConfig.PaidSkins) do
            addSkinId(id)
        end
    end
    if type(SkinShopConfig.TestSkins) == "table" then
        for id, _ in pairs(SkinShopConfig.TestSkins) do
            addSkinId(id)
        end
    end
end

local allTrailIds = {}
if TrailCatalog and type(TrailCatalog.Items) == "table" then
    for _, item in ipairs(TrailCatalog.Items) do
        if type(item) == "table" and item.id then
            item.available = true
            table.insert(allTrailIds, item.id)
        end
    end
    TrailCatalog.usable = function()
        return true
    end
    TrailCatalog.ownedMap = function()
        local m = {}
        for _, id in ipairs(allTrailIds) do
            m[id] = true
        end
        return m
    end
end

local allPunchIds = {}
if PunchCatalog and type(PunchCatalog.Items) == "table" then
    for _, item in ipairs(PunchCatalog.Items) do
        if type(item) == "table" and item.id then
            item.available = true
            table.insert(allPunchIds, item.id)
        end
    end
    PunchCatalog.usable = function()
        return true
    end
    PunchCatalog.ownedMap = function()
        local m = {}
        for _, id in ipairs(allPunchIds) do
            m[id] = true
        end
        return m
    end
end

local allEmoteIds = {}
if EmoteCatalog and type(EmoteCatalog.Items) == "table" then
    for _, item in ipairs(EmoteCatalog.Items) do
        if type(item) == "table" and item.id then
            item.available = true
            table.insert(allEmoteIds, item.id)
        end
    end
    EmoteCatalog.usable = function()
        return true
    end
    EmoteCatalog.ownedMap = function()
        local m = {}
        for _, id in ipairs(allEmoteIds) do
            m[id] = true
        end
        return m
    end
end

local allBundleIds = { "Bundle", "TerrorBundle", "Summer1", "Summer2", "Deserto" }
if ShopCatalog and type(ShopCatalog.Bundles) == "table" then
    local bSeen = {}
    for _, id in ipairs(allBundleIds) do
        bSeen[id] = true
    end
    for id, _ in pairs(ShopCatalog.Bundles) do
        if not bSeen[id] then
            bSeen[id] = true
            table.insert(allBundleIds, id)
        end
    end
end

if SkinShopConfig then
    if type(SkinShopConfig.PaidSkins) == "table" then
        table.clear(SkinShopConfig.PaidSkins)
    end
    if type(SkinShopConfig.TestSkins) == "table" then
        table.clear(SkinShopConfig.TestSkins)
    end
    SkinShopConfig.ParseOwned = function()
        local m = {}
        for _, id in ipairs(allSkinIds) do
            m[id] = true
        end
        return m
    end
    SkinShopConfig.HasAllBundleSkins = function()
        return true
    end
    SkinShopConfig.BundleOwned = function()
        return true
    end
end

-- ============================================================================
-- 3. UNLOCK ALL PROFILE MEDALS (38), TITLES (25) & BANNERS (27)
-- ============================================================================
local allMedalIds = {}
local allBannerIds = {}
local allTitleIds = {}

if ProfileCatalog then
    if type(ProfileCatalog.Medals) == "table" then
        for _, m in ipairs(ProfileCatalog.Medals) do
            if type(m) == "table" and m.id then
                table.insert(allMedalIds, m.id)
            end
        end
    end
    if type(ProfileCatalog.Banners) == "table" then
        for _, b in ipairs(ProfileCatalog.Banners) do
            if type(b) == "table" and b.id then
                table.insert(allBannerIds, b.id)
            end
        end
    end
    if type(ProfileCatalog.Titles) == "table" then
        for _, t in ipairs(ProfileCatalog.Titles) do
            if type(t) == "table" and t.id then
                table.insert(allTitleIds, t.id)
            end
        end
    end
    ProfileCatalog.TitleUnlocked = function()
        return true
    end
    ProfileCatalog.BannerUnlocked = function()
        return true
    end
    ProfileCatalog.MedalsFor = function()
        local map = {}
        local list = {}
        for _, id in ipairs(allMedalIds) do
            map[id] = true
            table.insert(list, id)
        end
        return map, list
    end
end

-- ============================================================================
-- 4. AUTHORITATIVE CLIENT LOADOUT & ATTRIBUTE ENFORCEMENT
-- ============================================================================
local allSkinsCsv = table.concat(allSkinIds, ",")
local allTrailsCsv = table.concat(allTrailIds, ",")
local allPunchesCsv = table.concat(allPunchIds, ",")
local allEmotesCsv = table.concat(allEmoteIds, ",")
local allBundlesCsv = table.concat(allBundleIds, ",")

local customLoadout = {
    skin = LocalPlayer:GetAttribute("SGCharacterVisual") or "BonecoNoob",
    color = LocalPlayer:GetAttribute("SGCharacterColor") or "COLOR12",
    trail = LocalPlayer:GetAttribute("SGTrail") or "Fumaca",
    punch = LocalPlayer:GetAttribute("SGPunch") or "Padrao",
    emote = LocalPlayer:GetAttribute("SGEmote") or "Floss"
}

local customProfile = {
    title = nil,
    banner = nil,
    show = nil
}

local peerStates = {} -- [uidStr] = { uid = num, name = str, skin = str, color = str, trail = str, punch = str, emote = str, title = str, banner = str, show = tbl, tag = str, tagColor = str, ts = num }
local broadcastMyState = nil
local savePresetToFile = nil
local PRESET_FILE = "primedash_saved_preset.json"
local HttpService = game:GetService("HttpService")
local updatingPeerAttrs = {}

-- Load saved preset from disk if available
pcall(function()
    if type(isfile) == "function" and type(readfile) == "function" and isfile(PRESET_FILE) then
        local raw = readfile(PRESET_FILE)
        if type(raw) == "string" and #raw > 2 then
            local decoded = HttpService:JSONDecode(raw)
            if type(decoded) == "table" then
                if type(decoded.skin) == "string" and decoded.skin ~= "" then customLoadout.skin = decoded.skin end
                if type(decoded.color) == "string" and decoded.color ~= "" then customLoadout.color = decoded.color end
                if type(decoded.trail) == "string" and decoded.trail ~= "" then customLoadout.trail = decoded.trail end
                if type(decoded.punch) == "string" and decoded.punch ~= "" then customLoadout.punch = decoded.punch end
                if type(decoded.emote) == "string" and decoded.emote ~= "" then customLoadout.emote = decoded.emote end
                if type(decoded.title) == "string" and decoded.title ~= "" then customProfile.title = decoded.title end
                if type(decoded.banner) == "string" and decoded.banner ~= "" then customProfile.banner = decoded.banner end
                if type(decoded.show) == "table" and #decoded.show > 0 then customProfile.show = decoded.show end
            end
        end
    end
end)

savePresetToFile = function()
    if type(writefile) ~= "function" then
        return
    end
    pcall(function()
        local data = {
            skin = customLoadout.skin,
            color = customLoadout.color,
            trail = customLoadout.trail,
            punch = customLoadout.punch,
            emote = customLoadout.emote,
            title = customProfile.title,
            banner = customProfile.banner,
            show = customProfile.show
        }
        writefile(PRESET_FILE, HttpService:JSONEncode(data))
    end)
end

-- Hook CharacterAppearance.forOwner so both LocalPlayer and synced Peers always return their authoritative P2P skin & color!
if CharacterAppearance and type(CharacterAppearance.forOwner) == "function" then
    local origForOwner = CharacterAppearance.forOwner
    CharacterAppearance.forOwner = function(owner, ...)
        if owner == LocalPlayer then
            if CharacterCatalog and type(CharacterCatalog.sanitize) == "function" then
                return CharacterCatalog.sanitize({
                    skin = customLoadout.skin or LocalPlayer:GetAttribute("SGCharacterVisual"),
                    color = customLoadout.color or LocalPlayer:GetAttribute("SGCharacterColor")
                })
            end
        elseif typeof(owner) == "Instance" and owner:IsA("Player") then
            local pState = peerStates[tostring(owner.UserId)]
            if pState and CharacterCatalog and type(CharacterCatalog.sanitize) == "function" then
                return CharacterCatalog.sanitize({
                    skin = pState.skin or owner:GetAttribute("SGCharacterVisual"),
                    color = pState.color or owner:GetAttribute("SGCharacterColor")
                })
            end
        end
        return origForOwner(owner, ...)
    end
end

local applyingAttrs = false

local function refreshLobbyAndCharacterPreview()
    pcall(function()
        local ctrl = _G.__SG056Control
        if ctrl and ctrl.mainMenu and not ctrl.mainMenu.started and ctrl.mainMenu.preview and CharacterAppearance then
            ctrl.mainMenu.preview:Set(CharacterAppearance.forOwner(LocalPlayer))
        end
    end)
end

local function enforceUnlockAttributes()
    if applyingAttrs then
        return
    end
    applyingAttrs = true
    pcall(function()
        if LocalPlayer:GetAttribute("SGOwnedSkins") ~= allSkinsCsv then
            LocalPlayer:SetAttribute("SGOwnedSkins", allSkinsCsv)
        end
        if LocalPlayer:GetAttribute("SGOwnedTrails") ~= allTrailsCsv then
            LocalPlayer:SetAttribute("SGOwnedTrails", allTrailsCsv)
        end
        if LocalPlayer:GetAttribute("SGOwnedPunches") ~= allPunchesCsv then
            LocalPlayer:SetAttribute("SGOwnedPunches", allPunchesCsv)
        end
        if LocalPlayer:GetAttribute("SGOwnedEmotes") ~= allEmotesCsv then
            LocalPlayer:SetAttribute("SGOwnedEmotes", allEmotesCsv)
        end
        if LocalPlayer:GetAttribute("SGBundlesOwned") ~= allBundlesCsv then
            LocalPlayer:SetAttribute("SGBundlesOwned", allBundlesCsv)
        end
        if LocalPlayer:GetAttribute("SGPaidRandomBlocked") ~= false then
            LocalPlayer:SetAttribute("SGPaidRandomBlocked", false)
        end
        if LocalPlayer:GetAttribute("SGNoEmote") == true then
            LocalPlayer:SetAttribute("SGNoEmote", false)
        end
        if customLoadout.skin and LocalPlayer:GetAttribute("SGCharacterVisual") ~= customLoadout.skin then
            LocalPlayer:SetAttribute("SGCharacterVisual", customLoadout.skin)
        end
        if customLoadout.color and LocalPlayer:GetAttribute("SGCharacterColor") ~= customLoadout.color then
            LocalPlayer:SetAttribute("SGCharacterColor", customLoadout.color)
        end
        if customLoadout.trail and LocalPlayer:GetAttribute("SGTrail") ~= customLoadout.trail then
            LocalPlayer:SetAttribute("SGTrail", customLoadout.trail)
        end
        if customLoadout.punch and LocalPlayer:GetAttribute("SGPunch") ~= customLoadout.punch then
            LocalPlayer:SetAttribute("SGPunch", customLoadout.punch)
        end
        if customLoadout.emote and LocalPlayer:GetAttribute("SGEmote") ~= customLoadout.emote then
            LocalPlayer:SetAttribute("SGEmote", customLoadout.emote)
        end
    end)
    applyingAttrs = false
end

enforceUnlockAttributes()

local watchedAttrs = {
    "SGOwnedSkins",
    "SGOwnedTrails",
    "SGOwnedPunches",
    "SGOwnedEmotes",
    "SGBundlesOwned",
    "SGPaidRandomBlocked",
    "SGCharacterVisual",
    "SGCharacterColor",
    "SGTrail",
    "SGPunch",
    "SGEmote"
}

for _, attrName in ipairs(watchedAttrs) do
    trackConn(LocalPlayer:GetAttributeChangedSignal(attrName):Connect(function()
        if not applyingAttrs then
            enforceUnlockAttributes()
        end
    end))
end

-- ============================================================================
-- 5. PATCH STUMBLESKINSCLIENT UPVALUES & UI (HIDDEN SKINS + ALL 12 COLORS)
-- ============================================================================
local function upgradeStumbleSkinsClient()
    if type(getgc) ~= "function" then
        return
    end
    local getupvals = (debug and debug.getupvalues) or getupvalues
    if type(getupvals) ~= "function" then
        return
    end

    local u48Ref, u41Ref, u39Ref, u61Ref, layoutSkinsRef, paintRef, showCurrentRef, refreshCreatorTabsRef
    local scrollingFrameRef

    for _, obj in ipairs(getgc(true)) do
        if type(obj) == "table" then
            local bNoob = rawget(obj, "BonecoNoob")
            if type(bNoob) == "table" and rawget(bNoob, "card") and rawget(bNoob, "box") then
                u48Ref = obj
            else
                local first = rawget(obj, 1)
                local second = rawget(obj, 2)
                if type(first) == "table" then
                    if rawget(first, "id") == "emotes" and type(second) == "table" and rawget(second, "id") == "colors" then
                        u41Ref = obj
                    elseif rawget(first, "id") == "COLOR12" and type(second) == "table" and rawget(second, "id") == "COLOR6" then
                        u39Ref = obj
                    end
                end
            end
        elseif type(obj) == "function" and (not islclosure or islclosure(obj)) then
            local ok, ups = pcall(getupvals, obj)
            if ok and type(ups) == "table" then
                local hasSkinGrid = false
                local hasStumbleSkins = false
                local hasFetchCurrent = false
                for _, v in pairs(ups) do
                    if typeof(v) == "Instance" then
                        if v.Name == "SkinGrid" and v:IsA("ScrollingFrame") then
                            scrollingFrameRef = v
                            hasSkinGrid = true
                        elseif v.Name == "StumbleSkins" then
                            hasStumbleSkins = true
                        end
                    elseif type(v) == "function" then
                        local iOk, inf = pcall(debug.getinfo, v)
                        if iOk and inf and inf.name == "fetchCurrent" then
                            hasFetchCurrent = true
                        end
                    end
                end
                if hasStumbleSkins and hasFetchCurrent then
                    u61Ref = obj
                end
                local infoOk, info = pcall(debug.getinfo, obj)
                if infoOk and type(info) == "table" then
                    if info.name == "layoutSkins" and hasSkinGrid then
                        layoutSkinsRef = obj
                    elseif info.name == "paint" and hasSkinGrid then
                        paintRef = obj
                    elseif info.name == "showCurrent" then
                        for _, v in pairs(ups) do
                            if type(v) == "function" then
                                local i2, inf2 = pcall(debug.getinfo, v)
                                if i2 and inf2 and inf2.name == "ensureMainPreview" then
                                    showCurrentRef = obj
                                    break
                                end
                            end
                        end
                    elseif info.name == "refreshCreatorTabs" then
                        refreshCreatorTabsRef = obj
                    end
                end
            end
        end
    end

    if not scrollingFrameRef then
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        local sg = pg and pg:FindFirstChild("StumbleSkinsGui")
        scrollingFrameRef = sg and sg:FindFirstChild("SkinGrid", true)
    end

    -- Helper UI builders matching StumbleSkinsClient
    local function addHover(btn, scaleAmt)
        local sc = btn:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
        sc.Parent = btn
        local TweenService = game:GetService("TweenService")
        local ti = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        btn.MouseEnter:Connect(function()
            TweenService:Create(sc, ti, { Scale = scaleAmt }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(sc, ti, { Scale = 1 }):Play()
        end)
    end

    local function makeLayer(parent, name, img, z, size, pos)
        local il = Instance.new("ImageLabel")
        il.Name = name
        il.BackgroundTransparency = 1
        il.BorderSizePixel = 0
        il.Image = img or ""
        il.AnchorPoint = Vector2.new(0.5, 0.5)
        il.Position = pos or UDim2.fromScale(0.5, 0.5)
        il.Size = size or UDim2.fromScale(1, 1)
        il.ZIndex = z
        il.Active = false
        il.Parent = parent
        return il
    end

    local function makeCardName(parent, text)
        if not UIKit then
            return nil
        end
        local lbl = UIKit.label(parent, "CardName", text, 16)
        lbl.AnchorPoint = Vector2.new(0.5, 1)
        lbl.Position = UDim2.new(0.5, 0, 1, -9)
        lbl.Size = UDim2.new(1, -14, 0, 24)
        lbl.TextScaled = true
        lbl.ZIndex = 4
        local tc = Instance.new("UITextSizeConstraint")
        tc.MaxTextSize = 16
        tc.MinTextSize = 12
        tc.Parent = lbl
        return lbl
    end

    -- Inject missing skin cards (Policial, Bombeiro, Papai Noel, etc.) into SkinGrid & u48
    if u48Ref and scrollingFrameRef and CharacterCatalog and SkinUIAssets and SkinRarity then
        for idx, skinEntry in ipairs(CharacterCatalog.skins) do
            if not u48Ref[skinEntry.id] then
                local rar = SkinRarity.get(skinEntry.id)
                local cardImg = SkinUIAssets.Card[rar.rarityId] or SkinUIAssets.Card.common
                local btn = Instance.new("ImageButton")
                btn.Name = "Skin_" .. skinEntry.id
                btn.BackgroundTransparency = 1
                btn.BorderSizePixel = 0
                btn.AutoButtonColor = false
                btn.Image = cardImg
                btn.Selectable = true
                btn.Size = UDim2.fromOffset(132, 165)
                local row = math.floor((idx - 1) / 5)
                btn.Position = UDim2.fromOffset(((idx - 1) % 5) * 146, row * 179)
                btn.Parent = scrollingFrameRef
                addHover(btn, 1.05)
                if MenuArt and MenuArt.bindSound then
                    pcall(MenuArt.bindSound, btn)
                end

                local clip = Instance.new("Frame")
                clip.Name = "Clip"
                clip.BackgroundTransparency = 1
                clip.BorderSizePixel = 0
                clip.Position = UDim2.fromOffset(4, 4)
                clip.Size = UDim2.new(1, -8, 1, -8)
                clip.ClipsDescendants = true
                clip.ZIndex = 3
                clip.Active = false
                clip.Parent = btn
                local uc = Instance.new("UICorner")
                uc.CornerRadius = UDim.new(0, 6)
                uc.Parent = clip

                local pbox = Instance.new("Frame")
                pbox.Name = "PreviewBox"
                pbox.BackgroundTransparency = 1
                pbox.Position = UDim2.fromOffset(-35.35, -5.841)
                pbox.Size = UDim2.fromOffset(194.7, 194.7)
                pbox.ZIndex = 3
                pbox.Active = false
                pbox.Parent = clip

                if ShopAssets and ShopAssets.BottomFade then
                    local fade = makeLayer(btn, "Fade", ShopAssets.BottomFade, 4, UDim2.new(1, -8, 0.5, -4), UDim2.new(0.5, 0, 0.77, 0))
                    local uc2 = Instance.new("UICorner")
                    uc2.CornerRadius = UDim.new(0, 6)
                    uc2.Parent = fade
                    fade.ScaleType = Enum.ScaleType.Stretch
                end

                makeCardName(btn, skinEntry.name)
                local sel = makeLayer(btn, "Selected", SkinUIAssets.CardSelected, 6)
                sel.Visible = false
                local eq = makeLayer(btn, "Equipped", SkinUIAssets.Icon.check, 7, UDim2.fromOffset(30, 30), UDim2.new(1, -20, 0, 21))
                eq.Visible = false

                u48Ref[skinEntry.id] = {
                    card = btn,
                    box = pbox,
                    selected = sel,
                    badge = eq,
                    lock = nil
                }

                if ScreenRouter and u61Ref then
                    local sid = skinEntry.id
                    ScreenRouter.on(btn, function()
                        u61Ref({ skin = sid })
                    end)
                end
            end
        end
    end

    -- Unlock all 12 Skin Colors in the Colors tab (instead of just 5)
    if u41Ref and u39Ref and CharacterCatalog and type(CharacterCatalog.colors) == "table" and SkinUIAssets then
        local colorTab = nil
        for _, t in ipairs(u41Ref) do
            if t.id == "colors" then
                colorTab = t
                break
            end
        end

        if colorTab and colorTab.grid and colorTab.cards then
            local colorExist = {}
            for _, c in ipairs(u39Ref) do
                colorExist[c.id] = true
            end

            local extraColorNames = {
                COLOR1  = "MEDIUM SKIN",
                COLOR2  = "LIGHT",
                COLOR3  = "BROWN",
                COLOR4  = "ORANGE",
                COLOR5  = "GREEN",
                COLOR6  = "BLACK",
                COLOR7  = "BLUE",
                COLOR8  = "PINK",
                COLOR9  = "RED",
                COLOR10 = "PURPLE",
                COLOR11 = "WHITE",
                COLOR12 = "DEFAULT"
            }

            for _, cEntry in ipairs(CharacterCatalog.colors) do
                if not colorExist[cEntry.id] then
                    colorExist[cEntry.id] = true
                    table.insert(u39Ref, {
                        id = cEntry.id,
                        name = extraColorNames[cEntry.id] or string.upper(cEntry.name or cEntry.id),
                        rarity = "common",
                        available = true,
                        origin = "Skin color: NOOB, CRAQUE 10, NINJAS, SAMURAI, CLOWN and SCARVES",
                        swatch = { CharacterCatalog.color(cEntry.id) }
                    })
                end
            end

            -- Remove placeholder "Soon" cards for slots occupied by new colors
            for idx, item in ipairs(u39Ref) do
                if not colorTab.cards[item.id] and idx <= 20 then
                    local soonBtn = colorTab.grid:FindFirstChild("Soon" .. tostring(idx))
                    if soonBtn then
                        soonBtn:Destroy()
                    end

                    local btn = Instance.new("ImageButton")
                    btn.Name = "color_" .. item.id
                    btn.BackgroundTransparency = 1
                    btn.BorderSizePixel = 0
                    btn.AutoButtonColor = false
                    btn.Image = SkinUIAssets.Card.common
                    btn.Selectable = true
                    btn.Size = UDim2.fromOffset(132, 165)
                    local row = math.floor((idx - 1) / 5)
                    btn.Position = UDim2.fromOffset(((idx - 1) % 5) * 146, row * 179)
                    btn.Parent = colorTab.grid
                    addHover(btn, 1.05)
                    if MenuArt and MenuArt.bindSound then
                        pcall(MenuArt.bindSound, btn)
                    end

                    local iconLayer = makeLayer(btn, "ItemIcon", colorTab.fallbackIcon, 3, UDim2.fromOffset(92, 92), UDim2.new(0.5, 0, 0, 60))
                    iconLayer.Visible = false

                    local sw = Instance.new("Frame")
                    sw.Name = "Swatch"
                    sw.AnchorPoint = Vector2.new(0.5, 0.5)
                    sw.Position = UDim2.new(0.5, 0, 0, 66)
                    sw.Size = UDim2.fromOffset(84, 84)
                    sw.BackgroundColor3 = item.swatch[1]
                    sw.BorderSizePixel = 0
                    sw.ZIndex = 3
                    sw.Parent = btn
                    local uc = Instance.new("UICorner")
                    uc.CornerRadius = UDim.new(1, 0)
                    uc.Parent = sw
                    local us = Instance.new("UIStroke")
                    us.Color = Color3.fromRGB(12, 22, 58)
                    us.Thickness = 4
                    us.Parent = sw

                    local sh = Instance.new("Frame")
                    sh.Name = "Shine"
                    sh.BackgroundColor3 = Color3.new(1, 1, 1)
                    sh.BackgroundTransparency = 0.35
                    sh.BorderSizePixel = 0
                    sh.Position = UDim2.fromScale(0.18, 0.14)
                    sh.Size = UDim2.fromScale(0.3, 0.18)
                    sh.ZIndex = 4
                    sh.Parent = sw
                    local uc2 = Instance.new("UICorner")
                    uc2.CornerRadius = UDim.new(1, 0)
                    uc2.Parent = sh

                    local unavail = makeLayer(btn, "Unavailable", SkinUIAssets.Icon.lock, 9, UDim2.fromOffset(40, 40), UDim2.new(0.5, 0, 0, 60))
                    unavail.Visible = false
                    makeCardName(btn, item.name)

                    local sel = makeLayer(btn, "Selected", SkinUIAssets.CardSelected, 6)
                    sel.Visible = false
                    local eq = makeLayer(btn, "Equipped", SkinUIAssets.Icon.check, 7, UDim2.fromOffset(30, 30), UDim2.new(1, -20, 0, 21))
                    eq.Visible = false

                    colorTab.cards[item.id] = {
                        card = btn,
                        icon = iconLayer,
                        off = unavail,
                        selected = sel,
                        badge = eq,
                        item = item
                    }

                    if ScreenRouter and u61Ref then
                        local cid = item.id
                        ScreenRouter.on(btn, function()
                            u61Ref({ color = cid })
                        end)
                    end
                end
            end
        end

        -- Ensure all cards in emotes, punches, trails have their lock icons hidden
        for _, tab in ipairs(u41Ref) do
            tab.soon = false
            if type(tab.cards) == "table" then
                for _, cardObj in pairs(tab.cards) do
                    if cardObj.item then
                        cardObj.item.available = true
                    end
                    if cardObj.off and not tab.colors then
                        cardObj.off.Visible = false
                    end
                end
            end
        end
    end

    if refreshCreatorTabsRef then
        pcall(refreshCreatorTabsRef)
    end
    if layoutSkinsRef then
        pcall(layoutSkinsRef)
    end
    if paintRef then
        pcall(paintRef)
    end
    if showCurrentRef then
        pcall(showCurrentRef)
    end
end

upgradeStumbleSkinsClient()

-- ============================================================================
-- 6. PATCH PROFILECLIENT IN-MEMORY PROFILE (u74.me)
-- ============================================================================
local function enrichProfileData(data)
    if type(data) ~= "table" then
        return data
    end
    data.ok = true
    data.medals = table.clone(allMedalIds)
    data.owned = table.clone(allBannerIds)
    if customProfile.title then
        data.title = customProfile.title
    elseif not data.title or data.title == "" then
        data.title = (ProfileCatalog and ProfileCatalog.DefaultTitle) or "calouro"
    end
    if customProfile.banner then
        data.banner = customProfile.banner
    elseif not data.banner or data.banner == "" then
        data.banner = (ProfileCatalog and ProfileCatalog.DefaultBanner) or "sky"
    end
    if customProfile.show then
        data.show = table.clone(customProfile.show)
    elseif type(data.show) ~= "table" or #data.show == 0 then
        data.show = { "crown_500", "laser_300", "founder" }
    end
    if type(data.stats) == "table" then
        data.stats.skins = math.max(tonumber(data.stats.skins) or 0, #allSkinIds)
    end
    return data
end

local function enrichPeerProfileData(data, pState)
    if type(data) ~= "table" or type(pState) ~= "table" then
        return data
    end
    data.ok = true
    data.medals = table.clone(allMedalIds)
    data.owned = table.clone(allBannerIds)
    if type(pState.title) == "string" and pState.title ~= "" then
        data.title = pState.title
    end
    if type(pState.banner) == "string" and pState.banner ~= "" then
        data.banner = pState.banner
    end
    if type(pState.show) == "table" and #pState.show > 0 then
        data.show = table.clone(pState.show)
    end
    data.skin = {
        skin = pState.skin or (type(data.skin) == "table" and data.skin.skin) or "BonecoNoob",
        color = pState.color or (type(data.skin) == "table" and data.skin.color) or "COLOR12"
    }
    if type(data.stats) == "table" then
        data.stats.skins = math.max(tonumber(data.stats.skins) or 0, #allSkinIds)
    end
    return data
end

local function applyOverheadTitleAttribute(titleId)
    if not ProfileCatalog or type(titleId) ~= "string" then
        return
    end
    local tObj = ProfileCatalog.Title(titleId)
    if not tObj then
        return
    end
    local rObj = ProfileCatalog.Rarity and (ProfileCatalog.Rarity[tObj.rarity] or ProfileCatalog.Rarity.common)
    pcall(function()
        LocalPlayer:SetAttribute("SGTag", ProfileCatalog.Upper(tObj.name))
        if rObj and rObj.hex then
            LocalPlayer:SetAttribute("SGTagColor", rObj.hex)
        end
    end)
end

local function upgradeProfileClient()
    if type(getgc) ~= "function" then
        return
    end
    local getupvals = (debug and debug.getupvalues) or getupvalues
    if type(getupvals) ~= "function" then
        return
    end
    for _, fn in ipairs(getgc(false)) do
        if type(fn) == "function" and (not islclosure or islclosure(fn)) then
            local ok, ups = pcall(getupvals, fn)
            if ok and type(ups) == "table" then
                local u74Ref, refreshAllRef
                for _, v in pairs(ups) do
                    if type(v) == "table" and (rawget(v, "editing") ~= nil) and (rawget(v, "me") ~= nil or rawget(v, "viewing") ~= nil) then
                        u74Ref = v
                    elseif type(v) == "function" then
                        local iOk, inf = pcall(debug.getinfo, v)
                        if iOk and inf and inf.name == "refreshAll" then
                            refreshAllRef = v
                        end
                    end
                end
                if u74Ref and type(u74Ref.me) == "table" then
                    enrichProfileData(u74Ref.me)
                    if type(u74Ref.viewing) == "table" and u74Ref.viewing.userId then
                        local pState = peerStates[tostring(u74Ref.viewing.userId)]
                        if pState then
                            enrichPeerProfileData(u74Ref.viewing, pState)
                        end
                    end
                    if refreshAllRef then
                        pcall(refreshAllRef)
                    end
                    break
                end
            end
        end
    end
end

-- ============================================================================
-- 7. HOOK REMOTEFUNCTIONS (StumbleSkins & Profile.Request) VIA __NAMECALL
-- ============================================================================
local StumbleSkinsRF = ReplicatedStorage:FindFirstChild("StumbleSkins")
local ProfileFolder = ReplicatedStorage:FindFirstChild("Profile")
local ProfileRequestRF = ProfileFolder and ProfileFolder:FindFirstChild("Request")
local realInvokeServer = Instance.new("RemoteFunction").InvokeServer

local pendingServerSync = {}
local syncWorkerRunning = false

local function queueServerLoadoutSync(payload)
    if type(payload) ~= "table" or not StumbleSkinsRF then
        return
    end
    for k, v in pairs(payload) do
        pendingServerSync[k] = v
    end
    if syncWorkerRunning then
        return
    end
    syncWorkerRunning = true
    task.spawn(function()
        while next(pendingServerSync) ~= nil do
            -- Wait until player is in Lobby if currently in a match (server blocks StumbleSkins in match)
            while LocalPlayer:GetAttribute("SGInLobby") == false do
                task.wait(0.5)
            end
            local batch = table.clone(pendingServerSync)
            table.clear(pendingServerSync)
            -- Send each field spaced by 0.65s so server anti-spam never throttles it
            for k, v in pairs(batch) do
                if LocalPlayer:GetAttribute("SGInLobby") ~= false then
                    pcall(realInvokeServer, StumbleSkinsRF, "set", { [k] = v })
                    task.wait(0.65)
                else
                    pendingServerSync[k] = v
                end
            end
        end
        syncWorkerRunning = false
    end)
end

trackConn(LocalPlayer:GetAttributeChangedSignal("SGInLobby"):Connect(function()
    if LocalPlayer:GetAttribute("SGInLobby") ~= false then
        queueServerLoadoutSync({
            skin = customLoadout.skin,
            color = customLoadout.color,
            trail = customLoadout.trail,
            punch = customLoadout.punch,
            emote = customLoadout.emote
        })
    end
end))

if type(hookmetamethod) == "function" and type(getnamecallmethod) == "function" and not _G.__PrimeDashNamecallHooked then
    _G.__PrimeDashNamecallHooked = true
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "InvokeServer" then
            if self == StumbleSkinsRF or (typeof(self) == "Instance" and self.Name == "StumbleSkins") then
                local action, payload = ...
                if action == "set" and type(payload) == "table" then
                    if payload.skin then
                        customLoadout.skin = payload.skin
                    end
                    if payload.color then
                        customLoadout.color = payload.color
                    end
                    if payload.trail then
                        customLoadout.trail = payload.trail
                    end
                    if payload.punch then
                        customLoadout.punch = payload.punch
                    end
                    if payload.emote then
                        customLoadout.emote = payload.emote
                    end

                    task.defer(function()
                        enforceUnlockAttributes()
                        refreshLobbyAndCharacterPreview()
                        if savePresetToFile then savePresetToFile() end
                        if broadcastMyState then broadcastMyState(false) end
                    end)

                    -- Queue real server sync (executes immediately in lobby, or as soon as match ends)
                    queueServerLoadoutSync(payload)

                    return {
                        ok = true,
                        skin = customLoadout.skin,
                        color = customLoadout.color,
                        trail = customLoadout.trail,
                        punch = customLoadout.punch,
                        emote = customLoadout.emote
                    }
                end
            elseif self == ProfileRequestRF or (typeof(self) == "Instance" and self.Name == "Request" and self.Parent and self.Parent.Name == "Profile") then
                local action, payload = ...
                if action == "me" then
                    local res = oldNamecall(self, ...)
                    if type(res) == "table" then
                        return enrichProfileData(res)
                    end
                    return enrichProfileData({
                        ok = true,
                        userId = LocalPlayer.UserId,
                        name = LocalPlayer.DisplayName,
                        user = LocalPlayer.Name,
                        stats = { crowns = 0, seconds = 0, skins = #allSkinIds, views = 0 }
                    })
                elseif action == "view" then
                    local res = oldNamecall(self, ...)
                    if type(res) == "table" then
                        local targetUid = tonumber(res.userId) or tonumber(payload)
                        local pState = targetUid and peerStates[tostring(targetUid)] or nil
                        if not pState and type(payload) == "string" then
                            local cleanName = payload:gsub("^@", ""):lower()
                            for _, st in pairs(peerStates) do
                                if type(st.name) == "string" and st.name:lower() == cleanName then
                                    pState = st
                                    break
                                end
                            end
                        end
                        if pState then
                            return enrichPeerProfileData(res, pState)
                        end
                    end
                    return res
                elseif action == "equip" and type(payload) == "table" then
                    if payload.title then
                        customProfile.title = payload.title
                        task.defer(applyOverheadTitleAttribute, payload.title)
                    end
                    if payload.banner then
                        customProfile.banner = payload.banner
                    end
                    if type(payload.show) == "table" then
                        customProfile.show = table.clone(payload.show)
                    end
                    task.defer(function()
                        if savePresetToFile then savePresetToFile() end
                        if broadcastMyState then broadcastMyState(false) end
                    end)

                    -- Forward to real server in background if server allows
                    if ProfileRequestRF then
                        task.spawn(function()
                            pcall(realInvokeServer, ProfileRequestRF, action, payload)
                        end)
                    end

                    return {
                        ok = true,
                        title = customProfile.title or (ProfileCatalog and ProfileCatalog.DefaultTitle) or "calouro",
                        banner = customProfile.banner or (ProfileCatalog and ProfileCatalog.DefaultBanner) or "sky",
                        show = customProfile.show or { "crown_500", "laser_300", "founder" }
                    }
                end
            end
        end
        return oldNamecall(self, ...)
    end)
end

upgradeProfileClient()
refreshLobbyAndCharacterPreview()

-- ============================================================================
-- 8. FLOATING IN-MATCH & LOBBY INSTANT SKIN/COSMETIC CHANGER GUI (HOTKEY: [K])
-- ============================================================================
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local function equipCosmeticInstant(changes)
    if type(changes) ~= "table" then
        return
    end
    if changes.skin then
        customLoadout.skin = changes.skin
    end
    if changes.color then
        customLoadout.color = changes.color
    end
    if changes.trail then
        customLoadout.trail = changes.trail
    end
    if changes.punch then
        customLoadout.punch = changes.punch
    end
    if changes.emote then
        customLoadout.emote = changes.emote
    end

    enforceUnlockAttributes()
    refreshLobbyAndCharacterPreview()

    if changes.title then
        customProfile.title = changes.title
        applyOverheadTitleAttribute(changes.title)
        upgradeProfileClient()
        if ProfileRequestRF then
            task.spawn(function()
                pcall(realInvokeServer, ProfileRequestRF, "equip", { title = changes.title })
            end)
        end
    end

    -- Queue real server sync (sends immediately in lobby, or automatically as soon as match ends)
    if changes.skin or changes.color or changes.trail or changes.punch or changes.emote then
        queueServerLoadoutSync(changes)
    end

    if savePresetToFile then
        savePresetToFile()
    end
    if broadcastMyState then
        broadcastMyState(false)
    end
end

local function createFloatingSkinChangerGui()
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
    if not PlayerGui then
        return
    end

    local oldGui = PlayerGui:FindFirstChild("PrimeDashQuickSkinsGui")
    if oldGui then
        oldGui:Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "PrimeDashQuickSkinsGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 950
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = PlayerGui

    -- Floating Toggle Pill Button (Always accessible in-match & in-lobby)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleBtn"
    toggleBtn.AnchorPoint = Vector2.new(0, 0.5)
    toggleBtn.Position = UDim2.new(0, 14, 0.42, 0)
    toggleBtn.Size = UDim2.fromOffset(142, 42)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(16, 48, 114)
    toggleBtn.Text = "SKINS [K]"
    toggleBtn.Font = Enum.Font.LuckiestGuy
    toggleBtn.TextSize = 20
    toggleBtn.TextColor3 = Color3.fromRGB(255, 220, 65)
    toggleBtn.AutoButtonColor = true
    toggleBtn.ZIndex = 10
    toggleBtn.Parent = gui

    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(0, 12)
    tCorner.Parent = toggleBtn

    local tStroke = Instance.new("UIStroke")
    tStroke.Color = Color3.fromRGB(8, 20, 52)
    tStroke.Thickness = 3
    tStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    tStroke.Parent = toggleBtn

    local tGrad = Instance.new("UIGradient")
    tGrad.Color = ColorSequence.new(Color3.fromRGB(34, 115, 230), Color3.fromRGB(16, 56, 140))
    tGrad.Rotation = 90
    tGrad.Parent = toggleBtn

    -- Main Panel
    local panel = Instance.new("Frame")
    panel.Name = "MainPanel"
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Position = UDim2.fromScale(0.5, 0.5)
    panel.Size = UDim2.fromOffset(780, 480)
    panel.BackgroundColor3 = Color3.fromRGB(13, 38, 92)
    panel.BackgroundTransparency = 0.04
    panel.BorderSizePixel = 0
    panel.Visible = false
    panel.Active = true
    panel.ZIndex = 20
    panel.Parent = gui

    local pCorner = Instance.new("UICorner")
    pCorner.CornerRadius = UDim.new(0, 18)
    pCorner.Parent = panel

    local pStroke = Instance.new("UIStroke")
    pStroke.Color = Color3.fromRGB(6, 18, 46)
    pStroke.Thickness = 4
    pStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    pStroke.Parent = panel

    local pGrad = Instance.new("UIGradient")
    pGrad.Color = ColorSequence.new(Color3.fromRGB(22, 78, 172), Color3.fromRGB(11, 34, 82))
    pGrad.Rotation = 90
    pGrad.Parent = panel

    -- Top Header Bar (Draggable)
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 52)
    header.BackgroundColor3 = Color3.fromRGB(9, 28, 70)
    header.BackgroundTransparency = 0.25
    header.BorderSizePixel = 0
    header.ZIndex = 21
    header.Parent = panel

    local hCorner = Instance.new("UICorner")
    hCorner.CornerRadius = UDim.new(0, 18)
    hCorner.Parent = header

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Name = "Title"
    titleLbl.BackgroundTransparency = 1
    titleLbl.Position = UDim2.fromOffset(18, 6)
    titleLbl.Size = UDim2.fromOffset(440, 40)
    titleLbl.Font = Enum.Font.LuckiestGuy
    titleLbl.Text = "PRIME DASH - LIVE SKIN CHANGER"
    titleLbl.TextSize = 24
    titleLbl.TextColor3 = Color3.fromRGB(255, 220, 65)
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 22
    titleLbl.Parent = header

    local titleStroke = Instance.new("UIStroke")
    titleStroke.Color = Color3.fromRGB(6, 18, 46)
    titleStroke.Thickness = 2.5
    titleStroke.Parent = titleLbl

    local subLbl = Instance.new("TextLabel")
    subLbl.Name = "Sub"
    subLbl.BackgroundTransparency = 1
    subLbl.Position = UDim2.fromOffset(465, 14)
    subLbl.Size = UDim2.fromOffset(235, 24)
    subLbl.Font = Enum.Font.GothamBold
    subLbl.Text = "Equips instantly (Lobby & Match)"
    subLbl.TextSize = 13
    subLbl.TextColor3 = Color3.fromRGB(175, 215, 255)
    subLbl.TextXAlignment = Enum.TextXAlignment.Right
    subLbl.ZIndex = 22
    subLbl.Parent = header

    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.AnchorPoint = Vector2.new(1, 0.5)
    closeBtn.Position = UDim2.new(1, -12, 0.5, 0)
    closeBtn.Size = UDim2.fromOffset(36, 36)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 52, 68)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.LuckiestGuy
    closeBtn.TextSize = 20
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.ZIndex = 23
    closeBtn.Parent = header

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 10)
    cCorner.Parent = closeBtn

    local cStroke = Instance.new("UIStroke")
    cStroke.Color = Color3.fromRGB(6, 18, 46)
    cStroke.Thickness = 2.5
    cStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    cStroke.Parent = closeBtn

    -- Dragging support for Header and ToggleBtn
    local function makeDraggable(dragHandle, targetFrame)
        local dragging = false
        local dragStart, startPos
        trackConn(dragHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = targetFrame.Position
            end
        end))
        trackConn(UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                targetFrame.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end))
        trackConn(UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end))
    end

    makeDraggable(header, panel)
    makeDraggable(toggleBtn, toggleBtn)

    -- Left Column: 3D Live Preview + Active Loadout Summary
    local leftBox = Instance.new("Frame")
    leftBox.Name = "LeftPreviewBox"
    leftBox.Position = UDim2.fromOffset(14, 62)
    leftBox.Size = UDim2.fromOffset(230, 404)
    leftBox.BackgroundColor3 = Color3.fromRGB(9, 26, 66)
    leftBox.BackgroundTransparency = 0.2
    leftBox.BorderSizePixel = 0
    leftBox.ZIndex = 21
    leftBox.Parent = panel

    local lCorner = Instance.new("UICorner")
    lCorner.CornerRadius = UDim.new(0, 14)
    lCorner.Parent = leftBox

    local lStroke = Instance.new("UIStroke")
    lStroke.Color = Color3.fromRGB(6, 18, 46)
    lStroke.Thickness = 2.5
    lStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    lStroke.Parent = leftBox

    local previewHolder = Instance.new("Frame")
    previewHolder.Name = "PreviewHolder"
    previewHolder.Position = UDim2.fromOffset(6, 6)
    previewHolder.Size = UDim2.fromOffset(218, 250)
    previewHolder.BackgroundTransparency = 1
    previewHolder.ZIndex = 22
    previewHolder.Parent = leftBox

    local livePreviewObj = nil
    local function updateGui3DPreview()
        if not panel.Visible or not CharacterPreview then
            return
        end
        if not livePreviewObj then
            local ok, res = pcall(function()
                return CharacterPreview.new(previewHolder)
            end)
            if ok and res then
                livePreviewObj = res
                livePreviewObj.view.AnchorPoint = Vector2.zero
                livePreviewObj.view.Position = UDim2.new()
                livePreviewObj.view.Size = UDim2.fromScale(1, 1)
                livePreviewObj.view.ZIndex = 23
            end
        end
        if livePreviewObj then
            pcall(function()
                livePreviewObj:Set({
                    skin = customLoadout.skin,
                    color = customLoadout.color
                })
            end)
        end
    end

    local eqTitle = Instance.new("TextLabel")
    eqTitle.Name = "EquippedName"
    eqTitle.BackgroundTransparency = 1
    eqTitle.Position = UDim2.fromOffset(10, 260)
    eqTitle.Size = UDim2.fromOffset(210, 30)
    eqTitle.Font = Enum.Font.LuckiestGuy
    eqTitle.Text = "CURRENT SKIN"
    eqTitle.TextSize = 20
    eqTitle.TextScaled = true
    eqTitle.TextColor3 = Color3.new(1, 1, 1)
    eqTitle.ZIndex = 23
    eqTitle.Parent = leftBox

    local eqStroke = Instance.new("UIStroke")
    eqStroke.Color = Color3.fromRGB(6, 18, 46)
    eqStroke.Thickness = 2
    eqStroke.Parent = eqTitle

    local eqDetails = Instance.new("TextLabel")
    eqDetails.Name = "EquippedDetails"
    eqDetails.BackgroundTransparency = 1
    eqDetails.Position = UDim2.fromOffset(12, 294)
    eqDetails.Size = UDim2.fromOffset(206, 98)
    eqDetails.Font = Enum.Font.GothamBold
    eqDetails.TextSize = 13
    eqDetails.TextColor3 = Color3.fromRGB(185, 220, 255)
    eqDetails.TextXAlignment = Enum.TextXAlignment.Left
    eqDetails.TextYAlignment = Enum.TextYAlignment.Top
    eqDetails.TextWrapped = true
    eqDetails.ZIndex = 23
    eqDetails.Parent = leftBox

    -- Right Column: Tabs + Search Bar + Item Grid
    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Position = UDim2.fromOffset(256, 62)
    tabBar.Size = UDim2.fromOffset(510, 38)
    tabBar.BackgroundTransparency = 1
    tabBar.ZIndex = 21
    tabBar.Parent = panel

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 6)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabBar

    -- Search box for fast filtering
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Position = UDim2.fromOffset(256, 106)
    searchBox.Size = UDim2.fromOffset(510, 34)
    searchBox.BackgroundColor3 = Color3.fromRGB(8, 24, 60)
    searchBox.Text = ""
    searchBox.PlaceholderText = "Search skin, color, trail, punch or title..."
    searchBox.PlaceholderColor3 = Color3.fromRGB(125, 160, 210)
    searchBox.TextColor3 = Color3.new(1, 1, 1)
    searchBox.Font = Enum.Font.GothamBold
    searchBox.TextSize = 14
    searchBox.ClearTextOnFocus = false
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ZIndex = 22
    searchBox.Parent = panel

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0, 10)
    sCorner.Parent = searchBox

    local sStroke = Instance.new("UIStroke")
    sStroke.Color = Color3.fromRGB(30, 85, 180)
    sStroke.Thickness = 2
    sStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    sStroke.Parent = searchBox

    local sPad = Instance.new("UIPadding")
    sPad.PaddingLeft = UDim.new(0, 12)
    sPad.PaddingRight = UDim.new(0, 12)
    sPad.Parent = searchBox

    -- Scrolling Grid Container
    local gridScroll = Instance.new("ScrollingFrame")
    gridScroll.Name = "ItemGrid"
    gridScroll.Position = UDim2.fromOffset(256, 148)
    gridScroll.Size = UDim2.fromOffset(510, 318)
    gridScroll.BackgroundColor3 = Color3.fromRGB(9, 26, 66)
    gridScroll.BackgroundTransparency = 0.25
    gridScroll.BorderSizePixel = 0
    gridScroll.ScrollBarThickness = 8
    gridScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 180, 255)
    gridScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    gridScroll.CanvasSize = UDim2.new()
    gridScroll.ZIndex = 21
    gridScroll.Parent = panel

    local gCorner = Instance.new("UICorner")
    gCorner.CornerRadius = UDim.new(0, 14)
    gCorner.Parent = gridScroll

    local gPad = Instance.new("UIPadding")
    gPad.PaddingTop = UDim.new(0, 10)
    gPad.PaddingBottom = UDim.new(0, 10)
    gPad.PaddingLeft = UDim.new(0, 10)
    gPad.PaddingRight = UDim.new(0, 10)
    gPad.Parent = gridScroll

    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.CellSize = UDim2.fromOffset(156, 62)
    gridLayout.CellPadding = UDim2.fromOffset(10, 10)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gridLayout.Parent = gridScroll

    local rarityColors = {
        common    = Color3.fromRGB(55, 115, 200),
        rare      = Color3.fromRGB(40, 165, 95),
        epic      = Color3.fromRGB(145, 65, 225),
        legendary = Color3.fromRGB(230, 155, 25),
        mythic    = Color3.fromRGB(225, 45, 85),
        special   = Color3.fromRGB(0, 185, 215)
    }

    local currentTab = "skins"
    local tabButtons = {}
    local activeCards = {}

    local function updateSummaryText()
        local skinDisplay = (CharacterCatalog and CharacterCatalog.skinName and CharacterCatalog.skinName(customLoadout.skin)) or tostring(customLoadout.skin)
        eqTitle.Text = tostring(skinDisplay)
        eqDetails.Text = string.format(
            "ID: %s\nColor: %s\nTrail: %s\nPunch: %s\nEmote: %s\nTitle: %s",
            tostring(customLoadout.skin),
            tostring(customLoadout.color),
            tostring(customLoadout.trail),
            tostring(customLoadout.punch),
            tostring(customLoadout.emote),
            tostring(customProfile.title or (LocalPlayer:GetAttribute("SGTag") or "Padrao"))
        )
        updateGui3DPreview()
    end

    local function renderTabItems()
        for _, child in ipairs(gridScroll:GetChildren()) do
            if child:IsA("GuiObject") then
                child:Destroy()
            end
        end
        table.clear(activeCards)

        local query = string.lower(searchBox.Text or "")
        local items = {}

        if currentTab == "skins" then
            if CharacterCatalog and type(CharacterCatalog.skins) == "table" then
                for idx, s in ipairs(CharacterCatalog.skins) do
                    local rar = (SkinRarity and SkinRarity.get and SkinRarity.get(s.id)) or { rarityId = "common", origin = "" }
                    table.insert(items, {
                        order = idx,
                        id = s.id,
                        name = s.name or s.id,
                        sub = string.upper(rar.rarityId or "common"),
                        color = rarityColors[rar.rarityId] or rarityColors.common,
                        isEquipped = function()
                            return customLoadout.skin == s.id
                        end,
                        onSelect = function()
                            equipCosmeticInstant({ skin = s.id })
                        end
                    })
                end
            end
        elseif currentTab == "colors" then
            local colorNames = {
                COLOR1  = "MEDIUM SKIN",
                COLOR2  = "LIGHT",
                COLOR3  = "BROWN",
                COLOR4  = "ORANGE",
                COLOR5  = "GREEN",
                COLOR6  = "BLACK",
                COLOR7  = "BLUE",
                COLOR8  = "PINK",
                COLOR9  = "RED",
                COLOR10 = "PURPLE",
                COLOR11 = "WHITE",
                COLOR12 = "DEFAULT"
            }
            if CharacterCatalog and type(CharacterCatalog.colors) == "table" then
                for idx, c in ipairs(CharacterCatalog.colors) do
                    local c3 = CharacterCatalog.color(c.id)
                    table.insert(items, {
                        order = idx,
                        id = c.id,
                        name = colorNames[c.id] or c.name or c.id,
                        sub = c.id,
                        color = c3,
                        swatch = c3,
                        isEquipped = function()
                            return customLoadout.color == c.id
                        end,
                        onSelect = function()
                            equipCosmeticInstant({ color = c.id })
                        end
                    })
                end
            end
        elseif currentTab == "trails" then
            if TrailCatalog and type(TrailCatalog.Items) == "table" then
                for idx, t in ipairs(TrailCatalog.Items) do
                    table.insert(items, {
                        order = idx,
                        id = t.id,
                        name = t.name or t.id,
                        sub = "3D TRAIL",
                        color = rarityColors[t.rarity] or rarityColors.epic,
                        isEquipped = function()
                            return customLoadout.trail == t.id
                        end,
                        onSelect = function()
                            equipCosmeticInstant({ trail = t.id })
                        end
                    })
                end
            end
        elseif currentTab == "punches" then
            if PunchCatalog and type(PunchCatalog.Items) == "table" then
                for idx, p in ipairs(PunchCatalog.Items) do
                    table.insert(items, {
                        order = idx,
                        id = p.id,
                        name = p.name or p.id,
                        sub = "3D PUNCH",
                        color = rarityColors[p.rarity] or rarityColors.mythic,
                        isEquipped = function()
                            return customLoadout.punch == p.id
                        end,
                        onSelect = function()
                            equipCosmeticInstant({ punch = p.id })
                        end
                    })
                end
            end
        elseif currentTab == "emotes" then
            if EmoteCatalog and type(EmoteCatalog.Items) == "table" then
                for idx, e in ipairs(EmoteCatalog.Items) do
                    table.insert(items, {
                        order = idx,
                        id = e.id,
                        name = e.name or e.id,
                        sub = "EMOTE",
                        color = rarityColors[e.rarity] or rarityColors.rare,
                        isEquipped = function()
                            return customLoadout.emote == e.id
                        end,
                        onSelect = function()
                            equipCosmeticInstant({ emote = e.id })
                        end
                    })
                end
            end
        elseif currentTab == "titles" then
            if ProfileCatalog and type(ProfileCatalog.Titles) == "table" then
                for idx, t in ipairs(ProfileCatalog.Titles) do
                    local rObj = ProfileCatalog.Rarity and ProfileCatalog.Rarity[t.rarity]
                    table.insert(items, {
                        order = idx,
                        id = t.id,
                        name = ProfileCatalog.Upper(t.name or t.id),
                        sub = string.upper(t.rarity or "title"),
                        color = (rObj and rObj.top) or rarityColors[t.rarity] or rarityColors.common,
                        isEquipped = function()
                            return customProfile.title == t.id
                        end,
                        onSelect = function()
                            equipCosmeticInstant({ title = t.id })
                        end
                    })
                end
            end
        end

        for _, item in ipairs(items) do
            local match = (query == "")
                or (string.find(string.lower(item.name), query, 1, true) ~= nil)
                or (string.find(string.lower(item.id), query, 1, true) ~= nil)
                or (string.find(string.lower(item.sub), query, 1, true) ~= nil)

            if match then
                local equipped = item.isEquipped()
                local card = Instance.new("TextButton")
                card.Name = "Item_" .. item.id
                card.LayoutOrder = item.order
                card.BackgroundColor3 = item.color or Color3.fromRGB(35, 85, 175)
                card.AutoButtonColor = true
                card.Text = ""
                card.ZIndex = 22
                card.Parent = gridScroll

                local cc = Instance.new("UICorner")
                cc.CornerRadius = UDim.new(0, 10)
                cc.Parent = card

                local cs = Instance.new("UIStroke")
                cs.Color = equipped and Color3.fromRGB(255, 230, 65) or Color3.fromRGB(6, 18, 46)
                cs.Thickness = equipped and 3.5 or 2
                cs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                cs.Parent = card

                local cg = Instance.new("UIGradient")
                cg.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(190, 195, 210))
                cg.Rotation = 90
                cg.Parent = card

                local nameLbl = Instance.new("TextLabel")
                nameLbl.Name = "ItemName"
                nameLbl.BackgroundTransparency = 1
                nameLbl.Position = UDim2.fromOffset(8, 6)
                nameLbl.Size = UDim2.new(1, -16, 0, 28)
                nameLbl.Font = Enum.Font.LuckiestGuy
                nameLbl.Text = item.name
                nameLbl.TextSize = 16
                nameLbl.TextScaled = true
                nameLbl.TextColor3 = Color3.new(1, 1, 1)
                nameLbl.TextXAlignment = Enum.TextXAlignment.Left
                nameLbl.ZIndex = 23
                nameLbl.Parent = card

                local ns = Instance.new("UIStroke")
                ns.Color = Color3.fromRGB(6, 18, 46)
                ns.Thickness = 1.8
                ns.Parent = nameLbl

                local subItemLbl = Instance.new("TextLabel")
                subItemLbl.Name = "ItemSub"
                subItemLbl.BackgroundTransparency = 1
                subItemLbl.Position = UDim2.fromOffset(8, 36)
                subItemLbl.Size = UDim2.new(1, -16, 0, 18)
                subItemLbl.Font = Enum.Font.GothamBold
                subItemLbl.Text = equipped and "EQUIPPED" or item.sub
                subItemLbl.TextSize = 11
                subItemLbl.TextColor3 = equipped and Color3.fromRGB(255, 240, 110) or Color3.fromRGB(225, 235, 255)
                subItemLbl.TextXAlignment = Enum.TextXAlignment.Left
                subItemLbl.ZIndex = 23
                subItemLbl.Parent = card

                table.insert(activeCards, {
                    card = card,
                    stroke = cs,
                    subLbl = subItemLbl,
                    defaultSub = item.sub,
                    isEquipped = item.isEquipped
                })

                card.Activated:Connect(function()
                    item.onSelect()
                    for _, cObj in ipairs(activeCards) do
                        local eq = cObj.isEquipped()
                        cObj.stroke.Color = eq and Color3.fromRGB(255, 230, 65) or Color3.fromRGB(6, 18, 46)
                        cObj.stroke.Thickness = eq and 3.5 or 2
                        cObj.subLbl.Text = eq and "EQUIPPED" or cObj.defaultSub
                        cObj.subLbl.TextColor3 = eq and Color3.fromRGB(255, 240, 110) or Color3.fromRGB(225, 235, 255)
                    end
                    updateSummaryText()
                end)
            end
        end
    end

    local tabDefs = {
        { id = "skins",   label = "SKINS (33)" },
        { id = "colors",  label = "COLORS (12)" },
        { id = "trails",  label = "TRAILS" },
        { id = "punches", label = "PUNCHES" },
        { id = "emotes",  label = "EMOTES" },
        { id = "titles",  label = "TITLES" }
    }

    local function selectTab(tabId)
        currentTab = tabId
        for id, btn in pairs(tabButtons) do
            local active = (id == tabId)
            btn.BackgroundColor3 = active and Color3.fromRGB(255, 165, 25) or Color3.fromRGB(18, 56, 128)
            btn.TextColor3 = active and Color3.fromRGB(12, 22, 52) or Color3.new(1, 1, 1)
        end
        renderTabItems()
    end

    for idx, tDef in ipairs(tabDefs) do
        local tBtn = Instance.new("TextButton")
        tBtn.Name = "Tab_" .. tDef.id
        tBtn.LayoutOrder = idx
        tBtn.Size = UDim2.fromOffset(80, 34)
        tBtn.BackgroundColor3 = Color3.fromRGB(18, 56, 128)
        tBtn.Font = Enum.Font.LuckiestGuy
        tBtn.Text = tDef.label
        tBtn.TextSize = 13
        tBtn.TextScaled = true
        tBtn.TextColor3 = Color3.new(1, 1, 1)
        tBtn.ZIndex = 22
        tBtn.Parent = tabBar

        local tc = Instance.new("UICorner")
        tc.CornerRadius = UDim.new(0, 8)
        tc.Parent = tBtn

        local ts = Instance.new("UIStroke")
        ts.Color = Color3.fromRGB(6, 18, 46)
        ts.Thickness = 2
        ts.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        ts.Parent = tBtn

        local tp = Instance.new("UIPadding")
        tp.PaddingLeft = UDim.new(0, 4)
        tp.PaddingRight = UDim.new(0, 4)
        tp.Parent = tBtn

        tabButtons[tDef.id] = tBtn
        tBtn.Activated:Connect(function()
            selectTab(tDef.id)
        end)
    end

    trackConn(searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        renderTabItems()
    end))

    local function setPanelOpen(openState)
        panel.Visible = openState
        if openState then
            -- Unlock mouse cursor when opening during a match so player can click freely
            pcall(function()
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                UserInputService.MouseIconEnabled = true
            end)
            updateSummaryText()
            renderTabItems()
        end
    end

    -- Keep mouse unlocked while the Quick Skin Changer panel is visible in a match
    trackConn(game:GetService("RunService").RenderStepped:Connect(function()
        if panel.Visible then
            if UserInputService.MouseBehavior ~= Enum.MouseBehavior.Default then
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            end
            if not UserInputService.MouseIconEnabled then
                UserInputService.MouseIconEnabled = true
            end
        end
    end))

    toggleBtn.Activated:Connect(function()
        setPanelOpen(not panel.Visible)
    end)

    closeBtn.Activated:Connect(function()
        setPanelOpen(false)
    end)

    trackConn(UserInputService.InputBegan:Connect(function(input, gp)
        if gp and UserInputService:GetFocusedTextBox() then
            return
        end
        if input.KeyCode == Enum.KeyCode.K or input.KeyCode == Enum.KeyCode.RightShift then
            setPanelOpen(not panel.Visible)
        end
    end))

    selectTab("skins")
    updateSummaryText()
end

createFloatingSkinChangerGui()

if customProfile.title then
    applyOverheadTitleAttribute(customProfile.title)
end

-- ============================================================================
-- 9. REAL-TIME P2P COSMETIC SYNC ENGINE (BETWEEN SCRIPT USERS IN SAME SERVER)
-- ============================================================================
local syncRunning = true
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
    local SYNC_TOPIC = "ydx_pd1_" .. rawJobId:sub(1, 24)
    local SYNC_POST_URL = "https://ntfy.sh/" .. SYNC_TOPIC
    local lastSentSig = ""
    local lastSendTime = 0
    local lastPollUnix = 0

    local function applyPeerCosmetics(plr, pState)
        if not plr or plr == LocalPlayer or type(pState) ~= "table" then
            return
        end
        local uidKey = tostring(plr.UserId)
        if updatingPeerAttrs[uidKey] then
            return
        end
        updatingPeerAttrs[uidKey] = true
        pcall(function()
            if type(pState.skin) == "string" and pState.skin ~= "" and plr:GetAttribute("SGCharacterVisual") ~= pState.skin then
                plr:SetAttribute("SGCharacterVisual", pState.skin)
            end
            if type(pState.color) == "string" and pState.color ~= "" and plr:GetAttribute("SGCharacterColor") ~= pState.color then
                plr:SetAttribute("SGCharacterColor", pState.color)
            end
            if type(pState.trail) == "string" and pState.trail ~= "" and plr:GetAttribute("SGTrail") ~= pState.trail then
                plr:SetAttribute("SGTrail", pState.trail)
            end
            if type(pState.punch) == "string" and pState.punch ~= "" and plr:GetAttribute("SGPunch") ~= pState.punch then
                plr:SetAttribute("SGPunch", pState.punch)
            end
            if type(pState.emote) == "string" and pState.emote ~= "" and plr:GetAttribute("SGEmote") ~= pState.emote then
                plr:SetAttribute("SGEmote", pState.emote)
            end
            local tagText = pState.tag
            local tagHex = pState.tagColor
            if (not tagText or tagText == "") and type(pState.title) == "string" and pState.title ~= "" and ProfileCatalog then
                local tObj = ProfileCatalog.Title(pState.title)
                if tObj then
                    tagText = ProfileCatalog.Upper(tObj.name)
                    local rObj = ProfileCatalog.Rarity and (ProfileCatalog.Rarity[tObj.rarity] or ProfileCatalog.Rarity.common)
                    if rObj and rObj.hex then
                        tagHex = rObj.hex
                    end
                end
            end
            if type(tagText) == "string" and tagText ~= "" then
                if type(tagHex) == "string" and tagHex ~= "" and plr:GetAttribute("SGTagColor") ~= tagHex then
                    plr:SetAttribute("SGTagColor", tagHex)
                end
                if plr:GetAttribute("SGTag") ~= tagText then
                    plr:SetAttribute("SGTag", tagText)
                end
            end
        end)
        updatingPeerAttrs[uidKey] = false
    end

    local function buildMyPayload()
        return {
            uid = LocalPlayer.UserId,
            name = LocalPlayer.Name,
            skin = customLoadout.skin or LocalPlayer:GetAttribute("SGCharacterVisual") or "BonecoNoob",
            color = customLoadout.color or LocalPlayer:GetAttribute("SGCharacterColor") or "COLOR12",
            trail = customLoadout.trail or LocalPlayer:GetAttribute("SGTrail") or "Fumaca",
            punch = customLoadout.punch or LocalPlayer:GetAttribute("SGPunch") or "Padrao",
            emote = customLoadout.emote or LocalPlayer:GetAttribute("SGEmote") or "Floss",
            title = customProfile.title,
            banner = customProfile.banner,
            show = customProfile.show,
            tag = LocalPlayer:GetAttribute("SGTag"),
            tagColor = LocalPlayer:GetAttribute("SGTagColor"),
        }
    end

    broadcastMyState = function(force)
        if not syncRunning or not httpRequest then
            return
        end
        local payloadTbl = buildMyPayload()
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
                    ["Title"] = "ydx-pd-sync",
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
        if not uidNum or uidNum == LocalPlayer.UserId then
            return
        end
        local uidKey = tostring(uidNum)
        local state = {
            uid = uidNum,
            name = type(data.name) == "string" and data.name or "",
            skin = type(data.skin) == "string" and data.skin or "BonecoNoob",
            color = type(data.color) == "string" and data.color or "COLOR12",
            trail = type(data.trail) == "string" and data.trail or "Fumaca",
            punch = type(data.punch) == "string" and data.punch or "Padrao",
            emote = type(data.emote) == "string" and data.emote or "Floss",
            title = type(data.title) == "string" and data.title or nil,
            banner = type(data.banner) == "string" and data.banner or nil,
            show = type(data.show) == "table" and data.show or nil,
            tag = type(data.tag) == "string" and data.tag or nil,
            tagColor = type(data.tagColor) == "string" and data.tagColor or nil,
            ts = os.clock(),
        }
        peerStates[uidKey] = state

        local plr = Players:GetPlayerByUserId(uidNum)
        if plr then
            applyPeerCosmetics(plr, state)
        end
    end

    local function pollPeersOnce()
        if not syncRunning then
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

    local function hookPeerPlayer(plr)
        if not plr or plr == LocalPlayer then
            return
        end
        local uidKey = tostring(plr.UserId)
        for _, attrName in ipairs({ "SGCharacterVisual", "SGCharacterColor", "SGTrail", "SGPunch", "SGEmote", "SGTag", "SGTagColor" }) do
            trackConn(plr:GetAttributeChangedSignal(attrName):Connect(function()
                if updatingPeerAttrs[uidKey] then
                    return
                end
                local pState = peerStates[uidKey]
                if pState then
                    task.defer(applyPeerCosmetics, plr, pState)
                end
            end))
        end
        trackConn(plr.CharacterAdded:Connect(function()
            local pState = peerStates[uidKey]
            if pState then
                task.defer(applyPeerCosmetics, plr, pState)
                task.delay(0.25, applyPeerCosmetics, plr, pState)
            end
        end))
        if peerStates[uidKey] then
            task.defer(applyPeerCosmetics, plr, peerStates[uidKey])
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        hookPeerPlayer(plr)
    end
    trackConn(Players.PlayerAdded:Connect(function(plr)
        hookPeerPlayer(plr)
        task.delay(2, function()
            if syncRunning and broadcastMyState then
                broadcastMyState(true)
            end
        end)
    end))

    task.spawn(function()
        broadcastMyState(true)
        task.wait(0.4)
        pollPeersOnce()
        while syncRunning do
            task.wait(1.6)
            if not syncRunning then
                break
            end
            pollPeersOnce()
            if os.clock() - lastSendTime > 20 then
                broadcastMyState(true)
            end
        end
    end)
end)()

-- Notify via in-game ProfileToast if available!
pcall(function()
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local SkinsGui = PlayerGui and PlayerGui:FindFirstChild("StumbleSkinsGui")
    if SkinsGui then
        local statusLbl = SkinsGui:FindFirstChild("Status", true)
        if statusLbl and statusLbl:IsA("TextLabel") then
            statusLbl.Text = "UNLOCK ALL + P2P SYNC ACTIVE! (" .. tostring(#allSkinIds) .. " Skins, 12 Colors, Punches, Trails, Emotes)"
            statusLbl.TextColor3 = Color3.fromRGB(110, 240, 140)
        end
    end
end)

_G.__PrimeDashUnlockAllCleanup = function()
    syncRunning = false
    for _, c in ipairs(connections) do
        pcall(function()
            c:Disconnect()
        end)
    end
    table.clear(connections)
end

print(string.format(
    "[PRIME DASH UNLOCK ALL] Done! SKINS=%d | TRAILS=%d | PUNCHES=%d | EMOTES=%d | MEDALS=%d | TITLES=%d | BANNERS=%d",
    #allSkinIds, #allTrailIds, #allPunchIds, #allEmoteIds, #allMedalIds, #allTitleIds, #allBannerIds
))
