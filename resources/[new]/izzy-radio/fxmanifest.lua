

fx_version 'adamant'

game 'gta5'

author "gener4l"

lua54 'yes'

description 'izzy.tebex.io'

ui_page "html/index.html"

files {
    'html/**/**.**'
}

shared_scripts {
    "@vrp/lib/utils.lua",
    'config.lua',
    "notify.lua"
}

client_script { 
    "main/client.lua",
}

server_script { 
    "main/server.lua",
}




resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'