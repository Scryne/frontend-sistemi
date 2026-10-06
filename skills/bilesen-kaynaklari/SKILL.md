---
name: bilesen-kaynaklari
description: Bir UI parçasının hangi kaynaktan geleceğine karar verir ve dış bileşen kurulumunu güvenli yapar — shadcn temel bileşenleri, efekt kayıt defterleri (Magic UI, Aceternity, React Bits, ObsidianUI), 21st.dev, Motion, grafikler (EvilCharts) ve Lucide ikonları. Bir bileşen, grafik, animasyon, arka plan efekti, landing/portfolyo bölümü eklenirken; "şu efekti bul/kur", "marquee, bento, hero animasyonu" gibi isteklerde veya bir projeye components.json kurulurken kullan.
---

# Bileşen kaynakları: ne nereden gelir

Temel kural: **önce var olanı kullan, sonra uyarla, en son yaz.** Ama dışarıdan gelen her
bileşen projenin `DESIGN.md` token'larına çekilir; olduğu gibi bırakılan efekt, makine üretimi
arayüzün en tanıdık imzasıdır (`design-taste`).

## Yönlendirme

| İhtiyaç | Kaynak | Araç |
|---|---|---|
| Temel parça: button, form, dialog, table, sidebar, tabs | `@shadcn` | `shadcn` skill + shadcn MCP |
| Pazarlama/portfolyo efekti: marquee, metin animasyonu, arka plan, bento, logo bulutu | `@magicui`, `@aceternity`, `@react-bits`, `@obsidianui` | shadcn MCP / CLI; Magic UI için ayrıca `magicui` MCP |
| Grafik: alan, çizgi, çubuk, pasta, radar, radyal, sankey | `@evilcharts` (Recharts sürümleri) | shadcn CLI; önce `dataviz` skill'i, aşağıdaki bölüm |
| Yukarıda olmayan bir desen, fikir ve önizleme | 21st.dev | `21st` MCP (`search` ücretsiz) |
| Animasyonu yazmak/incelemek | Motion | `motion` skill + `motion` MCP (doküman araması ücretsiz) |
| Animasyon performans denetimi | — | `fixing-motion-performance` (MotionScore Motion+ ister, bizde yok) |
| İkon | Lucide (`lucide-react`, projenin `iconLibrary`'si) | aşağıdaki doğrulama |

Uygulama arayüzünde (panel, form, tablo, ayarlar) efekt kayıt defterleri kullanılmaz;
orası temel bileşen ve token işidir. Efektler tanıtım yüzeyleri içindir. Grafik bu kuralın
dışındadır: panelin parçasıdır, ama süsü değil veriyi taşır (aşağıda).

## Projede kurulum: components.json

Yerleşik ad alanları (`@magicui`, `@aceternity`, `@react-bits`) CLI'de ayarsız çalışır, ama
**shadcn MCP araması yalnız `components.json`'da yazılı kayıt defterlerini görür** (2026-09-28'de
ölçüldü: yazılı değilken `Unknown registry "@magicui"`). `shadcn init`'ten sonra ekle:

```json
"registries": {
  "@magicui": "https://magicui.design/r/{name}",
  "@aceternity": "https://ui.aceternity.com/registry/{name}.json",
  "@react-bits": "https://reactbits.dev/r/{name}.json",
  "@obsidianui": "https://www.obsidianui.dev/r/{name}.json",
  "@evilcharts": "https://evilcharts.com/r/{name}.json"
}
```

**`Connect Timeout` hatası alırsan.** Bazı ağlarda (router AAAA sorgusuna cevap vermiyorsa) AAAA kaydı olmayan alan adlarında DNS ~12 sn sürüyor, Node'un fetch'i
10 sn'de vazgeçiyor; shadcn CLI `evilcharts.com`, `magicui.design` gibi kayıt defterlerine ulaşamıyor (2026-10-04
ölçüldü, curl aynı anda çalışıyor). Komutun önüne IPv4 ön yüklemesini koy:

```bash
NODE_OPTIONS="--require $HOME/.claude/scripts/ipv4-dns.cjs" npx shadcn@latest add @evilcharts/recharts-line-chart
```

React Bits her bileşeni dört türde yayınlar; Tailwind + TypeScript projesinde `-TS-TW` sonekli
olanı seç (ör. `@react-bits/TextLoop-TS-TW`).

## Kurmadan önce (her seferinde)

1. **Ad çakışması.** `npx shadcn add` dosyayı `components/ui/<ad>`'a yazar ve aynı adlı dosyanın
   üzerine yazar. ObsidianUI'nin 70 öğesinin çoğu shadcn temel bileşenleriyle aynı adı taşır
   (button, card, dialog, input…). Efekt kayıt defterinden **temel bileşen adıyla kurma**;
   önce `npx shadcn@latest view @kayit/ad` ile hangi dosyaları yazacağına bak.
2. **Kodu oku.** Üçüncü taraf kayıt defterleri shadcn tarafından denetlenmez. `view` çıktısında
   eklenen bağımlılıklara (three.js, gsap, ağır paketler), ağ çağrılarına ve `dangerouslySetInnerHTML`'e
   bak.
