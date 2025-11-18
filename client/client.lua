if EVX.isEnv("client") == -1 then return end

RegisterNetEvent('vexlib:shownotif')
AddEventHandler('vexlib:shownotif', function(message)
    ESX.ShowNotification(message)
end)
