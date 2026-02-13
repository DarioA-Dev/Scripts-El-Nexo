@echo off
chcp 65001 >nul
title EL NEXO - MANTENIMIENTO DE SISTEMA v3.6
color 0A
setlocal enabledelayedexpansion

:: 1. VERIFICACIÓN DE PRIVILEGIOS
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo [ERROR] NIVEL DE AUTORIDAD INSUFICIENTE. EJECUTA COMO ADMINISTRADOR.
    echo Haz clic derecho ^> Ejecutar como administrador.
    pause >nul
    exit
)

echo ======================================================
echo          PROTOCOLO DE MANTENIMIENTO: EL NEXO
echo        (FASE 1: INTEGRIDAD Y COMPONENTES BASE)
echo ======================================================

:: 2. PUNTO DE CONTROL (VOLUNTARIO)
echo.
set /p "backup=¿Deseas generar un Punto de Control de Ingeniería? (S/N): "
if /i "%backup%"=="S" (
    echo [+] Iniciando respaldo de configuración de sistema...
    powershell -Command "Checkpoint-Computer -Description 'Mantenimiento El Nexo' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
    echo [OK] Punto de control establecido.
)

:: 3. OPTIMIZACIÓN DE COMPONENTES (PROCESO LARGO)
echo.
echo ======================================================
echo [AVISO] Iniciando purga del almacén de componentes (WinSxS).
echo ESTE PROCESO ES ALTAMENTE INTENSIVO Y PUEDE TARDAR 
echo ENTRE 5 Y 15 MINUTOS. NO CIERRES LA VENTANA.
echo El sistema está trabajando en segundo plano...
echo ======================================================
dism /online /cleanup-image /startcomponentcleanup /resetbase >nul 2>&1
echo [OK] Almacén de componentes optimizado y compactado.

:: 4. REPOSITORIO DE ACTUALIZACIONES
echo.
echo [+] Deteniendo servicios para purga de SoftwareDistribution...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
if exist %windir%\SoftwareDistribution\Download (
    echo [INFO] Limpiando carpeta de descargas de Windows Update...
    del /s /f /q %windir%\SoftwareDistribution\Download\*.* >nul 2>&1
    rmdir /s /q %windir%\SoftwareDistribution\Download >nul 2>&1
    mkdir %windir%\SoftwareDistribution\Download >nul 2>&1
)
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
echo [OK] Repositorio de Windows Update purgado y reiniciado.

echo.
echo ------------------------------------------------------
echo [FASE 1 COMPLETADA] PREPARANDO CACHÉS DE HARDWARE...
echo ------------------------------------------------------
timeout /t 3 >nul

title EL NEXO: MANTENIMIENTO DE SISTEMA [FASE 2]
color 0A

:: 5. CACHÉS DE HARDWARE (PROCESO POWERSHELL)
echo.
echo [+] Sincronizando purga de cachés de sombreadores (GPU)...
echo [AVISO] Escaneando directorios de NVIDIA, AMD y DirectX...
powershell -Command "Remove-Item -Path '$env:LOCALAPPDATA\NVIDIA\GLCache\*' -Recurse -Force -ErrorAction SilentlyContinue" >nul 2>&1
powershell -Command "Remove-Item -Path '$env:LOCALAPPDATA\AMD\DxCache\*' -Recurse -Force -ErrorAction SilentlyContinue" >nul 2>&1
powershell -Command "Remove-Item -Path '$env:LOCALAPPDATA\Microsoft\DirectX\ShaderCache\*' -Recurse -Force -ErrorAction SilentlyContinue" >nul 2>&1
echo [OK] Cachés de hardware reiniciadas satisfactoriamente.

:: 6. DESINSTALACIÓN DE PAQUETES UWP (DEBLOAT)
echo.
set /p "debloat=¿Deseas desinstalar paquetes de aplicaciones obsoletas? (S/N): "
if /i "%debloat%"=="S" (
    echo [+] Iniciando desinstalación de Bloatware...
    echo [AVISO] Esto puede tardar unos segundos dependiendo del sistema...
    powershell -Command "Get-AppxPackage *CandyCrush* | Remove-AppxPackage; Get-AppxPackage *WindowsMaps* | Remove-AppxPackage; Get-AppxPackage *YourPhone* | Remove-AppxPackage; Get-AppxPackage *BingNews* | Remove-AppxPackage" >nul 2>&1
    echo [OK] Paquetes UWP innecesarios eliminados.
)

:: 7. PURGA DE REGISTROS DE EVENTOS (PROCESO LARGO)
echo.
echo ======================================================
echo [+] Iniciando purga forense de registros de eventos.
echo [AVISO] Windows está limpiando miles de logs históricos. 
echo La ventana puede parecer inactiva por un momento...
echo ======================================================
for /f "tokens=*" %%e in ('wevtutil el') do (wevtutil cl "%%e") >nul 2>&1
echo [OK] Historial de eventos y errores reiniciado.

:: 8. LIMPIEZA DE DIRECTORIOS VOLÁTILES MASIVA
echo.
echo [+] Ejecutando purga final de directorios temporales...
if defined temp (
    echo [INFO] Limpiando carpeta TEMP de usuario...
    del /s /f /q %temp%\*.* >nul 2>&1
    for /d %%D in (%temp%\*) do rd /s /q "%%D" >nul 2>&1
)
if exist %windir%\Temp (
    echo [INFO] Limpiando carpeta TEMP de Windows...
    del /s /f /q %windir%\Temp\*.* >nul 2>&1
    for /d %%D in (%windir%\Temp\*) do rd /s /q "%%D" >nul 2>&1
)
if exist %windir%\Prefetch (
    echo [INFO] Limpiando Prefetch...
    del /s /f /q %windir%\Prefetch\*.* >nul 2>&1
)
echo [OK] Archivos temporales y de prelectura eliminados.

:: 9. OPTIMIZACIÓN DE INTERFAZ (EXPLORER)
echo [+] Reconstruyendo base de datos de iconos y miniaturas...
taskkill /f /im explorer.exe >nul 2>&1
if defined LocalAppData (
    del /f /q "%LocalAppData%\IconCache.db" >nul 2>&1
    del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
)
start explorer.exe
echo [OK] Caché de interfaz reiniciada.

echo.
echo ======================================================
echo    MANTENIMIENTO FINALIZADO. SISTEMA NEXO DEPURADO.
echo ======================================================
echo Se recomienda reiniciar para reconstruir las cachés.
echo.
set /p "r=¿Reiniciar ahora? (S/N): "
if /i "%r%"=="S" shutdown /r /t 5
exit
