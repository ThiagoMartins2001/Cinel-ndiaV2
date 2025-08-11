RegisterNuiCallback("fabricarItem",function(data, cb)
	if Routes.inService then
		TriggerEvent("Notify","negado","Você já está em uma rota de coleta!",5000)
		return
	end

	SetNuiFocus(false,false)
	TransitionFromBlurred(0)
	SendNUIMessage({ action = 'close' })
	
	Routes:initRoutes(data.item,data.direction)
	cb(true)
end)

RegisterNuiCallback("closeNui",function(data,cb)
	SetNuiFocus(false,false)
	TransitionFromBlurred(0)
	cb({})
end)