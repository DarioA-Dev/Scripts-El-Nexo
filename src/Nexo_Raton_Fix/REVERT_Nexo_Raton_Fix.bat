@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - REVERT Raton Fix
:: =========================================================================
::  EL NEXO - REVERT: RATON FIX [PLAN: FREE]  v5.2
::  Deshace SOLO lo que cambia Nexo_Raton_Fix.bat: MouseSpeed,
::  MouseThreshold1, MouseThreshold2 y MenuShowDelay.
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Nexo_Raton_Fix"
call :UI_HEADER "REVERT: RATON FIX" "5.2" "PLAN: FREE"
call :UI_REQUIRE_ADMIN || exit /b 1
call :RS_INIT

call :UI_PLAN_BEGIN "QUE VA A RESTAURAR ESTE REVERT"
call :UI_AUTO "Aceleracion del puntero"
call :UI_AUTO "Retardo de los menus (MenuShowDelay)"
call :UI_PLAN_END
if defined HAS_BK (
    call :UI_INFO "Origen: tu copia de seguridad en"
    call :UI_INFO "%NEXO_BK%"
) else (
    call :UI_WARN "No hay copia de seguridad: se usan valores de fabrica de Windows,"
    call :UI_INFO "solo en los ajustes que cambia Nexo_Raton_Fix.bat."
)
call :UI_CONFIRM "Restaurar ahora" || exit /b 0

call :UI_STEP 1 1 "Aceleracion del puntero y menus"
if defined HAS_BK (
    call :RS_GENERIC
) else (
    reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "1" /f >nul 2>&1 || set "SF=1"
    reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "6" /f >nul 2>&1 || set "SF=1"
    reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "10" /f >nul 2>&1 || set "SF=1"
    reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "400" /f >nul 2>&1 || set "SF=1"
)
call :STEP_END "Raton y menus restaurados." "Algun valor no se pudo restaurar. Revisa el log."

call :RS_CLOSE
call :UI_FINAL "REVERT COMPLETADO" "" 1
call :UI_INFO "Los cambios se aplican al cerrar sesion o reiniciar."
call :UI_REBOOT
exit /b 0

:: @@BLOCK ui@@
:: @@BLOCK restore@@
