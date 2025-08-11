-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("notify")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Shortcuts = false

Config_Notifys = module("base", "config/notifys")
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------

local tabelas = {
	["verde"] = { texto = "sucesso", svg_box = "box" },
	["vermelho"] = { texto = "negado", svg_box = "box" },
	["amarelo"] = { texto = "aviso", svg_box = "box" },
	["azul"] = { texto = "importante", svg_box = "box" },
	["sucesso"] = { texto = "sucesso", svg_box = "box" },
	["negado"] = { texto = "negado", svg_box = "box" },
	["aviso"] = { texto = "aviso", svg_box = "box" },
	["importante"] = { texto = "importante", svg_box = "box" },
	["blood"] = { texto = "sangramento", svg_box = "box" },
	["hunger"] = { texto = "fome", svg_box = "box" },
	["thirst"] = { texto = "sede", svg_box = "box" },
	["policia"] = { texto = "policia", svg_box = "box" },
	["locked"] = { texto = "garagem", svg_box = "box" },
	["unlocked"] = { texto = "garagem", svg_box = "box" },
	["staff"] = { texto = "prefeitura", svg_box = "box2" },
}

RegisterNetEvent("Notify")
AddEventHandler("Notify",function(css,mensagem,timer)
	local textn = "aviso"
	local box_default = "box"
	if tabelas[css] then
		textn = tabelas[css].texto
		box_default = tabelas[css].svg_box
	else
		textn = "aviso"
		box_default = "box"
	end 

	if not timer then
		timer = 10000
	end
	SendNUIMessage({ css = css, mensagem = mensagem, timer = timer, notify = true, textn = textn, box = box_default })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOWSHORTCUTS
-----------------------------------------------------------------------------------------------------------------------------------------
function showShortcuts()
	if not Shortcuts then
		SendNUIMessage({ shortcuts = true, shorts = vSERVER.Shortcuts() })
		Shortcuts = true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HIDESHORTCUTS
-----------------------------------------------------------------------------------------------------------------------------------------
function hideShortcuts()
	SendNUIMessage({ shortcuts = false })
	Shortcuts = false
end


