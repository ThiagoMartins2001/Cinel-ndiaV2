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
Tunnel.bindInterface("admin",Creative)
vCLIENT = Tunnel.getInterface("admin")
vKEYBOARD = Tunnel.getInterface("keyboard")

local webhookItem = "https://discord.com/api/webhooks/1295435953409626198/pftVaJEAXRZ6suQjz81R87do4yF3RECJeNnwuinygo8oHfaokkF56WDC77CvKnVdFJtY"
local webhookclearinv = "https://discord.com/api/webhooks/1295436194624180394/TfYu-q7IJD81OadDpTj_v5zibPwGfQRgAp9vWfAaCPczF8JGLDdkBx_z6D6FZrCBqbMs"
local webhookblips = "https://discord.com/api/webhooks/1295436287867617430/zp3yTEA9Y0oJg92CFu1uIBTknHCWS97_BgJc_Qt4lexz_G9vygKYeWOBuOfGW3W-1OQP"
local webhookanunciar = "https://discord.com/api/webhooks/1295443593116520458/VeoDhB-sA52geboM8kTJB34gkKebvaYEdULkKP9JpvlhM_94270sJRQ9dqhc8xXXaNWM"
local webhookgod = "https://discord.com/api/webhooks/1295443864127144078/8FCUhC2qv3sxhBp_ygrw0r8983IyEgoABmn5wxJ0f0PKdWpWlROSnBYOaZkOC0v6qo5b"
local webhooknc = "https://discord.com/api/webhooks/1295443745923268680/ljE9OJ1Okyy4cWsNRWwjGoVO2w22y2WYOKvOOw6wPFd3hdeS9OLnGXGpap__XqUesZXm"
local webhookkick = "https://discord.com/api/webhooks/1155798263480463441/an6UQtnuEkVM2_yXsfRUb4OmC4_4vsUsAGO_aUgKSdC65AqUlUDIVK1825BUecdGVL9n"
local webhooktpway = "https://discord.com/api/webhooks/1295444118343782410/3jwaYe3CRCLffjrcFIdFkcNR7lVIwFcjV5ggNjjHqRunj5Ov982b5o3yBSaAjk6Vhf4u"
local webhookfix = "https://discord.com/api/webhooks/1295444213928034344/ojv-magBO7zvLeAEtYlLJBbRxZqZ6iTY7gpWxLJlJSrm9rR6wJ5K0O0PZ-Gj7_OjldxG"
local webhookannounce = "https://discord.com/api/webhooks/1295443593116520458/VeoDhB-sA52geboM8kTJB34gkKebvaYEdULkKP9JpvlhM_94270sJRQ9dqhc8xXXaNWM"
local webhookannouncepolice = "https://discord.com/api/webhooks/1295444397546012762/prXa68OkLojjHWDbB0bqiVC6GPHQwo3pNfDzhWy8gxgOtLat-pxE7hUzbbV07FsqBneR"
local webhookitemall = "https://discord.com/api/webhooks/1295444493612613734/e16TLWrD61VHJEyTIDqwpznSqAhQWAvnMsYbuSf2A7LQ6eFkrHRnhhkDcrZ3DvY-omhe"
local webhookaddcar = "https://discord.com/api/webhooks/1295444679470485596/tEDmlPIQXQPqhR3fa3es78K049gjVJCYc2Ifv8WLv8FzrWrv0G_mqZgTt98_bXsP5K09"
local webhookbanimentos = "https://discord.com/api/webhooks/1155800093824401431/g5TVwKcxG6e9ga4TvhaobBQscXIm5gK6P5rMesx3ODebgidoqYvHC7dYlTPAQCOvc9Es"
local webhookdesbanimentos = "https://discord.com/api/webhooks/1295444776874938482/jzK4aScnrSus23K64UEZeQ_yVlaoVlNX0p407uLBgoMpzxITpNsMCdYD0PJj0HGDscfS"
local webhooktpcds = "https://discord.com/api/webhooks/1295444931204354088/NFManthWsqLtBKZM4gx3S-zioQ8vy-hgXtsYeMR29srutesf6wVZhcTln05PVnVQ1zj4"
local webhooktptome = "https://discord.com/api/webhooks/1295445364198998027/7NUdkIlbyUhJOE0GaHR32DZb66U0YldLSLQA7jHiHmnqy-yVErhvQ207tTnzieuF-M13"
local webhooktpto = "https://discord.com/api/webhooks/1362528950282223957/_TyjT5HVwEESKQO8f9gibEKqvawNyO54Sjv3mIRGNW29iF5a9asLbzOD2TAkd-uJCQkG"
local webhookspectate = "https://discord.com/api/webhooks/1295445712326234252/fmk03reKnp-DHYREFEswy4QwhQ4LWjZjbeKuUqHSUCU5R8m5hiJ0mSDyUhCHXBHvk2Mn"
local webhookgiveitem = "https://discord.com/api/webhooks/1362529550092730418/Xc1qibR3kvijjSUwwXgvcB-bwDf_SJ-Po8QHQcqM0k3uECBN1EiewZ_y2OAPjuF8iKjK"
local webhookvisto = "https://discord.com/api/webhooks/1362529625187553522/ZpijG9yzPsuSjj3wruh7yaX1tzNHcevAIvu2xLqyVA77AbJIyTB8_EAVaKDPXpJCp9XT"


