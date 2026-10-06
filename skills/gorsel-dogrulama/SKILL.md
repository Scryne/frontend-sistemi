---
name: gorsel-dogrulama
description: Çalışan bir web arayüzünü gerçek tarayıcıda dört ekran genişliğinde (390/768/1280/1440) ve açık/koyu temada açar; yatay taşmayı ve taşan öğeyi, konsol hatalarını, başarısız istekleri raporlar ve tam sayfa ekran görüntüsü alır. Bir UI işini "bitti" demeden önce, "mobilde bozuk mu", "ekran görüntüsü al", "taşma var mı", "konsol hatası var mı" dendiğinde veya bir frontend denetiminde kullan.
---

# Görsel doğrulama

Testlerin yeşil olması arayüzün doğru göründüğünü kanıtlamaz. 2026-09'da on projelik bir denetimde
bu kontrol her projede elle yeniden yazıldı ve her seferinde testlerin görmediği bir şey buldu
(bir soy ağacı sayfasında 415 px mobil taşma, bir panelde üç sayfada yatay taşma, bir başkasında her
oturumlu sayfada +241 px). Bu skill o kontrolü tek komuta indirir.

## Çalıştır

Sunucu açıkken (dev ya da `build && start`):

```bash
node ~/.claude/skills/gorsel-dogrulama/scripts/dogrula.mjs http://localhost:3000 \
  --rotalar /,/projeler,/iletisim --cikti gorsel-dogrulama
```

| Seçenek | Varsayılan | Not |
|---|---|---|
| `--rotalar` | `/` | virgülle; kök URL'ye göre |
| `--genislik` | `390,768,1280,1440` | telefon, tablet, dizüstü, masaüstü |
| `--tema` | `light,dark` | `prefers-color-scheme` ile |
| `--cikti` | `./gorsel-dogrulama` | PNG'ler + `rapor.json` |
| `--bekle` | `800` | ms; animasyon/yükleme oturması için |

Tarayıcı olarak kurulu Microsoft Edge denenir, açılmazsa Playwright Chromium'una düşer (kurulum betiği indirir). Başka bir Chromium için
`DOGRULA_TARAYICI=<yol>`. `file://` adresi de verilebilir.

## Sonucu okumak

- `SORUN` satırı: açılmadı / `taşma +Npx` (ilk üç taşan öğe seçicisiyle) / konsol hatası /
  4xx-5xx ya da başarısız istek. **Çıkış kodu 1** — "bitti" demeden önce 0 olmalı.
- `uyarı`: sayfa hatası sayılmayan eksikler (ör. favicon → `fixing-metadata`).
- Sayılar yetmez: **PNG'lere bak.** Üst üste binen metin, kesilen başlık, okunmayan kontrast,
  boş kalan grafik taşma ölçüsüne düşmez. En azından 390 px ve 1440 px karelerini aç.
- Ölçüm tek başına hüküm değil: kasıtlı yatay kaydırma alanı (tablo, karusel) `overflow-x:auto`
  içindeyse taşma sayılmaz; sayılıyorsa kapsayıcı yanlış.

## Ne zaman

- Yeni ekran/sayfa bitince (`frontend-sistemi` skill'indeki sıranın denetim adımı).
- Stil değişikliğinden sonra yalnız dokunulan rotayla.
- Tema, font, düzen kütüphanesi yükseltmesinden sonra bütün rotalarla.

## Kaynak

frontend-sistemi için yazıldı (2026-09-28); 2026-09 denetimindeki tek seferlik ekran görüntüsü ve
taşma teşhisi betiklerinin ortak hali. Bağımlılık: `scripts/node_modules/playwright-core`
(tarayıcısız paket; kurulum betiği `npm install` yapar).
