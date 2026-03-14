@echo off
:: =========================================================================
::   EL NEXO - REVERT: RATON FIX v5.0
::   Deshace todos los cambios aplicados por Nexo_Raton_Fix.bat
:: =========================================================================
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO - REVERT Raton Fix
color 0E

net session >nul 2>openfiles >nul 2>&11
if %errorlevel% neq 0 (
    cls & color 0C
    echo  Se requieren permisos de Administrador.
    echo  Haz clic derecho y selecciona "Ejecutar como administrador"
    pause & exit /b
)

cls
color 0E
echo.
echo  ============================================================
echo   EL NEXO - REVERT: RATON FIX
echo   Restaurando configuracion original del raton...
echo  ============================================================
echo.

:: ── ACELERACION ───────────────────────────────────────────────────────────
echo  [1/4] Restaurando aceleracion del puntero...
:: Windows por defecto tiene MouseSpeed=1 (aceleracion activada)
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "6" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "10" /f >nul 2>&1
echo  [OK] Aceleracion de Windows restaurada.

:: ── ENHANCE POINTER PRECISION ────────────────────────────────────────────
echo.
echo  [2/4] Reactivando Enhance Pointer Precision...
:: Valor por defecto de Windows con enhance pointer precision activado
reg add "HKCU\Control Panel\Mouse" /v "UserPreferencesMask" /t REG_BINARY /d "9f3e078012000000" /f >nul 2>&1
echo  [OK] Enhance Pointer Precision restaurado.

:: ── CURVAS DE MOVIMIENTO ──────────────────────────────────────────────────
echo.
echo  [3/4] Restaurando curvas de movimiento por defecto...
:: Valores por defecto de Windows para las curvas SmoothMouse
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseXCurve" /t REG_BINARY /d "0000000000000000c0cc0c0000000000809919000000000040662600000000000019330000000000" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d "0000000000000000000038000000000000701000000000000058160000000000005c230000000000" /f >nul 2>&1
echo  [OK] Curvas de movimiento restauradas.

:: ── BUFFER Y MENUS ────────────────────────────────────────────────────────
echo.
echo  [4/4] Restaurando configuracion de menus y buffer...
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "400" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseHoverTime" /t REG_SZ /d "400" /f >nul 2>&1
echo  [OK] Buffer y menus restaurados.

echo.
echo  ============================================================
echo   REVERT COMPLETADO
echo  ============================================================
echo   El raton ha vuelto a la configuracion por defecto.
echo   REINICIA el PC para aplicar todos los cambios.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Revert Raton Fix El Nexo..."
exit
