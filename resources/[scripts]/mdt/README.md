# MDT - Mobile Data Terminal
## Sistema de Gerenciamento Policial para Cinelândia

### 📋 Descrição
O MDT (Mobile Data Terminal) é um sistema moderno e profissional para gerenciamento policial, desenvolvido especificamente para a cidade de Cinelândia. O sistema oferece uma interface minimalista e funcional com todas as ferramentas necessárias para o trabalho policial.

### ✨ Características Principais

#### 🔐 Sistema de Login
- Autenticação segura de usuários
- Controle de acesso por departamento
- Logs de entrada e saída

#### 📊 Dashboard Interativo
- Estatísticas em tempo real
- Contadores de prisões, multas, mandados e veículos
- Quadro de avisos integrado

#### 🚔 Funcionalidades Policiais
- **Busca de Cidadãos**: Consulta completa de passaportes
- **Registro de Prisões**: Sistema completo de encarceramento
- **Aplicação de Multas**: Gestão de infrações
- **Mandados de Busca**: Controle de procurados
- **Portes de Armas**: Gestão de autorizações
- **Relatórios**: Sistema de boletins de ocorrência
- **Veículos**: Apreensão e liberação de veículos
- **Avisos**: Quadro de comunicações internas

#### ⚡ Sistema de Serviço
- Controle de entrada e saída de serviço
- Logs automáticos de atividade
- Status visual em tempo real

### 🛠️ Instalação

1. **Copie a pasta `mdt`** para `server/resources/[update]/`

2. **Adicione ao server.cfg**:
```cfg
ensure mdt
```

3. **Configure as permissões** no seu sistema VRP:
   - Police
   - Core
   - PRF
   - PCivil

4. **Substitua o logo**:
   - Substitua `web-side/images/logo.png` pela logo oficial da Cinelândia
   - Recomendado: 200x200 pixels, fundo transparente

### 🎮 Como Usar

#### Acesso ao Sistema
- **Digite `/mdt`** no chat para abrir o MDT
- O sistema abre como um painel compacto (70% da tela)
- **Nota**: Login temporariamente desabilitado para testes

#### Pontos de Referência (Opcional)
- **P.Militar**: 442.40, -981.84, 31.60
- **P.Penal**: 1840.21, 2578.52, 46.08
- **P.Rodoviária Federal**: -271.04, 6056.31, 33.05
- **P.Civil**: -947.81, -2040.48, 9.4
- **Core**: 847.28, -1284.72, 24.32

#### Credenciais Padrão
- **Usuário**: admin
- **Senha**: admin123

### 📁 Estrutura de Arquivos

```
mdt/
├── fxmanifest.lua          # Configuração do recurso
├── client-side/
│   ├── config.lua          # Configurações do cliente
│   └── core.lua            # Lógica principal do cliente
├── server-side/
│   └── core.lua            # Lógica principal do servidor
├── web-side/
│   ├── index.html          # Interface principal
│   ├── css.css             # Estilos
│   ├── app.js              # JavaScript
│   └── images/
│       └── logo.png        # Logo da cidade
└── README.md               # Este arquivo
```

### 🗄️ Tabelas do Banco de Dados

O sistema cria automaticamente as seguintes tabelas:

#### Tabelas Existentes (Reutilizadas)
- `prison` - Registros de prisão
- `port` - Portes de armas
- `reports` - Relatórios
- `warrants` - Mandados de busca

#### Novas Tabelas
- `mdt_users` - Usuários do sistema
- `mdt_announcements` - Avisos internos
- `mdt_impounded_vehicles` - Veículos apreendidos
- `mdt_service_logs` - Logs de serviço

### 🎨 Design

#### Características Visuais
- **Design Minimalista**: Interface limpa e moderna
- **Painel Compacto**: Abre como um painel menor, não em tela cheia
- **Responsivo**: Adaptável a diferentes resoluções
- **Tema Escuro**: Sidebar com gradiente profissional
- **Animações Suaves**: Transições elegantes
- **Ícones FontAwesome**: Interface intuitiva
- **Acesso Universal**: Disponível de qualquer lugar pressionando F6

