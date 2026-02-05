# El Nexo Center | Repositorio de Scripts de Alto Rendimiento

<p align="center">
  <img src="https://raw.githubusercontent.com/DarioA-Dev/Preparar-paginas-web/main/imagenes/top-readme.png" alt="Banner El Nexo" style="width: 100%; border-radius: 20px; box-shadow: 0 4px 12px rgba(0,0,0,0.3); border: 1px solid #000000;">
</p>

<div align="center">
  <img src="https://img.shields.io/badge/Status-Open_Source-0078D6?style=for-the-badge&logo=github&logoColor=white" style="border-radius: 12px;">
  <img src="https://img.shields.io/badge/Security-VirusTotal_Audited-25D366?style=for-the-badge&logo=virustotal&logoColor=white" style="border-radius: 12px;">
  <a href="https://discord.gg/7cUeyMC6NV">
    <img src="https://img.shields.io/badge/Community-Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white" style="border-radius: 12px;">
  </a>
</div>

---

## Protocolo de Transparencia e Integridad Técnica
La confianza en la optimización de sistemas se basa en la capacidad de auditoría. Este repositorio centraliza scripts de automatización diseñados bajo el estándar de **Sistemas y Redes** para garantizar la integridad del Kernel de Windows.

### Pilares de Confianza de El Nexo

<table style="border: none; border-collapse: collapse; width: 100%;">
  <tr>
    <td width="50%" style="border: none; padding: 10px;">
      <div style="background-color: #161b22; padding: 15px; border-radius: 20px; border: 1px solid #30363d; height: 180px;">
        <h4>Auditoría de Código Fuente</h4>
        <p style="font-size: 14px; color: #a0a0a0;">Despliegue exclusivo en archivos .bat legibles. Sin binarios opacos. Inspección línea por línea garantizada antes de la ejecución.</p>
      </div>
    </td>
    <td width="50%" style="border: none; padding: 10px;">
      <div style="background-color: #161b22; padding: 15px; border-radius: 20px; border: 1px solid #30363d; height: 180px;">
        <h4>Certificación de Seguridad</h4>
        <p style="font-size: 14px; color: #a0a0a0;">Escaneos recurrentes en motores de VirusTotal. Documentación de cambios en el registro para evitar detecciones por heurística.</p>
      </div>
    </td>
  </tr>
  <tr>
    <td width="50%" style="border: none; padding: 10px;">
      <div style="background-color: #161b22; padding: 15px; border-radius: 20px; border: 1px solid #30363d; height: 180px;">
        <h4>Protocolo de Reversión</h4>
        <p style="font-size: 14px; color: #a0a0a0;">Acceso a scripts de restauración en la carpeta backups-revert. Capacidad de retorno al estado original de Windows de forma inmediata.</p>
      </div>
    </td>
    <td width="50%" style="border: none; padding: 10px;">
      <div style="background-color: #161b22; padding: 15px; border-radius: 20px; border: 1px solid #30363d; height: 180px;">
        <h4>Soporte Comunitario</h4>
        <p style="font-size: 14px; color: #a0a0a0;">Canal directo con el Staff técnico en Discord para análisis de logs de rendimiento, latencia y telemetría de hardware.</p>
      </div>
    </td>
  </tr>
</table>

---

## Organización del Repositorio

| Carpeta | Función | Estándar |
| :--- | :--- | :--- |
| `core-scripts/` | Ejecutables directos para optimización rápida. | Producción |
| `source-code/` | Scripts con documentación técnica y archivos de reversión. | Auditoría |
| `backups-revert/` | Scripts exclusivos para la restauración de valores. | Seguridad |
| `releases-dist/` | Paquetes comprimidos para distribución y despliegue masivo. | Distribución |

---

## Análisis de Scripts: Ladrillo a Ladrillo

<details>
<summary style="font-size: 18px; font-weight: bold; cursor: pointer; padding: 10px; background: #161b22; border-radius: 10px; border-left: 5px solid #0078D6;"> 
  [01] Max_rendimiento_pc_El_Nexo.bat
</summary>
<div style="padding: 20px; background: #0d1117; border: 1px solid #30363d; border-radius: 0 0 10px 10px;">

### Descripción Técnica
Protocolo integral de optimización de Kernel, gestión de energía y reducción de latencia de hardware para equipos de sobremesa.

