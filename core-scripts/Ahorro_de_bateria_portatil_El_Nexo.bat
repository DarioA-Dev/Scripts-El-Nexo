@echo off
chcp 65001 >nul
title AHORRO DE BATERIA - EL NEXO v3.6
color 0A

:: Verificar Admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo [ERROR] Acceso Denegado
    echo Haz clic derecho ^> Ejecutar como administrador
    echo.
    pause
    exit
)

cls
echo ========================================
echo   AHORRO EXTREMO DE BATERIA
echo ========================================
echo.

:: Plan Eco
echo [1/5] Creando plan de ahorro...
powercfg -duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e 33333333-3333-3333-3333-333333333333 >nul 2>&1
powercfg -changename 33333333-3333-3333-3333-333333333333 "Ahorro Extremo El Nexo" >nul 2>&1
powercfg -setactive 33333333-3333-3333-3333-333333333333 >nul 2>&1
echo OK

:: Capar CPU al 70%%
echo [2/5] Limitando CPU al 70%%...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v "Attributes" /t REG_DWORD /d 2 /f >nul 2>&1
powercfg -setdcvalueindex 33333333-3333-3333-3333-333333333333 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 0 >nul 2>&1
powercfg -setdcvalueindex 33333333-3333-3333-3333-333333333333 54533251-82be-4824-96c1-47b60b740d00 bc5038f0-0a87-4fb1-a738-5c41205631cc 70 >nul 2>&1
echo OK

:: Power Throttling
echo [3/5] Activando Power Throttling...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PowerThrottlingOff" /t REG_DWORD /d 0 /f >nul 2>&1
echo OK

:: Visuales
echo [4/5] Desactivando transparencias...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f >nul 2>&1
echo OK

:: Reposo
echo [5/5] Configurando reposo agresivo...
powercfg -change -monitor-timeout-dc 2 >nul 2>&1
powercfg -change -standby-timeout-dc 5 >nul 2>&1
powercfg -h on >nul 2>&1
echo OK

echo.
echo ========================================
echo   AHORRO ACTIVADO
echo ========================================
echo.
echo El sistema ahora priorizara autonomia.
echo Es normal notar perdida de rendimiento.
echo.
pause