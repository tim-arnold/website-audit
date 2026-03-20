# Accessibility Audit Report — noblereach.org

**Prepared:** 2026-03-20
**Method:** Code audit (theme filesystem) + live audit (Playwright, 5 pages)
**Full findings:** `../data/accessibility-findings.md`
**Screenshots:** `../screenshots/` (homepage, person page, story page, news page, accordion keyboard tests)
**Standard:** WCAG 2.2 Level AA

---

## Executive Summary

- **Current conformance level: Does not meet WCAG 2.2 Level A.** Multiple Level A failures exist (missing landmark, no H1, missing button roles, inaccessible accordions). The site cannot claim AA conformance without a significant rebuild effort.
- **The person page template — the site's highest-traffic content — fails the most basic heading criterion.** Person names render as H5 with no H1 on the page. This affects every `/person/` URL and was already flagged in the SEO audit. Fixing it serves both AT users and search ranking.
- **No `<main>` landmark exists on any page.** The primary content area uses `<section id="content">` instead of `<main>`. Every page fails WCAG 2.4.1 (Bypass Blocks) as a result.
- **Interactive components are implemented with wrong HTML elements.** Accordions use headings as click targets (not buttons), carousel controls are icon-only `<a>` tags, and modal toggles are links not buttons — none communicate their state via ARIA.
- **A JavaScript error fires on every page load** (`Cannot redefine property: $persist`). If it breaks Alpine.js initialization, keyboard users cannot interact with modals, drawers, or carousels.
- **The map asset (noblereach-map.js) is 404-ing on production**, making MapSVG maps completely broken for all users.
- **Several items are straightforward to fix:** lang attribute is set, skip links are present, focus-visible styles exist, navigation has `focus-within` keyboard support for dropdowns, and social links have `aria-label` attributes. The foundation is workable.

---

## 1. WCAG 2.2 Compliance Summary

| Criterion | Level | Status | Notes |
|---|---|---|---|
| 1.1.1 Non-text Content | A | **Fail** | Person photos and story hero images have no alt text (live-confirmed); noscript fallback always empty; carousel arrows have no name; placeholder "CARD_TITLE_GOES_HERE" on live cards |
| 1.2.1 Audio-only / Video-only | A | Not tested | — |
| 1.2.2 Captions | A | Not tested | Video components exist; not verified |
| 1.2.3 Audio Description | A | Not tested | — |
| 1.3.1 Info and Relationships | A | **Fail** | Heading hierarchy broken sitewide; no `<main>`; `aria-current` on wrong element |
| 1.3.2 Meaningful Sequence | A | Pass | Content order appears logical |
| 1.3.3 Sensory Characteristics | A | Pass | No evidence of sensory-only instructions |
| 1.3.4 Orientation | AA | Pass | No orientation lock detected |
| 1.3.5 Identify Input Purpose | AA | Not tested | Forms not deeply tested |
| 1.4.1 Use of Color | A | Not tested | Requires visual review |
| 1.4.2 Audio Control | A | Not tested | Background video observed |
| 1.4.3 Contrast (Minimum) | AA | Not tested | Requires rendering; CSS uses custom properties |
| 1.4.4 Resize Text | AA | Pass | Viewport meta does not block scaling |
| 1.4.5 Images of Text | AA | Pass | No images of text observed |
| 1.4.10 Reflow | AA | Not tested | Requires viewport testing |
| 1.4.11 Non-text Contrast | AA | Not tested | Requires rendering |
| 1.4.12 Text Spacing | AA | Not tested | — |
| 1.4.13 Content on Hover or Focus | AA | Not tested | Dropdowns appear on hover/focus |
| 2.1.1 Keyboard | A | **Fail** | Accordion space key missing; dropdown state management incomplete |
| 2.1.2 No Keyboard Trap | A | Not tested | Modals/drawers not deeply tested |
| 2.1.4 Character Key Shortcuts | A | **Risk** | Staging arrow-key script may be live on production |
| 2.2.1 Timing Adjustable | A | Pass | No timed content observed |
| 2.2.2 Pause, Stop, Hide | A | Not tested | Carousels auto-play status unknown |
| 2.3.1 Three Flashes | A | Pass | No flashing content observed |
| 2.4.1 Bypass Blocks | A | **Fail** | No `<main>` landmark; skip links nav has no label |
| 2.4.2 Page Titled | A | Pass | `<title>` present and descriptive on all tested pages |
| 2.4.3 Focus Order | A | **Partial** | Keyboard walk confirmed on homepage and Scholars page: focus order is logical; focus visible on logo, skip links, nav, accordion; sticky header may occasionally obscure focus — not fully tested |
| 2.4.4 Link Purpose | A | **Partial** | Most links clear; carousel arrows unnamed; "CARD_TITLE_GOES_HERE" placeholder; social links say "Share on" when they're profile links |
| 2.4.5 Multiple Ways | AA | Pass | Search, navigation, and links provide multiple paths |
| 2.4.6 Headings and Labels | AA | **Fail** | Person pages: no H1; story pages: no H1; homepage: non-sequential levels |
| 2.4.7 Focus Visible | AA | **Partial** | focus-visible styles exist; skip links have `outline: none` |
| 2.4.11 Focus Not Obscured | AA | Not tested | Sticky header may obscure focused elements |
| 3.1.1 Language of Page | A | **Pass** | `<html lang="en">` present |
| 3.1.2 Language of Parts | AA | Not tested | — |
| 3.2.1 On Focus | A | Pass | No unexpected context changes on focus observed |
| 3.2.2 On Input | A | **Partial** | Links open in new tab without warning |
| 3.2.3 Consistent Navigation | AA | Pass | Navigation is consistent across pages |
| 3.2.4 Consistent Identification | AA | Pass | Components appear consistently identified |
| 3.3.1 Error Identification | A | Not tested | Form errors not tested |
| 3.3.2 Labels or Instructions | A | Not tested | — |
| 3.3.3 Error Suggestion | AA | Not tested | — |
| 3.3.4 Error Prevention | AA | Not tested | — |
| 4.1.1 Parsing | A | **Fail** | JS errors on every page; `:disabled` on `<a>` elements |
| 4.1.2 Name, Role, Value | A | **Fail** | Accordion missing aria-expanded; `<a>` as buttons; carousel arrows unnamed; "Company Name" placeholder |
| 4.1.3 Status Messages | AA | Not tested | — |

