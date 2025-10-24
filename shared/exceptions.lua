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
    Humane = 'If everything is right, return right'
}

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
    Locale = 'InvalidArgumentError',
    Humane = 'Got an invalid position argument'
}

Exceptions.TargetNotFoundError = {

}

function Vex.Throw(exceptionDef, details)
    local ex = Exceptions.new(
    exceptionDef.Type or 'Exceptions_Exception',
    exceptionDef.Locale or 'Exception', details)

    local dt = details or ex.Humane

    local msg
    if Vex.Locale and Vex.Locale.get then
        msg = Vex.Locale.get(ex.Locale) or
        ('['..ex.Type..'] ' .. tostring(dt))
    else
        msg = '['..ex.Type..'] ' .. tostring(dt)
    end

    error(msg, 2)
end

Vex.registerExport('Throw', Vex.Throw)
Vex.registerExport('Exceptions', Exceptions)
