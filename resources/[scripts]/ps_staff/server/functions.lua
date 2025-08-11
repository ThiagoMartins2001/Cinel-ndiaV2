-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy  = module("vrp","lib/Proxy")
local Tools  = module("vrp","lib/Tools")
local config = module(GetCurrentResourceName(),"config")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- variabless
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {}
local Spawn = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- database set
-----------------------------------------------------------------------------------------------------------------------------------------
DB = {}

DB.prepare = function(name, query)
    vRP.Prepare(name, query)
end

DB.execute = function(name, param)
    return vRP.Execute(name, param)
end

DB.query = function(name, param)
    return vRP.Query(name, param)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUERYES
-----------------------------------------------------------------------------------------------------------------------------------------
DB.prepare("ps_staff/all_users","SELECT I.*, U.* FROM vrp_user_identities AS I INNER JOIN vrp_users AS U ON U.id = I.user_id WHERE U.deleted = 0")
DB.prepare("ps_staff/get_warning_by_id","SELECT * FROM ps_staff_warnings WHERE id = @id")
-- DB.prepare("ps_staff/get_user_fines","SELECT SUM(Value) as total FROM fines WHERE Passport = @Passport")
-- DB.prepare("ps_staff/get_user_fines_details","SELECT * FROM fines WHERE Passport = @Passport ORDER BY id DESC")
-----------------------------------------------------------------------------------------------------------------------------------------
-- getUserSource
-----------------------------------------------------------------------------------------------------------------------------------------
getUserSource = function(user_id)
    return vRP.Source(tonumber(user_id))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getUserId
-----------------------------------------------------------------------------------------------------------------------------------------
getUserId = function(source)
    return vRP.Passport(source)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getUserIdentity
-----------------------------------------------------------------------------------------------------------------------------------------
getUserIdentity = function(user_id)
    return vRP.Identity(user_id)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getUserFullName
-----------------------------------------------------------------------------------------------------------------------------------------
getUserFullName = function(user_id)
    local identity = getUserIdentity(user_id)
    local name = identity.name
    return name
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getUserImage
-----------------------------------------------------------------------------------------------------------------------------------------
getUserImage = function(user_id)
    local identity = getUserIdentity(user_id)
    local image = config.UserImage -- identity.foto
    return image
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getUserFines
-----------------------------------------------------------------------------------------------------------------------------------------
getUserFines = function(user_id)
    -- Primeiro tentar buscar da tabela fines
    local result = exports.oxmysql:executeSync("SELECT SUM(Value) as total FROM fines WHERE Passport = @Passport", { Passport = user_id })
    
    if result and #result > 0 and result[1].total then
        return tonumber(result[1].total) or 0
    end
    
    -- Se não encontrar na tabela fines, buscar da tabela characters
    local charResult = DB.query("ps_staff/get_character_fines", { id = user_id })
    if charResult and #charResult > 0 and charResult[1].fines then
        return tonumber(charResult[1].fines) or 0
    end
    
    return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TESTE: Verificar dados na tabela fines
