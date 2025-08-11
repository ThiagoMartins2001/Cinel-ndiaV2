Routes = {
    inService = false,
    myTypeRoute = nil,
    myTypeReward = nil,
    myRouteIndex = 1,
    myMainIndex = 0,
    blip = false
}

CreateThread(function()
    while true do
        local idle = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        if not Routes.inService then
            for k,v in pairs(ConfigMainRoutes.mainBlips) do
                local distance = #(v.coords - coords)
                if distance <= 2 then
                    idle = 1
                    DrawText3Ds(v.coords[1],v.coords[2],v.coords[3],ConfigMainRoutes.textBlip.text)
                    if distance <= 2 then
                        if IsControlJustReleased(1,38) then
                            Routes.myMainIndex = k
                            if vTunnel.checkPermission(Routes.myMainIndex) then
                                Routes.myTypeRoute = v.typeRoute
                                Routes.myTypeReward = v.typeReward
    
                                SetNuiFocus(true,true)
                                TransitionToBlurred(1000)
                                SendNUIMessage({ action = 'open', data = {
                                    itens = ConfigRoutes.rewards[Routes.myTypeReward], 
                                    benchName = Routes.myTypeReward
                                } })
                            else
                                TriggerEvent("Notify","vermelho","Você não possui permissão.",5000)
                            end
                        end
                    end
                end
            end
        end

        if Routes.inService then
            idle = 1
            drawTxt("~w~Aperte ~r~F7~w~ se deseja finalizar o expediente.", 0.215,0.94)
            if IsControlJustReleased(1,168) then
                RemoveBlip(Routes.blip)
                Routes.inService = false
                Routes.myTypeRoute = nil
                Routes.myTypeReward = nil
                Routes.myRouteIndex = 1
                Routes.myMainIndex = 0
                Routes.blip = false
                TriggerEvent("Notify","vermelho","Você finalizou a rota de coletas!", 5000)
            end
        end

        Wait(idle)
    end
end)

function Routes:initRoutes(itemFarm,directionRoute)
    if not itemFarm or not directionRoute then
        return
    end

    self.inService = true

    self:createCheckpoint(ConfigRoutes.locs[self.myTypeRoute][directionRoute][self.myRouteIndex].coords)
    TriggerEvent("Notify","verde","Foi marcado o local de coleta no seu GPS.", 5000)

    CreateThread(function()
        while self.inService do
            local idle = 1000
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local nCoords = ConfigRoutes.locs[self.myTypeRoute][directionRoute][self.myRouteIndex].coords
            local distance = #(nCoords - coords)
            
            if distance <= 5 then
                idle = 1

                local bowz,cdz = GetGroundZFor_3dCoord(nCoords[1],nCoords[2],nCoords[3])
                DrawMarker(20,nCoords[1],nCoords[2],cdz+0.4,0,0,0,0,180.0,130.0,0.46,1.0,0.46, 255,0,0,125 ,1,0,0,1)

                if IsControlJustReleased(1,38) then

                    --[ PAYMENT FUNCTION ]--

                    vTunnel._paymentRoutes(self.myTypeReward,directionRoute,self.myRouteIndex,itemFarm,self.myTypeRoute)

                    --[ CREATE NEW BLIP ]--

                    self.myRouteIndex = self.myRouteIndex + 1

                    if self.myRouteIndex >= #ConfigRoutes.locs[self.myTypeRoute][directionRoute] then
                        self.myRouteIndex = 1
                    end

                    RemoveBlip(self.blip)

                    self:createCheckpoint(ConfigRoutes.locs[self.myTypeRoute][directionRoute][self.myRouteIndex].coords)

                    vRP._playAnim(true,{{"pickup_object","pickup_low"}},false)
                    FreezeEntityPosition(ped,true)
                    SetTimeout(ConfigMainRoutes.freezeTime*1000,function()
                        FreezeEntityPosition(ped,false)
                    end)
                end
            end

            Wait(idle)
        end
    end)

end

function Routes:createCheckpoint(coords)
    self.blip = AddBlipForCoord(coords[1],coords[2],coords[3])
    SetBlipSprite(self.blip,1)
    SetBlipColour(self.blip,1)
    SetBlipScale(self.blip,0.4)
    SetBlipAsShortRange(self.blip,false)
    SetBlipRoute(self.blip,true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Coleta")
    EndTextCommandSetBlipName(self.blip)
end

