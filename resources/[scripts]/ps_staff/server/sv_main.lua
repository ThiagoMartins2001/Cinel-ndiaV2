-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy  = module("vrp","lib/Proxy")
local config = module(GetCurrentResourceName(),"config")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

-- Inicializar DB se não existir
if not DB then
    DB = {}
    DB.prepare = function(name, query)
        print("^3[PS_STAFF DEBUG] DB.prepare chamado:", name)
        return function(params)
            print("^3[PS_STAFF DEBUG] DB query executada:", name)
            return {}
        end
    end
    DB.query = function(name, params)
        print("^3[PS_STAFF DEBUG] DB.query chamado:", name)
        return {}
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
psRP = {}
Tunnel.bindInterface("ps_staff",psRP)
vCLIENT = Tunnel.getInterface("ps_staff")
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUERYES
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATE TABLE ps_staff_warnings (
-- 	id SERIAL PRIMARY KEY,
--     staff_user_id INTEGER,
--     user_id INTEGER,
--     reason TEXT,
--     banned BOOLEAN,
--     banned_time FLOAT,
--     banned_real_time FLOAT,
--     created FLOAT
-- );

-- CREATE TABLE ps_staff_chat (
--     id SERIAL PRIMARY KEY,
--     staff_user_id INTEGER,
--     player_user_id INTEGER,
--     message TEXT,
--     is_staff BOOLEAN,
--     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- );

DB.prepare("ps_staff/get_warnings","SELECT * FROM ps_staff_warnings WHERE user_id = @user_id")
DB.prepare("ps_staff/get_warning","SELECT * FROM ps_staff_warnings WHERE id = @id")
DB.prepare("ps_staff/get_warning_by_id","SELECT * FROM ps_staff_warnings WHERE id = @id")
DB.prepare("ps_staff/add_warnings","INSERT INTO ps_staff_warnings (staff_user_id, user_id, reason, banned, banned_time, banned_real_time, created) VALUES (@staff_user_id, @user_id, @reason, @banned, @banned_time, @banned_real_time, @created)")
DB.prepare("ps_staff/edit_warning","UPDATE ps_staff_warnings SET banned = 1, banned_time = @banned_time, banned_real_time = @banned_real_time WHERE id = @id")
DB.prepare("ps_staff/delete_warning","DELETE FROM ps_staff_warnings WHERE id = @id")

-- Chat Staff Queries
DB.prepare("ps_staff/get_chat_messages","SELECT * FROM ps_staff_chat WHERE player_user_id = @player_user_id ORDER BY created_at ASC")
DB.prepare("ps_staff/add_chat_message","INSERT INTO ps_staff_chat (staff_user_id, player_user_id, message, is_staff, created_at) VALUES (@staff_user_id, @player_user_id, @message, @is_staff, NOW())")

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local staffperms = {}
local chatactive = {}
local chats      = {}
local messages   = {}
local chatStaffActive = {} -- Para controlar quem tem chat staff ativo

