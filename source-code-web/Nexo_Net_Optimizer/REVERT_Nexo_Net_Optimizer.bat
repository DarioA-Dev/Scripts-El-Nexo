@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - REVERT Net Optimizer
:: =========================================================================
::  EL NEXO - REVERT: NET OPTIMIZER [PLAN: FREE]  v5.2
::  Deshace SOLO lo que cambia Nexo_Net_Optimizer.bat: autotuning, RSS y
::  timestamps TCP; limite QoS; DNS de los adaptadores Ethernet y Wi-Fi.
::  El vaciado de la cache DNS y el reset de Winsock no se deshacen
::  (Windows los reconstruye solo).
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Nexo_Net_Optimizer"
call :UI_HEADER "REVERT: NET OPTIMIZER" "5.2" "PLAN: FREE"
call :UI_REQUIRE_ADMIN || exit /b 1
call :RS_INIT

call :UI_PLAN_BEGIN "QUE VA A RESTAURAR ESTE REVERT"
call :UI_AUTO "Autotuning, RSS y timestamps de TCP"
call :UI_AUTO "Limite de ancho de banda reservable por QoS"
call :UI_AUTO "DNS de los adaptadores Ethernet y Wi-Fi"
call :UI_PLAN_END
if defined HAS_BK (
    call :UI_INFO "Origen: tu copia de seguridad en"
    call :UI_INFO "%NEXO_BK%"
) else (
    call :UI_WARN "No hay copia de seguridad: se usan valores de fabrica de Windows,"
    call :UI_INFO "solo en los ajustes que cambia Nexo_Net_Optimizer.bat."
)
call :UI_CONFIRM "Restaurar ahora" || exit /b 0

call :UI_STEP 1 3 "Pila TCP/IP"
if defined HAS_BK (
    for /f "usebackq tokens=1,2,3 delims=|" %%a in ("%NEXO_BK%\backup.txt") do (
        if /i "%%a"=="NET" (
            if /i "%%b"=="AUTOTUNING" netsh int tcp set global autotuninglevel=%%c >nul 2>&1 || set "SF=1"
            if /i "%%b"=="RSS" netsh int tcp set global rss=%%c >nul 2>&1 || set "SF=1"
            if /i "%%b"=="TIMESTAMPS" if /i not "%%c"=="Allowed" netsh int tcp set global timestamps=%%c >nul 2>&1
        )
    )
)
:: Sin copia no se toca: el script solo pone los valores de fabrica.
call :STEP_END "TCP/IP restaurado." "Algun valor de TCP/IP no se pudo restaurar."

call :UI_STEP 2 3 "Limite QoS"
if defined HAS_BK (
    call :RS_GENERIC
) else (
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /f >nul 2>&1
)
call :STEP_END "QoS restaurado." "No se pudo restaurar el valor de QoS."

call :UI_STEP 3 3 "DNS"
if defined HAS_BK (
    for /f "usebackq tokens=1,2,3 delims=|" %%a in ("%NEXO_BK%\backup.txt") do (
        if /i "%%a"=="DNS" (
            if /i "%%c"=="DHCP" (
                netsh interface ip set dns name="%%b" source=dhcp >nul 2>&1 || set "SF=1"
                call :UI_LOG "%%b: DNS automatico"
            ) else if /i not "%%c"=="ABSENT" (
                call :SET_DNS "%%b" "%%c"
            )
        )
    )
) else (
    rem Sin copia: solo vuelve a DHCP si el DNS actual es el que pone el script
    call :DNS_DEFAULT "Ethernet"
    call :DNS_DEFAULT "Wi-Fi"
)
ipconfig /flushdns >nul 2>&1
call :STEP_END "DNS restaurado y cache DNS limpiada." "No se pudo restaurar el DNS de algun adaptador."

call :RS_CLOSE
call :UI_FINAL "REVERT COMPLETADO" "" 0
call :UI_REBOOT
exit /b 0

:SET_DNS
set "_i=0"
for %%s in (%~2) do (
    set /a _i+=1
    if !_i! equ 1 (
        netsh interface ip set dns name="%~1" source=static address=%%s >nul 2>&1 || set "SF=1"
    ) else (
        netsh interface ip add dns name="%~1" address=%%s index=!_i! >nul 2>&1
    )
)
call :UI_LOG "%~1: DNS %~2"
exit /b 0

:DNS_DEFAULT
call :GET_DNS "%~1"
if not defined _ns exit /b 0
set "_ns=%_ns: =,%"
if "%_ns%"=="1.1.1.1,1.0.0.1" goto :DNS_DEFAULT_DHCP
if "%_ns%"=="8.8.8.8,8.8.4.4" goto :DNS_DEFAULT_DHCP
exit /b 0
:DNS_DEFAULT_DHCP
netsh interface ip set dns name="%~1" source=dhcp >nul 2>&1 || set "SF=1"
call :UI_LOG "%~1: DNS automatico (valor de fabrica)"
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
:: ==========================================================================
::  BLOQUE COMUN DE RESTAURACION - EL NEXO 5.2
::  Lee %ProgramData%\ElNexo\Backup\<script>\backup.txt (creado por el
::  script principal) y devuelve cada ajuste a su valor original.
::  Sin copia, cada REVERT aplica valores de fabrica SOLO en los ajustes que
::  toca su script.
:: ==========================================================================
:RS_INIT
set "NEXO_BK=%ProgramData%\ElNexo\Backup\%UI_ID%"
set "HAS_BK="
if exist "%NEXO_BK%\backup.txt" set "HAS_BK=1"
exit /b 0

