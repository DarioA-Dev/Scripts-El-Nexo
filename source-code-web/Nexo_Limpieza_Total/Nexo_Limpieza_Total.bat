@echo off
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO v5.0 - LIMPIEZA TOTAL [PLAN: FREE]
color 0B
:: =========================================================================
::  EL NEXO - LIMPIEZA TOTAL [PLAN: FREE]  (v5.1 - blindado)
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Solo borra archivos temporales y caches que Windows regenera.
::  No cambia ninguna configuracion del sistema.
:: =========================================================================

fsutil dirty query %systemdrive% >nul 2>&1
if %errorlevel% neq 0 (
    cls & color 0C
    echo.
    echo  ============================================================
    echo   ACCESO DENEGADO - Se requieren permisos de Administrador
    echo  ============================================================
    echo   Haz clic derecho y selecciona "Ejecutar como administrador"
    echo  ============================================================
    pause & exit /b
)

cls
color 0B
echo.
echo  ============================================================
echo    ______ _       _   _ _______   ______
echo   ^|  ____^|^| ^|     ^| \ ^| ^|^|  ___\ \ / / __ \
echo   ^| ^|__  ^| ^|     ^|  \^| ^|^| ^|__  \ V / ^|  ^| ^|
echo   ^|  __^| ^| ^|     ^| . ` ^|^|  __^|  ^> ^<^| ^|  ^| ^|
echo   ^| ^|____^| ^|____ ^| ^|\  ^|^| ^|____/ . \ ^|__^| ^|
echo   ^|______^|^|______^|^|_^| \_^|^|______/_/\_\____/
echo.
echo  ============================================================
echo   LIMPIEZA TOTAL   ^|   PLAN: FREE
echo   Para la version completa: elnexocenter.com/optimizer
echo  ============================================================
echo.

set /p "backup=Crear punto de restauracion? (S/N): "
if /i "%backup%"=="S" (
    call :RESTORE_POINT "El Nexo Limpieza FREE"
    if !errorlevel! equ 0 (echo  [OK] Punto creado.) else (
        echo  [!] No se pudo crear.
        echo      Proteccion del sistema desactivada o ya se creo un punto hoy.
    )
) else (echo  [!] Saltando respaldo.)
echo.

echo  [PASO 1/5] Limpiando cache de Windows Update...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
timeout /t 2 /nobreak >nul
if exist "%windir%\SoftwareDistribution\Download" (
    del /s /f /q "%windir%\SoftwareDistribution\Download\*.*" >nul 2>&1
    for /d %%D in ("%windir%\SoftwareDistribution\Download\*") do rd /s /q "%%D" >nul 2>&1
)
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
echo  [OK] Cache de Windows Update eliminada.

echo.
echo  [PASO 2/5] Eliminando archivos temporales...
del /s /f /q "%temp%\*.*" >nul 2>&1
for /d %%D in ("%temp%\*") do rd /s /q "%%D" >nul 2>&1
del /s /f /q "%windir%\Temp\*.*" >nul 2>&1
for /d %%D in ("%windir%\Temp\*") do rd /s /q "%%D" >nul 2>&1
:: La carpeta Prefetch NO se borra: Windows la usa para acelerar el
:: arranque y la apertura de programas, y se mantiene sola.
echo  [OK] Temporales eliminados.

echo.
echo  [PASO 3/5] Limpiando historial de archivos recientes...
:: Solo los accesos directos de "Recientes". Las listas de salto
:: (AutomaticDestinations) se conservan: contienen elementos anclados.
del /f /q "%AppData%\Microsoft\Windows\Recent\*.lnk" >nul 2>&1
echo  [OK] Historial limpiado.

echo.
echo  [PASO 4/5] Limpiando logs de eventos...
echo.
echo   Los registros de eventos sirven para diagnosticar errores
echo   (pantallazos azules, fallos de drivers, actualizaciones).
echo   Vaciarlos NO mejora el rendimiento ni libera espacio relevante.
echo.
set "evlog=N"
set /p "evlog=Vaciar los logs de eventos de todos modos? (S/N, por defecto N): "
if /i "%evlog%"=="S" (
    for /f "tokens=*" %%e in ('wevtutil el 2^>nul') do wevtutil cl "%%e" >nul 2>&1
    echo  [OK] Logs de eventos eliminados.
) else (
    echo  [!] Logs de eventos conservados.
)

echo.
echo  [PASO 5/5] Reconstruyendo cache del Explorador...
set "papelera=N"
set /p "papelera=Vaciar tambien la papelera de reciclaje? (S/N, por defecto N): "
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul
del /f /q "%LocalAppData%\IconCache.db" >nul 2>&1
del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
if /i "%papelera%"=="S" powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1
start explorer.exe
if /i "%papelera%"=="S" (
    echo  [OK] Explorador reconstruido y papelera vaciada.
) else (
    echo  [OK] Explorador reconstruido. Papelera sin tocar.
)

echo.
echo  ============================================================
echo   LIMPIEZA FREE - COMPLETADO
echo  ============================================================
echo.
echo   Cambios aplicados en esta version FREE:
echo   [OK] Cache de Windows Update eliminada
echo   [OK] Archivos temporales borrados
echo   [OK] Historial de archivos recientes limpiado
if /i "%evlog%"=="S" echo   [OK] Logs de eventos vaciados
echo   [OK] Cache del Explorador reconstruida
echo.
echo  ============================================================
echo   BLOQUEADO EN PLAN FREE - DISPONIBLE EN NEXO OPTIMIZER PRO:
echo  ============================================================
echo.
echo   [PRO] DISM /cleanup-image /resetbase
echo         (Elimina hasta 10 GB del almacen WinSxS)
echo.
echo   [PRO] Limpieza de shader cache GPU (NVIDIA y AMD)
echo         (GLCache, DXCache, D3DSCache)
echo.
echo   [PRO] Flush de Standby List de RAM
echo         (Libera RAM atascada que Windows no devuelve)
echo.
echo   Consigue todo esto y mucho mas en:
echo   elnexocenter.com/optimizer
echo  ============================================================
echo.
pause
exit

:RESTORE_POINT
powershell -NoProfile -Command "try { Checkpoint-Computer -Description '%~1' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction Stop -WarningVariable w -WarningAction SilentlyContinue; if ($w) { exit 2 } } catch { exit 1 }" >nul 2>&1
exit /b %errorlevel%
