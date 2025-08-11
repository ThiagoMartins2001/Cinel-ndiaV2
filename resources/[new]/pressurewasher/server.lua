local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

src = {}
Tunnel.bindInterface("pressurewasher", src)
Proxy.addInterface("pressurewasher", src)

src.checkPayment = function(value)
	local source = source
	local user_id = vRP.Passport(source)
	if user_id then
		return vRP.PaymentFull(user_id, value)
	end
end
	