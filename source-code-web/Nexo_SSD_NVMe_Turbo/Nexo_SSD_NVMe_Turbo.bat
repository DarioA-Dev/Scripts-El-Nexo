@echo off
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO v5.0 - SSD NVMe TURBO [PLAN: FREE]
color 0B
:: =========================================================================
::  EL NEXO - SSD NVMe TURBO [PLAN: FREE]  (v5.1 - blindado)
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Antes de cambiar nada guarda los valores originales en
::  %ProgramData%\ElNexo\Backup\Nexo_SSD_NVMe_Turbo\backup.txt
::  REVERT_Nexo_SSD_NVMe_Turbo.bat restaura exactamente esos valores.
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
set "NEXO_BK=%ProgramData%\ElNexo\Backup\Nexo_SSD_NVMe_Turbo"
set "FSKEY=HKLM\SYSTEM\CurrentControlSet\Control\FileSystem"

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
echo   SSD NVMe TURBO   ^|   PLAN: FREE
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
call :RESTORE_POINT "El Nexo SSD Turbo FREE"
if !errorlevel! equ 0 (echo  [OK] Punto creado.) else (
    echo  [!] No se pudo crear.
    echo      Proteccion del sistema desactivada o ya se creo un punto hoy.
    echo      La copia de seguridad de El Nexo sigue activa.
)

echo.
echo  [PASO 2] Activando TRIM...
call :BK_REG "%FSKEY%" "DisableDeleteNotification"
fsutil behavior set DisableDeleteNotify 0 >nul 2>&1
echo  [OK] TRIM activado.

echo.
echo  [PASO 3] Desactivando escrituras innecesarias...
call :BK_REG "%FSKEY%" "NtfsDisableLastAccessUpdate"
call :BK_REG "%FSKEY%" "NtfsDisable8dot3NameCreation"
fsutil behavior set disablelastaccess 1 >nul 2>&1
fsutil behavior set disable8dot3 1 >nul 2>&1
echo  [OK] Timestamps y 8.3 desactivados.

echo.
echo  [PASO 4] Desactivando suspension del disco...
call :BK_PSET SUB_DISK DISKIDLE
powercfg -change -disk-timeout-ac 0 >nul 2>&1
powercfg -change -disk-timeout-dc 0 >nul 2>&1
echo  [OK] Disco siempre activo.

echo.
echo  ============================================================
echo   SSD NVMe TURBO FREE - COMPLETADO
echo  ============================================================
echo.
echo   Cambios aplicados en esta version FREE:
echo   [OK] TRIM activado (salud a largo plazo del SSD)
echo   [OK] Timestamps y nombres 8.3 desactivados
echo   [OK] Suspension del disco desactivada
echo.
echo   Para deshacerlo: REVERT_Nexo_SSD_NVMe_Turbo.bat
echo.
echo  ============================================================
echo   BLOQUEADO EN PLAN FREE - DISPONIBLE EN NEXO OPTIMIZER PRO:
echo  ============================================================
echo.
echo   [PRO] Native NVMe Stack de Windows 11 24H2
echo         (Hasta 64.000 colas paralelas, +80%% IOPS real)
echo         (Necesario para aprovechar DirectStorage)
echo.
echo   [PRO] SysMain (Superfetch) desactivado
echo         (Libera RAM y reduce escrituras innecesarias en SSD)
echo.
echo   [PRO] LargeSystemCache corregido a 0
echo         (El valor correcto para SSDs NVMe modernos)
echo.
echo   [PRO] IoPageLockLimit optimizado
echo         (Mejora la gestion de memoria del filesystem)
echo.
echo   Consigue todo esto y mucho mas en:
echo   elnexocenter.com/optimizer
echo  ============================================================
echo.
set /p "reboot=Deseas reiniciar? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando SSD Turbo FREE El Nexo..."
exit

:: =========================================================================
::  RUTINAS INTERNAS - COPIA DE SEGURIDAD EL NEXO
::  Formato de backup.txt (texto plano, una linea por ajuste):
::    REG|clave|valor|tipo|dato   (o REG|clave|valor|ABSENT| si no existia)
::    PSET|subgrupo|ajuste|guid_plan|valor_AC|valor_DC   (segundos)
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

:BK_PSET
:: Lee los dos ultimos valores hexadecimales de "powercfg /q" (AC y DC);
:: no depende del idioma de Windows.
%FIND% /I "PSET|%~1|%~2|" "%NEXO_BK%\backup.txt" >nul 2>&1 && exit /b 0
set "_g="
for /f "tokens=2 delims=:(" %%g in ('powercfg /getactivescheme') do set "_g=%%g"
if not defined _g exit /b 0
for /f "tokens=1" %%g in ("%_g%") do set "_g=%%g"
set "_prev="
set "_last="
for /f "tokens=2 delims=:" %%v in ('powercfg /q %_g% %~1 %~2 ^| %FIND% "0x"') do (
    set "_prev=!_last!"
    set "_last=%%v"
)
if not defined _prev exit /b 0
set /a _ac=!_prev!
set /a _dc=!_last!
>>"%NEXO_BK%\backup.txt" echo PSET^|%~1^|%~2^|%_g%^|!_ac!^|!_dc!
exit /b 0

:RESTORE_POINT
powershell -NoProfile -Command "try { Checkpoint-Computer -Description '%~1' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction Stop -WarningVariable w -WarningAction SilentlyContinue; if ($w) { exit 2 } } catch { exit 1 }" >nul 2>&1
exit /b %errorlevel%
