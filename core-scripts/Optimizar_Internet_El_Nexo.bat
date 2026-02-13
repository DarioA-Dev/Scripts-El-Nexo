@echo off
chcp 65001 >nul
title EL NEXO - OPTIMIZAR INTERNET
color 0B
setlocal enabledelayedexpansion

:: ADMIN CHECK
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Error: Se requiere Administrador.
    echo Haz clic derecho ^> Ejecutar como administrador.
    pause
    exit
)

echo ======================================================
echo          PROTOCOLO DE RED: EL NEXO v3.6
echo ======================================================

:: PUNTO DE RESTAURACIÓN
echo.
set /p "rp=¿Generar punto de restauración? (S/N): "
if /i "%rp%"=="S" (
    echo [+] Creando punto de restauración...
    wmic /namespace:\\root\default path SystemRestore call CreateRestorePoint "Red El Nexo", 100, 12 >nul 2>&1
    echo [OK] Punto creado.
)

:: PILA TCP/IP
echo.
echo [+] Configurando TCP/IP...
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global heuristics=disabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global fastopen=enabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
netsh int tcp set supplemental template=internet congestionprovider=cubic >nul 2>&1
echo [OK] TCP/IP optimizado.

:: THROTTLING
echo.
echo [+] Eliminando throttling...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Throttling eliminado.

:: MSI MODE (SIN POWERSHELL)
echo.
echo [+] Activando MSI en controladores...
reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "Interrupt Management" > "%temp%\msi_net.txt" 2>nul
if exist "%temp%\msi_net.txt" (
    for /f "tokens=*" %%i in ('type "%temp%\msi_net.txt" ^| findstr "HKEY_LOCAL_MACHINE"') do (
        reg add "%%i\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d 1 /f >nul 2>&1
    )
    del /f /q "%temp%\msi_net.txt" >nul 2>&1
)
echo [OK] MSI activado.

:: TCP ACK FREQUENCY (SIN POWERSHELL)
echo.
echo [+] Aplicando TcpAckFrequency...
for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" 2^>nul') do (
    reg add "%%a" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%a" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1
)
echo [OK] ACK Frequency configurado.

:: WI-FI POWER MANAGEMENT
echo.
set /p "laptop=¿Sistema portátil o Wi-Fi? (S/N): "
if /i "%laptop%"=="S" (
    echo [+] Desactivando ahorro de energía Wi-Fi...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0000" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0001" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0002" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1
    echo [OK] Wi-Fi optimizado.
)

:: DNS CLOUDFLARE
echo.
set /p "dns=¿Configurar DNS Cloudflare (1.1.1.1)? (S/N): "
if /i "%dns%"=="S" (
    echo [+] Configurando DNS...
    netsh interface ip set dns "Ethernet" static 1.1.1.1 primary >nul 2>&1
    netsh interface ip add dns "Ethernet" 1.0.0.1 index=2 >nul 2>&1
    netsh interface ip set dns "Wi-Fi" static 1.1.1.1 primary >nul 2>&1
    netsh interface ip add dns "Wi-Fi" 1.0.0.1 index=2 >nul 2>&1
    echo [OK] DNS configurado.
)

:: PURGA FINAL
echo.
echo [AVISO] Se ejecutará reset de IP.
echo         Posible micro-desconexión temporal.
echo [+] Reiniciando red...
ipconfig /flushdns >nul 2>&1
netsh winsock reset >nul 2>&1
netsh int ip reset >nul 2>&1

echo.
echo ======================================================
echo    PROTOCOLO COMPLETADO
echo ======================================================
set /p "r=¿Reiniciar ahora? (S/N): "
if /i "%r%"=="S" shutdown /r /t 5
exit
