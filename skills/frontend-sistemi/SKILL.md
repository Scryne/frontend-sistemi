---
name: frontend-sistemi
description: Global frontend sistemi — varsayılan estetik (dark glassmorphism), UI işinde hangi skill/MCP'nin hangi sırayla devreye girdiği, DESIGN.md kuralı. Herhangi bir UI/arayüz, sayfa, component, stil, landing, dashboard veya tasarım işine başlamadan önce yükle; küçük stil düzeltmesi dahil.
---

## Global Frontend Sistemi

Aşağıdaki kurallar frontend (UI) işi yapılan her projede geçerlidir.

## Varsayılan estetik: Dark Glassmorphism

Kullanıcı aksini belirtmedikçe yeni arayüz tasarlarken bu dil kullanılır.

**Arkaplan:** Saf siyah (#000) değil, koyu gradient mesh — derin mor, neon mavi, sıcak pembe
tonları arasında. Camın "arkasında bir şey" olmalı, düz tek renk arkaplan cam efektini öldürür.
Işık kaynağı tutarlı olsun: sol-üst daha açık, sağ-alt daha koyu (alpha-channel gradient).

**Cam panel:**
- `backdrop-filter: blur(...)` — 10-20px arası, 12px iyi bir başlangıç. Az blur cam hissini
  vermez, çok blur okunabilirliği öldürür.
- Panel arkaplanı: yarı saydam, `rgba(255,255,255,0.05–0.1)` (açık cam) veya koyu tint
  (`rgba(0,0,0,0.2-0.3)`), arkaplan karmaşıklığına göre ayarlanır.
- Kenar ("light catcher" border): 1px, `rgba(255,255,255,0.1)` — camın kenarından ışık
  yansıyormuş hissi verir.
- Metin: beyaz/açık gri, üstüne hafif 1px text-shadow — bulanık yüzeyden ayrışsın.
- Kontrast: WCAG asgari 4.5:1 (normal metin), 3:1 (büyük metin). Blur doğal olarak kontrastı
  düşürür, gerekirse arkaplan tint'i artırılarak telafi edilir.

**Nerede kullanılır, nerede kullanılmaz:** Sadece kilit elementlerde — navigasyon çubuğu, ana
aksiyon butonları, modal/overlay, öne çıkan kartlar, bildirim yüzeyleri. Her component'e,
tüm sayfa arkaplanına ya da ikincil UI elementlerine sürülmez — aşırı kullanım camı sıradanlaştırır
ve performansı düşürür.

**Performans:** `backdrop-filter` animasyonu pahalıdır, animasyonlu bulanıklaştırmadan kaçın.
Statik blur mümkünse önceden render edilir. Arkaplan hareketliyse GPU compositing için
`will-change: transform` veya `transform: translateZ(0)` kullanılır. Aynı anda çok sayıda
blur'lu katman üst üste bindirilmez.

**Erişilebilirlik:** `backdrop-filter` desteklemeyen tarayıcılar için daha opak solid fallback
renk tanımlanır. Etkileşimli alanların sınırları border ile net çizilir (sadece blur'a
güvenilmez). Koyu tema varsayılan olsa da kontrast her component'te ayrıca test edilir.

## Frontend işinde otomatik kullanılacak araçlar

UI/arayüz oluşturma, düzenleme veya inceleme işi yapılırken şunlar devreye girer, kullanıcıdan
ayrıca istenmesi beklenmez:

**Yön ve kimlik**
- **`frontend-design` skill** — estetik yön, tipografi, "şablon gibi durmayan" tasarım kararları.
- **`ui-ux-pro-max` skill** — palet, ikon, chart, stack-özel UI implementasyon kararları.
  `--persist`/`MASTER.md` kullanılmaz; kararlar `DESIGN.md`'ye işlenir.
- **`create-design-md` skill** — projenin `DESIGN.md` kimlik dosyasını mevcut koddan (veya bir
  URL'den) kanıta dayanarak üretir/günceller.
- **`design-taste` skill** — anti-slop yargı katmanı: üretmeden önce brief'i adlandır (mood,
  layout ailesi, motion derinliği), makine-üretimi arayüzün tekrarlayan "tell"lerini bilerek
  kır. `frontend-design` yönü verir, bu skill o yönün ortalamaya kaymasını engeller.
- **`logo-design` skill** — logo, marka işareti, favicon, uygulama ikonu: brief → konsept → SVG →
  16 px / tek renk / raf testi → teslim varyantları. Yalnız marka işi istendiğinde (2026-10-05).
- **`nothing-design` skill** — seçmeli alternatif stil (monokrom, tipografik, endüstriyel; veri
  yoğun dashboard'a uygun). Glassmorphism'le çelişir; yalnız kullanıcı "Nothing stili" dediğinde ya da
  projenin `DESIGN.md`'si bu stili seçtiğinde. Token'lar `DESIGN.md`'ye yazılır (2026-10-06).

**İnşa**
- **`bilesen-kaynaklari` skill** — hangi parça nereden gelir: temel bileşen `@shadcn`,
  tanıtım efekti `@magicui`/`@aceternity`/`@react-bits`/`@obsidianui`, ilham 21st, animasyon
  Motion, ikon Lucide. Kurulum öncesi koruma (ad çakışması, kod okuma, hareket azaltma, token'a
  çekme, lisans) ve projeye eklenecek `components.json` kayıt defterleri burada.
- **`shadcn` skill + `shadcn` MCP** — resmî skill (`components.json` olan projede devreye
  girer, proje bağlamını `shadcn info`'dan okur) ve kayıt defterlerinden arama/kurulum.
- **`magicui` MCP** — Magic UI kayıt defterini `components.json` olmadan da gezer.
- **`21st` MCP** — ilham ve önizleme (arama ücretsiz; kod API anahtarı ister, bizde yok).
- **`motion` skill + `motion` MCP** — animasyon yazımı, Motion dokümanı, CSS spring.
- **`baseline-ui` skill** — AI-slop karşıtı sert stack kontratı (`h-dvh`, `size-*`,
  `text-balance`, sabit z-index ölçeği, `cn`, erişilebilir primitive zorunluluğu). İnşa
  sırasında sürekli açık kalır, sonda bir kez uygulanmaz.

**Sertleştirme (yazılan koda uygulanır)**
- **`frontend-ui-engineering` skill** — production-kalite, responsive, state yönetimi.
- **`fixing-accessibility` skill** — hedefli WCAG denetimi: erişilebilir isim, klavye, focus
  trap, kontrast, form hataları. Minimal ve noktasal düzeltme yapar, UI'ı yeniden yazmaz.
- **`fixing-motion-performance` skill** — animasyon jank'i: compositor vs layout/paint,
  scroll-linked motion, `blur()`/`backdrop-filter` maliyeti. Glassmorphism kullanan
  projede yeni ekran ya da animasyon eklendiğinde zorunlu geçiş.
- **`fixing-metadata` skill** — title/description/canonical, OG + Twitter card, favicon,
  JSON-LD, robots. Herkese açık sayfa yayınlanmadan önce çalıştır.
- **`ux-writing` skill** — arayüz metni: buton, hata (what→why→how), boş durum, onay
  diyaloğu ("Delete account", "Delete" değil), bildirim. Kod bittiğinde metin bitmiş sayılmaz.
- **`tailwind-ui-refactor` skill** — Tailwind class'ları üzerinde son cila (hierarchy,
  spacing, depth).
- **`gorsel-dogrulama` skill** — çalışan arayüzü 4 genişlik × açık/koyu temada açar; taşma,
  konsol hatası, başarısız istek, ekran görüntüsü. Çıkış kodu 0 olmadan UI işi "bitti" değildir.

**Denetim (mevcut bir arayüzü iyileştirirken)**
- **`improve-ui` skill** — ürün kaynağına dokunmadan yüzeyi kendi tasarım kanıtına karşı
  denetler, `design-plans/` altına bağımsız uygulama planları yazar. "Bu ekranı toparla",
  "design-system drift var mı" tipi işlerin başlangıç noktası.

**Sıra (yeni arayüz):** `DESIGN.md` var mı kontrol et (yoksa `create-design-md`) → yön belirle
(`frontend-design` + `design-taste`) → `baseline-ui`'ı bağlama al → component'i kur
(`bilesen-kaynaklari` yönlendirir; animasyon `motion`) → palet/UX doğrula (`ui-ux-pro-max`) →
production kalitesi (`frontend-ui-engineering`) → metni yaz (`ux-writing`) → denetim pasları
(`fixing-accessibility`, animasyon varsa `fixing-motion-performance`, public sayfaysa
`fixing-metadata`) → Tailwind ise son cila (`tailwind-ui-refactor`) → `gorsel-dogrulama`.

**Sıra (mevcut arayüz):** `improve-ui` ile denetle ve plan çıkar → planı uygula → aynı denetim
paslarından geçir → `gorsel-dogrulama`.

**Ölçek:** tam sıra yeni ekran/sayfa içindir. Küçük değişiklikte (tek component, stil düzeltmesi,
metin) `DESIGN.md` token'larına uy, `baseline-ui`'ı açık tut, yalnız dokunulan alana denk düşen
denetim pasını çalıştır (form/dialog → `fixing-accessibility`, animasyon → `fixing-motion-performance`,
metin → `ux-writing`) ve `gorsel-dogrulama`'yı yalnız dokunulan rotayla koş. On skill'i küçük
işe yüklemek bağlamı doldurur, işi sulandırır.

## Proje-özel frontend kimliği: DESIGN.md

Yukarıdaki kurallar **taban disiplin** — sabit, her projede aynı. Ama hiçbir proje bir
öncekinin reskin'i gibi durmamalı: her projenin **proje kökünde `DESIGN.md`** dosyası olur
(accent renk paleti, tipografi eşleşmesi, mood, farklılaştırıcı detay — `ui-ux-pro-max`
skill'inin palet/font verisiyle belirlenir). **Frontend işine başlamadan önce bu dosyanın var
olduğunu ve doldurulmuş olduğunu kontrol et; yoksa veya yer tutucu içeriyorsa önce onu
oluştur, sonra inşaata geç.**

Boş şablon: `~/.claude/skills/frontend-sistemi/templates/DESIGN.md` (proje köküne kopyala, yer tutucuları doldur).

Format Google'ın DESIGN.md spec'i (alpha): YAML frontmatter normatif token'ları taşır,
Markdown gövdesi gerekçe ve uygulama rehberliğini. `create-design-md` skill'i bu dosyayı
üretir ve doğrular:

```bash
npx -p @google/design.md designmd lint DESIGN.md
npx -p @google/design.md designmd export --format css-tailwind DESIGN.md   # Tailwind v4
```

Windows'ta `npx @google/design.md` takılır: bin adı `design.md`, kökteki `DESIGN.md` dosyasını açmaya
çalışır. Bin'i `designmd` adıyla çağır (üç ayrı projede ölçüldü, 2026-09/10).

Kural: **kesin değerler frontmatter'da, gerekçe Markdown'da.** Aynı token iki yerde yaşamaz.
`DESIGN.md` ile global varsayılan estetik çeliştiğinde `DESIGN.md` kazanır.

**Miras:** 2026-09-05 öncesi kurulan projelerde bu dosya `docs/Design.md` adıyla ve serbest
metin olarak duruyor. Olduğu yerde bırak; o projede frontend işine dönüldüğünde
`create-design-md` ile köke taşınıp spec'e çevrilir. İki dosyayı aynı anda canlı tutma.

## Referans

Glassmorphism kaynakları, vendor edilen skill'lerin kökeni (ibelick/ui-skills) ve **bilerek
alınmayan** paketler (mattpocock/skills, plugin87/ux-ui-agent-skills'in çoğu, gerekçeleriyle):
bu skill'in yanındaki `KAYNAKLAR.md` (`~/.claude/skills/frontend-sistemi/KAYNAKLAR.md`). "Şu skill paketini kuralım mı"
sorusu gelirse önce orayı oku.
