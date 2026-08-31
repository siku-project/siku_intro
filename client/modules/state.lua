IntroActive = false

--- Sends an intro action and its payload to the interface.
---@param action string The NUI action suffix.
---@param payload table? The payload to forward.
function IntroPush(action, payload)
  SendNUIMessage({
    action = ('siku_intro:nui:%s'):format(action),
    payload = payload or {},
  })
end
