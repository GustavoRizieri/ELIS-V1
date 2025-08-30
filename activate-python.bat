@echo off
echo ===============================================
echo    Ambiente Python - ELIS-V1
echo ===============================================
echo.
echo Ativando ambiente virtual Python...
echo.

:: Verificar se o ambiente virtual existe
if not exist ".venv\Scripts\activate.bat" (
    echo ❌ Ambiente virtual nao encontrado!
    echo Execute primeiro: python -m venv .venv
    pause
    exit /b 1
)

:: Ativar o ambiente virtual
call .venv\Scripts\activate.bat

echo ✅ Ambiente virtual ativado com sucesso!
echo.
echo Versao do Python:
python --version
echo.
echo Pip instalado:
pip --version
echo.
echo ===============================================
echo    Comandos uteis:
echo ===============================================
echo.
echo • Instalar dependencias: pip install -r requirements.txt
echo • Listar pacotes: pip list
echo • Instalar pacote: pip install nome_do_pacote
echo • Desativar ambiente: deactivate
echo • Gerar requirements: pip freeze > requirements.txt
echo.
echo ===============================================
echo    Menu de opcoes:
echo ===============================================
echo.
echo 1. Instalar dependencias do requirements.txt
echo 2. Listar pacotes instalados
echo 3. Abrir shell Python interativo
echo 4. Verificar status do ambiente
echo 5. Continuar no terminal
echo.
set /p choice=Digite sua escolha (1-5): 

if "%choice%"=="1" (
    echo.
    echo Instalando dependencias...
    pip install -r requirements.txt
    echo.
    echo ✅ Dependencias instaladas!
    pause
)

if "%choice%"=="2" (
    echo.
    echo Pacotes instalados:
    pip list
    echo.
    pause
)

if "%choice%"=="3" (
    echo.
    echo Abrindo Python interativo...
    echo Digite 'exit()' para sair
    python
)

if "%choice%"=="4" (
    echo.
    echo Status do ambiente:
    echo Ambiente virtual: ATIVO
    echo Localizacao: %cd%\.venv
    echo Python: 
    python --version
    echo Pip:
    pip --version
    echo Total de pacotes:
    pip list | find /c /v ""
    echo.
    pause
)

if "%choice%"=="5" (
    echo.
    echo Continuando no terminal com ambiente ativo...
    echo Use 'deactivate' para desativar o ambiente
    echo.
)

echo.
echo Ambiente Python pronto para uso!
echo.