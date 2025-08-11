shared_script "@ThnAC/native.lua"
shared_script "@ThnAC/natives.lua"

fx_version 'adamant'
game 'gta5'
author 'Harry Network'
descrption 'Script para facilitar a solicitação e cópia de coordenadas'
ui_page "ui/index.html"
shared_scripts{
  "config.lua"
}
client_scripts {
  "client/*"
}
server_scripts {
  "server/*"
}
files {
  "ui/*"
}