Config = {}

-- IMPOSSIBILITADO DE UTILIZAR TARGET NO MOMENTO
Config.UseTarget = false -- Defina como verdadeiro para usar o Terceiro Olho, caso contrário, falso
Config.Webhook = "https://discord.com/api/webhooks/1249583959684157532/kXA0fEjh03l_gbctXsoXbxrlmoD5c4bVn_ifwZf-fajMOUbdlXqWDA6D6xCpJhZjyp2c"

-- Se verdadeiro, exibe a sobreposição da câmera corporal no usuário da tela da câmera corporal quando a câmera corporal está ligada
Config.SelfOverlay = true
Config.CustomImage = "xion.png"
Config.PlayBeep = true
Config.BeepSound = "beepbeep.wav"
Config.Jobs = {
    ['Police']  = {job = "Police", display = "Police", grade = 0},
}

-- The Locations to access Body Cam menu, job is the required job from Config.Jobs above
Config.Locations = {
    { coords = vector3(-591.13,-1034.79,22.39), job = "Police" }, ---------- PMESP
    { coords = vector3(-1137.7,-2273.36,14.81), job = "Police" },  ------- ROTA
    { coords = vector3(-501.98,294.66,83.44), job = "Police" },  ------- CIVIL
}

-- -- -- Box zones if using Config.Target = true to access Body Cam menu, job is the required job from Config.Jobs above
-- Config.Targets = {
--     { coords = vector3(386.93, 792.48, 187.69), width = 1.5, height = 1.5, job = "Police"}, 
--     { coords = vector3(447.97, -973.38, 30.69), width = 1.5, height = 1.5, job = "Police" },  
--     { coords = vector3(437.03, -996.21, 30.69), width = 1.5, height = 1.5, job = "Police" },
-- }