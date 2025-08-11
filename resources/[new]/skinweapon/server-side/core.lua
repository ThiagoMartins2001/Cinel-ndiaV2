Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")
Tools = module("vrp","lib/Tools")
Resource = GetCurrentResourceName()
vRP = Proxy.getInterface("vRP")
RegisterTunnel = {}
Tunnel.bindInterface(Resource, RegisterTunnel)
vTunnel = Tunnel.getInterface(Resource)
sand = Tunnel.getInterface(Resource)


vRP.Prepare('skinweapon/Create', "INSERT IGNORE INTO skins(component, stock) VALUES (@component, @stock)")

vRP.Prepare('skinweapon/getStock', "SELECT * FROM skins")
vRP.Prepare('skinweapon/getStockSpecific', "SELECT * FROM skins WHERE component = @component")
vRP.Prepare("skinweapon/setSkin","INSERT INTO skins_users(user_id, skins) VALUES(@user_id, @skins)")
vRP.Prepare('skinweapon/updateSkin', "UPDATE skins_users SET skins = @skins WHERE user_id = @user_id")
vRP.Prepare('skinweapon/updateSkinEquip', "UPDATE skins_users SET equipadas = @equipadas WHERE user_id = @user_id")
vRP.Prepare('skinweapon/getPlayerSkins', "SELECT * FROM skins_users WHERE user_id = @user_id")
vRP.Prepare('skinweapon/updateSkinStock', "UPDATE skins SET stock = @stock WHERE component = @component")

EquipWeapons = {}
GlobalState["Pistol"] = {}
GlobalState["Rifle"] = {}

CreateThread(function()
  if createAuto then
    for k,v in pairs(skinglobal) do
      vRP.Query('skinweapon/Create', { component = k, stock = v[6]})
    end
   -- exports["oxmysql"]:executeSync([[INSERT IGNORE INTO sjr_orgs(org) VALUES(?)]], { orgName })
  end
end)

RegisterCommand('skins', function(source,args)
  local source = source
  local user_id = vRP.Passport(source)
  if user_id then
    if perm and not vRP.HasPermission(user_id, perm) then return end
	  TriggerClientEvent('skinweapon:OpenClient', source)
  end
end)

RegisterServerEvent("skinweapon:check")
AddEventHandler("skinweapon:check",function(user_id,source)
  if user_id then
    local query = vRP.Query('skinweapon/getPlayerSkins', { user_id = user_id })
    if #query > 0 then
      local skins = json.decode(query[1].equipadas) or {}
      EquipWeapons[user_id] = {}
      for k,v in pairs(skins) do
        EquipWeapons[user_id][k] = v
      end
    end
  end
end)

RegisterServerEvent("skinweapon:check")
AddEventHandler("skinweapon:check",function()
  local source = source
  local user_id = vRP.Passport(source)
	if source and user_id then
    Wait(2000)
    local weapons = sand.getWeapons(source)
    for k,v in pairs(weapons) do
      -- print(json.encode(weapons))
      -- print(EquipWeapons[user_id][k])
      if EquipWeapons[user_id][k] then
        GiveWeaponComponentToPed(GetPlayerPed(source),k,EquipWeapons[user_id][k])
      end
    end
  end
end)

AddEventHandler("vRP:playerLeave",function(user_id,source)
  if user_id then
    if EquipWeapons[user_id] then
      vRP.Query('skinweapon/updateSkinEquip', { user_id = user_id, equipadas = json.encode(EquipWeapons[user_id])})
      EquipWeapons[user_id] = nil
    end
  end
end)

