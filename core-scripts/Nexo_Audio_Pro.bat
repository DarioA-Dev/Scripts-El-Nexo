@echo off
title EL NEXO - Audio Pro Unlocked
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
echo    PRIORIDAD DE AUDIO MAXIMA
echo ==========================================
echo.

:: 1. Prioridad de Servicios de Audio
echo [1/2] Elevando prioridad de Windows Audio...
:: Esto hace que la CPU trate el sonido antes que otros procesos
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "GPU Priority" /t REG_DWORD /d 1 /f >nul 2>&1

:: 2. Optimizacion de Buffer
echo [2/2] Optimizando Network Throttling para audio...
:: Evita que la red corte el audio
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1

echo.
echo ==========================================
echo    AUDIO SIN LATENCIA ACTIVADO
echo ==========================================
echo Reinicia para notar la mejora.
pause