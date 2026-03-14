@echo off
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO v5.0 - SSD NVMe TURBO
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
echo   PROTOCOLO: SSD NVMe TURBO [VELOCIDAD Y PARALELISMO MAXIMO]
echo   VERSION: 5.0
echo  ============================================================
echo.

echo  [PASO 1/7] Creando punto de restauracion...
echo.
powershell -Command "Checkpoint-Computer -Description 'El Nexo SSD Turbo' -RestorePointType 'MODIFY_SETTINGS'" 2>nul
echo  [OK] Punto de restauracion creado.

echo.
echo  [PASO 2/7] Activando TRIM...
echo.
fsutil behavior set DisableDeleteNotify 0 >nul 2>&1
echo  [OK] TRIM activado - el SSD se mantendra rapido a largo plazo.

echo.
echo  [PASO 3/7] Desactivando escrituras innecesarias en disco...
echo.
fsutil behavior set disablelastaccess 1 >nul 2>&1
fsutil behavior set disable8dot3 1 >nul 2>&1
echo  [OK] Timestamps y nombres 8.3 desactivados.

echo.
echo  [PASO 4/7] Desactivando suspension del disco...
echo.
powercfg -change -disk-timeout-ac 0 >nul 2>&1
powercfg -change -disk-timeout-dc 0 >nul 2>&1
echo  [OK] Disco siempre activo.

echo.
echo  [PASO 5/7] Configurando cache para SSD moderno...
echo.
:: LargeSystemCache=0 es el valor CORRECTO para SSD NVMe (no el 1 que usaba v4)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IoPageLockLimit" /t REG_DWORD /d 983040 /f >nul 2>&1
echo  [OK] LargeSystemCache=0 correcto para NVMe.

echo.
echo  [PASO 6/7] Desactivando SysMain (Superfetch)...
echo.
sc stop SysMain >nul 2>&1
sc config SysMain start=disabled >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 3 /f >nul 2>&1
echo  [OK] SysMain desactivado.

echo.
echo  [PASO 7/7] Activando Native NVMe Stack (Win 11 24H2+)...
echo.
for /f "tokens=3" %%v in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuildNumber 2^>nul ^| findstr CurrentBuildNumber') do set "WIN_BUILD=%%v"
if not defined WIN_BUILD set "WIN_BUILD=0"
if %WIN_BUILD% GEQ 26100 (
    echo  [*] Windows 11 24H2 detectado. Activando stack nativo...
    reg add "HKLM\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides" /v "4097064472" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides" /v "4097064473" /t REG_DWORD /d 1 /f >nul 2>&1
    echo  [OK] Native NVMe Stack activado. Requiere reinicio.
) else (
    echo  [!] No compatible con Native NVMe Stack. Se requiere Win 11 24H2+
)
fsutil behavior set memoryusage 2 >nul 2>&1

echo.
echo  ============================================================
echo   SSD NVMe TURBO COMPLETADO
echo  ============================================================
echo.
echo   Cambios aplicados:
echo   - TRIM activado
echo   - Timestamps y 8.3 desactivados
echo   - SysMain/Superfetch desactivado
echo   - LargeSystemCache corregido a 0
echo   - Native NVMe Stack activado (si Win 11 24H2+)
echo.
echo   REINICIA el PC para que todos los cambios entren en efecto.
echo  ============================================================
echo.
set /p "reboot=Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando NVMe Turbo El Nexo..."
exit
