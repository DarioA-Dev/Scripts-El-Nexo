@echo off
:: =========================================================================
::   EL NEXO - REVERT: AUDIO PRO v5.0
::   Deshace los cambios de registro aplicados por Nexo_Audio_Pro.bat
::   NOTA: Los servicios de bloatware (Nahimic, Sonic) no se reactivan
::   automaticamente — requieren reinstalacion del software del fabricante.
:: =========================================================================
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO - REVERT Audio Pro
color 0E

net session >nul 2>openfiles >nul 2>&11
if %errorlevel% neq 0 (
    cls & color 0C
    echo  Se requieren permisos de Administrador.
    echo  Haz clic derecho y selecciona "Ejecutar como administrador"
    pause & exit /b
)

cls
color 0E
echo.
echo  ============================================================
echo   EL NEXO - REVERT: AUDIO PRO
echo   Restaurando configuracion original de audio...
echo  ============================================================
echo.

:: ── SCHEDULER MULTIMEDIA AUDIO ────────────────────────────────────────────
echo  [1/3] Restaurando prioridades del scheduler de audio...
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Scheduling Category" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "SFIO Priority" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "GPU Priority" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Priority" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Latency Sensitive" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "Scheduling Category" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "SFIO Priority" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "GPU Priority" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "Latency Sensitive" /f >nul 2>&1
echo  [OK] Prioridades de audio restauradas.

:: ── NETWORK THROTTLING ────────────────────────────────────────────────────
echo.
echo  [2/3] Restaurando throttling de red para audio...
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /f >nul 2>&1
echo  [OK] Throttling restaurado.

:: ── PROTECTED AUDIO ───────────────────────────────────────────────────────
echo.
echo  [3/3] Restaurando configuracion de audio protegido...
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Audio" /v "DisableProtectedAudioDG" /f >nul 2>&1
echo  [OK] Audio protegido restaurado.

echo.
echo  ============================================================
echo   REVERT COMPLETADO
echo  ============================================================
echo.
echo   IMPORTANTE: Nahimic, Sonic Studio y DTS siguen desactivados.
echo   Para reactivarlos, reinstala el software de tu placa base
echo   o descargalo desde la web del fabricante (ASUS, MSI, etc).
echo.
echo   Reinicia para aplicar los cambios de audio.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Revert Audio Pro El Nexo..."
exit
