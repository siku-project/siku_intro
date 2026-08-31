local PLAYER_ID <const> = 'player'

local actors <const> = {}

--- The entity behind an actor id.
---@param id string The actor id.
---@return number? entity The entity handle, or nil.
function GetActor(id)
  if id == PLAYER_ID then
    return PlayerPedId()
  end

  local actor <const> = actors[id]

  if actor and DoesEntityExist(actor.entity) then
    return actor.entity
  end

  return nil
end

--- Places the real character for a scene.
---@param definition table The actor definition.
---@return nil
local function placePlayer(definition)
  local ped <const> = PlayerPedId()

  if definition.coords then
    SetEntityCoordsNoOffset(ped, definition.coords.x, definition.coords.y, definition.coords.z, false, false, false)
  end

  if definition.heading then
    SetEntityHeading(ped, definition.heading)
  end

  ClearPedTasksImmediately(ped)
end

--- Spawns one cinematic actor. Peds, vehicles and props are created
--- locally: nobody shares the instance, and a local entity costs the
--- network nothing.
---@param definition table The actor definition { id, type, model?, coords, heading?, scenario?, invincible? }.
---@return boolean spawned Whether the actor exists once this returns.
function SpawnActor(definition)
  if type(definition) ~= 'table' or type(definition.id) ~= 'string' then
    return false
  end

  if definition.type == PLAYER_ID then
    placePlayer(definition)

    return true
  end

  if actors[definition.id] then
    return true
  end

  local model <const> = joaat(definition.model)

  if not Siku.streaming.requestModel(model, IntroConfig.loadTimeout) then
    Siku.print.error(('Intro actor %q: model %s never loaded'):format(definition.id, definition.model))

    return false
  end

  local coords <const> = definition.coords
  local heading <const> = definition.heading or 0.0
  local entity

  if definition.type == 'vehicle' then
    entity = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, false)
    SetVehicleOnGroundProperly(entity)
    SetVehicleDoorsLocked(entity, 2)
  elseif definition.type == 'prop' then
    entity = CreateObjectNoOffset(model, coords.x, coords.y, coords.z, false, false, false)
  else
    entity = CreatePed(4, model, coords.x, coords.y, coords.z, heading, false, false)
    SetBlockingOfNonTemporaryEvents(entity, true)
    SetPedFleeAttributes(entity, 0, false)
    SetPedKeepTask(entity, true)

    if definition.scenario then
      TaskStartScenarioInPlace(entity, definition.scenario, 0, true)
    end
  end

  SetModelAsNoLongerNeeded(model)

  if not DoesEntityExist(entity) then
    Siku.print.error(('Intro actor %q could not be created'):format(definition.id))

    return false
  end

  SetEntityInvincible(entity, definition.invincible ~= false)
  FreezeEntityPosition(entity, definition.type == 'prop')

  actors[definition.id] = { entity = entity, kind = definition.type }

  if definition.warpInto then
    local vehicle <const> = GetActor(definition.warpInto)

    if vehicle then
      SetPedIntoVehicle(entity, vehicle, definition.seat or -1)
    end
  end

  return true
end

--- Deletes one cinematic actor. The player is never deleted.
---@param id string The actor id.
---@return nil
function DeleteActor(id)
  local actor <const> = actors[id]

  actors[id] = nil

  if actor and DoesEntityExist(actor.entity) then
    DeleteEntity(actor.entity)
  end
end

--- Deletes every cinematic actor.
---@return nil
function DeleteAllActors()
  for id in pairs(actors) do
    DeleteActor(id)
  end
end