**Estimated conformance:** Does not meet Level A. Estimated 9+ Level A failures.

---

## 2. Critical Issues

These issues must be resolved in the rebuild. They block or severely impair access to content.

### C-1 — No `<main>` landmark (affects every page)
**WCAG 1.3.1, 2.4.1 · Level A**

`_html/templates/core/base.twig:30` uses `<section class="content1" id="content">` for the main content area. A `<section>` without an accessible name is not a landmark. Screen reader users cannot jump to the main content via landmark navigation (a primary navigation technique).

**Fix for rebuild:** Change the outer content wrapper to `<main>`. One `<main>` per page.

---

### C-2 — Person page: no H1, person name rendered as H5 (affects highest-traffic content)
**WCAG 1.3.1, 2.4.6 · Level A/AA**

Every `/person/` URL lacks an H1. The person's name (e.g., "Governor Kevin Stitt") is H5 with no higher-level heading above it. Screen reader users navigating by headings encounter an orphaned H5 with no context.

**Cross-reference:** SEO audit also flags this — same fix serves both. See `seo-audit/reports/`.

**Fix for rebuild:** Person name → H1. Downstream section headings → H2/H3.

---

### C-3 — Story page: no H1, story title rendered as H4
**WCAG 1.3.1, 2.4.6 · Level A/AA**

Story pages (including high-traffic Emerge program stories) have no H1. The story title is H4, then body section headings ("The Challenge", "Entrepreneur Support") use H3 — the subheadings outrank the page title.

**Fix for rebuild:** Story title → H1. Section headings → H2. Subsections → H3.

---

### C-4 — Accordion has no ARIA state and uses H5 not button
**WCAG 4.1.2, 2.1.1 · Level A**

`accordion1.twig` implements triggers as `<h5 tabindex="0">` elements with click and Enter key handlers. Problems:
- Screen readers announce it as "heading level 5", not "button, collapsed"
- No `aria-expanded` — AT users can't know if panel is open or closed
- Space key doesn't toggle (required per ARIA authoring practices)
- Forces all accordion titles into H5 in the document heading hierarchy

**Fix for rebuild:** Use `<button aria-expanded="false">` inside a heading: `<h3><button>Title</button></h3>`. Toggle `aria-expanded` on open/close. Handle both Enter and Space keys.

