@echo off
title EL NEXO: RESTAURAR RED A FÁBRICA
chcp 65001 >nul
color 0E

net session >nul 2>&1
if %errorlevel% neq 0 (echo [ERROR] Ejecuta como Admin. & pause & exit)

echo [-] Restaurando Pila TCP/IP y DNS...
netsh int ip reset >nul
netsh winsock reset >nul
netsh int tcp set global autotuninglevel=normal >nul
netsh int tcp set global heuristics=enabled >nul
netsh int tcp set global rss=enabled >nul
netsh int tcp set global chimney=default >nul
netsh int tcp set global timestamps=default >nul

echo [-] Eliminando ajustes de latencia del registro...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 10 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 20 /f >nul

echo [OK] Red restaurada. Reinicia para completar.
pause
exit