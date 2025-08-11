-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy  = module("vrp","lib/Proxy")
local config = module("ps_staff","config")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
psRP = {}
Tunnel.bindInterface("ps_staff",psRP)
vSERVER = Tunnel.getInterface("ps_staff")

----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("adminp", "Adminp", "keyboard", "INSERT")

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local menuEnabled = false
local chatEnabled = false
local chatStaffEnabled = false -- Nova variável para chat staff

RegisterNetEvent('spawnarveiculo')
AddEventHandler('spawnarveiculo',function(name,plate)
	local mhash = GetHashKey(name)
	while not HasModelLoaded(mhash) do
		RequestModel(mhash)
		Citizen.Wait(10)
	end

	if HasModelLoaded(mhash) then
		local ped = PlayerPedId()
		local nveh = CreateVehicle(mhash,GetEntityCoords(ped),GetEntityHeading(ped),true,false)

		NetworkRegisterEntityAsNetworked(nveh)
		while not NetworkGetEntityIsNetworked(nveh) do
			NetworkRegisterEntityAsNetworked(nveh)
			Citizen.Wait(1)
		end

		SetVehicleOnGroundProperly(nveh)
		SetVehicleAsNoLongerNeeded(nveh)
		SetVehicleIsStolen(nveh,false)
		SetPedIntoVehicle(ped,nveh,-1)
		SetVehicleNeedsToBeHotwired(nveh,false)
		SetEntityInvincible(nveh,false)
		SetVehicleNumberPlateText(nveh,plate)
		Citizen.InvokeNative(0xAD738C3085FE7E11,nveh,true,true)
		SetVehicleHasBeenOwnedByPlayer(nveh,true)
		SetVehRadioStation(nveh,"OFF")
		SetVehicleDoorsLocked(nveh,2)

		SetModelAsNoLongerNeeded(mhash)
	end
end)

RegisterNetEvent('ps_staff:OpenTablet')
AddEventHandler('ps_staff:OpenTablet', function()
    if vSERVER.checkPermission() then
        ToggleActionMenu()
    end
end)

-- Evento para receber notificações de mudanças em grupos
RegisterNetEvent('ps_staff:groupChanged')
AddEventHandler('ps_staff:groupChanged', function(data)
    -- Enviar notificação para o JavaScript
    SendNUIMessage({
        action = "groupChanged",
        data = data
    })
end)

