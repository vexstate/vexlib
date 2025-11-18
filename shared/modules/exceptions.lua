EVX = EVX or {}
EVX.exceptions = EVX.exceptions or {}

EVX.exceptions.types = {
    error = {
        placeholder = "exceptions::error",
        name = "exceptions_error",
        __type = 'error'
    },
    warning = {
        placeholder = "exceptions::warning",
        name = "exceptions_warning",
        __type = 'warning'
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
--- @param name string
--- @param content string|any
--- @param doExit boolean
--- @return NORETURN
function EVX.exceptions.throw(placeholder, name, content, doExit)
    if type(doExit) ~= 'boolean' then
        return error("EVX.exceptions.throw: doExit must be boolean")
    end
    if type(name) ~= 'string' then
        return error("EVX.exceptions.throw: name must be string")
    end

    local typeInfo = EVX.exceptions.types[name] or { placeholder = placeholder, name = name }
    local message = string.format("[%s] %s", typeInfo.placeholder, tostring(content))

    if doExit then
        error(message, 2)
    else
        print(message)
    end
end

--- @generic T
--- @param placeholder? T
--- @param name string
--- @param content string|any
--- @return NORETURN
function EVX.exceptions.content(placeholder, name, content)
    if type(name) ~= 'string' then
        return error("EVX.exceptions.throw: kind must be string")
    end

    local typeInfo = EVX.exceptions.types[name] or { placeholder = placeholder, name = name }
    local message = string.format("[%s] %s", typeInfo.placeholder, tostring(content))

    return message
end

--- @param tbl table
--- @param properties table
--- @param custom_name? string
function EVX.exceptions.conobj(tbl, properties, custom_name)
    assert(type(tbl) == "table", "EVX.exceptions.conobj: tbl must be a table")

    local obj = properties or {}

    local mt = {
        __index = tbl,
        __tostring = function(self)
            return custom_name or self.name or "exceptions_error"
        end
    }

    function obj:raise(doExit)
        doExit = doExit or true
        local msg = tostring(self)
        if self.message then
            msg = msg .. ": " .. tostring(self.message)
        end
        if doExit then
            error(msg, 2)
        else
            print(msg)
        end
    end

    setmetatable(obj, mt)
    return obj
end

--- @param obj table
--- @param mt table
--- @param properties table
--- @param custom_name? string
--- @return table
function EVX.exceptions.tendobj(obj, mt, properties, custom_name)
    if type(obj) ~= "table" then
        error("EVX.exceptions.useobj: obj must be a table", 2)
    end

    properties = properties or {}
    mt = mt or {}

    for k, v in pairs(properties) do
        obj[k] = v
    end

    setmetatable(obj, {
        __index = mt.__index or obj,
        __tostring = mt.__tostring or function(self)
            return custom_name or self.name or "exceptions_error"
        end
    })

    if not obj.raise then
        function obj:raise(doExit)
            doExit = doExit == nil and true or doExit
            local msg = tostring(self)
            if self.message then
                msg = msg .. ": " .. tostring(self.message)
            end
            if doExit then
                error(msg, 2)
            else
                print(msg)
            end
        end
    end

    return obj
end

function EVX.exceptions.raise(obj, doExit)
    local message = tostring(obj)
    if obj.message then
        message = message .. ": " .. tostring(obj.message)
    end
    if doExit then
        error(message, 2)
    else
        print(message)
    end
end

function EVX.exceptions.pcall(func)
    local ok, err = pcall(func)
    if not ok then
        print("Caught exception:", err)
    end
    return ok, err
end


--- @param placeholder string
--- @param content string
--- @param __type? string
function EVX.exceptions.set(placeholder, content, __type)
    local obj = {
        placeholder = placeholder or "exceptions::error",
        name = content or "exceptions_error",
        __type = __type or "error"
    }

    return setmetatable(obj, {
        __index = {
            get = function(self)
                return ("[%s] %s"):format(self.placeholder, self.content)
            end
        },
        __newindex = function(_, key, _)
            EVX.exceptions.error(("Cannot modify exception object: %s"):format(key), 2)
        end,
        __tostring = function(self)
            return ("[%s] %s"):format(self.placeholder, self.content)
        end
    })
end
