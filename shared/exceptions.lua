
Exceptions = {}

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

Exceptions.Exception = {
    Type = 'Exceptions_Exception',
    Locale = 'Exception'
}

Exceptions.InvalidTypeException = {
    Type = 'Exceptions_InvalidTypeException',
    Locale = 'InvalidTypeException'
}

Exceptions.InvalidValueError = {
    Type = 'Exceptions_InvalidValueError',
    Locale = 'InvalidValueError'
}

Exceptions.InvalidArgumentError = {
    Type = 'Exceptions_InvalidArgumentError',
    Locale = 'InvalidArgumentError'
}

function Vex.Throw(exceptionDef, details)
    local ex = Exceptions.new(
    exceptionDef.Type or 'Exceptions_Exception',
    exceptionDef.Locale or 'Exception', details)

    local msg
    if Vex.Locale and Vex.Locale.get then
        msg = Vex.Locale.get(ex.Locale) or 
        ('['..ex.Type..'] ' .. tostring(details or ''))
    else
        msg = '['..ex.Type..'] ' .. tostring(details or '')
    end

    error(msg, 2)
end

function getExceptionDefinitions()
    return Exceptions
end

Vex.registerExport('getExceptionDefinitions', getExceptionDefinitions)