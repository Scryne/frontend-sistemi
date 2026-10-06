---
name: baseline-ui
description: Quickly deslop UI code by fixing spacing, hierarchy, typography, and small layout issues. Use when the interface needs a fast cleanup or polish pass.
---

# Baseline UI

Enforces an opinionated UI baseline to prevent AI-generated interface slop.

## How to use

- `/baseline-ui`
  Apply these constraints to any UI work in this conversation.

- `/baseline-ui <file>`
  Review the file against all constraints below and output:
  - violations (quote the exact line/snippet)
  - why it matters (1 short sentence)
  - a concrete fix (code-level suggestion)

## Stack

- MUST use Tailwind CSS defaults unless custom values already exist or are explicitly requested
- MUST use `motion/react` (formerly `framer-motion`) when JavaScript animation is required
- SHOULD use `tw-animate-css` for entrance and micro-animations in Tailwind CSS
- MUST use `cn` utility (`clsx` + `tailwind-merge`) for class logic

## Components

- MUST use accessible component primitives for anything with keyboard or focus behavior (`Base UI`, `React Aria`, `Radix`)
- MUST use the project’s existing component primitives first
- NEVER mix primitive systems within the same interaction surface
- SHOULD prefer [`Base UI`](https://base-ui.com/react/components) for new primitives if compatible with the stack
- MUST add an `aria-label` to icon-only buttons
- NEVER rebuild keyboard or focus behavior by hand unless explicitly requested

## Interaction

- MUST use an `AlertDialog` for destructive or irreversible actions
- SHOULD use structural skeletons for loading states
- NEVER use `h-screen`, use `h-dvh`
- MUST respect `safe-area-inset` for fixed elements
- MUST show errors next to where the action happens
- NEVER block paste in `input` or `textarea` elements

## Animation

- NEVER add animation unless it is explicitly requested
- MUST animate only compositor props (`transform`, `opacity`)
- NEVER animate layout properties (`width`, `height`, `top`, `left`, `margin`, `padding`)
- SHOULD avoid animating paint properties (`background`, `color`) except for small, local UI (text, icons)
- SHOULD use `ease-out` on entrance
- NEVER exceed `200ms` for interaction feedback
- MUST pause looping animations when off-screen
- SHOULD respect `prefers-reduced-motion`
- NEVER introduce custom easing curves unless explicitly requested
- SHOULD avoid animating large images or full-screen surfaces

## Typography

- MUST use `text-balance` for headings and `text-pretty` for body/paragraphs
- MUST use `tabular-nums` for data
- SHOULD use `truncate` or `line-clamp` for dense UI
- NEVER modify `letter-spacing` (`tracking-*`) unless explicitly requested

## Layout

- MUST use a fixed `z-index` scale (no arbitrary `z-*`)
- SHOULD use `size-*` for square elements instead of `w-*` + `h-*`

## Performance

- NEVER animate large `blur()` or `backdrop-filter` surfaces
- NEVER apply `will-change` outside an active animation
- NEVER use `useEffect` for anything that can be expressed as render logic

## Design

- NEVER use gradients unless explicitly requested
- NEVER use purple or multicolor gradients
- NEVER use glow effects as primary affordances
- SHOULD use Tailwind CSS default shadow scale unless explicitly requested
- MUST give empty states one clear next action
- SHOULD limit accent color usage to one per view
- SHOULD use existing theme or Tailwind CSS color tokens before introducing new ones

## Yerel gecersiz kilmalar (frontend-sistemi)

Global varsayilan estetik (`frontend-sistemi` skill'i) **dark glassmorphism**: koyu gradient mesh
arkaplan (mor / neon mavi / sicak pembe), yari saydam cam paneller, 1px light-catcher kenar.
Bu, yukaridaki Design bolumundeki su kurallarin "unless explicitly requested" istisnasidir —
talep zaten `frontend-sistemi` skill'inde yazili, her projede yeniden istenmesi gerekmez:

- `NEVER use gradients` → **gecersiz** sayfa/bolum arkaplani icin. Gradient mesh zorunlu;
  duz tek renk arkaplan cam efektini oldurur. Kural component yuzeylerinde (buton, kart
  dolgusu, metin) gecerli kalir.
- `NEVER use purple or multicolor gradients` → **gecersiz** ayni kapsamda. Mor/mavi/pembe
  mesh varsayilan paletin kendisi.
- `NEVER use glow effects as primary affordances` → **gecerli kalir**. Glow dekoratiftir;
  tiklanabilirligi glow ile anlatma, kenar + kontrastla anlat.

Geri kalan her kural (`h-dvh`, `size-*`, `text-balance`, sabit z-index olcegi, `cn`,
kompozitör-disi animasyon yasagi, `backdrop-filter` animasyonu yasagi) aynen gecerlidir ve
glassmorphism kurallariyla zaten ortusur.

Projeye ozel palet/tipografi `DESIGN.md`'de yasar ve bu varsayilani ezebilir; celiski
oldugunda `DESIGN.md` kazanir.

---

## Kaynak

Upstream: [ibelick/ui-skills](https://github.com/ibelick/ui-skills) (MIT), `skills/baseline-ui`.
Vendor edildi: 2026-09-05. Yeniden senkronlamak icin upstream ile diffle; asagidaki
"Yerel gecersiz kilmalar" bolumu (varsa) bize ait, ustune yazma.