-----------------------------------------------------------------------------------------------------------------------------------------
-- getStaffData
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.getStaffData()
    local source  = source
    local user_id = vRP.Passport(source)
    
    if not user_id or user_id == 0 then
        print("^1[PS_STAFF] Erro: user_id inválido em getStaffData: " .. tostring(user_id))
        return {}
    end
    
    local Identity = vRP.Identity(user_id)
    local data = {}
    
    if user_id and Identity and type(Identity) == "table" then
        data.name    = Identity["name"] or "Nome não encontrado"
        data.user_id = user_id
        data.role    = vRP.Hierarchy("Admin") or "Staff"
        data.perms   = {}

        if staffperms[user_id] ~= nil then
            data.perms = staffperms[user_id]
        end
    else
        print("^1[PS_STAFF] Erro: Identity inválida em getStaffData para user_id: " .. tostring(user_id))
        return {}
    end
    
    return data
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- checkPermission
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.checkPermission()
    local source  = source
    local user_id = vRP.Passport(source)
    
    if not user_id or user_id == 0 then
        print("^1[PS_STAFF] Erro: user_id inválido em checkPermission: " .. tostring(user_id))
        return false
    end
    
    if user_id then
        for k, v in pairs(config.permissions) do
            if vRP.HasGroup(user_id,k) then
                staffperms[user_id] = v
                return true
            end
        end
    end
    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- checkChatOpen
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.checkChatOpen()
    local source  = source
    local user_id = vRP.Passport(source)
    
    if not user_id or user_id == 0 then
        return false
    end
    
    if user_id then
        if chatactive[user_id] then
            return true
        end
    end
    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- checkChatStaffOpen (NOVA FUNÇÃO)
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.checkChatStaffOpen()
    local source  = source
    local user_id = vRP.Passport(source)
    
    if not user_id or user_id == 0 then
        return false
    end
    
    -- Qualquer player pode abrir o chat staff
    return true
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- getAllUsers
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.getAllUsers()
    local source  = source
    local user_id = vRP.Passport(source)

    if user_id and user_id ~= 0 then
        return getUsersList()
    end

    return {}
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- getUser (FUNÇÃO CORRIGIDA)
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.getUser(id)
    print("^3[PS_STAFF DEBUG] getUser chamado com id:", tostring(id))
    local source  = source
    local user_id = vRP.Passport(source)
    print("^3[PS_STAFF DEBUG] user_id do source:", tostring(user_id))

    if not user_id or user_id == 0 then
        print("^1[PS_STAFF] Erro: user_id inválido em getUser: " .. tostring(user_id))
        return false
    end

    if not id or tonumber(id) == 0 then
        print("^1[PS_STAFF] Erro: ID de destino inválido em getUser: " .. tostring(id))
        return false
    end

    if user_id then
        print("^3[PS_STAFF DEBUG] Chamando getUserInfo para id:", tostring(id))
        local userdata = getUserInfo(tonumber(id))
        
        -- VERIFICAÇÃO CRÍTICA ADICIONADA AQUI
        if not userdata or type(userdata) ~= "table" then
            print("^1[PS_STAFF] Erro: getUserInfo retornou dados inválidos para ID: " .. tostring(id))
            return false
        end
        
        print("^3[PS_STAFF DEBUG] getUserInfo retornou dados válidos")
        
        -- Inicializar warnings como tabela vazia
        userdata.warnings = {}

        -- Buscar warnings do banco de dados
        local warnings = DB.query("ps_staff/get_warnings", { user_id = tonumber(id) })
        if warnings and #warnings > 0 then
            userdata.warnings = warnings
        end

        print("^3[PS_STAFF DEBUG] Retornando userdata para o cliente")
        return userdata
    end

    print("^1[PS_STAFF] getUser retornando false - user_id inválido")
    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- addGroup (FUNÇÃO PARA ADICIONAR GRUPO)
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.addGroup(id, group, level)
    local source = source
    local user_id = vRP.Passport(source)
    
    print("^3[PS_STAFF DEBUG] addGroup chamado - ID:", tostring(id), "Grupo:", group, "Nível:", tostring(level))
    
    if not user_id or user_id == 0 then
        print("^1[PS_STAFF] Erro: user_id inválido em addGroup")
        return false
    end
    
    -- Verificar se o usuário tem permissão
    if not psRP.checkPermission() then
        print("^1[PS_STAFF] Usuário sem permissão em addGroup")
        return false
    end
    
    -- Adicionar grupo usando VRP
    vRP.SetPermission(tonumber(id), group, tonumber(level) or 1)
    
    -- Notificar todos os staffs sobre a mudança
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        local staffId = vRP.Passport(tonumber(playerId))
        if staffId and vRP.HasGroup(staffId, "Admin") then
            TriggerClientEvent("ps_staff:groupChanged", tonumber(playerId), {
                type = "add",
                user_id = tonumber(id),
                group = group,
                level = tonumber(level) or 1
            })
        end
    end
    
    print("^3[PS_STAFF DEBUG] Grupo adicionado com sucesso")
    return true
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- removeGroup (FUNÇÃO PARA REMOVER GRUPO)
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.removeGroup(id, group)
    local source = source
    local user_id = vRP.Passport(source)
    
    print("^3[PS_STAFF DEBUG] removeGroup chamado - ID:", tostring(id), "Grupo:", group)
    
    if not user_id or user_id == 0 then
        print("^1[PS_STAFF] Erro: user_id inválido em removeGroup")
        return false
    end
    
    -- Verificar se o usuário tem permissão
    if not psRP.checkPermission() then
        print("^1[PS_STAFF] Usuário sem permissão em removeGroup")
        return false
    end
    
    -- Remover grupo usando VRP
    vRP.RemovePermission(tonumber(id), group)
    
    -- Notificar todos os staffs sobre a mudança
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        local staffId = vRP.Passport(tonumber(playerId))
        if staffId and vRP.HasGroup(staffId, "Admin") then
            TriggerClientEvent("ps_staff:groupChanged", tonumber(playerId), {
                type = "remove",
                user_id = tonumber(id),
                group = group
            })
        end
    end
    
    print("^3[PS_STAFF DEBUG] Grupo removido com sucesso")
    return true
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- searchItems (BUSCAR ITENS)
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.searchItems(searchTerm)
    local source = source
    local user_id = vRP.Passport(source)
    
    print("^3[PS_STAFF DEBUG] searchItems chamado - Termo:", searchTerm)
    
    if not user_id or user_id == 0 then
        print("^1[PS_STAFF] Erro: user_id inválido em searchItems")
        return {}
    end
    
    -- Verificar se o usuário tem permissão
    if not psRP.checkPermission() then
        print("^1[PS_STAFF] Usuário sem permissão em searchItems")
        return {}
    end
    
    local results = searchItems(searchTerm)
    print("^3[PS_STAFF DEBUG] Resultados da busca:", #results)
    return results
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- getItemInfo (OBTER INFORMAÇÕES DE ITEM)
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.getItemInfo(itemId)
    local source = source
    local user_id = vRP.Passport(source)
    
    print("^3[PS_STAFF DEBUG] getItemInfo chamado - Item:", itemId)
    
    if not user_id or user_id == 0 then
        print("^1[PS_STAFF] Erro: user_id inválido em getItemInfo")
        return nil
    end
    
    -- Verificar se o usuário tem permissão
    if not psRP.checkPermission() then
        print("^1[PS_STAFF] Usuário sem permissão em getItemInfo")
        return nil
    end
    
    local itemInfo = getItemInfo(itemId)
    return itemInfo
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- getUserInventory (BUSCAR INVENTÁRIO DE PLAYER ESPECÍFICO)
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.getUserInventory(userId)
    local source = source
    local user_id = vRP.Passport(source)
    
    print("^3[PS_STAFF DEBUG] getUserInventory chamado - User:", userId)
    
    if not user_id or user_id == 0 then
        print("^1[PS_STAFF] Erro: user_id inválido em getUserInventory")
        return {}
    end
    
    -- Verificar se o usuário tem permissão
    if not psRP.checkPermission() then
        print("^1[PS_STAFF] Usuário sem permissão em getUserInventory")
        return {}
    end
    
    -- Buscar inventário do player especificado
    local inventory = getUserInventory(userId)
    print("^3[PS_STAFF DEBUG] Inventário retornado com", #inventory, "itens")
    return inventory
end



-----------------------------------------------------------------------------------------------------------------------------------------
-- getAllGroups
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.getAllGroups()
    local source  = source
    local user_id = vRP.Passport(source)

    if user_id and user_id ~= 0 then
        return getAllGroups()
    end

    return {}
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- getAllVehicles
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.getAllVehicles()
    local source  = source
    local user_id = getUserId(source)

    if user_id and user_id ~= 0 then
        return getAllVehicles()
    end

    return {}
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- getAllItems
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.getAllItems()
    local items = {}
    local itemList = module("vrp", "config/item")
    if not itemList then
        print("^1[PS_STAFF] Erro: Não foi possível carregar a lista de itens do vrp/config/item.lua")
        return items
    end
    for itemName, itemData in pairs(itemList) do
        table.insert(items, {
            item = itemName,
            name = itemData["Name"] or itemName
        })
    end
    return items
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- addGroup
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.addGroup(id, group, level)
    local source  = source
    local user_id = getUserId(source)

    if not user_id or user_id == 0 then
        return false
    end

    if not id or not group then
        print("^1[PS_STAFF] Erro: Parâmetros inválidos em addGroup - ID: " .. tostring(id) .. ", Group: " .. tostring(group))
        return false
    end

    level = tonumber(level) or 1

    if user_id then
        local check = addUserGroup(tonumber(id), group, level)
        if check then
            -- Notificar todos os staffs online sobre a mudança
            local players = GetPlayers()
            for _, playerId in ipairs(players) do
                local staffId = vRP.Passport(tonumber(playerId))
                if staffId and vRP.HasGroup(staffId, "Admin") then
                    TriggerClientEvent("ps_staff:groupChanged", tonumber(playerId), {
                        type = "add",
                        user_id = tonumber(id),
                        group = group,
                        level = level
                    })
                end
            end
            
            PerformHttpRequest(config.webhooks.addgroup, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    { 
                        title = "REGISTRO DE ADICIONAR GRUPO:\n⠀",
                        thumbnail = {
                            url = config.webhooks.webhookimage
                        }, 
                        fields = {
                            { 
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                            },
                            {
                                name = "**ID & GROUP & LEVEL: **",
                                value = "**"..tonumber(id).." no grupo: "..group.." (Nível: "..level..")**"
                            }
                        }, 
                        footer = { 
                            text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = config.webhooks.webhookimage
                        },
                        color = config.webhooks.webhookcolor
                    }
                }
            }), { ['Content-Type'] = 'application/json' })

            return true
        end
    end

    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- remGroup
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.remGroup(id, group)
    local source  = source
    local user_id = getUserId(source)

    if not user_id or user_id == 0 then
        return false
    end

    if not id or not group then
        print("^1[PS_STAFF] Erro: Parâmetros inválidos em remGroup - ID: " .. tostring(id) .. ", Group: " .. tostring(group))
        return false
    end

    if user_id then
        vRP.RemovePermission(tonumber(id),group)
        
        -- Notificar todos os staffs online sobre a mudança
        local players = GetPlayers()
        for _, playerId in ipairs(players) do
            local staffId = vRP.Passport(tonumber(playerId))
            if staffId and vRP.HasGroup(staffId, "Admin") then
                TriggerClientEvent("ps_staff:groupChanged", tonumber(playerId), {
                    type = "remove",
                    user_id = tonumber(id),
                    group = group
                })
            end
        end
        
        PerformHttpRequest(config.webhooks.remgroup, function(err, text, headers) end, 'POST', json.encode({
            embeds = {
                { 
                    title = "REGISTRO DE REMOVER GRUPO:\n⠀",
                    thumbnail = {
                        url = config.webhooks.remgroup
                    }, 
                    fields = {
                        { 
                            name = "**COLABORADOR DA EQUIPE:**",
                            value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                        },
                        {
                            name = "**ID & GROUP: **",
                            value = "**"..tonumber(id).." no grupo: "..group.."**"
                        }
                    }, 
                    footer = { 
                        text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                        icon_url = config.webhooks.webhookimage
                    },
                    color = config.webhooks.webhookcolor
                }
            }
        }), { ['Content-Type'] = 'application/json' })

        return true
    end

    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- addBan (FUNÇÃO CORRIGIDA)
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.addBan(id, time, reason)
    local source  = source
    local user_id = vRP.Passport(source) -- ID do staff que está aplicando o ban
    
    if not user_id or user_id == 0 then
        print("^1[PS_STAFF] Erro: user_id inválido em addBan: " .. tostring(user_id))
        return false
    end

    if not id or tonumber(id) == 0 then
        print("^1[PS_STAFF] Erro: ID de destino inválido em addBan: " .. tostring(id))
        return false
    end

    if not reason or reason == "" then
        print("^1[PS_STAFF] Erro: Motivo não informado em addBan")
        return false
    end

    local Identity = vRP.Identity(tonumber(id))    -- Identidade do jogador a ser banido

    if user_id then -- Verifica se o staff que executa o comando é válido
        if time ~= 0 then -- Garante que o tempo de banimento não é zero

            -- VERIFICAÇÃO CRÍTICA: Garante que a identidade do jogador a ser banido e a licença são válidas
            if Identity and type(Identity) == "table" and Identity["license"] and Identity["license"] ~= "" then
                -- Adiciona o registro no seu sistema de warnings (ps_staff_warnings)
                DB.query("ps_staff/add_warnings", {
                    staff_user_id    = user_id,
                    user_id          = tonumber(id),
                    reason           = reason,
                    banned           = 1,
                    banned_time      = time, -- Tempo do banimento em dias
                    banned_real_time = tonumber(time), -- Tempo real do banimento em dias
                    created          = os.date("%Y-%m-%d %H:%I:%S"),
                })

                -- Adiciona o banimento na tabela 'banneds' usando a mesma lógica do comando 'ban'
                -- A query é "banneds/InsertBanned" e usa "License" e "Time" como parâmetros.
                vRP.Query("banneds/InsertBanned", { License = Identity["license"], Time = tonumber(time) })
        
                -- Envia o webhook para o Discord
                PerformHttpRequest(config.webhooks.addban, function(err, text, headers) end, 'POST', json.encode({
                    embeds = {
                        {
                            title = "REGISTRO DE BANIMENTO:\n⠀",
                            thumbnail = {
                                url = config.webhooks.remgroup
                            },
                            fields = {
                                {
                                    name = "**STAFF QUE BANIU:**",
                                    value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                                },
                                {
                                    name = "**JOGADOR BANIDO:**",
                                    value = "**"..getUserFullName(tonumber(id)).."** [**"..tonumber(id).."**]\n⠀"
                                },
                                {
                                    name = "**MOTIVO:**",
                                    value = "**"..reason.."**\n⠀"
                                },
                                {
                                    name = "**TEMPO:**",
                                    value = "**"..tonumber(time).." dias**"
                                }
                            },
                            footer = {
                                text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                                icon_url = config.webhooks.webhookimage
                            },
                            color = config.webhooks.webhookcolor
                        }
                    }
                }), { ['Content-Type'] = 'application/json' })

                -- Kika o jogador banido se ele estiver online
                local OtherSource = vRP.Source(tonumber(id))
                if OtherSource then
                    vRP.Kick(OtherSource,"Banido!")
                end
                return true
            else
                -- Notifica o staff se não conseguir a licença do jogador
                sendnotify(source, "negado", "Não foi possível obter a licença do jogador (ID: "..tostring(id).."). Banimento não aplicado.", 8000)
                print("^1[PS_STAFF] Erro: Identity inválida para banimento - ID: " .. tostring(id))
            end
        else
            -- Notifica o staff se o tempo de banimento for zero
            TriggerClientEvent("Notify",source,"vermelho","O tempo de banimento não pode ser Zero!",8000)
        end
    end

    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- deleteBan
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.deleteBan(banId, userId)
    local source  = source
    local user_id = vRP.Passport(source) -- ID do staff que está deletando o ban
    
    if not user_id or user_id == 0 then
        print("^1[PS_STAFF] Erro: user_id inválido em deleteBan: " .. tostring(user_id))
        return false
    end

    -- Verificar permissão para deletar banimentos
    if not hasPermission(user_id, "deleteban") then
        sendnotify(source, "negado", "Você não tem permissão para deletar banimentos.", 5000)
        return false
    end

    if not banId or tonumber(banId) == 0 then
        print("^1[PS_STAFF] Erro: ID do ban inválido em deleteBan: " .. tostring(banId))
        return false
    end

    if not userId or tonumber(userId) == 0 then
        print("^1[PS_STAFF] Erro: ID do usuário inválido em deleteBan: " .. tostring(userId))
        return false
    end

    local Identity = vRP.Identity(tonumber(userId))    -- Identidade do jogador

    if user_id then
        -- Verificar se o banimento existe
        local check = DB.query("ps_staff/get_warning_by_id", { id = tonumber(banId) })
        
        -- Verificar se é um banimento válido (banned = 1 ou banned_real_time > 0)
        local isValidBan = false
        if #check > 0 then
            if check[1].banned == 1 or check[1].banned == true or (check[1].banned_real_time and check[1].banned_real_time > 0) then
                isValidBan = true
            end
        end
        
        if #check > 0 and isValidBan then
            -- Deletar o registro do banimento
            DB.query("ps_staff/delete_warning", { id = tonumber(banId) })

            -- Remover o banimento da tabela 'banneds' se a licença existir
            if Identity and type(Identity) == "table" and Identity["license"] and Identity["license"] ~= "" then
                vRP.Query("banneds/RemoveBanned", { License = Identity["license"] })
            end

            -- Enviar webhook para o Discord
            PerformHttpRequest(config.webhooks.deleteban, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    {
                        title = "REGISTRO DE REMOÇÃO DE BANIMENTO:\n⠀",
                        thumbnail = {
                            url = config.webhooks.remgroup
                        },
                        fields = {
                            {
                                name = "**STAFF QUE REMOVEU:**",
                                value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                            },
                            {
                                name = "**JOGADOR DESBANIDO:**",
                                value = "**"..getUserFullName(tonumber(userId)).."** [**"..tonumber(userId).."**]\n⠀"
                            },
                            {
                                name = "**MOTIVO ORIGINAL:**",
                                value = "**"..check[1].reason.."**\n⠀"
                            }
                        },
                        footer = {
                            text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = config.webhooks.webhookimage
                        },
                        color = config.webhooks.webhookcolor
                    }
                }
            }), { ['Content-Type'] = 'application/json' })

            return true
        else
            print("^1[PS_STAFF] Erro: Banimento não encontrado ou não é um banimento válido - ID: " .. tostring(banId))
            return false
        end
    end

    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- editBan
