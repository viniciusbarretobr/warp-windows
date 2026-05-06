@echo off
setlocal EnableDelayedExpansion

REM ============================================================
REM Teste de conectividade Cloudflare WARP
REM Uso via CMD remoto - sem interacao
REM ============================================================

set "WARP_CLI=C:\Program Files\Cloudflare\Cloudflare WARP\warp-cli.exe"

echo ============================================================
echo  Teste Cloudflare WARP - %COMPUTERNAME%
echo  Data: %date% %time%
echo ============================================================

REM --- 1. Verifica instalacao ---
echo [1/5] Verificando instalacao...
if not exist "%WARP_CLI%" (
    echo       FALHOU - WARP nao instalado
    echo Execute primeiro: instalar_warp.cmd
    exit /b 1
)
echo       OK - instalado

REM --- 2. Status do cliente ---
echo.
echo [2/5] Status do cliente:
echo ------------------------------------------------------------
"%WARP_CLI%" --accept-tos status
echo ------------------------------------------------------------

REM --- 3. Reconecta se necessario ---
"%WARP_CLI%" --accept-tos status | findstr /C:"Connected" >nul
if errorlevel 1 (
    echo [AVISO] Nao conectado, tentando conectar...
    "%WARP_CLI%" --accept-tos connect
    timeout /t 5 /nobreak >nul
)

REM --- 4. IP publico via Cloudflare trace ---
echo.
echo [3/5] Trace Cloudflare (procure warp=on):
echo ------------------------------------------------------------
curl -s https://www.cloudflare.com/cdn-cgi/trace
echo ------------------------------------------------------------

REM --- 5. Teste DNS ---
echo.
echo [4/5] Resolucao DNS via 1.1.1.1:
nslookup cloudflare.com 1.1.1.1 2>nul | findstr /C:"Address" /C:"Name"

REM --- 6. Latencia ---
echo.
echo [5/5] Latencia para 1.1.1.1:
ping -n 4 1.1.1.1

echo.
echo ============================================================
echo Teste concluido em %COMPUTERNAME%
echo ============================================================
endlocal