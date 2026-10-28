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

:: @@BLOCK ui@@
:: @@BLOCK restore@@
