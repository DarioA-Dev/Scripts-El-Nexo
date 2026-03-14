@echo off
:: =========================================================================
::   EL NEXO - REVERT: PROCESS KILLER v5.0
::   Reactiva los servicios desactivados PERMANENTEMENTE por niveles 2 y 3.
::   NOTA: Los procesos cerrados (kills) no se pueden revertir — se
::   reiniciaran solos con el siguiente reinicio del PC.
:: =========================================================================
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO - REVERT Process Killer
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
echo   EL NEXO - REVERT: PROCESS KILLER
echo   Reactivando servicios desactivados permanentemente...
echo  ============================================================
echo.
echo  NOTA: Este revert solo aplica a los SERVICIOS desactivados
echo  en los niveles 2 y 3. Los procesos cerrados se reiniciaran
echo  solos al reiniciar el PC.
echo.

:: ── SERVICIOS NIVEL 2 ─────────────────────────────────────────────────────
echo  [1/3] Restaurando servicios desactivados en Nivel 2...
for %%s in (gupdate gupdatem edgeupdate edgeupdatem AdobeARMservice WSearch DiagTrack dmwappushservice) do (
    sc config %%s start=auto >nul 2>&1
    sc start %%s >nul 2>&1
    echo  [*] Reactivado: %%s
)
echo  [OK] Servicios Nivel 2 restaurados.

:: ── SERVICIOS NIVEL 3 ─────────────────────────────────────────────────────
echo.
echo  [2/3] Restaurando servicios desactivados en Nivel 3...
for %%s in (XblAuthManager XblGameSave XboxNetApiSvc SysMain DiagTrack dmwappushservice) do (
    sc config %%s start=auto >nul 2>&1
    sc start %%s >nul 2>&1
    echo  [*] Reactivado: %%s
)
echo  [OK] Servicios Nivel 3 restaurados.

:: ── GAME BAR ──────────────────────────────────────────────────────────────
echo.
echo  [3/3] Restaurando Game Bar...
powershell -Command "
    \$gbKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR'
    if (-not (Test-Path \$gbKey)) { New-Item \$gbKey -Force | Out-Null }
    Set-ItemProperty \$gbKey 'AppCaptureEnabled' 1 -Type DWord
    Set-ItemProperty \$gbKey 'GameDVR_Enabled' 1 -Type DWord
    Remove-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR' 'AllowGameDVR' -ErrorAction SilentlyContinue
    Remove-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' 'AllowCortana' -ErrorAction SilentlyContinue
" >nul 2>&1
echo  [OK] Game Bar restaurado.

echo.
echo  ============================================================
echo   REVERT COMPLETADO
echo  ============================================================
echo.
echo   IMPORTANTE:
echo   - Los PROCESOS cerrados (launchers, updaters) se reiniciaran
echo     solos al arrancar el PC o al abrir sus aplicaciones.
echo   - El software RGB (Armoury Crate, iCUE, etc) requiere
echo     reinstalacion si fue desactivado en Nivel 3.
echo.
echo   Reinicia para que todos los servicios arranquen correctamente.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Revert Process Killer El Nexo..."
exit
