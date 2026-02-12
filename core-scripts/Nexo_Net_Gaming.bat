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
echo   MODULO: RED GAMING
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

# 1. Optimizar TCP
Write-Host "`n   [+] Configurando TCP Global..." -ForegroundColor Yellow
Start-Process netsh -ArgumentList "int tcp set global autotuninglevel=normal" -NoNewWindow -Wait
Start-Process netsh -ArgumentList "int tcp set global rss=enabled" -NoNewWindow -Wait
Start-Process netsh -ArgumentList "int tcp set global timestamps=disabled" -NoNewWindow -Wait
Write-Host "   [OK] TCP Global configurado." -ForegroundColor Green

# 2. Congestion Algorithm
Write-Host "`n   [+] Cambiando algoritmo de congestion a CTCP..." -ForegroundColor Yellow
Start-Process netsh -ArgumentList "int tcp set supplemental template=internet congestionprovider=ctcp" -NoNewWindow -Wait
Write-Host "   [OK] CTCP activado." -ForegroundColor Green

# 3. Firewall
Write-Host "`n   [+] Optimizando reglas de Firewall para descubrimiento..." -ForegroundColor Yellow
# Using netsh as in original script, as PowerShell equivalent (Set-NetFirewallRule) might be more complex to match exact group.
Start-Process netsh -ArgumentList "advfirewall firewall set rule group=""Deteccion de redes"" new enable=Yes" -NoNewWindow -Wait
Write-Host "   [OK] Reglas actualizadas." -ForegroundColor Green

Write-Host "`n   ======================================================" -ForegroundColor Cyan
Write-Host "      RED OPTIMIZADA" -ForegroundColor Cyan
Write-Host "   ======================================================" -ForegroundColor Cyan

Write-Host "   [EXITO] Operacion finalizada." -ForegroundColor Green
Write-Host "   Presiona cualquier tecla para salir..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")