---

### C-5 — Carousel controls have no accessible name
**WCAG 1.1.1, 4.1.2 · Level A**

`carousel1.twig` prev/next arrows are icon-only `<a href="#">` elements. Screen readers announce them as unnamed links. `:disabled` has no semantic effect on `<a>` elements.

**Fix for rebuild:** Replace with `<button aria-label="Previous slide">` / `<button aria-label="Next slide">`. Disable with `disabled` attribute (or `aria-disabled="true"` with JS prevention) at boundaries.

---

### C-6 — Person photos and story hero images have no alt text (live-confirmed)
**WCAG 1.1.1 · Level A**

Every person page and story page tested showed `<figure>` elements with no accessible alt text in the accessibility tree. Person profile photos are the primary visual identifier of the subject. Story header images establish context. Both are informative, not decorative.

**Live evidence:** `/person/kevin-stitt/`, `/stories/noblereach-emerge-lightdeck/`, `/stories/noblereach-emerge-coldquanta/` — all show `figure` with no text alternative.

**Fix for rebuild:** ACF image fields store alt text. The Twig templates rendering person headers and story headers must explicitly pass `alt="{{ image.alt }}"` to the image component. Also ensure content editors are prompted to fill alt text in ACF field settings.

---

### C-7 — "CARD_TITLE_GOES_HERE" placeholder as live link accessible name
**WCAG 2.4.4, 4.1.2 · Level A/AA**

`card2.twig` defaults overlink accessible name to the literal string `CARD_TITLE_GOES_HERE` when no link title is supplied. This is confirmed live on the homepage news feed — two news cards have this as their accessible name.

**Fix for rebuild:** The PHP template must supply the post title to every card2 overlink invocation. Remove or guard the template default.

---

## 3. Major Issues

These issues should be fixed in the rebuild. They degrade the experience significantly.

### M-1 — Homepage heading hierarchy is non-sequential
**WCAG 1.3.1, 2.4.6 · Level A/AA**

Heading levels on the homepage jump from H1 → H4, then back to H3, then H4, then H3, then H4, ending at H5 in the footer. Each section appears to set its heading level independently without awareness of the page's document outline.

**Fix:** The rebuild must establish a page-level heading plan before building components. Every template layout should document the heading level its section headings should use, and those should cascade from the page's H1.

---

### M-2 — Multiple navigation regions have no `aria-label`
**WCAG 2.4.1 · Level A**

Every page has three or more `<nav>` elements (skip links, main nav, utility nav) none of which have `aria-label` attributes. Screen reader users activating "navigate by landmarks" encounter multiple anonymous "navigation" regions.

**Fix:** `aria-label="Skip links"`, `aria-label="Main"`, `aria-label="Utility"` on respective `<nav>` elements.

---

### M-3 — Interactive buttons implemented as links
**WCAG 4.1.2 · Level A**

Mobile menu toggle, search toggle, and modal close controls are all `<a>` elements. They don't navigate to a URL; they trigger JavaScript state changes. Screen readers announce them as "link" instead of "button".

**Fix:** Replace with `<button>`. Add `aria-expanded` to toggling controls (open/close state).

---

### M-4 — Skip link focus indicator removed with `outline: none`
**WCAG 2.4.7 · Level AA**

`app.css:1429` sets `outline: none` on skip links. Skip links are critical for keyboard users and must have a clearly visible focus state.

**Fix:** Remove `outline: none`. Add `outline: 3px solid` with sufficient contrast against the semi-transparent background.

---

### M-5 — Dropdown nav lacks ARIA state management
**WCAG 2.1.1 · Level A**

Nav dropdowns open via CSS `focus-within`, which is functional for basic keyboard navigation. But there is no `aria-expanded` / `aria-haspopup` on parent nav links, so AT users don't know a submenu exists until they tab into it.

**Fix:** Add `aria-haspopup="true"` and `aria-expanded` (toggled by JS) to nav items with submenus. Consider a dedicated toggle button (chevron) for explicit submenu control.

---

### M-6 — JavaScript error on every page (`$persist` conflict)
**WCAG 4.1.1 · Level A**

`app.js:866: TypeError: Cannot redefine property: $persist` fires on load. If Alpine.js `$store` fails to initialize, all modal/drawer/carousel interactivity may silently break for keyboard and AT users.

