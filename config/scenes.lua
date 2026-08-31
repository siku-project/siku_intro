--- The SIKU introduction, act by act, shot by shot.
---
--- Search markers: SHOT, [CAMERA], [ACTOR ACTION], [SUBTITLE],
--- [VOICE SLOT], [MUSIC CUE], [LOCATION CUE], [TRANSITION],
--- [IN-GAME TUNING].
---
--- Every coordinate, FOV, duration and dialogue line in this file is data:
--- tune it here, never in the engine. Values marked [IN-GAME TUNING] are a
--- first coherent pass and expect a visual session in FiveM.

-- ============================================================
-- DESTINATION — the place gameplay begins.
-- Swap this block to move the whole third act somewhere else.
-- [IN-GAME TUNING] every value below.
-- ============================================================
local DESTINATION <const> = {
  --- Where Marcus' car stages before rolling into frame, off camera.
  staging = { coords = vector3(-140.0, -1035.0, 27.2), heading = 160.0 },

  --- Where the car actually stops.
  parking = vector3(-256.0, -978.0, 31.2),

  --- Where the character stands once dropped.
  dropoff = { coords = vector3(-260.5, -974.5, 31.2), heading = 205.0 },

  --- Where Marcus drives away to before despawning.
  exit = vector3(-320.0, -1040.0, 30.2),

  --- The establishing shot above the destination (SHOT 15).
  establishing = {
    from = { coords = vector3(-262.0, -968.0, 110.0), fov = 45.0 },
    to = { coords = vector3(-268.0, -962.0, 40.0), fov = 42.0 },
    duration = 8000,
  },

  --- The final glide that ends behind the player (SHOT 19). `to` should
  --- sit roughly where the gameplay camera rests: the engine blends the
  --- rest of the way.
  handover = {
    from = { coords = vector3(-266.0, -966.0, 34.0), fov = 42.0 },
    to = { coords = vector3(-262.2, -970.8, 32.6), fov = 50.0 },
    duration = 5000,
  },
}