3. **Hareket azaltma.** Kayıt defteri bileşenlerinin çoğu `prefers-reduced-motion`'a bakmaz.
   Kurduktan sonra ekle: Motion'da `useReducedMotion`, CSS'te
   `@media (prefers-reduced-motion: reduce)`.
4. **Token'a çek.** Sabit renkleri, gölgeleri, degradeleri `DESIGN.md` token'larıyla değiştir.
   Varsayılan "spotlight / beam / meteor / parlayan kart" görünümü bırakılmaz.
5. **Ölçü.** Bir görünüm alanında en fazla bir gösteriş efekti. Kat altındaki ağır efekt
   (canvas, WebGL, çok katmanlı blur) tembel yüklenir; bitince `fixing-motion-performance`.

## Grafikler: EvilCharts

shadcn'in yerleşik kayıt listesinde (`@evilcharts`, CLI ayarsız çözer); MIT, Next 16 + React 19 + Tailwind 4 ile
yazılmış. 14 Recharts + 13 ECharts grafiği, 230 örnek (`ex-…`), 25 hazır panel bloğu. 2026-10-04 spike'ı: temiz
`create-next-app` + `shadcn init` + `add @evilcharts/recharts-line-chart` → 7 dosya `components/evilcharts/` altına,
`recharts` + `motion` bağımlılığı, `next build` geçti.

1. **Önce `dataviz`.** Grafik türü, renk ve etiket kararı oradan gelir; EvilCharts yalnız çizimi verir.
2. **Recharts sürümünü seç.** ECharts dosyaları ~2.000 satır ve `echarts` paketi ağır; sankey dahil her türün
   Recharts karşılığı var. ECharts yalnız Recharts'ın kaldıramadığı veri boyutunda.
3. **Renk `chartConfig`'te.** Her seri `colors: { light: [...], dark: [...] }` alır; buraya `DESIGN.md`/dataviz
   paletini yaz, örneklerdeki yeşil-kırmızıyı bırakma (renk körlüğünde ayrışmaz).
4. **Süsü kapat.** Kayıt defterinin vitrini efekt: `glowing`, `hatched`/`dotted` alan, `animated-dashed` çizgi,
   `ping` nokta, gradyan. Bunlar veri taşımıyorsa kullanılmaz; varsayılan düz çizgi/alan yeter.
5. **Hareket azaltma.** Çizgi, alan, çubuk ve bileşik grafik OS ayarına bakıyor; **pasta, radar, radyal ve sankey
   bakmıyor** (2026-10-04, kaynak kodda `prefers-reduced-motion` yok). Bunlarda `useReducedMotion` ile
   `isAnimationActive={!azalt}` ver.
6. **Ad çakışması yok.** Dosyalar `components/evilcharts/` altına yazılır, shadcn'in `chart.tsx`'ine dokunmaz.
   `<style dangerouslySetInnerHTML>` yalnız `chartConfig`'ten CSS değişkeni üretir (shadcn `chart` ile aynı desen).

## 21st.dev

`search` ve önizleme ücretsiz; bileşen kodu (`get_component`, `?api_key=$API_KEY_21ST`) ücretli
ve bu makinede `API_KEY_21ST` tanımlı değil. Yani 21st bir **ilham ve karşılaştırma**
kaynağı: bulunan deseni önizlemesine bakarak kendi bileşenlerinle kur, anahtar yokken kod
getirmeye çalışma.

## Lucide ikonları

Resmî bir Lucide MCP'si yok; topluluk sunucuları bilerek kurulmadı. Model ikon adlarını çoğu zaman
doğru bilir ama olmayan bir ad TypeScript'te sessizce `undefined` render edebilir. Kullanmadan
önce doğrula:

```bash
ls node_modules/lucide-react/dist/esm/icons/ | grep -i "<aranan>"   # kebab-case, .mjs
```

Stil: tek ikon ailesi, `strokeWidth` proje genelinde sabit, shadcn bileşeni içindeyse boyut
sınıfı yok (`shadcn` skill'i, `rules/icons.md`).

## Lisans

| Kaynak | Lisans | Anlamı |
|---|---|---|
| shadcn/ui, Magic UI, ObsidianUI, EvilCharts | MIT | serbest |
| React Bits | MIT + Commons Clause | site/ürün içinde serbest; bileşenleri kütüphane olarak satmak/dağıtmak yok |
| Aceternity UI (ücretsiz) | açık lisans metni bulunamadı (2026-09-28) | yalnız son ürün içinde kullan, yeniden dağıtma |
| 21st.dev | bileşen başına yazarına göre | kodu alınırsa bileşen sayfasındaki lisansa bak |

## Kaynak

frontend-sistemi için yazıldı (2026-09-28); EvilCharts ve DNS notu 2026-10-04. Ölçümler: shadcn CLI 4.21.0 yerleşik kayıt defteri
listesi (`ui.shadcn.com/r/registries.json`, 382 kayıt), ObsidianUI `r/registry.json` (70 öğe),
lisanslar ilgili GitHub repolarından. Karar kaydı: `~/.claude/skills/frontend-sistemi/KAYNAKLAR.md`.
