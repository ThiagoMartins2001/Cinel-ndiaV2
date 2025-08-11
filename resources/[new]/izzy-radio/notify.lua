function notify(message, complement)
    if complement then
	    TriggerEvent('Notify', 'aviso', getMessage(message)..""..complement, 5000)
    else
        TriggerEvent('Notify', 'aviso', getMessage(message), 5000)
    end
end

function getMessage(message)
    return Config.Locale[message]
end