```
fx_version 'cerulean'
game 'gta5'

author 'NKN-SERVICES || byK3'
description "K3 TIKTOK COMMAND"
version '1.0.0'


shared_script {'config.lua', 'language.lua'}

client_scripts {
    'client/*',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    -- '@oxmysql/lib.lua',
    -- '@ghmattimysql/lib.lua',
    'server/*',
    'config.lua',
    'discord-config.lua',
}
```
