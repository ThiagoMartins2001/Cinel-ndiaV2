-- Debug para Baús
-- Adicione este arquivo ao fxmanifest.lua se necessário

CreateThread(function()
    Wait(10000) -- Aguarda 10 segundos para carregar tudo
    
    -- Verificar se Chests existe
    if not Chests then
        print("❌ Variável Chests não encontrada")
        return
    end
    
    print("=== DEBUG BAÚS ===")
    for Name, v in pairs(Chests) do
        print("Baú: " .. Name)
        print("Coordenadas: " .. v["Coords"].x .. ", " .. v["Coords"].y .. ", " .. v["Coords"].z)
        print("Mode: " .. v["Mode"])
        print("---")
    end
    
    -- Verificar se o target está funcionando
    if exports["target"] then
        print("✅ Target system está disponível")
    else
        print("❌ Target system NÃO está disponível")
    end
end)

-- Comando para testar baús
RegisterCommand("testbaues", function()
    -- Verificar se Chests existe
    if not Chests then
        print("❌ Variável Chests não encontrada. Aguarde o carregamento...")
        return
    end
    
    local playerCoords = GetEntityCoords(PlayerPedId())
    print("=== TESTE BAÚS ===")
    print("Sua posição: " .. playerCoords.x .. ", " .. playerCoords.y .. ", " .. playerCoords.z)
    
    for Name, v in pairs(Chests) do
        local distance = #(playerCoords - v["Coords"])
        print("Baú " .. Name .. " - Distância: " .. distance .. " metros")
        
        if distance < 10.0 then
            print("🎯 Baú próximo encontrado: " .. Name)
        end
    end
end, false)
