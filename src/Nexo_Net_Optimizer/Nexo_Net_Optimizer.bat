@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - NET OPTIMIZER [PLAN: FREE]
:: =========================================================================
::  EL NEXO - NET OPTIMIZER [PLAN: FREE]  v5.2
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Guarda tus valores originales antes de cambiarlos. Para deshacerlo:
::  REVERT_Nexo_Net_Optimizer.bat
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Nexo_Net_Optimizer"
call :UI_HEADER "NET OPTIMIZER" "5.2" "PLAN: FREE"
call :UI_REQUIRE_ADMIN || exit /b 1
call :BK_INIT
if errorlevel 1 (
    call :UI_FAIL "No se pudo crear la copia de seguridad. No se ha cambiado nada."
    call :UI_PAUSE
    exit /b 1
)

call :UI_PLAN_BEGIN "QUE VA A HACER ESTE SCRIPT"
call :UI_AUTO "TCP/IP en valores recomendados: autotuning normal, RSS activo"
call :UI_INFO "(solo cambia algo si alguien habia alterado esos valores)"
call :UI_AUTO "Limite de ancho de banda reservable por QoS a 0"
call :UI_INFO "(no aumenta tu velocidad: solo afecta a apps que piden QoS)"
call :UI_AUTO "Vaciar la cache DNS"
call :UI_OPT "DNS de Cloudflare o Google en los adaptadores Ethernet y Wi-Fi"
call :UI_OPT "Restablecer Winsock (reparacion: exige reiniciar)"
call :UI_OPT "Crear un punto de restauracion de Windows"
call :UI_PLAN_END
call :UI_INFO "Tus valores originales se guardan en:"
call :UI_INFO "%NEXO_BK%"
echo.
call :UI_ASK OPT_RP "Crear punto de restauracion"
call :UI_INFO "DNS:  [1] Cloudflare 1.1.1.1   [2] Google 8.8.8.8   [3] Mantener"
set "dns_opt="
set /p "dns_opt= %C_ACC%[?]%C_RST% Elige DNS [1/2/3, por defecto 3]: "
if not "!dns_opt!"=="1" if not "!dns_opt!"=="2" set "dns_opt=3"
call :UI_LOG "[?] DNS = !dns_opt!"
call :UI_INFO "Winsock solo conviene si tienes fallos de conexion; puede"
call :UI_INFO "desconfigurar algunas VPN o filtros de red."
call :UI_ASK OPT_WSK "Restablecer Winsock"
call :UI_CONFIRM "Aplicar los cambios" || exit /b 0

echo.
if "%OPT_RP%"=="S" (
    call :UI_INFO "Creando punto de restauracion..."
    call :UI_RESTORE_POINT "El Nexo Net Optimizer FREE"
) else (
    call :UI_SKIP "Punto de restauracion omitido."
)

call :UI_STEP 1 4 "Pila TCP/IP en valores recomendados..."
call :BK_NETTCP
netsh int tcp set global autotuninglevel=normal >nul 2>&1 || set "SF=1"
netsh int tcp set global rss=enabled >nul 2>&1 || set "SF=1"
netsh int tcp set global timestamps=disabled >nul 2>&1
call :STEP_END "TCP/IP en valores recomendados." "Algun valor de TCP/IP no se pudo aplicar."

call :UI_STEP 2 4 "Limite de ancho de banda reservable (QoS)..."
call :SET_REG "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" "NonBestEffortLimit" REG_DWORD 0
call :STEP_END "Limite QoS reservable a 0." "No se pudo escribir en el registro."

call :UI_STEP 3 4 "Configuracion de DNS..."
if "%dns_opt%"=="3" (
    call :UI_SKIP "DNS sin cambios."
) else (
    if "%dns_opt%"=="1" (set "DNS1=1.1.1.1" & set "DNS2=1.0.0.1" & set "DNSN=Cloudflare") else (set "DNS1=8.8.8.8" & set "DNS2=8.8.4.4" & set "DNSN=Google")
    for %%a in ("Ethernet" "Wi-Fi") do (
        call :BK_DNS %%a
        call :GET_DNS %%a
        if defined _guid (
            netsh interface ip set dns name=%%a source=static address=!DNS1! >nul 2>&1 || set "SF=1"
            netsh interface ip add dns name=%%a address=!DNS2! index=2 >nul 2>&1
        )
    )
    call :STEP_END "DNS !DNSN! configurado." "No se pudo cambiar el DNS de algun adaptador."
)

call :UI_STEP 4 4 "Limpiando cache DNS..."
ipconfig /flushdns >nul 2>&1
call :UI_OK "Cache DNS limpiada."
set "NEED_RB=0"
if "%OPT_WSK%"=="S" (
    netsh winsock reset catalog >nul 2>&1 && (call :UI_OK "Winsock restablecido.") || (call :UI_FAIL "No se pudo restablecer Winsock.")
    set "NEED_RB=1"
) else (
    call :UI_SKIP "Winsock sin cambios."
)

call :UI_FINAL "NET OPTIMIZER FREE - COMPLETADO" "REVERT_Nexo_Net_Optimizer.bat" %NEED_RB%
call :UI_PRO_BEGIN
call :UI_PRO "Energy-Efficient Ethernet desactivado en adaptadores Realtek" "Evita que la tarjeta de red ahorre energia a costa de latencia"
call :UI_PRO_END
call :UI_REBOOT
exit /b 0

:: @@BLOCK ui@@
:: @@BLOCK backup@@
