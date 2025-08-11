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
Creative = {}
Tunnel.bindInterface("player",Creative)
vCLIENT = Tunnel.getInterface("player")
vSKINSHOP = Tunnel.getInterface("skinshop")
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
local Debug = {}
RegisterServerEvent("player:Debug")
AddEventHandler("player:Debug",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Debug[Passport] or os.time() > Debug[Passport] then
		TriggerClientEvent("barbershop:Apply",source,vRP.UserData(Passport,"Barbershop"))
		TriggerClientEvent("skinshop:Apply",source,vRP.UserData(Passport,"Clothings"))
		TriggerClientEvent("tattoos:Apply",source,vRP.UserData(Passport,"Tatuagens"))
		TriggerClientEvent("target:Debug",source)
		TriggerEvent("DebugObjects",Passport)

		Debug[Passport] = os.time() + 10
	end
end)

function Creative.BypassInvi()
	local source = source
	--exports["blazeit_props"]:SetTempPermission(source, "Client",  "BypassInvisible", true)
	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Debug[Passport] then
		Debug[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("skin",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and Message[1] and Message[2] then
		if vRP.HasGroup(Passport,"Admin", 2) then
			local ClosestPed = vRP.Source(Message[1])
			if ClosestPed then
				vRPC.Skin(ClosestPed,Message[2])
				vRP.SkinCharacter(parseInt(Message[1]),Message[2])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DUITEXTURES
-----------------------------------------------------------------------------------------------------------------------------------------
local DuiTextures = {
	["MRPD"] = {
		["Distance"] = 1.50,
		["Dimension"] = 1.25,
		["Label"] = "Quadro Branco",
		["Coords"] = vec3(439.47,-985.85,35.99),
		["Link"] = "https://creative-rp.com/Quadro.png",
		["Dict"] = "prop_planning_b1",
		["Texture"] = "prop_base_white_01b",
		["Width"] = 550,
		["Weight"] = 450
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:TEXTURE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Texture")
AddEventHandler("player:Texture",function(Name)
	local source = source
	local Keyboard = vKEYBOARD.Primary(source,"Link:")
	if Keyboard then
		DuiTextures[Name]["Link"] = Keyboard[1]
		TriggerClientEvent("player:DuiUpdate",-1,Name,DuiTextures[Name])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:STRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Stress")
AddEventHandler("player:Stress",function(Number)
	local source = source
	local Number = parseInt(Number)
	local Passport = vRP.Passport(source)
	if Passport then
		vRP.DowngradeStress(Passport,Number)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("me",function(source,Message,History)
	local Passport = vRP.Passport(source)
	if Passport and Message[1] then
		local message = string.sub(History:sub(4),1,100)

		local Players = vRPC.Players(source)
		for _,v in pairs(Players) do
			async(function()
				TriggerClientEvent("showme:pressMe",v,source,message,10)
			end)
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------
-- E
---------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("e",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) > 100 then
		if Message[2] == "friend" then
			local ClosestPed = vRPC.ClosestPed(source,2)
			if ClosestPed then
				if vRP.GetHealth(ClosestPed) > 100 and not Player(ClosestPed)["state"]["Handcuff"] then
					local Identity = vRP.Identity(Passport)
					if vRP.Request(ClosestPed,"Pedido de <b>"..Identity["name"].."</b> da animação <b>"..Message[1].."</b>?","Sim, iniciar animação","Não, sai fora") then
						TriggerClientEvent("emotes",ClosestPed,Message[1])
						TriggerClientEvent("emotes",source,Message[1])
					end
				end
			end
		else
			TriggerClientEvent("emotes",source,Message[1])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- E2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("e2",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) > 100 then
		local ClosestPed = vRPC.ClosestPed(source,2)
		if ClosestPed then
			if vRP.HasService(Passport,"Paramedic") then
				TriggerClientEvent("emotes",ClosestPed,Message[1])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- E3
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("e3",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) > 100 then
		if vRP.HasGroup(Passport,"Admin",2) then
			local Players = vRPC.ClosestPeds(source,50)
			for _,v in pairs(Players) do
				async(function()
					TriggerClientEvent("emotes",v,Message[1])
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Doors")
AddEventHandler("player:Doors",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Vehicle,Network = vRPC.VehicleList(source,5)
		if Vehicle then
			local Players = vRPC.Players(source)
			for _,v in pairs(Players) do
				async(function()
					TriggerClientEvent("player:syncDoors",v,Network,Number)
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 911
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("911",function(source,Message,History)
	local Passport = vRP.Passport(source)
	if Passport and Message[1] and vRP.GetHealth(source) > 100 then
		if vRP.HasService(Passport,"PoliciaMilitar") or vRP.HasService(Passport,"Core") or vRP.HasService(Passport,"PRF") or vRP.HasService(Passport,"PCivil") then
			local Identity = vRP.Identity(Passport)
			local Service = vRP.NumPermission("PoliciaMilitar") + vRP.NumPermission("Core") + vRP.NumPermission("PRF") + vRP.NumPermission("PCivil")
			for Passports,Sources in pairs(Service) do
				async(function()
					TriggerClientEvent("chat:ClientMessage",Sources,Identity["name"],History:sub(4))
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 112
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("112",function(source,Message,History)
	local Passport = vRP.Passport(source)
	if Passport and Message[1] and vRP.GetHealth(source) > 100 then
		if vRP.HasService(Passport,"Paramedic") then
			local Identity = vRP.Identity(Passport)
			local Service = vRP.NumPermission("Paramedic")
			for Passports,Sources in pairs(Service) do
				async(function()
					TriggerClientEvent("Datatable",Sources,Identity["name"].." "..Identity["name2"],History:sub(4))
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOTSFIRED
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.shotsFired(Vehicle)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Vehicle then
			Vehicle = "Disparos de um veículo"
		else
			Vehicle = "Disparos com arma de fogo"
		end

		local Ped = GetPlayerPed(source)
		local Coords = GetEntityCoords(Ped)
		local Service = vRP.NumPermission("PoliciaMilitar") + vRP.NumPermission("Core") + vRP.NumPermission("PRF") + vRP.NumPermission("PCivil")
		for Passports,Sources in pairs(Service) do
			async(function()
				TriggerClientEvent("NotifyPush",Sources,{ code = 10, title = Vehicle, x = Coords["x"], y = Coords["y"], z = Coords["z"], blipColor = 6 })
			end)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CARRYPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
local playerCarry = {}
RegisterServerEvent("player:carryPlayer")
AddEventHandler("player:carryPlayer",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not vRP.InsideVehicle(source) then
			if playerCarry[Passport] then
				TriggerClientEvent("player:playerCarry",playerCarry[Passport],source)
				TriggerClientEvent("player:Commands",playerCarry[Passport],false)
				playerCarry[Passport] = nil
			else
				local ClosestPed = vRPC.ClosestPed(source,2)
				if ClosestPed then
					playerCarry[Passport] = ClosestPed

					TriggerClientEvent("player:playerCarry",playerCarry[Passport],source)
					TriggerClientEvent("player:Commands",playerCarry[Passport],true)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:WINSFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:winsFunctions")
AddEventHandler("player:winsFunctions",function(Mode)
	local source = source
	local vehicle,Network = vRPC.VehicleList(source,10)
	if vehicle then
		TriggerClientEvent("player:syncWins",source,Network,Mode)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CVFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:cvFunctions")
AddEventHandler("player:cvFunctions",function(Mode)
	local Distance = 1
	local source = source

	if Mode == "rv" then
		Distance = 10
	end

	local ClosestPed = vRPC.ClosestPed(source,Distance)
	if ClosestPed then
		local Passport = vRP.Passport(source)
		local Consult = vRP.InventoryItemAmount(Passport,"rope")
		if vRP.HasService(Passport,"Emergency") or Consult[1] >= 1 then
			local Vehicle,Network = vRPC.VehicleList(source,5)
			if Vehicle then
				local Networked = NetworkGetEntityFromNetworkId(Network)
				local Door = GetVehicleDoorLockStatus(Networked)

				if parseInt(Door) <= 1 then
					if Mode == "rv" then
						vCLIENT.removeVehicle(ClosestPed)
					elseif Mode == "cv" then
						vCLIENT.putVehicle(ClosestPed,Network)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
local preset = {
	-- ========================================
	-- FARDAMENTOS POLICIAIS (1-11)
	-- ========================================
	["1"] = { -- PoliciaMilitar
		["mp_m_freemode_01"] = {
             ["hat"] = { item = 0, texture = 0 },    -- Chapeus
            ["pants"] = { item = 143, texture = 4 },  -- Calças
            ["vest"] = { item = 71, texture = 0 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 0, texture = 0 }, -- Mascara
            ["shoes"] = { item = 63, texture = 0 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 25, texture = 0 }, -- Jaqueta
            ["accessory"] = { item = 0, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 0, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
        },
        ["mp_f_freemode_01"] = {
            ["hat"] = { item = -1, texture = 0 },
            ["pants"] = { item = 54, texture = 0 },
            ["vest"] = { item = 19, texture = 1 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["backpack"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 },
            ["mask"] = { item = 0, texture = 0 },
            ["shoes"] = { item = 25, texture = 0 },
            ["tshirt"] = { item = 35, texture = 0 },
            ["torso"] = { item = 92, texture = 2 },
            ["accessory"] = { item = 8, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["arms"] = { item = 31, texture = 0 },
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 }
        }
	},
	["2"] = { -- Core
		["mp_m_freemode_01"] = {
			 ["hat"] = { item = 206, texture = 3 },    -- Chapeus
            ["pants"] = { item = 205, texture = 0 },  -- Calças
            ["vest"] = { item = 86, texture = 5 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 52, texture = 3 }, -- Mascara
            ["shoes"] = { item = 145, texture = 1 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 556, texture = 0 }, -- Jaqueta
            ["accessory"] = { item = 189, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 4, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 1 },
			["pants"] = { item = 54, texture = 1 },
			["vest"] = { item = 4, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 3 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 35, texture = 0 },
			["torso"] = { item = 92, texture = 0 },
			["accessory"] = { item = 8, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 31, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["3"] = { -- PRF
	["mp_m_freemode_01"] = {
		["hat"] = { item = 0, texture = 0 },    -- Chapeus
		["pants"] = { item = 197, texture = 0 },  -- Calças
		["vest"] = { item = 95, texture = 0 },   -- Coletes
		["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
		["backpack"] = { item = 0, texture = 0 }, -- Mochila
		["decals"] = { item = 0, texture = 0 }, -- Adsivo
		["mask"] = { item = 58, texture = 7 }, -- Mascara
		["shoes"] = { item = 145, texture = 0 }, -- Sapato
		["tshirt"] = { item = 15, texture = 0 }, -- Camisa
		["torso"] = { item = 544, texture = 0 }, -- Jaqueta
		["accessory"] = { item = 184, texture = 0 }, -- Acessorio
		["watch"] = { item = -1, texture = 0 }, -- Relogio
		["arms"] = { item = 0, texture = 0 }, -- Braços
		["glass"] = { item = 0, texture = 0 }, -- Oculos
		["ear"] = { item = -1, texture = 0 } -- Brincos
	},
		["mp_f_freemode_01"] = {
			["hat"] = { item = 12, texture = 2 },
			["pants"] = { item = 151, texture = 3 },
			["vest"] = { item = 58, texture = 3 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 141, texture = 5 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 106, texture = 0 },
			["tshirt"] = { item = 237, texture = 0 },
			["torso"] = { item = 415, texture = 9 },
			["accessory"] = { item = 121, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 23, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["4"] = { -- PCivil 
	["mp_m_freemode_01"] = {
		["hat"] = { item = 0, texture = 0 },    -- Chapeus
		["pants"] = { item = 197, texture = 0 },  -- Calças
		["vest"] = { item = 86, texture = 0 },   -- Coletes
		["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
		["backpack"] = { item = 0, texture = 0 }, -- Mochila
		["decals"] = { item = 0, texture = 0 }, -- Adsivo
		["mask"] = { item = 58, texture = 7 }, -- Mascara
		["shoes"] = { item = 145, texture = 0 }, -- Sapato
		["tshirt"] = { item = 15, texture = 0 }, -- Camisa
		["torso"] = { item = 543, texture = 3 }, -- Jaqueta
		["accessory"] = { item = 184, texture = 0 }, -- Acessorio
		["watch"] = { item = -1, texture = 0 }, -- Relogio
		["arms"] = { item = 4, texture = 0 }, -- Braços
		["glass"] = { item = 0, texture = 0 }, -- Oculos
		["ear"] = { item = -1, texture = 0 } -- Brincos
	},
		["mp_f_freemode_01"] = {
			["hat"] = { item = 10, texture = 0 },
			["pants"] = { item = 151, texture = 1 },
			["vest"] = { item = 58, texture = 1 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 140, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 106, texture = 0 },
			["tshirt"] = { item = 237, texture = 0 },
			["torso"] = { item = 415, texture = 3 },
			["accessory"] = { item = 121, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 23, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["5"] = { -- Judiciary
		["mp_m_freemode_01"] = {
			["hat"] = { item = 0, texture = 0 },    -- Chapeus
            ["pants"] = { item = 37, texture = 0 },  -- Calças
            ["vest"] = { item = -1, texture = 0 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item =44, texture = 4 }, -- Adsivo
            ["mask"] = { item = 58, texture = 0 }, -- Mascara
            ["shoes"] = { item = 21, texture = 0 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 560, texture = 9 }, -- Jaqueta
            ["accessory"] = { item = 177, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 0, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = 10, texture = 0 },
			["pants"] = { item = 151, texture = 1 },
			["vest"] = { item = 57, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 106, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 416, texture = 0 },
			["accessory"] = { item = 121, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 23, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	
	-- ========================================
	-- FARDAMENTOS MÉDICOS (12-14)
	-- ========================================
	["12"] = { -- SAMU
		["mp_m_freemode_01"] = {
			["hat"] = { item = 191, texture = 0 },    -- Chapeus
            ["pants"] = { item = 193, texture = 0 },  -- Calças
            ["vest"] = { item = 83, texture = 0 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 58, texture = 2 }, -- Mascara
            ["shoes"] = { item = 145, texture = 0 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 538, texture = 0 }, -- Jaqueta
            ["accessory"] = { item = 180, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 4, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 105, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			-- ["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 6, texture = 0 },
			["torso"] = { item = 217, texture = 0 },
			["accessory"] = { item = 96, texture = 0 },
			-- ["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 106, texture = 0 },
			-- ["glass"] = { item = 0, texture = 0 },
			-- ["ear"] = { item = -1, texture = 0 }
		}
	},
	["7"] = { -- GRAER
		["mp_m_freemode_01"] = {
			["hat"] = { item = 206, texture = 3 },    -- Chapeus
            ["pants"] = { item = 205, texture = 0 },  -- Calças
            ["vest"] = { item = 86, texture = 5 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 52, texture = 3 }, -- Mascara
            ["shoes"] = { item = 145, texture = 1 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 556, texture = 0 }, -- Jaqueta
            ["accessory"] = { item = 189, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 4, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 1 },
			["pants"] = { item = 54, texture = 1 },
			["vest"] = { item = 4, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 3 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 35, texture = 0 },
			["torso"] = { item = 92, texture = 0 },
			["accessory"] = { item = 8, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 31, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["8"] = { -- GRAER PRF
		["mp_m_freemode_01"] = {
			["hat"] = { item = 209, texture = 1 },    -- Chapeus
            ["pants"] = { item = 188, texture = 2 },  -- Calças
            ["vest"] = { item = 104, texture = 1 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 0, texture = 0 }, -- Mascara
            ["shoes"] = { item = 138, texture = 2 }, -- Sapato
            ["tshirt"] = { item = 106, texture = 0 }, -- Camisa
            ["torso"] = { item = 562, texture = 2 }, -- Jaqueta
            ["accessory"] = { item = 1, texture = 1 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 4, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 105, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			-- ["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 6, texture = 0 },
			["torso"] = { item = 217, texture = 0 },
			["accessory"] = { item = 96, texture = 0 },
			-- ["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 106, texture = 0 },
			-- ["glass"] = { item = 0, texture = 0 },
			-- ["ear"] = { item = -1, texture = 0 }
		}
	},
	["9"] = { -- GTM PRF
		["mp_m_freemode_01"] = {
			["hat"] = { item = 209, texture = 0 },    -- Chapeus
            ["pants"] = { item = 188, texture = 0 },  -- Calças
            ["vest"] = { item = 104, texture = 0 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 0, texture = 0 }, -- Mascara
            ["shoes"] = { item = 138, texture = 2 }, -- Sapato
            ["tshirt"] = { item = 106, texture = 0 }, -- Camisa
            ["torso"] = { item = 562, texture = 1 }, -- Jaqueta
            ["accessory"] = { item = 1, texture = 1 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 4, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 105, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			-- ["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 6, texture = 0 },
			["torso"] = { item = 217, texture = 0 },
			["accessory"] = { item = 96, texture = 0 },
			-- ["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 106, texture = 0 },
			-- ["glass"] = { item = 0, texture = 0 },
			-- ["ear"] = { item = -1, texture = 0 }
		}
	},
	["10"] = { -- GTM
		["mp_m_freemode_01"] = {
			["hat"] = { item = 206, texture = 3 },    -- Chapeus
            ["pants"] = { item = 205, texture = 0 },  -- Calças
            ["vest"] = { item = 86, texture = 5 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 52, texture = 3 }, -- Mascara
            ["shoes"] = { item = 145, texture = 1 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 556, texture = 0 }, -- Jaqueta
            ["accessory"] = { item = 189, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 4, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 1 },
			["pants"] = { item = 54, texture = 1 },
			["vest"] = { item = 4, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 3 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 35, texture = 0 },
			["torso"] = { item = 92, texture = 0 },
			["accessory"] = { item = 8, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 31, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["11"] = { -- SPEED
		["mp_m_freemode_01"] = {
			["hat"] = { item = 0, texture = 0 },    -- Chapeus
            ["pants"] = { item = 197, texture = 0 },  -- Calças
            ["vest"] = { item = 85, texture = 4 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 53, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 58, texture = 6 }, -- Mascara
            ["shoes"] = { item = 145, texture = 0 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 543, texture = 3 }, -- Jaqueta
            ["accessory"] = { item = 183, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 4, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 105, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			-- ["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 6, texture = 0 },
			["torso"] = { item = 217, texture = 5 },
			["accessory"] = { item = 96, texture = 0 },
			-- ["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 106, texture = 0 },
			-- ["glass"] = { item = 0, texture = 0 },
			-- ["ear"] = { item = -1, texture = 0 }
		}
	},
	["12"] = { --Police (antigo preset 6)
		["mp_m_freemode_01"] = {
			["hat"] = { item = 0, texture = 0 },    -- Chapeus
            ["pants"] = { item = 197, texture = 0 },  -- Calças
            ["vest"] = { item = 85, texture = 4 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 53, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 58, texture = 6 }, -- Mascara
            ["shoes"] = { item = 145, texture = 0 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 543, texture = 3 }, -- Jaqueta
            ["accessory"] = { item = 183, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 4, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 105, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			-- ["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 6, texture = 0 },
			["torso"] = { item = 217, texture = 5 },
			["accessory"] = { item = 96, texture = 0 },
			-- ["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 106, texture = 0 },
			-- ["glass"] = { item = 0, texture = 0 },
			-- ["ear"] = { item = -1, texture = 0 }
		}
	},
	["13"] = { -- Core (antigo preset 7)
		["mp_m_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },    -- Chapeus
            ["pants"] = { item = 55, texture = 0 },  -- Calças
            ["vest"] = { item = 87, texture = 1 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 73, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 58, texture = 1 }, -- Mascara
            ["shoes"] = { item = 145, texture = 0 }, -- Sapato
            ["tshirt"] = { item = 55, texture = 0 }, -- Camisa
            ["torso"] = { item = 296, texture = 10 }, -- Jaqueta
            ["accessory"] = { item = 45, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 4, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 105, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			-- ["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 6, texture = 0 },
			["torso"] = { item = 217, texture = 4 },
			["accessory"] = { item = 96, texture = 0 },
			-- ["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 106, texture = 0 },
			-- ["glass"] = { item = 0, texture = 0 },
			-- ["ear"] = { item = -1, texture = 0 }
		}
	},
	["14"] = {
		["mp_m_freemode_01"] = { --ROCAM (antigo preset 8)
			["hat"] = { item = 197, texture = 0 },    -- Chapeus
            ["pants"] = { item = 197, texture = 0 },  -- Calças
            ["vest"] = { item = 85, texture = 3 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 54, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 0, texture = 0 }, -- Mascara
            ["shoes"] = { item = 145, texture = 0 }, -- Sapato
            ["tshirt"] = { item = 55, texture = 0 }, -- Camisa
            ["torso"] = { item = 544, texture = 10 }, -- Jaqueta
            ["accessory"] = { item = 1, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 0, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 105, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			-- ["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 6, texture = 0 },
			["torso"] = { item = 217, texture = 3 },
			["accessory"] = { item = 96, texture = 0 },
			-- ["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 106, texture = 0 },
			-- ["glass"] = { item = 0, texture = 0 },
			-- ["ear"] = { item = -1, texture = 0 }
		}
	},
	["15"] = { --PCivil (antigo preset 9)
		["mp_m_freemode_01"] = {
			["hat"] = { item = 0, texture = 0 },    -- Chapeus
            ["pants"] = { item = 59, texture = 9 },  -- Calças
            ["vest"] = { item = 71, texture = 0 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 124, texture = 1 }, -- Mascara
            ["shoes"] = { item = 145, texture = 0 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 525, texture = 0 }, -- Jaqueta
            ["accessory"] = { item = 184, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 0, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos 
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 105, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			-- ["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 6, texture = 0 },
			["torso"] = { item = 217, texture = 2 },
			["accessory"] = { item = 96, texture = 0 },
			-- ["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 106, texture = 0 },
			-- ["glass"] = { item = 0, texture = 0 },
			-- ["ear"] = { item = -1, texture = 0 }
		}
	},
	["16"] = { --GARRA DOPE (antigo preset 10)
		["mp_m_freemode_01"] = {
			 ["hat"] = { item = 0, texture = 0 },    -- Chapeus
            ["pants"] = { item = 59, texture = 9 },  -- Calças
            ["vest"] = { item = 71, texture = 3 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 124, texture = 1 }, -- Mascara
            ["shoes"] = { item = 145, texture = 0 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 524, texture = 1 }, -- Jaqueta
            ["accessory"] = { item = 183, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 4, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 105, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			-- ["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 6, texture = 0 },
			["torso"] = { item = 217, texture = 1 },
			["accessory"] = { item = 96, texture = 0 },
			-- ["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 106, texture = 0 },
			-- ["glass"] = { item = 0, texture = 0 },
			-- ["ear"] = { item = -1, texture = 0 }
		}
	},
		["17"] = { -- PRF (antigo preset 11)
			["mp_m_freemode_01"] = {
				["hat"] = { item = 209, texture = 0 },    -- Chapeus
				["pants"] = { item = 188, texture = 0 },  -- Calças
				["vest"] = { item = 104, texture = 0 },   -- Coletes
				["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
				["backpack"] = { item = 0, texture = 0 }, -- Mochila
				["decals"] = { item = 0, texture = 0 }, -- Adsivo
				["mask"] = { item = 0, texture = 0 }, -- Mascara
				["shoes"] = { item = 138, texture = 2 }, -- Sapato
				["tshirt"] = { item = 106, texture = 0 }, -- Camisa
				["torso"] = { item = 562, texture = 1 }, -- Jaqueta
				["accessory"] = { item = 1, texture = 1 }, -- Acessorio
				["watch"] = { item = -1, texture = 0 }, -- Relogio
				["arms"] = { item = 4, texture = 0 }, -- Braços
				["glass"] = { item = 0, texture = 0 }, -- Oculos
				["ear"] = { item = -1, texture = 0 } -- Brincos
			},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 105, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			-- ["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 6, texture = 0 },
			["torso"] = { item = 217, texture = 0 },
			["accessory"] = { item = 96, texture = 0 },
			-- ["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 106, texture = 0 },
			-- ["glass"] = { item = 0, texture = 0 },
			-- ["ear"] = { item = -1, texture = 0 }
		}
	},
	["18"] = { -- GRR (antigo preset 12)
		["mp_m_freemode_01"] = {
			["hat"] = { item = 209, texture = 1 },    -- Chapeus
            ["pants"] = { item = 188, texture = 2 },  -- Calças
            ["vest"] = { item = 104, texture = 1 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 0, texture = 0 }, -- Mascara
            ["shoes"] = { item = 138, texture = 2 }, -- Sapato
            ["tshirt"] = { item = 106, texture = 0 }, -- Camisa
            ["torso"] = { item = 562, texture = 2 }, -- Jaqueta
            ["accessory"] = { item = 1, texture = 1 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 4, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
	["mp_f_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 105, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		-- ["bracelet"] = { item = -1, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 25, texture = 0 },
		["tshirt"] = { item = 6, texture = 0 },
		["torso"] = { item = 217, texture = 0 },
		["accessory"] = { item = 96, texture = 0 },
		-- ["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 106, texture = 0 },
		-- ["glass"] = { item = 0, texture = 0 },
		-- ["ear"] = { item = -1, texture = 0 }
	   }
    },
	["19"] = { -- Police (antigo preset 13)
		["mp_m_freemode_01"] = {
			["hat"] = { item = 191, texture = 0 },    -- Chapeus
            ["pants"] = { item = 193, texture = 0 },  -- Calças
            ["vest"] = { item = 83, texture = 0 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 0, texture = 0 }, -- Mascara
            ["shoes"] = { item = 145, texture = 0 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 540, texture = 0 }, -- Jaqueta
            ["accessory"] = { item = 180, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 0, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
	["mp_f_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 105, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		-- ["bracelet"] = { item = -1, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 25, texture = 0 },
		["tshirt"] = { item = 6, texture = 0 },
		["torso"] = { item = 217, texture = 0 },
		["accessory"] = { item = 96, texture = 0 },
		-- ["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 106, texture = 0 },
		-- ["glass"] = { item = 0, texture = 0 },
		-- ["ear"] = { item = -1, texture = 0 }
	   }
	},
	["20"] = { -- Police IAMO (antigo preset 14)
		["mp_m_freemode_01"] = {
			["hat"] = { item = 192, texture = 0 },    -- Chapeus
            ["pants"] = { item = 192, texture = 0 },  -- Calças
            ["vest"] = { item = 83, texture = 0 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 58, texture = 2 }, -- Mascara
            ["shoes"] = { item = 145, texture = 0 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 539, texture = 0 }, -- Jaqueta
            ["accessory"] = { item = 180, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 8, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
	["mp_f_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 105, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		-- ["bracelet"] = { item = -1, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 25, texture = 0 },
		["tshirt"] = { item = 6, texture = 0 },
		["torso"] = { item = 217, texture = 0 },
		["accessory"] = { item = 96, texture = 0 },
		-- ["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 106, texture = 0 },
		-- ["glass"] = { item = 0, texture = 0 },
		-- ["ear"] = { item = -1, texture = 0 }
	   }
	},
	["21"] = { -- Police CMD (antigo preset 15)
		["mp_m_freemode_01"] = {
			["hat"] = { item = 191, texture = 0 },    -- Chapeus
            ["pants"] = { item = 193, texture = 0 },  -- Calças
            ["vest"] = { item = 83, texture = 0 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 58, texture = 2 }, -- Mascara
            ["shoes"] = { item = 145, texture = 0 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 538, texture = 0 }, -- Jaqueta
            ["accessory"] = { item = 180, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 4, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
	["mp_f_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 105, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		-- ["bracelet"] = { item = -1, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 25, texture = 0 },
		["tshirt"] = { item = 6, texture = 0 },
		["torso"] = { item = 217, texture = 0 },
		["accessory"] = { item = 96, texture = 0 },
		-- ["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 106, texture = 0 },
		-- ["glass"] = { item = 0, texture = 0 },
		-- ["ear"] = { item = -1, texture = 0 }
	   }
	},
	["12"] = { -- SAMU
		["mp_m_freemode_01"] = {
			["hat"] = { item = 223, texture = 1 },    -- Chapeus
            ["pants"] = { item = -1, texture = 0 },  -- Calças
            ["vest"] = { item = 113, texture = 0 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 209, texture = 0 }, -- Mascara
            ["shoes"] = { item = 148, texture = 0 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 646, texture = 0 }, -- Jaqueta
            ["accessory"] = { item =-1, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 88, texture = 1 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
	["mp_f_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 105, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		-- ["bracelet"] = { item = -1, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 25, texture = 0 },
		["tshirt"] = { item = 6, texture = 0 },
		["torso"] = { item = 217, texture = 0 },
		["accessory"] = { item = 96, texture = 0 },
		-- ["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 106, texture = 0 },
		-- ["glass"] = { item = 0, texture = 0 },
		-- ["ear"] = { item = -1, texture = 0 }
	   }
	},
	["13"] = { -- UPA
		["mp_m_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },    -- Chapeus
            ["pants"] = { item = 236, texture = 0 },  -- Calças
            ["vest"] = { item = -1, texture = 0 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 209, texture = 0 }, -- Mascara
            ["shoes"] = { item = 42, texture = 2 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 644, texture = 1 }, -- Jaqueta
            ["accessory"] = { item = -1, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 85, texture = 1 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
	["mp_f_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 105, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		-- ["bracelet"] = { item = -1, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 25, texture = 0 },
		["tshirt"] = { item = 6, texture = 0 },
		["torso"] = { item = 217, texture = 0 },
		["accessory"] = { item = 96, texture = 0 },
		-- ["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 106, texture = 0 },
		-- ["glass"] = { item = 0, texture = 0 },
		-- ["ear"] = { item = -1, texture = 0 }
	   }
	},
	["14"] = { -- CHEFE UPA
		["mp_m_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },    -- Chapeus
            ["pants"] = { item = 20, texture = 0 },  -- Calças
            ["vest"] = { item = -1, texture = 0 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 209, texture = 1 }, -- Mascara
            ["shoes"] = { item = 42, texture = 2 }, -- Sapato
            ["tshirt"] = { item =21, texture = 4 }, -- Camisa
            ["torso"] = { item = 645, texture = 1 }, -- Jaqueta
            ["accessory"] = { item = -1, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 88, texture = 1 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
	["mp_f_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 105, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		-- ["bracelet"] = { item = -1, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 25, texture = 0 },
		["tshirt"] = { item = 6, texture = 0 },
		["torso"] = { item = 217, texture = 0 },
		["accessory"] = { item = 96, texture = 0 },
		-- ["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 106, texture = 0 },
		-- ["glass"] = { item = 0, texture = 0 },
		-- ["ear"] = { item = -1, texture = 0 }
	   }
	},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Preset")
AddEventHandler("player:Preset",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasService(Passport,"Emergency") then
			local Model = vRP.ModelPlayer(source)

			if Model == "mp_m_freemode_01" or "mp_f_freemode_01" then
				TriggerClientEvent("skinshop:Apply",source,preset[Number][Model])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:checkTrunk")
AddEventHandler("player:checkTrunk",function()
	local source = source
	local ClosestPed = vRPC.ClosestPed(source,2)
	if ClosestPed then
		TriggerClientEvent("player:checkTrunk",ClosestPed)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKTRASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:checkTrash")
AddEventHandler("player:checkTrash",function()
	local source = source
	local ClosestPed = vRPC.ClosestPed(source,2)
	if ClosestPed then
		TriggerClientEvent("player:checkTrash",ClosestPed)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKSHOES
-----------------------------------------------------------------------------------------------------------------------------------------
local UniqueShoes = {}
RegisterServerEvent("player:checkShoes")
AddEventHandler("player:checkShoes",function(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not UniqueShoes[Entity] then
			UniqueShoes[Entity] = os.time()
		end

		if os.time() >= UniqueShoes[Entity] then
			if vSKINSHOP.checkShoes(Entity) then
				vRP.GenerateItem(Passport,"WEAPON_SHOES",2,true)
				UniqueShoes[Entity] = os.time() + 300
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OUTFIT - REMOVER
-----------------------------------------------------------------------------------------------------------------------------------------
local removeFit = {
	["homem"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 14, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 5, texture = 0 },
		["tshirt"] = { item = 15, texture = 0 },
		["torso"] = { item = 15, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 15, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	},
	["mulher"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 14, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 5, texture = 0 },
		["tshirt"] = { item = 15, texture = 0 },
		["torso"] = { item = 15, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 15, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:OUTFIT
-----------------------------------------------------------------------------------------------------------------------------------------
--[[ RegisterServerEvent("player:Outfit")
AddEventHandler("player:Outfit",function(Mode)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not exports["hud"]:Repose(Passport) and not exports["hud"]:Wanted(Passport) then
		if Mode == "aplicar" then
			local result = vRP.GetSrvData("Outfit:"..Passport,true)
			if result["pants"] ~= nil then
				TriggerClientEvent("skinshop:Apply",source,result)
				TriggerClientEvent("Notify",source,"verde","Roupas aplicadas.",3000)
			else
				TriggerClientEvent("Notify",source,"amarelo","Roupas não encontradas.",3000)
			end
		elseif Mode == "salvar" then
			local custom = vSKINSHOP.Customization(source)
			if custom then
				vRP.SetSrvData("Outfit:"..Passport,custom,true)
				TriggerClientEvent("Notify",source,"verde","Roupas salvas.",3000)
			end
		elseif Mode == "aplicarpremium" then
			local result = vRP.GetSrvData("PremiumOutfit:"..Passport,true)
			if result["pants"] ~= nil then
				TriggerClientEvent("skinshop:Apply",source,result)
				TriggerClientEvent("Notify",source,"verde","Roupas aplicadas.",3000)
			else
				TriggerClientEvent("Notify",source,"amarelo","Roupas não encontradas.",3000)
			end
		elseif Mode == "salvarpremium" then
			local custom = vSKINSHOP.Customization(source)
			if custom then
				vRP.SetSrvData("PremiumOutfit:"..Passport,custom,true)
				TriggerClientEvent("Notify",source,"verde","Roupas salvas.",3000)
			end
		elseif Mode == "remover" then
			local Model = vRP.ModelPlayer(source)
			if Model == "mp_m_freemode_01" then
				TriggerClientEvent("skinshop:Apply",source,removeFit["homem"])
			elseif Model == "mp_f_freemode_01" then
				TriggerClientEvent("skinshop:Apply",source,removeFit["mulher"])
			end
		else
			TriggerClientEvent("skinshop:set"..Mode,source)
		end
	end
end) ]]

RegisterServerEvent("player:Outfit")
AddEventHandler("player:Outfit",function(Mode)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport and not exports["hud"]:Repose(Passport) and not exports["hud"]:Wanted(Passport) then
        if Mode == "aplicar" then
            local result = vRP.GetSrvData("Outfit:"..Passport,true)
            if result["pants"] ~= nil then
				TriggerClientEvent("skinshop:Apply",source,result)
                TriggerClientEvent("Notify",source,"verde","Roupas aplicadas.",3000)
            else
                TriggerClientEvent("Notify",source,"amarelo","Roupas não encontradas.",3000)
            end
        elseif Mode == "salvar" then
            local custom = vSKINSHOP.getCustomization(source)
            if custom then
                vRP.SetSrvData("Outfit:"..Passport, custom, true)
                TriggerClientEvent("Notify",source,"verde","Roupas salvas.",3000)
            end
		elseif Mode == "aplicarpremium" then
			local result = vRP.GetSrvData("PremiumOutfit:"..Passport,true)
			if result["pants"] ~= nil then
				TriggerClientEvent("skinshop:Apply",source,result)
				TriggerClientEvent("Notify",source,"verde","Roupas aplicadas.",3000)
			else
				TriggerClientEvent("Notify",source,"amarelo","Roupas não encontradas.",3000)
			end
		elseif Mode == "salvarpremium" then
			local custom = vSKINSHOP.getCustomization(source)
			if custom then
				vRP.SetSrvData("PremiumOutfit:"..Passport,custom,true)
				TriggerClientEvent("Notify",source,"verde","Roupas salvas.",3000)
			end
        elseif Mode == "remover" then
            local Model = vRP.ModelPlayer(source)
            if Model == "mp_m_freemode_01" then
				TriggerClientEvent("skinshop:Apply",source,removeFit["homem"])
            elseif Model == "mp_f_freemode_01" then
				TriggerClientEvent("skinshop:Apply",source,removeFit["mulher"])
            end
        else
            TriggerClientEvent("skinshop:set"..Mode,source)
        end
    end
end)



-----------------------------------------------------------------------------------------------------------------------------------------
-- DEATH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Death")
AddEventHandler("player:Death",function(nsource)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and source ~= nsource then
		local OtherPassport = vRP.Passport(nsource)
		if OtherPassport then
			if GetPlayerRoutingBucket(source) < 900000 then
				TriggerEvent("Discord","Deaths","**Matou:** "..Passport.."\n**Morreu:** "..OtherPassport,3092790)
			else
				local Name = "Individuo Indigente"
				local Name2 = "Individuo Indigente"
				local Identity = vRP.Identity(Passport)
				local nIdentity = vRP.Identity(OtherPassport)

				if Identity and nIdentity then
					Name = Identity["name"].." "..Identity["name2"]
					Name2 = nIdentity["name"].." "..nIdentity["name2"]

					TriggerClientEvent("Notify",source,"amarelo","<b>"..Name.."</b> matou <b>"..Name2.."</b>",10000)
					TriggerClientEvent("Notify",nsource,"amarelo","<b>"..Name.."</b> matou <b>"..Name2.."</b>",10000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BIKEPACK
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Bikepack()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local amountWeight = 10
		local myWeight = vRP.GetWeight(Passport)

		if parseInt(myWeight) < 45 then
			amountWeight = 15
		elseif parseInt(myWeight) >= 45 and parseInt(myWeight) <= 79 then
			amountWeight = 10
		elseif parseInt(myWeight) >= 80 and parseInt(myWeight) <= 95 then
			amountWeight = 5
		elseif parseInt(myWeight) >= 100 and parseInt(myWeight) <= 148 then
			amountWeight = 2
		elseif parseInt(myWeight) >= 150 then
			amountWeight = 1
		end

		vRP.SetWeight(Passport,amountWeight)
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	TriggerClientEvent("player:DuiTable",source,DuiTextures)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if playerCarry[Passport] then
		TriggerClientEvent("player:Commands",playerCarry[Passport],false)
		playerCarry[Passport] = nil
	end
end)
-------------------------
-- CARREGAR - POLICIA
-------------------------
Creative.hasPolPerm = function()
	local src = source
	local charId = vRP.Passport(src)
	if vRP.hasPermission(charId,'Police') or vRP.hasPermission(charId,'Paramedic') or vRP.hasPermission(charId,'Admin') then
		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ID PROXIMO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("id", function(source, args)
	local source = source
	-- local user_id = vRP.Passport(source)
	local ClosestPed = vRPC.ClosestPed(source,3)
	if ClosestPed then
		local nuser_id = vRP.Passport(ClosestPed)
		TriggerClientEvent("Notify",source,"amarelo","Passaporte:"..nuser_id.."",7000)
		TriggerClientEvent("Notify",ClosestPed,"amarelo","Foi feito uma busca em seu passaporte",7000)
		--TriggerEvent("Discord","comando-id","**Passaporte:** "..Passport.."\n**Verificou o passaporte do:** "..parseFormat(nuser_id).."\n**Horário:** "..os.date("%H:%M:%S"),3042892)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETAR MOCHILA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:Survival")
AddEventHandler("player:Survival",function()
	local Source = source
	local Passport = vRP.Passport(Source)

	if vRP.UserPremium(Passport) then
		if ClearInventoryPremium then
			vRP.ClearInventory(Passport)
		end
	elseif CleanDeathInventory then
		vRP.ClearInventory(Passport)
	end
	
	local Datatable = vRP.Datatable(Passport)
	if WipeBackpackDeath and Datatable and Datatable.Weight then
		Datatable.Weight = BackpackWeightDefault
	end
	vRP.UpgradeThirst(Passport, 100)
	vRP.UpgradeHunger(Passport, 100)
	vRP.DowngradeStress(Passport, 100)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOT RESETAR MOCHILA 
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("player:Survival")
AddEventHandler("player:Survival",function()
	local Source = source
	local Passport = vRP.Passport(Source)
	if vRP.Celebridade(Passport) then
		if ClearInventoryCelebridade then
			vRP.ClearInventory(Passport)
		end
	elseif CleanDeathInventory then
		vRP.ClearInventory(Passport)
	end

	local Datatable = vRP.Datatable(Passport)
	if WipeBackpackDeath and Datatable and Datatable.Weight then
		Datatable.Weight = BackpackWeightDefault
	end
	vRP.UpgradeThirst(Passport, 100)
	vRP.UpgradeHunger(Passport, 100)
	vRP.DowngradeStress(Passport, 100)
end)




----------=================================================
----------============== ARRASTAR
----------=================================================


local L0_1, L1_1, L2_1, L3_1
L0_1 = {}
L1_1 = RegisterServerEvent
L2_1 = "ryt:sendEvent"
L1_1(L2_1)
L1_1 = AddEventHandler
L2_1 = "ryt:sendEvent"
function L3_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L4_2 = TriggerClientEvent
  L5_2 = "ryt:sendEvent"
  L6_2 = A0_2
  L7_2 = A1_2
  L8_2 = A3_2
  L9_2 = true
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  L4_2 = TriggerClientEvent
  L5_2 = "ryt:sendEvent"
  L6_2 = A1_2
  L7_2 = A0_2
  L8_2 = A2_2
  L9_2 = false
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
end
L1_1(L2_1, L3_1)
L1_1 = RegisterServerEvent
L2_1 = "ryt:Detach"
L1_1(L2_1)
L1_1 = AddEventHandler
L2_1 = "ryt:Detach"
function L3_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = TriggerClientEvent
  L2_2 = "ryt:Detach"
  L3_2 = A0_2
  L1_2(L2_2, L3_2)
end
L1_1(L2_1, L3_1)
L1_1 = RegisterServerEvent
L2_1 = "ryt:DeadEvent"
L1_1(L2_1)
L1_1 = AddEventHandler
L2_1 = "ryt:DeadEvent"
function L3_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = TriggerClientEvent
  L2_2 = "ryt:DeadEvent"
  L3_2 = A0_2
  L1_2(L2_2, L3_2)
end
L1_1(L2_1, L3_1)
L1_1 = RegisterServerEvent
L2_1 = "ryt:enterPed"
L1_1(L2_1)
L1_1 = AddEventHandler
L2_1 = "ryt:enterPed"
function L3_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = TriggerClientEvent
  L4_2 = "ryt:enterPed"
  L5_2 = A0_2
  L6_2 = A1_2
  L7_2 = A2_2
  L3_2(L4_2, L5_2, L6_2, L7_2)
end
L1_1(L2_1, L3_1)
L1_1 = RegisterServerEvent
L2_1 = "ryt:exitPed"
L1_1(L2_1)
L1_1 = AddEventHandler
L2_1 = "ryt:exitPed"
function L3_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = TriggerClientEvent
  L3_2 = "ryt:exitPed"
  L4_2 = A0_2
  L5_2 = A1_2
  L2_2(L3_2, L4_2, L5_2)
end
L1_1(L2_1, L3_1)
L1_1 = RegisterServerEvent
L2_1 = "ryt:syncVariable"
L1_1(L2_1)
L1_1 = AddEventHandler
L2_1 = "ryt:syncVariable"
function L3_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = TriggerClientEvent
  L2_2 = "ryt:syncVariable"
  L3_2 = -1
  L4_2 = A0_2
  L1_2(L2_2, L3_2, L4_2)
  L0_1 = A0_2
end
L1_1(L2_1, L3_1)
L1_1 = Citizen
L1_1 = L1_1.CreateThread
function L2_1()
  local L0_2, L1_2, L2_2
  L0_2 = Config
  L0_2 = L0_2.ESX
  L0_2 = L0_2.enabled
  if L0_2 then
    L0_2 = Config
    L0_2 = L0_2.ESX
    L0_2 = L0_2.exceptionJobs
    if L0_2 then
      ESX = nil
      L0_2 = TriggerEvent
      L1_2 = "esx:getSharedObject"
      function L2_2(A0_3)
        local L1_3
        ESX = A0_3
      end
      L0_2(L1_2, L2_2)
    end
  end
end
L1_1(L2_1)
L1_1 = Config
L1_1 = L1_1.ESX
L1_1 = L1_1.enabled
if L1_1 then
  L1_1 = Config
  L1_1 = L1_1.ESX
  L1_1 = L1_1.exceptionJobs
  if L1_1 then
    L1_1 = RegisterServerEvent
    L2_1 = "ryt:exceptionJobs"
    L1_1(L2_1)
    L1_1 = AddEventHandler
    L2_1 = "ryt:exceptionJobs"
    function L3_1(A0_2, A1_2)
      local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
      L2_2 = ESX
      L2_2 = L2_2.GetPlayerFromId
      L3_2 = A1_2
      L2_2 = L2_2(L3_2)
      L3_2 = TriggerClientEvent
      L4_2 = "ryt:exceptionJobs"
      L5_2 = A0_2
      L6_2 = false
      L3_2(L4_2, L5_2, L6_2)
      L3_2 = 1
      L4_2 = Config
      L4_2 = L4_2.ESX
      L4_2 = L4_2.jobs
      L4_2 = #L4_2
      L5_2 = 1
      for L6_2 = L3_2, L4_2, L5_2 do
        L7_2 = L2_2.job
        if nil ~= L7_2 then
          L7_2 = L2_2.job
          L7_2 = L7_2.name
          L8_2 = Config
          L8_2 = L8_2.ESX
          L8_2 = L8_2.jobs
          L8_2 = L8_2[L6_2]
          if L7_2 == L8_2 then
            L7_2 = TriggerClientEvent
            L8_2 = "ryt:exceptionJobs"
            L9_2 = A0_2
            L10_2 = true
            L7_2(L8_2, L9_2, L10_2)
          end
        end
      end
    end
    L1_1(L2_1, L3_1)
  end
end
