--- @diagnostic disable: undefined-global

EVX = EVX or {}
EVX.utils = EVX.utils or {}
EVX.blip = EVX.blip or {}
EVX.string = EVX.string or {}
EVX.table = EVX.table or {}
EVX.format = EVX.format or {}
EVX.meta = EVX.meta or {}


--- @param val any
--- @param ...? any
function EVX.rawget(val, ...)
    return val, ...
end

function EVX.literal(type_name, ...)
    local allowed = {...}
    return function(value)
        local value_type = type(value)
        if value_type ~= type_name then
            error("Expected type '" .. type_name .. "', got '" .. value_type .. "'")
        end
        for _, v in ipairs(allowed) do
            if v == value then
                return true
            end
        end
        error("Value '" .. tostring(value) .. "' not in allowed literals")
    end
end

function EVX.table.isEmpty(tbl)
    return next(tbl) == nil
end

function EVX.table.length(tbl)
    local count = 0
    for _ in pairs(tbl) do count = count + 1 end
    return count
end

function EVX.table.print(tbl, indent)
    indent = indent or 0
    for k, v in pairs(tbl) do
        local formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            EVX.table.print(v, indent + 1)
        else
            print(formatting .. tostring(v))
        end
    end
end

function EVX.table.contains(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then return true end
    end
    return false
end

function EVX.table.merge(t1, t2)
    local t = {}
    for k, v in pairs(t1) do t[k] = v end
    for k, v in pairs(t2) do t[k] = v end
    return t
end

--- @param str string
--- @return string|nil
function EVX.string.reverse(str)
    local t = {}

    for i = #str, 1, -1 do
        t[#t+1] = string.sub(str, i, i)
    end

    return table.concat(t)
end

--- @param str string
function EVX.string.trim(str)
    return str:match("^%s*(.-)%s*$")
end

--- @param str string
function EVX.string.toupper(str)
    return string.upper(str or "")
end

--- @param str string
function EVX.string.tolower(str)
    return string.lower(str or "")
end

--- @param str string
function EVX.string.capitalize(str)
    str = str or ""
    return str:gsub("^%l", string.upper)
end

--- @param str string
--- @param sep string
function EVX.string.split(str, sep)
    sep = sep or "%s"
    local t = {}
    for s in string.gmatch(str, "([^"..sep.."]+)") do
        t[#t+1] = s
    end
    return t
end

--- @param str string
--- @param startStr string
function EVX.string.startswith(str, startStr)
    str = str or ""
    startStr = startStr or ""
    return str:sub(1, #startStr) == startStr
end

--- @param str string
--- @param endStr string
function EVX.string.endswith(str, endStr)
    str = str or ""
    endStr = endStr or ""
    return str:sub(-#endStr) == endStr
end

--- @param str string
--- @param old string
--- @param new string
function EVX.string.replace(str, old, new)
    str = str or ""
    old = old or ""
    new = new or ""
    return str:gsub(old, new)
end

--- @param str string
--- @param sub string
function EVX.string.count(str, sub)
    str = str or ""
    sub = sub or ""
    local _, n = str:gsub(sub, "")
    return n
end

--- @param str string
function EVX.string.empty(str)
    return str == nil or str == "" or str == " "
end

function EVX.utils.inform(argc, ...)
    print(argc, ...)
end

--- @param text string
--- @param color string
--- @return string
function EVX.format.color(text, color)
    local code = EVX.format.colors[color] or "^7"
    return code .. tostring(text)
end

--- @param text string
--- @return string
function EVX.format.symbolize(text)
    local t = tostring(text):gsub("~(.-)~", function(sym)
        return EVX.format.symbols[sym] or sym
    end)
    return t
end

--- @return table
function EVX.format.getColors()
    return EVX.format.colors
end

--- @return table
function EVX.format.getSymbols()
    return EVX.format.symbols
end


--- @param x number
--- @return table|nil
function EVX.utils.vector1(x)
    if type(x) ~= 'number' then return nil end
    return { x = x }
end

--- @param x number
--- @param y number
--- @return table|nil
function EVX.utils.vector2(x, y)
    if type(x) ~= 'number' or type(y) ~= 'number' then return nil end
    return { x = x, y = y }
end

--- @param x number
--- @param y number
--- @param z number
--- @return table|nil
function EVX.utils.vector3(x, y, z)
    if type(x) ~= 'number' or type(y) ~= 'number' or type(z) ~= 'number' then
        return nil
    end
    return { x = x, y = y, z = z }
end

--- @param v1 table
--- @param v2 table
--- @return table|nil
function EVX.utils.add(v1, v2)
    if not v1 or not v2 then return nil end
    local t = {}
    for k,_ in pairs(v1) do
        if type(v1[k]) ~= "number" or type(v2[k]) ~= "number" then return nil end
        t[k] = v1[k] + v2[k]
    end
    return t
end

--- @param v1 table
--- @param v2 table
--- @return table|nil
function EVX.utils.sub(v1, v2)
    if not v1 or not v2 then return nil end
    local t = {}
    for k,_ in pairs(v1) do
        if type(v1[k]) ~= "number" or type(v2[k]) ~= "number" then return nil end
        t[k] = v1[k] - v2[k]
    end
    return t
end

--- @param v table
--- @param scalar number
--- @return table|nil
function EVX.utils.mul(v, scalar)
    if not v or type(scalar) ~= "number" then return nil end
    local t = {}
    for k,val in pairs(v) do
        if type(val) ~= "number" then return nil end
        t[k] = val * scalar
    end
    return t
end

--- @param v table
--- @param scalar number
--- @return table|nil
function EVX.utils.div(v, scalar)
    if not v or type(scalar) ~= "number" or scalar == 0 then return nil end
    local t = {}
    for k,val in pairs(v) do
        if type(val) ~= "number" then return nil end
        t[k] = val / scalar
    end
    return t
end

--- @param v table
--- @return number|nil
function EVX.utils.length(v)
    if not v then return nil end
    local sum = 0
    for _, val in pairs(v) do
        if type(val) ~= "number" then return nil end
        sum = sum + val * val
    end
    return math.sqrt(sum)
end

--- @param v table
--- @return table|nil
function EVX.utils.normalize(v)
    local len = EVX.utils.length(v)
    if not len or len == 0 then return nil end
    return EVX.utils.div(v, len)
end

--- @param v1 table
--- @param v2 table
--- @return number|nil
function EVX.utils.distance(v1, v2)
    local diff = EVX.utils.sub(v1, v2)
    if not diff then return nil end
    return EVX.utils.length(diff)
end

--- @param v table
function EVX.utils.printvec(v)
    if not v then print("nil vector") return end
    local s = "{ "
    for k,val in pairs(v) do
        s = s .. k .. "=" .. tostring(val) .. " "
    end
    s = s .. "}"
    print(s)
end

--- @param sprite number
--- @param posx number
--- @param posy number
--- @param posz number
--- @param size number|nil
--- @param color number|nil
--- @param textType string|nil
--- @param placeholder string|nil
--- @param displayBehaviour number|nil
function EVX.blip:make(
    sprite,
    posx, posy, posz,
    size, color,
    textType, placeholder,
    displayBehaviour
)
    local blip = AddBlipForCoord(posx, posy, posz)

    sprite = sprite or 1
    posx = posx or 0.0
    posy = posy or 0.0
    posz = posz or 0.0
    size = size or 1.0
    color = color or 4
    textType = textType or "STRING"
    placeholder = placeholder or ""
    displayBehaviour = displayBehaviour or 4

    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, displayBehaviour)
    SetBlipScale(blip, size)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName(textType)
    AddTextComponentSubstringPlayerName(placeholder)
    EndTextCommandSetBlipName(blip)

    local _e = EVX.exceptions.set(EVX.rawget("error"),
        EVX.rawget("Blip not found."))

    if blip then
        return blip, 'ok'
    else return nil, _e:get() end
end

function EVX.blip:pmake(
    spriteId,
    posx, posy, posz,
    size, color,
    textType, placeholder,
    displayBehaviour
)
    local blip = AddBlipForCoord(posx, posy, posz)

    SetBlipSprite(blip, spriteId)
    SetBlipDisplay(blip, displayBehaviour)
    SetBlipScale(blip, size)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName(textType)
    AddTextComponentSubstringPlayerName(placeholder)
    EndTextCommandSetBlipName(blip)

    local _e = EVX.exceptions.set(
        EVX.rawget("error"),
        EVX.rawget(tostring(("%s returned nil."):format("blip"))))

    if blip then
        return blip, 'ok'
    else return nil, _e:get() end
end

function EVX.blip:construct(
    __type,
    __sprite,
    posX, posY, posZ,
    placeholder,
    color, alpha,
    displayBh,
    scale,
    range,
    width, height,
    entity,
    radius,
    pickup
)
    if
        not __type
        or type(posX) ~= "number"
        or type(posY) ~= "number"
        or type(posZ) ~= "number"
    then
        return nil
    end

    local blip

    displayBh = displayBh or 4
    scale = scale or 0.8
    color = color or 2
    alpha = alpha or 128
    posZ = posZ or 0.0

    if __type == "coords" and posX and posY and posZ then
        blip = AddBlipForCoord(posX, posY, posZ)
        SetBlipSprite(blip, __sprite or 1)
        SetBlipDisplay(blip, displayBh)
        SetBlipScale(blip, scale)
        SetBlipColour(blip, color)
        SetBlipAsShortRange(blip, range)

    elseif __type == "area" and height and width and alpha
        and posX and posY and posZ
    then
        blip = AddBlipForArea(posX, posY, posZ, width, height)
        SetBlipColour(blip, color)
        SetBlipAlpha(blip, alpha or 128)

    elseif __type == "entity" and entity and posX and posY and posZ then
        blip = AddBlipForEntity(entity)
        SetBlipSprite(blip, __sprite or 1)
        SetBlipDisplay(blip, displayBh)
        SetBlipScale(blip, scale)
        SetBlipColour(blip, color)
        SetBlipAsShortRange(blip, range)

    elseif __type == "pickup" and pickup and posX and posY and posZ then
        blip = AddBlipForPickup(pickup)
        SetBlipSprite(blip, __sprite or 1)
        SetBlipDisplay(blip, displayBh)
        SetBlipScale(blip, scale)
        SetBlipColour(blip, color)
        SetBlipAsShortRange(blip, range)

    elseif __type == "radius" and radius and posX and posY and posZ then
        blip = AddBlipForRadius(posX, posY, posZ, radius)
        SetBlipSprite(blip, __sprite or 1)
        SetBlipDisplay(blip, displayBh)
        SetBlipScale(blip, scale)
        SetBlipColour(blip, color)
        SetBlipAsShortRange(blip, range)
    end

    if blip and placeholder and posX and posY and posZ then
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(placeholder)
        EndTextCommandSetBlipName(blip)
    end

    local _e = EVX.exceptions.set(
        EVX.rawget("error"),
        EVX.rawget(tostring(("%s returned nil."):format("blip"))))

    if blip then
        return blip, 'ok'
    else return nil, _e:get() end
end

function EVX.blip:pconstruct(
    __type,
    __sprite,
    posX, posY, posZ,
    placeholder,
    color, alpha,
    displayBh,
    scale,
    range,
    width, height,
    entity,
    radius,
    pickup
)
    if
        not __type
        or type(posX) ~= "number"
        or type(posY) ~= "number"
        or type(posZ) ~= "number"
    then
        return nil, Exceptions.InvalidTypeException.Locale
    end

    local blip

    displayBh = displayBh or 4
    scale = scale or 0.8
    color = color or 2
    alpha = alpha or 128
    posZ = posZ or 0.0

    if __type == "coords" and posX and posY and posZ then
        blip = AddBlipForCoord(posX, posY, posZ)
        SetBlipSprite(blip, __sprite or 1)
        SetBlipDisplay(blip, displayBh)
        SetBlipScale(blip, scale)
        SetBlipColour(blip, color)
        SetBlipAsShortRange(blip, range)

    elseif __type == "area" and height and width and alpha
        and posX and posY and posZ
    then
        blip = AddBlipForArea(posX, posY, posZ, width, height)
        SetBlipColour(blip, color)
        SetBlipAlpha(blip, alpha or 128)

    elseif __type == "entity" and entity and posX and posY and posZ then
        blip = AddBlipForEntity(entity)
        SetBlipSprite(blip, __sprite or 1)
        SetBlipDisplay(blip, displayBh)
        SetBlipScale(blip, scale)
        SetBlipColour(blip, color)
        SetBlipAsShortRange(blip, range)

    elseif __type == "pickup" and pickup and posX and posY and posZ then
        blip = AddBlipForPickup(pickup)
        SetBlipSprite(blip, __sprite or 1)
        SetBlipDisplay(blip, displayBh)
        SetBlipScale(blip, scale)
        SetBlipColour(blip, color)
        SetBlipAsShortRange(blip, range)

    elseif __type == "radius" and radius and posX and posY and posZ then
        blip = AddBlipForRadius(posX, posY, posZ, radius)
        SetBlipSprite(blip, __sprite or 1)
        SetBlipDisplay(blip, displayBh)
        SetBlipScale(blip, scale)
        SetBlipColour(blip, color)
        SetBlipAsShortRange(blip, range)
    end

    if blip and placeholder and posX and posY and posZ then
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(placeholder)
        EndTextCommandSetBlipName(blip)
    end


    local _e = EVX.exceptions.set(
        EVX.rawget("error"),
        EVX.rawget(tostring(("%s returned nil."):format("blip"))))

    if blip then
        return blip, 'ok'
    else return nil, _e:get() end
end

function EVX.blip:tconstruct(tbl)
    if type(tbl) ~= "table" then
        return nil
    end

    local blip
    local __type = tbl.type or "coords"
    local posX, posY, posZ = tbl.x or 0.0, tbl.y or 0.0, tbl.z or 0.0
    local sprite = tbl.sprite or 1
    local color = tbl.color or 2
    local alpha = tbl.alpha or 128
    local display = tbl.display or 4
    local scale = tbl.scale or 0.8
    local label = tbl.label or __type
    local entity = tbl.entity
    local radius = tbl.radius
    local width = tbl.width
    local height = tbl.height
    local pickup = tbl.pickup

    if __type == "coords" then
        blip = AddBlipForCoord(posX, posY, posZ)
        SetBlipSprite(blip, sprite)
        SetBlipDisplay(blip, display)
        SetBlipScale(blip, scale)
        SetBlipColour(blip, color)
        SetBlipAsShortRange(blip, true)

    elseif __type == "area"
    and height and width and color and alpha and posX and posY and posZ
    then
        blip = AddBlipForArea(posX, posY, posZ, width, height)
        SetBlipColour(blip, color)
        SetBlipAlpha(blip, alpha)

    elseif __type == "entity" and entity and sprite and display and scale and color
    then
        blip = AddBlipForEntity(entity)
        SetBlipSprite(blip, sprite)
        SetBlipDisplay(blip, display)
        SetBlipScale(blip, scale)
        SetBlipColour(blip, color)
        SetBlipAsShortRange(blip, true)

    elseif __type == "pickup" and pickup and sprite and display and scale and color
    then
        blip = AddBlipForPickup(pickup)
        SetBlipSprite(blip, sprite)
        SetBlipDisplay(blip, display)
        SetBlipScale(blip, scale)
        SetBlipColour(blip, color)
        SetBlipAsShortRange(blip, true)

    elseif __type == "radius" and radius
    then
        blip = AddBlipForRadius(posX, posY, posZ, radius)
        SetBlipSprite(blip, sprite)
        SetBlipDisplay(blip, display)
        SetBlipScale(blip, scale)
        SetBlipColour(blip, color)
        SetBlipAsShortRange(blip, true)
    else
        return nil
    end

    if blip and label then
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(label)
        EndTextCommandSetBlipName(blip)
    end
    
    local _e = EVX.exceptions.set(
        EVX.rawget("error"),
        EVX.rawget(tostring(("%s returned nil."):format("blip"))))

    if blip then
        return blip, 'ok'
    else return nil, _e:get() end
end

function EVX.blip:ptconstruct(tbl)
    if type(tbl) ~= "table" then
        return nil, Exceptions.InvalidTypeException.Locale
    end

    local blip
    local __type = tbl.type or "coords"
    local posX, posY, posZ = tbl.x or 0.0, tbl.y or 0.0, tbl.z or 0.0
    local sprite = tbl.sprite or 1
    local color = tbl.color or 2
    local alpha = tbl.alpha or 128
    local display = tbl.display or 4
    local scale = tbl.scale or 0.8
    local label = tbl.label or __type
    local entity = tbl.entity
    local radius = tbl.radius
    local width = tbl.width
    local height = tbl.height
    local pickup = tbl.pickup

    if __type == "coords" then
        blip = AddBlipForCoord(posX, posY, posZ)
        SetBlipSprite(blip, sprite)
        SetBlipDisplay(blip, display)
        SetBlipScale(blip, scale)
        SetBlipColour(blip, color)
        SetBlipAsShortRange(blip, true)

    elseif __type == "area"
    and height and width and color and alpha and posX and posY and posZ
    then
        blip = AddBlipForArea(posX, posY, posZ, width, height)
        SetBlipColour(blip, color)
        SetBlipAlpha(blip, alpha)

    elseif __type == "entity" and entity and sprite and display and scale and color
    then
        blip = AddBlipForEntity(entity)
        SetBlipSprite(blip, sprite)
        SetBlipDisplay(blip, display)
        SetBlipScale(blip, scale)
        SetBlipColour(blip, color)
        SetBlipAsShortRange(blip, true)

    elseif __type == "pickup" and pickup and sprite and display and scale and color
    then
        blip = AddBlipForPickup(pickup)
        SetBlipSprite(blip, sprite)
        SetBlipDisplay(blip, display)
        SetBlipScale(blip, scale)
        SetBlipColour(blip, color)
        SetBlipAsShortRange(blip, true)

    elseif __type == "radius" and radius
    then
        blip = AddBlipForRadius(posX, posY, posZ, radius)
        SetBlipSprite(blip, sprite)
        SetBlipDisplay(blip, display)
        SetBlipScale(blip, scale)
        SetBlipColour(blip, color)
        SetBlipAsShortRange(blip, true)
    else
        StaticError("[Error] Invalid or incomplete blip configuration.", false)
        return nil
    end

    if blip and label then
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(label)
        EndTextCommandSetBlipName(blip)
    end

    local _e = EVX.exceptions.set(
        EVX.rawget("error"),
        EVX.rawget(tostring(("%s returned nil."):format("blip"))))

    if blip then
        return blip, 'ok'
    else return nil, _e:get() end
end
