local load_time = 2000

-- this was loading test

---@test
-- function notify(text)
--     SetNotificationTextEntry('STRING')
--     AddTextComponentString(text)
--     DrawNotification(false, false)
-- end

-- Vex.registerExport('notify', notify)

-- Citizen.CreateThread(function()
--     Citizen.Wait(2000)
--     local welcome = Vex.Locale.get('welcome') or 'Welcome'
--     notify(welcome)
-- end)

function Vex.Utils:GetTableLen(table)
    if type(table) ~= 'table' then
        return nil, Exceptions.InvalidTypeException.Locale
    end

    local count = 0

    for _ in next, table do
        count = count + 1
    end

    return count, Exceptions.OK.Locale
end

function Vex.World:Vector3(x, y, z)
    for _, v in ipairs({x, y, z}) do
        if type(v) ~= 'number' then
            return nil, Vex.Exceptions.InvalidType.Locale
        end
    end

    x = x or 0.0
    y = y or 0.0
    z = z or 0.0

    return {x = x, y = y, z = z}, Exceptions.OK.Locale
end

function Vex.World:Vector2(x, y)
    for _, v in ipairs({x, y}) do
        if type(v) ~= 'number' then
            return nil, Vex.Exceptions.InvalidType.Locale
        end
    end

    x = x or 0.0
    y = y or 0.0

    return {x = x, y = y}, Vex.Exceptions.OK.Locale
end

function Vex.Blip:Make(
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
    return blip
end

function Vex.Blip:SafeMake(
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

function Vex.Blip:Construct(
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

function Vex.Blip:SafeConstruct(
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

function Vex.Blip:ConstructTable(tbl)
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
        StaticError("[Error] Invalid or incomplete blip configuration.", false)
        return nil
    end

    if blip and label then
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(label)
        EndTextCommandSetBlipName(blip)
    end
    return blip
end

function Vex.Blip:SafeConstructTable(tbl)
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

function Vex.Palette(target, before, after)
    local src = source
    if type(target) ~= 'string' then
        return Exceptions.InvalidTypeException
    end

    if type(before) ~= 'boolean' then
        return Exceptions.InvalidTypeException
    end

    if type(after) ~= 'boolean' then
        return Exceptions.InvalidTypeException
    end

    local Palette = {
        Color = {
            WHITE = '~w~',
            RESET = '~w~',
            BLACK = '~b~'
        }
    }

    if not before and not after then
        Vex.ChatNotify(source, target)
    elseif not before then
        Vex.ChatNotify(source, target)
    elseif not after then
        local new_target = before .. target .. tostring(Palette.Color.WHITE)
        Vex.ChatNotify(source, new_target)
    else
        local n = before .. target .. after
        Vex.ChatNotify(source, tostring(n))
    end
    
    return Vex.Locale.get('OK', 'en')
end