-----------------------------------------------------------------------------------------------------------------------------------------
DB.prepare("ps_staff/editBanned","UPDATE banneds SET time = UNIX_TIMESTAMP() + 86400 * @time WHERE license = @license")
function psRP.editBan(id,time)
    local source  = source
    local user_id = getUserId(source)
    
    if not user_id or user_id == 0 then
        return false
    end

    if not id or not time then
        print("^1[PS_STAFF] Erro: Parâmetros inválidos em editBan - ID: " .. tostring(id) .. ", Time: " .. tostring(time))
        return false
    end

    local Identity = vRP.Identity(tonumber(id))

    if user_id and Identity and type(Identity) == "table" then

        local check = DB.query("ps_staff/get_warning", { id = tonumber(id) })
        if #check > 0 then
            local origtime = os.time()
            local newtime  = time + 1 * 24 * tonumber(time) * 60

            DB.query("ps_staff/edit_warning", {
                banned_time      = newtime,
                banned_real_time = tonumber(time),
                id               = tonumber(id),
            })

            if Identity["license"] then
                DB.query("ps_staff/editBanned",{ license = Identity["license"], time = time })
            end

            PerformHttpRequest(config.webhooks.editban, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    { 
                        title = "REGISTRO DE EDITAR BANIMENTO:\n⠀",
                        thumbnail = {
                            url = config.webhooks.remgroup
                        }, 
                        fields = {
                            { 
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                            },
                            {
                                name = "**ID: **",
                                value = "**"..tonumber(id).."**"
                            },
                            {
                                name = "**TEMPO: **",
                                value = "**"..tonumber(time).."**"
                            }
                        }, 
                        footer = { 
                            text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = config.webhooks.webhookimage
                        },
                        color = config.webhooks.webhookcolor
                    }
                }
            }), { ['Content-Type'] = 'application/json' })
            return true
        end
    end

    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- getMessages
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.getMessages(id)
    local source  = source
    local user_id = getUserId(source)
    local data    = {}

    if not user_id or user_id == 0 then
        return {}
    end

    if user_id and id then
        id = tonumber(id)
        if chatactive[id] then
            chatid = chats[id]
            data   = messages[chatid] or {}
        end
    end

    return data
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- sendMessage
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.sendMessage(id, message)
    local source  = source
    local user_id = getUserId(source)

    if not user_id or user_id == 0 then
        return false
    end

    if not id or not message then
        print("^1[PS_STAFF] Erro: Parâmetros inválidos em sendMessage - ID: " .. tostring(id) .. ", Message: " .. tostring(message))
        return false
    end

    if user_id then
        
        id = tonumber(id)

        local nsource = getUserSource(id)

        if nsource == nil then
            sendnotify(source, "negado", "O player está offline", 5000)
            return false
        end

        if chatactive[id] == nil or chatactive[id] == false then
            chatactive[id] = true

            local chatid = math.random(1,10000)
    
            if messages[chatid] ~= nil then
                repeat
                    chatid = math.random(1,10000)
                    Citizen.Wait(0)
                until messages[chatid] == nil
            end

            chats[id] = chatid
            messages[chatid] = {}

            local messagedata = {
                user_id = user_id,
                staff   = true,
                name    = getUserFullName(user_id),
                image   = getUserImage(user_id),
                message = message
            }

            table.insert(messages[chatid], messagedata)
            sendnotify(nsource, "aviso", "Você recebeu uma nova mensagem da staff, utilize <b>/chatstaff</b> para responder", 10000)
            TriggerClientEvent("ps_staff:updatechatplayer",nsource)

            -- Salvar no banco de dados
            DB.execute("ps_staff/add_chat_message", {
                staff_user_id = user_id,
                player_user_id = id,
                message = message,
                is_staff = true
            })

            PerformHttpRequest(config.webhooks.sendmessage, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    { 
                        title = "REGISTRO DE ENVIAR MENSAGEM:\n⠀",
                        thumbnail = {
                            url = config.webhooks.remgroup
                        }, 
                        fields = {
                            { 
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                            },
                            {
                                name = "**ID: **",
                                value = "**"..tonumber(id).."**"
                            },
                            {
                                name = "**MENSAGEM: **",
                                value = "**"..message.."**"
                            }
                        }, 
                        footer = { 
                            text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = config.webhooks.webhookimage
                        },
                        color = config.webhooks.webhookcolor
                    }
                }
            }), { ['Content-Type'] = 'application/json' })
        else
            local chatid = chats[id]
            local messagedata = {
                user_id = user_id,
                staff   = true,
                name    = getUserFullName(user_id),
                image   = getUserImage(user_id),
                message = message
            }

            table.insert(messages[chatid], messagedata)
            sendnotify(nsource, "aviso", "Você recebeu uma nova mensagem da staff, utilize <b>/chatstaff</b> para responder", 10000)
            TriggerClientEvent("ps_staff:updatechatplayer",nsource)

            -- Salvar no banco de dados
            DB.execute("ps_staff/add_chat_message", {
                staff_user_id = user_id,
                player_user_id = id,
                message = message,
                is_staff = true
            })

            PerformHttpRequest(config.webhooks.sendmessage, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    { 
                        title = "REGISTRO DE ENVIAR MENSAGEM:\n⠀",
                        thumbnail = {
                            url = config.webhooks.remgroup
                        }, 
                        fields = {
                            { 
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                            },
                            {
                                name = "**ID: **",
                                value = "**"..tonumber(id).."**"
                            },
                            {
                                name = "**MENSAGEM: **",
                                value = "**"..message.."**"
                            }
                        }, 
                        footer = { 
                            text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = config.webhooks.webhookimage
                        },
                        color = config.webhooks.webhookcolor
                    }
                }
            }), { ['Content-Type'] = 'application/json' })
        end

        return true
    end

    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- getChatMessages
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.getChatMessages()
    local source  = source
    local user_id = getUserId(source)
    local data    = {}

    if not user_id or user_id == 0 then
        return {}
    end

    if user_id then
        if chatactive[user_id] then
            chatid = chats[user_id]
            data   = messages[chatid] or {}
        end
    end

    return data
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- sendMessagePlayer
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.sendMessagePlayer(message)
    local source  = source
    local user_id = getUserId(source)

    if not user_id or user_id == 0 then
        return false
    end

    if not message then
        print("^1[PS_STAFF] Erro: Mensagem inválida em sendMessagePlayer")
        return false
    end

    if user_id then
        if chatactive[user_id] then
            chatid = chats[user_id]

            local messagedata = {
                user_id = user_id,
                staff   = false,
                name    = getUserFullName(user_id),
                image   = getUserImage(user_id),
                message = message
            }
            
            local players = {}
            for k,v in pairs(messages[chatid]) do
                if v.staff then
                    if players[v.user_id] == nil then
                        table.insert(players, v.user_id)
                    end
                end
            end

            for k, v in pairs(players) do
                local nsource = getUserSource(v)
                if nsource then
                    TriggerClientEvent("ps_staff:updatechat",nsource, user_id)
                end
            end

            table.insert(messages[chatid], messagedata)

            PerformHttpRequest(config.webhooks.sendmessageplayer, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    { 
                        title = "REGISTRO DE RESPONDER MENSAGEM:\n⠀",
                        thumbnail = {
                            url = config.webhooks.remgroup
                        }, 
                        fields = {
                            { 
                                name = "**PLAYER:**",
                                value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                            },
                            {
                                name = "**MENSAGEM: **",
                                value = "**"..message.."**"
                            }
                        }, 
                        footer = { 
                            text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = config.webhooks.webhookimage
                        },
                        color = config.webhooks.webhookcolor
                    }
                }
            }), { ['Content-Type'] = 'application/json' })
            return true
        end
    end

    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAT STAFF FUNCTIONS (NOVAS FUNÇÕES)
