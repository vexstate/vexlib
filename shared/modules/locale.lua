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

function Locale.setDefaultLanguage()
    if Locale and Locale.cur then
        if Locale.cur == Locale.default then
            print(EVX.rawget("Language %s is already default language"):format(Locale.cur))
        else
            Locale.cur = Locale.default
            return true, 'ok'
        end
    end
end

function Locale.get(key, value)
    local _literal = EVX.literal("boolean", nil)
    local err = EVX.exceptions.set('error', 'Cant find table with %s lang')

    if Locale then
        if Locale.contains(Locale[key], Locale[key][value]) then
            return Locale[key][value]
        else
            print(tostring((EVX.rawget(err:fflush():format(value)))))
            return _literal(nil)
        end
    end
end
