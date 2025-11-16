EVX = EVX or {}
if EVX.isEnv("server") == -1 then return end

ESX = exports['es_extended']:getSharedObject()

Citizen.CreateThread(function ()
    while ESX == nil do
        ESX = exports['es_extended']:getSharedObject()
        Citizen.Wait(EVX.setpromise(0))
    end
end)

if ESX then
    TriggerClientEvent('chat:addMessage', source, {
        color = {200, 100, 100},
        args = {"vexlib", ("ESX loaded successfully: %s"):format(ESX and 'detected' or 'unknown')}
    })
end

if exports.ox_inventory then
    TriggerClientEvent('chat:addMessage', source, {
        color = {200, 100, 100},
        args = {"vexlib",
        ("OX loaded successfully: %s version"):format(
        exports.ox_inventory and 'detected' or 'unknown'
    )}
    })
end
