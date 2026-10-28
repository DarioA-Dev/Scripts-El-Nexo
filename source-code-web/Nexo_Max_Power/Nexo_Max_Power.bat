@echo off
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO v5.0 - MAX POWER [PLAN: FREE]
color 0B
:: =========================================================================
::  EL NEXO - MAX POWER [PLAN: FREE]  (v5.1 - blindado)
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Antes de cambiar nada guarda los valores originales en
::  %ProgramData%\ElNexo\Backup\Nexo_Max_Power\backup.txt
::  REVERT_Nexo_Max_Power.bat restaura exactamente esos valores.
:: =========================================================================

fsutil dirty query %systemdrive% >nul 2>&1
if %errorlevel% neq 0 (
    cls & color 0C
    echo.
    echo  ============================================================
    echo   ACCESO DENEGADO - Se requieren permisos de Administrador
    echo  ============================================================
    echo.
    echo   Haz clic derecho y selecciona "Ejecutar como administrador"
    echo  ============================================================
    pause & exit /b
)

set "FIND=%SystemRoot%\System32\find.exe"
set "NEXO_BK=%ProgramData%\ElNexo\Backup\Nexo_Max_Power"

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
echo   MAX POWER   ^|   PLAN: FREE
echo   Para la version completa: elnexocenter.com/optimizer
echo  ============================================================
echo.

:: DETECCION PC / LAPTOP (WMIC ya no existe en Windows 11 24H2: se usa CIM)
echo  [DETECCION] Identificando tipo de dispositivo...
echo.
set "DEVICE_TYPE=PC"
set "DEVICE_NAME=PC de Escritorio"
set "BAT_COUNT=0"
for /f %%b in ('powershell -NoProfile -Command "@(Get-CimInstance -ClassName Win32_Battery -ErrorAction SilentlyContinue).Count"') do set "BAT_COUNT=%%b"
if not "%BAT_COUNT%"=="0" (
    set "DEVICE_TYPE=LAPTOP"
    set "DEVICE_NAME=Portatil / Laptop"
)
echo  [INFO] Dispositivo: %DEVICE_NAME%
echo.

:: COPIA DE SEGURIDAD PROPIA (siempre)
call :BK_INIT
if errorlevel 1 (
    echo  [!] No se pudo crear la copia de seguridad en %ProgramData%\ElNexo.
    echo      No se ha cambiado nada.
    pause & exit /b
)
echo  [OK] Copia de seguridad de El Nexo: %NEXO_BK%
echo.

:: PUNTO DE RESTAURACION
echo  [PASO 1] Creando punto de restauracion...
set /p "backup=Crear respaldo antes de continuar? (S/N): "
if /i "%backup%"=="S" (
    call :RESTORE_POINT "El Nexo Max Power FREE"
    if !errorlevel! equ 0 (echo  [OK] Punto creado.) else (
        echo  [!] No se pudo crear.
        echo      Proteccion del sistema desactivada o ya se creo un punto hoy.
        echo      La copia de seguridad de El Nexo sigue activa.
    )
) else (echo  [!] Saltando respaldo.)

:: PLAN DE ENERGIA
echo.
echo  [PASO 2] Creando plan de energia personalizado...
call :BK_PWR
if "%DEVICE_TYPE%"=="PC" (
    set "NEXO_GUID=11111111-1111-1111-1111-111111111111"
    set "PLAN_NOMBRE=Maximo Rendimiento El Nexo"
) else (
    set "NEXO_GUID=22222222-2222-2222-2222-222222222222"
    set "PLAN_NOMBRE=Alto Rendimiento El Nexo"
)
powercfg -delete %NEXO_GUID% >nul 2>&1
:: Base: Alto rendimiento. En equipos con Modern Standby ese plan no existe:
:: entonces se parte de Equilibrado y se ajustan los mismos valores.
powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c %NEXO_GUID% >nul 2>&1
if errorlevel 1 powercfg -duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e %NEXO_GUID% >nul 2>&1
powercfg /query %NEXO_GUID% >nul 2>&1
if errorlevel 1 (
    echo  [!] No se pudo crear el plan de energia. Se omite este paso.
    goto :SERVICIOS
)
powercfg -changename %NEXO_GUID% "%PLAN_NOMBRE%" "Plan El Nexo FREE" >nul 2>&1
:: Los valores se escriben SOLO en el plan El Nexo, nunca en el plan del usuario.
powercfg -setacvalueindex %NEXO_GUID% SUB_DISK DISKIDLE 0 >nul 2>&1
powercfg -setacvalueindex %NEXO_GUID% SUB_SLEEP STANDBYIDLE 0 >nul 2>&1
powercfg -setacvalueindex %NEXO_GUID% sub_processor PROCTHROTTLEMIN 100 >nul 2>&1
powercfg -setacvalueindex %NEXO_GUID% sub_processor PROCTHROTTLEMAX 100 >nul 2>&1
powercfg -setacvalueindex %NEXO_GUID% sub_processor PERFBOOSTMODE 2 >nul 2>&1
powercfg -setacvalueindex %NEXO_GUID% sub_pciexpress aspm 0 >nul 2>&1
powercfg -setacvalueindex %NEXO_GUID% sub_usb usbsuspend 0 >nul 2>&1
powercfg -setactive %NEXO_GUID%
if "%DEVICE_TYPE%"=="PC" powercfg -h off >nul 2>&1
echo  [OK] Plan "%PLAN_NOMBRE%" activado.

