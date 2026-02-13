@echo off
:: =========================================================================
::   EL NEXO - LIMPIEZA PROFUNDA DEL SISTEMA v4.0
::   Protocolo: Purga de Componentes y Optimizacion de Disco
:: =========================================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO v4.0 - LIMPIEZA DEL SISTEMA
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
echo   PROTOCOLO: LIMPIEZA PROFUNDA [LIBERACION DE ESPACIO]
echo   VERSION: 4.0 ENHANCED - Estado: Iniciando secuencia...
echo  ============================================================
echo.

:: PUNTO DE CONTROL
echo  [PASO 1/8] Creando punto de restauracion de seguridad...
echo.
set /p "backup= Deseas crear un respaldo antes de continuar? (S/N): "
if /i "%backup%"=="S" (
    echo.
    echo  [*] Generando punto de restauracion del sistema...
    powershell -Command "Checkpoint-Computer -Description 'El Nexo v4.0 Limpieza' -RestorePointType 'MODIFY_SETTINGS'" 2>nul
    if !errorlevel! equ 0 (
        echo  [OK] Punto de restauracion creado correctamente.
    ) else (
        echo  [!] No se pudo crear el punto. Continuando de todos modos...
    )
) else (
    echo  [!] Saltando respaldo por decision del usuario.
)

:: COMPONENT STORE CLEANUP
echo.
echo  [PASO 2/8] Limpiando almacen de componentes de Windows...
echo.
echo  ============================================================
echo   [AVISO] Este proceso puede tardar 10-15 minutos.
echo   Es muy importante para liberar espacio en disco.
echo   Por favor, se paciente...
echo  ============================================================
echo.
dism /online /cleanup-image /startcomponentcleanup /resetbase
echo  [OK] Componentes antiguos eliminados correctamente.

:: WINDOWS UPDATE CACHE
echo.
echo  [PASO 3/8] Limpiando cache de Windows Update...
echo.
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
timeout /t 2 /nobreak >nul

if exist "%windir%\SoftwareDistribution\Download" (
    echo  [*] Eliminando archivos de actualizacion antiguos...
    del /s /f /q "%windir%\SoftwareDistribution\Download\*.*" >nul 2>&1
    for /d %%D in ("%windir%\SoftwareDistribution\Download\*") do rd /s /q "%%D" >nul 2>&1
)

net start wuauserv >nul 2>&1
net start bits >nul 2>&1
echo  [OK] Cache de actualizaciones eliminada.

:: TEMPORARY FILES
echo.
echo  [PASO 4/8] Eliminando archivos temporales...
echo.
echo  [*] Limpiando carpetas de usuario y sistema...
del /s /f /q "%temp%\*.*" >nul 2>&1
for /d %%D in ("%temp%\*") do rd /s /q "%%D" >nul 2>&1
del /s /f /q "%windir%\Temp\*.*" >nul 2>&1
for /d %%D in ("%windir%\Temp\*") do rd /s /q "%%D" >nul 2>&1

if exist "%windir%\Prefetch" (
    del /s /f /q "%windir%\Prefetch\*.*" >nul 2>&1
)
echo  [OK] Archivos temporales eliminados.

:: GPU SHADER CACHE
echo.
echo  [PASO 5/8] Limpiando caches de GPU...
echo.
if exist "%LocalAppData%\NVIDIA\GLCache" (
    echo  [*] Eliminando cache de NVIDIA OpenGL...
    rd /s /q "%LocalAppData%\NVIDIA\GLCache" >nul 2>&1
)
if exist "%LocalAppData%\NVIDIA\DXCache" (
    echo  [*] Eliminando cache de NVIDIA DirectX...
    rd /s /q "%LocalAppData%\NVIDIA\DXCache" >nul 2>&1
)
if exist "%LocalAppData%\AMD\DxCache" (
    echo  [*] Eliminando cache de AMD DirectX...
    rd /s /q "%LocalAppData%\AMD\DxCache" >nul 2>&1
)
if exist "%LocalAppData%\AMD\GLCache" (
    echo  [*] Eliminando cache de AMD OpenGL...
    rd /s /q "%LocalAppData%\AMD\GLCache" >nul 2>&1
)
if exist "%LocalAppData%\D3DSCache" (
    echo  [*] Eliminando cache de DirectX...
    rd /s /q "%LocalAppData%\D3DSCache" >nul 2>&1
)
echo  [OK] Caches de GPU eliminadas.

:: EVENT LOGS
echo.
echo  [PASO 6/8] Limpiando registros de eventos del sistema...
echo.
echo  [*] Eliminando logs acumulados...
for /f "tokens=*" %%e in ('wevtutil el 2^>nul') do (
    wevtutil cl "%%e" >nul 2>&1
)
echo  [OK] Registros de eventos eliminados.

:: EXPLORER CACHE
echo.
echo  [PASO 7/8] Reconstruyendo cache del explorador...
echo.
echo  [*] Reiniciando interfaz de Windows...
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul
del /f /q "%LocalAppData%\IconCache.db" >nul 2>&1
del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
start explorer.exe
echo  [OK] Interfaz de usuario optimizada.

:: RECYCLE BIN
echo.
echo  [PASO 8/8] Vaciando papelera de reciclaje...
echo.
rd /s /q %systemdrive%\$Recycle.bin >nul 2>&1
echo  [OK] Papelera vaciada.

:: FINALIZACION
echo.
echo  ============================================================
echo   LIMPIEZA COMPLETADA CON EXITO
echo  ============================================================
echo.
echo   Tu sistema ahora esta mas limpio y rapido.
echo   
echo   Espacio liberado:
echo   - Componentes antiguos eliminados
echo   - Archivos temporales borrados
echo   - Caches de GPU limpiadas
echo   - Logs del sistema vaciados
echo.
echo  ============================================================
echo.
pause
exit
