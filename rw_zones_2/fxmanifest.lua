fx_version 'cerulean'
game 'gta5'

name 'Royale_zones'

author 'RoyaleWind'
description 'By RoyaleWind'
version '1.0.0'

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/icons/*.png',
  'html/fonts/*.ttf',
  'html/style.css',
  'html/listener.js'
}

client_script {
  'rw_zone_red.lua',
  'rw_zone_green.lua',
  'rw_zone_neutral.lua'
}

shared_script {
  'config.lua'
}
