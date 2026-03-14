@echo off
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO v5.0 - AUDIO PRO
color 0B

net session >nul 2>&1
if %errorlevel% neq 0 (
    cls
    color 0C
    echo.
    echo  ============================================================
    echo   ACCESO DENEGADO - Se requieren permisos de Administrador
    echo  ============================================================
    echo.
    echo   Haz clic derecho y selecciona "Ejecutar como administrador"
    echo.
    echo  ============================================================
    pause
    exit /b
)

cls
color 0B
echo.
echo  ============================================================
echo    _____ _         _   _ _______  ___   ___
echo   ^|  ___^| ^|       ^| \ ^| ^|  _____^|^|   \ ^|   ^|
echo   ^| ^|__ ^| ^|       ^|  \^| ^| ^|___   ^| ^|\ \^| ^| ^|
echo   ^|  __^|^| ^|       ^| . ` ^|  _^|   ^| ^| \ ` ^| ^|
echo   ^| ^|___^| ^|____   ^| ^|\  ^| ^|____  ^| ^|  \ ^| ^|
echo   ^|_____^|______^|  ^|_^| \_^|______^| ^|___\____^|
echo.
echo  ============================================================
echo   PROTOCOLO: AUDIO PRO [SIN CRACKLING, SIN LATENCIA DPC]
echo   VERSION: 5.0
echo  ============================================================
echo.

echo  [PASO 1/5] Desactivando bloatware de audio (crackling y DPC alta)...
echo.
sc stop NahimicService >nul 2>&1
sc config NahimicService start=disabled >nul 2>&1
sc stop "Nahimic3" >nul 2>&1
sc config "Nahimic3" start=disabled >nul 2>&1
taskkill /f /im NahimicSvc64.exe >nul 2>&1
taskkill /f /im Nahimic3.exe >nul 2>&1
echo  [*] Nahimic: desactivado si estaba presente.

sc stop "Sonic Studio II Service" >nul 2>&1
sc config "Sonic Studio II Service" start=disabled >nul 2>&1
sc stop "Sonic Studio2 Service" >nul 2>&1
sc config "Sonic Studio2 Service" start=disabled >nul 2>&1
taskkill /f /im SonicStudio3.exe >nul 2>&1
taskkill /f /im SonicSuiteService.exe >nul 2>&1
echo  [*] Sonic Studio: desactivado si estaba presente.

powershell -Command "Get-AppxPackage *RealtekSemiconductor* | Remove-AppxPackage" 2>nul
echo  [*] Realtek Audio Console UWP: eliminado si estaba presente.

sc stop "DTSAudioSvc" >nul 2>&1
sc config "DTSAudioSvc" start=disabled >nul 2>&1
echo  [*] DTS Audio: desactivado si estaba presente.

echo  [OK] Purga de bloatware de audio completada.

echo.
echo  [PASO 2/5] Elevando prioridad de audio en el scheduler multimedia...
echo.
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "GPU Priority" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Priority" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "GPU Priority" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1
echo  [OK] Prioridad de audio maximizada.

echo.
echo  [PASO 3/5] Eliminando throttling de red para audio...
echo.
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] Throttling eliminado.

echo.
echo  [PASO 4/5] Activando MSI Mode en controladores de audio HD...
echo.
set "audio_temp=%temp%\nexo_audio_msi_%random%.txt"
reg query "HKLM\SYSTEM\CurrentControlSet\Enum\HDAUDIO" /s /f "Interrupt Management" >"%audio_temp%" 2>nul
if exist "%audio_temp%" (
    for /f "tokens=*" %%i in ('type "%audio_temp%" ^| findstr /I "HKEY_LOCAL_MACHINE"') do (
        reg add "%%i\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d 1 /f >nul 2>&1
    )
    del /f /q "%audio_temp%" >nul 2>&1
    echo  [OK] MSI Mode activado en controladores de audio HD.
) else (
    echo  [!] No se encontraron controladores HD Audio. Saltando MSI.
)

echo.
echo  [PASO 5/5] Ajustando configuracion del servicio de audio...
echo.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Audio" /v "DisableProtectedAudioDG" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] Servicio de audio configurado.

echo.
echo  ============================================================
echo   AUDIO PRO COMPLETADO
echo  ============================================================
echo.
echo   Cambios aplicados:
echo   - Nahimic / Sonic Studio / DTS desactivados
echo   - Realtek Audio Console UWP eliminado
echo   - Scheduler: prioridad maxima para audio
echo   - MSI Mode en controladores de audio HD
echo   - Throttling de red eliminado
echo.
echo   Si tenia crackling de audio, deberia desaparecer al reiniciar.
echo   RECOMENDACION: Reinicia para aplicar MSI Mode correctamente.
echo  ============================================================
echo.
set /p "reboot=Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando Audio Pro El Nexo..."
exit
