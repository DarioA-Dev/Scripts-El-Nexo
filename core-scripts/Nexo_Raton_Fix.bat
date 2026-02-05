@echo off
title EL NEXO - Raton 1:1 (Raw Input)
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
echo    ESTABILIDAD DE RATON (NO ACEL)
echo ==========================================
echo.

:: PUNTO DE RESTAURACION
echo Creando copia de seguridad de tu config actual...
powershell -Command "Checkpoint-Computer -Description 'Nexo Mouse Fix' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1

:: 1. Desactivar Aceleracion (Enhance Pointer Precision)
echo [1/2] Eliminando aceleracion de Windows...
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul 2>&1

:: 2. Ajustar cola de datos (Estabilidad)
echo [2/2] Ajustando MouseDataQueueSize...
:: Valor decimal 26 (hex 1a) ofrece buen buffer sin lag
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d 26 /f >nul 2>&1

echo.
echo ==========================================
echo    PRECISION 1:1 APLICADA
echo ==========================================
echo Debes REINICIAR para que el raton cambie.
pause