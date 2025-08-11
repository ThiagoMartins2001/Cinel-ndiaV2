


fx_version 'cerulean'
game 'gta5'

author 'AngelicXS'
version '1.7'

client_script {
	'@vrp/lib/utils.lua',
	'client.lua',
}

server_script {
	'@vrp/lib/utils.lua',
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}

shared_script 'config.lua'
