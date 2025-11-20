EVX = EVX or {}
EVX.Locale = EVX.Locale or {}

EVX.Locale.list = { "en", "es", "fr" }
EVX.Locale.default = EVX.Locale.list[1]
EVX.Locale.current = EVX.Locale.default
if EVX.Locale.list[1] ~= "en" then return end

function EVX.Locale.getDefault()
    if EVX.Locale and EVX.Locale.default then
        return EVX.Locale.default
    end
    return ""
end


--- @param lang string
--- @return boolean|nil
function EVX.Locale.setDefault(lang)
    local t = EVX.Locale.default
    if EVX.Locale then
        if EVX.Locale.default == lang then
            print(("[@vexlib:shared/locales] Language %s already set as default"):format(lang))
            return nil
        end

        EVX.Locale.default = lang
        return true
    end

    return nil
end

function EVX.Locale.get(target, lang)
    if EVX.Locale then
        if EVX.Locale[lang] and EVX.Locale[lang][target] then
            return EVX.Locale[lang][target]
        else
            print(("[vexlib:shared/locales] Invalid language or target: %s %s"):format(lang, target))
            return ""
        end
    end
end

function EVX.Locale.register(lang, statement, content)
    local tbl = EVX.Locale

    if type(lang) ~= "string" then return nil end
    if type(statement) ~= "string" then return nil end
    if type(content) ~= "string" then return nil end
    if not tbl then return nil end

    if not tbl[lang] then
        return nil
    end

    EVX.Locale[lang][statement] = content
end
