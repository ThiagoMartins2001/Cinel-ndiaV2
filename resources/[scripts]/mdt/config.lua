-- =============================================================================
-- MDT - Mobile Data Terminal
-- Configuração Centralizada
-- Cinelândia Roleplay
-- =============================================================================

Config = {}

-- =============================================================================
-- CONFIGURAÇÕES GERAIS
-- =============================================================================

-- Nome da cidade
Config.CityName = "Cinelândia"

-- Versão do sistema
Config.Version = "1.0.0"

-- Distância máxima para interação
Config.Distance = 2.0

-- =============================================================================
-- PONTOS DE ACESSO (REFERÊNCIA)
-- =============================================================================

-- O MDT é acessível de qualquer lugar usando o comando /mdt
-- As localizações abaixo são mantidas para referência histórica

Config.Locations = {
    -- Polícia Militar
    { 
        coords = vec3(442.40, -981.84, 31.60), 
        name = "P.Militar",
        department = "Police"
    },
    
    -- Polícia Penal
    { 
        coords = vec3(1840.21, 2578.52, 46.08), 
        name = "P.Penal",
        department = "Police"
    },
    
    -- Polícia Rodoviária Federal
    { 
        coords = vec3(-271.04, 6056.31, 33.05), 
        name = "P.Rodoviária Federal",
        department = "PRF"
    },
    
    -- Polícia Civil
    { 
        coords = vec3(-947.81, -2040.48, 9.4), 
        name = "P.Civil",
        department = "PCivil"
    },
    
    -- Core
    { 
        coords = vec3(847.28, -1284.72, 24.32), 
        name = "Core",
        department = "Core"
    }
}

-- =============================================================================
-- PERMISSÕES
-- =============================================================================

-- Departamentos que podem acessar o MDT
Config.AllowedDepartments = {
    "Police",
    "Core", 
    "PRF",
    "PCivil"
}

-- =============================================================================
-- CONFIGURAÇÕES DO BANCO DE DADOS
-- =============================================================================

-- Prefixo das tabelas do MDT
Config.TablePrefix = "mdt_"

-- =============================================================================
-- CONFIGURAÇÕES DE INTERFACE
-- =============================================================================

-- Cores do tema
Config.Colors = {
    Primary = "#667eea",
    Secondary = "#764ba2", 
    Success = "#27ae60",
    Error = "#e74c3c",
    Warning = "#f39c12",
    Info = "#3498db"
}

-- Configurações de notificação
Config.Notifications = {
    Duration = 3000, -- 3 segundos
    Position = "top-right"
}

-- =============================================================================
-- CONFIGURAÇÕES DE SEGURANÇA
-- =============================================================================

-- Tempo máximo de sessão (em minutos)
Config.SessionTimeout = 30

-- Tentativas máximas de login
Config.MaxLoginAttempts = 3

-- Tempo de bloqueio após tentativas falhadas (em minutos)
Config.LoginLockoutTime = 5

-- =============================================================================
-- CONFIGURAÇÕES DE LOGS
-- =============================================================================

-- Habilitar logs detalhados
Config.EnableLogs = true

-- Tipos de ações para log
Config.LogActions = {
    "login",
    "logout", 
    "prison",
    "fine",
    "warrant",
    "port",
    "report",
    "vehicle",
    "announcement",
    "service_toggle"
}

-- =============================================================================
-- CONFIGURAÇÕES DE DASHBOARD
-- =============================================================================

-- Atualização automática das estatísticas (em segundos)
Config.StatsUpdateInterval = 30

-- Número máximo de avisos exibidos no dashboard
Config.MaxAnnouncements = 10

-- =============================================================================
-- CONFIGURAÇÕES DE BUSCA
-- =============================================================================

-- Limite de resultados por busca
Config.SearchLimit = 50

-- Tempo de cache para resultados (em segundos)
Config.SearchCacheTime = 300

-- =============================================================================
-- CONFIGURAÇÕES DE FORMULÁRIOS
-- =============================================================================

-- Campos obrigatórios para prisão
Config.PrisonRequiredFields = {
    "passport",
    "services",
    "fines"
}

-- Campos obrigatórios para multa
Config.FineRequiredFields = {
    "passport",
    "fines",
    "text"
}

