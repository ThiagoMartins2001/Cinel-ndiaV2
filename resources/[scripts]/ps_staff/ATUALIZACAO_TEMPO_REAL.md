# Atualização em Tempo Real - PS Staff

## Resumo das Mudanças

Este documento descreve as implementações feitas para adicionar atualização automática em tempo real ao painel administrativo PS Staff.

## Problema Identificado

O painel ADMIN (ps_staff) não estava buscando informações dos players e grupos em tempo real, apenas carregando os dados uma vez quando o painel era aberto.

## Soluções Implementadas

### 1. Sistema de Atualização Automática

**Arquivo:** `html/js/script.js`

- **Variáveis de controle:**
  - `autoUpdateInterval`: Controla o intervalo de atualização
  - `autoUpdateEnabled`: Habilita/desabilita a atualização automática
  - `AUTO_UPDATE_INTERVAL`: Define o intervalo (10 segundos)

- **Funções principais:**
  - `startAutoUpdate()`: Inicia a atualização automática
  - `stopAutoUpdate()`: Para a atualização automática
  - `updateAllData()`: Atualiza todos os dados baseado na seção atual
  - `updatePlayersList()`: Atualiza lista de players
  - `updatePlayerData()`: Atualiza dados de um player específico
  - `updateGroups()`: Atualiza grupos

### 2. Controle Visual

**Arquivo:** `html/index.html`

- Adicionado botão de controle no título da seção:
```html
<div class="auto-update-controls">
    <button id="toggleAutoUpdate" class="btn-toggle" title="Ativar/Desativar atualização automática">
        <i class="fas fa-sync-alt"></i>
        <span id="autoUpdateStatus">Ativo</span>
    </button>
</div>
```

**Arquivo:** `html/css/style.css`

- Estilos para o botão de controle com animação de rotação
- Estados ativo/inativo com cores diferentes

### 3. Sistema de Eventos em Tempo Real

**Arquivo:** `server/sv_main.lua`

- **Novas funções:**
  - `psRP.getGroupMembers()`: Retorna membros de qualquer grupo
  - Eventos para entrada/saída de players
  - Notificações de mudanças em grupos

- **Eventos implementados:**
  - `vRP:playerSpawn`: Quando um player entra no servidor
  - `playerDropped`: Quando um player sai do servidor
  - Notificações de adição/remoção de grupos

**Arquivo:** `client/cl_main.lua`

- **Novos eventos:**
  - `ps_staff:groupChanged`: Recebe notificações de mudanças em grupos
  - `ps_staff:playerChanged`: Recebe notificações de mudanças em players

### 4. Handlers de Eventos

**Arquivo:** `html/js/script.js`

- **Funções de tratamento:**
  - `handleGroupChange()`: Processa mudanças em grupos
  - `handlePlayerChange()`: Processa mudanças em players

## Como Funciona

### Atualização Automática
1. Quando o painel é aberto, a atualização automática é iniciada
2. A cada 10 segundos, os dados são atualizados baseado na seção atual:
   - **Dashboard:** Atualiza contadores online e cards de organizações
   - **Players:** Atualiza lista de players e dados do player selecionado

### Eventos em Tempo Real
1. Quando um player entra/sai do servidor, todos os staffs são notificados
2. Quando um grupo é adicionado/removido, todos os staffs são notificados
3. As notificações atualizam automaticamente a interface sem necessidade de refresh

### Controle Manual
1. O botão de controle permite ativar/desativar a atualização automática
2. Quando ativo, o ícone gira continuamente
3. Quando inativo, o botão fica cinza

## Benefícios

1. **Dados sempre atualizados:** Informações em tempo real sem necessidade de refresh manual
2. **Melhor experiência:** Interface responsiva e dinâmica
3. **Controle do usuário:** Possibilidade de desativar a atualização automática
4. **Performance otimizada:** Atualizações inteligentes baseadas na seção atual
5. **Notificações instantâneas:** Mudanças são refletidas imediatamente

## Configurações

- **Intervalo de atualização:** 10 segundos (configurável em `AUTO_UPDATE_INTERVAL`)
- **Atualização automática:** Ativada por padrão
- **Notificações:** Enviadas para todos os staffs online

## Compatibilidade

- Compatível com a base VRP existente
- Não interfere com funcionalidades existentes
- Mantém todas as permissões e configurações atuais
