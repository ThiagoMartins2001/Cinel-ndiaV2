-----------------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO: COMO ADICIONAR MAIS LOCAIS DE ADRENALINA
-----------------------------------------------------------------------------------------------------------------------------------------

-- Para adicionar novos locais, edite o arquivo "adrenaline_locations.lua" 
-- e adicione novas entradas na tabela AdrenalineLocations:

-- EXEMPLO 1: Hospital
-- { ["Name"] = "Hospital Novo", ["Coords"] = vec3(1234.56, 789.01, 45.67), ["Radius"] = 50.0 },

-- EXEMPLO 2: Posto de Saúde Pequeno
-- { ["Name"] = "Posto de Saúde", ["Coords"] = vec3(987.65, 432.10, 23.45), ["Radius"] = 25.0 },

-- EXEMPLO 3: Clínica Privada
-- { ["Name"] = "Clínica Especializada", ["Coords"] = vec3(555.44, 333.22, 11.11), ["Radius"] = 35.0 },

-- EXEMPLO 4: Ambulância (local dinâmico)
-- { ["Name"] = "Ambulância", ["Coords"] = vec3(0, 0, 0), ["Radius"] = 10.0, ["Dynamic"] = true },

-----------------------------------------------------------------------------------------------------------------------------------------
-- COORDENADAS ÚTEIS PARA LOCAIS MÉDICOS
-----------------------------------------------------------------------------------------------------------------------------------------

-- Hospitais Principais:
-- Hospital Central: vec3(295.83, -1446.94, 29.97)
-- Hospital Pillbox: vec3(311.83, -593.31, 43.08)
-- Hospital Sandy Shores: vec3(1839.32, 3672.47, 34.28)
-- Hospital Paleto Bay: vec3(-247.07, 6331.5, 32.43)

-- Postos de Saúde:
-- Posto Vinewood: vec3(360.97, -585.84, 28.82)
-- Posto Grove Street: vec3(114.47, -784.95, 31.31)
-- Posto Del Perro: vec3(-1037.74, -2738.04, 20.17)

-- Clínicas Privadas:
-- Clínica Vespucci: vec3(-1091.49, -2744.34, 21.36)
-- Clínica Rockford Hills: vec3(-449.67, -340.83, 34.50)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DICAS PARA CONFIGURAÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------

-- 1. Use raios maiores (40-50m) para hospitais grandes
-- 2. Use raios menores (20-30m) para postos de saúde
-- 3. Teste sempre com o comando /testadrenalinelocation
-- 4. Considere a densidade populacional da área
-- 5. Evite sobreposição de áreas muito grandes

-- Para encontrar coordenadas de um local:
-- 1. Vá até o local desejado no jogo
-- 2. Use o comando /coords (se disponível)
-- 3. Ou use o comando /testadrenalinelocation para testar
