# Warp no Windows

## Script para automatizar a instalação do Warp da Cloudflare no Windows

### 2. No CMD remoto de cada PC:
```
cmdcurl -L -o %TEMP%\instalar_warp.cmd https://SEU-LINK/instalar_warp.cmd
curl -L -o %TEMP%\testar_warp.cmd https://SEU-LINK/testar_warp.cmd
%TEMP%\instalar_warp.cmd
```

### 3. Validar:
```
cmd%TEMP%\testar_warp.cmd
Procurar warp=on na saída.
```


### Note:

A partir do Windows 10 1803 (abril/2018) o curl.exe vem nativo em C:\Windows\System32\curl.exe.