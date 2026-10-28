# Ratón Fix — El Nexo 5.2 (FREE)

## Qué hace

Quita la aceleración del puntero de Windows (lo mismo que desmarcar «Mejorar la precisión del puntero») y hace que los menús se abran al instante.

## Ajustes

| Ajuste | Automático u opcional | Efecto real |
|---|---|---|
| `MouseSpeed`, `MouseThreshold1` y `MouseThreshold2` a 0 | Automático | Movimiento 1:1 del ratón, sin aceleración. Es exactamente lo que hace la casilla del Panel de control. |
| `MenuShowDelay` a 0 | Automático | Los menús se abren sin esperar 400 ms. Es un cambio visual: no afecta al ratón en juegos. |
| Punto de restauración | Opcional | Uno cada 24 horas como máximo. |

Los cambios se aplican al cerrar sesión o reiniciar.

## Requisitos

- Windows 10 o 11. Ejecutar como administrador (por coherencia con el resto; los valores son de tu usuario).

## Riesgos

- Ninguno relevante. Si estabas acostumbrado a la aceleración, notarás el puntero más lento al mover rápido.

## Cómo revertir

Ejecuta `REVERT_Nexo_Raton_Fix.bat`. Restaura los cuatro valores que tenías.

## Copia de seguridad y logs

- Copia: `C:\ProgramData\ElNexo\Backup\Nexo_Raton_Fix\backup.txt`.
- Log: `C:\ProgramData\ElNexo\Logs\Nexo_Raton_Fix.log`.

## Compatibilidad

Windows 10 y 11.

## Versión y cambios

- **5.2**: interfaz común; se retira el bloque PRO, que afirmaba que la versión FREE no desactivaba la aceleración por completo (sí lo hace).
- **5.1**: copia de seguridad real; el punto de restauración ya no se da por creado si falla.

## Código abierto y verificación

Código: https://github.com/DarioA-Dev/Scripts-El-Nexo (carpeta `source-code-web/Nexo_Raton_Fix`).

```
Get-FileHash .\Nexo_Raton_Fix.zip -Algorithm SHA256
```

Compara el resultado con `releases-dist-web/SHA256SUMS.txt` o con elnexocenter.com/nexos/performance.html.
