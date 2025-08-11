-----------------------------------------------------------------------------------------------------------------------------------------
-- TESTE DO SISTEMA DE ADRENALINA
-----------------------------------------------------------------------------------------------------------------------------------------

-- Comando para testar se o sistema está funcionando
RegisterCommand("testadrenaline", function()
    print("=== TESTE DO SISTEMA DE ADRENALINA ===")
    
    -- Teste 1: Verificar se os arquivos estão carregados
    if exports["paramedic"]:IsInAdrenalineLocation then
        print("✅ Função IsInAdrenalineLocation carregada")
    else
        print("❌ Função IsInAdrenalineLocation não encontrada")
    end
    
    if exports["paramedic"]:GetAdrenalineConfig then
        print("✅ Função GetAdrenalineConfig carregada")
    else
        print("❌ Função GetAdrenalineConfig não encontrada")
    end
    
    if exports["paramedic"]:GetAdrenalineLocations then
        print("✅ Função GetAdrenalineLocations carregada")
    else
        print("❌ Função GetAdrenalineLocations não encontrada")
    end
    
    -- Teste 2: Verificar configuração
    local config = exports["paramedic"]:GetAdrenalineConfig()
    if config then
        print("✅ Configuração carregada:")
        print("   - Tempo de aplicação: " .. config.ApplicationTime .. "ms")
        print("   - Vida após reanimação: " .. config.ReviveHealth)
        print("   - Distância máxima: " .. config.MaxDistance .. "m")
    else
        print("❌ Configuração não encontrada")
    end
    
    -- Teste 3: Verificar locais
    local locations = exports["paramedic"]:GetAdrenalineLocations()
    if locations then
        print("✅ " .. #locations .. " locais configurados:")
        for i, location in ipairs(locations) do
            print("   " .. i .. ". " .. location.Name .. " (Raio: " .. location.Radius .. "m)")
            print("      Coordenadas: " .. location.Coords.x .. ", " .. location.Coords.y .. ", " .. location.Coords.z)
        end
    else
        print("❌ Locais não encontrados")
    end
    
    -- Teste 4: Verificar posição atual
    local playerCoords = GetEntityCoords(PlayerPedId())
    local isInLocation, locationName = exports["paramedic"]:IsInAdrenalineLocation(playerCoords)
    
    print("📍 Sua posição atual: " .. playerCoords.x .. ", " .. playerCoords.y .. ", " .. playerCoords.z)
    
    if isInLocation then
        print("✅ Você está em local permitido: " .. locationName)
    else
        print("❌ Você NÃO está em local permitido")
    end
    
    print("=== FIM DO TESTE ===")
end, false)

-- Comando para debug detalhado
RegisterCommand("debugadrenaline", function()
    print("=== DEBUG DETALHADO ADRENALINA ===")
    
    local playerCoords = GetEntityCoords(PlayerPedId())
    print("📍 Sua posição: " .. playerCoords.x .. ", " .. playerCoords.y .. ", " .. playerCoords.z)
    
    -- Testar manualmente a verificação
    local locations = exports["paramedic"]:GetAdrenalineLocations()
    if locations then
        for i, location in ipairs(locations) do
            local distance = #(playerCoords - location.Coords)
            print("📏 Distância até " .. location.Name .. ": " .. distance .. "m")
            print("   Coordenadas do local: " .. location.Coords.x .. ", " .. location.Coords.y .. ", " .. location.Coords.z)
            print("   Raio permitido: " .. location.Radius .. "m")
            
            if distance <= location.Radius then
                print("   ✅ DENTRO DO RAIO PERMITIDO")
            else
                print("   ❌ FORA DO RAIO PERMITIDO")
            end
        end
    end
    
    print("=== FIM DO DEBUG ===")
end, false)

-- Comando para simular uso de adrenalina (apenas para teste)
RegisterCommand("simulateadrenaline", function()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local isInLocation, locationName = exports["paramedic"]:IsInAdrenalineLocation(playerCoords)
    
    if isInLocation then
        print("🎯 Simulando uso de adrenalina em: " .. locationName)
        
        -- Simular animação
        local config = exports["paramedic"]:GetAdrenalineConfig()
        TriggerEvent("Progress", "Aplicando Adrenalina (SIMULAÇÃO)", 3000)
        
        -- Simular notificação
        SetTimeout(3000, function()
            TriggerEvent("Notify", "verde", "Adrenalina aplicada com sucesso em " .. locationName .. "! (SIMULAÇÃO)", 5000)
        end)
    else
        print("❌ Não é possível simular uso fora de local permitido")
        TriggerEvent("Notify", "vermelho", "Você só pode usar adrenalina em locais médicos autorizados! (SIMULAÇÃO)", 5000)
    end
end, false)

-- Comando para mostrar informações detalhadas
RegisterCommand("adrenalineinfo", function()
    print("=== INFORMAÇÕES DO SISTEMA DE ADRENALINA ===")
    
    local config = exports["paramedic"]:GetAdrenalineConfig()
    local locations = exports["paramedic"]:GetAdrenalineLocations()
    
    print("📋 CONFIGURAÇÃO:")
    print("   Tempo de aplicação: " .. config.ApplicationTime .. "ms")
    print("   Vida após reanimação: " .. config.ReviveHealth)
    print("   Pontos de sede/fome: " .. config.ThirstPoints .. "/" .. config.HungerPoints)
    print("   Distância máxima: " .. config.MaxDistance .. "m")
    print("   Verificar paramédicos: " .. tostring(config.Security.CheckParamedics))
    print("   Logs habilitados: " .. tostring(config.Security.EnableLogs))
    
    print("\n🏥 LOCAIS AUTORIZADOS:")
    for i, location in ipairs(locations) do
        print("   " .. i .. ". " .. location.Name)
        print("      Coordenadas: " .. location.Coords.x .. ", " .. location.Coords.y .. ", " .. location.Coords.z)
        print("      Raio: " .. location.Radius .. "m")
    end
    
    print("\n💡 COMO USAR:")
    print("   1. Vá até um local autorizado")
    print("   2. Tenha o item 'Adrenalina' no inventário")
    print("   3. Clique no item próximo a uma pessoa desacordada")
    print("   4. Aguarde 8 segundos para a aplicação")
    
    print("\n🔧 COMANDOS DISPONÍVEIS:")
    print("   /testadrenalinelocation - Testa se está em local permitido")
    print("   /testadrenaline - Testa o sistema completo")
    print("   /simulateadrenaline - Simula uso de adrenalina")
    print("   /adrenalineinfo - Mostra estas informações")
    
    print("=== FIM DAS INFORMAÇÕES ===")
end, false)
