Config = Config or {}

Config.Version = Config.Version or '2.4.5'
Config.Name = Config.Name or 'VexLib'
Config.Locale = Config.Locale or 'en'
Config.Debug = Config.Debug or false
Config.Placeholder = Config.Placeholder or 'vexlib'

Vex = Vex or {}
Vex.Style = Vex.Style or {}
Vex.Chat = Vex.Chat or {}
Vex.Locale = Vex.Locale or {}
Vex.Config = Vex.Config or {}
Vex.Utils = Vex.Utils or {}
Vex.World = Vex.World or {}
Vex.Blip = Vex.Blip or {}
Vex.Player = Vex.Player or {}
Vex.Exceptions = Vex.Exceptions or {}
Vex._exports = Vex._exports or {}
Vex.Config.Version = Config.Version
Vex.Config.Name = Config.Name
Vex.Config.Locale = Config.Locale
Vex.Config.Debug = Config.Debug
Vex.Config.Placeholder = Config.Placeholder

Vexc = Vexc or {}
cLocales = cLocales or {}
Vexc.Config = Vexc.Config or {}
Vexc.Blip = Vexc.Blip or {}
Vexc.Util = Vexc.Util or {}
Vexc.Exception = Vexc.Exception or {}
Vexc.Locale = Vexc.Locale or {}
Vexc.TextFormat = Vexc.TextFormat or {}
Vexc._exports = Vexc._exports or {}
Exception = Vexc.Exception or {}

Vexc.Config.MaxPlayers = 48
Vexc.Config.AllowDebug = true
Vexc.Config.DefaultLocale = 'en'
Vexc.Config.DefaultException = 'Exception'
Vexc.Config.Locale = Vexc.Config.DefaultLocale

local function readonly(t)
    if type(t) ~= "table" then return t end
    return setmetatable({}, {
        __index = t,
        __newindex = function(_, _, _)
            error("Attempt to modify read-only table")
        end,
        __pairs = function() return pairs(t) end,
        __ipairs = function() return ipairs(t) end,
        __metatable = false
    })
end

local function deepcopy_readonly(t)
    if type(t) ~= "table" then return t end

    local proxy = {}
    for k, v in pairs(t) do
        proxy[k] = deepcopy_readonly(v)
    end

    return setmetatable({}, {
        __index = proxy,
        __newindex = function() error("Attempt to modify read-only table") end,
        __pairs = function() return pairs(proxy) end,
        __ipairs = function() return ipairs(proxy) end,
        __metatable = false
    })
end

function Vex.safeCall(fn, ...)
    local ok, res = pcall(fn, ...)

    if not ok then
        print(('vexlib - safeCall error: %s'):format(tostring(res)))
        return false, res
    end

    return true, res
end

function Vex.registerCommand(name, cb, adminOnly)
    RegisterCommand(name, function(source, args, raw)
        local xPlayer = ESX.GetPlayerFromId(source)

        if adminOnly then
            if not xPlayer then
                print(('^1[vexlib]^0: Player not found for command "%s"'):format(name))
                return
            end

            local group = xPlayer.getGroup()
            if group ~= 'admin' and group ~= 'superadmin' then
                Vex.ChatNotify(source, '[error]: You do not have permission to use this command.')
                return
            end
        end

        local ok, err = Vex.safeCall(cb, source, args, raw)
        if not ok then
            Vex.ChatNotify(source, '[error]: Command failed, check console for details.')
        end
    end)
end

function Vex.IsPlayerAce(playerId, ace)
    if not playerId or not ace then
        return false
    end

    if not IsDuplicityVersion() then
        return false
    end

    local hasAce = IsPlayerAceAllowed(playerId, ace)
    return hasAce == true
end

function Vex.IsPlayerGroup(playerId, group)
    if not playerId or not group then
        return false
    end

    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then
        return false
    end

    local playerGroup = xPlayer.getGroup()
    return tostring(playerGroup) == tostring(group)
end

function Vex.CheckPedGroup(xPlayer, expected_group)
    if not xPlayer then return false end
    local group = xPlayer.getGroup()
    return tostring(group) == tostring(expected_group)
end

function Vex.GatherPlayerIdentifier()
    local src = source
    local identifier = GetPlayerIdentifiers(src)

    if not identifier then
        return Exceptions.InvalidValue.Locale
    end

    return tostring(identifier)
end

function Vex.loadPlayer(identifier)
    if type(identifier) ~= 'string' then
        Vex.Throw(Vex.Exceptions.InvalidType, 'identifier must be a string')
    end

    return { id = identifier }
end

function Vex.ChatNotify(source, msg)
    TriggerClientEvent('chat:addMessage', source, {
        args = { '[vexlib]', msg }
    })
end

function Vex.Player:addItem(source, item, amount)
    local player
    if Vex.Config.Inventory == 'ESX' then
        player = ESX.GetPlayerFromId(source)
        if player then
            player.addInventoryItem(item, amount)
        end
    elseif Vex.Config.Inventory == 'OX' then
        player = Player(source)
        if player then
            player.addItem(item, amount)
        end
    end
end

