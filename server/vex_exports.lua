local function readonly(t)
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

local function deepcopy_readonly(t)
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

Vex.registerExport('Config', function() return readonly(Vex.Config) end)
Vex.registerExport('Locale', function() return readonly(Vex.Locale) end)
Vex.registerExport('Player', function() return readonly(Vex.Player) end)
Vex.registerExport('Utils', function() return readonly(Vex.Utils) end)
Vex.registerExport('World', function() return readonly(Vex.World) end)
Vex.registerExport('Blip', function() return readonly(Vex.Blip) end)
Vex.registerExport('Exceptions', function() return readonly(Vex.Exceptions) end)
Vex.registerExport('Style', function() return readonly(Vex.Style) end)
Vex.registerExport('Chat', function() return readonly(Vex.Chat) end)
Vex.registerExport('exception_new', function() return readonly(Vex.Exceptions.new) end)
Vex.registerExport('getESXPlayer', Vex.getESXPlayer)
Vex.registerExport('getOXPlayer', Vex.getOXPlayer)
Vex.registerExport('locale_get', function(k, l) return Vex.Locale.get(k, l) end)
Vex.registerExport('locale_register', function(lang, tbl) return Vex.Locale.register(lang, tbl) end)
Vex.registerExport('locale_setDefault', function(lang) return Vex.Locale.setDefault(lang) end)
Vex.registerExport('getVersion', function() return Vex.Config.Version end)
Vex.registerExport('Exception_Throw', Vex.Throw)
Vex.registerExport('IsPlayerAce', Vex.IsPlayerAce)
Vex.registerExport('IsPlayerGroup', Vex.IsPlayerGroup)
Vex.registerExport('safeCall', Vex.safeCall)
Vex.registerExport('CheckPedGroup', Vex.CheckPedGroup)

Vex.registerExport('global_t', function()
    return readonly(Vex)
end)

Vex.registerExport('proxy', function()
    return deepcopy_readonly(Vex)
end)
