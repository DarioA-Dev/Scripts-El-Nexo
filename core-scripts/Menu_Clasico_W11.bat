@echo off
chcp 65001 >nul
title EL NEXO - Menu Clasico Windows 11
color 0A

:: 1. ADMIN CHECK
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Necesitas permisos de Administrador.
    echo Haz clic derecho ^> Ejecutar como administrador.
    pause
    exit
)
cd /d "%~dp0"

echo ==========================================
echo    RESTAURAR MENU CLASICO (Win 10)
echo ==========================================
echo Esto hara que el clic derecho muestre todas
echo las opciones sin pulsar "Mostrar mas".
echo.

echo [1/2] Aplicando parche en registro...
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul 2>&1

echo [2/2] Reiniciando Explorador de Windows...
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

echo.
echo ==========================================
echo    MENU RESTAURADO
echo ==========================================
echo Prueba a hacer clic derecho ahora.
pause