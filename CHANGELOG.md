# Changelog

Versiones de los scripts publicados en `releases-dist-web/` (los que enlaza elnexocenter.com).

## 5.2 — 2026-10-28

**Interfaz**
- Interfaz común en los 12 scripts y sus REVERT: cabecera, resumen previo con cambios automáticos y opcionales, confirmación, `[PASO n/m]`, pantalla final con aplicados / omitidos / fallidos, log, copia de seguridad, REVERT y reinicio. Guía: `docs/ESTILO_CONSOLA.md`.
- Colores ANSI con degradación a texto plano; `NO_COLOR` o `NEXO_NO_COLOR` los desactivan.
- Log de cada ejecución en `C:\ProgramData\ElNexo\Logs`.
- Ningún script reinicia sin preguntar; ninguno se autoeleva con PowerShell.

**Cambios funcionales**
- Audio Pro: ya no toca `NetworkThrottlingIndex`.
- Max Power y Gaming Mode: `dmwappushservice` pasa a opcional (por defecto no). Automáticos solo DiagTrack, WerSvc y RetailDemo.
- Process Killer: lista los procesos cerrados y omitidos; ya no usa ficheros temporales.
- Benchmark: progreso `[PASO n/6]`; mismo formato de informe (`VERSION=18`).

**Textos**
- Bloques PRO solo con diferencias reales frente a la versión completa. Eliminados: «GPU Priority 8» (ya es el valor de Windows), «Turbo Boost desactivado en batería» (la FREE ya lo hace), Nagle/CTCP, «+80 % IOPS», IoPageLockLimit, LargeSystemCache, el bloque PRO de Ratón Fix y el de MPO Fix.
- Net Optimizer: «QoS al 0 % (ancho de banda completo)» sustituido por una explicación honesta.

**Documentación y distribución**
- README.md por script (fuente única) y PDF regenerados desde él, sin JavaScript ni adjuntos.
- `SHA256SUMS.txt` y ZIP reproducibles (`tools/build/build.ps1`).
- README, SECURITY y CHANGELOG del repositorio reescritos.

## 5.1 — 2026-10-28 (rama `hardening/scripts-v2`, no publicada por separado)

- Copia de seguridad real de cada ajuste en `C:\ProgramData\ElNexo\Backup` antes de cambiarlo.
- Cada REVERT restaura solo lo que cambia su script (antes restauraba también ajustes de la versión completa).
- `sc config ... start= valor` corregido: antes faltaba el espacio y el cambio no se aplicaba nunca.
- Max Power: detección de portátil sin WMIC; plan alternativo con Modern Standby; ya no apaga el monitor; PcaSvc y DPS ya no se desactivan.
- Gaming Mode: servicios Xbox opcionales.
- Net Optimizer: copia de DNS y TCP; Winsock opcional.
- Limpieza Total: ya no borra Prefetch ni listas de salto; registros de eventos y papelera opcionales.
- Process Killer: no cierra un launcher con un juego abierto; Battle.net detectado.
- Ahorro Batería: el revert ya no ejecuta `powercfg -restoredefaultschemes`.
- Benchmark: `.ps1` visible en el ZIP; informe en `C:\ProgramData\ElNexo\Benchmark`.

## 5.0 — 2026-04-03

- Versiones FREE publicadas en la web (cabecera `[PLAN: FREE]`).

## 14 de marzo de 2026

- Versiones completas en `releases-dist/`, `source-code/`, `core-scripts/` y `backups-revert/`. Se conservan sin cambios como histórico.
