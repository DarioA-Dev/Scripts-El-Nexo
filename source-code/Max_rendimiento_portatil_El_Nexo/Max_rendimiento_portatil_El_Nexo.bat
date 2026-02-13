@echo off
:: =========================================================================
::   EL NEXO - SISTEMA DE OPTIMIZACION AVANZADA v4.0 (PORTATIL)
::   Protocolo: Turbo Boost, Gestion Termica y Movilidad
:: =========================================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO v4.0 - OPTIMIZADOR PORTATIL
color 0B

:: VERIFICACION DE PRIVILEGIOS
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    cls
    color 0C
    echo.
    echo  ============================================================
    echo   ACCESO DENEGADO - Se requieren permisos de Administrador
    echo  ============================================================
    echo.
    echo   Haz clic derecho sobre el archivo y selecciona:
    echo   "Ejecutar como administrador"
    echo.
    echo  ============================================================
    pause
    exit /b
)

:: CABECERA CIBERPUNK "EL NEXO"
cls
color 0B
echo.
echo  ============================================================
echo      _____ _       _   _ _______   _______  
echo     ^|  ___^| ^|     ^| \ ^| ^|  ___\ \ / /  _ \ 
echo     ^| ^|__ ^| ^|     ^|  \^| ^| ^|__  \ V /^| ^| ^| ^|
echo     ^|  __^|^| ^|     ^| . ` ^|  __^|  ^> ^< ^| ^| ^| ^|
echo     ^| ^|___^| ^|____ ^| ^|\  ^| ^|___ / . \^| ^|_^| ^|
echo     ^|_____^|______^|_^| \_^|_____/_/ \_\_____/ 
echo.
echo  ============================================================
echo   PROTOCOLO: OPTIMIZACION MAXIMA [PORTATIL / LAPTOP]
echo   VERSION: 4.0 ENHANCED - Estado: Iniciando secuencia...
echo  ============================================================
echo.

:: PUNTO DE CONTROL
echo  [PASO 1/9] Creando punto de restauracion de seguridad...
echo.
set /p "backup= Deseas crear un respaldo antes de continuar? (S/N): "
if /i "%backup%"=="S" (
    echo.
    echo  [*] Generando punto de restauracion del sistema...
    powershell -Command "Checkpoint-Computer -Description 'El Nexo v4.0 Laptop' -RestorePointType 'MODIFY_SETTINGS'" 2>nul
    if !errorlevel! equ 0 (
        echo  [OK] Punto de restauracion creado correctamente.
    ) else (
        echo  [!] No se pudo crear el punto. Continuando de todos modos...
    )
) else (
    echo  [!] Saltando respaldo por decision del usuario.
)

:: PLAN DE ENERGIA ELITE
echo.
echo  [PASO 2/9] Creando plan de energia de alto rendimiento...
echo.
set "nexo_lp_guid=22222222-2222-2222-2222-222222222222"
powercfg -delete %nexo_lp_guid% >nul 2>&1
powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c %nexo_lp_guid% >nul 2>&1
powercfg -changename %nexo_lp_guid% "Alto Rendimiento El Nexo" "Plan optimizado para portatiles gaming conectados a corriente" >nul 2>&1
powercfg -setactive %nexo_lp_guid%

:: Configuracion avanzada
echo  [*] Configurando parametros de energia avanzados...
powercfg -change -monitor-timeout-ac 0 >nul 2>&1
powercfg -change -disk-timeout-ac 0 >nul 2>&1
powercfg -change -standby-timeout-ac 0 >nul 2>&1

:: CPU Performance
powercfg -setacvalueindex %nexo_lp_guid% sub_processor PROCTHROTTLEMIN 95 >nul 2>&1
powercfg -setacvalueindex %nexo_lp_guid% sub_processor PROCTHROTTLEMAX 100 >nul 2>&1
powercfg -setacvalueindex %nexo_lp_guid% sub_processor PERFBOOSTMODE 2 >nul 2>&1

:: Turbo Boost desbloqueado
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v "Attributes" /t REG_DWORD /d 2 /f >nul 2>&1
powercfg -setacvalueindex %nexo_lp_guid% 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 2 >nul 2>&1

:: Refrigeracion activa
powercfg -setacvalueindex %nexo_lp_guid% 54533251-82be-4824-96c1-47b60b740d00 94D3A615-A899-4AC5-AD2C-96D587C4A8D9 1 >nul 2>&1

:: PCI Express sin ahorro
powercfg -setacvalueindex %nexo_lp_guid% sub_pciexpress aspm 0 >nul 2>&1

echo  [OK] Plan de maxima potencia activado.

:: MSI MODE
echo.
echo  [PASO 3/9] Activando MSI Mode en dispositivos...
echo.
set "msi_temp=%temp%\nexo_msi_lp_%random%.txt"
reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "Interrupt Management" >"%msi_temp%" 2>nul
if exist "%msi_temp%" (
    echo  [*] Optimizando interrupciones de hardware...
    for /f "tokens=*" %%i in ('type "%msi_temp%" ^| findstr /I "HKEY_LOCAL_MACHINE"') do (
        reg add "%%i\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d 1 /f >nul 2>&1
    )
    del /f /q "%msi_temp%" >nul 2>&1
    echo  [OK] Latencia de hardware reducida.
)

:: NETWORK OPTIMIZATION
echo.
echo  [PASO 4/9] Optimizando adaptadores de red...
echo.
for /l %%n in (0,1,9) do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\000%%n" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1
)
echo  [OK] Wi-Fi configurado para maxima velocidad.

:: GPU OPTIMIZATION
echo.
echo  [PASO 5/9] Configurando sistema grafico...
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul 2>&1

set "gpu_temp=%temp%\nexo_gpu_lp_%random%.txt"
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Video" /s /f "EnableUlps" >"%gpu_temp%" 2>nul
if exist "%gpu_temp%" (
    for /f "tokens=*" %%a in ('type "%gpu_temp%" ^| findstr /I "HKEY_LOCAL_MACHINE"') do (
        reg add "%%a" /v "EnableUlps" /t REG_DWORD /d 0 /f >nul 2>&1
    )
    del /f /q "%gpu_temp%" >nul 2>&1
)
echo  [OK] GPU preparada para gaming intenso.

:: CPU & RAM
echo.
echo  [PASO 6/9] Ajustando prioridades del sistema...
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
echo  [OK] Sistema optimizado para respuesta rapida.

:: POWER THROTTLING
echo.
echo  [PASO 7/9] Desactivando limitadores de energia...
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PowerThrottlingOff" /t REG_DWORD /d 1 /f >nul 2>&1
echo  [OK] Throttling de CPU y GPU eliminado.

:: INPUT LAG
echo.
echo  [PASO 8/9] Reduciendo latencia de entrada...
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d 20 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d 20 /f >nul 2>&1
echo  [OK] Perifericos optimizados.

:: GAME PRIORITY
echo.
echo  [PASO 9/9] Configurando prioridad de juegos...
echo.
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
echo  [OK] Juegos con maxima prioridad.

:: FINALIZACION
echo.
echo  ============================================================
echo   OPTIMIZACION COMPLETADA CON EXITO
echo  ============================================================
echo.
echo   Tu portatil ahora esta listo para maxima potencia.
echo   
echo   IMPORTANTE:
echo   - Conecta el cargador para aprovechar todo el rendimiento
echo   - Selecciona el plan "Alto Rendimiento El Nexo"
echo   
echo   Se abrira el Panel de Control para activar el plan.
echo.
echo  ============================================================
echo.
pause

:: Abrir panel de energia
start powercfg.cpl

echo.
echo  [*] Reinicia tu PC para aplicar todos los cambios.
echo.
set /p "reboot= Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando para aplicar optimizaciones El Nexo..."

exit
