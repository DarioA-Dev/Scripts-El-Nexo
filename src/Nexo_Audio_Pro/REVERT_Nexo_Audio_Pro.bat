@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - REVERT Audio Pro
:: =========================================================================
::  EL NEXO - REVERT: AUDIO PRO [PLAN: FREE]  v5.2
::  Deshace SOLO lo que cambia Nexo_Audio_Pro.bat: 5 valores de la tarea
::  de audio de MMCSS y SystemResponsiveness. No toca NetworkThrottlingIndex.
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Nexo_Audio_Pro"
call :UI_HEADER "REVERT: AUDIO PRO" "5.2" "PLAN: FREE"
call :UI_REQUIRE_ADMIN || exit /b 1
call :RS_INIT

call :UI_PLAN_BEGIN "QUE VA A RESTAURAR ESTE REVERT"
call :UI_AUTO "Tarea de audio de MMCSS (5 valores)"
call :UI_AUTO "SystemResponsiveness"
call :UI_PLAN_END
if defined HAS_BK (
    call :UI_INFO "Origen: tu copia de seguridad en"
    call :UI_INFO "%NEXO_BK%"
) else (
    call :UI_WARN "No hay copia de seguridad: se usan valores de fabrica de Windows,"
    call :UI_INFO "solo en los ajustes que cambia Nexo_Audio_Pro.bat."
)
call :UI_CONFIRM "Restaurar ahora" || exit /b 0

set "MMKEY=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
call :UI_STEP 1 1 "Scheduler de audio"
if defined HAS_BK (
    call :RS_GENERIC
) else (
    reg add "%MMKEY%\Tasks\Audio" /v "Scheduling Category" /t REG_SZ /d "Medium" /f >nul 2>&1 || set "SF=1"
    reg add "%MMKEY%\Tasks\Audio" /v "SFIO Priority" /t REG_SZ /d "Normal" /f >nul 2>&1 || set "SF=1"
    reg add "%MMKEY%\Tasks\Audio" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1 || set "SF=1"
    reg add "%MMKEY%\Tasks\Audio" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1 || set "SF=1"
    reg delete "%MMKEY%\Tasks\Audio" /v "Latency Sensitive" /f >nul 2>&1
    reg add "%MMKEY%" /v "SystemResponsiveness" /t REG_DWORD /d 20 /f >nul 2>&1 || set "SF=1"
)
call :STEP_END "Configuracion de audio restaurada." "Algun valor no se pudo restaurar. Revisa el log."

call :RS_CLOSE
call :UI_FINAL "REVERT COMPLETADO" "" 1
call :UI_REBOOT
exit /b 0

:: @@BLOCK ui@@
:: @@BLOCK restore@@
