-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("garages", Creative)
vSERVER = Tunnel.getInterface("garages")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DECORATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
DecorRegister("Player_Vehicle", 3)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local Searched = nil
local Hotwired = false
local Anim = "machinic_loop_mechandplayer"
local Dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEMODS
-----------------------------------------------------------------------------------------------------------------------------------------
function VehicleMods(Vehicle,Customize)
    TriggerEvent("lscustoms:Apply",Vehicle,Customize)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNPOSITION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SpawnPosition(Select)
    local Slot = "0"
    local Checks = 0
    local Selected = {}
    local Position = nil

    repeat
        Checks = Checks + 1

        Slot = tostring(Checks)
        if GaragesCoords[Select] and GaragesCoords[Select][Slot] then
            local _, CoordsZ = GetGroundZFor_3dCoord(GaragesCoords[Select][Slot][1], GaragesCoords[Select][Slot][2],
                GaragesCoords[Select][Slot][3])
            Selected = { GaragesCoords[Select][Slot][1], GaragesCoords[Select][Slot][2], CoordsZ, GaragesCoords[Select]
                [Slot][4] }
            Position = GetClosestVehicle(Selected[1], Selected[2], Selected[3], 2.5, 0, 71)
        end
    until not DoesEntityExist(Position) or not GaragesCoords[Select][Slot]

    if not GaragesCoords[Select][tostring(Checks)] then
        TriggerEvent("Notify", "amarelo", "Vagas estão ocupadas.", "Atenção", 5000)
        return false
    end

    SendNUIMessage({ Action = "Close" })
	SetNuiFocus(false,false)

    return Selected
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CreateVehicle(Model, Network, Engine, Health, Customize, Windows, Tyres)
    if NetworkDoesNetworkIdExist(Network) then
        local Vehicle = NetToEnt(Network)
        if DoesEntityExist(Vehicle) then
            if Customize ~= nil then
                local Mods = json.decode(Customize)
                VehicleMods(Vehicle, Mods)
            end

            -- if Brakes[1] ~= nil then
            --     if Brakes[1] > 0.90 then
            --         Brakes[1] = 0.90
            --     end
            -- end

            -- if Brakes[2] ~= nil then
            --     if Brakes[2] > 0.55 then
            --         Brakes[2] = 0.55
            --     end
            -- end

            -- if Brakes[3] ~= nil then
            --     if Brakes[3] > 0.75 then
            --         Brakes[3] = 0.75
            --     end
            -- end

            -- SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fBrakeForce", Brakes[1] or 0.90)
            -- SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fBrakeBiasFront", Brakes[2] or 0.55)
            -- SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fHandBrakeForce", Brakes[3] or 0.75)

            SetVehicleEngineHealth(Vehicle, Engine + 0.0)
            SetVehicleHasBeenOwnedByPlayer(Vehicle, true)
            SetVehicleNeedsToBeHotwired(Vehicle, false)
            DecorSetInt(Vehicle, "Player_Vehicle", -1)
            SetVehicleOnGroundProperly(Vehicle)
            SetVehRadioStation(Vehicle, "OFF")
            SetEntityHealth(Vehicle, Health)

            if Windows then
                local Windows = json.decode(Windows)
                if Windows ~= nil then
                    for Index, v in pairs(Windows) do
                        if not v then
                            RemoveVehicleWindow(Vehicle, parseInt(Index))
                        end
                    end
                end
            end

            if Tyres then
                local Tyres = json.decode(Tyres)
                if Tyres ~= nil then
                    for Index, Burst in pairs(Tyres) do
                        if Burst then
                            SetVehicleTyreBurst(Vehicle, parseInt(Index), true, 1000.0)
                        end
                    end
                end
            end

            if not DecorExistOn(Vehicle, "Player_Vehicle") then
                DecorSetInt(Vehicle, "Player_Vehicle", -1)
            end

            if GetVehicleClass(Vehicle) == 14 then
                SetBoatAnchor(Vehicle, true)
            end

            SetModelAsNoLongerNeeded(Model)
            
           
        end
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:DELETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:Delete")
AddEventHandler("garages:Delete", function(Vehicle)
    if not Vehicle or Vehicle == "" then
        Vehicle = vRP.ClosestVehicle(15)
    end

    if IsEntityAVehicle(Vehicle) and (not Entity(Vehicle)["state"]["Tow"] or LocalPlayer["state"]["Admin"]) then
        local Tyres = {}
        local Doors = {}
        local Windows = {}

        for i = 0, 5 do
            Doors[i] = IsVehicleDoorDamaged(Vehicle, i)
        end

        for i = 0, 5 do
            Windows[i] = IsVehicleWindowIntact(Vehicle, i)
        end

        for i = 0, 7 do
            local Status = false

            if GetTyreHealth(Vehicle, i) ~= 1000.0 then
                Status = true
            end

            Tyres[i] = Status
        end

        if DecorExistOn(Vehicle, "Player_Vehicle") then
            DecorRemove(Vehicle, "Player_Vehicle")
        end

        vSERVER.Delete(VehToNet(Vehicle), GetEntityHealth(Vehicle), GetVehicleEngineHealth(Vehicle),
            GetVehicleBodyHealth(Vehicle), GetVehicleFuelLevel(Vehicle), Doors, Windows, Tyres,
            GetVehicleNumberPlateText(Vehicle),
            { GetVehicleHandlingFloat(Vehicle, "CHandlingData", "fBrakeForce"), GetVehicleHandlingFloat(Vehicle,
                "CHandlingData", "fBrakeBiasFront"), GetVehicleHandlingFloat(Vehicle, "CHandlingData", "fHandBrakeForce") })
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCHBLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SearchBlip(Coords)
    if DoesBlipExist(Searched) then
        RemoveBlip(Searched)
        Searched = nil
    end

    Searched = AddBlipForCoord(Coords["x"], Coords["y"], Coords["z"])
    SetBlipSprite(Searched, 225)
    SetBlipColour(Searched, 77)
    SetBlipScale(Searched, 0.6)
    SetBlipAsShortRange(Searched, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Veículo")
    EndTextCommandSetBlipName(Searched)

    SetTimeout(30000, function()
        RemoveBlip(Searched)
        Searched = nil
    end)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTHOTWIRED
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.StartHotwired()
    Hotwired = true

    if LoadAnim(Dict) then
        TaskPlayAnim(PlayerPedId(), Dict, Anim, 8.0, 8.0, -1, 49, 1, 0, 0, 0)
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPHOTWIRED
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.StopHotwired(Vehicle)
    Hotwired = false

    if LoadAnim(Dict) then
        StopAnimTask(PlayerPedId(), Dict, Anim, 8.0)
    end

    if Vehicle then
        SetVehicleHasBeenOwnedByPlayer(Vehicle, true)
        SetVehicleNeedsToBeHotwired(Vehicle, false)
        DecorSetInt(Vehicle, "Player_Vehicle", -1)
        SetVehRadioStation(Vehicle, "OFF")
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEHOTWIRED
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.UpdateHotwired(Status)
    Hotwired = Status
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTERDECORS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.RegisterDecors(Vehicle)
    SetVehicleHasBeenOwnedByPlayer(Vehicle, true)
    SetVehicleNeedsToBeHotwired(Vehicle, false)
    DecorSetInt(Vehicle, "Player_Vehicle", -1)
    SetVehRadioStation(Vehicle, "OFF")
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOOPHOTWIRED
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        local TimeDistance = 999

        local Ped = PlayerPedId()
        if IsPedInAnyVehicle(Ped) then
            local Vehicle = GetVehiclePedIsUsing(Ped)
            local Plate = GetVehicleNumberPlateText(Vehicle)
            if GetPedInVehicleSeat(Vehicle, -1) == Ped and Plate ~= "PDMSPORT" and not GlobalState["Plates"][Plate] and not Entity(Vehicle)["state"]["Lockpick"] then
                SetVehicleEngineOn(Vehicle, false, true, true)
                DisablePlayerFiring(Ped, true)
                TimeDistance = 1
            end

            if Hotwired and Vehicle then
                DisableControlAction(0, 75, true)
                DisableControlAction(0, 20, true)
                TimeDistance = 1
            end
        end

        Wait(TimeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:IMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:Impound")
AddEventHandler("garages:Impound", function()
    local Impound = vSERVER.Impound()
    if parseInt(#Impound) > 0 then
        for k, v in pairs(Impound) do
            exports["dynamic"]:AddButton(v["name"], "Clique para iniciar a liberação.", "garages:Impound", v["Model"],false, true)
        end

        exports["dynamic"]:Open()
    else
        TriggerEvent("Notify", "amarelo", "Você não possui veículos apreendidos.", "Atenção", 5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    local Tables = {}
    for _, v in pairs(GaragesCoords) do
        Tables[#Tables + 1] = { v["x"], v["y"], v["z"], 1.25, "E", "Garagem",
            "Pressione para abrir" }
    end
    TriggerEvent("hoverfy:Insert", Tables)

    while true do
        local TimeDistance = 999
        local Ped = PlayerPedId()
        if not IsPedInAnyVehicle(Ped) then
            local Coords = GetEntityCoords(Ped)

            for Number, v in pairs(GaragesCoords) do
                local Distance = #(Coords - vec3(v["x"], v["y"], v["z"]))
                if Distance <= 5.0 then
                    TimeDistance = 1

                    if Distance <= 1.25 and IsControlJustPressed(1, 38) and not LocalPlayer["state"]["usingPhone"] and not LocalPlayer["state"]["Target"] then
                        -- if vSERVER.Verify(Number) then
                            local Vehicles = vSERVER.Vehicles(Number)
                            if Vehicles then
                                Opened = Number
                                SetNuiFocus(true, true)
                                TriggerEvent("target:Debug")
                                SendNUIMessage({ Action = "Open", Payload = Vehicles })
                            end
                        end
                    end
                end
            -- end
        end

        Wait(TimeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close", function(Data, Callback)
    SetNuiFocus(false, false)

    Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:Close")
AddEventHandler("garages:Close", function()
    SendNUIMessage({ name = "Close" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Spawn",function(Data,Callback)
	TriggerServerEvent("garages:Spawn",Data["Model"],Opened)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Delete", function(Data, Callback)
    TriggerEvent("garages:Delete")

    Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAXVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Tax",function(Data,Callback)
	TriggerServerEvent("garages:Tax",Data["Model"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SELLVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Sell",function(Data,Callback)
	TriggerServerEvent("garages:Sell",Data["Model"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFERVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Transfer",function(Data,Callback)
	TriggerServerEvent("garages:Transfer",Data["Model"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:PROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:Propertys")
AddEventHandler("garages:Propertys", function(Table)
    for Name, v in pairs(Table) do
        GaragesCoords[Name] = {
            ["x"] = v["x"],
            ["y"] = v["y"],
            ["z"] = v["z"],
            ["1"] = v["1"]
        }
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:CLEAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:Clean")
AddEventHandler("garages:Clean", function(Name)
    if GaragesCoords[Name] then
        GaragesCoords[Name] = nil
    end
end)
