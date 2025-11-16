--- @diagnostic disable: undefined-global

EVX = EVX or {}
EVX.utils = EVX.utils or {}
EVX.blip = EVX.blip or {}

function EVX.utils.print(argc, ...)
    print(argc, ...)
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
--- @return number blip
function EVX.blip:make(
    sprite,
    posx, posy, posz,
    size, color,
    textType, placeholder,
    displayBehaviour
)
    local blip = AddBlipForCoord(posx, posy, posz)

    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, displayBehaviour)
    SetBlipScale(blip, size)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName(textType)
    AddTextComponentSubstringPlayerName(placeholder)
    EndTextCommandSetBlipName(blip)
    return blip
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

    if blip then
        return blip, Exceptions.OK.Locale or 'ok'
    else
        return nil, Exceptions.InvalidValueError.Locale
    end
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

    return blip
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

    return blip, Exceptions.OK.Locale
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
    return blip
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

    return blip, Exceptions.OK.Locale
end