-----------------------------------------------------------------------------------------------------------------------------------------
testFinesTable = function()
    print("^3[PS_STAFF DEBUG] ===== TESTE TABELA FINES =====")
    
    -- Testar se há dados na tabela
    local allFines = exports.oxmysql:executeSync("SELECT COUNT(*) as total FROM fines")
    print("^3[PS_STAFF DEBUG] Total de registros na tabela fines: " .. tostring(allFines[1].total))
    
    -- Testar alguns registros
    local sampleFines = exports.oxmysql:executeSync("SELECT * FROM fines LIMIT 5")
    print("^3[PS_STAFF DEBUG] Amostra de registros: " .. json.encode(sampleFines))
    
    -- Testar se há multas para o user_id 1 especificamente
    local user1Fines = exports.oxmysql:executeSync("SELECT * FROM fines WHERE Passport = 1")
    print("^3[PS_STAFF DEBUG] Multas do user_id 1: " .. json.encode(user1Fines))
    
    -- Testar a soma das multas do user_id 1
    local user1Total = exports.oxmysql:executeSync("SELECT SUM(Value) as total FROM fines WHERE Passport = 1")
    print("^3[PS_STAFF DEBUG] Total de multas do user_id 1: " .. json.encode(user1Total))
    
    -- Testar se a tabela existe
    local tableExists = exports.oxmysql:executeSync("SHOW TABLES LIKE 'fines'")
    print("^3[PS_STAFF DEBUG] Tabela fines existe: " .. json.encode(tableExists))
    
    -- Testar estrutura da tabela
    local tableStructure = exports.oxmysql:executeSync("DESCRIBE fines")
    print("^3[PS_STAFF DEBUG] Estrutura da tabela fines: " .. json.encode(tableStructure))
    
    -- Testar se há algum registro com Passport = 1
    local anyUser1 = exports.oxmysql:executeSync("SELECT COUNT(*) as count FROM fines WHERE Passport = 1")
    print("^3[PS_STAFF DEBUG] Registros com Passport = 1: " .. json.encode(anyUser1))
    
    print("^3[PS_STAFF DEBUG] ===== FIM DO TESTE =====")
    
    return allFines[1].total
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TESTE: Inserir multa de teste
-----------------------------------------------------------------------------------------------------------------------------------------
insertTestFine = function()
    print("^3[PS_STAFF DEBUG] ===== INSERINDO MULTA DE TESTE =====")
    
    local result = exports.oxmysql:executeSync("INSERT INTO fines (Passport, Name, Date, Hour, Value, Message) VALUES (1, 'Multa de Teste', '2024-01-01', '12:00', 1000, 'Teste do sistema ps_staff')")
    print("^3[PS_STAFF DEBUG] Resultado da inserção: " .. json.encode(result))
    
    -- Verificar se foi inserida
    local checkFine = exports.oxmysql:executeSync("SELECT * FROM fines WHERE Passport = 1 AND Name = 'Multa de Teste'")
    print("^3[PS_STAFF DEBUG] Multa inserida: " .. json.encode(checkFine))
    
    print("^3[PS_STAFF DEBUG] ===== FIM DA INSERÇÃO =====")
    
    return result
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getProfission
-----------------------------------------------------------------------------------------------------------------------------------------
getProfission = function(user_id)
    local profission = 'Desempregado'
    local primary    = "job"-- vRP.getUserGroupByType(user_id,'job')
    local hie        = "hie" -- vRP.getUserGroupByType(user_id,'hie')

    if primary ~= '' then
        profission = primary
    end

    if hie ~= '' then
        profission = hie
    end

    return profission
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getVipName
-----------------------------------------------------------------------------------------------------------------------------------------
getVipName = function(user_id)
    local vip = "pass" -- vRP.getUserGroupByType(user_id,'pass')

    if vip == '' then
        vip = 'Nenhum'
    end

    return vip
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getStaffName
-----------------------------------------------------------------------------------------------------------------------------------------
getStaffName = function(user_id)
    local staff = "staff" -- vRP.getUserGroupByType(user_id,'staff')

    if staff == '' then
        staff = 'Nenhum'
    end

    return staff
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- getGroupLevelName
-----------------------------------------------------------------------------------------------------------------------------------------
getGroupLevelName = function(groupName, level)
    local levelNames = {
        	["PoliciaMilitar"] = {
            [1] = "Comandante",
            [2] = "Subcomandante",
            [3] = "Coronel",
            [4] = "TenenteCoronel",
            [5] = "Major",
            [6] = "Capitão",
            [7] = "1ºTenente",
            [8] = "2ºTenente",
            [9] = "Aspirante",
            [10] = "Subtenente",
            [11] = "1ºSargento",
            [12] = "2ºSargento",
            [13] = "3ºSargento",
            [14] = "Cabo",
            [15] = "Soldado",
            [16] = "Aluno"
        },
        ["Core"] = {
            [1] = "Comandante",
            [2] = "Subcomandante",
            [3] = "Coronel",
            [4] = "TenenteCoronel",
            [5] = "Major",
            [6] = "Capitão",
            [7] = "1ºTenente",
            [8] = "2ºTenente",
            [9] = "Aspirante",
            [10] = "Subtenente",
            [11] = "1ºSargento",
            [12] = "2ºSargento",
            [13] = "3ºSargento"
        },
        ["PRF"] = {
            [1] = "Delegado",
            [2] = "Subdelegado",
            [3] = "DelegadoAdjunto",
            [4] = "DelegadoAuxiliar",
            [5] = "Escrivão",
            [6] = "Investigador",
            [7] = "Agente"
        },
        ["PCivil"] = {
            [1] = "Delegado",
            [2] = "Subdelegado",
            [3] = "DelegadoAdjunto",
            [4] = "DelegadoAuxiliar",
            [5] = "Escrivão",
            [6] = "Investigador",
            [7] = "Agente"
        },
        ["Judiciario"] = {
            [1] = "Juiz",
            [2] = "Promotor",
            [3] = "Advogado"
        },
        ["Paramedic"] = {
            [1] = "Diretor Geral",
            [2] = "Diretor",
            [3] = "Coordenador",
            [4] = "Médico Chefe",
            [5] = "Médico",
            [6] = "Enfermeiro Chefe",
            [7] = "Enfermeiro",
            [8] = "Estagiário"
        },
        ["Mechanic"] = {
            [1] = "Proprietário",
            [2] = "Gerente",
            [3] = "Mecânico Chefe",
            [4] = "Mecânico Especialista",
            [5] = "Mecânico",
            [6] = "Aprendiz"
        },
        ["Taxi"] = {
            [1] = "Proprietário",
            [2] = "Gerente",
            [3] = "Motorista Chefe",
            [4] = "Motorista",
            [5] = "Aprendiz"
        },
        ["Driver"] = {
            [1] = "Proprietário",
            [2] = "Gerente",
            [3] = "Motorista Chefe",
            [4] = "Motorista",
            [5] = "Aprendiz"
        },
        ["Farmer"] = {
            [1] = "Proprietário",
            [2] = "Gerente",
            [3] = "Fazendeiro Chefe",
            [4] = "Fazendeiro",
            [5] = "Ajudante"
        },
        ["Fisherman"] = {
            [1] = "Proprietário",
            [2] = "Gerente",
            [3] = "Pescador Chefe",
            [4] = "Pescador",
            [5] = "Ajudante"
        },
        ["Miner"] = {
            [1] = "Proprietário",
            [2] = "Gerente",
            [3] = "Minerador Chefe",
            [4] = "Minerador",
            [5] = "Ajudante"
        },
        ["Lumberjack"] = {
            [1] = "Proprietário",
            [2] = "Gerente",
            [3] = "Lenhador Chefe",
            [4] = "Lenhador",
            [5] = "Ajudante"
        },
        ["Hunter"] = {
            [1] = "Proprietário",
            [2] = "Gerente",
            [3] = "Caçador Chefe",
            [4] = "Caçador",
            [5] = "Aprendiz"
        },
        ["Garbage"] = {
            [1] = "Proprietário",
            [2] = "Gerente",
            [3] = "Lixeiro Chefe",
            [4] = "Lixeiro",
            [5] = "Ajudante"
        },
        ["Trucker"] = {
            [1] = "Proprietário",
            [2] = "Gerente",
            [3] = "Caminhoneiro Chefe",
            [4] = "Caminhoneiro",
            [5] = "Ajudante"
        },
        ["TowDriver"] = {
            [1] = "Proprietário",
            [2] = "Gerente",
            [3] = "Guincho Chefe",
            [4] = "Guincho",
            [5] = "Ajudante"
        },
        ["Bus"] = {
            [1] = "Proprietário",
            [2] = "Gerente",
            [3] = "Motorista Chefe",
            [4] = "Motorista",
            [5] = "Aprendiz"
        }
    }
    
    if levelNames[groupName] and levelNames[groupName][level] then
        return levelNames[groupName][level]
    end
    
    return "Nível " .. tostring(level)
