@echo off
REM ============================================
REM ELIS-V1 - Status Completo do Projeto
REM Passo 5: Sistema de Automação Inteligente
REM ============================================

setlocal enabledelayedexpansion

echo ============================================
echo    ELIS-V1 - Status Completo do Projeto
echo    Desenvolvido por: Marduka ^& Gustavo
echo ============================================
echo.

REM Verificar se estamos no diretório correto
if not exist "README.md" (
    echo ❌ Erro: Execute este script na raiz do projeto ELIS-V1
    pause
    exit /b 1
)

echo 📊 Coletando informações do projeto...
echo.

REM ============================================
REM INFORMAÇÕES GERAIS DO PROJETO
REM ============================================
echo 📋 INFORMAÇÕES GERAIS:
echo ============================================
echo 📁 Diretório atual: %CD%
echo 📅 Data/Hora: %date% %time%
echo 🖥️  Sistema: %OS%
echo 👤 Usuário: %USERNAME%
echo.

REM ============================================
REM STATUS DO GIT
REM ============================================
echo 🔧 STATUS DO GIT:
echo ============================================

if exist ".git" (
    echo ✅ Repositório Git inicializado
    
    REM Branch atual
    for /f "tokens=*" %%i in ('git branch --show-current 2^>nul') do set current_branch=%%i
    echo 🌿 Branch atual: !current_branch!
    
    REM Status do repositório
    echo.
    echo 📊 Status do repositório:
    git status --short
    
    REM Verificar commits não enviados
    for /f %%i in ('git log --oneline origin/main..HEAD 2^>nul ^| find /c /v ""') do set unpushed=%%i
    if !unpushed! gtr 0 (
        echo 📤 Commits não enviados: !unpushed!
    ) else (
        echo ✅ Repositório sincronizado
    )
    
    REM Último commit
    echo.
    echo 📝 Último commit:
    git log -1 --oneline 2>nul
    
) else (
    echo ❌ Repositório Git não inicializado
)
echo.

REM ============================================
REM AMBIENTE PYTHON
REM ============================================
echo 🐍 AMBIENTE PYTHON:
echo ============================================

if exist ".venv" (
    echo ✅ Ambiente virtual encontrado
    
    REM Verificar se está ativo
    if defined VIRTUAL_ENV (
        echo ✅ Ambiente virtual ativo
        echo 📦 Localização: %VIRTUAL_ENV%
    ) else (
        echo ⚠️  Ambiente virtual não ativo
        echo 💡 Execute: activate-python.bat
    )
    
    REM Verificar Python
    if exist ".venv\Scripts\python.exe" (
        echo 🐍 Python disponível no ambiente virtual
        .venv\Scripts\python.exe --version 2>nul
    )
    
) else (
    echo ❌ Ambiente virtual não encontrado
    echo 💡 Execute: python -m venv .venv
)

REM Verificar requirements.txt
if exist "requirements.txt" (
    echo ✅ Arquivo requirements.txt encontrado
    for /f %%i in ('find /c /v "" requirements.txt') do echo 📦 Dependências listadas: %%i
) else (
    echo ❌ Arquivo requirements.txt não encontrado
)
echo.

REM ============================================
REM ESTRUTURA DO PROJETO
REM ============================================
echo 📁 ESTRUTURA DO PROJETO:
echo ============================================

REM Verificar diretórios principais
set directories=src tests docs scripts .venv
for %%d in (%directories%) do (
    if exist "%%d" (
        echo ✅ %%d/
    ) else (
        echo ❌ %%d/ (não encontrado)
    )
)

echo.
REM Verificar arquivos principais
set files=README.md requirements.txt .gitignore workflow-config.json notification-config.json
for %%f in (%files%) do (
    if exist "%%f" (
        echo ✅ %%f
    ) else (
        echo ❌ %%f (não encontrado)
    )
)
echo.

