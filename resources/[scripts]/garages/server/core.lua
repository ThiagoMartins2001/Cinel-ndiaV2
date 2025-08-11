-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("garages", Creative)
vCLIENT = Tunnel.getInterface("garages")
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local Spawn = {}
local Signal = {}
local Searched = {}
local Propertys = {}
local SpawnVehicle = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Plates"] = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVERVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ServerVehicle(Model, x, y, z, Heading, Plate, Nitrox, Doors, Body, Fuel)
	local Vehicle = CreateVehicle(Model, x, y, z, Heading, true, true)

	while not DoesEntityExist(Vehicle) do
		Wait(100)
	end

	if DoesEntityExist(Vehicle) then
		if Plate ~= nil then
			SetVehicleNumberPlateText(Vehicle, Plate)
		else
			Plate = vRP.GeneratePlate()
			SetVehicleNumberPlateText(Vehicle, Plate)
		end

		SetVehicleBodyHealth(Vehicle, Body + 0.0)

		if Doors then
			local Doors = json.decode(Doors)
			if Doors ~= nil then
				for Number, Status in pairs(Doors) do
					if Status then
						SetVehicleDoorBroken(Vehicle, parseInt(Number), true)
					end
				end
			end
		end

		Entity(Vehicle)["state"]:set("Fuel", Fuel or 100, true)
		Entity(Vehicle)["state"]:set("Nitro",Nitrox or 0,true)

		return true,NetworkGetNetworkIdFromEntity(Vehicle),Vehicle
	end

	return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SIGNALREMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("signalRemove", function(Plate)
	if not Signal[Plate] then
		Signal[Plate] = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEREVERYONE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("plateReveryone", function(Plate)
	if GlobalState["Plates"][Plate] then
		local Plates = GlobalState["Plates"]
		Plates[Plate] = nil
		GlobalState:set("Plates", Plates, true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEEVERYONE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("plateEveryone", function(Plate)
	local Plates = GlobalState["Plates"]
	Plates[Plate] = true
	GlobalState:set("Plates", Plates, true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("platePlayers", function(Plate, Passport)
	if not vRP.PassportPlate(Plate) then
		local Plates = GlobalState["Plates"]
		Plates[Plate] = Passport
		GlobalState:set("Plates", Plates, true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Vehicles(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Garages[Number]["perm"] then
			if not vRP.HasGroup(Passport, Garages[Number]["perm"]) then
				return false
			end
		end

		if string.sub(Number, 1, 9) == "Propertys" then
			local Consult = vRP.Query("propertys/Exist", { name = Number })
			if Consult[1] then
				if parseInt(Consult[1]["Passport"]) == Passport or vRP.InventoryFull(Passport, "propertys-" .. Consult[1]["Serial"]) then
					if os.time() > Consult[1]["Tax"] then
						TriggerClientEvent("Notify", source, "amarelo", "Aluguel atrasado, procure um <b>Corretor de Imóveis</b>.", "Atenção", 5000)
						return false
					end
				else
					return false
				end
			end
		end

		local Vehicle = {}
		local Garage = Garages[Number]["name"]
		if Works[Garage] then
			for _, v in pairs(Works[Garage]) do
				local VehicleResult = vRP.Query("vehicles/selectVehicles", { Passport = Passport, vehicle = v })

				if VehicleExist(v) then
					if VehicleResult[1] then
						local TaxTime = false
						if VehicleResult[1]["tax"] >= os.time() then
							TaxTime = MinimalTimers(VehicleResult[1]["tax"] - os.time())
						end

						local RentalTime = false
						if VehicleResult[1]["rental"] ~= 0 then
							RentalTime = MinimalTimers(VehicleResult[1]["rental"] - os.time())
						end

						Vehicle[#Vehicle + 1] = {
							["Model"] = v,
							["Name"] = VehicleName(v),
							["Mode"] = VehicleMode(v),
							["Weight"] = VehicleChest(v),
							["Tax"] = VehiclePrice(v) * 0.10,
							["TaxTime"] = TaxTime,
							["RentalTime"] = RentalTime,
							["Engine"] = VehicleResult[1]["engine"] / 10,
							["Body"] = VehicleResult[1]["body"] / 10,
							["Fuel"] = VehicleResult[1]["fuel"],
						}
					else
						Vehicle[#Vehicle + 1] = {
							["Model"] = v,
							["Name"] = VehicleName(v),
							["Mode"] = VehicleMode(v),
							["Weight"] = VehicleChest(v),
							["Tax"] = VehiclePrice(v) * 0.10,
							["TaxTime"] = false,
							["RentalTime"] = false,
							["Engine"] = 100,
							["Body"] = 100,
							["Fuel"] = 100
						}
					end
				end
			end
		else
			local Consult = vRP.Query("vehicles/UserVehicles", { Passport = Passport })
			for _, v in pairs(Consult) do
				if VehicleExist(v["vehicle"]) then
					if v["work"] == "false" then
						local TaxTime = false

						if v["tax"] >= os.time() then
							TaxTime = MinimalTimers(v["tax"] - os.time())
						end

						if v["dismantle"] ~= 0 then
							TaxTime = false
						end

						local RentalTime = false
						if v["rental"] ~= 0 then
							RentalTime = MinimalTimers(v["rental"] - os.time())
						end

						Vehicle[#Vehicle + 1] = {
							["Model"] = v["vehicle"],
							["Name"] = VehicleName(v["vehicle"]),
							["Mode"] = VehicleMode(v["vehicle"]),
							["Weight"] = VehicleChest(v["vehicle"]),
							["Tax"] = VehiclePrice(v["vehicle"]) * 0.10,
							["TaxTime"] = TaxTime,
							["RentalTime"] = RentalTime,
							["Engine"] = v["engine"] / 10,
							["Body"] = v["body"] / 10,
							["Fuel"] = v["fuel"],
						}
					end
				end
			end
		end

		return Vehicle
	end

	return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- IMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Impound()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Vehicles = {}
		local Vehicle = vRP.Query("vehicles/UserVehicles", { Passport = Passport })

		for Number, v in ipairs(Vehicle) do
			if v["arrest"] >= os.time() then
				Vehicles[#Vehicles + 1] = {
					["Model"] = Vehicle[Number]["vehicle"],
					["name"] = VehicleName(Vehicle[Number]["vehicle"])
				}
			end
		end

		return Vehicles
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:IMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Impound")
AddEventHandler("garages:Impound", function(vehName)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local VehiclePrice = VehiclePrice(vehName)
		TriggerClientEvent("garages:Close", source)

		if vRP.Request(source, "Garagem", "A liberação do veículo tem o custo de <b>$" .. parseFormat(VehiclePrice * 0.25) .. "</b> dólares, deseja prosseguir com a liberação do mesmo?") then
			if vRP.PaymentFull(Passport, VehiclePrice * 0.25) then
				vRP.Query("vehicles/paymentArrest", { Passport = Passport, vehicle = vehName })
				TriggerClientEvent("Notify",source,"Sucesso","Veículo liberado.","verde",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Tax")
AddEventHandler("garages:Tax",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Consult = vRP.Query("vehicles/selectVehicles", { Passport = Passport, vehicle = Name })

		if Consult[1] and Consult[1]["dismantle"] == 1 then
			local Price = VehiclePrice(Name) * 0.07

			if vRP.PaymentFull(Passport, Price) then
				vRP.Query("desmanche/set", { Passport = Passport, vehicle = Name, dismantle = 0 })
				TriggerClientEvent("Notify",source,"Sucesso","Pagamento do desmanche concluído.","verde",5000)
				return
			end
		end

		if Consult[1] and Consult[1]["tax"] <= os.time() then
			local Price = VehiclePrice(Name) * 0.05

			if vRP.PaymentFull(Passport, Price) then
				vRP.Query("vehicles/updateVehiclesTax", { Passport = Passport, vehicle = Name })
				TriggerClientEvent("Notify",source,"Sucesso","Pagamento concluído.","verde",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SELL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Sell")
AddEventHandler("garages:Sell",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Mode = VehicleMode(Name)
		if Mode == "rental" or Mode == "work" then
			return
		end

		local Consult = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
		if Consult[1] then
			local Price = VehiclePrice(Name) * 0.5
			if vRP.Request(source,"Vender o veículo "..VehicleName(Name).." por $"..parseFormat(Price).."?","Sim, concluír venda","Não, mudei de ideia") then
				local Consult = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
				if Consult[1] then
					vRP.GiveBank(Passport,Price)
					vRP.Query("vehicles/removeVehicles",{ Passport = Passport, vehicle = Name })
					vRP.Query("entitydata/RemoveData",{ dkey = "Mods:"..Passport..":"..Name })
					vRP.Query("entitydata/RemoveData",{ dkey = "Chest:"..Passport..":"..Name })
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Transfer")
AddEventHandler("garages:Transfer",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local myVehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
		if myVehicle[1] then
			TriggerClientEvent("garages:Close",source)

			local Keyboard = vKEYBOARD.Primary(source,"Passaporte:")
			if Keyboard then
				local OtherPassport = parseInt(Keyboard[1])
				local Identity = vRP.Identity(OtherPassport)
				if Identity then
					if vRP.Request(source,"Transferir o veículo "..VehicleName(Name).." para "..Identity["name"].." "..Identity["name2"].."?","Sim, transferir","Não, mudei de ideia") then
						local Vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = parseInt(OtherPassport), vehicle = Name })
						if Vehicle[1] then
							TriggerClientEvent("Notify",source,"Atenção","<b>"..vRP.FullName(OtherPassport).."</b> já possui este modelo de veículo.","amarelo",5000)
						else
							vRP.Query("vehicles/moveVehicles",{ Passport = Passport, OtherPassport = parseInt(OtherPassport), vehicle = Name })

							local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..Passport..":"..Name })
							if parseInt(#Datatable) > 0 then
								vRP.Query("entitydata/SetData",{ dkey = "Mods:"..OtherPassport..":"..Name, dvalue = Datatable[1]["dvalue"] })
								vRP.Query("entitydata/RemoveData",{ dkey = "Mods:"..Passport..":"..Name })
							end

							local Datatable = vRP.GetSrvData("Chest:"..Passport..":"..Name,true)
							vRP.SetSrvData("Chest:"..OtherPassport..":"..Name,Datatable,true)
							vRP.RemSrvData("Chest:"..Passport..":"..Name,true)

							TriggerClientEvent("Notify",source,"Sucesso","Transferência concluída.","verde",5000)
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Spawn")
AddEventHandler("garages:Spawn",function(Name,Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if SpawnVehicle[Number] then
			if os.time() >= SpawnVehicle[Number] then
				SpawnVehicle[Number] = os.time() + 5
			else
				TriggerClientEvent("garages:Close", source)

				local Cooldown = MinimalTimers(SpawnVehicle[Number] - os.time())
				TriggerClientEvent("Notify", source, "azul", "Aguarde <b>" .. Cooldown .. "</b>.", false, 5000)
				return
			end
		else
			SpawnVehicle[Number] = os.time() + 5
		end

		local Coin = "Diamantes"
		local Gemstone = VehicleGems(Name)
		local vehicle = vRP.Query("vehicles/selectVehicles", { Passport = Passport, vehicle = Name })

		if not vehicle[1] then
			if parseInt(Gemstone) > 0 then
				TriggerClientEvent("garages:Close", source)

				if vRP.Request(source, "Garagem", "Alugar o veículo <b>" .. VehicleName(Name) .. "</b> por <b>" .. Gemstone .. "</b> gemas?") then
					if vRP.PaymentGemstone(Passport, Gemstone) then
						vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = Name, plate = vRP.GeneratePlate(), work = "true" })
						TriggerClientEvent("Notify",source,"Sucesso","Aluguel do veículo <b>"..VehicleName(Name).."</b> concluído.","verde",5000)
						vehicle = vRP.Query("vehicles/selectVehicles", { Passport = Passport, vehicle = Name })
					else
						TriggerClientEvent("Notify",source,"Aviso",Coin.." insuficiente.","amarelo",5000)
						return
					end
				else
					return
				end
			else
				TriggerClientEvent("garages:Close", source)

				local VehiclePrice = VehiclePrice(Name)
				if parseInt(VehiclePrice) > 0 then
					if vRP.Request(source, "Garagem", "Comprar <b>" .. VehicleName(Name) .. "</b> por <b>$" .. parseFormat(VehiclePrice) .. "</b> dólares?") then
						if vRP.PaymentFull(Passport, VehiclePrice) then
							vRP.Query("vehicles/addVehicles",
								{ Passport = Passport, vehicle = Name, plate = vRP.GeneratePlate(), work = "true" })
							vehicle = vRP.Query("vehicles/selectVehicles", { Passport = Passport, vehicle = Name })
						end
					else
						return
					end
				else
					vRP.Query("vehicles/addVehicles",
						{ Passport = Passport, vehicle = Name, plate = vRP.GeneratePlate(), work = "true" })
					vehicle = vRP.Query("vehicles/selectVehicles", { Passport = Passport, vehicle = Name })
				end
			end
		end

		if vehicle[1] then
			local Plates = GlobalState["Plates"]
			local Plate = vehicle[1]["plate"]

			if Spawn[Plate] then
				if not Signal[Plate] then
					if not Searched[Passport] then
						Searched[Passport] = os.time()
					end

					if os.time() >= parseInt(Searched[Passport]) then
						Searched[Passport] = os.time() + 60

						local Network = Spawn[Plate][3]
						local Network = NetworkGetEntityFromNetworkId(Network)
						if DoesEntityExist(Network) and not IsPedAPlayer(Network) and GetEntityType(Network) == 2 then
							vCLIENT.SearchBlip(source, GetEntityCoords(Network))
							TriggerClientEvent("Notify",source,"Atenção","Rastreador do veículo foi ativado por <b>30</b> segundos, lembrando que se o mesmo estiver em movimento a localização pode ser imprecisa.","policia",10000)
						else
							if Spawn[Plate] then
								Spawn[Plate] = nil
							end

							if Plates[Plate] then
								Plates[Plate] = nil
								GlobalState:set("Plates", Plates, true)
							end

							TriggerClientEvent("Notify",source,"Sucesso","A seguradora efetuou o resgate do seu veículo e o mesmo já se encontra disponível para retirada.","policia",5000)
						end
					else
						TriggerClientEvent("Notify",source,"Aviso","Rastreador só pode ser ativado a cada <b>60</b> segundos.","policia",5000)
					end
				else
					TriggerClientEvent("Notify",source,"Aviso","Rastreador está desativado.","policia",5000)
				end
			else
				if vehicle[1]["tax"] <= os.time() then
					TriggerClientEvent("Notify", source, "amarelo", "Taxa do veículo atrasada.", "Atenção", 5000)
				elseif vehicle[1]["arrest"] >= os.time() then
					TriggerClientEvent("Notify", source, "amarelo","Veículo apreendido, dirija-se até o <b>Impound</b> e efetue o pagamento da liberação do mesmo.","Atenção", 10000)
				elseif vehicle[1]["dismantle"] == 1 then
					TriggerClientEvent("Notify", source, "amarelo", "O seu veículo foi desmanchado, efetue o pagamento para a seguradora.", "Atenção", 5000)
				else
					-- if vehicle[1]["rental"] ~= 0 then
					-- 	if vehicle[1]["rental"] <= os.time() then
					-- 		if vRP.Request(source,"Atualizar o aluguel do veículo <b>"..VehicleName(Name).."</b> por <b>"..Gemstone.." gemas</b>?","Sim, concluír pagamento","Não, mudei de ideia") then
					-- 			if vRP.PaymentGems(Passport,Gemstone) then
					-- 				vRP.Query("vehicles/rentalVehiclesUpdate",{ Passport = Passport, vehicle = Name })
					-- 				TriggerClientEvent("Notify",source,"verde","Aluguel do veículo <b>"..VehicleName(Name).."</b> atualizado.",5000)
					-- 			else
					-- 				TriggerClientEvent("Notify",source,"vermelho","<b>Gemas</b> insuficientes.",5000)
					-- 				return
					-- 			end
					-- 		else
					-- 			return
					-- 		end
					-- 	end
					-- end

					if Gemstone > 0 and vehicle[1]["rental"] ~= 0 and vehicle[1]["rental"] <= os.time() then
						TriggerClientEvent("garages:Close",source)
	
						if VehicleClass(Name) == "Exclusivos" then
							Coin = "Platina"
						end
	
						if vRP.Request(source,"Garagem","Pagar o aluguel do veículo <b>"..VehicleName(Name).."</b> por <b>"..Dotted(Gemstone).." "..Coin.."</b>?") then
							if (Coin == "Diamantes" and vRP.PaymentGems(Passport,Gemstone)) or (Coin == "Platina" and vRP.TakeItem(Passport,"platinum",Gemstone)) then
								vRP.Query("vehicles/rentalVehiclesUpdate",{ Passport = Passport, vehicle = Name })
								TriggerClientEvent("Notify",source,"Sucesso","Aluguel do veículo <b>"..VehicleName(Name).."</b> atualizado.","verde",5000)
							else
								TriggerClientEvent("Notify",source,"Aviso",Coin.." insuficiente.","amarelo",5000)
	
								return false
							end
						else
	
							return false
						end
					end

					local Coords = vCLIENT.SpawnPosition(source, Number)
					if Coords then
						local Mods = nil
						local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..Passport..":"..Name })
						if parseInt(#Datatable) > 0 then
							Mods = Datatable[1]["dvalue"]
						end

						if Garages[Number]["payment"] then
							if vRP.UserPremium(Passport) then
								TriggerClientEvent("garages:Close", source)

								local Exist, Network = Creative.ServerVehicle(Name, Coords[1], Coords[2], Coords[3],
									Coords[4], Plate, vehicle[1]["nitro"], vehicle[1]["doors"], vehicle[1]["body"])

								if Exist then
									local Networked = NetworkGetEntityFromNetworkId(Network)

									vCLIENT.CreateVehicle(-1, Name, Network, vehicle[1]["engine"], vehicle[1]["health"],
										Mods, vehicle[1]["windows"], vehicle[1]["tyres"], vehicle[1]["brakes"])
									Entity(Networked)["state"]:set("Fuel", vehicle[1]["fuel"], true)
									TriggerEvent("engine:InsertBrakes", Network, vehicle[1]["brakes"])
									Spawn[Plate] = { Passport, Name, Network }

									Plates[Plate] = Passport
									GlobalState:set("Plates", Plates, true)

									if vehicle[1]["drift"] then
										Entity(Networked)["state"]:set("Drift", true, true)
									end
								end

								-- if vehicle[1]["mode"] == "normal" then
								-- 	local VehiclePrice = VehiclePrice(Name)
								-- 	if vRP.HasGroup(Passport, "Premium") then
								-- 		local Exist, Network = Creative.ServerVehicle(Name, Coords[1], Coords[2], Coords
								-- 			[3], Coords[4], Plate, vehicle[1]["nitro"], vehicle[1]["doors"],
								-- 			vehicle[1]["body"])

								-- 		if Exist then
								-- 			local Networked = NetworkGetEntityFromNetworkId(Network)

								-- 			vCLIENT.CreateVehicle(-1, Name, Network, vehicle[1]["engine"],
								-- 				vehicle[1]["health"], Mods, vehicle[1]["windows"], vehicle[1]["tyres"],
								-- 				vehicle[1]["brakes"])
								-- 			Entity(Networked)["state"]:set("Fuel", vehicle[1]["fuel"], true)
								-- 			TriggerEvent("engine:InsertBrakes", Network, vehicle[1]["brakes"])
								-- 			Spawn[Plate] = { Passport, Name, Network }

								-- 			Plates[Plate] = Passport
								-- 			GlobalState:set("Plates", Plates, true)

								-- 			if vehicle[1]["drift"] then
								-- 				Entity(Networked)["state"]:set("Drift", true, true)
								-- 			end
								-- 		end
								-- 	else
								-- 		if vRP.Request(source, "Garagem", "Retirar o veículo por <b>$" .. parseFormat(VehiclePrice * 0.05) .. "</b> dólares?") then
								-- 			if vRP.PaymentFull(Passport, parseInt(VehiclePrice * 0.05)) then
								-- 				local Exist, Network = Creative.ServerVehicle(Name, Coords[1], Coords[2],
								-- 					Coords[3], Coords[4], Plate, vehicle[1]["nitro"],
								-- 					vehicle[1]["doors"], vehicle[1]["body"])

								-- 				if Exist then
								-- 					local Networked = NetworkGetEntityFromNetworkId(Network)

								-- 					vCLIENT.CreateVehicle(-1, Name, Network, vehicle[1]["engine"],
								-- 						vehicle[1]["health"], Mods, vehicle[1]["windows"],
								-- 						vehicle[1]["tyres"], vehicle[1]["brakes"])
								-- 					Entity(Networked)["state"]:set("Fuel", vehicle[1]["fuel"], true)
								-- 					TriggerEvent("engine:InsertBrakes", Network, vehicle[1]["brakes"])
								-- 					Spawn[Plate] = { Passport, Name, Network }

								-- 					Plates[Plate] = Passport
								-- 					GlobalState:set("Plates", Plates, true)

								-- 					if vehicle[1]["drift"] then
								-- 						Entity(Networked)["state"]:set("Drift", true, true)
								-- 					end
								-- 				end
								-- 			else
								-- 				TriggerClientEvent("Notify",source,"Error","Dinheiro insuficiente.","vermelho",5000)
								-- 				return
								-- 			end
								-- 		else

								-- 		end
								-- 	end
								-- end
							end
						else
							TriggerClientEvent("garages:Close", source)
							local Exist, Network = Creative.ServerVehicle(Name, Coords[1], Coords[2], Coords[3], Coords[4],
								Plate, vehicle[1]["nitro"], vehicle[1]["doors"], vehicle[1]["body"])

							if Exist then
								local Networked = NetworkGetEntityFromNetworkId(Network)

								vCLIENT.CreateVehicle(-1, Name, Network, vehicle[1]["engine"], vehicle[1]["health"], Mods,vehicle[1]["windows"], vehicle[1]["tyres"], vehicle[1]["brakes"])
								Entity(Networked)["state"]:set("Fuel", vehicle[1]["fuel"], true)
								TriggerEvent("engine:InsertBrakes", Network, vehicle[1]["brakes"])
								Spawn[Plate] = { Passport, Name, Network }

								Plates[Plate] = Passport
								GlobalState:set("Plates", Plates, true)

								if vehicle[1]["drift"] then
									Entity(Networked)["state"]:set("Drift", true, true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("car", function(source, Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport, "Admin") and Message[1] then
			local VehicleName = Message[1]
			local Ped = GetPlayerPed(source)
			local Coords = GetEntityCoords(Ped)
			local Heading = GetEntityHeading(Ped)
			local Plate = "VEH" .. (math.random(10000, 90000) + Passport)

			local Exist, Network, Vehicle = Creative.ServerVehicle(VehicleName, Coords["x"], Coords["y"], Coords["z"],
				Heading, Plate, 2000, nil, 1000)
			if not Exist then
				return
			end

			local Networked = NetworkGetEntityFromNetworkId(Network)

			vCLIENT.CreateVehicle(-1, VehicleName, Network, 1000, 1000, nil, false, false, { 1.25, 0.75, 0.95 })
			Spawn[Plate] = { Passport, VehicleName, Network }
			TriggerEvent("engine:InsertBrakes", Network, "")
			Entity(Networked)["state"]:set("Fuel", 100, true)
			SetPedIntoVehicle(Ped, Vehicle, -1)

			local Plates = GlobalState["Plates"]
			Plates[Plate] = Passport
			GlobalState:set("Plates", Plates, true)

			Entity(Networked)["state"]:set("Drift", true, true)

			if Logs then
				exports["vrp"]:Embed("Garages",
					"**Passaporte:** " .. Passport .. "\n**Spawnou:** " .. VehicleName .. "\n**Coords:** " .. Coords,
					3042892)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("dv", function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport, "Admin", 2) then
		TriggerClientEvent("garages:Delete", source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:KEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Key")
AddEventHandler("garages:Key", function(entity)
	local source = source
	local Plate = entity[1]
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Plates"][Plate] == Passport then
		vRP.GenerateItem(Passport, "vehkey-" .. Plate, 1, true, false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:LOCK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Lock")
AddEventHandler("garages:Lock", function(Network, Plate)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Plates"][Plate] == Passport then
		TriggerEvent("garages:LockVehicle", source, Network)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:LOCKVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("garages:LockVehicle", function(source, Network)
	local Network = NetworkGetEntityFromNetworkId(Network)
	local Doors = GetVehicleDoorLockStatus(Network)

	if parseInt(Doors) <= 1 then
		TriggerClientEvent("Notify",source,"Aviso","Veículo trancado.","default",5000)
		TriggerClientEvent("sounds:Private", source, "locked", 0.7)
		SetVehicleDoorsLocked(Network, 2)
	else
		TriggerClientEvent("Notify",source,"Aviso","Veículo destrancado.","default",5000)
		TriggerClientEvent("sounds:Private", source, "unlocked", 0.7)
		SetVehicleDoorsLocked(Network, 1)
	end

	if not vRPC.InsideVehicle(source) then
		vRPC.PlayAnim(source, true, { "anim@mp_player_intmenu@key_fob@", "fob_click" }, false)
		Wait(350)
		vRPC.stopAnim(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Delete(Network, Health, Engine, Body, Fuel, Doors, Windows, Tyres, Plate, Brake)
	if Spawn[Plate] then
		local Networked = NetworkGetEntityFromNetworkId(Network)
		local Passport = Spawn[Plate][1]
		local Vehicle = Spawn[Plate][2]

		if parseInt(Engine) <= 100 then
			Engine = 100
		end

		if parseInt(Body) <= 100 then
			Body = 100
		end

		if parseInt(Fuel) >= 100 then
			Fuel = 100
		end

		if parseInt(Fuel) <= 0 then
			Fuel = 0
		end

		local vehicle = vRP.Query("vehicles/selectVehicles", { Passport = Passport, vehicle = Vehicle })
		if vehicle[1] ~= nil then
			vRP.Query("vehicles/updateVehicles",{ Passport = Passport, vehicle = Vehicle, nitro = Entity(Networked)["state"]["Nitro"] or 0,	engine = parseInt(Engine), body = parseInt(Body), health = parseInt(Health), fuel = parseInt(Fuel), doors = json.encode(Doors),	windows = json.encode(Windows),	tyres = json.encode(Tyres),	brakes = json.encode(Brake)	})
		end
	end

	TriggerEvent("garages:DeleteVehicle", Network, Plate)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:DELETEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:DeleteVehicle")
AddEventHandler("garages:DeleteVehicle", function(Network, Plate)
	if Network ~= nil and Plate ~= nil then
		if GlobalState["Plates"][Plate] then
			local Plates = GlobalState["Plates"]
			Plates[Plate] = nil
			GlobalState:set("Plates", Plates, true)
		end

		if Signal[Plate] then
			Signal[Plate] = nil
		end

		if Spawn[Plate] then
			Spawn[Plate] = nil
		end

		local Network = NetworkGetEntityFromNetworkId(Network)
		if DoesEntityExist(Network) and not IsPedAPlayer(Network) and GetEntityType(Network) == 2 and GetVehicleNumberPlateText(Network) == Plate then
			DeleteEntity(Network)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:PROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Propertys")
AddEventHandler("garages:Propertys", function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		TriggerClientEvent("garages:Close", source)
		TriggerClientEvent("Notify",source,"Aviso","Selecione o local da garagem.","amarelo",5000)

		local Hash = "prop_offroad_tyres02"
		local Application, Coords, Heading = vRPC.objectCoords(source, Hash)
		if Application then
			if #(Coords - exports["propertys"]:Coords(Name)) <= 25 then
				TriggerClientEvent("Notify",source,"Aviso","Selecione o local do veículo.","amarelo",5000)

				local Open = Coords
				local Hash = "patriot"
				local Application, Coords, Heading = vRPC.objectCoords(source, Hash)
				if Application then
					if #(Coords - exports["propertys"]:Coords(Name)) <= 25 then
						local New = {
							["1"] = { mathLength(Open["x"]), mathLength(Open["y"]), mathLength(Open["z"] + 1) },
							["2"] = { mathLength(Coords["x"]), mathLength(Coords["y"]), mathLength(Coords["z"] + 1),
								mathLength(Heading) }
						}

						Garages[Name] = { name = "Garage", payment = false, license = false }

						Propertys[Name] = {
							["x"] = New["1"][1],
							["y"] = New["1"][2],
							["z"] = New["1"][3],
							["1"] = New["2"]
						}

						vRP.Query("propertys/Garage",{ name = Name, garage = json.encode(New) })
						TriggerClientEvent("garages:Propertys", -1, Propertys)
					else
						TriggerClientEvent("Notify",source,"Error","A garagem precisa ser próximo da entrada.","vermelho",5000)
					end
				end
			else
				TriggerClientEvent("Notify",source,"Error","A garagem precisa ser próximo da entrada.","vermelho",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local Consult = vRP.Query("propertys/Garages")
	for _, v in pairs(Consult) do
		local Name = v["Name"]
		if not Propertys[Name] and v["Garage"] ~= "{}" then
			local Table = json.decode(v["Garage"])
			Garages[Name] = { name = "Garage", payment = false, license = false }

			Propertys[Name] = {
				["x"] = Table["1"][1],
				["y"] = Table["1"][2],
				["z"] = Table["1"][3],
				["1"] = Table["2"]
			}
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SIGNAL
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Signal", function(Plate)
	return Signal[Plate]
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect", function(Passport, source)
	TriggerClientEvent("garages:Propertys", source, Propertys)
end)