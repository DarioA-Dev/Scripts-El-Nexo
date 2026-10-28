@echo off
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO v5.0 - NET OPTIMIZER [PLAN: FREE]
color 0B
:: =========================================================================
::  EL NEXO - NET OPTIMIZER [PLAN: FREE]  (v5.1 - blindado)
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Antes de cambiar nada guarda los valores originales en
::  %ProgramData%\ElNexo\Backup\Nexo_Net_Optimizer\backup.txt
::  REVERT_Nexo_Net_Optimizer.bat restaura exactamente esos valores.
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
set "NEXO_BK=%ProgramData%\ElNexo\Backup\Nexo_Net_Optimizer"

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
echo   NET OPTIMIZER   ^|   PLAN: FREE
echo   Para la version completa: elnexocenter.com/optimizer
echo  ============================================================
echo.

call :BK_INIT
if errorlevel 1 (
    echo  [!] No se pudo crear la copia de seguridad en %ProgramData%\ElNexo.
    echo      No se ha cambiado nada.
    pause & exit /b
)
echo  [OK] Copia de seguridad de El Nexo: %NEXO_BK%
echo.

set /p "backup=Crear punto de restauracion? (S/N): "
if /i "%backup%"=="S" (
    call :RESTORE_POINT "El Nexo Net Optimizer FREE"
    if !errorlevel! equ 0 (echo  [OK] Punto creado.) else (
        echo  [!] No se pudo crear.
        echo      Proteccion del sistema desactivada o ya se creo un punto hoy.
        echo      La copia de seguridad de El Nexo sigue activa.
    )
) else (echo  [!] Saltando respaldo.)
echo.

echo  [PASO 1/4] Optimizando pila TCP/IP basica...
call :BK_NETTCP
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
echo  [OK] TCP/IP optimizado.

echo.
echo  [PASO 2/4] QoS al 0%% (ancho de banda completo)...
call :BK_REG "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" "NonBestEffortLimit"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] Reserva de ancho de banda eliminada.

echo.
echo  [PASO 3/4] Configuracion de DNS...
echo.
echo  Opciones de DNS:
echo   [1] Cloudflare 1.1.1.1
echo   [2] Google    8.8.8.8
echo   [3] Mantener DNS actual
echo.
set /p "dns_opt=Elige una opcion (1/2/3): "
if "%dns_opt%"=="1" (
    call :BK_DNS "Ethernet"
    call :BK_DNS "Wi-Fi"
    netsh interface ip set dns "Ethernet" static 1.1.1.1 primary >nul 2>&1
    netsh interface ip add dns "Ethernet" 1.0.0.1 index=2 >nul 2>&1
    netsh interface ip set dns "Wi-Fi" static 1.1.1.1 primary >nul 2>&1
    netsh interface ip add dns "Wi-Fi" 1.0.0.1 index=2 >nul 2>&1
    echo  [OK] DNS Cloudflare configurado.
) else if "%dns_opt%"=="2" (
    call :BK_DNS "Ethernet"
    call :BK_DNS "Wi-Fi"
    netsh interface ip set dns "Ethernet" static 8.8.8.8 primary >nul 2>&1
    netsh interface ip add dns "Ethernet" 8.8.4.4 index=2 >nul 2>&1
    netsh interface ip set dns "Wi-Fi" static 8.8.8.8 primary >nul 2>&1
    netsh interface ip add dns "Wi-Fi" 8.8.4.4 index=2 >nul 2>&1
    echo  [OK] DNS Google configurado.
) else (echo  [!] DNS sin cambios.)

echo.
echo  [PASO 4/4] Limpiando stack de red y cache DNS...
ipconfig /flushdns >nul 2>&1
echo.
echo   El reset de Winsock es una REPARACION, no una optimizacion:
echo   solo sirve si tienes fallos de conexion, obliga a reiniciar y
echo   puede desconfigurar algunas VPN o filtros de red.
echo.
set "wsk=N"
set /p "wsk=Resetear Winsock? (S/N, por defecto N): "
if /i "%wsk%"=="S" (
    netsh winsock reset catalog >nul 2>&1
    echo  [OK] Stack de red limpiado.
) else (
    echo  [OK] Cache DNS limpiada. Winsock sin cambios.
)

