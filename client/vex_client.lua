Vexc = Vexc or {}
Vexc.Config = Vexc.Config or {}
Vexc.Blip = Vexc.Blip or {}
Vexc.Util = Vexc.Util or {}
Vexc.Exception = Vexc.Exception or {}
Vexc.Locale = Vexc.Locale or {}
Vexc._exports = Vexc._exports or {}

Vexc.Config.AllowDebug = true
Vexc.Config.DefaultLocale = 'en'
Vexc.Config.DefaultException = 'Exception'

function Vexc.registerExport(name, fn)
    if type(name) ~= 'string' then
        print("Error: name must be a string")
        return nil
    end
    if type(fn) ~= 'function' then
        print("Error: fn must be a function")
        return nil
    end

    if Vexc._exports[name] then
        print('Export with name ' .. tostring(name) .. ' already exists')
        return nil
    end

    Vexc._exports[name] = fn

    if exports then
        exports(name, fn)
    end
end
