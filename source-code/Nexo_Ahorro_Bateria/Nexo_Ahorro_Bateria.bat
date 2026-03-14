@echo off
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO v5.0 - AHORRO BATERIA
color 0B

net session >nul 2>&1
if %errorlevel% neq 0 (
    cls
    color 0C
    echo.
    echo  ============================================================
    echo   ACCESO DENEGADO - Se requieren permisos de Administrador
    echo  ============================================================
    echo.
    echo   Haz clic derecho y selecciona "Ejecutar como administrador"
    echo.
    echo  ============================================================
    pause
    exit /b
)

cls
color 0B
echo.
echo  ============================================================
echo    _____ _         _   _ _______  ___   ___
echo   ^|  ___^| ^|       ^| \ ^| ^|  _____^|^|   \ ^|   ^|
echo   ^| ^|__ ^| ^|       ^|  \^| ^| ^|___   ^| ^|\ \^| ^| ^|
echo   ^|  __^|^| ^|       ^| . ` ^|  _^|   ^| ^| \ ` ^| ^|
echo   ^| ^|___^| ^|____   ^| ^|\  ^| ^|____  ^| ^|  \ ^| ^|
echo   ^|_____^|______^|  ^|_^| \_^|______^| ^|___\____^|
echo.
echo  ============================================================
echo   PROTOCOLO: AHORRO DE BATERIA [MODO ECO INTELIGENTE]
echo   VERSION: 5.0
echo  ============================================================
echo.

echo  [PASO 1/8] Creando punto de restauracion...
echo.
set /p "backup=Deseas crear un respaldo antes de continuar? (S/N): "
if /i "%backup%"=="S" (
    powershell -Command "Checkpoint-Computer -Description 'El Nexo Ahorro Bateria' -RestorePointType 'MODIFY_SETTINGS'" 2>nul
    if !errorlevel! equ 0 (echo  [OK] Punto creado.) else (echo  [!] No se pudo crear.)
) else (
    echo  [!] Saltando respaldo.
)

echo.
echo  [PASO 2/8] Creando plan de ahorro inteligente...
echo.
set "NEXO_ECO_GUID=33333333-3333-3333-3333-333333333333"
powercfg -delete %NEXO_ECO_GUID% >nul 2>&1
powercfg -duplicatescheme a1841308-3541-4fab-bc81-f71556f20b4a %NEXO_ECO_GUID% >nul 2>&1
powercfg -changename %NEXO_ECO_GUID% "Ahorro Inteligente El Nexo" "Plan optimizado para maxima duracion de bateria" >nul 2>&1
powercfg -setactive %NEXO_ECO_GUID%
powercfg -change -monitor-timeout-dc 3 >nul 2>&1
powercfg -change -disk-timeout-dc 5 >nul 2>&1
powercfg -change -standby-timeout-dc 10 >nul 2>&1
powercfg -h on >nul 2>&1
powercfg -setdcvalueindex %NEXO_ECO_GUID% sub_processor PROCTHROTTLEMIN 5 >nul 2>&1
powercfg -setdcvalueindex %NEXO_ECO_GUID% sub_processor PROCTHROTTLEMAX 75 >nul 2>&1
powercfg -setdcvalueindex %NEXO_ECO_GUID% sub_processor PERFBOOSTMODE 0 >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v "Attributes" /t REG_DWORD /d 2 /f >nul 2>&1
powercfg -setdcvalueindex %NEXO_ECO_GUID% 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 0 >nul 2>&1
powercfg -setdcvalueindex %NEXO_ECO_GUID% sub_pciexpress aspm 2 >nul 2>&1
powercfg -setdcvalueindex %NEXO_ECO_GUID% 54533251-82be-4824-96c1-47b60b740d00 94D3A615-A899-4AC5-AD2C-96D587C4A8D9 0 >nul 2>&1
echo  [OK] Plan "Ahorro Inteligente El Nexo" activado.

echo.
echo  [PASO 3/8] Reduciendo efectos visuales...
echo.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] Transparencias desactivadas.

echo.
echo  [PASO 4/8] Limitando aplicaciones en segundo plano...
echo.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d 2 /f >nul 2>&1
echo  [OK] Apps de fondo controladas.

echo.
echo  [PASO 5/8] Activando brillo adaptativo...
echo.
powercfg -setdcvalueindex %NEXO_ECO_GUID% 7516b95f-f776-4464-8c53-06167f40cc99 fbd9aa66-9553-4097-ba44-ed6e9d65eab8 1 >nul 2>&1
echo  [OK] Brillo adaptativo activado.

echo.
echo  [PASO 6/8] Activando throttling inteligente de CPU...
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PowerThrottlingOff" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] CPU reducira velocidad cuando no sea necesaria.

echo.
echo  [PASO 7/8] Desactivando indexacion en bateria...
echo.
sc stop WSearch >nul 2>&1
sc config WSearch start=demand >nul 2>&1
echo  [OK] Indexacion desactivada (ahorra CPU y IOPS del SSD).

echo.
echo  [PASO 8/8] Configurando red para ahorro...
echo.
for /l %%n in (0,1,9) do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\000%%n" /v "PnPCapabilities" /t REG_DWORD /d 16 /f >nul 2>&1
)
echo  [OK] Adaptadores de red en modo eco.

echo.
echo  ============================================================
echo   AHORRO DE BATERIA ACTIVADO
echo  ============================================================
echo.
echo   Cambios aplicados:
echo   - Plan ECO personalizado activo (CPU al 75%%)
echo   - Turbo Boost desactivado en bateria
echo   - Efectos visuales reducidos
echo   - Apps de fondo bloqueadas
echo   - Brillo adaptativo activado
echo   - Indexacion de disco desactivada
echo   - Red en modo eco
echo.
echo   NOTA: Para volver al maximo rendimiento ejecuta Max Power.
echo  ============================================================
echo.
start powercfg.cpl
echo.
echo  No es necesario reiniciar. Los cambios estan activos.
echo.
pause
exit
