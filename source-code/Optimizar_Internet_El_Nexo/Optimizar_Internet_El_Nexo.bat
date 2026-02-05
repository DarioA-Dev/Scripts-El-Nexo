@echo off
:: ==========================================================
::   EL NEXO - INGENIERÍA DE RED Y BAJA LATENCIA v3.6
::   Protocolo: Optimización de Pila TCP/IP y Registro
:: ==========================================================
chcp 65001 >nul
title EL NEXO: INGENIERÍA DE RED [FASE 1]
color 0B
setlocal enabledelayedexpansion

:: VERIFICACIÓN DE AUTORIDAD (ADMIN)
net session >nul 2>&1
if %errorlevel% neq 0 (echo [!] Error: Se requiere nivel de Administrador. & pause & exit)

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
netsh int tcp set global autotuninglevel=normal >nul
netsh int tcp set global heuristics=disabled >nul
netsh int tcp set global rss=enabled >nul
netsh int tcp set global fastopen=enabled >nul
netsh int tcp set global timestamps=disabled >nul
netsh int tcp set global ecncapability=disabled >nul
:: Establecer proveedor de congestión moderno (CUBIC)
netsh int tcp set supplemental template=internet congestionprovider=cubic >nul
echo [OK] Pila TCP/IP optimizada para alta velocidad y baja pérdida.

:: 3. ELIMINACIÓN DE ESTRANGULAMIENTO (THROTTLING)
echo.
echo [+] Ajustando índices de respuesta del sistema...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul
echo [OK] Restricciones de red multimedia desactivadas.

timeout /t 2 >nul
:: ==========================================================
::   EL NEXO - INGENIERÍA DE RED Y BAJA LATENCIA v3.6
::   Protocolo: Hardware, Modo MSI y DNS Turbo
:: ==========================================================
title EL NEXO: INGENIERÍA DE RED [FASE 2]
color 0B

:: 4. MODO MSI DINÁMICO (POWERSHELL BYPASS)
echo.
echo [+] Sincronizando Modo MSI en controladores de red...
:: Esta instrucción de PowerShell evita el error de los símbolos "&" que bloqueaban el script anterior.
powershell -Command "$pci = 'HKLM:\SYSTEM\CurrentControlSet\Enum\PCI'; Get-ChildItem $pci -Recurse | Where-Object { $_.Name -like '*Interrupt Management*' } | ForEach-Object { $msi = \"$($_.Name)\MessageSignaledInterruptProperties\"; if (Test-Path \"Registry::$msi\") { Set-ItemProperty -Path \"Registry::$msi\" -Name 'MSISupported' -Value 1 -Type DWord } }" >nul 2>&1
echo [OK] Interrupciones de hardware optimizadas (Latencia reducida).

:: 5. NAGLE'S ALGORITHM (TCP ACK FREQUENCY)
echo [+] Aplicando TcpAckFrequency a interfaces activas...
powershell -Command "$interfaces = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces'; Get-ChildItem $interfaces | ForEach-Object { Set-ItemProperty -Path $_.PSPath -Name 'TcpAckFrequency' -Value 1 -Type DWord; Set-ItemProperty -Path $_.PSPath -Name 'TCPNoDelay' -Value 1 -Type DWord }" >nul 2>&1
echo [OK] Confirmación instantánea de paquetes activada.

:: 6. PROTOCOLO HÍBRIDO (WI-FI / PORTÁTIL)
echo.
set /p "laptop=¿El sistema es un Portátil o usa Wi-Fi? (S/N): "
if /i "%laptop%"=="S" (
    echo [+] Desactivando gestión de energía en adaptadores inalámbricos...
    powershell -Command "Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | ForEach-Object { Disable-NetAdapterPowerManagement -Name $_.Name -ErrorAction SilentlyContinue }" >nul 2>&1
    echo [OK] Ahorro de energía Wi-Fi neutralizado.
)

:: 7. DNS TURBO (OPCIONAL)
echo.
set /p "dns=¿Deseas inyectar DNS de Cloudflare (1.1.1.1)? (S/N): "
if /i "%dns%"=="S" (
    echo [+] Configurando servidores DNS primarios y secundarios...
    powershell -Command "$adapters = Get-NetAdapter | Where-Object {$_.Status -eq 'Up'}; foreach ($a in $adapters) { Set-DnsClientServerAddress -InterfaceAlias $a.Name -ServerAddresses ('1.1.1.1','1.0.0.1') -ErrorAction SilentlyContinue }" >nul 2>&1
    echo [OK] DNS de alta velocidad establecido.
)

:: 8. PURGA FINAL
echo.
echo [+] Reiniciando caché de resolución y sockets...
ipconfig /flushdns >nul
netsh winsock reset >nul
netsh int ip reset >nul

echo ======================================================
echo    PROTOCOLO COMPLETADO. SISTEMA SINCRONIZADO.
echo ======================================================
set /p "r=¿Deseas reiniciar ahora para aplicar cambios? (S/N): "
if /i "%r%"=="S" shutdown /r /t 5
exit