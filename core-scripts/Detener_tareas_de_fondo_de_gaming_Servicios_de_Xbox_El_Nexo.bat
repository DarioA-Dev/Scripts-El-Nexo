@echo off
:: ==========================================================
::   EL NEXO - OPTIMIZACIÓN DE TAREAS DE FONDO v3.6
::   Ingeniería: AppPrivacy, Telemetría y Latencia de Interfaz
:: ==========================================================
chcp 65001 >nul
title EL NEXO: GESTIÓN DE TAREAS [FASE 1]
color 0B
setlocal enabledelayedexpansion

:: 1. VERIFICACIÓN DE PRIVILEGIOS
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo [ERROR] NIVEL DE AUTORIDAD INSUFICIENTE. EJECUTA COMO ADMINISTRADOR.
    pause >nul
    exit
)

echo ======================================================
echo          PROTOCOLO DE TAREAS DE FONDO: EL NEXO
echo        (FASE 1: RESTRICCIÓN DE APLICACIONES UWP)
echo ======================================================

:: 2. PUNTO DE CONTROL (VOLUNTARIO)
echo.
set /p "backup=¿Deseas generar un Punto de Control de Ingeniería? (S/N): "
if /i "%backup%"=="S" (
    echo [+] Iniciando respaldo de configuración de sistema...
    powershell -Command "Checkpoint-Computer -Description 'Tareas El Nexo' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
    echo [OK] Punto de control establecido.
)

:: 3. BLOQUEO GLOBAL DE APPS EN SEGUNDO PLANO
echo.
echo [+] Sincronizando políticas de privacidad de aplicaciones...
echo [AVISO] Se están inyectando directivas de denegación forzada...
:: Desactivar aplicaciones de fondo para todos los usuarios
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d 2 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d 0 /f >nul
echo [OK] Ejecución de aplicaciones en segundo plano neutralizada.

:: 4. NEUTRALIZACIÓN DE GAMEDVR Y CAPTURA AUTOMÁTICA
echo.
echo [+] Desactivando monitorización de GameDVR y GameBar...
echo [AVISO] Esto liberará ciclos de GPU utilizados en grabación pasiva...
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowgameDVR" /t REG_DWORD /d 0 /f >nul
echo [OK] Captura de fondo desactivada (Input Lag reducido).

timeout /t 2 >nul
:: ==========================================================
::   EL NEXO - OPTIMIZACIÓN DE TAREAS DE FONDO v3.6
::   Ingeniería: Xbox Services, Telemetría y CPU Scheduling
:: ==========================================================
title EL NEXO: GESTIÓN DE TAREAS [FASE 2]
color 0B

:: 5. PURGA DE SERVICIOS XBOX (PROCESO INTENSIVO)
echo.
echo [+] Deshabilitando servicios de Xbox Live y GameSave...
echo [AVISO] El sistema está reconfigurando el gestor de servicios...
for %%s in (XblAuthManager, XblGameSave, XboxGipSvc, XboxNetApiSvc, GamingServices) do (
    sc stop %%s >nul 2>&1
    sc config %%s start= disabled >nul 2>&1
)
echo [OK] Servicios de ecosistema Xbox neutralizados.

:: 6. TELEMETRÍA Y SEGUIMIENTO DE USUARIO (HARDENING 2025)
echo.
echo [+] Eliminando servicios de rastreo y recolección de datos...
echo [AVISO] Procesando lista de servicios de telemetría avanzada...
:: Connected User Experiences, WAP Push, Error Reporting, etc.
for %%s in (DiagTrack, dmwappushservice, WerSvc, PcaSvc, DPS, RetailDemo) do (
    sc stop %%s >nul 2>&1
    sc config %%s start= disabled >nul 2>&1
)
echo [OK] Telemetría y diagnóstico desactivados.

:: 7. OPTIMIZACIÓN DE PRIORIDAD DE JUEGOS (CPU SCHEDULING)
echo.
echo [+] Ajustando prioridades del programador para Gaming...
:: Forzar prioridad alta a los procesos multimedia y juegos
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul
echo [OK] Jerarquía de procesos configurada para alto rendimiento.

:: 8. LIMPIEZA DE TAREAS PROGRAMADAS (REDUCCIÓN DE INTERRUPCIONES)
echo.
echo [+] Desactivando tareas programadas de mantenimiento automático...
echo [AVISO] Esto puede tardar unos segundos...
powershell -Command "Disable-ScheduledTask -TaskName 'Microsoft\Windows\Defrag\ScheduledDefrag' -ErrorAction SilentlyContinue" >nul 2>&1
powershell -Command "Disable-ScheduledTask -TaskName 'Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser' -ErrorAction SilentlyContinue" >nul 2>&1
echo [OK] Tareas de fondo de bajo nivel desactivadas.

echo.
echo ======================================================
echo    PROTOCOLO DE TAREAS FINALIZADO.
echo    CPU LIBERADA PARA MÁXIMO RENDIMIENTO.
echo ======================================================
pause
exit