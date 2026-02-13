@echo off
:: =========================================================================
::   EL NEXO - REVERSION DE OPTIMIZACIONES v4.0
::   Modulo: Restaurar Servicios de Fondo [PROCESOS]
:: =========================================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO v4.0 - REVERTIR OPTIMIZACION DE PROCESOS
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
echo   PROTOCOLO: RESTAURACION DE PROCESOS [FONDO]
echo   VERSION: 4.0 - Estado: Reactivando servicios...
echo  ============================================================
echo.

:: RESTORE BACKGROUND APPS
echo  [PASO 1/5] Habilitando aplicaciones de fondo...
echo.
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] Apps de fondo permitidas.

:: RESTORE GAMEDVR
echo  [PASO 2/5] Reactivando GameDVR y Barra de Juegos...
echo.
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowgameDVR" /f >nul 2>&1
echo  [OK] GameDVR activo.

:: RESTORE XBOX SERVICES
echo.
echo  [PASO 3/5] Reactivando servicios de Xbox...
echo.
for %%s in (XblAuthManager XblGameSave XboxGipSvc XboxNetApiSvc GamingServices GamingServicesNet) do (
    sc config %%s start=demand >nul 2>&1
)
echo  [OK] Servicios de Xbox disponibles.

:: RESTORE TELEMETRY
echo.
echo  [PASO 4/5] Reactivando servicios de diagnostico...
echo.
for %%s in (DiagTrack dmwappushservice WerSvc PcaSvc DPS) do (
    sc config %%s start=auto >nul 2>&1
    sc start %%s >nul 2>&1
)
echo  [OK] Diagnostico del sistema activo.

:: RESTORE SCHEDULED TASKS
echo.
echo  [PASO 5/5] Reactivando tareas programadas...
echo.
schtasks /Change /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" /Enable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Enable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Enable >nul 2>&1
echo  [OK] Tareas de mantenimiento activas.

:: FINALIZACION
echo.
echo  ============================================================
echo   REVERSION COMPLETADA CON EXITO
echo  ============================================================
echo.
echo   Servicios y procesos de fondo restaurados.
echo.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar el sistema ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando para completar la reversion..."

exit
