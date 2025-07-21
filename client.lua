function SendNotify(message, type, duration, title)
    if type == nil then
        type = "info"
    end

    if target == nil then
        target = source
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
end

exports("SendNotify", SendNotify)

RegisterNetEvent("sharky_notify:sendNotify")
AddEventHandler("sharky_notify:sendNotify", function(message, type, duration, title)
    SendNotify(message, type, duration, title)
end)

if settings["enableTestCommand"] then
    RegisterCommand('testNotifyType', function(source, args)
        SendNotify(
            "Lorem, ipsum dolor sit amet consectetur adipisicing elit.",
            args[1], 5000)
    end, false)
end