echo.
echo  ============================================================
echo   NET OPTIMIZER FREE - COMPLETADO
echo  ============================================================
echo.
echo   Cambios aplicados en esta version FREE:
echo   [OK] TCP/IP basico optimizado
echo   [OK] QoS al 0%% (ancho de banda completo)
echo   [OK] DNS configurable (Cloudflare / Google)
if /i "%wsk%"=="S" (echo   [OK] Winsock reset y cache DNS limpiada) else (echo   [OK] Cache DNS limpiada)
echo.
echo   Para deshacerlo: REVERT_Nexo_Net_Optimizer.bat
echo.
echo  ============================================================
echo   BLOQUEADO EN PLAN FREE - DISPONIBLE EN NEXO OPTIMIZER PRO:
echo  ============================================================
echo.
echo   [PRO] Algoritmo de Nagle desactivado (TcpAckFrequency)
echo         (Paquetes enviados instantaneamente, sin batching)
echo.
echo   [PRO] CTCP como proveedor de congestion
echo         (Mejor algoritmo para gaming online competitivo)
echo.
echo   [PRO] Energy-Efficient Ethernet Realtek desactivado
echo         (Elimina picos de latencia incluso sin carga de red)
echo.
echo   [PRO] NetworkThrottlingIndex eliminado
echo         (Windows deja de limitar el trafico de red en juegos)
echo.
echo   Consigue todo esto y mucho mas en:
echo   elnexocenter.com/optimizer
echo  ============================================================
echo.
set /p "reboot=Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando Net Optimizer FREE El Nexo..."
exit

:: =========================================================================
::  RUTINAS INTERNAS - COPIA DE SEGURIDAD EL NEXO
::  Formato de backup.txt (texto plano, una linea por ajuste):
::    REG|clave|valor|tipo|dato   (o REG|clave|valor|ABSENT| si no existia)
::    NET|AUTOTUNING/RSS/TIMESTAMPS|valor
::    DNS|adaptador|DHCP  o  DNS|adaptador|servidor1,servidor2
::  Solo se guarda la primera vez que se toca cada ajuste.
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

:BK_NETTCP
:: Lectura con CIM (independiente del idioma de Windows); no cambia nada
%FIND% /I "NET|" "%NEXO_BK%\backup.txt" >nul 2>&1 && exit /b 0
for /f "tokens=1,2 delims==" %%a in ('powershell -NoProfile -Command "$t=Get-NetTCPSetting -SettingName Internet -ErrorAction SilentlyContinue; $o=Get-NetOffloadGlobalSetting -ErrorAction SilentlyContinue; if ($t) { 'AUTOTUNING=' + $t.AutoTuningLevelLocal; 'TIMESTAMPS=' + $t.Timestamps }; if ($o) { 'RSS=' + $o.ReceiveSideScaling }"') do (
    >>"%NEXO_BK%\backup.txt" echo NET^|%%a^|%%b
)
exit /b 0

:BK_DNS
:: Guarda los DNS IPv4 actuales del adaptador (vacio = automatico por DHCP)
%FIND% /I "DNS|%~1|" "%NEXO_BK%\backup.txt" >nul 2>&1 && exit /b 0
set "_ck="
set "_guid="
set "_ns="
for /f "delims=" %%K in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Network\{4D36E972-E325-11CE-BFC1-08002BE10318}" /s /f "%~1" /d /e 2^>nul ^| %FIND% /I "\Connection"') do set "_ck=%%K"
if not defined _ck (
    >>"%NEXO_BK%\backup.txt" echo DNS^|%~1^|ABSENT
    exit /b 0
)
set "_ck=%_ck:\Connection=%"
for %%G in ("%_ck%") do set "_guid=%%~nxG"
for /f "tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%_guid%" /v NameServer 2^>nul ^| %FIND% "REG_SZ"') do set "_ns=%%b"
if not defined _ns set "_ns=DHCP"
>>"%NEXO_BK%\backup.txt" echo DNS^|%~1^|!_ns!
exit /b 0

:RESTORE_POINT
powershell -NoProfile -Command "try { Checkpoint-Computer -Description '%~1' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction Stop -WarningVariable w -WarningAction SilentlyContinue; if ($w) { exit 2 } } catch { exit 1 }" >nul 2>&1
exit /b %errorlevel%
