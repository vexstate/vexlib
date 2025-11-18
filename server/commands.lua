EVX = EVX or {}

EVX.registerCommand('vexlib:version', function ()
    TriggerClientEvent('vexlib:shownotif', source, ("[vexlib] Version: %s"):format(EVX.meta.version))
end, false)

EVX.registerCommand('vexlib:author', function ()
    TriggerClientEvent('vexlib:shownotif', source, ("[vexlib] Author: %s"):format(EVX.meta.author))
end, false)
