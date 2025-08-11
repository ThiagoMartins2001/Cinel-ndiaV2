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
Tunnel.bindInterface("mdt",cRP)
vCLIENT = Tunnel.getInterface("mdt")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARES
-----------------------------------------------------------------------------------------------------------------------------------------
-- Tabelas existentes do sistema policial - ADAPTADAS PARA A FRAMEWORK ATUAL
vRP.Prepare("prison/cleanRecords","DELETE FROM prison WHERE nuser_id = @nuser_id")
vRP.Prepare("prison/getRecords","SELECT * FROM prison WHERE nuser_id = @nuser_id ORDER BY id DESC")
vRP.Prepare("prison/getRecords2","SELECT * FROM prison WHERE id = @id ORDER BY id DESC")
vRP.Prepare("prison/insertPrison","INSERT INTO prison(police,nuser_id,services,fines,text,date) VALUES(@police,@nuser_id,@services,@fines,@text,@date)")

vRP.Prepare("prison/insertPort","INSERT INTO port(identity,user_id,portType,serial,nidentity,date,exam) VALUES(@identity,@user_id,@portType,@serial,@nidentity,@date,@exam)")
vRP.Prepare("prison/getPorts","SELECT * FROM port ORDER BY portId DESC")
vRP.Prepare("prison/getPorts2","SELECT * FROM port WHERE portId = @portId")
vRP.Prepare("prison/updatePort","UPDATE port SET identity = @identity,user_id = @user_id,portType = @portType,serial = @serial,nidentity = @nidentity,date = @date,exam = @exam WHERE portId = @portId")
vRP.Prepare("prison/deletePort","DELETE FROM port WHERE portId = @portId")

vRP.Prepare("prison/getReports","SELECT * FROM reports ORDER BY id DESC")
vRP.Prepare("prison/getReportById","SELECT * FROM reports WHERE id = @id")
vRP.Prepare("prison/setReportSolved","UPDATE reports SET solved = 1, updated_at = @updated_at WHERE id = @id")
vRP.Prepare("prison/insertReport","INSERT INTO reports(victim_id, police_name, solved, victim_name, created_at, victim_report, updated_at) VALUES(@victim_id, @police_name, @solved, @victim_name, @created_at, @victim_report, @updated_at)")
vRP.Prepare("prison/deleteReport","DELETE FROM reports WHERE id = @id")

vRP.Prepare("prison/getWarrants","SELECT * FROM warrants ORDER BY id DESC")
vRP.Prepare("prison/getWarrants2","SELECT * FROM warrants WHERE id = @id")
vRP.Prepare("prison/deleteWarrant","DELETE FROM warrants WHERE id = @id")
vRP.Prepare("prison/insertWarrant","INSERT INTO warrants(user_id, identity, status, nidentity, timeStamp, reason) VALUES(@user_id, @identity, @status, @nidentity, @timeStamp, @reason)")

-- Novas tabelas para o MDT
vRP.Prepare("mdt/createUsers","CREATE TABLE IF NOT EXISTS `mdt_users` (`id` int(11) NOT NULL AUTO_INCREMENT, `passport` int(11) NOT NULL, `username` varchar(50) NOT NULL, `password` varchar(255) NOT NULL, `name` varchar(100) NOT NULL, `rank` varchar(50) NOT NULL, `department` varchar(50) NOT NULL, `created_at` timestamp DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;")

vRP.Prepare("mdt/createAnnouncements","CREATE TABLE IF NOT EXISTS `mdt_announcements` (`id` int(11) NOT NULL AUTO_INCREMENT, `title` varchar(200) NOT NULL, `content` text NOT NULL, `author` varchar(100) NOT NULL, `created_at` timestamp DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;")

vRP.Prepare("mdt/createImpoundedVehicles","CREATE TABLE IF NOT EXISTS `mdt_impounded_vehicles` (`id` int(11) NOT NULL AUTO_INCREMENT, `plate` varchar(10) NOT NULL, `model` varchar(50) NOT NULL, `reason` text NOT NULL, `officer` varchar(100) NOT NULL, `impounded_at` timestamp DEFAULT CURRENT_TIMESTAMP, `released_at` timestamp NULL, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;")