-----------------------------------------------------------------------------------------------------------------------------------------

-- getChatStaffMessages - Busca mensagens do chat staff para o player
function psRP.getChatStaffMessages()
    local source = source
    local user_id = vRP.Passport(source)
    
    if not user_id or user_id == 0 then
        return {}
    end
    
    local messages = DB.query("ps_staff/get_chat_messages", { player_user_id = user_id })
    local formattedMessages = {}
    
    for k, v in pairs(messages) do
        local staffName = "Staff"
        if v.staff_user_id and v.staff_user_id > 0 then
            local staffIdentity = vRP.Identity(v.staff_user_id)
            if staffIdentity and staffIdentity.name then
                staffName = staffIdentity.name
            end
        end
        
        table.insert(formattedMessages, {
            message = v.message,
            is_staff = v.is_staff,
            sender_name = v.is_staff and staffName or getUserFullName(user_id),
            timestamp = v.created_at,
            staff_user_id = v.staff_user_id,
            player_user_id = v.player_user_id
        })
    end
    
    return formattedMessages
end

-- sendChatStaffMessage - Player envia mensagem para staff
function psRP.sendChatStaffMessage(message)
    local source = source
    local user_id = vRP.Passport(source)
    
    if not user_id or user_id == 0 then
        return { success = false, error = "ID inválido" }
    end
    
    if not message or message == "" then
        return { success = false, error = "Mensagem vazia" }
    end
    
    -- Salvar mensagem no banco
    DB.execute("ps_staff/add_chat_message", {
        staff_user_id = 0, -- 0 indica que é mensagem do player
        player_user_id = user_id,
        message = message,
        is_staff = false
    })
    
    -- Notificar todos os staffs online
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        local staffId = vRP.Passport(tonumber(playerId))
        if staffId and vRP.HasGroup(staffId, "Admin") then
            sendnotify(tonumber(playerId), "aviso", "Nova mensagem no chat staff de " .. getUserFullName(user_id) .. " #" .. user_id, 8000)
        end
    end
    
    -- Webhook
    PerformHttpRequest(config.webhooks.sendmessageplayer, function(err, text, headers) end, 'POST', json.encode({
        embeds = {
            { 
                title = "CHAT STAFF - NOVA MENSAGEM:\n⠀",
                thumbnail = {
                    url = config.webhooks.webhookimage
                }, 
                fields = {
                    { 
                        name = "**PLAYER:**",
                        value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                    },
                    {
                        name = "**MENSAGEM: **",
                        value = "**"..message.."**"
                    }
                }, 
                footer = { 
                    text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                    icon_url = config.webhooks.webhookimage
                },
                color = config.webhooks.webhookcolor
            }
        }
    }), { ['Content-Type'] = 'application/json' })
    
    return { success = true }
