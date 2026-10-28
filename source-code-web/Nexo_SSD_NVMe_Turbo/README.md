# SSD NVMe Turbo — El Nexo 5.2 (FREE)

## Qué hace

Asegura que TRIM está activo, reduce escrituras innecesarias de NTFS y evita que el plan de energía apague el disco.

## Ajustes

| Ajuste | Automático u opcional | Efecto real |
|---|---|---|
| TRIM activo (`DisableDeleteNotify 0`) | Automático | Ya viene activo en Windows: es una salvaguarda. |
| No actualizar la fecha de último acceso (`disablelastaccess 1`) | Automático | Algunas escrituras menos. Desde Windows 10 1803 el sistema ya lo gestiona solo en discos grandes. |
| No crear nombres cortos 8.3 (`disable8dot3 1`) | Automático | Mejora pequeña en carpetas con muchísimos archivos. Puede afectar a instaladores muy antiguos. |
| Disco sin apagado automático en el plan activo | Automático | Solo afecta a discos duros; los NVMe gestionan su energía por su cuenta. En portátiles, algo más de consumo. |
| Punto de restauración | Opcional | Uno cada 24 horas como máximo. |

## Requisitos

- Windows 10 o 11. Ejecutar como administrador.

## Riesgos

- Programas muy antiguos que dependan de nombres 8.3 pueden fallar al instalarse.

## Cómo revertir

Ejecuta `REVERT_Nexo_SSD_NVMe_Turbo.bat` como administrador. Restaura los valores que tenías (no los fuerza a 0 como hacía la versión 5.0).

## Copia de seguridad y logs

- Copia: `C:\ProgramData\ElNexo\Backup\Nexo_SSD_NVMe_Turbo\backup.txt`.
- Log: `C:\ProgramData\ElNexo\Logs\Nexo_SSD_NVMe_Turbo.log`.

## Compatibilidad

Windows 10 y 11, con SSD SATA, NVMe o disco duro.

## Versión y cambios

- **5.2**: interfaz común; el bloque PRO ya no promete «+80 % IOPS» ni incluye ajustes que Windows ignora (IoPageLockLimit) o que ya son el valor de fábrica (LargeSystemCache 0).
- **5.1**: copia de seguridad real; REVERT corregido para último acceso y 8.3.

## Código abierto y verificación

Código: https://github.com/DarioA-Dev/Scripts-El-Nexo (carpeta `source-code-web/Nexo_SSD_NVMe_Turbo`).

```
Get-FileHash .\Nexo_SSD_NVMe_Turbo.zip -Algorithm SHA256
```

Compara el resultado con `releases-dist-web/SHA256SUMS.txt` o con elnexocenter.com/nexos/performance.html.
