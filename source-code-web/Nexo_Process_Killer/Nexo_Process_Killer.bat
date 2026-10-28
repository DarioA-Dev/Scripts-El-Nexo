@echo off
chcp 1252 >nul
setlocal enabledelayedexpansion
title EL NEXO v5.0 - PROCESS KILLER [PLAN: FREE]
color 0B
:: =========================================================================
::  EL NEXO - PROCESS KILLER [PLAN: FREE]  (v5.1 - blindado)
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Cierra launchers que estan solo en la bandeja del sistema (sin
::  ventana). Si un launcher tiene un juego u otra ventana abierta,
::  NO se cierra. No cambia ninguna configuracion de Windows.
:: =========================================================================

fsutil dirty query %systemdrive% >nul 2>&1
if %errorlevel% neq 0 (
    cls & color 0C
    echo.
    echo  ============================================================
    echo   ACCESO DENEGADO - Se requieren permisos de Administrador
    echo  ============================================================
    echo   Haz clic derecho y selecciona "Ejecutar como administrador"
    echo  ============================================================
    pause & exit /b
)

cls
color 0B
echo.
echo  ============================================================
echo    ______ _       _   _ _______   ______
echo   ^|  ____^|^| ^|     ^| \ ^| ^|^|  ___\ \ / / __ \
echo   ^| ^|__  ^| ^|     ^|  \^| ^|^| ^|__  \ V / ^|  ^| ^|
echo   ^|  __^| ^| ^|     ^| . ` ^|^|  __^|  ^> ^<^| ^|  ^| ^|
echo   ^| ^|____^| ^|____ ^| ^|\  ^|^| ^|____/ . \ ^|__^| ^|
echo   ^|______^|^|______^|^|_^| \_^|^|______/_/\_\____/
echo.
echo  ============================================================
echo   PROCESS KILLER   ^|   PLAN: FREE
echo   Version FREE: solo Nivel 1 disponible
echo   Para la version completa: elnexocenter.com/optimizer
echo  ============================================================
echo.

set /p "backup=Crear punto de restauracion? (S/N): "
if /i "%backup%"=="S" (
    call :RESTORE_POINT "El Nexo Process Killer FREE"
    if !errorlevel! equ 0 (echo  [OK] Punto creado.) else (
        echo  [!] No se pudo crear.
        echo      Proteccion del sistema desactivada o ya se creo un punto hoy.
    )
) else (echo  [!] Saltando respaldo.)
echo.

:: ANALISIS RAPIDO (mismos launchers que se cierran despues)
echo  [ANALISIS] Escaneando procesos activos...
set "L_VAL=0"
for /f "tokens=*" %%r in ('powershell -NoProfile -Command "try { $l=0; foreach ($n in @('steam','epicgameslauncher','origin','eadesktop','upc','battle.net')) { Get-Process -Name $n -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -eq [IntPtr]::Zero } | ForEach-Object { $l += [math]::Round($_.WorkingSet64/1MB) } }; Write-Output $l } catch { Write-Output 0 }"') do set "L_VAL=%%r"

echo.
echo  ============================================================
echo   Procesos detectados
echo   RAM estimada a liberar: ~%L_VAL% MB
echo  ============================================================
echo.
echo  [FREE] Solo disponible: NIVEL 1 - Limpieza de launchers
echo.
echo  [BLOQUEADO] Nivel 2 - Purga de updaters y servicios permanentes
echo  [BLOQUEADO] Nivel 3 - Modo Zero-Point con kill de RGB software
echo.
echo  Continuar con Nivel 1? (unica opcion en version FREE)
set /p "confirm=Ejecutar Nivel 1? (S/N): "
if /i not "%confirm%"=="S" (echo  Cancelado. & pause & exit)
echo.

:: NIVEL 1 - LIMPIEZA SUPERFICIAL
:: Un launcher solo se cierra si NINGUNO de sus procesos hijos tiene
:: ventana (un juego abierto desde Steam/Epic es hijo del launcher).
echo  [EJECUTANDO] Nivel 1 - Limpieza Superficial...
echo.
powershell -NoProfile -Command ^
    "$all = @(Get-CimInstance Win32_Process); " ^
    "function Get-Desc([int]$root) { $seen=@{}; $q=New-Object System.Collections.Queue; $q.Enqueue($root); $out=@(); while ($q.Count -gt 0) { $id=$q.Dequeue(); foreach ($c in $all) { if ($c.ParentProcessId -eq $id -and -not $seen.ContainsKey([int]$c.ProcessId)) { $seen[[int]$c.ProcessId]=1; $out+=$c; $q.Enqueue([int]$c.ProcessId) } } }; $out }; " ^
    "function Has-Window([int]$root) { foreach ($d in (Get-Desc $root)) { $p=Get-Process -Id $d.ProcessId -ErrorAction SilentlyContinue; if ($p -and $p.MainWindowHandle -ne [IntPtr]::Zero) { return $true } }; return $false }; " ^
    "$killed=0; " ^
    "$launchers=@('steam','epicgameslauncher','origin','eadesktop','upc','battle.net'); " ^
    "foreach ($l in $launchers) { Get-Process -Name $l -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -eq [IntPtr]::Zero } | ForEach-Object { if (Has-Window $_.Id) { Write-Host '  [!] Omitido (tiene un juego o ventana abierta):' $_.ProcessName -ForegroundColor Yellow } else { foreach ($d in (Get-Desc $_.Id)) { Stop-Process -Id $d.ProcessId -Force -ErrorAction SilentlyContinue }; Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue; $killed++; Write-Host '  [OK] Cerrado:' $_.ProcessName -ForegroundColor Green } } }; " ^
    "foreach ($b in @('widgets','gamebar')) { Get-Process -Name $b -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -eq [IntPtr]::Zero } | ForEach-Object { Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue; $killed++ } }; " ^
    "Write-Host ('{0} procesos cerrados.' -f $killed) -ForegroundColor Yellow"

echo.
echo  ============================================================
echo   PROCESS KILLER FREE - COMPLETADO
echo  ============================================================
echo.
echo   Cambios aplicados en esta version FREE:
echo   [OK] Nivel 1: Launchers inactivos cerrados
echo   [OK] Widgets y GameBar cerrados
echo   [OK] RAM liberada
echo.
echo  ============================================================
echo   BLOQUEADO EN PLAN FREE - DISPONIBLE EN NEXO OPTIMIZER PRO:
echo  ============================================================
echo.
echo   [PRO] Nivel 2 - Purga Tactica
echo         Desactiva updaters de Google/Edge/Adobe PERMANENTEMENTE
echo         Desactiva DiagTrack y telemetria de fondo para siempre
echo.
echo   [PRO] Nivel 3 - Modo Zero-Point
echo         Mata TODO excepto procesos del kernel
echo         Kill de software RGB (Armoury Crate, iCUE, RGB Fusion)
echo         Evita falsos positivos en BattlEye, Vanguard y EAC
echo.
echo   Consigue todo esto y mucho mas en:
echo   elnexocenter.com/optimizer
echo  ============================================================
echo.
set /p "reboot=Deseas reiniciar? (S/N): "
if /i "%reboot%"=="S" shutdown /r /t 10 /c "Reiniciando Process Killer FREE El Nexo..."
exit

:RESTORE_POINT
powershell -NoProfile -Command "try { Checkpoint-Computer -Description '%~1' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction Stop -WarningVariable w -WarningAction SilentlyContinue; if ($w) { exit 2 } } catch { exit 1 }" >nul 2>&1
exit /b %errorlevel%
