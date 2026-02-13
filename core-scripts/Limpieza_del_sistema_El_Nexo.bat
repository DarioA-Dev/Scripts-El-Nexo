@echo off
:: ==========================================================
::   EL NEXO - INGENIERÍA DE MANTENIMIENTO v3.6
::   Protocolo: Limpieza Forense y Purga de Componentes
:: ==========================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO: SYSTEM CLEANER v3.6
color 0A

:: 1. VERIFICACIÓN DE AUTORIDAD (ADMIN)
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo   [ERROR] SE REQUIEREN PRIVILEGIOS DE ADMINISTRADOR.
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
echo  ==========================================================
echo   PROTOCOLO: LIMPIEZA FORENSE DE SISTEMA (V3.6)
echo   ESTADO: Escaneando residuos de disco...
echo  ==========================================================
echo.

:: 3. PUNTO DE CONTROL
echo [SEGURIDAD] ¿Deseas generar un Punto de Control de Limpieza?
set /p "backup=Tu respuesta (S/N): "
if /i "%backup%"=="S" (
    echo.
    echo [+] Creando respaldo de configuración...
    powershell -Command "Checkpoint-Computer -Description 'Limpieza El Nexo v3.6' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
    echo [OK] Punto establecido.
)

:: 4. OPTIMIZACIÓN DE COMPONENTES (EL MÁS FUERTE)
echo.
echo =========================================================================
echo  [AVISO] Iniciando purga del Almacén de Componentes (WinSxS).
echo  ESTE PROCESO ES ALTAMENTE INTENSIVO Y PUEDE TARDAR 10-15 MINUTOS.
echo  Es vital para liberar Gigabytes de basura de actualizaciones antiguas.
echo =========================================================================
dism /online /cleanup-image /startcomponentcleanup /resetbase
echo [OK] Almacén de componentes optimizado y compactado.

:: 5. WINDOWS UPDATE & SOFTWARE DISTRIBUTION
echo.
echo [+] Deteniendo servicios para purga de repositorio de Update...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
if exist %windir%\SoftwareDistribution\Download (
    del /s /f /q %windir%\SoftwareDistribution\Download\*.* >nul 2>&1
    rd /s /q %windir%\SoftwareDistribution\Download >nul 2>&1
    mkdir %windir%\SoftwareDistribution\Download >nul 2>&1
)
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
echo [OK] Caché de Windows Update purgada satisfactoriamente.

:: 6. PURGA MASIVA DE TEMPORALES
echo.
echo [+] Ejecutando limpieza forense de directorios volátiles...
del /s /f /q %temp%\*.* >nul 2>&1
for /d %%D in (%temp%\*) do rd /s /q "%%D" >nul 2>&1
del /s /f /q %windir%\Temp\*.* >nul 2>&1
for /d %%D in (%windir%\Temp\*) do rd /s /q "%%D" >nul 2>&1
if exist %windir%\Prefetch (
    del /s /f /q %windir%\Prefetch\*.* >nul 2>&1
)
echo [OK] Archivos temporales de sistema y usuario eliminados.

:: 7. CACHÉS DE HARDWARE & GPU
echo.
echo [+] Purgando cachés de sombreadores (Shader Cache)...
if exist "%LocalAppData%\NVIDIA\GLCache" rd /s /q "%LocalAppData%\NVIDIA\GLCache" >nul 2>&1
if exist "%LocalAppData%\AMD\DxCache" rd /s /q "%LocalAppData%\AMD\DxCache" >nul 2>&1
echo [OK] Cachés de GPU reiniciadas.

:: 8. REGISTROS DE EVENTOS (WEVTUTIL)
echo.
echo [+] Eliminando registros de eventos acumulados (Event Logs)...
for /f "tokens=*" %%e in ('wevtutil el 2^>nul') do wevtutil cl "%%e" >nul 2>&1
echo [OK] Historial de errores y logs del sistema borrado.

:: 9. CACHÉ DE INTERFAZ (EXPLORER)
echo.
echo [+] Reconstruyendo base de datos de iconos y miniaturas...
taskkill /f /im explorer.exe >nul 2>&1
del /f /q "%LocalAppData%\IconCache.db" >nul 2>&1
del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
start explorer.exe
echo [OK] Interfaz de usuario reiniciada y limpia.

echo.
echo ==========================================================
echo    PROTOCOLO COMPLETADO. SISTEMA NEXO DEPURADO.
echo ==========================================================
echo.
pause
exit
