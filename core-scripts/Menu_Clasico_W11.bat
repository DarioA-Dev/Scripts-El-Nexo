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
echo   MODULO: MENU CLASICO WINDOWS 11
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

# 1. Restore Menu
Write-Host "`n   [+] Aplicando parche en registro (InprocServer32)..." -ForegroundColor Yellow
$key = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"
$subKey = "$key\InprocServer32"

if (!(Test-Path $key)) { New-Item -Path $key -Force | Out-Null }
if (!(Test-Path $subKey)) { New-Item -Path $subKey -Force | Out-Null }
# Set default value to empty string
Set-Item -Path $subKey -Value "" -ErrorAction SilentlyContinue

Write-Host "   [OK] Registro modificado." -ForegroundColor Green

# 2. Restart Explorer
Write-Host "`n   [+] Reiniciando Explorador de Windows..." -ForegroundColor Yellow
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Start-Process explorer
Write-Host "   [OK] Explorador reiniciado." -ForegroundColor Green

Write-Host "`n   ======================================================" -ForegroundColor Cyan
Write-Host "      MENU RESTAURADO" -ForegroundColor Cyan
Write-Host "   ======================================================" -ForegroundColor Cyan

Write-Host "   [EXITO] Operacion finalizada." -ForegroundColor Green
Write-Host "   Presiona cualquier tecla para salir..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")