# Brand Refresh Feasibility Report — Clean Air Task Force

> **Audit date:** 2026-03-30
> **Site URL:** https://www.catf.us/
> **Theme:** `catf-2021` v1.6.3 (custom WordPress theme)
> **Source access:** None — analysis based on compiled CSS, source map, and `theme.json`

---

## Executive Summary

A brand refresh (new colors, fonts, and visual polish) on the existing `catf-2021` theme is **feasible but not trivial**. The theme was built with a reasonably well-structured design token system, but the implementation has inconsistencies that would need to be addressed:

1. **Colors are ~75% centralized** via `theme.json` and CSS custom properties (`--wp--preset--color--brand-*`). However, ~36 hardcoded hex/rgba values duplicate brand colors directly in the compiled CSS, bypassing the variable system. A color swap in `theme.json` alone would update most of the site, but not all of it.

2. **Fonts are modular** — 5 `@font-face` declarations in `_fonts.scss` load self-hosted woff/woff2 files. Swapping typefaces requires updating font files, `@font-face` rules, and the font stacks referenced in `_typography.scss`. Typography sizing uses CSS custom properties via `theme.json` and would not need to change.

3. **The SCSS architecture is well-organized** (90 source files across `base/`, `blocks/`, `layouts/`, `modules/`, `mixins/`) with a clear separation of concerns. Variables and mixins are centralized. The source map is deployed, making debugging straightforward.

4. **The main risk is scattered hardcoded values** — shadow opacities, overlay colors, border colors, and a few SVG data URIs contain raw color values that the variable system does not reach. These would need to be found and updated manually or refactored to use variables.

5. **A pure color + font swap could be executed in 4–8 hours** by an experienced developer with theme source access. A more thorough cleanup (eliminating all hardcoded duplicates, adding missing variable references) would take 12–20 hours.

---

## Theme Architecture

### SCSS Structure (90 source files)

```
assets/
├── dist/
│   └── css/
│       ├── screen.min.css          ← compiled output
│       ├── screen.min.css.map      ← source map (deployed — DevTools can see SCSS)
│       ├── gravity-forms.min.css
│       └── ie.min.css
└── src/
    ├── js/
    └── sass/
        ├── screen.scss             ← main entry point
        ├── base/                   ← global tokens & resets (9 files)
        │   ├── _variables.scss     ← SCSS variables (spacing, breakpoints, z-index)
        │   ├── _accents.scss       ← accent/utility color classes
        │   ├── _fonts.scss         ← @font-face declarations
        │   ├── _typography.scss    ← type scale, heading/body styles
        │   ├── _elements.scss      ← base HTML element styles
        │   ├── _reset.scss         ← CSS reset
        │   ├── _animation.scss     ← keyframes & transitions
        │   ├── _media.scss         ← responsive image/video defaults
        │   └── _utilities.scss     ← utility classes
        ├── mixins/                 ← shared SCSS mixins (5 files)
        │   ├── _accents.scss       ← accent color mixin
        │   ├── _buttons.scss       ← button style mixin
        │   ├── _forms.scss         ← form element mixin
        │   ├── _layout.scss        ← grid/layout mixin
        │   ├── _typography.scss    ← type mixin
        │   └── _utilities.scss     ← utility mixin
        ├── blocks/                 ← ACF + WP block styles (27 files)
        │   ├── _acf-block-hero-slider.scss
        │   ├── _acf-block-page-section.scss
        │   ├── _acf-block-side-image-text.scss
        │   ├── _acf-block-post-slider.scss
        │   ├── _acf-block-tabbed-content.scss
        │   ├── _acf-block-resource-slider.scss
        │   ├── _acf-block-accordion.scss
        │   ├── _acf-block-logo-grid.scss
        │   ├── _acf-block-offset-hero.scss
        │   ├── _acf-block-custom-group.scss
        │   ├── _acf-block-text-slider.scss
        │   ├── _acf-block-image-slider.scss
        │   ├── _acf-block-event-slider.scss
        │   ├── _blocks-frontend.scss
        │   ├── _wp-block-button.scss
        │   ├── _wp-block-cover.scss
        │   ├── _wp-block-columns.scss
        │   ├── _wp-block-group.scss
        │   ├── _wp-block-image.scss
        │   ├── _wp-block-embed.scss
        │   ├── _wp-block-search.scss
        │   ├── _wp-block-separator.scss
        │   ├── _wp-block-social-links.scss
        │   ├── _wp-block-table.scss
        │   ├── _wp-block-spacer.scss
        │   └── _wp-block-quote.scss
        ├── layouts/                ← page-level layout styles (8 files)
        │   ├── _header.scss
        │   ├── _footer.scss
        │   ├── _main.scss
        │   ├── _entry-content.scss
        │   ├── _resource-content.scss
        │   ├── _page-section-grid.scss
        │   ├── _fullscreen-iframe.scss
        │   └── _post-with-action-menu.scss
        └── modules/               ← UI component styles (30+ files)
            ├── forms/
            │   ├── _forms.scss
            │   └── _search-filters.scss
            ├── lists/
            │   ├── _archive-list.scss
            │   ├── _post-list.scss
            │   ├── _action-tiles.scss
            │   ├── _box-arrow-list.scss
            │   ├── _cat-menu.scss
            │   ├── _social-icon-list.scss
            │   ├── _career-list.scss
            │   └── _file-collection.scss
            ├── _links.scss
            ├── _announcement-bar.scss
            ├── _dialog.scss
            ├── _hamburgers.scss
            ├── _social-sharing.scss
            ├── _pagination-nav.scss
            ├── _post-header.scss
            ├── _post-footer.scss
            ├── _bio-intro.scss
            ├── _event-card.scss
            └── ... (20+ more)
```

