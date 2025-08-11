-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("trucker",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKEXIST
-----------------------------------------------------------------------------------------------------------------------------------------
local Trucker = {}
local webhookcaminhao = "https://discord.com/api/webhooks/1296125627048525824/iV1OPUHrpTtOKHQgP3oSop_LVDXe59RwNGTu6FffMDiR6rjWABC8N7sn8yg6xbezLxSU"

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKEXIST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkExist()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not Trucker[Passport] then
			Trucker[Passport] = os.time()
		end

		if os.time() >= Trucker[Passport] then
			return true
		else
			local truckerTimers = parseInt(Trucker[Passport] - os.time())
			TriggerClientEvent("Notify",source,"azul","Aguarde <b>"..MinimalTimers(truckerTimers).."</b> para trabalhar novamente.",5000)
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELIVERY
-----------------------------------------------------------------------------------------------------------------------------------------
local Delivery = {
	["vehicles"] = {
		{ ["item"] = "dollars", ["min"] = 13000, ["max"] = 15000 },
	},
	["diesel"] = {
		{ ["item"] = "dollars", ["min"] = 13000, ["max"] = 15000 },
	},
	["fuel"] = {
		{ ["item"] = "dollars", ["min"] = 13000, ["max"] = 15000 },
	},
	["wood"] = {
		{ ["item"] = "dollars", ["min"] = 13000, ["max"] = 15000 },
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Payment(Service)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasPermission(Passport,"Premium") or vRP.HasGroup(Passport,"Premium")  then
			Trucker[Passport] = os.time() + 11600
		else
			Trucker[Passport] = os.time() + 46400
		end

		for k,v in pairs(Delivery[Service]) do
			local Rand = math.random(v["min"],v["max"])
			vRP.GenerateItem(Passport,v["item"],Rand,true)
			vRP.SendWebhook(webhookcaminhao, "LOGs Trucker", "**Passaporte: **"..Passport.."\n**Conclui a entrega e recebeu: **"..Rand.." "..v["item"], 10357504)

		end
		FamilyExperience(source)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FAMILYEXPERIENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function FamilyExperience(Source)
    local Player = Player(Source)["state"]
	local Passport = vRP.Passport(Source)
    if Player["Family"] then
        local XpAmount = math.random(25,35)		
		TriggerEvent("us_families:AddXP",Passport,Player["Family"],XpAmount,"Crafting")
    end
end