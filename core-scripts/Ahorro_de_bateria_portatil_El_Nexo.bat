@echo off
:: ==========================================================
::   EL NEXO - INGENIERÍA DE AUTONOMÍA MÓVIL v3.6
::   Protocolo: Capado de CPU, Desactivación de Turbo y Eco-Mode
:: ==========================================================
chcp 65001 >nul
title EL NEXO: AHORRO DE BATERÍA [FASE 1]
color 0A
setlocal enabledelayedexpansion

:: 1. VERIFICACIÓN DE PRIVILEGIOS
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo [ERROR] SE REQUIERE ACCESO AL KERNEL. EJECUTA COMO ADMINISTRADOR.
    echo Haz clic derecho > Ejecutar como administrador.
    pause >nul
    exit
)

echo ======================================================
echo          PROTOCOLO DE AUTONOMÍA: EL NEXO v3.6
echo        (FASE 1: CONTROL DE VOLTAJE Y HARDWARE)
echo ======================================================

:: 2. PUNTO DE CONTROL (VOLUNTARIO)
echo.
set /p "backup=¿Deseas generar un Punto de Control de Ingeniería? (S/N): "
if /i "%backup%"=="S" (
    echo [+] Iniciando respaldo de configuración...
    powershell -Command "Checkpoint-Computer -Description 'Eco Nexo' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
)

:: 3. CREACIÓN DE PLAN "NEXO ECO" (BAJO CONSUMO)
echo.
echo [+] Configurando Matriz Energética de bajo consumo...
set "nexo_eco_guid=33333333-3333-3333-3333-333333333333"
powercfg -delete %nexo_eco_guid% >nul 2>&1
:: Duplicar el esquema de "Economizador" (Power Saver)
powercfg -duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e %nexo_eco_guid% >nul 2>&1
powercfg -changename %nexo_eco_guid% "Ahorro Extremo El Nexo"
powercfg -setactive %nexo_eco_guid%

:: 4. CAPADO DE PROCESADOR (REDUCCIÓN DE VATIOS)
echo.
echo ======================================================
echo [+] Aplicando restricciones de frecuencia al silicio.
echo [AVISO] Limitando CPU al 70% y desactivando Turbo Boost.
echo Esto reducirá el calor y el consumo de la batería...
echo ======================================================
:: Desactivar Turbo Boost (Processor Performance Boost Mode -> Disabled)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v "Attributes" /t REG_DWORD /d 2 /f >nul
powercfg -setdcvalueindex %nexo_eco_guid% 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 0
:: Limitar estado máximo del procesador al 70% (Evita altas frecuencias)
powercfg -setdcvalueindex %nexo_eco_guid% 54533251-82be-4824-96c1-47b60b740d00 bc5038f0-0a87-4fb1-a738-5c41205631cc 70
:: Activar refrigeración pasiva (Baja la frecuencia antes de encender ventiladores)
powercfg -setdcvalueindex %nexo_eco_guid% 54533251-82be-4824-96c1-47b60b740d00 94d3a615-a899-4ac5-ae2b-e4d8f634367f 0

:: 5. HARDWARE: PCI EXPRESS Y USB
echo [+] Optimizando buses de datos para ahorro de energía...
powercfg -setdcvalueindex %nexo_eco_guid% sub_pciexpress aspm 2
powercfg -setdcvalueindex %nexo_eco_guid% sub_usb usbsuspend 1
echo [OK] Buses de hardware configurados en ahorro máximo.

timeout /t 2 >nul
:: ==========================================================
::   EL NEXO - INGENIERÍA DE AUTONOMÍA MÓVIL v3.6
::   Protocolo: Power Throttling, Visuales y Hibernación
:: ==========================================================
title EL NEXO: AHORRO DE BATERÍA [FASE 2]
color 0A

:: 6. ACTIVACIÓN DE POWER THROTTLING (CLAVE 2025)
echo.
echo [+] Habilitando Power Throttling de Windows...
echo [AVISO] Forzando a las aplicaciones a usar los núcleos de eficiencia...
:: 0 = Habilitado (Windows gestiona el ahorro)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PowerThrottlingOff" /t REG_DWORD /d 0 /f >nul
echo [OK] Power Throttling activo en el Kernel.

:: 7. RESTRICCIÓN VISUAL (REDUCCIÓN DE CARGA DE GPU)
echo.
echo [+] Desactivando efectos visuales y transparencias...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d 9012028010000000 /f >nul
echo [OK] Interfaz simplificada para menor consumo de GPU.

:: 8. GESTIÓN DE REPOSO (HIBERNACIÓN Y PANTALLA)
echo.
echo [+] Ajustando tiempos de inactividad críticos...
:: Pantalla apagada tras 2 minutos en batería
powercfg -change -monitor-timeout-dc 2
:: Suspender tras 5 minutos en batería
powercfg -change -standby-timeout-dc 5
:: Habilitar Hibernación (Gasta 0W comparado con el modo Suspensión)
powercfg -h on >nul 2>&1
echo [OK] Políticas de suspensión configuradas.

:: 9. APPS DE FONDO Y TELEMETRÍA (MODO ECO)
echo.
echo [+] Neutralizando procesos de fondo durante modo batería...
powershell -Command "Get-AppxPackage | ForEach-Object { reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications' /v 'GlobalUserDisabled' /t REG_DWORD /d 1 /f }" >nul 2>&1
echo [OK] Sincronización de aplicaciones en segundo plano bloqueada.

:: 10. FINALIZACIÓN
echo.
echo ======================================================
echo    PROTOCOLO DE AUTONOMÍA FINALIZADO.
echo    TU PORTÁTIL AHORA ES UN NEXO DE EFICIENCIA.
echo ======================================================
echo Nota: Es normal notar el sistema ligeramente más lento,
echo es la señal de que el procesador está ahorrando energía.
echo.
pause
exit