fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'arlenbales'

ui_page 'html/index.html'
files {
  'html/index.html',
  'html/script.js',
  'html/style.css',
  'html/*otf',
  'html/*png',
  'fonts/*.ttf',
  'fonts/*.otf'
 
}

client_scripts{
    'client/client.lua',
    'config.lua'
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server/server.lua',
  'config.lua',
}

escrow_ignore {
  'config.lua',
  'client/client.lua',
  'server/server.lua',
}

lua54 "yes"
