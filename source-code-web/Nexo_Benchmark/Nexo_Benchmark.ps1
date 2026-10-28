# =========================================================================
#  EL NEXO BENCHMARK - v18 (script de solo lectura)
#  Codigo abierto: https://github.com/DarioA-Dev/Scripts-El-Nexo
#
#  Que hace:
#   - Lee CPU, GPU, RAM, sistema, disco y numero de apps de inicio (WMI/CIM).
#   - Escribe dos ficheros de texto en %ProgramData%\ElNexo\Benchmark:
#       resultado_nexo.txt           (lo subes a elnexocenter.com/nexos/benchmark.html)
#       GUIA_MEJORAR_RENDIMIENTO.txt (consejos segun tu equipo)
#   - Abre la pagina del benchmark y la carpeta del informe.
#
#  Que NO hace:
#   - No cambia ninguna configuracion de Windows.
#   - No envia nada a internet: el informe lo subes tu manualmente y se
#     analiza en tu navegador.
#   - No escribe nada fuera de %ProgramData%\ElNexo.
# =========================================================================
$ErrorActionPreference = 'Stop'
try {
    Write-Host '   [+] Leyendo CPU...' -ForegroundColor Cyan
    $cpu = (Get-CimInstance Win32_Processor | Select-Object -First 1).Name

    Write-Host '   [+] Leyendo GPU...' -ForegroundColor Cyan
    $gpu = (Get-CimInstance Win32_VideoController | Where-Object { $_.Name -notlike '*Basic*' } | Select-Object -First 1).Name
    if (-not $gpu) { $gpu = (Get-CimInstance Win32_VideoController | Select-Object -First 1).Name }

    Write-Host '   [+] Leyendo RAM...' -ForegroundColor Cyan
    $ramGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 1)

    Write-Host '   [+] Leyendo Sistema...' -ForegroundColor Cyan
    $winVer = (Get-CimInstance Win32_OperatingSystem).Caption

    Write-Host '   [+] Leyendo almacenamiento...' -ForegroundColor Cyan
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

    Write-Host '   [+] Leyendo apps de inicio...' -ForegroundColor Cyan
    $startupApps = @(Get-CimInstance Win32_StartupCommand | Select-Object Name, Command, Location)
    $startupReg = Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -ErrorAction SilentlyContinue
    $startupCount = $startupApps.Count
    if ($startupReg) { $startupCount += @($startupReg.PSObject.Properties | Where-Object { $_.Name -notlike 'PS*' }).Count }

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
    $guia += 'PLAN DE ENERGIA - Activa Maximo Rendimiento:' + $nl
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
    $guia += '  - Si tienes SSD SATA: Un NVMe PCIe 4.0 duplica velocidades' + $nl
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
    $guia += '  - Usa V-Sync desactivado + framerate cap manual (menos latencia)' + $nl
    $guia += '  - Activa Resizable BAR / Smart Access Memory si tu equipo lo soporta' + $nl
    $guia += '  - En NVIDIA: Panel de control > Gestion de energia > Maximo rendimiento' + $nl + $nl
    $guia += '================================================================' + $nl
    $guia += '  Vuelve a ejecutar el benchmark tras optimizar para ver tu mejora' + $nl
    $guia += '  y sube tu resultado a elnexocenter.com para obtener tu rango!' + $nl
    $guia += '================================================================'
    Set-Content -Path $guiaFile -Value $guia -Encoding UTF8

    Write-Host ''
    Write-Host '  =============================================' -ForegroundColor DarkCyan
    Write-Host '        ANALISIS COMPLETADO                    ' -ForegroundColor White
    Write-Host '  =============================================' -ForegroundColor DarkCyan
    Write-Host "   CPU    : $cpu" -ForegroundColor Yellow
    Write-Host "   GPU    : $gpu" -ForegroundColor Yellow
    Write-Host "   RAM    : $ramGB GB" -ForegroundColor Yellow
    Write-Host "   DISCO  : $diskModel ($diskGB GB - $diskType)" -ForegroundColor Yellow
    Write-Host "   INICIO : $startupCount apps" -ForegroundColor Yellow
    Write-Host '  =============================================' -ForegroundColor DarkCyan
    Write-Host '   RANGO  : ??? (Subelo a elnexocenter.com)' -ForegroundColor Cyan
    Write-Host '  =============================================' -ForegroundColor DarkCyan
    Write-Host ''
    Write-Host "   Informe guardado en: $outFolder" -ForegroundColor Green
    Write-Host '   Abriendo navegador...' -ForegroundColor Green
    Start-Sleep -Seconds 2

    # Navegador predeterminado del usuario y carpeta del informe
    Start-Process 'https://elnexocenter.com/nexos/benchmark.html'
    Start-Process explorer.exe $outFolder
} catch {
    Write-Host ''
    Write-Host "   [ERROR]: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   Linea  : $($_.InvocationInfo.ScriptLineNumber)" -ForegroundColor Red
    Read-Host '   Pulsa Enter para cerrar'
}