### Modificaciones del Kernel y Energía
* **Matriz de Energía (GUID):** Inyección del esquema "Ultimate Performance" oculto de Windows, configurado con un identificador estático para garantizar la estabilidad del perfil de energía.
* **Throttling de CPU:** Forzado de los estados mínimo y máximo del procesador al 100% para eliminar el tiempo de subida de frecuencias.
* **Parámetros BCD:** Desactivación de *Dynamic Tick* y *Hypervisor* para reducir la latencia de las interrupciones (DPC Latency) y liberar ciclos de reloj.

### Optimización de Hardware (MSI & GPU)
* **Message Signaled Interrupts (MSI):** Algoritmo recursivo que reasigna las interrupciones de los dispositivos PCI a modo MSI, priorizando el bus de datos y reduciendo el input lag.
* **Graphics Tweaks:** Activación de *HwSchMode* (HAGS) con prioridad alta y desactivación de ULPS para evitar micro-stuttering en arquitecturas AMD.

### Gestión de Sistema y Red
* **Win32PrioritySeparation:** Ajuste en el registro (valor 38 decimal) para otorgar prioridad absoluta a los procesos en primer plano (gaming).
* **Kernel en RAM:** Configuración de *DisablePagingExecutive* para mantener el núcleo del sistema operativo fuera del archivo de paginación.
* **Limpieza de Bloatware:** Neutralización de servicios de telemetría y diagnósticos de Windows (DiagTrack, WerSvc) para liberar hilos de CPU.

> [!IMPORTANT]
> Este script maximiza el consumo eléctrico. Se recomienda exclusivamente para PC de torre conectados permanentemente a la red eléctrica.

</div>
</details>



<details>
<summary style="font-size: 18px; font-weight: bold; cursor: pointer; padding: 10px; background: #161b22; border-radius: 10px; border-left: 5px solid #848482;"> 
  [02] Max_rendimiento_portatil_El_Nexo.bat
</summary>
<div style="padding: 20px; background: #0d1117; border: 1px solid #30363d; border-radius: 0 0 10px 10px;">

### Descripción Técnica
Ingeniería de rendimiento móvil centrada en el desbloqueo de frecuencias de CPU y la estabilización de señales inalámbricas.

### Gestión Energética y Térmica
* **Desbloqueo de Turbo Boost:** Inyección de atributos en el registro para hacer visible y forzar el *Processor Performance Boost Mode* en estado "Agresivo", permitiendo que el procesador mantenga frecuencias elevadas bajo carga.
* **Esquema Nexo Elite:** Creación de un plan de energía optimizado que evita la entrada en estados de ahorro profundo de los núcleos (Core Parking).

### Latencia y Movilidad
* **Sincronización MSI Dinámica:** Implementación vía PowerShell para reasignar dinámicamente las prioridades del hardware móvil, optimizando la respuesta de la GPU integrada/dedicada.
* **Híbrido Wi-Fi (Low Latency):** Desactivación selectiva del *NetAdapterPowerManagement* para evitar que los adaptadores de red inalámbricos entren en modo de bajo consumo, eliminando micro-cortes durante sesiones de juego.
* **Anti-Power Throttling:** Bloqueo de la capacidad de Windows para limitar los recursos de aplicaciones que no se encuentran en primer plano.

> [!CAUTION]
> El uso de este script aumentará las temperaturas de operación del portátil. Se recomienda utilizar una base refrigeradora y mantener el cargador conectado.

</div>
</details>
<details>
<summary style="font-size: 18px; font-weight: bold; cursor: pointer; padding: 10px; background: #161b22; border-radius: 10px; border-left: 5px solid #25D366;"> 
  [03] Optimizar_Internet_El_Nexo.bat
</summary>
<div style="padding: 20px; background: #0d1117; border: 1px solid #30363d; border-radius: 0 0 10px 10px;">

### Descripción Técnica
Protocolo de optimización de la pila TCP/IP y reconfiguración de parámetros de red a bajo nivel para minimizar la latencia (ping) y eliminar el estrangulamiento de datos.

### Ingeniería de Protocolo TCP/IP
* **Ajuste de Ventana Recibida (RWIN):** Optimización del *autotuninglevel* para estabilizar el flujo de datos y desactivación de heurísticas de red que causan variaciones en la velocidad.
* **Implementación CUBIC:** Migración del proveedor de congestión al algoritmo CUBIC, estándar en sistemas de alto rendimiento para mejorar la recuperación ante pérdida de paquetes.
* **Fast Open y RSS:** Activación de *TCP Fast Open* para acelerar el intercambio de datos inicial y *Receive Side Scaling* para distribuir la carga de red eficientemente entre los núcleos de la CPU.

