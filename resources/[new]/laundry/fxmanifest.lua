

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

server_script 'src/main.server.lua'
client_script 'src/main.client.lua'

ui_page 'web/ui.html'

files {
    'web/**/*',
    'config/*.js'
}

shared_scripts {
	"@vrp/config/Item.lua",
	"@vrp/lib/Utils.lua",
    'config/*.shared.lua',
    'src/*.shared.lua'
}
