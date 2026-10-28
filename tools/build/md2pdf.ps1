<#
  Genera el PDF de cada script desde su README.md (fuente unica).
    .\tools\build\md2pdf.ps1
  - Convierte el Markdown de la plantilla a HTML estatico (sin JavaScript,
    sin enlaces activos, sin recursos externos).
  - Imprime a PDF con Microsoft Edge en modo headless (gratuito y local).
  - El PDF conserva el nombre que ya tenia en el ZIP (README.pdf o READ_ME.pdf).
#>
param([string]$Edge = "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe")
$ErrorActionPreference = 'Stop'
$root = Resolve-Path (Join-Path $PSScriptRoot '..\..')
$out  = Join-Path $root 'source-code-web'
if (-not (Test-Path $Edge)) { throw "No se encuentra Microsoft Edge en $Edge" }

function Esc([string]$s) { [Net.WebUtility]::HtmlEncode($s) }
function Inline([string]$s) {
    $s = Esc $s
    $s = [regex]::Replace($s, '`([^`]+)`', '<code>$1</code>')
    $s = [regex]::Replace($s, '\*\*([^*]+)\*\*', '<strong>$1</strong>')
    $s
}
function Convert-Md([string]$md) {
    $lines = ($md -replace "`r`n", "`n") -split "`n"
    $html = New-Object System.Text.StringBuilder
    $i = 0; $title = ''
    while ($i -lt $lines.Count) {
        $l = $lines[$i]
        if ($l -match '^```') {
            $i++; $code = @()
            while ($i -lt $lines.Count -and $lines[$i] -notmatch '^```') { $code += (Esc $lines[$i]); $i++ }
            [void]$html.AppendLine('<pre>' + ($code -join "`n") + '</pre>'); $i++; continue
        }
        if ($l -match '^(#{1,3})\s+(.*)$') {
            $n = $Matches[1].Length; if ($n -eq 1) { $title = $Matches[2] }
            [void]$html.AppendLine("<h$n>" + (Inline $Matches[2]) + "</h$n>"); $i++; continue
        }
        if ($l -match '^\|') {
            $rows = @()
            while ($i -lt $lines.Count -and $lines[$i] -match '^\|') { $rows += $lines[$i]; $i++ }
            [void]$html.AppendLine('<table>')
            for ($r = 0; $r -lt $rows.Count; $r++) {
                if ($rows[$r] -match '^\|[\s:|-]+\|\s*$') { continue }
                $cells = $rows[$r].Trim().Trim('|') -split '\|'
                $tag = if ($r -eq 0) { 'th' } else { 'td' }
                [void]$html.AppendLine('<tr>' + (($cells | ForEach-Object { "<$tag>" + (Inline $_.Trim()) + "</$tag>" }) -join '') + '</tr>')
            }
            [void]$html.AppendLine('</table>'); continue
        }
        if ($l -match '^- ') {
            [void]$html.AppendLine('<ul>')
            while ($i -lt $lines.Count -and $lines[$i] -match '^- (.*)$') { [void]$html.AppendLine('<li>' + (Inline $Matches[1]) + '</li>'); $i++ }
            [void]$html.AppendLine('</ul>'); continue
        }
        if ($l -match '^>\s?(.*)$') { [void]$html.AppendLine('<blockquote>' + (Inline $Matches[1]) + '</blockquote>'); $i++; continue }
        if ($l.Trim() -eq '') { $i++; continue }
        $para = @()
        while ($i -lt $lines.Count -and $lines[$i].Trim() -ne '' -and $lines[$i] -notmatch '^(#|\||- |```|>)') { $para += $lines[$i]; $i++ }
        [void]$html.AppendLine('<p>' + (Inline ($para -join ' ')) + '</p>')
    }
    @{ Title = $title; Body = $html.ToString() }
}

