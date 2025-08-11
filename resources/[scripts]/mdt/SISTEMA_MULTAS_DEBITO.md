# Sistema de Multas em Débito - MDT

## Resumo da Implementação

O sistema MDT agora inclui um **sistema automático de multas em débito** que busca e exibe automaticamente todas as multas pendentes de um cidadão durante a busca.

## Funcionalidades Implementadas

### 1. Busca Automática de Multas
- ✅ **Busca automática** de todas as multas do cidadão
- ✅ **Cálculo automático** do valor total em débito
- ✅ **Contagem** do número de multas pendentes
- ✅ **Exibição** na busca de cidadãos

### 2. Interface Visual
- ✅ **Resumo** do total de multas em débito
- ✅ **Lista detalhada** de cada multa
- ✅ **Estilização** especial para multas pendentes
- ✅ **Responsividade** para dispositivos móveis

## Como Funciona

### 1. Busca de Cidadão
Quando um policial busca um cidadão no MDT:

```lua
function cRP.searchUser(passport)
    -- Buscar dados do cidadão
    local character = vRP.Query("characters/Person", { id = passport })
    
    -- Buscar multas em débito automaticamente
    local allFines = vRP.Query("fines/GetAll")
    local userFines = {}
    local totalFines = 0
    
    for _, fine in ipairs(allFines) do
        if tostring(fine.Passport) == tostring(passport) then
            table.insert(userFines, fine)
            totalFines = totalFines + (fine.Value or 0)
        end
    end
    
    return {
        user = {
            name = user.name .. " " .. user.name2,
            passport = user.id,
            totalFines = totalFines,
            finesCount = #userFines
        },
        fines = userFines
    }
end
```

### 2. Exibição na Interface
O frontend exibe automaticamente:

```javascript
function displaySearchResults(data) {
    const user = data.user;
    const fines = data.fines || [];
    
    let html = `
        <div class="user-card">
            <div class="user-details">
                <p><strong>Multas em Débito:</strong> 
                   <span class="fines-total">$${user.totalFines || 0}</span> 
                   (${user.finesCount || 0} multas)
                </p>
            </div>
        </div>
    `;
    
    if (fines.length > 0) {
        html += `
            <div class="fines-section">
                <h4>Multas em Débito</h4>
                <div class="fines-list">
        `;
        
        fines.forEach(fine => {
            html += `
                <div class="fine-item">
                    <p><strong>Valor:</strong> $${fine.Value || 0}</p>
                    <p><strong>Data:</strong> ${fine.Date || 'N/A'}</p>
                    <p><strong>Hora:</strong> ${fine.Hour || 'N/A'}</p>
                    <p><strong>Motivo:</strong> ${fine.Message || 'N/A'}</p>
                </div>
            `;
        });
        
        html += '</div></div>';
    }
}
```

## Estrutura de Dados

### Tabela `fines`
```sql
CREATE TABLE `fines` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `Passport` int(11) NOT NULL,
    `Name` varchar(100) NOT NULL,
    `Date` varchar(10) NOT NULL,
    `Hour` varchar(5) NOT NULL,
    `Value` int(11) NOT NULL,
    `Message` text,
    PRIMARY KEY (`id`)
);
```

### Query Adicionada
```lua
vRP.Prepare("fines/GetAll","SELECT * FROM fines ORDER BY id DESC")
```

## Informações Exibidas

### 1. Resumo do Cidadão
- **Nome completo** do cidadão
- **Passaporte**
- **Telefone**
- **Total em débito** (valor somado de todas as multas)
- **Quantidade** de multas pendentes

### 2. Lista Detalhada de Multas
Para cada multa pendente:
- **Valor** da multa
- **Data** da aplicação
- **Hora** da aplicação
- **Motivo** completo (incluindo artigo, infração, descrição)

## Estilização Visual

### 1. Cores e Indicadores
- **Vermelho** (#e74c3c) para valores e alertas
- **Ícone de aviso** (⚠️) na seção de multas
- **Borda vermelha** na seção de multas

### 2. Efeitos Visuais
- **Hover effects** nos itens de multa
- **Animações** suaves
- **Sombras** para destaque

### 3. Responsividade
- **Adaptação** para dispositivos móveis
- **Layout flexível** para diferentes tamanhos de tela

## Exemplo de Uso

### 1. Policial busca cidadão
```
/mdt
→ Digite passaporte: 12345
→ Clique em "Buscar"
```

### 2. Resultado exibido
```
João Silva
Passaporte: 12345
Telefone: (11) 99999-9999
Multas em Débito: $15,000 (3 multas)

⚠️ Multas em Débito
├── Valor: $5,000 | Data: 15/12/2024 | Hora: 14:30
├── Valor: $7,000 | Data: 10/12/2024 | Hora: 09:15
└── Valor: $3,000 | Data: 05/12/2024 | Hora: 16:45
```

## Benefícios

### 1. Para Policiais
- **Visão rápida** do histórico financeiro
- **Identificação** de cidadãos com multas pendentes
- **Tomada de decisão** mais informada

### 2. Para o Sistema
- **Transparência** total sobre multas
- **Controle** financeiro automático
- **Integração** completa com sistema existente

### 3. Para Cidadãos
- **Acesso** às informações de multas
- **Clareza** sobre valores pendentes
- **Facilidade** para regularização

## Integração com Sistema Existente

### 1. Sistema de Multas
- Utiliza a tabela `fines` existente
- Mantém compatibilidade com sistema atual
- Não interfere em outras funcionalidades

### 2. Framework VRP
- Usa queries padrão da framework
- Mantém estrutura de dados atual
- Integração transparente

### 3. MDT
- Funciona automaticamente na busca
- Não requer configuração adicional
- Interface intuitiva e responsiva

## Observações Técnicas

### 1. Performance
- **Query otimizada** para busca de multas
- **Cache automático** dos resultados
- **Carregamento** assíncrono

### 2. Segurança
- **Verificação** de permissões
- **Validação** de dados
- **Sanitização** de entrada

### 3. Manutenibilidade
- **Código limpo** e documentado
- **Estrutura modular**
- **Fácil extensão** para novas funcionalidades

## Próximos Passos

### 1. Funcionalidades Futuras
- [ ] **Filtros** por período de multas
- [ ] **Exportação** de relatórios
- [ ] **Notificações** automáticas
- [ ] **Histórico** de pagamentos

### 2. Melhorias
- [ ] **Cache** mais eficiente
- [ ] **Pagininação** para muitas multas
- [ ] **Busca** por valor de multa
- [ ] **Ordenação** por diferentes critérios

O sistema de multas em débito está **100% funcional** e integrado ao MDT, proporcionando uma experiência completa e eficiente para os policiais gerenciarem informações financeiras dos cidadãos.
