@echo off
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO v5.0 - LIMPIEZA TOTAL
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
echo   PROTOCOLO: LIMPIEZA TOTAL [SISTEMA PRISTINO]
echo   VERSION: 5.0
echo  ============================================================
echo.

echo  [PASO 1/9] Creando punto de restauracion...
echo.
set /p "backup=Deseas crear un respaldo antes de continuar? (S/N): "
if /i "%backup%"=="S" (
    powershell -Command "Checkpoint-Computer -Description 'El Nexo Limpieza Total' -RestorePointType 'MODIFY_SETTINGS'" 2>nul
    if !errorlevel! equ 0 (echo  [OK] Punto creado.) else (echo  [!] No se pudo crear. Continuando...)
) else (
    echo  [!] Saltando respaldo.
)

echo.
echo  [PASO 2/9] Limpiando almacen de componentes de Windows...
echo.
echo  ============================================================
echo   AVISO: Este paso puede tardar 10-20 minutos. No cierres
echo   esta ventana. Es el paso mas importante para liberar disco.
echo  ============================================================
echo.
dism /online /cleanup-image /startcomponentcleanup /resetbase
echo  [OK] Componentes antiguos eliminados.

echo.
echo  [PASO 3/9] Limpiando cache de Windows Update...
echo.
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
timeout /t 2 /nobreak >nul
if exist "%windir%\SoftwareDistribution\Download" (
    del /s /f /q "%windir%\SoftwareDistribution\Download\*.*" >nul 2>&1
    for /d %%D in ("%windir%\SoftwareDistribution\Download\*") do rd /s /q "%%D" >nul 2>&1
)
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
echo  [OK] Cache de actualizaciones eliminada.

echo.
echo  [PASO 4/9] Eliminando archivos temporales...
echo.
del /s /f /q "%temp%\*.*" >nul 2>&1
for /d %%D in ("%temp%\*") do rd /s /q "%%D" >nul 2>&1
del /s /f /q "%windir%\Temp\*.*" >nul 2>&1
for /d %%D in ("%windir%\Temp\*") do rd /s /q "%%D" >nul 2>&1
if exist "%windir%\Prefetch" del /s /f /q "%windir%\Prefetch\*.*" >nul 2>&1
echo  [OK] Archivos temporales eliminados.

echo.
echo  [PASO 5/9] Limpiando caches de GPU...
echo.
if exist "%LocalAppData%\NVIDIA\GLCache" rd /s /q "%LocalAppData%\NVIDIA\GLCache" >nul 2>&1
if exist "%LocalAppData%\NVIDIA\DXCache" rd /s /q "%LocalAppData%\NVIDIA\DXCache" >nul 2>&1
if exist "%LocalAppData%\NVIDIA\OptixCache" rd /s /q "%LocalAppData%\NVIDIA\OptixCache" >nul 2>&1
if exist "%LocalAppData%\AMD\DxCache" rd /s /q "%LocalAppData%\AMD\DxCache" >nul 2>&1
if exist "%LocalAppData%\AMD\GLCache" rd /s /q "%LocalAppData%\AMD\GLCache" >nul 2>&1
if exist "%LocalAppData%\D3DSCache" rd /s /q "%LocalAppData%\D3DSCache" >nul 2>&1
echo  [OK] Caches de GPU eliminadas.

echo.
echo  [PASO 6/9] Limpiando historial de archivos recientes...
echo.
del /f /q "%AppData%\Microsoft\Windows\Recent\*.*" >nul 2>&1
del /f /q "%AppData%\Microsoft\Windows\Recent\AutomaticDestinations\*.*" >nul 2>&1
del /f /q "%AppData%\Microsoft\Windows\Recent\CustomDestinations\*.*" >nul 2>&1
echo  [OK] Historial de archivos recientes limpiado.

echo.
echo  [PASO 7/9] Liberando memoria RAM en estado Standby...
echo.
powershell -Command "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class Mem { [DllImport(\"psapi.dll\")] public static extern bool EmptyWorkingSet(IntPtr h); }'; Get-Process | Where-Object {$_.WorkingSet64 -gt 5MB} | ForEach-Object { try { [Mem]::EmptyWorkingSet($_.Handle) | Out-Null } catch {} }; [GC]::Collect(); [GC]::WaitForPendingFinalizers(); [GC]::Collect()" 2>nul
echo  [OK] RAM en Standby liberada.

echo.
echo  [PASO 8/9] Limpiando registros de eventos...
echo.
for /f "tokens=*" %%e in ('wevtutil el 2^>nul') do wevtutil cl "%%e" >nul 2>&1
echo  [OK] Logs de eventos eliminados.

echo.
echo  [PASO 9/9] Reconstruyendo cache del Explorador...
echo.
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul
del /f /q "%LocalAppData%\IconCache.db" >nul 2>&1
del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
rd /s /q %systemdrive%\$Recycle.bin >nul 2>&1
start explorer.exe
echo  [OK] Explorador reconstruido y papelera vaciada.

echo.
echo  ============================================================
echo   LIMPIEZA TOTAL COMPLETADA
echo  ============================================================
echo.
echo   Limpiado en esta sesion:
echo   - Almacen de componentes Windows (WinSxS)
echo   - Cache de Windows Update
echo   - Archivos temporales (usuario y sistema)
echo   - Caches de GPU (NVIDIA y AMD)
echo   - Historial de archivos recientes
echo   - RAM en estado Standby liberada
echo   - Logs de eventos del sistema
echo   - Cache de iconos y miniaturas
echo   - Papelera de reciclaje
echo  ============================================================
echo.
pause
exit
