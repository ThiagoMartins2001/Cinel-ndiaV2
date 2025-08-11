-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES QUE ESTAVAM FALTANDO
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- getAllUsers
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.getAllUsers()
    local source = source
    local user_id = vRP.Passport(source)
    
    print("^3[PS_STAFF DEBUG] getAllUsers chamado para user_id:", tostring(user_id))
    
    if not user_id or user_id == 0 then
        print("^1[PS_STAFF] Erro: user_id inválido em getAllUsers")
        return {}
    end
    
    -- Verificar se o usuário tem permissão
    if not psRP.checkPermission() then
        print("^1[PS_STAFF] Usuário sem permissão em getAllUsers")
        return {}
    end
    
    local users = {}
    
    -- Buscar todos os usuários online
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        local playerUserId = vRP.Passport(tonumber(playerId))
        if playerUserId and playerUserId > 0 then
            users[tostring(playerUserId)] = {
                user_id = playerUserId,
                name = "Player #" .. tostring(playerUserId),
                online = true
            }
        end
    end
    
    print("^3[PS_STAFF DEBUG] Users retornados:", #players, "players online")
    return users
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- getAllGroups
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.getAllGroups()
    local source = source
    local user_id = vRP.Passport(source)
    
    print("^3[PS_STAFF DEBUG] getAllGroups chamado para user_id:", tostring(user_id))
    
    if not user_id or user_id == 0 then
        print("^1[PS_STAFF] Erro: user_id inválido em getAllGroups")
        return {}
    end
    
    -- Verificar se o usuário tem permissão
    if not psRP.checkPermission() then
        print("^1[PS_STAFF] Usuário sem permissão em getAllGroups")
        return {}
    end
    
    local groups = getAllGroups()
    print("^3[PS_STAFF DEBUG] Groups retornados:", #groups, "groups")
    return groups
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- getAllVehicles
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.getAllVehicles()
    local source = source
    local user_id = vRP.Passport(source)
    
    print("^3[PS_STAFF DEBUG] getAllVehicles chamado para user_id:", tostring(user_id))
    
    if not user_id or user_id == 0 then
        print("^1[PS_STAFF] Erro: user_id inválido em getAllVehicles")
        return {}
    end
    
    -- Verificar se o usuário tem permissão
    if not psRP.checkPermission() then
        print("^1[PS_STAFF] Usuário sem permissão em getAllVehicles")
        return {}
    end
    
    local vehicles = getAllVehicles()
    print("^3[PS_STAFF DEBUG] Vehicles retornados:", #vehicles, "vehicles")
    return vehicles
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- getAllItems
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.getAllItems()
    local source = source
    local user_id = vRP.Passport(source)
    
    print("^3[PS_STAFF DEBUG] getAllItems chamado para user_id:", tostring(user_id))
    
    if not user_id or user_id == 0 then
        print("^1[PS_STAFF] Erro: user_id inválido em getAllItems")
        return {}
    end
    
    -- Verificar se o usuário tem permissão
    if not psRP.checkPermission() then
        print("^1[PS_STAFF] Usuário sem permissão em getAllItems")
        return {}
    end
    
    local items = getAllItems()
    print("^3[PS_STAFF DEBUG] Items retornados:", #items, "items")
    return items
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- getChatMessages
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.getChatMessages()
    local source = source
    local user_id = vRP.Passport(source)
    
    print("^3[PS_STAFF DEBUG] getChatMessages chamado para user_id:", tostring(user_id))
    
    if not user_id or user_id == 0 then
        print("^1[PS_STAFF] Erro: user_id inválido em getChatMessages")
        return {}
    end
    
    -- Verificar se o usuário tem permissão
    if not psRP.checkPermission() then
        print("^1[PS_STAFF] Usuário sem permissão em getChatMessages")
        return {}
    end
    
    -- Retornar mensagens vazias por enquanto
    local messages = {}
    print("^3[PS_STAFF DEBUG] Chat messages retornados:", #messages, "messages")
    return messages
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- getChatStaffMessages
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.getChatStaffMessages()
    local source = source
    local user_id = vRP.Passport(source)
    
    print("^3[PS_STAFF DEBUG] getChatStaffMessages chamado para user_id:", tostring(user_id))
    
    if not user_id or user_id == 0 then
        print("^1[PS_STAFF] Erro: user_id inválido em getChatStaffMessages")
        return {}
    end
    
    -- Verificar se o usuário tem permissão
    if not psRP.checkPermission() then
        print("^1[PS_STAFF] Usuário sem permissão em getChatStaffMessages")
        return {}
    end
    
    -- Retornar mensagens vazias por enquanto
    local messages = {}
    print("^3[PS_STAFF DEBUG] Chat staff messages retornados:", #messages, "messages")
    return messages
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- getUser
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.getUser(id)
    print("^3[PS_STAFF DEBUG] getUser chamado com id:", tostring(id))
    local source = source
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
