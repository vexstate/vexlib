if EVX.env ~= "server" then return end
if EVX.isEnv("server") == -1 then return end

EVX._exports = EVX._exports or {}

function EVX.registerExport(name, fn)
    if type(name) ~= "string" or type(fn) ~= "function" then return end
    if EVX._exports[name] then return end

    if not exports then
        error("[vexlib:server/exports] No export module found.", 2)
        return nil
    end

    EVX._exports[name] = fn
    exports(name, fn)
end

EVX.registerExport("server", function()
    return EVX
end)
