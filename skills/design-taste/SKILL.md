---
name: design-taste
description: Anti-slop judgment layer for UI work — name the brief before generating, break the recurring tells of machine-generated interfaces (repeated section rhythm, equal-weight card triplets, centered everything, generic drop shadows, rainbow accents), and choose motion that means something. Use when starting a new screen or page, when a design "looks AI-generated" or templated, or when reviewing whether a UI reads as intentional rather than default.
---

# Design Taste

Tokens, components and accessibility make a design *correct*. Taste makes it *intentional*.
This skill is the judgment layer that sits between direction-setting and building.

## Nasil kullanilir

1. **Once brief'i adlandir, sonra uret.** `references/design-taste.md` icindeki "Brief Inference"
   adimi zorunlu: sektor/alan, kitle ve ton, mood (kazanilmasi gereken sifat), motion derinligi,
   layout ailesi, referans capasi. Mood'u ve layout ailesini adlandiramiyorsan ortalamaya
   geri dusersin.
2. **Slop tell tablosunu gec.** Ayni dosyadaki "Statistical Slop" tablosu her satirda bir
   kusur ve onun karsiligini veriyor. Bunlari baslangic noktasi degil, **kirilacak kusur**
   olarak oku.
3. **Motion'a karar veriyorsan** `references/motion-choreography.md`'ye bak: hangi hareket
   ne anlatiyor, sure ve easing secimleri, `prefers-reduced-motion`.
4. Sonucu uretmeden once plani brief'e karsi bir kez elestir.

## Sinirlar

- Bu skill **estetik yargi** katmanidir; erisilebilirlik, kullanici ihtiyaci ve tutarlilik
  onun ustundedir. Kontrast dusuren veya bir pattern'i kiran "guzel" karar basarisiz karardir.
- Somut deger uretmez. Palet/tipografi verisi icin `ui-ux-pro-max`, projenin kendi kimligi
  icin kokteki `DESIGN.md` kullanilir. Celiski oldugunda `DESIGN.md` kazanir.
- Global `~/.claude/CLAUDE.md`'deki dark glassmorphism varsayilani bu skill'in genel
  "gradient/aksan rengi kisitla" tavsiyelerini **arkaplan icin** ezer; kisitlama component
  yuzeylerinde ve aksan renklerinde gecerli kalir (ayni istisna `baseline-ui`'da da yazili).

## Referanslar

- `references/design-taste.md` — anti-slop doktrini, brief cikarimi, spatial rhythm,
  variance mandate, tipografi kullanimi.
- `references/motion-choreography.md` — hareketin anlami, sure/easing, reduced-motion.

---

## Kaynak

Upstream: [plugin87/ux-ui-agent-skills](https://github.com/plugin87/ux-ui-agent-skills) (MIT
— package.json ve README rozetine gore; repoda LICENSE dosyasi yok), `taste/`.
Vendor edildi: 2026-09-05. Upstream'de bunlar skill degil duz referans dosyalariydi; bu
SKILL.md bize ait. Referans dosyalarindaki `tokens/*.json`, `taste/aesthetic-systems.md`,
`content/voice-tone.md`, `accessibility/aria-patterns.md` yollari bizim karsiliklarimizla
(`DESIGN.md` frontmatter, `ui-ux-pro-max`, `ux-writing`, `fixing-accessibility`) degistirildi.
