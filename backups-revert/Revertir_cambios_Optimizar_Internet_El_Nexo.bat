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
echo   MODULO: RESTAURAR RED A FABRICA
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

# 1. Network Reset
Write-Host "`n   [-] Restaurando Pila TCP/IP y DNS..." -ForegroundColor Yellow
Start-Process netsh -ArgumentList "int ip reset" -NoNewWindow -Wait
Start-Process netsh -ArgumentList "winsock reset" -NoNewWindow -Wait

# 2. TCP Global Defaults
Write-Host "`n   [-] Restaurando parametros TCP Globales..." -ForegroundColor Yellow
Start-Process netsh -ArgumentList "int tcp set global autotuninglevel=normal" -NoNewWindow -Wait
Start-Process netsh -ArgumentList "int tcp set global heuristics=enabled" -NoNewWindow -Wait
Start-Process netsh -ArgumentList "int tcp set global rss=enabled" -NoNewWindow -Wait
Start-Process netsh -ArgumentList "int tcp set global chimney=default" -NoNewWindow -Wait
Start-Process netsh -ArgumentList "int tcp set global timestamps=default" -NoNewWindow -Wait

# 3. Registry Revert
Write-Host "`n   [-] Eliminando ajustes de latencia del registro..." -ForegroundColor Yellow
$sysProfile = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
if (Test-Path $sysProfile) {
    Set-ItemProperty -Path $sysProfile -Name "NetworkThrottlingIndex" -Value 10 -Type DWord -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $sysProfile -Name "SystemResponsiveness" -Value 20 -Type DWord -ErrorAction SilentlyContinue
}
Write-Host "   [OK] Registro restaurado." -ForegroundColor Green

Write-Host "`n   ======================================================" -ForegroundColor Cyan
Write-Host "      RED RESTAURADA" -ForegroundColor Cyan
Write-Host "   ======================================================" -ForegroundColor Cyan
Write-Host "   Reinicia para completar." -ForegroundColor Yellow

Write-Host "   [EXITO] Operacion finalizada." -ForegroundColor Green
Write-Host "   Presiona cualquier tecla para salir..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")