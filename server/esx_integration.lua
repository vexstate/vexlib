ESX = exports['es_extended']:getSharedObject()

local hasESX = ESX ~= nil
local hasOX = exports.ox_inventory ~= nil

AddEventHandler('playerSpawned', function(spawn)
    local src = source
    local player = ESX.GetPlayerFromId(src)
    local _crg = GetPlayerGroup(player)

    if _crg == 'admin' or _crg == 'superadmin' then
        TriggerClientEvent('chat:addMessage', src, {
            color = {200, 100, 100},
            args = {"vexlib", ("ESX loaded successfully: %s"):format(hasESX and 'detected' or 'unknown')}
        })

        TriggerClientEvent('chat:addMessage', src, {
            color = {200, 100, 100},
            args = {"vexlib", ("OX Inventory loaded successfully: %s"):format(hasOX and 'detected' or 'unknown')}
        })
    end
end)
