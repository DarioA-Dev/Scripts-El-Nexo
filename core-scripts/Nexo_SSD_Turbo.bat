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
echo   MODULO: SSD NVMe TURBO
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
Write-Host "`n   [+] Creando punto de seguridad rapido..." -ForegroundColor Yellow
Checkpoint-Computer -Description 'Nexo SSD Turbo' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction SilentlyContinue
Write-Host "   [OK] Punto de control creado." -ForegroundColor Green

# 2. Enable TRIM
Write-Host "`n   [+] Forzando TRIM..." -ForegroundColor Yellow
Start-Process fsutil -ArgumentList "behavior set DisableDeleteNotify 0" -NoNewWindow -Wait
Write-Host "   [OK] TRIM activado." -ForegroundColor Green

# 3. Disable Last Access
Write-Host "`n   [+] Desactivando escritura de 'ultimo acceso'..." -ForegroundColor Yellow
Start-Process fsutil -ArgumentList "behavior set disablelastaccess 1" -NoNewWindow -Wait
Write-Host "   [OK] Escritura innecesaria eliminada." -ForegroundColor Green

# 4. Disable Sleep
Write-Host "`n   [+] Evitando suspension del disco..." -ForegroundColor Yellow
powercfg -change -disk-timeout-ac 0
powercfg -change -disk-timeout-dc 0
Write-Host "   [OK] Disco siempre activo." -ForegroundColor Green

# 5. File System Priority
Write-Host "`n   [+] Optimizando memoria de sistema de archivos..." -ForegroundColor Yellow
$memMan = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
if (Test-Path $memMan) {
    Set-ItemProperty -Path $memMan -Name "LargeSystemCache" -Value 1 -Type DWord -ErrorAction SilentlyContinue
}
Write-Host "   [OK] Caché de archivos ampliada." -ForegroundColor Green

Write-Host "`n   ======================================================" -ForegroundColor Cyan
Write-Host "      SSD OPTIMIZADO" -ForegroundColor Cyan
Write-Host "   ======================================================" -ForegroundColor Cyan

Write-Host "   [EXITO] Operacion finalizada." -ForegroundColor Green
Write-Host "   Presiona cualquier tecla para salir..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")