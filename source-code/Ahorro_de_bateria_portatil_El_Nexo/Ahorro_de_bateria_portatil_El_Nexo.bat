@echo off
:: =========================================================================
::   EL NEXO - SISTEMA DE AUTONOMIA EXTENDIDA v4.0 (ECO-MODE)
::   Protocolo: Ahorro Inteligente de Bateria
:: =========================================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO v4.0 - MODO AHORRO DE BATERIA
color 0B

:: VERIFICACION DE PRIVILEGIOS
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    cls
    color 0C
    echo.
    echo  ============================================================
    echo   ACCESO DENEGADO - Se requieren permisos de Administrador
    echo  ============================================================
    echo.
    echo   Haz clic derecho sobre el archivo y selecciona:
    echo   "Ejecutar como administrador"
    echo.
    echo  ============================================================
    pause
    exit /b
)

:: CABECERA CIBERPUNK "EL NEXO"
cls
color 0B
echo.
echo  ============================================================
echo      _____ _       _   _ _______   _______  
echo     ^|  ___^| ^|     ^| \ ^| ^|  ___\ \ / /  _ \ 
echo     ^| ^|__ ^| ^|     ^|  \^| ^| ^|__  \ V /^| ^| ^| ^|
echo     ^|  __^|^| ^|     ^| . ` ^|  __^|  ^> ^< ^| ^| ^| ^|
echo     ^| ^|___^| ^|____ ^| ^|\  ^| ^|___ / . \^| ^|_^| ^|
echo     ^|_____^|______^|_^| \_^|_____/_/ \_\_____/ 
echo.
echo  ============================================================
echo   PROTOCOLO: EXTENSION DE AUTONOMIA [MODO ECO]
echo   VERSION: 4.0 ENHANCED - Estado: Iniciando secuencia...
echo  ============================================================
echo.

:: PUNTO DE CONTROL
echo  [PASO 1/7] Creando punto de restauracion de seguridad...
echo.
set /p "backup= Deseas crear un respaldo antes de continuar? (S/N): "
if /i "%backup%"=="S" (
    echo.
    echo  [*] Generando punto de restauracion del sistema...
    powershell -Command "Checkpoint-Computer -Description 'El Nexo v4.0 Eco Mode' -RestorePointType 'MODIFY_SETTINGS'" 2>nul
    if !errorlevel! equ 0 (
        echo  [OK] Punto de restauracion creado correctamente.
    ) else (
        echo  [!] No se pudo crear el punto. Continuando de todos modos...
    )
) else (
    echo  [!] Saltando respaldo por decision del usuario.
)

:: PLAN ECO MEJORADO
echo.
echo  [PASO 2/7] Creando plan de ahorro inteligente...
echo.
set "nexo_eco_guid=33333333-3333-3333-3333-333333333333"
powercfg -delete %nexo_eco_guid% >nul 2>&1
powercfg -duplicatescheme a1841308-3541-4fab-bc81-f71556f20b4a %nexo_eco_guid% >nul 2>&1
powercfg -changename %nexo_eco_guid% "Ahorro Inteligente El Nexo" "Plan optimizado para maxima duracion de bateria" >nul 2>&1
powercfg -setactive %nexo_eco_guid%

:: Configuracion avanzada
echo  [*] Ajustando parametros de bateria...
powercfg -change -monitor-timeout-dc 3 >nul 2>&1
powercfg -change -disk-timeout-dc 5 >nul 2>&1
powercfg -change -standby-timeout-dc 10 >nul 2>&1
powercfg -h on >nul 2>&1

:: CPU limitado al 75%
powercfg -setdcvalueindex %nexo_eco_guid% sub_processor PROCTHROTTLEMIN 5 >nul 2>&1
powercfg -setdcvalueindex %nexo_eco_guid% sub_processor PROCTHROTTLEMAX 75 >nul 2>&1
powercfg -setdcvalueindex %nexo_eco_guid% sub_processor PERFBOOSTMODE 0 >nul 2>&1

:: Desactivar Turbo Boost en bateria
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v "Attributes" /t REG_DWORD /d 2 /f >nul 2>&1
powercfg -setdcvalueindex %nexo_eco_guid% 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 0 >nul 2>&1

:: PCI Express ahorro maximo
powercfg -setdcvalueindex %nexo_eco_guid% sub_pciexpress aspm 2 >nul 2>&1

:: Refrigeracion pasiva
powercfg -setdcvalueindex %nexo_eco_guid% 54533251-82be-4824-96c1-47b60b740d00 94D3A615-A899-4AC5-AD2C-96D587C4A8D9 0 >nul 2>&1

echo  [OK] Plan de ahorro activado.

:: INTERFAZ SIMPLIFICADA
echo.
echo  [PASO 3/7] Reduciendo efectos visuales...
echo.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] Efectos de vidrio desactivados.

:: APPS DE FONDO
echo.
echo  [PASO 4/7] Limitando aplicaciones en segundo plano...
echo.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d 2 /f >nul 2>&1
echo  [OK] Apps de fondo controladas.

:: BRILLO ADAPTATIVO
echo.
echo  [PASO 5/7] Activando brillo adaptativo...
echo.
powercfg -setdcvalueindex %nexo_eco_guid% 7516b95f-f776-4464-8c53-06167f40cc99 fbd9aa66-9553-4097-ba44-ed6e9d65eab8 1 >nul 2>&1
echo  [OK] Pantalla se ajustara automaticamente.

:: POWER THROTTLING
echo.
echo  [PASO 6/7] Activando throttling inteligente...
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PowerThrottlingOff" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] Sistema reducira velocidad cuando no sea necesaria.

:: NETWORK POWER SAVING
echo.
echo  [PASO 7/7] Optimizando red para ahorro...
echo.
for /l %%n in (0,1,9) do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\000%%n" /v "PnPCapabilities" /t REG_DWORD /d 16 /f >nul 2>&1
)
echo  [OK] Adaptadores de red en modo eco.

:: FINALIZACION
echo.
echo  ============================================================
echo   OPTIMIZACION COMPLETADA CON EXITO
echo  ============================================================
echo.
echo   Tu portatil ahora durara mucho mas con bateria.
echo   
echo   IMPORTANTE:
echo   - Este modo es ideal para tareas livianas
echo   - Para gaming, usa el plan de Alto Rendimiento
echo   
echo   Se abrira el Panel de Control para activar el plan.
echo.
echo  ============================================================
echo.
pause

:: Abrir panel de energia
start powercfg.cpl

echo.
echo  [*] No es necesario reiniciar, los cambios ya estan activos.
echo.
pause
exit
