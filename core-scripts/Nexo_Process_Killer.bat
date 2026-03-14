@echo off
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO v5.0 - PROCESS KILLER
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
echo   PROTOCOLO: PROCESS KILLER [GESTION INTELIGENTE]
echo   VERSION: 5.0
echo  ============================================================
echo.

set /p "backup=Crear punto de restauracion antes de continuar? (S/N): "
if /i "%backup%"=="S" (
    powershell -Command "Checkpoint-Computer -Description 'El Nexo Process Killer' -RestorePointType 'MODIFY_SETTINGS'" 2>nul
    if !errorlevel! equ 0 (echo  [OK] Punto creado.) else (echo  [!] No se pudo crear.)
) else (
    echo  [!] Saltando respaldo.
)

:: ANALISIS RAPIDO via PowerShell -Command inline
echo.
echo  ============================================================
echo   ANALIZANDO PROCESOS...
echo  ============================================================
echo.

for /f "tokens=*" %%r in ('powershell -NoProfile -Command "try { $l=0; $u=0; $b=0; $launchers=@('steam','epicgameslauncher','origin','discord','battlenet'); $updaters=@('onedrive','searchindexer','edgeupdate','googleupdate'); $bloat=@('gamebar','yourphone','widget','cortana'); Get-Process | ForEach-Object { $n=$_.ProcessName.ToLower(); if ($launchers -contains $n){$l+=[math]::Round($_.WorkingSet64/1MB)}; if ($updaters -contains $n){$u+=[math]::Round($_.WorkingSet64/1MB)}; if ($bloat -contains $n){$b+=[math]::Round($_.WorkingSet64/1MB)} }; Write-Output \"L=$l U=$u B=$b\" } catch { Write-Output 'L=0 U=0 B=0' }"') do set "RESULT=%%r"

:: Parsear resultado
for /f "tokens=1,2,3" %%a in ("%RESULT%") do (
    set "L_VAL=%%a"
    set "U_VAL=%%b"
    set "B_VAL=%%c"
)
set "L_VAL=%L_VAL:L=%"
set "U_VAL=%U_VAL:U=%"
set "B_VAL=%B_VAL:B=%"
if not defined L_VAL set "L_VAL=0"
if not defined U_VAL set "U_VAL=0"
if not defined B_VAL set "B_VAL=0"

echo  [OK] Analisis completado.
echo.
echo  ============================================================
echo   SELECCIONA EL NIVEL DE OPTIMIZACION
echo  ============================================================
echo.
echo  [1] NIVEL 1 - LIMPIEZA SUPERFICIAL
echo      Launchers inactivos, navegadores huerfanos, bloatware
echo      RAM estimada a liberar: ~%L_VAL% MB
echo.
echo  [2] NIVEL 2 - PURGA TACTICA
echo      Todo Nivel 1 + updaters + servicios PERMANENTES
echo      RAM adicional: ~%U_VAL% MB
echo.
echo  [3] NIVEL 3 - MODO ZERO-POINT
echo      Todo Nivel 2 + bloatware Windows + RGB software
echo      (Armoury Crate, iCUE, RGB Fusion - falsos positivos Anti-Cheat)
echo      RAM adicional: ~%B_VAL% MB
echo.
echo  [0] SALIR
echo  ============================================================
echo.
set /p "nivel=Selecciona nivel (1/2/3/0): "
if "%nivel%"=="0" exit
if "%nivel%"=="1" goto NIVEL1
if "%nivel%"=="2" goto NIVEL2
if "%nivel%"=="3" goto NIVEL3
echo  [ERROR] Opcion invalida.
timeout /t 3 >nul
exit

:NIVEL1
cls
color 0B
echo.
echo  [NIVEL 1] Limpieza Superficial...
echo.
powershell -NoProfile -Command ^
    "function Kill-Tree($id) { Get-CimInstance Win32_Process | Where-Object {$_.ParentProcessId -eq $id} | ForEach-Object { Kill-Tree $_.ProcessId }; try { Stop-Process -Id $id -Force -EA Stop } catch {} }; " ^
    "$killed=0; " ^
    "$launchers=@('steam','epicgameslauncher','origin','eadesktop','upc','battlenet'); " ^
    "foreach ($l in $launchers) { Get-Process -Name $l -EA SilentlyContinue | Where-Object {$_.MainWindowHandle -eq 0} | ForEach-Object { Kill-Tree $_.Id; $killed++; Write-Host '  [OK] Cerrado:' $_.ProcessName -ForegroundColor Green } }; " ^
    "$bloat=@('widget','gamebar'); " ^
    "foreach ($b in $bloat) { Get-Process -Name $b -EA SilentlyContinue | Where-Object {$_.MainWindowHandle -eq 0} | ForEach-Object { Kill-Tree $_.Id; $killed++ } }; " ^
    "[GC]::Collect(); " ^
    "Write-Host ('{0} procesos cerrados.' -f $killed) -ForegroundColor Yellow"