RegisterTunnel.RequestSkins = function()
  local pistol = {}
  local rifle = {}
  local query = vRP.Query('skinweapon/getStock')
  if not (#query > 0) then if prints then print("Você não gerou o arquivo de stock das armas") end return end
  for k,v in pairs(query) do
    if skinglobal[v.component][4] == "Rifle" then
      rifle[#rifle+1] = { name = skinglobal[v.component][1], type = skinglobal[v.component][4], price = skinglobal[v.component][2], weapon = skinglobal[v.component][3], component = v.component, equip = v.component, rarity = skinglobal[v.component][5], stock = v.stock}
    else
      pistol[#pistol+1] = { name = skinglobal[v.component][1], type = skinglobal[v.component][4], price = skinglobal[v.component][2], weapon = skinglobal[v.component][3], component = v.component, equip = v.component, rarity = skinglobal[v.component][5], stock = v.stock}
    end
  end
  GlobalState["Rifle"] = rifle
  GlobalState["Pistol"] = pistol
end

RegisterTunnel.RequestEquip = function(data)
  local source = source
  local user_id = vRP.Passport(source)
  if user_id then
    local weapons = sand.getWeapons(source)
    if weapons[skinglobal[data][3]] then
      if EquipWeapons[user_id][skinglobal[data][3]] then
        RemoveWeaponComponentFromPed(GetPlayerPed(source),skinglobal[data][3],data)
      end
      EquipWeapons[user_id][skinglobal[data][3]] = data
      GiveWeaponComponentToPed(GetPlayerPed(source),skinglobal[data][3],data)
      TriggerClientEvent("Notify",source,"verde","Skin aplicada com sucesso.")
      TriggerClientEvent('skinweapon:CloseNUI', source) -- Adiciona esta linha para fechar a NUI
    else
      TriggerClientEvent("Notify",source,"vermelho","Você não possui essa arma equipada para usar o componente.")
    end
  end
end

RegisterTunnel.RequestBuy = function(data)
  local source = source
  local user_id = vRP.Passport(source)
  if user_id then
    if skinglobal[data] then
      local query = vRP.Query('skinweapon/getStockSpecific', { component = data })
      if #query > 0 then
        if query[1].stock >= 1 then
          local query2 = vRP.Query('skinweapon/getPlayerSkins', { user_id = user_id })
          local skins = {}
          if #query2 > 0 then skins = json.decode(query2[1].skins) end
          if not skins[query[1].component] then
            if vRP.PaymentGems(user_id,skinglobal[query[1].component][2]) then
              if #query2 > 0 then
                skins[query[1].component] = true
                vRP.Query('skinweapon/updateSkinStock', { component = query[1].component, stock = query[1].stock-1 })
                vRP.Query('skinweapon/updateSkin', { user_id = user_id, skins = json.encode(skins)})
                RegisterTunnel.RequestSkins()
                TriggerClientEvent("Notify",source,"verde","Você comprou o item com sucesso.","verde",5000)
              else
                skins[query[1].component] = true
                vRP.Query('skinweapon/updateSkinStock', { component = query[1].component, stock = query[1].stock-1 })
                vRP.Query('skinweapon/setSkin', { user_id = user_id, skins = json.encode(skins)})
                RegisterTunnel.RequestSkins()
                TriggerClientEvent("Notify",source,"verde","Você comprou o item com sucesso.","verde",5000)
              end
            else
              TriggerClientEvent("Notify",source,"azul","Você não possui dinheiro suficiente para isso.","amarelo",5000)
            end
          else
            TriggerClientEvent("Notify",source,"azul","Você já possui esta skin.","amarelo",5000)
          end
        else
          TriggerClientEvent("Notify",source,"azul","Este item está com o estoque esgotado.","amarelo",5000)
        end
      else
        if prints then print("componente não encontrado no banco de dados ID:"..user_id) end
      end
    else
      if prints then print("componente não encontrado no config ID:"..user_id) end
    end
  end
end

RegisterTunnel.RequestTransf = function(data)
  local source = source
  local user_id = vRP.Passport(source)
  local identity = vRP.Identities(user_id)
  if user_id then
    local query = vRP.Query('skinweapon/getPlayerSkins', { user_id = user_id })
    local skins = {}
    if #query > 0 then 
      skins = json.decode(query[1].skins)
    end
    if skins[data] then
      local nuser = vRP.prompt(source, 'Digite o id do player que você deseja enviar a skin', '')
      if nuser and nuser ~= '' then
        local nidentity = vRP.Identities(parseInt(nuser))
        local query2 = vRP.query('skinweapon/getPlayerSkins', { user_id = parseInt(nuser) })
        local skins2 = {}
        if #query2 > 0 then skins2 = json.decode(query2[1].skins) end
        if not skins2[data] then
          skins[data] = nil
          skins2[data] = true
          vRP.Query('skinweapon/updateSkin', { user_id = user_id, skins = json.encode(skins)})
          RemoveWeaponComponentFromPed(GetPlayerPed(source),skinglobal[data][3],data)
          EquipWeapons[user_id][skinglobal[data][3]] = nil
          TriggerClientEvent("Notify",source,"verde","Você enviou a skin com sucesso para o cidadao "..nidentity.name.." "..nidentity.name2.."!","verde",5000)
          if #query2 > 0 then
            vRP.Query('skinweapon/updateSkin', { user_id = parseInt(nuser), skins = json.encode(skins2)})
          else
            vRP.Query('skinweapon/setSkin', { user_id = parseInt(nuser), skins = json.encode(skins2)})
          end
          local nsource = vRP.Source(parseInt(nuser))
          if nsource then
            TriggerClientEvent("Notify",nsource,"verde","O cidadão "..identity.name.." "..identity.name2.." acabou de te enviar uma skin!","verde",5000)
          end
        else
          TriggerClientEvent("Notify",source,"azul","Este player já possui esta skin.","amarelo",5000)
        end
      else
        TriggerClientEvent("Notify",source,"azul","Usuario informado inexistente ou informado de forma errada.","amarelo",5000)
      end
    else
      if 'print' then print("componente não encontrado no id, possivel inject ID:"..user_id) end
    end
  end
end

RegisterTunnel.RequestEquip = function(data)
  local source = source
  local user_id = vRP.Passport(source)
  if user_id then
    local weapons = sand.getWeapons(source)
    if weapons[skinglobal[data][3]] then
      if EquipWeapons[user_id][skinglobal[data][3]] then
        RemoveWeaponComponentFromPed(GetPlayerPed(source),skinglobal[data][3],data)
      end
      EquipWeapons[user_id][skinglobal[data][3]] = data
      GiveWeaponComponentToPed(GetPlayerPed(source),skinglobal[data][3],data)
      TriggerClientEvent("Notify",source,"verde","Skin aplicada com sucesso.","Verde",5000)
      TriggerClientEvent('skinweapon:CloseNUI', source) -- Adiciona esta linha para fechar a NUI
    else
      TriggerClientEvent("Notify",source,"azul","Você não possui essa arma equipada para usar o componente.","amarelo",5000)
    end
  end
end

RegisterTunnel.RequestUnequip = function(data)
  local source = source
  local user_id = vRP.Passport(source)
  if user_id then
    local weapons = sand.getWeapons(source)
    if weapons[skinglobal[data][3]] then
      EquipWeapons[user_id][skinglobal[data][3]] = nil
      RemoveWeaponComponentFromPed(GetPlayerPed(source),skinglobal[data][3],data)
      TriggerClientEvent("Notify",source,"verde","Skin removida com sucesso.","Verde",5000)
    else
      TriggerClientEvent("Notify",source,"azul","Você não possui essa arma equipada para remover esse componente.","amarelo",5000)
    end
  end
end

RegisterTunnel.RequestPossuidas = function()
  local source = source
  local user_id = vRP.Passport(source)
  if user_id then
    if not EquipWeapons[user_id] then EquipWeapons[user_id] = {} end
    local query = vRP.Query('skinweapon/getPlayerSkins', { user_id = user_id })
    local weapons = {}
    if #query > 0 then
      local skins = json.decode(query[1].skins) or {}
      for k,v in pairs(skins) do
        weapons[#weapons+1] = { name = skinglobal[k][1], type = skinglobal[k][4], price = skinglobal[k][2], weapon = skinglobal[k][3], component = k, equip = (EquipWeapons[user_id][skinglobal[k][3]] == k and "Equipada" or "Desequipada"), rarity = skinglobal[k][5]}
      end
      return weapons
    end
  end
  return {}
end