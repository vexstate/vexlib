EVX = EVX or {}
EVX.env = EVX.env or (IsDuplicityVersion() and 'server' or 'client')

EVX.meta = EVX.meta or {
    name = 'vexlib',
    version = '3.0.0',
    author = 'Matija && Vexstate'
}

EVX._modules = EVX._modules or {}
EVX._exports = EVX._exports or {}

function EVX.isEnv(env)
    if EVX.env ~= env then
        return -1
    else return 0 end
end

function EVX.registerExport(name, fn)
    if type(name) ~= 'string' then
        print("Error: name must be a string")
        return nil
    end
    if type(fn) ~= 'function' then
        print("Error: fn must be a function")
        return nil
    end

    if EVX._exports[name] then
        print('Export with name ' .. tostring(name) .. ' already exists')
        return nil
    end

    EVX._exports[name] = fn

    exports(name, fn)
end

function EVX.getExport(name)
    if EVX._exports then
       return EVX._exports[name]
    end
end

function EVX.getModule(name)
    if EVX._modules then
       return EVX._modules[name]
    end
end
