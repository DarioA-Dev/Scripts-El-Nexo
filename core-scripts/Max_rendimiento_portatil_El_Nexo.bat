@echo off
chcp 65001 >nul
title EL NEXO - RENDIMIENTO PORTÁTIL
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
echo          PROTOCOLO PORTÁTIL: EL NEXO v3.6
echo ======================================================

:: PUNTO DE RESTAURACIÓN
echo.
set /p "backup=¿Crear Punto de Restauración? (S/N): "
if /i "%backup%"=="S" (
    echo [+] Creando punto de restauración...
    wmic /namespace:\\root\default path SystemRestore call CreateRestorePoint "Portátil Nexo", 100, 12 >nul 2>&1
    echo [OK] Punto creado.
)

:: PLAN DE ENERGÍA
echo.
echo [+] Creando plan de energía...
set "nexo_lp_guid=22222222-2222-2222-2222-222222222222"
powercfg -delete %nexo_lp_guid% >nul 2>&1
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 %nexo_lp_guid% >nul 2>&1
powercfg -changename %nexo_lp_guid% "Optimización Portátil El Nexo"
powercfg -setactive %nexo_lp_guid%

:: TURBO BOOST Y TÉRMICA
echo.
echo [+] Configurando CPU...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v "Attributes" /t REG_DWORD /d 2 /f >nul 2>&1
powercfg -setacvalueindex %nexo_lp_guid% 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 2 >nul 2>&1
powercfg -setacvalueindex %nexo_lp_guid% 54533251-82be-4824-96c1-47b60b740d00 94D3A615-A899-4AC5-AD2C-96D587C4A8D9 1 >nul 2>&1
powercfg -setacvalueindex %nexo_lp_guid% 54533251-82be-4824-96c1-47b60b740d00 893434c-01ed-4d00-8805-0c7ed2b904d9 5 >nul 2>&1
powercfg -setacvalueindex %nexo_lp_guid% 54533251-82be-4824-96c1-47b60b740d00 bc5038f0-0a87-4fb1-a738-5c41205631cc 100 >nul 2>&1
echo [OK] CPU configurada (Turbo activo, Mín 5%%).

:: MSI MODE (SIN POWERSHELL)
echo.
echo [+] Activando MSI...
reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "Interrupt Management" > "%temp%\msi_laptop.txt" 2>nul
if exist "%temp%\msi_laptop.txt" (
    for /f "tokens=*" %%i in ('type "%temp%\msi_laptop.txt" ^| findstr "HKEY_LOCAL_MACHINE"') do (
        reg add "%%i\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d 1 /f >nul 2>&1
    )
    del /f /q "%temp%\msi_laptop.txt" >nul 2>&1
)
echo [OK] MSI activado.

:: RED WI-FI
echo.
echo [+] Optimizando adaptadores Wi-Fi...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0000" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0001" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0002" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1
echo [OK] Wi-Fi optimizado.

:: REGISTRO
echo.
echo [+] Optimizando sistema...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PowerThrottlingOff" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul 2>&1
echo [OK] Sistema optimizado.

echo.
echo ======================================================
echo    PROTOCOLO COMPLETADO
echo ======================================================
echo Mantén el portátil CONECTADO A LA CORRIENTE
echo para máximo rendimiento.
echo.
set /p r="¿Reiniciar ahora? (S/N): "
if /i "%r%"=="S" shutdown /r /t 5
exit
