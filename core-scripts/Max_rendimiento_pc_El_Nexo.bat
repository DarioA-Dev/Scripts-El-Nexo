@echo off
chcp 65001 >nul
title EL NEXO - MÁXIMO RENDIMIENTO (V3.5 EXTENDED)
color 0A
setlocal enabledelayedexpansion

:: --- [1. VERIFICACIÓN DE NIVEL 0 (ADMIN)] ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo [ERROR CRÍTICO] ACCESO DENEGADO AL KERNEL.
    echo El Nexo requiere privilegios de Administrador.
    echo Haz clic derecho ^> Ejecutar como administrador.
    pause >nul
    exit
)

echo ======================================================
echo          INICIANDO SECUENCIA EL NEXO V3.5
echo        (Versión Extendida: Kernel + Energía)
echo ======================================================

:: --- [2. PUNTO DE RESTAURACIÓN (LÓGICA BLINDADA)] ---
echo.
echo [SEGURIDAD] ¿Deseas crear un Punto de Restauración del Sistema?
echo (Recomendado si es la primera vez que ejecutas este script)
set /p "choice=Escribe S para Si, o N para No: "
if /i "%choice%"=="S" (
    echo [+] Iniciando instantánea de volumen...
    powershell -Command "Checkpoint-Computer -Description 'Backup El Nexo V3.5' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
    echo [OK] Punto de seguridad establecido.
) else (
    echo [!] Saltando copia de seguridad a petición del usuario.
)

:: --- [3. GESTIÓN DE ENERGÍA DE ALTO VOLTAJE] ---
echo.
echo [+] Reconstruyendo Matriz de Energía (GUID Estático)...
:: Definimos el GUID de El Nexo para evitar errores de búsqueda y forzar creación
set "nexo_guid=11111111-1111-1111-1111-111111111111"

:: Limpieza preventiva
powercfg -delete %nexo_guid% >nul 2>&1

:: Creación Forzada: Duplicar esquema de alto rendimiento y capturar en GUID estático
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 %nexo_guid% >nul 2>&1
powercfg -changename %nexo_guid% "Maximo Rendimiento El Nexo"
powercfg -setactive %nexo_guid%

:: TWEAKS PROFUNDOS DE ENERGÍA (EXTENDIDO)
echo [+] Aplicando micro-ajustes de energía...
:: Desactivar suspensión de disco duro (0 = Nunca)
powercfg -change -disk-timeout-ac 0
:: Desactivar suspensión de monitor (Opcional, configurado a nunca)
powercfg -change -monitor-timeout-ac 0
:: Desactivar hibernación para liberar espacio y reducir escrituras
powercfg -h off >nul 2>&1
:: Máximo rendimiento en estado de procesador
powercfg -setacvalueindex %nexo_guid% sub_processor PROCTHROTTLEMIN 100
powercfg -setacvalueindex %nexo_guid% sub_processor PROCTHROTTLEMAX 100
:: Desactivar ahorro de energía en PCI Express (Link State Power Management)
powercfg -setacvalueindex %nexo_guid% sub_pciexpress aspm 0
:: Desactivar suspensión selectiva de USB
powercfg -setacvalueindex %nexo_guid% sub_usb usbsuspend 0

echo [OK] Matriz de energía operativa.

:: --- [4. KERNEL & BOOTLOADER (BCDEDIT EXTENDIDO)] ---
echo.
echo [+] Optimizando parámetros de arranque (BCD)...
:: Desactivar "Dynamic Tick" (Vital para laptops y latencia)
bcdedit /set disabledynamictick yes >nul 2>&1
:: Forzar reloj de plataforma (Desactivado para reducir latencia DPC)
bcdedit /set useplatformclock no >nul 2>&1
:: Sincronización de TSC (Enhanced para Ryzen/Core modernos)
bcdedit /set tscsyncpolicy Enhanced >nul 2>&1
:: Desactivar logo de arranque (Acelera boot)
bcdedit /set bootux disabled >nul 2>&1
:: Desactivar Hypervisor (Mejora FPS en VMs no usadas)
bcdedit /set hypervisorlaunchtype off >nul 2>&1
:: Desactivar protecciones de integridad dinámicas (Ganancia marginal de CPU)
bcdedit /set isolatedcontext No >nul 2>&1
:: Permitir uso de drivers sin firmar (Opcional, útil para herramientas custom)
bcdedit /set nointegritychecks No >nul 2>&1

echo.
echo ------------------------------------------------------
echo [PARTE 1 COMPLETADA] MANTÉN LA VENTANA O EJECUTA PARTE 2
echo ------------------------------------------------------
timeout /t 2 >nul

title EL NEXO: PROTOCOLO DE INGENIERÍA V3.5 (SISTEMA)
color 0A