### Eliminación de Estrangulamiento (Throttling)
* **NetworkThrottlingIndex:** Configuración del índice de red al máximo valor permitido (`0xFFFFFFFF`) para desactivar el mecanismo de Windows que limita el tráfico no multimedia cuando se ejecutan juegos.
* **SystemResponsiveness:** Ajuste de la reserva de recursos del sistema al 0% para garantizar que el tráfico de red tenga prioridad absoluta sobre las tareas de fondo de Windows.

### Latencia y Resolución DNS
* **Algoritmo de Nagle (TCP No Delay):** Desactivación del agrupamiento de paquetes mediante la inyección de *TcpAckFrequency* en el registro, logrando una confirmación instantánea de los paquetes enviados.
* **Modo MSI en Red:** Sincronización de los controladores de red mediante *Message Signaled Interrupts* para reducir el tiempo de respuesta del hardware ante paquetes entrantes.
* **Inyección DNS Turbo:** Opción de configuración de servidores DNS de Cloudflare (1.1.1.1) para acelerar la resolución de nombres y reducir el tiempo de carga de servidores.

> [!TIP]
> **Perfil de Uso:** Ideal para jugadores competitivos y entornos de streaming que requieren estabilidad de red absoluta. Incluye limpieza automática de caché DNS y reinicio de sockets.

</div>
</details>



<details>
<summary style="font-size: 18px; font-weight: bold; cursor: pointer; padding: 10px; background: #161b22; border-radius: 10px; border-left: 5px solid #FFD700;"> 
  [04] Limpieza_del_sistema_El_Nexo.bat
</summary>
<div style="padding: 20px; background: #0d1117; border: 1px solid #30363d; border-radius: 0 0 10px 10px;">

### Descripción Técnica
Sistema de depuración forense y mantenimiento preventivo diseñado para purgar archivos residuales, regenerar cachés de hardware y compactar el sistema operativo.

### Mantenimiento de Componentes Críticos
* **Purga de WinSxS:** Ejecución de limpieza avanzada del almacén de componentes mediante DISM para eliminar versiones obsoletas de archivos del sistema y compactar el tamaño del SO en disco.
* **Reseteo de Windows Update:** Detención de servicios críticos y purga del directorio `SoftwareDistribution` para solucionar errores de actualización y liberar espacio de archivos de descarga temporales.

### Depuración de Hardware y Software
* **Sincronización de Caché de GPU:** Eliminación selectiva de las cachés de sombreadores (Shader Cache) de NVIDIA, AMD y DirectX, forzando una reconstrucción limpia que soluciona problemas de estabilidad gráfica.
* **UWP Debloat:** Desinstalación automatizada de paquetes de aplicaciones preinstaladas (CandyCrush, BingNews, etc.) que consumen recursos en segundo plano y ocupan espacio innecesario.
* **Purga de Registros (EventLogs):** Limpieza forense de todos los historiales de eventos y errores de Windows, aliviando la carga de lectura/escritura del sistema de diagnóstico.

### Optimización de Interfaz y Temporales
* **Limpieza de Directorios Volátiles:** Purga recursiva de carpetas `Temp` y `Prefetch`, eliminando miles de archivos basura que ralentizan el acceso al disco.
* **Reconstrucción del Explorer:** Reinicio forzado de la caché de iconos y miniaturas para corregir errores visuales y acelerar la navegación por carpetas de Windows.

> [!IMPORTANT]
> **Aviso de Rendimiento:** El proceso de limpieza de componentes (WinSxS) es intensivo y puede tardar varios minutos. Se recomienda realizarlo una vez al mes para mantener la integridad del sistema.

</div>
</details>
<details>
<summary style="font-size: 18px; font-weight: bold; cursor: pointer; padding: 10px; background: #161b22; border-radius: 10px; border-left: 5px solid #5865F2;"> 
  [05] Detener_tareas_de_fondo_de_gaming_Servicios_de_Xbox_El_Nexo.bat
</summary>
<div style="padding: 20px; background: #0d1117; border: 1px solid #30363d; border-radius: 0 0 10px 10px;">

### Descripción Técnica
Protocolo de neutralización de procesos UWP y servicios de ecosistema Xbox para maximizar la disponibilidad de hilos de la CPU y reducir el jitter en juegos.

