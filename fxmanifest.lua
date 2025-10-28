fx_version 'cerulean'
game 'gta5'
author 'Matija && Vextstate'
description 'Vexlib - Clean Lua Framework for FiveM (ESX and OX compatible)'
version '2.4.5'

exports {
    'proxy', 'global_t'
}

server_script {
    'server/vex_server.lua',
    'server/esx_integration.lua',
    'shared/vex_shared.lua',
    'shared/exceptions.lua',
    'shared/locale.lua'
}

client_script 'client/vex_client.lua'