-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS PARA USO DE ADRENALINA
-----------------------------------------------------------------------------------------------------------------------------------------
local AdrenalineLocations = {
    -- Local Específico para Adrenalina
    { ["Name"] = "Local de Adrenalina", ["Coords"] = vec3(808.80,-494.76,30.69), ["Radius"] = 5.0 }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- VERIFICAR SE ESTÁ EM LOCAL PERMITIDO
-----------------------------------------------------------------------------------------------------------------------------------------
function IsInAdrenalineLocation(playerCoords)
    print("^3[DEBUG]^7 Verificando localização: " .. playerCoords.x .. ", " .. playerCoords.y .. ", " .. playerCoords.z)
    
    for _, location in pairs(AdrenalineLocations) do
        local distance = #(playerCoords - location["Coords"])
        print("^3[DEBUG]^7 Distância até " .. location["Name"] .. ": " .. distance .. "m (máximo: " .. location["Radius"] .. "m)")
        
        if distance <= location["Radius"] then
            print("^2[DEBUG]^7 ✅ Local permitido: " .. location["Name"])
            return true, location["Name"]
        end
    end
    
    print("^1[DEBUG]^7 ❌ Nenhum local permitido encontrado")
    return false, nil
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTAR FUNÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------
exports("IsInAdrenalineLocation", IsInAdrenalineLocation)
exports("GetAdrenalineLocations", function() return AdrenalineLocations end)
