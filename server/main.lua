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

--- @param val any
--- @return NORETURN
function EVX.setpromise(val)
    return val
end

--- @param promise number
--- @return NORETURN
function EVX.wait(promise)

    if promise < 0 then
        Wait(0)
        return
    end

    Wait(promise)
    return
end

--- @return NORETURN
function EVX.cwait(promise)
    Citizen.Wait(promise)
    return
end

--- @return NORETURN
function EVX.cawait(promise)
    Citizen.Await(promise)
    return
end

function EVX.setreadonly(tbl)
    if type(tbl) ~= "table" then
        EVX.utils.inform(EVX.rawget("[vexlib:server] Invalid data type"))
        return
    end

    local proxy = {}

    local mt = {
        __index = tbl,
        __newindex = function(t, k, v)
            print(EVX.rawget("[vexlib:server] Can't modify table (readonly)"))
        end,
        __pairs = function()
            return pairs(tbl)
        end,
        __ipairs = function()
            return ipairs(tbl)
        end,
        __len = function()
            return #tbl
        end
    }

    setmetatable(proxy, mt)
    return proxy
end

function EVX.getPlayerFromId(psrc)
    if not psrc or psrc < -1 then
        print(EVX.rawget(("[vexlib:server] Player \'%s\' is unknown"):format(psrc or -2)))
        return
    end

    return ESX.GetPlayerFromId(psrc)
end

function EVX.getPlayerGroup(player)
    if not player then
        return nil
    end

    return GetPlayerGroup(player)
end

RegisterNetEvent('vexlib:notifyAllPlayers')
AddEventHandler('vexlib:notifyAllPlayers', function(message)
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
