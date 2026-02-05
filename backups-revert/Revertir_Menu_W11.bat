@echo off
title EL NEXO - Revertir Menu (Moderno)
color 0E

:: 1. ADMIN CHECK
fsutil dirty query %systemdrive% >nul
if %errorlevel% neq 0 (
    echo ERROR: Necesitas permisos de Administrador.
    pause
    exit
)
cd /d "%~dp0"

echo ==========================================
echo    RESTAURAR MENU MODERNO (W11)
echo ==========================================
echo Volviendo al diseño original de Windows 11.
echo.

echo [1/2] Eliminando parche de registro...
reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f >nul 2>&1

echo [2/2] Reiniciando Explorador...
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

echo.
echo ==========================================
echo    MENU MODERNO RESTAURADO
echo ==========================================
echo Prueba el clic derecho ahora.
pause