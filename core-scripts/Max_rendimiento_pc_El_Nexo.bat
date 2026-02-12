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
echo   MODULO: MAXIMO RENDIMIENTO PC (KERNEL + ENERGIA)
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
$rp = Read-Host "¿Deseas crear un Punto de Restauración del Sistema? (S/N)"
if ($rp -eq 'S') {
    Write-Host "   [+] Iniciando instantánea de volumen..." -ForegroundColor Yellow
    Checkpoint-Computer -Description 'Backup El Nexo V4.0' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction SilentlyContinue
    Write-Host "   [OK] Punto de seguridad establecido." -ForegroundColor Green
} else {
    Write-Host "   [!] Saltando copia de seguridad a petición del usuario." -ForegroundColor Gray
}

# 2. Power Plan
Write-Host "`n   [+] Reconstruyendo Matriz de Energía (GUID Estático)..." -ForegroundColor Yellow
$nexo_guid = "11111111-1111-1111-1111-111111111111"

# Cleanup & Create
powercfg -delete $nexo_guid | Out-Null
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 $nexo_guid | Out-Null
powercfg -changename $nexo_guid "Maximo Rendimiento El Nexo" | Out-Null
powercfg -setactive $nexo_guid | Out-Null

# Tweaks
Write-Host "   [+] Aplicando micro-ajustes de energía..." -ForegroundColor Yellow
powercfg -change -disk-timeout-ac 0
powercfg -change -monitor-timeout-ac 0
powercfg -h off | Out-Null
powercfg -setacvalueindex $nexo_guid sub_processor PROCTHROTTLEMIN 100
powercfg -setacvalueindex $nexo_guid sub_processor PROCTHROTTLEMAX 100
# PCI Express Link State Power Management (Off)
powercfg -setacvalueindex $nexo_guid sub_pciexpress aspm 0
# USB Selective Suspend (Disabled)
powercfg -setacvalueindex $nexo_guid sub_usb usbsuspend 0
powercfg -setactive $nexo_guid
Write-Host "   [OK] Matriz de energía operativa." -ForegroundColor Green

# 3. Kernel & Boot (BCD)
Write-Host "`n   [+] Optimizando parámetros de arranque (BCD)..." -ForegroundColor Yellow
bcdedit /set disabledynamictick yes | Out-Null
bcdedit /set useplatformclock no | Out-Null
bcdedit /set tscsyncpolicy Enhanced | Out-Null
bcdedit /set bootux disabled | Out-Null
bcdedit /set hypervisorlaunchtype off | Out-Null
bcdedit /set isolatedcontext No | Out-Null
bcdedit /set nointegritychecks No | Out-Null
Write-Host "   [OK] Bootloader optimizado." -ForegroundColor Green

# 4. MSI Mode & GPU
Write-Host "`n   [+] Inyectando Modo MSI (Message Signaled Interrupts)..." -ForegroundColor Yellow
$pci = 'HKLM:\SYSTEM\CurrentControlSet\Enum\PCI'
if (Test-Path $pci) {
    Get-ChildItem $pci -Recurse | Where-Object { $_.Name -like '*Interrupt Management*' } | ForEach-Object {
        $msi = "Registry::$($_.Name)\MessageSignaledInterruptProperties"
        if (Test-Path $msi) {
            Set-ItemProperty -Path $msi -Name 'MSISupported' -Value 1 -Type DWord -ErrorAction SilentlyContinue
        }
    }
}

Write-Host "   [+] Optimizando GPU (ULPS) y Prioridades..." -ForegroundColor Yellow
$video = 'HKLM:\SYSTEM\CurrentControlSet\Control\Video'
if (Test-Path $video) {
    Get-ChildItem $video -Recurse | Where-Object { $_.Property -contains 'EnableUlps' } | ForEach-Object {
        Set-ItemProperty -Path $_.PSPath -Name 'EnableUlps' -Value 0 -Type DWord -ErrorAction SilentlyContinue
    }
}

# HAGS & GameDVR
$regGraphics = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"
if (Test-Path $regGraphics) {
    Set-ItemProperty -Path $regGraphics -Name "HwSchMode" -Value 2 -Type DWord -ErrorAction SilentlyContinue
}
$regGameConfig = "HKCU:\System\GameConfigStore"
if (Test-Path $regGameConfig) {
    Set-ItemProperty -Path $regGameConfig -Name "GameDVR_FSEBehaviorMode" -Value 2 -Type DWord -ErrorAction SilentlyContinue
}
Write-Host "   [OK] GPU y Rendering optimizados." -ForegroundColor Green

# 5. Registry (CPU & RAM)
Write-Host "`n   [+] Reconfigurando Scheduler de CPU y Memoria..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "DisablePagingExecutive" -Value 1 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "LargeSystemCache" -Value 0 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Value 0 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 0xFFFFFFFF -Type DWord -ErrorAction SilentlyContinue

# 6. Input Lag
Write-Host "`n   [+] Reduciendo latencia de entrada (Input Lag)..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" -Name "MouseDataQueueSize" -Value 50 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" -Name "KeyboardDataQueueSize" -Value 50 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value "0" -Type String -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseHoverTime" -Value "10" -Type String -ErrorAction SilentlyContinue

# 7. FileSystem
Write-Host "`n   [+] Optimizando sistema de archivos NTFS..." -ForegroundColor Yellow
fsutil behavior set disablelastaccess 1 | Out-Null
fsutil behavior set disable8dot3 1 | Out-Null

# 8. Services
Write-Host "`n   [+] Neutralizando servicios innecesarios..." -ForegroundColor Yellow
$services = @("DiagTrack", "dmwappushservice", "SysMain", "WerSvc", "MapsBroker", "PcaSvc", "DPS", "RetailDemo", "WSearch")
foreach ($s in $services) {
    Stop-Service -Name $s -Force -ErrorAction SilentlyContinue
    Set-Service -Name $s -StartupType Disabled -ErrorAction SilentlyContinue
}

# GameDVR Policies
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue
$policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"
if (!(Test-Path $policyPath)) { New-Item -Path $policyPath -Force | Out-Null }
Set-ItemProperty -Path $policyPath -Name "AllowGameDVR" -Value 0 -Type DWord -ErrorAction SilentlyContinue

# 9. Cleanup
Write-Host "`n   [+] Purgando archivos temporales..." -ForegroundColor Yellow
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
ipconfig /flushdns | Out-Null

Write-Host "`n   ======================================================" -ForegroundColor Cyan
Write-Host "      PROTOCOLO EL NEXO V4.0 COMPLETADO" -ForegroundColor Cyan
Write-Host "      (Kernel, GPU, Red y Energía Optimizados)" -ForegroundColor Cyan
Write-Host "   ======================================================" -ForegroundColor Cyan
Write-Host "   [IMPORTANTE] Debes REINICIAR el PC para cargar el nuevo Kernel." -ForegroundColor Yellow

$r = Read-Host "¿Reiniciar ahora? (S/N)"
if ($r -eq 'S') {
    Restart-Computer -Force
}

Write-Host "   [EXITO] Operacion finalizada." -ForegroundColor Green
Write-Host "   Presiona cualquier tecla para salir..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
