local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vSERVER = Tunnel.getInterface("giant-k9")

local Dog
local Follow = true
local Sit = false
local Down = false
local inVehicle = false
Relationship = nil
garbage = nil

RegisterCommand('dog',function(source,args,rawCommand)
   TriggerEvent('giant-k9:dogspawn')
end)

RegisterNetEvent('giant-k9:dogspawn', function()
	if not Relationship then
		garbage, Relationship = AddRelationshipGroup('doggroup')
		SetRelationshipBetweenGroups(0, Relationship, Relationship)
	end
	if not DoesEntityExist(Dog) then
		local hash = HashGrabber('a_c_shepherd')
		local Player = PlayerPedId()
		local PlayerCoords = GetEntityCoords(Player)
		local PlayerHeading = GetEntityHeading(Player)
		local plyCoords = GetOffsetFromEntityInWorldCoords(Player, 0.0, 1.0, 0.0)
		Dog = CreatePed(3, hash, PlayerCoords.x, (PlayerCoords.y+2), (PlayerCoords.z-1), PlayerHeading, true, true)
		TaskSetBlockingOfNonTemporaryEvents(Dog, true)
		SetEntityMaxHealth(Dog, Config.DogMaxHp)
		SetEntityHealth(Dog, Config.DogMaxHp)
		SetEntityAsMissionEntity(Dog)
		SetPedCombatRange(Dog, 2)
		SetPedFleeAttributes(Dog, 0, 0)
		SetPedCombatMovement(Dog, 3)
		GiveWeaponToPed(Dog, GetHashKey("WEAPON_ANIMAL"), 1, true, true)
		SetPedCombatAttributes(Dog, 3, true)
		SetPedCombatAttributes(Dog, 5, true)
        SetPedCombatAttributes(Dog, 46, true)
		TriggerEvent('giant-k9:dogactions')
		SetPedRelationshipGroupHash(PlayerPedId(), Relationship)
		SetPedRelationshipGroupHash(Dog, Relationship)
	else
		DeleteEntity(Dog)
		RemoveRelationshipGroup(Relationship)
	end
end)

RegisterNetEvent('giant-k9:dogactions', function()
	CreateThread(function()
		while DoesEntityExist(Dog) do
			local DogCoord = GetEntityCoords(Dog)
			local Sleep = 0
			if IsControlJustReleased(0,Config.FollowCommand) then
				ClearPedTasks(Dog)
				Sleep = 2000
				Follow = true
			end
			Wait(Sleep)
		end
	end)
	
	CreateThread(function()
		local Near1 = 0
		while DoesEntityExist(Dog) do
			local Sleep = 1000
			if Follow then
				local Player = PlayerPedId()
				local PlayerCoord = GetEntityCoords(Player)
				local DogCoord = GetEntityCoords(Dog)
				local Dist = #(PlayerCoord - DogCoord)
				if not inVehicle then
					local DogMove = IsPedWalking(Dog) or IsPedRunning(Dog) or IsPedSprinting(Dog)
					if not DogMove then
						ClearPedTasks(Dog)
						TaskGoToEntity(Dog, Player, -1, 0.8, 8.0, 1073741824, 0)
					elseif Near1 == Dist then
						ClearPedTasks(Dog)
					end
				end
				Near1 = Dist
			end
			Wait(Sleep)
		end
	end)
	
	CreateThread(function()
		while DoesEntityExist(Dog) do
			local Player = PlayerPedId()
			local Sleep = 1000
			if IsPedInAnyVehicle(Player, false) and Follow then
				local Vehicle = GetVehiclePedIsIn(Player, false)
				if IsVehicleSeatAccessible(Dog, Vehicle, 1, true, true) then
					inVehicle = true
					TaskEnterVehicle(Dog, Vehicle, 2000, 1, 2, 1, 0)
					Wait(4000)
					TaskWarpPedIntoVehicle(Dog, Vehicle, 1)
				elseif IsVehicleSeatAccessible(Dog, Vehicle, 2, true, true) then
					inVehicle = true
					TaskEnterVehicle(Dog, Vehicle, 2000, 1, 2, 1, 0)
					Wait(4000)
					TaskWarpPedIntoVehicle(Dog, Vehicle, 2)
				else
					Follow = false
					AnimationSitDog()
				end
				while inVehicle do
					if not IsPedInAnyVehicle(Player, false) and Follow then
						Wait(500)
						inVehicle = false
						local DogCoords = GetEntityCoords(Player)
						local DogHP = GetEntityMaxHealth(Dog)
                       	SetEntityCoords(Dog,DogCoords.x, DogCoords.y+1.5, DogCoords.z-0.8)
						Wait(100)
						PlaceObjectOnGroundProperly(Dog)
						SetEntityHealth(Dog, DogHP)
					end
					Wait(750)
				end
			end
			Wait(Sleep)
		end
	end)
	
	CreateThread(function()
		while DoesEntityExist(Dog) do
			local Sleep = 0
			if IsControlJustReleased(0,Config.StayCommand) then
				Sleep = 1000
				Follow = false
				local spot = math.random(1,2)
				if spot == 1 then
					AnimationSitDog()
				else
					AnimationLayDog()
				end
				while not Follow do
					Wait(100)
				end
			else
				Sleep = 0
			end
			Wait(Sleep)
		end
	end)
	
	CreateThread(function()
        while DoesEntityExist(Dog) do
            local Player = PlayerPedId()
            local _, targetentity = GetEntityPlayerIsFreeAimingAt(PlayerId())
            local Sleep = 500
            if IsEntityAPed(targetentity) then
                local target = tonumber(GetPlayerServerId(NetworkGetPlayerIndexFromPed(targetentity)))
                Sleep = 0
                if IsControlJustReleased(0,Config.SearchCommand) then
                    StopAttack()
                    TriggerEvent('giant-k9:searching', target,targetentity)
                elseif IsControlJustReleased(0,Config.AttackCommand) then
                    StopAttack()
					TaskCombatPed(Dog, targetentity, 0, 16)
                    TriggerEvent('giant-k9:client:attacking', targetentity)
                end
            end
            Wait(Sleep)
        end
    end)
end)

