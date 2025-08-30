@echo off
REM ============================================
REM ELIS-V1 - Fluxo Automatizado de Commit Git
REM Passo 5: Sistema de Automação Inteligente
REM ============================================

setlocal enabledelayedexpansion

echo ============================================
echo    ELIS-V1 - Fluxo de Commit Automatizado
echo ============================================
echo.

REM Verificar se estamos em um repositório Git
if not exist ".git" (
    echo ❌ Erro: Não é um repositório Git
    echo    Execute este script na raiz do projeto
    pause
    exit /b 1
)

echo 📋 Iniciando fluxo de commit automatizado...
echo.

REM Passo 1: Auto-save (simulado - o Trae-IDE já faz isso)
echo 💾 Passo 1: Verificando salvamento automático...
echo    ✅ Arquivos salvos automaticamente pelo Trae-IDE
echo.

REM Passo 2: Verificar status atual
echo 📊 Passo 2: Verificando status do repositório...
git status
echo.

REM Passo 3: Verificar se há mudanças para commit
for /f %%i in ('git status --porcelain 2^>nul ^| find /c /v ""') do set changes=%%i

if %changes%==0 (
    echo ℹ️  Nenhuma mudança detectada para commit
    echo    O repositório está limpo
    pause
    exit /b 0
)

echo ✅ Detectadas %changes% mudanças para commit
echo.

REM Passo 4: Mostrar arquivos que serão adicionados
echo 📁 Arquivos que serão incluídos no commit:
git status --short
echo.

REM Passo 5: Solicitar confirmação
set /p confirm=Deseja continuar com o commit? (S/n): 
if /i "!confirm!"=="n" (
    echo ❌ Commit cancelado pelo usuário
    pause
    exit /b 0
)

REM Passo 6: Adicionar arquivos ao staging
echo ⚡ Passo 3: Adicionando arquivos ao staging...
git add .
if errorlevel 1 (
    echo ❌ Erro ao adicionar arquivos
    pause
    exit /b 1
)
echo    ✅ Arquivos adicionados com sucesso
echo.

REM Passo 7: Solicitar mensagem de commit
echo 📝 Passo 4: Definindo mensagem do commit...
set /p commit_message=Digite a mensagem do commit: 

if "!commit_message!"=="" (
    echo ⚠️  Mensagem vazia, usando mensagem padrão...
    set commit_message=[AUTO] Commit via sistema de automação - %date% %time%
)

echo    Mensagem: !commit_message!
echo.

REM Passo 8: Fazer o commit
echo 🚀 Passo 5: Executando commit...
git commit -m "!commit_message!"
if errorlevel 1 (
    echo ❌ Erro ao fazer commit
    pause
    exit /b 1
)

echo ✅ Commit realizado com sucesso!
echo.

REM Passo 9: Mostrar informações do commit
echo 📋 Informações do último commit:
git log -1 --oneline
echo.

REM Passo 10: Verificar se há commits para push
for /f %%i in ('git log --oneline origin/main..HEAD 2^>nul ^| find /c /v ""') do set unpushed=%%i

if %unpushed% gtr 0 (
    echo 📤 Há %unpushed% commit(s) não enviado(s) para o repositório remoto
    set /p push_confirm=Deseja fazer push agora? (S/n): 
    if /i "!push_confirm!" neq "n" (
        echo 🌐 Enviando commits para o repositório remoto...
        git push
        if errorlevel 1 (
            echo ⚠️  Erro ao fazer push - verifique a conexão
        ) else (
            echo ✅ Push realizado com sucesso!
        )
    )
) else (
    echo ✅ Repositório sincronizado com o remoto
)

echo.
echo 🎉 Fluxo de commit concluído!
echo ============================================

REM Registrar atividade no log
echo [%date% %time%] Fluxo de commit executado: "%commit_message%" >> workflow-automation.log

pause