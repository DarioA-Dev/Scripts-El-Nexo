@echo off
:: =========================================================================
::   EL NEXO - REVERT: SSD NVMe TURBO v5.0
::   Deshace todos los cambios aplicados por Nexo_SSD_NVMe_Turbo.bat
:: =========================================================================
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO - REVERT SSD NVMe Turbo
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
echo   EL NEXO - REVERT: SSD NVMe TURBO
echo   Restaurando configuracion original de almacenamiento...
echo  ============================================================
echo.

:: ── TRIM ──────────────────────────────────────────────────────────────────
echo  [1/5] Restaurando TRIM a estado por defecto...
:: TRIM sigue activado por defecto en Windows — no hay nada que revertir aqui
:: DisableDeleteNotify=0 ES el valor correcto y por defecto
echo  [OK] TRIM: sin cambios (ya era el valor correcto por defecto).

:: ── TIMESTAMPS Y 8DOT3 ────────────────────────────────────────────────────
echo.
echo  [2/5] Restaurando timestamps de ultimo acceso...
fsutil behavior set disablelastaccess 0 >nul 2>&1
fsutil behavior set disable8dot3 0 >nul 2>&1
echo  [OK] Timestamps restaurados.

:: ── SYSMAIN / SUPERFETCH ─────────────────────────────────────────────────
echo.
echo  [3/5] Reactivando SysMain (Superfetch)...
sc config SysMain start=auto >nul 2>&1
sc start SysMain >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d 3 /f >nul 2>&1
echo  [OK] SysMain reactivado.

:: ── CACHE DE MEMORIA ──────────────────────────────────────────────────────
echo.
echo  [4/5] Restaurando configuracion de cache de memoria...
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IoPageLockLimit" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SystemPages" /f >nul 2>&1
echo  [OK] Cache de memoria restaurada.

:: ── NATIVE NVMe STACK ─────────────────────────────────────────────────────
echo.
echo  [5/5] Revirtiendo Native NVMe Stack...
reg delete "HKLM\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides" /v "4097064472" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides" /v "4097064473" /f >nul 2>&1
echo  [OK] NVMe Stack revertido al stack por defecto de Windows.

echo.
echo  ============================================================
echo   REVERT COMPLETADO
echo  ============================================================
echo   REINICIA el PC para aplicar los cambios de almacenamiento.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Revert SSD Turbo El Nexo..."
exit
