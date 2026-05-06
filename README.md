# Warp no Windows

## Script para automatizar a instalação do Warp da Cloudflare no Windows

### 1. No CMD remoto de cada PC:
```
del %TEMP%\instalar_warp.cmd %TEMP%\testar_warp.cmd
curl -L -o %TEMP%\instalar_warp.cmd https://raw.githubusercontent.com/viniciusbarretobr/warp-windows/main/instalar_warp.bat
curl -L -o %TEMP%\testar_warp.cmd https://raw.githubusercontent.com/viniciusbarretobr/warp-windows/main/testar_warp.bat
%TEMP%\instalar_warp.cmd
```

### 2. Validar:
```
cmd%TEMP%\testar_warp.cmd
Procurar warp=on na saída.
```

#### Notes:

1. A partir do Windows 10 1803 (abril/2018) o curl.exe vem nativo em C:\Windows\System32\curl.exe.

2. Caso nao tenha o Curl instalado no Windows, instalar com este comando:
```
where curl >nul 2>&1 || (powershell -Command "Invoke-WebRequest -Uri 'https://curl.se/windows/latest.cgi?p=win64-mingw.zip' -OutFile $env:TEMP+'\curl.zip'; Expand-Archive -Path $env:TEMP+'\curl.zip' -DestinationPath $env:TEMP+'\curl' -Force; Get-ChildItem $env:TEMP+'\curl' -Filter 'curl.exe' -Recurse | Select-Object -First 1 | Copy-Item -Destination C:\Windows\System32\")
```

