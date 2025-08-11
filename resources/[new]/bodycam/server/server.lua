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
cRP = {}
Tunnel.bindInterface("bodycam",cRP)
vCLIENT = Tunnel.getInterface("bodycam")

local camPlayers = {}

RegisterNetEvent('alc:camstatus')
AddEventHandler('alc:camstatus', function(ison)
    local src = source
	if camPlayers[source] == nil then
        camPlayers[source] = true 	
        TriggerClientEvent('Notify',src, "verde", "Câmera corporal ligada", 5000)
        TriggerClientEvent("bcam:UpdateWatch",-1, camPlayers)
    else
        if ison ~= nil then
            camPlayers[source] = ison
        else
            camPlayers[source] = not camPlayers[source]
        end
        if camPlayers[source] then
            TriggerClientEvent('Notify',src, "verde", "Câmera corporal ligada", 5000)
            TriggerClientEvent("bcam:UpdateWatch",-1,  camPlayers)
        else
            TriggerClientEvent('Notify',src, "vermelho", "Câmera corporal desligada", 5000)
            TriggerClientEvent("bcam:UpdateWatch",-1,  camPlayers)
        end
    end
end)

function cRP.hasPolice()
    local source = source
    local user_id = vRP.Passport(source)
    return vRP.HasGroup(user_id,"Police")
end

function cRP.getPlayer(arg)
    local tped = GetPlayerPed(arg)
    return {targetped = tped,coords = GetEntityCoords(tped), pednid = NetworkGetNetworkIdFromEntity(tped) , isCam = camPlayers[arg]}
end

function cRP.getPopos(arg)
    local popos = {}
    local source = source
    local policeResult = vRP.NumPermission(arg)
    for k, source in pairs(policeResult) do
        local user_id = vRP.Passport(source)
        local userIdentity  = vRP.Identity (user_id)
        if userIdentity  then
            popos[#popos+1] = {
                name = userIdentity ["name"],
                fname = userIdentity ["name2"],
                lname = userIdentity ["name"].." "..userIdentity ["name2"],
                source = source,
                label = 'Departamento Central',
                job = arg,
                department = arg,
                rank = "-",
                camon = camPlayers[source],
            }
        end
    end

    return popos
end

function cRP.getPlayerInfos()
    local source = source
    local user_id = vRP.Passport(source)
    local userIdentity  = vRP.Identity (user_id)
    if userIdentity  then
        local infos = {
            name = userIdentity ["name"],
            fname = userIdentity ["name2"],
            lname = userIdentity ["name"].." "..userIdentity ["name2"],
            source = source,
            label = 'Departamento Central',
            job = "Police",
            department = "Police",
            rank = "-",
            camon = true,
        }
        return infos
    end
end

RegisterCommand("pm", function(source, args)
    local user_id = vRP.Passport(source)
    if not user_id then return end
    if vRP.HasGroup(user_id, "Police") then
        if args[1] then
            local target_id = tonumber(args[1])
            local target_source = vRP.Source (target_id)
            if target_source then
                TriggerClientEvent("screenshot", target_source)
            end
        end
    end
end)