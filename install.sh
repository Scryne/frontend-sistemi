#!/usr/bin/env bash
# Frontend sistemi kurulumu (macOS / Linux / Git Bash)
#
#   ./install.sh
#   API_KEY_21ST=anahtar ./install.sh
#   ./install.sh --atla-mcp --atla-tarayici --atla-claude-md
#
# Ne yaptigi icin install.ps1'in basina bak; ikisi ayni adimlari izler. Tekrar calistirmak guvenlidir.
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SKILLS="$CLAUDE_DIR/skills"
ZAMAN="$(date +%Y%m%d-%H%M%S)"
ATLA_MCP=0; ATLA_TARAYICI=0; ATLA_MD=0
for a in "$@"; do
  case "$a" in
    --atla-mcp) ATLA_MCP=1 ;;
    --atla-tarayici) ATLA_TARAYICI=1 ;;
    --atla-claude-md) ATLA_MD=1 ;;
    *) echo "bilinmeyen secenek: $a"; exit 2 ;;
  esac
done

adim()  { printf '\n\033[36m==> %s\033[0m\n' "$1"; }
uyari() { printf '\033[33m  ! %s\033[0m\n' "$1"; }
tamam() { printf '\033[32m  + %s\033[0m\n' "$1"; }
var()   { command -v "$1" >/dev/null 2>&1; }

adim "On kosullar"
var node || { echo "Node.js 18+ gerekli (https://nodejs.org)"; exit 1; }
var npm  || { echo "npm gerekli"; exit 1; }
tamam "node $(node --version)"
if var python3 || var python; then tamam "python bulundu"; else uyari "python yok: ui-ux-pro-max ve logo-design betikleri calismaz"; fi
CLAUDE_VAR=0; if var claude; then CLAUDE_VAR=1; tamam "claude bulundu"; else uyari "claude CLI yok: MCP adimi atlanacak"; fi

adim "Skill'ler -> $SKILLS"
mkdir -p "$SKILLS"
YEDEK="$CLAUDE_DIR/skills-yedek/$ZAMAN"
for d in "$REPO"/skills/*/; do
  ad="$(basename "$d")"
  if [ -e "$SKILLS/$ad" ]; then
    mkdir -p "$YEDEK"; mv "$SKILLS/$ad" "$YEDEK/$ad"
    uyari "$ad zaten vardi, yedeklendi: $YEDEK"
  fi
  cp -R "$d" "$SKILLS/$ad"
  tamam "$ad"
done

adim "IPv4 DNS on yuklemesi -> ~/.claude/scripts/ipv4-dns.cjs"
mkdir -p "$CLAUDE_DIR/scripts"
cp "$REPO/scripts/ipv4-dns.cjs" "$CLAUDE_DIR/scripts/ipv4-dns.cjs"
tamam "kopyalandi"

adim "gorsel-dogrulama bagimliliklari"
( cd "$SKILLS/gorsel-dogrulama/scripts"
  npm install --no-fund --no-audit
  tamam "playwright-core kuruldu"
  if [ "$ATLA_TARAYICI" = 1 ]; then uyari "tarayici indirme atlandi"
  elif [ -e "/Applications/Microsoft Edge.app" ] || [ -e "/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" ] || var microsoft-edge || var microsoft-edge-stable; then tamam "Microsoft Edge bulundu"
  else
    if node node_modules/playwright-core/cli.js install chromium; then tamam "Playwright Chromium indirildi"
    else uyari "Chromium indirilemedi; DOGRULA_TARAYICI=<chromium yolu> ile calisir"; fi
  fi )

if [ "$ATLA_MCP" = 1 ] || [ "$CLAUDE_VAR" = 0 ]; then
  adim "MCP sunuculari atlandi"
else
  adim "MCP sunuculari (kullanici duzeyi)"
  MEVCUT="$(claude mcp list 2>/dev/null || true)"
  mcp_ekle() {
    local ad="$1"; shift
    if printf '%s\n' "$MEVCUT" | grep -q "^$ad:"; then tamam "$ad zaten kayitli, dokunulmadi"; return; fi
    if claude mcp add --scope user "$@"; then tamam "$ad eklendi"; else uyari "$ad eklenemedi: claude mcp add --scope user $*"; fi
  }
  mcp_ekle shadcn  shadcn -- npx shadcn@latest mcp
  mcp_ekle magicui magicui -- npx -y @magicuidesign/mcp@latest
  mcp_ekle motion  --transport http motion https://mcp.motion.dev
  if [ -n "${API_KEY_21ST:-}" ]; then
    mcp_ekle 21st --transport http 21st https://21st.dev/api/mcp --header "x-api-key: $API_KEY_21ST"
  else
    uyari "21st atlandi: anahtar gerekli (ucretsiz: https://21st.dev/mcp). Sonra: API_KEY_21ST=<anahtar> ./install.sh"
  fi
fi

if [ "$ATLA_MD" = 1 ]; then
  adim "CLAUDE.md atlandi"
else
  adim "~/.claude/CLAUDE.md yonlendirmesi"
  MD="$CLAUDE_DIR/CLAUDE.md"
  if [ -f "$MD" ] && grep -q "frontend-sistemi:baslangic" "$MD"; then tamam "zaten var, dokunulmadi"
  else printf '\n' >> "$MD"; cat "$REPO/CLAUDE-snippet.md" >> "$MD"; tamam "eklendi: $MD"; fi
fi

adim "Bitti"
echo "Claude Code'u yeniden baslat. Kontrol: 'claude mcp list' ve bir oturumda '/frontend-sistemi'."
