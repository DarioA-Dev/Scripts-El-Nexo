# Audio Pro — El Nexo 5.2 (FREE)

## Qué hace

Da más prioridad al audio dentro del programador multimedia de Windows (MMCSS) y reduce la CPU que Windows reserva para tareas de fondo.

## Ajustes

| Ajuste | Automático u opcional | Efecto real |
|---|---|---|
| Tarea «Audio» de MMCSS: Scheduling Category High, SFIO Priority High, Latency Sensitive | Automático | Los hilos de audio registrados en MMCSS pasan a la franja de prioridad más alta. Ayuda con la CPU muy cargada. |
| Tarea «Audio»: GPU Priority 1 y Priority 2 | Automático | Sin efecto práctico: Microsoft indica que GPU Priority no se usa y que con categoría High la prioridad se trata siempre como 2. |
| `SystemResponsiveness` a 0 | Automático | Menos CPU reservada a tareas de fondo (Windows lo trata como 10). Efecto pequeño. |
| Punto de restauración | Opcional | Uno cada 24 horas como máximo. |

Desde la versión 5.2 **ya no se toca `NetworkThrottlingIndex`**: desactivarlo quitaba una protección que Windows aplica precisamente para que el tráfico de red no interrumpa el audio.

## Requisitos

- Windows 10 o 11. Ejecutar como administrador.

## Riesgos

- Mínimos. No elimina software de audio ni drivers.

## Cómo revertir

Ejecuta `REVERT_Nexo_Audio_Pro.bat` como administrador. Restaura los 5 valores de la tarea «Audio» y `SystemResponsiveness`.

> Si usaste una versión anterior (5.0), esta dejaba `NetworkThrottlingIndex` en `0xFFFFFFFF`. El REVERT 5.2 no lo toca; para volver al valor de Windows, pon `10` en `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile`.

## Copia de seguridad y logs

- Copia: `C:\ProgramData\ElNexo\Backup\Nexo_Audio_Pro\backup.txt`.
- Log: `C:\ProgramData\ElNexo\Logs\Nexo_Audio_Pro.log`.

## Compatibilidad

Windows 10 y 11.

## Versión y cambios

- **5.2**: se quita `NetworkThrottlingIndex`; interfaz común; ya no se autoeleva con PowerShell.
- **5.1**: copia de seguridad real; el REVERT ya no borra valores que Windows trae de serie.

## Código abierto y verificación

Código: https://github.com/DarioA-Dev/Scripts-El-Nexo (carpeta `source-code-web/Nexo_Audio_Pro`).

```
Get-FileHash .\Nexo_Audio_Pro.zip -Algorithm SHA256
```

Compara el resultado con `releases-dist-web/SHA256SUMS.txt` o con elnexocenter.com/nexos/performance.html.