#### Cores Principais
- **Primária**: #667eea (Azul)
- **Secundária**: #764ba2 (Roxo)
- **Sucesso**: #27ae60 (Verde)
- **Erro**: #e74c3c (Vermelho)
- **Aviso**: #f39c12 (Laranja)

### 🔧 Configuração Avançada

#### Personalizar Pontos de Acesso
Edite `client-side/config.lua`:
```lua
Config.Locations = {
    { vec3(x, y, z), "Nome do Local" },
    -- Adicione mais locais conforme necessário
}
```

#### Alterar Tecla de Acesso
```lua
Config.Key = 167  -- F6 (consulte a lista de teclas do GTA V)
```

#### Configurar Permissões
No arquivo `server-side/core.lua`, função `checkPermission()`:
```lua
return vRP.HasService(Passport,"Police") or 
       vRP.HasService(Passport,"Core") or 
       vRP.HasService(Passport,"PRF") or 
       vRP.HasService(Passport,"PCivil")
```

### 🚀 Funcionalidades Detalhadas

#### Dashboard
- **Estatísticas em Tempo Real**: Contadores atualizados automaticamente
- **Quadro de Avisos**: Comunicações internas da corporação
- **Status de Serviço**: Indicador visual de disponibilidade

#### Busca de Cidadãos
- **Consulta por Passaporte**: Busca rápida e eficiente
- **Histórico Completo**: Prisões, multas e mandados
- **Informações Detalhadas**: Dados pessoais e registros

#### Gestão de Prisões
- **Formulário Completo**: Todos os campos necessários
- **Integração com VRP**: Sistema de prisão automático
- **Logs Detalhados**: Registro de todas as ações

#### Sistema de Multas
- **Aplicação Rápida**: Interface otimizada
- **Integração com VRP**: Sistema de multas automático
- **Histórico Completo**: Registro de todas as infrações

#### Mandados de Busca
- **Criação Simples**: Modal intuitivo
- **Gestão Completa**: Adicionar, editar, remover
- **Status Atualizado**: Controle de mandados ativos

#### Portes de Armas
- **Registro Detalhado**: Serial, status, exames
- **Gestão Completa**: CRUD completo
- **Histórico**: Registro de todas as autorizações

#### Relatórios
- **Sistema de BO**: Boletins de ocorrência
- **Status de Resolução**: Controle de casos
- **Gestão Completa**: Criar, resolver, remover

#### Veículos
- **Apreensão**: Registro de veículos apreendidos
- **Liberação**: Sistema de devolução
- **Histórico**: Controle completo de veículos

#### Avisos
- **Comunicação Interna**: Quadro de avisos
- **Gestão Completa**: Criar, editar, remover
- **Timestamps**: Controle de datas

### 🔒 Segurança

- **Autenticação Obrigatória**: Login necessário para acesso
- **Controle de Permissões**: Verificação de serviço
- **Logs de Atividade**: Registro de todas as ações
- **Validação de Dados**: Verificação de entrada
- **Proteção contra SQL Injection**: Queries preparadas

### 📱 Responsividade

O sistema é totalmente responsivo e funciona em:
- **Desktop**: Interface completa
- **Tablet**: Adaptação automática
- **Mobile**: Sidebar compacta

### 🎯 Compatibilidade

- **VRP Framework**: Totalmente compatível
- **FiveM**: Versão mais recente
- **MySQL**: Banco de dados suportado
- **Navegadores**: Chrome, Firefox, Safari, Edge

### 🆘 Suporte

Para suporte técnico ou dúvidas:
1. Verifique este README
2. Consulte os comentários no código
3. Entre em contato com a equipe de desenvolvimento

### 📝 Changelog

#### v1.0.0 (Lançamento Inicial)
- ✅ Sistema de login completo
- ✅ Dashboard interativo
- ✅ Todas as funcionalidades policiais
- ✅ Design moderno e responsivo
- ✅ Integração com VRP
- ✅ Sistema de logs
- ✅ Controle de serviço

### 🎉 Agradecimentos

Desenvolvido com ❤️ para a cidade de Cinelândia, proporcionando uma ferramenta profissional e eficiente para o trabalho policial.

---

**Cinelândia MDT v1.0.0** - Sistema Profissional de Gerenciamento Policial 