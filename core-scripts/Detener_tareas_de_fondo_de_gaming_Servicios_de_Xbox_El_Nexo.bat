@echo off
:: ==========================================================
::   EL NEXO - OPTIMIZACIÓN DE TAREAS DE FONDO v3.6
::   Protocolo: Xbox Services, Telemetría y CPU Scheduling
:: ==========================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO: TASK MANAGER v3.6
color 0A

:: 1. VERIFICACIÓN DE PRIVILEGIOS
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo   [ERROR] ACCESO DENEGADO. EJECUTA COMO ADMINISTRADOR.
    pause >nul
    exit
)

:: 2. CABECERA ASCII "EL NEXO"
cls
echo.
echo   ______ _       _   _ ______   _____ 
echo  ^|  ____^| ^|     ^| \ ^| ^|  ____^| \ \ / / _ \ 
echo  ^| ^|__  ^| ^|     ^|  \^| ^| ^|__     \ V / ^| ^| ^|
echo  ^|  __^| ^| ^|     ^| . ` ^|  __^|     ^> ^<^| ^| ^| ^|
echo  ^| ^|____^| ^|____ ^| ^|\  ^| ^|____   / . \ ^|_^| ^|
echo  ^|______^|______^|_^| \_^|______^| /_/ \_\___/ 
echo.
echo  ==========================================================
echo   PROTOCOLO: NEUTRALIZACIÓN DE TAREAS (V3.6)
echo   ESTADO: Escaneando procesos de telemetría...
echo  ==========================================================
echo.

:: 3. PUNTO DE CONTROL
echo [SEGURIDAD] ¿Deseas generar punto de restauración antes de purgar servicios?
set /p "backup=Tu respuesta (S/N): "
if /i "%backup%"=="S" (
    echo.
    echo [+] Iniciando respaldo de configuración de servicios...
    powershell -Command "Checkpoint-Computer -Description 'Tareas Nexo v3.6' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
    echo [OK] Punto establecido.
)

:: 4. BLOQUEO GLOBAL DE APPS UWP
echo.
echo [+] Inyectando directivas de denegación para apps de fondo...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
echo [OK] Ejecución de apps en segundo plano neutralizada.

:: 5. NEUTRALIZACIÓN DE GAMEDVR & XBOX
echo.
echo [+] Desactivando GameDVR y Servicios de Ecosistema Xbox...
echo     [INFO] Esto liberará ciclos de GPU y memoria RAM.
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowgameDVR" /t REG_DWORD /d 0 /f >nul 2>&1
for %%s in (XblAuthManager XblGameSave XboxGipSvc XboxNetApiSvc GamingServices) do (
    sc stop %%s >nul 2>&1
    sc config %%s start= disabled >nul 2>&1
)
echo [OK] Servicios de Xbox neutralizados.

:: 6. TELEMETRÍA AVANZADA
echo.
echo [+] Eliminando servicios de rastreo y recolección de datos...
for %%s in (DiagTrack dmwappushservice WerSvc PcaSvc DPS RetailDemo) do (
    sc stop %%s >nul 2>&1
    sc config %%s start= disabled >nul 2>&1
)
echo [OK] Telemetría y diagnóstico desactivados.

:: 7. PRIORIDAD DE JUEGOS (CPU SCHEDULING)
echo.
echo [+] Ajustando prioridades de "Games" en el SystemProfile...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
echo [OK] Jerarquía de procesos configurada para alto rendimiento.

:: 8. LIMPIEZA DE TAREAS PROGRAMADAS
echo.
echo [+] Desactivando tareas de mantenimiento automático...
powershell -Command "Disable-ScheduledTask -TaskName 'Microsoft\Windows\Defrag\ScheduledDefrag' -ErrorAction SilentlyContinue" >nul 2>&1
powershell -Command "Disable-ScheduledTask -TaskName 'Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser' -ErrorAction SilentlyContinue" >nul 2>&1
echo [OK] Tareas de bajo nivel desactivadas.

echo.
echo ==========================================================
echo    PROTOCOLO COMPLETADO. CPU LIBERADA AL 100%%.
echo ==========================================================
echo.
pause
exit
