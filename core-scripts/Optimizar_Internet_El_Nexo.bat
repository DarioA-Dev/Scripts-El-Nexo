@echo off
chcp 65001 >nul
title OPTIMIZACION DE INTERNET - EL NEXO v3.6
color 0B

:: Verificar Admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo [ERROR] Acceso Denegado
    echo Haz clic derecho ^> Ejecutar como administrador
    echo.
    pause
    exit
)

cls
echo ========================================
echo   OPTIMIZACION DE RED - EL NEXO
echo ========================================
echo.

:: TCP/IP Global
echo [1/5] Configurando TCP/IP...
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global heuristics=disabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global fastopen=enabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
netsh int tcp set supplemental template=internet congestionprovider=cubic >nul 2>&1
echo OK

:: Throttling
echo [2/5] Eliminando throttling...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
echo OK

:: Nagle Algorithm
echo [3/5] Desactivando Nagle's Algorithm...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1
echo OK

:: DNS opcional
echo [4/5] DNS Cloudflare (opcional)...
set /p dns="Configurar DNS 1.1.1.1? (S/N): "
if /i "%dns%"=="S" (
    netsh interface ip set dns "Ethernet" static 1.1.1.1 primary >nul 2>&1
    netsh interface ip add dns "Ethernet" 1.0.0.1 index=2 >nul 2>&1
    netsh interface ip set dns "Wi-Fi" static 1.1.1.1 primary >nul 2>&1
    netsh interface ip add dns "Wi-Fi" 1.0.0.1 index=2 >nul 2>&1
    echo DNS configurado
) else (
    echo Saltado
)

:: Reset final
echo [5/5] Reiniciando red...
echo.
echo [AVISO] Posible micro-corte de red.
timeout /t 2 >nul
ipconfig /flushdns >nul 2>&1
netsh winsock reset >nul 2>&1
netsh int ip reset >nul 2>&1
echo OK

echo.
echo ========================================
echo   OPTIMIZACION COMPLETADA
echo ========================================
echo.
pause
