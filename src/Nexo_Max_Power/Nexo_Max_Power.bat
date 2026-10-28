@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - MAX POWER [PLAN: FREE]
:: =========================================================================
::  EL NEXO - MAX POWER [PLAN: FREE]  v5.2
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Guarda tus valores originales antes de cambiarlos. Para deshacerlo:
::  REVERT_Nexo_Max_Power.bat
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Nexo_Max_Power"
call :UI_HEADER "MAX POWER" "5.2" "PLAN: FREE"
call :UI_REQUIRE_ADMIN || exit /b 1
call :BK_INIT
if errorlevel 1 (
    call :UI_FAIL "No se pudo crear la copia de seguridad. No se ha cambiado nada."
    call :UI_PAUSE
    exit /b 1
)

call :IS_LAPTOP
if "%IS_LAPTOP%"=="1" (
    set "NEXO_GUID=22222222-2222-2222-2222-222222222222"
    set "PLAN_NOMBRE=Alto Rendimiento El Nexo"
    set "DEVICE_NAME=portatil"
) else (
    set "NEXO_GUID=11111111-1111-1111-1111-111111111111"
    set "PLAN_NOMBRE=Maximo Rendimiento El Nexo"
    set "DEVICE_NAME=PC de sobremesa"
)
echo.
call :UI_INFO "Dispositivo detectado: %DEVICE_NAME%"

call :UI_PLAN_BEGIN "QUE VA A HACER ESTE SCRIPT"
call :UI_AUTO "Crear y activar el plan de energia %PLAN_NOMBRE%"
call :UI_AUTO "En ese plan: CPU a maxima frecuencia y sin suspension"
if not "%IS_LAPTOP%"=="1" call :UI_AUTO "Desactivar la hibernacion y el Inicio rapido"
call :UI_AUTO "Desactivar telemetria: DiagTrack, WerSvc y RetailDemo"
call :UI_AUTO "Prioridad MMCSS de la tarea Games a High"
call :UI_OPT "Desactivar dmwappushservice (rompe la inscripcion MDM o Intune)"
call :UI_OPT "Crear un punto de restauracion de Windows"
call :UI_PLAN_END
call :UI_INFO "Tus valores originales se guardan en:"
call :UI_INFO "%NEXO_BK%"
echo.
call :UI_ASK OPT_RP "Crear punto de restauracion"
call :UI_ASK OPT_DMW "Desactivar tambien dmwappushservice"
call :UI_CONFIRM "Aplicar los cambios" || exit /b 0

echo.
if "%OPT_RP%"=="S" (
    call :UI_INFO "Creando punto de restauracion..."
    call :UI_RESTORE_POINT "El Nexo Max Power FREE"
) else (
    call :UI_SKIP "Punto de restauracion omitido."
)

call :UI_STEP 1 3 "Plan de energia El Nexo"
call :BK_PWR
powercfg -delete %NEXO_GUID% >nul 2>&1
:: Base: Alto rendimiento. Con Modern Standby ese plan no existe y se parte
:: de Equilibrado con los mismos valores.
powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c %NEXO_GUID% >nul 2>&1
if errorlevel 1 powercfg -duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e %NEXO_GUID% >nul 2>&1
powercfg /query %NEXO_GUID% >nul 2>&1
if errorlevel 1 (
    call :UI_FAIL "No se pudo crear el plan de energia."
    goto :MP_SERVICIOS
)
powercfg -changename %NEXO_GUID% "%PLAN_NOMBRE%" "Plan El Nexo FREE" >nul 2>&1
:: Valores escritos SOLO en el plan El Nexo, nunca en el plan del usuario
powercfg -setacvalueindex %NEXO_GUID% SUB_DISK DISKIDLE 0 >nul 2>&1 || set "SF=1"
powercfg -setacvalueindex %NEXO_GUID% SUB_SLEEP STANDBYIDLE 0 >nul 2>&1 || set "SF=1"
powercfg -setacvalueindex %NEXO_GUID% SUB_PROCESSOR PROCTHROTTLEMIN 100 >nul 2>&1 || set "SF=1"
powercfg -setacvalueindex %NEXO_GUID% SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1 || set "SF=1"
powercfg -setacvalueindex %NEXO_GUID% SUB_PROCESSOR PERFBOOSTMODE 2 >nul 2>&1
powercfg -setacvalueindex %NEXO_GUID% SUB_PCIEXPRESS ASPM 0 >nul 2>&1
powercfg -setacvalueindex %NEXO_GUID% 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
powercfg -setactive %NEXO_GUID% >nul 2>&1 || set "SF=1"
if not "%IS_LAPTOP%"=="1" powercfg -h off >nul 2>&1
call :STEP_END "Plan %PLAN_NOMBRE% activado." "El plan se activo, pero algun valor no se aplico."

:MP_SERVICIOS
call :UI_STEP 2 3 "Servicios de telemetria"
for %%s in (DiagTrack WerSvc RetailDemo) do call :SVC_OFF %%s
if "%OPT_DMW%"=="S" call :SVC_OFF dmwappushservice
call :STEP_END "Telemetria desactivada." "Algun servicio no se pudo desactivar. Revisa el log."
if not "%OPT_DMW%"=="S" call :UI_SKIP "dmwappushservice sin cambios."

call :UI_STEP 3 3 "Prioridad de juegos (MMCSS)"
set "GAMES=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
call :SET_REG "%GAMES%" "Priority" REG_DWORD 6
call :SET_REG "%GAMES%" "Scheduling Category" REG_SZ High
call :STEP_END "Prioridad de juegos configurada." "No se pudo escribir en el registro."

call :UI_FINAL "MAX POWER FREE - COMPLETADO" "REVERT_Nexo_Max_Power.bat" 1
call :UI_PRO_BEGIN
call :UI_PRO "MSI Mode en grafica, red y almacenamiento" "Interrupciones MSI donde el driver lo admite"
call :UI_PRO "Win32PrioritySeparation y DisablePagingExecutive" "Reparto de CPU y memoria del nucleo de Windows"
call :UI_PRO "ULPS desactivado en graficas AMD" "Evita el estado de ahorro profundo de la GPU"
call :UI_PRO "Nucleos de CPU sin aparcar" "CPMINCORES al 100 en el plan de energia"
call :UI_PRO_END
start "" powercfg.cpl
call :UI_REBOOT
exit /b 0

:: @@BLOCK ui@@
:: @@BLOCK backup@@
