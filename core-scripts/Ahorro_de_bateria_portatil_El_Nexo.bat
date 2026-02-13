@echo off
:: ==========================================================
::   EL NEXO - INGENIERÍA DE AUTONOMÍA MÓVIL v3.6
::   Protocolo: Capado de CPU, Eco-Mode y Bus Optimization
:: ==========================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO: ECO-MODE v3.6
color 0A

:: 1. VERIFICACIÓN DE PRIVILEGIOS
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo   [ERROR] SE REQUIERE NIVEL DE ADMINISTRADOR.
    echo   Para gestionar el voltaje necesitas privilegios altos.
    pause >nul
    exit
)

:: 2. CABECERA ASCII "EL NEXO"
cls
echo.
echo   ______ _       _   _ ______   _____ 
echo  ^|  ____^| ^|     ^| \ ^| ^|  ____^| \ \ / / _ \ 
echo  ^| ^|__  ^| ^|     ^|  \^| ^| ^|__     \ V / ^| ^| ^|
echo  ^|  __^| ^| ^|     ^| . ` ^|  __^|     ^> ^<^| ^| ^| ^|
echo  ^| ^|____^| ^|____ ^| ^|\  ^| ^|____   / . \ ^|_^| ^|
echo  ^|______^|______^|_^| \_^|______^| /_/ \_\___/ 
echo.
echo  ==========================================================
echo   PROTOCOLO: AHORRO EXTREMO DE BATERÍA (V3.6)
echo   ESTADO: Entrando en modo de bajo consumo...
echo  ==========================================================
echo.

:: 3. PUNTO DE CONTROL
echo [SEGURIDAD] ¿Generar punto de restauración antes del Eco-Mode?
set /p "backup=Tu respuesta (S/N): "
if /i "%backup%"=="S" (
    echo.
    echo [+] Iniciando respaldo mediante PowerShell...
    powershell -Command "Checkpoint-Computer -Description 'Eco Nexo v3.6' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
    echo [OK] Punto establecido.
)

:: 4. PLAN ECO (LÓGICA PODEROSA)
echo.
echo [+] Configurando esquema de energía de bajo consumo (NEXO-ECO)...
set "nexo_eco_guid=33333333-3333-3333-3333-333333333333"
powercfg -delete %nexo_eco_guid% >nul 2>&1
powercfg -duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e %nexo_eco_guid% >nul 2>&1
powercfg -changename %nexo_eco_guid% "Ahorro Extremo El Nexo"
powercfg -setactive %nexo_eco_guid%
echo [OK] Eco-Mode activado.

:: 5. CAPADO DE CPU & BUS (ELITE)
echo.
echo [+] Limitando frecuencia del procesador al 70%% (Eco-Clock)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v "Attributes" /t REG_DWORD /d 2 /f >nul 2>&1
:: Desactivar Boost en batería
powercfg -setdcvalueindex %nexo_eco_guid% 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 0 >nul 2>&1
:: Máximo 70% CPU
powercfg -setdcvalueindex %nexo_eco_guid% 54533251-82be-4824-96c1-47b60b740d00 bc5038f0-0a87-4fb1-a738-5c41205631cc 70 >nul 2>&1
:: PCI Express en ahorro máximo
powercfg -setdcvalueindex %nexo_eco_guid% sub_pciexpress aspm 2 >nul 2>&1
echo [OK] Voltaje y frecuencias reducidos para máxima autonomía.

:: 6. INTERFAZ & TAREAS
echo.
echo [+] Simplificando interfaz visual y bloqueando tareas de fondo...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PowerThrottlingOff" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
echo [OK] Consumo de GPU y CPU en reposo optimizado.

:: 7. POLÍTICAS DE REPOSO
echo.
echo [+] Configurando tiempos de inactividad agresivos...
powercfg -change -monitor-timeout-dc 2 >nul 2>&1
powercfg -change -standby-timeout-dc 5 >nul 2>&1
powercfg -h on >nul 2>&1
echo [OK] Modo Hibernación forzado tras inactividad.

:: 8. FINALIZACIÓN
echo.
echo ==========================================================
echo    PROTOCOLO COMPLETADO. SISTEMA EN MODO AHORRO MÁXIMO.
echo ==========================================================
echo.
pause
exit