### Gestión de Privacidad y Apps (UWP)
* **AppPrivacy Hardening:** Inyección de directivas administrativas para denegar de forma forzada la ejecución de aplicaciones de la Microsoft Store en segundo plano (`LetAppsRunInBackground`).
* **BackgroundAccess Neutralization:** Bloqueo global de acceso a aplicaciones en segundo plano a nivel de usuario y sistema, eliminando el consumo fantasma de ciclos de reloj.

### Optimización de Multimedia y GameDVR
* **GameDVR & GameBar:** Desactivación de la monitorización y grabación pasiva de clips de juego. Esto libera recursos de la GPU y reduce el input lag provocado por el proceso *Broadcast User Service*.
* **Multimedia Class Scheduler:** Reconfiguración de las tareas de red y juegos para asignar una prioridad de GPU (`Priority 8`) y una categoría de programación `High`, garantizando que el juego sea el proceso dominante.

### Purga de Servicios y Telemetría
* **Xbox Ecosystem:** Detención y deshabilitación de servicios de autenticación, guardado en la nube y monitorización de red de Xbox (`XblAuthManager`, `XblGameSave`, `XboxNetApiSvc`).
* **Tareas Programadas:** Desactivación vía PowerShell de tareas de mantenimiento automático y recolectores de telemetría como el *Microsoft Compatibility Appraiser*, evitando picos de uso de CPU durante sesiones competitivas.

> [!TIP]
> **Recomendación:** Ejecutar este script antes de iniciar cualquier juego competitivo para asegurar que Windows no realice tareas de mantenimiento en segundo plano.

</div>
</details>



<details>
<summary style="font-size: 18px; font-weight: bold; cursor: pointer; padding: 10px; background: #161b22; border-radius: 10px; border-left: 5px solid #848482;"> 
  [06] Ahorro_de_bateria_portatil_El_Nexo.bat
</summary>
<div style="padding: 20px; background: #0d1117; border: 1px solid #30363d; border-radius: 0 0 10px 10px;">

### Descripción Técnica
Ingeniería de eficiencia energética diseñada para maximizar la autonomía de portátiles mediante el capado dinámico del silicio y la optimización de buses de hardware.

### Control de Voltaje y Frecuencia (CPU)
* **Inyección de Perfil "Nexo Eco":** Creación de un esquema energético basado en el economizador de Windows, pero con restricciones personalizadas en los estados de rendimiento.
* **Capado de Frecuencia (70%):** Limitación forzada del estado máximo del procesador al 70%, evitando que la CPU entre en frecuencias de alto consumo y reduciendo drásticamente la generación de calor.
* **Desactivación de Turbo Boost:** Bloqueo del *Processor Performance Boost Mode*, eliminando los saltos de voltaje innecesarios que agotan la batería rápidamente.

### Optimización de Buses y Visuales
* **ASPM (Active State Power Management):** Activación del ahorro de energía máximo en los buses PCI Express y suspensión selectiva de puertos USB.
* **Interfaz Simplificada:** Desactivación de transparencias de Windows y efectos visuales de la interfaz para reducir la carga de procesamiento de la GPU integrada.
* **Power Throttling:** Habilitación forzada de la tecnología de ahorro de energía en el Kernel para obligar a los procesos a utilizar exclusivamente los núcleos de eficiencia (E-Cores).

### Gestión de Reposo Crítico
* **Hibernación Forzada:** Configuración de tiempos de inactividad agresivos y activación de la hibernación (0W) sobre la suspensión tradicional, preservando la carga de la batería durante periodos de transporte.

> [!CAUTION]
> **Aviso de Rendimiento:** Este script ralentizará deliberadamente el sistema para extender la duración de la batería. No recomendado para tareas de carga pesada.

</div>
</details>



<details>
<summary style="font-size: 18px; font-weight: bold; cursor: pointer; padding: 10px; background: #161b22; border-radius: 10px; border-left: 5px solid #848482;"> 
  [06] Ahorro_de_bateria_portatil_El_Nexo.bat
</summary>
<div style="padding: 20px; background: #0d1117; border: 1px solid #30363d; border-radius: 0 0 10px 10px;">

### Descripción Técnica
Ingeniería de eficiencia energética diseñada para maximizar la autonomía de portátiles mediante el capado dinámico del silicio y la optimización de buses de hardware.

