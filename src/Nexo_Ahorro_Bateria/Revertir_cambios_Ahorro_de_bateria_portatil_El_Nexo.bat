@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - REVERT Ahorro Bateria
:: =========================================================================
::  EL NEXO - REVERT: AHORRO BATERIA [PLAN: FREE]  v5.2
::  Deshace SOLO lo que cambia Nexo_Ahorro_Bateria.bat: plan Ahorro
::  Inteligente e hibernacion, transparencias, Aero Peek y apps en segundo
::  plano. Ya no ejecuta "powercfg -restoredefaultschemes" (borraba todos
::  los planes del usuario y del fabricante).
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Nexo_Ahorro_Bateria"
call :UI_HEADER "REVERT: AHORRO BATERIA" "5.2" "PLAN: FREE"
call :UI_REQUIRE_ADMIN || exit /b 1
call :RS_INIT

call :UI_PLAN_BEGIN "QUE VA A RESTAURAR ESTE REVERT"
call :UI_AUTO "Plan de energia anterior y borrado del plan El Nexo"
call :UI_AUTO "Hibernacion como estaba"
call :UI_AUTO "Transparencias, Aero Peek y apps en segundo plano"
call :UI_PLAN_END
if defined HAS_BK (
    call :UI_INFO "Origen: tu copia de seguridad en"
    call :UI_INFO "%NEXO_BK%"
) else (
    call :UI_WARN "No hay copia de seguridad: se usan valores de fabrica de Windows,"
    call :UI_INFO "solo en los ajustes que cambia Nexo_Ahorro_Bateria.bat."
)
call :UI_CONFIRM "Restaurar ahora" || exit /b 0

call :UI_STEP 1 2 "Plan de energia e hibernacion"
call :RS_PWR "33333333-3333-3333-3333-333333333333"
call :STEP_END "Plan anterior activado y plan El Nexo eliminado." "No se pudo activar el plan anterior."

call :UI_STEP 2 2 "Efectos visuales y apps de fondo"
if defined HAS_BK (
    call :RS_GENERIC
) else (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 1 /f >nul 2>&1 || set "SF=1"
    reg add "HKCU\Software\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d 1 /f >nul 2>&1 || set "SF=1"
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /f >nul 2>&1
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /f >nul 2>&1
)
call :STEP_END "Efectos y apps de fondo restaurados." "Algun valor no se pudo restaurar. Revisa el log."

call :RS_CLOSE
call :UI_FINAL "REVERT COMPLETADO" "" 0
call :UI_REBOOT
exit /b 0

:: @@BLOCK ui@@
:: @@BLOCK restore@@