### Build Pipeline

The theme compiles SCSS to minified CSS with source maps. The build tool is not visible from the front end, but the presence of `screen.min.css` + `.map` alongside a `src/sass/` → `dist/css/` structure suggests a standard Node-based build (likely Webpack, Gulp, or Laravel Mix). **Source access is required to run the build.**

---

## Color System Analysis

### Token Layer: `theme.json`

All brand colors are defined in `theme.json` and emitted as CSS custom properties by WordPress:

| Token | Variable | Hex | Role | Usage Count |
|---|---|---|---|---|
| Brand A | `--wp--preset--color--brand-a` | `#0047BB` | Primary blue (links, buttons, CTAs) | **87** |
| Brand B | `--wp--preset--color--brand-b` | `#012169` | Dark navy (headings, hover states, nav) | **64** |
| Brand C | `--wp--preset--color--brand-c` | `#00C2F3` | Cyan accent | 5 |
| Brand D | `--wp--preset--color--brand-d` | `#A0E203` | Lime green accent | **0** (unused) |
| Brand E | `--wp--preset--color--brand-e` | `#03CDA7` | Teal accent | **0** (unused) |
| Brand F | `--wp--preset--color--brand-f` | `#C800A1` | Magenta accent | 4 |
| Brand G | `--wp--preset--color--brand-g` | `#D8EAFD` | Light blue tint | 8 |
| Brand H | `--wp--preset--color--brand-h` | `#CDD4E0` | Cool gray border | 18 |
| Brand I | `--wp--custom--color-brand-i` | `#153171` | Deep navy variant | 1 |
| Brand J | `--wp--custom--color-brand-j` | `#F3F2F2` | Off-white background | 1 |
| Brand White | `--wp--preset--color--brand-white` | `#ffffff` | White | 22 |
| Brand Black | `--wp--preset--color--brand-black` | `#000000` | Black | **0** (unused) |
| Warning | `--wp--custom--color-warning` | `#E10F0F` | Error/warning red | 1 |

**Key insight:** The palette has 13 tokens, but only **Brand A, B, H, White, and G** carry the visual weight. Brand D, E, and Black are defined but never used in the compiled CSS. A refresh palette needs to focus on 5–6 tokens to cover ~95% of the visual surface.

### Hardcoded Color Leakage

Despite the variable system, the compiled CSS contains **~36 instances of hardcoded hex values that duplicate brand tokens**:

| Hex Value | Should Be | Count | Where |
|---|---|---|---|
| `#012169` | `brand-b` | 4 | Inline SVG data URIs, specific element overrides |
| `#0047BB` | `brand-a` | 1 | SVG data URI (arrow icon) |
| `#CDD4E0` | `brand-h` | 2 | Border colors in event cards |
| `#F3F2F2` | `brand-j` | 3 | Background colors |
| `#f3f1f2` | ~`brand-j` | 4 | Near-duplicate off-white (rounding error?) |
| `#fff` / `#ffffff` | `brand-white` | 18+ | Backgrounds, text, borders |

**Impact for a refresh:** Changing `theme.json` alone would update ~210 variable references across the site. The ~36 hardcoded values would retain the old palette and need manual SCSS fixes. The SVG data URI colors (arrows, icons) are the trickiest — they're embedded in the SCSS as base64/URL-encoded strings.

### Shadow & Overlay System

Shadows and overlays use hardcoded `rgba()` values that are **not tied to brand tokens**:

| Pattern | Count | Notes |
|---|---|---|
| `rgba(0,0,0,.18)` | 15+ | Standard card/element shadow |
| `rgba(0,0,0,.15)` | 5 | Lighter shadow variant |
| `rgba(0,0,0,.1)` | 3 | Subtle borders/dividers |
| `rgba(0,0,0,.25)` | 2 | Stronger shadow |
| `rgba(0,0,0,.7)` | 1 | Heavy overlay |
| `rgba(43,46,56,.9)` | 1 | Dialog overlay |
| `rgba(10,13,52,.9)` | 1 | Dark navy overlay |

These are all based on black or near-black. For a brand refresh that only changes colors/fonts, they can likely stay as-is. If the refresh introduces a different shadow palette (e.g., colored shadows), they'd need refactoring.

---

## Typography System

### Font Definitions

| Font | Weight/Style | File Format | Defined In |
|---|---|---|---|
| TT Norms Pro Normal | Regular | woff, woff2 | `_fonts.scss` |
| TT Norms Pro Bold | Bold | woff, woff2 | `_fonts.scss` |
| TT Norms Pro Italic | Italic | woff, woff2 | `_fonts.scss` |
| TT Norms Pro Bold Italic | Bold Italic | woff, woff2 | `_fonts.scss` |
| Frank Ruhl Libre | Regular, 500 | woff, woff2 | `_fonts.scss` (Google Fonts subset) |

**TT Norms Pro** is a commercial typeface (TypeType foundry). It's used as the primary sans-serif for body text, navigation, buttons, and UI. **Frank Ruhl Libre** is used as the serif accent for headings.

### Font Stack References

The SCSS uses specific font-family names per weight rather than a single variable:

```
"TTNormsPro-Normal", Arial, sans-serif     ← body text
"TTNormsPro-Bold", Arial, sans-serif       ← bold text, headings
"TTNormsPro-Italic", Arial, sans-serif     ← italic text
"TTNormsPro-BoldItalic", Arial, sans-serif ← bold italic
"Frank Ruhl Libre", serif                  ← heading accents
```

**Swapping fonts requires:**
1. Replace woff/woff2 files in `assets/dist/fonts/`
2. Update `@font-face` declarations in `_fonts.scss`
3. Update font-family references in `_typography.scss` and any component that specifies a font directly
4. The `_typography.scss` mixin likely centralizes most font-family assignments, but some blocks may specify fonts directly

### Type Scale

Font sizes are tokenized in `theme.json` using fluid `clamp()` values:

| Token | Variable | Value |
|---|---|---|
| Paragraph XS | `--para-x-small` | `clamp(0.94rem, 3vw, 0.94rem)` |
| Paragraph S | `--para-small` | `clamp(1.06rem, 3vw, 1.06rem)` |
| Paragraph M | `--para-medium` | `clamp(1.1rem, 3vw, 1.19rem)` |
| Paragraph L | `--para-large` | `clamp(1.2rem, 3vw, 1.38rem)` |
| Paragraph XL | `--para-x-large` | `clamp(1.4rem, 3.3vw, 1.75rem)` |
| Heading XXS | `--hdg-xx-small` | `clamp(1.19rem, 3vw, 1.31rem)` |
| Heading XS | `--hdg-x-small` | `clamp(1.2rem, 3.4vw, 1.44rem)` |
| Heading S | `--hdg-small` | `clamp(1.5rem, 4vw, 1.75rem)` |
| Heading M | `--hdg-medium` | `clamp(1.8rem, 5vw, 2.63rem)` |
| Heading L | `--hdg-large` | `clamp(2rem, 7vw, 3.38rem)` |
| Eyebrow | `--eyebrow` | `clamp(0.95rem, 3vw, 1.25rem)` |
| Custom A | `--font-size-a` | `clamp(1.3rem, 3.4vw, 1.85rem)` |
| Custom B | `--font-size-b` | `clamp(1.15rem, 3vw, 1.5rem)` |