:SERVICIOS
:: SERVICIOS DE TELEMETRIA
echo.
echo  [PASO 3] Desactivando servicios de telemetria...
for %%s in (DiagTrack dmwappushservice WerSvc RetailDemo) do (
    call :BK_SVC %%s
    sc stop %%s >nul 2>&1
    sc config %%s start= disabled >nul 2>&1
)
echo  [OK] Telemetria desactivada.

:: PRIORIDAD DE JUEGOS (basica)
echo.
echo  [PASO 4] Configurando prioridad basica de juegos...
call :BK_REG "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Priority"
call :BK_REG "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Scheduling Category"
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
echo  [OK] Prioridad de juegos configurada.

echo.
echo  ============================================================
echo   MAX POWER FREE - COMPLETADO
echo  ============================================================
echo.
echo   Cambios aplicados en esta version FREE:
echo   [OK] Plan de energia personalizado
echo   [OK] CPU al 100%% sin throttling
echo   [OK] Telemetria de Microsoft desactivada
echo   [OK] Prioridad basica de juegos
echo.
echo   Para deshacerlo: REVERT_Nexo_Max_Power.bat
echo.
echo  ============================================================
echo   BLOQUEADO EN PLAN FREE - DISPONIBLE EN NEXO OPTIMIZER PRO:
echo  ============================================================
echo.
echo   [PRO] MSI Mode en GPU, NIC y almacenamiento
echo         (Elimina latencia DPC - impacto directo en FPS)
echo.
echo   [PRO] Optimizacion del kernel (bcdedit TSCSync, x2APIC)
echo         (Reduce micro-stutters a nivel de sistema)
echo.
echo   [PRO] GPU: ULPS off + MPO off
echo         (Elimina pantallazos negros en Alt+Tab)
echo.
echo   [PRO] Win32PrioritySeparation + DisablePagingExecutive
echo         (Prioridad absoluta de CPU para juegos)
echo.
echo   [PRO] GPU Priority 8 en scheduler multimedia
echo         (El ajuste mas impactante para 1%% lows)
echo.
echo   Consigue todo esto y mucho mas en:
echo   elnexocenter.com/optimizer
echo  ============================================================
echo.
start powercfg.cpl
set /p "reboot=Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando Max Power FREE El Nexo..."
exit

:: =========================================================================
::  RUTINAS INTERNAS - COPIA DE SEGURIDAD EL NEXO
::  Formato de backup.txt (texto plano, una linea por ajuste):
::    REG|clave|valor|tipo|dato   (o REG|clave|valor|ABSENT| si no existia)
::    SVC|servicio|tipo_inicio|RUNNING/STOPPED
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

:BK_SVC
%FIND% /I "SVC|%~1|" "%NEXO_BK%\backup.txt" >nul 2>&1 && exit /b 0
sc qc "%~1" >nul 2>&1
if errorlevel 1 (
    >>"%NEXO_BK%\backup.txt" echo SVC^|%~1^|ABSENT^|
    exit /b 0
)
set "_st="
for /f "tokens=3" %%t in ('sc qc "%~1" ^| %FIND% "START_TYPE"') do set "_st=%%t"
set "_mode=demand"
if "%_st%"=="0" set "_mode=boot"
if "%_st%"=="1" set "_mode=system"
if "%_st%"=="2" set "_mode=auto"
if "%_st%"=="4" set "_mode=disabled"
for /f %%x in ('sc qc "%~1" ^| %FIND% /C "DELAYED"') do if not "%%x"=="0" set "_mode=delayed-auto"
set "_run=STOPPED"
for /f %%x in ('sc query "%~1" ^| %FIND% /C "RUNNING"') do if not "%%x"=="0" set "_run=RUNNING"
>>"%NEXO_BK%\backup.txt" echo SVC^|%~1^|%_mode%^|%_run%
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
