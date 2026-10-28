@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - REVERT Limpieza Total
:: =========================================================================
::  EL NEXO - REVERT: LIMPIEZA TOTAL [PLAN: FREE]  v5.2
::  Nexo_Limpieza_Total.bat no cambia ninguna configuracion: solo borra
::  temporales y caches. Este REVERT no modifica nada; explica que se
::  regenera solo y que no se puede recuperar.
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Nexo_Limpieza_Total"
call :UI_HEADER "REVERT: LIMPIEZA TOTAL" "5.2" "PLAN: FREE"

call :UI_PLAN_BEGIN "NO HAY AJUSTES QUE RESTAURAR"
call :UI_INFO "Limpieza Total no desactiva servicios ni toca el registro."
echo.
call :UI_INFO "SE REGENERA SOLO:  cache de Windows Update"
call :UI_INFO "                   cache de iconos y miniaturas"
call :UI_INFO "                   historial de archivos recientes"
call :UI_INFO "NO REVERSIBLE:     archivos temporales borrados"
call :UI_INFO "                   registros de eventos, si elegiste vaciarlos"
call :UI_INFO "                   papelera, si elegiste vaciarla"
call :UI_PLAN_END
call :UI_INFO "Si creaste un punto de restauracion antes de la limpieza, esta en:"
call :UI_INFO "Panel de control, Sistema, Proteccion del sistema."

call :UI_FINAL "REVERT COMPLETADO" "" 0
call :UI_PAUSE
exit /b 0

:: @@BLOCK ui@@
