EVX = EVX or {}
Locale = Locale or {}
EVX.Locale = Locale

Locale.default = "en"
Locale.list = {"en", "es"}
Locale.cur = Locale.default

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
            print(EVX.rawget(("Language %s is already default language"):format(Locale.cur)))
        else
            Locale.cur = Locale.default
            return true, 'ok'
        end
    end
end

function Locale.get(lang, key)
    local _literal = EVX.literal("boolean", nil)
    local err = EVX.exceptions.set('error', 'Cant find key %s in language')

    if lang == nil then
        lang = Locale.default
    end

    if type(Locale[lang]) ~= "table" then
        print(("Language '%s' does not exist"):format(lang))
        return _literal(nil)
    end

    local val = Locale[lang][key]
    if val == nil then
        print(EVX.rawget(err.fflush(err):format(key)))
        return _literal(nil)
    end

    return val
end

function Locale.create(tableRef, lang, key , val)
    local _l = EVX.literal('boolean', nil, true, false)

    if type(tableRef) ~= 'table'
        or type(lang) ~= 'string'
        or type(key) ~= 'string'
        or type(val) ~= 'string' then
        return _l(nil)
    end

    tableRef[lang] = tableRef[lang] or {}
    local langTable = tableRef[lang]

    if langTable[key] ~= nil then
        print(("Key '%s' already exists in language '%s'"):format(key, lang))
        return _l(false)
    end

    for _, v in pairs(langTable) do
        if v == val then
            print(("Value '%s' already exists in language '%s'"):format(val, lang))
            return _l(false)
        end
    end

    langTable[key] = val

    return _l(true)
end

EVX.registerExport('locale_get', function ()
    return EVX.Locale
end)
