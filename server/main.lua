EVX = EVX or {}
if EVX.isEnv("server") == -1 then return end

--- @param command string
--- @param fn fun(source:number, args:table, raw:string)
--- @param admin boolean
function EVX.registerCommand(command, fn, admin)

    if type(command) ~= "string" or command == "" then
        return error("EVX.registerCommand: 'command' must be a non-empty string", 2)
    end

    if type(fn) ~= "function" then
        return error("EVX.registerCommand: 'fn' must be a function", 2)
    end

    if type(admin) ~= "boolean" then
        return error("EVX.registerCommand: 'admin' must be a boolean", 2)
    end

    RegisterCommand(command, function(source, args, raw)
        args = args or {}

        fn(source, args, raw)
    end, admin)

    return true
end

function EVX.setpromise(val)
    return val
end

RegisterNetEvent('vexlib:notifyAll')
AddEventHandler('vexlib:notifyAll', function(message)
    local src = source
    local player = ESX.GetPlayerFromId(src)

    local gub = EVX.exceptions.set(EVX.rawget("error"), EVX.rawget("Player not loaded."))

    if not player then
        EVX.utils.inform(tostring(gub:get() or gub.__type))
        return
    end

    local _crg = GetPlayerGroup(player)

    if _crg == 'admin' or _crg == 'superadmin' then
        EVX.utils.inform("Admin " .. player.getName() .. " sent a notification: " .. tostring(message))
        TriggerClientEvent('chat:addMessage', -1, {
            args = {"^3Admin Notification", message}
        })
    else
        EVX.utils.inform(
        EVX.format.colors[1].."You do not have permission to send this notification."
        )
    end
end)

RegisterNetEvent('vexlib:getauthor')
AddEventHandler('vexlib:getauthor', function ()
    local src = source

    TriggerClientEvent('chat:addMessage', src, {
        color = {0, 0, 200},
        multiline = true,
        args = {"vexlib", ("Author: %s"):format(tostring(EVX.meta.author))}
    })
end)

RegisterNetEvent('vexlib:getversion')
AddEventHandler('vexlib:getversion', function ()
    local src = source
    TriggerClientEvent('chat:addMessage', src, {
        color = {255, 100, 0},
        multiline = true,
        args = {"vexlib", ("Current version: %s"):format(EVX.meta.version)}
    })
end)

RegisterNetEvent('vexlib:githublink')
AddEventHandler('vexlib:githublink', function ()
    local src = source
    local _link = EVX.rawget(tostring(EVX.meta._github))
    local message = ("Thanks for using vexlib, find us on %s"):format(tostring(_link))

    TriggerClientEvent('vexlib:shownotif', src, message)
end)

EVX.registerExport('getServerObject', function ()
    return EVX
end)
