-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
Cargas = {}
local itemrouboBenson = "WEAPON_CROWBAR"
local itemrouboBenson2 = "lockpick"
local MinPoliciaBenson = -3
local maxRobbBenson = 7

local RyanBypassBenson = false
local var = "Desativado"

RegisterCommand("Faly2", function(source, args, rawCommand)
    local Passport = vRP.Passport(source)
    if vRP.HasGroup(Passport, "Admin") then		
        
        RyanBypassBenson = not RyanBypassBenson
		if RyanBypassBenson then
			var = "Ativado"
		else
			var = "Desativado"
		end
        TriggerClientEvent("Notify", source, "amarelo", "Bypass de policia para Benson "..var.." ",false,5000)
    end
end, false)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BENSONLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local BensonList = {
	"keyboard", "mouse", "playstation", "xbox", "dish", "fan", "blender", "switch", "cup", "lampshade", "watch",
	"bracelet", "spray01", "spray02", "spray03", "spray04", "slipper", "soap", "eraser",
	"dices", "floppy", "horseshoe", "deck", "tinner"
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:STOCKADE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Benson")
AddEventHandler("inventory:Benson",function(Vehicle)
	local source = source
	local Plate = Vehicle[1]
	local Passport = vRP.Passport(source)
	local Service = vRP.NumPermission("PoliciaMilitar") + vRP.NumPermission("Core") + vRP.NumPermission("PRF") + vRP.NumPermission("PCivil")
	-- if CooldownBenson and os.time() < CooldownBenson then
    --     local CooldownNotify = MinimalTimers(CooldownBenson - os.time())
	-- 	TriggerClientEvent("Notify", source, "azul", "Aguarde <b>" .. CooldownNotify .. "</b>.", 5000)        
    --     return false
    -- end

	if not Active[Passport] then
		if not vRP.PassportPlate(Plate) or RyanBypassBenson then
			if Total >= MinPoliciaBenson or RyanBypassBenson then
				if true then --if vRP.HasService(Passport,"Ilegal") then												
					TriggerClientEvent("roberrys:openDoors",-1,Vehicle[4],"benson")
					if not vCLIENT.checkWeapon(source, itemrouboBenson) then
						TriggerClientEvent("Notify",source,"amarelo","Você precisa colocar o <b>"..itemName(itemrouboBenson).."</b> em mãos.",5000)
						return false
					end

					if not Cargas[Plate] then
						local Consult = vRP.InventoryItemAmount(Passport, itemrouboBenson2, 1)
	
						if Consult[1] >= 1 and not vRP.CheckDamaged(Consult[2]) then 
							vRP.TakeItem(Passport, Consult[2], 1, false)
							vRP.GiveItem(Passport, "placainvasora-0", 1, false)
							TriggerClientEvent("NotifyItens",source,{ "-",itemIndex(itemrouboBenson2),1,itemName(itemrouboBenson2) })
							
						else
							TriggerClientEvent("Notify",source,"amarelo","Você precisa de <b>"..itemName(itemrouboBenson2).."</b>.",5000)
							return false
						end					
					end
					
					vRPC.playAnim(source,false,{ "anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer" },true)
					if vTASKBAR.taskLockpick(source) then
						if not Cargas[Plate] then
							Cargas[Plate] = maxRobbBenson
							CooldownBenson = os.time() + 3600

							local Coords = vRP.GetEntityCoords(source)
							local Service = vRP.NumPermission("PoliciaMilitar") + vRP.NumPermission("Core") + vRP.NumPermission("PRF") + vRP.NumPermission("PCivil")
							for Passports,Sources in pairs(Service) do
								async(function()
									vRPC.PlaySound(Sources,"ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")
									TriggerClientEvent("NotifyPush",Sources,{ code = 20, title = "Roubo Caminhão de Cargas", x = Coords["x"], y = Coords["y"], z = Coords["z"], criminal = "Alarme de segurança", time = "Recebido às "..os.date("%H:%M"), blipColor = 16 })
								end)
							end
						end

						if Cargas[Plate] <= 0 then
							TriggerClientEvent("Notify",source,"amarelo","Compartimento vazio.",5000)
							vRPC.stopAnim(source)
							-- DeleteEntity dps de 1 min
							SetTimeout(60000, function()
								TriggerEvent("nation:deleteVehicle", Vehicle[4])
							end)
							return false
						end

						
						TriggerClientEvent("roberrys:Destroy", -1, Vehicle[4])
						
						vCLIENT.StockadeExtras(source)
						Active[Passport] = os.time() + 15
						Cargas[Plate] = Cargas[Plate] - 1
						Player(source)["state"]["Buttons"] = true
						TriggerClientEvent("Progress",source,"Roubando",15000)
						vRPC.playAnim(source,false,{"oddjobs@shop_robbery@rob_till","loop"},true)

						repeat
							if Active[Passport] and os.time() >= parseInt(Active[Passport]) then
								Active[Passport] = nil
								vRPC.stopAnim(source, false)
								Player(source)["state"]["Buttons"] = false

								local Coords = vRP.GetEntityCoords(source)
								local Service = vRP.NumPermission("PoliciaMilitar") + vRP.NumPermission("Core") + vRP.NumPermission("PRF") + vRP.NumPermission("PCivil")
								for Passports,Sources in pairs(Service) do
									async(function()
										vRPC.PlaySound(Sources,"ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")
										TriggerClientEvent("NotifyPush",Sources,{ code = 20, title = "Roubo Caminhão de Cargas", x = Coords["x"], y = Coords["y"], z = Coords["z"], criminal = "Alarme de segurança", time = "Recebido às "..os.date("%H:%M"), blipColor = 16 })
									end)
								end
								
								local randomItem = BensonList[math.random(#BensonList)]
								local amountItem = math.random(10, 15)
								vRP.GenerateItem(Passport, randomItem, amountItem, true)
								local Coords = vRP.GetEntityCoords(source)
								--LOG--
								-- exports["vrp"]:Embed("Cargas",
								-- "```prolog\n[Benson]\n[Passaporte]: "..Passport.." \n[Item]: "..itemName(randomItem).." \n[Qtd]: "..amountItem.."\n[Coordenadas]: "..Coords.x..","..Coords.y..","..Coords.z
								-- ..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```",
								-- 0xa3c846)
								--LOG--
							end

							Wait(100)
						until not Active[Passport]
					else
						vRPC.stopAnim(source, false)
					end
				else
					TriggerClientEvent("Notify", source, "amarelo", "Você não consegue fazer isto.", 5000)
				end
			else
				TriggerClientEvent("Notify", source, "amarelo", "Contingente indisponível.", 5000)
			end
		else
			TriggerClientEvent("Notify", source, "amarelo", "Veículo protegido pela seguradora.", 5000)
		end
	end
end)
						