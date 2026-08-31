local started <const> = {}

--- Starts the introduction for a player. The character resource calls
--- this once a fresh character is ready, while the player still sits in
--- the private instance it prepared — the introduction plays there and
--- never touches the bucket itself before the end.
---@param sessionId number The player server id.
---@return boolean startedNow Whether the introduction was launched.
local function start(sessionId)
  if type(sessionId) ~= 'number' or started[sessionId] then
    return false
  end

  if not GetPlayerPing(tostring(sessionId)) or GetPlayerPing(tostring(sessionId)) <= 0 then
    return false
  end

  started[sessionId] = true
  TriggerClientEvent('siku_intro:client:start', sessionId)

  return true
end

RegisterNetEvent('siku_intro:server:finished', function()
  local sessionId <const> = source

  if not started[sessionId] then
    return
  end

  started[sessionId] = nil

  if IntroConfig.releaseBucket then
    Siku.bucket.releasePlayerInstance(sessionId)
  end

  TriggerEvent('siku:intro:finished', sessionId)
end)

AddEventHandler('playerDropped', function()
  started[source] = nil
end)

exports('Start', start)
