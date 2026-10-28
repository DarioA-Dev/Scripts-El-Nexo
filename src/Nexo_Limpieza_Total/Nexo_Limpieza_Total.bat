@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - LIMPIEZA TOTAL [PLAN: FREE]
:: =========================================================================
::  EL NEXO - LIMPIEZA TOTAL [PLAN: FREE]  v5.2
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Solo borra temporales y caches que Windows regenera. No cambia ninguna
::  configuracion del sistema (por eso no necesita copia de seguridad).
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Nexo_Limpieza_Total"
call :UI_HEADER "LIMPIEZA TOTAL" "5.2" "PLAN: FREE"
call :UI_REQUIRE_ADMIN || exit /b 1

call :UI_PLAN_BEGIN "QUE VA A HACER ESTE SCRIPT"
call :UI_AUTO "Vaciar la cache de descargas de Windows Update"
call :UI_AUTO "Borrar archivos temporales del usuario y de Windows"
call :UI_AUTO "Borrar los accesos directos de Archivos recientes"
call :UI_INFO "(las listas de salto y sus elementos anclados se conservan)"
call :UI_AUTO "Regenerar la cache de iconos y miniaturas del Explorador"
call :UI_OPT "Vaciar los registros de eventos (no mejora el rendimiento)"
call :UI_OPT "Vaciar la papelera de reciclaje de tu usuario"
call :UI_OPT "Crear un punto de restauracion de Windows"
call :UI_PLAN_END
call :UI_INFO "Lo borrado no se puede recuperar. No se tocan tus documentos."
echo.
call :UI_ASK OPT_RP "Crear punto de restauracion"
call :UI_INFO "Los registros de eventos sirven para diagnosticar errores"
call :UI_INFO "(pantallazos azules, drivers, actualizaciones)."
call :UI_ASK OPT_LOGS "Vaciar los registros de eventos"
call :UI_ASK OPT_BIN "Vaciar la papelera de reciclaje"
call :UI_CONFIRM "Empezar la limpieza" || exit /b 0

echo.
if "%OPT_RP%"=="S" (
    call :UI_INFO "Creando punto de restauracion..."
    call :UI_RESTORE_POINT "El Nexo Limpieza FREE"
) else (
    call :UI_SKIP "Punto de restauracion omitido."
)

call :UI_STEP 1 5 "Limpiando cache de Windows Update..."
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
timeout /t 2 /nobreak >nul
if exist "%windir%\SoftwareDistribution\Download" (
    del /s /f /q "%windir%\SoftwareDistribution\Download\*.*" >nul 2>&1
    for /d %%D in ("%windir%\SoftwareDistribution\Download\*") do rd /s /q "%%D" >nul 2>&1
)
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
call :UI_OK "Cache de Windows Update eliminada."

call :UI_STEP 2 5 "Eliminando archivos temporales..."
del /s /f /q "%temp%\*.*" >nul 2>&1
for /d %%D in ("%temp%\*") do rd /s /q "%%D" >nul 2>&1
del /s /f /q "%windir%\Temp\*.*" >nul 2>&1
for /d %%D in ("%windir%\Temp\*") do rd /s /q "%%D" >nul 2>&1
:: La carpeta Prefetch NO se borra: Windows la usa para acelerar el arranque.
call :UI_OK "Temporales eliminados (los que estaban en uso se conservan)."

call :UI_STEP 3 5 "Limpiando historial de archivos recientes..."
del /f /q "%AppData%\Microsoft\Windows\Recent\*.lnk" >nul 2>&1
call :UI_OK "Historial limpiado."

call :UI_STEP 4 5 "Limpiando logs de eventos..."
if "%OPT_LOGS%"=="S" (
    for /f "tokens=*" %%e in ('wevtutil el 2^>nul') do wevtutil cl "%%e" >nul 2>&1
    call :UI_OK "Logs de eventos eliminados."
) else (
    call :UI_SKIP "Logs de eventos conservados."
)

call :UI_STEP 5 5 "Reconstruyendo cache del Explorador..."
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul
del /f /q "%LocalAppData%\IconCache.db" >nul 2>&1
del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
start "" explorer.exe
call :UI_OK "Cache del Explorador reconstruida."
if "%OPT_BIN%"=="S" (
    powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1
    call :UI_OK "Papelera vaciada."
) else (
    call :UI_SKIP "Papelera sin tocar."
)

call :UI_FINAL "LIMPIEZA FREE - COMPLETADO" "" 0
call :UI_PRO_BEGIN
call :UI_PRO "Limpieza de componentes de Windows (DISM /ResetBase)" "Libera espacio de WinSxS; despues no se pueden desinstalar updates"
call :UI_PRO_END
call :UI_PAUSE
exit /b 0

:: @@BLOCK ui@@
