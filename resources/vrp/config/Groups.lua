-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
Groups = {
	["OwnerInvoke"] = {
		["Parent"] = {
			["OwnerInvoke"] = true
		},
		["Hierarchy"] = { "Owner","Developer" },
		["Service"] = {}
	},
	["Admin"] = {
		["Parent"] = {
			["Admin"] = true
		},
		["Hierarchy"] = { "Administrador","Moderador","Suporte","Help" },
		["Salary"] = { 10000, 8000, 5000, 4500, 1500  },
		["Service"] = {}
	},
	["Inicial"] = {
		["Parent"] = {
			["Inicial"] = true
		},
		["Hierarchy"] = { "Inicial" },
		["Salary"] = { 2500 },
		["Service"] = {}
	},


	["Premium"] = {
		["Parent"] = {
			["Premium"] = true
		},
		["Hierarchy"] = { "AbosolutUltimate","Abosolut","Advenced","Diamond","Platium","Gold" },
		["Salary"] = { 15000, 8000, 5000, 4500, 3500, 2500 },
		["Service"] = {}
	},

	["vipgold"] = {
		["Parent"] = {
			["vipgold"] = true
		},
		["Hierarchy"] = { "vipgold" },
		["Salary"] = { 2500 },
		["Service"] = {}
	},
	["vipplatium"] = {
		["Parent"] = {
			["vipplatium"] = true
		},
		["Hierarchy"] = { "vipplatium" },
		["Salary"] = { 3500 },
		["Service"] = {}
	},
	["vipdiamond"] = {
		["Parent"] = {
			["vipdiamond"] = true
		},
		["Hierarchy"] = { "vipdiamond" },
		["Salary"] = { 4500 },
		["Service"] = {}
	},
	["vipadvenced"] = {
		["Parent"] = {
			["vipadvenced"] = true
		},
		["Hierarchy"] = { "vipadvenced" },
		["Salary"] = { 5000 },
		["Service"] = {}
	},
	["vipabsolut"] = {
		["Parent"] = {
			["vipabsolut"] = true
		},
		["Hierarchy"] = { "vipabsolut" },
		["Salary"] = { 8000 },
		["Service"] = {}
	},
	["vipabsolutultimate"] = {
		["Parent"] = {
			["vipabsolutultimate"] = true
		},
		["Hierarchy"] = { "vipabsolutultimate" },
		["Salary"] = { 15000 },
		["Service"] = {}
	},

	-- GRUPOS POLICIAIS ATUALIZADOS
	["PoliciaMilitar"] = {
		["Parent"] = {
			["PoliciaMilitar"] = true
		},
		["Hierarchy"] = { "Comandante", "Subcomandante", "Coronel", "Tenente Coronel", "Major", "Capitão", "1 Tenente", "2 Tenente", "Aspirante","Subtenente", "1 Sargento","2 Sargento","3 Sargento", "Cabo", "Soldado", "Aluno" },
		["Salary"] = { 10000, 8800, 8100, 7800, 7100, 6800, 6100, 5800, 5100, 4800, 4100, 3800, 3100, 2800, 2100, 1800 },
		["Service"] = {},
		["Type"] = "Work"
	},

	["Core"] = {
		["Parent"] = {
			["Core"] = true
		},
		["Hierarchy"] = { "Comandante", "Subcomandante", "Coronel", "Tenente Coronel", "Major", "Capitão", "1 Tenente", "2 Tenente", "Aspirante","Subtenente", "1 Sargento","2 Sargento","3 Sargento" },
		["Salary"] = { 10000, 10000, 9300, 9000, 8300, 8000, 7300, 7000, 6300, 6000, 5300, 5000, 4300 },
		["Service"] = {},
		["Type"] = "Work"
	},

	["Judiciary"] = {
		["Parent"] = {
			["Judiciary"] = true
		},
		["Hierarchy"] = { "Presidente TJCN", "Desembargador", "Primeiro Secretário Desembargador", "Segundo Secretário Desembargador", "Juiz Geral", "Promotor de Justiça", "Advogado", "Defensor Público", "Defensor Público Substituto" },
		["Salary"] = { 10000, 8800, 8100, 7800, 7100, 6800, 6100, 4800, 5100, 5100 },
		["Service"] = {},
		["Type"] = "Work"
	},

	["PRF"] = {
		["Parent"] = {
			["PRF"] = true
		},
		["Hierarchy"] = { "Diretor", "Inspetor Especial", "Inspetor", "Agente Especial", "Agente", "Aspirante", "Cadete" },
		["Salary"] = { 10000, 8800, 8100, 7800, 7100, 6800, 6100 },
		["Service"] = {},
		["Type"] = "Work"
	},

	["PCivil"] = {
		["Parent"] = {
			["PCivil"] = true
		},
		["Hierarchy"] = { "Delegado", "Escrivão", "Investigador", "Agente" },
		["Salary"] = { 10000, 8800, 8100, 7800 },
		["Service"] = {},
		["Type"] = "Work"
	},

	-- GRUPOS MÉDICOS
	["LiderParamedic"] = {
		["Parent"] = {
			["LiderParamedic"] = true
		},
		["Hierarchy"] = { "Diretor"},
		["Salary"] = {},
		["Service"] = {},
		["Type"] = "Work"
	},
	["Paramedic"] = {
		["Parent"] = {
			["Paramedic"] = true
		},
		["Hierarchy"] = { "Diretor","Supervisor","Médico", "Interno", "Paramédico", "Trainee"  },
		["Salary"] = { 8500,7000,6700,5500,4000,3500 },
		["Service"] = {},
		["Type"] = "Work"
	},

	-- GRUPOS DE TRABALHO
	["LiderPawnshop"] = {
		["Parent"] = {
			["LiderPawnshop"] = true
		},
		["Hierarchy"] = { "Chefe"},
		["Service"] = {},
		["Type"] = "Work"
	},
	["Pawnshop"] = {
		["Parent"] = {
			["Pawnshop"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Supervisor","Vendedor" },
		["Service"] = {},
		["Type"] = "Work"
	},

------------------------- /FAIXADA/EMPRESAS SUL  -----------------------------
	["Ifrut"] = {
		["Parent"] = {
			["Ifrut"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Supervisor","Vendedor" },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Vanilla"] = {           
		["Parent"] = { 
			["Vanilla"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Work"
	},
	["LiderMechanic"] = {
		["Parent"] = {
			["LiderMechanic"] = true
		},
		["Hierarchy"] = { "Chefe"},
		["Salary"] = { 10 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Mechanic"] = {
		["Parent"] = {
			["Mechanic"] = true,
			["LiderMechanic"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Supervisor","Mecânico" },
		["Salary"] = { 12000,9000,7000,5000,3000 },
		["Service"] = {},
		["Type"] = "Work"
	},

 ------------------------------------ ORG - MAFIA NORTE -----------------------------
	["LiderThelost"] = {
		["Parent"] = {
			["LiderThelost"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Supervisor","Mecânico" },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Thelost"] = {
		["Parent"] = {
			["Thelost"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Supervisor","Mecânico" },
		["Service"] = {},
		["Type"] = "Work"
	},
	["LiderDesmanche"] = {
		["Parent"] = {
			["LiderDesmanche"] = true
		},
		["Hierarchy"] = { "Chefe" },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Desmanche"] = {
		["Parent"] = {
			["Desmanche"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Supervisor","Mecânico" },
		["Service"] = {},
		["Type"] = "Work"
	},

----------------------------------------------------------------------------------------------
	["Vinhedo"] = {
		["Parent"] = {
			["Vinhedo"] = true
		},
		["Hierarchy"] = { "Patrão","Gerente","Soldado","Vapor","Avião","Fogueteiro" },
		["Service"] = {},
		["Type"] = "Work"
	},

------------------------------------------- NEW CARGOS ------------------------------------------
-- ["Matuto"] = {             
-- 	["Parent"] = {
-- 		["Matuto"] = true
-- 	},
-- 	["Hierarchy"] = { "Chefe"},
-- 	["Service"] = {},
-- 	["Type"] = "Work"
-- },  


["LiderFavela01"] = {             
	["Parent"] = {
		["LiderFavela01"] = true
	},
	["Hierarchy"] = { "Lider"},
	["Service"] = {},
	["Type"] = "Work"
},
["Favela01"] = {             
	["Parent"] = {
		["Favela01"] = true
	},
	["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
	["Service"] = {},
	["Type"] = "Work"
},



["LiderFavela02"] = {             
	["Parent"] = {
		["LiderFavela02"] = true
	},
	["Hierarchy"] = { "Lider"},
	["Service"] = {},
	["Type"] = "Work"
},
["Favela02"] = {             
	["Parent"] = {
		["Favela02"] = true
	},
	["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
	["Service"] = {},
	["Type"] = "Work"
},



["LiderFavela03"] = {             
	["Parent"] = {
		["LiderFavela03"] = true
	},
	["Hierarchy"] = { "Lider"},
	["Service"] = {},
	["Type"] = "Work"
},
["Favela03"] = {             
	["Parent"] = {
		["Favela03"] = true
	},
	["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
	["Service"] = {},
	["Type"] = "Work"
},




["LiderFavela04"] = {             
	["Parent"] = {
		["LiderFavela04"] = true
	},
	["Hierarchy"] = { "Lider"},
	["Service"] = {},
	["Type"] = "Work"
},
["Favela04"] = {             
	["Parent"] = {
		["Favela04"] = true
	},
	["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
	["Service"] = {},
	["Type"] = "Work"
},




["LiderFavela05"] = {             
	["Parent"] = {
		["LiderFavela05"] = true
	},
	["Hierarchy"] = { "Lider"},
	["Service"] = {},
	["Type"] = "Work"
},
["Favela05"] = {             
	["Parent"] = {
		["Favela05"] = true
	},
	["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
	["Service"] = {},
	["Type"] = "Work"
},



["LiderFavela06"] = {             
	["Parent"] = {
		["LiderFavela06"] = true
	},
	["Hierarchy"] = { "Lider"},
	["Service"] = {},
	["Type"] = "Work"
},
["Favela06"] = {             
	["Parent"] = {
		["Favela06"] = true
	},
	["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
	["Service"] = {},
	["Type"] = "Work"
},


["LiderFavela07"] = {             
	["Parent"] = {
		["LiderFavela07"] = true
	},
	["Hierarchy"] = { "Lider"},
	["Service"] = {},
	["Type"] = "Work"
},
["Favela07"] = {             
	["Parent"] = {
		["Favela07"] = true
	},
	["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
	["Service"] = {},
	["Type"] = "Work"
},


["LiderFavela08"] = {             
	["Parent"] = {
		["LiderFavela08"] = true
	},
	["Hierarchy"] = { "Lider"},
	["Service"] = {},
	["Type"] = "Work"
},
["Favela08"] = {             
	["Parent"] = {
		["Favela08"] = true
	},
	["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
	["Service"] = {},
	["Type"] = "Work"
},


["LiderFavela09"] = {             
	["Parent"] = {
		["LiderFavela09"] = true
	},
	["Hierarchy"] = { "Lider"},
	["Service"] = {},
	["Type"] = "Work"
},
["Favela09"] = {             
	["Parent"] = {
		["Favela09"] = true
	},
	["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
	["Service"] = {},
	["Type"] = "Work"
},


["LiderFavela10"] = {             
	["Parent"] = {
		["LiderFavela10"] = true
	},
	["Hierarchy"] = { "Lider"},
	["Service"] = {},
	["Type"] = "Work"
},
["Favela10"] = {             
	["Parent"] = {
		["Favela10"] = true
	},
	["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
	["Service"] = {},
	["Type"] = "Work"
},



------------------------------------------------- ARMAS ------------------------------------
["LiderArmas1"] = {             
	["Parent"] = {
		["LiderArmas1"] = true
	},
	["Hierarchy"] = { "Lider"},
	["Service"] = {},
	["Type"] = "Work"
},
["Armas1"] = {             
	["Parent"] = {
		["Armas1"] = true
	},
	["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
	["Service"] = {},
	["Type"] = "Work"
},


["LiderArmas2"] = {             
	["Parent"] = {
		["LiderArmas2"] = true
	},
	["Hierarchy"] = { "Lider"},
	["Service"] = {},
	["Type"] = "Work"
},
["Armas2"] = {             
	["Parent"] = {
		["Armas2"] = true
	},
	["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
	["Service"] = {},
	["Type"] = "Work"
},

["LiderArmas3"] = {             
	["Parent"] = {
		["LiderArmas3"] = true
	},
	["Hierarchy"] = { "Lider"},
	["Service"] = {},
	["Type"] = "Work"
},
["Armas3"] = {             
	["Parent"] = {
		["Armas3"] = true
	},
	["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
	["Service"] = {},
	["Type"] = "Work"
},

------------------------------------ MUNICAO -------------------------------------------------

["LiderMunicao1"] = {             
	["Parent"] = {
		["LiderMunicao1"] = true
	},
	["Hierarchy"] = { "Lider"},
	["Service"] = {},
	["Type"] = "Work"
},
["Municao1"] = {             
	["Parent"] = {
		["Municao1"] = true
	},
	["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
	["Service"] = {},
	["Type"] = "Work"
},


["LiderMunicao2"] = {             
	["Parent"] = {
		["LiderMunicao2"] = true
	},
	["Hierarchy"] = { "Lider"},
	["Service"] = {},
	["Type"] = "Work"
},
["Municao2"] = {             
	["Parent"] = {
		["Municao2"] = true
	},
	["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
	["Service"] = {},
	["Type"] = "Work"
},

["LiderMunicao3"] = {             
	["Parent"] = {
		["LiderMunicao3"] = true
	},
	["Hierarchy"] = { "Lider"},
	["Service"] = {},
	["Type"] = "Work"
},
["Municao3"] = {             
	["Parent"] = {
		["Municao3"] = true
	},
	["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
	["Service"] = {},
	["Type"] = "Work"
},

--------------------------------------------- RESTAURANTES -------------------------------------
["LiderYakuza"] = {
	["Parent"] = {
		["LiderYakuza"] = true
	},
	["Hierarchy"] = { "Chefe"},
	["Salary"] = { 10 },
	["Service"] = {},
	["Type"] = "Work"
},
["Yakuza"] = {
	["Parent"] = {
		["Yakuza"] = true
	},
	["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Supervisor","Mecânico" },
	["Salary"] = { 12000,9000,7000,5000,3000 },
	["Service"] = {},
	["Type"] = "Work"
},
["LiderMcdonalds"] = {
	["Parent"] = {
		["LiderMcdonalds"] = true
	},
	["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Supervisor","Membro" },
	["Salary"] = { 1500,1200,1000,800,500 },
	["Service"] = {},
	["Type"] = "Work"
},
["Mcdonalds"] = {
	["Parent"] = {
		["Mcdonalds"] = true
	},
	["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Supervisor","Membro" },
	["Salary"] = { 6000,4000,3300,2500,1500 },
	["Service"] = {},
	["Type"] = "Work"
},
["LiderUwucoffee"] = {
	["Parent"] = {
		["LiderUwucoffee"] = true
	},
	["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Supervisor","Vendedor" },
	["Salary"] = { 1500,1200,1000,800,500 },
	["Service"] = {},
	["Type"] = "Work"
},
["Uwucoffee"] = {
	["Parent"] = {
		["Uwucoffee"] = true
	},
	["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Supervisor","Vendedor" },
	["Salary"] = { 1500,1200,1000,800,500 },
	["Service"] = {},
	["Type"] = "Work"
},

-------------------------------------------------------------------------------------------------
	["Modelo"] = {
		["Parent"] = {
			["Modelo"] = true,
		},
		["Hierarchy"] = { "Absolut Modelo" },
		["Salary"] = { 2000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Influencer"] = {
		["Parent"] = {
			["Influencer"] = true
		},
		["Hierarchy"] = { "Absolut Infuence" },
		["Salary"] = { 3000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Celebridade"] = {
		["Parent"] = {
			["Celebridade"] = true
		},
		["Hierarchy"] = { "Absolut Celebridade" },
		["Salary"] = { 4000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Skinshop"] = {
		["Parent"] = {
			["Skinshop"] = true
		},
		["Hierarchy"] = { "Chefe" },
		["Salary"] = {},
		["Service"] = {},
		["Type"] = "Work"
	},
	["Streamer"] = {
		["Parent"] = {
			["Streamer"] = true
		},
		["Hierarchy"] = { "Chefe" },
		["Salary"] = { 3000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Cam"] = {
		["Parent"] = {
			["Cam"] = true
		},
		["Hierarchy"] = { "Chefe" },
		["Salary"] = {},
		["Service"] = {},
		["Type"] = "Work"
	},
	["Som"] = {
		["Parent"] = {
			["Som"] = true
		},
		["Hierarchy"] = { "Chefe" },
		["Salary"] = {},
		["Service"] = {},
		["Type"] = "Work"
	},
	["Atachs"] = {
		["Parent"] = {
			["Atachs"] = true
		},
		["Hierarchy"] = { "Chefe" },
		["Salary"] = {},
		["Service"] = {},
		["Type"] = "Work"
	},
	["VerificadoInsta"] = {
		["Parent"] = {
			["VerificadoInsta"] = true
		},
		["Hierarchy"] = { "Verificado" },
		["Service"] = {},
		["Type"] = "Work"
	},

	["MultiInsta"] = {
		["Parent"] = {
			["MultiInsta"] = true
		},
		["Hierarchy"] = { "MultiInsta" },
		["Service"] = {},
		["Type"] = "Work"
	},

	--------------------------------------------------------------
	
	-- GRUPO EMERGENCY ATUALIZADO COM TODOS OS GRUPOS POLICIAIS
	["Emergency"] = {
		["Parent"] = {
			["PoliciaMilitar"] = true,
			["Core"] = true,
			["Judiciary"] = true,
			["PRF"] = true,
			["PCivil"] = true,
			["Paramedic"] = true
		},
		["Hierarchy"] = { "Chefe" },
		["Service"] = {}
	},
	["Restaurants"] = {
		["Parent"] = {
			["Mcdonalds"] = true,
			["Yakuza"] = true,
			["Uwucoffee"] = true

		},
		["Hierarchy"] = { "Chefe" },
		["Service"] = {}
	}
}