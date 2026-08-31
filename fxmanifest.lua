fx_version 'cerulean'
game 'gta5'

author 'Siku Studio'
description 'A cinematic introduction system for the SIKU ecosystem — delivering immersive character arrivals through scripted scenes, dynamic cameras, actors, animations, audio, and seamless world transitions. Built for configurable, premium FiveM roleplay experiences.'
version '0.1.0'

name 'siku_intro'

lua54 'yes'

shared_scripts {
  '@siku_core/init.lua',
  'config/translation.lua',
  'config/intro.lua',
  'config/scenes.lua',
}

server_scripts {
  'server/init.lua',
  'server/main.lua',
}

client_scripts {
  'client/modules/state.lua',
  'client/modules/actors.lua',
  'client/modules/cameras.lua',
  'client/modules/steps.lua',
  'client/modules/cleanup.lua',
  'client/modules/sequence.lua',
  'client/main.lua',
}

ui_page 'web/dist/index.html'

files {
  'translations/*.lua',
  'web/dist/**/*',
}

dependencies {
  'siku_core',
}
