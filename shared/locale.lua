Locales = Locales or {}

Vex.Locale = Vex.Locale or {}

function Vex.Locale.setDefault(lang)
    Vex.Config.Locale = lang
end

function Vex.Locale.register(lang, tbl)
    Locales[lang] = tbl
end

function Vex.Locale.get(key, lang)
    local language = lang or Vex.Config.Locale or 'en'

    if Locales[language] and Locales[language][key] then
        return Locales[language][key]
    end

    if Locales['en'] and Locales['en'][key] then
        return Locales['en'][key]
    end

    return nil
end
