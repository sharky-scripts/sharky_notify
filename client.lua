local Notify = {

    SendNotify = function(message, type, duration, title)
        if type == nil then
            type = "info"
        end
    
        if duration == nil then
            duration = settings["defaultDuration"]
        end
    
        local notifyTypeConfig = settings["types"][type] or settings["types"]["info"]
        local finalTitle = title or notifyTypeConfig.title
    
        SendNUIMessage({
            type = "notify",
            message = message,
            notifyType = type,
            duration = duration,
            title = finalTitle,
            config = {
                icon = notifyTypeConfig.icon,
                styling = notifyTypeConfig.styling,
                defaultDuration = settings["defaultDuration"]
            }
        })
    end,
    
    OpenPositionEditor = function()
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "openPositionEditor"
        })
    end,

    ClosePositionEditor = function()
        SetNuiFocus(false, false)
        SendNUIMessage({
            type = "closePositionEditor"
        })
    end,

    savePosition = function(position)
        TriggerServerEvent("sharky_notify:savePosition", position)
        SendNUIMessage({
            type = "savePosition",
            position = position
        })
    end,
}


RegisterNetEvent("sharky_notify:sendNotify")
AddEventHandler("sharky_notify:sendNotify", function(message, type, duration, title)
    Notify.SendNotify(message, type, duration, title)
end)

function OpenPositionEditor()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "openPositionEditor"
    })
end

exports("OpenPositionEditor", OpenPositionEditor)

RegisterNUICallback("savePosition", function(data, cb)
    if data.position then
        settings["position"] = data.position
        SendNUIMessage({
            type = "setPosition",
            position = data.position
        })
    end
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("closePositionEditor", function(data, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterCommand('notifyposition', function()
    OpenPositionEditor()
end, false)

if settings["enableTestCommand"] then
    RegisterCommand('testNotifyType', function(source, args)
        SendNotify(
            "Lorem, ipsum dolor sit amet consectetur adipisicing elit.",
            args[1], 5000)
    end, false)

    
end


exports("Notify", Notify.SendNotify)