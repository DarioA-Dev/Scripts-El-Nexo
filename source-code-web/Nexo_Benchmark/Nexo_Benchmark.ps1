# =========================================================================
#  EL NEXO BENCHMARK  v5.2 (informe VERSION=18) - script de solo lectura
#  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
#
#  Que hace:
#   - Lee CPU, GPU, RAM, sistema, disco y numero de apps de inicio (CIM).
#   - Escribe dos ficheros de texto en %ProgramData%\ElNexo\Benchmark:
#       resultado_nexo.txt           (se sube a elnexocenter.com/nexos/benchmark.html)
#       GUIA_MEJORAR_RENDIMIENTO.txt (consejos segun tu equipo)
#   - Abre la pagina del benchmark y la carpeta del informe.
#
#  Que NO hace:
#   - No cambia ninguna configuracion de Windows.
#   - No envia nada a internet: el informe lo subes tu y se analiza en tu
#     navegador.
#   - No escribe nada fuera de %ProgramData%\ElNexo.
#
#  Estilo de consola: docs/ESTILO_CONSOLA.md (mismos tokens que los .bat).
# =========================================================================
$ErrorActionPreference = 'Stop'
$useColor = -not ($env:NO_COLOR -or $env:NEXO_NO_COLOR)

function Say([string]$tag, [string]$msg) {
    $colors = @{ 'OK' = 'Green'; '!' = 'Yellow'; 'ERROR' = 'Red'; 'PASO' = 'Cyan' }
    $label = if ($tag -like 'PASO*') { "[$tag]" } else { "[$tag]" }
    $key = if ($tag -like 'PASO*') { 'PASO' } else { $tag }
    if ($useColor -and $colors.ContainsKey($key)) {
        Write-Host (' ' + $label) -ForegroundColor $colors[$key] -NoNewline
        Write-Host (' ' + $msg)
    } else {
        Write-Host (' ' + $label + ' ' + $msg)
    }
}

