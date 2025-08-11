

shared_script ""


thn_disabletrigger "yes"
fx_version "bodacious"
game "gta5"
lua54 "yes"
ui_page "web-side/index.html"

client_scripts {
	"client-side/*"
}
server_scripts {
	"server-side/*"
}

shared_scripts {
	"@vrp/config/Native.lua",
	"@vrp/config/Item.lua",
	"@vrp/lib/Utils.lua",
	"theft.lua",
}

files {
	"web-side/*"
}                                          