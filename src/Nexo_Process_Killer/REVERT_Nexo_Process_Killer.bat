@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - REVERT Process Killer
:: =========================================================================
::  EL NEXO - REVERT: PROCESS KILLER [PLAN: FREE]  v5.2
::  Nexo_Process_Killer.bat (Nivel 1) solo cierra procesos: no desactiva
::  servicios ni cambia el registro. Este REVERT no modifica nada.
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Nexo_Process_Killer"
call :UI_HEADER "REVERT: PROCESS KILLER" "5.2" "PLAN: FREE"

call :UI_PLAN_BEGIN "NO HAY AJUSTES QUE RESTAURAR"
call :UI_INFO "El Nivel 1 solo cierra launchers, Widgets y Game Bar que estaban"
call :UI_INFO "en segundo plano. No cambia ningun ajuste de Windows."
call :UI_INFO "Los programas cerrados vuelven al abrirlos o al reiniciar el PC."
call :UI_PLAN_END

call :UI_FINAL "REVERT COMPLETADO" "" 0
call :UI_PAUSE
exit /b 0

:: @@BLOCK ui@@
