@echo off
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO v5.0 - MAX POWER
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
echo   PROTOCOLO: MAX POWER [DETECCION AUTOMATICA PC / LAPTOP]
echo   VERSION: 5.0
echo  ============================================================
echo.

:: DETECCION PC / LAPTOP via WMI (metodo mas fiable que powercfg /batteryreport)
echo  [DETECCION] Identificando tipo de dispositivo...
echo.
set "DEVICE_TYPE=PC"
set "DEVICE_NAME=PC de Escritorio"

for /f "skip=1 tokens=*" %%b in ('wmic path win32_battery get BatteryStatus 2^>nul') do (
    set "BAT_LINE=%%b"
    if not "!BAT_LINE!"=="" if not "!BAT_LINE!"=="  " (
        set "DEVICE_TYPE=LAPTOP"
        set "DEVICE_NAME=Portatil / Laptop"
    )
)

if "%DEVICE_TYPE%"=="PC" (
    color 0E
    echo  [PC] Perfil: MAXIMO RENDIMIENTO ABSOLUTO
) else (
    echo  [LAPTOP] Perfil: ALTO RENDIMIENTO OPTIMIZADO
)
echo.

:: PUNTO DE RESTAURACION
echo  [PASO 1/10] Creando punto de restauracion...
echo.
set /p "backup=Deseas crear un respaldo antes de continuar? (S/N): "
if /i "%backup%"=="S" (
    powershell -Command "Checkpoint-Computer -Description 'El Nexo Max Power' -RestorePointType 'MODIFY_SETTINGS'" 2>nul
    if !errorlevel! equ 0 (echo  [OK] Punto creado.) else (echo  [!] No se pudo crear. Continuando...)
) else (
    echo  [!] Saltando respaldo.
)
color 0B

:: PLAN DE ENERGIA
echo.
echo  [PASO 2/10] Creando plan de energia personalizado...
echo.
if "%DEVICE_TYPE%"=="PC" (
    set "NEXO_GUID=11111111-1111-1111-1111-111111111111"
    set "PLAN_NOMBRE=Maximo Rendimiento El Nexo"
    set "PLAN_DESC=Plan optimizado para gaming extremo en PC"
) else (
    set "NEXO_GUID=22222222-2222-2222-2222-222222222222"
    set "PLAN_NOMBRE=Alto Rendimiento El Nexo"
    set "PLAN_DESC=Plan optimizado para laptops gaming"
)
powercfg -delete %NEXO_GUID% >nul 2>&1
powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c %NEXO_GUID% >nul 2>&1
powercfg -changename %NEXO_GUID% "%PLAN_NOMBRE%" "%PLAN_DESC%" >nul 2>&1
powercfg -setactive %NEXO_GUID%
powercfg -change -monitor-timeout-ac 0 >nul 2>&1
powercfg -change -disk-timeout-ac 0 >nul 2>&1
powercfg -change -standby-timeout-ac 0 >nul 2>&1
if "%DEVICE_TYPE%"=="PC" (
    powercfg -setacvalueindex %NEXO_GUID% sub_processor PROCTHROTTLEMIN 100 >nul 2>&1
    powercfg -setacvalueindex %NEXO_GUID% sub_processor PROCTHROTTLEMAX 100 >nul 2>&1
    powercfg -setacvalueindex %NEXO_GUID% sub_processor CPMINCORES 100 >nul 2>&1
    powercfg -h off >nul 2>&1
) else (
    powercfg -setacvalueindex %NEXO_GUID% sub_processor PROCTHROTTLEMIN 95 >nul 2>&1
    powercfg -setacvalueindex %NEXO_GUID% sub_processor PROCTHROTTLEMAX 100 >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v "Attributes" /t REG_DWORD /d 2 /f >nul 2>&1
    powercfg -setacvalueindex %NEXO_GUID% 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 2 >nul 2>&1
    powercfg -setacvalueindex %NEXO_GUID% 54533251-82be-4824-96c1-47b60b740d00 94D3A615-A899-4AC5-AD2C-96D587C4A8D9 1 >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PowerThrottlingOff" /t REG_DWORD /d 1 /f >nul 2>&1
)
powercfg -setacvalueindex %NEXO_GUID% sub_processor PERFBOOSTMODE 2 >nul 2>&1
powercfg -setacvalueindex %NEXO_GUID% sub_pciexpress aspm 0 >nul 2>&1
powercfg -setacvalueindex %NEXO_GUID% sub_usb usbsuspend 0 >nul 2>&1
echo  [OK] Plan "%PLAN_NOMBRE%" activado.