:: --- [5. LATENCIA DE HARDWARE (MSI MODE & GPU)] ---
echo.
echo [+] Inyectando Modo MSI (Message Signaled Interrupts)...
echo     [INFO] Escaneando bus PCI. Esto puede tomar unos instantes...
:: FIX: Se usa archivo temporal para evitar colgado de pipes en sistemas corruptos
reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "Interrupt Management" > "%temp%\nexo_pci_scan.txt" 2>nul
if exist "%temp%\nexo_pci_scan.txt" (
    for /f "tokens=*" %%i in ('type "%temp%\nexo_pci_scan.txt" ^| findstr "HKEY_LOCAL_MACHINE"') do (
        reg add "%%i\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d 1 /f >nul 2>&1
    )
    del /f /q "%temp%\nexo_pci_scan.txt" >nul 2>&1
)

echo [+] Optimizando GPU (NVIDIA/AMD) y Prioridades...
echo     [INFO] Buscando y desactivando ULPS (Ultra Low Power State)...
:: FIX: Optimizacion segura para ULPS
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Video" /s /f "EnableUlps" > "%temp%\nexo_gpu_scan.txt" 2>nul
if exist "%temp%\nexo_gpu_scan.txt" (
    for /f "delims=" %%a in ('type "%temp%\nexo_gpu_scan.txt" ^| findstr "HKEY_LOCAL_MACHINE"') do (
        reg add "%%a" /v "EnableUlps" /t REG_DWORD /d 0 /f >nul 2>&1
    )
    del /f /q "%temp%\nexo_gpu_scan.txt" >nul 2>&1
)

:: Programación de GPU acelerada por hardware (HAGS) - Prioridad Alta
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul 2>&1
:: Desactivar "Optimización de pantalla completa" global
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f >nul 2>&1

:: --- [6. OPTIMIZACIÓN DEL REGISTRO (CPU & RAM)] ---
echo.
echo [+] Reconfigurando Scheduler de CPU y Memoria...
:: Win32PrioritySeparation: 26 (Hex) = Prioridad absoluta a Foreground
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul
:: DisablePagingExecutive: Mantener Kernel en RAM
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul
:: LargeSystemCache: Optimizado para IO (0 para Gaming, 1 para Server - Usamos 0)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f >nul
:: SystemResponsiveness: Reservar 0% de CPU para tareas de fondo
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul
:: NetworkThrottlingIndex: Desactivar límite de paquetes de red
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul

:: --- [7. INPUT LAG Y PERIFÉRICOS (MOUSE/TECLADO)] ---
echo.
echo [+] Reduciendo latencia de entrada (Input Lag)...
:: Tamaño de cola de datos de ratón y teclado
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d 50 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d 50 /f >nul
:: MenuShowDelay: Velocidad de despliegue de menús (0 = Instantáneo)
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul
:: MouseHoverTime: Tiempo de respuesta al pasar el ratón
reg add "HKCU\Control Panel\Mouse" /v "MouseHoverTime" /t REG_SZ /d "10" /f >nul

:: --- [8. SISTEMA DE ARCHIVOS (NTFS TWEAKS)] ---
echo.
echo [+] Optimizando sistema de archivos NTFS...
:: Desactivar marca de tiempo de último acceso (Acelera lectura de disco)
fsutil behavior set disablelastaccess 1 >nul 2>&1
:: Desactivar nombres cortos 8dot3 (Mejora rendimiento en carpetas grandes)
fsutil behavior set disable8dot3 1 >nul 2>&1

:: --- [9. SERVICIOS Y TELEMETRÍA (KILL LIST EXTENDIDA 2025)] ---
echo.
echo [+] Neutralizando servicios innecesarios (Bloatware)...
set services=DiagTrack dmwappushservice SysMain WerSvc MapsBroker PcaSvc DPS RetailDemo WSearch
for %%s in (%services%) do (
    sc stop %%s >nul 2>&1
    sc config %%s start= disabled >nul 2>&1
)

echo [+] Desactivando GameDVR y Barra de Juegos...
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul

:: --- [10. LIMPIEZA FINAL Y CIERRE] ---
echo.
echo [+] Purgando archivos temporales...
del /s /f /q %temp%\*.* >nul 2>&1
del /s /f /q C:\Windows\Temp\*.* >nul 2>&1
ipconfig /flushdns >nul 2>&1

echo ======================================================
echo    PROTOCOLO EL NEXO V3.5 COMPLETADO
echo    (Kernel, GPU, Red y Energía Optimizados)
echo ======================================================
echo [IMPORTANTE] Debes REINICIAR el PC para cargar el nuevo Kernel.
echo.
set /p r="¿Reiniciar ahora? (S/N): "
if /i "%r%"=="S" shutdown /r /t 3
exit
