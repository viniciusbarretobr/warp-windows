@echo off
setlocal EnableDelayedExpansion
REM ============================================================
REM Instalador automatico Cloudflare WARP (consumer)
REM Uso via CMD remoto - sem interacao
REM ============================================================
set "MSI_URL=https://1111-releases.cloudflareclient.com/windows/Cloudflare_WARP_Release-x64.msi"
set "MSI_PATH=%TEMP%\Cloudflare_WARP.msi"
set "WARP_CLI=C:\Program Files\Cloudflare\Cloudflare WARP\warp-cli.exe"
set "LOG=%TEMP%\warp_install.log"
echo ============================================================
echo  Instalador Cloudflare WARP - %COMPUTERNAME%
echo  Log: %LOG%
echo ============================================================
REM --- Verifica privilegios de admin ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERRO] Este script precisa ser executado como Administrador
    echo Abra o CMD remoto com privilegios elevados e tente novamente
    exit /b 1
)
echo [OK] Executando como Administrador
echo [%date% %time%] Inicio > "%LOG%"
REM --- 1. Verifica se ja esta instalado ---
if exist "%WARP_CLI%" (
    echo [INFO] WARP ja instalado, pulando download
    goto :registrar
)
REM --- 2. Download do MSI ---
echo [1/4] Baixando instalador WARP...
curl -L -s -o "%MSI_PATH%" "%MSI_URL%"
if not exist "%MSI_PATH%" (
    echo [ERRO] Falha no download
    exit /b 1
)
echo       OK - %MSI_PATH%
REM --- 3. Instalacao silenciosa ---
echo [2/4] Instalando silenciosamente...
msiexec /i "%MSI_PATH%" /quiet /norestart /l*v "%LOG%.msi"
if errorlevel 1 (
    echo [ERRO] msiexec falhou - veja %LOG%.msi
    exit /b 1
)
REM --- 4. Aguarda binario aparecer ---
echo [3/4] Aguardando servico...
set /a tentativas=0
:aguarda
if not exist "%WARP_CLI%" (
    timeout /t 2 /nobreak >nul
    set /a tentativas+=1
    if !tentativas! geq 30 (
        echo [ERRO] Timeout - WARP nao apareceu apos 60s
        exit /b 1
    )
    goto :aguarda
)
timeout /t 5 /nobreak >nul
:registrar
REM --- 5. Pula tela de boas-vindas (onboarding) ---
echo [INFO] Configurando para pular onboarding...
reg add "HKLM\SOFTWARE\Cloudflare\Warp" /v "organization" /t REG_SZ /d "" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Cloudflare\Warp" /v "onboarding_complete" /t REG_DWORD /d 1 /f >nul 2>&1
for /f "tokens=2" %%u in ('query session ^| findstr /R /C:"console"') do (
    reg load "HKU\TempUser" "C:\Users\%%u\NTUSER.DAT" >nul 2>&1
    reg add "HKU\TempUser\SOFTWARE\Cloudflare\Warp" /v "onboarding_complete" /t REG_DWORD /d 1 /f >nul 2>&1
    reg unload "HKU\TempUser" >nul 2>&1
)
REM --- 6. Registro, configuracao e conexao ---
echo [4/4] Registrando, configurando e conectando...
"%WARP_CLI%" --accept-tos registration new >> "%LOG%" 2>&1
timeout /t 3 /nobreak >nul
"%WARP_CLI%" --accept-tos set-mode warp >> "%LOG%" 2>&1
"%WARP_CLI%" --accept-tos connect >> "%LOG%" 2>&1
"%WARP_CLI%" --accept-tos enable-always-on >> "%LOG%" 2>&1
timeout /t 5 /nobreak >nul
REM --- 7. Status final ---
echo.
echo ============================================================
echo Status final:
echo ============================================================
"%WARP_CLI%" --accept-tos status
echo.
echo Validacao rapida (deve mostrar warp=on):
curl -s https://www.cloudflare.com/cdn-cgi/trace | findstr /C:"warp="
echo.
echo Concluido em %COMPUTERNAME% - log em %LOG%
endlocal