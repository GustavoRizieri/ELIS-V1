# Sistema de Notificação GitHub - ELIS-V1

## Visão Geral

O Sistema de Notificação GitHub é uma solução completa para monitorar atualizações do repositório, rastrear progresso de tarefas e gerar notificações automáticas sobre mudanças no projeto ELIS-V1.

## Componentes do Sistema

### 1. Script Principal (`github-monitor.ps1`)

Script PowerShell que implementa todas as funcionalidades de monitoramento:

#### Funcionalidades:
- **Verificação de Status**: Mostra informações sobre o repositório local
- **Monitoramento de Atualizações**: Detecta novos commits no repositório remoto
- **Sincronização**: Atualiza o repositório local com mudanças remotas
- **Análise de Progresso**: Categoriza commits por tipo de tarefa
- **Sistema de Notificações**: Gera alertas sobre mudanças importantes
- **Monitoramento Contínuo**: Execução automática a cada 5 minutos

#### Parâmetros de Execução:
```powershell
# Verificar status atual
./github-monitor.ps1 -Action check

# Sincronizar com repositório remoto
./github-monitor.ps1 -Action sync

# Mostrar apenas status
./github-monitor.ps1 -Action status

# Iniciar monitoramento contínuo
./github-monitor.ps1 -Action monitor

# Ver histórico de notificações
./github-monitor.ps1 -Action notifications
```

### 2. Interface de Usuário (`start-github-monitor.bat`)

Script batch que fornece uma interface amigável para o sistema:

#### Opções do Menu:
1. **Verificar status atual** - Executa verificação completa
2. **Iniciar monitoramento contínuo** - Ativa monitoramento automático
3. **Mostrar relatório de atividade** - Exibe resumo de atividades
4. **Verificar configurações** - Mostra arquivo de configuração
5. **Sair** - Encerra o programa

### 3. Arquivo de Configuração (`notification-config.json`)

Configurações personalizáveis do sistema:

```json
{
  "project": {
    "name": "ELIS-V1",
    "repository_url": "https://github.com/GustavoRizieri/ELIS-V1.git",
    "main_branch": "main"
  },
  "monitoring": {
    "check_interval_minutes": 5,
    "auto_fetch": true,
    "track_local_changes": true
  },
  "notifications": {
    "new_commits": {
      "enabled": true,
      "show_details": true,
      "max_commits_display": 10
    },
    "unpushed_commits": {
      "enabled": true,
      "reminder_interval_hours": 2
    }
  }
}
```

## Arquivos Gerados pelo Sistema

### 1. `github-updates.log`
Log detalhado de todas as operações do sistema com timestamps.

### 2. `notifications.txt`
Histórico de notificações em formato JSON para consulta posterior.

### 3. `last-check.txt`
Timestamp da última verificação realizada pelo sistema.

## Funcionalidades Detalhadas

### Análise de Progresso de Tarefas

O sistema categoriza commits automaticamente:

- **Passos**: Commits relacionados a etapas do projeto
- **Implementações**: Criação de novas funcionalidades
- **Correções**: Fixes e resoluções de bugs
- **Documentação**: Atualizações de documentação
- **Testes**: Implementação e execução de testes
- **Configurações**: Mudanças de configuração e setup

### Sistema de Logs Coloridos

- **ALERT** (Vermelho): Atualizações importantes detectadas
- **SUCCESS** (Verde): Operações concluídas com sucesso
- **SUMMARY** (Ciano): Resumos de atividades
- **PROGRESS** (Amarelo): Informações de progresso
- **STATUS** (Magenta): Informações de status
- **INFO** (Branco): Informações gerais

### Detecção de Atualizações

O sistema:
1. Executa `git fetch` para buscar atualizações
2. Compara commits locais com remotos
3. Identifica novos commits disponíveis
4. Gera notificações detalhadas
5. Oferece opção de sincronização automática

## Como Usar

### Execução Rápida
```batch
# Interface amigável
start-github-monitor.bat

# Verificação direta
powershell -ExecutionPolicy Bypass -File github-monitor.ps1 -Action check
```

### Monitoramento Contínuo
```powershell
# Inicia monitoramento que roda indefinidamente
./github-monitor.ps1 -Action monitor
```

### Verificação de Notificações
```powershell
# Mostra últimas 10 notificações
./github-monitor.ps1 -Action notifications
```

## Requisitos do Sistema

- **PowerShell 5.0+**
- **Git** instalado e configurado
- **Repositório Git** inicializado
- **Conexão com internet** para verificar repositório remoto
- **Política de execução** do PowerShell configurada (`RemoteSigned` ou superior)

## Configuração Inicial

1. **Configurar Política de Execução**:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. **Verificar Configuração do Git**:
   ```bash
   git remote -v
   git status
   ```

3. **Executar Primeira Verificação**:
   ```powershell
   ./github-monitor.ps1 -Action check
   ```

## Solução de Problemas

### Erro de Política de Execução
**Problema**: Script não executa por política de segurança
**Solução**: 
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

### Erro de Repositório Remoto
**Problema**: `fatal: ambiguous argument 'origin/'`
**Solução**: Verificar configuração do repositório remoto
```bash
git remote add origin https://github.com/GustavoRizieri/ELIS-V1.git
git fetch origin
```

### Caracteres Especiais nos Logs
**Problema**: Caracteres mal formatados na saída
**Solução**: O sistema foi otimizado para evitar caracteres especiais problemáticos

## Benefícios do Sistema

1. **Monitoramento Automático**: Detecta mudanças sem intervenção manual
2. **Notificações Inteligentes**: Categoriza e prioriza informações
3. **Interface Amigável**: Menu interativo para facilitar uso
4. **Logs Detalhados**: Histórico completo de todas as operações
5. **Configuração Flexível**: Personalizável via arquivo JSON
6. **Integração Git**: Funciona nativamente com comandos Git

## Conclusão

O Sistema de Notificação GitHub para ELIS-V1 fornece uma solução completa para monitoramento de repositório, permitindo acompanhar o progresso do projeto de forma automatizada e eficiente. O sistema é especialmente útil para:

- Desenvolvedores trabalhando em equipe
- Projetos com múltiplas etapas
- Necessidade de acompanhamento contínuo
- Integração com fluxos de trabalho Git

---

**Versão**: 2.0  
**Data**: Agosto 2025  
**Projeto**: ELIS-V1 - Passo 3 Concluído