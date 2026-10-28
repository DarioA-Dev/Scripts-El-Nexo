@echo off
:: =========================================================================
::   EL NEXO - REVERT: RATON FIX [PLAN: FREE]  (v5.1)
::   Deshace SOLO lo que cambia Nexo_Raton_Fix.bat (version FREE):
::     - MouseSpeed, MouseThreshold1, MouseThreshold2
::     - MenuShowDelay
::   Via principal: copia de seguridad en
::     %ProgramData%\ElNexo\Backup\Nexo_Raton_Fix\backup.txt
::   Sin copia: valores de fabrica de Windows, solo para esos ajustes.
:: =========================================================================
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO - REVERT Raton Fix
color 0E

fsutil dirty query %systemdrive% >nul 2>&1
if %errorlevel% neq 0 (
    cls & color 0C
    echo  Se requieren permisos de Administrador.
    echo  Haz clic derecho y selecciona "Ejecutar como administrador"
    pause & exit /b
)

set "NEXO_BK=%ProgramData%\ElNexo\Backup\Nexo_Raton_Fix"

cls
color 0E
echo.
echo  ============================================================
echo   EL NEXO - REVERT: RATON FIX
echo   Restaurando configuracion original del raton...
echo  ============================================================
echo.
if exist "%NEXO_BK%\backup.txt" (
    echo  [OK] Copia de seguridad encontrada: se restauran tus valores originales.
    echo.
    echo  [1/2] Restaurando aceleracion del puntero y menus...
    call :RESTORE_GENERIC
    move /y "%NEXO_BK%\backup.txt" "%NEXO_BK%\backup.restaurado.txt" >nul 2>&1
) else (
    echo  [!] No hay copia de seguridad de El Nexo.
    echo      Se aplican los valores de fabrica de Windows, solo en los
    echo      ajustes que modifica Nexo_Raton_Fix.bat.
    echo.
    echo  [1/2] Restaurando aceleracion del puntero y menus...
    reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "1" /f >nul 2>&1
    reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "6" /f >nul 2>&1
    reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "10" /f >nul 2>&1
    reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "400" /f >nul 2>&1
)
echo  [OK] Aceleracion de Windows y menus restaurados.

echo.
echo  [2/2] Comprobacion final...
echo  [OK] Listo.

echo.
echo  ============================================================
echo   REVERT COMPLETADO
echo  ============================================================
echo   El raton ha vuelto a la configuracion anterior.
echo   REINICIA el PC (o cierra sesion) para aplicar los cambios.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Revert Raton Fix El Nexo..."
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
