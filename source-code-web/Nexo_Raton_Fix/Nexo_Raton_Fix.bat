@echo off
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO v5.0 - RATON FIX [PLAN: FREE]
color 0B
:: =========================================================================
::  EL NEXO - RATON FIX [PLAN: FREE]  (v5.1 - blindado)
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Antes de cambiar nada guarda los valores originales en
::  %ProgramData%\ElNexo\Backup\Nexo_Raton_Fix\backup.txt
::  REVERT_Nexo_Raton_Fix.bat restaura exactamente esos valores.
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
set "NEXO_BK=%ProgramData%\ElNexo\Backup\Nexo_Raton_Fix"

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
echo   RATON FIX   ^|   PLAN: FREE
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

echo  [PASO 1] Creando punto de restauracion...
call :RESTORE_POINT "El Nexo Raton Fix FREE"
if !errorlevel! equ 0 (echo  [OK] Punto creado.) else (
    echo  [!] No se pudo crear.
    echo      Proteccion del sistema desactivada o ya se creo un punto hoy.
    echo      La copia de seguridad de El Nexo sigue activa.
)

echo.
echo  [PASO 2] Desactivando aceleracion del puntero...
call :BK_REG "HKCU\Control Panel\Mouse" "MouseSpeed"
call :BK_REG "HKCU\Control Panel\Mouse" "MouseThreshold1"
call :BK_REG "HKCU\Control Panel\Mouse" "MouseThreshold2"
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul 2>&1
echo  [OK] Aceleracion basica desactivada.

echo.
echo  [PASO 3] Reduciendo latencia de menus...
call :BK_REG "HKCU\Control Panel\Desktop" "MenuShowDelay"
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1
echo  [OK] MenuShowDelay a 0ms.

echo.
echo  ============================================================
echo   RATON FIX FREE - COMPLETADO
echo  ============================================================
echo.
echo   Cambios aplicados en esta version FREE:
echo   [OK] Aceleracion basica de puntero desactivada
echo   [OK] MenuShowDelay reducido a 0ms
echo.
echo   Los cambios se aplican al cerrar sesion o reiniciar.
echo   Para deshacerlo: REVERT_Nexo_Raton_Fix.bat
echo.
echo  ============================================================
echo   BLOQUEADO EN PLAN FREE - DISPONIBLE EN NEXO OPTIMIZER PRO:
echo  ============================================================
echo.
echo   [PRO] UserPreferencesMask corregido
echo         Desactiva "Enhance Pointer Precision" a nivel de sistema
echo         La version FREE NO desactiva esto completamente
echo         (El Panel de Control puede volver a activarlo)
echo.
echo   [PRO] SmoothMouseXCurve y SmoothMouseYCurve linealizadas
echo         Elimina la curva de aceleracion a nivel de driver
echo         Sin esto la precision 1:1 real no esta garantizada
echo.
echo   [PRO] MouseDataQueueSize optimizado
echo         Mejora la estabilidad del buffer del controlador
echo.
echo   Consigue todo esto y mucho mas en:
echo   elnexocenter.com/optimizer
echo  ============================================================
echo.
set /p "reboot=Deseas reiniciar? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando Raton Fix FREE El Nexo..."
exit

:: =========================================================================
::  RUTINAS INTERNAS - COPIA DE SEGURIDAD EL NEXO
::  Formato de backup.txt (texto plano, una linea por ajuste):
::    REG|clave|valor|tipo|dato   (o REG|clave|valor|ABSENT| si no existia)
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

:RESTORE_POINT
powershell -NoProfile -Command "try { Checkpoint-Computer -Description '%~1' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction Stop -WarningVariable w -WarningAction SilentlyContinue; if ($w) { exit 2 } } catch { exit 1 }" >nul 2>&1
exit /b %errorlevel%
