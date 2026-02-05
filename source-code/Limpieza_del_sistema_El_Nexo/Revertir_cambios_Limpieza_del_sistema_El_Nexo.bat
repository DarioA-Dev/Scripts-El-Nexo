@echo off
:: ==========================================================
::   EL NEXO - PROTOCOLO DE RESTAURACIÓN DE MANTENIMIENTO
::   Objetivo: Reestablecer servicios de diagnóstico y Store
:: ==========================================================
chcp 65001 >nul
title EL NEXO: RESTAURAR PARÁMETROS DE MANTENIMIENTO
color 0B

:: VERIFICACIÓN DE ADMINISTRADOR
net session >nul 2>&1
if %errorlevel% neq 0 (echo [!] Error: Ejecuta como Administrador. & pause & exit)

echo ======================================================
echo      REESTABLECIENDO SERVICIOS DE MANTENIMIENTO
echo ======================================================

:: Reactivar servicios de diagnóstico y almacenamiento
echo [-] Habilitando servicios de sistema...
for %%s in (WSearch, bits, wuauserv, AppXSvc, StateRepository) do (
    sc config %%s start= auto >nul 2>&1
    sc start %%s >nul 2>&1
)

:: Reestablecer telemetría básica necesaria para Windows Update
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 1 /f >nul

echo [OK] Servicios restaurados.
pause
exit