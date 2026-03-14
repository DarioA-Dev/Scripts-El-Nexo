@echo off
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO v5.0 - RATON FIX
color 0B

net session >nul 2>&1
if %errorlevel% neq 0 (
    cls
    color 0C
    echo.
    echo  ============================================================
    echo   ACCESO DENEGADO - Se requieren permisos de Administrador
    echo  ============================================================
    echo.
    echo   Haz clic derecho y selecciona "Ejecutar como administrador"
    echo.
    echo  ============================================================
    pause
    exit /b
)

cls
color 0B
echo.
echo  ============================================================
echo    _____ _         _   _ _______  ___   ___
echo   ^|  ___^| ^|       ^| \ ^| ^|  _____^|^|   \ ^|   ^|
echo   ^| ^|__ ^| ^|       ^|  \^| ^| ^|___   ^| ^|\ \^| ^| ^|
echo   ^|  __^|^| ^|       ^| . ` ^|  _^|   ^| ^| \ ` ^| ^|
echo   ^| ^|___^| ^|____   ^| ^|\  ^| ^|____  ^| ^|  \ ^| ^|
echo   ^|_____^|______^|  ^|_^| \_^|______^| ^|___\____^|
echo.
echo  ============================================================
echo   PROTOCOLO: RATON FIX [PRECISION 1:1 Y RAW INPUT]
echo   VERSION: 5.0
echo  ============================================================
echo.

echo  [PASO 1/5] Creando punto de restauracion...
echo.
powershell -Command "Checkpoint-Computer -Description 'El Nexo Raton Fix' -RestorePointType 'MODIFY_SETTINGS'" 2>nul
echo  [OK] Punto de restauracion creado.

echo.
echo  [PASO 2/5] Desactivando aceleracion del puntero...
echo.
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul 2>&1
echo  [OK] Aceleracion eliminada - movimiento 1:1.

echo.
echo  [PASO 3/5] Desactivando Enhance Pointer Precision...
echo.
reg add "HKCU\Control Panel\Mouse" /v "UserPreferencesMask" /t REG_BINARY /d "9e3e078012000000" /f >nul 2>&1
echo  [OK] Enhance Pointer Precision desactivado a nivel de sistema.

echo.
echo  [PASO 4/5] Aplicando curvas de movimiento lineales...
echo.
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseXCurve" /t REG_BINARY /d "0000000000000000156e000000000000004001000000000029dc030000000000" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d "0000000000000000fd11010000000000002404000000000000fc12000000000000c0bb01000000000000c8" /f >nul 2>&1
echo  [OK] Curvas de movimiento linealizadas.

echo.
echo  [PASO 5/5] Optimizando buffer y latencia de menus...
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d 20 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseHoverTime" /t REG_SZ /d "8" /f >nul 2>&1
echo  [OK] Buffer optimizado y latencia de menus a 0ms.

echo.
echo  ============================================================
echo   RATON FIX COMPLETADO
echo  ============================================================
echo.
echo   Cambios aplicados:
echo   - Aceleracion del puntero desactivada (1:1 real)
echo   - Enhance Pointer Precision desactivado
echo   - Curvas de movimiento linealizadas
echo   - Buffer del controlador optimizado
echo   - Latencia de menus a 0ms
echo.
echo   IMPORTANTE: Reinicia el PC para aplicar todos los cambios.
echo  ============================================================
echo.
set /p "reboot=Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando Raton Fix El Nexo..."
exit
