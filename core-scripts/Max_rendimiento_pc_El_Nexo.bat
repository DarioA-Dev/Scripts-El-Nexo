@echo off
chcp 65001 >nul
title EL NEXO - MÁXIMO RENDIMIENTO PC
color 0A
setlocal enabledelayedexpansion

:: VERIFICACIÓN DE ADMIN
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo [ERROR] ACCESO DENEGADO AL KERNEL.
    echo El Nexo requiere privilegios de Administrador.
    echo Haz clic derecho ^> Ejecutar como administrador.
    pause >nul
    exit
)

echo ======================================================
echo          INICIANDO SECUENCIA EL NEXO V3.6
echo ======================================================

:: PUNTO DE RESTAURACIÓN
echo.
echo [SEGURIDAD] ¿Crear Punto de Restauración? (S/N)
set /p "choice=Tu respuesta: "
if /i "%choice%"=="S" (
    echo [+] Creando punto de restauración...
    wmic /namespace:\\root\default path SystemRestore call CreateRestorePoint "El Nexo Backup", 100, 12 >nul 2>&1
    echo [OK] Punto creado.
)

:: GESTIÓN DE ENERGÍA
echo.
echo [+] Configurando plan de energía...
set "nexo_guid=11111111-1111-1111-1111-111111111111"
powercfg -delete %nexo_guid% >nul 2>&1
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 %nexo_guid% >nul 2>&1
powercfg -changename %nexo_guid% "Maximo Rendimiento El Nexo"
powercfg -setactive %nexo_guid%
powercfg -change -disk-timeout-ac 0
powercfg -change -monitor-timeout-ac 0
powercfg -h off >nul 2>&1
powercfg -setacvalueindex %nexo_guid% sub_processor PROCTHROTTLEMIN 100 >nul 2>&1
powercfg -setacvalueindex %nexo_guid% sub_processor PROCTHROTTLEMAX 100 >nul 2>&1
powercfg -setacvalueindex %nexo_guid% sub_pciexpress aspm 0 >nul 2>&1
powercfg -setacvalueindex %nexo_guid% sub_usb usbsuspend 0 >nul 2>&1
echo [OK] Energía optimizada.

:: KERNEL Y BOOTLOADER
echo.
echo [+] Optimizando arranque...
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /set useplatformclock no >nul 2>&1
bcdedit /set tscsyncpolicy Enhanced >nul 2>&1
bcdedit /set bootux disabled >nul 2>&1
bcdedit /set hypervisorlaunchtype off >nul 2>&1
echo [OK] Kernel optimizado.

:: MSI MODE (SIN POWERSHELL)
echo.
echo [+] Configurando interrupciones MSI...
reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "Interrupt Management" > "%temp%\msi.txt" 2>nul
if exist "%temp%\msi.txt" (
    for /f "tokens=*" %%i in ('type "%temp%\msi.txt" ^| findstr "HKEY_LOCAL_MACHINE"') do (
        reg add "%%i\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d 1 /f >nul 2>&1
    )
    del /f /q "%temp%\msi.txt" >nul 2>&1
)
echo [OK] MSI activado.

:: GPU OPTIMIZACIÓN
echo.
echo [+] Optimizando GPU...
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Video" /s /f "EnableUlps" > "%temp%\gpu.txt" 2>nul
if exist "%temp%\gpu.txt" (
    for /f "delims=" %%a in ('type "%temp%\gpu.txt" ^| findstr "HKEY_LOCAL_MACHINE"') do (
        reg add "%%a" /v "EnableUlps" /t REG_DWORD /d 0 /f >nul 2>&1
    )
    del /f /q "%temp%\gpu.txt" >nul 2>&1
)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f >nul 2>&1
echo [OK] GPU configurada.

:: CPU Y MEMORIA
echo.
echo [+] Optimizando CPU y RAM...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
echo [OK] CPU optimizada.

:: INPUT LAG
echo.
echo [+] Reduciendo latencia...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d 50 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d 50 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseHoverTime" /t REG_SZ /d "10" /f >nul 2>&1
echo [OK] Latencia reducida.

:: NTFS
echo.
echo [+] Optimizando disco...
fsutil behavior set disablelastaccess 1 >nul 2>&1
fsutil behavior set disable8dot3 1 >nul 2>&1
echo [OK] Disco optimizado.

:: SERVICIOS
echo.
echo [+] Desactivando servicios...
for %%s in (DiagTrack dmwappushservice SysMain WerSvc MapsBroker PcaSvc DPS RetailDemo WSearch) do (
    sc stop %%s >nul 2>&1
    sc config %%s start= disabled >nul 2>&1
)
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Servicios neutralizados.

:: LIMPIEZA
echo.
echo [+] Limpiando temporales...
del /s /f /q %temp%\*.* >nul 2>&1
del /s /f /q C:\Windows\Temp\*.* >nul 2>&1
ipconfig /flushdns >nul 2>&1
echo [OK] Sistema limpio.

echo.
echo ======================================================
echo    PROTOCOLO COMPLETADO
echo ======================================================
echo DEBES REINICIAR para aplicar cambios.
echo.
set /p r="¿Reiniciar ahora? (S/N): "
if /i "%r%"=="S" shutdown /r /t 3
exit