goto FIN

:NIVEL2
cls
color 0B
echo.
echo  [NIVEL 2] Purga Tactica...
echo.
:: Desactivar servicios permanentemente
for %%s in (gupdate gupdatem edgeupdate edgeupdatem AdobeARMservice WSearch DiagTrack dmwappushservice) do (
    sc stop %%s >nul 2>&1
    sc config %%s start=disabled >nul 2>&1
    echo  [OK] Desactivado: %%s
)
:: Matar procesos
powershell -NoProfile -Command ^
    "function Kill-Tree($id) { Get-CimInstance Win32_Process | Where-Object {$_.ParentProcessId -eq $id} | ForEach-Object { Kill-Tree $_.ProcessId }; try { Stop-Process -Id $id -Force -EA Stop } catch {} }; " ^
    "$killed=0; " ^
    "$targets=@('steam','epicgameslauncher','origin','discord','adobeupdater','googleupdate','edgeupdate','onedrive','compattelrunner'); " ^
    "foreach ($t in $targets) { Get-Process -Name $t -EA SilentlyContinue | ForEach-Object { Kill-Tree $_.Id; $killed++; Write-Host '  [OK] Kill:' $_.ProcessName -ForegroundColor Green } }; " ^
    "[GC]::Collect(); " ^
    "Write-Host ('{0} procesos cerrados.' -f $killed) -ForegroundColor Yellow"
goto FIN

:NIVEL3
cls
color 0C
echo.
echo  ADVERTENCIA: NIVEL 3 aplica cambios PERMANENTES.
echo  Desactiva bloatware Windows y software RGB.
echo.
set /p "confirm=Estas seguro? (S/N): "
if /i not "%confirm%"=="S" (echo  Cancelado. & timeout /t 3 >nul & exit)
cls
color 0B
echo.
echo  [NIVEL 3] Modo Zero-Point...
echo.
:: Servicios bloatware
for %%s in (XblAuthManager XblGameSave XboxGipSvc XboxNetApiSvc WSearch SysMain DiagTrack dmwappushservice RetailDemo) do (
    sc stop %%s >nul 2>&1
    sc config %%s start=disabled >nul 2>&1
    echo  [OK] Desactivado: %%s
)
:: GameBar registro
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [OK] GameBar desactivado en registro.
:: RGB software — causa falsos positivos en BattlEye, Vanguard, EAC
echo.
echo  Desactivando software RGB (Anti-Cheat safety)...
for %%s in (ArmouryCrateService AsusUpdateCheck LightingService CorsairLLAccess64 CorsairService RGBFusion MSIRGBService) do (
    sc stop %%s >nul 2>&1
    sc config %%s start=disabled >nul 2>&1
)
for %%p in (armoury aurasync icue lghub rgbfusion mysticlight signalrgb) do (
    taskkill /f /im %%p.exe >nul 2>&1
)
echo  [OK] Software RGB desactivado.
:: Purga de procesos con whitelist (FIX v5: variable local $procId)
echo.
echo  Purgando procesos no esenciales...
powershell -NoProfile -Command ^
    "function Kill-Tree($id) { Get-CimInstance Win32_Process | Where-Object {$_.ParentProcessId -eq $id} | ForEach-Object { Kill-Tree $_.ProcessId }; try { Stop-Process -Id $id -Force -EA Stop } catch {} }; " ^
    "$wl=@('system','idle','csrss','lsass','services','smss','wininit','dwm','explorer','svchost','conhost','fontdrvhost','nvcontainer','nvcpl','audiodg','powershell','cmd','taskmgr','winlogon','userinit','sihost','ctfmon','SecurityHealthSystray'); " ^
    "$killed=0; " ^
    "foreach ($proc in Get-Process) { if ($proc.Id -in @(0,4)) { continue }; $isW=$false; foreach ($w in $wl) { if ($proc.ProcessName.ToLower() -like ('*'+$w+'*')) { $isW=$true; break } }; if ($isW) { continue }; $procId=$proc.Id; try { Kill-Tree $procId; $killed++ } catch {} }; " ^
    "[GC]::Collect(); [GC]::WaitForPendingFinalizers(); [GC]::Collect(); " ^
    "Write-Host ('Procesos no esenciales cerrados: {0}' -f $killed) -ForegroundColor Yellow"
goto FIN

:FIN
echo.
echo  ============================================================
echo   PROCESO COMPLETADO
echo  ============================================================
echo.
echo  Ejecuta este script antes de cada sesion de juego.
echo.
set /p "reboot=Deseas reiniciar ahora? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando Process Killer El Nexo..."
exit
