local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

Hiro = {}
Tunnel.bindInterface("jobdeliver",Hiro)
--------------------------------------------------------------------------------------------------------------------------------------------
----PAGAMENTO
--------------------------------------------------------------------------------------------------------------------------------------------
-- function Hiro.Payment(distancia)
-- 	local source = source
-- 	local Passport = vRP.Passport(source)
-- 	if Passport then
-- 	local payment = distancia * 0.1
--         payment = payment / 0.20 
-- 		vRP.GiveItem(Passport,config.item,math.floor(payment)) 
-- 		TriggerClientEvent("sounds:Private",source,"cash",0.1)
-- 		TriggerClientEvent("Notify",source,"verde","Entrega feita, vá buscar mais entregas no restaurante",9000)
-- 		return payment
-- 	end
-- end
function Hiro.Payment(distancia)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local payment = distancia * 0.5  -- ajuste o fator de multiplicação conforme necessário
        if payment < 200 then
            payment = 200
        elseif payment > 400 then
            payment = 400
        end
        vRP.GiveItem(Passport, config.item, math.floor(payment))
        TriggerClientEvent("sounds:Private", source, "cash", 0.1)
        TriggerClientEvent("Notify", source, "verde", "Entrega feita, vá buscar mais entregas no restaurante", 9000)
        return payment
    end
end
--------------------------------------------------------------------------------------------------------------------------------------------
----TELEPORT
--------------------------------------------------------------------------------------------------------------------------------------------
function Hiro.teleport(x,y,z)
	local source = source
 	vRPclient.teleport(source,x,y,z)
end
--------------------------------------------------------------------------------------------------------------------------------------------
----DELETAR
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trydeleteveh554")
AddEventHandler("trydeleteveh554",function(index)
	TriggerClientEvent("garages:Delete",source,index[3])
end)