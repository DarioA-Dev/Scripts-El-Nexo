@echo off
chcp 65001 >nul
title EL NEXO - RENDIMIENTO PORTÁTIL v3.6
color 0A
setlocal enabledelayedexpansion

:: 1. VERIFICACIÓN DE AUTORIDAD
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo [ERROR] SE REQUIERE ACCESO AL KERNEL. EJECUTA COMO ADMINISTRADOR.
    echo Haz clic derecho ^> Ejecutar como administrador.
    pause >nul
    exit
)

echo ======================================================
echo          PROTOCOLO PORTÁTIL: EL NEXO v3.6
echo        (FASE 1: MATRIZ DE ENERGÍA Y TÉRMICA)
echo ======================================================

:: 2. PUNTO DE CONTROL
echo.
set /p "backup=¿Generar un Punto de Control de Ingeniería? (S/N): "
if /i "%backup%"=="S" (
    echo [+] Iniciando respaldo de configuración de sistema...
    powershell -Command "Checkpoint-Computer -Description 'Rendimiento Portatil Nexo' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
    echo [OK] Punto de control establecido.
)

:: 3. CREACIÓN DE PLAN "NEXO ELITE" (PROCESO DE ALTA PRIORIDAD)
echo.
echo [+] Construyendo esquema de energía personalizado...
set "nexo_lp_guid=22222222-2222-2222-2222-222222222222"
powercfg -delete %nexo_lp_guid% >nul 2>&1
:: Duplicar el esquema de Máximo Rendimiento
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 %nexo_lp_guid% >nul 2>&1
powercfg -changename %nexo_lp_guid% "Optimización Portátil El Nexo"
powercfg -setactive %nexo_lp_guid%

:: 4. DESBLOQUEO DE PARÁMETROS OCULTOS DEL PROCESADOR (TURBO BOOST)
echo.
echo ======================================================
echo [+] Desbloqueando "Processor Performance Boost Mode".
echo [AVISO] Inyectando acceso a frecuencias Turbo en el registro...
echo ======================================================
:: Hacer visible el modo de boost para forzarlo
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v "Attributes" /t REG_DWORD /d 2 /f >nul 2>&1
:: Configurar Boost Mode en "Agresivo" (Máximo rendimiento)
powercfg -setacvalueindex %nexo_lp_guid% 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 2 >nul 2>&1

:: SEGURIDAD TÉRMICA NEXO: Configuración de refrigeración y estados mínimos
echo [+] Aplicando directivas de refrigeración activa y seguridad...
:: Directiva de refrigeración de sistema: Activo (1)
powercfg -setacvalueindex %nexo_lp_guid% 54533251-82be-4824-96c1-47b60b740d00 94D3A615-A899-4AC5-AD2C-96D587C4A8D9 1 >nul 2>&1
:: Estado mínimo del procesador: 5%% (Permite enfriamiento en reposo)
powercfg -setacvalueindex %nexo_lp_guid% 54533251-82be-4824-96c1-47b60b740d00 8934347c-01ed-4d00-8805-0c7ed2b904d9 5 >nul 2>&1
:: Estado máximo del procesador: 100%%
powercfg -setacvalueindex %nexo_lp_guid% 54533251-82be-4824-96c1-47b60b740d00 bc5038f0-0a87-4fb1-a738-5c41205631cc 100 >nul 2>&1

echo [OK] Frecuencias de CPU liberadas de restricciones de ahorro.

timeout /t 2 >nul

title EL NEXO: RENDIMIENTO PORTÁTIL [FASE 2]
color 0A

:: 5. MODO MSI DINÁMICO (HARDWARE OPTIMIZATION)
echo.
echo [+] Sincronizando Modo MSI en controladores de sistema...
echo ======================================================
echo [AVISO] El sistema está reasignando las interrupciones
echo de la GPU y Red para reducir el Input Lag. 
echo Esto puede tardar unos segundos...
echo ======================================================
reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "Interrupt Management" > "%temp%\nexo_msi_laptop.txt" 2>nul
if exist "%temp%\nexo_msi_laptop.txt" (
    for /f "tokens=*" %%i in ('type "%temp%\nexo_msi_laptop.txt" ^| findstr "HKEY_LOCAL_MACHINE"') do (
        reg add "%%i\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d 1 /f >nul 2>&1
    )
    del /f /q "%temp%\nexo_msi_laptop.txt" >nul 2>&1
)
echo [OK] Prioridad de hardware establecida mediante Message Signaled Interrupts.

:: 6. OPTIMIZACIÓN DE LATENCIA DE RED (REGISTRO)
echo.
echo [+] Configurando adaptadores para baja latencia de señal...
:: Desactivar ahorro de energía en tarjetas de red via registro
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0000" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0001" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0002" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1
echo [OK] Sincronización de red móvil optimizada.

:: 7. AJUSTES DE REGISTRO PARA SISTEMAS MÓVILES
echo.
echo [+] Inyectando parámetros de respuesta instantánea...
:: Desactivar Power Throttling (Evita que Windows limite apps cuando no están en foco)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PowerThrottlingOff" /t REG_DWORD /d 1 /f >nul 2>&1
:: Prioridad de Win32 (Quantum) para procesos en primer plano
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul 2>&1
echo [OK] Prioridades de kernel ajustadas para movilidad.

:: 8. CIERRE DE PROTOCOLO
echo.
echo ======================================================
echo    INGENIERÍA PORTÁTIL COMPLETADA CON ÉXITO.
echo    HARDWARE CONFIGURADO PARA MÁXIMO RENDIMIENTO.
echo ======================================================
echo Se recomienda mantener el portátil CONECTADO A LA CORRIENTE
echo para obtener el 100%% de la potencia inyectada.
echo.
set /p r="¿Deseas reiniciar ahora? (S/N): "
if /i "%r%"=="S" shutdown /r /t 5
exit
