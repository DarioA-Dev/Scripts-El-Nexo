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

:: ==========================================================================
::  BLOQUE COMUN DE INTERFAZ - EL NEXO 5.2
::  Identico en todos los scripts. Guia: docs/ESTILO_CONSOLA.md
::  Colores ANSI solo si la consola los admite; si no, texto plano.
::  Para desactivar los colores: variable de entorno NO_COLOR o NEXO_NO_COLOR.
:: ==========================================================================
:UI_INIT
set "UI_ID=%~1"
set /a N_OK=0, N_SKIP=0, N_FAIL=0
set "SF=0"
set "FIND=%SystemRoot%\System32\find.exe"
set "NEXO_LOG=%ProgramData%\ElNexo\Logs\%~1.log"
if not exist "%ProgramData%\ElNexo\Logs\" mkdir "%ProgramData%\ElNexo\Logs" >nul 2>&1
2>nul (>>"%NEXO_LOG%" echo ==== %date% %time% %UI_FILE% ====) || set "NEXO_LOG=NUL"
set "ESC="
set "C_ACC="
set "C_OK="
set "C_WARN="
set "C_ERR="
set "C_RST="
if defined NO_COLOR goto :UI_INIT_PLAIN
if defined NEXO_NO_COLOR goto :UI_INIT_PLAIN
set "UI_VER="
set "UI_BUILD=0"
for /f "tokens=2 delims=[]" %%v in ('ver') do set "UI_VER=%%v"
for /f "tokens=2" %%v in ("%UI_VER%") do set "UI_VER=%%v"
for /f "tokens=3 delims=." %%v in ("%UI_VER%") do set "UI_BUILD=%%v"
if %UI_BUILD% LSS 10586 goto :UI_INIT_PLAIN
reg query "HKCU\Console" /v ForceV2 2>nul | %FIND% "0x0" >nul && goto :UI_INIT_PLAIN
for /f %%e in ('echo prompt $E ^| cmd') do set "ESC=%%e"
if not defined ESC goto :UI_INIT_PLAIN
set "C_ACC=%ESC%[96m"
set "C_OK=%ESC%[92m"
set "C_WARN=%ESC%[93m"
set "C_ERR=%ESC%[91m"
set "C_RST=%ESC%[0m"
exit /b 0
:UI_INIT_PLAIN
color 0B
exit /b 0

