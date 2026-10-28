<#
  Analisis estatico de los scripts El Nexo. NO ejecuta ningun script.
    .\tools\lint\lint.ps1 -Dir source-code-web
  Devuelve el numero de problemas como codigo de salida.
#>
param([string]$Dir = 'source-code-web')
$problems = 0
function Report($f, $msg) { Write-Host ("  [X] {0}: {1}" -f $f, $msg); $script:problems++ }

# Patrones prohibidos (heuristica de antivirus o riesgo para el usuario)
$forbidden = [ordered]@{
  '(?i)start=(auto|disabled|demand|boot|system|delayed-auto)\b' = 'sc config sin espacio tras start='
  '(?i)\bwmic\b'                                   = 'WMIC (eliminado en Windows 11 24H2)'
  '(?i)-WindowStyle\s+Hidden|-w\s+hidden'          = 'ventana oculta'
  '(?i)\s-e(nc|ncodedcommand)?\s+[A-Za-z0-9+/=]{16,}' = 'comando codificado'
  '(?i)FromBase64String|ToBase64String'            = 'Base64'
  '(?i)\biex\b|Invoke-Expression'                  = 'Invoke-Expression'
  '(?i)DownloadString|DownloadFile|Invoke-WebRequest|Invoke-RestMethod|Net\.WebClient|bitsadmin|certutil|Start-BitsTransfer|curl\s|wget\s' = 'descarga desde script'
  '(?i)Add-MpPreference|Set-MpPreference|ExclusionPath|DisableRealtimeMonitoring' = 'toca Microsoft Defender'
  '(?i)taskkill[^\r\n]*(MsMpEng|SecurityHealth|MsSense|NisSrv|wscsvc|WinDefend)' = 'taskkill sobre seguridad'
  '(?i)sc(\.exe)?\s+(stop|config)\s+"?(WinDefend|wscsvc|SecurityHealthService|Sense|mpssvc|BFE|wuauserv|Spooler|Audiosrv|AudioEndpointBuilder|Dhcp|Dnscache|NlaSvc|netprofm)\b' = 'desactiva servicio critico'
  '(?i)%TEMP%\\[^"]*\.(ps1|bat|cmd|vbs|js)|\$env:TEMP' = 'script generado en TEMP'
  '(?i)restoredefaultschemes'                      = 'borra planes de energia del usuario'
  '(?i)\\Prefetch\\'                               = 'borrado de Prefetch'
  '(?i)\$Recycle\.bin'                             = 'rd de la papelera de todos los usuarios'
  '(?i)AutomaticDestinations'                      = 'borra elementos anclados'
}
# Longitud visible estimada de variables en mensajes
$varLen = @{ NEXO_BK = 50; PLAN_NOMBRE = 26; DEVICE_NAME = 15; L_VAL = 6 }
function Visible([string]$s) {
  $s = [regex]::Replace($s, '%C_[A-Z]+%', '')
  $s = [regex]::Replace($s, '[%!]([A-Z_]+)[%!]', { param($m) if ($varLen.ContainsKey($m.Groups[1].Value)) { 'x' * $varLen[$m.Groups[1].Value] } else { 'x' * 12 } })
  $s -replace '\^(.)', '$1'
}
$prefix = @{ UI_OK = 6; UI_SKIP = 5; UI_WARN = 5; UI_FAIL = 9; UI_INFO = 6; UI_AUTO = 15; UI_OPT = 15; UI_PRO = 9 }

