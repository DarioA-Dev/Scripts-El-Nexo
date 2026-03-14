@echo off
:: =========================================================================
::   EL NEXO - REVERT: NET OPTIMIZER v5.0
::   Deshace todos los cambios aplicados por Nexo_Net_Optimizer.bat
:: =========================================================================
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO - REVERT Net Optimizer
color 0E

net session >nul 2>openfiles >nul 2>&11
if %errorlevel% neq 0 (
    cls & color 0C
    echo  Se requieren permisos de Administrador.
    echo  Haz clic derecho y selecciona "Ejecutar como administrador"
    pause & exit /b
)

cls
color 0E
echo.
echo  ============================================================
echo   EL NEXO - REVERT: NET OPTIMIZER
echo   Restaurando configuracion original de red...
echo  ============================================================
echo.

:: ── TCP/IP STACK ───────────────────────────────────────────────────────────
echo  [1/5] Restaurando pila TCP/IP a valores por defecto...
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global heuristics=enabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global fastopen=disabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set global ecncapability=application >nul 2>&1
netsh int tcp set global dca=enabled >nul 2>&1
:: Restaurar proveedor de congestion por defecto
netsh int tcp set supplemental template=internet congestionprovider=default >nul 2>&1
echo  [OK] TCP/IP restaurado.

:: ── NETWORK THROTTLING ────────────────────────────────────────────────────
echo.
echo  [2/5] Restaurando throttling de red...
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /f >nul 2>&1
echo  [OK] Throttling restaurado.

:: ── NAGLE Y QOS ──────────────────────────────────────────────────────────
echo.
echo  [3/5] Restaurando algoritmo de Nagle y QoS...
for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" 2^>nul ^| findstr /I "HKEY"') do (
    reg delete "%%a" /v "TcpAckFrequency" /f >nul 2>&1
    reg delete "%%a" /v "TCPNoDelay" /f >nul 2>&1
    reg delete "%%a" /v "TcpDelAckTicks" /f >nul 2>&1
)
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /f >nul 2>&1
echo  [OK] Nagle y QoS restaurados.

:: ── REALTEK EEE ───────────────────────────────────────────────────────────
echo.
echo  [4/5] Restaurando Energy-Efficient Ethernet...
for /l %%n in (0,1,9) do (
    reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\000%%n" /v "EEE" /f >nul 2>&1
    reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\000%%n" /v "GreenEthernetEnable" /f >nul 2>&1
    reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\000%%n" /v "PnPCapabilities" /f >nul 2>&1
)
echo  [OK] EEE restaurado.

:: ── DNS ───────────────────────────────────────────────────────────────────
echo.
echo  [5/5] Restaurando DNS automatico (DHCP)...
netsh interface ip set dns "Ethernet" dhcp >nul 2>&1
netsh interface ip set dns "Wi-Fi" dhcp >nul 2>&1
ipconfig /flushdns >nul 2>&1
netsh winsock reset catalog >nul 2>&1
echo  [OK] DNS en automatico (DHCP). Cache DNS limpiada.

echo.
echo  ============================================================
echo   REVERT COMPLETADO
echo  ============================================================
echo   La red ha vuelto a la configuracion por defecto de Windows.
echo   REINICIA el PC para aplicar todos los cambios de red.
echo  ============================================================
echo.
set /p "reboot= Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Revert Net Optimizer El Nexo..."
exit
