@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - AUDIO PRO [PLAN: FREE]
:: =========================================================================
::  EL NEXO - AUDIO PRO [PLAN: FREE]  v5.2
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Guarda tus valores originales antes de cambiarlos. Para deshacerlo:
::  REVERT_Nexo_Audio_Pro.bat
::  v5.2: ya NO toca NetworkThrottlingIndex (desactivarlo quita una
::  proteccion que Windows usa precisamente para el audio).
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Nexo_Audio_Pro"
call :UI_HEADER "AUDIO PRO" "5.2" "PLAN: FREE"
call :UI_REQUIRE_ADMIN || exit /b 1
call :BK_INIT
if errorlevel 1 (
    call :UI_FAIL "No se pudo crear la copia de seguridad. No se ha cambiado nada."
    call :UI_PAUSE
    exit /b 1
)

call :UI_PLAN_BEGIN "QUE VA A HACER ESTE SCRIPT"
call :UI_AUTO "Tarea de audio de MMCSS en categoria High y E/S High"
call :UI_AUTO "Audio marcado como sensible a la latencia"
call :UI_AUTO "SystemResponsiveness a 0: menos CPU reservada a tareas de fondo"
call :UI_INFO "(efecto pequeno; ayuda sobre todo con la CPU muy cargada)"
call :UI_OPT "Crear un punto de restauracion de Windows"
call :UI_PLAN_END
call :UI_INFO "Tus valores originales se guardan en:"
call :UI_INFO "%NEXO_BK%"
echo.
call :UI_ASK OPT_RP "Crear punto de restauracion"
call :UI_CONFIRM "Aplicar los cambios" || exit /b 0

echo.
if "%OPT_RP%"=="S" (
    call :UI_INFO "Creando punto de restauracion..."
    call :UI_RESTORE_POINT "El Nexo Audio Pro FREE"
) else (
    call :UI_SKIP "Punto de restauracion omitido."
)

set "MMKEY=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
call :UI_STEP 1 2 "Elevando prioridad del scheduler de audio..."
call :SET_REG "%MMKEY%\Tasks\Audio" "Scheduling Category" REG_SZ High
call :SET_REG "%MMKEY%\Tasks\Audio" "SFIO Priority" REG_SZ High
call :SET_REG "%MMKEY%\Tasks\Audio" "GPU Priority" REG_DWORD 1
call :SET_REG "%MMKEY%\Tasks\Audio" "Priority" REG_DWORD 2
call :SET_REG "%MMKEY%\Tasks\Audio" "Latency Sensitive" REG_SZ True
call :STEP_END "Prioridad de audio elevada en MMCSS." "No se pudo escribir en el registro."

call :UI_STEP 2 2 "Reduciendo la CPU reservada a tareas de fondo..."
call :SET_REG "%MMKEY%" "SystemResponsiveness" REG_DWORD 0
call :STEP_END "SystemResponsiveness a 0." "No se pudo escribir en el registro."

call :UI_FINAL "AUDIO PRO FREE - COMPLETADO" "REVERT_Nexo_Audio_Pro.bat" 1
call :UI_PRO_BEGIN
call :UI_PRO "Nahimic, Sonic Studio y DTS desactivados" "Causa conocida de chasquidos y picos DPC en algunas placas"
call :UI_PRO "MSI Mode en el controlador de audio HD" "Interrupciones MSI si el driver lo admite"
call :UI_PRO "Prioridad MMCSS para Pro Audio" "Para programas de produccion musical"
call :UI_PRO_END
call :UI_REBOOT
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
::  BLOQUE COMUN DE COPIA DE SEGURIDAD - EL NEXO 5.2
::  Antes de cambiar cada ajuste se guarda su valor ORIGINAL, en texto
::  plano, en %ProgramData%\ElNexo\Backup\<script>\backup.txt
::  Solo se guarda la primera vez: si ejecutas el script varias veces, el
::  REVERT restaura lo que habia antes de la primera ejecucion.
::  Lineas:  REG|clave|valor|tipo|dato   (REG|clave|valor|ABSENT| = no existia)
::           SVC|servicio|tipo_inicio|RUNNING o STOPPED
::           TASK|tarea|ENABLE o DISABLE
::           PWR|ACTIVE|guid   PWR|HIBERNATE|0x0 o 0x1
::           PSET|subgrupo|ajuste|guid|AC|DC   NET|clave|valor
::           DNS|adaptador|DHCP o servidores   KEY|clave|PRESENT o ABSENT
:: ==========================================================================
:BK_INIT
set "NEXO_BK=%ProgramData%\ElNexo\Backup\%UI_ID%"
if not exist "%NEXO_BK%\" mkdir "%NEXO_BK%" >nul 2>&1
if not exist "%NEXO_BK%\backup.txt" type nul > "%NEXO_BK%\backup.txt" 2>nul
if exist "%NEXO_BK%\backup.txt" exit /b 0
set "NEXO_BK="
exit /b 1

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

