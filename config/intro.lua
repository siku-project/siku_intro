IntroConfig = {
  --- Release bucket
  ---
  --- Whether finishing the introduction moves the player from their private
  --- instance back into the main world, through the core bucket service.
  --- The introduction never touches the bucket at start: it plays inside
  --- whatever instance the character resource prepared.
  releaseBucket = true,

  --- Protection
  ---
  --- Whether the character is made invincible while the introduction runs.
  invincible = true,

  --- Hide HUD
  ---
  --- Whether the radar and, when siku_hud is running, the whole HUD are
  --- hidden during the introduction.
  hideHud = true,

  --- Model timeout
  ---
  --- How long a model or animation request may take before the step gives
  --- up, in milliseconds.
  loadTimeout = 10000,

  --- Driving defaults
  ---
  --- The style and speed a driveTo step falls back to. 786603 keeps the
  --- driver on the road, stopping at nothing.
  driving = {
    speed = 14.0,
    style = 786603,
  },

  --- Final fade
  ---
  --- How long the fade takes when the introduction has to bail out early,
  --- in milliseconds. A completed introduction never fades: it hands the
  --- camera over seamlessly (see handover).
  finalFade = 1200,

  --- Handover
  ---
  --- The seamless end of a completed introduction: the scripted camera
  --- glides back to the gameplay camera over `blend` milliseconds, then
  --- the World Reveal plays. Until the real effect exists, a subtle focus
  --- pulse stands in for it.
  handover = {
    blend = 2500,
  },

  --- Music
  ---
  --- One place for the montage track. The file lives in
  --- web/public/audio/music/intro/ and ships with the build; replacing the
  --- track is replacing this value (or the file itself). No file, no
  --- problem: the interface stays silent and the montage plays on.
  music = {
    montage = 'audio/music/intro/intro_city.ogg',
    volume = 0.55,
  },
}
