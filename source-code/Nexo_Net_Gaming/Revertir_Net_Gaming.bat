@echo off
title EL NEXO - Revertir Red (Default)
color 0A

:: 1. ADMIN CHECK
fsutil dirty query %systemdrive% >nul
if %errorlevel% neq 0 (
    echo ERROR: Necesitas permisos de Administrador.
    pause
    exit
)
cd /d "%~dp0"

echo ==========================================
echo    RESTAURANDO RED ESTANDAR
echo ==========================================
echo.

:: 1. Restaurar TCP Global
echo [1/2] Restaurando valores TCP...
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global rss=default >nul 2>&1
netsh int tcp set global timestamps=default >nul 2>&1

:: 2. Restaurar Algoritmo de congestion
echo [2/2] Restaurando proveedor de congestion...
netsh int tcp set supplemental template=internet congestionprovider=default >nul 2>&1

echo.
echo ==========================================
echo    RED RESTAURADA
echo ==========================================
pause