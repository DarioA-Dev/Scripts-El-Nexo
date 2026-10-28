# Seguridad

## Versiones mantenidas

| Carpeta | Estado |
|---|---|
| `releases-dist-web/` (5.2) | Mantenida. Es la que enlaza elnexocenter.com. |
| `releases-dist/` y carpetas del 14 de marzo de 2026 | Histórico sin mantenimiento. No las uses. |

## Cómo informar de un problema

Si encuentras un fallo de seguridad o un script que hace algo distinto de lo que dice su README:

- Abre un *issue* en este repositorio **sin** incluir datos personales ni registros completos, o
- escribe por el formulario de contacto de elnexocenter.com si prefieres no hacerlo público.

Indica el script, la versión (aparece en la cabecera) y, si puedes, el log de `C:\ProgramData\ElNexo\Logs\<script>.log`.

## Qué hacen y qué no hacen los scripts

**Sí:**
- Cambian ajustes de Windows documentados en el README de cada script (registro, servicios, tareas, planes de energía, DNS).
- Guardan antes una copia en texto plano de los valores originales (`C:\ProgramData\ElNexo\Backup`).
- Escriben un log local (`C:\ProgramData\ElNexo\Logs`).

**No:**
- No descargan ni ejecutan nada de internet.
- No usan comandos codificados (`-EncodedCommand`, Base64), `Invoke-Expression` ni ventanas ocultas.
- No tocan Microsoft Defender, el firewall, Windows Update, la impresión, el audio ni los servicios de red.
- No envían datos. El Benchmark genera un fichero que tú subes a la web, y se analiza en tu navegador.
- No reinician el equipo sin preguntar.

Estas reglas las comprueba `tools/lint/lint.ps1` antes de cada publicación (patrones prohibidos, CRLF, ASCII, etiquetas y parseo de PowerShell).

## Verificar lo que descargas

```
Get-FileHash .\<NOMBRE>.zip -Algorithm SHA256
```

Compáralo con `releases-dist-web/SHA256SUMS.txt`. Los ZIP son reproducibles: `tools/build/build.ps1 -Zip` genera los mismos hashes a partir de `source-code-web/`.

Los PDF de cada ZIP se generan desde el README.md con Microsoft Edge y se comprueban con `tools/build/check_pdf.ps1`: sin JavaScript, sin acciones de apertura, sin ficheros embebidos ni enlaces.

## Firma de código

Los scripts **no están firmados digitalmente**. El Benchmark usa `-ExecutionPolicy Bypass` solo para su propio proceso, porque Windows bloquea por defecto los `.ps1` sin firmar. Verifica el SHA-256 antes de ejecutarlos.
