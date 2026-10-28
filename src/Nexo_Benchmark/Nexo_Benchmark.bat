@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - BENCHMARK
:: =========================================================================
::  EL NEXO BENCHMARK  v5.2 (informe VERSION=18) - solo lectura
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Este .bat solo lanza Nexo_Benchmark.ps1, que va junto a el en el ZIP
::  en texto plano: puedes abrirlo con el Bloc de notas y revisarlo.
::  El informe se guarda en %ProgramData%\ElNexo\Benchmark.
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Nexo_Benchmark"
call :UI_HEADER "BENCHMARK" "5.2" "solo lectura"
call :UI_REQUIRE_ADMIN || exit /b 1

if not exist "%~dp0Nexo_Benchmark.ps1" (
    call :UI_FAIL "Falta Nexo_Benchmark.ps1 junto a este archivo."
    call :UI_INFO "Descomprime el ZIP completo y ejecutalo desde esa carpeta."
    call :UI_PAUSE
    exit /b 1
)

call :UI_PLAN_BEGIN "QUE VA A HACER ESTE SCRIPT"
call :UI_AUTO "Leer CPU, GPU, RAM, sistema, disco y apps de inicio"
call :UI_INFO "(solo lectura: no cambia nada en tu PC ni envia datos)"
call :UI_AUTO "Guardar el informe en C:\ProgramData\ElNexo\Benchmark"
call :UI_AUTO "Abrir la pagina del benchmark y la carpeta del informe"
call :UI_PLAN_END
call :UI_CONFIRM "Empezar el analisis" || exit /b 0

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Nexo_Benchmark.ps1"
if errorlevel 1 (
    call :UI_FAIL "El analisis no se completo. Revisa el mensaje de arriba."
) else (
    call :UI_OK "Informe resultado_nexo.txt generado."
)

call :UI_FINAL "BENCHMARK - COMPLETADO" "" 0
call :UI_INFO "Sube resultado_nexo.txt en elnexocenter.com/nexos/benchmark.html"
call :UI_PAUSE
exit /b 0

:: @@BLOCK ui@@
