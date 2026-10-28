@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - REVERT Gaming Mode
:: =========================================================================
::  EL NEXO - REVERT: GAMING MODE [PLAN: FREE]  v5.2
::  Deshace SOLO lo que cambia Nexo_Gaming_Mode.bat: Game Bar/DVR,
::  servicios Xbox y de telemetria, 3 tareas programadas y las apps en
::  segundo plano.
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Nexo_Gaming_Mode"
call :UI_HEADER "REVERT: GAMING MODE" "5.2" "PLAN: FREE"
call :UI_REQUIRE_ADMIN || exit /b 1
call :RS_INIT

call :UI_PLAN_BEGIN "QUE VA A RESTAURAR ESTE REVERT"
call :UI_AUTO "Xbox Game Bar y grabacion (Game DVR)"
call :UI_AUTO "Servicios Xbox y de telemetria desactivados por el script"
call :UI_AUTO "3 tareas programadas de telemetria y diagnostico"
call :UI_AUTO "Apps de la Store en segundo plano"
call :UI_PLAN_END
if defined HAS_BK (
    call :UI_INFO "Origen: tu copia de seguridad en"
    call :UI_INFO "%NEXO_BK%"
) else (
    call :UI_WARN "No hay copia de seguridad: se usan valores de fabrica de Windows,"
    call :UI_INFO "solo en los ajustes que cambia Nexo_Gaming_Mode.bat."
)
call :UI_CONFIRM "Restaurar ahora" || exit /b 0

call :UI_STEP 1 1 "Game Bar, servicios, tareas y apps de fondo"
if defined HAS_BK (
    call :RS_GENERIC
) else (
    reg delete "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /f >nul 2>&1
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowgameDVR" /f >nul 2>&1
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /f >nul 2>&1
    for %%s in (XblAuthManager XblGameSave XboxGipSvc XboxNetApiSvc WerSvc RetailDemo dmwappushservice) do call :SVC_DEFAULT %%s demand
    for %%s in (GamingServices GamingServicesNet DiagTrack) do call :SVC_DEFAULT %%s auto
    schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Enable >nul 2>&1
    schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Enable >nul 2>&1
    schtasks /Change /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Enable >nul 2>&1
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /f >nul 2>&1
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /f >nul 2>&1
)
call :STEP_END "Configuracion restaurada." "Algun ajuste no se pudo restaurar. Revisa el log."

call :RS_CLOSE
call :UI_FINAL "REVERT COMPLETADO" "" 1
call :UI_REBOOT
exit /b 0

:: @@BLOCK ui@@
:: @@BLOCK restore@@
