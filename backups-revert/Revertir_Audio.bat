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
echo   MODULO: REVERTIR AUDIO (DEFAULT)
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

# 1. Restore Priority
Write-Host "`n   [1/2] Restaurando prioridad normal..." -ForegroundColor Yellow
$audioTask = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio"
if (Test-Path $audioTask) {
    Remove-ItemProperty -Path $audioTask -Name "Scheduling Category" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path $audioTask -Name "SFIO Priority" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path $audioTask -Name "GPU Priority" -ErrorAction SilentlyContinue
}
Write-Host "   [OK] Prioridades restablecidas." -ForegroundColor Green

# 2. Restore Buffer & Net
Write-Host "`n   [2/2] Restaurando Network Throttling..." -ForegroundColor Yellow
$sysProfile = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
if (Test-Path $sysProfile) {
    Set-ItemProperty -Path $sysProfile -Name "NetworkThrottlingIndex" -Value 10 -Type DWord -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $sysProfile -Name "SystemResponsiveness" -Value 20 -Type DWord -ErrorAction SilentlyContinue
}
Write-Host "   [OK] Buffer restaurado." -ForegroundColor Green

Write-Host "`n   ======================================================" -ForegroundColor Cyan
Write-Host "      AUDIO RESTAURADO" -ForegroundColor Cyan
Write-Host "   ======================================================" -ForegroundColor Cyan
Write-Host "   Reinicia para aplicar." -ForegroundColor Yellow

Write-Host "   [EXITO] Operacion finalizada." -ForegroundColor Green
Write-Host "   Presiona cualquier tecla para salir..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")