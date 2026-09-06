# Nestbau – Design-System (v2.0)

Kurzfassung. Vollständig: `Nestbau/DESIGN-GUIDE.md` im Repo. Chronologie der UI-Entscheidungen: [[Learnings]].

## Farbpalette (food-inspired, warm)

| Rolle | Hex |
|-------|-----|
| Primary Orange (`--flame`) | `#FF8C42` |
| Peach / Amber (`--amber`) | `#FFB84D` |
| Green / Teal (`--teal`) | `#A8D5BA` |
| Dark Green | `#7EC483` |
| Maroon (Error/Wichtig) | `#D64045` |
| BG light | `#fafaf8` · Surface `#ffffff` · Sunken `#f5f3f0` |
| Text light | `#1f2420` / soft `#6b6f68` |
| Dark: BG `#1a1a1a` · Surface `#242426` · Text `#f2f1ee` · Green `#6eb59e` |

Alt-Palette **ersetzt**: Teal `#1c7d70`, Dark Green `#4a6741`, Maroon `#8B4545`.

Gradients: Buttons `linear-gradient(135deg, #FF8C42, #FFB84D)`, Accent `#A8D5BA → #7EC483`.

## Typografie

Font-Stack: `-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Manrope", sans-serif`
- h1 1.3rem/700 · h2 1.1rem/700 · body 0.95rem/400 · label 0.84rem/600 · meta 0.7rem/700 uppercase
- Line-height: Headings 1.2, Body 1.5, Forms 1.4

## Komponenten

- **Button:** Radius 14px, min-height 48px, Padding 14/16, Transition 250ms, Hover −2px + Schatten
- **Card:** Radius 20px, Padding 18px, `shadow 0 2px 8px rgba(0,0,0,.06)`, Hover `0 8px 24px rgba(0,0,0,.12)`
- **Input:** Radius 12px, Border 1.5px transparent, Focus = Orange-Border + flame-tint Shadow
- **Chip/Filter:** Pill (Radius 999px), aktiv = Orange-Gradient + weißer Text
- **Tabs:** unten fixiert, 66px hoch, Buttons 48×48, aktiver Indikator Orange-Unterstrich 3px

## Motion

- fast 150ms (interaktiv) · base 250ms (Standard) · slow 400ms (Modals)
- slideIn / fadeIn 250ms, spin 0.8s linear
- `prefers-reduced-motion: reduce` → Animationen 1ms

## Responsive

- Breakpoints: ≤480 (mobil, primär), 481–768 (Tablet), ≥769 (Desktop)
- `.app` max-width 480px, zentriert; kein horizontales Scrollen
- `viewport-fit=cover` (Notch), 84px Bottom-Padding für Tabbar
- Touch-Targets ≥ 48×48, Gap ≥ 8px

## Accessibility

- Text-Kontrast ≥ 4.5:1 (WCAG AA), interaktiv ≥ 3:1
- Sichtbarer Focus-Ring (Orange, 3px)
- Semantisches HTML, Form-Labels, aria-labels an Icon-Buttons

## Design-Prinzipien

1. Warm & einladend (Orange/Peach für Ernährungskontext)
2. Clean & minimal (Weißraum, klare Hierarchie)
3. Modern & smooth (Gradients, Schatten, Transitions)
4. Zugänglich (Kontrast, große Targets)
5. Schnell & responsiv (Vanilla CSS, 0 Dependencies)

## Dateien

- `nestbau-design.css` (externes Stylesheet), `index.html`, `icon.svg`, `manifest.json` (`theme_color #FF8C42`, `background_color #fafaf8`)