**Fix:** Resolve the Alpine.js plugin conflict before launch.

---

### M-7 — Map JS is 404-ing; MapSVG maps non-functional
**WCAG 4.1.1 · Level A**

`noblereach-map.js` returns 404 on production. MapSVG interactive maps are completely broken. When restored, MapSVG maps require significant ARIA work (region labels, keyboard navigation, text alternatives) to be accessible.

**Fix:** Restore the map file. Then implement SVG map accessibility: each region should have a `<title>` and `role="img"`, with keyboard-navigable focus on interactive regions.

---

### M-8 — `logo2.twig` renders `aria-label="Company Name"` verbatim
**WCAG 4.1.2 · Level A**

The `logo2` partial has a hardcoded placeholder `aria-label="Company Name"`. Any partner/sponsor logo rendered via this component provides a meaningless accessible name.

**Fix:** Accept `company_name` as a required variable and use it.

---

### M-9 — `noscript` image fallback always has empty alt text
**WCAG 1.1.1 · Level A**

`img1.twig:15`: `<noscript><img src="{{ src }}" alt="">` — informative images lose their alt text for users with JS disabled.

**Fix:** Pass the alt variable: `alt="{{ alt }}"`.

---

### M-10 — Staging arrow-key script may render on production
**WCAG 2.1.4 · Level A**

A script binding left/right arrow keys to page navigation is wrapped only in an HTML comment (not a Twig conditional). If it executes on production, it will intercept AT navigation keys. **Verify and fix before launch.**

---

## 4. Minor Issues

### Minor-1 — `aria-current="page"` on `<li>` not `<a>`
Move `aria-current="page"` from the list item to the anchor element inside it. (Finding O-09)

### Minor-2 — Accesskeys conflict with AT shortcuts
Remove accesskeys from skip links and nav links, or document them visibly. (Finding O-07)

### Minor-3 — Social links open new tab without warning
Add "(opens in new tab)" to the social link `aria-label` values. Change "Share on X" to "X (opens in new tab)" since these are profile links, not share actions. (Finding U-02)

### Minor-4 — Footer H5 headings appear without H1-H4 context
The footer uses H5 for "Sign up for our newsletters" — this is disconnected from the document outline. If the footer's headings are cosmetic, use `<p role="heading" aria-level="2">` or restructure. If structural, ensure the overall outline supports H5 at that point. (Finding P-04)

---

## 5. Component-Specific Findings

### Navigation / Header

| Issue | Severity | Fix |
|---|---|---|
| Skip links nav has no `aria-label` | Major | Add `aria-label="Skip links"` |
| Skip links have `outline: none` | Major | Remove; add visible focus ring |
| Main nav has no `aria-label` | Major | Add `aria-label="Main"` |
| Utility nav has no `aria-label` | Major | Add `aria-label="Utility"` |
| Menu/Search toggles are `<a>`, not `<button>` | Major | Convert to `<button>`, add `aria-expanded` |
| Nav dropdowns lack `aria-haspopup` / `aria-expanded` | Major | Add ARIA state management |
| `aria-current="page"` on `<li>` not `<a>` | Minor | Move to `<a>` |
| Accesskeys on nav items | Minor | Remove or document |

### Person Page Template

| Issue | Severity | Fix |
|---|---|---|
| No H1 — person name is H5 | **Critical** | Render as H1 |
| Person photo has no alt text (live-confirmed) | **Critical** | Pass `alt="{{ image.alt }}"` from ACF field |
| No `<main>` landmark | **Critical** | Apply to base template |

### Story Page Template

| Issue | Severity | Fix |
|---|---|---|
| No H1 — story title is H4 | **Critical** | Render as H1 |
| Story hero image has no alt text (live-confirmed) | **Critical** | Pass `alt="{{ image.alt }}"` from ACF field |
| Section headings (H3) outrank story title (H4) | **Critical** | Hierarchy: title H1 → sections H2 |
| Inconsistent heading levels across stories | Major | Live: LightDeck uses H3, ColdQuanta uses H2 for same sections — standardize in template |

### News Page Template

| Issue | Severity | Fix |
|---|---|---|
| H1 present ✓ | Pass | — |
| Article sections use H3 (H2 skipped) | Major | Sections → H2 |
| Related news section also H3 | Major | Adjust to H2 |

