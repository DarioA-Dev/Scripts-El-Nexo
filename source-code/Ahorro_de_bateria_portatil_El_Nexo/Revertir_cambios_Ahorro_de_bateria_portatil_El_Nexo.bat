@echo off
:: ==========================================================
::   EL NEXO - PROTOCOLO DE REVERSIÓN DE AUTONOMÍA
::   Objetivo: Restaurar el equilibrio de rendimiento y energía
:: ==========================================================
chcp 65001 >nul
title EL NEXO: RESTAURAR EQUILIBRIO DE ENERGÍA
color 0B

net session >nul 2>&1
if %errorlevel% neq 0 (echo [!] Error: Ejecuta como Administrador. & pause & exit)

echo ======================================================
echo      REESTABLECIENDO PARÁMETROS DE FÁBRICA
echo ======================================================

:: 1. RESTAURAR PLAN EQUILIBRADO
echo [-] Restaurando planes de energía por defecto...
powercfg -restoredefaultschemes >nul 2>&1
powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1

:: 2. ELIMINAR RESTRICCIONES DE CPU
echo [-] Eliminando bloqueos de frecuencia y Power Throttling...
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PowerThrottlingOff" /t REG_DWORD /d 0 /f >nul

echo [OK] El sistema ha vuelto a su estado original.
pause
exit