These are well-structured and would not need to change for a color/font refresh unless the new typeface has different optical sizing needs.

---

## Utility Class System

The theme generates WordPress-standard utility classes from `theme.json` tokens:

### Color Utilities (from `_accents.scss`)

```css
.has-brand-a-color { color: var(--wp--preset--color--brand-a); }
.has-brand-b-color { color: var(--wp--preset--color--brand-b); }
.has-brand-a-background-color { background-color: var(--wp--preset--color--brand-a); }
.has-brand-white-color { color: var(--wp--preset--color--brand-white); }
/* ... 18 total utility classes */
```

These are used throughout block content authored in the WordPress editor. Editors pick colors from the palette and WP applies `has-brand-*` classes. **This is good for a refresh** — the classes reference variables, so updating `theme.json` values flows through automatically.

### Accent Modifier Pattern

Blocks use parent-level accent classes to modify child element colors:

```css
.has-brand-white-color .flickity-button { /* inverted button */ }
.has-brand-a-background-hover:hover { /* interactive state */ }
```

This is a simple but effective system. A refresh would not need to change the class structure — only the underlying color values.

---

## Responsive Design

### Breakpoints

| Name | Query | Purpose |
|---|---|---|
| Mobile | `max-width: 759px` | Single column, stacked layout |
| Tablet | `min-width: 760px` | Two-column layouts begin |
| Desktop | `min-width: 950px` | Full layouts, larger type |
| Wide | `min-width: 1270px` | Max-width containers |

These are consistent across all 90 SCSS files and are likely defined as SCSS variables in `_variables.scss`. A brand refresh would not need to touch breakpoints.

### Layout Tokens

| Token | Variable | Value |
|---|---|---|
| Content width | `--wp--style--global--content-size` | `49.69rem` |
| Wide width | `--wp--style--global--wide-size` | `57.5rem` |
| Widest width | `--wp--custom--widest-size` | `69.06rem` |

---

## Block-by-Block Complexity

| Block | CSS Rules | Brand Variable Usage | Hardcoded Colors? | Refresh Risk |
|---|---|---|---|---|
| `acf-block-accordion` | ~80 | High | Minimal | Low |
| `acf-block-tabbed-content` | ~70 | High | Minimal | Low |
| `acf-block-page-section` | ~65 | High | 1–2 border colors | Low |
| `acf-block-hero-slider` | ~50 | High | Overlay rgba | Low |
| `acf-block-offset-hero` | ~45 | High | Overlay rgba | Low |
| `acf-block-event-slider` | ~40 | Medium | 1 hardcoded border | Low |
| `acf-block-post-slider` | ~35 | High | None | **Lowest** |
| `acf-block-side-image-text` | ~30 | High | None | **Lowest** |
| `acf-block-resource-slider` | ~25 | High | None | **Lowest** |
| `acf-block-logo-grid` | ~15 | High | None | **Lowest** |
| `acf-block-bio-tiles` | ~15 | High | None | **Lowest** |
| WP core blocks (9 files) | ~120 total | Mixed | Some | Medium |

---

## Feasibility Assessment

### Option A: Quick Color + Font Swap (4–8 hours)

**What it covers:**
- Update 10 color values in `theme.json` → updates ~210 CSS variable references site-wide
- Replace font files in `assets/dist/fonts/`
- Update `@font-face` in `_fonts.scss` and font stacks in `_typography.scss`
- Rebuild CSS (`npm run build` or equivalent)

**What it leaves behind:**
- ~36 hardcoded hex/rgba values in SCSS (old colors persist in shadows, SVG icons, edge-case borders)
- SVG data URI colors in icons (arrows, etc.) would still show old palette
- Any content with inline `style=""` attributes set in the WP editor
- Near-duplicate off-whites (`#f3f1f2` vs `#F3F2F2`) not on the variable system

