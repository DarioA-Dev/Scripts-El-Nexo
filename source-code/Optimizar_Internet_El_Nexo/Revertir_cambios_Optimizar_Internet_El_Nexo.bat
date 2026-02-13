@echo off
:: =========================================================================
::   EL NEXO - REVERSION DE OPTIMIZACIONES v4.0
::   Modulo: Restaurar Configuracion Original [RED]
:: =========================================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO v4.0 - REVERTIR OPTIMIZACIONES DE RED
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
echo   PROTOCOLO: REVERSION DE OPTIMIZACIONES [RED]
echo   VERSION: 4.0 - Estado: Restaurando configuracion...
echo  ============================================================
echo.

:: RESTORE TCP STACK
echo  [PASO 1/5] Restaurando pila TCP/IP...
echo.
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global heuristics=enabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global chimney=automatic >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set supplemental template=internet congestionprovider=default >nul 2>&1
echo  [OK] TCP/IP restaurado a valores por defecto.

:: RESTORE NETWORK THROTTLING
echo.
echo  [PASO 2/5] Restaurando Network Throttling...
echo.
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 10 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 20 /f >nul 2>&1
echo  [OK] Throttling restaurado.

:: RESTORE NAGLE'S ALGORITHM
echo.
echo  [PASO 3/5] Restaurando algoritmo de Nagle...
echo.
for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" 2^>nul ^| findstr /I "HKEY"') do (
    reg delete "%%a" /v "TcpAckFrequency" /f >nul 2>&1
    reg delete "%%a" /v "TCPNoDelay" /f >nul 2>&1
    reg delete "%%a" /v "TcpDelAckTicks" /f >nul 2>&1
)
echo  [OK] Algoritmo de Nagle activo.

:: RESTORE QOS
echo.
echo  [PASO 4/5] Restaurando QoS...
echo.
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /f >nul 2>&1
echo  [OK] QoS por defecto.

:: NETWORK RESET
echo.
echo  [PASO 5/5] Aplicando cambios de red...
echo.
ipconfig /flushdns >nul 2>&1
echo  [OK] Cache DNS limpiada.

:: FINALIZACION
echo.
echo  ============================================================
echo   REVERSION COMPLETADA CON EXITO
echo  ============================================================
echo.
echo   Tu conexion de red ha sido restaurada a configuracion
echo   original de Windows.
echo.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar el sistema ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando para completar la reversion..."

exit
