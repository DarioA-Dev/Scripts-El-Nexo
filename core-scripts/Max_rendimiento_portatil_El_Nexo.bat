@echo off
chcp 65001 >nul
title RENDIMIENTO PORTATIL - EL NEXO v3.6
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
echo   PORTÁTIL - RENDIMIENTO OPTIMO
echo ========================================
echo.

:: Plan de energia
echo [1/4] Creando plan de energia personalizado...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 22222222-2222-2222-2222-222222222222 >nul 2>&1
powercfg -changename 22222222-2222-2222-2222-222222222222 "Optimizacion Portatil El Nexo" >nul 2>&1
powercfg -setactive 22222222-2222-2222-2222-222222222222 >nul 2>&1
echo OK

:: Turbo Boost (seguro termicamente)
echo [2/4] Desbloqueando Turbo Boost (5%% min para enfriamiento)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v "Attributes" /t REG_DWORD /d 2 /f >nul 2>&1
powercfg -setacvalueindex 22222222-2222-2222-2222-222222222222 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 2 >nul 2>&1
powercfg -setacvalueindex 22222222-2222-2222-2222-222222222222 54533251-82be-4824-96c1-47b60b740d00 893434c-01ed-4d00-8805-0c7ed2b904d9 5 >nul 2>&1
powercfg -setacvalueindex 22222222-2222-2222-2222-222222222222 54533251-82be-4824-96c1-47b60b740d00 bc5038f0-0a87-4fb1-a738-5c41205631cc 100 >nul 2>&1
echo OK

:: Red Wi-Fi
echo [3/4] Desactivando ahorro de energia en Wi-Fi...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0000" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0001" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1
echo OK

:: Registro
echo [4/4] Optimizando sistema...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PowerThrottlingOff" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul 2>&1
echo OK

echo.
echo ========================================
echo   OPTIMIZACION COMPLETADA
echo ========================================
echo.
echo [IMPORTANTE] Mantén el portátil enchufado
echo para obtener máximo rendimiento.
echo.
pause
