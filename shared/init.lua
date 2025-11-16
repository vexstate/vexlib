EVX = EVX or {}
EVX.env = EVX.env or (IsDuplicityVersion() and 'server' or 'client')

EVX.meta = { version = "3.0.0", author = "Matija" }

if EVX.env == 'server' then
    EVX._modules = EVX._modules or {}
    EVX._exports = EVX._exports or {}
    EVX._functions = EVX._functions or {}

    EVX._exports = setmetatable({}, {
        __newindex = function()
            error("Cannot modify exports directly!")
        end})

    function EVX.registerExport(name, fn)
        if type(name) ~= 'string' or type(fn) ~= 'function' then return end
        if EVX._exports[name] then return end
        EVX._exports[name] = fn
        exports(name, fn)
    end
end

function EVX.isEnv(env)
    if EVX.env ~= env then
        return -1
    else return 0 end
end

function EVX.getExport(name)
    if EVX._exports then
       return EVX._exports[name]
    end
end

function EVX.getModule(name)
    if EVX._modules then
       return EVX._modules[name]
    end
end
