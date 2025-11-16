EVX = EVX or {}

EVX.registerCommand('vexlib:version', function ()
    EVX.utils.inform(("[vexlib] Current version: %s"):format(EVX.meta.version))
end, false)


EVX.registerCommand('vexlib:author', function ()
    EVX.utils.inform(("[vexlib] Author: %s"):format(tostring(EVX.meta.author)))
end, false)

