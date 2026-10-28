@echo off
:: =========================================================================
::   EL NEXO - RESTAURADOR DE MENU CLASICO v4.1 (blindado)
::   Protocolo: Menu Contextual de Windows 10
::   Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::   Solo cambia una clave de TU usuario (HKCU): no necesita permisos
::   de administrador. Para deshacerlo: Revertir_Menu_W11.bat
:: =========================================================================
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO v4.0 - MENU CLASICO
color 0B
cd /d "%~dp0"

set "FIND=%SystemRoot%\System32\find.exe"
set "NEXO_BK=%ProgramData%\ElNexo\Backup\Menu_Clasico_W11"
set "MENU_KEY=HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"

:: CABECERA CIBERPUNK "EL NEXO"
cls
color 0B
echo.
echo  ============================================================
echo    ______ _       _   _ _______   ______
echo   ^|  ____^|^| ^|     ^| \ ^| ^|^|  ___\ \ / / __ \
echo   ^| ^|__  ^| ^|     ^|  \^| ^|^| ^|__  \ V / ^|  ^| ^|
echo   ^|  __^| ^| ^|     ^| . ` ^|^|  __^|  ^> ^<^| ^|  ^| ^|
echo   ^| ^|____^| ^|____ ^| ^|\  ^|^| ^|____/ . \ ^|__^| ^|
echo   ^|______^|^|______^|^|_^| \_^|^|______/_/\_\____/
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

:: COPIA DE SEGURIDAD (si no se puede crear, el revert usa el valor de fabrica)
call :BK_INIT
if not errorlevel 1 call :BK_KEY "%MENU_KEY%"

:: APPLY REGISTRY PATCH
echo  [PASO 1/2] Aplicando modificacion de registro...
echo.
reg add "%MENU_KEY%\InprocServer32" /f /ve >nul 2>&1
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
echo   Ejecuta Revertir_Menu_W11.bat (incluido en el ZIP)
echo.
echo  ============================================================
echo.
pause
exit

:: =========================================================================
::  RUTINAS INTERNAS - COPIA DE SEGURIDAD EL NEXO
::    KEY|clave|PRESENT/ABSENT  (si la clave ya existia antes del script)
:: =========================================================================
:BK_INIT
if not exist "%NEXO_BK%\" mkdir "%NEXO_BK%" >nul 2>&1
if not exist "%NEXO_BK%\backup.txt" type nul > "%NEXO_BK%\backup.txt" 2>nul
if not exist "%NEXO_BK%\backup.txt" exit /b 1
exit /b 0

:BK_KEY
%FIND% /I "KEY|%~1|" "%NEXO_BK%\backup.txt" >nul 2>&1 && exit /b 0
reg query "%~1" >nul 2>&1
if errorlevel 1 (
    >>"%NEXO_BK%\backup.txt" echo KEY^|%~1^|ABSENT
) else (
    >>"%NEXO_BK%\backup.txt" echo KEY^|%~1^|PRESENT
)
exit /b 0
