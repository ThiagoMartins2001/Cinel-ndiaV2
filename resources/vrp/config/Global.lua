-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
Currency = "R$"
UsableF7 = false
Whitelisted = true
CombatLogMinutes = 0
SalarySeconds = 2400
BannedText = "o Faly mandou um Beijo"
CleanDeathInventory = true
ClearInventoryPremium = true
ClearInventoryCelebridade = false
ServerName = "Invoke Kira"
ReleaseText = "Acesso nosso discord e faça sua Allowlist-> https://discord.gg/R9287cKVxW "
SpawnCoords = vec3(1620.7,3558.12,35.38)
BackArenaPos = vec3(-1046.43,-474.55,36.78)
BackPrison = vec3(1896.15,2604.44,45.75)
BackpackWeightDefault = 50
WipeBackpackDeath = true
NewItemIdentity = true
CrouchAiming = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- BASE
-----------------------------------------------------------------------------------------------------------------------------------------
BaseMode = "license" -- license ou steam
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESOURCES
-----------------------------------------------------------------------------------------------------------------------------------------
CreativeBank = false
IgnoreCardLimit = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- THEME
-----------------------------------------------------------------------------------------------------------------------------------------
Theme = {
    ["currency"] = Currency,
    ["main"] = "#C0C0C0",
    ["common"] = "#6fc66a",
    ["rare"] = "#6ac6c5",
    ["epic"] = "#c66a75",
    ["legendary"] = "#c6986a",
    ["accept"] = {
        ["letter"] = "#dcffe9",
        ["background"] = "#3fa466"
    },
    ["reject"] = {
        ["letter"] = "#ffe8e8",
        ["background"] = "#ad4443"
    },
    ["chat"] = {
        ["Families"] = "#ff0000",
        ["Ballas"] = "#00ff00",
        ["Vagos"] = "#0000ff"
    },
    ["hud"] = {
        ["modes"] = {
            ["info"] = 3, -- [ Opções disponíveis: 1,2,3 ],
            ["icon"] = "fill", -- [ Opções disponíveis: fill,line ],
            ["status"] = 2, -- [ Opções disponíveis: 1,2,3,4,5,6 ],
            ["vehicle"] = 1 -- [ Opções disponíveis: 1,2,3 ]
        },
        ["percentage"] = true,
        ["icons"] = "#FFFFFF",
        ["nitro"] = "#f69d2a",
        ["rpm"] = "#FFFFFF",
        ["fuel"] = "#f94c54",
        ["engine"] = "#ff4c55",
        ["health"] = "#E73225",
        ["armor"] = "#1876E2",
        ["hunger"] = "#D47A23",
        ["thirst"] = "#22B2CC",
        ["stress"] = "#AB1AD1",
        ["luck"] = "#F18A7C",
        ["dexterity"] = "#FFCF61",
        ["repose"] = "#F18A7C",
        ["pointer"] = "#FFFF",
        ["progress"] = {
            ["background"] = "#FFFFFF",
            ["circle"] = "#581937;",
            ["letter"] = "#FFFFFF"
        }
    },
    ["notifyitem"] = {
        ["add"] = {
            ["letter"] = "#dcffe9",
            ["background"] = "#3fa466"
        },
        ["remove"] = {
            ["letter"] = "#ffe8e8",
            ["background"] = "#ad4443"
        }
    },
    ["pause"] = {
        ["premium"] = true,
        ["store"] = true,
        ["battlepass"] = true,
        ["boxes"] = true,
        ["marketplace"] = true,
        ["skinweapon"] = true,
        ["map"] = true,
        ["settings"] = true,
        ["disconnect"] = true
    }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUNGER / THIRST
-----------------------------------------------------------------------------------------------------------------------------------------
ConsumeHunger = 1
ConsumeThirst = 1
CooldownHungerThrist = 90000
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDICTION
-----------------------------------------------------------------------------------------------------------------------------------------
ConsumeAddiction = 1
CooldownAddiction = 60000
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAINTENANCE
-----------------------------------------------------------------------------------------------------------------------------------------
Maintenance = false		
MaintenanceText = "Servidor em manutenção fique atento ao nosso discord para mais informações."
MaintenanceLicenses = {
	["db11d7eb13622f385944ce78ab44c01e421b662d"] = true, -- Faly
    ["63fba0459089a9caebfc84391de76d0c95cfeba9"] = true, -- 
    ["0fead5d9d04e95e0eae425eae3bdbaa015a09bb3"] = true, -- 
    ["99e24b85ee3655bbe02b096d275c36524014b429"] = true, -- 

}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARENA (Itens recebidos ao entrar na arena)
-----------------------------------------------------------------------------------------------------------------------------------------
ArenaItens = {
	["WEAPON_PISTOL_MK2"] = 1,
	["WEAPON_PISTOL_AMMO"] = 1000
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERITENS (Itens recebidos ao criar o personagem)
-----------------------------------------------------------------------------------------------------------------------------------------
CharacterItens = {
	["hamburger2"] = 5,
    ["water"] = 5,
	["dollars"] = 50000,
	["cellphone"] = 1,
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUPBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
GroupBlips = {
	["PoliciaMilitar"] = true,
	["Core"] = true,
	["PRF"] = true,
	["PCivil"] = true,
	["Paramedic"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLIENTSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
ClientState = {
	["PoliciaMilitar"] = true,
	["Core"] = true,
	["PRF"] = true,
	["PCivil"] = true,
	["Mechanic"] = true,
	["Paramedic"] = true,
    ["Admin"] = true,
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTCLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
StartClothes = {
	-- ["mp_m_freemode_01"] = {
	-- 	["pants"] = { item = 26, texture = 0 },
	-- 	["arms"] = { item = 0, texture = 0 },
	-- 	["tshirt"] = { item = 15, texture = 0 },
	-- 	["torso"] = { item = 57, texture = 0 },
	-- 	["vest"] = { item = 0, texture = 0 },
	-- 	["shoes"] = { item = 0, texture = 2 },
	-- 	["mask"] = { item = 0, texture = 0 },
	-- 	["backpack"] = { item = 0, texture = 0 },
	-- 	["hat"] = { item = -1, texture = 0 },
	-- 	["glass"] = { item = 0, texture = 0 },
	-- 	["ear"] = { item = -1, texture = 0 },
	-- 	["watch"] = { item = -1, texture = 0 },
	-- 	["bracelet"] = { item = -1, texture = 0 },
	-- 	["accessory"] = { item = 0, texture = 0 },
	-- 	["decals"] = { item = 0, texture = 0 }
	-- },
	-- ["mp_f_freemode_01"] = {
	-- 	["pants"] = { item = 157, texture = 0 },
	-- 	["arms"] = { item = 0, texture = 0 },
	-- 	["tshirt"] = { item = 1, texture = 0 },
	-- 	["torso"] = { item = 368, texture = 1 },
	-- 	["vest"] = { item = 0, texture = 0 },
	-- 	["shoes"] = { item = 1, texture = 0 },
	-- 	["mask"] = { item = 0, texture = 0 },
	-- 	["backpack"] = { item = 0, texture = 0 },
	-- 	["hat"] = { item = -1, texture = 0 },
	-- 	["glass"] = { item = 0, texture = 0 },
	-- 	["ear"] = { item = -1, texture = 0 },
	-- 	["watch"] = { item = -1, texture = 0 },
	-- 	["bracelet"] = { item = -1, texture = 0 },
	-- 	["accessory"] = { item = 0, texture = 0 },
	-- 	["decals"] = { item = 0, texture = 0 }
	-- }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LANG
-----------------------------------------------------------------------------------------------------------------------------------------
Lang = {
	["Join"] = "Entrando...",
	["Connecting"] = "Conectando...",
	["Position"] = "Você é o %d/%d da fila, aguarde sua conexão",
	["Error"] = "Conexão perdida."
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUEUE
-----------------------------------------------------------------------------------------------------------------------------------------
Queue = {
	["List"] = {},
	["Players"] = {},
	["Counts"] = 0,
	["Connecting"] = {},
	["Threads"] = 0,
	["Max"] = 2048
}