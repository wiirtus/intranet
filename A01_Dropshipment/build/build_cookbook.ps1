# Builds the HTML cookbooks (EN + CZ) from markdown sources and build\cookbook_template.html
# - embeds the markdown into the template, fills UI texts for the language
# - inlines local images (image/...) as base64, so each HTML is one self-contained file
# Usage:  powershell -ExecutionPolicy Bypass -File build\build_cookbook.ps1            (builds both)
#         powershell -ExecutionPolicy Bypass -File build\build_cookbook.ps1 -Lang cs   (only Czech)

param([ValidateSet('all', 'en', 'cs')][string]$Lang = 'all')

$ErrorActionPreference = 'Stop'
$buildDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$root     = Split-Path -Parent $buildDir
$utf8     = New-Object System.Text.UTF8Encoding $false
$tpl      = [IO.File]::ReadAllText((Join-Path $buildDir 'cookbook_template.html'), $utf8)

$targets = @{
    en = @{ src = Join-Path $root 'Alza_shipping_cookbook_eng.md'; out = Join-Path $root 'Alza_shipping_cookbook_eng.html' }
    cs = @{ src = Join-Path $buildDir 'cookbook_cz.md';           out = Join-Path $root 'Alza_shipping_cookbook_cz.html' }
}

$ui = @{
    en = @{
        lang = 'en'; title = 'Alza Dropshipment – Shipping Cookbook'; brand = 'Alza Dropshipment · Shipping Cookbook'
        contents = 'Contents'; printTitle = 'Print / save as PDF'; themeTitle = 'Switch light / dark'
        dark = 'Dark'; light = 'Light'; loading = 'Loading…'; toTop = 'Back to top'
        footerGen = 'Generated from'; footerSrc = 'Source of API facts: Alza Trade API documentation'
        zoom = 'Click to enlarge ⤢'; kicker = 'Alza Trade API · Supplier guide'; supplier = 'Supplier'
        copy = 'Copy'; copied = 'Copied ✓'; legendDir = 'Direction'
        legendPills = 'Required: <span class="pill green">R</span> Conditional: <span class="pill amber">C</span> Not used: <span class="pill grey">–</span>'
    }
    cs = @{
        lang = 'cs'; title = 'Alza Dropshipment – Kuchařka přepravy'; brand = 'Alza Dropshipment · Kuchařka přepravy'
        contents = 'Obsah'; printTitle = 'Tisk / uložit jako PDF'; themeTitle = 'Přepnout světlý / tmavý režim'
        dark = 'Tmavý'; light = 'Světlý'; loading = 'Načítám…'; toTop = 'Nahoru'
        footerGen = 'Vygenerováno z'; footerSrc = 'Zdroj API údajů: dokumentace Alza Trade API'
        zoom = 'Kliknutím zvětšíte ⤢'; kicker = 'Alza Trade API · Příručka pro dodavatele'; supplier = 'Dodavatel'
        copy = 'Kopírovat'; copied = 'Zkopírováno ✓'; legendDir = 'Směr'
        legendPills = '<span class="pill green">Povinné</span> <span class="pill amber">Podmíněné</span> <span class="pill grey">–</span> nepoužívá se'
    }
}

$mime = @{ png = 'image/png'; jpg = 'image/jpeg'; jpeg = 'image/jpeg'; gif = 'image/gif'; svg = 'image/svg+xml'; webp = 'image/webp' }
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

$langs = if ($Lang -eq 'all') { @('en', 'cs') } else { @($Lang) }
foreach ($l in $langs) {
    $t = $targets[$l]
    $script:inlined = 0
    $md = [IO.File]::ReadAllText($t.src, $utf8)
    $md = [regex]::Replace($md, '!\[([^\]]*)\]\(([^)\s]+)\)', $evaluator)
    if ($md -match '</script') { throw "$($t.src) contains '</script' - cannot embed safely." }

    $html = $tpl
    foreach ($k in $ui[$l].Keys) { $html = $html.Replace("{{T:$k}}", $ui[$l][$k]) }
    if ($html -match '\{\{T:(\w+)\}\}') { throw "Missing UI text '$($Matches[1])' for language '$l'." }
    $html = $html.Replace('<!--SOURCE-->', [IO.Path]::GetFileName($t.src)).Replace('<!--BUILD_DATE-->', (Get-Date -Format 'yyyy-MM-dd HH:mm'))
    $html = $html.Replace('<!--MARKDOWN-->', $md)   # last, so markdown text is never touched by the replacements above
    [IO.File]::WriteAllText($t.out, $html, $utf8)
    "[$l] Built $($t.out)  ($([math]::Round((Get-Item $t.out).Length / 1KB)) KB, $script:inlined image(s) inlined)"
}
