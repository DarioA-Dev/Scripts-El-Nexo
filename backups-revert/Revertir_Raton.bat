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
echo   MODULO: REVERTIR RATON (DEFAULT)
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

# 1. Restore Acceleration
Write-Host "`n   [1/2] Reactivando aceleracion..." -ForegroundColor Yellow
$mouseKey = "HKCU:\Control Panel\Mouse"
if (Test-Path $mouseKey) {
    Set-ItemProperty -Path $mouseKey -Name "MouseSpeed" -Value "1" -Type String -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $mouseKey -Name "MouseThreshold1" -Value "6" -Type String -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $mouseKey -Name "MouseThreshold2" -Value "10" -Type String -ErrorAction SilentlyContinue
}
Write-Host "   [OK] Aceleracion por defecto." -ForegroundColor Green

# 2. Restore Buffer
Write-Host "`n   [2/2] Restaurando MouseDataQueueSize..." -ForegroundColor Yellow
$mouClass = "HKLM:\SYSTEM\CurrentControlSet\Services\mouclass\Parameters"
if (Test-Path $mouClass) {
    Remove-ItemProperty -Path $mouClass -Name "MouseDataQueueSize" -ErrorAction SilentlyContinue
}
Write-Host "   [OK] Buffer de hardware original." -ForegroundColor Green

Write-Host "`n   ======================================================" -ForegroundColor Cyan
Write-Host "      CONFIGURACION ORIGINAL APLICADA" -ForegroundColor Cyan
Write-Host "   ======================================================" -ForegroundColor Cyan
Write-Host "   Debes REINICIAR el PC." -ForegroundColor Yellow

$r = Read-Host "¿Deseas reiniciar ahora? (S/N)"
if ($r -eq 'S') {
    Restart-Computer -Force
}

Write-Host "   [EXITO] Operacion finalizada." -ForegroundColor Green
Write-Host "   Presiona cualquier tecla para salir..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")