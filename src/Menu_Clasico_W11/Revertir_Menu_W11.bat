@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - REVERTIR MENU CLASICO
:: =========================================================================
::  EL NEXO - REVERT: MENU CLASICO DE WINDOWS 11  v5.2
::  Deshace SOLO lo que cambia Menu_Clasico_W11.bat: la clave CLSID
::  {86ca1aa0-...} de tu usuario. Si esa clave ya existia antes de usar
::  el script (segun la copia de seguridad), no se borra.
::  No necesita permisos de administrador.
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Menu_Clasico_W11"
call :UI_HEADER "REVERT: MENU CLASICO W11" "5.2" "Windows 11"
call :RS_INIT
set "MENU_KEY=HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"

call :UI_PLAN_BEGIN "QUE VA A RESTAURAR ESTE REVERT"
call :UI_AUTO "Menu contextual de Windows 11 (con Mostrar mas opciones)"
call :UI_AUTO "Reiniciar el Explorador de Windows para aplicarlo"
call :UI_PLAN_END
call :UI_CONFIRM "Restaurar ahora" || exit /b 0

call :UI_STEP 1 2 "Eliminando modificacion del registro..."
set "WAS_PRESENT="
if defined HAS_BK (
    %FIND% /I "KEY|%MENU_KEY%|PRESENT" "%NEXO_BK%\backup.txt" >nul 2>&1 && set "WAS_PRESENT=1"
)
if defined WAS_PRESENT (
    call :UI_SKIP "La clave ya existia antes de usar El Nexo: se conserva."
) else (
    reg query "%MENU_KEY%" >nul 2>&1 && (reg delete "%MENU_KEY%" /f >nul 2>&1 || set "SF=1")
    call :STEP_END "Clave de registro eliminada." "No se pudo eliminar la clave."
)

call :UI_STEP 2 2 "Reiniciando Explorador de Windows..."
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 1 /nobreak >nul
start "" explorer.exe
call :UI_OK "Menu de Windows 11 restaurado."

call :RS_CLOSE
call :UI_FINAL "REVERT COMPLETADO" "" 0
call :UI_PAUSE
exit /b 0

:: @@BLOCK ui@@
:: @@BLOCK restore@@
