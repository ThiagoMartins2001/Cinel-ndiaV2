# Adaptações do MDT para a Framework Atual

## Resumo das Adaptações

O sistema MDT foi adaptado para funcionar com a framework VRP atual, incluindo as seguintes modificações:

## 1. Estrutura de Dados

### Tabela `characters`
- **Campo `name`**: Nome do personagem
- **Campo `name2`**: Sobrenome do personagem (anteriormente `lastname`)
- **Campo `id`**: ID único do personagem (passaporte)
- **Campo `phone`**: Telefone do personagem

### Adaptações Realizadas:
- Substituído `user.lastname` por `user.name2`
- Substituído `targetUser.lastname` por `targetUser.name2`
- Adaptado todas as funções para usar a estrutura correta

## 2. Queries Adicionadas

### Tabelas Criadas Automaticamente:
```sql
-- Tabela de prisões
CREATE TABLE IF NOT EXISTS `prison` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `police` varchar(100) NOT NULL,
    `nuser_id` int(11) NOT NULL,
    `services` int(11) DEFAULT 0,
    `fines` int(11) DEFAULT 0,
    `text` text,
    `date` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
);

-- Tabela de mandados
CREATE TABLE IF NOT EXISTS `warrants` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `user_id` int(11) NOT NULL,
    `identity` varchar(100) NOT NULL,
    `status` enum('active','inactive') DEFAULT 'active',
    `nidentity` varchar(100) NOT NULL,
    `timeStamp` timestamp DEFAULT CURRENT_TIMESTAMP,
    `reason` text,
    PRIMARY KEY (`id`)
);

-- Tabela de relatórios
CREATE TABLE IF NOT EXISTS `reports` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `victim_id` int(11) NOT NULL,
    `police_name` varchar(100) NOT NULL,
    `solved` tinyint(1) DEFAULT 0,
    `victim_name` varchar(100) NOT NULL,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `victim_report` text,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
);

-- Tabela de portes
CREATE TABLE IF NOT EXISTS `port` (
    `portId` int(11) NOT NULL AUTO_INCREMENT,
    `identity` varchar(100) NOT NULL,
    `user_id` int(11) NOT NULL,
    `portType` varchar(50) NOT NULL,
    `serial` varchar(50) NOT NULL,
    `nidentity` varchar(100) NOT NULL,
    `date` timestamp DEFAULT CURRENT_TIMESTAMP,
    `exam` text,
    PRIMARY KEY (`portId`)
);
```

## 3. Funções Adaptadas

### 3.1 Busca de Cidadãos
```lua
-- Antes
local formattedUser = {
    name = user.name .. " " .. user.lastname,
    passport = user.id,
    phone = user.phone or "N/A"
}

-- Depois
local formattedUser = {
    name = user.name .. " " .. user.name2,
    passport = user.id,
    phone = user.phone or "N/A"
}
```

### 3.2 Aplicação de Multas
```lua
-- Antes
local fullName = targetUser.name .. " " .. targetUser.lastname

-- Depois
local fullName = targetUser.name .. " " .. targetUser.name2
```

### 3.3 Mandados de Busca
```lua
-- Antes
local targetUser = vRP.UserData(passport)
if targetUser then
    identity = targetUser.name
end

-- Depois
local character = vRP.Query("characters/Person", { id = passport })
if character and #character > 0 then
    local targetUser = character[1]
    local fullName = targetUser.name .. " " .. targetUser.name2
    identity = fullName
end
```

### 3.4 Portes de Armas
```lua
-- Antes
local targetUser = vRP.UserData(passport)
if targetUser then
    identity = targetUser.name
end

-- Depois
local character = vRP.Query("characters/Person", { id = passport })
if character and #character > 0 then
    local targetUser = character[1]
    local fullName = targetUser.name .. " " .. targetUser.name2
    identity = fullName
end
```

### 3.5 Relatórios
```lua
-- Antes
local Identity = vRP.Identity(Passport)
if Identity then
    fullName = Identity.name .. " " .. Identity.lastname
end

-- Depois
local character = vRP.Query("characters/Person", { id = Passport })
if character and #character > 0 then
    local userData = character[1]
    fullName = userData.name .. " " .. userData.name2
end
```

## 4. Integração com Sistema de Multas

O MDT utiliza a tabela `fines` existente na framework:
```lua
vRP.Query("fines/Add", {
    Passport = passport,
    Name = fullName,
    Date = os.date("%d/%m/%Y"),
    Hour = os.date("%H:%M"),
    Value = fines,
    Message = completeMessage
})
```

## 5. Sistema de Permissões

O MDT verifica permissões usando os grupos da framework:
```lua
-- Verificar se o usuário tem permissão de polícia
return vRP.HasGroup(Passport,"Police") or 
       vRP.HasGroup(Passport,"Core") or 
       vRP.HasGroup(Passport,"PRF") or 
       vRP.HasGroup(Passport,"PCivil")
```

## 6. Comandos e Acesso

### Comando Principal:
```lua
RegisterCommand("mdt", function()
    if vSERVER.checkPermission() then
        openMDT()
    end
end)
```

### Senhas por Departamento:
- **Polícia Militar**: `pm123`
- **Polícia Civil**: `pc123`
- **CORE**: `core123`
- **PRF**: `prf123`

## 7. Funcionalidades Mantidas

- ✅ Busca de cidadãos por passaporte
- ✅ Aplicação de multas com código penal
- ✅ Aplicação de prisões
- ✅ Gestão de mandados de busca
- ✅ Gestão de portes de armas
- ✅ Sistema de relatórios
- ✅ Dashboard com estatísticas
- ✅ Avisos internos
- ✅ Veículos apreendidos
- ✅ Logs de serviço

## 8. Como Usar

1. **Acessar MDT**: Digite `/mdt` no chat
2. **Login**: Use seu passaporte e a senha do departamento
3. **Buscar Cidadão**: Digite o passaporte para ver histórico
4. **Aplicar Multa/Prisão**: Use o código penal integrado
5. **Gerenciar Mandados**: Crie e remova mandados de busca
6. **Relatórios**: Crie e gerencie relatórios de ocorrências

## 9. Observações Importantes

- Todas as tabelas são criadas automaticamente na primeira execução
- O sistema é compatível com a estrutura atual da framework
- As multas são integradas ao sistema financeiro existente
- Os logs de serviço são mantidos para auditoria
- O sistema suporta múltiplos departamentos policiais
