--- Puts the player back into a playable state, whatever happened: actors
--- gone, cameras destroyed, interface cleared, HUD and controls restored.
--- Safe to call twice — everything it touches tolerates already being
--- clean.
---@return nil
function CleanupIntro()
  IntroActive = false

  DeleteAllActors()
  DestroyIntroCameras()
  ClearFocus()

  IntroPush('setActive', { active = false })

  local ped <const> = PlayerPedId()

  SetEntityInvincible(ped, false)
  FreezeEntityPosition(ped, false)
  ClearPedTasks(ped)

  if IntroConfig.hideHud then
    DisplayRadar(true)

    if GetResourceState('siku_hud') == 'started' then
      exports.siku_hud:SetVisible(true)
    end
  end

  if not IsScreenFadedIn() then
    DoScreenFadeIn(IntroConfig.finalFade)
  end
end

AddEventHandler('onResourceStop', function(resource)
  if resource ~= GetCurrentResourceName() then
    return
  end

  if IntroActive then
    CleanupIntro()
  end
end)
