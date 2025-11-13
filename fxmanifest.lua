fx_version 'cerulean'
game 'gta5'
author 'Matija && Vextstate'
description 'Vexlib - Clean Lua Framework for FiveM (ESX and OX compatible)'
version '2.4.5'

-- exports {
--     'proxy', 'global_t', 'client_t'
-- }
-- 

server_exports {
    'proxy',
    'global_t'
}

client_exports {
    'client_t'
}

server_scripts {
    'config.lua',
    'server/vex_server.lua',
    'shared/locale.lua',
    'locales/en.lua',
    'locales/es.lua',
    'shared/vex_shared.lua',
    'shared/exceptions.lua',
    'server/esx_integration.lua',
}

client_scripts {
    'client/vex_client.lua',
    'client/label/label.lua',
    'client/locales/en.lua'
}
