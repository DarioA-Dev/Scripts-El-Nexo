@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - PROCESS KILLER [PLAN: FREE]
:: =========================================================================
::  EL NEXO - PROCESS KILLER [PLAN: FREE]  v5.2
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Cierra launchers que estan solo en la bandeja del sistema. Si un
::  launcher tiene un juego u otra ventana abierta, NO se cierra.
::  No cambia ninguna configuracion de Windows.
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Nexo_Process_Killer"
call :UI_HEADER "PROCESS KILLER" "5.2" "PLAN: FREE - solo Nivel 1"
call :UI_REQUIRE_ADMIN || exit /b 1

echo.
call :UI_INFO "Escaneando procesos activos..."
set "L_VAL=0"
for /f "tokens=*" %%r in ('powershell -NoProfile -Command "try { $l=0; foreach ($n in @('steam','epicgameslauncher','origin','eadesktop','upc','battle.net')) { Get-Process -Name $n -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -eq [IntPtr]::Zero } | ForEach-Object { $l += [math]::Round($_.WorkingSet64/1MB) } }; Write-Output $l } catch { Write-Output 0 }"') do set "L_VAL=%%r"

call :UI_PLAN_BEGIN "QUE VA A HACER ESTE SCRIPT"
call :UI_AUTO "Cerrar Steam, Epic, EA, Ubisoft y Battle.net de la bandeja"
call :UI_INFO "(si tienen un juego o una ventana abierta, se dejan como estan)"
call :UI_AUTO "Cerrar Widgets y Game Bar si estan en segundo plano"
call :UI_INFO "RAM estimada a liberar: ~%L_VAL% MB"
call :UI_PLAN_END
call :UI_INFO "Los programas cerrados vuelven al abrirlos o al reiniciar."
call :UI_CONFIRM "Ejecutar Nivel 1" || exit /b 0

call :UI_STEP 1 1 "Nivel 1 - Limpieza de launchers..."
:: Un launcher solo se cierra si NINGUNO de sus procesos hijos tiene ventana
:: (un juego abierto desde Steam o Epic es hijo del launcher).
:: El codigo PowerShell va en texto plano en estas variables (PK1..PK6) y se
:: ejecuta una sola vez; su salida se lee linea a linea (KILL, KEEP, TOTAL).
set "PK1=$all = @(Get-CimInstance Win32_Process); "
set "PK2=function Get-Desc([int]$root) { $seen=@{}; $q=New-Object System.Collections.Queue; $q.Enqueue($root); $out=@(); while ($q.Count -gt 0) { $id=$q.Dequeue(); foreach ($c in $all) { if ($c.ParentProcessId -eq $id -and -not $seen.ContainsKey([int]$c.ProcessId)) { $seen[[int]$c.ProcessId]=1; $out+=$c; $q.Enqueue([int]$c.ProcessId) } } }; $out }; "
set "PK3=function Has-Window([int]$root) { foreach ($d in (Get-Desc $root)) { $p=Get-Process -Id $d.ProcessId -ErrorAction SilentlyContinue; if ($p -and $p.MainWindowHandle -ne [IntPtr]::Zero) { return $true } }; return $false }; $killed=0; "
set "PK4=foreach ($l in @('steam','epicgameslauncher','origin','eadesktop','upc','battle.net')) { Get-Process -Name $l -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -eq [IntPtr]::Zero } | ForEach-Object { if (Has-Window $_.Id) { Write-Output ('KEEP ' + $_.ProcessName) } else { foreach ($d in (Get-Desc $_.Id)) { Stop-Process -Id $d.ProcessId -Force -ErrorAction SilentlyContinue }; Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue; $killed++; Write-Output ('KILL ' + $_.ProcessName) } } }; "
set "PK5=foreach ($b in @('widgets','gamebar')) { Get-Process -Name $b -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -eq [IntPtr]::Zero } | ForEach-Object { Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue; $killed++; Write-Output ('KILL ' + $_.ProcessName) } }; "
set "PK6=Write-Output ('TOTAL ' + $killed)"
set "PK_TOTAL=0"
for /f "tokens=1,*" %%a in ('powershell -NoProfile -Command "!PK1!!PK2!!PK3!!PK4!!PK5!!PK6!"') do (
    if "%%a"=="KILL" call :UI_INFO "Cerrado: %%b"
    if "%%a"=="KEEP" call :UI_WARN "Omitido, tiene un juego o ventana abierta: %%b"
    if "%%a"=="TOTAL" set "PK_TOTAL=%%b"
)
call :UI_OK "Nivel 1: !PK_TOTAL! procesos cerrados. RAM de los launchers liberada."

call :UI_FINAL "PROCESS KILLER FREE - COMPLETADO" "" 0
call :UI_PRO_BEGIN
call :UI_PRO "Nivel 2: actualizadores en segundo plano desactivados" "Google, Edge y Adobe; servicios de telemetria"
call :UI_PRO "Nivel 3: software RGB cerrado" "Armoury Crate, iCUE, RGB Fusion, Mystic Light, SignalRGB"
call :UI_PRO_END
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
