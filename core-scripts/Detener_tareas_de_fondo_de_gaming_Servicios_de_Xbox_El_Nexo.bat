@echo off
:: =========================================================================
::   EL NEXO - OPTIMIZADOR DE PROCESOS v4.0
::   Protocolo: Xbox Services, Telemetria y Prioridades de CPU
:: =========================================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO v4.0 - GESTOR DE PROCESOS
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
echo   PROTOCOLO: OPTIMIZACION DE PROCESOS [LIBERAR CPU]
echo   VERSION: 4.0 ENHANCED - Estado: Iniciando secuencia...
echo  ============================================================
echo.

:: PUNTO DE CONTROL
echo  [PASO 1/7] Creando punto de restauracion de seguridad...
echo.
set /p "backup= Deseas crear un respaldo antes de continuar? (S/N): "
if /i "%backup%"=="S" (
    echo.
    echo  [*] Generando punto de restauracion del sistema...
    powershell -Command "Checkpoint-Computer -Description 'El Nexo v4.0 Procesos' -RestorePointType 'MODIFY_SETTINGS'" 2>nul
    if !errorlevel! equ 0 (
        echo  [OK] Punto de restauracion creado correctamente.
    ) else (
        echo  [!] No se pudo crear el punto. Continuando de todos modos...
    )
) else (
    echo  [!] Saltando respaldo por decision del usuario.
)

:: UWP BACKGROUND APPS
echo.
echo  [PASO 2/7] Desactivando aplicaciones en segundo plano...
echo.
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
echo  [OK] Apps de Microsoft Store controladas.

:: GAMEDVR & XBOX SERVICES
echo.
echo  [PASO 3/7] Desactivando servicios de Xbox...
echo.
echo  [*] Esto liberara recursos de GPU y CPU...
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowgameDVR" /t REG_DWORD /d 0 /f >nul 2>&1

for %%s in (XblAuthManager XblGameSave XboxGipSvc XboxNetApiSvc GamingServices GamingServicesNet) do (
    sc stop %%s >nul 2>&1
    sc config %%s start=disabled >nul 2>&1
)
echo  [OK] Servicios de Xbox desactivados.

:: TELEMETRY SERVICES
echo.
echo  [PASO 4/7] Desactivando servicios de telemetria...
echo.
for %%s in (DiagTrack dmwappushservice WerSvc PcaSvc DPS RetailDemo) do (
    sc stop %%s >nul 2>&1
    sc config %%s start=disabled >nul 2>&1
)
echo  [OK] Recopilacion de datos desactivada.

:: GAME PRIORITY
echo.
echo  [PASO 5/7] Configurando prioridades de juegos...
echo.
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1
echo  [OK] Juegos con maxima prioridad del sistema.

:: SCHEDULED TASKS
echo.
echo  [PASO 6/7] Desactivando tareas programadas innecesarias...
echo.
schtasks /Change /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable >nul 2>&1
echo  [OK] Tareas de mantenimiento desactivadas.

:: WINDOWS SEARCH
echo.
echo  [PASO 7/7] Configurando servicios opcionales...
echo.
set /p "search= Deseas desactivar la indexacion de busqueda? (Libera CPU) (S/N): "
if /i "%search%"=="S" (
    sc stop WSearch >nul 2>&1
    sc config WSearch start=disabled >nul 2>&1
    echo  [OK] Indexacion de busqueda desactivada.
) else (
    echo  [!] Manteniendo busqueda de Windows activa.
)

:: FINALIZACION
echo.
echo  ============================================================
echo   OPTIMIZACION COMPLETADA CON EXITO
echo  ============================================================
echo.
echo   Tu sistema ahora tiene:
echo   - Menos procesos en segundo plano
echo   - Mas recursos para juegos
echo   - Mejor rendimiento general
echo.
echo   RECOMENDACION: Reinicia tu PC para aplicar todos los cambios.
echo.
echo  ============================================================
echo.
pause
exit
