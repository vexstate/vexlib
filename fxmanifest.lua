fx_version 'cerulean'
game 'gta5'
author 'Matija && Vextstate'
description 'VexLib - Clean Lua Framework for FiveM (ESX and OX compatible)'
version '2.4.5'

shared_script {
    'shared/vex_shared.lua',
    'shared/exceptions.lua',
    'shared/locale.lua'
}

exports {
    'import'
}

server_script {
    'server/vex_server.lua',
    'server/esx_integration.lua'
}

client_script 'client/vex_client.lua'
