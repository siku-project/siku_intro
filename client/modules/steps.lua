local ENTER_TIMEOUT <const> = 15000

--- Every action a timeline step may name. A handler receives the step and
--- blocks for as long as the step should hold the timeline; overlapping
--- work (a drive, an animation) simply returns immediately and later steps
--- run alongside it.
local ACTIONS <const> = {}

function ACTIONS.teleport(step)
  local entity <const> = GetActor(step.actor)

  if entity then
    SetEntityCoordsNoOffset(entity, step.coords.x, step.coords.y, step.coords.z, false, false, false)

    if step.heading then
      SetEntityHeading(entity, step.heading)
    end
  end
end

function ACTIONS.clearTasks(step)
  local entity <const> = GetActor(step.actor)

  if entity then
    ClearPedTasks(entity)
  end
end

function ACTIONS.lookAt(step)
  local entity <const> = GetActor(step.actor)
  local target <const> = GetActor(step.target)

  if entity and target then
    TaskTurnPedToFaceEntity(entity, target, step.duration or -1)
  end
end

function ACTIONS.playAnim(step)
  local entity <const> = GetActor(step.actor)

  if not entity then
    return
  end

  if not Siku.streaming.requestAnimDict(step.dict, IntroConfig.loadTimeout) then
    return
  end

  TaskPlayAnim(entity, step.dict, step.anim, 4.0, -4.0, step.duration or -1, step.flag or 1, 0.0, false, false, false)
end

function ACTIONS.playScenario(step)
  local entity <const> = GetActor(step.actor)

  if entity then
    TaskStartScenarioInPlace(entity, step.scenario, 0, true)
  end
end

function ACTIONS.walkTo(step)
  local entity <const> = GetActor(step.actor)

  if entity then
    TaskGoStraightToCoord(entity, step.coords.x, step.coords.y, step.coords.z, step.speed or 1.0, -1, step.heading or 0.0, 0.5)
  end
end

function ACTIONS.enterVehicle(step)
  local entity <const> = GetActor(step.actor)
  local vehicle <const> = GetActor(step.vehicle)

  if entity and vehicle then
    SetVehicleDoorsLocked(vehicle, 1)
    TaskEnterVehicle(entity, vehicle, ENTER_TIMEOUT, step.seat or -1, step.speed or 1.0, 1, 0)
  end
end

function ACTIONS.leaveVehicle(step)
  local entity <const> = GetActor(step.actor)

  if entity then
    local vehicle <const> = GetVehiclePedIsIn(entity, false)

    if vehicle ~= 0 then
      TaskLeaveVehicle(entity, vehicle, 0)
    end
  end
end

function ACTIONS.driveTo(step)
  local vehicle <const> = GetActor(step.actor)
  local driver <const> = GetActor(step.driver)

  if vehicle and driver then
    TaskVehicleDriveToCoordLongrange(
      driver,
      vehicle,
      step.coords.x,
      step.coords.y,
      step.coords.z,
      step.speed or IntroConfig.driving.speed,
      step.style or IntroConfig.driving.style,
      step.stopRange or 8.0
    )
  end
end

function ACTIONS.waitArrival(step)
  local entity <const> = GetActor(step.actor)

  if not entity then
    return
  end

  local radius <const> = step.radius or 10.0
  local deadline <const> = GetGameTimer() + (step.timeout or 60000)

  while IntroActive and GetGameTimer() < deadline do
    if #(GetEntityCoords(entity) - step.coords) <= radius then
      return
    end

    Wait(250)
  end
end

function ACTIONS.deleteActor(step)
  DeleteActor(step.actor)
end

--- Streams the world around a distant point, so a camera far from the
--- player never reveals an unloaded scene. Cleared with clearFocus once
--- the shots there are done.
function ACTIONS.focusArea(step)
  SetFocusPosAndVel(step.coords.x, step.coords.y, step.coords.z, 0.0, 0.0, 0.0)
  RequestCollisionAtCoord(step.coords.x, step.coords.y, step.coords.z)
end

function ACTIONS.clearFocus()
  ClearFocus()
end

function ACTIONS.freeze(step)
  local entity <const> = GetActor(step.actor)

  if entity then
    FreezeEntityPosition(entity, step.frozen ~= false)
  end
end

--- Runs one timeline step. Steps are small tables read from the scene
--- configuration; an unknown shape is reported and skipped so a typo in
--- the scenario never strands the player mid-cinematic.
---@param step table The step.
---@return nil
function RunStep(step)
  if type(step) ~= 'table' then
    return
  end

  if step.wait then
    local deadline <const> = GetGameTimer() + step.wait

    while IntroActive and GetGameTimer() < deadline do
      Wait(50)
    end

    return
  end

  if step.fade then
    local duration <const> = step.duration or 800

    if step.fade == 'in' then
      DoScreenFadeIn(duration)
    else
      DoScreenFadeOut(duration)

      while IntroActive and not IsScreenFadedOut() do
        Wait(0)
      end
    end

    return
  end

  if step.camera then
    ActivateCamera(step.camera, step.transition)

    return
  end

  if step.location then
    IntroPush('showLocation', step.location)

    return
  end

  if step.subtitle then
    IntroPush('showSubtitle', step.subtitle)

    if step.subtitle.duration then
      RunStep({ wait = step.subtitle.duration })
    end

    return
  end

  if step.message then
    IntroPush('showMessage', step.message)

    return
  end

  if step.sound then
    PlaySoundFrontend(-1, step.sound.name, step.sound.set or '', true)

    return
  end

  if step.music then
    local cue <const> = step.music

    IntroPush('music', {
      action = cue.action,
      file = cue.file or IntroConfig.music.montage,
      volume = cue.volume or IntroConfig.music.volume,
      fade = cue.fade,
    })

    return
  end

  if step.action then
    local handler <const> = ACTIONS[step.action]

    if handler then
      handler(step)
    else
      Siku.print.warn(('Intro step names an unknown action %q'):format(tostring(step.action)))
    end

    return
  end

  Siku.print.warn('Intro step has no recognizable shape and was skipped')
end
