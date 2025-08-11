-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vSKINSHOP = Tunnel.getInterface("skinshop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("player",cRP)
vRPC = Tunnel.getInterface("player")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESETS
-----------------------------------------------------------------------------------------------------------------------------------------
local preset = {
	-- ========================================
	-- FARDAMENTOS POLICIAIS (1-11)
	-- ========================================
	["1"] = { -- PoliciaMilitar
		["mp_m_freemode_01"] = {
             ["hat"] = { item = 0, texture = 0 },    -- Chapeus
            ["pants"] = { item = 143, texture = 4 },  -- Calças
            ["vest"] = { item = 71, texture = 0 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 0, texture = 0 }, -- Mascara
            ["shoes"] = { item = 63, texture = 0 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 25, texture = 0 }, -- Jaqueta
            ["accessory"] = { item = 0, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 0, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
        },
        ["mp_f_freemode_01"] = {
            ["hat"] = { item = -1, texture = 0 },
            ["pants"] = { item = 54, texture = 0 },
            ["vest"] = { item = 19, texture = 1 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["backpack"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 },
            ["mask"] = { item = 0, texture = 0 },
            ["shoes"] = { item = 25, texture = 0 },
            ["tshirt"] = { item = 35, texture = 0 },
            ["torso"] = { item = 92, texture = 2 },
            ["accessory"] = { item = 8, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["arms"] = { item = 31, texture = 0 },
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 }
        }
	},
	["2"] = { -- Core
		["mp_m_freemode_01"] = {
			 ["hat"] = { item = 206, texture = 3 },    -- Chapeus
            ["pants"] = { item = 205, texture = 0 },  -- Calças
            ["vest"] = { item = 86, texture = 5 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 52, texture = 3 }, -- Mascara
            ["shoes"] = { item = 145, texture = 1 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 556, texture = 0 }, -- Jaqueta
            ["accessory"] = { item = 189, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 4, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 1 },
			["pants"] = { item = 54, texture = 1 },
			["vest"] = { item = 4, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 3 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 35, texture = 0 },
			["torso"] = { item = 92, texture = 0 },
			["accessory"] = { item = 8, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 31, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["3"] = { -- PRF
	["mp_m_freemode_01"] = {
		["hat"] = { item = 0, texture = 0 },    -- Chapeus
		["pants"] = { item = 197, texture = 0 },  -- Calças
		["vest"] = { item = 95, texture = 0 },   -- Coletes
		["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
		["backpack"] = { item = 0, texture = 0 }, -- Mochila
		["decals"] = { item = 0, texture = 0 }, -- Adsivo
		["mask"] = { item = 58, texture = 7 }, -- Mascara
		["shoes"] = { item = 145, texture = 0 }, -- Sapato
		["tshirt"] = { item = 15, texture = 0 }, -- Camisa
		["torso"] = { item = 544, texture = 0 }, -- Jaqueta
		["accessory"] = { item = 184, texture = 0 }, -- Acessorio
		["watch"] = { item = -1, texture = 0 }, -- Relogio
		["arms"] = { item = 0, texture = 0 }, -- Braços
		["glass"] = { item = 0, texture = 0 }, -- Oculos
		["ear"] = { item = -1, texture = 0 } -- Brincos
	},
		["mp_f_freemode_01"] = {
			["hat"] = { item = 12, texture = 2 },
			["pants"] = { item = 151, texture = 3 },
			["vest"] = { item = 58, texture = 3 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 141, texture = 5 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 106, texture = 0 },
			["tshirt"] = { item = 237, texture = 0 },
			["torso"] = { item = 415, texture = 9 },
			["accessory"] = { item = 121, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 23, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["4"] = { -- PCivil
	["mp_m_freemode_01"] = {
		["hat"] = { item = 0, texture = 0 },    -- Chapeus
		["pants"] = { item = 197, texture = 0 },  -- Calças
		["vest"] = { item = 86, texture = 0 },   -- Coletes
		["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
		["backpack"] = { item = 0, texture = 0 }, -- Mochila
		["decals"] = { item = 0, texture = 0 }, -- Adsivo
		["mask"] = { item = 58, texture = 7 }, -- Mascara
		["shoes"] = { item = 145, texture = 0 }, -- Sapato
		["tshirt"] = { item = 15, texture = 0 }, -- Camisa
		["torso"] = { item = 543, texture = 3 }, -- Jaqueta
		["accessory"] = { item = 184, texture = 0 }, -- Acessorio
		["watch"] = { item = -1, texture = 0 }, -- Relogio
		["arms"] = { item = 4, texture = 0 }, -- Braços
		["glass"] = { item = 0, texture = 0 }, -- Oculos
		["ear"] = { item = -1, texture = 0 } -- Brincos
	},
		["mp_f_freemode_01"] = {
			["hat"] = { item = 10, texture = 0 },
			["pants"] = { item = 151, texture = 1 },
			["vest"] = { item = 58, texture = 1 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 140, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 106, texture = 0 },
			["tshirt"] = { item = 237, texture = 0 },
			["torso"] = { item = 415, texture = 3 },
			["accessory"] = { item = 121, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 23, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["5"] = { -- Judiciary
		["mp_m_freemode_01"] = {
			["hat"] = { item = 0, texture = 0 },    -- Chapeus
            ["pants"] = { item = 37, texture = 0 },  -- Calças
            ["vest"] = { item = -1, texture = 0 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item =44, texture = 4 }, -- Adsivo
            ["mask"] = { item = 58, texture = 0 }, -- Mascara
            ["shoes"] = { item = 21, texture = 0 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 560, texture = 9 }, -- Jaqueta
            ["accessory"] = { item = 177, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 0, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = 10, texture = 0 },
			["pants"] = { item = 151, texture = 1 },
			["vest"] = { item = 57, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 106, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 416, texture = 0 },
			["accessory"] = { item = 121, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 23, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["6"] = { -- CMD GERAL
		["mp_m_freemode_01"] = {
			["hat"] = { item = 191, texture = 0 },    -- Chapeus
            ["pants"] = { item = 193, texture = 0 },  -- Calças
            ["vest"] = { item = 83, texture = 0 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 58, texture = 2 }, -- Mascara
            ["shoes"] = { item = 145, texture = 0 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 538, texture = 0 }, -- Jaqueta
            ["accessory"] = { item = 180, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 4, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 105, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			-- ["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 6, texture = 0 },
			["torso"] = { item = 217, texture = 0 },
			["accessory"] = { item = 96, texture = 0 },
			-- ["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 106, texture = 0 },
			-- ["glass"] = { item = 0, texture = 0 },
			-- ["ear"] = { item = -1, texture = 0 }
		}
	},
	["7"] = { -- GRAER
		["mp_m_freemode_01"] = {
			["hat"] = { item = 206, texture = 3 },    -- Chapeus
            ["pants"] = { item = 205, texture = 0 },  -- Calças
            ["vest"] = { item = 86, texture = 5 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 52, texture = 3 }, -- Mascara
            ["shoes"] = { item = 145, texture = 1 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 556, texture = 0 }, -- Jaqueta
            ["accessory"] = { item = 189, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 4, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 1 },
			["pants"] = { item = 54, texture = 1 },
			["vest"] = { item = 4, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 3 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 35, texture = 0 },
			["torso"] = { item = 92, texture = 0 },
			["accessory"] = { item = 8, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 31, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["8"] = { -- GRAER PRF
		["mp_m_freemode_01"] = {
			["hat"] = { item = 209, texture = 1 },    -- Chapeus
            ["pants"] = { item = 188, texture = 2 },  -- Calças
            ["vest"] = { item = 104, texture = 1 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 0, texture = 0 }, -- Mascara
            ["shoes"] = { item = 138, texture = 2 }, -- Sapato
            ["tshirt"] = { item = 106, texture = 0 }, -- Camisa
            ["torso"] = { item = 562, texture = 2 }, -- Jaqueta
            ["accessory"] = { item = 1, texture = 1 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 4, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 105, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			-- ["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 6, texture = 0 },
			["torso"] = { item = 217, texture = 0 },
			["accessory"] = { item = 96, texture = 0 },
			-- ["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 106, texture = 0 },
			-- ["glass"] = { item = 0, texture = 0 },
			-- ["ear"] = { item = -1, texture = 0 }
		}
	},
	["9"] = { -- GTM PRF
		["mp_m_freemode_01"] = {
			["hat"] = { item = 209, texture = 0 },    -- Chapeus
            ["pants"] = { item = 188, texture = 0 },  -- Calças
            ["vest"] = { item = 104, texture = 0 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 0, texture = 0 }, -- Mascara
            ["shoes"] = { item = 138, texture = 2 }, -- Sapato
            ["tshirt"] = { item = 106, texture = 0 }, -- Camisa
            ["torso"] = { item = 562, texture = 1 }, -- Jaqueta
            ["accessory"] = { item = 1, texture = 1 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 4, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 105, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			-- ["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 6, texture = 0 },
			["torso"] = { item = 217, texture = 0 },
			["accessory"] = { item = 96, texture = 0 },
			-- ["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 106, texture = 0 },
			-- ["glass"] = { item = 0, texture = 0 },
			-- ["ear"] = { item = -1, texture = 0 }
		}
	},
	["10"] = { -- GTM
		["mp_m_freemode_01"] = {
			["hat"] = { item = 206, texture = 3 },    -- Chapeus
            ["pants"] = { item = 205, texture = 0 },  -- Calças
            ["vest"] = { item = 86, texture = 5 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 52, texture = 3 }, -- Mascara
            ["shoes"] = { item = 145, texture = 1 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 556, texture = 0 }, -- Jaqueta
            ["accessory"] = { item = 189, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 4, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 1 },
			["pants"] = { item = 54, texture = 1 },
			["vest"] = { item = 4, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 3 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 35, texture = 0 },
			["torso"] = { item = 92, texture = 0 },
			["accessory"] = { item = 8, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 31, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["11"] = { -- SPEED
		["mp_m_freemode_01"] = {
			["hat"] = { item = 0, texture = 0 },    -- Chapeus
            ["pants"] = { item = 197, texture = 0 },  -- Calças
            ["vest"] = { item = 85, texture = 4 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 53, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 58, texture = 6 }, -- Mascara
            ["shoes"] = { item = 145, texture = 0 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 543, texture = 3 }, -- Jaqueta
            ["accessory"] = { item = 183, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 4, texture = 0 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 105, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			-- ["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 6, texture = 0 },
			["torso"] = { item = 217, texture = 5 },
			["accessory"] = { item = 96, texture = 0 },
			-- ["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 106, texture = 0 },
			-- ["glass"] = { item = 0, texture = 0 },
			-- ["ear"] = { item = -1, texture = 0 }
		}
	},
	
	-- ========================================
	-- FARDAMENTOS MÉDICOS (12-14)
	-- ========================================
	["12"] = { -- SAMU
		["mp_m_freemode_01"] = {
			["hat"] = { item = 223, texture = 1 },    -- Chapeus
            ["pants"] = { item = -1, texture = 0 },  -- Calças
            ["vest"] = { item = 113, texture = 0 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 209, texture = 0 }, -- Mascara
            ["shoes"] = { item = 148, texture = 0 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 646, texture = 0 }, -- Jaqueta
            ["accessory"] = { item =-1, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 88, texture = 1 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
	["mp_f_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 105, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		-- ["bracelet"] = { item = -1, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 25, texture = 0 },
		["tshirt"] = { item = 6, texture = 0 },
		["torso"] = { item = 217, texture = 0 },
		["accessory"] = { item = 96, texture = 0 },
		-- ["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 106, texture = 0 },
		-- ["glass"] = { item = 0, texture = 0 },
		-- ["ear"] = { item = -1, texture = 0 }
	   }
	},
	["13"] = { -- UPA
		["mp_m_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },    -- Chapeus
            ["pants"] = { item = 236, texture = 0 },  -- Calças
            ["vest"] = { item = -1, texture = 0 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 209, texture = 0 }, -- Mascara
            ["shoes"] = { item = 42, texture = 2 }, -- Sapato
            ["tshirt"] = { item = 15, texture = 0 }, -- Camisa
            ["torso"] = { item = 644, texture = 1 }, -- Jaqueta
            ["accessory"] = { item = -1, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 85, texture = 1 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
	["mp_f_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 105, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		-- ["bracelet"] = { item = -1, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 25, texture = 0 },
		["tshirt"] = { item = 6, texture = 0 },
		["torso"] = { item = 217, texture = 0 },
		["accessory"] = { item = 96, texture = 0 },
		-- ["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 106, texture = 0 },
		-- ["glass"] = { item = 0, texture = 0 },
		-- ["ear"] = { item = -1, texture = 0 }
	   }
	},
	["14"] = { -- CHEFE UPA
		["mp_m_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },    -- Chapeus
            ["pants"] = { item = 20, texture = 0 },  -- Calças
            ["vest"] = { item = -1, texture = 0 },   -- Coletes
            ["bracelet"] = { item = -1, texture = 0 }, -- Pulseira
            ["backpack"] = { item = 0, texture = 0 }, -- Mochila
            ["decals"] = { item = 0, texture = 0 }, -- Adsivo
            ["mask"] = { item = 209, texture = 1 }, -- Mascara
            ["shoes"] = { item = 42, texture = 2 }, -- Sapato
            ["tshirt"] = { item =21, texture = 4 }, -- Camisa
            ["torso"] = { item = 645, texture = 1 }, -- Jaqueta
            ["accessory"] = { item = -1, texture = 0 }, -- Acessorio
            ["watch"] = { item = -1, texture = 0 }, -- Relogio
            ["arms"] = { item = 88, texture = 1 }, -- Braços
            ["glass"] = { item = 0, texture = 0 }, -- Oculos
            ["ear"] = { item = -1, texture = 0 } -- Brincos
		},
	["mp_f_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 105, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		-- ["bracelet"] = { item = -1, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 25, texture = 0 },
		["tshirt"] = { item = 6, texture = 0 },
		["torso"] = { item = 217, texture = 0 },
		["accessory"] = { item = 96, texture = 0 },
		-- ["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 106, texture = 0 },
		-- ["glass"] = { item = 0, texture = 0 },
		-- ["ear"] = { item = -1, texture = 0 }
	   }
	},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Preset")
AddEventHandler("player:Preset",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasService(Passport,"Emergency") then
			local Model = vRP.ModelPlayer(source)

			if Model == "mp_m_freemode_01" or "mp_f_freemode_01" then
				TriggerClientEvent("skinshop:Apply",source,preset[Number][Model])
			end
		end
	end
end)
