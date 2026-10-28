@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - MPO FIX [PLAN: FREE]
:: =========================================================================
::  EL NEXO - MPO FIX [PLAN: FREE]  v5.2
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Opcion [1] guarda el valor original de OverlayTestMode y lo cambia.
::  Opcion [2] restaura exactamente ese valor (o lo borra, como trae
::  Windows de serie).
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "MPO_Fix"
call :UI_HEADER "MPO FIX" "5.2" "PLAN: FREE"
call :UI_REQUIRE_ADMIN || exit /b 1
set "DWM_KEY=HKLM\SOFTWARE\Microsoft\Windows\Dwm"

echo.
call :UI_INFO "[1] Desactivar MPO  (aplica el fix)"
call :UI_INFO "[2] Revertir MPO    (restaura tu valor anterior)"
set "accion="
set /p "accion= %C_ACC%[?]%C_RST% Elige una opcion [1/2]: "
call :UI_LOG "[?] Opcion = !accion!"
if "!accion!"=="2" goto :REVERTIR
if not "!accion!"=="1" (
    call :UI_WARN "Opcion no valida. No se ha cambiado nada."
    call :UI_PAUSE
    exit /b 0
)

call :UI_PLAN_BEGIN "QUE VA A HACER ESTE SCRIPT"
call :UI_AUTO "Desactivar Multiplane Overlay: OverlayTestMode = 5"
call :UI_INFO "Util si tienes parpadeos, pantallazos negros con Alt+Tab o"
call :UI_INFO "tirones con overlays. Sin esos sintomas no merece la pena: en"
call :UI_INFO "juegos en ventana sin bordes puede anadir algo de latencia."
call :UI_INFO "En algunas versiones de Windows 11 24H2 puede no tener efecto."
call :UI_OPT "Crear un punto de restauracion de Windows"
call :UI_PLAN_END
echo.
call :UI_ASK OPT_RP "Crear punto de restauracion"
call :UI_CONFIRM "Aplicar el MPO Fix" || exit /b 0

call :BK_INIT
if errorlevel 1 (
    call :UI_FAIL "No se pudo crear la copia de seguridad. No se ha cambiado nada."
    call :UI_PAUSE
    exit /b 1
)
echo.
if "%OPT_RP%"=="S" (
    call :UI_INFO "Creando punto de restauracion..."
    call :UI_RESTORE_POINT "El Nexo MPO Fix FREE"
) else (
    call :UI_SKIP "Punto de restauracion omitido."
)

call :UI_STEP 1 2 "Desactivando Multiplane Overlay..."
call :SET_REG "%DWM_KEY%" "OverlayTestMode" REG_DWORD 5
call :STEP_END "MPO desactivado correctamente." "Error al escribir en el registro."

call :UI_STEP 2 2 "Verificando cambio aplicado..."
set "MPO_VAL="
for /f "tokens=3" %%v in ('reg query "%DWM_KEY%" /v OverlayTestMode 2^>nul') do set "MPO_VAL=%%v"
if "%MPO_VAL%"=="0x5" (
    call :UI_OK "Verificacion correcta. Valor OverlayTestMode = 5."
) else (
    call :UI_FAIL "No se pudo verificar el valor."
)

call :UI_FINAL "MPO FIX FREE - COMPLETADO" "Nexo_MPO_Fix.bat, opcion 2" 1
call :UI_REBOOT
exit /b 0

:REVERTIR
set "NEXO_BK=%ProgramData%\ElNexo\Backup\%UI_ID%"
call :UI_PLAN_BEGIN "QUE VA A RESTAURAR"
call :UI_AUTO "OverlayTestMode al valor que tenias antes del fix"
call :UI_INFO "(si no existia, se elimina, que es lo que trae Windows)"
call :UI_INFO "Puede volver a causar pantallazos con Alt+Tab."
call :UI_PLAN_END
call :UI_CONFIRM "Revertir el MPO Fix" || exit /b 0

call :UI_STEP 1 1 "Restaurando OverlayTestMode..."
set "ORIG_T="
set "ORIG_D="
if exist "%NEXO_BK%\backup.txt" (
    for /f "usebackq tokens=1,2,3,4* delims=|" %%a in ("%NEXO_BK%\backup.txt") do (
        if /i "%%a"=="REG" if /i "%%c"=="OverlayTestMode" (
            set "ORIG_T=%%d"
            set "ORIG_D=%%e"
        )
    )
)
if defined ORIG_T if /i not "%ORIG_T%"=="ABSENT" (
    reg add "%DWM_KEY%" /v "OverlayTestMode" /t %ORIG_T% /d "%ORIG_D%" /f >nul 2>&1 || set "SF=1"
    call :STEP_END "OverlayTestMode restaurado a tu valor anterior." "No se pudo restaurar el valor."
    goto :REVERTIDO
)
reg query "%DWM_KEY%" /v OverlayTestMode >nul 2>&1
if errorlevel 1 (
    call :UI_SKIP "El MPO Fix no estaba aplicado: no hay nada que revertir."
    goto :REVERTIDO
)
reg delete "%DWM_KEY%" /v "OverlayTestMode" /f >nul 2>&1 || set "SF=1"
call :STEP_END "MPO restaurado a configuracion por defecto de Windows." "Error al eliminar el valor."

:REVERTIDO
if exist "%NEXO_BK%\backup.txt" move /y "%NEXO_BK%\backup.txt" "%NEXO_BK%\backup.restaurado.txt" >nul 2>&1
call :UI_FINAL "MPO FIX - REVERT COMPLETADO" "" 1
call :UI_REBOOT
exit /b 0

:: @@BLOCK ui@@
:: @@BLOCK backup@@
