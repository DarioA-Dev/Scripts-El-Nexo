# Benchmark — El Nexo 5.2 (solo lectura)

## Qué hace

Lee los datos básicos de tu equipo y genera un informe de texto para subirlo a elnexocenter.com/nexos/benchmark.html, donde se analiza en tu navegador. No cambia nada en tu PC.

## Ajustes

| Ajuste | Automático u opcional | Efecto real |
|---|---|---|
| Leer CPU, GPU, RAM, sistema, disco y número de apps de inicio | Automático | Solo lectura (CIM/WMI). |
| Guardar `resultado_nexo.txt` y `GUIA_MEJORAR_RENDIMIENTO.txt` en `C:\ProgramData\ElNexo\Benchmark` | Automático | Dos ficheros de texto. Nada se envía a internet. |
| Abrir la página del benchmark y la carpeta del informe | Automático | Usa tu navegador predeterminado. |

## Requisitos

- Windows 10 u 11 con PowerShell 5.1 (incluido en Windows). Ejecutar como administrador.
- Descomprime el ZIP completo: `Nexo_Benchmark.bat` lanza `Nexo_Benchmark.ps1`, que va en el mismo ZIP en texto plano.

## Riesgos

- Ninguno: no modifica el sistema. El `.bat` usa `-ExecutionPolicy Bypass` solo para ese proceso, porque Windows bloquea por defecto los `.ps1` sin firmar.

## Cómo revertir

No hay nada que revertir. Puedes borrar la carpeta `C:\ProgramData\ElNexo\Benchmark`.

## Copia de seguridad y logs

- Copia: no aplica.
- Log: `C:\ProgramData\ElNexo\Logs\Nexo_Benchmark.log`.

## Compatibilidad

Windows 10 y 11. El formato del informe (`VERSION=18`) no cambia.

## Versión y cambios

- **5.2**: interfaz común; progreso con `[PASO n/6]`.
- **5.1**: el `.ps1` va visible en el ZIP (antes se generaba en `%TEMP%` y se ejecutaba); el informe se guarda en `C:\ProgramData\ElNexo\Benchmark` en lugar del Escritorio.

## Código abierto y verificación

Código: https://github.com/DarioA-Dev/Scripts-El-Nexo (carpeta `source-code-web/Nexo_Benchmark`).

```
Get-FileHash .\Nexo_Benchmark.zip -Algorithm SHA256
```

Compara el resultado con `releases-dist-web/SHA256SUMS.txt`.
