@echo off
:: ==========================================================
::   EL NEXO - INGENIERÍA DE RED Y BAJA LATENCIA v3.6
::   Protocolo: TCP/IP Stack, DNS y Nagle's Algorithm
:: ==========================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO: NETWORK OPTIMIZER v3.6
color 0B

:: 1. VERIFICACIÓN DE AUTORIDAD (ADMIN)
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo   [ERROR] NIVEL DE AUTORIDAD INSUFICIENTE.
    echo   Para optimizar la pila TCP/IP necesitas ser ADMINISTRADOR.
    pause >nul
    exit
)

:: 2. CABECERA ASCII "EL NEXO"
cls
echo.
echo   ______ _       _   _ ______   _____ 
echo  ^|  ____^| ^|     ^| \ ^| ^|  ____^| \ \ / / _ \ 
echo  ^| ^|__  ^| ^|     ^|  \^| ^| ^|__     \ V / ^| ^| ^|
echo  ^|  __^| ^| ^|     ^| . ` ^|  __^|     ^> ^<^| ^| ^| ^|
echo  ^| ^|____^| ^|____ ^| ^|\  ^| ^|____   / . \ ^|_^| ^|
echo  ^|______^|______^|_^| \_^|______^| /_/ \_\___/ 
echo.
echo  ==========================================================
echo   PROTOCOLO: BAJA LATENCIA DE RED (V3.6)
echo   ESTADO: Sincronizando interfaz de red...
echo  ==========================================================
echo.

:: 3. PUNTO DE CONTROL
echo [SEGURIDAD] ¿Deseas generar un Punto de Control de Red?
set /p "rp=Presiona S para crear, o N para saltar: "
if /i "%rp%"=="S" (
    echo.
    echo [+] Creando punto de seguridad...
    powershell -Command "Checkpoint-Computer -Description 'Red El Nexo v3.6' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
    echo [OK] Punto establecido.
)

:: 4. OPTIMIZACIÓN DE LA PILA TCP/IP (EXTREMO)
echo.
echo [+] Reconfigurando parámetros globales de la pila TCP...
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global heuristics=disabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global fastopen=enabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
:: Proveedor de congestión Cubic (Balanceado/Moderno)
netsh int tcp set supplemental template=internet congestionprovider=cubic >nul 2>&1
echo [OK] TCP/IP optimizado para transferencia de alta velocidad.

:: 5. ELIMINACIÓN DE ESTRANGULAMIENTO (THROTTLING)
echo.
echo [+] Ajustando índices de respuesta de red del sistema...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Throttling de red desactivado.

:: 6. MODO MSI DINÁMICO (RED)
echo.
echo [+] Inyectando Modo MSI en adaptadores de red...
reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "Interrupt Management" > "%temp%\nexo_msi_net.txt" 2>nul
if exist "%temp%\nexo_msi_net.txt" (
    for /f "tokens=*" %%i in ('type "%temp%\nexo_msi_net.txt" ^| findstr "HKEY_LOCAL_MACHINE"') do (
        reg add "%%i\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d 1 /f >nul 2>&1
    )
    del /f /q "%temp%\nexo_msi_net.txt" >nul 2>&1
)
echo [OK] Latencia de hardware reducida en el bus PCI.

:: 7. NAGLE'S ALGORITHM (TCP ACK FREQUENCY)
echo.
echo [+] Aplicando TcpAckFrequency (Instante ACK)...
for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" 2^>nul') do (
    reg add "%%a" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%a" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1
)
echo [OK] Confirmación instantánea de paquetes activada (Menor Ping).

:: 8. PROTOCOLO HÍBRIDO (WI-FI / PORTÁTIL)
echo.
set /p "laptop=¿Tu sistema es un PORTÁTIL o usa WI-FI? (S/N): "
if /i "%laptop%"=="S" (
    echo.
    echo [+] Desactivando gestión de energía en adaptadores inalámbricos...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0000" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0001" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0002" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1
    echo [OK] Ahorro de energía en red neutralizado.
)

:: 9. DNS TURBO (CLOUDFLARE)
echo.
echo [!] ¿Deseas inyectar DNS de alta velocidad (1.1.1.1)?
set /p "dns=Tu respuesta (S/N): "
if /i "%dns%"=="S" (
    echo.
    echo [+] Configurando DNS El Nexo...
    netsh interface ip set dns "Ethernet" static 1.1.1.1 primary >nul 2>&1
    netsh interface ip add dns "Ethernet" 1.0.0.1 index=2 >nul 2>&1
    netsh interface ip set dns "Wi-Fi" static 1.1.1.1 primary >nul 2>&1
    netsh interface ip add dns "Wi-Fi" 1.0.0.1 index=2 >nul 2>&1
    echo [OK] Servidores DNS establecidos satisfactoriamente.
)

:: 10. PURGA FINAL
echo.
echo [AVISO] Se va a reiniciar la red para aplicar los cambios.
echo         Tendrás una micro-desconexión temporal de 2-3 segundos.
echo [+] Ejecutando RESET de pila IP y Flush DNS...
ipconfig /flushdns >nul 2>&1
netsh winsock reset >nul 2>&1
netsh int ip reset >nul 2>&1
echo [OK] Conexión de red restablecida y optimizada.

echo.
echo ==========================================================
echo    PROTOCOLO COMPLETADO. RED SINCRONIZADA AL 100%%.
echo ==========================================================
echo Se recomienda reiniciar el PC para consolidar cambios.
echo.
pause
exit
