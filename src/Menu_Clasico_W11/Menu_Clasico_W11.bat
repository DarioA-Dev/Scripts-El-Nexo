@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - MENU CLASICO
:: =========================================================================
::  EL NEXO - MENU CLASICO DE WINDOWS 11  v5.2
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Solo cambia una clave de TU usuario (HKCU): no necesita permisos de
::  administrador. Para deshacerlo: Revertir_Menu_W11.bat
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Menu_Clasico_W11"
call :UI_HEADER "MENU CLASICO W11" "5.2" "Windows 11"
set "MENU_KEY=HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"

call :UI_PLAN_BEGIN "QUE VA A HACER ESTE SCRIPT"
call :UI_AUTO "Mostrar el menu contextual completo, sin Mostrar mas opciones"
call :UI_INFO "(solo para tu usuario; no necesita administrador)"
call :UI_AUTO "Reiniciar el Explorador de Windows para aplicarlo"
call :UI_INFO "(se cerraran las ventanas del Explorador que tengas abiertas)"
call :UI_PLAN_END
call :UI_CONFIRM "Aplicar el cambio" || exit /b 0

call :BK_INIT
if errorlevel 1 (
    call :UI_WARN "Sin copia de seguridad: el revert usara el valor de fabrica."
) else (
    call :BK_KEY "%MENU_KEY%"
)

call :UI_STEP 1 2 "Aplicando modificacion de registro..."
reg add "%MENU_KEY%\InprocServer32" /f /ve >nul 2>&1 || set "SF=1"
call :STEP_END "Parche aplicado correctamente." "No se pudo escribir en el registro."

call :UI_STEP 2 2 "Reiniciando Explorador de Windows..."
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 1 /nobreak >nul
start "" explorer.exe
call :UI_OK "Cambios aplicados. Prueba a hacer clic derecho."

call :UI_FINAL "MENU CLASICO W11 - COMPLETADO" "Revertir_Menu_W11.bat" 0
call :UI_PAUSE
exit /b 0

:: @@BLOCK ui@@
:: @@BLOCK backup@@
