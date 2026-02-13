@echo off
chcp 65001 >nul
title EL NEXO - REVERTIR AUDIO
color 0E

:: ADMIN CHECK
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Necesitas permisos de Administrador.
    echo Haz clic derecho ^> Ejecutar como administrador.
    pause
    exit
)

echo ==========================================
echo    RESTAURAR AUDIO A VALORES DEFAULT
echo ==========================================
echo.

echo [1/2] Restaurando prioridad normal...
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Scheduling Category" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "SFIO Priority" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "GPU Priority" /f >nul 2>&1

echo [2/2] Restaurando Network Throttling...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 10 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 20 /f >nul 2>&1

echo.
echo ==========================================
echo    AUDIO RESTAURADO
echo ==========================================
echo Reinicia para aplicar.
pause