<#
  Verifica los PDF de source-code-web (solo lectura):
   - sin JavaScript, acciones de apertura, acciones automaticas, Launch,
     ficheros embebidos, formularios ni enlaces URI;
   - metadatos presentes (solo informativo);
   - texto extraible: decodifica los flujos con sus mapas ToUnicode y
     comprueba que aparece el titulo del README.
    .\tools\build\check_pdf.ps1
#>
$ErrorActionPreference = 'Stop'
$root = Resolve-Path (Join-Path $PSScriptRoot '..\..')
$latin = [Text.Encoding]::GetEncoding(28591)
$bad = 0

function Inflate([byte[]]$data) {
    try {
        $ms = [IO.MemoryStream]::new($data, 2, $data.Length - 2)
        $ds = New-Object IO.Compression.DeflateStream($ms, [IO.Compression.CompressionMode]::Decompress)
        $o = New-Object IO.MemoryStream; $ds.CopyTo($o); $ds.Dispose(); , $o.ToArray()
    } catch { , ([byte[]]@()) }
}

foreach ($pdf in Get-ChildItem (Join-Path $root 'source-code-web') -Recurse -Filter *.pdf) {
    $name = $pdf.Directory.Name + '\' + $pdf.Name
    $bytes = [IO.File]::ReadAllBytes($pdf.FullName)
    $raw = $latin.GetString($bytes)
    $issues = @()
    foreach ($k in '/JavaScript', '/JS ', '/JS(', '/OpenAction', '/AA ', '/AA<<', '/Launch', '/EmbeddedFile', '/RichMedia', '/XFA', '/AcroForm', '/URI') {
        if ($raw.Contains($k)) { $issues += $k.Trim() }
    }

    # Objetos y flujos
    $objs = @{}
    foreach ($m in [regex]::Matches($raw, '(?s)(\d+) 0 obj(.*?)endobj')) { $objs[[int]$m.Groups[1].Value] = $m.Groups[2].Value }
    $streams = @{}
    foreach ($id in $objs.Keys) {
        $o = $objs[$id]
        $si = $o.IndexOf("stream`n"); $sl = 7
        if ($si -lt 0) { $si = $o.IndexOf("stream`r`n"); $sl = 8 }
        if ($si -lt 0) { continue }
        $start = $si + $sl; $end = $o.LastIndexOf('endstream')
        $data = $latin.GetBytes($o.Substring($start, $end - $start))
        if ($o.Substring(0, $si) -match '/FlateDecode') { $data = Inflate $data }
        $streams[$id] = $latin.GetString($data)
    }
    # Mapas ToUnicode por fuente
    $fontMap = @{}
    foreach ($id in $objs.Keys) {
        if ($objs[$id] -match '/ToUnicode (\d+) 0 R') {
            $cmap = $streams[[int]$Matches[1]]; $map = @{}
            foreach ($sec in [regex]::Matches($cmap, '(?s)beginbfchar(.*?)endbfchar')) {
                foreach ($m in [regex]::Matches($sec.Groups[1].Value, '<([0-9A-Fa-f]+)>\s*<([0-9A-Fa-f]+)>')) {
                    $u = $m.Groups[2].Value; $chars = ''
                    for ($c = 0; $c + 4 -le $u.Length; $c += 4) { $chars += [char][Convert]::ToInt32($u.Substring($c, 4), 16) }
                    $map[$m.Groups[1].Value.ToUpper()] = $chars
                }
            }
            foreach ($sec in [regex]::Matches($cmap, '(?s)beginbfrange(.*?)endbfrange')) {
                foreach ($m in [regex]::Matches($sec.Groups[1].Value, '<([0-9A-Fa-f]+)>\s*<([0-9A-Fa-f]+)>\s*<([0-9A-Fa-f]+)>')) {
                    $lo = [Convert]::ToInt32($m.Groups[1].Value, 16); $hi = [Convert]::ToInt32($m.Groups[2].Value, 16); $b = [Convert]::ToInt32($m.Groups[3].Value, 16)
                    for ($g = $lo; $g -le $hi; $g++) { $map[$g.ToString('X4')] = [string][char]($b + $g - $lo) }
                }
            }
            $fontMap[$id] = $map
        }
    }
    # Nombres de recurso (/F1 12 0 R) -> objeto fuente
    $res = @{}
    foreach ($m in [regex]::Matches($raw, '/(F\d+|[A-Za-z]+\d*)\s+(\d+) 0 R')) { if ($fontMap.ContainsKey([int]$m.Groups[2].Value)) { $res[$m.Groups[1].Value] = $fontMap[[int]$m.Groups[2].Value] } }
    # Extraer texto de los flujos de contenido
    $text = New-Object System.Text.StringBuilder
    foreach ($s in $streams.Values) {
        if ($s -notmatch '\bTf\b') { continue }
        $cur = $null
        foreach ($m in [regex]::Matches($s, '/(\S+)\s+[\d.]+\s+Tf|\[(.*?)\]\s*TJ|<([0-9A-Fa-f]+)>\s*Tj')) {
            if ($m.Groups[1].Success) { $cur = $res[$m.Groups[1].Value]; continue }
            if (-not $cur) { continue }
            $hexes = if ($m.Groups[2].Success) { [regex]::Matches($m.Groups[2].Value, '<([0-9A-Fa-f]+)>') | ForEach-Object { $_.Groups[1].Value } } else { @($m.Groups[3].Value) }
            foreach ($h in $hexes) { for ($c = 0; $c + 4 -le $h.Length; $c += 4) { $k = $h.Substring($c, 4).ToUpper(); if ($cur.ContainsKey($k)) { [void]$text.Append($cur[$k]) } } }
            [void]$text.Append(' ')
        }
    }
    $plain = ($text.ToString() -replace '\s+', '')
    $title = ([IO.File]::ReadAllLines((Join-Path $pdf.DirectoryName 'README.md'), [Text.Encoding]::UTF8)[0] -replace '^#\s*', '' -replace '\s+', '')
    $extractOk = $plain.Contains($title.Substring(0, [Math]::Min(12, $title.Length)))
    $meta = @([regex]::Matches($raw, '/(Producer|Creator|Title|CreationDate|ModDate)\b') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique) -join ','
    if ($env:NEXO_PDF_DEBUG) { Write-Host ($text.ToString().Substring(0,[Math]::Min(300,$text.Length))) }
    if ($issues.Count -or -not $extractOk) { $bad++ }
    "{0,-38} activo:{1,-12} texto:{2,-3} chars:{3,6} meta:{4}" -f $name, $(if ($issues) { $issues -join ',' } else { 'ninguno' }), $(if ($extractOk) { 'OK' } else { 'NO' }), $plain.Length, $meta
}
"PDF con problemas: $bad"
exit $bad
