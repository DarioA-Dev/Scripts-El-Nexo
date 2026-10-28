# MPO Fix — El Nexo 5.2 (FREE)

## Qué hace

Desactiva Multiplane Overlay (MPO), una función de la composición de Windows que en algunos equipos provoca parpadeos, pantallazos negros con Alt+Tab o tirones con overlays. Incluye la opción de revertir en el mismo archivo.

## Ajustes

| Ajuste | Automático u opcional | Efecto real |
|---|---|---|
| `OverlayTestMode = 5` en `HKLM\SOFTWARE\Microsoft\Windows\Dwm` | Automático (opción 1) | Corrige esos síntomas en muchos equipos. Sin síntomas no merece la pena: en juegos en ventana sin bordes puede añadir algo de latencia. En algunas versiones de Windows 11 24H2 puede no tener efecto. |
| Punto de restauración | Opcional | Uno cada 24 horas como máximo. |

Requiere reiniciar.

## Requisitos

- Windows 10 u 11. Ejecutar como administrador.

## Riesgos

- Latencia algo mayor en juegos en ventana sin bordes.

## Cómo revertir

Ejecuta `Nexo_MPO_Fix.bat` y elige la opción **2**. Restaura el valor que tenías antes del fix o, si no existía, lo elimina (lo que trae Windows).

## Copia de seguridad y logs

- Copia: `C:\ProgramData\ElNexo\Backup\MPO_Fix\backup.txt`.
- Log: `C:\ProgramData\ElNexo\Logs\MPO_Fix.log`.

## Compatibilidad

Windows 10 y 11.

## Versión y cambios

- **5.2**: interfaz común; se retira el bloque PRO (no había diferencias reales con otra versión).
- **5.1**: copia del valor previo; textos sin promesas («Impacto real: cero en juegos»).

## Código abierto y verificación

Código: https://github.com/DarioA-Dev/Scripts-El-Nexo (carpeta `source-code-web/MPO_Fix`).

```
Get-FileHash .\MPO_Fix.zip -Algorithm SHA256
```

Compara el resultado con `releases-dist-web/SHA256SUMS.txt` o con elnexocenter.com/nexos/performance.html.
