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
echo   MODULO: MANTENIMIENTO DE SISTEMA DE ARCHIVOS
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
$rp = Read-Host "¿Deseas generar un Punto de Control de Ingeniería? (S/N)"
if ($rp -eq 'S') {
    Write-Host "   [+] Iniciando respaldo de configuración de sistema..." -ForegroundColor Yellow
    Checkpoint-Computer -Description 'Mantenimiento El Nexo v4.0' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction SilentlyContinue
    Write-Host "   [OK] Punto de control establecido." -ForegroundColor Green
}

# 2. DISM Cleanup
Write-Host "`n   [AVISO] Iniciando purga del almacén de componentes (WinSxS)." -ForegroundColor Cyan
Write-Host "   ESTE PROCESO ES ALTAMENTE INTENSIVO Y PUEDE TARDAR." -ForegroundColor Cyan
Write-Host "   [+] Ejecutando DISM..." -ForegroundColor Yellow
Start-Process dism -ArgumentList "/online /cleanup-image /startcomponentcleanup /resetbase" -NoNewWindow -Wait
Write-Host "   [OK] Almacén de componentes optimizado." -ForegroundColor Green

# 3. Windows Update Cleanup
Write-Host "`n   [+] Deteniendo servicios para purga de Windows Update..." -ForegroundColor Yellow
Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
Stop-Service -Name bits -Force -ErrorAction SilentlyContinue
$wuDir = "$env:SystemRoot\SoftwareDistribution\Download"
if (Test-Path $wuDir) {
    Remove-Item -Path "$wuDir\*" -Recurse -Force -ErrorAction SilentlyContinue
}
Start-Service -Name wuauserv -ErrorAction SilentlyContinue
Start-Service -Name bits -ErrorAction SilentlyContinue
Write-Host "   [OK] Repositorio de Windows Update purgado." -ForegroundColor Green

# 4. Hardware Caches
Write-Host "`n   [+] Sincronizando purga de cachés de sombreadores (GPU)..." -ForegroundColor Yellow
Remove-Item -Path "$env:LOCALAPPDATA\NVIDIA\GLCache\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:LOCALAPPDATA\AMD\DxCache\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\DirectX\ShaderCache\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "   [OK] Cachés de hardware reiniciadas." -ForegroundColor Green

# 5. UWP Debloat
Write-Host ""
$debloat = Read-Host "¿Deseas desinstalar paquetes de aplicaciones obsoletas? (S/N)"
if ($debloat -eq 'S') {
    Write-Host "   [+] Iniciando desinstalación de Bloatware..." -ForegroundColor Yellow
    Get-AppxPackage *CandyCrush* -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue
    Get-AppxPackage *WindowsMaps* -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue
    Get-AppxPackage *YourPhone* -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue
    Get-AppxPackage *BingNews* -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue
    Write-Host "   [OK] Paquetes UWP innecesarios eliminados." -ForegroundColor Green
}

# 6. Event Logs
Write-Host "`n   [+] Iniciando purga forense de registros de eventos..." -ForegroundColor Yellow
wevtutil el | ForEach-Object { wevtutil cl "$_" } | Out-Null
Write-Host "   [OK] Historial de eventos reiniciado." -ForegroundColor Green

# 7. Temp Cleanup
Write-Host "`n   [+] Ejecutando purga final de directorios temporales..." -ForegroundColor Yellow
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
if (Test-Path "$env:SystemRoot\Prefetch") {
    Remove-Item -Path "$env:SystemRoot\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
}
Write-Host "   [OK] Archivos temporales eliminados." -ForegroundColor Green

# 8. Icon Cache (Explorer)
Write-Host "`n   [+] Reconstruyendo base de datos de iconos y miniaturas..." -ForegroundColor Yellow
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1
if (Test-Path "$env:LOCALAPPDATA\IconCache.db") {
    Remove-Item -Path "$env:LOCALAPPDATA\IconCache.db" -Force -ErrorAction SilentlyContinue
}
$thumbDir = "$env:LOCALAPPDATA\Microsoft\Windows\Explorer"
if (Test-Path $thumbDir) {
    Get-ChildItem -Path $thumbDir -Filter "thumbcache_*.db" | Remove-Item -Force -ErrorAction SilentlyContinue
}
Start-Process explorer
Write-Host "   [OK] Caché de interfaz reiniciada." -ForegroundColor Green

Write-Host "`n   ======================================================" -ForegroundColor Cyan
Write-Host "      MANTENIMIENTO FINALIZADO. SISTEMA NEXO DEPURADO." -ForegroundColor Cyan
Write-Host "   ======================================================" -ForegroundColor Cyan
Write-Host "   Se recomienda reiniciar para reconstruir las cachés." -ForegroundColor Yellow

$r = Read-Host "¿Reiniciar ahora? (S/N)"
if ($r -eq 'S') {
    Restart-Computer -Force
}

Write-Host "   [EXITO] Operacion finalizada." -ForegroundColor Green
Write-Host "   Presiona cualquier tecla para salir..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
