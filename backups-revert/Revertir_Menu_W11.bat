@echo off
chcp 65001 >nul
title EL NEXO - REVERTIR MENU CLASICO
color 0E

:: ADMIN CHECK
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Necesitas permisos de Administrador.
    echo Haz clic derecho ^> Ejecutar como administrador.
    pause
    exit
)

echo ==========================================
echo    RESTAURAR MENU WINDOWS 11
echo ==========================================
echo.

echo [1/2] Eliminando parche del registro...
reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f >nul 2>&1

echo [2/2] Reiniciando Explorador de Windows...
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

echo.
echo ==========================================
echo    MENU WINDOWS 11 RESTAURADO
echo ==========================================
pause