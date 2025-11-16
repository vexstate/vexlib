EVX = EVX or {}
Locale = Locale or {}
EVX.Locale = Locale
Locale.default = "en"
Locale.list = {"en", "es"}
Locale.cur = Locale.default
Locale.default = Locale.default or {}
Locale.list = Locale.list or {}

--- @generic T
--- @param list T[]
--- @param lang T
--- @return boolean
function Locale.contains(list, lang)
    for i = 1, #list do
        if list[i] == lang then
            return true
        end
    end
    return false
end

function Locale.setdef()
    Locale.cur = Locale.default
end
