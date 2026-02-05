@echo off
title EL NEXO - Revertir Audio (Default)
color 0D

:: 1. ADMIN CHECK
fsutil dirty query %systemdrive% >nul
if %errorlevel% neq 0 (
    echo ERROR: Necesitas permisos de Administrador.
    pause
    exit
)
cd /d "%~dp0"

echo ==========================================
echo    RESTAURANDO AUDIO ESTANDAR
echo ==========================================
echo.

:: 1. Restaurar Prioridad de Servicios
echo [1/2] Restaurando prioridad normal...
:: Borramos las claves forzadas para que Windows use las suyas
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Scheduling Category" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "SFIO Priority" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "GPU Priority" /f >nul 2>&1

:: 2. Restaurar Buffer y Red
echo [2/2] Restaurando Network Throttling...
:: Valor decimal 10 es el default de Windows
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 10 /f >nul 2>&1
:: Valor decimal 20 (20% CPU reservada para background) es default
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 20 /f >nul 2>&1

echo.
echo ==========================================
echo    AUDIO RESTAURADO
echo ==========================================
echo Reinicia para aplicar.
pause