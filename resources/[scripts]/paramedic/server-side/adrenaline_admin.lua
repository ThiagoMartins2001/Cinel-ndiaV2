-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vCLIENT = Tunnel.getInterface("paramedic")
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDO PARA ADICIONAR LOCAL DE ADRENALINA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("addadrenalinelocation", function(source, args, rawCommand)
    local Passport = vRP.Passport(source)
    if Passport and vRP.HasPermission(Passport, "Admin") then
        local playerCoords = GetEntityCoords(GetPlayerPed(source))
        local locationName = args[1] or "Local " .. os.time()
        local radius = tonumber(args[2]) or 30.0
        
        -- Aqui você pode implementar a lógica para salvar o local no banco de dados
        -- Por enquanto, apenas mostra as coordenadas
        TriggerClientEvent("Notify", source, "verde", "Local de adrenalina adicionado: " .. locationName .. " | Raio: " .. radius .. "m", 5000)
        print("^2[ADRENALINA]^7 Novo local adicionado por " .. Passport .. ": " .. locationName .. " em " .. playerCoords.x .. ", " .. playerCoords.y .. ", " .. playerCoords.z)
    end
end, false)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDO PARA LISTAR LOCAIS DE ADRENALINA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("listadrenalinelocations", function(source, args, rawCommand)
    local Passport = vRP.Passport(source)
    if Passport and vRP.HasPermission(Passport, "Admin") then
        local locations = exports["paramedic"]:GetAdrenalineLocations()
        TriggerClientEvent("Notify", source, "azul", "Locais de adrenalina carregados: " .. #locations, 5000)
        for i, location in ipairs(locations) do
            print("^3[ADRENALINA]^7 " .. i .. ". " .. location.Name .. " - Raio: " .. location.Radius .. "m")
        end
    end
end, false)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDO PARA TESTAR LOCAL DE ADRENALINA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("testadrenalinelocation", function(source, args, rawCommand)
    local Passport = vRP.Passport(source)
    if Passport then
        local playerCoords = GetEntityCoords(GetPlayerPed(source))
        local isInLocation, locationName = exports["paramedic"]:IsInAdrenalineLocation(playerCoords)
        
        if isInLocation then
            TriggerClientEvent("Notify", source, "verde", "Você está em local permitido: " .. locationName, 5000)
        else
            TriggerClientEvent("Notify", source, "vermelho", "Você NÃO está em local permitido para usar adrenalina", 5000)
        end
    end
end, false)

-- Comando para recarregar o sistema de adrenalina
RegisterCommand("reloadadrenaline", function(source, args, rawCommand)
    local Passport = vRP.Passport(source)
    if Passport and vRP.HasPermission(Passport, "Admin") then
        print("^2[ADRENALINA]^7 Recarregando sistema de adrenalina...")
        TriggerClientEvent("Notify", source, "azul", "Sistema de adrenalina recarregado!", 5000)
        
        -- Forçar recarga dos exports
        local locations = exports["paramedic"]:GetAdrenalineLocations()
        if locations then
            print("^2[ADRENALINA]^7 " .. #locations .. " locais carregados:")
            for i, location in ipairs(locations) do
                print("   " .. i .. ". " .. location.Name .. " - Raio: " .. location.Radius .. "m")
            end
        end
    end
end, false)