:UI_HEADER
:: %1 = nombre   %2 = version   %3 = plan (opcional)
cls
echo.
echo %C_ACC%  ==========================================================================%C_RST%
echo %C_ACC%     ______ _       _   _ _______   ______%C_RST%
echo %C_ACC%    ^|  ____^|^| ^|     ^| \ ^| ^|^|  ___\ \ / / __ \%C_RST%
echo %C_ACC%    ^| ^|__  ^| ^|     ^|  \^| ^|^| ^|__  \ V / ^|  ^| ^|%C_RST%
echo %C_ACC%    ^|  __^| ^| ^|     ^| . ` ^|^|  __^|  ^> ^<^| ^|  ^| ^|%C_RST%
echo %C_ACC%    ^| ^|____^| ^|____ ^| ^|\  ^|^| ^|____/ . \ ^|__^| ^|%C_RST%
echo %C_ACC%    ^|______^|^|______^|^|_^| \_^|^|______/_/\_\____/%C_RST%
echo.
echo %C_ACC%  ==========================================================================%C_RST%
if "%~3"=="" (echo   %~1   ^|   v%~2) else (echo   %~1   ^|   v%~2   ^|   %~3)
echo   Codigo abierto: github.com/DarioA-Dev/Scripts-El-Nexo
echo %C_ACC%  ==========================================================================%C_RST%
exit /b 0

:UI_REQUIRE_ADMIN
fsutil dirty query %systemdrive% >nul 2>&1 && exit /b 0
echo.
echo  %C_ERR%[ERROR]%C_RST% ACCESO DENEGADO - Se requieren permisos de Administrador
echo          Haz clic derecho en el archivo y elige "Ejecutar como administrador".
call :UI_LOG "[ERROR] Sin permisos de administrador"
call :UI_PAUSE
exit /b 1

:UI_PLAN_BEGIN
echo.
echo  %C_ACC%%~1%C_RST%
echo   ------------------------------------------------------------------------
exit /b 0

:UI_AUTO
echo    [AUTO]      %~1
exit /b 0

:UI_OPT
echo    [OPCIONAL]  %~1
exit /b 0

:UI_PLAN_END
echo   ------------------------------------------------------------------------
exit /b 0

:UI_ASK
:: %1 = variable de salida (S o N)   %2 = pregunta
set "_ans="
set /p "_ans= %C_ACC%[?]%C_RST% %~2 [S/N, por defecto N]: "
if /i "!_ans!"=="S" (set "%~1=S") else (set "%~1=N")
call :UI_LOG "[?] %~2 = !%~1!"
exit /b 0

:UI_CONFIRM
echo.
call :UI_ASK _go "%~1"
if /i "!_go!"=="S" exit /b 0
call :UI_WARN "Cancelado. No se ha cambiado nada."
call :UI_PAUSE
exit /b 1

:UI_STEP
:: %1 = n   %2 = total   %3 = texto
echo.
echo  %C_ACC%[PASO %~1/%~2]%C_RST% %~3
call :UI_LOG "[PASO %~1/%~2] %~3"
set "SF=0"
exit /b 0

:UI_OK
echo  %C_OK%[OK]%C_RST% %~1
set /a N_OK+=1
call :UI_LOG "[OK] %~1"
exit /b 0

:UI_SKIP
echo  %C_WARN%[!]%C_RST% %~1
set /a N_SKIP+=1
call :UI_LOG "[!] %~1"
exit /b 0

:UI_WARN
echo  %C_WARN%[!]%C_RST% %~1
call :UI_LOG "[!] %~1"
exit /b 0

:UI_FAIL
echo  %C_ERR%[ERROR]%C_RST% %~1
set /a N_FAIL+=1
call :UI_LOG "[ERROR] %~1"
exit /b 0

:UI_INFO
echo       %~1
exit /b 0

:STEP_END
:: %1 = mensaje si todo fue bien   %2 = mensaje si algo fallo
if "%SF%"=="0" (call :UI_OK "%~1") else (call :UI_FAIL "%~2")
exit /b 0

:UI_LOG
2>nul >>"%NEXO_LOG%" echo [%time:~0,8%] %~1
exit /b 0

:UI_RESTORE_POINT
:: Checkpoint-Computer devuelve exito aunque se salte el punto (limite de
:: 24 h): por eso tambien se comprueba el aviso.
powershell -NoProfile -Command "try { Checkpoint-Computer -Description '%~1' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction Stop -WarningVariable w -WarningAction SilentlyContinue; if ($w) { exit 2 } } catch { exit 1 }" >nul 2>&1
if errorlevel 2 (
    call :UI_SKIP "Punto no creado: Windows solo permite uno cada 24 horas."
    exit /b 0
)
if errorlevel 1 (
    call :UI_SKIP "Punto no creado: Proteccion del sistema desactivada o sin espacio."
    exit /b 0
)
call :UI_OK "Punto creado."
exit /b 0

:UI_PRO_BEGIN
echo.
echo  %C_ACC%INCLUIDO EN NEXO OPTIMIZER PRO (no en esta version FREE)%C_RST%
echo   ------------------------------------------------------------------------
exit /b 0

:UI_PRO
echo    [PRO] %~1
if not "%~2"=="" echo          %~2
exit /b 0

:UI_PRO_END
echo   ------------------------------------------------------------------------
echo    Mas informacion: elnexocenter.com/optimizer
exit /b 0

:UI_FINAL
:: %1 = titulo   %2 = REVERT asociado (o vacio)   %3 = 1 si hay que reiniciar
set "_title=%~1"
if %N_FAIL% GTR 0 set "_title=%~1 CON ERRORES"
echo.
echo %C_ACC%  ==========================================================================%C_RST%
echo   %_title%
echo %C_ACC%  ==========================================================================%C_RST%
echo    Aplicados: %N_OK%    Omitidos: %N_SKIP%    Fallidos: %N_FAIL%
echo    Log:                %NEXO_LOG%
if defined NEXO_BK (echo    Copia de seguridad: %NEXO_BK%) else (echo    Copia de seguridad: no aplica, este script no cambia ajustes)
if not "%~2"=="" echo    Para deshacerlo:    %~2
if "%~3"=="1" (echo    Reinicio:           necesario para aplicar todos los cambios) else (echo    Reinicio:           no necesario)
echo %C_ACC%  ==========================================================================%C_RST%
call :UI_LOG "%_title% - aplicados %N_OK%, omitidos %N_SKIP%, fallidos %N_FAIL%"
exit /b 0

:UI_REBOOT
:: Pregunta si reiniciar; nunca reinicia sin confirmacion
echo.
call :UI_ASK _rb "Reiniciar ahora"
if /i "!_rb!"=="S" shutdown /r /t 10 /c "El Nexo: reiniciando para aplicar los cambios"
exit /b 0

:UI_PAUSE
echo.
echo   Pulsa una tecla para cerrar...
pause >nul
exit /b 0
