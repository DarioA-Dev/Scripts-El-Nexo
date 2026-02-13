@echo off
:: =========================================================================
::   EL NEXO - REVERSION DE OPTIMIZACIONES v4.0
::   Modulo: Restaurar Configuracion Original [PC ESCRITORIO]
:: =========================================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO v4.0 - REVERTIR OPTIMIZACIONES PC
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
echo   PROTOCOLO: REVERSION DE OPTIMIZACIONES [PC ESCRITORIO]
echo   VERSION: 4.0 - Estado: Restaurando configuracion...
echo  ============================================================
echo.

:: RESTORE POWER SCHEME
echo  [PASO 1/7] Restaurando planes de energia de fabrica...
echo.
powercfg -restoredefaultschemes >nul 2>&1
powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
powercfg -h on >nul 2>&1
echo  [OK] Plan Equilibrado activado.

:: RESTORE KERNEL
echo.
echo  [PASO 2/7] Eliminando modificaciones del kernel...
echo.
bcdedit /deletevalue disabledynamictick >nul 2>&1
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /deletevalue tscsyncpolicy >nul 2>&1
bcdedit /deletevalue bootux >nul 2>&1
bcdedit /deletevalue hypervisorlaunchtype >nul 2>&1
bcdedit /deletevalue x2apicpolicy >nul 2>&1
echo  [OK] Parametros de arranque restaurados.

:: RESTORE CPU & RAM
echo.
echo  [PASO 3/7] Restaurando prioridades de CPU y memoria...
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 20 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 10 /f >nul 2>&1
echo  [OK] Configuracion de memoria normalizada.

:: RESTORE GPU
echo.
echo  [PASO 4/7] Restaurando configuracion grafica...
echo.
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /f >nul 2>&1
echo  [OK] GPU configurada por defecto.

:: RESTORE INPUT
echo.
echo  [PASO 5/7] Restaurando configuracion de entrada...
echo.
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "400" /f >nul 2>&1
echo  [OK] Perifericos restaurados.

:: RESTORE FILESYSTEM
echo.
echo  [PASO 6/7] Restaurando sistema de archivos...
echo.
fsutil behavior set disablelastaccess 2 >nul 2>&1
fsutil behavior set disable8dot3 2 >nul 2>&1
fsutil behavior set memoryusage 1 >nul 2>&1
echo  [OK] NTFS configurado por defecto.

:: RESTORE SERVICES
echo.
echo  [PASO 7/7] Reactivando servicios del sistema...
echo.
for %%s in (DiagTrack dmwappushservice SysMain WerSvc PcaSvc DPS WSearch) do (
    sc config %%s start=auto >nul 2>&1
    sc start %%s >nul 2>&1
)
echo  [OK] Servicios de Windows activos.

:: FINALIZACION
echo.
echo  ============================================================
echo   REVERSION COMPLETADA CON EXITO
echo  ============================================================
echo.
echo   Tu PC ha sido restaurado a su configuracion original.
echo.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar el sistema ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando para completar la reversion..."

exit
