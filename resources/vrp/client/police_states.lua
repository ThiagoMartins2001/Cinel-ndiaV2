-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE STATES
-----------------------------------------------------------------------------------------------------------------------------------------
-- Sistema para gerenciar os estados dos grupos policiais no client-side

-- Evento para definir o estado do jogador quando entra em serviço
RegisterNetEvent("police:setState")
AddEventHandler("police:setState", function(group, state)
    if group and state ~= nil then
        LocalPlayer["state"]:set(group, state, false)
        print("^2[POLICE STATES] ^7Estado " .. group .. " definido como: " .. tostring(state))
    end
end)

-- Evento para limpar todos os estados policiais
RegisterNetEvent("police:clearStates")
AddEventHandler("police:clearStates", function()
    LocalPlayer["state"]:set("PoliciaMilitar", false, false)
    LocalPlayer["state"]:set("Core", false, false)
    LocalPlayer["state"]:set("PRF", false, false)
    LocalPlayer["state"]:set("PCivil", false, false)
    print("^2[POLICE STATES] ^7Todos os estados policiais foram limpos")
end)

-- Comando para testar os estados (apenas para debug)
RegisterCommand("teststates", function()
    print("^3=== ESTADOS POLICIAIS ===")
    print("PoliciaMilitar: " .. tostring(LocalPlayer["state"]["PoliciaMilitar"]))
    print("Core: " .. tostring(LocalPlayer["state"]["Core"]))
    print("PRF: " .. tostring(LocalPlayer["state"]["PRF"]))
    print("PCivil: " .. tostring(LocalPlayer["state"]["PCivil"]))
    print("Paramedic: " .. tostring(LocalPlayer["state"]["Paramedic"]))
    print("^3========================")
end, false)
