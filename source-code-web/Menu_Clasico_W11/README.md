# Menú Clásico W11 — El Nexo 5.2

## Qué hace

Vuelve a mostrar el menú contextual completo de Windows (el del clic derecho), sin tener que pulsar «Mostrar más opciones».

## Ajustes

| Ajuste | Automático u opcional | Efecto real |
|---|---|---|
| Clave `HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32` vacía | Automático | Menú contextual clásico para tu usuario. Método conocido y estable. |
| Reiniciar el Explorador de Windows | Automático | Aplica el cambio al momento. Se cierran las ventanas del Explorador abiertas. |

## Requisitos

- Windows 11. **No necesita permisos de administrador** (solo cambia tu usuario).

## Riesgos

- Ninguno relevante. Una actualización de Windows podría dejar de respetar esta clave.

## Cómo revertir

Ejecuta `Revertir_Menu_W11.bat`. Borra la clave, salvo que ya existiera antes de usar El Nexo.

## Copia de seguridad y logs

- Copia: `C:\ProgramData\ElNexo\Backup\Menu_Clasico_W11\backup.txt` (si no se puede crear, el revert usa el valor de fábrica, que es borrar la clave).
- Log: `C:\ProgramData\ElNexo\Logs\Menu_Clasico_W11.log`.

## Compatibilidad

Windows 11 (21H2 en adelante).

## Versión y cambios

- **5.2**: interfaz común; ya no se autoeleva a administrador; el mensaje final indica el archivo de revert correcto.

## Código abierto y verificación

Código: https://github.com/DarioA-Dev/Scripts-El-Nexo (carpeta `source-code-web/Menu_Clasico_W11`).

```
Get-FileHash .\Menu_Clasico_W11.zip -Algorithm SHA256
```

Compara el resultado con `releases-dist-web/SHA256SUMS.txt`.