try {
    Write-Host ''
    Say 'PASO 1/6' 'Leyendo CPU...'
    $cpu = (Get-CimInstance Win32_Processor | Select-Object -First 1).Name

    Say 'PASO 2/6' 'Leyendo GPU...'
    $gpu = (Get-CimInstance Win32_VideoController | Where-Object { $_.Name -notlike '*Basic*' } | Select-Object -First 1).Name
    if (-not $gpu) { $gpu = (Get-CimInstance Win32_VideoController | Select-Object -First 1).Name }

    Say 'PASO 3/6' 'Leyendo RAM y sistema...'
    $ramGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 1)
    $winVer = (Get-CimInstance Win32_OperatingSystem).Caption

    Say 'PASO 4/6' 'Leyendo almacenamiento...'
    $disk = Get-CimInstance Win32_DiskDrive | Select-Object -First 1
    $diskModel = $disk.Model
    $diskGB = [math]::Round($disk.Size / 1GB, 0)
    $diskType = $null
    try {
        $phys = Get-PhysicalDisk -ErrorAction Stop | Where-Object { $_.DeviceId -eq [string]$disk.Index } | Select-Object -First 1
        if (-not $phys) { $phys = Get-PhysicalDisk -ErrorAction Stop | Select-Object -First 1 }
        $diskType = [string]$phys.MediaType
    } catch { $diskType = $null }
    if (-not $diskType -or $diskType -eq 'Unspecified') { $diskType = 'SSD/NVMe' }

    Say 'PASO 5/6' 'Leyendo apps de inicio...'
    $startupApps = @(Get-CimInstance Win32_StartupCommand | Select-Object Name, Command, Location)
    $startupReg = Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -ErrorAction SilentlyContinue
    $startupCount = $startupApps.Count
    if ($startupReg) { $startupCount += @($startupReg.PSObject.Properties | Where-Object { $_.Name -notlike 'PS*' }).Count }

    Say 'PASO 6/6' 'Guardando el informe...'
    $nl = [Environment]::NewLine
    $outFolder = Join-Path $env:ProgramData 'ElNexo\Benchmark'
    New-Item -ItemType Directory -Force -Path $outFolder | Out-Null
    $outFile  = Join-Path $outFolder 'resultado_nexo.txt'
    $guiaFile = Join-Path $outFolder 'GUIA_MEJORAR_RENDIMIENTO.txt'

    # Formato que lee js/benchmark.js en la web: CLAVE=valor (no cambiar claves)
    $content  = '=== EL NEXO CENTER - BENCHMARK REPORT ===' + $nl
    $content += '-----------------------------------------' + $nl
    $content += 'VERSION=18' + $nl
    $content += 'FUENTE_DATO=WMI_HW_SCAN' + $nl
    $content += '-----------------------------------------' + $nl
    $content += 'CPU='          + $cpu          + $nl
    $content += 'GPU='          + $gpu          + $nl
    $content += 'RAM='          + $ramGB        + ' GB' + $nl
    $content += 'SISTEMA='      + $winVer       + $nl
    $content += 'DISCO='        + $diskModel    + $nl
    $content += 'DISCO_GB='     + $diskGB       + ' GB' + $nl
    $content += 'DISCO_TIPO='   + $diskType     + $nl
    $content += 'APPS_INICIO='  + $startupCount + $nl
    $content += '-----------------------------------------' + $nl
    $content += 'SUBE ESTE ARCHIVO A: elnexocenter.com'
    Set-Content -Path $outFile -Value $content -Encoding UTF8

    $guia  = '================================================================' + $nl
    $guia += '  GUIA: COMO MEJORAR EL RENDIMIENTO DE TU PC' + $nl
    $guia += '  El Nexo Center - Optimizacion de Hardware y Software' + $nl
    $guia += '================================================================' + $nl + $nl
    $guia += 'TU EQUIPO DETECTADO:' + $nl
    $guia += "  CPU    : $cpu" + $nl
    $guia += "  GPU    : $gpu" + $nl
    $guia += "  RAM    : $ramGB GB" + $nl
    $guia += "  DISCO  : $diskModel ($diskGB GB - $diskType)" + $nl
    $guia += "  APPS INICIO: $startupCount programas" + $nl + $nl
    $guia += '================================================================' + $nl
    $guia += '  1. OPTIMIZACION DE SOFTWARE (GRATIS)' + $nl
    $guia += '================================================================' + $nl + $nl
    $guia += 'APPS DE INICIO - Desactiva las innecesarias:' + $nl
    $guia += '  Como hacerlo: Ctrl+Shift+Esc > Inicio > Click derecho > Deshabilitar' + $nl
    $guia += '  Candidatos a desactivar:' + $nl
    $guia += '    - Discord, Spotify, Steam, Epic Games (abrir manualmente)' + $nl
    $guia += '    - OneDrive (si no lo usas a diario)' + $nl
    $guia += '    - Microsoft Teams, Skype' + $nl
    $guia += '    - Adobe Creative Cloud, Java Updater' + $nl
    $guia += '    - Apps de impresoras (HP Smart, Epson, Canon)' + $nl
    $guia += '    - NVIDIA GeForce Experience (el driver funciona sin ella)' + $nl + $nl
    $guia += 'PLAN DE ENERGIA - Usa Alto rendimiento si estas enchufado:' + $nl
    $guia += '  Panel de control > Hardware > Opciones de energia > Alto rendimiento' + $nl + $nl
    $guia += 'ACTUALIZACIONES DE DRIVERS:' + $nl
    $guia += '  - GPU: Descarga siempre los drivers mas recientes de NVIDIA/AMD/Intel' + $nl
    $guia += '  - Chipset: Descarga los drivers de chipset de la web del fabricante' + $nl + $nl
    $guia += 'LIMPIEZA DEL SISTEMA:' + $nl
    $guia += '  - Ejecuta "Nexo_Limpieza_Total.bat" de la suite Nexo' + $nl
    $guia += '  - O manualmente: Win+R > cleanmgr > Limpiar archivos de sistema' + $nl + $nl
    $guia += 'MODO DE JUEGO DE WINDOWS:' + $nl
    $guia += '  Win+I > Juegos > Modo de juego > Activar' + $nl + $nl
    $guia += 'XBOX GAME BAR (desactivar si no la usas):' + $nl
    $guia += '  Win+I > Juegos > Xbox Game Bar > Desactivar' + $nl + $nl
    $guia += '================================================================' + $nl
    $guia += '  2. OPTIMIZACION DE HARDWARE (INVERSION)' + $nl
    $guia += '================================================================' + $nl + $nl
    $guia += 'RAM - Mejoras recomendadas segun tu capacidad actual:' + $nl
    $guia += "  Tienes: $ramGB GB" + $nl
    $guia += '  - Con menos de 8 GB : URGENTE ampliar a 16 GB minimo' + $nl
    $guia += '  - Con 8 GB           : Ampliar a 16-32 GB mejora mucho en multitarea' + $nl
    $guia += '  - Con 16 GB          : Buena base. 32 GB si editas video o usas VMs' + $nl
    $guia += '  - Con 32 GB o mas    : Mas que suficiente para la mayoria de usos' + $nl + $nl
    $guia += 'ALMACENAMIENTO:' + $nl
    $guia += "  Tienes: $diskModel ($diskGB GB - $diskType)" + $nl
    $guia += '  - Si tienes HDD: Pasar a SSD NVMe es la mejora mas notoria posible' + $nl
    $guia += '  - Si tienes SSD SATA: Un NVMe PCIe 4.0 mejora mucho las cargas grandes' + $nl
    $guia += '  - Si tienes NVMe: Ya tienes lo mejor. Prioriza CPU/GPU' + $nl + $nl
    $guia += 'GPU - Cuanto mejoras con un upgrade:' + $nl
    $guia += '  La GPU es el componente que mas impacta en gaming y creacion de contenido.' + $nl
    $guia += '  Consulta el diagnostico de sinergia en elnexocenter.com' + $nl
    $guia += '  para saber si tu CPU limita tu GPU o viceversa.' + $nl + $nl
    $guia += '================================================================' + $nl
    $guia += '  3. AJUSTES EN JUEGOS' + $nl
    $guia += '================================================================' + $nl + $nl
    $guia += '  - Activa NVIDIA DLSS / AMD FSR / Intel XeSS segun tu GPU' + $nl
    $guia += '  - Reduce Sombras y Distancia de dibujado (mayor impacto en FPS)' + $nl
    $guia += '  - Usa V-Sync desactivado + limite de FPS manual (menos latencia)' + $nl
    $guia += '  - Activa Resizable BAR / Smart Access Memory si tu equipo lo soporta' + $nl
    $guia += '  - En NVIDIA: Panel de control > Gestion de energia > Maximo rendimiento' + $nl + $nl
    $guia += '================================================================' + $nl
    $guia += '  Vuelve a ejecutar el benchmark tras optimizar para ver tu mejora' + $nl
    $guia += '  y sube tu resultado a elnexocenter.com para obtener tu rango.' + $nl
    $guia += '================================================================'
    Set-Content -Path $guiaFile -Value $guia -Encoding UTF8
    Say 'OK' 'Informe guardado.'

    Write-Host ''
    Write-Host '  ------------------------------------------------------------------------'
    Write-Host "   CPU    : $cpu"
    Write-Host "   GPU    : $gpu"
    Write-Host "   RAM    : $ramGB GB"
    Write-Host "   DISCO  : $diskModel ($diskGB GB - $diskType)"
    Write-Host "   INICIO : $startupCount apps"
    Write-Host '   RANGO  : sube resultado_nexo.txt a elnexocenter.com'
    Write-Host '  ------------------------------------------------------------------------'
    Write-Host "   Carpeta: $outFolder"
    Start-Sleep -Seconds 2

    # Navegador predeterminado del usuario y carpeta del informe
    Start-Process 'https://elnexocenter.com/nexos/benchmark.html'
    Start-Process explorer.exe $outFolder
    exit 0
} catch {
    Say 'ERROR' $_.Exception.Message
    Say 'ERROR' ('Linea ' + $_.InvocationInfo.ScriptLineNumber)
    exit 1
}
