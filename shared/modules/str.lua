EVX = EVX or {}
EVX.string = EVX.string or {}

EVX.string._blank = ("")
EVX.string._space = (" ")
EVX.string._blank = EVX.string._blank or ""
EVX.string._space = EVX.string._space or " "

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
