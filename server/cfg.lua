if EVX.env ~= "server" then return end
if EVX.isEnv("server") == -1 then return end

--- @class Config
--- @field _env string
--- @field _meta table
--- @field [any] any
--- @diagnostic disable-next-line: undefined-global
local cfg = cfg or {}

cfg._env = "server"
cfg._meta = {}

function cfg.setDefault(key, value)
    if cfg[key] == nil then
        cfg[key] = value
    end
    cfg._meta[key] = cfg._meta[key] or {}
    cfg._meta[key].default = value
end

function cfg.setType(key, typeName)
    cfg._meta[key] = cfg._meta[key] or {}
    cfg._meta[key].type = typeName
end

function cfg.validate()
    for key, meta in pairs(cfg._meta) do
        if meta.type and cfg[key] ~= nil then
            if type(cfg[key]) ~= meta.type then
                print(string.format("Config key '%s' expected type '%s', got '%s'", key, meta.type, type(cfg[key])))
                return false
            end
        end
    end
    return true
end

function cfg.load(path)
    local file = io.open(path, "r")
    if not file then return false, "Cannot open file: " .. path end

    local content = file:read("*a")
    file:close()

    local chunk, err = load(content, path, "t", {})
    if not chunk then return false, err end

    local success, result = pcall(chunk)
    if not success then return false, result end

    if type(result) == "table" then
        for k, v in pairs(result) do
            cfg[k] = v
        end
    end

    return true
end

function cfg.save(path)
    local file = io.open(path, "w")
    if not file then return false end

    for k, v in pairs(cfg) do
        if k:sub(1,1) ~= "_" then
            local valStr
            if type(v) == "string" then
                valStr = string.format('"%s"', v)
            elseif type(v) == "boolean" or type(v) == "number" then
                valStr = tostring(v)
            else
                valStr = '"[unsupported]"'
            end
            file:write(string.format("%s = %s\n", k, valStr))
        end
    end

    file:close()
    return true
end

return cfg
