# Warp no Windows

## Script para automatizar a instalação do Warp da Cloudflare no Windows

### 2. No CMD remoto de cada PC:
```
cmdcurl -L -o %TEMP%\instalar_warp.cmd https://github.com/viniciusbarretobr/warp-windows/blob/main/instalar_warp.bat
curl -L -o %TEMP%\testar_warp.cmd https://github.com/viniciusbarretobr/warp-windows/blob/main/testar_warp.bat
%TEMP%\instalar_warp.cmd
```

### 3. Validar:
```
cmd%TEMP%\testar_warp.cmd
Procurar warp=on na saída.
```

### Note:
A partir do Windows 10 1803 (abril/2018) o curl.exe vem nativo em C:\Windows\System32\curl.exe.

## Caso nao tenha o Curl instalado no Windows, instalar com este comando:
```
where curl >nul 2>&1 || (powershell -Command "Invoke-WebRequest -Uri 'https://curl.se/windows/latest.cgi?p=win64-mingw.zip' -OutFile $env:TEMP+'\curl.zip'; Expand-Archive -Path $env:TEMP+'\curl.zip' -DestinationPath $env:TEMP+'\curl' -Force; Get-ChildItem $env:TEMP+'\curl' -Filter 'curl.exe' -Recurse | Select-Object -First 1 | Copy-Item -Destination C:\Windows\System32\")
```