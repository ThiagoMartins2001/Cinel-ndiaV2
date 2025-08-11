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
Tunnel.bindInterface("chest",Creative)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Open = {}

local Webhooks = {
	["Personal"] = {
		"https://discord.com/api/webhooks/1355376222900719828/H4UIzHWjcOXtdtEJ8XwgjUSa3jx5PNz0XCtVyRCE8h4L-lD-C9XSwSpsvzkMh0naBJTU",
	
	},
	["Evidences"] = {
		"https://discord.com/api/webhooks/1355376222900719828/H4UIzHWjcOXtdtEJ8XwgjUSa3jx5PNz0XCtVyRCE8h4L-lD-C9XSwSpsvzkMh0naBJTU",
		
	},
	["Police"] = {
		"https://discord.com/api/webhooks/1355376222900719828/H4UIzHWjcOXtdtEJ8XwgjUSa3jx5PNz0XCtVyRCE8h4L-lD-C9XSwSpsvzkMh0naBJTU",
	
	},
	["Mechanic"] = {
		"https://discord.com/api/webhooks/1355376377637109861/uv9IxsgDvN_vvXezoPp-cppKTsx1U32GISWwjGhhk1xYjMTRMM7XvnxoOTnvBSbylz7r",
	
	},


	["LiderFavela01"] = {
		"https://discord.com/api/webhooks/1362536558489768177/DgKcMZvRr-Kcdmv2Ku9EPGXteMESEi756Pg_QYnlHAkgkaUUQbWtCsK8CNLVRns3Z5eP",
	},
	["Favela01"] = {
		"https://discord.com/api/webhooks/1355376473493475562/-UjPhw5WTtgxnevK1rrycetokQKnvUq8Lr8ShzsVG08FpzWe0Iex8xZxWOvNKOWVy381",
	},


	["LiderFavela02"] = {
		"https://discord.com/api/webhooks/1362536715574710323/SetH939tr7nZC0aln4NpLoKjl4O_bPw2o7YME45y5P6Xhqh5pLWp6FC7UUB78RYKrm-9",
	},
	["Favela02"] = {
		"https://discord.com/api/webhooks/1362536815671906424/tj2R9aOQf3xLbLMeDYhaDkVkbuEt6N2oRrwbw_knLZU_Y-5VFwNCne6C3at1pAi2ak39"
	},


	["LiderFavela03"] = {
		"https://discord.com/api/webhooks/1362536973478396144/qxL0Uh3dCMbynlCthSAmSPl1-rJV-b9aNCWsg17xJI08KpQ4Gfiyfs7nBy-CRsuP8VqJ",
	},
	["Favela03"] = {
		"https://discord.com/api/webhooks/1362537042604589278/qJUoBD52Ti56wk-taq-I5DAYELNIiVVPOrE6NhqbvU5cPkr34djOAegkUo3fETnLpvGB",

	},


	["LiderFavela04"] = {
		"https://discord.com/api/webhooks/1362537201526767747/9OahNfuQcWcalltLy1JN4rZ9TCHRhLCHZG3zFXZH0LHlbSW4Vc3ic5i-RsDMAl8FnZ0Z",
	},
	["Favela04"] = {
		"https://discord.com/api/webhooks/1362537199106654380/h-HQkHmAobqjpfvqtzgOg12w6M4AfqvExLm16XtPcePPgLYgisy-H4KGvGMa1YiVtMKa",
	
	},

	["LiderFavela05"] = {
		"https://discord.com/api/webhooks/1362537387581767940/GNNEEzBCoJGyi8B9j3K7-A8L1kWwgHiqJAs0XxnAzJCVomsokhKNiSRC6cL7YKLNfCj1",
	},
	["Favela05"] = {
		"https://discord.com/api/webhooks/1362537452757192837/PHlgfr6WGeVyp4xRvKHY1kHeio1-RlftYQE4iI_GKmQzfGQ9iFp9dqWeUKEIAKtsm5iP",
	},



	["LiderMcdonalds"] = {
		"https://discord.com/api/webhooks/1362537772321083583/bRuq-d9J76Apewwb4RSDOlRyOZPxoMJwTZmBaHQKDd5ElxLgZH7R5eZfSVx4oUdpbua5",
		
	},
	["Mcdonalds"] = {
		"https://discord.com/api/webhooks/1362537865933754398/2mxtY4pa6ZubMzPLjf7Y_6jBHJ9SZGyuIy_JBA13PEmBz182GHL6Z8wRmpLv2Gx7qAmY",
		
	},


	
	["LiderIfrut"] = {
		"https://discord.com/api/webhooks/1362537998188806329/wdbAJXxM4qsq6ND5kGLp0JKMvk7eFXyJSE6m1LZhqE189ihyagaAN24vA0n4SL8EWyQ7",
		
	},
	["Ifrut-ilegal"] = {
		"https://discord.com/api/webhooks/1362542289074786595/dPlpxv_5PB-66naUB58EkDTI1HSuYJWUIxf83KvNAN6n433HXVk546LQoJmySF8p9Ny2",
		
	},
	["Ifrut"] = {
		"https://discord.com/api/webhooks/1362538061099175996/JDvJvMSWtQW2OKNeRfnxW--_VxCg-ig-dbLBn8roKSSlZCYtiNNFbfUcFbA-deaI1adU",
		
	},


	["LiderPawnshop"] = {
		"https://discord.com/api/webhooks/1362538207991955529/UCKDjPnhz47Cqtf0iLrvIMa2DV0oVMa0elXmoahuijjX4i3iFXYkxiLaIHP9LycdyiHa",
		
	},
	["Pawnshop"] = {
		"https://discord.com/api/webhooks/1362538304339447891/Aq3DWT_CVqrpnDbOArVwNYgCyFTQAUFpdhAwNU62ddytMYF_Q8RytVu3Uj5QVh2Ownt1",
		
	},


	["LiderDesmanche"] = {
		"https://discord.com/api/webhooks/1362538585848545553/1OLHxCofl_fYsJQpmkA_1PekGEx4RRMkNzhBNr7AajozE925GsLSDKqVydaGaQVIKInX",
		
	},
	["Desmanche"] = {
		"https://discord.com/api/webhooks/1362538652554756246/Knb645atAFl5dttwmTYik2Kpk_Y83peavVEnmnKf42127CX8tGq5WOQdnw9MZw4KSyuh",
		
	},


	["LiderArmas1"] = {
		"https://discord.com/api/webhooks/1362538963838963844/oL67rxNhZXFzaN492hfdmmPqcediMTYIp9nFiSYx0BFFMaDPsca0RFJRismsJzFYrVTZ",
		
	},
	["Armas1"] = {
		"https://discord.com/api/webhooks/1362538969153142794/mjiQEcHazneQJH7MiYfINLpCHfs3_QsGxSgC1P4sSu-4hh8xADa10NZqLk1ronNtRS0I",
		
	},


	["LiderArmas2"] = {
		"https://discord.com/api/webhooks/1362539162493915406/UB8YR8fjG-06eG6lKqN33Z53xRgq68GZk9QXqKlPQ2Xw5oCLacFNYvOvv4qTX1OhGodD",
		
	},
	["Armas2"] = {
		"https://discord.com/api/webhooks/1362539283109380317/59wW4uutL4hGQkgnKop-OdILJPDGWHgov5g36nZP0t9mc8sykldTc4-q8Rq_7g964Z1Q",
		
	},


	["LiderMunicao1"] = {
		"https://discord.com/api/webhooks/1362539648798298317/Noy45R5YOYDRdIgM-uzj5lMAXGXMNtiYn3z3ZPGwGbFQnXRMf93g_hrnwo447n21erk8",
		
	},
	["Municao1"] = {
		"https://discord.com/api/webhooks/1362539715018096641/OrXKDIjIr4iU_znFRxgthNnOsGgVk35YWf28je_eYU1uCrujlCSxyS8jSolEM5tDSTsw",
		
	},


	["LiderMunicao2"] = {
		"https://discord.com/api/webhooks/1362539818839703713/BwbUy4F5G_eMMpUYsPvLt-1s726NjYobHX_JSug1rlIacBXrO1Cxw0drS95zaulhLVam",
		
	},
	["Municao2"] = {
		"https://discord.com/api/webhooks/1362538652554756246/Knb645atAFl5dttwmTYik2Kpk_Y83peavVEnmnKf42127CX8tGq5WOQdnw9MZw4KSyuh",
		
	},
	

}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Permissions(Name,Mode,weight)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not exports["hud"]:Wanted(Passport) then
		if Mode == "Personal" then
			Open[Passport] = { ["Name"] = "Personal:"..Passport, ["Weight"] = 50, ["Logs"] = false, ["Save"] = true }
			return true
		elseif Mode == "Evidences" and vRP.HasService(Passport,"PCivil") then
			local Keyboard = vKEYBOARD.Primary(source,"Passaporte:")
			if Keyboard then
				Open[Passport] = { ["Name"] = "Evidences:"..Keyboard[1], ["Weight"] = 50, ["Logs"] = false, ["Save"] = true }
				return true
			end
		elseif Mode == "Custom" then
			Open[Passport] = { ["Name"] = Name, ["Weight"] = 50, ["Logs"] = true, ["Save"] = false }
			return true
		elseif Mode == "SNT" then
			Open[Passport] = { ["Name"] = Name, ["Weight"] = weight, ["Save"] = true }
			return true
		else
			if Name == "trayPwnshp"  or Name == "trayUwuCoff"  or Name == "trayPrls1"  or Name == "trayPrls2" or Name == "trayTql1" or Name == "trayTql2" or Name == "trayShot" or Name == "trayDigital" or Name == "trayPawn" or Name == "trayBlaze" or Name == "trayDigital" then
				Open[Passport] = { ["Name"] = Name, ["Weight"] = 200, ["Logs"] = false, ["Save"] = true }
				return true
			end

			local Consult = vRP.Query("chests/GetChests",{ name = Name })
			if Consult[1] and vRP.HasService(Passport,Consult[1]["perm"]) then
				Open[Passport] = { ["Name"] = Name, ["Weight"] = Consult[1]["weight"], ["Logs"] = Consult[1]["logs"], ["Save"] = true }
				return true
			end
		end
	end

	return false
