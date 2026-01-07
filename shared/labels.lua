EVX = EVX or {}
EVX.Label = EVX.Label or {}

EVX.Label["@"] = {
    root = {
        [1] = { put = "@vexlib:root" },
        [2] = { put = "@vexlib:fxmanifest" },
        [3] = { put = "@vexlib:shared/locales" },
    }
}
---
--- @param target string
--- @param ctg string
--- @param field number
--- @return string
function EVX.Label.puts(target, ctg, field)
    if type(ctg) ~= "string" or type(field) ~= "number" then
        return ""
    end

    local targetTable = EVX.Label[target]
    if not targetTable then return "" end

    local categoryTable = targetTable[ctg]
    if not categoryTable or type(categoryTable) ~= "table" then
        return ""
    end

    local entry = categoryTable[field]
    if entry and type(entry.put) == "string" then
        return entry.put
    end

    return ""
end

--- @param target string
--- @param ctg string
--- @param value string
--- @return boolean
function EVX.Label.addto(target, ctg, value)
    if type(target) ~= "string" or type(ctg) ~= "string" or type(value) ~= "string" then
        return false
    end

    EVX.Label[target] = EVX.Label[target] or {}

    EVX.Label[target][ctg] = EVX.Label[target][ctg] or {}

    local categoryTable = EVX.Label[target][ctg]

    for _, entry in ipairs(categoryTable) do
        if entry.put == value then
            return false
        end
    end

    table.insert(categoryTable, { put = value })
    return true
end
