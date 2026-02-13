@echo off
:: =========================================================================
::   EL NEXO - OPTIMIZADOR DE RATON v4.0
::   Protocolo: Precision 1:1 y Raw Input
:: =========================================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO v4.0 - PRECISION DE RATON
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
echo   PROTOCOLO: OPTIMIZACION DE RATON [PRECISION 1:1]
echo   VERSION: 4.0 ENHANCED - Estado: Iniciando secuencia...
echo  ============================================================
echo.

:: PUNTO DE CONTROL
echo  [PASO 1/4] Creando punto de restauracion de seguridad...
echo.
powershell -Command "Checkpoint-Computer -Description 'El Nexo v4.0 Mouse Fix' -RestorePointType 'MODIFY_SETTINGS'" 2>nul

:: DISABLE ACCELERATION
echo.
echo  [PASO 2/4] Desactivando aceleracion de Windows...
echo.
echo  [*] Eliminando "Mejorar precision del puntero"...
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul 2>&1
echo  [OK] Aceleracion eliminada - movimiento 1:1.

:: MOUSE DATA QUEUE
echo.
echo  [PASO 3/4] Optimizando cola de datos del raton...
echo.
echo  [*] Ajustando buffer para mejor estabilidad...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d 20 /f >nul 2>&1
echo  [OK] Buffer optimizado.

:: ADDITIONAL SETTINGS
echo.
echo  [PASO 4/4] Aplicando ajustes adicionales...
echo.
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseHoverTime" /t REG_SZ /d "8" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseXCurve" /t REG_BINARY /d 0000000000000000156e000000000000004001000000000029dc030000000000 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d 0000000000000000fd11010000000000002404000000000000fc12000000000000c0bb01000000000000c8 /f >nul 2>&1
echo  [OK] Configuracion completada.

:: FINALIZACION
echo.
echo  ============================================================
echo   OPTIMIZACION COMPLETADA CON EXITO
echo  ============================================================
echo.
echo   Tu raton ahora tiene:
echo   - Precision 1:1 sin aceleracion
echo   - Respuesta mas directa y predecible
echo   - Mejor control en juegos FPS
echo.
echo   IMPORTANTE: Debes REINICIAR para aplicar los cambios.
echo.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando para aplicar optimizaciones de raton..."

exit