:: KERNEL Y BOOTLOADER
echo.
echo  [PASO 3/10] Optimizando parametros del kernel...
echo.
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /set useplatformclock no >nul 2>&1
bcdedit /set tscsyncpolicy Enhanced >nul 2>&1
bcdedit /set bootux disabled >nul 2>&1
bcdedit /set x2apicpolicy Enable >nul 2>&1
bcdedit /set hypervisorlaunchtype off >nul 2>&1
echo  [OK] Kernel configurado para minima latencia.

:: MSI MODE
echo.
echo  [PASO 4/10] Activando MSI Mode en dispositivos PCI...
echo.
set "msi_temp=%temp%\nexo_msi_%random%.txt"
reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "Interrupt Management" >"%msi_temp%" 2>nul
if exist "%msi_temp%" (
    for /f "tokens=*" %%i in ('type "%msi_temp%" ^| findstr /I "HKEY_LOCAL_MACHINE"') do (
        reg add "%%i\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d 1 /f >nul 2>&1
    )
    del /f /q "%msi_temp%" >nul 2>&1
)
echo  [OK] MSI Mode activado en GPU, red y almacenamiento.

:: GPU
echo.
echo  [PASO 5/10] Optimizando GPU...
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d 5 /f >nul 2>&1
set "gpu_temp=%temp%\nexo_gpu_%random%.txt"
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Video" /s /f "EnableUlps" >"%gpu_temp%" 2>nul
if exist "%gpu_temp%" (
    for /f "tokens=*" %%a in ('type "%gpu_temp%" ^| findstr /I "HKEY_LOCAL_MACHINE"') do (
        reg add "%%a" /v "EnableUlps" /t REG_DWORD /d 0 /f >nul 2>&1
    )
    del /f /q "%gpu_temp%" >nul 2>&1
)
echo  [OK] GPU: HAGS activo, ULPS off, MPO off.

:: CPU Y RAM
echo.
echo  [PASO 6/10] Ajustando prioridades de CPU y memoria...
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
echo  [OK] CPU y RAM priorizados.

:: LATENCIA DE ENTRADA
echo.
echo  [PASO 7/10] Reduciendo latencia de perifericos...
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d 20 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d 20 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseHoverTime" /t REG_SZ /d "8" /f >nul 2>&1
echo  [OK] Perifericos con respuesta minima.

:: SISTEMA DE ARCHIVOS
echo.
echo  [PASO 8/10] Optimizando sistema de archivos...
echo.
fsutil behavior set disablelastaccess 1 >nul 2>&1
fsutil behavior set disable8dot3 1 >nul 2>&1
fsutil behavior set memoryusage 2 >nul 2>&1
echo  [OK] Sistema de archivos acelerado.

:: PRIORIDAD JUEGOS
echo.
echo  [PASO 9/10] Configurando prioridad de juegos en el scheduler...
echo.
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1
echo  [OK] GPU Priority 8, Scheduling Category High.

:: SERVICIOS
echo.
echo  [PASO 10/10] Desactivando servicios innecesarios...
echo.
for %%s in (DiagTrack dmwappushservice WerSvc PcaSvc DPS RetailDemo SysMain) do (
    sc stop %%s >nul 2>&1
    sc config %%s start=disabled >nul 2>&1
)
echo  [OK] Telemetria y Superfetch desactivados.

echo.
echo  ============================================================
echo   MAX POWER COMPLETADO
echo  ============================================================
echo.
echo   Dispositivo: %DEVICE_NAME%
echo   Plan activo: %PLAN_NOMBRE%
echo.
echo   Cambios aplicados:
echo   - Plan de energia personalizado activo
echo   - Kernel con minima latencia (requiere reinicio)
echo   - MSI Mode en dispositivos PCI
echo   - GPU: HAGS activo, ULPS off, MPO off
echo   - Scheduler: GPU Priority 8, High
echo   - Telemetria y Superfetch desactivados
echo.
if "%DEVICE_TYPE%"=="LAPTOP" echo   RECORDATORIO: Conecta el cargador para maximo rendimiento.
echo.
echo   IMPORTANTE: Reinicia el PC para aplicar los cambios del kernel.
echo  ============================================================
echo.
start powercfg.cpl
set /p "reboot=Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando Max Power El Nexo..."
exit