-- =============================================================================
-- CONFIGURAÇÕES DE VEÍCULOS
-- =============================================================================

-- Tempo máximo de apreensão (em dias)
Config.MaxImpoundTime = 30

-- Taxa de liberação de veículo
Config.VehicleReleaseFee = 1000

-- =============================================================================
-- CONFIGURAÇÕES DE RELATÓRIOS
-- =============================================================================

-- Status disponíveis para relatórios
Config.ReportStatuses = {
    "Pendente",
    "Em Andamento", 
    "Resolvido",
    "Arquivado"
}

-- =============================================================================
-- CONFIGURAÇÕES DE MANDADOS
-- =============================================================================

-- Status disponíveis para mandados
Config.WarrantStatuses = {
    "Ativo",
    "Executado",
    "Cancelado",
    "Expirado"
}

-- Duração padrão de mandados (em dias)
Config.DefaultWarrantDuration = 30

-- =============================================================================
-- CONFIGURAÇÕES DE PORTES
-- =============================================================================

-- Tipos de porte disponíveis
Config.PortTypes = {
    "Arma de Fogo",
    "Arma de Caça",
    "Arma Esportiva"
}

-- Status disponíveis para portes
Config.PortStatuses = {
    "Ativo",
    "Suspenso",
    "Cancelado",
    "Expirado"
}

-- =============================================================================
-- CONFIGURAÇÕES DE ANÚNCIOS
-- =============================================================================

-- Categorias de anúncios
Config.AnnouncementCategories = {
    "Geral",
    "Urgente",
    "Informação",
    "Treinamento",
    "Evento"
}

-- Duração padrão de anúncios (em dias)
Config.DefaultAnnouncementDuration = 7

-- =============================================================================
-- CONFIGURAÇÕES DE EXPORTAÇÃO
-- =============================================================================

-- Formato de data padrão
Config.DateFormat = "%Y-%m-%d %H:%M:%S"

-- Fuso horário
Config.Timezone = "America/Sao_Paulo"

-- =============================================================================
-- CONFIGURAÇÕES DE BACKUP
-- =============================================================================

-- Habilitar backup automático
Config.EnableAutoBackup = true

-- Frequência de backup (em horas)
Config.BackupInterval = 24

-- Manter backups por (em dias)
Config.BackupRetention = 7

-- =============================================================================
-- CONFIGURAÇÕES DE PERFORMANCE
-- =============================================================================

-- Cache de consultas (em segundos)
Config.QueryCacheTime = 60

-- Limite de conexões simultâneas
Config.MaxConnections = 100

-- Timeout de consultas (em segundos)
Config.QueryTimeout = 30

-- =============================================================================
-- CONFIGURAÇÕES DE DEBUG
-- =============================================================================

-- Modo debug
Config.DebugMode = false

-- Log de erros detalhado
Config.DetailedErrorLogs = false

-- =============================================================================
-- FUNÇÕES DE UTILIDADE
-- =============================================================================

-- Verificar se um departamento tem acesso
function Config.HasAccess(department)
    for _, allowed in ipairs(Config.AllowedDepartments) do
        if allowed == department then
            return true
        end
    end
    return false
end

-- Obter coordenadas de um local por nome
function Config.GetLocationByName(name)
    for _, location in ipairs(Config.Locations) do
        if location.name == name then
            return location.coords
        end
    end
    return nil
end

-- Verificar se uma coordenada é um ponto de acesso
function Config.IsAccessPoint(coords)
    for _, location in ipairs(Config.Locations) do
        local distance = #(coords - location.coords)
        if distance <= Config.Distance then
            return true, location
        end
    end
    return false, nil
end

-- Formatar data
function Config.FormatDate(timestamp)
    return os.date(Config.DateFormat, timestamp)
end

-- Validar campos obrigatórios
function Config.ValidateRequiredFields(data, requiredFields)
    for _, field in ipairs(requiredFields) do
        if not data[field] or data[field] == "" then
            return false, "Campo obrigatório: " .. field
        end
    end
    return true, nil
end

-- =============================================================================
-- EXPORTAÇÃO DA CONFIGURAÇÃO
-- =============================================================================

return Config 