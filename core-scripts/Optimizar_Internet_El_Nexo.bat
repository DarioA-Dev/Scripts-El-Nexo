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
echo   MODULO: OPTIMIZACION DE INTERNET
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
$rp = Read-Host "¿Generar punto de restauración de red? (S/N)"
if ($rp -eq 'S') {
    Write-Host "   [+] Ejecutando instantánea de configuración..." -ForegroundColor Yellow
    Checkpoint-Computer -Description 'Red El Nexo v4.0' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction SilentlyContinue
    Write-Host "   [OK] Punto de control generado." -ForegroundColor Green
}

# 2. TCP/IP Stack (Netsh calls)
Write-Host "`n   [+] Reconfigurando parámetros globales de la pila TCP..." -ForegroundColor Yellow
Start-Process netsh -ArgumentList "int tcp set global autotuninglevel=normal" -NoNewWindow -Wait
Start-Process netsh -ArgumentList "int tcp set global heuristics=disabled" -NoNewWindow -Wait
Start-Process netsh -ArgumentList "int tcp set global rss=enabled" -NoNewWindow -Wait
Start-Process netsh -ArgumentList "int tcp set global fastopen=enabled" -NoNewWindow -Wait
Start-Process netsh -ArgumentList "int tcp set global timestamps=disabled" -NoNewWindow -Wait
Start-Process netsh -ArgumentList "int tcp set global ecncapability=disabled" -NoNewWindow -Wait
Start-Process netsh -ArgumentList "int tcp set supplemental template=internet congestionprovider=cubic" -NoNewWindow -Wait
Write-Host "   [OK] Pila TCP/IP optimizada." -ForegroundColor Green

# 3. Registry Tweaks (Throttling)
Write-Host "`n   [+] Ajustando índices de respuesta del sistema..." -ForegroundColor Yellow
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
if (Test-Path $regPath) {
    Set-ItemProperty -Path $regPath -Name "NetworkThrottlingIndex" -Value 0xFFFFFFFF -Type DWord
    Set-ItemProperty -Path $regPath -Name "SystemResponsiveness" -Value 0 -Type DWord
    Write-Host "   [OK] Restricciones de red multimedia desactivadas." -ForegroundColor Green
} else {
    Write-Host "   [!] Ruta de registro no encontrada." -ForegroundColor Red
}

# 4. MSI Mode
Write-Host "`n   [+] Sincronizando Modo MSI en controladores de red..." -ForegroundColor Yellow
$pci = 'HKLM:\SYSTEM\CurrentControlSet\Enum\PCI'
if (Test-Path $pci) {
    Get-ChildItem $pci -Recurse | Where-Object { $_.Name -like '*Interrupt Management*' } | ForEach-Object {
        $msi = "Registry::$($_.Name)\MessageSignaledInterruptProperties"
        if (Test-Path $msi) {
            Set-ItemProperty -Path $msi -Name 'MSISupported' -Value 1 -Type DWord -ErrorAction SilentlyContinue
        }
    }
}
Write-Host "   [OK] Interrupciones de hardware optimizadas." -ForegroundColor Green

# 5. TcpAckFrequency
Write-Host "`n   [+] Aplicando TcpAckFrequency a interfaces activas..." -ForegroundColor Yellow
$interfaces = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces'
if (Test-Path $interfaces) {
    Get-ChildItem $interfaces | ForEach-Object {
        Set-ItemProperty -Path $_.PSPath -Name 'TcpAckFrequency' -Value 1 -Type DWord -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $_.PSPath -Name 'TCPNoDelay' -Value 1 -Type DWord -ErrorAction SilentlyContinue
    }
}
Write-Host "   [OK] Confirmación instantánea de paquetes activada." -ForegroundColor Green

# 6. Hybrid Protocol (Laptop/Wifi)
Write-Host ""
$laptop = Read-Host "¿El sistema es un Portátil o usa Wi-Fi? (S/N)"
if ($laptop -eq 'S') {
    Write-Host "   [+] Desactivando gestión de energía en adaptadores inalámbricos..." -ForegroundColor Yellow
    Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | ForEach-Object {
        Disable-NetAdapterPowerManagement -Name $_.Name -ErrorAction SilentlyContinue 
    }
    Write-Host "   [OK] Ahorro de energía Wi-Fi neutralizado." -ForegroundColor Green
}

# 7. DNS Turbo
Write-Host ""
$dns = Read-Host "¿Deseas inyectar DNS de Cloudflare (1.1.1.1)? (S/N)"
if ($dns -eq 'S') {
    Write-Host "   [+] Configurando servidores DNS..." -ForegroundColor Yellow
    $adapters = Get-NetAdapter | Where-Object {$_.Status -eq 'Up'}
    foreach ($a in $adapters) {
        Set-DnsClientServerAddress -InterfaceAlias $a.Name -ServerAddresses ('1.1.1.1','1.0.0.1') -ErrorAction SilentlyContinue
    }
    Write-Host "   [OK] DNS de alta velocidad establecido." -ForegroundColor Green
}

# 8. Purge
Write-Host "`n   [AVISO] Se ejecutará un reinicio de la configuración IP." -ForegroundColor Yellow
Write-Host "   [+] Reiniciando caché de resolución y sockets..." -ForegroundColor Yellow
Start-Process ipconfig -ArgumentList "/flushdns" -NoNewWindow -Wait
Start-Process netsh -ArgumentList "winsock reset" -NoNewWindow -Wait
Start-Process netsh -ArgumentList "int ip reset" -NoNewWindow -Wait

Write-Host "`n   ======================================================" -ForegroundColor Cyan
Write-Host "      PROTOCOLO COMPLETADO. SISTEMA SINCRONIZADO." -ForegroundColor Cyan
Write-Host "   ======================================================" -ForegroundColor Cyan

$r = Read-Host "¿Deseas reiniciar ahora para aplicar cambios? (S/N)"
if ($r -eq 'S') {
    Restart-Computer -Force
}

Write-Host "   [EXITO] Operacion finalizada." -ForegroundColor Green
Write-Host "   Presiona cualquier tecla para salir..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
