local Tunnel = module("vrp","lib/Tunnel")
local ResName = GetCurrentResourceName()
vRP = Tunnel.getInterface("vRP")

vSERVER = Tunnel.getInterface(ResName)

local data = {}
local machineId

Functions = {
    closeMachine = function()
        data = {}
        SetNuiFocus(false, false)
        SendNUIMessage({ action = "forceCloseInterface" })
    end,

    openMachineMenu = function(id)

		machineId = id
		local machineData = GlobalState["laundry_" .. id]

		SendNUIMessage({ action = "setConfig", config = { upgrades = upgrades, mathematics = mathematics } })
		SendNUIMessage({ action = "openMachine", data = machineData })
		SetNuiFocus(true, true)
	end,


    tryUpgradeMachine = function(machineId, upgradeType)
		
		local machineData = GlobalState["laundry_" .. machineId]
		local currentLevel = machineData.upgrades[upgradeType]
		local upgradeInfo = upgrades[upgradeType].levels[currentLevel + 1]
        local success = vSERVER.tryUpgradeMachine(machineId, upgradeType)
		Functions.closeMachine()
		
		return success
    end,

    startWashing = function(machineId, amount)
        local machineData = GlobalState["laundry_" .. machineId]
        if machineData.progress then return end

        local success, data = vSERVER.startWashing(machineId, amount)
        if success then

            SendNUIMessage({ action = "openMachine", data = data })
            Functions.closeMachine()
        end
    end,

    tryCollectWashedMoney = function(machineId)
        local success = vSERVER.tryCollectWashedMoney(machineId)
        if success then
            GlobalState["laundry_" .. machineId].progress = nil
            SendNUIMessage({ action = "openMachine", data = GlobalState["laundry_" .. machineId] })
			Functions.closeMachine()
        end
    end,

    tryDepositCleaners = function(machineId, amount)
        local success = vSERVER.tryDepositCleaners(machineId, amount)
        if success then
            GlobalState["laundry_" .. machineId].cleaners = success
            SendNUIMessage({ action = "openMachine", data = GlobalState["laundry_" .. machineId] })
        end
    end,
}

local storedMachines = {}
local function createMachine(coords)

	if #GlobalState["laundry:ObjectsLoaded"] > 0 then return end
	
    local model = 'bkr_prop_prtmachine_dryer_spin'
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    local groundZFound, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z)
	local finalZ = groundZFound and groundZ or coords.z - 1.0


	local success, obj = vRP.CreateObject(model,coords["x"],coords["y"],finalZ)
	if not success then return end
	machineProp = NetworkGetEntityFromNetworkId(obj)
	PlaceObjectOnGroundProperly(machineProp)

    SetEntityHeading(machineProp, coords.w)
    SetEntityInvincible(machineProp, true)
    FreezeEntityPosition(machineProp, true)
	storedMachines[#storedMachines + 1] = obj
	vSERVER.LoadedObjects(storedMachines)
end

RegisterNUICallback('_GET', function(data, cb)
    local action = data.action
	local amount = tonumber(data.amount) or 0
	
    if action == 'tryWashMoney' then
		local success = false
        if amount > 0 then
            success = Functions.startWashing(machineId, amount)
        end
		cb(success)
    elseif action == 'close' then
        SetNuiFocus(false, false)
    elseif action == 'tryUpgradeMachine' then
        local success = Functions.tryUpgradeMachine(machineId, data.upgrade)
        cb(success)
    elseif action == 'tryDepositCleaners' then
        local success = vSERVER.tryDepositCleaners(machineId, amount)
		cb(success)
    elseif action == 'tryCollectWashedMoney' then
        local success = Functions.tryCollectWashedMoney(machineId)
        cb(success)
	elseif action == 'tryCancelProgress' then
		local success = vSERVER.stopProgress(machineId)
		cb(success)
    end
end)

RegisterNetEvent('openMachine',Functions.openMachineMenu)

local useTarget = true
CreateThread(function()
	if useTarget then
		for k,v in pairs(laundries) do

			if v.machine.coords then
				local cds= v.machine.coords
				local x,y,z,w = cds.x, cds.y, cds.z, cds.w
				
				exports["target"]:AddCircleZone("openLaundromat:"..k,vec3(x,y,z),1.35,{
					name = "openLaundromat:"..k,
					heading = 3374176
				},{
					shop = k,
					Distance = v[6] or 1.75,
					options = {
						{
							event = "openMachine",
							label = "Acessar",
							tunnel = "shop"
						}
					}
				})    
			end
		end
	else
		RegisterCommand('+openLaundromat', function(source, args, rawCommand)
			local playerCoords = GetEntityCoords(PlayerPedId())
			for id, laundry in pairs(laundries) do
				local machineCoords = vector3(laundry.machine.coords.x, laundry.machine.coords.y, laundry.machine.coords.z)
				local Permission = vSERVER.Permission(id)

				if Permission and #(playerCoords - machineCoords) <= 1.5 then
					machineId = id
					Functions.openMachineMenu(id)
					break
				end
			end
		end)
		RegisterKeyMapping('+openLaundromat', 'Open Laundromat Menu', 'keyboard', 'E')
	end
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    for id, laundry in pairs(laundries) do
		if laundry.machine.object then
			createMachine(laundry.machine.coords)
		end
    end
end)