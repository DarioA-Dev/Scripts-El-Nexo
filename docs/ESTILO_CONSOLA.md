# Guía de estilo de consola — El Nexo 5.2

Todos los scripts (`.bat`) y sus REVERT siguen esta guía. La interfaz vive en un único bloque, `tools/build/ui_block.cmd.txt`, que `tools/build/build.ps1 -Assemble` copia literalmente al final de cada `.bat`. Así cada ZIP es autosuficiente y todos se ven igual. No se edita el bloque dentro de un `.bat` concreto: se edita la plantilla y se vuelve a montar.

## Reglas de formato

- Solo ASCII y finales de línea CRLF. Sin tildes ni caracteres de caja Unicode; los bordes se dibujan con `-`, `=`, `+` y `|`.
- Ancho máximo de 78 columnas en todo lo que ve el usuario (lo comprueba `tools/lint/lint.ps1`).
- Nada de `%`, `!`, `&`, `|`, `<` ni `>` dentro de los mensajes que se pasan a las funciones de interfaz.

## Colores

| Uso | Secuencia ANSI | Sin ANSI |
|---|---|---|
| Acento (titulares, `[PASO n/m]`, `[?]`) | `ESC[96m` (cian claro) | `color 0B` en toda la consola |
| `[OK]` | `ESC[92m` (verde) | texto plano |
| `[!]` | `ESC[93m` (amarillo) | texto plano |
| `[ERROR]` | `ESC[91m` (rojo) | texto plano |

- Los colores ANSI solo se activan en Windows 10 1511 (build 10586) o posterior y con la consola moderna (si `HKCU\Console\ForceV2 = 0`, consola heredada, se usa texto plano).
- El carácter ESC se obtiene con `prompt $E` en un `cmd` hijo. No se usa PowerShell para pintar.
- Con la variable de entorno `NO_COLOR` o `NEXO_NO_COLOR` definida, se usa texto plano. Recomendado si otro programa (por ejemplo, Nexo Optimizer) lee la salida.

## Estructura de pantalla

1. **Cabecera** (`UI_HEADER`): banner ASCII, nombre, versión, plan y la línea `Codigo abierto: github.com/DarioA-Dev/Scripts-El-Nexo`.
2. **Comprobación de administrador** (`UI_REQUIRE_ADMIN`): mensaje idéntico en todos. Menú Clásico no la necesita.
3. **Resumen previo** (`UI_PLAN_BEGIN`, `UI_AUTO`, `UI_OPT`, `UI_PLAN_END`): qué se cambiará automáticamente (`[AUTO]`) y qué es opcional (`[OPCIONAL]`), con la ruta de la copia de seguridad.
4. **Preguntas** (`UI_ASK`): siempre `[?] Pregunta [S/N, por defecto N]:`. Cualquier respuesta que no sea `S` cuenta como `N`.
5. **Confirmación** (`UI_CONFIRM`): si no se confirma, `[!] Cancelado. No se ha cambiado nada.`
6. **Pasos** (`UI_STEP`): ` [PASO n/m] Texto`, seguido de líneas ` [OK]`, ` [!]` o ` [ERROR]`.
7. **Pantalla final** (`UI_FINAL`): título (`... - COMPLETADO` o `REVERT COMPLETADO`; se añade `CON ERRORES` si algo falló), contadores *Aplicados / Omitidos / Fallidos*, ruta del log, ruta de la copia de seguridad, nombre del REVERT y si hace falta reiniciar.
8. **Bloque PRO** (`UI_PRO_BEGIN`, `UI_PRO`, `UI_PRO_END`): solo diferencias reales con la versión completa, sin promesas de rendimiento.
9. **Reinicio** (`UI_REBOOT`): siempre preguntado; nunca se reinicia sin confirmación.

## Tokens estables (no cambiar)

Nexo Optimizer u otras herramientas pueden leer la salida. Estos tokens no cambian de forma:
`[PASO n/m]`, `[OK]`, `[!]`, `[ERROR]`, `COMPLETADO`, `REVERT COMPLETADO`, `[AUTO]`, `[OPCIONAL]`, `[?]`, y las claves de `resultado_nexo.txt` (`VERSION`, `FUENTE_DATO`, `CPU`, `GPU`, `RAM`, `SISTEMA`, `DISCO`, `DISCO_GB`, `DISCO_TIPO`, `APPS_INICIO`).

## Log y copia de seguridad

- Log de cada ejecución: `%ProgramData%\ElNexo\Logs\<script>.log` (texto plano, sin colores).
- Copia de seguridad: `%ProgramData%\ElNexo\Backup\<script>\backup.txt`. Tras revertir se renombra a `backup.restaurado.txt`.

## Benchmark (PowerShell)

`Nexo_Benchmark.ps1` usa los mismos tokens (`[PASO n/6]`, `[OK]`, `[!]`, `[ERROR]`) y los mismos colores mediante `Write-Host -ForegroundColor`, y también respeta `NO_COLOR` y `NEXO_NO_COLOR`.
