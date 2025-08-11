local vehData = {}

vRP.Prepare('sjr/selectAll', "SELECT * FROM 0r_mechanics")
vRP.Prepare('sjr/selectUnique', 'SELECT * FROM 0r_mechanics WHERE plate = @plate')
vRP.Prepare('sjr/updateVeh', "UPDATE 0r_mechanics SET data = @data WHERE plate = @plate")
vRP.Prepare('sjr/insertVeh', "INSERT INTO 0r_mechanics (plate, data) VALUES (@plate, @data)")

Citizen.CreateThread(function()
    local result = vRP.Query('sjr/selectAll', {})
    if #result > 0 then
        for plate, data in pairs(result) do
            vehData[data.plate] = json.decode(data.data)
        end
    end
end)

addElement = function(section, data)
    if not vehData[data.plate] then
        vehData[data.plate] = {}
    end

    if section == "fitment" then
        vehData[data.plate][section] = data.fitment
    elseif data.mod == "Stock" then
        vehData[data.plate][section] = nil
    else
        vehData[data.plate][section] = data.mod
    end


    local output = vRP.Query('sjr/selectUnique', { plate = data.plate})
    if #output > 0 then
        vRP.Query('sjr/updateVeh', { plate = data.plate, data = json.encode(vehData[data.plate])})
    else
        vRP.Query('sjr/insertVeh', { plate = data.plate, data = json.encode(vehData[data.plate])})
    end

    TriggerClientEvent("0r-mechanic:client:updateVehData", -1, vehData)
end

RegisterServerEvent("0r-mechanic:server:syncFitment", function(vehicleId, fitmentData)
    TriggerClientEvent("0r-mechanic:client:syncFitment", -1, vehicleId, fitmentData)
end)

RegisterServerEvent("0r-mechanic:server:useNitro", function(vehicleId)
    TriggerClientEvent("0r-mechanic:client:useNitro", -1, vehicleId)
end)

RegisterServerEvent("0r-mechanic:server:addElement", addElement)

RegisterServerEvent("tunning:syncApplyMods")
AddEventHandler("tunning:syncApplyMods",function(vehicle,vehicle_tuning)
    TriggerClientEvent("tunning:applyTunning",-1,vehicle, vehicle_tuning)
end)

-- RegisterServerEvent("tunning:applyTunning")
-- AddEventHandler("tunning:applyTunning",function(vehicle,plate)
-- 	local user_id = vRP.getUserByRegistration(plate)
-- 	local data = vRP.getSData("custom:u"..user_id.."veh_"..tostring(vehname))
-- 	local custom = json.decode(data)
--     if custom then
-- 		TriggerClientEvent("tunning:applyTunning",-1,vehicle, custom)
--     end
-- end)

Citizen.CreateThread(function()

    src.checkPermission = function(perm)
        local source = source
        local user_id = vRP.Passport(source)
        if user_id then
            return vRP.HasPermission(user_id, perm)
        end
        return false
    end

    src.buyComponent = function(data, mods)
        local source = source
        local xPlayer = GetPlayer(source)

        if not xPlayer then
            return
        end
        if vRP.PaymentFull(xPlayer,data.price) then
           -- vRP.setSData("custom:u" .. nuser_id .. "veh_" .. tostring(data.model),json.encode(mods))
            vRP.Query("entitydata/SetData",{ dkey = "Mods:"..data.plate, dvalue = json.encode(mods) })
            return {status = true}
        end


        Notification(Config.Locale["dont_have_money"])
        return {status = false}
    end

    src.buyBasketData = function(data, mods)
        local source = source
        local user_id = vRP.Passport(source)
        if user_id then
            local type = data[1]
            local basketData = data[2]
            local currentMechanic = data[3]
            local plate = data[4]
            local totalPrice = 0
            if next(basketData) then
                for k,v in pairs(basketData) do
                    if v.component.price then
                        totalPrice += v.component.price
                    end
                end
            end


            if vRP.PaymentFull(user_id,totalPrice) then
                vRP.Query("entitydata/SetData",{ dkey = "Mods:"..plate, dvalue = json.encode(mods) })
                -- local nuser_id = vRP.getUserByRegistration(plate)
                -- if nuser_id then
                --     vRP.setSData("custom:u" .. nuser_id .. "veh_" .. tostring(model),json.encode(mods))
                -- end
                return {status = true}
            end
        


            Notification(Config.Locale["dont_have_money"])
            return {status = false}
        end
        return {status = false}
    end
    src.getVehData = function()
        return vehData
    end
end)






