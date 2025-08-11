


fx_version "bodacious"
game "gta5"
lua54 "yes"

shared_scripts {
	"@vrp/config/Global.lua"
}

client_scripts {
	"@vrp/config/Native.lua",
	"@PolyZone/client.lua",
	"@vrp/lib/Utils.lua",
	'config.lua',
	"client-side/*"
}

server_scripts {
	"@vrp/config/Item.lua",
	"@vrp/lib/Utils.lua",
	'config.lua',
	"server-side/*"
}