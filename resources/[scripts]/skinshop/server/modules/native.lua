-----------------------------------------------------------------------------------------------------------------------------------------
-- CARREGA EMOJI DO COMANDO
-----------------------------------------------------------------------------------------------------------------------------------------
function emoji(Passport)
	local Pass = tostring(Passport)
	if Staffs[Pass] then
		local emoji = Staffs[Pass].emoji
		if emoji == '' then
			return '🚻'
		else
			return emoji				
		end
	end
	return '🚻'
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MUDA A COR DO DISCORD AZUL E PRETO
-----------------------------------------------------------------------------------------------------------------------------------------
function colorblueblack(last_color)
	local color = math.random(0, 1)
	if color == 0 then
		color = 21247
	else
		color = 2369063
	end
	while color == last_color do
		color = math.random(0, 1)
		if color == 0 then
			color = 21247
		else
			color = 2369063
		end
	end
	return color
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORD
-----------------------------------------------------------------------------------------------------------------------------------------
function SkinshopDiscord(WebHooks,Info,Title,Passport)
	
	local source = source
	local Passport =  Passport
    local Image = 'https://cdn.discordapp.com/attachments/1073567170400878723/1074824373959143444/skinshop.png'
	if Passport then
		Color = colorblueblack(Last_Color)
		Last_Color = Color
		Description = '``` \n    › '..Info..' \n ```'
        SendDiscordsSkinshop(WebHooks, Passport, Title, Description, Color, Image)
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDO
-----------------------------------------------------------------------------------------------------------------------------------------
function cmd(command)
	if commands[command] then
		return commands[command].cmd
	end
	return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDO ATIVO
-----------------------------------------------------------------------------------------------------------------------------------------
function ativo(command)
	if commands[command] then
		if commands[command].ativo == 'true' then
			return false
		end
	end
	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VERIFICA LOG ATIVO
-----------------------------------------------------------------------------------------------------------------------------------------
function discord(command)
	if commands[command] then
		if commands[command].log == 'true' then
			return true
		end
	end
	return false
end