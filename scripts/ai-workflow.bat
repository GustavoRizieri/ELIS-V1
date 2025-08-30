@echo off
REM ============================================
REM ELIS-V1 - Assistente de IA para Workflows
REM Passo 5: Sistema de Automação Inteligente
REM ============================================

setlocal enabledelayedexpansion

echo ============================================
echo    ELIS-V1 - Assistente de IA Workflows
echo    Desenvolvido por: Marduka ^& Gustavo
echo ============================================
echo.

REM Verificar se estamos no diretório correto
if not exist "src\ai_workflow_assistant.py" (
    echo ❌ Erro: Assistente de IA não encontrado
    echo    Execute este script na raiz do projeto ELIS-V1
    pause
    exit /b 1
)

REM Verificar ambiente Python
if not exist ".venv" (
    echo ❌ Erro: Ambiente virtual Python não encontrado
    echo 💡 Execute primeiro: python -m venv .venv
    pause
    exit /b 1
)

echo 🤖 Iniciando Assistente de IA para Workflows...
echo.

:MENU
cls
echo ============================================
echo    ELIS-V1 - Assistente de IA Workflows
echo ============================================
echo.
echo 🤖 OPÇÕES DISPONÍVEIS:
echo.
echo [1] 🔍 Reconhecer Intent de Comando
echo [2] 🚀 Executar Workflow Específico
echo [3] 📋 Listar Workflows Disponíveis
echo [4] 🧪 Testar Assistente de IA
echo [5] 📊 Status do Sistema
echo [6] 📝 Ver Logs de Automação
echo [7] ⚙️  Configurar Workflows
echo [8] 🆘 Ajuda e Documentação
echo [0] ❌ Sair
echo.
set /p choice=Escolha uma opção (0-8): 

if "%choice%"=="1" goto RECOGNIZE_INTENT
if "%choice%"=="2" goto EXECUTE_WORKFLOW
if "%choice%"=="3" goto LIST_WORKFLOWS
if "%choice%"=="4" goto TEST_AI
if "%choice%"=="5" goto SYSTEM_STATUS
if "%choice%"=="6" goto VIEW_LOGS
if "%choice%"=="7" goto CONFIGURE
if "%choice%"=="8" goto HELP
if "%choice%"=="0" goto EXIT

echo ❌ Opção inválida! Tente novamente.
pause
goto MENU

:RECOGNIZE_INTENT
cls
echo 🔍 RECONHECIMENTO DE INTENT
echo ============================================
echo.
echo Digite um comando em linguagem natural e o assistente
echo tentará identificar qual workflow executar.
echo.
echo Exemplos:
echo • "Quero fazer commit das mudanças"
echo • "Verificar status do projeto"
echo • "Ativar ambiente Python"
echo • "Instalar dependências"
echo.
set /p user_input=Digite seu comando: 

if "%user_input%"=="" (
    echo ❌ Comando vazio!
    pause
    goto MENU
)

echo.
echo 🤖 Analisando comando: "%user_input%"
echo.

REM Ativar ambiente e executar assistente
.venv\Scripts\activate.bat && python src\ai_workflow_assistant.py --recognize "%user_input%"

echo.
pause
goto MENU

:EXECUTE_WORKFLOW
cls
echo 🚀 EXECUTAR WORKFLOW ESPECÍFICO
echo ============================================
echo.
echo Workflows disponíveis:
echo [1] git-commit - Commit automatizado
echo [2] git-push - Push para repositório
echo [3] python-activate - Ativar ambiente Python
echo [4] python-test - Executar testes
echo [5] project-status - Status do projeto
echo [6] github-monitor - Monitorar GitHub
echo.
set /p workflow_choice=Escolha um workflow (1-6): 

if "%workflow_choice%"=="1" (
    echo 🚀 Executando: Commit automatizado
    call scripts\git-commit-flow.bat
) else if "%workflow_choice%"=="2" (
    echo 🚀 Executando: Push para repositório
    git push
) else if "%workflow_choice%"=="3" (
    echo 🚀 Executando: Ativar ambiente Python
    call activate-python.bat
) else if "%workflow_choice%"=="4" (
    echo 🚀 Executando: Testes Python
    .venv\Scripts\activate.bat && python -m pytest tests/
) else if "%workflow_choice%"=="5" (
    echo 🚀 Executando: Status do projeto
    call scripts\project-status.bat
) else if "%workflow_choice%"=="6" (
    echo 🚀 Executando: Monitor GitHub
    call start-github-monitor.bat
) else (
    echo ❌ Opção inválida!
)

pause
goto MENU

:LIST_WORKFLOWS
cls
echo 📋 WORKFLOWS DISPONÍVEIS
echo ============================================
echo.