end

-- DEBUG PERMISSIONS
RegisterCommand("testpermprf", function(source, args)
    local Passport = vRP.Passport(source)
    if Passport then
        print("=== DEBUG PERMISSÕES PRF ===")
        print("Passport: " .. Passport)
        
        -- Verificar se tem o grupo PRF
        local hasGroup = vRP.HasGroup(Passport, "PRF")
        print("Tem grupo PRF: " .. tostring(hasGroup))
        
        -- Verificar se está em serviço
        local hasService = vRP.HasService(Passport, "PRF")
        print("Está em serviço PRF: " .. tostring(hasService))
        
        -- Verificar no banco de dados
        local Consult = vRP.Query("chests/GetChests", { name = "PRF" })
        if Consult[1] then
            print("✅ Baú PRF encontrado no banco")
            print("Permissão necessária: " .. Consult[1]["perm"])
            print("Peso: " .. Consult[1]["weight"])
            print("Logs: " .. Consult[1]["logs"])
        else
            print("❌ Baú PRF NÃO encontrado no banco")
        end
        
        -- Testar permissão
        local hasPermission = Creative.Permissions("PRF", "1", 50000)
        print("Permissão concedida: " .. tostring(hasPermission))
        
        TriggerClientEvent("Notify", source, "azul", "Verifique o console do servidor", false, 5000)
    end
end, true)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Chest()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Open[Passport] then
		local Inventory = {}
		local Inv = vRP.Inventory(Passport)
		for Index,v in pairs(Inv) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["max"] = itemMaxAmount(v["item"])
			v["desc"] = itemDescription(v["item"])
			v["economy"] = parseFormat(itemEconomy(v["item"]))
			v["key"] = v["item"]
			v["slot"] = Index

			local Split = splitString(v["item"],"-")
			if Split[2] ~= nil then
				if itemDurability(v["item"]) then
					v["durability"] = parseInt(os.time() - Split[2])
					v["days"] = itemDurability(v["item"])
				else
					v["durability"] = 0
					v["days"] = 1
				end
			else
				v["durability"] = 0
				v["days"] = 1
			end

			Inventory[Index] = v
		end

		local Chest = {}
		local Result = vRP.GetSrvData("Chest:"..Open[Passport]["Name"],Open[Passport]["Save"])
		for Index,v in pairs(Result) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["max"] = itemMaxAmount(v["item"])
			v["economy"] = parseFormat(itemEconomy(v["item"]))
			v["desc"] = itemDescription(v["item"])
			v["key"] = v["item"]
			v["slot"] = Index

			local Split = splitString(v["item"],"-")
			if Split[2] ~= nil then
				if itemDurability(v["item"]) then
					v["durability"] = parseInt(os.time() - Split[2])
					v["days"] = itemDurability(v["item"])
				else
					v["durability"] = 0
					v["days"] = 1
				end
			else
				v["durability"] = 0
				v["days"] = 1
			end

			Chest[Index] = v
		end

		return Inventory,Chest,vRP.InventoryWeight(Passport),vRP.GetWeight(Passport),vRP.ChestWeight(Result),Open[Passport]["Weight"]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENITENS
