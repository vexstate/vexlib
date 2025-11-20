EVX = EVX or {}
EVX.exceptions = EVX.exceptions or {}
EVX.exceptions.object = EVX.exceptions.object or {}

EVX.exceptions.object = {
    ok = {
        [1] = { TYPE = "ok", INFO = "No error has occured" },
        [2] = { TYPE = "ok_exit", INFO = "Everything is okey, exiting..." }
    },
    error = {
        [1] = {
            TYPE = "exception",
            INFO = "The error has occured."
        },
        [2] = {
            TYPE = "value_exception",
            INFO = "Value exception has been made."
        }
    },
    abort = {
        [1] = { TYPE = "abort", INFO = "Aborting..." }
    }
}

--- @param full? boolean
function EVX.exceptions.plist(full)
    for category, exceptions in pairs(EVX.exceptions.object) do
        print("Category: " .. category)
        for i, obj in ipairs(exceptions) do
            if full then
                print(string.format("  [%d] TYPE: %s, INFO: %s", i, obj.TYPE, obj.INFO))
            else
                print(string.format("  [%d] TYPE: %s", i, obj.TYPE))
            end
        end
    end
end

--- @param tp string
--- @param des? string
--- @param val? number
function EVX.exceptions.createobj(tp, des, val)
    if type(tp) ~= "string" then
        return nil
    end

    local obj = {
        TYPE = tp,
        DES = des or "",
        VAL = val or -1
    }

    local mt = {
        __index = {
            get = function (self)
                return self.TYPE
            end,

            flush = function(self)
                print(string.format("[vexlib:exceptions] Type: %s | Description: %s | Value: %s",
                    self.TYPE, self.DES, tostring(self.VAL)))
                return self.VAL
            end,

            setdes = function(self, newDes)
                if type(newDes) == "string" then
                    self.DES = newDes
                end
            end,

            pdes = function(self)
                print("[vexlib:exceptions] " .. self.DES)
            end
        }
    }

    setmetatable(obj, mt)
    return obj
end


--- @return string|nil
function EVX.exceptions.get(obj, tp)
    if type(obj) ~= "string" then
        return nil
    end

    if type(tp) ~= "number" then
        return nil
    end

    local ct = EVX.exceptions.object[obj]
    if not ct then
        return nil
    end

    local e = ct[tp]
    if not e then
        return nil
    end

    return e.INFO
end
