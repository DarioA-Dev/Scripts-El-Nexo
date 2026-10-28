@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - RATON FIX [PLAN: FREE]
:: =========================================================================
::  EL NEXO - RATON FIX [PLAN: FREE]  v5.2
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Guarda tus valores originales antes de cambiarlos. Para deshacerlo:
::  REVERT_Nexo_Raton_Fix.bat
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Nexo_Raton_Fix"
call :UI_HEADER "RATON FIX" "5.2" "PLAN: FREE"
call :UI_REQUIRE_ADMIN || exit /b 1
call :BK_INIT
if errorlevel 1 (
    call :UI_FAIL "No se pudo crear la copia de seguridad. No se ha cambiado nada."
    call :UI_PAUSE
    exit /b 1
)

call :UI_PLAN_BEGIN "QUE VA A HACER ESTE SCRIPT"
call :UI_AUTO "Quitar la aceleracion del puntero"
call :UI_INFO "(equivale a desmarcar Mejorar la precision del puntero)"
call :UI_AUTO "Menus al instante: MenuShowDelay a 0"
call :UI_INFO "(efecto visual; no cambia la respuesta del raton en juegos)"
call :UI_OPT "Crear un punto de restauracion de Windows"
call :UI_PLAN_END
call :UI_INFO "Tus valores originales se guardan en:"
call :UI_INFO "%NEXO_BK%"
echo.
call :UI_ASK OPT_RP "Crear punto de restauracion"
call :UI_CONFIRM "Aplicar los cambios" || exit /b 0

echo.
if "%OPT_RP%"=="S" (
    call :UI_INFO "Creando punto de restauracion..."
    call :UI_RESTORE_POINT "El Nexo Raton Fix FREE"
) else (
    call :UI_SKIP "Punto de restauracion omitido."
)

call :UI_STEP 1 2 "Desactivando aceleracion del puntero..."
call :SET_REG "HKCU\Control Panel\Mouse" "MouseSpeed" REG_SZ 0
call :SET_REG "HKCU\Control Panel\Mouse" "MouseThreshold1" REG_SZ 0
call :SET_REG "HKCU\Control Panel\Mouse" "MouseThreshold2" REG_SZ 0
call :STEP_END "Aceleracion del puntero desactivada." "No se pudo escribir en el registro."

call :UI_STEP 2 2 "Reduciendo el retardo de los menus..."
call :SET_REG "HKCU\Control Panel\Desktop" "MenuShowDelay" REG_SZ 0
call :STEP_END "MenuShowDelay a 0 ms." "No se pudo escribir en el registro."

call :UI_FINAL "RATON FIX FREE - COMPLETADO" "REVERT_Nexo_Raton_Fix.bat" 1
call :UI_INFO "Los cambios se aplican al cerrar sesion o reiniciar."
call :UI_PRO_END
call :UI_REBOOT
exit /b 0

:: @@BLOCK ui@@
:: @@BLOCK backup@@
