@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - GAMING MODE [PLAN: FREE]
:: =========================================================================
::  EL NEXO - GAMING MODE [PLAN: FREE]  v5.2
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Guarda tus valores originales antes de cambiarlos. Para deshacerlo:
::  REVERT_Nexo_Gaming_Mode.bat
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Nexo_Gaming_Mode"
call :UI_HEADER "GAMING MODE" "5.2" "PLAN: FREE"
call :UI_REQUIRE_ADMIN || exit /b 1
call :BK_INIT
if errorlevel 1 (
    call :UI_FAIL "No se pudo crear la copia de seguridad. No se ha cambiado nada."
    call :UI_PAUSE
    exit /b 1
)

call :UI_PLAN_BEGIN "QUE VA A HACER ESTE SCRIPT"
call :UI_AUTO "Desactivar la grabacion de Xbox Game Bar (Game DVR)"
call :UI_AUTO "Desactivar telemetria: DiagTrack, WerSvc y RetailDemo"
call :UI_AUTO "Desactivar 3 tareas de telemetria y diagnostico de disco"
call :UI_AUTO "Bloquear apps de la Store en segundo plano"
call :UI_INFO "(algunas apps de la Store pueden no mostrar notificaciones)"
call :UI_OPT "Desactivar servicios Xbox: rompe Xbox Live, Game Pass y mandos"
call :UI_OPT "Desactivar dmwappushservice (rompe la inscripcion MDM o Intune)"
call :UI_OPT "Crear un punto de restauracion de Windows"
call :UI_PLAN_END
call :UI_INFO "Tus valores originales se guardan en:"
call :UI_INFO "%NEXO_BK%"
echo.
call :UI_ASK OPT_RP "Crear punto de restauracion"
call :UI_ASK OPT_XBOX "Desactivar los servicios de Xbox"
call :UI_ASK OPT_DMW "Desactivar tambien dmwappushservice"
call :UI_CONFIRM "Aplicar los cambios" || exit /b 0

echo.
if "%OPT_RP%"=="S" (
    call :UI_INFO "Creando punto de restauracion..."
    call :UI_RESTORE_POINT "El Nexo Gaming Mode FREE"
) else (
    call :UI_SKIP "Punto de restauracion omitido."
)

call :UI_STEP 1 4 "Desactivando Xbox Game Bar y DVR..."
call :SET_REG "HKCU\System\GameConfigStore" "GameDVR_Enabled" REG_DWORD 0
call :SET_REG "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowgameDVR" REG_DWORD 0
call :SET_REG "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" "AppCaptureEnabled" REG_DWORD 0
call :STEP_END "Xbox Game Bar y DVR desactivados." "No se pudo escribir en el registro."

call :UI_STEP 2 4 "Desactivando servicios de Xbox..."
if "%OPT_XBOX%"=="S" (
    for %%s in (XblAuthManager XblGameSave XboxGipSvc XboxNetApiSvc GamingServices GamingServicesNet) do call :SVC_OFF %%s
    call :STEP_END "Servicios Xbox desactivados." "Algun servicio Xbox no se pudo desactivar. Revisa el log."
) else (
    call :UI_SKIP "Servicios Xbox sin cambios."
)

call :UI_STEP 3 4 "Desactivando telemetria..."
for %%s in (DiagTrack WerSvc RetailDemo) do call :SVC_OFF %%s
if "%OPT_DMW%"=="S" call :SVC_OFF dmwappushservice
call :STEP_END "Telemetria desactivada." "Algun servicio no se pudo desactivar. Revisa el log."
if not "%OPT_DMW%"=="S" call :UI_SKIP "dmwappushservice sin cambios."

call :UI_STEP 4 4 "Desactivando tareas y apps de fondo..."
call :TASK_OFF "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
call :TASK_OFF "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
call :TASK_OFF "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
call :SET_REG "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" "LetAppsRunInBackground" REG_DWORD 2
call :SET_REG "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled" REG_DWORD 1
call :STEP_END "Apps de fondo bloqueadas." "Alguna tarea o valor no se pudo cambiar. Revisa el log."

call :UI_FINAL "GAMING MODE FREE - COMPLETADO" "REVERT_Nexo_Gaming_Mode.bat" 1
call :UI_PRO_BEGIN
call :UI_PRO "Overlays de NVIDIA y Steam desactivados" "Instant Replay de NVIDIA y overlay de Steam"
call :UI_PRO "Programacion de GPU acelerada por hardware (HAGS)" "Activada en graficas compatibles"
call :UI_PRO "Nahimic y Sonic Studio desactivados" "Causa conocida de chasquidos de audio en algunas placas"
call :UI_PRO "SystemResponsiveness a 0" "Menos CPU reservada a tareas de fondo"
call :UI_PRO_END
call :UI_REBOOT
exit /b 0

:: @@BLOCK ui@@
:: @@BLOCK backup@@
