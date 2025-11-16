EVX.exceptions = EVX.exceptions or {}

EVX.exceptions.types = {
    error = {
        placeholder = "exceptions::error",
        name = "exceptions_error"
    },
    warning = {
        placeholder = "exceptions::warning",
        name = "exceptions_warning"
    }
}

--- @param message string
--- @param code number
function EVX.exceptions.error(message, code)
    if type(message) == 'string' and type(code) == 'number' then
        return error(message, code)
    end
end

--- @generic T
--- @param placeholder? T
--- @param kind string
--- @param content string|any
--- @param doExit boolean
--- @return NORETURN
function EVX.exceptions.throw(placeholder, kind, content, doExit)
    if type(doExit) ~= 'boolean' then
        return error("EVX.exceptions.throw: doExit must be boolean")
    end
    if type(kind) ~= 'string' then
        return error("EVX.exceptions.throw: kind must be string")
    end

    local typeInfo = EVX.exceptions.types[kind] or { placeholder = placeholder, name = kind }
    local message = string.format("[%s] %s", typeInfo.placeholder, tostring(content))

    if doExit then
        error(message, 2)
    else
        print(message)
    end
end

--- @generic T
--- @param placeholder? T
--- @param kind string
--- @param content string|any
--- @return NORETURN
function EVX.exceptions.create(placeholder, kind, content)
    if type(kind) ~= 'string' then
        return error("EVX.exceptions.throw: kind must be string")
    end

    local typeInfo = EVX.exceptions.types[kind] or { placeholder = placeholder, name = kind }
    local message = string.format("[%s] %s", typeInfo.placeholder, tostring(content))

    return message
end
