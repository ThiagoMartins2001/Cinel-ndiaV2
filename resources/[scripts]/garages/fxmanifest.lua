

fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/index.html"

client_scripts {
	"@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
	"client/*"
}

server_scripts {
	"@vrp/config/Vehicle.lua",
	"@vrp/config/Global.lua",
	"@vrp/lib/Utils.lua",
	"server/*"
}

files {
	"web-side/*",
	"web-side/**/*"
}

shared_scripts {
	"shared/*"
}