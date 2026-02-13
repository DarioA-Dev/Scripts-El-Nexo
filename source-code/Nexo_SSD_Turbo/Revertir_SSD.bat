@echo off
:: =========================================================================
::   EL NEXO - REVERSION DE OPTIMIZACIONES v4.0
::   Modulo: Restaurar Configuracion Original [SSD]
:: =========================================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO v4.0 - REVERTIR OPTIMIZACIONES SSD
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
echo   PROTOCOLO: REVERSION DE OPTIMIZACIONES [SSD]
echo   VERSION: 4.0 - Estado: Restaurando configuracion...
echo  ============================================================
echo.

:: RESTORE LAST ACCESS
echo  [PASO 1/4] Restaurando registro de ultimo acceso...
echo.
fsutil behavior set disablelastaccess 2 >nul 2>&1
fsutil behavior set disable8dot3 2 >nul 2>&1
echo  [OK] Timestamps gestionados por el sistema.

:: RESTORE DISK TIMEOUT
echo.
echo  [PASO 2/4] Restaurando suspension de disco...
echo.
powercfg -change -disk-timeout-ac 20 >nul 2>&1
powercfg -change -disk-timeout-dc 10 >nul 2>&1
echo  [OK] Timeouts por defecto.

:: RESTORE MEMORY CACHE
echo.
echo  [PASO 3/4] Restaurando cache de memoria...
echo.
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IoPageLockLimit" /f >nul 2>&1
echo  [OK] Cache normalizada.

:: RESTORE PREFETCH
echo.
echo  [PASO 4/4] Restaurando servicios de prefetch...
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d 3 /f >nul 2>&1
echo  [OK] Prefetch activo.

:: FINALIZACION
echo.
echo  ============================================================
echo   REVERSION COMPLETADA CON EXITO
echo  ============================================================
echo.
echo   Tu SSD/NVMe ha sido restaurado a configuracion por defecto.
echo.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar el sistema ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando para completar la reversion..."

exit