end

-- sendChatStaffReply - Staff responde para player via chat staff
function psRP.sendChatStaffReply(playerId, message)
    local source = source
    local staff_user_id = vRP.Passport(source)
    
    if not staff_user_id or staff_user_id == 0 then
        return { success = false, error = "Staff ID inválido" }
    end
    
    if not playerId or tonumber(playerId) == 0 then
        return { success = false, error = "Player ID inválido" }
    end
    
    if not message or message == "" then
        return { success = false, error = "Mensagem vazia" }
    end
    
    playerId = tonumber(playerId)
    
    -- Verificar se staff tem permissão
    if not vRP.HasGroup(staff_user_id, "Admin") then
        return { success = false, error = "Sem permissão" }
    end
    
    -- Salvar mensagem no banco
    DB.execute("ps_staff/add_chat_message", {
        staff_user_id = staff_user_id,
        player_user_id = playerId,
        message = message,
        is_staff = true
    })
    
    -- Notificar o player se estiver online
    local playerSource = vRP.Source(playerId)
    if playerSource then
        sendnotify(playerSource, "aviso", "Nova resposta da staff no chat! Use /chatstaff para ver", 8000)
        TriggerClientEvent("ps_staff:newchatstaffmessage", playerSource, {
            message = message,
            is_staff = true,
            sender_name = getUserFullName(staff_user_id),
            timestamp = os.date("%Y-%m-%d %H:%M:%S")
        })
    end
    
    return { success = true }
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- spawnItem
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.spawnItem(item, amount, id)
    local source  = source
    local user_id = getUserId(source)

    if not user_id or user_id == 0 then
        return { success = false, message = "Usuário não autorizado" }
    end

    if not item then
        return { success = false, message = "Item não especificado" }
    end

    -- Se não foi especificada quantidade, usar 1 como padrão
    if not amount or amount == "" then
        amount = 1
    else
        amount = tonumber(amount) or 1
    end

    -- Se não foi especificado ID (passport), usar o próprio usuário
    if not id or id == "" then
        id = user_id
    else
        id = tonumber(id)
    end
    
    if not id or id <= 0 then
        return { success = false, message = "ID inválido" }
    end

    -- Verificar se o item existe usando itemBody (mesmo do comando /item)
    local itemData = itemBody(item)
    if itemData == nil then
        return { success = false, message = "Item não encontrado: " .. item }
    end

    -- Usar vRP.GenerateItem (mesmo do comando /item)
    vRP.GenerateItem(id, item, amount, true)
    
    -- Atualizar inventário do cliente se for o próprio usuário
    if id == user_id then
        TriggerClientEvent("inventory:Update", source, "Backpack")
    end

    -- Log do spawn
    PerformHttpRequest(config.webhooks.spawnitem, function(err, text, headers) end, 'POST', json.encode({
        embeds = {
            { 
                title = "REGISTRO DE SPAWN ITEM:\n⠀",
                thumbnail = {
                    url = config.webhooks.remgroup
                }, 
                fields = {
                    { 
                        name = "**COLABORADOR DA EQUIPE:**",
                        value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                    },
                    {
                        name = "**ID: **",
                        value = "**"..tonumber(id).."**"
                    },
                    {
                        name = "**ITEM: **",
                        value = "**"..item.."**"
                    },
                    {
                        name = "**QUANTIDADE: **",
                        value = "**"..tonumber(amount).."**"
                    }
                }, 
                footer = { 
                    text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                    icon_url = config.webhooks.webhookimage
                },
                color = config.webhooks.webhookcolor
            }
        }
    }), { ['Content-Type'] = 'application/json' })

    return { success = true, message = "Item spawnado com sucesso" }
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- spawnVehicle
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.spawnVehicle(id, vehicle)
    local source  = source
    local user_id = getUserId(source)

    if not user_id or user_id == 0 then
        return { success = false, message = "Usuário não autorizado" }
    end

    if not vehicle then
        return { success = false, message = "Veículo inválido" }
    end

    -- Se ID for 0 ou nil, usar o ID do próprio jogador
    if not id or id == 0 then
        id = user_id
    else
        id = tonumber(id)
    end
    
    if not id or id <= 0 then
        return { success = false, message = "ID inválido" }
    end
    
    local check = spawnVehicle(id, vehicle)
    if check then
        PerformHttpRequest(config.webhooks.spawnvehicle, function(err, text, headers) end, 'POST', json.encode({
            embeds = {
                { 
                    title = "REGISTRO DE SPAWN VEÍCULO:\n⠀",
                    thumbnail = {
                        url = config.webhooks.remgroup
                    }, 
                    fields = {
                        { 
                            name = "**COLABORADOR DA EQUIPE:**",
                            value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                        },
                        {
                            name = "**ID: **",
                            value = "**"..tonumber(id).."**"
                        },
                        {
                            name = "**VEÍCULO: **",
                            value = "**"..vehicle.."**"
                        }
                    }, 
                    footer = { 
                        text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                        icon_url = config.webhooks.webhookimage
                    },
                    color = config.webhooks.webhookcolor
                }
            }
        }), { ['Content-Type'] = 'application/json' })

        return { success = true, message = "Carro spawnado com sucesso" }
    else
        return { success = false, message = "Falha ao spawnar veículo" }
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- addVehicle
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.addVehicle(id, vehicle)
    local source  = source
    local user_id = getUserId(source)

    if not user_id or user_id == 0 then
        return { success = false, message = "Usuário não autorizado" }
    end

    if not vehicle then
        return { success = false, message = "Veículo inválido" }
    end

    if not id or id == "" then
        id = user_id
    else
        id = tonumber(id)
    end
    
    if not id or id <= 0 then
        return { success = false, message = "ID inválido" }
    end
    
    local check = addVehicle(id, vehicle)
    if check then
        PerformHttpRequest(config.webhooks.addvehicle, function(err, text, headers) end, 'POST', json.encode({
            embeds = {
                { 
                    title = "REGISTRO DE ADICIONAR VEÍCULO:\n⠀",
                    thumbnail = {
                        url = config.webhooks.remgroup
                    }, 
                    fields = {
                        { 
                            name = "**COLABORADOR DA EQUIPE:**",
                            value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                        },
                        {
                            name = "**ID: **",
                            value = "**"..tonumber(id).."**"
                        },
                        {
                            name = "**VEÍCULO: **",
                            value = "**"..vehicle.."**"
                        }
                    }, 
                    footer = { 
                        text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                        icon_url = config.webhooks.webhookimage
                    },
                    color = config.webhooks.webhookcolor
                }
            }
        }), { ['Content-Type'] = 'application/json' })

        local targetName = getUserFullName(id)
        return { success = true, message = "Carro adicionado na garagem do: " .. targetName .. " #" .. id .. " - Sucesso" }
    else
        return { success = false, message = "Falha ao adicionar veículo" }
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- removeVehicle
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.removeVehicle(id, vehicle, plate)
    local source  = source
    local user_id = getUserId(source)

    if not user_id or user_id == 0 then
        print("^1[PS_STAFF] Erro: user_id inválido em removeVehicle: " .. tostring(user_id))
        return { success = false, message = "Usuário não autorizado" }
    end

    if not vehicle then
        print("^1[PS_STAFF] Erro: vehicle inválido em removeVehicle: " .. tostring(vehicle))
        return { success = false, message = "Veículo inválido" }
    end

    if not id or id == 0 then
        print("^1[PS_STAFF] Erro: id inválido em removeVehicle: " .. tostring(id))
        return { success = false, message = "ID inválido" }
    end
    
    print("^3[PS_STAFF] Tentando remover veículo: " .. vehicle .. " do jogador: " .. tostring(id) .. " por: " .. tostring(user_id))
    
    -- Verificar se o veículo existe na garagem do jogador
    local result = exports.oxmysql:executeSync("SELECT * FROM vehicles WHERE Passport = @Passport AND vehicle = @vehicle", { 
        Passport = id, 
        vehicle = vehicle 
    })
    
    if not result or #result == 0 then
        print("^1[PS_STAFF] Veículo não encontrado na garagem: " .. vehicle .. " - Passport: " .. tostring(id))
        return { success = false, message = "Veículo não encontrado na garagem do jogador" }
    end
    
    print("^2[PS_STAFF] Veículo encontrado, removendo...")
    
    -- Remover o veículo usando a mesma query do comando remcar
    vRP.Query("vehicles/removeVehicles", { Passport = id, vehicle = vehicle })
    
    -- Remover dados relacionados ao veículo
    vRP.Query("entitydata/RemoveData", { Name = "Mods:"..id..":"..vehicle })
    vRP.Query("entitydata/RemoveData", { Name = "Chest:"..id..":"..vehicle })
    
    print("^2[PS_STAFF] Veículo removido com sucesso: " .. vehicle .. " do jogador: " .. tostring(id))
    
    -- Enviar notificação de sucesso para o staff
    TriggerClientEvent("Notify", source, "verde", "Veículo <b>"..vehicle.."</b> removido com sucesso da garagem do jogador <b>"..getUserFullName(id).." #"..id.."</b>.", 5000)
    
    -- Log da ação
    PerformHttpRequest(config.webhooks.removevehicle, function(err, text, headers) end, 'POST', json.encode({
        embeds = {
            { 
                title = "REGISTRO DE REMOÇÃO DE VEÍCULO:\n⠀",
                thumbnail = {
                    url = config.webhooks.remgroup
                }, 
                fields = {
                    { 
                        name = "**COLABORADOR DA EQUIPE:**",
                        value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                    },
                    {
                        name = "**ID DO JOGADOR: **",
                        value = "**"..tonumber(id).."**"
                    },
                    {
                        name = "**VEÍCULO: **",
                        value = "**"..vehicle.."**"
                    },
                    {
                        name = "**PLACA: **",
                        value = "**"..(plate or "N/A").."**"
                    }
                }, 
                footer = { 
                    text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                    icon_url = config.webhooks.webhookimage
                },
                color = config.webhooks.webhookcolor
            }
        }
    }), { ['Content-Type'] = 'application/json' })

    local targetName = getUserFullName(id)
    return { success = true, message = "Veículo removido com sucesso da garagem do: " .. targetName .. " #" .. id }
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDO CHATSTAFF
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('chatstaff', function(source, args)
    local user_id = vRP.Passport(source)
    
    if not user_id or user_id == 0 then
        TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Erro: ID do usuário não encontrado.")
        return
    end
    
    print("^2[PS_STAFF] Comando /chatstaff executado por user_id: " .. tostring(user_id))
    
    -- Verificar se o usuário existe
    local Identity = vRP.Identity(user_id)
    if not Identity then
        TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Erro: Identidade do usuário não encontrada.")
        return
    end
    
    -- Abrir chat staff
    TriggerClientEvent('ps_staff:openchatstaff', source)
end)

