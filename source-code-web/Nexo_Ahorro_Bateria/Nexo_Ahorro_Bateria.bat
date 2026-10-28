@echo off
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO v5.0 - AHORRO BATERIA [PLAN: FREE]
color 0B
:: =========================================================================
::  EL NEXO - AHORRO BATERIA [PLAN: FREE]  (v5.1 - blindado)
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Antes de cambiar nada guarda los valores originales en
::  %ProgramData%\ElNexo\Backup\Nexo_Ahorro_Bateria\backup.txt
::  Revertir_cambios_Ahorro_de_bateria_portatil_El_Nexo.bat los restaura.
:: =========================================================================

fsutil dirty query %systemdrive% >nul 2>&1
if %errorlevel% neq 0 (
    cls & color 0C
    echo.
    echo  ============================================================
    echo   ACCESO DENEGADO - Se requieren permisos de Administrador
    echo  ============================================================
    echo   Haz clic derecho y selecciona "Ejecutar como administrador"
    echo  ============================================================
    pause & exit /b
)
cd /d "%~dp0"

set "FIND=%SystemRoot%\System32\find.exe"
set "NEXO_BK=%ProgramData%\ElNexo\Backup\Nexo_Ahorro_Bateria"

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
echo   AHORRO BATERIA   ^|   PLAN: FREE
echo   Para la version completa: elnexocenter.com/optimizer
echo  ============================================================
echo.

call :BK_INIT
if errorlevel 1 (
    echo  [!] No se pudo crear la copia de seguridad en %ProgramData%\ElNexo.
    echo      No se ha cambiado nada.
    pause & exit /b
)
echo  [OK] Copia de seguridad de El Nexo: %NEXO_BK%
echo.

set /p "backup=Crear punto de restauracion? (S/N): "
if /i "%backup%"=="S" (
    call :RESTORE_POINT "El Nexo Ahorro Bateria FREE"
    if !errorlevel! equ 0 (echo  [OK] Punto creado.) else (
        echo  [!] No se pudo crear.
        echo      Proteccion del sistema desactivada o ya se creo un punto hoy.
        echo      La copia de seguridad de El Nexo sigue activa.
    )
) else (echo  [!] Saltando respaldo.)
echo.

echo  [PASO 1/3] Creando plan de ahorro inteligente...
call :BK_PWR
set "NEXO_ECO_GUID=33333333-3333-3333-3333-333333333333"
powercfg -delete %NEXO_ECO_GUID% >nul 2>&1
:: Base: Economizador. En equipos con Modern Standby ese plan no existe:
:: entonces se parte de Equilibrado y se ajustan los mismos valores.
powercfg -duplicatescheme a1841308-3541-4fab-bc81-f71556f20b4a %NEXO_ECO_GUID% >nul 2>&1
if errorlevel 1 powercfg -duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e %NEXO_ECO_GUID% >nul 2>&1
powercfg /query %NEXO_ECO_GUID% >nul 2>&1
if errorlevel 1 (
    echo  [!] No se pudo crear el plan de energia. Se omite este paso.
    goto :EFECTOS
)
powercfg -changename %NEXO_ECO_GUID% "Ahorro Inteligente El Nexo" "Plan El Nexo FREE" >nul 2>&1
:: Los valores se escriben SOLO en el plan El Nexo, nunca en el plan del usuario.
powercfg -setdcvalueindex %NEXO_ECO_GUID% SUB_VIDEO VIDEOIDLE 180 >nul 2>&1
powercfg -setdcvalueindex %NEXO_ECO_GUID% SUB_DISK DISKIDLE 300 >nul 2>&1
powercfg -setdcvalueindex %NEXO_ECO_GUID% SUB_SLEEP STANDBYIDLE 600 >nul 2>&1
powercfg -setdcvalueindex %NEXO_ECO_GUID% sub_processor PROCTHROTTLEMIN 5 >nul 2>&1
powercfg -setdcvalueindex %NEXO_ECO_GUID% sub_processor PROCTHROTTLEMAX 75 >nul 2>&1
powercfg -setdcvalueindex %NEXO_ECO_GUID% sub_processor PERFBOOSTMODE 0 >nul 2>&1
powercfg -setactive %NEXO_ECO_GUID%
powercfg -h on >nul 2>&1
echo  [OK] Plan ECO activado (CPU al 75%%).

:EFECTOS
echo.
echo  [PASO 2/3] Reduciendo efectos visuales...
call :BK_REG "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "EnableTransparency"
call :BK_REG "HKCU\Software\Microsoft\Windows\DWM" "EnableAeroPeek"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] Transparencias desactivadas.

