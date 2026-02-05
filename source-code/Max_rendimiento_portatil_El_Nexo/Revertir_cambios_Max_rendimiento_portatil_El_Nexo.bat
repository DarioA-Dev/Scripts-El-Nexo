@echo off
:: ==========================================================
::   EL NEXO - PROTOCOLO DE REVERSIÓN PORTÁTIL
::   Objetivo: Restaurar gestión térmica y energía estándar
:: ==========================================================
chcp 65001 >nul
title EL NEXO: RESTAURAR PARÁMETROS PORTÁTIL
color 0B

net session >nul 2>&1
if %errorlevel% neq 0 (echo [!] Error: Ejecuta como Administrador. & pause & exit)

echo [-] Restaurando Esquemas de Energía de Fábrica...
powercfg -restoredefaultschemes >nul 2>&1
powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1

echo [-] Eliminando registros de Turbo Boost forzado...
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v "Attributes" /f >nul 2>&1

echo [OK] El sistema ha vuelto a la configuración térmica de Windows.
pause
exit