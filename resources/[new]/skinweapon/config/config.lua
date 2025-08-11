-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
command = "skins" -- comando para abrir o sistema de skins pelo server
perm = false -- permissão para abrir o sistema de skins pelo server, coloque "false" para não precisar de permissão
showfirst = { -- primeira skin que irá aparecer ao abrir o skinweapon
	skin = "COMPONENT_FIVESEVEN_AI", -- nome do componente da skin
	weapon = "WEAPON_PISTOL_MK2" -- nome da arma
}

createAuto = true
prints = true
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINGLOBAL
-----------------------------------------------------------------------------------------------------------------------------------------
-- "<b>Lendária</b>" "<b1>Épica</b1>" "<b2>Rara</b2>" "Normal"
skinglobal = {
	["COMPONENT_FIVESEVEN_AA"] = { "Five Seven Korea",30,"WEAPON_PISTOL_MK2","Pistol","<b1>Épica</b1>", 20 },
	["COMPONENT_FIVESEVEN_AI"] = { "Five Seven Hello Kitty",30,"WEAPON_PISTOL_MK2","Pistol","<b1>Épica</b1>", 20 },
	["COMPONENT_FIVESEVEN_AJ"] = { "Five Seven Alien",30,"WEAPON_PISTOL_MK2","Pistol","<b1>Épica</b1>", 20 },
	["COMPONENT_FIVESEVEN_AM"] = { "Five Seven Mexico",30,"WEAPON_PISTOL_MK2","Pistol","<b1>Épica</b1>", 20 },
	["COMPONENT_FIVESEVEN_AO"] = { "Five Seven Nike X",30,"WEAPON_PISTOL_MK2","Pistol","<b1>Épica</b1>", 20 },
	["COMPONENT_FIVESEVEN_AP"] = { "Five Seven My X",30,"WEAPON_PISTOL_MK2","Pistol","<b1>Épica</b1>", 20 },
	["COMPONENT_FIVESEVEN_AR"] = { "Five Seven Vulcão",30,"WEAPON_PISTOL_MK2","Pistol","<b1>Épica</b1>", 20 },
	["COMPONENT_FIVESEVEN_AT"] = { "Five Seven Nike Smile",30,"WEAPON_PISTOL_MK2","Pistol","<b1>Épica</b1>", 20 },
	["COMPONENT_FIVESEVEN_NV"] = { "Five Seven Nike V.",30,"WEAPON_PISTOL_MK2","Pistol","<b1>Épica</b1>", 20 },
	["COMPONENT_FIVESEVEN_BARBIE"] = { "Five Seven Barbie",30,"WEAPON_PISTOL_MK2","Pistol","<b1>Épica</b1>", 20 },
	["COMPONENT_GLOCK_SNACKCLUB"] = { "Glock Snack Club",30,"WEAPON_COMBATPISTOL","Pistol","<b1>Épica</b1>", 20 },
	["COMPONENT_GLOCK_SEATERROR"] = { "Glock Sea Terror",30,"WEAPON_COMBATPISTOL","Pistol","<b1>Épica</b1>", 20 },
	["COMPONENT_GLOCK_REDSAMURAI"] = { "Glock Red Samurai",30,"WEAPON_COMBATPISTOL","Pistol","<b1>Épica</b1>", 20 },
	["COMPONENT_GLOCK_BT"] = { "Glock Gaiden",30,"WEAPON_COMBATPISTOL","Pistol","<b1>Épica</b1>", 20 },
	["COMPONENT_GLOCK_BW"] = { "Glock Royal Salute",30,"WEAPON_COMBATPISTOL","Pistol","<b1>Épica</b1>", 20 },
	["COMPONENT_GLOCK_CH"] = { "Glock Nike France",30,"WEAPON_COMBATPISTOL","Pistol","<b1>Épica</b1>", 20 },
	["COMPONENT_GLOCK_CI"] = { "Glock Cyclone",30,"WEAPON_COMBATPISTOL","Pistol","<b1>Épica</b1>", 20 },
	["COMPONENT_AK47_SKIN"] = { "AK-47 Dragon",60,"WEAPON_ASSAULTRIFLE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_AK47_MARK_SKIN"] = { "AK-47 Mark",60,"WEAPON_ASSAULTRIFLE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_AK47_TOE_SKIN"] = { "AK-47 Skeleton Red",60,"WEAPON_ASSAULTRIFLE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_AK47_WH_SKIN"] = { "AK-47 Rosa",60,"WEAPON_ASSAULTRIFLE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_AK47_WHITE_SKIN"] = { "AK-47 My X",60,"WEAPON_ASSAULTRIFLE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_AK47_WHITEB_SKIN"] = { "AK-47 My X 2",60,"WEAPON_ASSAULTRIFLE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_AK47_PARTEN_SKIN"] = { "AK-47 Cromada",60,"WEAPON_ASSAULTRIFLE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_AK47_YE_SKIN"] = { "AK-47 Banana Joy",60,"WEAPON_ASSAULTRIFLE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_AK47_AH_SKIN"] = { "AK-47 Monster",60,"WEAPON_ASSAULTRIFLE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_AK47_AA_SKIN"] = { "AK-47 MK2 Pink",60,"WEAPON_ASSAULTRIFLE_MK2","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_AK47_AB_SKIN"] = { "AK-47 MK2 Noturna Blue",60,"WEAPON_ASSAULTRIFLE_MK2","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_AK47_AC_SKIN"] = { "AK-47 MK2 Gelo",60,"WEAPON_ASSAULTRIFLE_MK2","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_AK47_AE_SKIN"] = { "AK-47 MK2 Roxo",60,"WEAPON_ASSAULTRIFLE_MK2","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_AK47_AG_SKIN"] = { "AK-47 MK2 Noturna Green",60,"WEAPON_ASSAULTRIFLE_MK2","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_AK47_AI_SKIN"] = { "AK-47 MK2 Hulk",60,"WEAPON_ASSAULTRIFLE_MK2","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_AK47_AK_SKIN"] = { "AK-47 MK2 Have",60,"WEAPON_ASSAULTRIFLE_MK2","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_AK47_AL_SKIN"] = { "AK-47 MK2 Water",60,"WEAPON_ASSAULTRIFLE_MK2","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_AK47_AM_SKIN"] = { "AK-47 MK2 Cinza",60,"WEAPON_ASSAULTRIFLE_MK2","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_AK47_AN_SKIN"] = { "AK-47 MK2 Bolt Black",60,"WEAPON_ASSAULTRIFLE_MK2","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_AK47_AQ_SKIN"] = { "AK-47 MK2 Minerva Purple",60,"WEAPON_ASSAULTRIFLE_MK2","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_M4_AD_SKIN"] = { "M4 Neon",60,"WEAPON_CARBINERIFLE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_M4_AL_SKIN"] = { "M4 Dragon Red",60,"WEAPON_CARBINERIFLE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_M4_AM_SKIN"] = { "M4 AM",60,"WEAPON_CARBINERIFLE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_M4_AR_SKIN"] = { "M4 Dragon Purple",60,"WEAPON_CARBINERIFLE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_M4_AS_SKIN"] = { "M4 Dragon Blue",60,"WEAPON_CARBINERIFLE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_M4_COLT_SKIN"] = { "M4 Colt",60,"WEAPON_CARBINERIFLE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_M4_DK_SKIN"] = { "M4 DK",60,"WEAPON_CARBINERIFLE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_M4_DRAGON_SKIN"] = { "M4 Dragon",60,"WEAPON_CARBINERIFLE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_M4_GR_SKIN"] = { "M4 Griffin",60,"WEAPON_CARBINERIFLE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_M4_HUNTER_SKIN"] = { "M4 Hunter",60,"WEAPON_CARBINERIFLE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_M4_W_SKIN"] = { "M4 W",60,"WEAPON_CARBINERIFLE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_M4_MK2_AJ_SKIN"] = { "M4 MK2 Mark",60,"WEAPON_CARBINERIFLE_MK2","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_M4_MK2_BL_SKIN"] = { "M4 MK2 BL",60,"WEAPON_CARBINERIFLE_MK2","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_G3_BB"] = { "G3 Branco Brasil",60,"WEAPON_SPECIALCARBINE_MK2","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_G3_CA"] = { "G3 Camaleao",60,"WEAPON_SPECIALCARBINE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_G3_PB"] = { "G3 Preto Brasil",60,"WEAPON_SPECIALCARBINE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_G3_RAE"] = { "G3 Rosa Espelhado",60,"WEAPON_SPECIALCARBINE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_G3_SUB"] = { "G3 Sublime",60,"WEAPON_SPECIALCARBINE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_G3_BRIN"] = { "G3 Brinquedo",60,"WEAPON_SPECIALCARBINE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_G3_ANCI"] = { "G3 Ancifogo",60,"WEAPON_SPECIALCARBINE","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_G3_MK2_GP"] = { "G3 MK2 Glitchpop",60,"WEAPON_SPECIALCARBINE_MK2","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_G3_MK2_ONI"] = { "G3 MK2 Oni",60,"WEAPON_SPECIALCARBINE_MK2","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_G3_MK2_RGX"] = { "G3 MK2 Rgx",60,"WEAPON_SPECIALCARBINE_MK2","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_G3_MK2_SAQ"] = { "G3 MK2 Saqueadora",60,"WEAPON_SPECIALCARBINE_MK2","Rifle","<b>Lendária</b>", 20 },
	["COMPONENT_G3_MK2_SING"] = { "G3 MK2 Singularidade",60,"WEAPON_SPECIALCARBINE_MK2","Rifle","<b>Lendária</b>", 20 },
}