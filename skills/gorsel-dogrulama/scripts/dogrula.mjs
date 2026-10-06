// Görsel doğrulama: rotaları dört genişlikte, açık/koyu temada açar; yatay taşmayı (ve taşan
// öğeyi), konsol hatalarını, sayfa hatalarını ve başarısız istekleri raporlar, tam sayfa PNG alır.
//
// node dogrula.mjs <kök-url> [--rotalar /,/hakkinda] [--genislik 390,768,1280,1440]
//                  [--tema light,dark] [--cikti klasor] [--bekle ms]
// Tarayıcı: Microsoft Edge (Windows'ta kurulu), açılmazsa Playwright Chromium. Başka Chromium için DOGRULA_TARAYICI=yol.
// Çıkış kodu: sorun varsa 1 — CI'da ya da "bitti" demeden önce kapı olarak kullanılabilir.
import { chromium } from 'playwright-core';
import { mkdirSync, writeFileSync } from 'node:fs';
import { join, resolve } from 'node:path';

const argv = process.argv.slice(2);
const kok = argv[0] && !argv[0].startsWith('--') ? argv[0] : null;
const al = (ad, vars) => { const i = argv.indexOf(`--${ad}`); return i >= 0 ? argv[i + 1] : vars; };
const KULLANIM = 'kullanım: node dogrula.mjs <kök-url> [--rotalar /,/x] [--genislik 390,768,1280,1440] [--tema light,dark] [--cikti klasor] [--bekle ms]';
if (argv.includes('--help') || argv.includes('-h')) { console.log(KULLANIM); process.exit(0); }
if (!kok) {
  console.error(KULLANIM);
  process.exit(2);
}
const rotalar = al('rotalar', '/').split(',');
const genislikler = al('genislik', '390,768,1280,1440').split(',').map(Number);
const temalar = al('tema', 'light,dark').split(',');
const cikti = resolve(al('cikti', 'gorsel-dogrulama'));
const bekle = Number(al('bekle', '800'));
mkdirSync(cikti, { recursive: true });

const url = (rota) => (kok.startsWith('file:') ? kok : new URL(rota, kok.endsWith('/') ? kok : kok + '/').href);
const ad = (rota, g, t) => `${(rota.replace(/[^a-z0-9]+/gi, '_').replace(/^_|_$/g, '') || 'kok')}-${g}-${t}.png`;

// Edge güncellemesi channel'ı bozarsa Playwright'ın kendi Chromium'una düş (ms-playwright kurulu).
async function tarayiciAc() {
  if (process.env.DOGRULA_TARAYICI) return chromium.launch({ executablePath: process.env.DOGRULA_TARAYICI });
  try { return await chromium.launch({ channel: 'msedge' }); }
  catch (e) {
    console.error('Edge açılamadı, Playwright Chromium deneniyor: ' + e.message.split('\n')[0]);
    return chromium.launch();
  }
}
const tarayici = await tarayiciAc();
const sonuclar = [];
for (const tema of temalar) {
  for (const g of genislikler) {
    const baglam = await tarayici.newContext({ viewport: { width: g, height: 900 }, colorScheme: tema, deviceScaleFactor: 1 });
    for (const rota of rotalar) {
      const s = await baglam.newPage();
      const konsol = [];
      const istek = [];
      const uyari = [];
      s.on('console', (m) => {
        if (m.type() !== 'error') return;
        // Tarayıcının kendiliğinden istediği /favicon.ico eksikse sayfa hatası değil, uyarı.
        if (/\/favicon\.ico$/.test(m.location()?.url || '')) { uyari.push('favicon yok (fixing-metadata)'); return; }
        konsol.push(m.text().slice(0, 200));
      });
      s.on('pageerror', (e) => konsol.push('SAYFA: ' + e.message.slice(0, 200)));
      s.on('response', (r) => { if (r.status() >= 400) istek.push(`${r.status()} ${r.url().slice(0, 140)}`); });
      s.on('requestfailed', (r) => {
        // Next 16 segment prefetch'i önce sayfaya HEAD atar; Chromium gövdesiz yanıtı ERR_ABORTED
        // diye raporlar ama ardından segment istekleri 200 döner (2026-09-28). Hata değil.
        if (r.method() === 'HEAD' && r.failure()?.errorText === 'net::ERR_ABORTED') return;
        istek.push(`HATA ${r.failure()?.errorText} ${r.url().slice(0, 140)}`);
      });
      let acilis = null;
      try { await s.goto(url(rota), { waitUntil: 'networkidle', timeout: 45000 }); } catch (e) { acilis = e.message.split('\n')[0]; }
      await s.waitForTimeout(bekle);
      const tasma = await s.evaluate(() => {
        const w = document.documentElement.clientWidth;
        const fazla = document.documentElement.scrollWidth - w;
        const suclular = [];
        if (fazla > 0) {
          for (const el of document.querySelectorAll('body *')) {
            const r = el.getBoundingClientRect();
            if (r.width && r.right > w + 1 && getComputedStyle(el).position !== 'fixed') {
              const id = el.id ? '#' + el.id : '';
              const cls = typeof el.className === 'string' && el.className ? '.' + el.className.trim().split(/\s+/).slice(0, 2).join('.') : '';
              suclular.push(`${el.tagName.toLowerCase()}${id}${cls} (+${Math.round(r.right - w)}px)`);
              if (suclular.length >= 3) break;
            }
          }
        }
        return { fazla, suclular };
      });
      const dosya = ad(rota, g, tema);
      await s.screenshot({ path: join(cikti, dosya), fullPage: true }).catch(() => {});
      const sorun = Boolean(acilis) || tasma.fazla > 0 || konsol.length > 0 || istek.length > 0;
      sonuclar.push({ rota, genislik: g, tema, acilis, tasma, konsol, istek, uyari, dosya, sorun });
      console.log(`${sorun ? 'SORUN' : 'tamam'}  ${rota} ${g}px ${tema}` +
        (acilis ? `  açılmadı: ${acilis}` : '') +
        (tasma.fazla > 0 ? `  taşma +${tasma.fazla}px ${tasma.suclular.join(', ')}` : '') +
        (konsol.length ? `  konsol ${konsol.length}: ${konsol[0]}` : '') +
        (istek.length ? `  istek ${istek.length}: ${istek[0]}` : '') +
        (uyari.length ? `  uyarı: ${[...new Set(uyari)].join(', ')}` : ''));
      await s.close();
    }
    await baglam.close();
  }
}
await tarayici.close();
writeFileSync(join(cikti, 'rapor.json'), JSON.stringify(sonuclar, null, 2));
const sorunlu = sonuclar.filter((x) => x.sorun).length;
console.log(`\n${sonuclar.length} kare, ${sorunlu} sorunlu · ${cikti}`);
process.exit(sorunlu ? 1 : 0);
