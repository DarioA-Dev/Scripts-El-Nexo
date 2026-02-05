@echo off
title EL NEXO - Revertir Raton (Default)
color 0C

:: 1. ADMIN CHECK
fsutil dirty query %systemdrive% >nul
if %errorlevel% neq 0 (
    echo ERROR: Necesitas permisos de Administrador.
    pause
    exit
)
cd /d "%~dp0"

echo ==========================================
echo    RESTAURANDO RATON (CON ACEL)
echo ==========================================
echo.

:: 1. Reactivar Aceleracion (Default Windows)
echo [1/2] Reactivando aceleracion...
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "6" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "10" /f >nul 2>&1

:: 2. Restaurar Buffer
echo [2/2] Restaurando MouseDataQueueSize...
:: Borramos la clave personalizada para usar la del driver
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /f >nul 2>&1

echo.
echo ==========================================
echo    CONFIGURACION ORIGINAL APLICADA
echo ==========================================
echo Debes REINICIAR el PC.
pause