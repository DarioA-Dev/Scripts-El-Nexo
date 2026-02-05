@echo off
:: ==========================================================
::   EL NEXO - PROTOCOLO DE RESTAURACIÓN DE TAREAS
::   Objetivo: Reestablecer servicios de Xbox y Apps de Fondo
:: ==========================================================
chcp 65001 >nul
title EL NEXO: RESTAURAR TAREAS Y SERVICIOS
color 0B

net session >nul 2>&1
if %errorlevel% neq 0 (echo [!] Error: Se requiere nivel de Administrador. & pause & exit)

echo ======================================================
echo      REESTABLECIENDO PROCESOS DE FONDO Y XBOX
echo ======================================================

:: 1. REACTIVAR APLICACIONES DE FONDO
echo [-] Habilitando permisos de aplicaciones en segundo plano...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: 2. REACTIVAR SERVICIOS DE XBOX Y GAMEBAR
echo [-] Reconfigurando servicios de Xbox a modo Automático...
for %%s in (XblAuthManager, XblGameSave, XboxGipSvc, XboxNetApiSvc, GamingServices) do (
    sc config %%s start= demand >nul 2>&1
)

:: 3. RESTAURAR GAME DVR
echo [-] Habilitando GameDVR y Barra de Juegos...
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowgameDVR" /t REG_DWORD /d 1 /f >nul

echo [OK] Servicios y procesos restaurados.
pause
exit