-----------------------------------------------------------------------------------------------------------------------------------------
-- STAFF
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("staff",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		TriggerEvent("service:ToggleServer",source,Passport)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LSCUSTOMS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("lscustoms",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin", 1) and vRP.HasService(Passport,"Admin") then
		TriggerClientEvent("lscustoms:Open",source)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- UGROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("checkgroup",function(source,Message)
	local Passport = vRP.Passport(source)
	if vRP.HasGroup(Passport, "Admin", 1) then
		if Passport and parseInt(Message[1]) > 0 then
			local Messages = ""
			local Groups = vRP.Groups()
			local OtherPassport = Message[1]
			for Permission,_ in pairs(Groups) do
				local Data = vRP.DataGroups(Permission)
				if Data[OtherPassport] then
					Messages = Messages..Permission.."<br>"
				end
			end
	
			if Messages ~= "" then
				TriggerClientEvent("Notify",source,"verde",Messages,10000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARINV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("clearinv",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 2) and vRP.HasService(Passport,"Admin") and parseInt(Message[1]) > 0 then
			TriggerClientEvent("Notify",source,"verde","Limpeza concluída.",5000)
			vRP.ClearInventory(Message[1])
			vRP.SendWebhook(webhookclearinv, "LOGs Clear INV", "**Passaporte: **"..Passport.."\n**Limpou o inv. de: ** "..Message[1], 3558275)
		end
	end
end)
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- GEM
-- -----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("pordimas",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin") and vRP.HasService(Passport,"Admin") and parseInt(Message[1]) > 0 and parseInt(Message[2]) > 0 then
			local Amount = parseInt(Message[2])
			local OtherPassport = parseInt(Message[1])
			local Identity = vRP.Identity(OtherPassport)
			if Identity then
				TriggerClientEvent("Notify",source,"verde","Gemas entregues.",5000)
				vRP.Query("accounts/AddGems",{ license = Identity["license"], gems = Amount })
				TriggerEvent("Discord","Gemstone","**Source:** "..source.."\n**Passaporte:** "..Passport.."\n**Para:** "..OtherPassport.."\n**Gemas:** "..Amount.."\n**Address:** "..GetPlayerEndpoint(source),3092790)
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- RENAME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("rename",function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") and vRP.HasService(Passport,"Admin") then
		local Keyboard = vKEYBOARD.Tertiary(source,"Passaporte","Nome","Sobrenome")
		if Keyboard then
			vRP.UpgradeNames(Keyboard[1],Keyboard[2],Keyboard[3])
			TriggerClientEvent("Notify",source,"Sucesso","Nome atualizado.","verde",5000)
			--exports["discord"]:Embed("Renamed","**[ADMIN]:** "..Passport.."\n**[PASSAPORTE]:** "..Keyboard[1].."\n**[NOME]:** "..Keyboard[2].." "..Keyboard[3].."\n**[DATA & HORA]:** "..os.date("%d/%m/%Y").." às "..os.date("%H:%M"))
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("blips",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 3) and vRP.HasService(Passport,"Admin") then
			vRPC.BlipAdmin(source)
			vRP.SendWebhook(webhookblips, "LOGs blips", "**Passaporte: **"..Passport, 3558275)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANUNCIAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("anunciar",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 2) and vRP.HasService(Passport,"Admin") then
			local Keyboard = vKEYBOARD.Primary(source,"Anúncio:")
			if Keyboard then
				TriggerClientEvent("Notify",-1,"admin",Keyboard[1].."<br><b>Anúncio Prefeitura</b>",40000)
				vRP.SendWebhook(webhookanunciar, "LOGs anunciar", "**Passaporte: **"..Passport.."\n**Anunciou: **"..Keyboard[1], 10357504)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("god",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 3) and vRP.HasService(Passport,"Admin") then
			
			if Message[1] then
				local OtherPassport = parseInt(Message[1])
				local ClosestPed = vRP.Source(OtherPassport)
				if ClosestPed then
					-- vRP.RemAddiction(Passport)
					-- vRP.DowngradeAddiction(OtherPassport,100)
					vRP.Revive(ClosestPed,150)
				end
				vRP.SendWebhook(webhookgod, "LOGs god", "**Passaporte: **"..Passport.."\n**Deu GOD em: **"..Message[1], 10357504)
			else
				vRP.Revive(source,150)
				-- vRP.RemAddiction(Passport)
				-- vRP.DowngradeAddiction(Passport,100)

				TriggerClientEvent("paramedic:Reset",source)
				vRP.SendWebhook(webhookgod, "LOGs god", "**Passaporte: **"..Passport.."\n**Deu GOD em: ** nele mesmo", 10357504)

				vRPC.removeObjects(source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("good",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 2) and vRP.HasService(Passport,"Admin") then
			
			if Message[1] then
				local OtherPassport = parseInt(Message[1])
				local ClosestPed = vRP.Source(OtherPassport)
				if ClosestPed then
					vRP.UpgradeThirst(OtherPassport,100)
					vRP.UpgradeHunger(OtherPassport,100)
					vRP.DowngradeStress(OtherPassport,100)
					vRP.RemAddiction(OtherPassport)
					vRP.DowngradeAddiction(OtherPassport,100)
					vRP.Revive(ClosestPed,200)
					TriggerClientEvent("vRP:ResetWalkMode",ClosestPed)
				end
				vRP.SendWebhook(webhookgod, "LOGs god", "**Passaporte: **"..Passport.."\n**Deu GOOD em: **"..Message[1], 10357504)
			else
				vRP.Revive(source,200,true)
				vRP.UpgradeThirst(Passport,100)
				vRP.UpgradeHunger(Passport,100)
				vRP.DowngradeStress(Passport,100)
				vRP.RemAddiction(Passport)
				vRP.DowngradeAddiction(Passport,100)

				TriggerClientEvent("vRP:ResetWalkMode",source)
				TriggerClientEvent("paramedic:Reset",source)
				vRP.SendWebhook(webhookgod, "LOGs god", "**Passaporte: **"..Passport.."\n**Deu GOOD em: ** nele mesmo", 10357504)

				vRPC.removeObjects(source)
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDICTION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("addiction",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 3) and vRP.HasService(Passport,"Admin") then
			if Message[1] then
				local OtherPassport = parseInt(Message[1])
				local ClosestPed = vRP.Source(OtherPassport)
				if ClosestPed then
					vRP.SetAddiction(OtherPassport)
					vRP.UpgradeAddiction(OtherPassport,100)
				end
			else
				vRP.SetAddiction(Passport)
				vRP.UpgradeAddiction(Passport,100)
			end
		end
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- TXTENTITY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.TxtEntity(m,c,r,h)
	local source = source
	local Passport = vRP.Passport(source)
	if vRP.HasGroup(Passport,'Admin') then
	  vRP.Archive('entity.lua','Model: '..m)
	  vRP.Archive('entity.lua','Coords: '..mathLength(c.x)..','..mathLength(c.y)..','..mathLength(c.z))
	  vRP.Archive('entity.lua','Rotation: '..mathLength(r.x)..','..mathLength(r.y)..','..mathLength(r.z))
	  vRP.Archive('entity.lua','Heading: '..mathLength(h)..'\n')
	end
  end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COLETE
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterCommand("colete",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 2) and vRP.HasService(Passport,"Admin") then
			if Message[1] then
				local OtherPassport = parseInt(Message[1])
				local ClosestPed = vRP.Source(OtherPassport)
				if ClosestPed then
					vRP.SetArmour(source,99)
				end
			else
				vRP.Revive(source,200,true)
				vRP.SetArmour(source,99)
				vRP.UpgradeThirst(Passport,100)
				vRP.UpgradeHunger(Passport,100)
				vRP.DowngradeStress(Passport,100)

				TriggerClientEvent("paramedic:Reset",source)

				vRPC.removeObjects(source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("item",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 1) and vRP.HasService(Passport,"Admin") then
			if Message[1] and Message[2] and itemBody(Message[1]) ~= nil then
				vRP.GenerateItem(Passport,Message[1],parseInt(Message[2]),true)

				vRP.SendWebhook(webhookItem, "LOGs Spawn Item", "**Passaporte: **"..Passport.."\n**Spawnou: ** x"..Message[2].." "..Message[1], 3558275)
			end
		end
	end
end)

RegisterCommand('Fawn',function(src,r,c)

	print(VehicleName('ninef'))
	print(VehicleName('bmws'))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GiveItem
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("daritem",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"OwnerInvoke",1) then
			if Message[1] and Message[2] and Message[3] and itemBody(Message[1]) ~= nil then
				vRP.GenerateItem(Message[3],Message[1],parseInt(Message[2]),true)
				TriggerClientEvent("Notify",source,"verde","Você deu <b>"..Message[2].."x "..Message[1].."</b> ao Passaporte <b>"..Message[3].."</b>.",10000)
				vRP.SendWebhook(webhookgiveitem, "LOGs Give Item", "**Passaporte: **"..Passport.."\n**Deu o item: ** x"..Message[2].." "..Message[1].."\n**Ao Passaporte:** "..Message[3], 3558275)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("delete",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and Message[1] then
		if vRP.HasGroup(Passport,"OwnerInvoke",1) then
			local OtherPassport = parseInt(Message[1])
			vRP.Query("characters/removeCharacter",{ id = OtherPassport })
			TriggerClientEvent("Notify",source,"verde","Personagem <b>"..OtherPassport.."</b> deletado.",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("nc",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",3) and vRP.HasService(Passport,"Admin") then
			vRPC.noClip(source)
			vRP.SendWebhook(webhooknc, "LOGs NC", "**Passaporte: **"..Passport.."\n**Usou NC**", 10357504)
			--TriggerClientEvent('noclipeffect',-1)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kick",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 3) and vRP.HasService(Passport,"Admin") and parseInt(Message[1]) > 0 then
			local OtherSource = vRP.Source(Message[1])
			if OtherSource then
				TriggerClientEvent("Notify",source,"amarelo","Passaporte <b>"..Message[1].."</b> expulso.",5000)
				vRP.Kick(OtherSource,"Expulso da cidade.")
				vRP.SendWebhook(webhookkick, "LOGs Kick", "**Passaporte: **"..Passport.."\n**Kickou: **"..Message[1], 10357504)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ban",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 2) and vRP.HasService(Passport,"Admin") and parseInt(Message[1]) > 0 and parseInt(Message[2]) > 0 then
			local Days = parseInt(Message[2])
			local OtherPassport = parseInt(Message[1])
			local Identity = vRP.Identity(OtherPassport)
			if Identity then
				vRP.Query("banneds/InsertBanned",{ license = Identity["license"], time = Days })
				TriggerClientEvent("Notify",source,"amarelo","Passaporte <b>"..OtherPassport.."</b> banido por <b>"..Days.."</b> dias.",5000)
				vRP.SendWebhook(webhookbanimentos, "LOGs Banimentos", "**Passaporte: **"..Passport.."\n**Baniu: **"..OtherPassport.."\n**Duração em dias: **"..Days, 10357504)
				local OtherSource = vRP.Source(OtherPassport)
				if OtherSource then
					vRP.Kick(OtherSource,"Banido.")
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("unban",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 3) and vRP.HasService(Passport,"Admin") and parseInt(Message[1]) > 0 then
			local OtherPassport = parseInt(Message[1])
			local Identity = vRP.Identity(OtherPassport)
			if Identity then
				vRP.Query("banneds/RemoveBanned",{ license = Identity["license"] })
				TriggerClientEvent("Notify",source,"verde","Passaporte <b>"..OtherPassport.."</b> desbanido.",5000)
				vRP.SendWebhook(webhookdesbanimentos, "LOGs Banimentos", "**Passaporte: **"..Passport.."\n**Desbaniu: **"..OtherPassport, 10357504)

			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPCDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpcds",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 3) and vRP.HasService(Passport,"Admin") then
			local Keyboard = vKEYBOARD.Primary(source,"Cordenadas:")
			if Keyboard then
				local Split = splitString(Keyboard[1],",")
				vRP.Teleport(source,Split[1] or 0,Split[2] or 0,Split[3] or 0)
				vRP.SendWebhook(webhooktpcds, "LOGs TPCDS", "**Passaporte: **"..Passport.."\n**Deu TP na CDS: **"..Split[1]..", "..Split[2]..", "..Split[3], 10357504)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cds",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 3) and vRP.HasService(Passport,"Admin") then
			local Ped = GetPlayerPed(source)
			local Coords = GetEntityCoords(Ped)
			local heading = GetEntityHeading(Ped)

			vKEYBOARD.Copy(source,"Cordenadas:",mathLength(Coords["x"])..","..mathLength(Coords["y"])..","..mathLength(Coords["z"])..","..mathLength(heading))
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("group",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		--if vRP.HasGroup(Passport,"Admin", 1) and vRP.HasService(Passport,"Admin") then
			if parseInt(Message[1]) > 0 and Message[2] then
				TriggerClientEvent("Notify",source,"verde","Adicionado <b>"..Message[2].."</b> ao passaporte <b>"..Message[1].."</b>.",5000)
				vRP.SetPermission(Message[1],Message[2],Message[3])
				TriggerEvent("Discord","group","**Setou Group**\n\n**Passaporte:** "..Passport.."\n**Para:** "..Message[1].."\n**Grupo:** "..Message[2],3553599)

				-- dk_groups
				if Message[1] and Message[2] then
					TriggerEvent("dk_groups/sendAction","remove",parseInt(Message[1]),Message[2].."//"..(Message[3] or 1))
				end
				-- dk_groups

			end
		--end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- UNGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ungroup",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 2) and vRP.HasService(Passport,"Admin") and parseInt(Message[1]) > 0 and Message[2] then
			TriggerClientEvent("Notify",source,"verde","Removido <b>"..Message[2].."</b> ao passaporte <b>"..Message[1].."</b>.",5000)
			vRP.RemovePermission(Message[1],Message[2])
			TriggerEvent("Discord","ungroup","**Removeu Grupo**\n\n**Passaporte:** "..Passport.."\n**Para:** "..Message[1].."\n**Grupo:** "..Message[2],3553599)

			-- dk_groups
			if Message[1] and Message[2] then
				TriggerEvent("dk_groups/sendAction","remove",parseInt(Message[1]),Message[2])
			end
			-- dk_groups
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tptome",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 3) and vRP.HasService(Passport,"Admin") and parseInt(Message[1]) > 0 then
			local ClosestPed = vRP.Source(Message[1])
			if ClosestPed then
				local Ped = GetPlayerPed(source)
				local Coords = GetEntityCoords(Ped)

				vRP.Teleport(ClosestPed,Coords["x"],Coords["y"],Coords["z"])
				vRP.SendWebhook(webhooktptome, "LOGs tptome", "**Passaporte: **"..Passport.."\n**Deu TP to me no ID: **"..Message[1].."\n**Na localização: **"..Coords["x"]..", "..Coords["y"]..", "..Coords["z"], 10357504)

			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpto",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 3) and vRP.HasService(Passport,"Admin") and parseInt(Message[1]) > 0 then
			local ClosestPed = vRP.Source(Message[1])
			if ClosestPed then
				local Ped = GetPlayerPed(ClosestPed)
				local Coords = GetEntityCoords(Ped)
				vRP.Teleport(source,Coords["x"],Coords["y"],Coords["z"])
				vRP.SendWebhook(webhooktpto, "LOGs tpto", "**Passaporte: **"..Passport.."\n**Deu TP no ID: **"..Message[1].."\n**Na localização: **"..Coords["x"]..", "..Coords["y"]..", "..Coords["z"], 10357504)

			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpway",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 3) and vRP.HasService(Passport,"Admin") then
			vCLIENT.teleportWay(source)
			vRP.SendWebhook(webhooktpway, "LOGs TPWAY", "**Passaporte: **"..Passport.."\n**Usou TPWAY**", 10357504)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limbo",function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) <= 100 then
		vCLIENT.teleportLimbo(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hash",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 2) and vRP.HasService(Passport,"Admin") then
			local vehicle = vRPC.VehicleHash(source)
			if vehicle then
				print(vehicle)
				vRP.Archive("hash.txt",vehicle)
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tuning",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 1) and vRP.HasService(Passport,"Admin") then
			TriggerClientEvent("admin:vehicleTuning",source)

		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("fix",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 2) and vRP.HasService(Passport,"Admin") then
			local Vehicle,Network,Plate = vRPC.VehicleList(source,10)
			if Vehicle then
				TriggerClientEvent("inventory:repairAdmin",source,Network,Plate)
				vRP.SendWebhook(webhookfix, "LOGs FIX", "**Passaporte: **"..Passport.."\n**Deu fix em algum veículo", 10357504)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limparlocal",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 2) and vRP.HasService(Passport,"Admin") then
			local Ped = GetPlayerPed(source)
			local Coords = GetEntityCoords(Ped)
			TriggerClientEvent("syncarea",source,Coords["x"],Coords["y"],Coords["z"],100)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("players",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 3) and vRP.HasService(Passport,"Admin") then
			TriggerClientEvent("Notify",source,"azul","<b>Jogadores Conectados:</b> "..GetNumPlayerIndices(),5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:COORDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("admin:Coords")
AddEventHandler("admin:Coords",function(Coords)
	vRP.Archive("coordenadas.txt",mathLength(Coords["x"])..","..mathLength(Coords["y"])..","..mathLength(Coords["z"]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.buttonTxt()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin") then
			local Ped = GetPlayerPed(source)
			local Coords = GetEntityCoords(Ped)
			local heading = GetEntityHeading(Ped)

			vRP.Archive(Passport..".txt",mathLength(Coords["x"])..","..mathLength(Coords["y"])..","..mathLength(Coords["z"])..","..mathLength(heading))
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand("anuncio",function(source,Message,History)
-- 	local Passport = vRP.Passport(source)
-- 	if Passport then
-- 		if vRP.HasGroup(Passport,"Admin", 1) and Message[1] then
-- 			TriggerClientEvent("chat:ClientMessage",-1,"Governador",History:sub(9))
-- 			vRP.SendWebhook(webhookannounce, "LOGs Announce", "**Passaporte: **"..Passport.."\n**Anunciou: **"..Message[1], 10357504)

-- 		end
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE POLICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("anunciar",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 2) and vRP.HasService(Passport,"Admin") then
			local Keyboard = vKEYBOARD.Primary(source,"Prefeitura:")
			if Keyboard then
				TriggerClientEvent("Notify",-1,"adm",Keyboard[1].."<br><b>Anúncio Prefeitura</b>",50000)
				--vRP.SendWebhook(webhookanunciar, "LOGs anunciar", "**Passaporte: **"..Passport.."\n**Anunciou: **"..Keyboard[1], 10357504)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE POLICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("anunciopolice",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"PoliciaMilitar",2) or vRP.HasGroup(Passport,"Core",2) or vRP.HasGroup(Passport,"PRF",2) or vRP.HasGroup(Passport,"PCivil",2) then
			local Keyboard = vKEYBOARD.Primary(source,"Policia:")
			if Keyboard then
				TriggerClientEvent("Notify",-1,"police",Keyboard[1].."<br><b>Anúncio Policia</b>",20000)
				vRP.SendWebhook(webhookanunciar, "LOGs anunciar", "**Passaporte: **"..Passport.."\n**Anunciou: **"..Keyboard[1], 10357504)
			end
		end
	end
end)



-----------------------------------------------------------------------------------------------------------------------------------------
-- ANUNCIAR MECHANIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("anunciomec",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Mechanic",2) then
			local Keyboard = vKEYBOARD.Primary(source,"Mecanica:")
			if Keyboard then
				TriggerClientEvent("Notify",-1,"amarelo",Keyboard[1].."<br><b>Anúncio Mecanica Absolut Customs</b>",20000)
				vRP.SendWebhook(webhookanunciar, "LOGs anunciar", "**Passaporte: **"..Passport.."\n**Anunciou: **"..Keyboard[1], 10357504)
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ANUNCIAR Mcdonalds
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("anunciomc",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Mcdonalds",3) then
			local Keyboard = vKEYBOARD.Primary(source,"Mcdonalds:")
			if Keyboard then
				TriggerClientEvent("Notify",-1,"fome",Keyboard[1].."<br><b>Anúncio MCDONALDS</b>",20000)
				vRP.SendWebhook(webhookanunciar, "LOGs anunciar", "**Passaporte: **"..Passport.."\n**Anunciou: **"..Keyboard[1], 10357504)
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ANUNCIAR Ifrut
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("anunciorestaurante",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Ifrut",3) then
			local Keyboard = vKEYBOARD.Primary(source,"Ifrut:")
			if Keyboard then
				TriggerClientEvent("Notify",-1,"amor",Keyboard[1].."<br><b>Anúncio Ifrut</b>",20000)
				vRP.SendWebhook(webhookanunciar, "LOGs anunciar", "**Passaporte: **"..Passport.."\n**Anunciou: **"..Keyboard[1], 10357504)
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ANUNCIAR Pawnshop
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("anunciopawnshop",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Pawnshop",3) then
			local Keyboard = vKEYBOARD.Primary(source,"Pawnshop:")
			if Keyboard then
				TriggerClientEvent("Notify",-1,"compras",Keyboard[1].."<br><b>Anúncio Pawnshop</b>",20000)
				vRP.SendWebhook(webhookanunciar, "LOGs anunciar", "**Passaporte: **"..Passport.."\n**Anunciou: **"..Keyboard[1], 10357504)
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE POLICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("anunciohp",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Paramedic",1) then
			local Keyboard = vKEYBOARD.Primary(source,"Hospital:")
			if Keyboard then
				TriggerClientEvent("Notify",-1,"adm",Keyboard[1].."<br><b>Anúncio Hospital</b>",50000)
				--vRP.SendWebhook(webhookanunciar, "LOGs anunciar", "**Passaporte: **"..Passport.."\n**Anunciou: **"..Keyboard[1], 10357504)
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONSOLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("console",function(source,Message,History)
	if source == 0 then
		TriggerClientEvent("chat:ClientMessage",-1,"Governador",History:sub(9))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICKALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kickall",function(source)
	if source ~= 0 then
		local Passport = vRP.Passport(source)
		if not vRP.HasGroup(Passport,"Admin", 1) then
			return
		end
	end

	local List = vRP.Players()
	for _,Sources in pairs(List) do
		vRP.Kick(Sources,"Desconectado, a cidade reiniciou.")
		Wait(100)
	end

	TriggerEvent("SaveServer",false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("save",function(source)
	if source ~= 0 then
		local Passport = vRP.Passport(source)
		if not vRP.HasGroup(Passport,"Admin", 1) then
			return
		end
	end

	TriggerEvent("SaveServer",false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SALVAR AUTOMATICO
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		TriggerEvent("SaveServer",false)
		Wait(5*60000)
	end
end)

-- Tempestade
RegisterCommand("tempestade",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 2) and vRP.HasService(Passport,"Admin") then
			TriggerClientEvent("Notify",-1,"tempestade","Temporal se aproxima em 5 minutos, se abriguem!",20000)
			GlobalState["Weather"] = "clearing"
			Wait(2*60*1000)
			TriggerClientEvent("Notify",-1,"tempestade","Temporal se aproxima em 3 minutos, se abriguem!",20000)
			GlobalState["Weather"] = "rain"
			Wait(2*60*1000)
			TriggerClientEvent("Notify",-1,"tempestade","Temporal se aproxima em menos de 1 minuto, se abriguem!",20000)
			GlobalState["Weather"] = "thunder"
			Wait(1*60*1000)


			local List = vRP.Players()
			for _,Sources in pairs(List) do
				vRP.Kick(Sources,"Você foi atingido pela tempestade.")
				Wait(1000)
			end
			TriggerEvent("SaveServer",false)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("itemall",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"OwnerInvoke",1) then
			local List = vRP.Players()
			for OtherPlayer,_ in pairs(List) do
				async(function()
					vRP.GenerateItem(OtherPlayer,Message[1],Message[2],true)
				end)
			end

			TriggerClientEvent("Notify",source,"verde","Envio concluído.",10000)
			vRP.SendWebhook(webhookitemall, "LOGs Itemall", "**Passaporte: **"..Passport.."\n**Deu a todos jogadores: **"..Message[1].."x"..Message[2], 10357504)
				
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACECOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local Checkpoint = 0
function Creative.raceCoords(vehCoords,leftCoords,rightCoords)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		Checkpoint = Checkpoint + 1

		vRP.Archive("races.txt","["..Checkpoint.."] = {")

		vRP.Archive("races.txt","{ "..mathLength(vehCoords["x"])..","..mathLength(vehCoords["y"])..","..mathLength(vehCoords["z"]).." },")
		vRP.Archive("races.txt","{ "..mathLength(leftCoords["x"])..","..mathLength(leftCoords["y"])..","..mathLength(leftCoords["z"]).." },")
		vRP.Archive("races.txt","{ "..mathLength(rightCoords["x"])..","..mathLength(rightCoords["y"])..","..mathLength(rightCoords["z"]).." }")

		vRP.Archive("races.txt","},")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
local Spectate = {}
RegisterCommand("spec",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 3) and vRP.HasService(Passport,"Admin") then
			if Spectate[Passport] then
				local Ped = GetPlayerPed(Spectate[Passport])
				if DoesEntityExist(Ped) then
					SetEntityDistanceCullingRadius(Ped,0.0)
				end

				TriggerClientEvent("admin:resetSpectate",source)
				Spectate[Passport] = nil
			else
				local nsource = vRP.Source(Message[1])
				if nsource then
					local Ped = GetPlayerPed(nsource)
					if DoesEntityExist(Ped) then
						SetEntityDistanceCullingRadius(Ped,999999999.0)
						Wait(1000)
						TriggerClientEvent("admin:initSpectate",source,nsource)
						Spectate[Passport] = nsource
						vRP.SendWebhook(webhookspectate, "LOGs Spectate", "**Passaporte: **"..Passport.."\n**Espionou: **"..Message[1], 10357504)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Spectate[Passport] then
		Spectate[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- /empresas
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand('empresas',function(source)
-- 	local Passport = vRP.Passport(source) 
--     local onlinePlayers = GetNumPlayerIndices()
--     local Service,paramedic = vRP.NumPermission("Paramedic")
--     local Service,mechanic = vRP.NumPermission("Mechanic")
--     local Service,mechanic68 = vRP.NumPermission("Mechanic68") 
-- 	local Service,digital = vRP.NumPermission("Ifrut") 
-- 	local Service,pawnshop = vRP.NumPermission("Pawnshop") 
-- 	local Service,Bennys = vRP.NumPermission("Bennys") 
-- 	-- local Service,LSCustoms = vRP.NumPermission("LSCustoms") 
-- 	-- local Service,Hornys = vRP.NumPermission("Hornys") 
-- 	local Service,Uwucoffee = vRP.NumPermission("Uwucoffee") 
-- 	local Service,Mcdonalds = vRP.NumPermission("Mcdonalds") 

-- 	if digital >= 1 then
--     TriggerClientEvent("Notify",source,"verde","<bold><b>Ifrut</b>: <b>ABERTA!</bold>",9000)
-- 	end
-- 	if pawnshop >= 1 then
-- 		TriggerClientEvent("Notify",source,"verde","<bold><b>PawnShop</b>: <b>ABERTA!</bold>",9000)
-- 	end
-- 	if mechanic >= 1 then
-- 		TriggerClientEvent("Notify",source,"verde","<bold><b>Autocare</b>: <b>ABERTA!</bold>",9000)
-- 	end
-- 	if mechanic68 >= 1 then
-- 		TriggerClientEvent("Notify",source,"verde","<bold><b>68 Harmony Repais</b>: <b>ABERTA!</bold>",9000)
-- 	end
-- 	if Bennys >= 1 then
-- 		TriggerClientEvent("Notify",source,"verde","<bold><b>Bennys</b>: <b>ABERTA!</bold>",9000)
-- 	end
-- 	-- if LSCustoms >= 1 then
-- 	-- 	TriggerClientEvent("Notify",source,"verde","<bold><b>LSCustoms</b>: <b>ABERTA!</bold>",9000)
-- 	-- end
-- 	-- if Hornys >= 1 then
-- 	-- 	TriggerClientEvent("Notify",source,"verde","<bold><b>Hornys</b>: <b>ABERTO!</bold>",9000)
-- 	-- end
-- 	if Uwucoffee >= 1 then
-- 		TriggerClientEvent("Notify",source,"verde","<bold><b>Uwucoffee</b>: <b>ABERTO!</bold>",9000)
-- 	end
-- 	if Mcdonalds >= 1 then
-- 		TriggerClientEvent("Notify",source,"verde","<bold><b>Mcdonalds</b>: <b>ABERTO!</bold>",9000)
-- 	end

-- 	if digital < 1 then
--     TriggerClientEvent("Notify",source,"vermelho","<bold><b>Ifrut</b>: <b>FECHADA!</bold>",9000)
-- 	end
-- 	if pawnshop < 1 then
-- 		TriggerClientEvent("Notify",source,"vermelho","<bold><b>PawnShop</b>: <b>FECHADA!</bold>",9000)
-- 	end
-- 	if mechanic < 1 then
-- 		TriggerClientEvent("Notify",source,"vermelho","<bold><b>Autocare</b>: <b>FECHADA!</bold>",9000)
-- 	end
-- 	if mechanic68 < 1 then
-- 		TriggerClientEvent("Notify",source,"vermelho","<bold><b>68 Harmony Repais</b>: <b>FECHADA!</bold>",9000)
-- 	end
-- 	if Bennys < 1 then
-- 		TriggerClientEvent("Notify",source,"vermelho","<bold><b>Bennys</b>: <b>FECHADA!</bold>",9000)
-- 	end
-- 	-- if LSCustoms < 1 then
-- 	-- 	TriggerClientEvent("Notify",source,"vermelho","<bold><b>LSCustoms</b>: <b>FECHADA!</bold>",9000)
-- 	-- end
-- 	-- if Hornys < 1 then
-- 	-- 	TriggerClientEvent("Notify",source,"vermelho","<bold><b>Hornys</b>: <b>FECHADO!</bold>",9000)
-- 	-- end
-- 	if Uwucoffee < 1 then
-- 		TriggerClientEvent("Notify",source,"vermelho","<bold><b>Uwucoffee</b>: <b>FECHADO!</bold>",9000)
-- 	end
-- 	if Mcdonalds < 1 then
-- 		TriggerClientEvent("Notify",source,"vermelho","<bold><b>Mcdonalds</b>: <b>FECHADO!</bold>",9000)
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- /LEGAIS
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('status',function(source)
	local Passport = vRP.Passport(source) 
	if Passport then
		--if vRP.HasGroup(Passport,"Admin", 3) and vRP.HasService(Passport,"Admin") then
   
		local Service,police = vRP.NumPermission("PoliciaMilitar")
		local Service,paramedic = vRP.NumPermission("Paramedic")
		local Service,mechanic = vRP.NumPermission("Mechanic")
		local Service,ifrut = vRP.NumPermission("Ifrut") 
		local Service,pawnshop = vRP.NumPermission("Pawnshop") 

		TriggerClientEvent("Notify",source,"azul","<br>Policiais</b>: <b>"..police.."<br>Paramédicos</b>: <b>"
		..paramedic.."<br>Mecânicos</b>: <b>"..mechanic.."<br>Ifrut</b> : <b>"..ifrut.."<br>PawnShop</b>: <b>"..pawnshop.."</b></bold>",9000)
		--end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- /restaurantes
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('restaurantes',function(source)
	local Passport = vRP.Passport(source) 
	if Passport then
		if vRP.HasGroup(Passport,"Admin", 3) and vRP.HasService(Passport,"Admin") then
    local onlinePlayers = GetNumPlayerIndices()
    local Service,Uwucoffee = vRP.NumPermission("Uwucoffee")
    local Service,Mcdonalds = vRP.NumPermission("Mcdonalds")
    local Service,Hornys = vRP.NumPermission("Hornys")
    TriggerClientEvent("Notify",source,"azul","<bold><b>Jogadores online (Restaurantes)</b>: <b>"..Uwucoffee+Mcdonalds+Hornys.."<br>Hornys</b>: <b>"..Hornys.."<br>Mcdonalds</b>: <b>"..Mcdonalds.."<br>Uwucoffee</b>: <b>"
	..Uwucoffee.."</b></bold>.",9000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- /SUL
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand('sul',function(source)
-- 	local Passport = vRP.Passport(source) 
-- 	if Passport then
-- 		if vRP.HasGroup(Passport,"Admin", 3) and vRP.HasService(Passport,"Admin") then
--     local Passport = vRP.Passport(source) 
--     local onlinePlayers = GetNumPlayerIndices()
--     local Service,families = vRP.NumPermission("Families")
--     local Service,vagos = vRP.NumPermission("Vagos")
--     local Service,bloods = vRP.NumPermission("Bloods")
--     local Service,Cripz = vRP.NumPermission("Cripz") 
-- 	local Service,ballas = vRP.NumPermission("Ballas") 
-- 	local Service,mafia = vRP.NumPermission("Mafia") 
-- 	local Service,rogers = vRP.NumPermission("Rogers") 
-- 	local Service,tequila = vRP.NumPermission("Tequila") 
--     TriggerClientEvent("Notify",source,"azul","<bold><b>Jogadores Online (Sul)</b>: <b>"..families+vagos+bloods+Cripz+ballas+mafia+rogers+tequila.."<br>Families</b>: <b>"..families.."<br>Vagos</b>: <b>"..vagos.."<br>Bloods</b>: <b>"..bloods..
-- 	"<br>Cripz</b>: <b>"..Cripz.."<br>Ballas</b>: <b>"..ballas.."<br>Mafia</b>: <b>"..mafia.."<br>Rogers</b>: <b>"..rogers.."<br>Tequila</b>: <b>"..tequila.."</b></bold>.",9000)
-- 		end
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- /NORTE
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand('norte',function(source)
-- 	local Passport = vRP.Passport(source) 
-- 	if Passport then
-- 		if vRP.HasGroup(Passport,"Admin", 3) and vRP.HasService(Passport,"Admin") then
--     local Passport = vRP.Passport(source) 
--     local onlinePlayers = GetNumPlayerIndices()
--     local Service,vinhedo = vRP.NumPermission("Vinhedo")
--     local Service,cantagalo = vRP.NumPermission("Cantagalo")
--     local Service,trem = vRP.NumPermission("Trem")
--     local Service,renegados = vRP.NumPermission("Renegados") 
-- 	local Service,redencao = vRP.NumPermission("Redencao") 
-- 	local Service,yellow = vRP.NumPermission("Yellow") 
-- 	local Service,resistencia = vRP.NumPermission("Resistencia") 
-- 	local Service,esquadrao = vRP.NumPermission("Esquadrao") 
--     TriggerClientEvent("Notify",source,"azul","<bold><b>Jogadores online (Norte)</b>: <b>"..vinhedo+cantagalo+trem+renegados+redencao+yellow+resistencia+esquadrao.."<br>Vinhedo</b>: <b>"..vinhedo.."<br>Cantagalo</b>: <b>"..cantagalo.."<br>Trem</b>: <b>"..trem..
-- 	"<br>Renegados</b>: <b>"..renegados.."<br>Redencao</b>: <b>"..redencao.."<br>Yellow</b>: <b>"..yellow.."<br>Resistencia</b>: <b>"..resistencia.."<br>Esquadrao</b>: <b>"..esquadrao.."</b></bold>.",9000)
-- 		end
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('debug',function(source, args, rawCommand)
	local user_id = vRP.Passport(source)
	if user_id ~= nil then
		if vRP.hasPermission(user_id,"Admin", 1) then
			TriggerClientEvent("ToggleDebug",source)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- FOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("fome", function(source, args)
	local user_id = vRP.Passport(source)
	if vRP.HasGroup(user_id,"Admin",1) and args[1] then
		local target_id = tonumber(args[1])
		-- vRP.UpgradeThirst(target_id,100)
		-- vRP.UpgradeHunger(target_id,100)
		-- vRP.DowngradeStress(target_id,100)
		vRP.DowngradeThirst(target_id,90)
		vRP.DowngradeHunger(target_id,90)
		vRP.UpgradeStress(target_id,90)
		TriggerClientEvent("Notify",source,"verde","Fome, sede e stress adicionados no passaporte: <b>"..target_id.."</b>.",10000)
	end
end)
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- Quantidade de players e ids Online.
-- -----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("pon",function(source,args,rawCommand)
    local user_id = vRP.Passport(source)
    if vRP.HasGroup(user_id, "Admin",2) then
        local users = vRP.Players()
        local players = ""
        local quantidade = 0
        for k,v in pairs(users) do
            if GetNumPlayerIndices() then
                players = players..", "
            end
            players = players..k
            quantidade = quantidade + 1
        end
		TriggerClientEvent("Notify",source,"amarelo","TOTAL ONLINE : <b>"..quantidade.."</b><br>ID's ONLINE : <b>"..players.."</b>",5000)
    end
end)


-------------------------------------------------------------------------------------------------------------------------------------------
-- ADDCAR
-------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("addcar", function(source, args)
    local Passport = vRP.Passport(source)
    local carro, id, tempo = args[1], args[2], args[3]

    if not vRP.HasGroup(Passport, "OwnerInvoke", 1) then return end

	if not carro or not id then
		TriggerClientEvent("Notify", source, "vermelho","Uso do comando correto: /addcar [carro] [id] [tempo] | Deixar sem tempo para ser permanente", 5000)
		return
	end
	if not VehicleName(carro) then
		TriggerClientEvent("Notify", source, "vermelho","Carro inválido", 5000)
		return
	end
	
	if tempo then
		vRP.Query("vehicles/customRentalVehicles",{ Passport = id, vehicle = carro, plate = vRP.GeneratePlate(), work = "false", time = tempo * 60 * 60 * 24 })
		vRP.SendWebhook(webhookaddcar, "LOGs addcar", "**Passaporte: **"..Passport.."\n**Deu o carro: **"..carro.."\n**Ao ID: **"..id.."\n**Por: **"..tempo.."dias", 10357504)
	else
		vRP.Query("vehicles/addVehicles",{ Passport = id, vehicle = carro, plate = vRP.GeneratePlate(), work = "false" })
		vRP.SendWebhook(webhookaddcar, "LOGs addcar", "**Passaporte: **"..Passport.."\n**Deu o carro: **"..carro.."\n**Ao ID: **"..id.."\n**Por: **Tempo Indefinido", 10357504)
	end

	TriggerClientEvent("Notify", source, "verde","Carro adicionado com sucesso", 5000)
end)

CreateThread(function()
	vRP.Archive('playerControl.lua','Data/Horário: '..os.date('%x'..' %X'))
	vRP.Archive('playerControl.lua','Servidor Reiniciado\n\n')

	while true do
		Wait(60*1000*10)
		vRP.Archive('playerControl.lua','Data/Horário: '..os.date('%x'..' %X'))
		vRP.Archive('playerControl.lua','Players Online: '..GetNumPlayerIndices()..'\n')
	end
end)

Creative.hasPerm = function(perm)
	local src = source
	local Passport = vRP.Passport(src)
	return vRP.HasPermission(Passport,perm)
end

Creative.getVehType = function(netVeh)
	return GetVehicleType(NetworkGetEntityFromNetworkId(netVeh))
end

Creative.globalLeaveVehicle = function(netPed,netVeh)
	TaskLeaveVehicle(NetworkGetEntityFromNetworkId(netPed),NetworkGetEntityFromNetworkId(netVeh),16)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDREM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("remcar",function(source,Message)
	local source = source
	local Passport = vRP.Passport(source)
	if vRP.HasGroup(Passport,"OwnerInvoke",1 or 2 or 3 or 4 or 5) then
		if Passport and Message[1] and Message[2] then
			vRP.Query("vehicles/removeVehicles",{ Passport = parseInt(Message[1]), vehicle = Message[2]})
			TriggerClientEvent("Notify",source,"verde","Retirado o veiculo <b>"..Message[2].."</b> da garagem de ID <b>"..Message[1].."</b>.",10000)
			TriggerEvent("Discord","remcar","**Passporte Removeu: **"..Passport.." \n[Do Id:]: "..Message[1].."\n[Veiculo:]: "..Message[2]..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------------
-- MAIS MOCHILA
-------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('+mochila',function(src,r,c)
	local charId,otherId,quant
	charId = vRP.Passport(src)
	if not vRP.HasPermission(charId,'Admin',1) then return end

	if not r[1] and not r[2] then
		TriggerClientEvent('Notify',src,'amarelo','Comando: /+mochila [Id] [Quantidade]',7000)
		return
	end

	otherId = tonumber(r[1])
	if not otherId or otherId == 0 then
		TriggerClientEvent('Notify',src,'vermelho','Id inválido',7000)
		return
	end

	quant = tonumber(r[2])
	if not quant or quant == 0 then
		TriggerClientEvent('Notify',src,'vermelho','Quantidade inválida',7000)
		return
	end

	vRP.SetWeight(otherId,quant)
	TriggerClientEvent('Notify',src,'verde','Adicionado '..quant..' de mochila para o player: '..otherId,7000)
end)
-------------------------------------------------------------------------------------------------------------------------------------------
-- MENAS MOCHILA
-------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('-mochila',function(src,r,c)
	local charId,otherId,quant
	charId = vRP.Passport(src)
	if not vRP.HasPermission(charId,'Admin',1) then return end

	if not r[1] and not r[2] then
		TriggerClientEvent('Notify',src,'amarelo','Comando: /-mochila [Id] [Quantidade]',7000)
		return
	end

	otherId = tonumber(r[1])
	if not otherId or otherId == 0 then
		TriggerClientEvent('Notify',src,'vermelho','Id inválido',7000)
		return
	end
	
	quant = tonumber(r[2])
	if not quant or quant == 0 then
		TriggerClientEvent('Notify',src,'vermelho','Quantidade inválida',7000)
		return
	end

	vRP.SetWeight(otherId,quant*-1)
	TriggerClientEvent('Notify',src,'verde','Removido '..quant..' de mochila para o player: '..otherId,7000)
end)
-------------------------------------------------------------------------------------------------------------------------------------------
-- DAR DANO
-------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('dano',function(src,r,c)
	local charId = vRP.Passport(src)

	if not vRP.HasPermission(charId,'Admin',2) then return end

	if not r[1] or not r[2] then
		TriggerClientEvent('Notify',src,'amarelo','Comando: /dano [Id] [Dano]', 5000)
		return
	end

	local targetId = tonumber(r[1])
	if not targetId or targetId <= 0 or tostring(dmg):find('%.') or not vRP.Source(targetId) then
		TriggerClientEvent('Notify',src,'vermelho','Id inválido ou Offline', 5000)
		return
	end

	local dmg = tonumber(r[2])
	if not dmg or dmg <= 0 or tostring(dmg):find('%.') then
		TriggerClientEvent('Notify',src,'vermelho','Número de dano inválido', 5000)
		return
	end

	local targetSrc = vRP.Source(targetId)
	print(targetId)
	print(targetSrc)
	vRPC.UpgradeHealth(targetSrc,dmg*-1)	
	TriggerClientEvent('Notify',src,'verde','Dano causado', 5000)
end)
-------------------------------------------------------------------------------------------------------------------------------------------
-- MANDAR DM
-------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('dm',function(src,r,c)
	local charId = vRP.Passport(src)

	if not vRP.HasPermission(charId,'Admin',2) then return end

	if not r[1] or not r[2] then
		TriggerClientEvent('Notify',src,'amarelo','Comando: /dano [Id] [mensagem]', 20000)
		return
	end

	local targetId = tonumber(r[1])
	if not targetId or targetId <= 0 or tostring(dmg):find('%.') or not vRP.Source(targetId) then
		TriggerClientEvent('Notify',src,'vermelho','Id inválido ou Offline', 5000)
		return
	end
	
	local message = c:sub(('dm'):len()+2) 
	message = message:sub(tostring(r[1]):len()+2)

	local targetSrc = vRP.Source(targetId)
	TriggerClientEvent('Notify',src,'verde','Mensagem enviada', 5000)
	TriggerClientEvent('Notify',targetSrc,'amarelo',message, 5000)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("visto",function(Source,Message)
	local Passport = vRP.Passport(Source)
	if Passport then
		local Mode = tostring(Message[1])
		local TargetId = parseInt(Message[2])
		if Mode and TargetId then
			if vRP.HasGroup(Passport,"PoliciaMilitar",1) or vRP.HasGroup(Passport,"Core",1) or vRP.HasGroup(Passport,"PRF",1) or vRP.HasGroup(Passport,"PCivil",1) or (vRP.HasGroup(Passport,"Admin", 1) and vRP.HasService(Passport,"Admin")) then
				if Mode == "add" then
					vRP.AddVisa(TargetId)
					TriggerClientEvent("Notify",Source,"azul","Adicionou visto com sucesso",5000)
				elseif Mode == "rem" then
					TriggerClientEvent("Notify",Source,"azul","Removeu visto com sucesso",5000)
					vRP.RemVisa(TargetId)
				end
				vRP.SendWebhook(webhookvisto, "LOGs Itemall", "**Passaporte: **"..Passport.."\n**Deu a todos jogadores: **"..Message[1].."x"..Message[2], 10357504)	
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- WL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("wl",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		local OtherPassport = parseInt(Message[1])
		if vRP.HasGroup(Passport,"Admin",3) and OtherPassport > 0 then
			TriggerClientEvent("Notify",source,"verde","ID: <b>"..Message[1].."</b> Liberado <b>",5000)
			vRP.Query("accounts/updateWhitelist",{ id = Message[1], whitelist = 1 })
			TriggerEvent("Discord","wl","**Liberou Whitelisted**\n\n**Passaporte:** "..Passport.."\n**Para:** "..Message[1],3553599)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNWL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("unwl",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",3) then
			TriggerClientEvent("Notify",source,"verde","ID: <b>"..Message[1].."</b> WL REMOVIDA <b>",5000)
			vRP.Query("accounts/updateWhitelist",{ id = Message[1], whitelist = 0 })
			TriggerEvent("Discord","unwl","**Removeu Whitelisted**\n\n**Passaporte:** "..Passport.."\n**Para:** "..Message[1],3553599)	
		end
	end
end)

----------------------------------------------------------------------------------------
-- GUARDINHA --- Server
----------------------------------------------------------------------------------------
RegisterCommand("guardinha", function(source)
    local source = source
    local Passport = vRP.Passport(source)

    if Passport then
        if vRP.HasGroup(Passport, "Admin", 1) then
            local Players = vRPC.ClosestPeds(source, 999999)
            for _, v in pairs(Players) do
                TriggerClientEvent("Notify", -1, "amarelo", "Os carros vazios serão deletados em 30 segundos!", 30000)

                Citizen.SetTimeout(31000, function()
                    TriggerClientEvent("Notify", -1, "verde", "Todos os carros vazios foram recuperados!", 20000)
                end)
            end

            Citizen.Wait(30000)
            TriggerClientEvent("admin:guardinha", source)
        end
    end
end)




-- local Service, Amount = vRP.NumPermission("Paramedic")
-- print(json.encode(Service,{indent=true}),Amount)

-- local Groups = vRP.Groups()
-- for Permission in pairs(Groups) do
-- 	local Amount = 0
--     local Tables = {}

--     if Groups[Permission] and Groups[Permission]["Parent"] then
--         for Parent in pairs(Groups[Permission]["Parent"]) do
--             if Groups[Parent] and Groups[Parent]["Service"] then
--                 for Passport,Source in pairs(Groups[Parent]["Service"]) do
-- 					print(Permission,Passport)
--                     -- if Source and Characters[Source] and not Tables[Passport] then
--                     --     Tables[Passport] = Source
--                     --     Amount = Amount + 1
--                     -- end
--                 end
--             end
--         end
--     end
-- end