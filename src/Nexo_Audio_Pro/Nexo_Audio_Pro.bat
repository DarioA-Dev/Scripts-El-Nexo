@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - AUDIO PRO [PLAN: FREE]
:: =========================================================================
::  EL NEXO - AUDIO PRO [PLAN: FREE]  v5.2
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Guarda tus valores originales antes de cambiarlos. Para deshacerlo:
::  REVERT_Nexo_Audio_Pro.bat
::  v5.2: ya NO toca NetworkThrottlingIndex (desactivarlo quita una
::  proteccion que Windows usa precisamente para el audio).
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Nexo_Audio_Pro"
call :UI_HEADER "AUDIO PRO" "5.2" "PLAN: FREE"
call :UI_REQUIRE_ADMIN || exit /b 1
call :BK_INIT
if errorlevel 1 (
    call :UI_FAIL "No se pudo crear la copia de seguridad. No se ha cambiado nada."
    call :UI_PAUSE
    exit /b 1
)

call :UI_PLAN_BEGIN "QUE VA A HACER ESTE SCRIPT"
call :UI_AUTO "Tarea de audio de MMCSS en categoria High y E/S High"
call :UI_AUTO "Audio marcado como sensible a la latencia"
call :UI_AUTO "SystemResponsiveness a 0: menos CPU reservada a tareas de fondo"
call :UI_INFO "(efecto pequeno; ayuda sobre todo con la CPU muy cargada)"
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
    call :UI_RESTORE_POINT "El Nexo Audio Pro FREE"
) else (
    call :UI_SKIP "Punto de restauracion omitido."
)

set "MMKEY=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
call :UI_STEP 1 2 "Elevando prioridad del scheduler de audio..."
call :SET_REG "%MMKEY%\Tasks\Audio" "Scheduling Category" REG_SZ High
call :SET_REG "%MMKEY%\Tasks\Audio" "SFIO Priority" REG_SZ High
call :SET_REG "%MMKEY%\Tasks\Audio" "GPU Priority" REG_DWORD 1
call :SET_REG "%MMKEY%\Tasks\Audio" "Priority" REG_DWORD 2
call :SET_REG "%MMKEY%\Tasks\Audio" "Latency Sensitive" REG_SZ True
call :STEP_END "Prioridad de audio elevada en MMCSS." "No se pudo escribir en el registro."

call :UI_STEP 2 2 "Reduciendo la CPU reservada a tareas de fondo..."
call :SET_REG "%MMKEY%" "SystemResponsiveness" REG_DWORD 0
call :STEP_END "SystemResponsiveness a 0." "No se pudo escribir en el registro."

call :UI_FINAL "AUDIO PRO FREE - COMPLETADO" "REVERT_Nexo_Audio_Pro.bat" 1
call :UI_PRO_BEGIN
call :UI_PRO "Nahimic, Sonic Studio y DTS desactivados" "Causa conocida de chasquidos y picos DPC en algunas placas"
call :UI_PRO "MSI Mode en el controlador de audio HD" "Interrupciones MSI si el driver lo admite"
call :UI_PRO "Prioridad MMCSS para Pro Audio" "Para programas de produccion musical"
call :UI_PRO_END
call :UI_REBOOT
exit /b 0

:: @@BLOCK ui@@
:: @@BLOCK backup@@
