@echo off
:: =========================================================================
::   EL NEXO - REVERT: SSD NVMe TURBO [PLAN: FREE]  (v5.1)
::   Deshace SOLO lo que cambia Nexo_SSD_NVMe_Turbo.bat (version FREE):
::     - TRIM (DisableDeleteNotification)
::     - ultimo acceso NTFS y nombres cortos 8.3
::     - tiempo de apagado del disco en el plan de energia activo
::   Via principal: copia de seguridad en
::     %ProgramData%\ElNexo\Backup\Nexo_SSD_NVMe_Turbo\backup.txt
::   Sin copia: valores de fabrica de Windows, solo para esos ajustes.
:: =========================================================================
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO - REVERT SSD NVMe Turbo
color 0E

fsutil dirty query %systemdrive% >nul 2>&1
if %errorlevel% neq 0 (
    cls & color 0C
    echo  Se requieren permisos de Administrador.
    echo  Haz clic derecho y selecciona "Ejecutar como administrador"
    pause & exit /b
)

set "FIND=%SystemRoot%\System32\find.exe"
set "NEXO_BK=%ProgramData%\ElNexo\Backup\Nexo_SSD_NVMe_Turbo"
set "FSKEY=HKLM\SYSTEM\CurrentControlSet\Control\FileSystem"

cls
color 0E
echo.
echo  ============================================================
echo   EL NEXO - REVERT: SSD NVMe TURBO
echo   Restaurando configuracion original de almacenamiento...
echo  ============================================================
echo.
if exist "%NEXO_BK%\backup.txt" (
    echo  [OK] Copia de seguridad encontrada: se restauran tus valores originales.
) else (
    echo  [!] No hay copia de seguridad de El Nexo.
    echo      Se aplican los valores de fabrica de Windows, solo en los
    echo      ajustes que modifica Nexo_SSD_NVMe_Turbo.bat.
)
echo.

:: -- TRIM, ULTIMO ACCESO Y 8.3 ---------------------------------------------
echo  [1/2] Restaurando TRIM, timestamps y nombres 8.3...
if exist "%NEXO_BK%\backup.txt" (
    call :RESTORE_GENERIC
) else (
    rem Valores de fabrica: TRIM activo, ultimo acceso gestionado por el
    rem sistema (2 = 0x80000002) y 8.3 por volumen (2)
    reg add "%FSKEY%" /v "DisableDeleteNotification" /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "%FSKEY%" /v "NtfsDisableLastAccessUpdate" /t REG_DWORD /d 0x80000002 /f >nul 2>&1
    reg add "%FSKEY%" /v "NtfsDisable8dot3NameCreation" /t REG_DWORD /d 2 /f >nul 2>&1
)
echo  [OK] Sistema de archivos restaurado.

:: -- APAGADO DEL DISCO -----------------------------------------------------
echo.
echo  [2/2] Restaurando apagado del disco en el plan de energia...
set "_done="
if exist "%NEXO_BK%\backup.txt" (
    for /f "usebackq tokens=1-6 delims=|" %%a in ("%NEXO_BK%\backup.txt") do (
        if /i "%%a"=="PSET" (
            powercfg -setacvalueindex %%d %%b %%c %%e >nul 2>&1
            powercfg -setdcvalueindex %%d %%b %%c %%f >nul 2>&1
            set "_done=%%d"
        )
    )
) else (
    rem Sin copia: solo si el disco esta en "nunca" (lo que pone el script)
    rem se vuelve a 20 min con corriente y 10 min con bateria.
    call :DISK_DEFAULT
)
if defined _done (
    for /f "tokens=2 delims=:(" %%g in ('powercfg /getactivescheme') do set "_act=%%g"
    for /f "tokens=1" %%g in ("!_act!") do if /i "%%g"=="!_done!" powercfg -setactive %%g >nul 2>&1
)
echo  [OK] Apagado del disco restaurado.

if exist "%NEXO_BK%\backup.txt" move /y "%NEXO_BK%\backup.txt" "%NEXO_BK%\backup.restaurado.txt" >nul 2>&1

echo.
echo  ============================================================
echo   REVERT COMPLETADO
echo  ============================================================
echo   REINICIA el PC para aplicar los cambios de almacenamiento.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Revert SSD Turbo El Nexo..."
exit

:: =========================================================================
::  RUTINAS INTERNAS
:: =========================================================================
:RESTORE_GENERIC
setlocal DisableDelayedExpansion
for /f "usebackq tokens=1,2,3,4* delims=|" %%a in ("%NEXO_BK%\backup.txt") do (
    if /i "%%a"=="REG" (
        if /i "%%d"=="ABSENT" (
            reg delete "%%b" /v "%%c" /f >nul 2>&1
        ) else (
            reg add "%%b" /v "%%c" /t %%d /d "%%e" /f >nul 2>&1
        )
        echo  [*] Restaurado: %%c
    )
)
endlocal
exit /b 0

:DISK_DEFAULT
set "_g="
for /f "tokens=2 delims=:(" %%g in ('powercfg /getactivescheme') do set "_g=%%g"
if not defined _g exit /b 0
for /f "tokens=1" %%g in ("%_g%") do set "_g=%%g"
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
