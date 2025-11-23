EVX = EVX or {}
EVX.Config = EVX.Config or {}

local xml = require("LuaXML")
local find = nil
local configFile = "config.xml"

local function getText(node)
    if type(node) == "table" and #node > 0 then
        return node[1]
    elseif type(node) == "string" then
        return node
    end
    return nil
end


local function loadConfig()
    local cfg = {}

    local xmlRoot = xml.load(configFile)
    if not xmlRoot then
        print("[EVX] Failed to load config.xml")
        return cfg
    end

    cfg.Meta = {
        Version = getText(xmlRoot:find("Meta/Version")),
        Author = getText(xmlRoot:find("Meta/Author")),
        GitHub = getText(xmlRoot:find("Meta/GitHub"))
    }

    cfg.Environment = {
        Default = getText(xmlRoot:find("Environment/Default")),
        Allowed = {}
    }
    for _, envNode in ipairs(xmlRoot:find("Environment/Allowed")) do
        table.insert(cfg.Environment.Allowed, getText(envNode))
    end

    cfg.Locale = {
        Default = getText(xmlRoot:find("Locale/Default")),
        Available = {}
    }
    for _, lang in ipairs(xmlRoot:find("Locale/Available")) do
        table.insert(cfg.Locale.Available, getText(lang))
    end

    cfg.Admins = {}
    for _, group in ipairs(xmlRoot:find("Admins")) do
        table.insert(cfg.Admins, getText(group))
    end

    local notifNode = xmlRoot:find("Notifications")
    cfg.Notifications = {
        MaxLength = tonumber(getText(notifNode:find("MaxLength"))) or 2000,
        RateLimit = tonumber(getText(notifNode:find("RateLimit"))) or 2000
    }

    cfg.Labels = {}
    local labelsRoot = xmlRoot:find("Labels/Root")
    cfg.Labels.Root = {}
    for _, pathNode in ipairs(labelsRoot) do
        table.insert(cfg.Labels.Root, getText(pathNode))
    end

    local debugNode = xmlRoot:find("Debug")
    cfg.Debug = {
        Enable = getText(debugNode:find("Enable")) == "true",
        LogFile = getText(debugNode:find("LogFile"))
    }

    return cfg
end

EVX.Config = loadConfig()



print("[EVX] Framework version: " .. EVX.Config.Meta.Version)

