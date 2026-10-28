<#
  Compilacion de los scripts El Nexo (no ejecuta ningun script de El Nexo).

    .\tools\build\build.ps1 -Assemble   # src\ + bloques comunes -> source-code-web\
    .\tools\build\build.ps1 -Zip        # source-code-web\ -> releases-dist-web\*.zip + SHA256SUMS.txt

  Los ZIP son reproducibles: mismo orden de entradas, fecha fija y
  compresion fija. Con las mismas fuentes salen los mismos SHA-256.
  releases-dist\ (versiones del 14-mar) no se toca nunca.
#>
param([switch]$Assemble, [switch]$Zip)
$ErrorActionPreference = 'Stop'
$root  = Resolve-Path (Join-Path $PSScriptRoot '..\..')
$src   = Join-Path $root 'src'
$out   = Join-Path $root 'source-code-web'
$dist  = Join-Path $root 'releases-dist-web'
$ascii = New-Object Text.ASCIIEncoding

function Read-Block($name) {
    $t = [IO.File]::ReadAllText((Join-Path $PSScriptRoot "$name.cmd.txt"))
    ($t -replace "`r`n", "`n").TrimEnd("`n")
}

if ($Assemble) {
    $blocks = @{ ui = Read-Block 'ui_block'; backup = Read-Block 'backup_block'; restore = Read-Block 'restore_block' }
    foreach ($dir in Get-ChildItem $src -Directory) {
        $dest = Join-Path $out $dir.Name
        New-Item -ItemType Directory -Force $dest | Out-Null
        foreach ($f in Get-ChildItem $dir.FullName -File) {
            $t = [IO.File]::ReadAllText($f.FullName) -replace "`r`n", "`n"
            if ($f.Extension -eq '.bat') {
                $t = [regex]::Replace($t, '(?m)^:: @@BLOCK (\w+)@@$', { param($m) $blocks[$m.Groups[1].Value] })
                if ($t -match '@@BLOCK') { throw "Bloque sin resolver en $($f.Name)" }
            }
            $t = $t.TrimEnd("`n") + "`n"
            [IO.File]::WriteAllText((Join-Path $dest $f.Name), ($t -replace "`n", "`r`n"), $ascii)
        }
        Write-Host "montado: $($dir.Name)"
    }
}

if ($Zip) {
    Add-Type -AssemblyName System.IO.Compression
    $fixed = [DateTimeOffset]::new(2026, 10, 28, 0, 0, 0, [TimeSpan]::Zero)
    $sums = New-Object System.Collections.Generic.List[string]
    foreach ($dir in Get-ChildItem $out -Directory | Sort-Object Name) {
        # En el ZIP van los scripts y el PDF; el README.md es la fuente del PDF
        $files = Get-ChildItem $dir.FullName -File | Where-Object { $_.Extension -in '.bat', '.ps1', '.pdf' } | Sort-Object Name
        $zipPath = Join-Path $dist ($dir.Name + '.zip')
        $ms = New-Object IO.MemoryStream
        $za = New-Object IO.Compression.ZipArchive($ms, [IO.Compression.ZipArchiveMode]::Create, $true)
        foreach ($f in $files) {
            $e = $za.CreateEntry($f.Name, [IO.Compression.CompressionLevel]::Optimal)
            $e.LastWriteTime = $fixed
            $s = $e.Open(); $b = [IO.File]::ReadAllBytes($f.FullName); $s.Write($b, 0, $b.Length); $s.Dispose()
        }
        $za.Dispose()
        [IO.File]::WriteAllBytes($zipPath, $ms.ToArray())
        $h = (Get-FileHash $zipPath -Algorithm SHA256).Hash.ToLower()
        $sums.Add("$h  $($dir.Name).zip")
        Write-Host ("{0,-24} {1,7} {2}" -f ($dir.Name + '.zip'), (Get-Item $zipPath).Length, $h)
    }
    [IO.File]::WriteAllText((Join-Path $dist 'SHA256SUMS.txt'), (($sums -join "`n") + "`n"), $ascii)
}
