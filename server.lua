local dataFile = GetResourcePath(GetCurrentResourceName()) .. "/data.json"

local positionCache = {}

local function LoadPositions()
    local file = io.open(dataFile, "r")
    if not file then return end
    local content = file:read("*a")
    file:close()
    if content and content ~= "" then
        local data = json.decode(content)
        if data then
            positionCache = data
        end
    end
end

LoadPositions()

local function SavePosition(license, position)
    positionCache[license] = position
    local file = io.open(dataFile, "w")
    if file then
        file:write(json.encode(positionCache))
        file:close()
    end
end

RegisterServerEvent("sharky_notify:savePosition", function(position)
    local src = source
    local license = GetPlayerIdentifierByType(src, "license")
    if not license then return end
    SavePosition(license, position)
end)

RegisterServerEvent("sharky_notify:requestPosition", function()
    local src = source
    local license = GetPlayerIdentifierByType(src, "license")
    if not license then return end
    local position = positionCache[license] or settings["position"]
    TriggerClientEvent("sharky_notify:loadPosition", src, position)
end)


AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        Wait(1000)
    end
end)