function psRP.getOnlinePlayers()
    local players = GetPlayers()
    return #players
end

function psRP.getOnlineStaff()
    local count = 0
    local users = vRP.Players()
    for user_id, _ in pairs(users) do
        if vRP.HasGroup(user_id, "Admin") then
            count = count + 1
        end
    end
    return count
end

function psRP.getOnlinePolice()
    local count = 0
    local users = vRP.Players()
    for user_id, _ in pairs(users) do
        	if vRP.HasGroup(user_id, "PoliciaMilitar") or vRP.HasGroup(user_id, "Core") or vRP.HasGroup(user_id, "PRF") or vRP.HasGroup(user_id, "PCivil") then
            count = count + 1
        end
    end
    return count
end

function psRP.getOnlinePRF()
    local count = 0
    local users = vRP.Players()
    for user_id, _ in pairs(users) do
        if vRP.HasGroup(user_id, "PRF") then
            count = count + 1
        end
    end
    return count
end

function psRP.getOnlinePCivil()
    local count = 0
    local users = vRP.Players()
    for user_id, _ in pairs(users) do
        if vRP.HasGroup(user_id, "PCivil") then
            count = count + 1
        end
    end
    return count
end

function psRP.getOnlineCore()
    local count = 0
    local users = vRP.Players()
    for user_id, _ in pairs(users) do
        if vRP.HasGroup(user_id, "Core") then
            count = count + 1
        end
    end
    return count
