if EVX.env ~= "client" then return end
if EVX.isEnv("client") == -1 then return end

exports("utils_get", function()
    return EVX.utils
end)

exports("locale_get", function()
    return {
        get = EVX.Locale.get
    }
end)

exports("format_get", function()
    return EVX.format
end)

exports("string_get", function()
    return EVX.string
end)
