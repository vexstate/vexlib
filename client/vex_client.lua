---@diagnostic disable: undefined-global

Vexc = Vexc or {}
cLocales = cLocales or {}
Vexc.Config = Vexc.Config or {}
Vexc.Blip = Vexc.Blip or {}
Vexc.Util = Vexc.Util or {}
Vexc.Exception = Vexc.Exception or {}
Vexc.Locale = Vexc.Locale or {}
Vexc.TextFormat = Vexc.TextFormat or {}
Vexc._exports = Vexc._exports or {}
Exception = Vexc.Exception or {}

Vexc.Config.MaxPlayers = 48
Vexc.Config.AllowDebug = true
Vexc.Config.DefaultLocale = 'en'
Vexc.Config.DefaultException = 'Exception'
Vexc.Config.Locale = Vexc.Config.DefaultLocale

local metabase = {
    __index = function(t,k) return rawget(t,k) end
}

Exception = {
    ['ERROR'] = 'error',
    ['OK'] = 'ok',
    ['WARNING'] = 'warning',
    ['ABORT'] = 'abort'
}

function Vexc.RegisterExport(name, fn)
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

    exports(name, fn)
end

function Vexc.Locale.SetDefault()
    Vexc.Config.Locale = Vexc.Config.DefaultLocale
end

function Vexc.Locale.SetDefaultByHand(lang)
    Vexc.Config.Locale = lang
end

function Vexc.Locale.Register(lang, tbl)
    cLocales[lang] = tbl
end

function Vexc.Locale.Get(key, lang)
    local language = lang or Vex.Config.Locale or 'en'

    if cLocales[language] and cLocales[language][key] then
        return cLocales[language][key]
    end

    if cLocales['en'] and cLocales['en'][key] then
        return cLocales['en'][key]
    end

    return nil
end

function Vexc.Config.Modify(obj, value)
    if Vexc and Vexc.Config and Vexc.Config[obj] then
        Vexc.Config[obj] = value
    else
        print('No already names provided, just new!')
        return nil
    end
end

function Vexc.TextFormat:Label(table, label)
    if type(table) ~= 'table' then
        print('Invalid data type: table')
    end

    if type(label) ~= 'string' then
        print('Invalid data type: string')
    end

    if Vexc and Labels and Labels[table] then
        for _, v in pairs(Labels[table]) do
            if not Labels[table][label] then
                return nil
            end
        end
    end

    return Labels[table][label]
end

function Exception:Make(typeName, localeKey, details)
    local obj = setmetatable({}, metabase)
    obj.Type = typeName or 'Vexc.Exception'
    obj.Locale = localeKey or Vexc.Config.DefaultException
    obj.Details = details

    return obj
end

function Exception:Get(label)
    if not Exception then
        error('No valid table found', 1)
    end

    if not Exception[label] or not Exception[label][value] then
        error('No valid table member nor value found', 2)
    end

    return Exception[label][0]
end

function Exception:ThrowProgramError(msg, lvl)
    if type(msg) ~= 'string' then
        return nil
    end

    if type(lvl) ~= 'number' then
        return nil
    end

    local lvl = lvl or 0
    local msg = msg or Exception:Get('OK') or 'ok'

    return error(msg, lvl)
end

function Exception:ThrowConsoleError(msg, label)
    local v = { msg = msg, label = label }

    for _, x in pairs(v) do
        if type(x) ~= 'string' then
            return -1, nil
        end
    end

    local l = Exception:Get(tostring(label)) or 'ok'
    local msg = msg or 'Error occurred.'

    print("["..l.."]".." "..msg)

    return 0, true
end

Vexc.RegisterExport('client_t', function ()
    return Vexc
end)