### Control de Voltaje y Frecuencia (CPU)
* **Inyección de Perfil Nexo-Eco:** Creación de un esquema energético basado en el economizador de Windows, pero con restricciones personalizadas en los estados de rendimiento del procesador.
* **Capado de Frecuencia (70%):** Limitación forzada del estado máximo del procesador al 70%, evitando que la CPU entre en frecuencias de alto consumo y reduciendo drásticamente la generación de calor.
* **Desactivación de Turbo Boost:** Bloqueo del *Processor Performance Boost Mode*, eliminando los picos de voltaje innecesarios que agotan la batería de forma prematura.

### Optimización de Buses y Visuales
* **ASPM (Active State Power Management):** Activación del ahorro de energía máximo en los buses PCI Express y suspensión selectiva de puertos USB inactivos.
* **Interfaz Simplificada:** Desactivación de transparencias de Windows y efectos visuales de la interfaz para reducir la carga de procesamiento de la GPU integrada (iGPU).
* **Power Throttling:** Habilitación forzada de la tecnología de ahorro de energía en el Kernel para obligar a los procesos a utilizar exclusivamente los núcleos de eficiencia.

### Gestión de Reposo Crítico
* **Hibernación Inteligente:** Configuración de tiempos de inactividad agresivos y priorización de la hibernación sobre la suspensión tradicional para preservar la carga durante el transporte del equipo.

> [!CAUTION]
> **Aviso de Rendimiento:** Este script ralentizará deliberadamente el sistema para extender la duración de la batería. No se recomienda para tareas de carga pesada como edición de video o gaming.

</div>
</details>
<details>
<summary style="font-size: 18px; font-weight: bold; cursor: pointer; padding: 10px; background: #161b22; border-radius: 10px; border-left: 5px solid #00BFFF;"> 
  [07] Nexo_SSD_Turbo.bat
</summary>
<div style="padding: 20px; background: #0d1117; border: 1px solid #30363d; border-radius: 0 0 10px 10px;">

### Descripción Técnica
Protocolo de optimización para unidades de estado sólido (NVMe/SSD) centrado en la reducción de ciclos de escritura innecesarios y la aceleración del acceso a datos.

### Optimización de Lectura y Escritura
* **Forzado de TRIM:** Activación de `DisableDeleteNotify 0` para asegurar que el controlador del SSD gestione eficientemente los bloques de datos liberados, manteniendo la velocidad de escritura constante.
* **Desactivación de Sellos de Tiempo:** Configuración de `disablelastaccess 1` para eliminar la actualización de metadatos de "último acceso" en cada archivo, liberando ancho de banda del bus de datos.
* **LargeSystemCache:** Inyección en el registro para priorizar el caché del sistema de archivos en la memoria RAM, acelerando la respuesta del explorador de archivos.

### Persistencia y Energía
* **Suspensión de Disco:** Desactivación de los tiempos de espera de apagado del disco (`disk-timeout 0`) para evitar latencias de reanudación (spin-up) durante el uso del sistema.

> [!IMPORTANT]
> **Seguridad:** Este script incluye un punto de restauración automático previo a la modificación de parámetros de comportamiento de archivos.

</div>
</details>



<details>
<summary style="font-size: 18px; font-weight: bold; cursor: pointer; padding: 10px; background: #161b22; border-radius: 10px; border-left: 5px solid #D100D1;"> 
  [08] Nexo_Audio_Pro.bat
</summary>
<div style="padding: 20px; background: #0d1117; border: 1px solid #30363d; border-radius: 0 0 10px 10px;">

### Descripción Técnica
Ajuste de la arquitectura multimedia de Windows para eliminar el *popping* de audio y garantizar que el procesamiento de sonido tenga prioridad sobre las tareas de fondo.

### Priorización de Tareas (MMCSS)
* **Scheduling Category:** Elevación del servicio de audio a categoría `High` para evitar que procesos de sistema interrumpan el flujo de sonido.
* **SFIO & GPU Priority:** Asignación de prioridad máxima en las operaciones de entrada/salida y ciclos de GPU para controladores de audio profesionales y gaming.

### Estabilidad de Buffer
* **Network Throttling Bypass:** Configuración del índice de estrangulamiento de red a `0xFFFFFFFF`, impidiendo que el tráfico de internet degrade la calidad del audio o aumente la latencia en interfaces de sonido.