:RS_GENERIC
:: Restaura las lineas REG, SVC, TASK y KEY de la copia
for /f "usebackq tokens=1,2,3,4* delims=|" %%a in ("%NEXO_BK%\backup.txt") do (
    if /i "%%a"=="REG" (
        if /i "%%d"=="ABSENT" (
            reg query "%%b" /v "%%c" >nul 2>&1 && (reg delete "%%b" /v "%%c" /f >nul 2>&1 || set "SF=1")
        ) else (
            reg add "%%b" /v "%%c" /t %%d /d "%%e" /f >nul 2>&1 || set "SF=1"
        )
        call :UI_LOG "Restaurado %%c"
    )
    if /i "%%a"=="SVC" if /i not "%%c"=="ABSENT" (
        sc config "%%b" start= %%c >nul 2>&1 || set "SF=1"
        if /i "%%d"=="RUNNING" sc start "%%b" >nul 2>&1
        call :UI_LOG "Servicio %%b restaurado a %%c"
    )
    if /i "%%a"=="TASK" if /i not "%%c"=="ABSENT" (
        schtasks /Change /TN "%%b" /%%c >nul 2>&1 || set "SF=1"
        call :UI_LOG "Tarea %%b restaurada"
    )
    if /i "%%a"=="KEY" if /i "%%c"=="ABSENT" (
        reg query "%%b" >nul 2>&1 && (reg delete "%%b" /f >nul 2>&1 || set "SF=1")
        call :UI_LOG "Clave %%b eliminada"
    )
)
exit /b 0

:RS_PWR
:: Devuelve el plan activo anterior y la hibernacion. %1 = GUID de plan El
:: Nexo a eliminar (se pueden pasar varios separados por espacios)
set "_orig="
set "_hib="
if defined HAS_BK (
    for /f "usebackq tokens=1,2,3 delims=|" %%a in ("%NEXO_BK%\backup.txt") do (
        if /i "%%a"=="PWR" if /i "%%b"=="ACTIVE" set "_orig=%%c"
        if /i "%%a"=="PWR" if /i "%%b"=="HIBERNATE" set "_hib=%%c"
    )
)
set "_target=381b4222-f694-41f0-9685-ff5bb260df2e"
if defined _orig (
    set "_mine="
    for %%p in (%~1) do if /i "%%p"=="!_orig!" set "_mine=1"
    if not defined _mine powercfg /query !_orig! >nul 2>&1 && set "_target=!_orig!"
)
powercfg -setactive %_target% >nul 2>&1 || set "SF=1"
for %%p in (%~1) do powercfg -delete %%p >nul 2>&1
if defined _hib (
    if /i "%_hib%"=="0x0" (powercfg -h off >nul 2>&1) else (powercfg -h on >nul 2>&1)
)
call :UI_LOG "Plan activo: %_target%"
exit /b 0

:SVC_DEFAULT
:: Sin copia: solo actua si el servicio existe y esta desactivado
sc qc "%~1" >nul 2>&1 || exit /b 0
for /f "tokens=3" %%t in ('sc qc "%~1" ^| %FIND% "START_TYPE"') do if "%%t"=="4" (
    sc config "%~1" start= %~2 >nul 2>&1 || set "SF=1"
    call :UI_LOG "Servicio %~1 a %~2 (valor de fabrica)"
)
exit /b 0

:RS_CLOSE
:: Marca la copia como usada: la proxima ejecucion del script crea una nueva
if defined HAS_BK move /y "%NEXO_BK%\backup.txt" "%NEXO_BK%\backup.restaurado.txt" >nul 2>&1
exit /b 0

:GET_DNS
:: _guid del adaptador con ese nombre y _ns con sus DNS IPv4 (vacio = DHCP)
set "_ck="
set "_guid="
set "_ns="
for /f "delims=" %%K in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Network\{4D36E972-E325-11CE-BFC1-08002BE10318}" /s /f "%~1" /d /e 2^>nul ^| %FIND% /I "\Connection"') do set "_ck=%%K"
if not defined _ck exit /b 0
set "_ck=%_ck:\Connection=%"
for %%G in ("%_ck%") do set "_guid=%%~nxG"
for /f "tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%_guid%" /v NameServer 2^>nul ^| %FIND% "REG_SZ"') do set "_ns=%%b"
exit /b 0

:IS_LAPTOP
set "IS_LAPTOP=0"
set "_bc=0"
for /f %%b in ('powershell -NoProfile -Command "@(Get-CimInstance -ClassName Win32_Battery -ErrorAction SilentlyContinue).Count"') do set "_bc=%%b"
if not "%_bc%"=="0" set "IS_LAPTOP=1"
exit /b 0
