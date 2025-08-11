Routes = {
    coords = {},
    time = {},
    alerts = {}
}

function RegisterTunnel.checkPermission(mainIndex)
    local user_id = vRP.Passport(source)
    if not user_id or not mainIndex then
        return
    end
    for i=1, #ConfigMainRoutes.mainBlips[mainIndex].permissions do
        if vRP.hasPermission(user_id,ConfigMainRoutes.mainBlips[mainIndex].permissions[i]) then
            return true
        end
    end
    return false
end

function RegisterTunnel.paymentRoutes(typeReward,directionRoute,indexRoute,itemFarm,typeRoute)
    if not typeRoute or not directionRoute or not indexRoute or not typeReward then
        print("Erro: ",typeReward,directionRoute,indexRoute,itemFarm,typeRoute)
        return
    end
    local user_id = vRP.Passport(source)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local distance = #(ConfigRoutes.locs[typeRoute][directionRoute][indexRoute].coords - coords)
    --[ DISTANCIA DO BLIP ]--
    if distance >= ConfigMainRoutes.distAlt then
        Routes.alerts[user_id] = Routes:checkUserAlerts(user_id) + 1
        print("^0ID: ^3"..user_id.."^0 Suspeito de TriggerEvent, Motivo:^3 Distancia Longa do blip")
        return
    end

    --[ PAGAMENTO EM POUCO TEMPO ]--
    if (os.time() - Routes:checkUserTime(user_id)) <= ConfigMainRoutes.timeAlt then
        Routes.alerts[user_id] = Routes:checkUserAlerts(user_id) + 1
        print("^0ID: ^3"..user_id.."^0 Suspeito de TriggerEvent, Motivo:^3 Tempo")
        return
    end
    Routes.time[user_id] = os.time()

    --[ DISNTACIA MUITO PROXIMA DE UM PAGAMENTO E OUTRO ]--
    local nDistance = #(coords - Routes:checkUserCoords(user_id))
    if nDistance <= 10 then
        Routes.alerts[user_id] = Routes:checkUserAlerts(user_id) + 1
        print("^0ID: ^3"..user_id.."^0 Suspeito de TriggerEvent, Motivo:^3 Distancia Proxima")
        return
    end
    Routes.coords[user_id] = coords

    --[ PAGAMENTO LIBERADO ]--

    for i=1,#ConfigRoutes.rewards[typeReward][itemFarm]["items"] do
        local valueIndexed = ConfigRoutes.rewards[typeReward][itemFarm]["items"][i]
        local amount
        if directionRoute == "north" then
            amount = math.random(valueIndexed.min, valueIndexed.max) * 2
        else
            amount = math.random(valueIndexed.min, valueIndexed.max)
        end

        if vRP.InventoryWeight(user_id) + (itemWeight(valueIndexed.item) * amount) >= vRP.GetWeight(user_id) then
            TriggerClientEvent("Notify",source,"vermelho","Sua mochila está cheia.", 5000)
            break
        end


        vRP.GiveItem(user_id,valueIndexed.item,amount,true)
    end

end

function Routes:checkUserCoords(user_id)
    return Routes.coords[user_id] or vec3(0,0,0)
end

function Routes:checkUserTime(user_id)
    return Routes.time[user_id] or 0
end

function Routes:checkUserAlerts(user_id)
    return Routes.alerts[user_id] or 0
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
    Routes.coords[user_id] = vec3(0,0,0)
    Routes.time[user_id] = 0
    Routes.alerts[user_id] = 0
end)