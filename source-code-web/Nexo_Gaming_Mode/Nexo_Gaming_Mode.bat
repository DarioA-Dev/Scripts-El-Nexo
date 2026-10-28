@echo off
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO v5.0 - GAMING MODE [PLAN: FREE]
color 0B
:: =========================================================================
::  EL NEXO - GAMING MODE [PLAN: FREE]  (v5.1 - blindado)
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Antes de cambiar nada guarda los valores originales en
::  %ProgramData%\ElNexo\Backup\Nexo_Gaming_Mode\backup.txt
::  REVERT_Nexo_Gaming_Mode.bat restaura exactamente esos valores.
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

set "FIND=%SystemRoot%\System32\find.exe"
set "NEXO_BK=%ProgramData%\ElNexo\Backup\Nexo_Gaming_Mode"

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
echo   GAMING MODE   ^|   PLAN: FREE
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
    call :RESTORE_POINT "El Nexo Gaming Mode FREE"
    if !errorlevel! equ 0 (echo  [OK] Punto creado.) else (
        echo  [!] No se pudo crear.
        echo      Proteccion del sistema desactivada o ya se creo un punto hoy.
        echo      La copia de seguridad de El Nexo sigue activa.
    )
) else (echo  [!] Saltando respaldo.)
echo.

echo  [PASO 1/4] Desactivando Xbox Game Bar y DVR...
call :BK_REG "HKCU\System\GameConfigStore" "GameDVR_Enabled"
call :BK_REG "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowgameDVR"
call :BK_REG "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" "AppCaptureEnabled"
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowgameDVR" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] Xbox Game Bar y DVR desactivados.

echo.
echo  [PASO 2/4] Desactivando servicios de Xbox...
echo.
echo   AVISO: desactivarlos rompe el inicio de sesion Xbox en juegos de PC
echo   (incluidos juegos de Steam con cuenta Xbox: Halo MCC, Forza,
echo   Minecraft...), Game Pass y la actualizacion de mandos Xbox.
echo   No mejora los FPS: estos servicios solo arrancan cuando se usan.
echo.
set "xbox=N"
set /p "xbox=Desactivar servicios de Xbox de todos modos? (S/N, por defecto N): "
if /i "%xbox%"=="S" (
    for %%s in (XblAuthManager XblGameSave XboxGipSvc XboxNetApiSvc GamingServices GamingServicesNet) do (
        call :BK_SVC %%s
        sc stop %%s >nul 2>&1
        sc config %%s start= disabled >nul 2>&1
    )
    echo  [OK] Servicios Xbox desactivados.
) else (
    echo  [!] Servicios Xbox sin cambios.
)

echo.
echo  [PASO 3/4] Desactivando telemetria...
for %%s in (DiagTrack dmwappushservice WerSvc RetailDemo) do (
    call :BK_SVC %%s
    sc stop %%s >nul 2>&1
    sc config %%s start= disabled >nul 2>&1
)
echo  [OK] Telemetria desactivada.

echo.
echo  [PASO 4/4] Desactivando tareas y apps de fondo...
call :BK_TASK "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
call :BK_TASK "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
call :BK_TASK "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable >nul 2>&1
call :BK_REG "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" "LetAppsRunInBackground"
call :BK_REG "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
echo  [OK] Apps de fondo bloqueadas.

echo.
echo  ============================================================
echo   GAMING MODE FREE - COMPLETADO
echo  ============================================================
echo.
echo   Cambios aplicados en esta version FREE:
echo   [OK] Xbox Game Bar y DVR desactivados
if /i "%xbox%"=="S" echo   [OK] Servicios Xbox desactivados
echo   [OK] Telemetria de Microsoft desactivada
echo   [OK] Apps de fondo bloqueadas
echo.
echo   Para deshacerlo: REVERT_Nexo_Gaming_Mode.bat
echo.
echo  ============================================================
echo   BLOQUEADO EN PLAN FREE - DISPONIBLE EN NEXO OPTIMIZER PRO:
echo  ============================================================
echo.
echo   [PRO] GPU Priority 8 + Scheduling Category High
echo         (El cambio que mas FPS y menos stutters da)
echo.
echo   [PRO] SystemResponsiveness=0
echo         (100%% de recursos del sistema para el juego)
echo.
echo   [PRO] HAGS configurado correctamente
echo         (Elimina micro-stutters en DirectX 12 y Vulkan)
echo.
echo   [PRO] Overlays NVIDIA ShadowPlay y Steam desactivados
echo         (Eliminan inyeccion de DLL en la cadena de render)
echo.
echo   [PRO] Purga de Nahimic y Sonic Studio
echo         (Causa principal de crackling y picos DPC)
echo.
echo   Consigue todo esto y mucho mas en:
echo   elnexocenter.com/optimizer
echo  ============================================================
echo.
set /p "reboot=Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando Gaming Mode FREE El Nexo..."
exit

:: =========================================================================
::  RUTINAS INTERNAS - COPIA DE SEGURIDAD EL NEXO
::  Formato de backup.txt (texto plano, una linea por ajuste):
::    REG|clave|valor|tipo|dato   (o REG|clave|valor|ABSENT| si no existia)
::    SVC|servicio|tipo_inicio|RUNNING/STOPPED
::    TASK|tarea|ENABLE/DISABLE
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

:BK_TASK
%FIND% /I "TASK|%~1|" "%NEXO_BK%\backup.txt" >nul 2>&1 && exit /b 0
schtasks /Query /TN "%~1" >nul 2>&1
if errorlevel 1 (
    >>"%NEXO_BK%\backup.txt" echo TASK^|%~1^|ABSENT
    exit /b 0
)
set "_ts=ENABLE"
for /f %%x in ('schtasks /Query /TN "%~1" /XML ^| %FIND% /C "<Enabled>false</Enabled>"') do if not "%%x"=="0" set "_ts=DISABLE"
>>"%NEXO_BK%\backup.txt" echo TASK^|%~1^|%_ts%
exit /b 0

:RESTORE_POINT
powershell -NoProfile -Command "try { Checkpoint-Computer -Description '%~1' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction Stop -WarningVariable w -WarningAction SilentlyContinue; if ($w) { exit 2 } } catch { exit 1 }" >nul 2>&1
exit /b %errorlevel%
