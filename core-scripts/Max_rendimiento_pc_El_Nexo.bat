@echo off
chcp 65001 >nul
title EL NEXO - MÁXIMO RENDIMIENTO PC v3.6
color 0A

:: Verificar Admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo [ERROR] Acceso Denegado
    echo Este script requiere permisos de Administrador.
    echo Haz clic derecho sobre el archivo ^> Ejecutar como administrador
    echo.
    pause
    exit
)

cls
echo ========================================
echo   EL NEXO - OPTIMIZACION MAXIMA PC
echo ========================================
echo.

:: Plan de Energia
echo [1/8] Creando plan de energia...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 11111111-1111-1111-1111-111111111111 >nul 2>&1
powercfg -changename 11111111-1111-1111-1111-111111111111 "Maximo Rendimiento El Nexo" >nul 2>&1
powercfg -setactive 11111111-1111-1111-1111-111111111111 >nul 2>&1
powercfg -change -disk-timeout-ac 0 >nul 2>&1
powercfg -change -monitor-timeout-ac 0 >nul 2>&1
powercfg -h off >nul 2>&1
echo OK

:: Kernel
echo [2/8] Optimizando kernel...
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /set useplatformclock no >nul 2>&1
bcdedit /set tscsyncpolicy Enhanced >nul 2>&1
bcdedit /set bootux disabled >nul 2>&1
bcdedit /set hypervisorlaunchtype off >nul 2>&1
echo OK

:: GPU
echo [3/8] Configurando GPU...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f >nul 2>&1
echo OK

:: CPU
echo [4/8] Optimizando CPU...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f >nul 2>&1
echo OK

:: Red
echo [5/8] Optimizando red...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
echo OK

:: Mouse
echo [6/8] Reduciendo input lag...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d 50 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1
echo OK

:: Disco
echo [7/8] Optimizando disco...
fsutil behavior set disablelastaccess 1 >nul 2>&1
fsutil behavior set disable8dot3 1 >nul 2>&1
echo OK

:: Servicios
echo [8/8] Desactivando servicios innecesarios...
sc config DiagTrack start= disabled >nul 2>&1
sc config SysMain start= disabled >nul 2>&1
sc config WSearch start= disabled >nul 2>&1
sc stop DiagTrack >nul 2>&1
sc stop SysMain >nul 2>&1
sc stop WSearch >nul 2>&1
echo OK

echo.
echo ========================================
echo   OPTIMIZACION COMPLETADA
echo ========================================
echo.
echo DEBES REINICIAR EL PC para aplicar cambios.
echo.
pause
