@echo off
:: =========================================================================
::   EL NEXO - REVERT: MAX POWER v5.0
::   Deshace todos los cambios aplicados por Nexo_Max_Power.bat
:: =========================================================================
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO - REVERT Max Power
color 0E

net session >nul 2>openfiles >nul 2>&11
if %errorlevel% neq 0 (
    cls & color 0C
    echo  Se requieren permisos de Administrador.
    echo  Haz clic derecho y selecciona "Ejecutar como administrador"
    pause & exit /b
)

cls
color 0E
echo.
echo  ============================================================
echo   EL NEXO - REVERT: MAX POWER
echo   Restaurando configuracion original del sistema...
echo  ============================================================
echo.

:: ── ELIMINAR PLANES DE ENERGIA CREADOS ───────────────────────────────────
echo  [1/7] Eliminando planes de energia de El Nexo...
powercfg -delete 11111111-1111-1111-1111-111111111111 >nul 2>&1
powercfg -delete 22222222-2222-2222-2222-222222222222 >nul 2>&1
:: Restaurar plan Equilibrado por defecto
powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
:: Restaurar hibernacion
powercfg -h on >nul 2>&1
echo  [OK] Planes eliminados. Plan Equilibrado restaurado.

:: ── KERNEL Y BOOTLOADER ────────────────────────────────────────────────────
echo.
echo  [2/7] Restaurando parametros del kernel...
bcdedit /deletevalue disabledynamictick >nul 2>&1
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /deletevalue tscsyncpolicy >nul 2>&1
bcdedit /deletevalue bootux >nul 2>&1
bcdedit /deletevalue x2apicpolicy >nul 2>&1
:: Restaurar VBS / Hypervisor
bcdedit /set hypervisorlaunchtype auto >nul 2>&1
echo  [OK] Kernel restaurado a valores por defecto.

:: ── GPU: MPO, PREEMPTION, ULPS ────────────────────────────────────────────
echo.
echo  [3/7] Restaurando configuracion de GPU...
reg delete "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /f >nul 2>&1
:: ULPS: restaurar a activado (valor 1)
set "gpu_temp=%temp%\nexo_rev_gpu_%random%.txt"
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Video" /s /f "EnableUlps" >"%gpu_temp%" 2>nul
if exist "%gpu_temp%" (
    for /f "tokens=*" %%a in ('type "%gpu_temp%" ^| findstr /I "HKEY_LOCAL_MACHINE"') do (
        reg add "%%a" /v "EnableUlps" /t REG_DWORD /d 1 /f >nul 2>&1
    )
    del /f /q "%gpu_temp%" >nul 2>&1
)
echo  [OK] GPU restaurada.

:: ── CPU, RAM Y PRIORIDADES ─────────────────────────────────────────────────
echo.
echo  [4/7] Restaurando prioridades de CPU y memoria...
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /f >nul 2>&1
echo  [OK] Prioridades de CPU y memoria restauradas.

:: ── LATENCIA DE ENTRADA ────────────────────────────────────────────────────
echo.
echo  [5/7] Restaurando configuracion de perifericos...
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "400" /f >nul 2>&1
reg delete "HKCU\Control Panel\Mouse" /v "MouseHoverTime" /f >nul 2>&1
echo  [OK] Perifericos restaurados.

:: ── GAME PRIORITY ─────────────────────────────────────────────────────────
echo.
echo  [6/7] Restaurando prioridades del scheduler multimedia...
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /f >nul 2>&1
echo  [OK] Scheduler restaurado.

:: ── SERVICIOS ─────────────────────────────────────────────────────────────
echo.
echo  [7/7] Reactivando servicios desactivados...
for %%s in (DiagTrack dmwappushservice WerSvc PcaSvc DPS SysMain) do (
    sc config %%s start=auto >nul 2>&1
    sc start %%s >nul 2>&1
)
:: RetailDemo se deja desactivado (irrelevante para el usuario)
echo  [OK] Servicios restaurados.

echo.
echo  ============================================================
echo   REVERT COMPLETADO
echo  ============================================================
echo   El sistema ha vuelto a la configuracion de Windows.
echo   REINICIA el PC para que los cambios de kernel tomen efecto.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Revert Max Power El Nexo..."
exit
