local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

vSERVER = Tunnel.getInterface("pressurewasher")

AddEventHandler('pwasher:onPumpBreak', function()
    TriggerEvent("Notify", 'vermelho', "Você quebrou a maquina e vai pagar o valor de $" .. Config.PumpBreakFee .. "!", 5000)
    vSERVER.checkPayment(Config.PumpBreakFee)
end)

AddEventHandler('pwasher:requestEquipPump', function()
    local payment = vSERVER.checkPayment(Config.PumpUsePrice)
    if payment then
        TriggerEvent("pwasher:equipPump")
    else
        TriggerEvent("Notify", 'vermelho', 'Você não possui dinheiro suficiente para isso.', 5000)
    end
end)

AddEventHandler('pwasher:playSplashParticle', function(pname, posx, posy, posz, heading)
	Citizen.CreateThread(function()
        UseParticleFxAssetNextCall("core")
        local pfx = StartParticleFxLoopedAtCoord(pname, posx, posy, posz, 0.0, 0.0, heading, 1.0, false, false, false, false)
        Citizen.Wait(100)
        StopParticleFxLooped(pfx, 0)
    end)
    Wait(5000)
    local veh = vRP.ClosestVehicle(2)
    print(veh, 'aq fora')
    if veh then
        print('aq', veh)
        SetVehicleFixed(veh)
    end
end)

AddEventHandler('pwasher:playWaterParticle', function(pname, entity, density)
	Citizen.CreateThread(function()
        for i = 0, density, 1 do
            UseParticleFxAssetNextCall("core")
            StartParticleFxNonLoopedOnEntity(pname, objID, 0.5, 0.0, 0.0, 90.0, 0.0, -90.0, 1.0, true, true, true)
        end
    end)
end)

Citizen.CreateThread(function()
    RequestNamedPtfxAsset("core")
    while not HasNamedPtfxAssetLoaded("core") do
         Citizen.Wait(1)
    end
end)

function ShowNotification(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(0,1)
end