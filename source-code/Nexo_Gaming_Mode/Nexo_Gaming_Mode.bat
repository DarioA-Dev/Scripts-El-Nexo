@echo off
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO v5.0 - GAMING MODE
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
echo   PROTOCOLO: GAMING MODE [MODO COMPETICION TOTAL]
echo   VERSION: 5.0
echo  ============================================================
echo.
echo  Este script aplica cambios PERMANENTES al sistema.
echo.

set /p "backup=Crear punto de restauracion antes de continuar? (S/N): "
if /i "%backup%"=="S" (
    powershell -Command "Checkpoint-Computer -Description 'El Nexo Gaming Mode' -RestorePointType 'MODIFY_SETTINGS'" 2>nul
    if !errorlevel! equ 0 (echo  [OK] Punto creado.) else (echo  [!] No se pudo crear.)
) else (
    echo  [!] Saltando respaldo.
)
echo.

echo  [PASO 1/7] Desactivando overlays (Xbox, NVIDIA, Steam)...
echo.
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowgameDVR" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] Xbox Game Bar y DVR desactivados.
reg add "HKCU\Software\NVIDIA Corporation\Global\Shadow Play\NVSCPSSVC" /v "EnableWRTD" /t REG_DWORD /d 0 /f >nul 2>&1
taskkill /f /im nvsphelper64.exe >nul 2>&1
taskkill /f /im "NVIDIA Share.exe" >nul 2>&1
echo  [OK] NVIDIA Instant Replay desactivado.
reg add "HKCU\Software\Valve\Steam" /v "NoGameOverlay" /t REG_DWORD /d 1 /f >nul 2>&1
echo  [OK] Steam overlay reducido.

echo.
echo  [PASO 2/7] Configurando HAGS...
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul 2>&1
echo  [OK] HAGS configurado correctamente.

echo.
echo  [PASO 3/7] Inyectando prioridades en el scheduler multimedia...
echo.
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] GPU Priority 8, Scheduling Category High.

echo.
echo  [PASO 4/7] Desactivando servicios de Xbox...
echo.
for %%s in (XblAuthManager XblGameSave XboxGipSvc XboxNetApiSvc GamingServices GamingServicesNet) do (
    sc stop %%s >nul 2>&1
    sc config %%s start=disabled >nul 2>&1
)
echo  [OK] Servicios Xbox desactivados.

echo.
echo  [PASO 5/7] Desactivando telemetria...
echo.
for %%s in (DiagTrack dmwappushservice WerSvc PcaSvc DPS RetailDemo) do (
    sc stop %%s >nul 2>&1
    sc config %%s start=disabled >nul 2>&1
)
echo  [OK] Telemetria desactivada.

echo.
echo  [PASO 6/7] Desactivando bloatware de audio (Nahimic, Sonic Studio)...
echo.
sc stop NahimicService >nul 2>&1
sc config NahimicService start=disabled >nul 2>&1
sc stop "Sonic Studio II Service" >nul 2>&1
sc config "Sonic Studio II Service" start=disabled >nul 2>&1
taskkill /f /im SonicStudio3.exe >nul 2>&1
taskkill /f /im NahimicSvc64.exe >nul 2>&1
echo  [OK] Bloatware de audio desactivado si estaba presente.

echo.
echo  [PASO 7/7] Desactivando tareas programadas y apps de fondo...
echo.
schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
echo  [OK] Tareas de fondo desactivadas.

set /p "search=Desactivar indexacion de busqueda? (Libera CPU) (S/N): "
if /i "%search%"=="S" (
    sc stop WSearch >nul 2>&1
    sc config WSearch start=disabled >nul 2>&1
    echo  [OK] Indexacion desactivada.
) else (
    echo  [!] Indexacion sin cambios.
)

echo.
echo  ============================================================
echo   GAMING MODE ACTIVADO
echo  ============================================================
echo.
echo   Cambios aplicados:
echo   - Overlays Xbox, NVIDIA, Steam desactivados
echo   - HAGS configurado correctamente
echo   - Scheduler: GPU Priority 8, Scheduling High
echo   - Servicios Xbox y telemetria desactivados
echo   - Nahimic / Sonic Studio desactivados
echo   - Apps de fondo bloqueadas
echo.
echo   RECOMENDACION: Reinicia para aplicar todos los cambios.
echo  ============================================================
echo.
set /p "reboot=Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando Gaming Mode El Nexo..."
exit
