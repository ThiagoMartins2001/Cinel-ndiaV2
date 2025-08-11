

fx_version 'cerulean'

games { 'gta5' }

description 'Bodycam for QB-Core by Messy Scripts'

version '1.8'

author 'Alc NetWork'

ui_page 'web/index.html'

shared_scripts {
    'config.lua'
}

client_scripts {
	"@vrp/lib/utils.lua",
	'client/client.lua'
}

server_scripts {
	"@vrp/lib/utils.lua",
	'@oxmysql/lib/MySQL.lua',
	'server/server.lua'
}

files {
	'web/*.png',
	'web/*.ttf',
	'web/*.html',
	'web/*.css',
	'web/*.js',
	'web/*.wav',
	'web/*.mp3',
	'web/*.ogg'
}
escrow_ignore {
	'config.lua'
}
lua54 'yes'