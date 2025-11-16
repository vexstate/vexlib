---@diagnostic disable: undefined-global

Vexc = Vexc or {}
CLocales = CLocales or {}
Vexc.Config = Vexc.Config or {}
Vexc.Blip = Vexc.Blip or {}
Vexc.Util = Vexc.Util or {}
Vexc.Exception = Vexc.Exception or {}
Vexc.Locale = Vexc.Locale or {}
Vexc.TextFormat = Vexc.TextFormat or {}
Vexc._exports = Vexc._exports or {}
Exception = Vexc.Exception or {}

Vexc.Config.MaxPlayers = 48
Vexc.Config.AllowDebug = true
Vexc.Config.DefaultLocale = 'en'
Vexc.Config.DefaultException = 'Exception'
Vexc.Config.Locale = Vexc.Config.DefaultLocale

local metabase = {
    __index = function(t,k) return rawget(t,k) end
}

Exception = {
    ['ERROR'] = 'error',
    ['OK'] = 'ok',
    ['WARNING'] = 'warning',
    ['ABORT'] = 'abort'
}

function Vexc.RegisterExport(name, fn)
    if type(name) ~= 'string' then
        print("Error: name must be a string")
        return nil
    end
    if type(fn) ~= 'function' then
        print("Error: fn must be a function")
        return nil
    end

    if Vexc._exports[name] then
        print('Export with name ' .. tostring(name) .. ' already exists')
        return nil
    end

    Vexc._exports[name] = fn

    exports(name, fn)
end

function Vexc.Locale.SetDefault()
    Vexc.Config.Locale = Vexc.Config.DefaultLocale
end

function Vexc.Locale.SetDefaultByHand(lang)
    Vexc.Config.Locale = lang
end

function Vexc.Locale.Register(lang, tbl)
    CLocales[lang] = tbl
end

function Vexc.Locale.Get(key, lang)
    local language = lang or Vex.Config.Locale or 'en'

    if CLocales[language] and CLocales[language][key] then
        return CLocales[language][key]
    end

    if CLocales['en'] and CLocales['en'][key] then
        return CLocales['en'][key]
    end

    return nil
end

function Vexc.Config.Modify(obj, value)
    if Vexc and Vexc.Config and Vexc.Config[obj] then
        Vexc.Config[obj] = value
    else
        print('No already names provided, just new!')
        return nil
    end
end

function Vexc.Util:Vector3(x, y, z)
    if type(x) ~= 'number' or type(y) ~= 'number' or type(z) ~= 'number' then
        local errMsg = Vexc.Exception.Get('InvalidType')
        print("[Vexlib] Vector3 error: " .. tostring(errMsg))
        return nil
    end

    return { x = x, y = y, z = z }
end


function Vexc.TextFormat:Label(table, label)
    if type(table) ~= 'table' then
        print('Invalid data type: table')
    end

    if type(label) ~= 'string' then
        print('Invalid data type: string')
    end

    if Vexc and Labels and Labels[table] then
        for _, v in pairs(Labels[table]) do
            if not Labels[table][label] then
                return nil
            end
        end
    end

    return Labels[table][label]
end

function Exception:Make(typeName, localeKey, details)
    local obj = setmetatable({}, metabase)
    obj.Type = typeName or 'Vexc.Exception'
    obj.Locale = localeKey or Vexc.Config.DefaultException
    obj.Details = details

    return obj
end

function Vexc.Exception.Get(label)
    if not label then
        return Vexc.Exception['Exception'] or 'Unknown error'
    end

    return Vexc.Exception[label] or Vexc.Exception['Exception'] or 'Unknown error'
end


function Exception:ThrowProgramError(msg, lvl)
    if type(msg) ~= 'string' then
        return nil
    end

    if type(lvl) ~= 'number' then
        return nil
    end

    local lvl = lvl or 0
    local msg = msg or Exception:Get('OK') or 'ok'

    return error(msg, lvl)
end

function Exception:ThrowConsoleError(msg, label)
    local v = { msg = msg, label = label }

    for _, x in pairs(v) do
        if type(x) ~= 'string' then
            return -1, nil
        end
    end

    local l = Exception:Get(tostring(label)) or 'ok'
    local msg = msg or 'Error occurred.'

    print("["..l.."]".." "..msg)

    return 0, true
end

function Vexc.Blip:Make(
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

function Vexc.Blip:SafeMake(
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

function Vexc.Blip:Construct(
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

function Vexc.Blip:SafeConstruct(
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

function Vexc.Blip:ConstructTable(tbl)
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

function Vexc.Blip:SafeConstructTable(tbl)
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


Vexc.RegisterExport('client_t', function ()
    return Vexc
end)



