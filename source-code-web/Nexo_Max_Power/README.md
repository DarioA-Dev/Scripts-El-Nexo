# Max Power — El Nexo 5.2 (FREE)

## Qué hace

Crea y activa un plan de energía propio para que la CPU no baje de frecuencia mientras juegas, desactiva la telemetría de Windows y sube la prioridad de la tarea «Games» del programador multimedia (MMCSS). Detecta si el equipo es un portátil y, en ese caso, no toca la hibernación.

## Ajustes

| Ajuste | Automático u opcional | Efecto real |
|---|---|---|
| Plan «Máximo/Alto Rendimiento El Nexo» (copia de Alto rendimiento o, si no existe, de Equilibrado) | Automático | CPU al 100 % mínimo y máximo, sin suspensión ni apagado de disco con corriente. Más consumo y temperatura; mejora pequeña en equipos modernos. |
| Hibernación e Inicio rápido desactivados (solo sobremesa) | Automático | Libera `hiberfil.sys`. El arranque en frío puede tardar algo más. |
| Servicios DiagTrack, WerSvc y RetailDemo desactivados | Automático | Privacidad: deja de enviar telemetría e informes de error. Efecto en rendimiento despreciable. |
| Servicio dmwappushservice desactivado | Opcional | Rompe la inscripción en MDM/Intune (equipos de empresa). |
| MMCSS «Games»: Priority 6, Scheduling Category High | Automático | Solo afecta a juegos que se registran en MMCSS (pocos). Efecto pequeño. |
| Punto de restauración | Opcional | Windows solo crea uno cada 24 horas y requiere Protección del sistema activa. |

## Requisitos

- Windows 10 o 11. Ejecutar como administrador.

## Riesgos

- Más consumo eléctrico y calor con el plan El Nexo.
- Sin hibernación no hay Inicio rápido.
- Desactivar dmwappushservice puede impedir gestionar el equipo desde la empresa.

## Cómo revertir

Ejecuta `REVERT_Nexo_Max_Power.bat` como administrador. Restaura **solo** lo anterior: el plan que tenías activo, la hibernación, los servicios y la prioridad MMCSS. Si no hay copia de seguridad, usa los valores de fábrica de Windows solo en esos ajustes.

## Copia de seguridad y logs

- Copia: `C:\ProgramData\ElNexo\Backup\Nexo_Max_Power\backup.txt` (texto plano, se guarda antes de cambiar nada).
- Log: `C:\ProgramData\ElNexo\Logs\Nexo_Max_Power.log`.

## Compatibilidad

Windows 10 1607 o posterior y Windows 11 (incluido 24H2, sin WMIC). En equipos con Modern Standby el plan se basa en Equilibrado.

## Versión y cambios

- **5.2**: interfaz común, resumen previo y confirmación; dmwappushservice pasa a opcional; textos PRO solo con diferencias reales.
- **5.1**: copia de seguridad real; `sc config start= disabled` corregido (antes fallaba); detección de portátil sin WMIC; ya no apaga el monitor; PcaSvc y DPS ya no se desactivan.

## Código abierto y verificación

Código: https://github.com/DarioA-Dev/Scripts-El-Nexo (carpeta `source-code-web/Nexo_Max_Power`). Los `.bat` son texto plano: ábrelos con el Bloc de notas antes de ejecutarlos.

Para comprobar que el ZIP no se ha alterado, en PowerShell:

```
Get-FileHash .\Nexo_Max_Power.zip -Algorithm SHA256
```

y compara el resultado con `releases-dist-web/SHA256SUMS.txt` del repositorio o con la lista de elnexocenter.com/nexos/performance.html.
