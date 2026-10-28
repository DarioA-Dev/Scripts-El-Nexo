# Net Optimizer — El Nexo 5.2 (FREE)

## Qué hace

Deja la pila TCP/IP en los valores recomendados por Windows, quita el límite de ancho de banda reservable por QoS, vacía la caché DNS y, si lo eliges, cambia el DNS o restablece Winsock.

## Ajustes

| Ajuste | Automático u opcional | Efecto real |
|---|---|---|
| Autotuning normal, RSS activado, timestamps desactivados | Automático | Son los valores de fábrica: solo cambia algo si alguien los había alterado. |
| Límite QoS reservable a 0 (`NonBestEffortLimit`) | Automático | No aumenta tu velocidad: Windows solo reserva ancho de banda para apps que piden QoS y lo libera si nadie lo usa. |
| Vaciar la caché DNS | Automático | Inocuo; Windows la rellena sola. |
| DNS Cloudflare (1.1.1.1) o Google (8.8.8.8) en «Ethernet» y «Wi‑Fi» | Opcional | Puede acelerar la resolución de nombres. No cambia el ping dentro de una partida. |
| Restablecer Winsock | Opcional, por defecto NO | Es una reparación para fallos de conexión. Exige reiniciar y puede desconfigurar algunas VPN o filtros de red. |
| Punto de restauración | Opcional | Uno cada 24 horas como máximo. |

## Requisitos

- Windows 10 o 11. Ejecutar como administrador.

## Riesgos

- Si usas un DNS propio (Pi‑hole, empresa), elige «Mantener». Si lo cambias, el REVERT lo devuelve tal como estaba.
- El reset de Winsock no se puede deshacer.

## Cómo revertir

Ejecuta `REVERT_Nexo_Net_Optimizer.bat` como administrador. Restaura TCP/IP, QoS y los DNS que tenías (estáticos o automáticos).

## Copia de seguridad y logs

- Copia: `C:\ProgramData\ElNexo\Backup\Nexo_Net_Optimizer\backup.txt`.
- Log: `C:\ProgramData\ElNexo\Logs\Nexo_Net_Optimizer.log`.

## Compatibilidad

Windows 10 y 11. El DNS solo se cambia en adaptadores llamados exactamente «Ethernet» y «Wi‑Fi».

## Versión y cambios

- **5.2**: interfaz común; textos honestos sobre QoS; se retira del bloque PRO la promesa sobre Nagle y CTCP.
- **5.1**: copia de DNS y TCP; Winsock opcional.

## Código abierto y verificación

Código: https://github.com/DarioA-Dev/Scripts-El-Nexo (carpeta `source-code-web/Nexo_Net_Optimizer`).

```
Get-FileHash .\Nexo_Net_Optimizer.zip -Algorithm SHA256
```

Compara el resultado con `releases-dist-web/SHA256SUMS.txt` o con elnexocenter.com/nexos/performance.html.
