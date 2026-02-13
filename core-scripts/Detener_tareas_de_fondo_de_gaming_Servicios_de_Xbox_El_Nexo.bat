@echo off
chcp 65001 >nul
title EL NEXO - GESTIÓN DE TAREAS
color 0A
setlocal enabledelayedexpansion

:: ADMIN CHECK
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo [ERROR] Necesitas permisos de Administrador.
    echo Haz clic derecho ^> Ejecutar como administrador.
    pause >nul
    exit
)

echo ======================================================
echo          PROTOCOLO DE TAREAS DE FONDO: EL NEXO
echo ======================================================

:: PUNTO DE RESTAURACIÓN
echo.
set /p "backup=¿Crear Punto de Restauración? (S/N): "
if /i "%backup%"=="S" (
    echo [+] Creando punto de restauración...
    wmic /namespace:\\root\default path SystemRestore call CreateRestorePoint "Tareas Nexo", 100, 12 >nul 2>&1
    echo [OK] Punto creado.
)

:: APPS EN SEGUNDO PLANO
echo.
echo [+] Bloqueando apps de fondo...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Apps bloqueadas.

:: GAMEDVR
echo.
echo [+] Desactivando GameDVR...
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowgameDVR" /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] GameDVR desactivado.

:: SERVICIOS XBOX
echo.
echo [+] Desactivando Xbox...
for %%s in (XblAuthManager XblGameSave XboxGipSvc XboxNetApiSvc GamingServices) do (
    sc stop %%s >nul 2>&1
    sc config %%s start= disabled >nul 2>&1
)
echo [OK] Xbox desactivado.

:: TELEMETRÍA
echo.
echo [+] Bloqueando telemetría...
for %%s in (DiagTrack dmwappushservice WerSvc PcaSvc DPS RetailDemo) do (
    sc stop %%s >nul 2>&1
    sc config %%s start= disabled >nul 2>&1
)
echo [OK] Telemetría bloqueada.

:: PRIORIDAD GAMING
echo.
echo [+] Optimizando prioridades...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
echo [OK] Prioridades optimizadas.

echo.
echo ======================================================
echo    PROTOCOLO COMPLETADO
echo ======================================================
pause
exit
