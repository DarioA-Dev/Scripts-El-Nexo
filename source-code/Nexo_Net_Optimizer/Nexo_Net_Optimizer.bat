@echo off
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO v5.0 - NET OPTIMIZER
color 0B

net session >nul 2>&1
if %errorlevel% neq 0 (
    cls
    color 0C
    echo.
    echo  ============================================================
    echo   ACCESO DENEGADO - Se requieren permisos de Administrador
    echo  ============================================================
    echo.
    echo   Haz clic derecho y selecciona "Ejecutar como administrador"
    echo.
    echo  ============================================================
    pause
    exit /b
)

cls
color 0B
echo.
echo  ============================================================
echo    _____ _         _   _ _______  ___   ___
echo   ^|  ___^| ^|       ^| \ ^| ^|  _____^|^|   \ ^|   ^|
echo   ^| ^|__ ^| ^|       ^|  \^| ^| ^|___   ^| ^|\ \^| ^| ^|
echo   ^|  __^|^| ^|       ^| . ` ^|  _^|   ^| ^| \ ` ^| ^|
echo   ^| ^|___^| ^|____   ^| ^|\  ^| ^|____  ^| ^|  \ ^| ^|
echo   ^|_____^|______^|  ^|_^| \_^|______^| ^|___\____^|
echo.
echo  ============================================================
echo   PROTOCOLO: NET OPTIMIZER [PING Y LATENCIA MINIMA]
echo   VERSION: 5.0
echo  ============================================================
echo.

echo  [PASO 1/8] Creando punto de restauracion...
echo.
set /p "backup=Deseas crear un respaldo antes de continuar? (S/N): "
if /i "%backup%"=="S" (
    powershell -Command "Checkpoint-Computer -Description 'El Nexo Net Optimizer' -RestorePointType 'MODIFY_SETTINGS'" 2>nul
    if !errorlevel! equ 0 (echo  [OK] Punto creado.) else (echo  [!] No se pudo crear. Continuando...)
) else (
    echo  [!] Saltando respaldo.
)

echo.
echo  [PASO 2/8] Optimizando pila TCP/IP con CTCP...
echo.
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global heuristics=disabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global fastopen=enabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
netsh int tcp set global dca=enabled >nul 2>&1
netsh int tcp set global netdma=enabled >nul 2>&1
netsh int tcp set supplemental template=internet congestionprovider=ctcp >nul 2>&1
echo  [OK] TCP/IP optimizado con CTCP.

echo.
echo  [PASO 3/8] Eliminando limitadores de red del sistema...
echo.
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] Throttling de red desactivado.

echo.
echo  [PASO 4/8] Desactivando algoritmo de Nagle...
echo.
for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" 2^>nul ^| findstr /I "HKEY"') do (
    reg add "%%a" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%a" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%a" /v "TcpDelAckTicks" /t REG_DWORD /d 0 /f >nul 2>&1
)
echo  [OK] Paquetes enviados instantaneamente.

echo.
echo  [PASO 5/8] QoS al 0%% (todo el ancho de banda disponible)...
echo.
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] Ancho de banda reservado eliminado.

echo.
echo  [PASO 6/8] Desactivando Energy-Efficient Ethernet Realtek...
echo.
for /l %%n in (0,1,9) do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\000%%n" /v "EEE" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\000%%n" /v "GreenEthernetEnable" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\000%%n" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1
)
echo  [OK] EEE desactivado - latencia de red consistente.

echo.
echo  [PASO 7/8] Configuracion de DNS...
echo.
echo  Opciones de DNS:
echo   [1] Cloudflare 1.1.1.1  (mas rapido globalmente)
echo   [2] Google    8.8.8.8   (mas estable)
echo   [3] Mantener DNS actual
echo.
set /p "dns_opt=Elige una opcion (1/2/3): "
if "%dns_opt%"=="1" (
    netsh interface ip set dns "Ethernet" static 1.1.1.1 primary >nul 2>&1
    netsh interface ip add dns "Ethernet" 1.0.0.1 index=2 >nul 2>&1
    netsh interface ip set dns "Wi-Fi" static 1.1.1.1 primary >nul 2>&1
    netsh interface ip add dns "Wi-Fi" 1.0.0.1 index=2 >nul 2>&1
    echo  [OK] DNS Cloudflare configurado.
) else if "%dns_opt%"=="2" (
    netsh interface ip set dns "Ethernet" static 8.8.8.8 primary >nul 2>&1
    netsh interface ip add dns "Ethernet" 8.8.4.4 index=2 >nul 2>&1
    netsh interface ip set dns "Wi-Fi" static 8.8.8.8 primary >nul 2>&1
    netsh interface ip add dns "Wi-Fi" 8.8.4.4 index=2 >nul 2>&1
    echo  [OK] DNS Google configurado.
) else (
    echo  [!] DNS sin cambios.
)

echo.
echo  [PASO 8/8] Limpiando stack de red y cache DNS...
echo.
ipconfig /flushdns >nul 2>&1
netsh winsock reset catalog >nul 2>&1
netsh int ip reset >nul 2>&1
echo  [OK] Stack de red reseteado y DNS limpiado.

echo.
echo  ============================================================
echo   NET OPTIMIZER COMPLETADO
echo  ============================================================
echo.
echo   Cambios aplicados:
echo   - TCP/IP con CTCP (mejor para gaming)
echo   - Nagle desactivado (paquetes sin retardo)
echo   - QoS al 0%% (ancho de banda completo)
echo   - EEE Realtek desactivado (latencia estable)
echo   - Throttling de red eliminado
echo.
echo   RECOMENDACION: Reinicia el PC para mejores resultados.
echo  ============================================================
echo.
set /p "reboot=Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando Net Optimizer El Nexo..."
exit