REM ============================================
REM SISTEMA DE MONITORAMENTO
REM ============================================
echo 🔔 SISTEMA DE MONITORAMENTO:
echo ============================================

if exist "github-monitor.ps1" (
    echo ✅ Script de monitoramento disponível
) else (
    echo ❌ Script de monitoramento não encontrado
)

if exist "start-github-monitor.bat" (
    echo ✅ Interface de monitoramento disponível
) else (
    echo ❌ Interface de monitoramento não encontrada
)

if exist "notification-config.json" (
    echo ✅ Configuração de notificações disponível
) else (
    echo ❌ Configuração de notificações não encontrada
)
echo.

REM ============================================
REM SISTEMA DE AUTOMAÇÃO (PASSO 5)
REM ============================================
echo 🤖 SISTEMA DE AUTOMAÇÃO:
echo ============================================

if exist "workflow-config.json" (
    echo ✅ Configuração de fluxos de trabalho disponível
) else (
    echo ❌ Configuração de fluxos não encontrada
)

if exist "src\ai_workflow_assistant.py" (
    echo ✅ Assistente de IA disponível
) else (
    echo ❌ Assistente de IA não encontrado
)

if exist "scripts\git-commit-flow.bat" (
    echo ✅ Fluxo de commit automatizado disponível
) else (
    echo ❌ Fluxo de commit não encontrado
)
echo.

REM ============================================
REM LOGS E ATIVIDADE
REM ============================================
echo 📝 LOGS E ATIVIDADE:
echo ============================================

if exist "workflow-automation.log" (
    for /f %%i in ('find /c /v "" workflow-automation.log') do echo 📋 Entradas no log de automação: %%i
) else (
    echo ℹ️  Nenhum log de automação encontrado
)

if exist "github-updates.log" (
    for /f %%i in ('find /c /v "" github-updates.log') do echo 📋 Entradas no log do GitHub: %%i
) else (
    echo ℹ️  Nenhum log do GitHub encontrado
)

if exist "notifications.txt" (
    for /f %%i in ('find /c /v "" notifications.txt') do echo 🔔 Notificações registradas: %%i
) else (
    echo ℹ️  Nenhuma notificação registrada
)
echo.

REM ============================================
REM RESUMO E RECOMENDAÇÕES
REM ============================================
echo 💡 RESUMO E RECOMENDAÇÕES:
echo ============================================

REM Calcular score de completude
set score=0

if exist ".git" set /a score+=10
if exist ".venv" set /a score+=15
if exist "requirements.txt" set /a score+=10
if exist "src" set /a score+=10
if exist "tests" set /a score+=10
if exist "github-monitor.ps1" set /a score+=15
if exist "workflow-config.json" set /a score+=15
if exist "src\ai_workflow_assistant.py" set /a score+=15

echo 📊 Score de completude: !score!/100

if !score! geq 90 (
    echo 🎉 Projeto EXCELENTE! Todos os sistemas funcionais
) else if !score! geq 70 (
    echo ✅ Projeto BOM! Maioria dos sistemas funcionais
) else if !score! geq 50 (
    echo ⚠️  Projeto PARCIAL! Alguns sistemas precisam de atenção
) else (
    echo ❌ Projeto INCOMPLETO! Vários sistemas precisam ser configurados
)

echo.
echo 🚀 PRÓXIMAS AÇÕES SUGERIDAS:
if not exist ".venv" echo    • Configurar ambiente virtual Python
if not exist "workflow-config.json" echo    • Configurar sistema de automação
if not defined VIRTUAL_ENV echo    • Ativar ambiente virtual Python
if !unpushed! gtr 0 echo    • Fazer push dos commits pendentes

echo.
echo ============================================
echo 📋 Status coletado em: %date% %time%
echo ============================================

REM Registrar verificação no log
echo [%date% %time%] Status do projeto verificado - Score: !score!/100 >> workflow-automation.log

pause