


fx_version "bodacious"
game "gta5"


shared_scripts {
    "cfg.lua",
}

client_scripts {
	"@vrp/lib/utils.lua",
	"client/*"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"@vrp/config/Item.lua",
	"server/*"
}         