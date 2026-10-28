@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EL NEXO v5.2 - PROCESS KILLER [PLAN: FREE]
:: =========================================================================
::  EL NEXO - PROCESS KILLER [PLAN: FREE]  v5.2
::  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
::  Cierra launchers que estan solo en la bandeja del sistema. Si un
::  launcher tiene un juego u otra ventana abierta, NO se cierra.
::  No cambia ninguna configuracion de Windows.
:: =========================================================================
set "UI_FILE=%~nx0"
call :UI_INIT "Nexo_Process_Killer"
call :UI_HEADER "PROCESS KILLER" "5.2" "PLAN: FREE - solo Nivel 1"
call :UI_REQUIRE_ADMIN || exit /b 1

echo.
call :UI_INFO "Escaneando procesos activos..."
set "L_VAL=0"
for /f "tokens=*" %%r in ('powershell -NoProfile -Command "try { $l=0; foreach ($n in @('steam','epicgameslauncher','origin','eadesktop','upc','battle.net')) { Get-Process -Name $n -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -eq [IntPtr]::Zero } | ForEach-Object { $l += [math]::Round($_.WorkingSet64/1MB) } }; Write-Output $l } catch { Write-Output 0 }"') do set "L_VAL=%%r"

call :UI_PLAN_BEGIN "QUE VA A HACER ESTE SCRIPT"
call :UI_AUTO "Cerrar Steam, Epic, EA, Ubisoft y Battle.net de la bandeja"
call :UI_INFO "(si tienen un juego o una ventana abierta, se dejan como estan)"
call :UI_AUTO "Cerrar Widgets y Game Bar si estan en segundo plano"
call :UI_INFO "RAM estimada a liberar: ~%L_VAL% MB"
call :UI_PLAN_END
call :UI_INFO "Los programas cerrados vuelven al abrirlos o al reiniciar."
call :UI_CONFIRM "Ejecutar Nivel 1" || exit /b 0

call :UI_STEP 1 1 "Nivel 1 - Limpieza de launchers..."
:: Un launcher solo se cierra si NINGUNO de sus procesos hijos tiene ventana
:: (un juego abierto desde Steam o Epic es hijo del launcher).
:: El codigo PowerShell va en texto plano en estas variables (PK1..PK6) y se
:: ejecuta una sola vez; su salida se lee linea a linea (KILL, KEEP, TOTAL).
set "PK1=$all = @(Get-CimInstance Win32_Process); "
set "PK2=function Get-Desc([int]$root) { $seen=@{}; $q=New-Object System.Collections.Queue; $q.Enqueue($root); $out=@(); while ($q.Count -gt 0) { $id=$q.Dequeue(); foreach ($c in $all) { if ($c.ParentProcessId -eq $id -and -not $seen.ContainsKey([int]$c.ProcessId)) { $seen[[int]$c.ProcessId]=1; $out+=$c; $q.Enqueue([int]$c.ProcessId) } } }; $out }; "
set "PK3=function Has-Window([int]$root) { foreach ($d in (Get-Desc $root)) { $p=Get-Process -Id $d.ProcessId -ErrorAction SilentlyContinue; if ($p -and $p.MainWindowHandle -ne [IntPtr]::Zero) { return $true } }; return $false }; $killed=0; "
set "PK4=foreach ($l in @('steam','epicgameslauncher','origin','eadesktop','upc','battle.net')) { Get-Process -Name $l -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -eq [IntPtr]::Zero } | ForEach-Object { if (Has-Window $_.Id) { Write-Output ('KEEP ' + $_.ProcessName) } else { foreach ($d in (Get-Desc $_.Id)) { Stop-Process -Id $d.ProcessId -Force -ErrorAction SilentlyContinue }; Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue; $killed++; Write-Output ('KILL ' + $_.ProcessName) } } }; "
set "PK5=foreach ($b in @('widgets','gamebar')) { Get-Process -Name $b -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -eq [IntPtr]::Zero } | ForEach-Object { Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue; $killed++; Write-Output ('KILL ' + $_.ProcessName) } }; "
set "PK6=Write-Output ('TOTAL ' + $killed)"
set "PK_TOTAL=0"
for /f "tokens=1,*" %%a in ('powershell -NoProfile -Command "!PK1!!PK2!!PK3!!PK4!!PK5!!PK6!"') do (
    if "%%a"=="KILL" call :UI_INFO "Cerrado: %%b"
    if "%%a"=="KEEP" call :UI_WARN "Omitido, tiene un juego o ventana abierta: %%b"
    if "%%a"=="TOTAL" set "PK_TOTAL=%%b"
)
call :UI_OK "Nivel 1: !PK_TOTAL! procesos cerrados. RAM de los launchers liberada."

call :UI_FINAL "PROCESS KILLER FREE - COMPLETADO" "" 0
call :UI_PRO_BEGIN
call :UI_PRO "Nivel 2: actualizadores en segundo plano desactivados" "Google, Edge y Adobe; servicios de telemetria"
call :UI_PRO "Nivel 3: software RGB cerrado" "Armoury Crate, iCUE, RGB Fusion, Mystic Light, SignalRGB"
call :UI_PRO_END
call :UI_PAUSE
exit /b 0

:: @@BLOCK ui@@
