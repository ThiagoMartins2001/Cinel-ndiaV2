--  _    _                         _   _      _                      _    
-- | |  | |                       | \ | |    | |                    | |   
-- | |__| | __ _ _ __ _ __ _   _  |  \| | ___| |___      _____  _ __| | __
-- |  __  |/ _` | '__| '__| | | | | . ` |/ _ \ __\ \ /\ / / _ \| '__| |/ /
-- | |  | | (_| | |  | |  | |_| | | |\  |  __/ |_ \ V  V / (_) | |  |   < 
-- |_|  |_|\__,_|_|  |_|   \__, | |_| \_|\___|\__| \_/\_/ \___/|_|  |_|\_\
--                          __/ |                                         
--                         |___/                                          
-- Script disponibilizado de forma gratuita em https://discord.gg/vbwtqBbU2p | SE VENDER É GUEI



local quickCoords = false

local copyCoords = false

RegisterCommand(Config.CoordenadasDisplay, function()
  quickCoords = not quickCoords
  SendNUIMessage({
    quickCoords = quickCoords
  })
end, false)

RegisterCommand(Config.MenuCoordenadas, function()
  copyCoords = not copyCoords
  SendNUIMessage({
    copyCoords = copyCoords,
    cCoords = GetEntityCoords(PlayerPedId()),
    cHeading = GetEntityHeading(PlayerPedId())
  })
  SetNuiFocus(copyCoords, copyCoords)
end, false)

RegisterNUICallback("closeCopy", function()
  ExecuteCommand(Config.MenuCoordenadas)
end)

CreateThread(function()
  while true do 
    Wait(3000)
    while quickCoords do
      Wait(50)
      SendNUIMessage({
        coords = GetEntityCoords(PlayerPedId()),
        heading = GetEntityHeading(PlayerPedId())
      })
    end
  end
end)