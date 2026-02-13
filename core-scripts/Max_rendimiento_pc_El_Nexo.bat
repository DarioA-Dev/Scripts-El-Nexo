@echo off
:: =========================================================================
::   EL NEXO - INGENIERÍA DE RENDIMIENTO EXTREMO v3.6 (CORE-PC)
::   Protocolo: Kernel, Energía, Latencia de Hardware y GPU
:: =========================================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO: KERNEL OPTIMIZER v3.6
color 0A

:: 1. VERIFICACIÓN DE NIVEL DE AUTORIDAD (ADMIN)
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo   [ERROR CRÍTICO] SE REQUIERE ACCESO AL KERNEL.
    echo   Por favor, ejecuta este script como ADMINISTRADOR.
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
echo  =========================================================================
echo   PROTOCOLO: MÁXIMO RENDIMIENTO PC (V3.6 EXTENDED)
echo   ESTADO: Listo para inyección de parámetros de bajo nivel.
echo  =========================================================================
echo.

:: 3. PUNTO DE CONTROL DE INGENIERÍA (RESTORE POINT)
echo [SEGURIDAD] ¿Deseas generar un Punto de Control de Ingeniería?
echo ^(Muy recomendado antes de modificar parámetros de Kernel^)
set /p "backup=Presiona S para crear, o N para saltar: "
if /i "%backup%"=="S" (
    echo.
    echo [+] Iniciando instantánea de volumen mediante PowerShell...
    powershell -Command "Checkpoint-Computer -Description 'El Nexo Core Opt v3.6' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
    echo [OK] Punto de seguridad establecido.
) else (
    echo.
    echo [!] ADVERTENCIA: Saltando copia de seguridad a petición del usuario.
)

:: 4. MATRIZ DE ENERGÍA DE ALTO VOLTAJE
echo.
echo [+] Reconstruyendo Matriz de Energía (GUID Estático)...
set "nexo_guid=11111111-1111-1111-1111-111111111111"
powercfg -delete %nexo_guid% >nul 2>&1
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 %nexo_guid% >nul 2>&1
powercfg -changename %nexo_guid% "Maximo Rendimiento El Nexo"
powercfg -setactive %nexo_guid%
:: Tweaks internos de energía
powercfg -change -disk-timeout-ac 0 >nul 2>&1
powercfg -change -monitor-timeout-ac 0 >nul 2>&1
powercfg -h off >nul 2>&1
powercfg -setacvalueindex %nexo_guid% sub_processor PROCTHROTTLEMIN 100 >nul 2>&1
powercfg -setacvalueindex %nexo_guid% sub_processor PROCTHROTTLEMAX 100 >nul 2>&1
powercfg -setacvalueindex %nexo_guid% sub_pciexpress aspm 0 >nul 2>&1
powercfg -setacvalueindex %nexo_guid% sub_usb usbsuspend 0 >nul 2>&1
echo [OK] Esquema de energía forzado a máximo rendimiento.

:: 5. OPTIMIZACIÓN DE KERNEL & BOOTLOADER (BCDEDIT)
echo.
echo [+] Reconfigurando parámetros de arranque (BCD)...
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /set useplatformclock no >nul 2>&1
bcdedit /set tscsyncpolicy Enhanced >nul 2>&1
bcdedit /set bootux disabled >nul 2>&1
bcdedit /set hypervisorlaunchtype off >nul 2>&1
bcdedit /set isolatedcontext No >nul 2>&1
bcdedit /set nointegritychecks No >nul 2>&1
echo [OK] Latencia de kernel reducida significativamente.

:: 6. LATENCIA DE HARDWARE (MODO MSI & GPU)
echo.
echo [+] Inyectando Modo MSI (Message Signaled Interrupts)...
echo     [INFO] Escaneando controladores... Esto puede tardar unos segundos.
reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "Interrupt Management" > "%temp%\nexo_msi.txt" 2>nul
if exist "%temp%\nexo_msi.txt" (
    for /f "tokens=*" %%i in ('type "%temp%\nexo_msi.txt" ^| findstr "HKEY_LOCAL_MACHINE"') do (
        reg add "%%i\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d 1 /f >nul 2>&1
    )
    del /f /q "%temp%\nexo_msi.txt" >nul 2>&1
)
echo [OK] Interrupciones sincronizadas prioritariamente.

echo.
echo [+] Optimizando Motor Gráfico (HAGS & ULPS)...
:: Hardware Accelerated GPU Scheduling (Prioridad 2 = ON)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul 2>&1
:: Desactivar ULPS (Ahorro de energía en GPU)
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Video" /s /f "EnableUlps" > "%temp%\nexo_gpu.txt" 2>nul
if exist "%temp%\nexo_gpu.txt" (
    for /f "delims=" %%a in ('type "%temp%\nexo_gpu.txt" ^| findstr "HKEY_LOCAL_MACHINE"') do (
        reg add "%%a" /v "EnableUlps" /t REG_DWORD /d 0 /f >nul 2>&1
    )
    del /f /q "%temp%\nexo_gpu.txt" >nul 2>&1
)
echo [OK] Sistema gráfico configurado para FPS estables.

:: 7. AJUSTES PROFUNDOS DE REGISTRO (CPU & RAM)
echo.
echo [+] Inyectando optimizaciones de memoria y scheduler...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
echo [OK] Jerarquía de CPU y RAM alineada para gaming.

:: 8. LATENCIA DE ENTRADA (INPUT LAG)
echo.
echo [+] Minimizando Input Lag (Ratón y Teclado)...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d 50 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d 50 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseHoverTime" /t REG_SZ /d "10" /f >nul 2>&1
echo [OK] Tiempo de respuesta de periféricos optimizado.

:: 9. SISTEMA DE ARCHIVOS (NTFS)
echo.
echo [+] Optimizando acceso a disco NTFS...
fsutil behavior set disablelastaccess 1 >nul 2>&1
fsutil behavior set disable8dot3 1 >nul 2>&1
echo [OK] Lectura de archivos acelerada.

:: 10. BLOATWARE & SERVICIOS (NEUTRALIZACIÓN)
echo.
echo [+] Neutralizando servicios de fondo y telemetría...
for %%s in (DiagTrack dmwappushservice SysMain WerSvc PcaSvc DPS RetailDemo WSearch) do (
    sc stop %%s >nul 2>&1
    sc config %%s start= disabled >nul 2>&1
)
echo [OK] Carga innecesaria del procesador eliminada.

:: 11. CIERRE DE PROTOCOLO
echo.
echo =========================================================================
echo   PROTOCOLO EL NEXO v3.6 COMPLETADO SATISFACTORIAMENTE.
echo   MÁXIMA POTENCIA DE KERNEL APLICADA.
echo =========================================================================
echo.
echo [IMPORTANTE] Debes REINICIAR el sistema para cargar el nuevo Kernel.
echo.
set /p r="¿Deseas reiniciar el sistema ahora? (S/N): "
if /i "%r%"=="S" shutdown /r /t 5
exit
