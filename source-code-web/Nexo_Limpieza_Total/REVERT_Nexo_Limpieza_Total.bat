@echo off
:: =========================================================================
::   EL NEXO - REVERT: LIMPIEZA TOTAL [PLAN: FREE]  (v5.1)
::   Nexo_Limpieza_Total.bat (version FREE) NO cambia ninguna
::   configuracion: solo borra temporales y caches. Por eso este REVERT
::   no modifica nada; solo explica que se puede recuperar y como.
:: =========================================================================
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO - REVERT Limpieza Total
color 0E

cls
echo.
echo  ============================================================
echo   EL NEXO - REVERT: LIMPIEZA TOTAL
echo  ============================================================
echo.
echo  La version FREE de Limpieza Total no cambia ningun ajuste de
echo  Windows: no desactiva servicios ni toca el registro.
echo  Por eso no hay nada que revertir.
echo.
echo   [SE REGENERA SOLO]  Cache de Windows Update
echo   [SE REGENERA SOLO]  Cache de iconos y miniaturas del Explorador
echo   [SE REGENERA SOLO]  Historial de archivos recientes
echo.
echo   [NO REVERSIBLE]     Archivos temporales eliminados
echo   [NO REVERSIBLE]     Logs de eventos (solo si elegiste vaciarlos)
echo   [NO REVERSIBLE]     Papelera (solo si elegiste vaciarla)
echo.
echo  ============================================================
echo   REVERT COMPLETADO
echo  ============================================================
echo.
echo   Los archivos eliminados NO pueden recuperarse.
echo   Si tienes un punto de restauracion creado antes de la
echo   limpieza, puedes usarlo desde:
echo   Panel de Control ^> Sistema ^> Proteccion del sistema
echo  ============================================================
echo.
pause
exit
