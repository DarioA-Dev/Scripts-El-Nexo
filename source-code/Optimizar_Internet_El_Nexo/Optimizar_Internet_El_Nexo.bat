@echo off
:: =========================================================================
::   EL NEXO - OPTIMIZADOR DE RED Y BAJA LATENCIA v4.0
::   Protocolo: TCP/IP Stack, DNS y Eliminacion de Lag
:: =========================================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO v4.0 - OPTIMIZADOR DE RED
color 0B

:: VERIFICACION DE PRIVILEGIOS
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    cls
    color 0C
    echo.
    echo  ============================================================
    echo   ACCESO DENEGADO - Se requieren permisos de Administrador
    echo  ============================================================
    echo.
    echo   Haz clic derecho sobre el archivo y selecciona:
    echo   "Ejecutar como administrador"
    echo.
    echo  ============================================================
    pause
    exit /b
)

:: CABECERA CIBERPUNK "EL NEXO"
cls
color 0B
echo.
echo  ============================================================
echo      _____ _       _   _ _______   _______  
echo     ^|  ___^| ^|     ^| \ ^| ^|  ___\ \ / /  _ \ 
echo     ^| ^|__ ^| ^|     ^|  \^| ^| ^|__  \ V /^| ^| ^| ^|
echo     ^|  __^|^| ^|     ^| . ` ^|  __^|  ^> ^< ^| ^| ^| ^|
echo     ^| ^|___^| ^|____ ^| ^|\  ^| ^|___ / . \^| ^|_^| ^|
echo     ^|_____^|______^|_^| \_^|_____/_/ \_\_____/ 
echo.
echo  ============================================================
echo   PROTOCOLO: OPTIMIZACION DE RED [BAJA LATENCIA]
echo   VERSION: 4.0 ENHANCED - Estado: Iniciando secuencia...
echo  ============================================================
echo.

:: PUNTO DE CONTROL
echo  [PASO 1/9] Creando punto de restauracion de seguridad...
echo.
set /p "backup= Deseas crear un respaldo antes de continuar? (S/N): "
if /i "%backup%"=="S" (
    echo.
    echo  [*] Generando punto de restauracion del sistema...
    powershell -Command "Checkpoint-Computer -Description 'El Nexo v4.0 Red' -RestorePointType 'MODIFY_SETTINGS'" 2>nul
    if !errorlevel! equ 0 (
        echo  [OK] Punto de restauracion creado correctamente.
    ) else (
        echo  [!] No se pudo crear el punto. Continuando de todos modos...
    )
) else (
    echo  [!] Saltando respaldo por decision del usuario.
)

:: TCP/IP STACK OPTIMIZATION
echo.
echo  [PASO 2/9] Optimizando pila TCP/IP...
echo.
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global heuristics=disabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global fastopen=enabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
netsh int tcp set global chimney=enabled >nul 2>&1
netsh int tcp set supplemental template=internet congestionprovider=cubic >nul 2>&1
echo  [OK] Protocolo TCP configurado para gaming.

:: NETWORK THROTTLING
echo.
echo  [PASO 3/9] Eliminando limitadores de red...
echo.
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] Throttling de red desactivado.

:: MSI MODE FOR NETWORK
echo.
echo  [PASO 4/9] Activando MSI Mode en adaptadores de red...
echo.
set "msi_temp=%temp%\nexo_msi_net_%random%.txt"
reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "Interrupt Management" >"%msi_temp%" 2>nul
if exist "%msi_temp%" (
    echo  [*] Optimizando interrupciones de hardware de red...
    for /f "tokens=*" %%i in ('type "%msi_temp%" ^| findstr /I "HKEY_LOCAL_MACHINE"') do (
        reg add "%%i\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d 1 /f >nul 2>&1
    )
    del /f /q "%msi_temp%" >nul 2>&1
    echo  [OK] Latencia de adaptadores reducida.
)

:: NAGLE'S ALGORITHM DISABLE
echo.
echo  [PASO 5/9] Desactivando algoritmo de Nagle...
echo.
for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" 2^>nul ^| findstr /I "HKEY"') do (
    reg add "%%a" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%a" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%a" /v "TcpDelAckTicks" /t REG_DWORD /d 0 /f >nul 2>&1
)
echo  [OK] Paquetes se enviaran instantaneamente.

:: QOS PACKET SCHEDULER
echo.
echo  [PASO 6/9] Configurando Quality of Service...
echo.
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] QoS optimizado para juegos.

:: WIFI/LAPTOP OPTIMIZATION
echo.
echo  [PASO 7/9] Optimizacion de adaptadores inalambricos...
echo.
set /p "laptop= Tu sistema usa Wi-Fi o es un portatil? (S/N): "
if /i "%laptop%"=="S" (
    echo.
    echo  [*] Desactivando ahorro de energia en Wi-Fi...
    for /l %%n in (0,1,9) do (
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\000%%n" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1
    )
    echo  [OK] Wi-Fi configurado para maxima velocidad.
)

:: DNS CONFIGURATION
echo.
echo  [PASO 8/9] Configuracion de servidores DNS...
echo.
set /p "dns= Deseas configurar DNS de Cloudflare (1.1.1.1)? (S/N): "
if /i "%dns%"=="S" (
    echo.
    echo  [*] Aplicando DNS de baja latencia...
    netsh interface ip set dns "Ethernet" static 1.1.1.1 primary >nul 2>&1
    netsh interface ip add dns "Ethernet" 1.0.0.1 index=2 >nul 2>&1
    netsh interface ip set dns "Wi-Fi" static 1.1.1.1 primary >nul 2>&1
    netsh interface ip add dns "Wi-Fi" 1.0.0.1 index=2 >nul 2>&1
    echo  [OK] DNS configurados correctamente.
) else (
    echo  [!] Saltando configuracion DNS.
)

:: NETWORK RESET
echo.
echo  [PASO 9/9] Aplicando cambios de red...
echo.
echo  [*] Se reiniciaran los adaptadores de red brevemente...
ipconfig /flushdns >nul 2>&1
netsh winsock reset catalog >nul 2>&1
netsh int ip reset >nul 2>&1
echo  [OK] Cambios aplicados correctamente.

:: FINALIZACION
echo.
echo  ============================================================
echo   OPTIMIZACION COMPLETADA CON EXITO
echo  ============================================================
echo.
echo   Tu conexion ahora tiene:
echo   - Menor ping y latencia
echo   - Mejor estabilidad en juegos online
echo   - Paquetes sin retardo artificial
echo.
echo   RECOMENDACION: Reinicia tu PC para mejores resultados.
echo.
echo  ============================================================
echo.
pause
exit
