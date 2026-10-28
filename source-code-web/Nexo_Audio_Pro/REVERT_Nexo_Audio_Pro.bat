@echo off
:: =========================================================================
::   EL NEXO - REVERT: AUDIO PRO [PLAN: FREE]  (v5.1)
::   Deshace SOLO lo que cambia Nexo_Audio_Pro.bat (version FREE):
::     - Tasks\Audio: Scheduling Category, SFIO Priority, GPU Priority,
::       Priority, Latency Sensitive
::     - SystemProfile: NetworkThrottlingIndex, SystemResponsiveness
::   Via principal: copia de seguridad en
::     %ProgramData%\ElNexo\Backup\Nexo_Audio_Pro\backup.txt
::   Sin copia: valores de fabrica de Windows, solo para esos ajustes.
:: =========================================================================
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO - REVERT Audio Pro
color 0E

fsutil dirty query %systemdrive% >nul 2>&1
if %errorlevel% neq 0 (
    cls & color 0C
    echo  Se requieren permisos de Administrador.
    echo  Haz clic derecho y selecciona "Ejecutar como administrador"
    pause & exit /b
)

set "NEXO_BK=%ProgramData%\ElNexo\Backup\Nexo_Audio_Pro"
set "MMKEY=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"

cls
color 0E
echo.
echo  ============================================================
echo   EL NEXO - REVERT: AUDIO PRO
echo   Restaurando configuracion original de audio...
echo  ============================================================
echo.
if exist "%NEXO_BK%\backup.txt" (
    echo  [OK] Copia de seguridad encontrada: se restauran tus valores originales.
    echo.
    echo  [1/2] Restaurando scheduler de audio y throttling de red...
    call :RESTORE_GENERIC
    move /y "%NEXO_BK%\backup.txt" "%NEXO_BK%\backup.restaurado.txt" >nul 2>&1
) else (
    echo  [!] No hay copia de seguridad de El Nexo.
    echo      Se aplican los valores de fabrica de Windows, solo en los
    echo      ajustes que modifica Nexo_Audio_Pro.bat.
    echo.
    echo  [1/2] Restaurando scheduler de audio y throttling de red...
    reg add "%MMKEY%\Tasks\Audio" /v "Scheduling Category" /t REG_SZ /d "Medium" /f >nul 2>&1
    reg add "%MMKEY%\Tasks\Audio" /v "SFIO Priority" /t REG_SZ /d "Normal" /f >nul 2>&1
    reg add "%MMKEY%\Tasks\Audio" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
    reg add "%MMKEY%\Tasks\Audio" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
    reg delete "%MMKEY%\Tasks\Audio" /v "Latency Sensitive" /f >nul 2>&1
    reg add "%MMKEY%" /v "NetworkThrottlingIndex" /t REG_DWORD /d 10 /f >nul 2>&1
    reg add "%MMKEY%" /v "SystemResponsiveness" /t REG_DWORD /d 20 /f >nul 2>&1
)
echo  [OK] Configuracion de audio restaurada.

echo.
echo  [2/2] Comprobacion final...
echo  [OK] Listo.

echo.
echo  ============================================================
echo   REVERT COMPLETADO
echo  ============================================================
echo.
echo   Reinicia para aplicar los cambios de audio.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Revert Audio Pro El Nexo..."
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