> [!TIP]
> **Ideal para:** Usuarios de tarjetas de sonido dedicadas, interfaces USB y jugadores que dependen de un posicionamiento de audio preciso (FPS).

</div>
</details>



<details>
<summary style="font-size: 18px; font-weight: bold; cursor: pointer; padding: 10px; background: #161b22; border-radius: 10px; border-left: 5px solid #00FF00;"> 
  [09] Nexo_Net_Gaming.bat
</summary>
<div style="padding: 20px; background: #0d1117; border: 1px solid #30363d; border-radius: 0 0 10px 10px;">

### Descripción Técnica
Reconfiguración de la pila de red enfocada en la estabilidad del ping y la fluidez del tráfico LAN en entornos competitivos.

### Protocolos TCP/IP Avanzados
* **Receive Side Scaling (RSS):** Activación de la distribución de carga de red entre múltiples núcleos de la CPU, evitando cuellos de botella en un solo hilo.
* **TCP Timestamps:** Desactivación de sellos de tiempo para reducir el tamaño del encabezado de los paquetes y liberar recursos de procesamiento de red.
* **Compound TCP (CTCP):** Implementación del algoritmo de congestión de Microsoft para mejorar el rendimiento en redes de alta latencia o con pérdida de paquetes.

### Conectividad LAN
* **Detección de Redes:** Habilitación de reglas de Firewall para una comunicación fluida en red local, reduciendo el tiempo de descubrimiento de servidores y servicios compartidos.

</div>
</details>



<details>
<summary style="font-size: 18px; font-weight: bold; cursor: pointer; padding: 10px; background: #161b22; border-radius: 10px; border-left: 5px solid #FF0000;"> 
  [10] Nexo_Raton_Fix.bat
</summary>
<div style="padding: 20px; background: #0d1117; border: 1px solid #30363d; border-radius: 0 0 10px 10px;">

### Descripción Técnica
Protocolo de entrada de datos pura (Raw Input) diseñado para eliminar la aceleración por software y estabilizar el buffer de movimiento del ratón.

### Eliminación de Aceleración
* **MouseSpeed & Thresholds:** Neutralización completa de los parámetros de aceleración de Windows para lograr una relación de movimiento 1:1 entre el sensor y el cursor.
* **Raw Input Path:** Inyección de valores en el registro que fuerzan a Windows a ignorar los modificadores de precisión del panel de control.

### Gestión de Buffer
* **MouseDataQueueSize:** Ajuste de la cola de datos a `26` (decimal), un valor equilibrado para ratones con altas tasas de sondeo (1000Hz - 8000Hz), evitando la pérdida de paquetes de movimiento en juegos.

</div>
</details>



<details>
<summary style="font-size: 18px; font-weight: bold; cursor: pointer; padding: 10px; background: #161b22; border-radius: 10px; border-left: 5px solid #FFA500;"> 
  [11] Menu_Clasico_W11.bat
</summary>
<div style="padding: 20px; background: #0d1117; border: 1px solid #30363d; border-radius: 0 0 10px 10px;">

### Descripción Técnica
Parche de interfaz para restaurar el menú contextual clásico de Windows 10 en sistemas Windows 11, eliminando el paso extra de "Mostrar más opciones".

### Modificación de CLSID
* **InprocServer32 Injection:** Aplicación de un parche en el registro mediante la creación de la clave `{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}`, forzando al Explorador de Windows a cargar la interfaz de usuario clásica.
* **Explorer Restart:** Automatización del reinicio del proceso `explorer.exe` para aplicar los cambios de interfaz sin necesidad de cerrar sesión.

> [!NOTE]
> Este script es puramente estético y de usabilidad. No afecta al rendimiento del sistema, pero mejora el flujo de trabajo técnico.

</div>
</details>

---

## Contacto y Soporte Técnico
Para reportar fallos de compatibilidad o solicitar análisis de hardware, utiliza los canales oficiales:

* **Email:** dalvarezd7@gmail.com
* **Web:** [elnexocenter.com](https://elnexocenter.com)
* **Discord:** [Comunidad El Nexo](https://discord.gg/7cUeyMC6NV)

<p align="center">
  <img src="https://raw.githubusercontent.com/DarioA-Dev/Preparar-paginas-web/main/imagenes/nexo.png" alt="Footer El Nexo" style="width: 20%;">
  
  <em>Arquitecto y Desarrollador Jefe: <b>Dario Alvarez</b></em>
</p>