-----------------------------------------------------------------------------------------------------------------------------------------
local OpenItens = {
	["mechanicpass"] = {
		["Open"] = "Mechanic",
		["Table"] = {
			{ ["Item"] = "advtoolbox", ["Amount"] = 1 },
			{ ["Item"] = "toolbox", ["Amount"] = 2 },
			{ ["Item"] = "tyres", ["Amount"] = 4 },
			{ ["Item"] = "dollars", ["Amount"] = 200 }
		}
	},
	["uwucoffeepass"] = {
		["Open"] = "Uwucoffee",
		["Table"] = {
			{ ["Item"] = "nigirizushi", ["Amount"] = 3 },
			{ ["Item"] = "sushi", ["Amount"] = 3 },
			{ ["Item"] = "dollars", ["Amount"] = 200 }
		}
	},
	["pizzathispass"] = {
		["Open"] = "PizzaThis",
		["Table"] = {
			{ ["Item"] = "nigirizushi", ["Amount"] = 3 },
			{ ["Item"] = "sushi", ["Amount"] = 3 },
			{ ["Item"] = "dollars", ["Amount"] = 200 }
		}
	},
	["Mcdonaldspass"] = {
		["Open"] = "Mcdonalds",
		["Table"] = {
			{ ["Item"] = "hamburger2", ["Amount"] = 1 },
			{ ["Item"] = "cookedmeat", ["Amount"] = 2 },
			{ ["Item"] = "cookedfishfillet", ["Amount"] = 1 },
			{ ["Item"] = "dollars", ["Amount"] = 200 }
		}
	},
	["paramedicpass"] = {
		["Open"] = "Paramedic",
		["Table"] = {
			{ ["Item"] = "gauze", ["Amount"] = 3 },
			{ ["Item"] = "medkit", ["Amount"] = 1 },
			{ ["Item"] = "analgesic", ["Amount"] = 4 },
			{ ["Item"] = "dollars", ["Amount"] = 200 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Store(Item,Slot,Amount,Target)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport and Open[Passport] then
		if Amount <= 0 then Amount = 1 end

		if itemBlock(Item) then
			TriggerClientEvent("chest:Update",source,"Refresh")

			return true
		end

		if OpenItens[Item] and OpenItens[Item]["Open"] == Open[Passport]["Name"] then
			if vRP.TakeItem(Passport,Item,1) then
				for _,v in pairs(OpenItens[Item]["Table"]) do
					vRP.GenerateItem(Passport,v["Item"],v["Amount"])
				end
			end

			TriggerClientEvent("chest:Update",source,"Refresh")

			return true
		end

		if vRP.StoreChest(Passport,"Chest:"..Open[Passport]["Name"],Amount,Open[Passport]["Weight"],Slot,Target,true) then
			TriggerClientEvent("chest:Update",source,"Refresh")
		else
			local Result = vRP.GetSrvData("Chest:"..Open[Passport]["Name"],Open[Passport]["Save"])
			TriggerClientEvent("chest:Update",source,"Update",vRP.InventoryWeight(Passport),vRP.GetWeight(Passport),vRP.ChestWeight(Result),Open[Passport]["Weight"])

			for k,v in pairs(Webhooks) do
				if string.find(Open[Passport]["Name"], k) then
					for _,webhook in pairs(v) do
						vRP.SendWebhook(webhook, "LOGs BAÚ GUARDOU", "**Passaporte: **"..Passport.."\n**Guardou: **x"..Amount.." "..Item.."\n**Baú: **"..Open[Passport]["Name"], 7065707)
					end
				end
			end

			if Open[Passport]["Logs"] then
				TriggerEvent("Discord",Open[Passport]["Name"],"**Passaporte:** "..Passport.."\n**Guardou:** "..Amount.."x "..itemName(Item),3042892)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Take(Item,Slot,Amount,Target)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport and Open[Passport] then
		if Amount <= 0 then Amount = 1 end

		if vRP.TakeChest(Passport,"Chest:"..Open[Passport]["Name"],Amount,Slot,Target,true) then
			TriggerClientEvent("chest:Update",source,"Refresh")
		else
			local Result = vRP.GetSrvData("Chest:"..Open[Passport]["Name"],Open[Passport]["Save"])
			TriggerClientEvent("chest:Update",source,"Update",vRP.InventoryWeight(Passport),vRP.GetWeight(Passport),vRP.ChestWeight(Result),Open[Passport]["Weight"])

			if string.sub(Open[Passport]["Name"],1,9) == "Helicrash" and vRP.ChestWeight(Result) <= 0 then
				TriggerClientEvent("chest:Close",source)
				exports["helicrash"]:Box()
			end
			
			for k,v in pairs(Webhooks) do
				if string.find(Open[Passport]["Name"], k) then
					for _,webhook in pairs(v) do
						vRP.SendWebhook(webhook, "LOGs BAÚ RETIROU", "**Passaporte: **"..Passport.."\n**Retirou: **x"..Amount.." "..Item.."\n**Baú: **"..Open[Passport]["Name"], 16726610)
					end
				end
			end

			if Open[Passport]["Logs"] then
				TriggerEvent("Discord",Open[Passport]["Name"],"**Passaporte:** "..Passport.."\n**Retirou:** "..Amount.."x "..itemName(Item),9317187)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Update(Slot,Target,Amount)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport and Open[Passport] then
		if Amount <= 0 then Amount = 1 end

		if vRP.Update(Passport,"Chest:"..Open[Passport]["Name"],Slot,Target,Amount) then
			TriggerClientEvent("chest:Update",source,"Refresh")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:UPGRADE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("chest:Upgrade")
AddEventHandler("chest:Upgrade",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasService(Passport,Name) then
			if vRP.Request(source,"Aumentar <b>50Kg</b> por <b>$10.000</b> dólares?","Sim, efetuar pagamento","Não, decido depois") then
				if vRP.PaymentFull(Passport,10000) then
					vRP.Query("chests/UpdateChests",{ name = Name })
					TriggerClientEvent("Notify",source,"verde","Compra concluída.",3000)
				else
					TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Open[Passport] then
		Open[Passport] = nil
	end
end)