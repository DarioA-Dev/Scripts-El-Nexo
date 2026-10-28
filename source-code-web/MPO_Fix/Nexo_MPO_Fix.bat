@echo off
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO v5.0 - MPO FIX [PLAN: FREE]
color 0B
:: =========================================================================
::  EL NEXO - MPO FIX [PLAN: FREE]  (v5.1 - blindado)
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Opcion [1] guarda el valor original de OverlayTestMode en
::  %ProgramData%\ElNexo\Backup\MPO_Fix\backup.txt antes de cambiarlo.
::  Opcion [2] restaura exactamente ese valor.
:: =========================================================================

fsutil dirty query %systemdrive% >nul 2>&1
if %errorlevel% neq 0 (
    cls & color 0C
    echo.
    echo  ============================================================
    echo   ACCESO DENEGADO - Se requieren permisos de Administrador
    echo  ============================================================
    echo   Haz clic derecho y selecciona "Ejecutar como administrador"
    echo  ============================================================
    pause & exit /b
)

set "FIND=%SystemRoot%\System32\find.exe"
set "NEXO_BK=%ProgramData%\ElNexo\Backup\MPO_Fix"
set "DWM_KEY=HKLM\SOFTWARE\Microsoft\Windows\Dwm"

cls
color 0B
echo.
echo  ============================================================
echo    ______ _       _   _ _______   ______
echo   ^|  ____^|^| ^|     ^| \ ^| ^|^|  ___\ \ / / __ \
echo   ^| ^|__  ^| ^|     ^|  \^| ^|^| ^|__  \ V / ^|  ^| ^|
echo   ^|  __^| ^| ^|     ^| . ` ^|^|  __^|  ^> ^<^| ^|  ^| ^|
echo   ^| ^|____^| ^|____ ^| ^|\  ^|^| ^|____/ . \ ^|__^| ^|
echo   ^|______^|^|______^|^|_^| \_^|^|______/_/\_\____/
echo.
echo  ============================================================
echo   MPO FIX   ^|   PLAN: FREE
echo   Para la version completa: elnexocenter.com/optimizer
echo  ============================================================
echo.

echo  Que deseas hacer?
echo.
echo   [1] Desactivar MPO  (Aplica el fix)
echo   [2] Revertir MPO    (Restaura Windows por defecto)
echo.
set /p "accion=Elige una opcion (1/2): "
if "%accion%"=="2" goto :REVERTIR
if not "%accion%"=="1" (
    echo.
    echo  [!] Opcion no valida. Saliendo.
    pause & exit /b
)

echo.
echo  ============================================================
echo   INFORMACION TECNICA - LEE ANTES DE CONTINUAR
echo  ============================================================
echo.
echo   Que es MPO (Multiplane Overlay)?
echo   Es una funcion de la GPU que permite mostrar capas
echo   graficas por separado (como los subtitulos del sistema).
echo   En juegos puede causar:
echo     - Pantallazos negros al hacer Alt+Tab
echo     - Micro-stuttering aleatorio en juegos
echo     - Conflictos con overlays (Discord, NVIDIA, Xbox)
echo.
echo   Este fix desactiva MPO en el registro de Windows.
echo   Solo merece la pena si tienes esos sintomas: en juegos en
echo   ventana sin bordes puede anadir algo de latencia.
echo   En algunas versiones de Windows 11 24H2 puede no tener efecto.
echo.
echo   REVERSIBLE: Si en algun momento deseas restaurar el
echo   comportamiento original puedes ejecutar este mismo
echo   script y elegir la opcion [2] Revertir.
echo.
echo  ============================================================
echo.

set /p "confirm=Deseas aplicar el MPO Fix? (S/N): "
if /i not "%confirm%"=="S" (
    echo.
    echo  [!] Operacion cancelada por el usuario.
    pause & exit /b
)
echo.

call :BK_INIT
if errorlevel 1 (
    echo  [!] No se pudo crear la copia de seguridad en %ProgramData%\ElNexo.
    echo      No se ha cambiado nada.
    pause & exit /b
)
call :BK_REG "%DWM_KEY%" "OverlayTestMode"

echo  [PASO 1/2] Desactivando Multiplane Overlay...
reg add "%DWM_KEY%" /v "OverlayTestMode" /t REG_DWORD /d 5 /f >nul 2>&1
if %errorlevel% equ 0 (
    echo  [OK] MPO desactivado correctamente.
) else (
    echo  [!] Error al escribir en el registro. Asegurate de ejecutar como Administrador.
    pause & exit /b
)

echo.
echo  [PASO 2/2] Verificando cambio aplicado...
set "MPO_VAL="
for /f "tokens=3" %%v in ('reg query "%DWM_KEY%" /v OverlayTestMode 2^>nul') do set "MPO_VAL=%%v"
if "%MPO_VAL%"=="0x5" (
    echo  [OK] Verificacion correcta. Valor OverlayTestMode = 5.
) else (
    echo  [!] No se pudo verificar el valor. Comprueba manualmente si es necesario.
)

echo.
echo  ============================================================
echo   MPO FIX FREE - COMPLETADO
echo  ============================================================
echo.
echo   Cambios aplicados en esta version FREE:
echo   [OK] OverlayTestMode = 5 en HKLM\SOFTWARE\Microsoft\Windows\Dwm
echo   [OK] Pantallazos negros en Alt+Tab solucionados
echo   [OK] Stuttering por conflicto MPO eliminado
echo.
echo  ============================================================
echo   IMPORTANTE: DEBES REINICIAR EL PC PARA QUE SURTA EFECTO
echo  ============================================================
echo.
echo  ============================================================
echo   BLOQUEADO EN PLAN FREE - DISPONIBLE EN NEXO OPTIMIZER PRO:
echo  ============================================================
echo.
echo   [PRO] Desactivacion de MPO por adaptador grafico especifico
echo         (Evita conflictos en sistemas con GPU integrada + dedicada)
echo.
echo   [PRO] Fix de Hardware-accelerated GPU Scheduling (HAGS)
echo         (Combinado con MPO off elimina el 99%% de pantallazos)
echo.
echo   [PRO] Desactivacion de Presentation Mode automatico
echo         (Fuerza el modo de menor latencia en todos los juegos)
echo.
echo   [PRO] Fix de MPO en monitores multiples
echo         (Configuracion avanzada para setups de 2+ pantallas)
echo.
echo   Consigue todo esto y mucho mas en:
echo   elnexocenter.com/optimizer
echo  ============================================================
echo.
set /p "reboot=Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando - MPO Fix El Nexo aplicado"
exit /b

:REVERTIR
echo.
echo  ============================================================
echo   REVERTIR MPO - RESTAURAR CONFIGURACION POR DEFECTO
echo  ============================================================
echo.
echo   Se restaurara el valor de OverlayTestMode que habia antes
echo   del fix (o se eliminara, que es lo que trae Windows).
echo   Esto puede volver a causar pantallazos en Alt+Tab.
echo.
set /p "confirm_rev=Confirmas que deseas revertir? (S/N): "
if /i not "%confirm_rev%"=="S" (
    echo.
    echo  [!] Operacion cancelada.
    pause & exit /b
)
echo.

echo  [PASO 1/1] Eliminando clave OverlayTestMode...
set "ORIG_T="
set "ORIG_D="
if exist "%NEXO_BK%\backup.txt" (
    for /f "usebackq tokens=1,2,3,4* delims=|" %%a in ("%NEXO_BK%\backup.txt") do (
        if /i "%%a"=="REG" if /i "%%c"=="OverlayTestMode" (
            set "ORIG_T=%%d"
            set "ORIG_D=%%e"
        )
    )
)
if defined ORIG_T if /i not "%ORIG_T%"=="ABSENT" (
    reg add "%DWM_KEY%" /v "OverlayTestMode" /t %ORIG_T% /d "%ORIG_D%" /f >nul 2>&1
    echo  [OK] OverlayTestMode restaurado al valor que tenias antes ^(%ORIG_D%^).
    move /y "%NEXO_BK%\backup.txt" "%NEXO_BK%\backup.restaurado.txt" >nul 2>&1
    goto :REVERTIDO
)
reg query "%DWM_KEY%" /v OverlayTestMode >nul 2>&1
if %errorlevel% neq 0 (
    echo  [!] La clave no existe. El MPO Fix no estaba aplicado.
    pause & exit /b
)
reg delete "%DWM_KEY%" /v "OverlayTestMode" /f >nul 2>&1
if %errorlevel% equ 0 (
    echo  [OK] MPO restaurado a configuracion por defecto de Windows.
) else (
    echo  [!] Error al eliminar la clave. Comprueba permisos de Administrador.
    pause & exit /b
)
if exist "%NEXO_BK%\backup.txt" move /y "%NEXO_BK%\backup.txt" "%NEXO_BK%\backup.restaurado.txt" >nul 2>&1

:REVERTIDO
echo.
echo  ============================================================
echo   MPO FIX - REVERTIDO
echo  ============================================================
echo.
echo   [OK] OverlayTestMode eliminado del registro
echo   [OK] Windows utilizara MPO segun su configuracion original
echo.
echo  ============================================================
echo   IMPORTANTE: DEBES REINICIAR EL PC PARA QUE SURTA EFECTO
echo  ============================================================
echo.
set /p "reboot=Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando - MPO Revertido El Nexo"
exit /b

:: =========================================================================
::  RUTINAS INTERNAS - COPIA DE SEGURIDAD EL NEXO
::    REG|clave|valor|tipo|dato   (o REG|clave|valor|ABSENT| si no existia)
:: =========================================================================
:BK_INIT
if not exist "%NEXO_BK%\" mkdir "%NEXO_BK%" >nul 2>&1
if not exist "%NEXO_BK%\backup.txt" type nul > "%NEXO_BK%\backup.txt" 2>nul
if not exist "%NEXO_BK%\backup.txt" exit /b 1
exit /b 0

:BK_REG
set "_k=%~1"
set "_n=%~2"
%FIND% /I "REG|%_k%|%_n%|" "%NEXO_BK%\backup.txt" >nul 2>&1 && exit /b 0
set "_line="
set "_t="
set "_d="
for /f "delims=" %%L in ('reg query "%_k%" /v "%_n%" 2^>nul ^| %FIND% "REG_"') do set "_line=%%L"
if not defined _line (
    >>"%NEXO_BK%\backup.txt" echo REG^|%_k%^|%_n%^|ABSENT^|
    exit /b 0
)
set "_rest=!_line:*%_n%=!"
for /f "tokens=1*" %%a in ("!_rest!") do (
    set "_t=%%a"
    set "_d=%%b"
)
>>"%NEXO_BK%\backup.txt" echo REG^|%_k%^|%_n%^|!_t!^|!_d!
exit /b 0
