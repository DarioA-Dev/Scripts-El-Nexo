@echo off
title EL NEXO - Red Gaming
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
echo    OPTIMIZACION DE RED GAMING
echo ==========================================
echo.

:: 1. Optimizar TCP (Ping mas estable)
echo [1/3] Configurando TCP Global...
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1

:: 2. Algoritmo de congestion (CTCP es mejor para juegos)
echo [2/3] Cambiando algoritmo de congestion...
netsh int tcp set supplemental template=internet congestionprovider=ctcp >nul 2>&1

:: 3. Firewall (Permitir trafico LAN fluido)
echo [3/3] Optimizando reglas de Firewall...
netsh advfirewall firewall set rule group="Deteccion de redes" new enable=Yes >nul 2>&1

echo.
echo ==========================================
echo    RED OPTIMIZADA
echo ==========================================
pause