IntroScenes = {

  -- ============================================================
  -- ACT I — ARRIVAL / MARCUS / FIRST CONTACT
  -- ============================================================

  -- ============================================================
  -- SHOT 01 → 04 — LSIA: the character walks out, Marcus drives
  -- in, first words, everyone gets in the car.
  -- ============================================================
  {
    id = 'act1_lsia',

    actors = {
      -- [IN-GAME TUNING] terminal exit position and walk target.
      { id = 'player', type = 'player', coords = vector3(-1037.6, -2736.1, 20.2), heading = 145.0 },

      -- Marcus and his car start staged up the airport road, out of
      -- frame: SHOT 02 drives them in for real. Swap the sedan model to
      -- change his car everywhere.
      -- [IN-GAME TUNING] staging position, far enough to be unseen.
      {
        id = 'sedan',
        type = 'vehicle',
        model = 'fugitive',
        coords = vector3(-966.0, -2696.0, 13.9),
        heading = 240.0,
      },
      { id = 'marcus', type = 'ped', model = 'a_m_y_business_03', coords = vector3(-966.0, -2696.0, 13.9), warpInto = 'sedan', seat = -1 },
    },

    cameras = {
      -- [CAMERA] SHOT 01 — medium 3/4 on the character, gentle push-in.
      -- [IN-GAME TUNING] framing, fov, push distance.
      arrival = {
        type = 'move',
        from = { coords = vector3(-1031.5, -2731.0, 22.4), fov = 38.0 },
        to = { coords = vector3(-1033.6, -2733.4, 21.6), fov = 34.0 },
        duration = 7000,
        easing = 'easeInOut',
        lookAtActor = 'player',
      },

      -- [CAMERA] SHOT 02 — wide 3/4 front: the car rolls in and stops.
      -- [IN-GAME TUNING] must read both the road and the character.
      pickup = {
        type = 'static',
        coords = vector3(-1046.0, -2732.0, 22.8),
        lookAt = vector3(-1030.0, -2734.0, 20.5),
        fov = 45.0,
      },

      -- [CAMERA] SHOT 03 — dialogue coverage.
      marcus_medium = {
        type = 'static',
        coords = vector3(-1035.2, -2737.6, 21.4),
        lookAtActor = 'marcus',
        fov = 32.0,
      },
      player_reverse = {
        type = 'static',
        coords = vector3(-1032.4, -2733.0, 21.4),
        lookAtActor = 'player',
        fov = 32.0,
      },
      two_shot = {
        type = 'static',
        coords = vector3(-1039.5, -2731.5, 21.9),
        lookAt = vector3(-1034.5, -2736.0, 20.8),
        fov = 40.0,
      },
    },

    timeline = {
      -- SHOT 01 — PLAYER ARRIVAL -------------------------------------
      { camera = 'arrival' },
      { fade = 'in', duration = 1400 },
      -- [ACTOR ACTION] the character actually walks out of the terminal.
      { action = 'walkTo', actor = 'player', coords = vector3(-1034.8, -2739.4, 20.2), speed = 1.0, heading = 145.0 },
      { wait = 1800 },
      -- [LOCATION CUE]
      { location = { title = 'LOS SANTOS', subtitle = 'Los Santos International Airport', duration = 4500 } },
      { wait = 3600 },

      -- SHOT 02 — MARCUS ARRIVES -------------------------------------
      -- [TRANSITION] cut on the character stopping.
      { camera = 'pickup' },
      -- [ACTOR ACTION] the car genuinely drives in and brakes to a stop.
      -- [IN-GAME TUNING] approach speed and stop point.
      { action = 'driveTo', actor = 'sedan', driver = 'marcus', coords = vector3(-1039.5, -2738.8, 20.3), speed = 11.0, stopRange = 3.0 },
      { action = 'waitArrival', actor = 'sedan', coords = vector3(-1039.5, -2738.8, 20.3), radius = 5.0, timeout = 30000 },
      { wait = 1200 },

      -- SHOT 03 — FIRST CONTACT --------------------------------------
      -- [ACTOR ACTION] Marcus steps out, walks up, looks the character
      -- over. Body language beats stillness.
      { action = 'leaveVehicle', actor = 'marcus' },
      { wait = 2000 },
      { camera = 'marcus_medium', transition = { type = 'cut' } },
      { action = 'walkTo', actor = 'marcus', coords = vector3(-1036.2, -2737.4, 20.2), speed = 1.0 },
      { action = 'lookAt', actor = 'player', target = 'marcus' },
      { wait = 1600 },
      { action = 'lookAt', actor = 'marcus', target = 'player' },

      -- [SUBTITLE] [VOICE SLOT] voice = 'marcus_01'
      { subtitle = { speaker = 'MARCUS', text = "C'est toi, le nouveau ?", duration = 2600 } },
      -- [ACTOR ACTION] he sizes the character up.
      { action = 'playAnim', actor = 'marcus', dict = 'gestures@m@standing@casual', anim = 'gesture_shrug_soft', flag = 49 },
      { wait = 900 },
      { camera = 'player_reverse', transition = { type = 'cut' } },
      { wait = 1400 },
      { camera = 'marcus_medium', transition = { type = 'cut' } },
      -- [SUBTITLE] [VOICE SLOT] voice = 'marcus_02'
      { subtitle = { speaker = 'MARCUS', text = 'Ouais... ça se voit un peu.', duration = 2600 } },
      { wait = 700 },
      { camera = 'two_shot', transition = { type = 'interp', duration = 900 } },
      -- [SUBTITLE] [VOICE SLOT] voice = 'marcus_03'
      { subtitle = { speaker = 'MARCUS', text = 'Allez, monte. Je vais te montrer un peu le coin.', duration = 3200 } },
      -- [ACTOR ACTION] a nod toward the car, then he heads back.
      { action = 'playAnim', actor = 'marcus', dict = 'gestures@m@standing@casual', anim = 'gesture_point', flag = 49 },
      { wait = 1400 },

      -- SHOT 04 — ENTER THE CAR --------------------------------------
      { action = 'enterVehicle', actor = 'marcus', vehicle = 'sedan', seat = -1 },
      { action = 'enterVehicle', actor = 'player', vehicle = 'sedan', seat = 0 },
      -- [IN-GAME TUNING] both actors need to be seated before departure.
      { wait = 5500 },
    },
  },

  -- ============================================================
  -- SHOT 05 / 06 — DEPARTURE & FIRST CITY REVEAL
  -- ============================================================
  {
    id = 'act1_departure',

    cameras = {
      -- [CAMERA] SHOT 05 — 3/4 rear roadside: the car takes the road.
      -- [IN-GAME TUNING] roadside placement along the LSIA exit.
      depart = {
        type = 'static',
        coords = vector3(-1027.0, -2721.0, 21.5),
        lookAtActor = 'sedan',
        fov = 40.0,
      },

      -- [CAMERA] SHOT 06 — the reveal: rises off the road and swings
      -- toward the skyline while the car shrinks below.
      -- [IN-GAME TUNING] the whole ascent — this is the first wow shot.
      reveal = {
        type = 'move',
        from = { coords = vector3(-1010.0, -2680.0, 28.0), fov = 45.0 },
        to = { coords = vector3(-950.0, -2560.0, 240.0), fov = 40.0 },
        duration = 9000,
        easing = 'easeInOut',
        lookAt = vector3(-180.0, -880.0, 180.0),
      },
    },

    timeline = {
      -- SHOT 05 — DEPARTURE ------------------------------------------
      { camera = 'depart', transition = { type = 'cut' } },
      -- [ACTOR ACTION] real road, toward the city.
      { action = 'driveTo', actor = 'sedan', driver = 'marcus', coords = vector3(-760.0, -2320.0, 14.0), speed = 17.0 },
      { wait = 4000 },

      -- SHOT 06 — FIRST CITY REVEAL ----------------------------------
      -- [TRANSITION] the camera abandons the car and climbs.
      { camera = 'reveal', transition = { type = 'interp', duration = 1600 } },
      { wait = 1200 },
      -- [SUBTITLE] [VOICE SLOT] voice = 'marcus_04'
      { subtitle = { speaker = 'MARCUS', text = 'Enfin bref...', duration = 2000 } },
      { wait = 900 },
      -- [SUBTITLE] [VOICE SLOT] voice = 'marcus_05'
      -- Alternative line kept on hand: 'Bienvenue chez toi.'
      { subtitle = { speaker = 'MARCUS', text = 'Bienvenue à Los Santos.', duration = 3000 } },

      -- [MUSIC CUE — CITY MONTAGE START] -----------------------------
      { music = { action = 'play', fade = 2500 } },
      { wait = 3800 },
    },
  },

  -- ============================================================
  -- ACT II — CITY MONTAGE (image + music, no dialogue)
  -- ============================================================

  -- ============================================================
  -- SHOT 07 — SKYLINE HERO: lateral travelling between the towers.
  -- ============================================================
  {
    id = 'montage_skyline',

    cameras = {
      -- [CAMERA] parallax glide across Downtown, not a hovering freecam.
      -- [IN-GAME TUNING] path between the towers.
      hero = {
        type = 'move',
        from = { coords = vector3(-420.0, -820.0, 210.0), fov = 42.0 },
        to = { coords = vector3(-180.0, -740.0, 190.0), fov = 42.0 },
        duration = 6500,
        easing = 'linear',
        lookAt = vector3(-75.0, -820.0, 240.0),
      },
    },

    timeline = {
      { action = 'focusArea', coords = vector3(-260.0, -800.0, 60.0) },
      -- [TRANSITION] fade hides the jump from the airport reveal.
      { camera = 'hero', transition = { type = 'fade', duration = 500 } },
      { wait = 6200 },
    },
  },

  -- ============================================================
  -- SHOT 08 — CITY AVENUE: low camera, traffic crossing the frame.
  -- ============================================================
  {
    id = 'montage_avenue',

    actors = {
      -- Cinematic traffic: local cars driven through the frame.
      -- [IN-GAME TUNING] lanes, spacing, speeds.
      { id = 'ave_car_a', type = 'vehicle', model = 'buffalo', coords = vector3(-560.0, -690.0, 33.0), heading = 90.0 },
      { id = 'ave_drv_a', type = 'ped', model = 'a_m_y_stlat_01', coords = vector3(-560.0, -690.0, 33.0), warpInto = 'ave_car_a' },
      { id = 'ave_car_b', type = 'vehicle', model = 'asea', coords = vector3(-380.0, -698.0, 32.5), heading = 270.0 },
      { id = 'ave_drv_b', type = 'ped', model = 'a_f_y_business_02', coords = vector3(-380.0, -698.0, 32.5), warpInto = 'ave_car_b' },
    },

    cameras = {
      -- [CAMERA] slightly above the roadway, slow rise.
      avenue = {
        type = 'move',
        from = { coords = vector3(-470.0, -680.0, 34.5), fov = 48.0 },
        to = { coords = vector3(-466.0, -676.0, 38.5), fov = 45.0 },
        duration = 5500,
        easing = 'easeOut',
        lookAt = vector3(-420.0, -695.0, 33.0),
      },
    },

    timeline = {
      { action = 'focusArea', coords = vector3(-460.0, -690.0, 33.0) },
      -- [TRANSITION] cut: wide to street level.
      { camera = 'avenue' },
      { action = 'driveTo', actor = 'ave_car_a', driver = 'ave_drv_a', coords = vector3(-330.0, -690.0, 32.5), speed = 16.0 },
      { action = 'driveTo', actor = 'ave_car_b', driver = 'ave_drv_b', coords = vector3(-600.0, -700.0, 33.5), speed = 14.0 },
      { wait = 5200 },
      { action = 'deleteActor', actor = 'ave_car_a' },
      { action = 'deleteActor', actor = 'ave_drv_a' },
      { action = 'deleteActor', actor = 'ave_car_b' },
      { action = 'deleteActor', actor = 'ave_drv_b' },
    },
  },

  -- ============================================================
  -- SHOT 09 — STREET LIFE: a human-scale beat, a few extras.
  -- ============================================================
  {
    id = 'montage_street',

    actors = {
      -- Cinematic extras. Nobody's story, just life.
      -- [IN-GAME TUNING] positions and scenario picks.
      { id = 'st_coffee', type = 'ped', model = 'a_f_y_hipster_02', coords = vector3(120.5, -1024.0, 29.3), heading = 340.0, scenario = 'WORLD_HUMAN_AA_COFFEE' },
      { id = 'st_phone', type = 'ped', model = 'a_m_y_business_02', coords = vector3(124.0, -1021.5, 29.3), heading = 200.0, scenario = 'WORLD_HUMAN_STAND_MOBILE' },
      { id = 'st_walker', type = 'ped', model = 'a_f_y_business_04', coords = vector3(108.0, -1030.0, 29.3), heading = 70.0 },
    },

    cameras = {
      -- [CAMERA] medium shot, gentle push through the sidewalk scene.
      sidewalk = {
        type = 'move',
        from = { coords = vector3(112.0, -1017.0, 30.5), fov = 40.0 },
        to = { coords = vector3(116.5, -1019.5, 30.2), fov = 36.0 },
        duration = 5000,
        easing = 'easeInOut',
        lookAt = vector3(122.0, -1023.0, 29.8),
      },
    },

    timeline = {
      { action = 'focusArea', coords = vector3(118.0, -1022.0, 29.3) },
      -- [TRANSITION] cut on matching left-to-right energy.
      { camera = 'sidewalk' },
      { action = 'walkTo', actor = 'st_walker', coords = vector3(130.0, -1018.0, 29.3), speed = 1.0 },
      { wait = 5000 },
      { action = 'deleteActor', actor = 'st_coffee' },
      { action = 'deleteActor', actor = 'st_phone' },
      { action = 'deleteActor', actor = 'st_walker' },
    },
  },

  -- ============================================================
  -- SHOT 10 — LANDMARK: Pillbox, purely cinematic.
  -- ============================================================
  {
    id = 'montage_pillbox',

    actors = {
      -- [IN-GAME TUNING] the ambulance bay outside Pillbox.
      { id = 'pb_amb', type = 'vehicle', model = 'ambulance', coords = vector3(294.5, -603.0, 43.0), heading = 70.0 },
      { id = 'pb_medic', type = 'ped', model = 's_m_m_paramedic_01', coords = vector3(297.5, -600.5, 43.2), heading = 160.0, scenario = 'WORLD_HUMAN_CLIPBOARD' },
      { id = 'pb_medic_b', type = 'ped', model = 's_f_y_scrubs_01', coords = vector3(299.0, -602.5, 43.2), heading = 20.0, scenario = 'WORLD_HUMAN_STAND_IMPATIENT' },
    },

    cameras = {
      -- [CAMERA] pass-by along the entrance.
      pillbox = {
        type = 'move',
        from = { coords = vector3(310.0, -594.0, 45.5), fov = 42.0 },
        to = { coords = vector3(302.0, -589.0, 44.8), fov = 40.0 },
        duration = 5000,
        easing = 'easeInOut',
        lookAt = vector3(296.0, -601.0, 43.8),
      },
    },

    timeline = {
      { action = 'focusArea', coords = vector3(300.0, -598.0, 43.2) },
      { camera = 'pillbox', transition = { type = 'fade', duration = 400 } },
      -- [LOCATION CUE] cinematic only — no tutorial line.
      { location = { title = 'PILLBOX', subtitle = 'Medical District', duration = 4000 } },
      { wait = 4800 },
      { action = 'deleteActor', actor = 'pb_amb' },
      { action = 'deleteActor', actor = 'pb_medic' },
      { action = 'deleteActor', actor = 'pb_medic_b' },
    },
  },

  -- ============================================================
  -- SHOT 11 — DIFFERENT ATMOSPHERE: Vespucci, air after Downtown.
  -- ============================================================
  {
    id = 'montage_vespucci',

    cameras = {
      -- [CAMERA] slow lateral along the beach line, palms in frame.
      -- [IN-GAME TUNING] time of day decides how good this looks.
      beach = {
        type = 'move',
        from = { coords = vector3(-1310.0, -1400.0, 12.0), fov = 46.0 },
        to = { coords = vector3(-1250.0, -1450.0, 10.0), fov = 44.0 },
        duration = 6000,
        easing = 'linear',
        lookAt = vector3(-1420.0, -1520.0, 4.0),
      },
    },

    timeline = {
      { action = 'focusArea', coords = vector3(-1290.0, -1440.0, 6.0) },
      -- [TRANSITION] fade: full change of atmosphere.
      { camera = 'beach', transition = { type = 'fade', duration = 450 } },
      { wait = 5800 },
    },
  },

  -- ============================================================
  -- SHOT 12 — URBAN DETAIL: one fast machine through a low frame.
  -- ============================================================
  {
    id = 'montage_detail',

    actors = {
      { id = 'dt_sport', type = 'vehicle', model = 'jester', coords = vector3(-620.0, -880.0, 24.5), heading = 90.0 },
      { id = 'dt_drv', type = 'ped', model = 'a_m_y_vinewood_03', coords = vector3(-620.0, -880.0, 24.5), warpInto = 'dt_sport' },
    },

    cameras = {
      -- [CAMERA] low at the intersection; the car rips across.
      intersection = {
        type = 'static',
        coords = vector3(-540.0, -874.0, 25.6),
        lookAt = vector3(-560.0, -882.0, 24.8),
        fov = 50.0,
      },
    },

    timeline = {
      { action = 'focusArea', coords = vector3(-560.0, -880.0, 24.5) },
      -- [TRANSITION] cut, movement match with the beach glide.
      { camera = 'intersection' },
      { action = 'driveTo', actor = 'dt_sport', driver = 'dt_drv', coords = vector3(-420.0, -880.0, 25.5), speed = 30.0 },
      { wait = 3800 },
      { action = 'deleteActor', actor = 'dt_sport' },
      { action = 'deleteActor', actor = 'dt_drv' },
    },
  },

  -- ============================================================
  -- SHOT 13 — WORKING CITY: the port, containers, activity.
  -- ============================================================
  {
    id = 'montage_port',

    actors = {
      { id = 'port_truck', type = 'vehicle', model = 'hauler', coords = vector3(-388.0, -2626.0, 6.0), heading = 320.0 },
      { id = 'port_worker', type = 'ped', model = 's_m_y_construct_01', coords = vector3(-382.0, -2620.0, 6.0), heading = 140.0, scenario = 'WORLD_HUMAN_WELDING' },
      { id = 'port_worker_b', type = 'ped', model = 's_m_m_dockwork_01', coords = vector3(-392.0, -2618.0, 6.0), heading = 250.0, scenario = 'WORLD_HUMAN_CLIPBOARD' },
    },

    cameras = {
      -- [CAMERA] slow rise between the container rows.
      port = {
        type = 'move',
        from = { coords = vector3(-398.0, -2612.0, 8.0), fov = 44.0 },
        to = { coords = vector3(-402.0, -2606.0, 18.0), fov = 42.0 },
        duration = 5500,
        easing = 'easeIn',
        lookAt = vector3(-385.0, -2622.0, 8.0),
      },
    },

    timeline = {
      { action = 'focusArea', coords = vector3(-390.0, -2620.0, 6.0) },
      -- [TRANSITION] cut.
      { camera = 'port' },
      { wait = 5300 },
      { action = 'deleteActor', actor = 'port_truck' },
      { action = 'deleteActor', actor = 'port_worker' },
      { action = 'deleteActor', actor = 'port_worker_b' },
    },
  },

  -- ============================================================
  -- SHOT 14 — FINAL HERO SHOT: street to full skyline.
  -- While the camera is up high, Marcus' car is silently staged
  -- near the destination for act III.
  -- ============================================================
  {
    id = 'montage_hero',

    cameras = {
      -- [CAMERA] the trailer shot: starts low in the street, ends on the
      -- whole skyline. The music peaks here.
      -- [IN-GAME TUNING] the most important camera of the montage.
      ascent = {
        type = 'move',
        from = { coords = vector3(160.0, -920.0, 32.0), fov = 48.0 },
        to = { coords = vector3(60.0, -790.0, 260.0), fov = 40.0 },
        duration = 9000,
        easing = 'easeInOut',
        lookAt = vector3(-120.0, -700.0, 120.0),
      },
    },

    timeline = {
      { action = 'focusArea', coords = vector3(120.0, -860.0, 32.0) },
      -- [TRANSITION] rise/drop pairing with the port's final rise.
      { camera = 'ascent', transition = { type = 'fade', duration = 400 } },
      { wait = 3500 },
      -- [LOCATION CUE] minimal. The image does the talking.
      { location = { title = 'LOS SANTOS', duration = 4000 } },
      -- [ACTOR ACTION] invisible: the car (Marcus and the character
      -- inside) is staged near the destination while nobody watches.
      { action = 'teleport', actor = 'sedan', coords = DESTINATION.staging.coords, heading = DESTINATION.staging.heading },
      { wait = 5200 },
    },
  },

  -- ============================================================
  -- ACT III — RETURN TO THE PLAYER
  -- ============================================================

  -- ============================================================
  -- SHOT 15 / 16 — DESTINATION: the place first, then the car.
  -- ============================================================
  {
    id = 'act3_arrival',

    cameras = {
      -- [CAMERA] SHOT 15 — establishing from above, slow descent; the
      -- car enters the frame on its way down.
      establishing = {
        type = 'move',
        from = DESTINATION.establishing.from,
        to = DESTINATION.establishing.to,
        duration = DESTINATION.establishing.duration,
        easing = 'easeInOut',
        lookAt = DESTINATION.parking,
      },

      -- [CAMERA] SHOT 16 — curb level for the stop.
      curb = {
        type = 'static',
        coords = vector3(-265.5, -972.0, 32.4),
        lookAtActor = 'sedan',
        fov = 40.0,
      },
    },

    timeline = {
      { action = 'focusArea', coords = DESTINATION.parking },

      -- [MUSIC CUE — CITY MONTAGE END / FADE] ------------------------
      { music = { action = 'stop', fade = 6000 } },

      -- SHOT 15 — ESTABLISHING ---------------------------------------
      -- [TRANSITION] fade out of the hero shot, into the descent.
      { camera = 'establishing', transition = { type = 'fade', duration = 500 } },
      { action = 'driveTo', actor = 'sedan', driver = 'marcus', coords = DESTINATION.parking, speed = 10.0, stopRange = 3.0 },
      { wait = 6500 },

      -- SHOT 16 — CAR ARRIVAL ----------------------------------------
      { camera = 'curb', transition = { type = 'interp', duration = 1500 } },
      { action = 'waitArrival', actor = 'sedan', coords = DESTINATION.parking, radius = 6.0, timeout = 45000 },
      { wait = 1500 },
    },
  },

  -- ============================================================
  -- SHOT 17 / 18 — GOODBYE: last words, Marcus really leaves.
  -- ============================================================
  {
    id = 'act3_goodbye',

    cameras = {
      -- [CAMERA] SHOT 17 — two-shot at the curb.
      farewell = {
        type = 'static',
        coords = vector3(-263.8, -970.0, 32.2),
        lookAtActor = 'player',
        fov = 38.0,
      },

      -- [CAMERA] SHOT 18 — the car pulls away; the camera stays with it
      -- for a moment (pointAt follows the entity on its own).
      departure = {
        type = 'static',
        coords = vector3(-262.0, -975.5, 32.6),
        lookAtActor = 'sedan',
        fov = 42.0,
      },
    },

    timeline = {
      -- SHOT 17 — FINAL DIALOGUE -------------------------------------
      { camera = 'farewell', transition = { type = 'cut' } },
      -- [SUBTITLE] [VOICE SLOT] voice = 'marcus_06'
      { subtitle = { speaker = 'MARCUS', text = 'Voilà. On y est.', duration = 2400 } },
      { action = 'leaveVehicle', actor = 'player' },
      { wait = 2800 },
      { action = 'walkTo', actor = 'player', coords = DESTINATION.dropoff.coords, speed = 1.0, heading = DESTINATION.dropoff.heading },
      { wait = 1800 },
      -- [SUBTITLE] [VOICE SLOT] voice = 'marcus_07'
      { subtitle = { speaker = 'MARCUS', text = "Pour la suite... c'est à toi de jouer.", duration = 3200 } },
      { wait = 1000 },
      -- [SUBTITLE] [VOICE SLOT] voice = 'marcus_08'
      { subtitle = { speaker = 'MARCUS', text = 'Bonne chance.', duration = 2200 } },
      { wait = 800 },

      -- SHOT 18 — MARCUS LEAVES --------------------------------------
      { camera = 'departure', transition = { type = 'cut' } },
      -- [ACTOR ACTION] he genuinely drives off.
      { action = 'driveTo', actor = 'sedan', driver = 'marcus', coords = DESTINATION.exit, speed = 12.0 },
      { wait = 5000 },
      { action = 'deleteActor', actor = 'sedan' },
      { action = 'deleteActor', actor = 'marcus' },
    },
  },

  -- ============================================================
  -- SHOT 19 — SEAMLESS HANDOVER
  -- The camera swings behind the character and settles close to a
  -- gameplay framing; the engine then blends the rest of the way
  -- into the real gameplay camera and plays the World Reveal.
  -- ============================================================
  {
    id = 'act3_handover',

    cameras = {
      -- [CAMERA] [IN-GAME TUNING] `to` should end just about where the
      -- gameplay camera would rest behind the character.
      handover = {
        type = 'move',
        from = DESTINATION.handover.from,
        to = DESTINATION.handover.to,
        duration = DESTINATION.handover.duration,
        easing = 'easeInOut',
        lookAtActor = 'player',
      },
    },

    timeline = {
      -- [TRANSITION] one continuous move — no cut into gameplay.
      { camera = 'handover', transition = { type = 'interp', duration = 1200 } },
      { wait = DESTINATION.handover.duration },
      -- The engine takes over from here: gameplay blend + World Reveal.
    },
  },
}