:BK_SVC
%FIND% /I "SVC|%~1|" "%NEXO_BK%\backup.txt" >nul 2>&1 && exit /b 0
sc qc "%~1" >nul 2>&1
if errorlevel 1 (
    >>"%NEXO_BK%\backup.txt" echo SVC^|%~1^|ABSENT^|
    exit /b 0
)
set "_st="
for /f "tokens=3" %%t in ('sc qc "%~1" ^| %FIND% "START_TYPE"') do set "_st=%%t"
set "_mode=demand"
if "%_st%"=="0" set "_mode=boot"
if "%_st%"=="1" set "_mode=system"
if "%_st%"=="2" set "_mode=auto"
if "%_st%"=="4" set "_mode=disabled"
for /f %%x in ('sc qc "%~1" ^| %FIND% /C "DELAYED"') do if not "%%x"=="0" set "_mode=delayed-auto"
set "_run=STOPPED"
for /f %%x in ('sc query "%~1" ^| %FIND% /C "RUNNING"') do if not "%%x"=="0" set "_run=RUNNING"
>>"%NEXO_BK%\backup.txt" echo SVC^|%~1^|%_mode%^|%_run%
exit /b 0

:BK_TASK
%FIND% /I "TASK|%~1|" "%NEXO_BK%\backup.txt" >nul 2>&1 && exit /b 0
set "_ts=ENABLE"
for /f %%x in ('schtasks /Query /TN "%~1" /XML 2^>nul ^| %FIND% /C "<Enabled>false</Enabled>"') do if not "%%x"=="0" set "_ts=DISABLE"
>>"%NEXO_BK%\backup.txt" echo TASK^|%~1^|%_ts%
exit /b 0

:BK_PWR
%FIND% /I "PWR|" "%NEXO_BK%\backup.txt" >nul 2>&1 && exit /b 0
call :GET_ACTIVE_SCHEME
if defined _g >>"%NEXO_BK%\backup.txt" echo PWR^|ACTIVE^|%_g%
set "_h="
for /f "tokens=3" %%h in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v HibernateEnabled 2^>nul ^| %FIND% "REG_DWORD"') do set "_h=%%h"
if defined _h >>"%NEXO_BK%\backup.txt" echo PWR^|HIBERNATE^|%_h%
exit /b 0

:GET_ACTIVE_SCHEME
set "_g="
for /f "tokens=2 delims=:(" %%g in ('powercfg /getactivescheme') do set "_g=%%g"
if defined _g for /f "tokens=1" %%g in ("%_g%") do set "_g=%%g"
exit /b 0

:BK_PSET
:: Ultimos dos valores hexadecimales de "powercfg /q" = AC y DC (no depende
:: del idioma de Windows)
%FIND% /I "PSET|%~1|%~2|" "%NEXO_BK%\backup.txt" >nul 2>&1 && exit /b 0
call :GET_ACTIVE_SCHEME
if not defined _g exit /b 0
set "_prev="
set "_last="
for /f "tokens=2 delims=:" %%v in ('powercfg /q %_g% %~1 %~2 ^| %FIND% "0x"') do (
    set "_prev=!_last!"
    set "_last=%%v"
)
if not defined _prev exit /b 0
set /a _ac=!_prev!
set /a _dc=!_last!
>>"%NEXO_BK%\backup.txt" echo PSET^|%~1^|%~2^|%_g%^|!_ac!^|!_dc!
exit /b 0

