if EVX.env ~= "server" then return end

EVX._exports = EVX._exports or {}

function EVX.registerExport(name, fn)
    if type(name) ~= "string" or type(fn) ~= "function" then return end
    if EVX._exports[name] then return end

    EVX._exports[name] = fn
    exports(name, fn)
end

EVX.registerExport("getServerCore", function()
    return EVX
end)
