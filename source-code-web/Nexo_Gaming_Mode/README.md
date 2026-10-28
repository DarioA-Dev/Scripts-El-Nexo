# Gaming Mode — El Nexo 5.2 (FREE)

## Qué hace

Desactiva la grabación de Xbox Game Bar, la telemetría y algunas tareas de diagnóstico, y limita las apps de la Store en segundo plano. Los servicios de Xbox solo se tocan si lo eliges.

## Ajustes

| Ajuste | Automático u opcional | Efecto real |
|---|---|---|
| Game DVR / grabación de Game Bar desactivados | Automático | Útil si grababas en segundo plano; si no, no cambia nada. |
| Servicios DiagTrack, WerSvc y RetailDemo desactivados | Automático | Privacidad. Efecto en rendimiento despreciable. |
| 3 tareas programadas (Compatibility Appraiser, CEIP Consolidator, DiskDiagnostic) | Automático | Evita picos puntuales de CPU del Appraiser. |
| Apps de la Store en segundo plano bloqueadas | Automático | Algo menos de RAM y CPU. Algunas apps (WhatsApp, Phone Link…) pueden no mostrar notificaciones. |
| Servicios Xbox (XblAuthManager, XblGameSave, XboxGipSvc, XboxNetApiSvc, GamingServices, GamingServicesNet) | Opcional, por defecto NO | No mejora los FPS. Rompe el inicio de sesión Xbox en juegos de PC (también de Steam: Halo MCC, Forza, Minecraft), Game Pass y la actualización de mandos Xbox. |
| Servicio dmwappushservice | Opcional, por defecto NO | Rompe la inscripción en MDM/Intune. |
| Punto de restauración | Opcional | Uno cada 24 horas como máximo. |

## Requisitos

- Windows 10 o 11. Ejecutar como administrador.

## Riesgos

- La política de apps en segundo plano hace que Configuración muestre «Algunas opciones las administra tu organización».
- Los servicios Xbox, si eliges desactivarlos, rompen funciones de juego online.

## Cómo revertir

Ejecuta `REVERT_Nexo_Gaming_Mode.bat` como administrador. Restaura solo lo que cambió el script (registro, servicios y tareas) desde la copia de seguridad, o con valores de fábrica si no la hay.

## Copia de seguridad y logs

- Copia: `C:\ProgramData\ElNexo\Backup\Nexo_Gaming_Mode\backup.txt`.
- Log: `C:\ProgramData\ElNexo\Logs\Nexo_Gaming_Mode.log`.

## Compatibilidad

Windows 10 1607 o posterior y Windows 11. Si un servicio o tarea no existe en tu edición, se omite.

## Versión y cambios

- **5.2**: interfaz común; dmwappushservice opcional; textos PRO corregidos («GPU Priority 8» ya es el valor de Windows y se ha quitado).
- **5.1**: servicios Xbox opcionales; `sc config` corregido; PcaSvc y DPS ya no se desactivan; copia de seguridad real.

## Código abierto y verificación

Código: https://github.com/DarioA-Dev/Scripts-El-Nexo (carpeta `source-code-web/Nexo_Gaming_Mode`).

```
Get-FileHash .\Nexo_Gaming_Mode.zip -Algorithm SHA256
```

Compara el resultado con `releases-dist-web/SHA256SUMS.txt` o con elnexocenter.com/nexos/performance.html.
