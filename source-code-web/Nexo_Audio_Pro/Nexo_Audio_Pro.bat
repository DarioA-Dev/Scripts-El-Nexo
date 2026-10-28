@echo off
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO v5.0 - AUDIO PRO [PLAN: FREE]
color 0B
:: =========================================================================
::  EL NEXO - AUDIO PRO [PLAN: FREE]  (v5.1 - blindado)
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Antes de cambiar nada guarda los valores originales en
::  %ProgramData%\ElNexo\Backup\Nexo_Audio_Pro\backup.txt
::  REVERT_Nexo_Audio_Pro.bat restaura exactamente esos valores.
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
set "NEXO_BK=%ProgramData%\ElNexo\Backup\Nexo_Audio_Pro"
set "MMKEY=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"

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
echo   AUDIO PRO   ^|   PLAN: FREE
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

echo  [PASO 1/2] Elevando prioridad del scheduler de audio...
call :BK_REG "%MMKEY%\Tasks\Audio" "Scheduling Category"
call :BK_REG "%MMKEY%\Tasks\Audio" "SFIO Priority"
call :BK_REG "%MMKEY%\Tasks\Audio" "GPU Priority"
call :BK_REG "%MMKEY%\Tasks\Audio" "Priority"
call :BK_REG "%MMKEY%\Tasks\Audio" "Latency Sensitive"
reg add "%MMKEY%\Tasks\Audio" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "%MMKEY%\Tasks\Audio" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
reg add "%MMKEY%\Tasks\Audio" /v "GPU Priority" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "%MMKEY%\Tasks\Audio" /v "Priority" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "%MMKEY%\Tasks\Audio" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1
echo  [OK] Prioridad de audio maximizada en el scheduler.

echo.
echo  [PASO 2/2] Eliminando throttling de red para audio...
call :BK_REG "%MMKEY%" "NetworkThrottlingIndex"
call :BK_REG "%MMKEY%" "SystemResponsiveness"
reg add "%MMKEY%" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
reg add "%MMKEY%" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] Throttling de red eliminado.

echo.
echo  ============================================================
echo   AUDIO PRO FREE - COMPLETADO
echo  ============================================================
echo.
echo   Cambios aplicados en esta version FREE:
echo   [OK] Scheduling Category High para audio
echo   [OK] Latency Sensitive activado
echo   [OK] Throttling de red para audio eliminado
echo.
echo   Para deshacerlo: REVERT_Nexo_Audio_Pro.bat
echo.
echo  ============================================================
echo   BLOQUEADO EN PLAN FREE - DISPONIBLE EN NEXO OPTIMIZER PRO:
echo  ============================================================
echo.
echo   [PRO] Purga de Nahimic (MSI, Samsung, ASUS)
echo         Causa principal del crackling y latencia DPC alta
echo         La version FREE NO lo elimina
echo.
echo   [PRO] Purga de Sonic Studio / Sonic Suite (ASUS ROG/TUF)
echo         Otro causante conocido de audio con cortes
echo.
echo   [PRO] Eliminacion de Realtek Audio Console UWP
echo         La app oculta que genera interrupciones innecesarias
echo.
echo   [PRO] MSI Mode en controladores HD Audio
echo         Elimina la latencia DPC a nivel de hardware
echo         Sin esto los picos de latencia siguen presentes
echo.
echo   Consigue todo esto y mucho mas en:
echo   elnexocenter.com/optimizer
echo  ============================================================
echo.
set /p "reboot=Deseas reiniciar? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando Audio Pro FREE El Nexo..."
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
