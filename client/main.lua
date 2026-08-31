--- Pushes the active language and its translations to the NUI.
---@return nil
local function sendLocale()
  SendNUIMessage({
    action = 'siku_intro:nui:setLocale',
    locale = {
      language = TranslationConfig.language,
      translations = Siku.locale.translations(),
    },
  })
end

RegisterNUICallback('siku_intro:nui:ready', function(_, cb)
  sendLocale()
  cb({})
end)
