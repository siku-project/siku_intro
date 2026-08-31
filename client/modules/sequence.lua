--- Keeps gameplay inputs away from the character for as long as the
--- introduction runs. One light loop, gone the moment the flag drops.
---@return nil
local function holdControls()
  CreateThread(function()
    while IntroActive do
      DisableAllControlActions(0)
      Wait(0)
    end
  end)
end

--- Prepares the character and the screen for the cinematic.
---@return nil
local function enterCinematic()
  local ped <const> = PlayerPedId()

  DoScreenFadeOut(0)

  if IntroConfig.invincible then
    SetEntityInvincible(ped, true)
  end

  if IntroConfig.hideHud then
    DisplayRadar(false)

    if GetResourceState('siku_hud') == 'started' then
      exports.siku_hud:SetVisible(false)
    end
  end

  IntroPush('setActive', { active = true })
  holdControls()
end

--- Plays one scene: its actors, its cameras, then its timeline.
---@param scene table The scene definition.
---@return boolean completed Whether the scene ran to its end.
local function playScene(scene)
  for index = 1, #(scene.actors or {}) do
    SpawnActor(scene.actors[index])
  end

  SetSceneCameras(scene.cameras)

  local timeline <const> = scene.timeline or {}

  for index = 1, #timeline do
    if not IntroActive then
      return false
    end

    local ok <const>, err <const> = pcall(RunStep, timeline[index])

    if not ok then
      Siku.print.error(('Intro scene %q failed at step %d: %s'):format(scene.id, index, tostring(err)))

      return false
    end
  end

  return IntroActive
end

--- The World Reveal placeholder: a subtle cold focus pulse the moment the
--- character enters the world. The real Aurora wave effect replaces the
--- body of this function, nothing else has to move.
---@return nil
local function playWorldReveal()
  AnimpostfxPlay('FocusIn', 0, false)
end

--- Ends the introduction.
---
--- A completed run never shows a loading seam: the scripted camera glides
--- back into the gameplay camera, the World Reveal pulses, and by the time
--- the player realizes the cinematic is over they can already move. An
--- aborted run falls back to a plain fade so nothing broken stays on
--- screen.
---@param completed boolean Whether every scene ran.
---@return nil
local function finishIntro(completed)
  if completed then
    Siku.camera.stopRendering(true, IntroConfig.handover.blend)
    Wait(IntroConfig.handover.blend)
    playWorldReveal()
    CleanupIntro()
    TriggerServerEvent('siku_intro:server:finished')

    return
  end

  DoScreenFadeOut(0)

  while not IsScreenFadedOut() do
    Wait(0)
  end

  CleanupIntro()
  TriggerServerEvent('siku_intro:server:finished')
  Wait(500)
  DoScreenFadeIn(IntroConfig.finalFade)
end

--- Runs the whole introduction, scene after scene.
---@return nil
function RunIntro()
  if IntroActive then
    return
  end

  IntroActive = true
  enterCinematic()

  local completed = true

  for index = 1, #IntroScenes do
    if not playScene(IntroScenes[index]) then
      completed = false

      break
    end
  end

  finishIntro(completed)
end

RegisterNetEvent('siku_intro:client:start', function()
  CreateThread(RunIntro)
end)
