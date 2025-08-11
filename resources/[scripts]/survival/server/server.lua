local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

local survival = {}
Tunnel.bindInterface("survival", survival)

local Callbacks = {}

RegisterNetEvent("callback:trigger", function(name, requestId, args)
    local src = source
    if Callbacks[name] then
        Callbacks[name](src, function(result)
            TriggerClientEvent("callback:response", src, requestId, result)
        end, table.unpack(args or {}))
    else
       -- print("[SURVIVAL] Callback '"..name.."' não encontrado.")
        TriggerClientEvent("callback:response", src, requestId, nil)
    end
end)

Callbacks["survival:GetVipGroup"] = function(source, cb)
    local user_id = vRP.Passport(source)
    if user_id then
        if vRP.HasGroup(user_id, "vipabsolutultimate") then
            cb("vipabsolutultimate")
        elseif vRP.HasGroup(user_id, "vipehp") then
            cb("vipehp")
        elseif vRP.HasGroup(user_id, "vipadvanced") then
            cb("vipadvanced")
        elseif vRP.HasGroup(user_id, "vipdiamond") then
            cb("vipdiamond")
        elseif vRP.HasGroup(user_id, "vipplatium") then
            cb("vipplatium")
        elseif vRP.HasGroup(user_id, "vipgold") then
            cb("vipgold")
        else
            cb("none")
        end
    else
        cb("none")
    end
end

