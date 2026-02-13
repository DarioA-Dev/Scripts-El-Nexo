@echo off
:: =========================================================================
::   EL NEXO - REVERSION DE OPTIMIZACIONES v4.0
::   Modulo: Restaurar Servicios de Sistema [LIMPIEZA]
:: =========================================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO v4.0 - REVERTIR LIMPIEZA DEL SISTEMA
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
echo   PROTOCOLO: RESTAURACION DE SERVICIOS [LIMPIEZA]
echo   VERSION: 4.0 - Estado: Reactivando servicios...
echo  ============================================================
echo.

:: RESTORE WINDOWS UPDATE
echo  [PASO 1/2] Reactivando servicios de Windows Update...
echo.
sc config wuauserv start=auto >nul 2>&1
sc config bits start=auto >nul 2>&1
sc start wuauserv >nul 2>&1
sc start bits >nul 2>&1
echo  [OK] Windows Update activo.

:: RESTORE SYSTEM SERVICES
echo.
echo  [PASO 2/2] Reactivando servicios del sistema...
echo.
sc config WSearch start=auto >nul 2>&1
sc start WSearch >nul 2>&1
echo  [OK] Busqueda de Windows activa.

:: FINALIZACION
echo.
echo  ============================================================
echo   REVERSION COMPLETADA CON EXITO
echo  ============================================================
echo.
echo   Servicios del sistema restaurados.
echo.
echo   NOTA: Los archivos eliminados no se pueden recuperar.
echo   Solo se han reactivado los servicios de mantenimiento.
echo.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar el sistema ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando para completar la reversion..."

exit
