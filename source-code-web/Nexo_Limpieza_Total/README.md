# Limpieza Total — El Nexo 5.2 (FREE)

## Qué hace

Borra archivos temporales y cachés que Windows vuelve a generar. No cambia ninguna configuración del sistema, por eso no necesita copia de seguridad.

## Ajustes

| Ajuste | Automático u opcional | Efecto real |
|---|---|---|
| Caché de descargas de Windows Update | Automático | Libera espacio. Windows vuelve a descargar lo que necesite. |
| Temporales del usuario y de Windows | Automático | Libera espacio. Los archivos en uso se conservan. |
| Accesos directos de «Archivos recientes» | Automático | Privacidad. Las listas de salto y sus elementos anclados se conservan. |
| Caché de iconos y miniaturas (reinicia el Explorador) | Automático | Corrige iconos o miniaturas corruptos. Se regenera sola. |
| Vaciar los registros de eventos | Opcional, por defecto NO | No mejora el rendimiento ni libera espacio relevante, y se pierde información para diagnosticar errores. |
| Vaciar la papelera de tu usuario | Opcional, por defecto NO | Libera espacio. Lo borrado no se recupera. |
| Punto de restauración | Opcional | Uno cada 24 horas como máximo. |

La carpeta Prefetch **no** se borra: Windows la usa para acelerar el arranque y se mantiene sola.

## Requisitos

- Windows 10 o 11. Ejecutar como administrador.

## Riesgos

- Lo borrado no se puede recuperar. No se tocan tus documentos, descargas ni escritorio.

## Cómo revertir

No hay ajustes que revertir. `REVERT_Nexo_Limpieza_Total.bat` solo explica qué se regenera solo y qué no.

## Copia de seguridad y logs

- Copia: no aplica (no cambia configuración).
- Log: `C:\ProgramData\ElNexo\Logs\Nexo_Limpieza_Total.log`.

## Compatibilidad

Windows 10 y 11.

## Versión y cambios

- **5.2**: interfaz común; el bloque PRO solo menciona la limpieza DISM, que sí está en la versión completa.
- **5.1**: ya no borra Prefetch ni las listas de salto; registros de eventos y papelera opcionales; la papelera solo es la de tu usuario.

## Código abierto y verificación

Código: https://github.com/DarioA-Dev/Scripts-El-Nexo (carpeta `source-code-web/Nexo_Limpieza_Total`).

```
Get-FileHash .\Nexo_Limpieza_Total.zip -Algorithm SHA256
```

Compara el resultado con `releases-dist-web/SHA256SUMS.txt` o con elnexocenter.com/nexos/performance.html.