foreach ($f in Get-ChildItem $Dir -Recurse -Include *.bat, *.ps1) {
  $name  = $f.Directory.Name + '\' + $f.Name
  $bytes = [IO.File]::ReadAllBytes($f.FullName)
  if (@($bytes | Where-Object { $_ -gt 127 }).Count) { Report $name 'caracteres no ASCII' }
  $text = [IO.File]::ReadAllText($f.FullName)
  if (($text -replace "`r`n", '') -match "`n") { Report $name 'finales de linea LF (se esperan CRLF)' }
  $lines = $text -split "`r`n"

  foreach ($k in $forbidden.Keys) {
    $hits = @($lines | Where-Object { $_ -match $k -and $_ -notmatch '^\s*(::|rem\s|#)' })
    if ($hits.Count) { Report $name ($forbidden[$k] + ' -> ' + $hits[0].Trim()) }
  }

  if ($f.Extension -eq '.ps1') {
    $tok = $null; $err = $null
    [void][System.Management.Automation.Language.Parser]::ParseFile($f.FullName, [ref]$tok, [ref]$err)
    foreach ($e in $err) { Report $name ("PS parse: " + $e.Message + " (linea " + $e.Extent.StartLineNumber + ")") }
    foreach ($l in $lines) { if ($l -match "Write-Host\s+'([^']*)'" -and $Matches[1].Length -gt 78) { Report $name "linea de consola > 78: $($Matches[1])" } }
    continue
  }

  # Etiquetas
  $labels = @($lines | Where-Object { $_ -match '^:([A-Za-z_]\w*)\s*$' } | ForEach-Object { $Matches[1].ToUpper() })
  foreach ($m in [regex]::Matches($text, '(?i)\b(?:call|goto)\s+:([A-Za-z_]\w*)')) {
    if ($m.Groups[1].Value -ieq 'EOF') { continue }
    if ($labels -notcontains $m.Groups[1].Value.ToUpper()) { Report $name ('etiqueta inexistente :' + $m.Groups[1].Value) }
  }
  foreach ($d in ($labels | Group-Object | Where-Object { $_.Count -gt 1 })) { Report $name ('etiqueta duplicada :' + $d.Name) }

  # Comillas y parentesis (fuera de comillas y sin ^)
  $depth = 0; $ln = 0
  foreach ($l in $lines) {
    $ln++
    $s = $l.Trim()
    if ($s -match '^(::|rem\s)') { continue }
    $inQ = $false; $prev = ''
    for ($i = 0; $i -lt $s.Length; $i++) {
      $c = $s[$i]
      if ($c -eq '"') { $inQ = -not $inQ }
      elseif (-not $inQ -and $prev -ne '^') {
        if ($c -eq '(') { $depth++ } elseif ($c -eq ')') { if ($depth -gt 0) { $depth-- } }
      }
      $prev = $c
    }
    if ($inQ) { Report $name "comillas sin cerrar en linea $ln" }
  }
  if ($depth -ne 0) { Report $name "parentesis desequilibrados ($depth)" }

  # Ancho maximo 78 columnas en lo que ve el usuario
  $ln = 0
  foreach ($l in $lines) {
    $ln++
    $s = $l.Trim()
    if ($s -match '^(?:\(?\s*)?echo[ .](.*)$' -and $s -notmatch '%~\d') {
      $v = Visible ($Matches[1] -replace '\)\s*(else.*)?$', '')
      if ($v.Length -gt 78) { Report $name "linea $ln > 78 columnas" }
    }
    foreach ($m in [regex]::Matches($s, '(?i)call :(UI_\w+|STEP_END|UI_STEP)\s+(.*)$')) {
      $fn = $m.Groups[1].Value.ToUpper()
      $args = @([regex]::Matches($m.Groups[2].Value, '"([^"]*)"') | ForEach-Object { $_.Groups[1].Value })
      if ($fn -eq 'STEP_END') { foreach ($a in $args) { if ((Visible $a).Length + 9 -gt 78) { Report $name "linea $ln mensaje > 78: $a" } } }
      elseif ($fn -eq 'UI_STEP') { foreach ($a in $args) { if ((Visible $a).Length + 13 -gt 78) { Report $name "linea $ln paso > 78: $a" } } }
      elseif ($prefix.ContainsKey($fn)) { foreach ($a in $args) { if ((Visible $a).Length + $prefix[$fn] -gt 78) { Report $name "linea $ln mensaje > 78: $a" } } }
    }
  }

  # PowerShell incrustado: -Command "..." (con continuaciones ^) y variables PKn
  $vars = @{}
  foreach ($m in [regex]::Matches($text, '(?m)^set "(PK\d)=(.*)"\r?$')) { $vars[$m.Groups[1].Value] = $m.Groups[2].Value }
  $joined = $text -replace "\^\r\n\s*", ' '
  foreach ($m in [regex]::Matches($joined, '(?i)powershell\s+-NoProfile\s+-Command\s+((?:"[^"]*"\s*)+)')) {
    $parts = [regex]::Matches($m.Groups[1].Value, '"([^"]*)"') | ForEach-Object { $_.Groups[1].Value }
    $code = ($parts -join ' ') -replace '%~1', 'X'
    $code = [regex]::Replace($code, '!(PK\d)!', { param($x) $vars[$x.Groups[1].Value] })
    $tok = $null; $err = $null
    [void][System.Management.Automation.Language.Parser]::ParseInput($code, [ref]$tok, [ref]$err)
    foreach ($e in $err) { Report $name ("PS -Command parse: " + $e.Message) }
  }
}
Write-Host ("Problemas: {0}" -f $problems)
exit $problems
