local definitions = {}
local handles <const> = {}
local currentHandle = nil

--- Registers the camera definitions of the running scene. Handles are
--- created lazily on first activation, so a camera never rendered costs
--- nothing.
---@param cameras table? The scene camera definitions, keyed by id.
---@return nil
function SetSceneCameras(cameras)
  definitions = cameras or {}
end

--- Where a camera definition should look, resolved at activation time.
---@param definition table The camera definition.
---@return vector3|number? target Coords, an entity, or nil.
local function resolveLookAt(definition)
  if definition.lookAtActor then
    return GetActor(definition.lookAtActor)
  end

  return definition.lookAt
end

--- Builds the camera behind a definition.
---@param id string The camera id.
---@param definition table The camera definition.
---@return number? handle The camera handle, or nil.
local function buildCamera(id, definition)
  if definition.type == 'spline' then
    return Siku.camera.createSpline({
      nodes = definition.nodes,
      duration = definition.duration,
      fov = definition.fov,
    })
  end

  local origin <const> = definition.type == 'move' and definition.from or definition
  local handle <const> = Siku.camera.create({
    coords = origin.coords,
    fov = origin.fov or definition.fov,
  })

  local target <const> = resolveLookAt(definition)

  if type(target) == 'number' then
    Siku.camera.pointAtEntity(handle, target, definition.lookAtOffset)
  elseif target then
    Siku.camera.pointAtCoords(handle, target)
  end

  if definition.type == 'attach' then
    local entity <const> = GetActor(definition.actor)

    if entity then
      Siku.camera.attachToEntity(handle, entity, definition.offset, true)
    end
  end

  return handle
end

--- Renders a scene camera, through a transition. 'cut' swaps instantly,
--- 'fade' hides the swap behind a short fade, 'interp' glides from the
--- rendering camera to this one. The gameplay camera is never shown
--- between two scripted ones.
---@param id string The camera id.
---@param transition table? The transition { type, duration?, easing? }.
---@return nil
function ActivateCamera(id, transition)
  local definition <const> = definitions[id]

  if not definition then
    Siku.print.warn(('Intro camera %q is not declared by the scene'):format(tostring(id)))

    return
  end

  if not handles[id] or not Siku.camera.exists(handles[id]) then
    handles[id] = buildCamera(id, definition)
  end

  local handle <const> = handles[id]

  if not handle then
    return
  end

  local kind <const> = transition and transition.type or 'cut'

  if kind == 'fade' and IntroActive then
    local duration <const> = (transition and transition.duration or 400) // 2

    DoScreenFadeOut(duration)

    while not IsScreenFadedOut() do
      Wait(0)
    end

    Siku.camera.render(handle)
    DoScreenFadeIn(duration)
  elseif kind == 'interp' and currentHandle then
    Siku.camera.switchTo(handle, transition and transition.duration, transition and transition.easing)
  else
    Siku.camera.render(handle)
  end

  currentHandle = handle

  if definition.type == 'move' then
    Siku.camera.moveTo(handle, definition.to, definition.duration, definition.easing)
  end
end

--- Destroys every intro camera and hands the screen back to gameplay.
---@return nil
function DestroyIntroCameras()
  Siku.camera.stopRendering()
  Siku.camera.destroyAll()

  for id in pairs(handles) do
    handles[id] = nil
  end

  definitions = {}
  currentHandle = nil
end
