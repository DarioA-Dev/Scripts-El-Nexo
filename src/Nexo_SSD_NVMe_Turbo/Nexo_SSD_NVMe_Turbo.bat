@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - SSD NVMe TURBO [PLAN: FREE]
:: =========================================================================
::  EL NEXO - SSD NVMe TURBO [PLAN: FREE]  v5.2
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Guarda tus valores originales antes de cambiarlos. Para deshacerlo:
::  REVERT_Nexo_SSD_NVMe_Turbo.bat
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Nexo_SSD_NVMe_Turbo"
call :UI_HEADER "SSD NVMe TURBO" "5.2" "PLAN: FREE"
call :UI_REQUIRE_ADMIN || exit /b 1
call :BK_INIT
if errorlevel 1 (
    call :UI_FAIL "No se pudo crear la copia de seguridad. No se ha cambiado nada."
    call :UI_PAUSE
    exit /b 1
)

call :UI_PLAN_BEGIN "QUE VA A HACER ESTE SCRIPT"
call :UI_AUTO "Asegurar que TRIM esta activo (normalmente ya lo esta)"
call :UI_AUTO "No actualizar la fecha de ultimo acceso de los archivos NTFS"
call :UI_AUTO "No crear nombres cortos 8.3 (afecta a instaladores muy viejos)"
call :UI_AUTO "Disco sin apagado automatico en el plan de energia activo"
call :UI_INFO "(solo afecta a discos duros; los NVMe gestionan su energia solos)"
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
    call :UI_RESTORE_POINT "El Nexo SSD Turbo FREE"
) else (
    call :UI_SKIP "Punto de restauracion omitido."
)

set "FSKEY=HKLM\SYSTEM\CurrentControlSet\Control\FileSystem"
call :UI_STEP 1 3 "Activando TRIM..."
call :BK_REG "%FSKEY%" "DisableDeleteNotification"
fsutil behavior set DisableDeleteNotify 0 >nul 2>&1 || set "SF=1"
call :STEP_END "TRIM activado." "No se pudo activar TRIM."

call :UI_STEP 2 3 "Desactivando escrituras innecesarias..."
call :BK_REG "%FSKEY%" "NtfsDisableLastAccessUpdate"
call :BK_REG "%FSKEY%" "NtfsDisable8dot3NameCreation"
fsutil behavior set disablelastaccess 1 >nul 2>&1 || set "SF=1"
fsutil behavior set disable8dot3 1 >nul 2>&1 || set "SF=1"
call :STEP_END "Ultimo acceso y nombres 8.3 desactivados." "Algun ajuste de NTFS no se pudo aplicar."

call :UI_STEP 3 3 "Desactivando la suspension del disco..."
call :BK_PSET SUB_DISK DISKIDLE
powercfg -change -disk-timeout-ac 0 >nul 2>&1 || set "SF=1"
powercfg -change -disk-timeout-dc 0 >nul 2>&1
call :STEP_END "Disco siempre activo." "No se pudo cambiar el plan de energia."

call :UI_FINAL "SSD NVMe TURBO FREE - COMPLETADO" "REVERT_Nexo_SSD_NVMe_Turbo.bat" 1
call :UI_PRO_BEGIN
call :UI_PRO "SysMain (Superfetch) desactivado" "Menos lecturas en segundo plano; util con poca RAM"
call :UI_PRO "Controlador NVMe nativo de Windows (experimental)" "Solo Windows 11 24H2 o posterior; beneficio segun equipo"
call :UI_PRO_END
call :UI_REBOOT
exit /b 0

:: @@BLOCK ui@@
:: @@BLOCK backup@@
