@echo off
:: =========================================================================
::   EL NEXO - REVERT: LIMPIEZA TOTAL v5.0
::   NOTA IMPORTANTE: La limpieza de archivos es IRREVERSIBLE por naturaleza.
::   Este script reactiva los servicios que se detuvieron durante la limpieza
::   y restaura la cache del Explorador.
:: =========================================================================
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO - REVERT Limpieza Total
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
echo   EL NEXO - REVERT: LIMPIEZA TOTAL
echo  ============================================================
echo.
echo  AVISO: La eliminacion de archivos es permanente.
echo  Este revert solo puede restaurar lo que no sean archivos:
echo.
echo   [REVERSIBLE]   Servicios detenidos durante la limpieza
echo   [REVERSIBLE]   Cache del explorador (se reconstruye sola)
echo   [REVERSIBLE]   Winsock y servicios de actualizacion
echo.
echo   [NO REVERSIBLE] Archivos temporales eliminados
echo   [NO REVERSIBLE] Cache de GPU borrada
echo   [NO REVERSIBLE] Logs de eventos limpiados
echo   [NO REVERSIBLE] Componentes WinSxS eliminados (DISM)
echo.
set /p "confirm= Continuar con el revert parcial? (S/N): "
if /i not "%confirm%"=="S" (echo  Cancelado. & pause & exit)

echo.

:: ── SERVICIOS DE WINDOWS UPDATE ───────────────────────────────────────────
echo  [1/3] Reactivando servicios de Windows Update...
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
sc config wuauserv start=auto >nul 2>&1
sc config bits start=auto >nul 2>&1
echo  [OK] Windows Update y BITS reactivados.

:: ── RECONSTRUIR CACHE DEL EXPLORADOR ─────────────────────────────────────
echo.
echo  [2/3] Reconstruyendo cache del Explorador...
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul
start explorer.exe
echo  [OK] Explorador reiniciado — la cache se reconstruira automaticamente.

:: ── INDEXACION ────────────────────────────────────────────────────────────
echo.
echo  [3/3] Reactivando indexacion de busqueda...
sc config WSearch start=auto >nul 2>&1
sc start WSearch >nul 2>&1
echo  [OK] Indexacion reactivada. Windows reindexara en segundo plano.

echo.
echo  ============================================================
echo   REVERT PARCIAL COMPLETADO
echo  ============================================================
echo.
echo   Los archivos eliminados NO pueden recuperarse.
echo   Si tienes un punto de restauracion creado antes de la
echo   limpieza, puedes usarlo desde:
echo   Panel de Control > Sistema > Proteccion del sistema
echo  ============================================================
echo.
pause
exit
