@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - REVERT Max Power
:: =========================================================================
::  EL NEXO - REVERT: MAX POWER [PLAN: FREE]  v5.2
::  Deshace SOLO lo que cambia Nexo_Max_Power.bat: plan de energia e
::  hibernacion, servicios DiagTrack/WerSvc/RetailDemo/dmwappushservice y
::  la prioridad MMCSS de la tarea Games.
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Nexo_Max_Power"
call :UI_HEADER "REVERT: MAX POWER" "5.2" "PLAN: FREE"
call :UI_REQUIRE_ADMIN || exit /b 1
call :RS_INIT

call :UI_PLAN_BEGIN "QUE VA A RESTAURAR ESTE REVERT"
call :UI_AUTO "Plan de energia anterior y borrado de los planes El Nexo"
call :UI_AUTO "Hibernacion como estaba"
call :UI_AUTO "Servicios DiagTrack, WerSvc, RetailDemo y dmwappushservice"
call :UI_AUTO "Prioridad MMCSS de la tarea Games"
call :UI_PLAN_END
if defined HAS_BK (
    call :UI_INFO "Origen: tu copia de seguridad en"
    call :UI_INFO "%NEXO_BK%"
) else (
    call :UI_WARN "No hay copia de seguridad: se usan valores de fabrica de Windows,"
    call :UI_INFO "solo en los ajustes que cambia Nexo_Max_Power.bat."
)
call :UI_CONFIRM "Restaurar ahora" || exit /b 0

call :UI_STEP 1 2 "Plan de energia e hibernacion"
call :RS_PWR "11111111-1111-1111-1111-111111111111 22222222-2222-2222-2222-222222222222"
if not defined HAS_BK (
    call :IS_LAPTOP
    if "!IS_LAPTOP!"=="0" powercfg -h on >nul 2>&1
)
call :STEP_END "Plan anterior activado y planes El Nexo eliminados." "No se pudo activar el plan anterior."

call :UI_STEP 2 2 "Servicios y prioridad de juegos"
set "GAMES=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
if defined HAS_BK (
    call :RS_GENERIC
) else (
    call :SVC_DEFAULT DiagTrack auto
    call :SVC_DEFAULT WerSvc demand
    call :SVC_DEFAULT RetailDemo demand
    call :SVC_DEFAULT dmwappushservice demand
    reg add "%GAMES%" /v "Priority" /t REG_DWORD /d 2 /f >nul 2>&1 || set "SF=1"
    reg add "%GAMES%" /v "Scheduling Category" /t REG_SZ /d "Medium" /f >nul 2>&1 || set "SF=1"
)
call :STEP_END "Servicios y prioridad restaurados." "Algun ajuste no se pudo restaurar. Revisa el log."

call :RS_CLOSE
call :UI_FINAL "REVERT COMPLETADO" "" 1
call :UI_REBOOT
exit /b 0

:: @@BLOCK ui@@
:: @@BLOCK restore@@
