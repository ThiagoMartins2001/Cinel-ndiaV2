local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local ResName = GetCurrentResourceName()
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")

API = {}
Tunnel.bindInterface(ResName,API)
vCLIENT = Tunnel.getInterface(ResName)

GlobalState["laundry:ObjectsLoaded"] = {}

local function storedData(machineId)
    return GlobalState["laundry_" .. machineId]
end

local function saveLaundryData(id, data)
    local laundryData = {}
    for id, _ in pairs(laundries or {}) do
        laundryData[tostring(id)] = GlobalState["laundry_" .. id]
    end
    SaveResourceFile(ResName, 'database.json', json.encode(laundryData))
end

local function updateStoredData(machineId, data)
    GlobalState["laundry_" .. machineId] = data
    saveLaundryData(machineId, data)
end

local reset = false
local function loadLaundryData()

	if reset then
		for id, _ in pairs(laundries) do
            updateStoredData(id, { id = id, upgrades = { potency = 0, efficiency = 0 }, cleaners = 0, progress = nil })
        end
	end
	
    local file = not reset and LoadResourceFile(ResName, 'database.json') or ''
    if file then
        local laundryData = json.decode(file) or {}
        for id, machine in pairs(laundryData) do
            updateStoredData(id, machine)
        end
    else
        for id, _ in pairs(laundries) do
            GlobalState["laundry_" .. id] = {
				id = id,
                upgrades = {
                    potency = 0,
                    efficiency = 0
                },
                cleaners = 0,
                progress = nil
            }
        end
    end
end

loadLaundryData()

local function Permission(source, machineId)
	local Passport = vRP.Passport(source)
	local permission = laundries[machineId]?.permission
	local canUse = not permission or #permission == 0 or false
	
	for _, Perm in pairs(permission or {}) do

		if not canUse and string.len(Perm) > 0 then
			if vRP.HasPermission(Passport, Perm) or vRP.HasGroup(Passport,Perm) then
				canUse = true
				break
			end
		end
	end
	return canUse
end

function API.Permission(machineId)
	return Permission(source, machineId)
end

function API.LoadedObjects(objects)
	GlobalState["laundry:ObjectsLoaded"] = objects
end

function API.stopProgress(machineId)
	local data = storedData(machineId)
	if data.progress then
		local Passport = vRP.Passport(source)
		vRP.GiveItem(Passport, items.dirty_money, data.progress.amount, true)
		TriggerClientEvent('Notify', source, 'verde', "Lavagem cancelada com sucesso.", 5000)
		data.progress = nil
		updateStoredData(machineId, data)
		return true
	end
	return false
end

function API.startWashing(machineId, amount)
	
	if not Permission(source, machineId) then return end
	
    local Passport = vRP.Passport(source)
    local dirtyMoney = vRP.InventoryItemAmount(Passport, items.dirty_money)[1]
    local cleaners = storedData(machineId)?.cleaners or 0

    local cleanersNeeded = math.ceil(amount / mathematics.base_value) * mathematics.cleaner_cost

    if dirtyMoney < amount then
        TriggerClientEvent('Notify', source, 'amarelo', "Dinheiro sujo insuficiente.", 5000)
        return false
    end

    if cleaners < cleanersNeeded or (cleaners - cleanersNeeded) < 0 then
        TriggerClientEvent('Notify', source, 'amarelo', "Limpadores insuficientes.", 5000)
        return false
    end

    vRP.RemoveItem(Passport, items.dirty_money, amount, true)
    local data = storedData(machineId)

    local time = mathematics.wash_time * (amount / mathematics.base_value)
    local tax = amount * (mathematics.tax_percent / 100)
    local result = amount - tax
    local potencyLevel = data.upgrades.potency
    local timeReduction = upgrades.potency.levels[potencyLevel] and upgrades.potency.levels[potencyLevel].time_reduce_percent or 0
    time = time - (time * (timeReduction / 100))

    data.progress = {
        amount = amount,
		result = result,
        start_time = os.time(),
        total_time = time,
        cleaners = cleanersNeeded
    }
    
	data.cleaners -= cleanersNeeded
    TriggerClientEvent('Notify', source, 'verde', "Lavagem iniciada com sucesso.", 5000)

    updateStoredData(machineId, data)
    return true, data
end

