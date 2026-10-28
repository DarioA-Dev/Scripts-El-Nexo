@echo off
:: =========================================================================
::   EL NEXO - REVERT: MAX POWER [PLAN: FREE]  (v5.1)
::   Deshace SOLO lo que cambia Nexo_Max_Power.bat (version FREE):
::     - plan de energia El Nexo e hibernacion
::     - servicios DiagTrack, dmwappushservice, WerSvc, RetailDemo
::     - Tasks\Games: Priority y Scheduling Category
::   Via principal: copia de seguridad en
::     %ProgramData%\ElNexo\Backup\Nexo_Max_Power\backup.txt
::   Sin copia: valores de fabrica de Windows, solo para esos ajustes.
:: =========================================================================
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO - REVERT Max Power
color 0E

fsutil dirty query %systemdrive% >nul 2>&1
if %errorlevel% neq 0 (
    cls & color 0C
    echo  Se requieren permisos de Administrador.
    echo  Haz clic derecho y selecciona "Ejecutar como administrador"
    pause & exit /b
)

set "FIND=%SystemRoot%\System32\find.exe"
set "NEXO_BK=%ProgramData%\ElNexo\Backup\Nexo_Max_Power"
set "BALANCED=381b4222-f694-41f0-9685-ff5bb260df2e"

cls
color 0E
echo.
echo  ============================================================
echo   EL NEXO - REVERT: MAX POWER
echo   Restaurando configuracion original del sistema...
echo  ============================================================
echo.
if exist "%NEXO_BK%\backup.txt" (
    echo  [OK] Copia de seguridad encontrada: se restauran tus valores originales.
) else (
    echo  [!] No hay copia de seguridad de El Nexo.
    echo      Se aplican los valores de fabrica de Windows, solo en los
    echo      ajustes que modifica Nexo_Max_Power.bat.
)
echo.

:: -- PLAN DE ENERGIA E HIBERNACION ----------------------------------------
echo  [1/3] Restaurando plan de energia...
set "ORIG_GUID="
set "ORIG_HIB="
if exist "%NEXO_BK%\backup.txt" (
    for /f "usebackq tokens=1,2,3 delims=|" %%a in ("%NEXO_BK%\backup.txt") do (
        if /i "%%a"=="PWR" if /i "%%b"=="ACTIVE" set "ORIG_GUID=%%c"
        if /i "%%a"=="PWR" if /i "%%b"=="HIBERNATE" set "ORIG_HIB=%%c"
    )
)
set "TARGET=%BALANCED%"
if defined ORIG_GUID (
    if /i not "%ORIG_GUID%"=="11111111-1111-1111-1111-111111111111" if /i not "%ORIG_GUID%"=="22222222-2222-2222-2222-222222222222" (
        powercfg /query %ORIG_GUID% >nul 2>&1 && set "TARGET=%ORIG_GUID%"
    )
)
powercfg -setactive %TARGET% >nul 2>&1
powercfg -delete 11111111-1111-1111-1111-111111111111 >nul 2>&1
powercfg -delete 22222222-2222-2222-2222-222222222222 >nul 2>&1
if defined ORIG_HIB (
    if /i "%ORIG_HIB%"=="0x0" (powercfg -h off >nul 2>&1) else (powercfg -h on >nul 2>&1)
) else if not exist "%NEXO_BK%\backup.txt" (
    rem Sin copia: el script solo apaga la hibernacion en PC de escritorio
    call :IS_DESKTOP
    if "!IS_PC!"=="1" powercfg -h on >nul 2>&1
)
echo  [OK] Plan El Nexo eliminado. Plan anterior activado.

:: -- SERVICIOS Y PRIORIDAD DE JUEGOS --------------------------------------
echo.
echo  [2/3] Restaurando servicios y prioridad de juegos...
if exist "%NEXO_BK%\backup.txt" (
    call :RESTORE_GENERIC
) else (
    call :SVC_DEFAULT DiagTrack auto
    call :SVC_DEFAULT dmwappushservice demand
    call :SVC_DEFAULT WerSvc demand
    call :SVC_DEFAULT RetailDemo demand
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 2 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "Medium" /f >nul 2>&1
)
echo  [OK] Servicios y scheduler restaurados.

:: -- CERRAR COPIA --------------------------------------------------------
echo.
echo  [3/3] Cerrando copia de seguridad...
if exist "%NEXO_BK%\backup.txt" move /y "%NEXO_BK%\backup.txt" "%NEXO_BK%\backup.restaurado.txt" >nul 2>&1
echo  [OK] Listo.

echo.
echo  ============================================================
echo   REVERT COMPLETADO
echo  ============================================================
echo   El sistema ha vuelto a la configuracion anterior.
echo   REINICIA el PC para aplicar todos los cambios.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Revert Max Power El Nexo..."
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
    if /i "%%a"=="SVC" if /i not "%%c"=="ABSENT" (
        sc config "%%b" start= %%c >nul 2>&1
        if /i "%%d"=="RUNNING" sc start "%%b" >nul 2>&1
        echo  [*] Servicio restaurado: %%b ^(%%c^)
    )
)
endlocal
exit /b 0

:SVC_DEFAULT
:: Solo actua si el servicio existe y esta desactivado (lo que hace el script)
sc qc "%~1" >nul 2>&1 || exit /b 0
for /f "tokens=3" %%t in ('sc qc "%~1" ^| %FIND% "START_TYPE"') do if "%%t"=="4" (
    sc config "%~1" start= %~2 >nul 2>&1
    echo  [*] Servicio restaurado: %~1 ^(%~2^)
)
exit /b 0

:IS_DESKTOP
set "IS_PC=1"
set "_bc=0"
for /f %%b in ('powershell -NoProfile -Command "@(Get-CimInstance -ClassName Win32_Battery -ErrorAction SilentlyContinue).Count"') do set "_bc=%%b"
if not "%_bc%"=="0" set "IS_PC=0"
exit /b 0
