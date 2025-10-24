local Exceptions = Vex.Exceptions

local base = {
    __index = function(t,k) return rawget(t,k) end
}

function Exceptions.new(typeName, localeKey, details)
    local obj = setmetatable({}, base)
    obj.Type = typeName or 'Vex.Exception'
    obj.Locale = localeKey or 'Exception'
    obj.Details = details
    return obj
end

Exceptions.OK = {
    Type = 'Exceptions_OK',
    Locale = 'OK',
    Humane = function(lang)
        return Vex.Locale.get('OK',
        lang or Vex.Config.Locale)
    end
}

Exceptions.Exception = {
    Type = 'Exceptions_Exception',
    Locale = "Exception",
    Humane = function (lang)
        return Vex.Locale.get('Exception',
        lang or Vex.Config.Locale)
    end
}
Exceptions.InvalidType = {
    Type = 'Exceptions_InvalidTypeException',
    Locale = 'InvalidType',
    Humane = function (lang)
        return Vex.Locale.get('InvalidType',
        lang or Vex.Config.Locale)
    end
}

Exceptions.InvalidValue = {
    Type = 'Exceptions_InvalidValue',
    Locale = 'InvalidValue',
    Humane = function (lang)
        return Vex.Locale.get('InvalidValue',
        lang or Vex.Config.Locale)
    end
}

Exceptions.InvalidArgument = {
    Type = 'Exceptions_InvalidArgument',
    Locale = 'InvalidArgument',
    Humane = function (lang)
        return Vex.Locale.get('InvalidArgument',
        lang or Vex.Config.Locale)
    end
}

function Vex.Throw(exceptionDef, details)
    local ex = Exceptions.new(
    exceptionDef.Type or 'Exceptions_Exception',
    exceptionDef.Locale or 'Exception', details or '')

    local dt = details

    local msg
    if Vex.Locale and Vex.Locale.get then
        msg = Vex.Locale.get(ex.Locale) or
        ('['..ex.Type..'] ' .. tostring(dt or ''))
    else
        msg = '['..ex.Type..'] ' .. tostring(dt or '')
    end

    error(msg, 2)
end

Vex.registerExport('Throw', Vex.Throw)
Vex.registerExport('Exceptions', Exceptions)
