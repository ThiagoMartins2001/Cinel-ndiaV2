Config = {}

Config.Framework = "auto" -- auto, esx or qb
Config.voipSystem = "auto" -- auto, pma-voice, mumble-voip, saltychat
Config.debug = true
Config.radioName = "radio" -- item name
Config.defaultVolume = 50 -- default volume of the radio, 0 - 100

Config.RadioProp = 'prop_cs_hand_radio'

Config.jobChannels = { -- channels where only designated jobs can participate
    [1] = {
        frequency = {
            "190",
            "191"
        },
        jobs = {
            "Police"
        }
    },
    [2] = {
        frequency = {
            "112",
            "113"
        },
        jobs = {
            "Paramedic"
        }
    },
    [3] = {
        frequency = {
            "100",
        },
        jobs = {
            "mecanicothunder.permissao"
        }
    },
    [4] = {
        frequency = {
            "101",
        },
        jobs = {
            "mecanicocruz.permissao"
        }
    },
}

Config.Locale = {
    created = "Canal criado com sucesso!",
    created_fail = "Essa frequencia já esta criada.",
    
    disconnected = "Você desconectou com sucesso!",
    disconnected_fail = "Algum erro ocorreu ao tentar desconectar.",

    connected = "Você conectou com sucesso!",
    password = "Digite a senha para entrar nesse canal!",

    notfound = "Esse canal não foi encontrado!",
    wrong = "Senha incorreta!",

    wait = "Aguarde para fazer isso.",
    kick = "You were disconnected because you didn't have a radio.",
    job = "Essa frequencia é privada!",

    volume_up = "volume aumentado ",
    volume_down = "volume reduzido ",
    max = "volume já esta no maximo!",
    min = "volume já esta no minimo!"
}
