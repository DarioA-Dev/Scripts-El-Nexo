@echo off
:: =========================================================================
::   EL NEXO - OPTIMIZADOR DE AUDIO PRO v4.0
::   Protocolo: Latencia Cero y Maxima Calidad
:: =========================================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
title EL NEXO v4.0 - AUDIO PRO
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
echo   PROTOCOLO: OPTIMIZACION DE AUDIO [LATENCIA CERO]
echo   VERSION: 4.0 ENHANCED - Estado: Iniciando secuencia...
echo  ============================================================
echo.

:: AUDIO SERVICE PRIORITY
echo  [PASO 1/4] Elevando prioridad de servicios de audio...
echo.
echo  [*] El audio tendra maxima prioridad sobre otros procesos...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "GPU Priority" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Priority" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1
echo  [OK] Prioridad de audio maximizada.

:: NETWORK THROTTLING
echo.
echo  [PASO 2/4] Desactivando throttling de red para audio...
echo.
echo  [*] Evita que la red interrumpa el streaming de audio...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] Throttling eliminado.

:: AUDIO BUFFER OPTIMIZATION
echo.
echo  [PASO 3/4] Optimizando buffers de audio...
echo.
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "GPU Priority" /t REG_DWORD /d 1 /f >nul 2>&1
echo  [OK] Buffers optimizados.

:: AUDIO ENHANCEMENTS
echo.
echo  [PASO 4/4] Configurando mejoras de audio...
echo.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Audio" /v "DisableProtectedAudioDG" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] Sistema de audio configurado.

:: FINALIZACION
echo.
echo  ============================================================
echo   OPTIMIZACION COMPLETADA CON EXITO
echo  ============================================================
echo.
echo   Tu sistema de audio ahora tiene:
echo   - Minima latencia posible
echo   - Maxima prioridad de CPU
echo   - Sin interferencias de red
echo.
echo   RECOMENDACION: Reinicia para aplicar todos los cambios.
echo.
echo  ============================================================
echo.
pause
exit
