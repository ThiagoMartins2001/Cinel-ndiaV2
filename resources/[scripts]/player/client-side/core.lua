-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("player",Creative)
vSERVER = Tunnel.getInterface("player")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Meth = 0
local Drunk = 0
local Cocaine = 0
local Energetic = 0
local Residuals = nil
LocalPlayer["state"]["Tea"] = 3600
LocalPlayer["state"]["Handcuff"] = false
LocalPlayer["state"]["Commands"] = false
LocalPlayer["state"]["Rope"] = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:COMMANDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:Commands")
AddEventHandler("player:Commands",function(status)
	LocalPlayer["state"]["Commands"] = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PLAYERCARRY
-----------------------------------------------------------------------------------------------------------------------------------------
local playerCarry = false
RegisterNetEvent("player:playerCarry")
AddEventHandler("player:playerCarry",function(entity,mode)
	if playerCarry then
		DetachEntity(PlayerPedId(),false,false)
		playerCarry = false
	else
		if mode == "handcuff" then
			AttachEntityToEntity(PlayerPedId(),GetPlayerPed(GetPlayerFromServerId(entity)),11816,0.0,0.5,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
		else
			AttachEntityToEntity(PlayerPedId(),GetPlayerPed(GetPlayerFromServerId(entity)),11816,0.6,0.0,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
		end

		playerCarry = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:ROPECARRY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:ropeCarry")
AddEventHandler("player:ropeCarry",function(Entity)
	if LocalPlayer["state"]["Rope"] then
		DetachEntity(PlayerPedId(),false,false)
		LocalPlayer["state"]:set("Rope",false,true)
	else
		LocalPlayer["state"]:set("Rope",true,true)
		AttachEntityToEntity(PlayerPedId(),GetPlayerPed(GetPlayerFromServerId(Entity)),0,0.20,0.12,0.63,0.5,0.5,0.0,false,false,false,false,2,false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADROPEANIM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Rope"] then
			TimeDistance = 1
			local Ped = PlayerPedId()
			if not IsEntityPlayingAnim(Ped,"nm","firemans_carry",3) then
				vRP.playAnim(false,{"nm","firemans_carry"},true)
				vRPC.playAnim(source,true,{"missfinale_c2mcs_1","fin_c2_mcs_1_camman"},true)
			end

			DisableControlAction(0,23,true)
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATSHUFFLE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) then
			TimeDistance = 100

			if not GetPedConfigFlag(Ped,184,true) then
				SetPedConfigFlag(Ped,184,true)
			end

			local Vehicle = GetVehiclePedIsIn(Ped)
			if GetPedInVehicleSeat(Vehicle,0) == Ped then
				if GetIsTaskActive(Ped,165) then
					SetPedIntoVehicle(Ped,Vehicle,0)
				end
			end
		else
			if GetPedConfigFlag(Ped,184,true) then
				SetPedConfigFlag(Ped,184,false)
			end
		end

		Wait(100)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETENERGETIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("setEnergetic")
AddEventHandler("setEnergetic",function(Timer,Number)
	Energetic = Energetic + Timer
	SetRunSprintMultiplierForPlayer(PlayerId(),Number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETENERGETIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("resetEnergetic")
AddEventHandler("resetEnergetic",function()
	if Energetic > 0 then
		SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
		Energetic = 0
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADENERGETIC
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Energetic > 0 then
			Energetic = Energetic - 1
			RestorePlayerStamina(PlayerId(),1.0)

			if Energetic <= 0 or GetEntityHealth(PlayerPedId()) <= 100 then
				SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
				Energetic = 0
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETMETH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("setMeth")
AddEventHandler("setMeth",function()
	Meth = Meth + 80

	if not GetScreenEffectIsActive("DMT_flight") then
		StartScreenEffect("DMT_flight",0,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADMETH
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Meth > 0 then
			Meth = Meth - 1

			if Meth <= 0 or GetEntityHealth(PlayerPedId()) <= 100 then
				Meth = 0

				if GetScreenEffectIsActive("DMT_flight") then
					StopScreenEffect("DMT_flight")
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETCOCAINE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("setCocaine")
AddEventHandler("setCocaine",function()
	Cocaine = Cocaine + 80

	if not GetScreenEffectIsActive("MinigameTransitionIn") then
		StartScreenEffect("MinigameTransitionIn",0,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCOCAINE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Cocaine > 0 then
			Cocaine = Cocaine - 1

			if Cocaine <= 0 or GetEntityHealth(PlayerPedId()) <= 100 then
				Cocaine = 0

				if GetScreenEffectIsActive("MinigameTransitionIn") then
					StopScreenEffect("MinigameTransitionIn")
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETDRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("setDrunkTime")
AddEventHandler("setDrunkTime",function(Timer)
	Drunk = Drunk + Timer

	LocalPlayer["state"]["Drunk"] = true

	if LoadMovement("move_m@drunk@verydrunk") then
		SetPedMovementClipset(PlayerPedId(),"move_m@drunk@verydrunk",0.25)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Drunk > 0 then
			Drunk = Drunk - 1

			if Drunk <= 0 or GetEntityHealth(PlayerPedId()) <= 100 then
				ResetPedMovementClipset(PlayerPedId(),0.25)
				LocalPlayer["state"]["Drunk"] = false
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCHOODOPTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:syncHoodOptions")
AddEventHandler("player:syncHoodOptions",function(Network,Active)
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			if Active == "open" then
				SetVehicleDoorOpen(Vehicle,4,0,0)
			elseif Active == "close" then
				SetVehicleDoorShut(Vehicle,4,0)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCDOORSOPTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:syncDoorsOptions")
AddEventHandler("player:syncDoorsOptions",function(Network,Active)
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			if Active == "open" then
				SetVehicleDoorOpen(Vehicle,5,0,0)
			elseif Active == "close" then
				SetVehicleDoorShut(Vehicle,5,0)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCWINS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:syncWins")
AddEventHandler("player:syncWins",function(Network,Active)
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			if Active == "1" then
				RollUpWindow(Vehicle,0)
				RollUpWindow(Vehicle,1)
				RollUpWindow(Vehicle,2)
				RollUpWindow(Vehicle,3)
			else
				RollDownWindow(Vehicle,0)
				RollDownWindow(Vehicle,1)
				RollDownWindow(Vehicle,2)
				RollDownWindow(Vehicle,3)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCDOORS
-----------------------------------------------------------------------------------------------------------------------------------------
local doorStatus = { ["1"] = 0, ["2"] = 1, ["3"] = 2, ["4"] = 3, ["5"] = 5, ["6"] = 4 }
RegisterNetEvent("player:syncDoors")
AddEventHandler("player:syncDoors",function(Network,Active)
	if NetworkDoesNetworkIdExist(Network) then
		local v = NetToEnt(Network)
		if DoesEntityExist(v) and GetVehicleDoorLockStatus(v) == 1 then
			if doorStatus[Active] then
				if GetVehicleDoorAngleRatio(v,doorStatus[Active]) == 0 then
					SetVehicleDoorOpen(v,doorStatus[Active],0,0)
				else
					SetVehicleDoorShut(v,doorStatus[Active],0)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:seatPlayer")
AddEventHandler("player:seatPlayer",function(Index)
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		local Vehicle = GetVehiclePedIsUsing(Ped)

		if Index == "0" then
			if IsVehicleSeatFree(Vehicle,-1) then
				SetPedIntoVehicle(Ped,Vehicle,-1)
			end
		elseif Index == "1" then
			if IsVehicleSeatFree(Vehicle,0) then
				SetPedIntoVehicle(Ped,Vehicle,0)
			end
		else
			for Seat = 1,10 do
				if IsVehicleSeatFree(Vehicle,Seat) then
					SetPedIntoVehicle(Ped,Vehicle,Seat)
					break
				end
			end
		end
	end
end)
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- THREADHANDCUFF
-- -----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 100
		if LocalPlayer["state"]["Handcuff"] or LocalPlayer["state"]["Target"] then
			TimeDistance = 1
			DisableControlAction(1,18,true)
			DisableControlAction(1,21,true)
			DisableControlAction(1,55,true)
			DisableControlAction(1,102,true)
			DisableControlAction(1,179,true)
			DisableControlAction(1,203,true)
			DisableControlAction(1,76,true)
			DisableControlAction(1,23,true)
			DisableControlAction(1,24,true)
			DisableControlAction(1,25,true)
			DisableControlAction(1,140,true)
			DisableControlAction(1,142,true)
			DisableControlAction(1,143,true)
			DisableControlAction(1,75,true)
			DisableControlAction(1,22,true)
			DisableControlAction(1,243,true)
			DisableControlAction(1,257,true)
			DisableControlAction(1,263,true)
			DisableControlAction(1,311,true)
			DisablePlayerFiring(PlayerPedId(),true)
		end

		Wait(TimeDistance)
	end
end)
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- THREADHANDCUFF
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- CreateThread(function()
-- 	while true do
-- 		local TimeDistance = 999
-- 		local Ped = PlayerPedId()
-- 		if LocalPlayer["state"]["Handcuff"] and GetEntityHealth(Ped) > 100 and not ropeCarry and not playerCarry then
-- 			if not IsEntityPlayingAnim(Ped,"mp_arresting","idle",3) then
-- 				if LoadAnim("mp_arresting") then
-- 					TaskPlayAnim(Ped,"mp_arresting","idle",8.0,8.0,-1,49,0,0,0,0)
-- 				end

-- 				TimeDistance = 1
-- 			end
-- 		end

-- 		Wait(TimeDistance)
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOTDISTANCE
-----------------------------------------------------------------------------------------------------------------------------------------
local losSantos = PolyZone:Create({
	vector2(-2153.08,-3131.33),
	vector2(-1581.58,-2092.38),
	vector2(-3271.05,275.85),
	vector2(-3460.83,967.42),
	vector2(-3202.39,1555.39),
	vector2(-1642.50,993.32),
	vector2(312.95,1054.66),
	vector2(1313.70,341.94),
	vector2(1739.01,-1280.58),
	vector2(1427.42,-3440.38),
	vector2(-737.90,-3773.97)
},{ name = "santos" })

local sandyShores = PolyZone:Create({
	vector2(-375.38,2910.14),
	vector2(307.66,3664.47),
	vector2(2329.64,4128.52),
	vector2(2349.93,4578.50),
	vector2(1680.57,4462.48),
	vector2(1570.01,4961.27),
	vector2(1967.55,5203.67),
	vector2(2387.14,5273.98),
	vector2(2735.26,4392.21),
	vector2(2512.33,3711.16),
	vector2(1681.79,3387.82),
	vector2(258.85,2920.16)
},{ name = "sandy" })

local paletoBay = PolyZone:Create({
	vector2(-529.40,5755.14),
	vector2(-234.39,5978.46),
	vector2(278.16,6381.84),
	vector2(672.67,6434.39),
	vector2(699.56,6877.77),
	vector2(256.59,7058.49),
	vector2(17.64,7054.53),
	vector2(-489.45,6449.50),
	vector2(-717.59,6030.94)
},{ name = "paleto" })

local Zancudo = PolyZone:Create({
	vector2(-2565.79,2934.08),
	vector2(-2342.66,3505.22),
	vector2(-1728.25,3108.1),
	vector2(-1880.28,2689.69)
},{ name = "Zancudo" })
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSHOTSFIRED
-----------------------------------------------------------------------------------------------------------------------------------------
local ShotDelay = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSHOT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Route"] < 900000 then
			local Ped = PlayerPedId()
			if IsPedArmed(Ped,6) and GetGameTimer() >= ShotDelay then
				
				TimeDistance = 1

				if IsPedShooting(Ped) then
					ShotDelay = GetGameTimer() + 60000
					TriggerEvent("player:Residuals","Resíduo de Pólvora.")

					local Vehicle = false
					local Coords = GetEntityCoords(Ped)

					if Zancudo:isPointInside(Coords) then goto continue end
					
					if not IsPedCurrentWeaponSilenced(Ped) then 
						if (losSantos:isPointInside(Coords) or sandyShores:isPointInside(Coords) or paletoBay:isPointInside(Coords)) and not LocalPlayer["state"]["Police"] then
							TriggerServerEvent("evidence:dropEvidence","blue")

							if IsPedInAnyVehicle(Ped) then
								Vehicle = true
							end
							vSERVER.shotsFired(Vehicle)
						end
					else
						if math.random(100) >= 80 then
							if (losSantos:isPointInside(Coords) or sandyShores:isPointInside(Coords) or paletoBay:isPointInside(Coords)) and not LocalPlayer["state"]["Police"] then
								TriggerServerEvent("evidence:dropEvidence","blue")

								if IsPedInAnyVehicle(Ped) then
									Vehicle = true
								end

								vSERVER.shotsFired(Vehicle)
							end
						end
					end
					::continue::
				end
			end
		end

		Wait(TimeDistance)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SHAKESHOTTING
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) and IsPedArmed(Ped,6) then
			TimeDistance = 1

			local Vehicle = GetVehiclePedIsUsing(Ped)
			if IsPedShooting(Ped) and (GetVehicleClass(Vehicle) ~= 15 and GetVehicleClass(Vehicle) ~= 16) then
				ShakeGameplayCam("SMALL_EXPLOSION_SHAKE",0.05)
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSOAP
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkSoap()
	return Residuals
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:RESIDUALS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:Residuals")
AddEventHandler("player:Residuals",function(Informations)
	if Informations then
		if not Residuals then
			Residuals = {}
		end

		Residuals[Informations] = true
	else
		Residuals = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:inBennys")
AddEventHandler("player:inBennys",function(status)
	inBennys = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.removeVehicle()
	if not inBennys then
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) then
			TaskLeaveVehicle(Ped,GetVehiclePedIsUsing(Ped),0)
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------
-- CLEANEFFECTDRUGS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("cleanEffectDrugs")
AddEventHandler("cleanEffectDrugs",function()
	if GetScreenEffectIsActive("MinigameTransitionIn") then
		StopScreenEffect("MinigameTransitionIn")
	end

	if GetScreenEffectIsActive("DMT_flight") then
		StopScreenEffect("DMT_flight")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PUTVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.putVehicle(Network)
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			local vehSeats = 10
			local Ped = PlayerPedId()

			repeat
				vehSeats = vehSeats - 1

				if IsVehicleSeatFree(Vehicle,vehSeats) then
					ClearPedTasks(Ped)
					ClearPedSecondaryTask(Ped)
					SetPedIntoVehicle(Ped,Vehicle,vehSeats)

					vehSeats = true
				end
			until vehSeats == true or vehSeats == 0
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRUISER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ancorar",function(source,Message)
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		local Vehicle = GetVehiclePedIsUsing(Ped)
		if GetPedInVehicleSeat(Vehicle,-1) == Ped and not IsEntityInAir(Vehicle) then
			local speed = GetEntitySpeed(Vehicle) * 3.6

			if speed >= 10 then
				if not Message[1] then
					SetEntityMaxSpeed(Vehicle,GetVehicleEstimatedMaxSpeed(Vehicle))
					TriggerEvent("Notify","amarelo","Ancora lançada.",3000)
				else
					if parseInt(Message[1]) > 10 then
						SetEntityMaxSpeed(Vehicle,0.01 * Message[1])
						TriggerEvent("Notify","verde","Ancora recolhida.",3000)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GAMEEVENTTRIGGERED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("gameEventTriggered",function(name,Message)
	if name == "CEventNetworkEntityDamage" then
		if (GetEntityHealth(Message[1]) <= 100 and PlayerPedId() == Message[2] and IsPedAPlayer(Message[1])) then
			local Index = NetworkGetPlayerIndexFromPed(Message[1])
			local source = GetPlayerServerId(Index)
			TriggerServerEvent("player:Death",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNKABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local inTrunk = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:ENTERTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:enterTrunk")
AddEventHandler("player:enterTrunk",function(Entity)
	if not inTrunk then
		if vSERVER.BypassInvi() then
			LocalPlayer["state"]["Commands"] = true
			LocalPlayer["state"]["Invisible"] = true
			SetEntityVisible(PlayerPedId(),false,false)
			AttachEntityToEntity(PlayerPedId(),Entity[3],-1,0.0,-2.2,0.5,0.0,0.0,0.0,false,false,false,false,20,true)
			inTrunk = true
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:checkTrunk")
AddEventHandler("player:checkTrunk",function()
	if inTrunk then
		local Ped = PlayerPedId()
		local Vehicle = GetEntityAttachedTo(Ped)
		if DoesEntityExist(Vehicle) then
			inTrunk = false
			DetachEntity(Ped,false,false)
			SetEntityVisible(Ped,true,false)
			LocalPlayer["state"]["Commands"] = false
			LocalPlayer["state"]["Invisible"] = false
			SetEntityCoords(Ped,GetOffsetFromEntityInWorldCoords(Ped,0.0,-1.25,-0.25),false,false,false,false)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999

		if inTrunk then
			local Ped = PlayerPedId()
			local Vehicle = GetEntityAttachedTo(Ped)
			if DoesEntityExist(Vehicle) then
				TimeDistance = 1

				DisablePlayerFiring(Ped,true)

				if IsEntityVisible(Ped) then
					LocalPlayer["state"]["Invisible"] = true
					SetEntityVisible(Ped,false,false)
				end

				if IsControlJustPressed(1,38) then
					inTrunk = false
					DetachEntity(Ped,false,false)
					SetEntityVisible(Ped,true,false)
					LocalPlayer["state"]["Commands"] = false
					LocalPlayer["state"]["Invisible"] = false
					SetEntityCoords(Ped,GetOffsetFromEntityInWorldCoords(Ped,0.0,-1.25,-0.25),false,false,false,false)
				end
			else
				inTrunk = false
				DetachEntity(Ped,false,false)
				SetEntityVisible(Ped,true,false)
				LocalPlayer["state"]["Commands"] = false
				LocalPlayer["state"]["Invisible"] = false
				SetEntityCoords(Ped,GetOffsetFromEntityInWorldCoords(Ped,0.0,-1.25,-0.25),false,false,false,false)
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BIKEPACK
-----------------------------------------------------------------------------------------------------------------------------------------
local bikesPoints = 0
local bikesTea = false
local bikeMaxPoints = 900
local bikesTimer = GetGameTimer()
local bikesTeaTimer = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- BIKESMODEL
-----------------------------------------------------------------------------------------------------------------------------------------
local bikesModel = {
	[1131912276] = true,
	[448402357] = true,
	[-836512833] = true,
	[-186537451] = true,
	[1127861609] = true,
	[-1233807380] = true,
	[-400295096] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:MUSHROOMTEA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:MushroomTea")
AddEventHandler("player:MushroomTea",function()
	bikesTea = true
	bikeMaxPoints = 600
	LocalPlayer["state"]["Tea"] = 3600
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBIKES
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()

		if IsPedInAnyVehicle(Ped) then
			local Vehicle = GetVehiclePedIsUsing(Ped)
			local vehModel = GetEntityModel(Vehicle)
			local speed = GetEntitySpeed(Vehicle) * 3.6

			if bikesModel[vehModel] and GetGameTimer() >= bikesTimer and speed >= 10 then
				bikesTimer = GetGameTimer() + 1000
				bikesPoints = bikesPoints + 1

				if bikesPoints >= bikeMaxPoints then
					vSERVER.Bikepack()
					bikesPoints = 0
				end
			end
		end

		if commandFps then
			if IsPedSwimming(Ped) then
				ClearTimecycleModifier()
				commandFps = false
			end
		end

		Wait(1000)
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------
----- FPS ON 
----------------------------------------------------------------------------------------------------------------------------------------

RegisterCommand("fps",function(source,args)
    if args[1] == "on" then
        SetTimecycleModifier("cinema")
        TriggerEvent("Notify","sucesso","Boost de fps ligado!")
    elseif args[1] == "off" then
        SetTimecycleModifier("default")
        TriggerEvent("Notify","sucesso","Boost de fps desligado!")
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBIKETEA
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if bikesTea then
			if GetGameTimer() >= bikesTeaTimer then
				bikesTeaTimer = GetGameTimer() + 1000
				LocalPlayer["state"]["Tea"] = LocalPlayer["state"]["Tea"] - 1

				if LocalPlayer["state"]["Tea"] <= 0 then
					LocalPlayer["state"]["Tea"] = 3600
					bikeMaxPoints = 900
					bikesTea = false
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANCORAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ancorar",function()
	local Ped = PlayerPedId()
	if IsPedInAnyBoat(Ped) then
		local Vehicle = GetVehiclePedIsUsing(Ped)
		if CanAnchorBoatHere(Vehicle) then
			TriggerEvent("Notify","verde","Embarcação desancorada.",5000)
			SetBoatAnchor(Vehicle,false)
		else
			TriggerEvent("Notify","verde","Embarcação ancorada.",5000)
			SetBoatAnchor(Vehicle,true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COWCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local Cows = {
	-- { 2440.58,4736.35,34.29 },
	-- { 2432.5,4744.58,34.31 },
	-- { 2424.47,4752.37,34.31 },
	-- { 2416.28,4760.8,34.31 },
	-- { 2408.6,4768.88,34.31 },
	-- { 2400.32,4777.48,34.53 },
	-- { 2432.46,4802.66,34.83 },
	-- { 2440.62,4794.22,34.66 },
	-- { 2448.65,4786.57,34.64 },
	-- { 2456.88,4778.08,34.49 },
	-- { 2464.53,4770.04,34.37 },
	-- { 2473.38,4760.98,34.31 },
	-- { 2495.03,4762.77,34.37 },
	-- { 2503.13,4754.08,34.31 },
	-- { 2511.34,4746.04,34.31 },
	-- { 2519.56,4737.35,34.29 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Index,v in pairs(Cows) do
		exports["target"]:AddCircleZone("Cows:"..Index,vec3(v[1],v[2],v[3]),0.5,{
			name = "Cows:"..Index,
			heading = 3374176
		},{
			Distance = 1.25,
			options = {
				{
					event = "inventory:MakeProducts",
					label = "Retirar Leite",
					tunnel = "products",
					service = "milkBottle"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNKABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local inTrash = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:ENTERTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:enterTrash")
AddEventHandler("player:enterTrash",function(Entity)
	if not inTrash then
		-- if vSERVER.BypassInvi() then
			LocalPlayer["state"]["Commands"] = true
	
			local Ped = PlayerPedId()
			FreezeEntityPosition(Ped,true)
			LocalPlayer["state"]["Invisible"] = true
			SetEntityVisible(Ped,false,false)
			SetEntityCoords(Ped,Entity[4],false,false,false,false)
	
			inTrash = GetOffsetFromEntityInWorldCoords(Entity[1],0.0,-1.5,0.0)
	
			while inTrash do
				Wait(1)
	
				if IsControlJustPressed(1,38) then
					FreezeEntityPosition(Ped,false)
					SetEntityVisible(Ped,true,false)
					LocalPlayer["state"]["Invisible"] = false
					SetEntityCoords(Ped,inTrash,false,false,false,false)
					LocalPlayer["state"]["Commands"] = false
	
					inTrash = false
				end
			end
		-- end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKTRASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:checkTrash")
AddEventHandler("player:checkTrash",function()
	if inTrash then
		local Ped = PlayerPedId()
		FreezeEntityPosition(Ped,false)
		SetEntityVisible(Ped,true,false)
		LocalPlayer["state"]["Invisible"] = false
		SetEntityCoords(Ped,inTrash,false,false,false,false)
		LocalPlayer["state"]["Commands"] = false

		inTrash = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- YOGABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Yoga = false
local YogaPoints = 0
local YogaTimer = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:YOGA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:Yoga")
AddEventHandler("player:Yoga",function()
	if not Yoga then
		Yoga = true
		YogaPoints = 0
		TriggerEvent("Notify","amarelo","Yoga iniciado, para finalizar pressione <b>E</b>.",5000)

		while Yoga do
			if GetGameTimer() >= YogaTimer then
				YogaTimer = GetGameTimer() + 1000
				YogaPoints = YogaPoints + 1

				if YogaPoints >= 5 then
					TriggerServerEvent("player:Stress",1)
					YogaPoints = 0
				end
			end

			local Ped = PlayerPedId()
			if not IsEntityPlayingAnim(Ped,"amb@world_human_yoga@male@base","base_a",3) then
				vRP.playAnim(false,{"amb@world_human_yoga@male@base","base_a"},true)
			end

			if IsControlJustPressed(1,38) then
				vRP.removeObjects()
				Yoga = false
				break
			end

			Wait(1)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MEGAPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
local Megaphone = false
RegisterNetEvent("player:Megaphone")
AddEventHandler("player:Megaphone",function()
	Megaphone = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADMEGAPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Megaphone then
			local Ped = PlayerPedId()
			if not IsEntityPlayingAnim(Ped,"anim@random@shop_clothes@watches","base",3) then
				TriggerServerEvent("pma-voice:Megaphone",false)
				TriggerEvent("pma-voice:Megaphone",false)
				Megaphone = false
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DUIVARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local DuiTextures = {}
local InnerTexture = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:DUITABLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:DuiTable")
AddEventHandler("player:DuiTable",function(Table)
	DuiTextures = Table
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADMEGAPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if not IsPedInAnyVehicle(Ped) then
			local Coords = GetEntityCoords(Ped)

			for Line,v in pairs(DuiTextures) do
				if #(Coords - v["Coords"]) <= 15 then
					if not InnerTexture[Line] then
						InnerTexture[Line] = true

						local Texture = CreateRuntimeTxd("Texture"..Line)
						local TextureObject = CreateDui(v["Link"],v["Width"],v["Weight"])
						local TextureHandle = GetDuiHandle(TextureObject)

						CreateRuntimeTextureFromDuiHandle(Texture,"Back"..Line,TextureHandle)
						AddReplaceTexture(v["Dict"],v["Texture"],"Texture"..Line,"Back"..Line)

						exports["target"]:AddCircleZone("Texture"..Line,v["Coords"],v["Dimension"],{
							name = "Texture"..Line,
							heading = 3374176
						},{
							shop = Line,
							Distance = v["Distance"],
							options = {
								{
									event = "player:Texture",
									label = v["Label"],
									tunnel = "server"
								}
							}
						})
					end
				else
					if InnerTexture[Line] then
						exports["target"]:RemCircleZone("Texture"..Line)
						RemoveReplaceTexture(v["Dict"],v["Texture"])
						InnerTexture[Line] = nil
					end
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:DUIUPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:DuiUpdate")
AddEventHandler("player:DuiUpdate",function(Name,Table)
	DuiTextures[Name] = Table

	local Ped = PlayerPedId()
	local Fast = DuiTextures[Name]
	local Coords = GetEntityCoords(Ped)
	if #(Coords - Fast["Coords"]) <= 15 then
		local Texture = CreateRuntimeTxd("Texture"..Name)
		local TextureObject = CreateDui(Fast["Link"],Fast["Width"],Fast["Weight"])
		local TextureHandle = GetDuiHandle(TextureObject)

		CreateRuntimeTextureFromDuiHandle(Texture,"Back"..Name,TextureHandle)
		AddReplaceTexture(Fast["Dict"],Fast["Texture"],"Texture"..Name,"Back"..Name)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:RELATIONSHIP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:Relationship")
AddEventHandler("player:Relationship",function(Group)
	if Group == "Ballas" then
		SetRelationshipBetweenGroups(1,GetHashKey("AMBIENT_GANG_BALLAS"),GetHashKey("PLAYER"))
		SetRelationshipBetweenGroups(1,GetHashKey("PLAYER"),GetHashKey("AMBIENT_GANG_BALLAS"))
	elseif Group == "Families" then
		SetRelationshipBetweenGroups(1,GetHashKey("AMBIENT_GANG_FAMILY"),GetHashKey("PLAYER"))
		SetRelationshipBetweenGroups(1,GetHashKey("PLAYER"),GetHashKey("AMBIENT_GANG_FAMILY"))
	elseif Group == "Vagos" then
		SetRelationshipBetweenGroups(1,GetHashKey("AMBIENT_GANG_MEXICAN"),GetHashKey("PLAYER"))
		SetRelationshipBetweenGroups(1,GetHashKey("PLAYER"),GetHashKey("AMBIENT_GANG_MEXICAN"))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CARWASH
-----------------------------------------------------------------------------------------------------------------------------------------
local WashProgress = false
local Wash = {
	{ 24.27,-1391.96,28.7 },
	{ 170.59,-1718.43,28.66 },
	{ 167.69,-1715.92,28.66 },
	{ -699.86,-932.84,18.38 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCARWASH
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) and not WashProgress then
			local Coords = GetEntityCoords(Ped)
			local Vehicle = GetVehiclePedIsUsing(Ped)
			if GetPedInVehicleSeat(Vehicle,-1) == Ped then
				for _,v in pairs(Wash) do
					local Distance = #(Coords - vec3(v[1],v[2],v[3]))
					if Distance <= 2.5 then
						TimeDistance = 1

						if IsControlJustPressed(1,38) then
							WashProgress = true

							FreezeEntityPosition(Vehicle,true)

							UseParticleFxAssetNextCall("core")
							local Particle01 = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p",v[1],v[2],v[3],0.0,0.0,0.0,1.0,false,false,false,false)

							UseParticleFxAssetNextCall("core")
							local Particle02 = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p",v[1] + 2.5,v[2],v[3],0.0,0.0,0.0,1.0,false,false,false,false)

							SetTimeout(15000,function()
								TriggerServerEvent("CleanVehicle",VehToNet(Vehicle))

								FreezeEntityPosition(Vehicle,false)
								StopParticleFxLooped(Particle01,0)
								StopParticleFxLooped(Particle02,0)
								WashProgress = false
							end)
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)

-- local oldCam = nil
-- local oldVehCam = nil

-- Citizen.CreateThread(function()
-- 	if IsPedInAnyVehicle(PlayerPedId()) then
-- 		if IsPlayerFreeAiming(PlayerId()) then
-- 			if oldCam == nil then
-- 				oldCam = GetFollowPedCamViewMode()
-- 			end
-- 			if oldVehCam == nil then
-- 				oldVehCam = GetFollowVehicleCamViewMode()
-- 			end
-- 			SetFollowVehicleCamViewMode(4)
-- 			SetFollowPedCamViewMode(4)
-- 		else
-- 			if oldCam ~= nil then
-- 				SetFollowPedCamViewMode(oldCam)
-- 				oldCam = nil
-- 			end
-- 			if oldVehCam ~= nil then
-- 				SetFollowVehicleCamViewMode(oldVehCam)
-- 				oldVehCam = nil
-- 			end
-- 		end
-- 	else
-- 		if oldCam ~= nil then
-- 			SetFollowPedCamViewMode(oldCam)
-- 			oldCam = nil
-- 		end
-- 		if oldVehCam ~= nil then
-- 			SetFollowVehicleCamViewMode(oldVehCam)
-- 			oldVehCam = nil
-- 		end
-- 	end

-- 	Wait(1)
-- end)

Citizen.CreateThread(function()
	while true do
		SetRelationshipBetweenGroups(1,GetHashKey("AMBIENT_GANG_BALLAS"),GetHashKey("PLAYER"))
		SetRelationshipBetweenGroups(1,GetHashKey("PLAYER"),GetHashKey("AMBIENT_GANG_BALLAS"))
		SetRelationshipBetweenGroups(1,GetHashKey("AMBIENT_GANG_FAMILY"),GetHashKey("PLAYER"))
		SetRelationshipBetweenGroups(1,GetHashKey("PLAYER"),GetHashKey("AMBIENT_GANG_FAMILY"))
		SetRelationshipBetweenGroups(1,GetHashKey("AMBIENT_GANG_MEXICAN"),GetHashKey("PLAYER"))
		SetRelationshipBetweenGroups(1,GetHashKey("PLAYER"),GetHashKey("AMBIENT_GANG_MEXICAN"))
		SetRelationshipBetweenGroups(1,GetHashKey("AMBIENT_GANG_LOST"),GetHashKey("PLAYER"))
		SetRelationshipBetweenGroups(1,GetHashKey("PLAYER"),GetHashKey("AMBIENT_GANG_LOST")) 
		SetPedConfigFlag(PlayerPedId(), 35, false) 

		-- local veh = GetVehiclePedIsIn(PlayerPedId(), false)
		-- if DoesEntityExist(veh) and not IsEntityDead(veh) then
		-- 	local model = GetEntityModel(veh)
			
		-- 	if not IsThisModelABoat(model) and not IsThisModelAHeli(model) and not IsThisModelAPlane(model) and IsEntityInAir(veh) then
		-- 		DisableControlAction(0, 59) -- leaning left/right
		-- 		DisableControlAction(0, 60) -- leaning up/down
		-- 	end
		-- end

		Wait(1)
	end
end)

-------------------------
-- CARREGAR - POLICIA
-------------------------
RegisterCommand('!wei|carry|cop',function()
	if not vSERVER.hasPolPerm() then return end
	--TriggerServerEvent('player:carryPlayer')
	fGrab()
end)

RegisterKeyMapping('!wei|carry|cop','Carregar - Policia','keyboard', 'H')


-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTIPL:HOSPITAL
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    RequestIpl("rc12b_fixed")
    RequestIpl("rc12b_destroyed")
    RequestIpl("rc12b_default")
    RequestIpl("rc12b_hospitalinterior_lod")
    RequestIpl("rc12b_hospitalinterior")
end)


-----------------------------------------------------------------
--TakeHostage by Robbster, do not redistrbute without permission--
------------------------------------------------------------------

local hostageAllowedWeapons = {
	"WEAPON_PISTOL",
	"WEAPON_COMBATPISTOL",
	"WEAPON_PISTOL_MK2",
	"WEAPON_SNSPISTOL",
 
	--etc add guns you want
}

local holdingHostageInProgress = false
local takeHostageAnimNamePlaying = ""
local takeHostageAnimDictPlaying = ""
local takeHostageControlFlagPlaying = 0

RegisterCommand("refem",function()
	takeHostage()
end)

function takeHostage()
	ClearPedSecondaryTask(GetPlayerPed(-1))
	DetachEntity(GetPlayerPed(-1), true, false)
	for i=1, #hostageAllowedWeapons do
		if HasPedGotWeapon(GetPlayerPed(-1), GetHashKey(hostageAllowedWeapons[i]), false) then
			if GetAmmoInPedWeapon(GetPlayerPed(-1), GetHashKey(hostageAllowedWeapons[i])) > 0 then
				canTakeHostage = true 
				foundWeapon = GetHashKey(hostageAllowedWeapons[i])
				break
			end 					
		end
	end

	if not canTakeHostage then 
		TriggerEvent("Notify","amarelo","Você precisa de uma pistola com munição para fazer um refém!.", 5000)
	end

	if not holdingHostageInProgress and canTakeHostage then		
		local player = PlayerPedId()	
		--lib = 'misssagrab_inoffice'
		--anim1 = 'hostage_loop'
		--lib2 = 'misssagrab_inoffice'
		--anim2 = 'hostage_loop_mrk'
		lib = 'anim@gangops@hostage@'
		anim1 = 'perp_idle'
		lib2 = 'anim@gangops@hostage@'
		anim2 = 'victim_idle'
		distans = 0.11 --Higher = closer to camera
		distans2 = -0.24 --higher = left
		height = 0.0
		spin = 0.0		
		length = 100000
		controlFlagMe = 49
		controlFlagTarget = 49
		animFlagTarget = 50
		attachFlag = true 
		local closestPlayer = GetClosestPlayer(2)
		target = GetPlayerServerId(closestPlayer)
		if closestPlayer ~= -1 and closestPlayer ~= nil then
			SetCurrentPedWeapon(GetPlayerPed(-1), foundWeapon, true)
			holdingHostageInProgress = true
			holdingHostage = true 
			TriggerServerEvent('cmg3_animations:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget,attachFlag)
		else
			TriggerEvent("Notify","amarelo","Ninguém por perto para fazer de réfem.", 5000)
		end 
	end
	canTakeHostage = false 
end 

RegisterNetEvent('cmg3_animations:syncTarget')
AddEventHandler('cmg3_animations:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag,animFlagTarget,attach)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	if holdingHostageInProgress then 
		holdingHostageInProgress = false 
	else 
		holdingHostageInProgress = true
	end
	beingHeldHostage = true 
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	if attach then 
		AttachEntityToEntity(GetPlayerPed(-1), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	else 
	end
	
	if controlFlag == nil then controlFlag = 0 end
	
	if animation2 == "victim_fail" then 
		SetEntityHealth(GetPlayerPed(-1),0)
		DetachEntity(GetPlayerPed(-1), true, false)
		TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
		beingHeldHostage = false 
		holdingHostageInProgress = false 
	elseif animation2 == "shoved_back" then 
		holdingHostageInProgress = false 
		DetachEntity(GetPlayerPed(-1), true, false)
		TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
		beingHeldHostage = false 
	else
		TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)	
	end
	takeHostageAnimNamePlaying = animation2
	takeHostageAnimDictPlaying = animationLib
	takeHostageControlFlagPlaying = controlFlag
end)

RegisterNetEvent('cmg3_animations:syncMe')
AddEventHandler('cmg3_animations:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = GetPlayerPed(-1)
	ClearPedSecondaryTask(GetPlayerPed(-1))
	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	takeHostageAnimNamePlaying = animation
	takeHostageAnimDictPlaying = animationLib
	takeHostageControlFlagPlaying = controlFlag
	if animation == "perp_fail" then 
		SetPedShootsAtCoord(GetPlayerPed(-1), 0.0, 0.0, 0.0, 0)
		holdingHostageInProgress = false 
	end
	if animation == "shove_var_a" then 
		Wait(900)
		ClearPedSecondaryTask(GetPlayerPed(-1))
		holdingHostageInProgress = false 
	end
end)

RegisterNetEvent('cmg3_animations:cl_stop')
AddEventHandler('cmg3_animations:cl_stop', function()
	holdingHostageInProgress = false
	beingHeldHostage = false 
	holdingHostage = false 
	ClearPedSecondaryTask(GetPlayerPed(-1))
	DetachEntity(GetPlayerPed(-1), true, false)
end)

Citizen.CreateThread(function()
	while true do
		if holdingHostage or beingHeldHostage then 
			while not IsEntityPlayingAnim(GetPlayerPed(-1), takeHostageAnimDictPlaying, takeHostageAnimNamePlaying, 3) do
				TaskPlayAnim(GetPlayerPed(-1), takeHostageAnimDictPlaying, takeHostageAnimNamePlaying, 8.0, -8.0, 100000, takeHostageControlFlagPlaying, 0, false, false, false)
				Citizen.Wait(0)
			end
		end
		Wait(0)
	end
end)

function GetPlayers()
    local players = {}

	for _, i in ipairs(GetActivePlayers()) do
        table.insert(players, i)
    end

    return players
end

function GetClosestPlayer(radius)
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
	--print("closest player is dist: " .. tostring(closestDistance))
	if closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end

Citizen.CreateThread(function()
	while true do 
		if holdingHostage then
			if IsEntityDead(GetPlayerPed(-1)) then	
				holdingHostage = false
				holdingHostageInProgress = false 
				local closestPlayer = GetClosestPlayer(2)
				target = GetPlayerServerId(closestPlayer)
				TriggerServerEvent("cmg3_animations:stop",target)
				Wait(100)
				releaseHostage()
			end 
			DisableControlAction(0,24,true) -- disable attack
			DisableControlAction(0,25,true) -- disable aim
			DisableControlAction(0,47,true) -- disable weapon
			DisableControlAction(0,58,true) -- disable weapon
			DisablePlayerFiring(GetPlayerPed(-1),true)
			local playerCoords = GetEntityCoords(GetPlayerPed(-1))
			DrawText3D(playerCoords.x,playerCoords.y,playerCoords.z,"Aperte [Y] para soltar, [U] para matar")
			if IsDisabledControlJustPressed(0,246) then --release	
				holdingHostage = false
				holdingHostageInProgress = false 
				local closestPlayer = GetClosestPlayer(2)
				target = GetPlayerServerId(closestPlayer)
				TriggerServerEvent("cmg3_animations:stop",target)
				Wait(100)
				releaseHostage()
			elseif IsDisabledControlJustPressed(0,303) then --kill 			
				holdingHostage = false
				holdingHostageInProgress = false 		
				local closestPlayer = GetClosestPlayer(2)
				target = GetPlayerServerId(closestPlayer)
				TriggerServerEvent("cmg3_animations:stop",target)				
				killHostage()
			end
		end
		if beingHeldHostage then 
			DisableControlAction(0,21,true) -- disable sprint
			DisableControlAction(0,24,true) -- disable attack
			DisableControlAction(0,25,true) -- disable aim
			DisableControlAction(0,47,true) -- disable weapon
			DisableControlAction(0,58,true) -- disable weapon
			DisableControlAction(0,263,true) -- disable melee
			DisableControlAction(0,264,true) -- disable melee
			DisableControlAction(0,257,true) -- disable melee
			DisableControlAction(0,140,true) -- disable melee
			DisableControlAction(0,141,true) -- disable melee
			DisableControlAction(0,142,true) -- disable melee
			DisableControlAction(0,143,true) -- disable melee
			DisableControlAction(0,75,true) -- disable exit vehicle
			DisableControlAction(27,75,true) -- disable exit vehicle  
			DisableControlAction(0,22,true) -- disable jump
			DisableControlAction(0,32,true) -- disable move up
			DisableControlAction(0,268,true)
			DisableControlAction(0,33,true) -- disable move down
			DisableControlAction(0,269,true)
			DisableControlAction(0,34,true) -- disable move left
			DisableControlAction(0,270,true)
			DisableControlAction(0,35,true) -- disable move right
			DisableControlAction(0,271,true)
		end
		Wait(0)
	end
end)

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    if onScreen then
        SetTextScale(0.19, 0.19)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function releaseHostage()
	local player = PlayerPedId()	
	lib = 'reaction@shove'
	anim1 = 'shove_var_a'
	lib2 = 'reaction@shove'
	anim2 = 'shoved_back'
	distans = 0.11 --Higher = closer to camera
	distans2 = -0.24 --higher = left
	height = 0.0
	spin = 0.0		
	length = 100000
	controlFlagMe = 120
	controlFlagTarget = 0
	animFlagTarget = 1
	attachFlag = false
	local closestPlayer = GetClosestPlayer(2)
	target = GetPlayerServerId(closestPlayer)
	if closestPlayer ~= 0 then
		TriggerServerEvent('cmg3_animations:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget,attachFlag)
	end
end 

function killHostage()
	local player = PlayerPedId()	
	lib = 'anim@gangops@hostage@'
	anim1 = 'perp_fail'
	lib2 = 'anim@gangops@hostage@'
	anim2 = 'victim_fail'
	distans = 0.11 --Higher = closer to camera
	distans2 = -0.24 --higher = left
	height = 0.0
	spin = 0.0		
	length = 0.2
	controlFlagMe = 168
	controlFlagTarget = 0
	animFlagTarget = 1
	attachFlag = false
	local closestPlayer = GetClosestPlayer(2)
	target = GetPlayerServerId(closestPlayer)
	if target ~= 0 then
		TriggerServerEvent('cmg3_animations:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget,attachFlag)
	end	
end 

function drawNativeNotification(text)
    SetTextComponentFormat('STRING')
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end




---------------------------------------------------------
--[ NPC CONTROL ] 
---------------------------------------------------------
local disableAreas = { -- Local onde nao vai nascer NPC
    vector3(-182.23,-894.84,29.69),
    vector3(157.43,-1016.11,32.96),
    vector3(458.43,-1036.12,35.52),
	  vector3(-617.09,-1000.39,24.75),

    vector3(-469.93,267.13,83.37),
    vector3(2065.48,2632.5,52.64),
    vector3(2081.93,2628.62,55.37),
    vector3(71.52,-1580.42,29.3)
}

local enableRadius = 200.0 -- raio em que os NPCs serão desativados

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        for _, area in ipairs(disableAreas) do
            local distanceFromDisableArea = #(playerCoords - area)
            if distanceFromDisableArea < enableRadius then
                SetVehicleDensityMultiplierThisFrame(0.0)
                SetPedDensityMultiplierThisFrame(0.0)
                SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
                SetRandomVehicleDensityMultiplierThisFrame(0.0)
                SetParkedVehicleDensityMultiplierThisFrame(0.0)
            end
        end
        if not IsAnyVehicleNearPoint(playerCoords, enableRadius) then
            SetVehicleDensityMultiplierThisFrame(1.0)
            SetPedDensityMultiplierThisFrame(1.0)
            SetScenarioPedDensityMultiplierThisFrame(1.0, 1.0)
            SetRandomVehicleDensityMultiplierThisFrame(1.0)
            SetParkedVehicleDensityMultiplierThisFrame(0.0)
        end
    end
end)

---------------------------------------------------------
--[ Baixar arma ] 
---------------------------------------------------------
local TEMP_BOOLEAN = false
RegisterCommand("baixararma", function()
    local ped = PlayerPedId()
    TEMP_BOOLEAN = not TEMP_BOOLEAN

    if TEMP_BOOLEAN then
        if not HasClipSetLoaded("move_ped_wpn_jerrycan_generic") then
            RequestClipSet("move_ped_wpn_jerrycan_generic")
            while not HasClipSetLoaded("move_ped_wpn_jerrycan_generic") do
                Wait(10)
            end
        end
        local WEAPON_HAND = false
        while TEMP_BOOLEAN do
            ped = PlayerPedId()
            local status,hash = GetCurrentPedWeapon(ped)
            if not status and boolean then
                WEAPON_HAND = false
                ResetPedWeaponMovementClipset(ped, 0.0)
            elseif status and not boolean then
			
                WEAPON_HAND = true
                SetPedWeaponMovementClipset(ped, "move_ped_wpn_jerrycan_generic", 0.50)
            end
            Wait(500)
        end
    else
        ResetPedWeaponMovementClipset(ped, 0.0)
    end
end)



----------=================================================
----------============== ARRASTAR
----------=================================================

local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1
L0_1 = GetPlayerPed
L1_1 = -1
L0_1 = L0_1(L1_1)
L1_1 = nil
L2_1 = nil
L3_1 = 0
L4_1 = false
L5_1 = 0
L6_1 = 1000
L7_1 = 0
L8_1 = 0
L9_1 = {}
L10_1 = false
L11_1 = false
L12_1 = nil
L13_1 = false
L14_1 = false
L15_1 = nil
L16_1 = false
pedInFront = 0
jobPlayer = L16_1
function L16_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L0_2 = GetEntityCoords
  L1_2 = L0_1
  L2_2 = false
  L0_2 = L0_2(L1_2, L2_2)
  L1_2 = GetOffsetFromEntityInWorldCoords
  L2_2 = L0_1
  L3_2 = 0.0
  L4_2 = 1.3
  L5_2 = 0.0
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2)
  L2_2 = StartShapeTestCapsule
  L3_2 = L0_2.x
  L4_2 = L0_2.y
  L5_2 = L0_2.z
  L6_2 = L1_2.x
  L7_2 = L1_2.y
  L8_2 = L1_2.z
  L9_2 = 1.0
  L10_2 = 12
  L11_2 = L0_1
  L12_2 = 7
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L3_2 = GetShapeTestResult
  L4_2 = L2_2
  L3_2, L4_2, L5_2, L6_2, L7_2 = L3_2(L4_2)
  L8_2 = IsEntityDead
  L9_2 = L7_2
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = IsPedAPlayer
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if L8_2 then
      return L7_2
  end
  else
    L8_2 = 0
    return L8_2
  end
end
function L17_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = CastRayPointToPoint
  L1_2 = GetEntityCoords
  L2_2 = L0_1
  L1_2 = L1_2(L2_2)
  L2_2 = GetOffsetFromEntityInWorldCoords
  L3_2 = L0_1
  L4_2 = 0.0
  L5_2 = 2.0
  L6_2 = 0.0
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
  L3_2 = 10
  L4_2 = L0_1
  L5_2 = 0
  L0_2 = L0_2(L1_2, L2_2, L3_2, L4_2, L5_2)
  L1_2 = GetRaycastResult
  L2_2 = L0_2
  L1_2, L2_2, L3_2, L4_2, L5_2 = L1_2(L2_2)
  L6_2 = IsEntityAVehicle
  L7_2 = L5_2
  L6_2 = L6_2(L7_2)
  if L6_2 then
    return L5_2
  else
    L6_2 = 0
    return L6_2
  end
end
GetVehicleInFront = L17_1
function L17_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = ipairs
  L2_2 = GetActivePlayers
  L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L2_2()
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = GetPlayerPed
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if L7_2 == A0_2 then
      return L6_2
    end
  end
  L1_2 = -1
  return L1_2
end
function L18_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = DisableControlAction
  L1_2 = 0
  L2_2 = 24
  L3_2 = true
  L0_2(L1_2, L2_2, L3_2)
  L0_2 = DisableControlAction
  L1_2 = 0
  L2_2 = 25
  L3_2 = true
  L0_2(L1_2, L2_2, L3_2)
  L0_2 = DisableControlAction
  L1_2 = 0
  L2_2 = 14
  L3_2 = true
  L0_2(L1_2, L2_2, L3_2)
  L0_2 = DisableControlAction
  L1_2 = 0
  L2_2 = 15
  L3_2 = true
  L0_2(L1_2, L2_2, L3_2)
  L0_2 = DisableControlAction
  L1_2 = 0
  L2_2 = 23
  L3_2 = true
  L0_2(L1_2, L2_2, L3_2)
  L0_2 = DisableControlAction
  L1_2 = 0
  L2_2 = 24
  L3_2 = true
  L0_2(L1_2, L2_2, L3_2)
  L0_2 = DisableControlAction
  L1_2 = 0
  L2_2 = 25
  L3_2 = true
  L0_2(L1_2, L2_2, L3_2)
  L0_2 = DisableControlAction
  L1_2 = 0
  L2_2 = 37
  L3_2 = true
  L0_2(L1_2, L2_2, L3_2)
  L0_2 = DisableControlAction
  L1_2 = 0
  L2_2 = 44
  L3_2 = true
  L0_2(L1_2, L2_2, L3_2)
  L0_2 = DisableControlAction
  L1_2 = 0
  L2_2 = 140
  L3_2 = true
  L0_2(L1_2, L2_2, L3_2)
  L0_2 = DisableControlAction
  L1_2 = 0
  L2_2 = 141
  L3_2 = true
  L0_2(L1_2, L2_2, L3_2)
  L0_2 = DisableControlAction
  L1_2 = 0
  L2_2 = 142
  L3_2 = true
  L0_2(L1_2, L2_2, L3_2)
  L0_2 = DisableControlAction
  L1_2 = 0
  L2_2 = 257
  L3_2 = true
  L0_2(L1_2, L2_2, L3_2)
  L0_2 = DisableControlAction
  L1_2 = 0
  L2_2 = 263
  L3_2 = true
  L0_2(L1_2, L2_2, L3_2)
  L0_2 = DisableControlAction
  L1_2 = 0
  L2_2 = 264
  L3_2 = true
  L0_2(L1_2, L2_2, L3_2)
end
function L19_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  if A0_2 then
    L3_2 = RequestAnimDict
    L4_2 = A1_2
    L3_2(L4_2)
    while true do
      L3_2 = HasAnimDictLoaded
      L4_2 = A1_2
      L3_2 = L3_2(L4_2)
      if L3_2 then
        break
      end
      L3_2 = Citizen
      L3_2 = L3_2.Wait
      L4_2 = 100
      L3_2(L4_2)
    end
    L3_2 = TaskPlayAnim
    L4_2 = L0_1
    L5_2 = A1_2
    L6_2 = A2_2
    L7_2 = 8.0
    L8_2 = -8
    L9_2 = -1
    L10_2 = 51
    L11_2 = 0
    L12_2 = 0
    L13_2 = 0
    L14_2 = 0
    L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  end
end
function L20_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = L15_1
  if nil == L0_2 then
    L0_2 = pedInFront
    if 0 == L0_2 then
      goto lbl_110
    end
    L0_2 = PedToNet
    L1_2 = pedInFront
    L0_2 = L0_2(L1_2)
    L2_1 = L0_2
    L1_2 = L2_1
    L0_2 = L9_1
    L0_2[L1_2] = nil
    L0_2 = TriggerServerEvent
    L1_2 = "ryt:syncVariable"
    L2_2 = L9_1
    L0_2(L1_2, L2_2)
    L0_2 = Config
    L0_2 = L0_2.ESX
    L0_2 = L0_2.enabled
    if L0_2 then
      L0_2 = Config
      L0_2 = L0_2.ESX
      L0_2 = L0_2.exceptionJobs
      if L0_2 then
        L0_2 = TriggerServerEvent
        L1_2 = "ryt:exceptionJobs"
        L2_2 = GetPlayerServerId
        L3_2 = L17_1
        L4_2 = L0_1
        L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
        L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
        L3_2 = GetPlayerServerId
        L4_2 = L17_1
        L5_2 = pedInFront
        L4_2, L5_2, L6_2 = L4_2(L5_2)
        L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2)
        L0_2(L1_2, L2_2, L3_2, L4_2, L5_2, L6_2)
        while true do
          L0_2 = L12_1
          if nil ~= L0_2 then
            break
          end
          L0_2 = Citizen
          L0_2 = L0_2.Wait
          L1_2 = 0
          L0_2(L1_2)
        end
    end
    else
      L0_2 = true
      L12_1 = L0_2
    end
    L0_2 = L12_1
    if L0_2 then
      L0_2 = TriggerServerEvent
      L1_2 = "ryt:sendEvent"
      L2_2 = GetPlayerServerId
      L3_2 = L17_1
      L4_2 = pedInFront
      L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
      L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
      L3_2 = GetPlayerServerId
      L4_2 = L17_1
      L5_2 = L0_1
      L4_2, L5_2, L6_2 = L4_2(L5_2)
      L3_2 = L3_2(L4_2, L5_2, L6_2)
      L4_2 = PedToNet
      L5_2 = pedInFront
      L4_2 = L4_2(L5_2)
      L5_2 = PedToNet
      L6_2 = L0_1
      L5_2, L6_2 = L5_2(L6_2)
      L0_2(L1_2, L2_2, L3_2, L4_2, L5_2, L6_2)
      L0_2 = nil
      L12_1 = L0_2
    end
  else
    L0_2 = TriggerServerEvent
    L1_2 = "ryt:Detach"
    L2_2 = GetPlayerServerId
    L3_2 = L17_1
    L4_2 = NetToPed
    L5_2 = L15_1
    L4_2, L5_2, L6_2 = L4_2(L5_2)
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2)
    L2_2, L3_2, L4_2, L5_2, L6_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
    L0_2(L1_2, L2_2, L3_2, L4_2, L5_2, L6_2)
    L0_2 = ClearPedTasksImmediately
    L1_2 = L0_1
    L0_2(L1_2)
    L0_2 = nil
    L1_2 = nil
    L2_1 = L1_2
    L1_1 = L0_2
    L0_2 = 0
    L1_2 = false
    L2_2 = 0
    L3_2 = 1000
    L6_1 = L3_2
    L5_1 = L2_2
    L4_1 = L1_2
    L3_1 = L0_2
    L0_2 = false
    L1_2 = false
    L11_1 = L1_2
    L10_1 = L0_2
    L0_2 = false
    pedInFront = 0
    jobPlayer = L0_2
    L0_2 = nil
    L15_1 = L0_2
  end
  ::lbl_110::
end
fGrab = L20_1
function L20_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = L3_1
  if 0 ~= L1_2 then
    L1_2 = L7_1
    if 0 ~= L1_2 then
      L2_2 = L2_1
      L1_2 = L9_1
      L3_2 = L3_1
      L1_2[L2_2] = L3_2
      L1_2 = TriggerServerEvent
      L2_2 = "ryt:syncVariable"
      L3_2 = L9_1
      L1_2(L2_2, L3_2)
      if A0_2 then
        L1_2 = TriggerEvent
        L2_2 = "ryt:DeadEvent"
        L1_2(L2_2)
        L1_2 = TriggerServerEvent
        L2_2 = "ryt:enterPed"
        L3_2 = GetPlayerServerId
        L4_2 = L17_1
        L5_2 = NetToPed
        L6_2 = L2_1
        L5_2, L6_2 = L5_2(L6_2)
        L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2)
        L3_2 = L3_2(L4_2, L5_2, L6_2)
        L4_2 = L7_1
        L4_2 = L4_2 - 1
        L5_2 = VehToNet
        L6_2 = L3_1
        L5_2, L6_2 = L5_2(L6_2)
        L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
      else
        L1_2 = Hint
        L2_2 = Config
        L2_2 = L2_2.Languages
        L3_2 = Config
        L3_2 = L3_2.Language
        L2_2 = L2_2[L3_2]
        L2_2 = L2_2.taskenter
        L1_2(L2_2)
        L1_2 = IsControlJustPressed
        L2_2 = 0
        L3_2 = Config
        L3_2 = L3_2.Keys
        L3_2 = L3_2.TaskEnterKey
        L1_2 = L1_2(L2_2, L3_2)
        if L1_2 then
          L1_2 = TriggerEvent
          L2_2 = "ryt:DeadEvent"
          L1_2(L2_2)
          L1_2 = TriggerServerEvent
          L2_2 = "ryt:enterPed"
          L3_2 = GetPlayerServerId
          L4_2 = L17_1
          L5_2 = NetToPed
          L6_2 = L2_1
          L5_2, L6_2 = L5_2(L6_2)
          L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2)
          L3_2 = L3_2(L4_2, L5_2, L6_2)
          L4_2 = L7_1
          L4_2 = L4_2 - 1
          L5_2 = VehToNet
          L6_2 = L3_1
          L5_2, L6_2 = L5_2(L6_2)
          L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
        end
      end
    end
  end
end
fPutCar = L20_1
function L20_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = L3_1
  if 0 ~= L1_2 then
    L2_2 = L2_1
    L1_2 = L9_1
    L1_2 = L1_2[L2_2]
    if nil ~= L1_2 then
      L1_2 = L3_1
      L3_2 = L2_1
      L2_2 = L9_1
      L2_2 = L2_2[L3_2]
      if L1_2 == L2_2 then
        if A0_2 then
          L1_2 = Vdist
          L2_2 = GetEntityCoords
          L3_2 = L0_1
          L2_2 = L2_2(L3_2)
          L3_2 = GetEntityCoords
          L4_2 = NetToPed
          L5_2 = L2_1
          L4_2, L5_2, L6_2 = L4_2(L5_2)
          L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2)
          L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
          if L1_2 then
            L1_2 = TriggerServerEvent
            L2_2 = "ryt:exitPed"
            L3_2 = GetPlayerServerId
            L4_2 = L17_1
            L5_2 = NetToPed
            L6_2 = L2_1
            L5_2, L6_2 = L5_2(L6_2)
            L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2)
            L3_2 = L3_2(L4_2, L5_2, L6_2)
            L4_2 = VehToNet
            L6_2 = L2_1
            L5_2 = L9_1
            L5_2 = L5_2[L6_2]
            L4_2, L5_2, L6_2 = L4_2(L5_2)
            L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
            L2_2 = L2_1
            L1_2 = L9_1
            L1_2[L2_2] = nil
            L1_2 = TriggerServerEvent
            L2_2 = "ryt:syncVariable"
            L3_2 = L9_1
            L1_2(L2_2, L3_2)
          end
        else
          L1_2 = 5
          L6_1 = L1_2
          L1_2 = L8_1
          if L1_2 < 3.0 then
            L1_2 = Hint
            L2_2 = Config
            L2_2 = L2_2.Languages
            L3_2 = Config
            L3_2 = L3_2.Language
            L2_2 = L2_2[L3_2]
            L2_2 = L2_2.exitped
            L1_2(L2_2)
            L1_2 = IsControlJustReleased
            L2_2 = 0
            L3_2 = Config
            L3_2 = L3_2.Keys
            L3_2 = L3_2.TaskEnterKey
            L1_2 = L1_2(L2_2, L3_2)
            if L1_2 then
              L1_2 = TriggerServerEvent
              L2_2 = "ryt:exitPed"
              L3_2 = GetPlayerServerId
              L4_2 = L17_1
              L5_2 = NetToPed
              L6_2 = L2_1
              L5_2, L6_2 = L5_2(L6_2)
              L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2)
              L3_2 = L3_2(L4_2, L5_2, L6_2)
              L4_2 = VehToNet
              L6_2 = L2_1
              L5_2 = L9_1
              L5_2 = L5_2[L6_2]
              L4_2, L5_2, L6_2 = L4_2(L5_2)
              L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
              L2_2 = L2_1
              L1_2 = L9_1
              L1_2[L2_2] = nil
              L1_2 = TriggerServerEvent
              L2_2 = "ryt:syncVariable"
              L3_2 = L9_1
              L1_2(L2_2, L3_2)
              L1_2 = 1000
              L6_1 = L1_2
            end
          end
        end
      end
    end
  end
end
fExitCar = L20_1
L20_1 = RegisterNetEvent
L21_1 = "ryt:sendEvent"
L20_1(L21_1)
L20_1 = AddEventHandler
L21_1 = "ryt:sendEvent"
function L22_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  if A2_2 then
    L1_1 = A1_2
    L3_2 = 200
    L6_1 = L3_2
    L3_2 = AttachEntityToEntity
    L4_2 = L0_1
    L5_2 = NetToPed
    L6_2 = A1_2
    L5_2 = L5_2(L6_2)
    L6_2 = 4103
    L7_2 = Config
    L7_2 = L7_2.AttachPosition
    L8_2 = 0.0
    L9_2 = 0.0
    L10_2 = 0.0
    L11_2 = true
    L12_2 = false
    L13_2 = false
    L14_2 = true
    L15_2 = 1
    L16_2 = true
    L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
    L3_2 = L19_1
    L4_2 = Config
    L4_2 = L4_2.Animations
    L4_2 = L4_2.citizenAnimation
    L4_2 = L4_2.enabled
    L5_2 = Config
    L5_2 = L5_2.Animations
    L5_2 = L5_2.citizenAnimation
    L5_2 = L5_2.animDict
    L6_2 = Config
    L6_2 = L6_2.Animations
    L6_2 = L6_2.citizenAnimation
    L6_2 = L6_2.anim
    L3_2(L4_2, L5_2, L6_2)
  else
    L15_1 = A1_2
    L3_2 = 5
    L6_1 = L3_2
    L3_2 = L19_1
    L4_2 = Config
    L4_2 = L4_2.Animations
    L4_2 = L4_2.policeAnimation
    L4_2 = L4_2.enabled
    L5_2 = Config
    L5_2 = L5_2.Animations
    L5_2 = L5_2.policeAnimation
    L5_2 = L5_2.animDict
    L6_2 = Config
    L6_2 = L6_2.Animations
    L6_2 = L6_2.policeAnimation
    L6_2 = L6_2.anim
    L3_2(L4_2, L5_2, L6_2)
  end
end
L20_1(L21_1, L22_1)
L20_1 = RegisterNetEvent
L21_1 = "ryt:Detach"
L20_1(L21_1)
L20_1 = AddEventHandler
L21_1 = "ryt:Detach"
function L22_1()
  local L0_2, L1_2, L2_2
  L0_2 = DetachEntity
  L1_2 = L0_1
  L2_2 = true
  L0_2(L1_2, L2_2)
  L0_2 = ClearPedTasks
  L1_2 = L0_1
  L0_2(L1_2)
  L0_2 = nil
  L1_1 = L0_2
  L0_2 = 1000
  L6_1 = L0_2
end
L20_1(L21_1, L22_1)
L20_1 = RegisterNetEvent
L21_1 = "ryt:DeadEvent"
L20_1(L21_1)
L20_1 = AddEventHandler
L21_1 = "ryt:DeadEvent"
function L22_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = L15_1
  oldDrag = L0_2
  L0_2 = IsPedAPlayer
  L1_2 = NetToPed
  L2_2 = oldDrag
  L1_2, L2_2, L3_2, L4_2, L5_2 = L1_2(L2_2)
  L0_2 = L0_2(L1_2, L2_2, L3_2, L4_2, L5_2)
  if L0_2 then
    L0_2 = TriggerServerEvent
    L1_2 = "ryt:Detach"
    L2_2 = GetPlayerServerId
    L3_2 = L17_1
    L4_2 = NetToPed
    L5_2 = oldDrag
    L4_2, L5_2 = L4_2(L5_2)
    L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2)
    L0_2(L1_2, L2_2, L3_2, L4_2, L5_2)
  end
  L0_2 = nil
  L15_1 = L0_2
  L0_2 = 1000
  L6_1 = L0_2
  L0_2 = ClearPedTasksImmediately
  L1_2 = L0_1
  L0_2(L1_2)
end
L20_1(L21_1, L22_1)
L20_1 = RegisterNetEvent
L21_1 = "ryt:enterPed"
L20_1(L21_1)
L20_1 = AddEventHandler
L21_1 = "ryt:enterPed"
function L22_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = TaskEnterVehicle
  L3_2 = L0_1
  L4_2 = NetToVeh
  L5_2 = A1_2
  L4_2 = L4_2(L5_2)
  L5_2 = 20000
  L6_2 = A0_2
  L7_2 = 1.5
  L8_2 = 1
  L9_2 = 0
  L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
end
L20_1(L21_1, L22_1)
L20_1 = RegisterNetEvent
L21_1 = "ryt:exitPed"
L20_1(L21_1)
L20_1 = AddEventHandler
L21_1 = "ryt:exitPed"
function L22_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = TaskLeaveVehicle
  L2_2 = L0_1
  L3_2 = NetToVeh
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = 256
  L1_2(L2_2, L3_2, L4_2)
end
L20_1(L21_1, L22_1)
L20_1 = RegisterNetEvent
L21_1 = "ryt:exceptionJobs"
L20_1(L21_1)
L20_1 = AddEventHandler
L21_1 = "ryt:exceptionJobs"
function L22_1(A0_2)
  local L1_2
  L1_2 = not A0_2
  L12_1 = L1_2
end
L20_1(L21_1, L22_1)
L20_1 = RegisterNetEvent
L21_1 = "ryt:syncVariable"
L20_1(L21_1)
L20_1 = AddEventHandler
L21_1 = "ryt:syncVariable"
function L22_1(A0_2)
  local L1_2
  L9_1 = A0_2
end
L20_1(L21_1, L22_1)
L20_1 = Citizen
L20_1 = L20_1.CreateThread
function L21_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  while true do
    L0_2 = GetPlayerPed
    L1_2 = -1
    L0_2 = L0_2(L1_2)
    L0_1 = L0_2
    L0_2 = Config
    L0_2 = L0_2.CommandEnabled
    if not L0_2 then
      L0_2 = verifyJobPlayer
      L0_2 = L0_2()
      jobPlayer = L0_2
    end
    L0_2 = L16_1
    L0_2 = L0_2()
    pedInFront = L0_2
    L0_2 = IsEntityDead
    L1_2 = L0_1
    L0_2 = L0_2(L1_2)
    if not L0_2 then
      L0_2 = IsPedRagdoll
      L1_2 = L0_1
      L0_2 = L0_2(L1_2)
    end
    L4_1 = L0_2
    L0_2 = L1_1
    if nil ~= L0_2 then
      L0_2 = IsPedWalking
      L1_2 = NetToPed
      L2_2 = L1_1
      L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2 = L1_2(L2_2)
      L0_2 = L0_2(L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2)
      pedWalking = L0_2
      L0_2 = IsPedSprinting
      L1_2 = NetToPed
      L2_2 = L1_1
      L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2 = L1_2(L2_2)
      L0_2 = L0_2(L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2)
      pedSprinting = L0_2
      L0_2 = IsEntityPlayingAnim
      L1_2 = L0_1
      L2_2 = Config
      L2_2 = L2_2.Animations
      L2_2 = L2_2.citizenAnimation
      L2_2 = L2_2.animDict
      L3_2 = Config
      L3_2 = L3_2.Animations
      L3_2 = L3_2.citizenAnimation
      L3_2 = L3_2.anim
      L4_2 = 3
      L0_2 = L0_2(L1_2, L2_2, L3_2, L4_2)
      L5_1 = L0_2
    else
      L0_2 = L15_1
      if nil ~= L0_2 then
        L0_2 = GetVehicleInFront
        L0_2 = L0_2()
        L3_1 = L0_2
        L0_2 = IsEntityPlayingAnim
        L1_2 = L0_1
        L2_2 = Config
        L2_2 = L2_2.Animations
        L2_2 = L2_2.policeAnimation
        L2_2 = L2_2.animDict
        L3_2 = Config
        L3_2 = L3_2.Animations
        L3_2 = L3_2.policeAnimation
        L3_2 = L3_2.anim
        L4_2 = 3
        L0_2 = L0_2(L1_2, L2_2, L3_2, L4_2)
        L5_1 = L0_2
        L0_2 = L3_1
        if 0 ~= L0_2 then
          L0_2 = 1
          L1_2 = GetNumberOfVehicleDoors
          L2_2 = L3_1
          L1_2 = L1_2(L2_2)
          L2_2 = 1
          for L3_2 = L0_2, L1_2, L2_2 do
            L4_2 = GetEntryPositionOfDoor
            L5_2 = L3_1
            L6_2 = L3_2
            L4_2 = L4_2(L5_2, L6_2)
            L5_2 = Vdist
            L6_2 = GetEntityCoords
            L7_2 = L0_1
            L6_2 = L6_2(L7_2)
            L7_2 = L4_2
            L5_2 = L5_2(L6_2, L7_2)
            L6_2 = 0.8
            if L5_2 < L6_2 then
              L7_1 = L3_2
              L5_2 = true
              L13_1 = L5_2
            end
          end
        else
          L0_2 = false
          L13_1 = L0_2
        end
      end
    end
    L0_2 = Config
    L0_2 = L0_2.CommandEnabled
    if not L0_2 then
      L0_2 = GetVehicleInFront
      L0_2 = L0_2()
      L3_1 = L0_2
      L0_2 = L3_1
      if 0 ~= L0_2 then
        L1_2 = L2_1
        L0_2 = L9_1
        L0_2 = L0_2[L1_2]
        if nil ~= L0_2 then
          L0_2 = L3_1
          L2_2 = L2_1
          L1_2 = L9_1
          L1_2 = L1_2[L2_2]
          if L0_2 == L1_2 then
            L0_2 = Vdist
            L1_2 = GetEntityCoords
            L2_2 = L0_1
            L1_2 = L1_2(L2_2)
            L2_2 = GetEntityCoords
            L3_2 = NetToPed
            L4_2 = L2_1
            L3_2, L4_2, L5_2, L6_2, L7_2 = L3_2(L4_2)
            L2_2, L3_2, L4_2, L5_2, L6_2, L7_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
            L0_2 = L0_2(L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2)
            L8_1 = L0_2
          end
        end
      end
    end
    L0_2 = Citizen
    L0_2 = L0_2.Wait
    L1_2 = 500
    L0_2(L1_2)
  end
end
L20_1(L21_1)
L20_1 = Citizen
L20_1 = L20_1.CreateThread
function L21_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  while true do
    L0_2 = Citizen
    L0_2 = L0_2.Wait
    L1_2 = L6_1
    L0_2(L1_2)
    L0_2 = Config
    L0_2 = L0_2.CommandEnabled
    if L0_2 then
      L0_2 = Config
      L0_2 = L0_2.DropPlayer
      if not L0_2 then
        goto lbl_16
      end
    end
    L0_2 = fExitCar
    L1_2 = false
    L0_2(L1_2)
    ::lbl_16::
    L0_2 = L1_1
    if nil ~= L0_2 then
      L0_2 = pedWalking
      if L0_2 then
        L0_2 = TaskGoStraightToCoord
        L1_2 = L0_1
        L2_2 = GetOffsetFromEntityInWorldCoords
        L3_2 = NetToPed
        L4_2 = L1_1
        L3_2 = L3_2(L4_2)
        L4_2 = 0.0
        L5_2 = 1.2
        L6_2 = 1.32
        L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
        L3_2 = 1.0
        L4_2 = 500
        L5_2 = 130.0
        L6_2 = 0.0
        L0_2(L1_2, L2_2, L3_2, L4_2, L5_2, L6_2)
        L0_2 = L18_1
        L0_2()
        L0_2 = false
        L10_1 = L0_2
      else
        L0_2 = pedSprinting
        if L0_2 then
          L0_2 = TaskGoStraightToCoord
          L1_2 = L0_1
          L2_2 = GetOffsetFromEntityInWorldCoords
          L3_2 = NetToPed
          L4_2 = L1_1
          L3_2 = L3_2(L4_2)
          L4_2 = 0.0
          L5_2 = 8.2
          L6_2 = 1.32
          L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
          L3_2 = 5.0
          L4_2 = 500
          L5_2 = 130.0
          L6_2 = 0.0
          L0_2(L1_2, L2_2, L3_2, L4_2, L5_2, L6_2)
          L0_2 = L18_1
          L0_2()
          L0_2 = false
          L10_1 = L0_2
        else
          L0_2 = L10_1
          if not L0_2 then
            L0_2 = TaskGoStraightToCoord
            L1_2 = L0_1
            L2_2 = GetOffsetFromEntityInWorldCoords
            L3_2 = L0_1
            L4_2 = 0.0
            L5_2 = 0.0
            L6_2 = 1.32
            L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
            L3_2 = 1.0
            L4_2 = 2000
            L5_2 = GetEntityHeading
            L6_2 = L0_1
            L5_2 = L5_2(L6_2)
            L6_2 = 3.0
            L0_2(L1_2, L2_2, L3_2, L4_2, L5_2, L6_2)
            L0_2 = true
            L10_1 = L0_2
          end
        end
      end
      L0_2 = L5_1
      if not L0_2 then
        L0_2 = L19_1
        L1_2 = Config
        L1_2 = L1_2.Animations
        L1_2 = L1_2.citizenAnimation
        L1_2 = L1_2.enabled
        L2_2 = Config
        L2_2 = L2_2.Animations
        L2_2 = L2_2.citizenAnimation
        L2_2 = L2_2.animDict
        L3_2 = Config
        L3_2 = L3_2.Animations
        L3_2 = L3_2.citizenAnimation
        L3_2 = L3_2.anim
        L0_2(L1_2, L2_2, L3_2)
      end
      L0_2 = L4_1
      if L0_2 then
        L0_2 = L11_1
        if not L0_2 then
          L0_2 = true
          L11_1 = L0_2
          L0_2 = TriggerServerEvent
          L1_2 = "ryt:DeadEvent"
          L2_2 = GetPlayerServerId
          L3_2 = L17_1
          L4_2 = NetToPed
          L5_2 = L1_1
          L4_2, L5_2, L6_2 = L4_2(L5_2)
          L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2)
          L2_2, L3_2, L4_2, L5_2, L6_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
          L0_2(L1_2, L2_2, L3_2, L4_2, L5_2, L6_2)
        end
      else
        L0_2 = false
        L11_1 = L0_2
      end
    else
      L0_2 = L15_1
      if nil ~= L0_2 then
        L0_2 = Config
        L0_2 = L0_2.CollisionRange
        if L0_2 > 0.0 then
          L0_2 = SetPedCapsule
          L1_2 = L0_1
          L2_2 = Config
          L2_2 = L2_2.CollisionRange
          L0_2(L1_2, L2_2)
        end
        L0_2 = L18_1
        L0_2()
        L0_2 = Config
        L0_2 = L0_2.DisableSprint
        if L0_2 then
          L0_2 = DisableControlAction
          L1_2 = 0
          L2_2 = 21
          L3_2 = true
          L0_2(L1_2, L2_2, L3_2)
        end
        L0_2 = L4_1
        if L0_2 then
          L0_2 = TriggerEvent
          L1_2 = "ryt:DeadEvent"
          L0_2(L1_2)
        end
        L0_2 = L5_1
        if not L0_2 then
          L0_2 = L19_1
          L1_2 = Config
          L1_2 = L1_2.Animations
          L1_2 = L1_2.policeAnimation
          L1_2 = L1_2.enabled
          L2_2 = Config
          L2_2 = L2_2.Animations
          L2_2 = L2_2.policeAnimation
          L2_2 = L2_2.animDict
          L3_2 = Config
          L3_2 = L3_2.Animations
          L3_2 = L3_2.policeAnimation
          L3_2 = L3_2.anim
          L0_2(L1_2, L2_2, L3_2)
        end
        L0_2 = Config
        L0_2 = L0_2.DropPlayer
        if not L0_2 then
          L0_2 = Config
          L0_2 = L0_2.CommandEnabled
          if L0_2 then
            goto lbl_196
          end
        end
        L0_2 = Hint
        L1_2 = Config
        L1_2 = L1_2.Languages
        L2_2 = Config
        L2_2 = L2_2.Language
        L1_2 = L1_2[L2_2]
        L1_2 = L1_2.releaseperson
        L0_2(L1_2)
        L0_2 = IsControlJustPressed
        L1_2 = 0
        L2_2 = Config
        L2_2 = L2_2.Keys
        L2_2 = L2_2.GrabAndDropKey
        L0_2 = L0_2(L1_2, L2_2)
        if L0_2 then
          L0_2 = fGrab
          L0_2()
        end
        ::lbl_196::
        L0_2 = Config
        L0_2 = L0_2.CommandEnabled
        if L0_2 then
          L0_2 = Config
          L0_2 = L0_2.DropPlayer
          if not L0_2 then
            goto lbl_207
          end
        end
        L0_2 = fPutCar
        L1_2 = false
        L0_2(L1_2)
      end
    end
    ::lbl_207::
  end
end
L20_1(L21_1)
function L20_1()
  local L0_2, L1_2
  L0_2 = L13_1
  return L0_2
end
GetPutCarAvailable = L20_1
function L20_1()
  local L0_2, L1_2, L2_2
  L0_2 = GetVehicleInFront
  L0_2 = L0_2()
  if 0 ~= L0_2 then
    L2_2 = L2_1
    L1_2 = L9_1
    L1_2 = L1_2[L2_2]
    if nil ~= L1_2 then
      L1_2 = true
      return L1_2
    end
  end
  L1_2 = false
  return L1_2
end
GetExitCarAvailable = L20_1
L20_1 = exports
L21_1 = "GetPutCarAvailable"
L22_1 = GetPutCarAvailable
L20_1(L21_1, L22_1)
L20_1 = exports
L21_1 = "GetExitCarAvailable"
L22_1 = GetExitCarAvailable
L20_1(L21_1, L22_1)

function Hint(message)
    SetTextComponentFormat("STRING")
    AddTextComponentString(message)
    DisplayHelpTextFromStringLabel(0, 0, 0, -1)
end

-- AddEventHandler("bus:Init",function()
--     if Active then
--         ...
--     else
--         ...
--         Active = true
--         SetPedConfigFlag(PlayerPedId(), 32, false) -- Impede ejeção
--         MakeBlips()
--     end
-- end)



RegisterCommand("gethash", function()
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local streetHash, crossingHash = GetStreetNameAtCoord(x, y, z)
    local streetName = GetStreetNameFromHashKey(streetHash)
    local crossingName = crossingHash ~= 0 and GetStreetNameFromHashKey(crossingHash) or "Nenhum"

    -- Mensagem no chat
    TriggerEvent("chatMessage", "[HASH]", {255, 0, 0}, 
        "Hash da rua: ^2" .. streetHash .. "^7 ("..streetName.."), Crossing: ^2"..crossingHash.."^7 ("..crossingName..")")

    -- Print no F8 também
    print("Hash da rua: " .. streetHash .. " ("..streetName..")")
    print("Hash do cruzamento: " .. crossingHash .. " ("..crossingName..")")
end)