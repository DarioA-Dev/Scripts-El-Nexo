@echo off
:: =========================================================================
::   EL NEXO - REVERSION DE OPTIMIZACIONES v4.0
::   Modulo: Restaurar Configuracion Original [PORTATIL]
:: =========================================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO v4.0 - REVERTIR OPTIMIZACIONES PORTATIL
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
echo   PROTOCOLO: REVERSION DE OPTIMIZACIONES [PORTATIL]
echo   VERSION: 4.0 - Estado: Restaurando configuracion...
echo  ============================================================
echo.

:: RESTORE POWER SCHEME
echo  [PASO 1/5] Restaurando planes de energia de fabrica...
echo.
powercfg -restoredefaultschemes >nul 2>&1
powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
echo  [OK] Plan Equilibrado activado.

:: RESTORE TURBO BOOST
echo.
echo  [PASO 2/5] Restaurando configuracion de Turbo Boost...
echo.
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v "Attributes" /f >nul 2>&1
echo  [OK] Turbo Boost gestionado automaticamente.

:: RESTORE NETWORK
echo.
echo  [PASO 3/5] Restaurando gestion de energia de red...
echo.
for /l %%n in (0,1,9) do (
    reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\000%%n" /v "PnPCapabilities" /f >nul 2>&1
)
echo  [OK] Adaptadores configurados por defecto.

:: RESTORE POWER THROTTLING
echo.
echo  [PASO 4/5] Restaurando Power Throttling...
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PowerThrottlingOff" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] Gestion inteligente de energia activa.

:: RESTORE SYSTEM PROFILE
echo.
echo  [PASO 5/5] Restaurando perfil del sistema...
echo.
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 20 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 10 /f >nul 2>&1
echo  [OK] Perfil normalizado.

:: FINALIZACION
echo.
echo  ============================================================
echo   REVERSION COMPLETADA CON EXITO
echo  ============================================================
echo.
echo   Tu portatil ha sido restaurado a su configuracion original.
echo.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar el sistema ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando para completar la reversion..."

exit
