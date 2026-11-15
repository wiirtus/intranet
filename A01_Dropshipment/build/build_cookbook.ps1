# Builds Alza_shipping_cookbook_eng.html from Alza_shipping_cookbook_eng.md
# - embeds the markdown into build\cookbook_template.html
# - inlines local images (image/...) as base64, so the HTML is one self-contained file
# Usage:  powershell -ExecutionPolicy Bypass -File build\build_cookbook.ps1

$ErrorActionPreference = 'Stop'
$buildDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$root     = Split-Path -Parent $buildDir
$mdPath   = Join-Path $root 'Alza_shipping_cookbook_eng.md'
$tplPath  = Join-Path $buildDir 'cookbook_template.html'
$outPath  = Join-Path $root 'Alza_shipping_cookbook_eng.html'

$utf8 = New-Object System.Text.UTF8Encoding $false
$md   = [IO.File]::ReadAllText($mdPath, $utf8)
$tpl  = [IO.File]::ReadAllText($tplPath, $utf8)

$mime = @{ png = 'image/png'; jpg = 'image/jpeg'; jpeg = 'image/jpeg'; gif = 'image/gif'; svg = 'image/svg+xml'; webp = 'image/webp' }
$script:inlined = 0
$evaluator = [System.Text.RegularExpressions.MatchEvaluator] {
    param($m)
    $src = $m.Groups[2].Value
    if ($src -match '^(https?:|data:)') { return $m.Value }
    $file = Join-Path $root ($src -replace '/', '\')
    if (-not (Test-Path $file)) { Write-Warning "Image not found: $src"; return $m.Value }
    $ext = [IO.Path]::GetExtension($file).TrimStart('.').ToLower()
    $b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($file))
    $script:inlined++
    return "![$($m.Groups[1].Value)](data:$($mime[$ext]);base64,$b64)"
}
$md = [regex]::Replace($md, '!\[([^\]]*)\]\(([^)\s]+)\)', $evaluator)

if ($md -match '</script') { throw 'Markdown contains "</script" - cannot embed safely.' }

$html = $tpl.Replace('<!--MARKDOWN-->', $md).Replace('<!--BUILD_DATE-->', (Get-Date -Format 'yyyy-MM-dd HH:mm'))
[IO.File]::WriteAllText($outPath, $html, $utf8)

"Built $outPath  ($([math]::Round((Get-Item $outPath).Length / 1KB)) KB, $script:inlined image(s) inlined)"
