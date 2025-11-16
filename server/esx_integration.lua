ESX = exports['es_extended']:getSharedObject()
local promise = 0

Citizen.CreateThread(function ()
    while ESX == nil do
        ESX = exports['es_extended']:getSharedObject()
        Citizen.Wait(promise)
    end
end)
