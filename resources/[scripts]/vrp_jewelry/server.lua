local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

func = {}
Tunnel.bindInterface("vrp_jewelry",func)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {}
local timers = 0
local andamento = false
local roubando = false
local segundos = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKJEWELRY
-----------------------------------------------------------------------------------------------------------------------------------------
function func.checkJewelry(x,y,z,h,sec,tipo)
	local source = source
	local user_id = vRP.Passport(source)
	local policia = vRP.NumPermission("Police")
	if user_id then
		if #policia < 4 then
			TriggerClientEvent("Notify",source,"amarelo","Número insuficiente de policiais no momento para iniciar o roubo.", 5000)
		elseif (os.time()-timers) <= 5400 then
			TriggerClientEvent("Notify",source,"amarelo","A joalheria não se recuperou do ultimo roubo, aguarde <b>"..parseInt((5400-(os.time()-timers))).." segundos</b> até que o sistema seja restaurado.", 5000)
		else
			if vRP.TakeItem(user_id,"floppy",1) and not roubando then
				roubando = true
				vRPclient._playAnim(source,false,{"anim@heists@prison_heistig1_p1_guard_checks_bus","loop"},true)
				TriggerClientEvent('iniciandojewelry',source,x,y,z,h,sec,tipo,true)
				local firewall = math.random(100)
				SetTimeout(sec*1000,function()
					if firewall >= 20 then
						segundos = 600
						andamento = true
						timers = os.time()
						TriggerClientEvent('iniciandojewelry',source,x,y,z,h,sec,tipo,false)
						TriggerClientEvent("Notify",source,"verde","A proteção do <b>Baidu Antivirus</b> foi comprometida e todos os balcões foram liberados.", 5000)
						SetTimeout(20000,function()
							func.callPolice(x,y,z)
						end)
					else
						roubando = false
						func.callPolice(x,y,z)
						TriggerClientEvent('iniciandojewelry',source,x,y,z,h,sec,tipo,false)
						TriggerClientEvent("Notify",source,"amarelo","O computador é protegido pelo <b>Baidu Antivirus</b>, ele bloqueou sua conexão, tente novamente.", 5000)
					end
				end)
			else
				TriggerClientEvent("Notify",source,"azul","Precisa de um <b>Disket</b> para hackear as câmeras de segurança.", 5000)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CALLPOLICE
-----------------------------------------------------------------------------------------------------------------------------------------
function func.callPolice(x,y,z)
	local source = source
	TriggerClientEvent("vrp_sound:fixed",-1,source,x,y,z,100,'alarm',0.7)
	local policia = vRP.NumPermission("Police")
	for l,w in pairs(policia) do
		local player = vRP.Source(parseInt(w))
		if player then
			async(function()
				TriggerClientEvent("NotifyPush",player,{ code = 31, title = "Roubo a Joalheria", x = x, y = y, z = z, time = "Recebido às "..os.date("%H:%M"), blipColor = 22 })
				vRPclient.PlaySound(player,"Beep_Green","DLC_HEIST_HACKING_SNAKE_SOUNDS")
			end)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETURNJEWELRY
-----------------------------------------------------------------------------------------------------------------------------------------
function func.returnJewelry()
	return andamento
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMEROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
local timers = {}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k,v in pairs(timers) do
			if v > 0 then
				timers[k] = v - 1
			end
		end
		if andamento then
			segundos = segundos - 1
			if segundos <= 0 then
				timers = {}
				andamento = false
				roubando = false
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKJEWELS
-----------------------------------------------------------------------------------------------------------------------------------------
local jewels = {
	[1] = { item = "ouro" },
	[2] = { item = "ouro" },
	[3] = { item = "ouro" },
	[4] = { item = "ouro" },
	[5] = { item = "ouro" }
}

function func.checkJewels(id,x,y,z,h,tipo)
	local source = source
	local user_id = vRP.Passport(source)
	if user_id then
		if timers[id] == 0 or not timers[id] then
			timers[id] = 600
			TriggerClientEvent('iniciandojewelry',source,x,y,z,h,10,tipo,true)
			vRPclient._playAnim(source,false,{"oddjobs@shop_robbery@rob_till","loop"},true)
			SetTimeout(10000,function()
				vRP.GenerateItem(user_id,jewels[math.random(5)].item,math.random(20,30))
			end)
		else
			TriggerClientEvent("Notify",source,"amarelo","O balcão está vazio, aguarde <b>"..parseInt(timers[id]).." segundos</b> até que a loja se recupera do ultimo roubo.", 5000)
		end
	end
end