### Forms (Gravity Forms)

| Issue | Severity | Fix |
|---|---|---|
| GF has built-in ARIA — passes baseline | Pass | — |
| Custom rendering via shortcode — test errors with AT | Not tested | Run AT test on form submission |
| HubSpot embed form (hardcoded) — ARIA unknown | Not tested | Test with screen reader |

### Maps (MapSVG)

| Issue | Severity | Fix |
|---|---|---|
| `noblereach-map.js` 404 — maps broken entirely | **Critical** | Restore file |
| SVG maps have no keyboard navigation | **Critical** | Implement region focus, `<title>`, `role="img"` |
| SVG maps have no text alternative | **Critical** | Provide equivalent text list of all map regions/data |

### Footer

| Issue | Severity | Fix |
|---|---|---|
| H5 headings without preceding H1-H4 context | Minor | Restructure or use `role="heading"` with explicit level |
| Social links open new tab without warning | Minor | Update aria-label |

---

## 6. Rebuild Recommendations

### Heading Structure Plan

The rebuild must define heading levels per template before building components. Recommended structure:

| Context | H1 | H2 | H3 | H4 |
|---|---|---|---|---|
| Person page | Person name | Sections in layout | Subsections | Card titles |
| Story page | Story title | "The Challenge", "Entrepreneur Support", etc. | Subheadings | — |
| News article | Article title | Article sections | Sub-sections | Related content |
| Homepage | Hero headline | Major sections ("What We Do", "Stories", etc.) | Card/item titles | — |
| Page templates | Page title (H1 in header) | Major sections | Subsections | Cards |

**Cross-reference:** The SEO audit found that person and story pages need H1 for SEO performance. The a11y and SEO fix are identical — establish an H1 on every page.

### ARIA Patterns to Adopt

| Component | Pattern |
|---|---|
| Accordion | [ARIA Accordion](https://www.w3.org/WAI/ARIA/apg/patterns/accordion/) — `<button aria-expanded>` inside heading |
| Modal / Drawer | [ARIA Dialog](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/) — `role="dialog"`, `aria-modal="true"`, focus trap |
| Navigation with dropdowns | [ARIA Disclosure Navigation](https://www.w3.org/WAI/ARIA/apg/patterns/disclosure/examples/disclosure-navigation/) — toggle button per submenu |
| Carousel | [ARIA Carousel](https://www.w3.org/WAI/ARIA/apg/patterns/carousel/) — `role="region"`, prev/next buttons, auto-pause |
| Tabs | [ARIA Tabs](https://www.w3.org/WAI/ARIA/apg/patterns/tabs/) if used |

### Testing Process for Rebuild

1. **Automated (during development):** Run axe-core in CI on all templates. Target zero violations at each PR.
2. **Semi-automated:** Lighthouse accessibility audit on every page template (aim for ≥90).
3. **Manual keyboard walk:** Tab through every page template once — verify focus is always visible and in logical order.
4. **Screen reader testing:** Test key templates with NVDA + Chrome (Windows) and VoiceOver + Safari (Mac/iOS). At minimum: person page, news article, homepage, any page with accordion.
5. **editoria11y plugin:** The site already has the Editoria11y accessibility checker plugin installed. Keep it active in staging; fix issues it surfaces before launch.

### Key Requirements for the New Build

- [ ] Every page has exactly one `<main>` landmark
- [ ] Every page has exactly one `<h1>` — the page's primary title
- [ ] Heading levels never skip (H1 → H2 → H3, not H1 → H4)
- [ ] All `<nav>` elements have unique `aria-label` values
- [ ] All interactive controls that don't navigate use `<button>`, not `<a>`
- [ ] All modals/drawers implement focus trapping and return focus on close
- [ ] All `aria-expanded` states are toggled by JavaScript on all disclosure controls
- [ ] Carousels have named prev/next buttons and a mechanism to pause auto-play
- [ ] Skip link has a visible focus outline
- [ ] All images passed to `img1.twig` have their alt value propagated to the `<noscript>` fallback
- [ ] Person photo and story/program hero image templates pass `alt` from ACF field values; ACF image fields enforce alt text as required
- [ ] Map components provide a text equivalent of all interactive regions
- [ ] No JavaScript errors on page load
- [ ] BugHerd script removed from all production deployments
