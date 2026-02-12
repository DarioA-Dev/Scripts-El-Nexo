<# : batch script hack
@echo off
:: ==========================================================================
::   EL NEXO - SUITE DE OPTIMIZACION v4.0
::   (C) 2026 DarioA-Dev | Engineering Dept.
:: ==========================================================================
::   ARQUITECTURA: Hybrid PowerShell Wrapper (Stable)
:: ==========================================================================

:: 1. INICIO ROBUSTO
chcp 65001 >nul
setlocal
cd /d "%~dp0"
title [EL NEXO] Kernel Optimizer
color 0B

:: 2. INTERFAZ (ASCII CON ESCAPE CORRECTO)
cls
echo.
echo   ______ _       _   _ ______   _____
echo  ^|  ____^| ^|     ^| \ ^| ^|  ____^| \ \ / / _ \
echo  ^| ^|__  ^| ^|     ^|  \^| ^| ^|__     \ V / ^| ^| ^|
echo  ^|  __^| ^| ^|     ^| . ` ^|  __^|     ^> ^<^| ^| ^| ^|
echo  ^| ^|____^| ^|____ ^| ^|\  ^| ^|____   / . \ ^|_^| ^|
echo  ^|______^|______^|_^| \_^|______^| /_/ \_\___/
echo.
echo  ==========================================================================
echo   MODULO: RESTAURAR TAREAS DE FONDO
echo   INFO: Optimizando... Por favor espere.
echo  ==========================================================================
echo.

:: 3. ELEVACION DE PRIVILEGIOS (ADMIN)
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo   [!] SOLICITANDO PERMISOS DE ADMINISTRADOR...
    powershell -Command "Start-Process -Verb RunAs -FilePath '%~f0'"
    exit /b
)

:: 4. LANZAMIENTO DEL MOTOR POWERSHELL
:: Lee este mismo archivo, ignora las lineas Batch y ejecuta el resto
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-Expression -Command ((Get-Content -LiteralPath '%~f0') -join \"`n\")"
exit /b
:>

# ===========================================================================
#  ZONA POWERSHELL (AQUI EMPIEZA LA LOGICA REAL)
# ===========================================================================
$Host.UI.RawUI.WindowTitle = "[EL NEXO] Motor Hibrido Activo"
Write-Host "   [CORE] Cargando modulos del sistema..." -ForegroundColor Cyan

# 1. Background Apps
Write-Host "`n   [-] Habilitando permisos de aplicaciones en segundo plano..." -ForegroundColor Yellow
$appPrivacy = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"
if (Test-Path $appPrivacy) {
    Set-ItemProperty -Path $appPrivacy -Name "LetAppsRunInBackground" -Value 0 -Type DWord -ErrorAction SilentlyContinue
}
$bgApps = "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications"
if (Test-Path $bgApps) {
    Set-ItemProperty -Path $bgApps -Name "GlobalUserDisabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue
}
Write-Host "   [OK] Apps de fondo permitidas." -ForegroundColor Green

# 2. Xbox Services
Write-Host "`n   [-] Reconfigurando servicios de Xbox a modo Automático/Manual..." -ForegroundColor Yellow
$xboxServices = @("XblAuthManager", "XblGameSave", "XboxGipSvc", "XboxNetApiSvc", "GamingServices")
foreach ($s in $xboxServices) {
    Set-Service -Name $s -StartupType Manual -ErrorAction SilentlyContinue
}
Write-Host "   [OK] Servicios de Xbox restaurados." -ForegroundColor Green

# 3. GameDVR
Write-Host "`n   [-] Habilitando GameDVR y Barra de Juegos..." -ForegroundColor Yellow
$gameConfig = "HKCU:\System\GameConfigStore"
if (Test-Path $gameConfig) {
    Set-ItemProperty -Path $gameConfig -Name "GameDVR_Enabled" -Value 1 -Type DWord -ErrorAction SilentlyContinue
}
$dvrPolicy = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"
if (Test-Path $dvrPolicy) {
    Set-ItemProperty -Path $dvrPolicy -Name "AllowgameDVR" -Value 1 -Type DWord -ErrorAction SilentlyContinue
}
Write-Host "   [OK] GameDVR habilitado." -ForegroundColor Green

Write-Host "`n   ======================================================" -ForegroundColor Cyan
Write-Host "      RESTAURACION COMPLETADA" -ForegroundColor Cyan
Write-Host "   ======================================================" -ForegroundColor Cyan
Write-Host "   Servicios y procesos restaurados." -ForegroundColor Yellow

Write-Host "   [EXITO] Operacion finalizada." -ForegroundColor Green
Write-Host "   Presiona cualquier tecla para salir..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")