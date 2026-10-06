# Frontend sistemi kurulumu (Windows, PowerShell 5.1+)
#
#   powershell -ExecutionPolicy Bypass -File .\install.ps1
#   powershell -ExecutionPolicy Bypass -File .\install.ps1 -Api21stKey "anahtar"
#
# Yaptigi:
#   1. skills/ altindaki her skill'i ~/.claude/skills/ altina kopyalar
#      (ayni adli skill varsa once ~/.claude/skills-yedek/<zaman>/ altina yedekler)
#   2. ipv4-dns.cjs'i ~/.claude/scripts/ altina kopyalar
#   3. gorsel-dogrulama icin npm install (+ Edge yoksa Playwright Chromium indirir)
#   4. MCP sunucularini kullanici duzeyinde ekler: shadcn, magicui, motion, (anahtar verilirse) 21st
#   5. ~/.claude/CLAUDE.md'ye frontend sistemi yonlendirmesini ekler (zaten varsa dokunmaz)
# Tekrar calistirmak guvenlidir.

param(
  [string]$Api21stKey = $env:API_KEY_21ST,
  [switch]$AtlaMcp,
  [switch]$AtlaTarayici,
  [switch]$AtlaClaudeMd,
  [string]$ClaudeDir = (Join-Path $HOME ".claude")
)

$ErrorActionPreference = "Stop"
$Repo = Split-Path -Parent $MyInvocation.MyCommand.Path
$Claude = $ClaudeDir
$Skills = Join-Path $Claude "skills"
$Zaman = Get-Date -Format "yyyyMMdd-HHmmss"

function Adim($m) { Write-Host "`n==> $m" -ForegroundColor Cyan }
function Uyari($m) { Write-Host "  ! $m" -ForegroundColor Yellow }
function Tamam($m) { Write-Host "  + $m" -ForegroundColor Green }
function KomutVar($komut) { return [bool](Get-Command $komut -ErrorAction SilentlyContinue) }

Adim "On kosullar"
$eksik = @()
if (-not (KomutVar "node")) { $eksik += "Node.js 18+ (https://nodejs.org)" }
if (-not (KomutVar "npm")) { $eksik += "npm" }
if ($eksik.Count -gt 0) { throw "Eksik: $($eksik -join ', '). Kurup tekrar calistir." }
Tamam "node $(node --version)"
if (KomutVar "python") { Tamam "python bulundu (ui-ux-pro-max ve logo-design betikleri icin)" }
else { Uyari "python yok: ui-ux-pro-max aramasi ve logo-design betikleri calismaz (https://python.org)" }
$claudeVar = KomutVar "claude"
if ($claudeVar) { Tamam "claude bulundu" } else { Uyari "claude CLI yok: MCP adimi atlanacak (sonra tekrar calistir)" }

Adim "Skill'ler -> $Skills"
New-Item -ItemType Directory -Force $Skills | Out-Null
$yedekDir = Join-Path $Claude "skills-yedek\$Zaman"
Get-ChildItem (Join-Path $Repo "skills") -Directory | ForEach-Object {
  $hedef = Join-Path $Skills $_.Name
  if (Test-Path $hedef) {
    New-Item -ItemType Directory -Force $yedekDir | Out-Null
    Move-Item $hedef (Join-Path $yedekDir $_.Name)
    Uyari "$($_.Name) zaten vardi, yedeklendi: $yedekDir"
  }
  Copy-Item $_.FullName $hedef -Recurse
  Tamam $_.Name
}

Adim "IPv4 DNS on yuklemesi -> ~/.claude/scripts/ipv4-dns.cjs"
$scripts = Join-Path $Claude "scripts"
New-Item -ItemType Directory -Force $scripts | Out-Null
Copy-Item (Join-Path $Repo "scripts\ipv4-dns.cjs") (Join-Path $scripts "ipv4-dns.cjs") -Force
Tamam "kopyalandi"

Adim "gorsel-dogrulama bagimliliklari"
$gd = Join-Path $Skills "gorsel-dogrulama\scripts"
Push-Location $gd
try {
  npm install --no-fund --no-audit
  if ($LASTEXITCODE -ne 0) { throw "npm install basarisiz" }
  Tamam "playwright-core kuruldu"
  $edge = @(
    "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
    "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
  ) | Where-Object { Test-Path $_ }
  if ($AtlaTarayici) { Uyari "tarayici indirme atlandi (-AtlaTarayici)" }
  elseif ($edge) { Tamam "Microsoft Edge bulundu, ayrica tarayici indirilmedi" }
  else {
    node node_modules/playwright-core/cli.js install chromium
    if ($LASTEXITCODE -ne 0) { Uyari "Chromium indirilemedi; DOGRULA_TARAYICI=<chromium yolu> ile calisir" }
    else { Tamam "Playwright Chromium indirildi" }
  }
} finally { Pop-Location }

if ($AtlaMcp -or -not $claudeVar) {
  Adim "MCP sunuculari atlandi"
} else {
  Adim "MCP sunuculari (kullanici duzeyi)"
  $mevcut = (claude mcp list 2>$null) -join "`n"
  function McpEkle($ad, [string[]]$argv) {
    if ($mevcut -match "(?m)^$([regex]::Escape($ad)):") { Tamam "$ad zaten kayitli, dokunulmadi"; return }
    & claude mcp add --scope user @argv
    if ($LASTEXITCODE -eq 0) { Tamam "$ad eklendi" } else { Uyari "$ad eklenemedi (komutu elle dene: claude mcp add --scope user $($argv -join ' '))" }
  }
  McpEkle "shadcn"  @("shadcn", "--", "npx", "shadcn@latest", "mcp")
  McpEkle "magicui" @("magicui", "--", "npx", "-y", "@magicuidesign/mcp@latest")
  McpEkle "motion"  @("--transport", "http", "motion", "https://mcp.motion.dev")
  if ($Api21stKey) {
    McpEkle "21st" @("--transport", "http", "21st", "https://21st.dev/api/mcp", "--header", "x-api-key: $Api21stKey")
  } else {
    Uyari "21st atlandi: anahtar gerekli (ucretsiz: https://21st.dev/mcp). Sonra: .\install.ps1 -Api21stKey <anahtar>"
  }
}

if ($AtlaClaudeMd) {
  Adim "CLAUDE.md atlandi"
} else {
  Adim "~/.claude/CLAUDE.md yonlendirmesi"
  $md = Join-Path $Claude "CLAUDE.md"
  $parca = Get-Content (Join-Path $Repo "CLAUDE-snippet.md") -Raw -Encoding UTF8
  $icerik = ""
  if (Test-Path $md) { $icerik = Get-Content $md -Raw -Encoding UTF8 }
  if ($icerik -match "frontend-sistemi:baslangic") { Tamam "zaten var, dokunulmadi" }
  else {
    $utf8 = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::AppendAllText($md, "`n" + $parca, $utf8)
    Tamam "eklendi: $md"
  }
}

Adim "Bitti"
Write-Host "Claude Code'u yeniden baslat. Kontrol: 'claude mcp list' ve bir oturumda '/frontend-sistemi'."
