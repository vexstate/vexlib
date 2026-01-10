if EVX.env ~= "client" then return end
if EVX.isEnv("client") == -1 then return end

exports("utils_get", function()
    return EVX.utils
end) -- utils
exports("locale_get", function()
    return {
        get = EVX.Locale.get
    }
end)



exports("string_get", function()
    return EVX.string
end)