:BK_NETTCP
:: Lectura con CIM (independiente del idioma); no cambia nada
%FIND% /I "NET|" "%NEXO_BK%\backup.txt" >nul 2>&1 && exit /b 0
for /f "tokens=1,2 delims==" %%a in ('powershell -NoProfile -Command "$t=Get-NetTCPSetting -SettingName Internet -ErrorAction SilentlyContinue; $o=Get-NetOffloadGlobalSetting -ErrorAction SilentlyContinue; if ($t) { 'AUTOTUNING=' + $t.AutoTuningLevelLocal; 'TIMESTAMPS=' + $t.Timestamps }; if ($o) { 'RSS=' + $o.ReceiveSideScaling }"') do (
    >>"%NEXO_BK%\backup.txt" echo NET^|%%a^|%%b
)
exit /b 0

:BK_DNS
:: DNS IPv4 actuales del adaptador (vacio = automatico por DHCP)
%FIND% /I "DNS|%~1|" "%NEXO_BK%\backup.txt" >nul 2>&1 && exit /b 0
call :GET_DNS "%~1"
if not defined _guid (
    >>"%NEXO_BK%\backup.txt" echo DNS^|%~1^|ABSENT
    exit /b 0
)
if not defined _ns set "_ns=DHCP"
>>"%NEXO_BK%\backup.txt" echo DNS^|%~1^|!_ns!
exit /b 0

:GET_DNS
set "_ck="
set "_guid="
set "_ns="
for /f "delims=" %%K in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Network\{4D36E972-E325-11CE-BFC1-08002BE10318}" /s /f "%~1" /d /e 2^>nul ^| %FIND% /I "\Connection"') do set "_ck=%%K"
if not defined _ck exit /b 0
set "_ck=%_ck:\Connection=%"
for %%G in ("%_ck%") do set "_guid=%%~nxG"
for /f "tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%_guid%" /v NameServer 2^>nul ^| %FIND% "REG_SZ"') do set "_ns=%%b"
exit /b 0

:BK_KEY
%FIND% /I "KEY|%~1|" "%NEXO_BK%\backup.txt" >nul 2>&1 && exit /b 0
reg query "%~1" >nul 2>&1
if errorlevel 1 (
    >>"%NEXO_BK%\backup.txt" echo KEY^|%~1^|ABSENT
) else (
    >>"%NEXO_BK%\backup.txt" echo KEY^|%~1^|PRESENT
)
exit /b 0

:SET_REG
:: %1 clave  %2 valor  %3 tipo  %4 dato. Guarda el original y escribe.
call :BK_REG "%~1" "%~2"
reg add "%~1" /v "%~2" /t %~3 /d "%~4" /f >nul 2>&1
if errorlevel 1 set "SF=1"
exit /b 0

:SVC_OFF
:: Desactiva un servicio si existe (guarda antes su tipo de inicio)
sc qc "%~1" >nul 2>&1 || exit /b 0
call :BK_SVC "%~1"
sc stop "%~1" >nul 2>&1
sc config "%~1" start= disabled >nul 2>&1
if errorlevel 1 set "SF=1"
call :UI_LOG "Servicio %~1 desactivado"
exit /b 0

:TASK_OFF
:: Desactiva una tarea programada si existe (guarda antes su estado)
schtasks /Query /TN "%~1" >nul 2>&1 || exit /b 0
call :BK_TASK "%~1"
schtasks /Change /TN "%~1" /Disable >nul 2>&1
if errorlevel 1 set "SF=1"
exit /b 0

:IS_LAPTOP
:: IS_LAPTOP=1 si hay bateria (CIM; WMIC ya no existe en Windows 11 24H2)
set "IS_LAPTOP=0"
set "_bc=0"
for /f %%b in ('powershell -NoProfile -Command "@(Get-CimInstance -ClassName Win32_Battery -ErrorAction SilentlyContinue).Count"') do set "_bc=%%b"
if not "%_bc%"=="0" set "IS_LAPTOP=1"
exit /b 0
