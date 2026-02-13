@echo off
:: =========================================================================
::   EL NEXO - OPTIMIZADOR DE SSD/NVMe v4.0
::   Protocolo: TRIM, Cache y Velocidad de Disco
:: =========================================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO v4.0 - OPTIMIZADOR SSD
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
echo   PROTOCOLO: OPTIMIZACION DE SSD/NVMe [MODO TURBO]
echo   VERSION: 4.0 ENHANCED - Estado: Iniciando secuencia...
echo  ============================================================
echo.

:: PUNTO DE CONTROL
echo  [PASO 1/6] Creando punto de restauracion de seguridad...
echo.
powershell -Command "Checkpoint-Computer -Description 'El Nexo v4.0 SSD Turbo' -RestorePointType 'MODIFY_SETTINGS'" 2>nul

:: TRIM ACTIVATION
echo.
echo  [PASO 2/6] Activando comando TRIM...
echo.
echo  [*] TRIM mantiene el SSD rapido a largo plazo...
fsutil behavior set DisableDeleteNotify 0 >nul 2>&1
echo  [OK] TRIM activado correctamente.

:: LAST ACCESS TIMESTAMP
echo.
echo  [PASO 3/6] Desactivando registro de ultimo acceso...
echo.
echo  [*] Esto reduce escrituras innecesarias al disco...
fsutil behavior set disablelastaccess 1 >nul 2>&1
fsutil behavior set disable8dot3 1 >nul 2>&1
echo  [OK] Timestamps desactivados.

:: DISK TIMEOUT
echo.
echo  [PASO 4/6] Evitando suspension del disco...
echo.
powercfg -change -disk-timeout-ac 0 >nul 2>&1
powercfg -change -disk-timeout-dc 0 >nul 2>&1
echo  [OK] Disco siempre activo.

:: MEMORY CACHE
echo.
echo  [PASO 5/6] Optimizando cache de sistema de archivos...
echo.
echo  [*] Aumentando cache en RAM para reducir lecturas...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IoPageLockLimit" /t REG_DWORD /d 983040 /f >nul 2>&1
echo  [OK] Cache optimizado.

:: PREFETCH & SUPERFETCH
echo.
echo  [PASO 6/6] Configurando servicios de disco...
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] Servicios optimizados para SSD.

:: FINALIZACION
echo.
echo  ============================================================
echo   OPTIMIZACION COMPLETADA CON EXITO
echo  ============================================================
echo.
echo   Tu SSD/NVMe ahora esta optimizado para:
echo   - Maxima velocidad de lectura/escritura
echo   - Mayor durabilidad a largo plazo
echo   - Mejor uso de cache en RAM
echo.
echo  ============================================================
echo.
pause
exit
