@echo off
:: =========================================================================
::   EL NEXO - REVERT: NET OPTIMIZER [PLAN: FREE]  (v5.1)
::   Deshace SOLO lo que cambia Nexo_Net_Optimizer.bat (version FREE):
::     - autotuning, RSS y timestamps TCP
::     - NonBestEffortLimit (QoS)
::     - DNS de los adaptadores "Ethernet" y "Wi-Fi" (si se cambiaron)
::   El reset de Winsock y el vaciado de la cache DNS no se pueden
::   deshacer (tampoco hace falta: Windows los reconstruye solo).
::   Via principal: copia de seguridad en
::     %ProgramData%\ElNexo\Backup\Nexo_Net_Optimizer\backup.txt
::   Sin copia: valores de fabrica de Windows, solo para esos ajustes.
:: =========================================================================
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO - REVERT Net Optimizer
color 0E

fsutil dirty query %systemdrive% >nul 2>&1
if %errorlevel% neq 0 (
    cls & color 0C
    echo  Se requieren permisos de Administrador.
    echo  Haz clic derecho y selecciona "Ejecutar como administrador"
    pause & exit /b
)

set "FIND=%SystemRoot%\System32\find.exe"
set "NEXO_BK=%ProgramData%\ElNexo\Backup\Nexo_Net_Optimizer"

cls
color 0E
echo.
echo  ============================================================
echo   EL NEXO - REVERT: NET OPTIMIZER
echo   Restaurando configuracion original de red...
echo  ============================================================
echo.
if exist "%NEXO_BK%\backup.txt" (
    echo  [OK] Copia de seguridad encontrada: se restauran tus valores originales.
) else (
    echo  [!] No hay copia de seguridad de El Nexo.
    echo      Se aplican los valores de fabrica de Windows, solo en los
    echo      ajustes que modifica Nexo_Net_Optimizer.bat.
)
echo.

:: -- TCP/IP ----------------------------------------------------------------
echo  [1/3] Restaurando pila TCP/IP...
if exist "%NEXO_BK%\backup.txt" (
    for /f "usebackq tokens=1,2,3 delims=|" %%a in ("%NEXO_BK%\backup.txt") do (
        if /i "%%a"=="NET" (
            if /i "%%b"=="AUTOTUNING" netsh int tcp set global autotuninglevel=%%c >nul 2>&1
            if /i "%%b"=="RSS" netsh int tcp set global rss=%%c >nul 2>&1
            if /i "%%b"=="TIMESTAMPS" if /i not "%%c"=="Allowed" netsh int tcp set global timestamps=%%c >nul 2>&1
        )
    )
)
:: Sin copia no se toca nada: los valores que aplica el script ya son los
:: de fabrica de Windows (autotuning normal, RSS activado, timestamps off).
echo  [OK] TCP/IP restaurado.

:: -- QOS -------------------------------------------------------------------
echo.
echo  [2/3] Restaurando QoS...
if exist "%NEXO_BK%\backup.txt" (
    call :RESTORE_GENERIC
) else (
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /f >nul 2>&1
)
echo  [OK] QoS restaurado.

:: -- DNS -------------------------------------------------------------------
echo.
echo  [3/3] Restaurando DNS...
if exist "%NEXO_BK%\backup.txt" (
    for /f "usebackq tokens=1,2,3 delims=|" %%a in ("%NEXO_BK%\backup.txt") do (
        if /i "%%a"=="DNS" (
            if /i "%%c"=="DHCP" (
                netsh interface ip set dns name="%%b" source=dhcp >nul 2>&1
                echo  [*] %%b: DNS automatico ^(DHCP^)
            ) else if /i not "%%c"=="ABSENT" (
                call :SET_DNS "%%b" "%%c"
                echo  [*] %%b: DNS %%c
            )
        )
    )
) else (
    rem Sin copia: solo se vuelve a DHCP si el DNS actual es el que pone el script
    call :DNS_DEFAULT "Ethernet"
    call :DNS_DEFAULT "Wi-Fi"
)
ipconfig /flushdns >nul 2>&1
echo  [OK] DNS restaurado. Cache DNS limpiada.

if exist "%NEXO_BK%\backup.txt" move /y "%NEXO_BK%\backup.txt" "%NEXO_BK%\backup.restaurado.txt" >nul 2>&1

echo.
echo  ============================================================
echo   REVERT COMPLETADO
echo  ============================================================
echo   La red ha vuelto a la configuracion anterior.
echo   REINICIA el PC para aplicar todos los cambios de red.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Revert Net Optimizer El Nexo..."
exit

:: =========================================================================
::  RUTINAS INTERNAS
:: =========================================================================
:RESTORE_GENERIC
setlocal DisableDelayedExpansion
for /f "usebackq tokens=1,2,3,4* delims=|" %%a in ("%NEXO_BK%\backup.txt") do (
    if /i "%%a"=="REG" (
        if /i "%%d"=="ABSENT" (
            reg delete "%%b" /v "%%c" /f >nul 2>&1
        ) else (
            reg add "%%b" /v "%%c" /t %%d /d "%%e" /f >nul 2>&1
        )
        echo  [*] Restaurado: %%c
    )
)
endlocal
exit /b 0

:SET_DNS
set "_i=0"
for %%s in (%~2) do (
    set /a _i+=1
    if !_i! equ 1 (
        netsh interface ip set dns name="%~1" source=static address=%%s >nul 2>&1
    ) else (
        netsh interface ip add dns name="%~1" address=%%s index=!_i! >nul 2>&1
    )
)
exit /b 0

:DNS_DEFAULT
set "_ck="
set "_guid="
set "_ns="
for /f "delims=" %%K in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Network\{4D36E972-E325-11CE-BFC1-08002BE10318}" /s /f "%~1" /d /e 2^>nul ^| %FIND% /I "\Connection"') do set "_ck=%%K"
if not defined _ck exit /b 0
set "_ck=%_ck:\Connection=%"
for %%G in ("%_ck%") do set "_guid=%%~nxG"
for /f "tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%_guid%" /v NameServer 2^>nul ^| %FIND% "REG_SZ"') do set "_ns=%%b"
if not defined _ns exit /b 0
set "_ns=%_ns: =,%"
if "%_ns%"=="1.1.1.1,1.0.0.1" goto :DNS_DEFAULT_DHCP
if "%_ns%"=="8.8.8.8,8.8.4.4" goto :DNS_DEFAULT_DHCP
exit /b 0
:DNS_DEFAULT_DHCP
netsh interface ip set dns name="%~1" source=dhcp >nul 2>&1
echo  [*] %~1: DNS automatico ^(DHCP^)
exit /b 0