vRP.Prepare("mdt/createServiceLogs","CREATE TABLE IF NOT EXISTS `mdt_service_logs` (`id` int(11) NOT NULL AUTO_INCREMENT, `passport` int(11) NOT NULL, `officer_name` varchar(100) NOT NULL, `action` enum('entrada','saida') NOT NULL, `timestamp` timestamp DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;")

-- Criar tabelas que podem não existir
vRP.Prepare("mdt/createPrisonTable","CREATE TABLE IF NOT EXISTS `prison` (`id` int(11) NOT NULL AUTO_INCREMENT, `police` varchar(100) NOT NULL, `nuser_id` int(11) NOT NULL, `services` int(11) DEFAULT 0, `fines` int(11) DEFAULT 0, `text` text, `date` timestamp DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;")

vRP.Prepare("mdt/createWarrantsTable","CREATE TABLE IF NOT EXISTS `warrants` (`id` int(11) NOT NULL AUTO_INCREMENT, `user_id` int(11) NOT NULL, `identity` varchar(100) NOT NULL, `status` enum('active','inactive') DEFAULT 'active', `nidentity` varchar(100) NOT NULL, `timeStamp` timestamp DEFAULT CURRENT_TIMESTAMP, `reason` text, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;")

vRP.Prepare("mdt/createReportsTable","CREATE TABLE IF NOT EXISTS `reports` (`id` int(11) NOT NULL AUTO_INCREMENT, `victim_id` int(11) NOT NULL, `police_name` varchar(100) NOT NULL, `solved` tinyint(1) DEFAULT 0, `victim_name` varchar(100) NOT NULL, `created_at` timestamp DEFAULT CURRENT_TIMESTAMP, `victim_report` text, `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;")

vRP.Prepare("mdt/createPortTable","CREATE TABLE IF NOT EXISTS `port` (`portId` int(11) NOT NULL AUTO_INCREMENT, `identity` varchar(100) NOT NULL, `user_id` int(11) NOT NULL, `portType` varchar(50) NOT NULL, `serial` varchar(50) NOT NULL, `nidentity` varchar(100) NOT NULL, `date` timestamp DEFAULT CURRENT_TIMESTAMP, `exam` text, PRIMARY KEY (`portId`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;")

-- Queries para o MDT
vRP.Prepare("mdt/insertUser","INSERT INTO mdt_users(passport,username,password,name,rank,department) VALUES(@passport,@username,@password,@name,@rank,@department)")
vRP.Prepare("mdt/getUserByUsername","SELECT * FROM mdt_users WHERE username = @username")
vRP.Prepare("mdt/getUserByPassport","SELECT * FROM mdt_users WHERE passport = @passport")

vRP.Prepare("mdt/insertAnnouncement","INSERT INTO mdt_announcements(title,content,author) VALUES(@title,@content,@author)")
vRP.Prepare("mdt/getAnnouncements","SELECT * FROM mdt_announcements ORDER BY created_at DESC")
vRP.Prepare("mdt/deleteAnnouncement","DELETE FROM mdt_announcements WHERE id = @id")

vRP.Prepare("mdt/insertImpoundedVehicle","INSERT INTO mdt_impounded_vehicles(plate,model,reason,officer) VALUES(@plate,@model,@reason,@officer)")
vRP.Prepare("mdt/getImpoundedVehicles","SELECT * FROM mdt_impounded_vehicles WHERE released_at IS NULL ORDER BY impounded_at DESC")
vRP.Prepare("mdt/releaseVehicle","UPDATE mdt_impounded_vehicles SET released_at = CURRENT_TIMESTAMP WHERE plate = @plate")

vRP.Prepare("mdt/insertServiceLog","INSERT INTO mdt_service_logs(passport,officer_name,action) VALUES(@passport,@officer_name,@action)")
vRP.Prepare("mdt/getServiceLogs","SELECT * FROM mdt_service_logs WHERE passport = @passport ORDER BY timestamp DESC LIMIT 1")