-- Evento para receber notificações de mudanças em players
RegisterNetEvent('ps_staff:playerChanged')
AddEventHandler('ps_staff:playerChanged', function(data)
    -- Enviar notificação para o JavaScript
    SendNUIMessage({
        action = "playerChanged",
        data = data
    })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ToggleActionMenu
-----------------------------------------------------------------------------------------------------------------------------------------
function ToggleActionMenu()
	menuEnabled = not menuEnabled
	if menuEnabled then
		SetNuiFocus(true,true)

        local staff    = vSERVER.getStaffData()
        local users    = vSERVER.getAllUsers()
        local groups   = vSERVER.getAllGroups()
        local vehicles = vSERVER.getAllVehicles()
        local items    = vSERVER.getAllItems()

        SendNUIMessage({ action = "loadstaff", staff = staff })
        SendNUIMessage({ action = "loadusers", users = users })
        SendNUIMessage({ action = "loadgroups", groups = groups })
        SendNUIMessage({ action = "loadvehicles", vehicles = vehicles })
        SendNUIMessage({ action = "loaditems", items = items })
        SendNUIMessage({ action = "showmenu" })

		config.starttablet()
	else
		SetNuiFocus(false,false)
		SendNUIMessage({ action = "hidemenu" })
		config.stoptablet()
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ToggleActionChat
-----------------------------------------------------------------------------------------------------------------------------------------
function ToggleActionChat()
	chatEnabled = not chatEnabled
	if chatEnabled then
		SetNuiFocus(true,true)

        local messages = vSERVER.getChatMessages()

        SendNUIMessage({ action = "loadmessages", messages = messages })
        SendNUIMessage({ action = "showchat" })

		config.starttablet()
	else
		SetNuiFocus(false,false)
		SendNUIMessage({ action = "hidechat" })
		config.stoptablet()
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ToggleActionChatStaff (NOVA FUNÇÃO)
-----------------------------------------------------------------------------------------------------------------------------------------
function ToggleActionChatStaff()
	chatStaffEnabled = not chatStaffEnabled
	if chatStaffEnabled then
		SetNuiFocus(true,true)

        local messages = vSERVER.getChatStaffMessages()

        SendNUIMessage({ action = "loadchatstaffmessages", messages = messages })
        SendNUIMessage({ action = "openchatstaff" })

		config.starttablet()
	else
		SetNuiFocus(false,false)
		SendNUIMessage({ action = "closechatstaff" })
		config.stoptablet()
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand opentablet
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(config.commands.opentablet, function(source, args, rawCommand)
    if vSERVER.checkPermission() then
        ToggleActionMenu()
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand openchat
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(config.commands.openchat, function(source, args, rawCommand)
    if vSERVER.checkChatOpen() then
        ToggleActionChat()
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand chatstaff (NOVO COMANDO)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('chatstaff', function(source, args, rawCommand)
    if vSERVER.checkChatStaffOpen() then
        ToggleActionChatStaff()
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- close
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close", function(data, cb)
    if chatStaffEnabled then
        ToggleActionChatStaff()
    elseif chatEnabled then
        ToggleActionChat()
    else
        ToggleActionMenu()
    end
    cb(true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- getuser
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("getuser", function(data, cb)
    local data = vSERVER.getUser(tonumber(data.id))
    cb(data)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- addgroup
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("addgroup", function(data, cb)
    local data = vSERVER.addGroup(tonumber(data.id), data.group, data.level)
    cb(data)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- remgroup
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("remgroup", function(data, cb)
    local data = vSERVER.remGroup(tonumber(data.id), data.group)
    cb(data)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- addban
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("addban", function(data, cb)
    local data = vSERVER.addBan(tonumber(data.id), tonumber(data.time), data.reason)
    cb(data)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- deleteban
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("deleteban", function(data, cb)
    local data = vSERVER.deleteBan(tonumber(data.id), tonumber(data.user_id))
    cb(data)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- editban
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("editban", function(data, cb)
    local data = vSERVER.editBan(tonumber(data.id), tonumber(data.time))
    cb(data)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAT STAFF CALLBACKS (NOVOS)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("getchatstaffmessages", function(data, cb)
    local messages = vSERVER.getChatStaffMessages()
    cb({ messages = messages })
end)

RegisterNUICallback("sendchatstaffmessage", function(data, cb)
    local result = vSERVER.sendChatStaffMessage(data.message)
    cb(result)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- spawnitem
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("spawnitem", function(data, cb)
    local data = vSERVER.spawnItem(data.item, data.amount, data.id)
    cb(data)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- spawnvehicle
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("spawnvehicle", function(data, cb)
    local data = vSERVER.spawnVehicle(data.id, data.vehicle)
    cb(data)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- addvehicle
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("addvehicle", function(data, cb)
    local data = vSERVER.addVehicle(data.id, data.vehicle)
    cb(data)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- removevehicle
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("removevehicle", function(data, cb)
    local data = vSERVER.removeVehicle(tonumber(data.user_id), data.vehicle, data.plate)
    cb(data)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- notify
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("notify", function(data, cb)
    TriggerEvent("Notify", data.type, data.message, 5000)
    cb(true)
end)

RegisterNUICallback("getOnlinePlayers", function(data, cb)
    local count = vSERVER.getOnlinePlayers()
    cb({count = count})
end)

RegisterNUICallback("getOnlineStaff", function(data, cb)
    local count = vSERVER.getOnlineStaff()
    cb({count = count})
end)

RegisterNUICallback("getOnlinePolice", function(data, cb)
    local count = vSERVER.getOnlinePolice()
    cb({count = count})
end)

RegisterNUICallback("getOnlinePRF", function(data, cb)
    local count = vSERVER.getOnlinePRF()
    cb({count = count})
end)

RegisterNUICallback("getOnlinePCivil", function(data, cb)
    local count = vSERVER.getOnlinePCivil()
    cb({count = count})
end)

RegisterNUICallback("getOnlineCore", function(data, cb)
    local count = vSERVER.getOnlineCore()
    cb({count = count})
end)

RegisterNUICallback("getOnlineOficina01", function(data, cb)
    local count = vSERVER.getOnlineOficina01()
    cb({count = count})
end)

RegisterNUICallback("getOnlineOficina012", function(data, cb)
    local count = vSERVER.getOnlineOficina012()
    cb({count = count})
end)

RegisterNUICallback("getOnlineHarmony", function(data, cb)
    local count = vSERVER.getOnlineHarmony()
    cb({count = count})
end)

RegisterNUICallback("getOnlineJudiciary", function(data, cb)
    local count = vSERVER.getOnlineJudiciary()
    cb({count = count})
end)

RegisterNUICallback("getOnlineParamedic", function(data, cb)
    local count = vSERVER.getOnlineParamedic()
    cb({count = count})
end)

RegisterNUICallback("getOnlineBurgerShot", function(data, cb)
    local count = vSERVER.getOnlineBurgerShot()
    cb({count = count})
end)

RegisterNUICallback("getOnlinePearls", function(data, cb)
    local count = vSERVER.getOnlinePearls()
    cb({count = count})
end)

RegisterNUICallback("getAllStaffMembers", function(data, cb)
    local group = data and data.group or "Admin"
    local staffList = vSERVER.getAllStaffMembers(group)
    cb(staffList or {})
end)

RegisterNUICallback("getAllPoliceMembers", function(data, cb)
    local staffList = vSERVER.getAllStaffMembers("Police")
    cb(staffList or {})
end)

function psRP.CreateVehicleDurateston(Model,Network,Engine,Health,Customize,Windows,Tyres)
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			if Customize ~= nil then
				local Mods = json.decode(Customize)
				VehicleMods(Vehicle,Mods)
			end

			SetVehicleEngineHealth(Vehicle,Engine + 0.0)
			SetEntityHealth(Vehicle,Health)

			if Windows then
				local Windows = json.decode(Windows)
				if Windows ~= nil then
					for k,v in pairs(Windows) do
						if not v then
							RemoveVehicleWindow(Vehicle,parseInt(k))
						end
					end
				end
			end

			if Tyres then
				local Tyres = json.decode(Tyres)
				if Tyres ~= nil then
					for k,Burst in pairs(Tyres) do
						if Burst then
							SetVehicleTyreBurst(Vehicle,parseInt(k),true,1000.0)
						end
					end
				end
			end

			if Model == "maverick2" then
				if LocalPlayer["state"]["Police"] then
					SetVehicleLivery(Vehicle,0)
				elseif LocalPlayer["state"]["Paramedic"] then
					SetVehicleLivery(Vehicle,1)
				end
			end

			if not DecorExistOn(Vehicle,"PlayerVehicle") then
				DecorSetInt(Vehicle,"PlayerVehicle",-1)
			end

			SetModelAsNoLongerNeeded(Model)
		end
	end
end