function Vex.Player:removeItem(source, item, amount)
    local player
    if Vex.Config.Inventory == 'ESX' then
        player = ESX.GetPlayerFromId(source)
        if player then
            player.removeInventoryItem(item, amount)
        end
    elseif Vex.Config.Inventory == 'OX' then
        player = Player(source)
        if player then
            player.removeItem(item, amount)
        end
    end
end

function Vex.Player:addMoney(source, amount)
    local player
    if Vex.Config.Inventory == 'ESX' then
        player = ESX.GetPlayerFromId(source)
        if player then
            player.addMoney(amount)
        end
    elseif Vex.Config.Inventory == 'OX' then
        player = Player(source)
        if player then
            player.addMoney(amount)
        end
    end
end

function Vex.Player:removeMoney(source, amount)
    local player
    if Vex.Config.Inventory == 'ESX' then
        player = ESX.GetPlayerFromId(source)
        if player then
            player.removeMoney(amount)
        end
    elseif Vex.Config.Inventory == 'OX' then
        player = Player(source)
        if player then
            player.removeMoney(amount)
        end
    end
end

Vex.registerCommand('vex_version', function (source, args, raw)
    local ver = Vex.Config.Version

    if source == 0 then
        print('Vexlib version: ' .. ver)
    else
        Vex.ChatNotify(source, '[vexlib] : Version : ' .. ver)
    end
end, true)

Vex.registerCommand('vex_givemoney', function (source, args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        TriggerClientEvent('chat:addMessage', source, {
            args = { 'VexLib', '[error]: Cannot find player with this source.' }
        })
        return
    end

    local playerGroup = xPlayer.getGroup()
    if playerGroup ~= 'admin' and playerGroup ~= 'superadmin' then
        TriggerClientEvent('chat:addMessage', source, {
            args = { 'VexLib', '[error]: You do not have permission to use this command.' }
        })
        return
    end

    local targetId = tonumber(args[1])
    local amount = tonumber(args[2])

    if not targetId or not amount then
        TriggerClientEvent('chat:addMessage', source, {
            args = { 'VexLib', 'Usage: /vex_givemoney [playerId] [amount]' }
        })
        return
    end

    local xTarget = ESX.GetPlayerFromId(targetId)
    if not xTarget then
        TriggerClientEvent('chat:addMessage', source, {
            args = { 'VexLib', '[error]: Target player not found.' }
        })
        return
    end

    xTarget.addMoney(amount)

    TriggerClientEvent('chat:addMessage', targetId, {
        args = { 'VexLib', ('You have received $%s from an admin.'):format(amount) }
    })

    TriggerClientEvent('chat:addMessage', source, {
        args = { 'VexLib', ('You gave $%s to player %s.'):format(amount, targetId) }
    })
end, true)

Vex.registerCommand('vex_oxgivemoney', function(source, args)
    local xPlayer = Vex.getOXPlayer(source)
    if not xPlayer then return end

    local targetId = tonumber(args[1])
    local amount = tonumber(args[2])
    if not targetId or not amount or amount <= 0 then return end

    local xTarget = Vex.getOXPlayer(targetId)
    if not xTarget then return end

    xTarget.addMoney(amount)

    Vex.ChatNotify(targetId, ('You received $%s from an admin.'):format(amount))
    Vex.ChatNotify(source, ('You gave $%s to player %s.'):format(amount, targetId))
end, true)

Vex.registerExport('Config', function() return readonly(Vex.Config) end)
Vex.registerExport('Locale', function() return readonly(Vex.Locale) end)
Vex.registerExport('Player', function() return readonly(Vex.Player) end)
Vex.registerExport('Utils', function() return readonly(Vex.Utils) end)
Vex.registerExport('World', function() return readonly(Vex.World) end)
Vex.registerExport('Blip', function() return readonly(Vex.Blip) end)
Vex.registerExport('Exceptions', function() return readonly(Vex.Exceptions) end)
Vex.registerExport('Style', function() return readonly(Vex.Style) end)
Vex.registerExport('Chat', function() return readonly(Vex.Chat) end)
Vex.registerExport('exception_new', function() return readonly(Vex.Exceptions.new) end)
Vex.registerExport('getESXPlayer', Vex.getESXPlayer)
Vex.registerExport('getOXPlayer', Vex.getOXPlayer)
Vex.registerExport('locale_get', function(k, l) return Vex.Locale.get(k, l) end)
Vex.registerExport('locale_register', function(lang, tbl) return Vex.Locale.register(lang, tbl) end)
Vex.registerExport('locale_setDefault', function(lang) return Vex.Locale.setDefault(lang) end)
Vex.registerExport('getVersion', function() return Vex.Config.Version end)
Vex.registerExport('Exception_Throw', Vex.Throw)
Vex.registerExport('IsPlayerAce', Vex.IsPlayerAce)
Vex.registerExport('IsPlayerGroup', Vex.IsPlayerGroup)
Vex.registerExport('safeCall', Vex.safeCall)
Vex.registerExport('CheckPedGroup', Vex.CheckPedGroup)

Vex.registerExport('global_t', function()
    return Vex
end)

Vex.registerExport('proxy', function()
    return deepcopy_readonly(Vex)
end)
