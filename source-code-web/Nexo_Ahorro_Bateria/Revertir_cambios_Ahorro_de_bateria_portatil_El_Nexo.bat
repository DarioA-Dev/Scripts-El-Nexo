@echo off
:: =========================================================================
::   EL NEXO - REVERSION: AHORRO BATERIA [PLAN: FREE]  (v5.1)
::   Deshace SOLO lo que cambia Nexo_Ahorro_Bateria.bat (version FREE):
::     - plan "Ahorro Inteligente El Nexo" e hibernacion
::     - transparencias y Aero Peek
::     - apps en segundo plano (2 valores)
::   Ya NO ejecuta "powercfg -restoredefaultschemes": eso borraba todos
::   los planes de energia del usuario y del fabricante.
::   Via principal: copia de seguridad en
::     %ProgramData%\ElNexo\Backup\Nexo_Ahorro_Bateria\backup.txt
::   Sin copia: valores de fabrica de Windows, solo para esos ajustes.
:: =========================================================================
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO v4.0 - REVERTIR MODO ECO
color 0B

fsutil dirty query %systemdrive% >nul 2>&1
if %errorlevel% neq 0 (
    cls & color 0C
    echo  Se requieren permisos de Administrador.
    echo  Haz clic derecho y selecciona "Ejecutar como administrador"
    pause & exit /b
)
cd /d "%~dp0"

set "NEXO_BK=%ProgramData%\ElNexo\Backup\Nexo_Ahorro_Bateria"
set "BALANCED=381b4222-f694-41f0-9685-ff5bb260df2e"
set "ECO=33333333-3333-3333-3333-333333333333"

cls
color 0B
echo.
echo  ============================================================
echo    ______ _       _   _ _______   ______
echo   ^|  ____^|^| ^|     ^| \ ^| ^|^|  ___\ \ / / __ \
echo   ^| ^|__  ^| ^|     ^|  \^| ^|^| ^|__  \ V / ^|  ^| ^|
echo   ^|  __^| ^| ^|     ^| . ` ^|^|  __^|  ^> ^<^| ^|  ^| ^|
echo   ^| ^|____^| ^|____ ^| ^|\  ^|^| ^|____/ . \ ^|__^| ^|
echo   ^|______^|^|______^|^|_^| \_^|^|______/_/\_\____/
echo.
echo  ============================================================
echo   PROTOCOLO: REVERSION DE MODO ECO [AHORRO BATERIA]
echo   VERSION: 4.0 - Estado: Restaurando configuracion...
echo  ============================================================
echo.
if exist "%NEXO_BK%\backup.txt" (
    echo  [OK] Copia de seguridad encontrada: se restauran tus valores originales.
) else (
    echo  [!] No hay copia de seguridad de El Nexo.
    echo      Se aplican los valores de fabrica de Windows, solo en los
    echo      ajustes que modifica Nexo_Ahorro_Bateria.bat.
)
echo.

:: RESTORE POWER SCHEME
echo  [PASO 1/3] Restaurando plan de energia anterior...
echo.
set "ORIG_GUID="
set "ORIG_HIB="
if exist "%NEXO_BK%\backup.txt" (
    for /f "usebackq tokens=1,2,3 delims=|" %%a in ("%NEXO_BK%\backup.txt") do (
        if /i "%%a"=="PWR" if /i "%%b"=="ACTIVE" set "ORIG_GUID=%%c"
        if /i "%%a"=="PWR" if /i "%%b"=="HIBERNATE" set "ORIG_HIB=%%c"
    )
)
set "TARGET=%BALANCED%"
if defined ORIG_GUID if /i not "%ORIG_GUID%"=="%ECO%" (
    powercfg /query %ORIG_GUID% >nul 2>&1 && set "TARGET=%ORIG_GUID%"
)
powercfg -setactive %TARGET% >nul 2>&1
powercfg -delete %ECO% >nul 2>&1
if defined ORIG_HIB (
    if /i "%ORIG_HIB%"=="0x0" (powercfg -h off >nul 2>&1) else (powercfg -h on >nul 2>&1)
)
echo  [OK] Plan El Nexo eliminado. Plan anterior activado.

:: RESTORE TRANSPARENCY + BACKGROUND APPS
echo.
echo  [PASO 2/3] Restaurando efectos visuales y apps de fondo...
echo.
if exist "%NEXO_BK%\backup.txt" (
    call :RESTORE_GENERIC
) else (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "HKCU\Software\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d 1 /f >nul 2>&1
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /f >nul 2>&1
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /f >nul 2>&1
)
echo  [OK] Efectos de interfaz y apps de fondo restaurados.

:: CERRAR COPIA
echo.
echo  [PASO 3/3] Cerrando copia de seguridad...
if exist "%NEXO_BK%\backup.txt" move /y "%NEXO_BK%\backup.txt" "%NEXO_BK%\backup.restaurado.txt" >nul 2>&1
echo  [OK] Listo.

:: FINALIZACION
echo.
echo  ============================================================
echo   REVERSION COMPLETADA CON EXITO
echo  ============================================================
echo.
echo   Tu sistema ha vuelto a la configuracion anterior.
echo.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar el sistema ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando para completar la reversion..."

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
