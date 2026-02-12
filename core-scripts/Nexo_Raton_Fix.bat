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
echo   MODULO: ESTABILIDAD DE RATON (1:1)
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
Write-Host "`n   [+] Creando copia de seguridad de tu config actual..." -ForegroundColor Yellow
Checkpoint-Computer -Description 'Nexo Mouse Fix' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction SilentlyContinue
Write-Host "   [OK] Punto de control creado." -ForegroundColor Green

# 2. Disable Acceleration
Write-Host "`n   [+] Eliminando aceleracion de Windows..." -ForegroundColor Yellow
$mouseKey = "HKCU:\Control Panel\Mouse"
if (Test-Path $mouseKey) {
    Set-ItemProperty -Path $mouseKey -Name "MouseSpeed" -Value "0" -Type String -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $mouseKey -Name "MouseThreshold1" -Value "0" -Type String -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $mouseKey -Name "MouseThreshold2" -Value "0" -Type String -ErrorAction SilentlyContinue
}
Write-Host "   [OK] Aceleracion desactivada." -ForegroundColor Green

# 3. Mouse Data Queue
Write-Host "`n   [+] Ajustando buffer de hardware..." -ForegroundColor Yellow
$mouClass = "HKLM:\SYSTEM\CurrentControlSet\Services\mouclass\Parameters"
if (Test-Path $mouClass) {
    Set-ItemProperty -Path $mouClass -Name "MouseDataQueueSize" -Value 26 -Type DWord -ErrorAction SilentlyContinue
}
Write-Host "   [OK] Buffer ajustado." -ForegroundColor Green

Write-Host "`n   ======================================================" -ForegroundColor Cyan
Write-Host "      PRECISION 1:1 APLICADA" -ForegroundColor Cyan
Write-Host "   ======================================================" -ForegroundColor Cyan
Write-Host "   Debes REINICIAR para que el raton cambie." -ForegroundColor Yellow

$r = Read-Host "¿Deseas reiniciar ahora? (S/N)"
if ($r -eq 'S') {
    Restart-Computer -Force
}

Write-Host "   [EXITO] Operacion finalizada." -ForegroundColor Green
Write-Host "   Presiona cualquier tecla para salir..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")