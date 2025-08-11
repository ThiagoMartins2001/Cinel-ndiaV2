# Sistema de Adrenalina em Locais Específicos

## Descrição
Este sistema permite que players usem adrenalina para reanimar outros players apenas em locais médicos autorizados, como hospitais, postos de saúde e clínicas.

## Como Funciona

### Para Players:
1. **Localização**: O player deve estar dentro de um local autorizado (raio de 30-50 metros dos pontos médicos)
2. **Uso**: Com o item "Adrenalina" no inventário, clique no item próximo a uma pessoa desacordada
3. **Processo**: Uma animação de 8 segundos será executada
4. **Resultado**: A pessoa será reanimada com 101 de vida e receberá 15 pontos de sede e fome

### Locais Autorizados:
- **Hospital Sul**: Coordenadas (359.46, -1421.1, 32.5) - Raio: 50m
- **Hospital Norte**: Coordenadas (1826.79, 3674.3, 34.27) - Raio: 50m  
- **Hospital Paleto**: Coordenadas (-254.98, 6326.58, 32.42) - Raio: 50m
- **Posto Sandy Shores**: Coordenadas (1141.68, -1539.66, 35.03) - Raio: 30m
- **Clínica Central**: Coordenadas (311.83, -593.31, 43.08) - Raio: 40m

## Comandos Administrativos

### `/testadrenalinelocation`
- **Uso**: Testa se você está em um local permitido para usar adrenalina
- **Permissão**: Todos os players

### `/listadrenalinelocations` 
- **Uso**: Lista todos os locais configurados no console
- **Permissão**: Administradores

### `/addadrenalinelocation [nome] [raio]`
- **Uso**: Adiciona um novo local de adrenalina na sua posição atual
- **Parâmetros**: 
  - `nome`: Nome do local (opcional)
  - `raio`: Raio em metros (opcional, padrão: 30)
- **Permissão**: Administradores

## Configuração

### Adicionar Novos Locais:
Edite o arquivo `client-side/adrenaline_locations.lua` e adicione novos locais na tabela `AdrenalineLocations`:

```lua
{ ["Name"] = "Nome do Local", ["Coords"] = vec3(x, y, z), ["Radius"] = raio_em_metros }
```

### Modificar Comportamento:
- **Tempo de aplicação**: Edite o valor `8000` no arquivo `server-side/itens.lua`
- **Vida após reanimação**: Edite o valor `101` no arquivo `server-side/itens.lua`
- **Pontos de sede/fome**: Edite os valores `15` no arquivo `server-side/itens.lua`

## Recursos de Segurança

1. **Verificação de Localização**: Só funciona em locais autorizados
2. **Aviso de Paramédicos**: Alerta quando há paramédicos online
3. **Logs**: Todas as ações são registradas no sistema de logs
4. **Validações**: Verifica se a pessoa está realmente desacordada

## Notificações

- **Sucesso**: "Adrenalina aplicada com sucesso em [Local]!"
- **Erro de Local**: "Você só pode usar adrenalina em locais médicos autorizados!"
- **Sem Pessoa**: "Nenhuma pessoa próxima encontrada!"
- **Pessoa Consciente**: "A pessoa precisa estar desacordada para usar adrenalina!"
- **Paramédicos Online**: "Existem paramédicos online. É recomendado chamar um profissional!"

## Compatibilidade

Este sistema é compatível com:
- vRP Framework
- Sistema de inventário existente
- Sistema de paramédicos
- Sistema de logs
- Sistema de notificações
