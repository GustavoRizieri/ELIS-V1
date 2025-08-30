@echo off
echo ===============================================
echo    Sistema de Monitoramento GitHub - ELIS-V1
echo ===============================================
echo.
echo Escolha uma opcao:
echo.
echo 1. Verificar status atual
echo 2. Iniciar monitoramento continuo
echo 3. Mostrar relatorio de atividade
echo 4. Verificar configuracoes
echo 5. Sair
echo.
set /p choice=Digite sua escolha (1-5): 

if "%choice%"=="1" (
    echo.
    echo Verificando status atual...
    powershell -ExecutionPolicy Bypass -File "github-monitor.ps1" -Action status
    pause
    goto menu
)

if "%choice%"=="2" (
    echo.
    echo Iniciando monitoramento continuo...
    echo Pressione Ctrl+C para parar
    powershell -ExecutionPolicy Bypass -File "github-monitor.ps1" -Action monitor
    pause
    goto menu
)

if "%choice%"=="3" (
    echo.
    echo Gerando relatorio de atividade...
    powershell -ExecutionPolicy Bypass -File "github-monitor.ps1" -Action check
    pause
    goto menu
)

if "%choice%"=="4" (
    echo.
    echo Verificando configuracoes...
    if exist "notification-config.json" (
        echo ✅ Arquivo de configuracao encontrado
        echo Conteudo:
        type "notification-config.json"
    ) else (
        echo ❌ Arquivo de configuracao nao encontrado
    )
    pause
    goto menu
)

if "%choice%"=="5" (
    echo.
    echo Saindo...
    exit /b
)

echo Opcao invalida. Tente novamente.
pause

:menu
cls
goto start

:start
echo ===============================================
echo    Sistema de Monitoramento GitHub - ELIS-V1
echo ===============================================
echo.
echo Escolha uma opcao:
echo.
echo 1. Verificar status atual
echo 2. Iniciar monitoramento continuo
echo 3. Mostrar relatorio de atividade
echo 4. Verificar configuracoes
echo 5. Sair
echo.
set /p choice=Digite sua escolha (1-5): 
goto menu