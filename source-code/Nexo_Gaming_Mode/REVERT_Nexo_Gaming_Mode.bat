@echo off
:: =========================================================================
::   EL NEXO - REVERT: GAMING MODE v5.0
::   Deshace todos los cambios aplicados por Nexo_Gaming_Mode.bat
:: =========================================================================
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO - REVERT Gaming Mode
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
echo   EL NEXO - REVERT: GAMING MODE
echo   Restaurando configuracion original del sistema...
echo  ============================================================
echo.

:: ── GAME DVR Y XBOX ────────────────────────────────────────────────────────
echo  [1/6] Restaurando Xbox Game Bar y DVR...
reg delete "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowgameDVR" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /f >nul 2>&1
echo  [OK] Game Bar y DVR restaurados a valores por defecto.

:: ── NVIDIA ────────────────────────────────────────────────────────────────
echo.
echo  [2/6] Restaurando overlay de NVIDIA...
reg delete "HKCU\Software\NVIDIA Corporation\Global\Shadow Play\NVSCPSSVC" /v "EnableWRTD" /f >nul 2>&1
echo  [OK] NVIDIA Instant Replay restaurado.

:: ── STEAM ─────────────────────────────────────────────────────────────────
echo.
echo  [3/6] Restaurando overlay de Steam...
reg delete "HKCU\Software\Valve\Steam" /v "NoGameOverlay" /f >nul 2>&1
echo  [OK] Steam overlay restaurado.

:: ── SCHEDULER MULTIMEDIA ──────────────────────────────────────────────────
echo.
echo  [4/6] Restaurando prioridades del scheduler...
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /f >nul 2>&1
echo  [OK] Scheduler restaurado.

:: ── SERVICIOS XBOX Y TELEMETRIA ───────────────────────────────────────────
echo.
echo  [5/6] Reactivando servicios de Xbox y telemetria...
for %%s in (XblAuthManager XblGameSave XboxNetApiSvc) do (
    sc config %%s start=auto >nul 2>&1
    sc start %%s >nul 2>&1
)
for %%s in (DiagTrack WerSvc PcaSvc DPS) do (
    sc config %%s start=auto >nul 2>&1
    sc start %%s >nul 2>&1
)
echo  [OK] Servicios restaurados.

:: ── APPS DE FONDO ─────────────────────────────────────────────────────────
echo.
echo  [6/6] Restaurando apps de segundo plano...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /f >nul 2>&1
echo  [OK] Apps de fondo restauradas.

:: ── NOTA SOBRE AUDIO ──────────────────────────────────────────────────────
echo.
echo  NOTA: Nahimic y Sonic Studio NO se reactivan automaticamente.
echo  Si los necesitas, reinstalalos desde el software de tu placa base.

echo.
echo  ============================================================
echo   REVERT COMPLETADO
echo  ============================================================
echo   Reinicia el PC para que todos los cambios tomen efecto.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Revert Gaming Mode El Nexo..."
exit
