Theft = {
	["RobberyCooldown"] = 3600, -- SEGUNDOS PARA ROUBAR NOVAMENTE
	["CopAmount"] = 3, -- NUMERO DE POLICIAIS NECESSARIOS
	["AlertChance"] = 50, -- CHANCE DE CHAMAR A POLICIA AO ENTRAR NA RESIDENCIA (1 a 100)
	["InteriorConfig"] = {
		
		
		[1] = {
			["Interior"] = "Emerald", -- NOME DO INTERIOR
			["RobberyCoords"] = vec3(120.49,-119.28,-23.81), -- COORDENADA ONDE ROUBAR (DENTRO DO INTERIOR)
		},
		[2] = {  
			["Interior"] = "Diamond",
			["RobberyCoords"] = vec3(51.34,-44.42,-24.01),
		},
		[3] = {
			["Interior"] = "Ruby",
			["RobberyCoords"] = vec3(99.97,-103.52,-24.2),
		},
		[4] = {
			["Interior"] = "Sapphire",
			["RobberyCoords"] = vec3(63.66,77.46,-24.57),
		},
		[5] = {
			["Interior"] = "Amethyst",
			["RobberyCoords"] = vec3(161.97,-154.02,-17.79),
		},
		[6] = {
			["Interior"] = "Amber",
			["RobberyCoords"] = vec3(120.98,-124.23,-27.4),
		},
	},

	["Rewards"] = {
		[1] = {
			["Item"] = "dollarz",
			["Amount"] = 28000,
			["Chance"] = 90, -- CHANCE DE VIR ESTE ITEM (QUANTO MAIOR, MAIS CHANCES DE GANHAR)
		},
		[2] = {
			["Item"] = "diamond",
			["Amount"] = 3,
			["Chance"] = 40,
		},
		[3] = {
			["Item"] = "joint",
			["Amount"] = 70,
			["Chance"] = 50,
		},
		[4] = {
			["Item"] = "pendrive2",
			["Amount"] = 5,
			["Chance"] = 70,
		},
		[5] = {
			["Item"] = "WEAPON_PISTOL_AMMO",
			["Amount"] = 30,
			["Chance"] = 20,
		},
		[6] = {
			["Item"] = "WEAPON_PISTOL",
			["Amount"] = 1,
			["Chance"] = 10,
		},
		[7] = {
			["Item"] = "ruby",
			["Amount"] = 10,
			["Chance"] = 20,
		},
		[8] = {
			["Item"] = "dollarz",
			["Amount"] = 30000,
			["Chance"] = 45,
		},
	}
}


  