# Frontend sistemi (Claude Code)

Claude Code için hazır bir frontend çalışma sistemi: 19 skill, 4 MCP sunucusu ve bir kurulum
betiği. Claude'a bir UI işi verdiğinde (sayfa, component, landing, dashboard, küçük stil
düzeltmesi) hangi skill'in hangi sırayla devreye gireceğini, varsayılan estetiği ve her projenin
kendi `DESIGN.md` kimlik dosyasını yönetir.

- **Varsayılan estetik:** dark glassmorphism (koyu gradient mesh + yarı saydam cam paneller).
  Projenin `DESIGN.md`'si başka bir stil seçerse o kazanır.
- **Kural:** proje kökünde doldurulmuş `DESIGN.md` olmadan arayüz inşa edilmez.
- **"Bitti" kapısı:** `gorsel-dogrulama` 4 ekran genişliği × açık/koyu temada taşma, konsol hatası
  ve başarısız istek kontrolü yapar; çıkış kodu 0 olmadan UI işi bitmiş sayılmaz.

Ana kural dosyası: [`skills/frontend-sistemi/SKILL.md`](skills/frontend-sistemi/SKILL.md).
Neyin nereden geldiği ve neyin bilerek alınmadığı: [`skills/frontend-sistemi/KAYNAKLAR.md`](skills/frontend-sistemi/KAYNAKLAR.md).

## Gereksinimler

