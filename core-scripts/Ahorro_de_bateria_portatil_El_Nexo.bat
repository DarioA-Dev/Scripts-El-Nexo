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
echo   MODULO: AHORRO DE BATERIA PORTATIL
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
    Write-Host "   [+] Iniciando respaldo de configuración..." -ForegroundColor Yellow
    Checkpoint-Computer -Description 'Eco Nexo' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction SilentlyContinue
    Write-Host "   [OK] Punto de control establecido." -ForegroundColor Green
}

# 2. Power Plan (Eco)
Write-Host "`n   [+] Configurando Matriz Energética de bajo consumo..." -ForegroundColor Yellow
$nexo_eco_guid = "33333333-3333-3333-3333-333333333333"

# Cleanup & Create
powercfg -delete $nexo_eco_guid | Out-Null
powercfg -duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e $nexo_eco_guid | Out-Null
powercfg -changename $nexo_eco_guid "Ahorro Extremo El Nexo" | Out-Null
powercfg -setactive $nexo_eco_guid | Out-Null

# 3. CPU Caps
Write-Host "   [+] Aplicando restricciones de frecuencia al silicio..." -ForegroundColor Yellow
$boostPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7"
if (Test-Path $boostPath) {
    Set-ItemProperty -Path $boostPath -Name "Attributes" -Value 2 -Type DWord -ErrorAction SilentlyContinue
}
# Turbo Boost Disabled (0)
powercfg -setdcvalueindex $nexo_eco_guid 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 0
# Max Processor State 70%
powercfg -setdcvalueindex $nexo_eco_guid 54533251-82be-4824-96c1-47b60b740d00 bc5038f0-0a87-4fb1-a738-5c41205631cc 70
# Passive Cooling (0)
powercfg -setdcvalueindex $nexo_eco_guid 54533251-82be-4824-96c1-47b60b740d00 94d3a615-a899-4ac5-ae2b-e4d8f634367f 0

# 4. Hardware Optimization
Write-Host "   [+] Optimizando buses de datos para ahorro de energía..." -ForegroundColor Yellow
# ASPM Max Power Savings (2)
powercfg -setdcvalueindex $nexo_eco_guid sub_pciexpress aspm 2
# USB Suspend Enabled (1)
powercfg -setdcvalueindex $nexo_eco_guid sub_usb usbsuspend 1
Write-Host "   [OK] Buses de hardware configurados en ahorro máximo." -ForegroundColor Green

# 5. Power Throttling
Write-Host "`n   [+] Habilitando Power Throttling de Windows..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name "PowerThrottlingOff" -Value 0 -Type DWord -ErrorAction SilentlyContinue
Write-Host "   [OK] Power Throttling activo en el Kernel." -ForegroundColor Green

# 6. Visuals
Write-Host "`n   [+] Desactivando efectos visuales y transparencias..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x02,0x80,0x10,0x00,0x00,0x00)) -Type Binary -ErrorAction SilentlyContinue
Write-Host "   [OK] Interfaz simplificada." -ForegroundColor Green

# 7. Sleep Settings
Write-Host "`n   [+] Ajustando tiempos de inactividad críticos..." -ForegroundColor Yellow
powercfg -change -monitor-timeout-dc 2
powercfg -change -standby-timeout-dc 5
powercfg -h on | Out-Null
Write-Host "   [OK] Políticas de suspensión configuradas." -ForegroundColor Green

# 8. Background Apps
Write-Host "`n   [+] Neutralizando procesos de fondo durante modo batería..." -ForegroundColor Yellow
Get-AppxPackage -ErrorAction SilentlyContinue | ForEach-Object {
    $regKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications"
    if (Test-Path $regKey) {
        Set-ItemProperty -Path $regKey -Name 'GlobalUserDisabled' -Value 1 -Type DWord -ErrorAction SilentlyContinue
    }
}
Write-Host "   [OK] Sincronización de aplicaciones bloqueada." -ForegroundColor Green

Write-Host "`n   ======================================================" -ForegroundColor Cyan
Write-Host "      PROTOCOLO DE AUTONOMÍA FINALIZADO." -ForegroundColor Cyan
Write-Host "      TU PORTÁTIL AHORA ES UN NEXO DE EFICIENCIA." -ForegroundColor Cyan
Write-Host "   ======================================================" -ForegroundColor Cyan
Write-Host "   Nota: Es normal notar el sistema ligeramente más lento." -ForegroundColor Yellow

Write-Host "   [EXITO] Operacion finalizada." -ForegroundColor Green
Write-Host "   Presiona cualquier tecla para salir..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")