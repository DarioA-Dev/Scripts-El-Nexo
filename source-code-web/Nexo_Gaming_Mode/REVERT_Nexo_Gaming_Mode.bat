@echo off
:: =========================================================================
::   EL NEXO - REVERT: GAMING MODE [PLAN: FREE]  (v5.1)
::   Deshace SOLO lo que cambia Nexo_Gaming_Mode.bat (version FREE):
::     - Game Bar / DVR (3 valores de registro)
::     - servicios Xbox (si se eligio desactivarlos) y de telemetria
::     - 3 tareas programadas y 2 valores de apps en segundo plano
::   Via principal: copia de seguridad en
::     %ProgramData%\ElNexo\Backup\Nexo_Gaming_Mode\backup.txt
::   Sin copia: valores de fabrica de Windows, solo para esos ajustes.
:: =========================================================================
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO - REVERT Gaming Mode
color 0E

fsutil dirty query %systemdrive% >nul 2>&1
if %errorlevel% neq 0 (
    cls & color 0C
    echo  Se requieren permisos de Administrador.
    echo  Haz clic derecho y selecciona "Ejecutar como administrador"
    pause & exit /b
)

set "FIND=%SystemRoot%\System32\find.exe"
set "NEXO_BK=%ProgramData%\ElNexo\Backup\Nexo_Gaming_Mode"

cls
color 0E
echo.
echo  ============================================================
echo   EL NEXO - REVERT: GAMING MODE
echo   Restaurando configuracion original del sistema...
echo  ============================================================
echo.
if exist "%NEXO_BK%\backup.txt" (
    echo  [OK] Copia de seguridad encontrada: se restauran tus valores originales.
    echo.
    echo  [1/2] Restaurando Game Bar, servicios, tareas y apps de fondo...
    call :RESTORE_GENERIC
    move /y "%NEXO_BK%\backup.txt" "%NEXO_BK%\backup.restaurado.txt" >nul 2>&1
) else (
    echo  [!] No hay copia de seguridad de El Nexo.
    echo      Se aplican los valores de fabrica de Windows, solo en los
    echo      ajustes que modifica Nexo_Gaming_Mode.bat.
    echo.
    echo  [1/2] Restaurando Game Bar, servicios, tareas y apps de fondo...
    reg delete "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /f >nul 2>&1
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowgameDVR" /f >nul 2>&1
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /f >nul 2>&1
    call :SVC_DEFAULT XblAuthManager demand
    call :SVC_DEFAULT XblGameSave demand
    call :SVC_DEFAULT XboxGipSvc demand
    call :SVC_DEFAULT XboxNetApiSvc demand
    call :SVC_DEFAULT GamingServices auto
    call :SVC_DEFAULT GamingServicesNet auto
    call :SVC_DEFAULT DiagTrack auto
    call :SVC_DEFAULT dmwappushservice demand
    call :SVC_DEFAULT WerSvc demand
    call :SVC_DEFAULT RetailDemo demand
    schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Enable >nul 2>&1
    schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Enable >nul 2>&1
    schtasks /Change /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Enable >nul 2>&1
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /f >nul 2>&1
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /f >nul 2>&1
)
echo  [OK] Configuracion restaurada.

echo.
echo  [2/2] Comprobacion final...
echo  [OK] Listo.

echo.
echo  ============================================================
echo   REVERT COMPLETADO
echo  ============================================================
echo   Reinicia el PC para que todos los cambios tomen efecto.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Revert Gaming Mode El Nexo..."
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
    if /i "%%a"=="TASK" if /i not "%%c"=="ABSENT" (
        schtasks /Change /TN "%%b" /%%c >nul 2>&1
        echo  [*] Tarea restaurada: %%b
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
