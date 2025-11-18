EVX = EVX or {}
EVX.env = EVX.env or (IsDuplicityVersion() and 'server' or 'client')

EVX.meta = { version = "3.0.0", author = "Matija", _github = "https://github.com/vexstate"}

if EVX.env == 'server' then
    EVX._modules = EVX._modules or {}
    EVX._exports = EVX._exports or {}
    EVX._functions = EVX._functions or {}

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

EVX.registerExport('getSharedObject', function ()
    return EVX
end)
