function Vex.safeCall(fn, ...)
    local ok, res = pcall(fn, ...)

    if not ok then
        print(('VexLib - safeCall error: %s'):format(tostring(res)))
        return false, res
    end

    return true, res
end

function Vex.loadPlayer(identifier)
    if type(identifier) ~= 'string' then
        Vex.Throw(Exceptions.InvalidTypeException, 'identifier must be a string')
    end

    return { id = identifier }
end

function Vex.ChatNotify(source, msg)
    TriggerClientEvent('chat:addMessage', source, {
        args = { 'VexLib', msg }
    })
end

function Vex.registerCommand(name, cb, adminOnly)
    RegisterCommand(name, function(source, args, raw)
        local xPlayer = ESX.GetPlayerFromId(source)

        if adminOnly then
            if not xPlayer then
                print(('^1[VexLib]^0: Player not found for command "%s"'):format(name))
                return
            end

            local group = xPlayer.getGroup()
            if group ~= 'admin' and group ~= 'superadmin' then
                Vex.msg(source, '[error]: You do not have permission to use this command.')
                return
            end
        end

        local ok, err = Vex.safeCall(cb, source, args, raw)
        if not ok then
            Vex.msg(source, '[error]: Command failed, check console for details.')
        end
    end)
end

function Vex.CheckPedGroup(xPlayer, expected_group)
    if not xPlayer then return false end
    local group = xPlayer.getGroup()
    return tostring(group) == tostring(expected_group)
end

function getConfig()
    return Vex.Config
end

Vex.registerExport('getConfig', getConfig)

RegisterCommand('vex_version', function(source, args, raw)
    local ver = Vex.Config.Version
    if source == 0 then
        print('VexLib version: ' .. ver)
    else
        TriggerClientEvent('chat:addMessage', source, { args = { 'VexLib',
        'Version: ' .. ver } })
    end
end)

RegisterCommand('vex_givemoney', function(source, args)
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

end)
