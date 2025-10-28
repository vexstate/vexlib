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
        proxy[k] = deepcopy_readonly(v)  -- recursively wrap nested tables
    end

    return setmetatable({}, {
        __index = proxy,
        __newindex = function() error("Attempt to modify read-only table") end,
        __pairs = function() return pairs(proxy) end,
        __ipairs = function() return ipairs(proxy) end,
        __metatable = false
    })
end

function Vex.safeCall(fn, ...)
    local ok, res = pcall(fn, ...)

    if not ok then
        print(('vexlib - safeCall error: %s'):format(tostring(res)))
        return false, res
    end

    return true, res
end

function Vex.registerCommand(name, cb, adminOnly)
    RegisterCommand(name, function(source, args, raw)
        local xPlayer = ESX.GetPlayerFromId(source)

        if adminOnly then
            if not xPlayer then
                print(('^1[vexlib]^0: Player not found for command "%s"'):format(name))
                return
            end

            local group = xPlayer.getGroup()
            if group ~= 'admin' and group ~= 'superadmin' then
                Vex.ChatNotify(source, '[error]: You do not have permission to use this command.')
                return
            end
        end

        local ok, err = Vex.safeCall(cb, source, args, raw)
        if not ok then
            Vex.ChatNotify(source, '[error]: Command failed, check console for details.')
        end
    end)
end

function Vex.IsPlayerAce(playerId, ace)
    if not playerId or not ace then
        return false
    end

    if not IsDuplicityVersion() then
        return false
    end

    local hasAce = IsPlayerAceAllowed(playerId, ace)
    return hasAce == true
end

function Vex.IsPlayerGroup(playerId, group)
    if not playerId or not group then
        return false
    end

    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then
        return false
    end

    local playerGroup = xPlayer.getGroup()
    return tostring(playerGroup) == tostring(group)
end

function Vex.CheckPedGroup(xPlayer, expected_group)
    if not xPlayer then return false end
    local group = xPlayer.getGroup()
    return tostring(group) == tostring(expected_group)
end

function Vex.GatherPlayerIdentifier()
    local src = source
    local identifier = GetPlayerIdentifiers(src)

    if not identifier then
        return Exceptions.InvalidValue.Locale
    end

    return tostring(identifier)
end

function Vex.loadPlayer(identifier)
    if type(identifier) ~= 'string' then
        Vex.Throw(Vex.Exceptions.InvalidType, 'identifier must be a string')
    end

    return { id = identifier }
end

function Vex.ChatNotify(source, msg)
    TriggerClientEvent('chat:addMessage', source, {
        args = { '[vexlib]', msg }
    })
end

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

function Vex.Player:addItem(source, item, amount)
    local player
    if Vex.Config.Inventory == 'ESX' then
        player = ESX.GetPlayerFromId(source)
        if player then
            player.addInventoryItem(item, amount)
        end
    elseif Vex.Config.Inventory == 'OX' then
        player = Player(source)
        if player then
            player.addItem(item, amount)
        end
    end
end

function Vex.Player:removeItem(source, item, amount)
    local player
    if Vex.Config.Inventory == 'ESX' then
        player = ESX.GetPlayerFromId(source)
        if player then
            player.removeInventoryItem(item, amount)
        end
    elseif Vex.Config.Inventory == 'OX' then
        player = Player(source)
        if player then
            player.removeItem(item, amount)
        end
    end
end

function Vex.Player:addMoney(source, amount)
    local player
    if Vex.Config.Inventory == 'ESX' then
        player = ESX.GetPlayerFromId(source)
        if player then
            player.addMoney(amount)
        end
    elseif Vex.Config.Inventory == 'OX' then
        player = Player(source)
        if player then
            player.addMoney(amount)
        end
    end
end

function Vex.Player:removeMoney(source, amount)
    local player
    if Vex.Config.Inventory == 'ESX' then
        player = ESX.GetPlayerFromId(source)
        if player then
            player.removeMoney(amount)
        end
    elseif Vex.Config.Inventory == 'OX' then
        player = Player(source)
        if player then
            player.removeMoney(amount)
        end
    end
end

Vex.registerCommand('vex_version', function (source, args, raw)
    local ver = Vex.Config.Version

    if source == 0 then
        print('Vexlib version: ' .. ver)
    else
        Vex.ChatNotify(source, '[vexlib] : Version : ' .. ver)
    end
end, true)

Vex.registerCommand('vex_givemoney', function (source, args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        TriggerClientEvent('chat:addMessage', source, {
            args = { 'VexLib', '[error]: Cannot find player with this source.' }
        })
        return
    end

    local playerGroup = xPlayer.getGroup()
    if playerGroup ~= 'admin' and playerGroup ~= 'superadmin' then
        TriggerClientEvent('chat:addMessage', source, {
            args = { 'VexLib', '[error]: You do not have permission to use this command.' }
        })
        return
    end

    local targetId = tonumber(args[1])
    local amount = tonumber(args[2])

    if not targetId or not amount then
        TriggerClientEvent('chat:addMessage', source, {
            args = { 'VexLib', 'Usage: /vex_givemoney [playerId] [amount]' }
        })
        return
    end

    local xTarget = ESX.GetPlayerFromId(targetId)
    if not xTarget then
        TriggerClientEvent('chat:addMessage', source, {
            args = { 'VexLib', '[error]: Target player not found.' }
        })
        return
    end

    xTarget.addMoney(amount)

    TriggerClientEvent('chat:addMessage', targetId, {
        args = { 'VexLib', ('You have received $%s from an admin.'):format(amount) }
    })

    TriggerClientEvent('chat:addMessage', source, {
        args = { 'VexLib', ('You gave $%s to player %s.'):format(amount, targetId) }
    })
end, true)

Vex.registerCommand('vex_oxgivemoney', function(source, args)
    local xPlayer = Vex.getOXPlayer(source)
    if not xPlayer then return end

    local targetId = tonumber(args[1])
    local amount = tonumber(args[2])
    if not targetId or not amount or amount <= 0 then return end

    local xTarget = Vex.getOXPlayer(targetId)
    if not xTarget then return end

    xTarget.addMoney(amount)

    Vex.ChatNotify(targetId, ('You received $%s from an admin.'):format(amount))
    Vex.ChatNotify(source, ('You gave $%s to player %s.'):format(amount, targetId))
end, true)

Vex.registerExport('Config', function() return readonly(Vex.Config) end)
Vex.registerExport('Locale', function() return readonly(Vex.Locale) end)
Vex.registerExport('Player', function() return readonly(Vex.Player) end)
Vex.registerExport('Utils', function() return readonly(Vex.Utils) end)
Vex.registerExport('World', function() return readonly(Vex.World) end)
Vex.registerExport('Blip', function() return readonly(Vex.Blip) end)
Vex.registerExport('Exceptions', function() return readonly(Vex.Exceptions) end)

Vex.registerExport('Throw', Vex.Throw)
Vex.registerExport('IsPlayerAce', Vex.IsPlayerAce)
Vex.registerExport('IsPlayerGroup', Vex.IsPlayerGroup)
Vex.registerExport('safeCall', Vex.safeCall)
Vex.registerExport('CheckPedGroup', Vex.CheckPedGroup)

Vex.registerExport('import', function()
    return deepcopy_readonly(Vex)
end)