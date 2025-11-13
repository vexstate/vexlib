Config = {}
Utils = {}
World = {}
Blip = {}
Player = {}
Exceptions = {}
Style = {}
Chat = {}

Config.Version = '2.4.5'
Config.Name = 'Vexlib'
Config.Placeholder = 'vexlib'
Config.Locale = 'en'
Config.Debug = false
Config.Inventory = 'OX' -- or ESX
Config.MaxPlayersSync = 32 -- max 48

Config = Config or {}

Config.Version = Config.Version or '2.4.5'
Config.Name = Config.Name or 'VexLib'
Config.Locale = Config.Locale or 'en'
Config.Debug = Config.Debug or false
Config.Placeholder = Config.Placeholder or 'vexlib'

Vex = Vex or {}
Vex.Style = Vex.Style or {}
Vex.Chat = Vex.Chat or {}
Vex.Locale = Vex.Locale or {}
Vex.Config = Vex.Config or {}
Vex.Utils = Vex.Utils or {}
Vex.World = Vex.World or {}
Vex.Blip = Vex.Blip or {}
Vex.Player = Vex.Player or {}
Vex.Exceptions = Vex.Exceptions or {}
Vex._exports = Vex._exports or {}
Vex.Config.Version = Config.Version
Vex.Config.Name = Config.Name
Vex.Config.Locale = Config.Locale
Vex.Config.Debug = Config.Debug
Vex.Config.Placeholder = Config.Placeholder

local Exceptions = Vex.Exceptions

function Vex.registerExport(name, fn)
    Vex._exports[name] = fn
    exports(name, fn)
end

function Vex.getExport(name)
    return Vex._exports[name]
end


function readonly(t)
    if type(t) ~= "table" then return t end
    return setmetatable({}, {
        __index = t,
        __newindex = function(_, _, _)
            error("Attempt to modify read-only table")
        end,
        __pairs = function() return pairs(t) end,
        __ipairs = function() return ipairs(t) end,
        __metatable = false
    })
end

function deepcopy_readonly(t)
    if type(t) ~= "table" then return t end

    local proxy = {}
    for k, v in pairs(t) do
        proxy[k] = deepcopy_readonly(v)
    end

    return setmetatable({}, {
        __index = proxy,
        __newindex = function() error("Attempt to modify read-only table") end,
        __pairs = function() return pairs(proxy) end,
        __ipairs = function() return ipairs(proxy) end,
        __metatable = false
    })
end
