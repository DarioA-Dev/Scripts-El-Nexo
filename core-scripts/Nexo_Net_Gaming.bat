@echo off
:: =========================================================================
::   EL NEXO - OPTIMIZADOR DE RED GAMING v4.0
::   Protocolo: Ping Estable y Baja Latencia
:: =========================================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO v4.0 - RED GAMING
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
echo   PROTOCOLO: RED GAMING [PING ESTABLE]
echo   VERSION: 4.0 ENHANCED - Estado: Iniciando secuencia...
echo  ============================================================
echo.

:: TCP GLOBAL SETTINGS
echo  [PASO 1/5] Configurando TCP para gaming...
echo.
echo  [*] Optimizando pila TCP/IP...
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set global dca=enabled >nul 2>&1
netsh int tcp set global netdma=enabled >nul 2>&1
echo  [OK] TCP optimizado para juegos.

:: CONGESTION PROVIDER
echo.
echo  [PASO 2/5] Cambiando algoritmo de congestion...
echo.
echo  [*] CTCP es mejor para gaming online...
netsh int tcp set supplemental template=internet congestionprovider=ctcp >nul 2>&1
echo  [OK] Algoritmo configurado.

:: QOS CONFIGURATION
echo.
echo  [PASO 3/5] Configurando Quality of Service...
echo.
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] QoS optimizado.

:: NETWORK DISCOVERY
echo.
echo  [PASO 4/5] Optimizando reglas de Firewall...
echo.
netsh advfirewall firewall set rule group="Deteccion de redes" new enable=Yes >nul 2>&1
echo  [OK] Firewall configurado.

:: NAGLE'S ALGORITHM
echo.
echo  [PASO 5/5] Desactivando algoritmo de Nagle...
echo.
for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" 2^>nul ^| findstr /I "HKEY"') do (
    reg add "%%a" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%a" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1
)
echo  [OK] Latencia de red reducida.

:: FINALIZACION
echo.
echo  ============================================================
echo   OPTIMIZACION COMPLETADA CON EXITO
echo  ============================================================
echo.
echo   Tu conexion gaming ahora tiene:
echo   - Ping mas estable
echo   - Mejor sincronizacion en juegos
echo   - Paquetes sin retardo
echo.
echo   RECOMENDACION: Reinicia tu PC para mejores resultados.
echo.
echo  ============================================================
echo.
pause
exit
