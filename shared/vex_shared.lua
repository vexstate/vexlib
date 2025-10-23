
Vex = Vex or {}
Vex.Config = Vex.Config or {}

Vex.Config.Version = Config.Version or '0.0.0'
Vex.Config.Name = Config.Name or 'VexLib'
Vex.Config.Locale = Config.Locale or 'en'
Vex.Config.Debug = Config.Debug or false

Vex._exports = Vex._exports or {}

function Vex.registerExport(name, fn)
    Vex._exports[name] = fn
end

function Vex.getExport(name)
    return Vex._exports[name]
end

function getVersion()
    return Vex.Config.Version
end

Vex.registerExport('getVersion', getVersion)