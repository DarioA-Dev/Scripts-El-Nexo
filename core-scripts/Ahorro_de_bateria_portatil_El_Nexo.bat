@echo off
chcp 65001 >nul
title EL NEXO - AHORRO DE BATERÍA
color 0A
setlocal enabledelayedexpansion

:: ADMIN CHECK
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo [ERROR] Necesitas permisos de Administrador.
    echo Haz clic derecho ^> Ejecutar como administrador.
    pause >nul
    exit
)

echo ======================================================
echo          PROTOCOLO DE AUTONOMÍA: EL NEXO v3.6
echo ======================================================

:: PUNTO DE RESTAURACIÓN
echo.
set /p "backup=¿Crear Punto de Restauración? (S/N): "
if /i "%backup%"=="S" (
    echo [+] Creando punto de restauración...
    wmic /namespace:\\root\default path SystemRestore call CreateRestorePoint "Ahorro Batería Nexo", 100, 12 >nul 2>&1
)

:: PLAN ECO
echo.
echo [+] Creando plan de ahorro...
set "nexo_eco_guid=33333333-3333-3333-3333-333333333333"
powercfg -delete %nexo_eco_guid% >nul 2>&1
powercfg -duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e %nexo_eco_guid% >nul 2>&1
powercfg -changename %nexo_eco_guid% "Ahorro Extremo El Nexo"
powercfg -setactive %nexo_eco_guid%

:: CAPADO DE CPU
echo.
echo [+] Limitando CPU al 70%%...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v "Attributes" /t REG_DWORD /d 2 /f >nul 2>&1
powercfg -setdcvalueindex %nexo_eco_guid% 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 0 >nul 2>&1
powercfg -setdcvalueindex %nexo_eco_guid% 54533251-82be-4824-96c1-47b60b740d00 bc5038f0-0a87-4fb1-a738-5c41205631cc 70 >nul 2>&1
powercfg -setdcvalueindex %nexo_eco_guid% 54533251-82be-4824-96c1-47b60b740d00 94d3a615-a899-4ac5-ae2b-e4d8f634367f 0 >nul 2>&1

:: HARDWARE
echo [+] Optimizando hardware...
powercfg -setdcvalueindex %nexo_eco_guid% sub_pciexpress aspm 2 >nul 2>&1
powercfg -setdcvalueindex %nexo_eco_guid% sub_usb usbsuspend 1 >nul 2>&1
echo [OK] CPU limitada.

:: POWER THROTTLING
echo.
echo [+] Activando Power Throttling...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PowerThrottlingOff" /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Throttling activo.

:: VISUALES
echo.
echo [+] Simplificando interfaz...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d 9012028010000000 /f >nul 2>&1
echo [OK] Visuales simplificados.

:: REPOSO
echo.
echo [+] Configurando reposo...
powercfg -change -monitor-timeout-dc 2
powercfg -change -standby-timeout-dc 5
powercfg -h on >nul 2>&1
echo [OK] Reposo configurado.

:: APPS DE FONDO
echo.
echo [+] Bloqueando apps en segundo plano...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
echo [OK] Apps bloqueadas.

echo.
echo ======================================================
echo    PROTOCOLO COMPLETADO
echo ======================================================
echo El sistema ahora priorizará autonomía.
echo Es normal notar ligera pérdida de rendimiento.
echo.
pause
exit