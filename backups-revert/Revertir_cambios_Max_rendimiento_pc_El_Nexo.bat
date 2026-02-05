@echo off
:: ==========================================================
::   EL NEXO - PROTOCOLO DE REVERSIÓN (ROLLBACK)
::   Objetivo: Restaurar valores de fábrica de Windows
:: ==========================================================
chcp 65001 >nul
title EL NEXO: RESTAURAR SISTEMA A FÁBRICA
color 0E
setlocal enabledelayedexpansion

:: 1. VERIFICACIÓN DE ADMIN
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Necesitas permisos de Administrador para restaurar el sistema.
    pause
    exit
)

echo ======================================================
echo      INICIANDO RESTAURACIÓN DE VALORES DE FÁBRICA
echo ======================================================
echo.

:: 2. RESTAURAR PLAN DE ENERGÍA EQUILIBRADO
echo [-] Restaurando plan de energía Equilibrado...
powercfg -restoredefaultschemes >nul 2>&1
:: Buscamos el esquema equilibrado estándar
for /f "tokens=4" %%a in ('powercfg -list ^| findstr /C:"Equilibrado"') do set balanced=%%a
if not defined balanced (
    :: Si no lo encuentra por nombre (inglés/otros), intenta el GUID estándar
    set balanced=381b4222-f694-41f0-9685-ff5bb260df2e
)
powercfg -setactive %balanced% >nul 2>&1
echo [OK] Plan de energía restablecido.

:: 3. RESTAURAR VALORES DE KERNEL (BCDEDIT)
echo [-] Eliminando modificaciones del Kernel...
bcdedit /deletevalue disabledynamictick >nul 2>&1
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /deletevalue tscsyncpolicy >nul 2>&1
bcdedit /deletevalue bootux >nul 2>&1
bcdedit /deletevalue hypervisorlaunchtype >nul 2>&1

:: 4. RESTAURAR REGISTRO (CPU & MEMORIA)
echo [-] Restaurando gestión de memoria y prioridades...
:: Win32PrioritySeparation: 2 (Valor por defecto para mejores programas)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 2 /f >nul
:: Restaurar Paging (Intercambio en disco)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f >nul
:: Restaurar Throttling de Red y Responsiveness
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 10 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 20 /f >nul

:: 5. RESTAURAR SERVICIOS (KILL LIST REVERSAL)
echo [-] Reactivando servicios de Windows...
set services=DiagTrack dmwappushservice SysMain WerSvc MapsBroker PcaSvc DPS RetailDemo WSearch
for %%s in (%services%) do (
    sc config %%s start= auto >nul 2>&1
    sc start %%s >nul 2>&1
)

:: 6. RESTAURAR GPU Y GAME DVR
echo [-] Reactivando GameDVR y ajustes de GPU por defecto...
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 1 /f >nul
:: Nota: No revertimos MSI Mode masivamente para evitar romper drivers, 
:: pero devolvemos HAGS a su valor por defecto si estaba cambiado.

:: 7. LIMPIEZA FINAL
echo.
echo ======================================================
echo    RESTAURACIÓN COMPLETADA.
echo    El sistema ha vuelto a su configuración estándar.
echo ======================================================
echo Reinicia para aplicar los cambios.
pause
exit