RegisterNetEvent('giant-k9:client:attacking', function(target)
	Follow = false
	TaskCombatPed(Dog, target, 0, 16)
end)

RegisterNetEvent('giant-k9:searching', function(target,entity)
    local hasItem = false
    local DogCoord = GetEntityCoords(Dog)
    local PlayerCoord = GetEntityCoords(entity)
	result = vSERVER.SearchPeople(target)
	hasItem = result
    while #(PlayerCoord - DogCoord) >= 1.5 do 
		PlayerCoord = GetEntityCoords(entity)
        DogCoord = GetEntityCoords(Dog)
        if #(PlayerCoord - DogCoord) >= 5 then
            TaskGoStraightToCoord(Dog, PlayerCoord, 2.0, -1, 0.0, 0.0)
        else
            TaskGoStraightToCoord(Dog, PlayerCoord, 1.0, -1, 0.0, 0.0)
            if #(PlayerCoord - DogCoord) <= 1.5 then
                ClearPedTasks(Dog)
                break
            end
        end
        Wait(0)
    end 
    Wait(1000)
    if hasItem then
        TaskTurnPedToFaceEntity(Dog,entity,-1)
        AnimationSitDog()
	else
		AnimationLayDog()
    end
end)

function StopAttack()
	ClearPedTasks(Dog)
	Follow = false
end

function HashGrabber(model)
    local hash = GetHashKey(model)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        Wait(10)
    end
    while not HasModelLoaded(hash) do
      Wait(10)
    end
    return hash
end

function AnimationSitDog()
    RequestAnimDict('creatures@rottweiler@amb@world_dog_sitting@base')
    while not HasAnimDictLoaded('creatures@rottweiler@amb@world_dog_sitting@base') do
        Wait(10)
    end
    TaskPlayAnim(Dog,'creatures@rottweiler@amb@world_dog_sitting@base','base', 8.0, 8.0, -1, 1, 0, 0, 0, 0)
end

function AnimationLayDog()
    RequestAnimDict('creatures@rottweiler@amb@sleep_in_kennel@')
    while not HasAnimDictLoaded('creatures@rottweiler@amb@sleep_in_kennel@') do
        Wait(10)
    end
    TaskPlayAnim(Dog,'creatures@rottweiler@amb@sleep_in_kennel@','sleep_in_kennel', 8.0, 8.0, -1, 1, 0, 0, 0, 0)
end

AddEventHandler('onResourceStop', function(resource)
	if GetCurrentResourceName() == resource then
		if DoesEntityExist(Dog) then
			DeleteEntity(Dog)
		end
	end
end)
