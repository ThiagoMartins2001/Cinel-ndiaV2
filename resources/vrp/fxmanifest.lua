
fx_version "bodacious"
game "gta5"
lua54 "yes"
author "ImagicTheCat"
creative_network "original"
creator "no"

client_scripts {
	"config/*",
	"lib/Utils.lua",
	"client/*"
}

server_scripts {
	"config/*",
	"auth.lua*",
	"lib/Utils.lua",
	"modules/vrp.lua",
	"modules/server.lua",
	"modules/misc.lua",
	"modules/prepare.lua"
}

files {
	"lib/*"
}