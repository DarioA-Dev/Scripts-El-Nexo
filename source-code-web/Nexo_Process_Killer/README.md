# Process Killer — El Nexo 5.2 (FREE, Nivel 1)

## Qué hace

Cierra los launchers de juegos que están solo en la bandeja del sistema (Steam, Epic Games, EA app, Ubisoft Connect, Battle.net, Origin) y Widgets o Game Bar si están en segundo plano. Si un launcher tiene un juego u otra ventana abierta, **no** se cierra.

## Ajustes

| Ajuste | Automático u opcional | Efecto real |
|---|---|---|
| Cerrar launchers sin ventana (y sus procesos auxiliares) | Automático | Libera la RAM que ocupaban (se muestra una estimación antes de confirmar). |
| Cerrar Widgets y Game Bar en segundo plano | Automático | Libera algo de RAM. |

No cambia ningún ajuste de Windows: los programas vuelven al abrirlos o al reiniciar.

## Requisitos

- Windows 10 o 11. Ejecutar como administrador.

## Riesgos

- Si tenías una descarga en curso en un launcher, se interrumpe.

## Cómo revertir

No hay ajustes que revertir. `REVERT_Nexo_Process_Killer.bat` solo lo explica.

## Copia de seguridad y logs

- Copia: no aplica (no cambia configuración).
- Log: `C:\ProgramData\ElNexo\Logs\Nexo_Process_Killer.log`.

## Compatibilidad

Windows 10 y 11.

## Versión y cambios

- **5.2**: interfaz común; lista de procesos cerrados y omitidos; sin ficheros temporales.
- **5.1**: ya no cierra un launcher si tiene un juego abierto (antes podía cerrar la partida); Battle.net detectado correctamente; estimación de RAM corregida.

## Código abierto y verificación

Código: https://github.com/DarioA-Dev/Scripts-El-Nexo (carpeta `source-code-web/Nexo_Process_Killer`).

```
Get-FileHash .\Nexo_Process_Killer.zip -Algorithm SHA256
```

Compara el resultado con `releases-dist-web/SHA256SUMS.txt` o con elnexocenter.com/nexos/performance.html.
