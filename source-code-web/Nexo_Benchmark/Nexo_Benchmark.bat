@echo off
setlocal EnableDelayedExpansion
cls
color 0b
:: =========================================================================
::  EL NEXO BENCHMARK - v18 (solo lectura)
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Este .bat solo lanza Nexo_Benchmark.ps1, que va junto a el en el ZIP
::  en texto plano: puedes abrirlo con el Bloc de notas y revisarlo.
::  El informe se guarda en %ProgramData%\ElNexo\Benchmark.
:: =========================================================================

echo.
echo  =============================================================
echo    EL NEXO BENCHMARK - v18
echo    Analisis de Hardware y Rendimiento
echo  =============================================================
echo.

:: Verificacion Admin
fsutil dirty query %systemdrive% >nul 2>&1
if %errorlevel% neq 0 goto :ERROR_NO_ADMIN

if not exist "%~dp0Nexo_Benchmark.ps1" goto :ERROR_NO_PS1

echo   [!] Analizando tu equipo... Por favor espera.
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Nexo_Benchmark.ps1"

echo.
echo  [FIN] Pulsa cualquier tecla para cerrar.
pause >nul
exit

:ERROR_NO_PS1
color 0c
echo.
echo  =============================================================
echo    ERROR: FALTA Nexo_Benchmark.ps1
echo  =============================================================
echo.
echo   Descomprime el ZIP completo y ejecuta Nexo_Benchmark.bat
echo   desde la misma carpeta que Nexo_Benchmark.ps1.
echo.
pause
exit

:ERROR_NO_ADMIN
cls
color 0c
echo.
echo  =============================================================
echo    ERROR: SIN PERMISOS DE ADMINISTRADOR
echo  =============================================================
echo.
echo   Click derecho sobre el archivo y selecciona:
echo   "Ejecutar como administrador"
echo.
pause
exit
