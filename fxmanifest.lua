fx_version 'cerulean'
game 'gta5'

author 'Matija && Vextstate'
description 'Vexlib - Clean Lua Framework for FiveM (ESX and OX compatible)'
version '3.0.0'


shared_scripts {
    'shared/init.lua',
    'shared/modules/alias.lua',
    'shared/modules/locale.lua',
    'shared/modules/format.lua',
    'shared/modules/utils.lua',
    'shared/modules/exceptions.lua'
}

server_scripts {
    'server/main.lua',
    'server/commands.lua',
    'server/esx_integration.lua'
}

client_scripts {
    'client/client.lua',
    'locales/lua/en.lua'
}

exports {
    'getSharedObject',
    'getServerObject'
}
