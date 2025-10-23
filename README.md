<div align="center"><h1>Vexlib</h1></div>

Is a modular and extendable Lua library built for FiveM, the multiplayer modification framework for GTA V. It provides a collection of utilities, configurations, and gameplay enhancements aimed at simplifying development and improving server performance, readability, and maintainability.

## 🚀 Features

- Centralized configuration system (`Configs`, `Settings`)
- Blip/marker/text draw helpers
- Player and entity validation utilities
- Type-checking and error-handling support
- Game-specific features (weather sync, safe zones, voice chat settings)
- Custom HUD, UI, and control options
- Easily expandable for custom jobs, systems, and frameworks


## 📄 Usage

### 1. Install the Resource

1. Git clone repo: 

```bash
git clone --depth=1 https://github.com/vexstate/vexlib.git
```

2. Place the `vexlib` folder inside your `resources` directory.
3. Add the following line to your _server.cfg_:


```cfg
# make sure that framework goes before custom scripts
ensure vexlib
# ensure my_little_script
# ...
```

4. More info about library and usage of same @: [Documentation](docs/vex_lib_five_m_lua_library_complete.md)
