fx_version 'cerulean'
game 'gta5'
author 'Vexstate'
description 'VexLib - Clean Lua library for FiveM (ESX compatible)'
version '1.0.0'

shared_script 'shared/vex_shared.lua'
shared_script 'shared/exceptions.lua'
shared_script 'shared/locale.lua'

server_script 'server/vex_server.lua'
server_script 'server/esx_integration.lua'
client_script 'client/vex_client.lua'


server_export 'getVersion'
server_export 'getExceptionDefinitions'
server_export 'getConfig'
