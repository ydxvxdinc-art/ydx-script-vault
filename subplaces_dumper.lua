-- AssetService Sub-Places Dumper (100% ASCII)
-- Lists every sub-place (PlaceId + Name) inside the current game Universe using AssetService:GetGamePlacesAsync()
-- Copies the formatted list to clipboard and prints it to console.

local function setClipboard(text)
    if setclipboard then
        setclipboard(text)
    elseif toclipboard then
        toclipboard(text)
    else
        print("Seu executor nao suporta copiar para a area de transferencia.")
    end
end

local placeList = {}
local currentGameId = game.PlaceId

print("Buscando sub-lugares do jogo ID: " .. tostring(currentGameId) .. "...")

local AssetService = game:GetService("AssetService")
local success, pages = pcall(function()
    return AssetService:GetGamePlacesAsync()
end)

if not success or not pages then
    warn("Erro ao buscar sub-lugares. O jogo pode nao ter sub-lugares ou o executor bloqueou a API.")
    return
end

while true do
    for _, place in pairs(pages:GetCurrentPage()) do
        table.insert(placeList, string.format("%s | ID: %d", tostring(place.Name), tonumber(place.PlaceId) or 0))
    end

    if pages.IsFinished then break end

    local advanceOk = pcall(function()
        pages:AdvanceToNextPageAsync()
    end)
    if not advanceOk then break end
    task.wait(0.1)
end

if #placeList > 0 then
    local finalText = "--- Subplaces de " .. tostring(currentGameId) .. " ---\n\n" .. table.concat(placeList, "\n")
    setClipboard(finalText)
    print("Copiado com sucesso! (" .. tostring(#placeList) .. " lugares)")
    print(finalText)
else
    warn("Nenhum sub-lugar encontrado ou o jogo atual nao possui sub-lugares.")
end
