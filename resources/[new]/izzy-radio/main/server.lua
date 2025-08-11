Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")
Tools = module("vrp","lib/Tools")
Resource = GetCurrentResourceName()
SERVER = IsDuplicityVersion()

if SERVER then
    vRP = Proxy.getInterface("vRP")
    vRPclient = Tunnel.getInterface("vRP")

    CreateTunnel = {}
    Tunnel.bindInterface(Resource, CreateTunnel)

    Execute = Tunnel.getInterface(Resource)
else
    vRP = Proxy.getInterface("vRP")

    CreateTunnel = {}
    Tunnel.bindInterface(Resource, CreateTunnel)

    Execute = Tunnel.getInterface(Resource)
end

vRP.Prepare('sjr/getChannels', "SELECT data FROM izzy_radio WHERE player = @player")
vRP.Prepare('sjr/createChannel', "INSERT INTO izzy_radio (player) VALUES (@player)")
vRP.Prepare('sjr/getChannelsPlayer', "SELECT data FROM izzy_radio WHERE player = @player")
vRP.Prepare('sjr/updateChannels', "UPDATE izzy_radio SET data = @data WHERE player = @player")
vRP.Prepare('sjr/getAllChannel', "SELECT data FROM izzy_radio")

local channels = {}

CreateTunnel.createChannel = function(data)
    local source = source
    if not channels[data.frequency] then
        channels[data.frequency] = {
            users = {
                [1] = {
                    id = source,
                    name = getName(source)
                }
            },
            password = data.password or nil,
            playerId = 1
        }
        TriggerClientEvent('izzy-radio:connect', source, data.frequency)
        return true
    else
        return false
    end
end

CreateTunnel.disconnect = function()
    local source = source
    for k,v in pairs(channels) do
        for a, src in pairs(v.users) do
            if source == src.id then
                channels[k]["users"][a] = nil
                updateMembers(source, channels[k]["users"])
                return true
            end
        end
    end
    return false
end

function resetConnection(source)
    for k,v in pairs(channels) do
        for a, src in pairs(v.users) do
            if source == src.id then
                channels[k]["users"][a] = nil
                updateMembers(source, channels[k]["users"])
                return true
            end
        end
    end
end

CreateTunnel.connect = function(data)
    local source = source
    
    resetConnection(source)

    if channels[data.frequency] then
        local info = channels[data.frequency]
        if info.password then
            return 'password'
        else
            channels[data.frequency]["users"][info.playerId+1] = {
                id = source,
                name = getName(source)
            }
            channels[data.frequency]["playerId"] = info.playerId+1
            TriggerClientEvent('izzy-radio:connect', source, data.frequency)
            updateMembers(source, channels[data.frequency]["users"])
            return true
        end
    else
        channels[data.frequency] = {
            users = {
                [1] = {
                    id = source,
                    name = getName(source)
                }
            },
            password = nil,
            playerId = 1
        }
        TriggerClientEvent('izzy-radio:connect', source, data.frequency)
        return 'new'
    end
end

CreateTunnel.password = function(data)
    local source = source
    if channels[data.frequency] then
        local info = channels[data.frequency]
        if info.password == data.password then
            channels[data.frequency]["users"][info.playerId+1] = {
                id = source,
                name = getName(source)
            }
            channels[data.frequency]["playerId"] = info.playerId+1
            TriggerClientEvent('izzy-radio:connect', source, data.frequency)
            updateMembers(source, channels[data.frequency]["users"])
            return true
        else
            return false
        end
    else
        return 'none'
    end
end

CreateTunnel.getChannels = function(data)
    local source = source
    local player = getPlayer(source)
    --local myInfo = MySQL.Sync.fetchAll("SELECT data FROM izzy_radio WHERE player = @player", {["@player"] =  player.identifier or player.PlayerData.citizenid})
    local myInfo = vRP.Query('sjr/getChannels', { player = player})

    if myInfo[1] then
        return json.decode(myInfo[1].data)
    else
        -- MySQL.Async.fetchAll("INSERT INTO izzy_radio (player) VALUES (@player)", { 
        --     ["@player"] = player.identifier or player.PlayerData.citizenid
        -- }, function(a)
        -- end)
        vRP.Query('sjr/createChannel', { player = player})
        return {}
    end
