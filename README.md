# El Nexo — Scripts de optimización para Windows

Scripts `.bat` de código abierto que acompañan a [elnexocenter.com](https://elnexocenter.com). Son texto plano: puedes leer cada línea antes de ejecutarlos. Cada script guarda tus valores originales antes de cambiar nada y trae un REVERT que los restaura.

> **Aviso de seguridad.** Ejecuta solo ZIP descargados de este repositorio o de elnexocenter.com y comprueba su SHA-256 (ver más abajo). Lee el código antes de ejecutarlo como administrador. Más información en [SECURITY.md](SECURITY.md).

## Catálogo (versiones vigentes: `releases-dist-web/`)

| Script | Versión | Qué hace | Estado |
|---|---|---|---|
| [Max Power](source-code-web/Nexo_Max_Power/README.md) | 5.2 FREE | Plan de energía propio, telemetría desactivada, prioridad MMCSS de juegos | Mantenido |
| [Gaming Mode](source-code-web/Nexo_Gaming_Mode/README.md) | 5.2 FREE | Game Bar/DVR desactivado, telemetría, apps de fondo; servicios Xbox opcionales | Mantenido |
| [Net Optimizer](source-code-web/Nexo_Net_Optimizer/README.md) | 5.2 FREE | TCP/IP en valores recomendados, QoS, DNS opcional, Winsock opcional | Mantenido |
| [Audio Pro](source-code-web/Nexo_Audio_Pro/README.md) | 5.2 FREE | Prioridad MMCSS del audio y SystemResponsiveness | Mantenido |
| [Ratón Fix](source-code-web/Nexo_Raton_Fix/README.md) | 5.2 FREE | Sin aceleración del puntero; menús al instante | Mantenido |
| [SSD NVMe Turbo](source-code-web/Nexo_SSD_NVMe_Turbo/README.md) | 5.2 FREE | TRIM, último acceso NTFS, nombres 8.3, apagado de disco | Mantenido |
| [Limpieza Total](source-code-web/Nexo_Limpieza_Total/README.md) | 5.2 FREE | Temporales y cachés; registros de eventos y papelera opcionales | Mantenido |
| [Process Killer](source-code-web/Nexo_Process_Killer/README.md) | 5.2 FREE | Cierra launchers en la bandeja (nunca si hay un juego abierto) | Mantenido |
| [Ahorro Batería](source-code-web/Nexo_Ahorro_Bateria/README.md) | 5.2 FREE | Plan de energía para batería, efectos y apps de fondo | Mantenido |
| [Menú Clásico W11](source-code-web/Menu_Clasico_W11/README.md) | 5.2 | Menú contextual completo de Windows 11 (sin administrador) | Mantenido |
| [MPO Fix](source-code-web/MPO_Fix/README.md) | 5.2 FREE | Desactiva Multiplane Overlay; revert incluido | Mantenido |
| [Benchmark](source-code-web/Nexo_Benchmark/README.md) | 5.2 (informe v18) | Lee el hardware y genera un informe para la web (solo lectura) | Mantenido |

Descarga directa: `https://github.com/DarioA-Dev/Scripts-El-Nexo/raw/main/releases-dist-web/<NOMBRE>.zip`

## Estructura

| Carpeta | Contenido |
|---|---|
| `releases-dist-web/` | **ZIP vigentes** que enlaza la web, y `SHA256SUMS.txt`. |
| `source-code-web/` | Contenido exacto de cada ZIP (`.bat`, `.ps1`, PDF) más su `README.md`, fuente del PDF. |
| `src/` | Cuerpo de cada script, sin los bloques comunes. |
| `tools/build/` | Bloques comunes (interfaz, copia de seguridad, restauración), compilación, PDF y verificación de PDF. |
| `tools/lint/` | Análisis estático de los scripts (no ejecuta nada). |
| `docs/` | Guía de estilo de consola. |
| `releases-dist/`, `source-code/`, `core-scripts/`, `backups-revert/` | **Versiones anteriores (14 de marzo de 2026), sin cambios.** Se conservan como histórico; no se mantienen ni se enlazan desde la web. |

## Cómo verificar un ZIP

En PowerShell, en la carpeta donde lo descargaste:

```
Get-FileHash .\Nexo_Max_Power.zip -Algorithm SHA256
```

El resultado debe coincidir con la línea correspondiente de [`releases-dist-web/SHA256SUMS.txt`](releases-dist-web/SHA256SUMS.txt) (también publicada en elnexocenter.com/nexos/performance.html).

## Copias de seguridad y logs

- Copia de tus valores originales: `C:\ProgramData\ElNexo\Backup\<script>\backup.txt`
- Log de cada ejecución: `C:\ProgramData\ElNexo\Logs\<script>.log`

## Compilar (mantenedores)

```
.\tools\build\build.ps1 -Assemble     # src + bloques comunes -> source-code-web
.\tools\lint\lint.ps1 -Dir source-code-web
.\tools\build\md2pdf.ps1              # README.md -> PDF (Microsoft Edge headless)
.\tools\build\check_pdf.ps1
.\tools\build\build.ps1 -Zip          # ZIP reproducibles + SHA256SUMS.txt
```

Ninguno de estos pasos ejecuta los scripts de optimización.

## Más

- [CHANGELOG.md](CHANGELOG.md)
- [SECURITY.md](SECURITY.md)
- [docs/ESTILO_CONSOLA.md](docs/ESTILO_CONSOLA.md)
- Comunidad: [Discord](https://discord.gg/7cUeyMC6NV)
