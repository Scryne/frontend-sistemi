# Frontend sistemi: kaynaklar ve alınmayanlar

Kural metni aynı klasördeki `SKILL.md`'de. Bu not o kuralların **nereden geldiğini ve
neyin bilerek alınmadığını** tutar. Karar tarihçesi kural değil, ihtiyaç anında okunur.

"Şu skill paketini kuralım mı?" sorusu gelirse önce burayı oku.

## Dark glassmorphism kaynakları (2026-09-01)

- https://medium.com/@developer_89726/dark-glassmorphism-the-aesthetic-that-will-define-ui-in-2026-93aa4153088f
- https://uxpilot.ai/blogs/glassmorphism-ui

## ibelick/ui-skills: alındı (2026-09-05)

`baseline-ui`, `create-design-md`, `fixing-accessibility`, `fixing-metadata`,
`fixing-motion-performance` ve `improve-ui` [ibelick/ui-skills](https://github.com/ibelick/ui-skills)
(MIT) reposundan vendor edildi. Her SKILL.md'nin sonunda bir "Kaynak" bloğu var. `baseline-ui`'da
ayrıca bir "Yerel geçersiz kılmalar" bölümü var: upstream "gradient kullanma, mor/çok renkli
gradient kullanma" diyor, dark glassmorphism varsayılanı bunu arkaplan için bilinçli olarak eziyor.

**Alınmayan:** upstream'deki `ui-skills-root` router skill'i (gereksiz: skill'ler lokalde,
Claude Code zaten description'dan yönlendiriyor) ve repo'nun MCP server'ı
(`https://www.ui-skills.com/mcp`).

## mattpocock/skills: alınmadı (2026-09-05)

[mattpocock/skills](https://github.com/mattpocock/skills). Adı yanıltıyor, içinde frontend yok:
TDD, spec, ticket, triage, domain modeling. Yani bir proje çalışma akışının rakibi, frontend
sisteminin tamamlayıcısı değil. Tek tek `diagnosing-bugs` / `research` gibi parçalar ileride
ayıklanabilir; toplu kurulum önerilmez.

## plugin87/ux-ui-agent-skills: iki parça alındı (2026-09-05)

[plugin87/ux-ui-agent-skills](https://github.com/plugin87/ux-ui-agent-skills). Alınanlar:
`ux-writing` (+ `voice-tone.md`, `i18n-rtl.md`) ve `design-taste` (+ `motion-choreography.md`).

Geri kalanı **bilerek alınmadı**:
- Skill'leri kendi kendine yetmiyor: her biri kardeş repo yollarına bakıyor, tek dosya
  kopyalanınca kırılıyor.
- Proje başına kurulan bir kit ve kendi 23KB'lık "agent persona" CLAUDE.md'siyle geliyor.
- `a11y-audit`/`performance`/`design-review`/`redesign` buradaki
  `fixing-accessibility`/`fixing-motion-performance`/`improve-ui` ile örtüşüyor.
- En önemlisi: `design-tokens`/`brandkit`/`token-build`/`governance` dörtlüsü
  `tokens/*.json`'ı (DTCG 3-tier) tek doğruluk kaynağı yapmak istiyor. Bu `DESIGN.md`
  kararıyla doğrudan çelişir, aynı token iki yerde yaşar.

Bir proje gerçekten tam bir design system istediğinde o kit proje bazında
`npx ux-ui-agent-skills add <alan>` ile kurulabilir (`claude` alanını, yani persona
CLAUDE.md'sini alma). `design-systems/library/` (138 sistem) referans korpusu olarak ilginç
ama alınmadı: sayıldı, 71'i gerçekten gözlemlenmiş detay, 67'si üretilmiş şablon.

## DESIGN.md mirası

Eski projelerde kimlik dosyası `docs/Design.md` adıyla serbest metin olarak durabilir. O projede
frontend işine dönüldüğünde `create-design-md` ile köke taşınıp spec'e çevrilir; iki dosya aynı
anda canlı tutulmaz. Boş şablon: bu klasördeki `templates/DESIGN.md`.

## Ölçek kuralı (2026-09-22)

11 adımlı araç sırası yeni ekran içindir; küçük bir değişiklik için on skill yüklemek bağlamı
doldurup asıl işi sulandırıyordu. Bu yüzden `frontend-sistemi`'ne ölçek kuralı eklendi.

## 2026-09-28 genişlemesi (shadcn, 21st, ObsidianUI, Magic UI, React Bits, Aceternity, Lucide, Motion)

Asıl bulgu: bunların çoğu ayrı MCP değil, **shadcn kayıt defteri**. shadcn CLI 4.21'in yerleşik
listesinde 382 kayıt var; `@magicui`, `@aceternity`, `@react-bits` ayarsız çalışır (CLI ile ölçüldü).
Ama shadcn **MCP** araması yalnız `components.json`'da yazılı kayıt defterlerini görür, bu yüzden
her frontend projesinde `registries` bloğu gerekli (metni `bilesen-kaynaklari` skill'inde).

**Alındı:**
- `magicui` MCP (resmî `@magicuidesign/mcp`, MIT), kullanıcı düzeyi. Artısı: `components.json`
  olmadan da gezer.
- `motion` MCP (`https://mcp.motion.dev`, ücretsiz doküman araması) + `motion` skill
  (motiondivision/ai-kit, `plugins/motion/skills/motion`). Etkileşimli `npx motion-ai` yerine elle.
- `shadcn` skill (resmî, shadcn-ui/ui `skills/shadcn`, MIT): `components.json`'lı projede devreye girer.
- ObsidianUI: MCP'si yok; kayıt defteri `https://www.obsidianui.dev/r/{name}.json` (70 öğe, MIT,
  asıl repo Atharvsinh-codez/ObsidianUI). **Tehlike:** öğelerin çoğu shadcn temel bileşenleriyle aynı
  ad (button, card, dialog) → kurulursa üzerine yazar; skill'de koruma var.
- Bu sistem için yazılanlar: `bilesen-kaynaklari` (yönlendirme + kurulum öncesi koruma + lisans tablosu),
  `gorsel-dogrulama` (4 genişlik × açık/koyu; taşma + suçlu öğe, konsol, başarısız istek; çıkış
  kodu). İkincisi denetimde her projede elle yeniden yazılan betiğin kalıcı hali; bozuk ve temiz
  test sayfasıyla doğrulandı.

**Alınmadı (gerekçe):**
- Aceternity ve React Bits için topluluk MCP'leri: resmî değil; React Bits'in yazarı da shadcn
  MCP'sini öneriyor. Yerleşik kayıt defterleri yetiyor.
- Lucide MCP'leri: resmî yok, hepsi topluluk. Yerine skill'de `node_modules/lucide-react/dist/esm/icons/`
  ile ad doğrulama.
- Motion+ MCP (`/plus`, ücretli giriş, girişsiz 401) ve `motion-reviewer` alt ajanı.
- 21st: arama ücretsiz, kod `x-api-key` ister → anahtar yoksa ilham kaynağı olarak.

**Lisans:** Magic UI / ObsidianUI / shadcn MIT; React Bits MIT + Commons Clause (site içinde serbest,
bileşeni satmak/dağıtmak yok); Aceternity ücretsiz bileşenler için açık lisans metni bulunamadı.

**Düzeltilen çelişki:** `ui-ux-pro-max`'in "Step 2b" adımı `--persist` ile
`design-system/<slug>/MASTER.md`'yi "Global Source of Truth" yapıyordu, yani plugin87'yi reddetme
gerekçesinin aynısı (aynı token iki yerde). SKILL.md'ye yerel geçersiz kılma eklendi.

**Köken kaydı eksik olanlar:** `frontend-design` (Apache-2.0 LICENSE.txt; muhtemelen anthropics/skills),
`ui-ux-pro-max` (muhtemelen nextlevelbuilder), `tailwind-ui-refactor` ("Refactoring UI" kitabına
dayanır, kaynağı yazılmamış), `frontend-ui-engineering` (kaynak yok). Güncelleme gerektiğinde önce
kökeni bul, SKILL.md sonuna "Kaynak" bloğu ekle.

## 2026-10-04 taraması

**Alındı:**
- **EvilCharts** (legions-developer/evilcharts, MIT): `bilesen-kaynaklari`'na grafik kaynağı olarak.
  shadcn'in yerleşik listesinde `@evilcharts`; temiz Next 16 projesinde `add` + `next build` geçti.
  Kurallar: önce `dataviz`, Recharts sürümü, renk `chartConfig`'te, süs efektleri kapalı,
  pasta/radar/radyal/sankey'e elle reduced-motion.
- **logo-design** skill'i (kaankiziltug/logo-design-skill, MIT, commit `0ecf52e`). Betikler bağımlılıksız
  Python, ağ çağrısı yok (okundu). 14 MB logo kütüphanesi (`assets/library/`) dahil.

**Alınmadı:** `scroll-craft` (`frontend-sistemi` ile aynı işe ikinci estetik dayatır; gerçek bir landing
işinde projeye yerel kurulabilir), `token-monitor`, `montaj` (lansman videosu tarzı),
`youtube-automation-agent` (README'de memecoin adresi).

**Yan bulgu:** shadcn CLI bazı ağlarda üçüncü taraf kayıt defterlerine `Connect Timeout` veriyor (AAAA'sız
alan adında DNS ~12 sn, Node 10 sn'de vazgeçiyor). Çözüm `~/.claude/scripts/ipv4-dns.cjs` ön yüklemesi
(kurulum betiği oraya kopyalar); tarif `bilesen-kaynaklari` skill'inde.

## nothing-design: seçmeli stil olarak alındı (2026-10-06)

[dominikmartn/nothing-design-skill](https://github.com/dominikmartn/nothing-design-skill) (MIT, commit `74affbb`).
Repoda yalnız 4 markdown var, kod yok. Tetiklenmesi açık istekle sınırlı ("Nothing style"), yani hiçbir
projeye kendiliğinden bulaşmaz.

**Neden alındı:** zanaat kuralları somut ve stil dışında da işe yarıyor: üç katman, font bütçesi (2 aile, 3 boyut,
2 ağırlık), boşluk = anlam, kap stratejisi (boşluk → çizgi → kenar → kart), ekran başına tek kırılma. Segmentli
ilerleme çubuğu ve değere verilen durum rengi veri yoğun panellere çok uyuyor.

**Yerel geçersiz kılmalar** (SKILL.md sonunda): token kaynağı `DESIGN.md` (plugin87 ve `ui-ux-pro-max`'teki
gerekçenin aynısı); upstream'in kontrast oranları yanlış (`#666`/`#000` = 3,66:1, "4,0" yazıyor), bu yüzden
`--text-disabled` okunacak metne verilmez; Tailwind eşlemesi eksik, `@theme` tarifi eklendi; önizleme GIF'i
turuncu, token kırmızı → vurgu `DESIGN.md`'de seçilir; public projede "Nothing" adı geçmez.

**Çelişki:** global dark glassmorphism ile (gradient/blur/gölge yasağı, `#000` arkaplan). Seçim proje bazında,
`DESIGN.md`'de. **Alınmayan:** `preview.gif` (1,6 MB).
