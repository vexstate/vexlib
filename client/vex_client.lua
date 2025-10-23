
function notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

Vex.registerExport('notify', notify)

Citizen.CreateThread(function()
    Citizen.Wait(2000)
    local welcome = Vex.Locale.get('welcome') or 'Welcome'
    notify(welcome)
end)
