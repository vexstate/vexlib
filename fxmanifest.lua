fx_version 'cerulean'
game 'gta5'
author 'Matija && Vexstate'
description 'VexLib - Clean Lua library for FiveM (ESX and OX compatible)'
version '2.4.5'

shared_script 'shared/vex_shared.lua'
shared_script 'shared/exceptions.lua'
shared_script 'shared/locale.lua'

server_script 'server/vex_server.lua'
server_script 'server/esx_integration.lua'
client_script 'client/vex_client.lua'


server_export 'getVersion'
server_export 'getExceptionDefinitions'
server_export 'getConfig'
server_export 'import'
