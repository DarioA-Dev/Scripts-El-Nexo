@echo off
:: =========================================================================
::   EL NEXO - REVERT: PROCESS KILLER [PLAN: FREE]  (v5.1)
::   Nexo_Process_Killer.bat (version FREE) solo cierra procesos: no
::   desactiva servicios ni cambia el registro. Por eso este REVERT no
::   modifica nada; los programas cerrados vuelven al abrirlos o al
::   reiniciar el PC.
:: =========================================================================
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO - REVERT Process Killer
color 0E

cls
echo.
echo  ============================================================
echo   EL NEXO - REVERT: PROCESS KILLER
echo  ============================================================
echo.
echo  La version FREE de Process Killer (Nivel 1) solo cierra
echo  launchers y Widgets/Game Bar que estaban en segundo plano.
echo  No cambia ningun ajuste de Windows: no hay nada que revertir.
echo.
echo  ============================================================
echo   REVERT COMPLETADO
echo  ============================================================
echo.
echo   IMPORTANTE:
echo   - Los PROCESOS cerrados (launchers) se reiniciaran
echo     solos al arrancar el PC o al abrir sus aplicaciones.
echo  ============================================================
echo.
pause
exit
