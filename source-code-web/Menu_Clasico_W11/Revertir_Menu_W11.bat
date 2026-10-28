@echo off
:: =========================================================================
::   EL NEXO - REVERSION DE OPTIMIZACIONES v4.1
::   Modulo: Restaurar Menu de Windows 11
::   Deshace SOLO lo que cambia Menu_Clasico_W11.bat: la clave
::   HKCU\Software\Classes\CLSID\{86ca1aa0-...}. Si esa clave ya existia
::   antes de usar el script (segun la copia de seguridad), no se borra.
::   No necesita permisos de administrador.
:: =========================================================================
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO v4.0 - REVERTIR MENU CLASICO
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
echo   PROTOCOLO: RESTAURAR MENU WINDOWS 11
echo   VERSION: 4.0 - Estado: Aplicando cambios...
echo  ============================================================
echo.

:: RESTORE MENU
echo  [PASO 1/2] Eliminando modificacion del registro...
echo.
set "WAS_PRESENT="
if exist "%NEXO_BK%\backup.txt" (
    %FIND% /I "KEY|%MENU_KEY%|PRESENT" "%NEXO_BK%\backup.txt" >nul 2>&1 && set "WAS_PRESENT=1"
)
if defined WAS_PRESENT (
    echo  [!] La clave ya existia antes de usar El Nexo: se conserva.
) else (
    reg delete "%MENU_KEY%" /f >nul 2>&1
    echo  [OK] Clave de registro eliminada.
)
if exist "%NEXO_BK%\backup.txt" move /y "%NEXO_BK%\backup.txt" "%NEXO_BK%\backup.restaurado.txt" >nul 2>&1

:: RESTART EXPLORER
echo.
echo  [PASO 2/2] Reiniciando Explorador de Windows...
echo.
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 1 /nobreak >nul
start explorer.exe
echo  [OK] Menu de Windows 11 restaurado.

:: FINALIZACION
echo.
echo  ============================================================
echo   REVERSION COMPLETADA CON EXITO
echo  ============================================================
echo.
echo   El menu contextual de Windows 11 ha sido restaurado.
echo   Prueba a hacer clic derecho en cualquier parte.
echo.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar el sistema ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando para completar la reversion..."

exit
