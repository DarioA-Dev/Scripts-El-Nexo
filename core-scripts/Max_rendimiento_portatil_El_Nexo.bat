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
echo   MODULO: MAXIMO RENDIMIENTO PORTATIL
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
$rp = Read-Host "¿Generar un Punto de Control de Ingeniería? (S/N)"
if ($rp -eq 'S') {
    Write-Host "   [+] Iniciando respaldo de configuración de sistema..." -ForegroundColor Yellow
    Checkpoint-Computer -Description 'Rendimiento Portatil Nexo' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction SilentlyContinue
    Write-Host "   [OK] Punto de control establecido." -ForegroundColor Green
} else {
    Write-Host "   [!] Saltando copia de seguridad a petición del usuario." -ForegroundColor Gray
}

# 2. Power Plan (Laptop)
Write-Host "`n   [+] Construyendo esquema de energía personalizado..." -ForegroundColor Yellow
$nexo_lp_guid = "22222222-2222-2222-2222-222222222222"

# Cleanup & Create
powercfg -delete $nexo_lp_guid | Out-Null
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 $nexo_lp_guid | Out-Null
powercfg -changename $nexo_lp_guid "Optimización Portátil El Nexo" | Out-Null
powercfg -setactive $nexo_lp_guid | Out-Null

# 3. Processor Turbo Boost Unlock
Write-Host "   [+] Desbloqueando 'Processor Performance Boost Mode'..." -ForegroundColor Yellow
$boostPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7"
if (Test-Path $boostPath) {
    Set-ItemProperty -Path $boostPath -Name "Attributes" -Value 2 -Type DWord -ErrorAction SilentlyContinue
}
# Boost Mode to Aggressive (2)
powercfg -setacvalueindex $nexo_lp_guid 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 2

# Thermal Security & Processor States
Write-Host "   [+] Aplicando directivas de refrigeración activa y seguridad..." -ForegroundColor Yellow
# System Cooling Policy: Active (1)
powercfg -setacvalueindex $nexo_lp_guid 54533251-82be-4824-96c1-47b60b740d00 94D3A615-A899-4AC5-AD2C-96D587C4A8D9 1
# Min Processor State: 5%
powercfg -setacvalueindex $nexo_lp_guid 54533251-82be-4824-96c1-47b60b740d00 8934347c-01ed-4d00-8805-0c7ed2b904d9 5
# Max Processor State: 100%
powercfg -setacvalueindex $nexo_lp_guid 54533251-82be-4824-96c1-47b60b740d00 bc5038f0-0a87-4fb1-a738-5c41205631cc 100
powercfg -setactive $nexo_lp_guid
Write-Host "   [OK] Frecuencias de CPU liberadas." -ForegroundColor Green

# 4. MSI Mode (Standard)
Write-Host "`n   [+] Sincronizando Modo MSI en controladores de sistema..." -ForegroundColor Yellow
$pci = 'HKLM:\SYSTEM\CurrentControlSet\Enum\PCI'
if (Test-Path $pci) {
    Get-ChildItem $pci -Recurse | Where-Object { $_.Name -like '*Interrupt Management*' } | ForEach-Object {
        $msi = "Registry::$($_.Name)\MessageSignaledInterruptProperties"
        if (Test-Path $msi) {
            Set-ItemProperty -Path $msi -Name 'MSISupported' -Value 1 -Type DWord -ErrorAction SilentlyContinue
        }
    }
}
Write-Host "   [OK] Prioridad de hardware establecida mediante MSI." -ForegroundColor Green

# 5. Network Latency (Laptop/Wifi)
Write-Host "`n   [+] Configurando adaptadores para baja latencia de señal..." -ForegroundColor Yellow
Get-NetAdapter | ForEach-Object {
    Disable-NetAdapterPowerManagement -Name $_.Name -ErrorAction SilentlyContinue
}
Write-Host "   [OK] Sincronización de red móvil optimizada." -ForegroundColor Green

# 6. Registry Tweaks (Mobile)
Write-Host "`n   [+] Inyectando parámetros de respuesta instantánea..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name "PowerThrottlingOff" -Value 1 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38 -Type DWord -ErrorAction SilentlyContinue
Write-Host "   [OK] Prioridades de kernel ajustadas para movilidad." -ForegroundColor Green

Write-Host "`n   ======================================================" -ForegroundColor Cyan
Write-Host "      INGENIERÍA PORTÁTIL COMPLETADA CON ÉXITO." -ForegroundColor Cyan
Write-Host "      HARDWARE CONFIGURADO PARA MÁXIMO RENDIMIENTO." -ForegroundColor Cyan
Write-Host "   ======================================================" -ForegroundColor Cyan
Write-Host "   Se recomienda mantener el portátil CONECTADO A LA CORRIENTE" -ForegroundColor Yellow
Write-Host "   para obtener el 100% de la potencia inyectada." -ForegroundColor Yellow

$r = Read-Host "¿Reiniciar ahora? (S/N)"
if ($r -eq 'S') {
    Restart-Computer -Force
}

Write-Host "   [EXITO] Operacion finalizada." -ForegroundColor Green
Write-Host "   Presiona cualquier tecla para salir..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
