
ESX = ESX or nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(100)
    end
    print(('VexLib: ESX integration loaded (version: %s)'):format(ESX and
    ESX.GetConfig and 'unknown' or 'detected'))
end)


function Vex.getESXPlayer(sourceOrIdentifier)
    if type(sourceOrIdentifier) == 'number' then
        return ESX.GetPlayerFromId(sourceOrIdentifier)
    elseif type(sourceOrIdentifier) == 'string' then
        for _, pid in pairs(ESX.GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(pid)
            if xPlayer and xPlayer.identifier == sourceOrIdentifier then
                return xPlayer
            end
        end
    end

    return nil
end

Vex.registerExport('getESXPlayer', Vex.getESXPlayer)