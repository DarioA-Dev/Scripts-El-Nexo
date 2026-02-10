@echo off
chcp 65001 >nul
title EL NEXO - SSD NVMe Turbo
color 0A

:: 1. ADMIN CHECK
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Necesitas permisos de Administrador.
    echo Haz clic derecho > Ejecutar como administrador.
    pause
    exit
)
cd /d "%~dp0"

echo ==========================================
echo    ACTIVANDO MODO SSD TURBO
echo ==========================================
echo.

:: PUNTO DE RESTAURACION
echo Creando punto de seguridad rapido...
powershell -Command "Checkpoint-Computer -Description 'Nexo SSD Turbo' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1

:: 1. Activar TRIM (Mantiene el SSD rapido)
echo [1/4] Forzando TRIM...
fsutil behavior set DisableDeleteNotify 0 >nul 2>&1

:: 2. Desactivar sellos de tiempo (Acelera lectura)
echo [2/4] Desactivando escritura de 'ultimo acceso'...
fsutil behavior set disablelastaccess 1 >nul 2>&1

:: 3. Evitar que el disco se duerma
echo [3/4] Evitando suspension del disco...
powercfg -change -disk-timeout-ac 0
powercfg -change -disk-timeout-dc 0

:: 4. Prioridad de Sistema de Archivos
echo [4/4] Optimizando memoria de sistema de archivos...
:: Aumenta el cache de archivos en RAM para no leer tanto del disco
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 1 /f >nul 2>&1

echo.
echo ==========================================
echo    SSD OPTIMIZADO
echo ==========================================
pause