-- Estatísticas adaptadas para usar as tabelas existentes
vRP.Prepare("mdt/getPrisonStats","SELECT COUNT(*) as total FROM prison WHERE DATE(date) = CURDATE()")
vRP.Prepare("mdt/getFineStats","SELECT COUNT(*) as total FROM fines WHERE DATE(date) = CURDATE()")
vRP.Prepare("mdt/getWarrantStats","SELECT COUNT(*) as total FROM warrants WHERE status = 'active'")
vRP.Prepare("mdt/getVehicleStats","SELECT COUNT(*) as total FROM mdt_impounded_vehicles WHERE released_at IS NULL")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATETABLES
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    -- Criar tabelas que podem não existir
    vRP.Query("mdt/createPrisonTable")
    vRP.Query("mdt/createWarrantsTable")
    vRP.Query("mdt/createReportsTable")
    vRP.Query("mdt/createPortTable")
    
    -- Criar tabelas do MDT
    vRP.Query("mdt/createUsers")
    vRP.Query("mdt/createAnnouncements")
    vRP.Query("mdt/createImpoundedVehicles")
    vRP.Query("mdt/createServiceLogs")
    
    -- Inserir usuário padrão se não existir
    local userExists = vRP.Query("mdt/getUserByUsername", { username = "admin" })
    if #userExists == 0 then
        vRP.Query("mdt/insertUser", {
            passport = 1,
            username = "admin",
            password = "admin123",
            name = "Administrador",
            rank = "Comandante",
            department = "P.Militar"
        })
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkPermission()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        -- Verificar se o usuário tem permissão de polícia (independente do status de serviço)
        -- Isso permite que policiais fora de serviço possam abrir o MDT para entrar em serviço
        	return vRP.HasGroup(Passport,"PoliciaMilitar") or vRP.HasGroup(Passport,"Core") or vRP.HasGroup(Passport,"PRF") or vRP.HasGroup(Passport,"PCivil")
    end
    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- AUTHENTICATE USER
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.authenticateUser(passport, department)
    local source = source
    local userPassport = vRP.Passport(source)
    
    print("^3[MDT DEBUG] authenticateUser chamado^7")
    print("^3[MDT DEBUG] source: " .. tostring(source) .. "^7")
    print("^3[MDT DEBUG] userPassport: " .. tostring(userPassport) .. "^7")
    print("^3[MDT DEBUG] passport fornecido: " .. tostring(passport) .. "^7")
    print("^3[MDT DEBUG] department: " .. tostring(department) .. "^7")
    
    if not userPassport then
        print("^1[MDT DEBUG] Usuário não identificado^7")
        return { success = false, message = "Usuário não identificado." }
    end
    
    -- Verificar se o passaporte fornecido existe na tabela characters
    local character = vRP.Query("characters/Person", { id = passport })
    print("^3[MDT DEBUG] Resultado da query characters: " .. tostring(#character) .. " registros^7")
    
    if #character == 0 then
        print("^1[MDT DEBUG] Passaporte não encontrado na base de dados^7")
        return { success = false, message = "Passaporte não encontrado na base de dados." }
    end
    
    local person = character[1]
    print("^3[MDT DEBUG] Person encontrado: " .. tostring(person.name) .. "^7")
    
    -- Verificar se o usuário tem permissão para o departamento especificado
    local hasPermission = false
    		if department == "PoliciaMilitar" and vRP.HasGroup(userPassport, "PoliciaMilitar") then
        hasPermission = true
        print("^2[MDT DEBUG] Usuário tem permissão Police^7")
    elseif department == "Pcivil" and vRP.HasGroup(userPassport, "PCivil") then
        hasPermission = true
        print("^2[MDT DEBUG] Usuário tem permissão PCivil^7")
    elseif department == "Core" and vRP.HasGroup(userPassport, "Core") then
        hasPermission = true
        print("^2[MDT DEBUG] Usuário tem permissão Core^7")
    elseif department == "PRF" and vRP.HasGroup(userPassport, "PRF") then
        hasPermission = true
        print("^2[MDT DEBUG] Usuário tem permissão PRF^7")
    end
    
    if not hasPermission then
        print("^1[MDT DEBUG] Usuário não tem permissão para o departamento^7")
        return { success = false, message = "Você não tem permissão para acessar este departamento." }
    end
    
    -- Verificar se o personagem tem permissão para o departamento
    local characterHasPermission = false
    		if department == "PoliciaMilitar" and vRP.HasGroup(passport, "PoliciaMilitar") then
        characterHasPermission = true
        print("^2[MDT DEBUG] Personagem tem permissão Police^7")
    elseif department == "Pcivil" and vRP.HasGroup(passport, "PCivil") then
        characterHasPermission = true
        print("^2[MDT DEBUG] Personagem tem permissão PCivil^7")
    elseif department == "Core" and vRP.HasGroup(passport, "Core") then
        characterHasPermission = true
        print("^2[MDT DEBUG] Personagem tem permissão Core^7")
    elseif department == "PRF" and vRP.HasGroup(passport, "PRF") then
        characterHasPermission = true
        print("^2[MDT DEBUG] Personagem tem permissão PRF^7")
    end
    
    if not characterHasPermission then
        print("^1[MDT DEBUG] Personagem não pertence ao departamento^7")
        return { success = false, message = "Este personagem não pertence ao departamento especificado." }
    end
    
    -- Determinar a patente baseada no grupo
    local rank = "Oficial"
    if vRP.HasGroup(passport, "Comandante") then
        rank = "Comandante"
    elseif vRP.HasGroup(passport, "Tenente") then
        rank = "Tenente"
    elseif vRP.HasGroup(passport, "Sargento") then
        rank = "Sargento"
    elseif vRP.HasGroup(passport, "Cabo") then
        rank = "Cabo"
    elseif vRP.HasGroup(passport, "Soldado") then
        rank = "Soldado"
    end
    
    print("^2[MDT DEBUG] Rank determinado: " .. rank .. "^7")
    
    -- Retornar dados do usuário autenticado
    local result = {
        success = true,
        user = {
            passport = passport,
            name = person.name,
            rank = rank,
            department = department
        }
    }
    
    print("^2[MDT DEBUG] Retornando resultado de sucesso^7")
    return result
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOGIN
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.login(username, password)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local user = vRP.Query("mdt/getUserByUsername", { username = username })
        if #user > 0 then
            if user[1].password == password then
                return { success = true, data = user[1] }
            else
                return { success = false, message = "Senha incorreta" }
            end
        else
            return { success = false, message = "Usuário não encontrado" }
        end
    end
    return { success = false, message = "Erro de autenticação" }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOGOUT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.logout()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        -- Log de logout
        local user = vRP.Query("mdt/getUserByPassport", { passport = Passport })
        if #user > 0 then
            vRP.Query("mdt/insertServiceLog", {
                passport = Passport,
                officer_name = user[1].name,
                action = "saida"
            })
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLESERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.toggleService()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local user = vRP.Query("mdt/getUserByPassport", { passport = Passport })
        if #user > 0 then
            -- Verificar se o usuário tem permissão de polícia
            if vRP.HasGroup(Passport,"PoliciaMilitar") or vRP.HasGroup(Passport,"Core") or vRP.HasGroup(Passport,"PRF") or vRP.HasGroup(Passport,"PCivil") then
                -- Verificar se está em serviço usando vRP.HasService
                local isInService = vRP.HasService(Passport,"PoliciaMilitar") or vRP.HasService(Passport,"Core") or vRP.HasService(Passport,"PRF") or vRP.HasService(Passport,"PCivil")
                
                if isInService then
                    -- Sair de serviço
                    if vRP.HasGroup(Passport,"PoliciaMilitar") then
                        vRP.ServiceLeave(source, Passport, "PoliciaMilitar", false)
                    elseif vRP.HasGroup(Passport,"Core") then
                        vRP.ServiceLeave(source, Passport, "Core", false)
                    elseif vRP.HasGroup(Passport,"PRF") then
                        vRP.ServiceLeave(source, Passport, "PRF", false)
                    elseif vRP.HasGroup(Passport,"PCivil") then
                        vRP.ServiceLeave(source, Passport, "PCivil", false)
                    end
                    
                    -- Registrar log de saída
                    vRP.Query("mdt/insertServiceLog", {
                        passport = Passport,
                        officer_name = user[1].name,
                        action = "saida"
                    })
                    
                    -- Notificar clientes sobre mudança de serviço
                    TriggerClientEvent("police:updateService", source, false)
                    
                    return { inService = false }
                else
                    -- Entrar em serviço
                    if vRP.HasGroup(Passport,"PoliciaMilitar") then
                        vRP.ServiceEnter(source, Passport, "PoliciaMilitar", false)
                    elseif vRP.HasGroup(Passport,"Core") then
                        vRP.ServiceEnter(source, Passport, "Core", false)
                    elseif vRP.HasGroup(Passport,"PRF") then
                        vRP.ServiceEnter(source, Passport, "PRF", false)
                    elseif vRP.HasGroup(Passport,"PCivil") then
                        vRP.ServiceEnter(source, Passport, "PCivil", false)
                    end
                    
                    -- Registrar log de entrada
                    vRP.Query("mdt/insertServiceLog", {
                        passport = Passport,
                        officer_name = user[1].name,
                        action = "entrada"
                    })
                    
                    -- Notificar clientes sobre mudança de serviço
                    TriggerClientEvent("police:updateService", source, true)
                    
                    return { inService = true }
                end
            else
                TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissão para usar o MDT.", "Erro", 5000)
                return { inService = false }
            end
        end
    end
    return { inService = false }
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GETSERVICESTATUS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getServiceStatus()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        -- Verificar se está em serviço usando vRP.HasService
        local isInService = vRP.HasService(Passport,"PoliciaMilitar") or vRP.HasService(Passport,"Core") or vRP.HasService(Passport,"PRF") or vRP.HasService(Passport,"PCivil")
        
        return { inService = isInService }
    end
    return { inService = false }
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERINFO
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getUserInfo()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local user = vRP.Query("mdt/getUserByPassport", { passport = Passport })
        if #user > 0 then
            return {
                name = user[1].name,
                rank = user[1].rank or "Oficial"
            }
        end
    end
    return {
        name = "Usuário Desconhecido",
        rank = "N/A"
    }
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCHUSER
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.searchUser(passport)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        -- Buscar na tabela characters por ID
        local character = vRP.Query("characters/Person", { id = passport })
        if character and #character > 0 then
            local user = character[1]
            local prisonRecords = vRP.Query("prison/getRecords", { nuser_id = passport })
            local warrants = vRP.Query("prison/getWarrants")
            local userWarrants = {}
            
            for k,v in pairs(warrants) do
                if v.user_id == tostring(passport) then
                    table.insert(userWarrants, v)
                end
            end
            
            -- Buscar multas em débito do cidadão
            local allFines = vRP.Query("fines/GetAll")
            local userFines = {}
            local totalFines = 0
            
            for _, fine in ipairs(allFines) do
                if tostring(fine.Passport) == tostring(passport) then
                    table.insert(userFines, fine)
                    totalFines = totalFines + (fine.Value or 0)
                end
            end
            
            -- Formatar dados do usuário para compatibilidade com a framework atual
            local formattedUser = {
                name = user.name .. " " .. user.name2,
                passport = user.id,
                phone = user.phone or "N/A",
                email = "N/A", -- characters table não tem email
                totalFines = totalFines,
                finesCount = #userFines
            }
            
            return {
                user = formattedUser,
                prisonRecords = prisonRecords,
                warrants = userWarrants,
                fines = userFines
            }
        end
    end
    return nil
end


function cRP.initFine(passport, fines, text, license, article, infraction, description)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local user = vRP.Query("mdt/getUserByPassport", { passport = Passport })
        if #user > 0 then
            -- Buscar dados do cidadão
            local character = vRP.Query("characters/Person", { id = passport })
            if character and #character > 0 then
                local targetUser = character[1]
                local fullName = targetUser.name .. " " .. targetUser.name2
                
                -- Criar mensagem completa com informações do código penal
                local completeMessage = ""
                if article and infraction then
                    completeMessage = completeMessage .. "**Artigo:** " .. article .. "\n"
                    completeMessage = completeMessage .. "**Infração:** " .. infraction .. "\n"
                end
                if description then
                    completeMessage = completeMessage .. "**Descrição:** " .. description .. "\n"
                end
                if text and text ~= "" then
                    completeMessage = completeMessage .. "**Observações:** " .. text .. "\n"
                end
                
                -- Aplicar multa usando a tabela fines
                vRP.Query("fines/Add", {
                    Passport = passport,
                    Name = fullName,
                    Date = os.date("%d/%m/%Y"),
                    Hour = os.date("%H:%M"),
                    Value = fines,
                    Message = completeMessage
                })
                
                -- Atualizar estatísticas do dashboard
                TriggerClientEvent("Notify", source, "sucesso", "Multa aplicada com sucesso.")
            else
                TriggerClientEvent("Notify", source, "negado", "Cidadão não encontrado.")
            end
        end
    end
end

function cRP.initPrisonFine(passport, fines, text, license, article, infraction, description, prisonTime)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local user = vRP.Query("mdt/getUserByPassport", { passport = Passport })
        if #user > 0 then
            -- Buscar dados do cidadão
            local character = vRP.Query("characters/Person", { id = passport })
            if character and #character > 0 then
                local targetUser = character[1]
                local fullName = targetUser.name .. " " .. targetUser.name2
                
                -- Criar mensagem completa com informações do código penal e tempo de prisão
                local completeMessage = ""
                if article and infraction then
                    completeMessage = completeMessage .. "**Artigo:** " .. article .. "\n"
                    completeMessage = completeMessage .. "**Infração:** " .. infraction .. "\n"
                end
                if description then
                    completeMessage = completeMessage .. "**Descrição:** " .. description .. "\n"
                end
                if prisonTime and prisonTime > 0 then
                    completeMessage = completeMessage .. "**Prisão:** " .. prisonTime .. " meses\n"
                end
                if text and text ~= "" then
                    completeMessage = completeMessage .. "**Observações:** " .. text .. "\n"
                end
                
                -- Aplicar multa usando a tabela fines
                vRP.Query("fines/Add", {
                    Passport = passport,
                    Name = fullName,
                    Date = os.date("%d/%m/%Y"),
                    Hour = os.date("%H:%M"),
                    Value = fines,
                    Message = completeMessage
                })
                
                -- Atualizar estatísticas do dashboard
                TriggerClientEvent("Notify", source, "sucesso", "Multa com prisão aplicada com sucesso.")
            else
                TriggerClientEvent("Notify", source, "negado", "Cidadão não encontrado.")
            end
        end
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- WARRANT FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.setWarrant(passport, text)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local user = vRP.Query("mdt/getUserByPassport", { passport = Passport })
        if #user > 0 then
            -- Buscar dados do cidadão usando a estrutura atual
            local character = vRP.Query("characters/Person", { id = passport })
            if character and #character > 0 then
                local targetUser = character[1]
                local fullName = targetUser.name .. " " .. targetUser.name2
                vRP.Query("prison/insertWarrant", {
                    user_id = passport,
                    identity = fullName,
                    status = "active",
                    nidentity = user[1].name,
                    timeStamp = os.date("%Y-%m-%d %H:%M:%S"),
                    reason = text
                })
                TriggerClientEvent("Notify", source, "sucesso", "Mandado de busca registrado.")
            end
        end
    end
end

function cRP.deleteWarrant(id)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        vRP.Query("prison/deleteWarrant", { id = id })
        TriggerClientEvent("Notify", source, "sucesso", "Mandado removido.")
    end
end

function cRP.getWarrants()
    return vRP.Query("prison/getWarrants")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PORT FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.givePort(passport, serial, status, exam)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local user = vRP.Query("mdt/getUserByPassport", { passport = Passport })
        if #user > 0 then
            -- Buscar dados do cidadão usando a estrutura atual
            local character = vRP.Query("characters/Person", { id = passport })
            if character and #character > 0 then
                local targetUser = character[1]
                local fullName = targetUser.name .. " " .. targetUser.name2
                vRP.Query("prison/insertPort", {
                    identity = fullName,
                    user_id = passport,
                    portType = "Arma de Fogo",
                    serial = serial,
                    nidentity = user[1].name,
                    date = os.date("%Y-%m-%d %H:%M:%S"),
                    exam = exam
                })
                TriggerClientEvent("Notify", source, "sucesso", "Porte registrado.")
            end
        end
    end
end

function cRP.editPort(id, passport, serial, status, exam)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local user = vRP.Query("mdt/getUserByPassport", { passport = Passport })
        if #user > 0 then
            -- Buscar dados do cidadão usando a estrutura atual
            local character = vRP.Query("characters/Person", { id = passport })
            if character and #character > 0 then
                local targetUser = character[1]
                local fullName = targetUser.name .. " " .. targetUser.name2
                vRP.Query("prison/updatePort", {
                    portId = id,
                    identity = fullName,
                    user_id = passport,
                    portType = "Arma de Fogo",
                    serial = serial,
                    nidentity = user[1].name,
                    date = os.date("%Y-%m-%d %H:%M:%S"),
                    exam = exam
                })
                TriggerClientEvent("Notify", source, "sucesso", "Porte atualizado.")
            end
        end
    end
end

function cRP.deletePort(id)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        vRP.Query("prison/deletePort", { portId = id })
        TriggerClientEvent("Notify", source, "sucesso", "Porte removido.")
    end
end

function cRP.getPortById(id)
    return vRP.Query("prison/getPorts2", { portId = id })
end

function cRP.searchPort()
    return vRP.Query("prison/getPorts")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPORT FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getReports()
    return vRP.Query("prison/getReports")
end

function cRP.getReportById(id)
    local result = vRP.Query("prison/getReportById", { id = id })
    if result and #result > 0 then
        return result[1]
    end
    return nil
end

function cRP.setReportSolved(id)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        vRP.Query("prison/setReportSolved", {
            id = id,
            updated_at = os.date("%Y-%m-%d %H:%M:%S")
        })
        TriggerClientEvent("Notify", source, "sucesso", "Relatório marcado como resolvido.")
    end
end

function cRP.insertReport(victim_id, victim_name, victim_report, officer_name, department, rank)
    local source = source
    local Passport = vRP.Passport(source)
    
    if Passport then
        -- Usar o nome do oficial fornecido pelo usuário ou determinar automaticamente
        local formattedOfficerName = officer_name or "Oficial"
        
        -- Se não foi fornecido um nome, determinar automaticamente
        if not officer_name or officer_name == "" then
            -- Obter o nome completo do personagem usando a estrutura atual
            local character = vRP.Query("characters/Person", { id = Passport })
            local fullName = "Oficial"
            
            if character and #character > 0 then
                local userData = character[1]
                fullName = userData.name .. " " .. userData.name2
            end
            
            -- Determinar o cargo/patente baseado no grupo
            local officerRank = rank or "Oficial"
            if vRP.HasGroup(Passport, "Comandante") then
                officerRank = "Comandante"
            elseif vRP.HasGroup(Passport, "Tenente") then
                officerRank = "Tenente"
            elseif vRP.HasGroup(Passport, "Sargento") then
                officerRank = "Sargento"
            elseif vRP.HasGroup(Passport, "Cabo") then
                officerRank = "Cabo"
            elseif vRP.HasGroup(Passport, "Soldado") then
                officerRank = "Soldado"
            end
            
            -- Formatar o nome do oficial no formato solicitado: "[Cargo] - [Nome do Personagem]"
            formattedOfficerName = officerRank .. " - " .. fullName
        end
        
        -- Adicionar informações do departamento e patente ao relatório
        local fullReport = victim_report
        if department and rank then
            fullReport = victim_report .. "\n\n---\nOficial: " .. formattedOfficerName .. "\nDepartamento: " .. department .. "\nPatente: " .. (rank or "Oficial")
        end
        
        vRP.Query("prison/insertReport", {
            victim_id = victim_id,
            police_name = formattedOfficerName,
            solved = "0",
            victim_name = victim_name,
            created_at = os.date("%Y-%m-%d %H:%M:%S"),
            victim_report = fullReport,
            updated_at = os.date("%Y-%m-%d %H:%M:%S")
        })
        TriggerClientEvent("Notify", source, "sucesso", "Relatório registrado.")
    end
end

function cRP.deleteReport(id)
    local source = source
    local Passport = vRP.Passport(source)
    
    if Passport then
        vRP.Query("prison/deleteReport", { id = id })
        TriggerClientEvent("Notify", source, "sucesso", "Relatório removido.")
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DASHBOARD FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getDashboardStats()
    local prisonStats = vRP.Query("mdt/getPrisonStats")
    local fineStats = vRP.Query("mdt/getFineStats")
    local warrantStats = vRP.Query("mdt/getWarrantStats")
    local vehicleStats = vRP.Query("mdt/getVehicleStats")
    
    return {
        prisons = prisonStats[1].total or 0,
        fines = fineStats[1].total or 0,
        warrants = warrantStats[1].total or 0,
        vehicles = vehicleStats[1].total or 0
    }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCEMENT FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getAnnouncements()
    return vRP.Query("mdt/getAnnouncements")
end

function cRP.addAnnouncement(title, content, author, department, rank)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        -- Usar dados fornecidos ou buscar do banco
        local authorName = author or "Oficial"
        if not author then
            local user = vRP.Query("mdt/getUserByPassport", { passport = Passport })
            if #user > 0 then
                authorName = user[1].name
            end
        end
        
        -- Adicionar informações do departamento e patente ao conteúdo
        local fullContent = content
        if department and rank then
            fullContent = content .. "\n\n---\nOficial: " .. authorName .. "\nDepartamento: " .. department .. "\nPatente: " .. rank
        end
        
        vRP.Query("mdt/insertAnnouncement", {
            title = title,
            content = fullContent,
            author = authorName
        })
        TriggerClientEvent("Notify", source, "sucesso", "Aviso publicado.")
    end
end

function cRP.deleteAnnouncement(id)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        vRP.Query("mdt/deleteAnnouncement", { id = id })
        TriggerClientEvent("Notify", source, "sucesso", "Aviso removido.")
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLE FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.impoundVehicle(plate, reason)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local user = vRP.Query("mdt/getUserByPassport", { passport = Passport })
        if #user > 0 then
            vRP.Query("mdt/insertImpoundedVehicle", {
                plate = plate,
                model = "Veículo",
                reason = reason,
                officer = user[1].name
            })
            TriggerClientEvent("Notify", source, "sucesso", "Veículo apreendido.")
        end
    end
end

function cRP.releaseVehicle(plate)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        vRP.Query("mdt/releaseVehicle", { plate = plate })
        TriggerClientEvent("Notify", source, "sucesso", "Veículo liberado.")
    end
end

function cRP.getImpoundedVehicles()
    return vRP.Query("mdt/getImpoundedVehicles")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINES LIST FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getFines(type)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local user = vRP.Query("mdt/getUserByPassport", { passport = Passport })
        if #user > 0 then
            local fines = vRP.Query("fines/GetAll")
            
            if type == "monetary" then
                -- Filtrar apenas multas monetárias (sem menção a prisão na mensagem)
                local monetaryFines = {}
                for _, fine in ipairs(fines) do
                    if fine.Message and not string.find(fine.Message:lower(), "prisão") then
                        table.insert(monetaryFines, fine)
                    end
                end
                return { success = true, fines = monetaryFines }
            elseif type == "prison" then
                -- Filtrar apenas multas com penalidades de prisão
                local prisonFines = {}
                for _, fine in ipairs(fines) do
                    if fine.Message and string.find(fine.Message:lower(), "prisão") then
                        table.insert(prisonFines, fine)
                    end
                end
                return { success = true, fines = prisonFines }
            else
                return { success = true, fines = fines }
            end
        end
    end
    return { success = false, fines = {} }
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES PARA REGISTROS DO CIDADÃO
-----------------------------------------------------------------------------------------------------------------------------------------

function cRP.getCitizenPrisonRecords(passport)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local user = vRP.Query("mdt/getUserByPassport", { passport = Passport })
        if #user > 0 then
            local records = vRP.Query("prison/getRecords", { nuser_id = passport })
            return { success = true, records = records }
        end
    end
    return { success = false, records = {} }
end

function cRP.getCitizenFines(passport)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local user = vRP.Query("mdt/getUserByPassport", { passport = Passport })
        if #user > 0 then
            local allFines = vRP.Query("fines/GetAll")
            local citizenFines = {}
            
            print("^3[MDT DEBUG]^7 Buscando multas para passport: " .. tostring(passport))
            print("^3[MDT DEBUG]^7 Total de multas no banco: " .. #allFines)
            
            for _, fine in ipairs(allFines) do
                if tostring(fine.Passport) == tostring(passport) then
                    table.insert(citizenFines, fine)
                    print("^3[MDT DEBUG]^7 Multa encontrada: ID=" .. fine.id .. ", Valor=" .. fine.Value)
                end
            end
            
            print("^3[MDT DEBUG]^7 Multas encontradas para o cidadão: " .. #citizenFines)
            
            return { success = true, fines = citizenFines }
        end
    end
    return { success = false, fines = {} }
end

function cRP.getCitizenWarrants(passport)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local user = vRP.Query("mdt/getUserByPassport", { passport = Passport })
        if #user > 0 then
            local allWarrants = vRP.Query("prison/getWarrants")
            local citizenWarrants = {}
            
            for _, warrant in ipairs(allWarrants) do
                if warrant.user_id == tostring(passport) and warrant.status == "active" then
                    table.insert(citizenWarrants, warrant)
                end
            end
            
            return { success = true, warrants = citizenWarrants }
        end
    end
    return { success = false, warrants = {} }
end 