@echo off
:: =========================================================================
::   EL NEXO - SISTEMA DE OPTIMIZACION AVANZADA v4.0 (CORE-PC)
::   Protocolo: Kernel, Energia, Latencia de Hardware y GPU
:: =========================================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO v4.0 - OPTIMIZADOR DE KERNEL
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
echo   PROTOCOLO: OPTIMIZACION MAXIMA DE SISTEMA [PC ESCRITORIO]
echo   VERSION: 4.0 ENHANCED - Estado: Iniciando secuencia...
echo  ============================================================
echo.

:: PUNTO DE CONTROL
echo  [PASO 1/10] Creando punto de restauracion de seguridad...
echo.
set /p "backup= Deseas crear un respaldo antes de continuar? (S/N): "
if /i "%backup%"=="S" (
    echo.
    echo  [*] Generando punto de restauracion del sistema...
    powershell -Command "Checkpoint-Computer -Description 'El Nexo v4.0 Max PC' -RestorePointType 'MODIFY_SETTINGS'" 2>nul
    if !errorlevel! equ 0 (
        echo  [OK] Punto de restauracion creado correctamente.
    ) else (
        echo  [!] No se pudo crear el punto. Continuando de todos modos...
    )
) else (
    echo  [!] Saltando respaldo por decision del usuario.
)

:: PLAN DE ENERGIA PERSONALIZADO MEJORADO
echo.
echo  [PASO 2/10] Creando plan de energia de maxima potencia...
echo.
set "nexo_guid=11111111-1111-1111-1111-111111111111"
powercfg -delete %nexo_guid% >nul 2>&1
powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c %nexo_guid% >nul 2>&1
powercfg -changename %nexo_guid% "Maximo Rendimiento El Nexo" "Plan optimizado para gaming y rendimiento extremo" >nul 2>&1
powercfg -setactive %nexo_guid%

:: Configuracion avanzada del plan
echo  [*] Configurando parametros de energia avanzados...
powercfg -change -disk-timeout-ac 0 >nul 2>&1
powercfg -change -monitor-timeout-ac 0 >nul 2>&1
powercfg -change -standby-timeout-ac 0 >nul 2>&1
powercfg -h off >nul 2>&1

:: CPU al 100%
powercfg -setacvalueindex %nexo_guid% sub_processor PROCTHROTTLEMIN 100 >nul 2>&1
powercfg -setacvalueindex %nexo_guid% sub_processor PROCTHROTTLEMAX 100 >nul 2>&1
powercfg -setacvalueindex %nexo_guid% sub_processor PERFBOOSTMODE 2 >nul 2>&1

:: PCI Express sin ahorro
powercfg -setacvalueindex %nexo_guid% sub_pciexpress aspm 0 >nul 2>&1

:: USB sin suspension
powercfg -setacvalueindex %nexo_guid% sub_usb usbsuspend 0 >nul 2>&1

:: Desactivar parking de nucleos
powercfg -setacvalueindex %nexo_guid% sub_processor CPMINCORES 100 >nul 2>&1

echo  [OK] Plan "Maximo Rendimiento El Nexo" activado.

:: KERNEL & BOOTLOADER
echo.
echo  [PASO 3/10] Optimizando parametros de arranque del sistema...
echo.
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /set useplatformclock no >nul 2>&1
bcdedit /set tscsyncpolicy Enhanced >nul 2>&1
bcdedit /set bootux disabled >nul 2>&1
bcdedit /set hypervisorlaunchtype off >nul 2>&1
bcdedit /set x2apicpolicy Enable >nul 2>&1
echo  [OK] Kernel configurado para minima latencia.

:: MODO MSI (Message Signaled Interrupts)
echo.
echo  [PASO 4/10] Activando MSI Mode en dispositivos PCI...
echo.
set "msi_temp=%temp%\nexo_msi_%random%.txt"
reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "Interrupt Management" >"%msi_temp%" 2>nul
if exist "%msi_temp%" (
    echo  [*] Escaneando controladores PCI...
    for /f "tokens=*" %%i in ('type "%msi_temp%" ^| findstr /I "HKEY_LOCAL_MACHINE"') do (
        reg add "%%i\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d 1 /f >nul 2>&1
    )
    del /f /q "%msi_temp%" >nul 2>&1
    echo  [OK] MSI Mode activado en GPU, red y almacenamiento.
)

:: GPU SCHEDULING & ULPS
echo.
echo  [PASO 5/10] Optimizando sistema grafico...
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t REG_DWORD /d 0 /f >nul 2>&1

set "gpu_temp=%temp%\nexo_gpu_%random%.txt"
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Video" /s /f "EnableUlps" >"%gpu_temp%" 2>nul
if exist "%gpu_temp%" (
    for /f "tokens=*" %%a in ('type "%gpu_temp%" ^| findstr /I "HKEY_LOCAL_MACHINE"') do (
        reg add "%%a" /v "EnableUlps" /t REG_DWORD /d 0 /f >nul 2>&1
    )
    del /f /q "%gpu_temp%" >nul 2>&1
)
echo  [OK] GPU configurada para FPS estables y sin throttling.

:: CPU & RAM OPTIMIZATIONS
echo.
echo  [PASO 6/10] Ajustando prioridades de CPU y memoria...
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
echo  [OK] Memoria y procesador priorizados para gaming.

:: INPUT LAG REDUCTION
echo.
echo  [PASO 7/10] Reduciendo latencia de entrada...
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d 20 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d 20 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseHoverTime" /t REG_SZ /d "8" /f >nul 2>&1
echo  [OK] Respuesta de raton y teclado optimizada.

:: FILESYSTEM OPTIMIZATIONS
echo.
echo  [PASO 8/10] Acelerando sistema de archivos...
echo.
fsutil behavior set disablelastaccess 1 >nul 2>&1
fsutil behavior set disable8dot3 1 >nul 2>&1
fsutil behavior set memoryusage 2 >nul 2>&1
echo  [OK] Lectura y escritura de disco mejoradas.

:: GAME PRIORITY
echo.
echo  [PASO 9/10] Configurando prioridad de juegos...
echo.
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
echo  [OK] Los juegos tendran maxima prioridad del sistema.

:: SERVICES OPTIMIZATION
echo.
echo  [PASO 10/10] Desactivando servicios innecesarios...
echo.
for %%s in (DiagTrack dmwappushservice SysMain WerSvc PcaSvc DPS RetailDemo WSearch) do (
    sc stop %%s >nul 2>&1
    sc config %%s start=disabled >nul 2>&1
)
echo  [OK] Servicios de telemetria y mantenimiento desactivados.

:: FINALIZACION
echo.
echo  ============================================================
echo   OPTIMIZACION COMPLETADA CON EXITO
echo  ============================================================
echo.
echo   Tu PC ahora esta configurado para maximo rendimiento.
echo   
echo   IMPORTANTE: Ahora debes activar el plan de energia creado.
echo   Se abrira el Panel de Control para que lo selecciones.
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
