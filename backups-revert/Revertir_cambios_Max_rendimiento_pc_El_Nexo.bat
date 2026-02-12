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
echo   MODULO: RESTAURAR EL NEXO (PC)
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

# 1. Restore Power
Write-Host "`n   [-] Restaurando planes de energía por defecto..." -ForegroundColor Yellow
powercfg -restoredefaultschemes | Out-Null
$balanced = "381b4222-f694-41f0-9685-ff5bb260df2e"
powercfg -setactive $balanced | Out-Null
Write-Host "   [OK] Plan Equilibrado activo." -ForegroundColor Green

# 2. Restore Kernel (BCD)
Write-Host "`n   [-] Eliminando modificaciones del Kernel (BCD)..." -ForegroundColor Yellow
Start-Process bcdedit -ArgumentList "/deletevalue disabledynamictick" -NoNewWindow -Wait -ErrorAction SilentlyContinue
Start-Process bcdedit -ArgumentList "/deletevalue useplatformclock" -NoNewWindow -Wait -ErrorAction SilentlyContinue
Start-Process bcdedit -ArgumentList "/deletevalue tscsyncpolicy" -NoNewWindow -Wait -ErrorAction SilentlyContinue
Start-Process bcdedit -ArgumentList "/deletevalue bootux" -NoNewWindow -Wait -ErrorAction SilentlyContinue
Start-Process bcdedit -ArgumentList "/deletevalue hypervisorlaunchtype" -NoNewWindow -Wait -ErrorAction SilentlyContinue
Write-Host "   [OK] Parametros de arranque limpios." -ForegroundColor Green

# 3. Restore Registry
Write-Host "`n   [-] Restaurando gestión de memoria y prioridades..." -ForegroundColor Yellow
$prioControl = "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"
if (Test-Path $prioControl) {
    Set-ItemProperty -Path $prioControl -Name "Win32PrioritySeparation" -Value 2 -Type DWord -ErrorAction SilentlyContinue
}

$memMan = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
if (Test-Path $memMan) {
    Set-ItemProperty -Path $memMan -Name "DisablePagingExecutive" -Value 0 -Type DWord -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $memMan -Name "LargeSystemCache" -Value 0 -Type DWord -ErrorAction SilentlyContinue
}

$sysProfile = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
if (Test-Path $sysProfile) {
    Set-ItemProperty -Path $sysProfile -Name "NetworkThrottlingIndex" -Value 10 -Type DWord -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $sysProfile -Name "SystemResponsiveness" -Value 20 -Type DWord -ErrorAction SilentlyContinue
}
Write-Host "   [OK] Claves de registro normalizadas." -ForegroundColor Green

# 4. Restore Services
Write-Host "`n   [-] Reactivando servicios de Windows..." -ForegroundColor Yellow
$services = @("DiagTrack", "dmwappushservice", "SysMain", "WerSvc", "MapsBroker", "PcaSvc", "DPS", "RetailDemo", "WSearch")
foreach ($s in $services) {
    Set-Service -Name $s -StartupType Automatic -ErrorAction SilentlyContinue
    Start-Service -Name $s -ErrorAction SilentlyContinue
}
Write-Host "   [OK] Servicios reactivados." -ForegroundColor Green

# 5. Restore GameDVR
Write-Host "`n   [-] Reactivando GameDVR..." -ForegroundColor Yellow
$gameConfig = "HKCU:\System\GameConfigStore"
if (Test-Path $gameConfig) {
    Set-ItemProperty -Path $gameConfig -Name "GameDVR_Enabled" -Value 1 -Type DWord -ErrorAction SilentlyContinue
}
$dvrPolicy = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"
if (Test-Path $dvrPolicy) {
    Set-ItemProperty -Path $dvrPolicy -Name "AllowGameDVR" -Value 1 -Type DWord -ErrorAction SilentlyContinue
}
Write-Host "   [OK] GameDVR activo." -ForegroundColor Green

Write-Host "`n   ======================================================" -ForegroundColor Cyan
Write-Host "      RESTAURACION COMPLETADA" -ForegroundColor Cyan
Write-Host "   ======================================================" -ForegroundColor Cyan
Write-Host "   El sistema ha vuelto a su configuración estándar." -ForegroundColor Yellow

Write-Host "   [EXITO] Operacion finalizada." -ForegroundColor Green
Write-Host "   Presiona cualquier tecla para salir..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")