echo.
echo  [PASO 3/3] Limitando apps de segundo plano...
call :BK_REG "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled"
call :BK_REG "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" "LetAppsRunInBackground"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d 2 /f >nul 2>&1
echo  [OK] Apps de fondo bloqueadas.

echo.
echo  ============================================================
echo   AHORRO BATERIA FREE - COMPLETADO
echo  ============================================================
echo.
echo   Cambios aplicados en esta version FREE:
echo   [OK] Plan ECO personalizado (CPU al 75%%)
echo   [OK] Efectos visuales reducidos
echo   [OK] Apps de fondo bloqueadas
echo.
echo   Para deshacerlo: Revertir_cambios_Ahorro_de_bateria_portatil_El_Nexo.bat
echo.
echo  ============================================================
echo   BLOQUEADO EN PLAN FREE - DISPONIBLE EN NEXO OPTIMIZER PRO:
echo  ============================================================
echo.
echo   [PRO] Turbo Boost desactivado en bateria
echo         (Reduce consumo hasta un 25%% en carga media)
echo.
echo   [PRO] Brillo adaptativo segun la luz ambiente
echo         (Ahorro real y automatico sin hacer nada)
echo.
echo   [PRO] Power Throttling inteligente de CPU
echo         (Windows gestiona el uso segun la tarea)
echo.
echo   [PRO] Energy-Efficient Ethernet desactivado correctamente
echo         (Sin picos de CPU por la NIC en reposo)
echo.
echo   [PRO] Indexacion de disco desactivada en bateria
echo         (Ahorra IOPS y calor en SSDs lentos)
echo.
echo   Consigue todo esto y mucho mas en:
echo   elnexocenter.com/optimizer
echo  ============================================================
echo.
start powercfg.cpl
pause
exit

:: =========================================================================
::  RUTINAS INTERNAS - COPIA DE SEGURIDAD EL NEXO
::  Formato de backup.txt (texto plano, una linea por ajuste):
::    REG|clave|valor|tipo|dato   (o REG|clave|valor|ABSENT| si no existia)
::    PWR|ACTIVE|guid_plan   y   PWR|HIBERNATE|0x0/0x1
::  Solo se guarda la primera vez que se toca cada ajuste.
:: =========================================================================
:BK_INIT
if not exist "%NEXO_BK%\" mkdir "%NEXO_BK%" >nul 2>&1
if not exist "%NEXO_BK%\backup.txt" type nul > "%NEXO_BK%\backup.txt" 2>nul
if not exist "%NEXO_BK%\backup.txt" exit /b 1
exit /b 0

:BK_REG
set "_k=%~1"
set "_n=%~2"
%FIND% /I "REG|%_k%|%_n%|" "%NEXO_BK%\backup.txt" >nul 2>&1 && exit /b 0
set "_line="
set "_t="
set "_d="
for /f "delims=" %%L in ('reg query "%_k%" /v "%_n%" 2^>nul ^| %FIND% "REG_"') do set "_line=%%L"
if not defined _line (
    >>"%NEXO_BK%\backup.txt" echo REG^|%_k%^|%_n%^|ABSENT^|
    exit /b 0
)
set "_rest=!_line:*%_n%=!"
for /f "tokens=1*" %%a in ("!_rest!") do (
    set "_t=%%a"
    set "_d=%%b"
)
>>"%NEXO_BK%\backup.txt" echo REG^|%_k%^|%_n%^|!_t!^|!_d!
exit /b 0

:BK_PWR
%FIND% /I "PWR|" "%NEXO_BK%\backup.txt" >nul 2>&1 && exit /b 0
set "_g="
for /f "tokens=2 delims=:(" %%g in ('powercfg /getactivescheme') do set "_g=%%g"
if defined _g for /f "tokens=1" %%g in ("%_g%") do set "_g=%%g"
if defined _g >>"%NEXO_BK%\backup.txt" echo PWR^|ACTIVE^|%_g%
set "_h="
for /f "tokens=3" %%h in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v HibernateEnabled 2^>nul ^| %FIND% "REG_DWORD"') do set "_h=%%h"
if defined _h >>"%NEXO_BK%\backup.txt" echo PWR^|HIBERNATE^|%_h%
exit /b 0

:RESTORE_POINT
powershell -NoProfile -Command "try { Checkpoint-Computer -Description '%~1' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction Stop -WarningVariable w -WarningAction SilentlyContinue; if ($w) { exit 2 } } catch { exit 1 }" >nul 2>&1
exit /b %errorlevel%
