@echo off
chcp 65001 >nul
title EL NEXO - LIMPIEZA DE SISTEMA
color 0A
setlocal enabledelayedexpansion

:: ADMIN CHECK
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo [ERROR] Necesitas permisos de Administrador.
    echo Haz clic derecho ^> Ejecutar como administrador.
    pause >nul
    exit
)

echo ======================================================
echo          PROTOCOLO DE MANTENIMIENTO: EL NEXO
echo ======================================================

:: PUNTO DE RESTAURACIÓN
echo.
set /p "backup=¿Crear Punto de Restauración? (S/N): "
if /i "%backup%"=="S" (
    echo [+] Creando punto de restauración...
    wmic /namespace:\\root\default path SystemRestore call CreateRestorePoint "Limpieza Nexo", 100, 12 >nul 2>&1
    echo [OK] Punto creado.
)

:: COMPONENTES (PROCESO LARGO)
echo.
echo ======================================================
echo [AVISO] Optimizando almacén de componentes (WinSxS).
echo PUEDE TARDAR 5-15 MINUTOS. NO CIERRES LA VENTANA.
echo ======================================================
dism /online /cleanup-image /startcomponentcleanup /resetbase >nul 2>&1
echo [OK] Componentes optimizados.

:: SOFTWARE DISTRIBUTION
echo.
echo [+] Limpiando Windows Update...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
if exist %windir%\SoftwareDistribution\Download (
    del /s /f /q %windir%\SoftwareDistribution\Download\*.* >nul 2>&1
    rmdir /s /q %windir%\SoftwareDistribution\Download >nul 2>&1
    mkdir %windir%\SoftwareDistribution\Download >nul 2>&1
)
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
echo [OK] Windows Update limpio.

:: TEMPORALES
echo.
echo [+] Limpiando temporales...
if defined temp (
    del /s /f /q %temp%\*.* >nul 2>&1
    for /d %%D in (%temp%\*) do rd /s /q "%%D" >nul 2>&1
)
if exist %windir%\Temp (
    del /s /f /q %windir%\Temp\*.* >nul 2>&1
    for /d %%D in (%windir%\Temp\*) do rd /s /q "%%D" >nul 2>&1
)
if exist %windir%\Prefetch (
    del /s /f /q %windir%\Prefetch\*.* >nul 2>&1
)
echo [OK] Temporales eliminados.

:: CACHÉS DE GPU (SIN POWERSHELL)
echo.
echo [+] Limpiando cachés de GPU...
if exist "%LocalAppData%\NVIDIA\GLCache" (
    del /s /f /q "%LocalAppData%\NVIDIA\GLCache\*" >nul 2>&1
    for /d %%D in ("%LocalAppData%\NVIDIA\GLCache\*") do rd /s /q "%%D" >nul 2>&1
)
if exist "%LocalAppData%\AMD\DxCache" (
    del /s /f /q "%LocalAppData%\AMD\DxCache\*" >nul 2>&1
    for /d %%D in ("%LocalAppData%\AMD\DxCache\*") do rd /s /q "%%D" >nul 2>&1
)
if exist "%LocalAppData%\Microsoft\DirectX\ShaderCache" (
    del /s /f /q "%LocalAppData%\Microsoft\DirectX\ShaderCache\*" >nul 2>&1
    for /d %%D in ("%LocalAppData%\Microsoft\DirectX\ShaderCache\*") do rd /s /q "%%D" >nul 2>&1
)
echo [OK] Cachés GPU limpias.

:: LOGS DE EVENTOS
echo.
echo [+] Limpiando registros de eventos...
for /f "tokens=*" %%e in ('wevtutil el') do (wevtutil cl "%%e") >nul 2>&1
echo [OK] Logs eliminados.

:: ICONOS Y MINIATURAS
echo.
echo [+] Reconstruyendo caché de iconos...
taskkill /f /im explorer.exe >nul 2>&1
if defined LocalAppData (
    del /f /q "%LocalAppData%\IconCache.db" >nul 2>&1
    del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
)
start explorer.exe
echo [OK] Interfaz reiniciada.

echo.
echo ======================================================
echo    MANTENIMIENTO FINALIZADO
echo ======================================================
echo Se recomienda reiniciar.
echo.
set /p "r=¿Reiniciar ahora? (S/N): "
if /i "%r%"=="S" shutdown /r /t 5
exit
