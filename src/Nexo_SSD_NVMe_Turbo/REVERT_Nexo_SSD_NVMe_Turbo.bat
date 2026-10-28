@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - REVERT SSD NVMe Turbo
:: =========================================================================
::  EL NEXO - REVERT: SSD NVMe TURBO [PLAN: FREE]  v5.2
::  Deshace SOLO lo que cambia Nexo_SSD_NVMe_Turbo.bat: TRIM, ultimo
::  acceso NTFS, nombres 8.3 y apagado del disco del plan activo.
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Nexo_SSD_NVMe_Turbo"
call :UI_HEADER "REVERT: SSD NVMe TURBO" "5.2" "PLAN: FREE"
call :UI_REQUIRE_ADMIN || exit /b 1
call :RS_INIT

call :UI_PLAN_BEGIN "QUE VA A RESTAURAR ESTE REVERT"
call :UI_AUTO "TRIM, ultimo acceso NTFS y nombres cortos 8.3"
call :UI_AUTO "Apagado del disco en el plan de energia"
call :UI_PLAN_END
if defined HAS_BK (
    call :UI_INFO "Origen: tu copia de seguridad en"
    call :UI_INFO "%NEXO_BK%"
) else (
    call :UI_WARN "No hay copia de seguridad: se usan valores de fabrica de Windows,"
    call :UI_INFO "solo en los ajustes que cambia Nexo_SSD_NVMe_Turbo.bat."
)
call :UI_CONFIRM "Restaurar ahora" || exit /b 0

set "FSKEY=HKLM\SYSTEM\CurrentControlSet\Control\FileSystem"
call :UI_STEP 1 2 "TRIM, ultimo acceso y nombres 8.3"
if defined HAS_BK (
    call :RS_GENERIC
) else (
    rem Fabrica: TRIM activo, ultimo acceso gestionado por el sistema
    rem (0x80000002) y 8.3 por volumen (2)
    reg add "%FSKEY%" /v "DisableDeleteNotification" /t REG_DWORD /d 0 /f >nul 2>&1 || set "SF=1"
    reg add "%FSKEY%" /v "NtfsDisableLastAccessUpdate" /t REG_DWORD /d 0x80000002 /f >nul 2>&1 || set "SF=1"
    reg add "%FSKEY%" /v "NtfsDisable8dot3NameCreation" /t REG_DWORD /d 2 /f >nul 2>&1 || set "SF=1"
)
call :STEP_END "Sistema de archivos restaurado." "Algun valor no se pudo restaurar. Revisa el log."

call :UI_STEP 2 2 "Apagado del disco"
set "_done="
if defined HAS_BK (
    for /f "usebackq tokens=1-6 delims=|" %%a in ("%NEXO_BK%\backup.txt") do (
        if /i "%%a"=="PSET" (
            powercfg -setacvalueindex %%d %%b %%c %%e >nul 2>&1 || set "SF=1"
            powercfg -setdcvalueindex %%d %%b %%c %%f >nul 2>&1
            set "_done=%%d"
        )
    )
) else (
    call :DISK_DEFAULT
)
if defined _done (
    call :GET_ACTIVE
    if /i "!_g!"=="!_done!" powercfg -setactive !_g! >nul 2>&1
)
call :STEP_END "Apagado del disco restaurado." "No se pudo restaurar el plan de energia."

call :RS_CLOSE
call :UI_FINAL "REVERT COMPLETADO" "" 1
call :UI_REBOOT
exit /b 0

:GET_ACTIVE
set "_g="
for /f "tokens=2 delims=:(" %%g in ('powercfg /getactivescheme') do set "_g=%%g"
if defined _g for /f "tokens=1" %%g in ("%_g%") do set "_g=%%g"
exit /b 0

:DISK_DEFAULT
:: Sin copia: solo si el disco esta en "nunca" (lo que pone el script) se
:: vuelve a 20 min con corriente y 10 min con bateria.
call :GET_ACTIVE
if not defined _g exit /b 0
set "_prev="
set "_last="
for /f "tokens=2 delims=:" %%v in ('powercfg /q %_g% SUB_DISK DISKIDLE ^| %FIND% "0x"') do (
    set "_prev=!_last!"
    set "_last=%%v"
)
if not defined _prev exit /b 0
set /a _ac=!_prev!
set /a _dc=!_last!
if !_ac! equ 0 powercfg -setacvalueindex %_g% SUB_DISK DISKIDLE 1200 >nul 2>&1
if !_dc! equ 0 powercfg -setdcvalueindex %_g% SUB_DISK DISKIDLE 600 >nul 2>&1
powercfg -setactive %_g% >nul 2>&1
exit /b 0

:: @@BLOCK ui@@
:: @@BLOCK restore@@