end

CreateTunnel.favorite = function(data, password)
    local source = source
    local player = getPlayer(source)
    local myInfo = vRP.Query('sjr/getChannelsPlayer', { player = player })
    

    if myInfo[1] then
        local fetch = json.decode(myInfo[1].data)

        if fetch[data.frequency] then
            fetch[data.frequency] = nil
        else
            if data.frequency then
                fetch[data.frequency] = password or "no_password"
            end
        end

        -- MySQL.Async.execute("UPDATE izzy_radio SET data = @data WHERE player = @player", {
        --     ['@player'] = player.identifier or player.PlayerData.citizenid,
        --     ['@data'] = json.encode(fetch),
        -- })
        vRP.Query('sjr/updateChannels', { player = player, data = json.encode(fetch) })
        return fetch
    else
        return false
    end
end

CreateTunnel.getMembers = function(frequency)
    local source = source

    if channels[frequency] then
        return channels[frequency].users
    else
        return false
    end
end

CreateTunnel.getJob = function(perm)
    local source = source
    local player = getPlayer(source)
    return vRP.HasPermission(player,perm)
end

CreateTunnel.checkItem = function()
    local source = source
    local user_id = vRP.Passport(source)
    if user_id then
        return vRP.InventoryItemAmount(user_id,'radio')[1] >= 1
    end
    return false
end

function getPlayer(source)
    return vRP.Passport(source)
end

AddEventHandler('playerDropped', function (reason)
    for k,v in pairs(channels) do
        for a, src in pairs(v.users) do
            if source == src.id then
                channels[k]["users"][a] = nil
                updateMembers(source, channels[k]["users"])
                break
            end
        end
    end
end)

-- Citizen.CreateThread(function()
--     while true do
--         for k,v in pairs(channels) do
--             for a, src in pairs(v.users) do
--                 local player = getPlayer(src.id)
--                 local item = player.getInventoryItem(Config.radioName)

--                 if not item then
--                     TriggerClientEvent('izzy-radio:forceKick', src.id)
--                 else
--                     local amount = item.count or item.amount
--                     if amount == 0 then
--                         TriggerClientEvent('izzy-radio:forceKick', src.id)
--                     end
--                 end
--                 if source == src.id then
--                     channels[k]["users"][a] = nil
--                     updateMembers(source, channels[k]["users"])
--                     break
--                 end
--             end
--         end
--         Citizen.Wait(5000)
--     end
-- end)

Citizen.CreateThread(function()
    local number = 0
    local fetch = vRP.Query('sjr/getAllChannel', {})

    for k,v in pairs(fetch) do
        local data = json.decode(v.data)
        for name,value in pairs(data) do
            if not channels[name] then
                local password = nil
                if value ~= "no_password" then
                    password = value
                end
                channels[name] = {
                    users = {},
                    password = password,
                    playerId = 0
                }
                number = number+1
            end
        end
    end
    debug(number..' channel loaded.')
end)



function getName(source)
    local user_id = vRP.Passport(source)
    if user_id then
        local identity = vRP.Identity(user_id)
        if identity then
            return identity.name.." "..identity.name2
        end
    end
    return "Nome indefinido"
end

function updateMembers(source, users)
    for k,v in pairs(users) do
        if v.id ~= source then
            TriggerClientEvent('izzy-radio:updateMembers', v.id)
        end
    end
end

function debug(txt)
    if Config.debug then
        print("[Debug] [izzy-radio] "..txt)
    end
end

RegisterServerEvent('izzy-radio:leave')
AddEventHandler('izzy-radio:leave', function(frequency)
	exports["saltychat"]:RemovePlayerRadioChannel(source, frequency)
end)

local talking = {}

CreateTunnel.getTalkings = function()
    return talking
end

RegisterServerEvent('izzy-radio:isTalking')
AddEventHandler('izzy-radio:isTalking', function(value)
	talking[source] = value
end)

RegisterNetEvent("pma-voice:setTalkingOnRadio")
AddEventHandler("pma-voice:setTalkingOnRadio", function(value)
    talking[source] = value
end)

Citizen.CreateThread(function()
    while true do
        TriggerClientEvent('izzy-radio:updateTalking', -1, talking)
        Citizen.Wait(500)
    end
end)