| Araç | Neden | Zorunlu mu |
|---|---|---|
| [Claude Code](https://docs.claude.com/en/docs/claude-code) (`claude` CLI) | skill'ler ve MCP'ler buna kurulur | evet |
| [Node.js](https://nodejs.org) 18+ ve npm | MCP sunucuları (`npx`), `gorsel-dogrulama`, shadcn CLI | evet |
| [Python](https://python.org) 3.10+ | `ui-ux-pro-max` araması, `logo-design` betikleri | önerilir |
| Git | repoyu klonlamak için | evet |
| Microsoft Edge ya da Chromium | `gorsel-dogrulama` tarayıcısı; Edge yoksa betik Chromium indirir | otomatik |

## Kurulum

```bash
git clone https://github.com/Scryne/frontend-sistemi.git
cd frontend-sistemi
```

**Windows (PowerShell):**

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

**macOS / Linux (ya da Windows'ta Git Bash):**

```bash
chmod +x install.sh && ./install.sh
```

Sonra Claude Code'u kapatıp yeniden aç. Kontrol:

```bash
claude mcp list          # shadcn, magicui, motion (ve anahtar verdiysen 21st) görünmeli
```

Claude Code içinde `/frontend-sistemi` yazınca skill yüklenmeli.

### Kurulum betiği ne yapar

1. `skills/` altındaki 19 skill'i `~/.claude/skills/` altına kopyalar. Aynı adlı bir skill zaten
   varsa silmez, `~/.claude/skills-yedek/<tarih-saat>/` altına taşır.
2. `scripts/ipv4-dns.cjs`'i `~/.claude/scripts/` altına koyar (aşağıda "Sorun giderme").
3. `gorsel-dogrulama` için `npm install` yapar; Edge yoksa Playwright Chromium indirir.
4. MCP sunucularını kullanıcı düzeyinde ekler (`claude mcp add --scope user`). Zaten kayıtlı
   olana dokunmaz.
5. `~/.claude/CLAUDE.md` sonuna kısa bir yönlendirme ekler ([`CLAUDE-snippet.md`](CLAUDE-snippet.md)):
   "UI işinden önce `frontend-sistemi` skill'ini yükle". Zaten varsa tekrar eklemez.

Tekrar çalıştırmak güvenlidir. İstemediğin adımı atlayabilirsin:

| PowerShell | Bash | Atlanan |
|---|---|---|
| `-AtlaMcp` | `--atla-mcp` | MCP sunucuları |
| `-AtlaTarayici` | `--atla-tarayici` | Chromium indirme |
| `-AtlaClaudeMd` | `--atla-claude-md` | `CLAUDE.md` yönlendirmesi |

### 21st.dev anahtarı (isteğe bağlı)

`21st` MCP'si bileşen ilhamı ve önizleme verir, anahtarsız çalışmaz. Ücretsiz anahtarı
https://21st.dev/mcp adresinden al, sonra:

```powershell
.\install.ps1 -Api21stKey "ANAHTARIN"          # Windows
```

```bash
API_KEY_21ST="ANAHTARIN" ./install.sh          # macOS / Linux
```

Anahtarı repoya yazma; yalnız komut satırında ver.

## İçerik

### MCP sunucuları

| Ad | Ne işe yarar | Bağlantı |
|---|---|---|
| `shadcn` | shadcn ve kayıt defterlerinde (Magic UI, Aceternity, React Bits…) arama/kurulum | `npx shadcn@latest mcp` |
| `magicui` | Magic UI bileşenlerini `components.json` olmadan gezer | `npx -y @magicuidesign/mcp@latest` |
| `motion` | Motion (eski Framer Motion) doküman ve örnek araması | `https://mcp.motion.dev` |
| `21st` | 21st.dev bileşen ilhamı (anahtar gerekir) | `https://21st.dev/api/mcp` |

### Skill'ler

Sıra ve hangi işte hangisinin devreye girdiği `frontend-sistemi` skill'inde yazılı; Claude bunu
kendisi izler.

| Skill | Rol | Kaynak / lisans |
|---|---|---|
| `frontend-sistemi` | ana kural: estetik, araç sırası, `DESIGN.md` kuralı, boş `DESIGN.md` şablonu | bu sistem |
| `bilesen-kaynaklari` | hangi bileşen nereden gelir, kurulum öncesi koruma, lisans tablosu | bu sistem |
| `gorsel-dogrulama` | 4 genişlik × açık/koyu ekran görüntüsü + taşma/konsol/istek denetimi | bu sistem |
| `frontend-design` | estetik yön, tipografi | muhtemelen anthropics/skills, Apache-2.0 (`LICENSE.txt`) |
| `design-taste` | anti-slop yargı katmanı | plugin87/ux-ui-agent-skills, MIT |
| `ux-writing` | arayüz metni, hata mesajı, boş durum | plugin87/ux-ui-agent-skills, MIT |
| `ui-ux-pro-max` | palet, font, ikon, chart verisi ve arama | upstream lisansı belirsiz (KAYNAKLAR.md) |
| `create-design-md` | projenin `DESIGN.md`'sini koddan/URL'den üretir | ibelick/ui-skills, MIT |
| `baseline-ui` | inşa sırasında açık kalan sert stack kontratı | ibelick/ui-skills, MIT |
| `fixing-accessibility` | WCAG denetimi | ibelick/ui-skills, MIT |
| `fixing-motion-performance` | animasyon performansı | ibelick/ui-skills, MIT |
| `fixing-metadata` | SEO, OG, favicon | ibelick/ui-skills, MIT |
| `improve-ui` | mevcut arayüzü denetleyip plan yazar | ibelick/ui-skills, MIT |
| `shadcn` | resmî shadcn skill'i | shadcn-ui/ui, MIT |
| `motion` | animasyon yazımı, CSS spring | motiondivision/ai-kit, MIT |
| `frontend-ui-engineering` | production kalitesi, responsive, state | upstream kaydı yok |
| `tailwind-ui-refactor` | Tailwind son cila ("Refactoring UI") | upstream kaydı yok |
| `logo-design` | logo/favicon/uygulama ikonu (1.400+ logoluk referans kütüphanesi) | kaankiziltug/logo-design-skill, MIT |
| `nothing-design` | seçmeli monokrom stil; yalnız "Nothing style" denince | dominikmartn/nothing-design-skill, MIT |

Üçüncü taraf skill'ler kendi lisanslarıyla gelir; bu repo private paylaşım içindir, yeniden
dağıtmadan önce lisanslara bak.

`bilesen-kaynaklari` grafik işinde Claude Code'un yerleşik `dataviz` skill'ine atıf yapar; sende
yoksa o adım atlanır, gerisi çalışır.

## Kullanım

Ayrı bir şey yapman gerekmiyor: Claude Code'da bir UI işi iste ("şu sayfayı yap", "bu formu
düzelt", "landing hazırla"). Claude önce `frontend-sistemi`'ni yükler, projede `DESIGN.md` yoksa
onu oluşturur, sonra sırayı izler. Elle çağırmak istersen `/frontend-sistemi`, `/gorsel-dogrulama`,
`/improve-ui` gibi skill adlarını yaz.

Yeni bir projede `DESIGN.md` başlatmak için şablon:
`~/.claude/skills/frontend-sistemi/templates/DESIGN.md`. Doğrulama:

```bash
npx -p @google/design.md designmd lint DESIGN.md
```

Görsel doğrulamayı elle çalıştırmak (dev sunucusu açıkken):

```bash
node ~/.claude/skills/gorsel-dogrulama/scripts/dogrula.mjs http://localhost:3000 --rotalar /,/hakkinda
```

## Sorun giderme

**shadcn CLI `Connect Timeout` veriyor.** Bazı ağlarda IPv6 (AAAA) DNS sorgusu takılıyor ve Node
10 saniyede vazgeçiyor. Komutu IPv4 ön yüklemesiyle çalıştır:

```bash
NODE_OPTIONS="--require $HOME/.claude/scripts/ipv4-dns.cjs" npx shadcn@latest add @magicui/marquee
```

```powershell
$env:NODE_OPTIONS = "--require $HOME\.claude\scripts\ipv4-dns.cjs"; npx shadcn@latest add @magicui/marquee
```

**`npx @google/design.md` Windows'ta takılıyor.** Bin'i `designmd` adıyla çağır:
`npx -p @google/design.md designmd lint DESIGN.md`.

**MCP "failed" görünüyor (Windows).** `npx` tabanlı sunucular bazı kurulumlarda `cmd /c` ister:
`claude mcp remove shadcn -s user` sonra
`claude mcp add --scope user shadcn -- cmd /c npx shadcn@latest mcp` (magicui için de aynısı).

**`gorsel-dogrulama` tarayıcı bulamıyor.** `DOGRULA_TARAYICI` ortam değişkenine bir Chromium/Chrome
yolu ver ya da `install` betiğini `-AtlaTarayici` olmadan tekrar çalıştır.

## Güncelleme ve kaldırma

Güncellemek: `git pull`, sonra kurulum betiğini tekrar çalıştır (eski kopyalar `skills-yedek/`e
taşınır; işin bitince o klasörü silebilirsin).

Kaldırmak: `~/.claude/skills/` altından yukarıdaki 19 klasörü sil,
`claude mcp remove <ad> -s user` ile MCP'leri kaldır, `~/.claude/CLAUDE.md`'de
`<!-- frontend-sistemi:baslangic -->` ile `<!-- frontend-sistemi:bitis -->` arasını sil.