function API.tryDepositCleaners(machineId, amount)
    local source = source
    local Passport = vRP.Passport(source)
    local cleanersAmount = vRP.InventoryItemAmount(Passport, items.cleaner)[1]

    if cleanersAmount < amount then
        TriggerClientEvent('Notify', source, 'amarelo', "Quantidade de limpadores insuficiente.", 5000)
        return false
    end

    vRP.RemoveItem(Passport, items.cleaner, amount, true)
    local data = storedData(machineId)
    data.cleaners = (data.cleaners or 0) + amount
    updateStoredData(machineId, data)
    return data.cleaners
end

function API.finishWashing(machineId)
    if not storedData(machineId).progress then
        TriggerClientEvent('Notify', source, 'amarelo', "Nenhuma lavagem em andamento.", 5000)
        return false
    end

    local currentTime = os.time()
    local startTime = storedData(machineId).progress.start_time
    local totalTime = storedData(machineId).progress.total_time
    local remainingTime = totalTime - (currentTime - startTime)

    if remainingTime > 0 then
        TriggerClientEvent('Notify', source, 'amarelo', "A lavagem ainda não está concluída.", 5000)
        return false
    end

    local Passport = vRP.Passport(source)
    vRP.GiveItem(Passport, items.clean_money, storedData(machineId).progress.result, true)
    TriggerClientEvent('Notify', source, 'verde', "Dinheiro lavado coletado com sucesso.", 5000)

    local data = storedData(machineId)
    data.progress = nil
    updateStoredData(machineId, data)
    return true
end

function API.tryCollectWashedMoney(machineId)
	
	if not Permission(source, machineId) then return end
	
    if not storedData(machineId).progress then
        TriggerClientEvent('Notify', source, 'amarelo', "Nenhuma lavagem em andamento.", 5000)
        return false
    end

    local currentTime = os.time()
    local startTime = storedData(machineId).progress.start_time
    local totalTime = storedData(machineId).progress.total_time
    local remainingTime = totalTime - (currentTime - startTime)

    if remainingTime > 0 then
        TriggerClientEvent('Notify', source, 'amarelo', "A lavagem ainda não está concluída.", 5000)
        return false
    end

    local Passport = vRP.Passport(source)
    vRP.GiveItem(Passport, items.clean_money, storedData(machineId).progress.result, true)
    TriggerClientEvent('Notify', source, 'verde', "Dinheiro lavado coletado com sucesso.", 5000)

    local data = storedData(machineId)
    data.progress = nil
    updateStoredData(machineId, data)
    return true
end

function API.tryUpgradeMachine(machineId, upgradeType)
    local source = source
    local Passport = vRP.Passport(source)
    local currentLevel = storedData(machineId).upgrades[upgradeType]
    local maxLevel = #upgrades[upgradeType].levels

    if currentLevel < maxLevel then
        local upgradeInfo = upgrades[upgradeType].levels[currentLevel + 1]
        if vRP.TakeItem(Passport, items.clean_money, upgradeInfo.price, true) then

            local data = storedData(machineId)
            data.upgrades[upgradeType] = currentLevel + 1
            updateStoredData(machineId, data)
            TriggerClientEvent('Notify', source, 'verde', "Máquina aprimorada com sucesso.", 5000)
            return true
        else
            TriggerClientEvent('Notify', source, 'amarelo', "Dinheiro insuficiente para o upgrade.", 5000)
            return false
        end
    else
        TriggerClientEvent('Notify', source, 'amarelo', "Máquina já está no nível máximo.", 5000)
        return false
    end
end

CreateThread(function()
    while true do
        Wait(1000)
        
        local currentTime = os.time()
        GlobalState["Time"] = currentTime
        
        for id, _ in pairs(laundries) do
            local machineData = storedData(id)
            if machineData.progress then
                local startTime = machineData.progress.start_time
                local totalTime = machineData.progress.total_time
                local elapsedTime = currentTime - startTime
                local remainingTime = totalTime - elapsedTime

                if remainingTime > 0 then
                    machineData.progress.remaining_time = remainingTime
                else
                    machineData.progress.remaining_time = -1
                end

                updateStoredData(id, machineData)
                saveLaundryData(id, machineData)
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(Name)

	if Name ~= GetCurrentResourceName() then return end
	
	local objects = GlobalState["laundry:ObjectsLoaded"]

	for _, v in pairs(objects) do
		local obj = NetworkGetEntityFromNetworkId(v)
		
		if DoesEntityExist(obj) then
			DeleteEntity(obj)
		end
	end
	
	GlobalState["laundry:ObjectsLoaded"] = {}
	
end)