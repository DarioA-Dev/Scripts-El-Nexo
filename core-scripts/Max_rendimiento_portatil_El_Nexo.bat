@echo off
:: ==========================================================
::   EL NEXO - INGENIERÍA DE RENDIMIENTO MÓVIL v3.6
::   Protocolo: Turbo Boost + Gestión Térmica
:: ==========================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO: RENDIMIENTO PORTÁTIL v3.6
color 0A

:: 1. VERIFICACIÓN DE AUTORIDAD (ADMIN)
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo   [ERROR] SE REQUIERE ACCESO AL KERNEL.
    echo   Haz clic derecho ^> Ejecutar como administrador.
    echo.
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
echo   PROTOCOLO: MÁXIMO RENDIMIENTO PORTÁTIL (V3.6)
echo   ESTADO: Analizando arquitectura térmica...
echo  ==========================================================
echo.

:: 3. PUNTO DE CONTROL
echo [SEGURIDAD] ¿Generar un Punto de Control de Ingeniería?
set /p "backup=Presiona S para crear, o N para saltar: "
if /i "%backup%"=="S" (
    echo.
    echo [+] Iniciando respaldo de configuración de sistema...
    powershell -Command "Checkpoint-Computer -Description 'Rendimiento Portatil Nexo' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
    echo [OK] Punto establecido.
)

:: 4. CREACIÓN DE PLAN "NEXO ELITE"
echo.
echo [+] Construyendo esquema de energía personalizado (NEXO-ELITE)...
set "nexo_lp_guid=22222222-2222-2222-2222-222222222222"
powercfg -delete %nexo_lp_guid% >nul 2>&1
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 %nexo_lp_guid% >nul 2>&1
powercfg -changename %nexo_lp_guid% "Optimización Portátil El Nexo"
powercfg -setactive %nexo_lp_guid%
echo [OK] Esquema activo y optimizado.

:: 5. DESBLOQUEO DE TURBO BOOST (AGRESIVO)
echo.
echo [+] Inyectando acceso a frecuencias Turbo (Processor Boost)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v "Attributes" /t REG_DWORD /d 2 /f >nul 2>&1
:: Modo Agresivo (Turbo constante en AC)
powercfg -setacvalueindex %nexo_lp_guid% 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 2 >nul 2>&1
echo [OK] Processor Performance Boost configurado en MODO AGRESIVO.

:: 6. SEGURIDAD TÉRMICA & ENFRIAMIENTO ACTIVO
echo.
echo [+] Aplicando directivas de refrigeración activa...
:: Refrigeración activa (Ventiladores prioridad 1)
powercfg -setacvalueindex %nexo_lp_guid% 54533251-82be-4824-96c1-47b60b740d00 94D3A615-A899-4AC5-AD2C-96D587C4A8D9 1 >nul 2>&1
:: Estado mínimo 5% (Permite idle cooldown)
powercfg -setacvalueindex %nexo_lp_guid% 54533251-82be-4824-96c1-47b60b740d00 8934347c-01ed-4d00-8805-0c7ed2b904d9 5 >nul 2>&1
:: Estado máximo 100%
powercfg -setacvalueindex %nexo_lp_guid% 54533251-82be-4824-96c1-47b60b740d00 bc5038f0-0a87-4fb1-a738-5c41205631cc 100 >nul 2>&1
echo [OK] Seguridad térmica configurada (Potencia equilibrada).

:: 7. MODO MSI (PORTÁTIL)
echo.
echo [+] Sincronizando Modo MSI en controladores PCI...
reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "Interrupt Management" > "%temp%\nexo_msi_lp.txt" 2>nul
if exist "%temp%\nexo_msi_lp.txt" (
    for /f "tokens=*" %%i in ('type "%temp%\nexo_msi_lp.txt" ^| findstr "HKEY_LOCAL_MACHINE"') do (
        reg add "%%i\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d 1 /f >nul 2>&1
    )
    del /f /q "%temp%\nexo_msi_lp.txt" >nul 2>&1
)
echo [OK] Latencia de hardware optimizada para movilidad.

:: 8. OPTIMIZACIÓN DE RED & PRIORIDAD
echo.
echo [+] Eliminando ahorro de energía en adaptadores Wi-Fi...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0000" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0001" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PowerThrottlingOff" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul 2>&1
echo [OK] Prioridades de sistema móvil establecidas.

:: 9. CIERRE
echo.
echo ==========================================================
echo    PROTOCOLO EL NEXO v3.6 COMPLETADO SATISFACTORIAMENTE.
echo    PORTÁTIL PREPARADO PARA MÁXIMA CARGA DE TRABAJO.
echo ==========================================================
echo.
echo [IMPORTANTE] Mantén el equipo CONECTADO A LA CORRIENTE.
echo.
set /p r="¿Deseas reiniciar ahora? (S/N): "
if /i "%r%"=="S" shutdown /r /t 5
exit
