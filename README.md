# 🧩 Vexlib — Clean & Modular Lua Framework for FiveM (ESX and OX Compatible)

**Author:** [Matija](https://github.com/n11kol11c)  
**Version:** 2.4.5  
**Framework Compatibility:** ESX Legacy / ESX 1.x / OX / ox_lib 

**License:** MIT  

---

## ✨ Overview

**VexLib** is a lightweight, modular Lua utility framework for **FiveM** that provides a clean, standardized way to build scripts and manage shared logic across multiple resources.  

It includes ready-to-use systems for:
- > ⚙️ Config management and exportable metadata  
- > 🌐 Locale (translation) handling  
- > ⚠️ Exception and error wrapping  
- > 🧠 Safe function calls (with crash protection)  
- > 💬 Reusable chat & notification utilities  
- > 🔗 Easy export registration for other resources  
- > 💵 ESX and OX player helpers and examples  

Built with **professional structure**, **ESX and OX compatibility**, VexLib helps you write cleaner, more modular, and safer server/client code.

---

## 🚀 Installation

1. **Download or clone** this repository into your `resources/` folder:
   ```bash
   git clone https://github.com/vexstate/vexlib.git
    ```

2. Add it to your **_server.cfg_**:
    ```cfg
    ensure vexlib
    ```

3. Make sure **_ESX_** and **_OX_** are started before **VexLib** if you want ESX and OX integration:
    ```bash
    ensure core
    ensure es_extended
    ensure ox_lib
    ensure ox_other_scripts
    ensure vexlib
    # ensure my_little_script
    # ensure ...
    ```
4. Add following line to server script:
   ```lua
   local Vex = exports['vexlib']:import()
   ```
> Vex functions are **only** allowed on server-side scripts

---

## 📁 Folder Structure

```
vexlib/
├── fxmanifest.lua
├── config.lua
├── README.md
├── locales/
│   ├── en.lua
│   └── es.lua
├── shared/
│   ├── vex_shared.lua
│   ├── exceptions.lua
│   └── locale.lua
├── server/
│   ├── vex_server.lua
│   └── esx_integration.lua
└── client/
    └── vex_client.lua
```

---

## ⚙️ Configuration

All main settings are defined in _config.lua_:
```lua
Config.Version = '2.4.5'
Config.Name = 'VexLib'
Config.Locale = 'en'
Config.Debug = false
Config.MaxPlayersSync = 32
```

> You can override these values or access them dynamically from other resources via exports.

---

## 🌐 Localization System

VexLib includes a simple **locale manager** with English (`en`) and Spanish (`es`) translations by default.

Example:  
```lua
local str = exports['vexlib']:locale_get('welcome')
print(str) -- "Welcome to Vexstate!"
```

To add your own language:
1. Create a new file in `locales/` (e.g., `fr.lua`).
2. Define your translations.
3. Register it via `Vex.Locale.register('fr', Locales['fr'])`.

---

## ⚠️ Exception System

A minimal but powerful **error and exception** layer.  
Use it to handle validation or runtime errors without crashing your resource.

```lua
Vex.Throw(Exceptions.InvalidTypeException, 'Expected string but got nil')
```

Or safely execute wrapped logic:
```lua
local ok, result = Vex.safeCall(function()
    return doSomethingRisky()
end)
```

If something fails, the error is printed in a consistent VexLib format without breaking your script.

---

## 🔗 Exports

| Export | Type | Description |
|:--|:--|:--|
| `getVersion()` | Shared | Returns current library version |
| `getConfig()` | Server | Returns current config table |
| `getExceptionDefinitions()` | Shared | Returns predefined exception objects |
| `locale_get(key, lang?)` | Shared | Returns a localized string |
| `getESXPlayer(sourceOrIdentifier)` | Server | Returns an ESX player object by ID or identifier |

### Example Usage

```lua
local version = exports['vexlib']:getVersion()
local cfg = exports['vexlib']:getConfig()
local errDefs = exports['vexlib']:getExceptionDefinitions()
print('[VexLib] version', version)
```

---

## 💵 ESX Integration

VexLib automatically detects and connects to ESX during startup.  
It provides helper functions for seamless ESX player handling.

Example:  
```lua
local xPlayer = exports['vexlib']:getESXPlayer(source)
if xPlayer then
    xPlayer.addMoney(1000)
end
```

**Included Example Command:**
```lua
/vex_version
```
Displays the library version either in console or chat.

---

## 💬 Client Helpers

A basic notification wrapper is provided in `client/vex_client.lua`:

```lua
exports['vexlib']:notify('Welcome to the server!')
```

You can replace or extend this to integrate with your UI framework (e.g. `ox_lib`, `qb-core`, `mythic_notify`, etc.).

---

## 🧱 Developer Notes

### Safe Call Pattern
Use `Vex.safeCall(fn, ...)` to protect logic:
```lua
local ok, res = Vex.safeCall(myRiskyFunction, arg1, arg2)
```

### Throwing Errors
Instead of native `error()`, use:
```lua
Vex.Throw(Exceptions.InvalidValueError, 'Health must be positive')
```

### Locale Access
```lua
local msg = Vex.Locale.get('goodbye', 'es')
print(msg) -- "¡Hasta luego!"
```

---

## 🧠 Best Practices

- ✅ Always wrap external calls in `Vex.safeCall` to prevent resource crashes.  
- ✅ Use `Vex.Throw` for structured exceptions.  
- ✅ Keep logic modular — shared code belongs in `shared/`, not `server/` or `client/`.  
- ✅ Prefix all exported or global functions with `Vex.` to prevent naming conflicts.  
- ✅ Use `Vex.Config.Debug` toggles for verbose output in dev environments.  

---

## 🧩 Extending VexLib

You can easily add new reusable systems or exports.  
Example: adding a new shared utility:

```lua
function Vex.utils.randomString(len)
    local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local str = ''
    for i = 1, len do
        local idx = math.random(1, #chars)
        str = str .. chars:sub(idx, idx)
    end
    return str
end

Vex.registerExport('randomString', Vex.utils.randomString)
```

Then in another resource:
```lua
local id = exports['vexlib']:randomString(8)
print('Generated ID:', id)
```

---

## 🧱 Example Integration (Server Command)

Create a custom command with exception safety:

```lua
RegisterCommand('vex_givemoney', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return TriggerClientEvent('chat:addMessage', source, { args = { 'VexLib', '[error]: Cannot find player' } })
    end

    local amount = tonumber(args[1])
    if not amount then
        Vex.Throw(Exceptions.InvalidTypeException, 'Amount must be a number')
    end

    xPlayer.addMoney(amount)
    TriggerClientEvent('chat:addMessage', source, { args = { 'VexLib', ('You received $%s'):format(amount) } })
end)
```

---

## 🧩 Contributing

Pull requests are welcome!  
If you’d like to contribute improvements, translations, or new modules:
1. Fork the repo  
2. Create a feature branch  
3. Submit a PR with detailed notes  

---

## 🧾 License

This project is released under the **MIT License**.  
You may freely use, modify, and redistribute it with attribution.

---

## 🏁 Summary

VexLib provides a **stable foundation** for professional FiveM development, especially in ESX-based environments.  
It removes boilerplate, enforces consistency, and improves error safety — helping you focus on gameplay logic instead of repetitive code.

> **Build faster.**  
> — *Vexstate*