$css = @'
@page { size: A4; margin: 18mm 16mm; }
body { font-family: "Segoe UI", Arial, sans-serif; font-size: 10.5pt; color: #1b1f24; line-height: 1.45; }
h1 { font-size: 19pt; margin: 0 0 4mm; padding-bottom: 2mm; border-bottom: 2.5pt solid #0b8fb3; color: #0b3d4f; }
h2 { font-size: 13pt; margin: 6mm 0 2mm; color: #0b6f8c; }
p { margin: 0 0 2.5mm; }
table { width: 100%; border-collapse: collapse; margin: 2mm 0 3mm; font-size: 9.5pt; }
th, td { border: 0.6pt solid #b9c4cc; padding: 1.6mm 2mm; vertical-align: top; text-align: left; }
th { background: #e6f4f8; color: #0b3d4f; }
tr { page-break-inside: avoid; }
code, pre { font-family: Consolas, "Courier New", monospace; font-size: 9pt; background: #f1f4f6; }
code { padding: 0 1mm; }
pre { padding: 2mm 3mm; border-left: 2pt solid #0b8fb3; white-space: pre-wrap; }
blockquote { margin: 2mm 0; padding: 2mm 3mm; border-left: 2pt solid #e0a800; background: #fff8e1; }
ul { margin: 0 0 2.5mm 5mm; padding: 0; }
.foot { margin-top: 8mm; font-size: 8.5pt; color: #5b6770; border-top: 0.6pt solid #b9c4cc; padding-top: 2mm; }
'@

function Stop-EdgeProfile([string]$p) {
    # Edge deja vivo su crashpad-handler: se cierran solo los procesos de este
    # perfil temporal (nunca el navegador del usuario).
    Get-CimInstance Win32_Process -Filter "Name='msedge.exe'" | Where-Object { $_.CommandLine -and $_.CommandLine.Contains($p) } |
        ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
}

foreach ($dir in Get-ChildItem $out -Directory | Sort-Object Name) {
    $edgeProfile = Join-Path ([IO.Path]::GetTempPath()) ('nexo_edge_' + [guid]::NewGuid().ToString('N'))
    try {
        $mdFile = Join-Path $dir.FullName 'README.md'
        if (-not (Test-Path $mdFile)) { continue }
        $doc = Convert-Md ([IO.File]::ReadAllText($mdFile, [Text.Encoding]::UTF8))
        $html = "<!doctype html><html lang=""es""><head><meta charset=""utf-8""><title>$(Esc $doc.Title)</title><style>$css</style></head><body>$($doc.Body)<div class=""foot"">El Nexo &middot; github.com/DarioA-Dev/Scripts-El-Nexo &middot; Generado desde README.md</div></body></html>"
        $tmpHtml = Join-Path ([IO.Path]::GetTempPath()) ("nexo_" + $dir.Name + '.html')
        [IO.File]::WriteAllText($tmpHtml, $html, (New-Object Text.UTF8Encoding($false)))
        $existing = Get-ChildItem $dir.FullName -Filter *.pdf | Select-Object -First 1
        $pdfName = if ($existing) { $existing.Name } else { 'README.pdf' }
        $pdf = Join-Path $dir.FullName $pdfName
        if (Test-Path $pdf) { Remove-Item $pdf -Force -Confirm:$false }
        $edgeArgs = @('--headless=new', '--disable-gpu', '--no-first-run', '--no-default-browser-check', '--disable-extensions',
                  "--user-data-dir=$edgeProfile", '--no-pdf-header-footer', "--print-to-pdf=$pdf", ([Uri]$tmpHtml).AbsoluteUri)
        $p = Start-Process -FilePath $Edge -ArgumentList $edgeArgs -PassThru -WindowStyle Minimized
        $deadline = (Get-Date).AddSeconds(90)
        while (-not $p.HasExited -and -not (Test-Path $pdf) -and (Get-Date) -lt $deadline) { Start-Sleep -Milliseconds 500 }
        Start-Sleep -Seconds 2   # deja que Edge termine de escribir el PDF
        Remove-Item $tmpHtml -Force -Confirm:$false
        if (-not (Test-Path $pdf)) { throw "Edge no genero $pdf" }
        # Metadatos minimos: el Creator de Edge (su user-agent) se sustituye por
        # un texto de la MISMA longitud, asi la tabla xref sigue siendo valida.
        $latin = [Text.Encoding]::GetEncoding(28591)
        $raw = $latin.GetString([IO.File]::ReadAllBytes($pdf))
        $m = [regex]::Match($raw, '/Creator \((?:\\.|[^\\)])*\)')
        if ($m.Success) {
            $label = '(El Nexo - README.md'
            $new = $label.PadRight($m.Length - 10) + ')'
            $raw = $raw.Remove($m.Index + 9, $m.Length - 9).Insert($m.Index + 9, $new)
            [IO.File]::WriteAllBytes($pdf, $latin.GetBytes($raw))
        }
        Write-Host ("{0,-22} {1,-12} {2,7} bytes" -f $dir.Name, $pdfName, (Get-Item $pdf).Length)
    } finally {
        Stop-EdgeProfile $edgeProfile
        Start-Sleep -Milliseconds 500
        if (Test-Path $edgeProfile) { Remove-Item $edgeProfile -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue }
    }
}
