
------------------------------------------------------------------------------------------------------------------------  
-- # items: itens que serão utilizados no sistema de desmanche (dinheiro sujo, dinheiro limpo e item para limpeza do dinheiro sujo)
------------------------------------------------------------------------------------------------------------------------

items = {

    dirty_money = "dollarz",

    clean_money = "dollars",

    cleaner = "cleaner"
    
}

------------------------------------------------------------------------------------------------------------------------  
-- # mathematics: cálculos da lavagem
------------------------------------------------------------------------------------------------------------------------

mathematics = {

    -- # valor utilizado como base, para cálculo do tempo e da quantidade de limpadores utilizados.
    base_value = 1000,

    -- # quantos segundos são utilizados para lavar o valor base, leve em consideração: tempo final = base_value * wash_time.
    wash_time = 5,

    -- # quantos itens de limpeza serão utilizados para lavar o valor base, leve em consideração: quantidade de limpadores = base_value * cleaner_cost.
    cleaner_cost = 1,

    -- # porcentagem da taxa que será removida do dinheiro ao ser lavado e transformado em dinheiro limpo.
    tax_percent = 40

}

------------------------------------------------------------------------------------------------------------------------  
-- # upgrades: configuração das melhorias para as máquinas de lavagem
------------------------------------------------------------------------------------------------------------------------

upgrades = {

    -- # upgrade 'efficiency': aumenta o valor máximo que a máquina pode lavar por vez.
    ["efficiency"] = {

        enabled = true, -- # habilitar esta melhoria

        name = "Eficiência", -- # nome (interface)

        description = "Aumenta a capacidade de limpeza, liberando a lavagem de quantias mais altas.", -- # descrição (interface)

        default_limit = 1000000, -- # limite padrão (sem upgrade)
        
        levels = { -- # limite para cada um dos 5 níveis possíveis de upgrade & custo para fazer o upgrade para cada nível
            [1] = { limit = 2000000, price = 100000 },
            [2] = { limit = 3000000, price = 100000 },
            [3] = { limit = 5000000, price = 100000 },
            [4] = { limit = 7500000, price = 100000 },
            [5] = { limit = 10000000, price = 100000 }
        }

    },

    -- # upgrade 'potency': reduz o tempo de lavagem, em PORCENTAGEM
    ["potency"] = {

        enabled = true, -- # habilitar esta melhoria

        name = "Potência", -- # nome (interface)

        description = "Melhora o hardware da máquina, reduzindo o tempo de lavagem!", -- # descrição (interface)

        levels = { -- # bônus (porcentagem) no tempo de lavagem para cada um dos 5 níveis possíveis de upgrade & custo para fazer o upgrade para cada nível
            [1] = { time_reduce_percent = 10, price = 100000 },
            [2] = { time_reduce_percent = 15, price = 100000 },
            [3] = { time_reduce_percent = 20, price = 100000 },
            [4] = { time_reduce_percent = 25, price = 100000 },
            [5] = { time_reduce_percent = 30, price = 100000 }
        }

    }

}

------------------------------------------------------------------------------------------------------------------------  
-- # laundries: cadastro das máquinas de lavagem
------------------------------------------------------------------------------------------------------------------------

--[[

    # Formato:

    ['1'] = { -- ID da máquina (deve ser único e se for alterado poderá causar a perda de lavagens em andamento)

        -- Configuração da máquina
        machine = {

            object = true, -- Esta máquina deve gerar o prop/objeto da máquina de lavagem de dinheiro? ( true = gerar objeto / false = não gerar objeto )

            -- Coordenada da máquina de lavagem
            coords = {4464.45,-4473.42,4.24-0.99,21.42}

        },

        -- Permissão para acessar esta máquina de lavagem, caso queira que seja pública deixe como: nil ( ex: permission = nil, )
        permission = {'owner'},

    },


--]]

laundries = {

    [1] = {

        machine = {

            object = false,

            coords = vector4(159.14,-1311.17,29.35,51.03)
        },

        permission = { "Pawnshop" }
    },
    
}