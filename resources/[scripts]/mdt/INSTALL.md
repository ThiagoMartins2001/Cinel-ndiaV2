# 🚀 Instalação Rápida - MDT Cinelândia

## 📋 Pré-requisitos
- FiveM Server
- VRP Framework
- MySQL Database
- Permissões de administrador

## ⚡ Instalação em 3 Passos

### 1️⃣ Copiar Arquivos
```bash
# Copie a pasta mdt para seu servidor
cp -r mdt/ server/resources/[update]/
```

### 2️⃣ Adicionar ao server.cfg
```cfg
# Adicione esta linha ao seu server.cfg
ensure mdt
```

### 3️⃣ Reiniciar Servidor
```bash
# Reinicie seu servidor FiveM
# Ou use o comando restart no console
restart mdt
```

## ✅ Verificação da Instalação

1. **Digite `/mdt`** no chat para abrir o MDT
2. **O sistema abrirá** como um painel compacto (70% da tela)
3. **Nota**: Login temporariamente desabilitado para testes funcionais

## 🔧 Configuração Inicial

### Personalizar Logo
```bash
# Substitua o arquivo logo.png
server/resources/[update]/mdt/web-side/images/logo.png
```

### Adicionar Usuários
```sql
-- Execute no seu banco de dados
INSERT INTO mdt_users (passport, username, password, name, rank, department) 
VALUES (SEU_PASSPORT, 'seu_usuario', 'sua_senha', 'Seu Nome', 'Sua Patente', 'Police');
```

### Configurar Permissões
Edite `server-side/core.lua` na função `checkPermission()`:
```lua
return vRP.HasService(Passport,"Police") or 
       vRP.HasService(Passport,"Core") or 
       vRP.HasService(Passport,"PRF") or 
       vRP.HasService(Passport,"PCivil")
```

## 🎯 Pontos de Referência (Opcional)

| Local | Coordenadas | Departamento |
|-------|-------------|--------------|
| P.Militar | 442.40, -981.84, 31.60 | Police |
| P.Penal | 1840.21, 2578.52, 46.08 | Police |
| P.Rodoviária Federal | -271.04, 6056.31, 33.05 | PRF |
| P.Civil | -947.81, -2040.48, 9.4 | PCivil |
| Core | 847.28, -1284.72, 24.32 | Core |

> **Nota**: O MDT agora é acessível de qualquer lugar pressionando F6, não sendo necessário estar em locais específicos.

## 🆘 Solução de Problemas

### Erro: "Recurso não encontrado"
- Verifique se a pasta `mdt` está em `server/resources/[update]/`
- Confirme se `ensure mdt` está no server.cfg

### Erro: "Sem permissão"
- Verifique se o jogador tem o serviço correto
- Confirme as configurações de permissão

### Erro: "Banco de dados"
- Verifique a conexão com MySQL
- Confirme se as tabelas foram criadas

## 📞 Suporte

Para suporte técnico:
1. Verifique o README.md completo
2. Consulte os logs do servidor
3. Entre em contato com a equipe de desenvolvimento

---

**MDT Cinelândia v1.0.0** - Sistema Profissional de Gerenciamento Policial 