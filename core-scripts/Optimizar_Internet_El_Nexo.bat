@echo off
chcp 65001 >nul
title EL NEXO - INGENIERÍA DE RED Y BAJA LATENCIA v3.6
color 0B
setlocal enabledelayedexpansion

:: VERIFICACIÓN DE AUTORIDAD (ADMIN)
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Error: Se requiere nivel de Administrador.
    echo Haz clic derecho ^> Ejecutar como administrador.
    pause
    exit
)

echo ======================================================
echo          PROTOCOLO DE RED: EL NEXO v3.6
echo        (FASE 1: OPTIMIZACIÓN DE PROTOCOLO)
echo ======================================================

:: 1. PUNTO DE CONTROL (SEGURIDAD)
echo.
set /p "rp=¿Generar punto de restauración de red? (S/N): "
if /i "%rp%"=="S" (
    echo [+] Ejecutando instantánea de configuración...
    powershell -Command "Checkpoint-Computer -Description 'Red El Nexo v3.6' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
    echo [OK] Punto de control generado.
)

:: 2. OPTIMIZACIÓN DE LA PILA TCP/IP (NETSH)
echo.
echo [+] Reconfigurando parámetros globales de la pila TCP...
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global heuristics=disabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global fastopen=enabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
:: Establecer proveedor de congestión moderno (CUBIC)
netsh int tcp set supplemental template=internet congestionprovider=cubic >nul 2>&1
echo [OK] Pila TCP/IP optimizada para alta velocidad y baja pérdida.

:: 3. ELIMINACIÓN DE ESTRANGULAMIENTO (THROTTLING)
echo.
echo [+] Ajustando índices de respuesta del sistema...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Restricciones de red multimedia desactivadas.

timeout /t 2 >nul

title EL NEXO: INGENIERÍA DE RED [FASE 2]
color 0B

:: 4. MODO MSI DINÁMICO (POWERSHELL BYPASS)
echo.
echo [+] Sincronizando Modo MSI en controladores de red...
:: Método de archivo temporal más robusto
reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "Interrupt Management" > "%temp%\nexo_msi_net.txt" 2>nul
if exist "%temp%\nexo_msi_net.txt" (
    for /f "tokens=*" %%i in ('type "%temp%\nexo_msi_net.txt" ^| findstr "HKEY_LOCAL_MACHINE"') do (
        reg add "%%i\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d 1 /f >nul 2>&1
    )
    del /f /q "%temp%\nexo_msi_net.txt" >nul 2>&1
)
echo [OK] Interrupciones de hardware optimizadas (Latencia reducida).

:: 5. NAGLE'S ALGORITHM (TCP ACK FREQUENCY)
echo [+] Aplicando TcpAckFrequency a interfaces activas...
:: Método de registro directo más compatible
for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" 2^>nul') do (
    reg add "%%a" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%a" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1
)
echo [OK] Confirmación instantánea de paquetes activada.

:: 6. PROTOCOLO HÍBRIDO (WI-FI / PORTÁTIL)
echo.
set /p "laptop=¿El sistema es un Portátil o usa Wi-Fi? (S/N): "
if /i "%laptop%"=="S" (
    echo [+] Desactivando gestión de energía en adaptadores inalámbricos...
    :: Método de registro más compatible
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0000" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0001" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1
    echo [OK] Ahorro de energía Wi-Fi neutralizado.
)

:: 7. DNS TURBO (OPCIONAL)
echo.
set /p "dns=¿Deseas inyectar DNS de Cloudflare (1.1.1.1)? (S/N): "
if /i "%dns%"=="S" (
    echo [+] Configurando servidores DNS primarios y secundarios...
    :: Método netsh más compatible
    netsh interface ip set dns "Ethernet" static 1.1.1.1 primary >nul 2>&1
    netsh interface ip add dns "Ethernet" 1.0.0.1 index=2 >nul 2>&1
    netsh interface ip set dns "Wi-Fi" static 1.1.1.1 primary >nul 2>&1
    netsh interface ip add dns "Wi-Fi" 1.0.0.1 index=2 >nul 2>&1
    echo [OK] DNS de alta velocidad establecido.
)

:: 8. PURGA FINAL
echo.
echo [AVISO] Se ejecutará un reinicio de la configuración IP.
echo         Es posible que experimentes una micro-desconexión temporal.
echo [+] Reiniciando caché de resolución y sockets...
ipconfig /flushdns >nul 2>&1
netsh winsock reset >nul 2>&1
netsh int ip reset >nul 2>&1

echo ======================================================
echo    PROTOCOLO COMPLETADO. SISTEMA SINCRONIZADO.
echo ======================================================
set /p "r=¿Deseas reiniciar ahora para aplicar cambios? (S/N): "
if /i "%r%"=="S" shutdown /r /t 5
exit
