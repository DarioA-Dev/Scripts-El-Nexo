@echo off
:: =========================================================================
::   EL NEXO - REVERSION DE OPTIMIZACIONES v4.0
::   Modulo: Restaurar Configuracion Original [AHORRO BATERIA]
:: =========================================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO v4.0 - REVERTIR MODO ECO
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
echo   PROTOCOLO: REVERSION DE MODO ECO [AHORRO BATERIA]
echo   VERSION: 4.0 - Estado: Restaurando configuracion...
echo  ============================================================
echo.

:: RESTORE POWER SCHEME
echo  [PASO 1/4] Restaurando planes de energia de fabrica...
echo.
powercfg -restoredefaultschemes >nul 2>&1
powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
echo  [OK] Plan Equilibrado activado.

:: RESTORE TRANSPARENCY
echo.
echo  [PASO 2/4] Restaurando efectos visuales...
echo.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d 1 /f >nul 2>&1
echo  [OK] Efectos de interfaz restaurados.

:: RESTORE BACKGROUND APPS
echo.
echo  [PASO 3/4] Habilitando aplicaciones de fondo...
echo.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /f >nul 2>&1
echo  [OK] Apps de fondo permitidas.

:: RESTORE POWER THROTTLING
echo.
echo  [PASO 4/4] Restaurando Power Throttling...
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PowerThrottlingOff" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] Gestion inteligente activa.

:: FINALIZACION
echo.
echo  ============================================================
echo   REVERSION COMPLETADA CON EXITO
echo  ============================================================
echo.
echo   Tu sistema ha sido restaurado a configuracion equilibrada.
echo.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar el sistema ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando para completar la reversion..."

exit
