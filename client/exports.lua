if EVX.env ~= "client" then return end

exports("getUtils", function()
    return EVX.utils
end)

exports("getLocale", function()
    return {
        get = EVX.Locale.get
    }
end)

exports("getFormat", function()
    return EVX.format
end)

exports("getString", function()
    return EVX.string
end)
