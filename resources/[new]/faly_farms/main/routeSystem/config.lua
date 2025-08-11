ConfigMainRoutes = {}

ConfigMainRoutes.images = {
	url = "http://45.146.81.222/inventory/",
	
	format = ".png"
}

ConfigMainRoutes.distAlt = 10 --Distancia  minima de alternancia entre uma rota e outra
ConfigMainRoutes.timeAlt = 10 --Tempo minimo de alternancia entre uma rota e outra ( Segundos )
ConfigMainRoutes.freezeTime = 1 --Tempo de freeze ( Segundos )

ConfigMainRoutes.textBlip = {
	text = "Pressione ~g~E~w~ para acessar as rotas.",
	textCollect = "Pressione ~g~E~w~ para coletar.",
}

ConfigMainRoutes.mainBlips = {

	--[ Armas ]--

	{ coords = vec3(1380.36,-1298.09,75.64), typeRoute = "Armas1", typeReward = "Armas1", permissions = {"Armas1"} },
	{ coords = vec3(1334.89,-681.36,75.86), typeRoute = "Armas2", typeReward = "Armas2", permissions = {"Armas2"} },

	--[ MUNICAO ]--
	{ coords = vec3(-312.94,1518.55,367.73), typeRoute = "Municao1", typeReward = "Municao1", permissions = {"Municao1"} },  --------- FAVELA Municao1
	{ coords = vec3(2518.57,4098.15,35.59), typeRoute = "Thelost", typeReward = "Thelost", permissions = {"Thelost"} },  --------- THE LOST Municao2

	

	--[ Mechanic ]--

	{ coords = vec3(875.85,-2097.42,30.48), typeRoute = "Mechanic", typeReward = "Mechanic", permissions = {"Mechanic"} },


	--[ DROGAS ]--
	{ coords = vec3(1269.51,-127.55,84.69), typeRoute = "Favela01", typeReward = "Favela01", permissions = {"Favela01"} },  --------- DISPONIVEL COCAINA ----------- AGORA E MUNICAO
	{ coords = vec3(2006.22,449.31,171.41), typeRoute = "Favela02", typeReward = "Favela02", permissions = {"Favela02"} },  --------- LEAN FAVELA02 
	{ coords = vec3(878.21,1034.35,283.67), typeRoute = "Favela03", typeReward = "Favela03", permissions = {"Favela03"} },  --------- META FAVELA03
	{ coords = vec3(803.32,-293.76,69.45), typeRoute = "Favela04", typeReward = "Favela04", permissions = {"Favela04"} },  --------- ECSTASY FAVELA04
	{ coords = vec3(-1865.93,2061.25,135.44), typeRoute = "Favela05", typeReward = "Favela05", permissions = {"Favela05"} },  --------- MACONHA FAVELA05

	{ coords = vec3(-1249.02,-801.03,17.83), typeRoute = "Ifrutrota", typeReward = "Ifrutrota", permissions = {"Ifrut"} },  --------- DIGITAL DEN

	{ coords = vec3(171.5,-1316.87,29.35), typeRoute = "Pawnshop", typeReward = "Pawnshop", permissions = {"Pawnshop"} },  --------- LAVAGEM PAWNSHOP 

	{ coords = vec3(951.55,-967.75,39.75), typeRoute = "Mechanic", typeReward = "Mechanic", permissions = {"Mechanic"} },  --------- Mechanic  

	
	{ coords = vec3(236.5,1769.33,211.75), typeRoute = "Favela06", typeReward = "Favela06", permissions = {"Favela06"} },  --------- Desmanche  

	{ coords = vec3(-75.07,15.3,72.93), typeRoute = "Mcdonalds", typeReward = "Mcdonalds", permissions = {"Mcdonalds"} },  --------- Mcdonalds

	{ coords = vec3(1272.47,-127.35,84.69), typeRoute = "Favela01-2", typeReward = "Favela01-2", permissions = {"Favela01"} },  --------- favela1
	


	
	
	

	-- { coords = vec3(1475.0,-685.95,108.26), typeRoute = "Drogas", typeReward = "Drogas", permissions = {"Vagos"} },
	-- { coords = vec3(2304.47,943.88,108.58), typeRoute = "Drogas", typeReward = "Drogas", permissions = {"Families"} },
	-- { coords = vec3(3053.04,2927.32,80.39), typeRoute = "Drogas", typeReward = "Drogas", permissions = {"Bloods"} }


}