fx_version 'cerulean'
game 'gta5'

author 'Matija && Vextstate'
description 'Vexlib - Clean Lua Framework for FiveM (ESX and OX compatible)'
version '3.0.0'

shared_scripts {
    'shared/init.lua',
    'shared/modules/alias.lua',
    'shared/modules/format.lua',
    'shared/modules/exceptions.lua',
    'shared/modules/locale.lua',
    'shared/modules/table.lua',
    'shared/modules/str.lua',
    'shared/modules/utils.lua'
}


client_scripts {
    'client/client.lua',
    'client/modules/ui.lua'
}


server_scripts {
    'server/config.lua',
    'server/init.lua',
    'server/modules/api.lua',
    'server/esx_integration.lua',
    'server/modules/file.lua'
}
