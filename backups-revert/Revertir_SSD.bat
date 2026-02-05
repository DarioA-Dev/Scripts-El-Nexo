@echo off
title EL NEXO - Revertir SSD (Default)
color 0B

:: 1. ADMIN CHECK
fsutil dirty query %systemdrive% >nul
if %errorlevel% neq 0 (
    echo ERROR: Necesitas permisos de Administrador.
    pause
    exit
)
cd /d "%~dp0"

echo ==========================================
echo    RESTAURANDO VALORES SSD DE FABRICA
echo ==========================================
echo.

:: 1. Restaurar timestamps (Default de Windows)
echo [1/3] Restaurando LastAccessUpdate...
:: El valor 2 es "Gestionado por el sistema" (Default moderno)
fsutil behavior set disablelastaccess 2 >nul 2>&1

:: 2. Restaurar suspension de disco
echo [2/3] Restaurando tiempo de espera disco...
:: 20 Minutos es el estandar
powercfg -change -disk-timeout-ac 20
powercfg -change -disk-timeout-dc 10

:: 3. Quitar prioridad de sistema de archivos
echo [3/3] Restaurando gestion de memoria...
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /f >nul 2>&1

echo.
echo ==========================================
echo    SSD RESTAURADO A NORMAL
echo ==========================================
pause