REM Ativar ambiente e listar workflows
.venv\Scripts\activate.bat && python src\ai_workflow_assistant.py --list

echo.
pause
goto MENU

:TEST_AI
cls
echo 🧪 TESTE DO ASSISTENTE DE IA
echo ============================================
echo.
echo Executando testes do assistente de IA...
echo.

REM Ativar ambiente e testar assistente
.venv\Scripts\activate.bat && python src\ai_workflow_assistant.py --test

echo.
pause
goto MENU

:SYSTEM_STATUS
cls
echo 📊 STATUS DO SISTEMA
echo ============================================
echo.

REM Verificar componentes do sistema
echo 🔍 Verificando componentes...
echo.

if exist "workflow-config.json" (
    echo ✅ Configuração de workflows: OK
) else (
    echo ❌ Configuração de workflows: FALTANDO
)

if exist "src\ai_workflow_assistant.py" (
    echo ✅ Assistente de IA: OK
) else (
    echo ❌ Assistente de IA: FALTANDO
)

if exist ".venv" (
    echo ✅ Ambiente Python: OK
) else (
    echo ❌ Ambiente Python: FALTANDO
)

if exist "scripts\git-commit-flow.bat" (
    echo ✅ Scripts de automação: OK
) else (
    echo ❌ Scripts de automação: FALTANDO
)

echo.
echo 🤖 Testando assistente de IA...
.venv\Scripts\activate.bat && python src\ai_workflow_assistant.py --status

echo.
pause
goto MENU

:VIEW_LOGS
cls
echo 📝 LOGS DE AUTOMAÇÃO
echo ============================================
echo.

if exist "workflow-automation.log" (
    echo 📋 Últimas 10 entradas do log:
    echo ----------------------------------------
    for /f "skip=0 tokens=*" %%i in ('more +0 workflow-automation.log ^| tail -10 2^>nul') do echo %%i
    echo ----------------------------------------
    echo.
    echo 💡 Para ver o log completo: notepad workflow-automation.log
) else (
    echo ℹ️  Nenhum log de automação encontrado
    echo    Os logs serão criados quando workflows forem executados
)

echo.
pause
goto MENU

:CONFIGURE
cls
echo ⚙️  CONFIGURAÇÃO DE WORKFLOWS
echo ============================================
echo.
echo 📝 Editando arquivo de configuração...
echo.

if exist "workflow-config.json" (
    notepad workflow-config.json
    echo ✅ Configuração editada!
    echo 💡 Reinicie o assistente para aplicar mudanças
) else (
    echo ❌ Arquivo de configuração não encontrado
    echo 💡 Execute o setup do projeto primeiro
)

echo.
pause
goto MENU

:HELP
cls
echo 🆘 AJUDA E DOCUMENTAÇÃO
echo ============================================
echo.
echo 📖 COMO USAR O ASSISTENTE DE IA:
echo.
echo 1. 🔍 RECONHECIMENTO DE INTENT:
echo    • Digite comandos em linguagem natural
echo    • Exemplo: "Quero fazer commit"
echo    • O assistente identifica o workflow apropriado
echo.
echo 2. 🚀 EXECUÇÃO DE WORKFLOWS:
echo    • Escolha workflows específicos do menu
echo    • Automação completa de tarefas comuns
echo    • Logs automáticos de todas as ações
echo.
echo 3. 📋 WORKFLOWS DISPONÍVEIS:
echo    • git-commit: Commit automatizado com verificações
echo    • git-push: Push seguro para repositório
echo    • python-activate: Ativação do ambiente Python
echo    • python-test: Execução de testes automatizados
echo    • project-status: Status completo do projeto
echo    • github-monitor: Monitoramento de atualizações
echo.
echo 4. 🤖 COMANDOS DE EXEMPLO:
echo    • "Fazer commit das mudanças"
echo    • "Verificar status do projeto"
echo    • "Ativar Python"
echo    • "Rodar testes"
echo    • "Monitorar GitHub"
echo.
echo 📚 DOCUMENTAÇÃO COMPLETA:
echo    • README.md - Visão geral do projeto
echo    • CONFIGURACAO-AMBIENTE-PYTHON.md - Setup Python
echo    • workflow-config.json - Configurações de automação
echo.
echo.
pause
goto MENU

:EXIT
echo.
echo 👋 Encerrando Assistente de IA...
echo.
echo 📋 Sessão finalizada em: %date% %time%
echo [%date% %time%] Assistente de IA finalizado >> workflow-automation.log
echo.
echo Obrigado por usar o ELIS-V1! 🚀
echo.
pause
exit /b 0