@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - AHORRO BATERIA [PLAN: FREE]
:: =========================================================================
::  EL NEXO - AHORRO BATERIA [PLAN: FREE]  v5.2
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Guarda tus valores originales antes de cambiarlos. Para deshacerlo:
::  Revertir_cambios_Ahorro_de_bateria_portatil_El_Nexo.bat
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Nexo_Ahorro_Bateria"
call :UI_HEADER "AHORRO BATERIA" "5.2" "PLAN: FREE"
call :UI_REQUIRE_ADMIN || exit /b 1
call :BK_INIT
if errorlevel 1 (
    call :UI_FAIL "No se pudo crear la copia de seguridad. No se ha cambiado nada."
    call :UI_PAUSE
    exit /b 1
)

call :UI_PLAN_BEGIN "QUE VA A HACER ESTE SCRIPT"
call :UI_AUTO "Crear y activar el plan Ahorro Inteligente El Nexo"
call :UI_INFO "Con bateria: CPU maxima 75, sin turbo, pantalla 3 min,"
call :UI_INFO "disco 5 min, suspension 10 min. Enchufado no cambia."
call :UI_AUTO "Activar la hibernacion"
call :UI_AUTO "Quitar transparencias y Aero Peek"
call :UI_AUTO "Bloquear apps de la Store en segundo plano"
call :UI_INFO "(algunas apps de la Store pueden no mostrar notificaciones)"
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
    call :UI_RESTORE_POINT "El Nexo Ahorro Bateria FREE"
) else (
    call :UI_SKIP "Punto de restauracion omitido."
)

call :UI_STEP 1 3 "Creando plan de ahorro inteligente..."
call :BK_PWR
set "NEXO_ECO_GUID=33333333-3333-3333-3333-333333333333"
powercfg -delete %NEXO_ECO_GUID% >nul 2>&1
:: Base: Economizador. Con Modern Standby ese plan no existe y se parte de
:: Equilibrado con los mismos valores.
powercfg -duplicatescheme a1841308-3541-4fab-bc81-f71556f20b4a %NEXO_ECO_GUID% >nul 2>&1
if errorlevel 1 powercfg -duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e %NEXO_ECO_GUID% >nul 2>&1
powercfg /query %NEXO_ECO_GUID% >nul 2>&1
if errorlevel 1 (
    call :UI_FAIL "No se pudo crear el plan de energia."
    goto :AB_EFECTOS
)
powercfg -changename %NEXO_ECO_GUID% "Ahorro Inteligente El Nexo" "Plan El Nexo FREE" >nul 2>&1
:: Valores escritos SOLO en el plan El Nexo, nunca en el plan del usuario
powercfg -setdcvalueindex %NEXO_ECO_GUID% SUB_VIDEO VIDEOIDLE 180 >nul 2>&1 || set "SF=1"
powercfg -setdcvalueindex %NEXO_ECO_GUID% SUB_DISK DISKIDLE 300 >nul 2>&1 || set "SF=1"
powercfg -setdcvalueindex %NEXO_ECO_GUID% SUB_SLEEP STANDBYIDLE 600 >nul 2>&1 || set "SF=1"
powercfg -setdcvalueindex %NEXO_ECO_GUID% SUB_PROCESSOR PROCTHROTTLEMIN 5 >nul 2>&1 || set "SF=1"
powercfg -setdcvalueindex %NEXO_ECO_GUID% SUB_PROCESSOR PROCTHROTTLEMAX 75 >nul 2>&1 || set "SF=1"
powercfg -setdcvalueindex %NEXO_ECO_GUID% SUB_PROCESSOR PERFBOOSTMODE 0 >nul 2>&1
powercfg -setactive %NEXO_ECO_GUID% >nul 2>&1 || set "SF=1"
powercfg -h on >nul 2>&1
call :STEP_END "Plan ECO activado: CPU limitada y sin turbo con bateria." "El plan se activo, pero algun valor no se aplico."

:AB_EFECTOS
call :UI_STEP 2 3 "Reduciendo efectos visuales..."
call :SET_REG "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "EnableTransparency" REG_DWORD 0
call :SET_REG "HKCU\Software\Microsoft\Windows\DWM" "EnableAeroPeek" REG_DWORD 0
call :STEP_END "Transparencias desactivadas." "No se pudo escribir en el registro."

call :UI_STEP 3 3 "Limitando apps de segundo plano..."
call :SET_REG "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled" REG_DWORD 1
call :SET_REG "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" "LetAppsRunInBackground" REG_DWORD 2
call :STEP_END "Apps de fondo bloqueadas." "No se pudo escribir en el registro."

call :UI_FINAL "AHORRO BATERIA FREE - COMPLETADO" "Revertir_cambios_Ahorro_de_bateria_portatil_El_Nexo.bat" 0
call :UI_PRO_BEGIN
call :UI_PRO "Brillo adaptativo activado con bateria" ""
call :UI_PRO "Ahorro maximo del bus PCIe (ASPM) con bateria" ""
call :UI_PRO "Windows Search en inicio manual" "Menos indexacion en segundo plano"
call :UI_PRO_END
start "" powercfg.cpl
call :UI_PAUSE
exit /b 0

:: @@BLOCK ui@@
:: @@BLOCK backup@@
