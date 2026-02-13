@echo off
chcp 65001 >nul
title LIMPIEZA DEL SISTEMA - EL NEXO v3.6
color 0A

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
echo   LIMPIEZA PROFUNDA - EL NEXO
echo ========================================
echo.
echo [AVISO] Este proceso puede tardar varios minutos.
echo.

:: Componentes Windows (LARGO)
echo [1/6] Optimizando componentes (TARDAR+ 5-15 min)...
dism /online /cleanup-image /startcomponentcleanup /resetbase >nul 2>&1
echo OK

:: Windows Update
echo [2/6] Limpiando Windows Update...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
if exist %windir%\SoftwareDistribution\Download (
    del /s /f /q %windir%\SoftwareDistribution\Download\*.* >nul 2>&1
    rd /s /q %windir%\SoftwareDistribution\Download >nul 2>&1
    mkdir %windir%\SoftwareDistribution\Download >nul 2>&1
)
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
echo OK

:: Temporales
echo [3/6] Limpiando temporales...
del /s /f /q %temp%\*.* >nul 2>&1
del /s /f /q C:\Windows\Temp\*.* >nul 2>&1
del /s /f /q C:\Windows\Prefetch\*.* >nul 2>&1
echo OK

:: Caches GPU
echo [4/6] Limpiando caches de GPU...
if exist "%LocalAppData%\NVIDIA\GLCache" rd /s /q "%LocalAppData%\NVIDIA\GLCache" >nul 2>&1
if exist "%LocalAppData%\AMD\DxCache" rd /s /q "%LocalAppData%\AMD\DxCache" >nul 2>&1
if exist "%LocalAppData%\D3DSCache" rd /s /q "%LocalAppData%\D3DSCache" >nul 2>&1
echo OK

:: Logs
echo [5/6] Limpiando logs del sistema...
for /f "tokens=*" %%e in ('wevtutil el 2^>nul') do wevtutil cl "%%e" >nul 2>&1
echo OK

:: Iconos
echo [6/6] Reconstruyendo cache de iconos...
taskkill /f /im explorer.exe >nul 2>&1
del /f /q "%LocalAppData%\IconCache.db" >nul 2>&1
del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
start explorer.exe
echo OK

echo.
echo ========================================
echo   LIMPIEZA COMPLETADA
echo ========================================
echo.
pause