end

function psRP.getOnlineOficina01()
    local count = 0
    local users = vRP.Players()
    for user_id, _ in pairs(users) do
        if vRP.HasGroup(user_id, "Oficina01") then
            count = count + 1
        end
    end
    return count
end

function psRP.getOnlineOficina012()
    local count = 0
    local users = vRP.Players()
    for user_id, _ in pairs(users) do
        if vRP.HasGroup(user_id, "Oficina02") then
            count = count + 1
        end
    end
    return count
end

function psRP.getOnlineHarmony()
    local count = 0
    local users = vRP.Players()
    for user_id, _ in pairs(users) do
        if vRP.HasGroup(user_id, "Harmony") then
            count = count + 1
        end
    end
    return count
end

function psRP.getOnlineJudiciary()
    local count = 0
    local users = vRP.Players()
    for user_id, _ in pairs(users) do
        if vRP.HasGroup(user_id, "Judiciary") then
            count = count + 1
        end
    end
    return count
end

function psRP.getOnlineParamedic()
    local count = 0
    local users = vRP.Players()
    for user_id, _ in pairs(users) do
        if vRP.HasGroup(user_id, "Paramedic") then
            count = count + 1
        end
    end
    return count
end

function psRP.getOnlineBurgerShot()
    local count = 0
    local users = vRP.Players()
    for user_id, _ in pairs(users) do
        if vRP.HasGroup(user_id, "BurgerShot") then
            count = count + 1
        end
    end
    return count