**Verdict:** Covers ~90% of the visual surface. Acceptable for a fast refresh, but noticeable inconsistencies in icons and shadows.

### Option B: Thorough Refresh with SCSS Cleanup (12–20 hours)

Everything in Option A, plus:
- Audit all 90 SCSS files for hardcoded color values and replace with `var()` references
- Refactor SVG data URIs to use inline SVGs or CSS `mask-image` so colors can be controlled via variables
- Extract shadow/overlay values into SCSS variables or CSS custom properties
- Remove unused tokens (Brand D, E, Black) from `theme.json`
- Clean up near-duplicate values (`#f3f1f2` → `#F3F2F2`)
- QA pass across all page templates and block combinations

**Verdict:** Clean result with no legacy color leakage. The right choice if the site will continue to evolve after the refresh.

### Option C: Full Rebuild (Not Recommended for Brand Refresh Only)

If the goal is *only* a brand refresh (new colors, fonts, minor visual tweaks), a full theme rebuild is overkill. The current theme's architecture is sound:
- Well-organized SCSS with clear separation of concerns
- Functional design token system via `theme.json`
- Modular block system with consistent patterns
- Standard WordPress conventions throughout

A rebuild is only justified if the refresh is paired with **structural changes** (new layouts, new content types, new CMS, responsive redesign, etc.).

---

## Risks & Gotchas

| Risk | Severity | Mitigation |
|---|---|---|
| **No source access** — we cannot confirm build pipeline works | High | Get repo access and test `npm install && npm run build` before starting |
| **Commercial font license (TT Norms Pro)** — may not cover a new domain | High | Verify license terms before assuming the font can transfer |
| **Editor inline styles** — content authors may have applied colors via WP editor color picker | Medium | Run a DB search for `has-brand-*` classes and inline `style="color:` / `background-color:` in `post_content` |
| **SVG data URIs** — hardcoded colors in base64-encoded SVGs | Medium | 5–6 instances; need manual replacement |
| **Pardot embedded forms** — styled externally | Medium | Pardot form styles are controlled in Pardot, not the theme — must be updated separately |
| **Gravity Forms** — has its own stylesheet (`gravity-forms.min.css`) | Medium | Separate CSS file needs its own review for brand colors |
| **`ie.min.css`** — IE-specific overrides | Low | Can be deleted; IE is EOL |
| **Flickity dependency** — GPL-licensed, unmaintained | Low | Not a brand refresh concern, but flag for future |
| **Cookie Script banner** — styled externally | Low | May need configuration update in Cookie Script dashboard |

---

## Recommended Approach

For a brand refresh on the existing site, **Option B (12–20 hours)** is the right balance:

1. **Get theme source access** and confirm the build pipeline works
2. **Update `theme.json`** with the new color palette (10 values)
3. **Replace font files** and update `_fonts.scss` + `_typography.scss`
4. **Search-and-replace hardcoded values** in SCSS source files
5. **Rebuild and deploy** CSS
6. **QA every page template**: homepage, blog post, program page, resource page, expert page, archive pages, search, regional pages, timeline
7. **Update external systems**: Pardot form styles, Cookie Script branding, Gravity Forms if customized, donation platform if branded

### Files to Touch (Priority Order)

| File | What Changes |
|---|---|
| `theme.json` | All color + optional font-size token values |
| `base/_fonts.scss` | `@font-face` declarations for new typeface |
| `base/_typography.scss` | `font-family` stacks |
| `base/_variables.scss` | Any SCSS-level color variables (breakpoints stay) |
| `base/_accents.scss` | Utility class color assignments (should auto-update via variables) |
| `base/_elements.scss` | Base element styles — check for hardcoded colors |
| `blocks/*.scss` (13 ACF blocks) | Scan for hardcoded hex in SVG data URIs and edge-case overrides |
| `modules/*.scss` (30+ files) | Scan for hardcoded colors |
| `mixins/_buttons.scss` | Button color patterns |
| `mixins/_accents.scss` | Accent mixin definitions |
| `gravity-forms.min.css` source | Form element brand colors |
