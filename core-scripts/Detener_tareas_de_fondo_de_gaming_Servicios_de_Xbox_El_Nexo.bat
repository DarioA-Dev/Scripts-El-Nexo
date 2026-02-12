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
echo   MODULO: GESTION DE TAREAS Y SERVICIOS
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

# 1. Restore Point
Write-Host ""
$backup = Read-Host "¿Deseas generar un Punto de Control de Ingeniería? (S/N)"
if ($backup -eq 'S') {
    Write-Host "   [+] Iniciando respaldo de configuración de sistema..." -ForegroundColor Yellow
    Checkpoint-Computer -Description 'Tareas El Nexo' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction SilentlyContinue
    Write-Host "   [OK] Punto de control establecido." -ForegroundColor Green
}

# 2. Background Apps Block
Write-Host "`n   [+] Sincronizando políticas de privacidad de aplicaciones..." -ForegroundColor Yellow
$policies = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"
if (!(Test-Path $policies)) { New-Item -Path $policies -Force | Out-Null }
Set-ItemProperty -Path $policies -Name "LetAppsRunInBackground" -Value 2 -Type DWord -ErrorAction SilentlyContinue

$bgApps = "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications"
if (!(Test-Path $bgApps)) { New-Item -Path $bgApps -Force | Out-Null }
Set-ItemProperty -Path $bgApps -Name "GlobalUserDisabled" -Value 1 -Type DWord -ErrorAction SilentlyContinue

$search = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
if (Test-Path $search) {
    Set-ItemProperty -Path $search -Name "BackgroundAppGlobalToggle" -Value 0 -Type DWord -ErrorAction SilentlyContinue
}
Write-Host "   [OK] Ejecución de aplicaciones en segundo plano neutralizada." -ForegroundColor Green

# 3. GameDVR
Write-Host "`n   [+] Desactivando monitorización de GameDVR..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehaviorMode" -Value 2 -Type DWord -ErrorAction SilentlyContinue
$dvrPolicy = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"
if (!(Test-Path $dvrPolicy)) { New-Item -Path $dvrPolicy -Force | Out-Null }
Set-ItemProperty -Path $dvrPolicy -Name "AllowgameDVR" -Value 0 -Type DWord -ErrorAction SilentlyContinue
Write-Host "   [OK] Captura de fondo desactivada." -ForegroundColor Green

# 4. Xbox Services
Write-Host "`n   [+] Deshabilitando servicios de Xbox Live y GameSave..." -ForegroundColor Yellow
$xboxServices = @("XblAuthManager", "XblGameSave", "XboxGipSvc", "XboxNetApiSvc", "GamingServices")
foreach ($s in $xboxServices) {
    Stop-Service -Name $s -Force -ErrorAction SilentlyContinue
    Set-Service -Name $s -StartupType Disabled -ErrorAction SilentlyContinue
}
Write-Host "   [OK] Servicios de ecosistema Xbox neutralizados." -ForegroundColor Green

# 5. Telemetry
Write-Host "`n   [+] Eliminando servicios de rastreo y recolección de datos..." -ForegroundColor Yellow
$telemetryServices = @("DiagTrack", "dmwappushservice", "WerSvc", "PcaSvc", "DPS", "RetailDemo")
foreach ($s in $telemetryServices) {
    Stop-Service -Name $s -Force -ErrorAction SilentlyContinue
    Set-Service -Name $s -StartupType Disabled -ErrorAction SilentlyContinue
}
Write-Host "   [OK] Telemetría y diagnóstico desactivados." -ForegroundColor Green

# 6. Gaming Priorities (Scheduler)
Write-Host "`n   [+] Ajustando prioridades del programador para Gaming..." -ForegroundColor Yellow
$gamesTask = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
if (Test-Path $gamesTask) {
    Set-ItemProperty -Path $gamesTask -Name "GPU Priority" -Value 8 -Type DWord -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $gamesTask -Name "Priority" -Value 6 -Type DWord -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $gamesTask -Name "Scheduling Category" -Value "High" -Type String -ErrorAction SilentlyContinue
}
Write-Host "   [OK] Jerarquía de procesos configurada para alto rendimiento." -ForegroundColor Green

# 7. Scheduled Tasks
Write-Host "`n   [+] Desactivando tareas programadas de mantenimiento..." -ForegroundColor Yellow
Disable-ScheduledTask -TaskName 'Microsoft\Windows\Defrag\ScheduledDefrag' -ErrorAction SilentlyContinue
Disable-ScheduledTask -TaskName 'Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser' -ErrorAction SilentlyContinue
Write-Host "   [OK] Tareas de fondo de bajo nivel desactivadas." -ForegroundColor Green

Write-Host "`n   ======================================================" -ForegroundColor Cyan
Write-Host "      PROTOCOLO DE TAREAS FINALIZADO." -ForegroundColor Cyan
Write-Host "      CPU LIBERADA PARA MÁXIMO RENDIMIENTO." -ForegroundColor Cyan
Write-Host "   ======================================================" -ForegroundColor Cyan

Write-Host "   [EXITO] Operacion finalizada." -ForegroundColor Green
Write-Host "   Presiona cualquier tecla para salir..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
