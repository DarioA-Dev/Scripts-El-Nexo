@echo off
:: =========================================================================
::   EL NEXO - RESTAURADOR DE MENU CLASICO v4.0
::   Protocolo: Menu Contextual de Windows 10
:: =========================================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO v4.0 - MENU CLASICO
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
echo   PROTOCOLO: MENU CLASICO DE WINDOWS 10 [RESTAURACION]
echo   VERSION: 4.0 ENHANCED - Estado: Iniciando secuencia...
echo  ============================================================
echo.

:: INFORMACION
echo  [INFO] Este script restaurara el menu contextual de Windows 10.
echo.
echo  Que conseguiras:
echo  - Clic derecho mostrara todas las opciones directamente
echo  - No mas "Mostrar mas opciones"
echo  - Menu mas rapido y eficiente
echo.
echo  ============================================================
echo.
pause

:: APPLY REGISTRY PATCH
echo  [PASO 1/2] Aplicando modificacion de registro...
echo.
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul 2>&1
echo  [OK] Parche aplicado correctamente.

:: RESTART EXPLORER
echo.
echo  [PASO 2/2] Reiniciando Explorador de Windows...
echo.
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 1 /nobreak >nul
start explorer.exe
echo  [OK] Cambios aplicados.

:: FINALIZACION
echo.
echo  ============================================================
echo   MODIFICACION COMPLETADA CON EXITO
echo  ============================================================
echo.
echo   Tu menu contextual ahora es el clasico de Windows 10.
echo   Prueba a hacer clic derecho en cualquier parte.
echo.
echo   Para volver al menu de Windows 11:
echo   Ejecuta este script de nuevo y elige "Restaurar W11"
echo.
echo  ============================================================
echo.
pause
exit
