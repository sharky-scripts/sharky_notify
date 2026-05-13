local Notify = {

    sendNotify = function(message, type, duration, title)
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

    loadPosition = function(pos)
        SendNUIMessage({
            type = "setPosition",
            position = pos
        })
    end,

    savePosition = function(position)
        settings["position"] = position
        TriggerServerEvent("sharky_notify:savePosition", position)
        SendNUIMessage({
            type = "setPosition",
            position = position
        })
    end,

    openPositionEditor = function()
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "openPositionEditor"
        })
    end,

    closePositionEditor = function()
        SetNuiFocus(false, false)
    end,
}


RegisterNetEvent("sharky_notify:sendNotify")
AddEventHandler("sharky_notify:sendNotify", function(message, type, duration, title)
    Notify.sendNotify(message, type, duration, title)
end)

RegisterNetEvent("sharky_notify:loadPosition")
AddEventHandler("sharky_notify:loadPosition", function(pos)
    Notify.loadPosition(pos)
end)

RegisterNUICallback("requestPosition", function(data, cb)
    TriggerServerEvent("sharky_notify:requestPosition")
    cb("ok")
end)

RegisterNUICallback("savePosition", function(data, cb)
    if data.position then
        Notify.savePosition(data.position)
    end
    Notify.closePositionEditor()
    cb("ok")
end)

RegisterNUICallback("closePositionEditor", function(data, cb)
    Notify.closePositionEditor()
    cb("ok")
end)

RegisterCommand('notifyposition', function()
    Notify.openPositionEditor()
end, false)

if settings["enableTestCommand"] then
    RegisterCommand('testNotifyType', function(source, args)
        Notify.sendNotify(
            "Lorem, ipsum dolor sit amet consectetur adipisicing elit.",
            args[1], 5000)
    end, false)
end

exports("OpenPositionEditor", Notify.openPositionEditor)
exports("Notify", Notify.sendNotify)
