# Ahorro Batería — El Nexo 5.2 (FREE)

## Qué hace

Crea y activa un plan de energía que, solo cuando el portátil va con batería, limita la CPU y desactiva el turbo; además reduce efectos visuales y limita las apps en segundo plano.

## Ajustes

| Ajuste | Automático u opcional | Efecto real |
|---|---|---|
| Plan «Ahorro Inteligente El Nexo»: con batería, CPU máxima 75, turbo desactivado, pantalla 3 min, disco 5 min, suspensión 10 min | Automático | Ahorro real de batería a cambio de menos rendimiento con batería. Enchufado no cambia. |
| Hibernación activada | Automático | Permite hibernar cuando la batería se agota. |
| Transparencias y Aero Peek desactivados | Automático | Ahorro pequeño de GPU. |
| Apps de la Store en segundo plano bloqueadas | Automático | Algo menos de consumo. Algunas apps pueden no mostrar notificaciones. |
| Punto de restauración | Opcional | Uno cada 24 horas como máximo. |

## Requisitos

- Portátil con Windows 10 u 11. Ejecutar como administrador.

## Riesgos

- Menos rendimiento con batería (es el objetivo).
- La política de apps en segundo plano hace que Configuración muestre «Algunas opciones las administra tu organización».

## Cómo revertir

Ejecuta `Revertir_cambios_Ahorro_de_bateria_portatil_El_Nexo.bat` como administrador. Activa de nuevo tu plan anterior, borra solo el plan El Nexo y restaura el resto. Ya **no** borra tus otros planes de energía ni los del fabricante.

## Copia de seguridad y logs

- Copia: `C:\ProgramData\ElNexo\Backup\Nexo_Ahorro_Bateria\backup.txt`.
- Log: `C:\ProgramData\ElNexo\Logs\Nexo_Ahorro_Bateria.log`.

## Compatibilidad

Windows 10 y 11. En equipos con Modern Standby (sin plan Economizador) el plan se basa en Equilibrado.

## Versión y cambios

- **5.2**: interfaz común; el bloque PRO ya no ofrece «Turbo Boost desactivado en batería», que la versión FREE ya hace.
- **5.1**: el revert ya no ejecuta `powercfg -restoredefaultschemes`; valores escritos solo en el plan El Nexo; copia de seguridad real.

## Código abierto y verificación

Código: https://github.com/DarioA-Dev/Scripts-El-Nexo (carpeta `source-code-web/Nexo_Ahorro_Bateria`).

```
Get-FileHash .\Nexo_Ahorro_Bateria.zip -Algorithm SHA256
```

Compara el resultado con `releases-dist-web/SHA256SUMS.txt` o con elnexocenter.com/nexos/performance.html.
