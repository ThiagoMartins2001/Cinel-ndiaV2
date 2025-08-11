-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIGURAÇÃO DO SISTEMA DE ADRENALINA
-----------------------------------------------------------------------------------------------------------------------------------------

AdrenalineConfig = {
    -- Tempo de aplicação da adrenalina (em milissegundos)
    ApplicationTime = 8000,
    
    -- Vida que o player recebe após ser reanimado
    ReviveHealth = 101,
    
    -- Pontos de sede e fome que o player recebe
    ThirstPoints = 15,
    HungerPoints = 15,
    
    -- Distância máxima para usar adrenalina em outro player
    MaxDistance = 3.0,
    
    -- Mensagens do sistema
    Messages = {
        Success = "Adrenalina aplicada com sucesso em %s!",
        WrongLocation = "Você só pode usar adrenalina em locais médicos autorizados!",
        NoPlayerNearby = "Nenhuma pessoa próxima encontrada!",
        PlayerNotUnconscious = "A pessoa precisa estar desacordada para usar adrenalina!",
        ParamedicsOnline = "Existem paramédicos online. É recomendado chamar um profissional!",
        Progress = "Aplicando Adrenalina",
        Revived = "Você foi reanimado com adrenalina!"
    },
    
    -- Animações
    Animations = {
        Dict = "mini@cpr@char_a@cpr_str",
        Name = "cpr_pumpchest"
    },
    
    -- Configurações de segurança
    Security = {
        -- Verificar se há paramédicos online
        CheckParamedics = true,
        
        -- Permitir uso apenas para paramédicos (false = todos podem usar)
        ParamedicsOnly = false,
        
        -- Log de todas as ações
        EnableLogs = true,
        
        -- Cooldown entre usos (em segundos)
        Cooldown = 30
    },
    
    -- Efeitos visuais (opcional)
    Effects = {
        -- Mostrar efeito de partículas durante aplicação
        ShowParticles = false,
        
        -- Som durante aplicação
        PlaySound = true,
        SoundName = "bandage",
        SoundVolume = 0.5
    }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÃO PARA OBTER CONFIGURAÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------
function GetAdrenalineConfig()
    return AdrenalineConfig
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTAR CONFIGURAÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------
exports("GetAdrenalineConfig", GetAdrenalineConfig)