end

function psRP.getOnlinePearls()
    local count = 0
    local users = vRP.Players()
    for user_id, _ in pairs(users) do
        if vRP.HasGroup(user_id, "Pearls") then
            count = count + 1
        end
    end
    return count
end

-- Endpoint para retornar todos os membros do grupo Admin (Staff)
function psRP.getAllStaffMembers(group)
    group = group or "Admin"
    local allUsers = getUsersList()
    local staffList = {}
    for _, user in pairs(allUsers) do
        local user_id = user.user_id
        if vRP.HasGroup(user_id, group) then
            table.insert(staffList, {
                user_id = user_id,
                name = user.name,
                online = user.online
            })
        end
    end
    return staffList
end

-- Endpoint para retornar membros de qualquer grupo
function psRP.getGroupMembers(group)
    if not group then
        return {}
    end
    
    local allUsers = getUsersList()
    local groupMembers = {}
    
    for _, user in pairs(allUsers) do
        local user_id = user.user_id
        if vRP.HasGroup(user_id, group) then
            table.insert(groupMembers, {
                user_id = user_id,
                name = user.name,
                online = user.online
            })
        end
    end
    
    return groupMembers
end

RegisterNetEvent("ps_staff:getAllStaffMembersRequest")
AddEventHandler("ps_staff:getAllStaffMembersRequest", function()
    local src = source
    local staffList = psRP.getAllStaffMembers()
    TriggerClientEvent("ps_staff:getAllStaffMembersResponse", src, staffList)
end)

-- Evento para quando um player entra no servidor
AddEventHandler("vRP:playerSpawn", function(user_id, source)
    if user_id and user_id > 0 then
        -- Notificar todos os staffs online sobre o novo player
        local players = GetPlayers()
        for _, playerId in ipairs(players) do
            local staffId = vRP.Passport(tonumber(playerId))
            if staffId and vRP.HasGroup(staffId, "Admin") then
                TriggerClientEvent("ps_staff:playerChanged", tonumber(playerId), {
                    type = "join",
                    user_id = user_id,
                    source = source
                })
            end
        end
    end
end)

-- Evento para quando um player sai do servidor
AddEventHandler("playerDropped", function(reason)
    local source = source
    local user_id = vRP.Passport(source)
    
    if user_id and user_id > 0 then
        -- Notificar todos os staffs online sobre o player que saiu
        local players = GetPlayers()
        for _, playerId in ipairs(players) do
            local staffId = vRP.Passport(tonumber(playerId))
            if staffId and vRP.HasGroup(staffId, "Admin") then
                TriggerClientEvent("ps_staff:playerChanged", tonumber(playerId), {
                    type = "leave",
                    user_id = user_id,
                    source = source,
                    reason = reason
                })
            end
        end
    end
end)