end


-----------------------------------------------------------------------------------------------------------------------------------------
-- getUsersList
-----------------------------------------------------------------------------------------------------------------------------------------
DB.prepare("ps_staff/all_users_weedzz","SELECT id, name, name2, phone, bank, prison, fines, cardlimit, spending, license, garage, locate, visa, sex, blood FROM characters ORDER BY id ASC")
DB.prepare("ps_staff/get_character_data","SELECT id, name, name2, phone, bank, prison, fines, cardlimit, spending, license, garage, locate, visa, sex, blood FROM characters WHERE id = @id")
DB.prepare("ps_staff/get_character_fines","SELECT fines FROM characters WHERE id = @id")
getUsersList = function()
    local rows = DB.query("ps_staff/all_users_weedzz", {})
    if #rows > 0 then
        local data = {}
        for k, v in pairs(rows) do
            local user_id = tonumber(v.id)
            
            -- Verificar se o ID é válido
            if user_id and user_id > 0 then
                local source = vRP.Source(user_id)
                local Identity = vRP.Identity(user_id)
                
                -- Verificar se Identity é válida ou usar dados da tabela characters
                if Identity and type(Identity) == "table" and Identity["name"] then
                    local userdata = {
                        user_id = user_id,
                        name    = Identity["name"],
                        online  = false
                    }

                    if source ~= nil then
                        userdata.online = true
                    end
                    table.insert(data, userdata)
                elseif v.name and v.name2 then
                    -- Usar dados da tabela characters se Identity não estiver disponível
                    local userdata = {
                        user_id = user_id,
                        name    = v.name.." "..v.name2,
                        online  = false,
                        phone   = v.phone or "N/A",
                        bank    = v.bank or 0,
                        prison  = v.prison or 0,
                        fines   = v.fines or 0,
                        cardlimit = v.cardlimit or 0,
                        spending = v.spending or 0,
                        license = v.license or "N/A",
                        garage  = v.garage or 0,
                        locate  = v.locate or "N/A",
                        visa    = v.visa or 0,
                        sex     = v.sex or "N/A",
                        blood   = v.blood or "N/A"
                    }

                    if source ~= nil then
                        userdata.online = true
                    end
                    table.insert(data, userdata)
                else
                    print("^3[PS_STAFF] Dados inválidos para user_id: " .. tostring(user_id))
                end
            else
                print("^3[PS_STAFF] ID inválido encontrado: " .. tostring(v.id))
            end
        end
        return data
    end
    return {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getUserInventory (BUSCAR INVENTÁRIO DO CHARACTER)
-----------------------------------------------------------------------------------------------------------------------------------------
getUserInventory = function(user_id)
    print("^3[PS_STAFF DEBUG] getUserInventory chamado para user_id: " .. tostring(user_id))
    
    local inventory = {}
    
    -- Buscar inventário usando vRP.Inventory
    local Inv = vRP.Inventory(user_id)
    print("^3[PS_STAFF DEBUG] Inventário obtido via vRP.Inventory:", Inv and "sim" or "não")
    
    if Inv then
        for Index, v in pairs(Inv) do
            if v and v.item and v.amount then
                local itemData = {
                    amount = parseInt(v.amount),
                    name = itemName(v.item),
                    peso = itemWeight(v.item),
                    index = itemIndex(v.item),
                    max = itemMaxAmount(v.item),
                    desc = itemDescription(v.item),
                    economy = parseFormat(itemEconomy(v.item)),
                    key = v.item,
                    slot = Index,
                    durability = 0,
                    days = 1,
                    image = getItemImage(v.item)
                }
                
                -- Verificar durabilidade se o item tiver timestamp
                local Split = splitString(v.item, "-")
                if Split[2] ~= nil then
                    if itemDurability(v.item) then
                        itemData.durability = parseInt(os.time() - Split[2])
                        itemData.days = itemDurability(v.item)
                    end
                end
                
                table.insert(inventory, itemData)
                print("^3[PS_STAFF DEBUG] Item processado:", v.item, "->", itemData.name, "Quantidade:", itemData.amount)
            end
        end
    end
    
    print("^3[PS_STAFF DEBUG] Total de itens no inventário:", #inventory)
    return inventory
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- getItemImage (OBTER URL DA IMAGEM DO ITEM)
-----------------------------------------------------------------------------------------------------------------------------------------
getItemImage = function(itemId)
    print("^3[PS_STAFF DEBUG] getItemImage chamado para item:", itemId)
    
    if not itemId then
        return config.UserImage -- Imagem padrão
    end
    
    -- Obter o índice do item
    local itemIdx = itemIndex(itemId)
    if not itemIdx then
        print("^1[PS_STAFF] Índice não encontrado para item:", itemId)
        return config.UserImage -- Imagem padrão
    end
    
    -- Construir URL da imagem
    local imageUrl = config.IPItems .. itemIdx .. ".png"
    print("^3[PS_STAFF DEBUG] URL da imagem gerada:", imageUrl)
    
    return imageUrl
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- getUserInfo 
-----------------------------------------------------------------------------------------------------------------------------------------
getUserInfo = function(user_id)
    print("^3[PS_STAFF DEBUG] getUserInfo chamado para user_id: " .. tostring(user_id))
    
    -- Buscar dados reais do player
    local Identity = vRP.Identity(user_id)
    print("^3[PS_STAFF DEBUG] Identity obtida:", Identity and "sim" or "não")
    
    local userdata = {
        user_id      = user_id,
        name         = Identity and (Identity.name or "NOME") .. " " .. (Identity.name2 or "SOBRENOME") or "Player #" .. tostring(user_id),
        phone        = Identity and Identity.phone or "N/A",
        registration = user_id,
        age          = "SEM REGISTRO",
        image        = config.UserImage,
        banned       = false,
        bank         = Identity and Identity.bank or 0,
        fines        = 0,
        inventory    = {},
        groups       = {},
        garage       = {},
        prison       = Identity and Identity.prison or 0,
        cardlimit    = Identity and Identity.cardlimit or 0,
        spending     = Identity and Identity.spending or 0,
        license      = Identity and Identity.license or "N/A",
        locate       = Identity and Identity.locate or "N/A",
        visa         = Identity and Identity.visa or 0,
        sex          = Identity and Identity.sex or "N/A",
        blood        = Identity and Identity.blood or "N/A"
    }
    
    -- Buscar grupos reais do player
    local groups = {}
    local Groups = vRP.Groups()
    print("^3[PS_STAFF DEBUG] Groups obtido:", Groups and "sim" or "não")
    
    if Groups then
        for Permission, _ in pairs(Groups) do
            local Data = vRP.DataGroups(Permission)
            if Data and Data[tostring(user_id)] then
                local groupLevel = Data[tostring(user_id)]
                local hierarchy = vRP.Hierarchy(Permission)
                local levelName = "Nível " .. tostring(groupLevel or 1)
                
                -- Buscar o nome correto do nível na hierarquia
                if hierarchy and hierarchy[groupLevel] then
                    levelName = hierarchy[groupLevel]
                end
                
                local groupdata = {
                    group = Permission,
                    name  = Permission,
                    level = groupLevel or 1,
                    levelName = levelName
                }

                table.insert(groups, groupdata)
                print("^3[PS_STAFF DEBUG] Grupo encontrado:", Permission, "Nível:", groupLevel)
            end
        end
    end
    
    userdata.groups = groups
    print("^3[PS_STAFF DEBUG] Total de grupos encontrados:", #groups)
    
    -- Buscar inventário real do player
    userdata.inventory = getUserInventory(user_id)
    print("^3[PS_STAFF DEBUG] userdata criado com sucesso")
    return userdata
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- getAllGroups
-----------------------------------------------------------------------------------------------------------------------------------------
getAllGroups = function()
    print("^3[PS_STAFF DEBUG] getAllGroups chamado")
    local listgroups = vRP.Groups()
    print("^3[PS_STAFF DEBUG] listgroups obtido:", listgroups and "sim" or "não")
    local groups = {}
    for k, v in pairs(listgroups) do
        local groupdata = {
            group = k,
            name  = k,
            hierarchy = v.Hierarchy or {}
        }
        table.insert(groups, groupdata)
    end
    return groups
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getAllVehicles
-----------------------------------------------------------------------------------------------------------------------------------------
getAllVehicles = function()
    local listvehicles = VehicleGlobal()
    local vehicles = {}
    local excludedClasses = { "Militares", "Helicópteros", "Aviões", "Trens", "Trailers", "Industriais" }
    
    for k, v in pairs(listvehicles) do
        local vehicleClass = VehicleClass(k)
        local exclude = false
        
        for _, class in ipairs(excludedClasses) do
            if vehicleClass == class then
                exclude = true
                break
            end
        end
        
        if not exclude then
            local vehicledata = {
                vehicle = k,
                name    = VehicleName(k)
            }
            table.insert(vehicles, vehicledata)
        end
    end
    return vehicles
end


-- Buscar itens da base de dados
function ItemListGlobal()
    print("^3[PS_STAFF DEBUG] Buscando itens na base de dados")
    
    local items = {}
    
    -- Tentar buscar itens usando diferentes métodos do VRP
    local success, result = pcall(function()
        -- Método 1: Tentar usar vRP.Items() se existir
        if vRP.Items then
            local vrpItems = vRP.Items()
            if vrpItems then
                print("^3[PS_STAFF DEBUG] Itens encontrados via vRP.Items():", #vrpItems)
                for itemName, itemData in pairs(vrpItems) do
                    items[itemName] = {
                        name = itemData.name or itemName,
                        index = itemData.index or itemName
                    }
                end
                return items
            end
        end
        
        -- Método 2: Tentar buscar na tabela de itens do banco
        if DB and DB.query then
            local rows = DB.query("SELECT * FROM items")
            if rows and #rows > 0 then
                print("^3[PS_STAFF DEBUG] Itens encontrados na tabela items:", #rows)
                for _, row in ipairs(rows) do
                    local itemName = row.name or row.item or row.id
                    if itemName then
                        items[itemName] = {
                            name = row.display_name or row.name or itemName,
                            index = row.index or itemName
                        }
                    end
                end
                return items
            end
        end
        
        -- Método 3: Tentar buscar na tabela vrp_items se existir
        if DB and DB.query then
            local rows = DB.query("SELECT * FROM vrp_items")
            if rows and #rows > 0 then
                print("^3[PS_STAFF DEBUG] Itens encontrados na tabela vrp_items:", #rows)
                for _, row in ipairs(rows) do
                    local itemName = row.name or row.item or row.id
                    if itemName then
                        items[itemName] = {
                            name = row.display_name or row.name or itemName,
                            index = row.index or itemName
                        }
                    end
                end
                return items
            end
        end
        
        -- Método 4: Tentar buscar na tabela inventory_items se existir
        if DB and DB.query then
            local rows = DB.query("SELECT * FROM inventory_items")
            if rows and #rows > 0 then
                print("^3[PS_STAFF DEBUG] Itens encontrados na tabela inventory_items:", #rows)
                for _, row in ipairs(rows) do
                    local itemName = row.name or row.item or row.id
                    if itemName then
                        items[itemName] = {
                            name = row.display_name or row.name or itemName,
                            index = row.index or itemName
                        }
                    end
                end
                return items
            end
        end
        
        -- Fallback: Lista básica de itens se nenhum método funcionar
        print("^1[PS_STAFF] Nenhum método funcionou, usando lista básica")
        return {
            ["water"] = { name = "Água", index = "water" },
            ["bread"] = { name = "Pão", index = "bread" },
            ["radio"] = { name = "Rádio", index = "radio" },
            ["cellphone"] = { name = "Celular", index = "cellphone" },
            ["money"] = { name = "Dinheiro", index = "money" },
            ["bank"] = { name = "Banco", index = "bank" }
        }
    end)
    
    if success and result then
        print("^3[PS_STAFF DEBUG] Total de itens encontrados:", #result)
        return result
    else
        print("^1[PS_STAFF] Erro ao buscar itens:", result)
        -- Retornar lista básica em caso de erro
        return {
            ["water"] = { name = "Água", index = "water" },
            ["bread"] = { name = "Pão", index = "bread" },
            ["radio"] = { name = "Rádio", index = "radio" },
            ["cellphone"] = { name = "Celular", index = "cellphone" }
        }
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- getAllItems
-----------------------------------------------------------------------------------------------------------------------------------------
getAllItems = function()
    print("^3[PS_STAFF DEBUG] getAllItems chamado")
    
    local listitems = ItemListGlobal()
    local items = {}
    
    for k, v in pairs(listitems) do
        local itemdata = {
            item  = k,
            name  = v.name or k,
            index = v.index or k
        }
        table.insert(items, itemdata)
        print("^3[PS_STAFF DEBUG] Item processado:", k, "->", v.name or k)
    end
    
    print("^3[PS_STAFF DEBUG] Total de itens retornados:", #items)
    return items
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- searchItems (BUSCAR ITENS POR NOME OU ID)
-----------------------------------------------------------------------------------------------------------------------------------------
searchItems = function(searchTerm)
    print("^3[PS_STAFF DEBUG] searchItems chamado com termo:", searchTerm)
    
    if not searchTerm or searchTerm == "" then
        print("^1[PS_STAFF] Termo de busca vazio")
        return {}
    end
    
    local allItems = getAllItems()
    local results = {}
    local searchLower = string.lower(searchTerm)
    
    for _, item in ipairs(allItems) do
        local itemNameLower = string.lower(item.name or "")
        local itemIdLower = string.lower(item.item or "")
        
        if string.find(itemNameLower, searchLower) or string.find(itemIdLower, searchLower) then
            table.insert(results, item)
            print("^3[PS_STAFF DEBUG] Item encontrado na busca:", item.item, "->", item.name)
        end
    end
    
    print("^3[PS_STAFF DEBUG] Total de resultados da busca:", #results)
    return results
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- getItemInfo (OBTER INFORMAÇÕES DE UM ITEM ESPECÍFICO)
-----------------------------------------------------------------------------------------------------------------------------------------
getItemInfo = function(itemId)
    print("^3[PS_STAFF DEBUG] getItemInfo chamado para item:", itemId)
    
    if not itemId then
        print("^1[PS_STAFF] ID do item não fornecido")
        return nil
    end
    
    local allItems = getAllItems()
    
    for _, item in ipairs(allItems) do
        if item.item == itemId then
            print("^3[PS_STAFF DEBUG] Item encontrado:", item.item, "->", item.name)
            return item
        end
    end
    
    print("^1[PS_STAFF] Item não encontrado:", itemId)
    return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- addUserGroup
-----------------------------------------------------------------------------------------------------------------------------------------
addUserGroup = function(user_id, group, level)
    level = tonumber(level) or 1
    vRP.SetPermission(user_id, group, level)
    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- remUserGroup
-----------------------------------------------------------------------------------------------------------------------------------------
remUserGroup = function(user_id, group)
    local source = vRP.Soruce(user_id)
    if source then
        vRP.RemovePermission(user_id,group)
    end
    -- if source then
    --     vRP.removeUserGroup(user_id, group)
    -- else
    --     local data = vRP.query("vRP/get_userdata",{ user_id = user_id, key = "vRP:datatable" })
    --     if not data[1] then
    --         sendnotify(source,"negado","ID não encontrado no banco de dados")
    --         return false
    --     end
    --     local index = json.decode(data[1].dvalue)
    --     for k,v in pairs(index.groups) do
    --         if k == group then
    --             index.groups[k] = nil
    --         end
    --     end
    --     setUserData(user_id,"vRP:datatable",json.encode(index))
    -- end
    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getHasPermission
-----------------------------------------------------------------------------------------------------------------------------------------
getHasPermission = function(user_id, perm)
    return vRP.HasGroup(user_id,perm)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- hasPermission (para verificar permissões do config.lua)
-----------------------------------------------------------------------------------------------------------------------------------------
hasPermission = function(user_id, perm)
    local config = module(GetCurrentResourceName(),"config")
    
    -- Verificar se o usuário tem algum grupo que tenha a permissão
    for group, permissions in pairs(config.permissions) do
        if vRP.HasGroup(user_id, group) then
            if permissions[perm] then
                return true
            end
        end
    end
    
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getBankMoney
-----------------------------------------------------------------------------------------------------------------------------------------
getBankMoney = function(user_id)
    local source = vRP.Source(user_id)
    if source then
        return vRP.GetBank(user_id)
    -- else
    --     local rows = vRP.query("vRP/get_money",{ user_id = user_id })
	-- 	if #rows > 0 then
	-- 		return tonumber(rows[1].bank)
	-- 	end
    end
    return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- giveInventoryItem
-----------------------------------------------------------------------------------------------------------------------------------------
giveInventoryItem = function(user_id, item, amount)
    local source = vRP.Source(user_id)
    if source then
        -- vRP.giveInventoryItem(user_id, item, amount)
        vRP.GenerateItem(user_id,item,amount, true)
        return true
    end
    return false
end
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- getUserData
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- getUserData = function(user_id, key)
--     return vRP.getUData(user_id, key)
-- end
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- setUserData
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- setUserData = function(user_id, key, data)
--     vRP.setUData(user_id, key, data)
-- end


function ServerVehicleDurateston(Model, x, y, z, Heading, Plate, Nitrox, Doors, Body, Fuel)
    -- print("^3[PS_STAFF] Criando veículo: " .. Model .. " em " .. x .. ", " .. y .. ", " .. z)
    local Vehicle = CreateVehicle(Model, x, y, z, Heading, true, true)
    local attempts = 0
    while not DoesEntityExist(Vehicle) and attempts < 50 do
        Wait(100)
        attempts = attempts + 1
    end
    if DoesEntityExist(Vehicle) then
        -- print("^2[PS_STAFF] Veículo criado com sucesso: " .. Model)
        if Plate ~= nil then
            SetVehicleNumberPlateText(Vehicle, Plate)
        else
            Plate = vRP.GeneratePlate()
            SetVehicleNumberPlateText(Vehicle, Plate)
        end
        SetVehicleBodyHealth(Vehicle, Body + 0.0)
        if not Fuel then
            TriggerEvent("engine:tryFuel", Plate, 100)
        end
        if Doors then
            local DoorsDecoded = json.decode(Doors)
            if DoorsDecoded ~= nil then
                for Number, Status in pairs(DoorsDecoded) do
                    if Status then
                        SetVehicleDoorBroken(Vehicle, parseInt(Number), true)
                    end
                end
            end
        end
        local Network = NetworkGetNetworkIdFromEntity(Vehicle)
        if Model ~= "wheelchair" then
            local NetworkEntity = NetworkGetEntityFromNetworkId(Network)
            SetVehicleDoorsLocked(NetworkEntity, 2)
        end
        -- print("^2[PS_STAFF] Veículo configurado com sucesso. Network ID: " .. tostring(Network))
        return true, Network, Vehicle
    else
        -- print("^1[PS_STAFF] Falha ao criar veículo: " .. Model)
        return false
    end
end


-----------------------------------------------------------------------------------------------------------------------------------------
-- spawnVehicle
-----------------------------------------------------------------------------------------------------------------------------------------
vCLIENT = Tunnel.getInterface("ps_staff")
spawnVehicle = function(user_id, vehicle)
    local source = vRP.Source(user_id)
    if not source then
        -- print("^1[PS_STAFF] Erro: Source não encontrado para user_id: " .. tostring(user_id))
        return false
    end
    local Passport = vRP.Passport(source)
    if not Passport then
        -- print("^1[PS_STAFF] Erro: Passport não encontrado para source: " .. tostring(source))
        return false
    end
    if not vehicle then
        -- print("^1[PS_STAFF] Erro: Veículo inválido: " .. tostring(vehicle))
        return false
    end
    local VehicleName = vehicle
    local Ped = GetPlayerPed(source)
    local Coords = GetEntityCoords(Ped)
    local Heading = GetEntityHeading(Ped)
    local Plate = "VEH"..(10000 + Passport)
    -- print("^3[PS_STAFF] Tentando spawnar veículo: " .. VehicleName .. " para user_id: " .. tostring(user_id))
    local Exist, Network, Vehicle = ServerVehicleDurateston(VehicleName, Coords["x"], Coords["y"], Coords["z"], Heading, Plate, 2000, nil, 1000)
    if not Exist then
        -- print("^1[PS_STAFF] Erro: Falha ao criar veículo: " .. VehicleName)
        return false
    end
    -- print("^2[PS_STAFF] Veículo criado com sucesso: " .. VehicleName .. " - Network: " .. tostring(Network))
    vCLIENT.CreateVehicleDurateston(-1, VehicleName, Network, 1000, 1000, nil, false, false)
    if not Spawn then
        Spawn = {}
    end
    Spawn[Plate] = { Passport, VehicleName, Network }
    TriggerEvent("engine:tryFuel", Plate, 100)
    SetPedIntoVehicle(Ped, Vehicle, -1)
    if not GlobalState["Plates"] then
        GlobalState:set("Plates", {}, true)
    end
    local Plates = GlobalState["Plates"]
    Plates[Plate] = Passport
    GlobalState:set("Plates", Plates, true)
    -- print("^2[PS_STAFF] Veículo spawnado com sucesso para user_id: " .. tostring(user_id))
    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- addVehicle
-----------------------------------------------------------------------------------------------------------------------------------------
addVehicle = function(user_id, vehicle)
    -- DB.execute("ps_resources/add_vehicle",{ user_id = user_id, vehicle = vehicle, plate = vRP.generatePlateNumber(), ipva = os.time() })
    vRP.Query("vehicles/addVehicles",{ Passport = user_id, vehicle = vehicle, plate = vRP.GeneratePlate(), work = "false" })
    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- sendnotify
-----------------------------------------------------------------------------------------------------------------------------------------
sendnotify = function(source, type, message, time)
    if time == nil then
        time = 8000
    end
    if source then 
        TriggerClientEvent("Notify",source,type,message,time)
    end
end

getUserGarage = function(user_id)
    local vehicles = {}
    local result = exports.oxmysql:executeSync("SELECT vehicle, plate FROM vehicles WHERE Passport = @Passport", { Passport = user_id })
    if result and #result > 0 then
        for _, v in ipairs(result) do
            -- Usar VehicleName para obter o nome amigável do veículo
            local friendlyName = v.vehicle
            if type(VehicleName) == "function" then
                friendlyName = VehicleName(v.vehicle)
            end
            table.insert(vehicles, {
                vehicle = v.vehicle,
                plate = v.plate,
                name = friendlyName
            })
        end
    end
    return vehicles
end