# Accessibility Findings — noblereach.org

**Date:** 2026-03-20
**Method:** Code audit (filesystem, `noblereach-2024` theme) + live audit (Playwright, production site)
**Pages tested live:** Homepage, `/person/kevin-stitt/`, `/stories/noblereach-emerge-lightdeck/`, `/news/16-innovations-fueled-by-the-federal-government/`, `/noblereach-emerge/` (redirected to `/stories/noblereach-emerge-coldquanta/`)

---

## 1. Perceivable

### 1.1 Text Alternatives

#### Finding P-01 — No `<main>` landmark on any page
- **WCAG:** 1.3.1 Info and Relationships (AA), supports 2.4.1 Bypass Blocks
- **Severity:** Critical
- **Location:** `_html/templates/core/base.twig:30`
- **Description:** The main content area is wrapped in `<section class="content1" id="content">` rather than `<main>`. A `<section>` element without an `aria-label` or `aria-labelledby` is not exposed as a landmark by assistive technologies. Screen reader users cannot jump directly to the page's primary content via landmark navigation.
- **Live evidence:** All five tested pages show main content as `generic` in the accessibility tree with no `main` role.
- **Fix:** Change `<section class="content1" id="content">` to `<main class="content1" id="content">`. If multiple `<main>` elements are ever needed (e.g., within iframes), the non-primary one must have `hidden` attribute.

---

#### Finding P-02 — Person page: no H1, person name is H5
- **WCAG:** 1.3.1 Info and Relationships (AA), 2.4.6 Headings and Labels (AA)
- **Severity:** Critical
- **Location:** Live: `https://noblereach.org/person/kevin-stitt/` — heading "Governor Kevin Stitt" [level=5]; code: `single-person.php` → `header2.twig`
- **Description:** Every person page lacks an H1. The person's name is rendered as H5 (`heading "Governor Kevin Stitt" [level=5]`), skipping H1 through H4. Screen reader users who navigate by headings cannot identify the page's primary subject. This also signals to assistive technology that the person name is low in the document hierarchy.
- **Note:** Cross-reference SEO audit — this was also flagged as an SEO issue. Fix serves both audiences.
- **Fix:** Render the person's name as H1 on the person single template. Adjust downstream heading levels accordingly (current H3/H4 section labels become H2/H3).

---

#### Finding P-03 — Story page: no H1, story title is H4
- **WCAG:** 1.3.1 Info and Relationships (AA), 2.4.6 Headings and Labels (AA)
- **Severity:** Critical
- **Location:** Live: `/stories/noblereach-emerge-lightdeck/` — "NobleReach supported LightDeck..." [level=4]; `/stories/noblereach-emerge-coldquanta/` — same pattern
- **Description:** Story pages have no H1. The story title is H4, and then section headings ("The Challenge", "Entrepreneur Support") use H3 — creating an inverted hierarchy (H4 → H3). Screen reader users navigating by headings will encounter a broken structure.
- **Fix:** Story title → H1. Section headings → H2. Subsection headings → H3.

---

#### Finding P-04 — Homepage heading hierarchy is non-sequential
- **WCAG:** 1.3.1 Info and Relationships (AA), 2.4.6 Headings and Labels (AA)
- **Severity:** Major
- **Location:** Live: `https://noblereach.org/` — heading sequence observed in accessibility tree
- **Description:** The homepage heading structure skips levels and reverses direction:
  | Level | Text |
  |---|---|
  | H1 | "NobleReach is a civic leadership platform..." (hero) |
  | H4 | "What We Do" (skips H2, H3) |
  | H3 | "Featured Stories" (jumps back) |
  | H4 | Story card titles |
  | H3 | "Sign Up to Receive Updates" (jumps back) |
  | H4 | "Get connected" |
  | H3 | "Recent News" (jumps back) |
  | H4 | News card titles |
  | H5 | "Sign up for our newsletters" (footer) |
- **Fix:** Establish a consistent document outline: H1 for page title, H2 for major sections, H3 for subsections/card titles. Heading levels should only ever increment by one.

---

#### Finding P-05 — News article heading hierarchy skips H2
- **WCAG:** 1.3.1 Info and Relationships (AA)
- **Severity:** Major
- **Location:** Live: `/news/16-innovations-fueled-by-the-federal-government/` — H1 for article title, then H3 for each numbered section (no H2)
- **Description:** News article pages have a correct H1 but immediately jump to H3 for article sections, skipping H2. The "More Recent News & Insights" related content section is also H3.
- **Fix:** Article sub-sections → H2. If the related news section uses the same level, use H2 for that as well.

---

#### Finding P-06 — Carousel navigation arrows have no accessible name
- **WCAG:** 1.1.1 Non-text Content (A), 4.1.2 Name, Role, Value (A)
- **Severity:** Critical
- **Location:** `_html/templates/partials/carousel1.twig:14-15`
- **Description:** Prev/Next carousel arrows are icon-only `<a>` elements with no text, no `aria-label`, and no `title`:
  ```
  <a href="#" class="carousel1-arrow carousel1-prev icon-angle-left-bold" @click.prevent="prev()">
  <a href="#" class="carousel1-arrow carousel1-next icon-angle-right-bold" @click.prevent="next()">
  ```
  Screen readers announce these as "link" with no purpose. These also use `:disabled` attribute which is not valid on `<a>` elements and will not communicate disabled state to AT.
- **Live evidence:** Homepage testimonial carousel prev/next rendered as anonymous links.
- **Fix:** Add `aria-label="Previous"` / `aria-label="Next"`. Replace `<a>` with `<button>`. Replace `:disabled` with `:aria-disabled` and prevent click when disabled.

---

#### Finding P-07 — `noscript` image fallback always has empty alt text
- **WCAG:** 1.1.1 Non-text Content (A)
- **Severity:** Major
- **Location:** `_html/templates/partials/img1.twig:15`
- **Description:** The lazy-loading image pattern includes a `<noscript>` fallback. This fallback always renders `alt=""` regardless of what alt text was passed for the main image:
  ```twig
  <noscript><img src="{{ src }}" alt=""></noscript>
  ```
  Users with JavaScript disabled (including some AT configurations) see images with no alternative text.
- **Fix:** Pass the alt variable to the noscript image: `<noscript><img src="{{ src }}" alt="{{ alt }}"></noscript>`

---

#### Finding P-08 — `CARD_TITLE_GOES_HERE` placeholder as link accessible name
- **WCAG:** 2.4.6 Headings and Labels (AA), 4.1.2 Name, Role, Value (A)
- **Severity:** Critical
- **Location:** `_html/templates/partials/card2.twig:5`
- **Description:** The card2 component has a hardcoded default for overlink text when no `link` variable is provided:
  ```twig
  {{ link|default('<a href="'~ link.url ~'" class="overlink1 card2-link -as:0" hoverwatch><span invisible>CARD_TITLE_GOES_HERE</span></a>') }}
  ```
  When no override is passed, invisible overlinks render with the accessible name "CARD_TITLE_GOES_HERE". This placeholder is live on the homepage news feed — Playwright confirmed two news cards with `link "CARD_TITLE_GOES_HERE"` as their accessible name.
- **Fix:** The PHP template rendering card2 components must pass a proper link title. Remove the hardcoded default text and require the title explicitly.

---

#### Finding P-13 — Person photo and story/program hero images have no alt text
- **WCAG:** 1.1.1 Non-text Content (A)
- **Severity:** Critical
- **Location:** Live: `/person/kevin-stitt/` — `figure [ref=e40]` with no accessible children; `/stories/noblereach-emerge-lightdeck/` — `figure [ref=e40]`; `/stories/noblereach-emerge-coldquanta/` — `figure [ref=e40]`
- **Description:** Person profile photos and story/program header images are rendered as `<figure>` elements with no `alt` text visible in the accessibility tree. Screen readers will either announce the filename or skip the image entirely with no description. For person pages, the photo is the primary visual identifier of the subject. For story pages, the header image establishes the topic context.
- **Live evidence:** All three person/story pages tested via Playwright showed `figure` with no text alternative in the accessibility tree. The rendered `<img>` elements inside these figures receive their `src` from ACF image fields — the alt text from the ACF field's `alt` property must be explicitly passed through the Twig template.
- **Fix:** In the Twig templates that render the person header image and story header image, pass `alt="{{ image.alt }}"` (or the ACF field equivalent) to the `img1.twig` partial. Ensure ACF image fields are configured to require alt text in the field group settings.

---

#### Finding P-09 — Logo link in footer has no visible alt text on the image
- **WCAG:** 1.1.1 Non-text Content (A)
- **Severity:** Minor
- **Location:** `_html/templates/partials/logo1.twig:2`; `_html/templates/partials/footer1.twig:4`
- **Description:** `logo1.twig` provides `aria-label="NobleReach"` on the link wrapping the logo image. This is an acceptable pattern. However the Playwright tree shows the footer logo as `link "NobleReach Foundation"` — verify the alt text on the actual rendered `<img>` matches the aria-label.
- **Fix:** Confirm logo `<img>` has `alt="NobleReach Foundation"` (or similar) so multiple redundant accessible names don't conflict.

---

### 1.2 Captions and Transcripts

#### Finding P-10 — No caption/transcript mechanism verified for video content
- **WCAG:** 1.2.2 Captions (Prerecorded) (A), 1.2.3 Audio Description (A)
- **Severity:** Not tested (no video found on tested pages)
- **Location:** `_html/templates/partials/video1.twig`, `_html/templates/partials/hero1.twig`
- **Description:** Hero sections support background video (`<video autoplay muted loop>`). Background videos with purely decorative content may be exempt, but any video with meaningful content requires captions. YouTube embeds (`component_youtube` layout) also require captions. The Twig templates do not add caption controls.
- **Fix:** Require captions for all substantive video content. Background decorative video should have `aria-hidden="true"`.

---

### 1.3 Color Contrast

#### Finding P-11 — Skip link active state has `outline: none`
- **WCAG:** 1.4.11 Non-text Contrast (AA), 2.4.7 Focus Visible (AA)
- **Severity:** Major
- **Location:** `assets/styles/app.css:1429`
- **Description:** Skip link anchor styles include `outline: none` with no replacement. When focused, the link is repositioned into view (correct) but has no focus ring:
  ```css
  .skips1 li a { outline: none; ... }
  .skips1 li a:focus, .skips1 li a:active { position: relative; left: 0; }
  ```
  The skip link background (dark, semi-transparent) may provide sufficient contrast for the text, but the link itself has no focus indicator border or outline.
- **Fix:** Remove `outline: none`. Add a visible focus ring: `outline: 3px solid #fff` or similar high-contrast style.

---

#### Finding P-12 — Color-only contrast issues require live testing
- **WCAG:** 1.4.3 Contrast (Minimum) (AA), 1.4.11 Non-text Contrast (AA)
- **Severity:** Not tested (requires visual rendering)
- **Location:** `assets/styles/app.css` — color system uses CSS custom properties (`--c_*`)
- **Description:** The CSS uses a comprehensive custom property color system. Contrast ratios cannot be computed from minified CSS alone. Key risk areas:
  - Light text on light background sections (multiple color scheme variants observed)
  - Label text on news/story cards (`.label` elements)
  - Stat numbers in large display type (may be decorative size but small weight)
  - Footer text on colored background
- **Fix:** Run automated contrast checker (axe, Lighthouse) across all template variants. Pay special attention to pages with `-cs:i` (inverted color scheme) applied.

---

## 2. Operable

### 2.1 Keyboard Accessible

#### Finding O-01 — Multiple interactive controls use `<a>` instead of `<button>`
- **WCAG:** 4.1.2 Name, Role, Value (A)
- **Severity:** Major
- **Location:** `_html/templates/partials/top1.twig:6-7`, `_html/templates/partials/drawer1.twig:2`, `_html/templates/partials/sidenav1.twig:5`
- **Description:** Non-navigating interactive controls are implemented as `<a>` elements:
  - `<a href="#search" aria-label="Search">` — opens search modal
  - `<a href="#sidenav" aria-label="Menu">` — opens mobile nav drawer
  - `<a href="#" aria-label="Close">` — closes modal/drawer
  These controls do not navigate to a new URL; they trigger JavaScript state changes. Screen readers announce them as links, not buttons, which misrepresents their function. Some AT shortcut keys (e.g., VoiceOver's "next form element") skip links in favor of buttons.
- **Fix:** Replace with `<button>` elements. Add `aria-expanded` to toggling controls (Menu, Search). Example: `<button aria-label="Menu" aria-expanded="false">`.

---

#### Finding O-02 — Accordion toggle is an H5 heading, not a button; missing `aria-expanded`
- **WCAG:** 4.1.2 Name, Role, Value (A), 2.1.1 Keyboard (A)
- **Severity:** Critical
- **Location:** `_html/templates/partials/accordion1.twig:4`
- **Description:**
  ```twig
  <h5 class="accordion1-title" clickable @click="toggle()" @keydown.enter="toggle()" tabindex="0">
  ```
  - The trigger element is an `<h5>` with `tabindex="0"`, not a `<button>`. Screen readers announce it as a heading level 5, not a button — users don't know it's interactive.
  - `aria-expanded` is absent — AT users cannot determine whether the panel is expanded or collapsed.
  - Only `@keydown.enter` is handled. The Space key (`@keydown.space`) must also toggle the panel per ARIA authoring practices for disclosure widgets.
  - H5 forces every accordion section into the document's heading hierarchy at level 5, regardless of surrounding context.
- **Fix:** Use `<button>` inside or replacing the heading trigger. Add `aria-expanded="false"` (updated to `"true"` when open). Add space key handler. Per ARIA Accordion pattern: `<h3><button aria-expanded="false">Title</button></h3>`.

---

#### Finding O-03 — Dropdown navigation inaccessible via keyboard
- **WCAG:** 2.1.1 Keyboard (A)
- **Severity:** Major
- **Location:** `_html/templates/partials/nav1.twig:6-10`, `assets/styles/app.css:1142`
- **Description:** Desktop nav dropdowns are triggered by `focus-within` CSS:
  ```css
  li:focus-within > .nav1-drop { visibility: visible; opacity: 1; }
  ```
  This works for keyboard users tabbing into the parent link. However:
  - No `aria-expanded` on the parent link indicates dropdown state to AT users
  - No `aria-haspopup` signals that a submenu exists
  - No explicit button to toggle the submenu (per ARIA disclosure navigation pattern)
  - Tabbing away should close the dropdown; unclear if this is handled
  - `aria-current="page"` is placed on `<li>`, not `<a>` (see Finding O-09)
- **Fix:** Add `aria-haspopup="true"` and `aria-expanded` to parent nav links that have submenus. Add a visible toggle button (chevron/triangle) per ARIA nav disclosure pattern.

---

#### Finding O-04 — Accordion space key not handled
- **WCAG:** 2.1.1 Keyboard (A)
- **Severity:** Major
- **Location:** `_html/templates/partials/accordion1.twig:4`
- **Description:** (See O-02 above.) The accordion only responds to Enter key. ARIA authoring practices require both Enter and Space to activate disclosure buttons.
- **Live evidence:** Confirmed on `/talent-opportunities/noblereach-scholars-program/`. Keyboard focus placed on "Computing & Cybersecurity" accordion heading. Enter key expanded the panel ✓. Space key scrolled the page instead of toggling the accordion ✗. Screenshot: `screenshots/accordion-keyboard-enter.png`.
- **Fix:** Add `@keydown.space.prevent="toggle()"` alongside the Enter handler.

---

### 2.4 Navigable

#### Finding O-05 — Skip links navigation region has no accessible name
- **WCAG:** 2.4.1 Bypass Blocks (A)
- **Severity:** Major
- **Location:** `_html/templates/partials/skips1.twig:1`
- **Description:**
  ```twig
  <nav{{ ['skips1', class]|attr('class') ... }}>
  ```
  The `<nav>` element wrapping skip links has no `aria-label` or `aria-labelledby`. With multiple `<nav>` elements on every page (skip nav, main nav, utility nav), screen reader users cannot distinguish them by landmark.
- **Live evidence:** Playwright snapshot shows an unlabeled `navigation` region inside the banner containing skip links.
- **Fix:** Add `aria-label="Skip links"` to `skips1.twig`'s `<nav>` element.

---

#### Finding O-06 — Main navigation and utility navigation have no accessible names
- **WCAG:** 2.4.1 Bypass Blocks (A)
- **Severity:** Major
- **Location:** `_html/templates/partials/nav1.twig:1`, `_html/templates/partials/nav2.twig`
- **Description:** The primary `<nav>` and the utility nav bar at the top of the page have no `aria-label`. Combined with the skip links nav (O-05), there are three or more unlabeled `<nav>` landmarks on every page. Screen reader users cannot distinguish "Main Navigation" from "Utility Navigation" from "Skip Links".
- **Fix:** Add `aria-label="Main"` to the primary nav, `aria-label="Utility"` to the utility bar nav, and `aria-label="Skip links"` to the skip nav.

---

#### Finding O-07 — Accesskeys conflict with assistive technology
- **WCAG:** Advisory (WCAG 2.2 does not require accesskeys; existing accesskeys may violate SC 2.1.4 if they conflict)
- **Severity:** Minor
- **Location:** `_html/templates/partials/skips1.twig:3-5`, `_html/templates/partials/nav1.twig:5`
- **Description:** Skip links use `accesskey="n"`, `accesskey="c"`, `accesskey="f"`. Nav links use `accesskey="1"` through `accesskey="5"`. Accesskeys conflict with browser shortcuts and screen reader commands. No documentation of these accesskeys is visible to users.
- **Fix:** Remove accesskeys, or if retained, document them prominently for users.

---

#### Finding O-08 — Staging arrow-key navigation script appears in production HTML
- **WCAG:** 2.1.4 Character Key Shortcuts (A)
- **Severity:** Major
- **Location:** `_html/templates/core/base.twig:53-59`
- **Description:** A script block marked `<!-- staging only { -->` binds the left/right arrow keys to navigate between pages:
  ```javascript
  document.onkeydown = function(event) {
      if(event.keyCode == '39') window.location = '{{ _nav.next }}';
      if(event.keyCode == '37') window.location = '{{ _nav.prev }}';
  };
  ```
  If this renders on the production site (the comment is only a code comment, not a conditional), arrow keys — which screen readers use to read content — will trigger page navigation. This would be a severe keyboard trap for AT users.
- **Live evidence:** Could not confirm whether this script block executes on production (Twig `_nav.next/_nav.prev` values may be empty). **Must verify before launch.**
- **Fix:** Wrap in a Twig environment conditional so it only renders in the design-system preview context, not in WordPress production output.

---

#### Finding O-09 — `aria-current="page"` on `<li>` instead of `<a>`
- **WCAG:** 1.3.1 Info and Relationships (A)
- **Severity:** Minor
- **Location:** `_html/templates/partials/nav1.twig:4`
- **Description:**
  ```twig
  <li{{ item|compactize in [base.section|compactize] ? ' aria-current="page"' }}>
  ```
  `aria-current="page"` is placed on the `<li>` element, not the `<a>` anchor. Screen readers look for `aria-current` on the interactive element (the link), not its container. This may not be announced correctly by all AT.
- **Fix:** Move `aria-current="page"` to the `<a>` element inside the list item.

---

## 3. Understandable

### 3.1 Readable

#### Finding U-01 — `html` `lang` attribute is set correctly
- **WCAG:** 3.1.1 Language of Page (A)
- **Severity:** Pass
- **Location:** `_html/templates/core/base.twig:2`
- **Description:** `<html lang="en">` is present. ✓

---

### 3.2 Predictable

#### Finding U-02 — Social links open in new tab without warning
- **WCAG:** 3.2.2 On Input (A)
- **Severity:** Minor
- **Location:** `_html/templates/partials/socials1.twig:6`
- **Description:** Social links use `target="_blank"` with no visual or audible indication that they open a new tab. The `aria-label="Share on LinkedIn"` also uses misleading language — these are links to NobleReach's profiles, not share actions.
- **Fix:** Add a visually hidden warning to the aria-label: `aria-label="LinkedIn (opens in new tab)"`. Alternatively, add a new-tab icon with a visually-hidden warning span.

---

#### Finding U-03 — `logo2.twig` hardcodes `aria-label="Company Name"` placeholder
- **WCAG:** 4.1.2 Name, Role, Value (A)
- **Severity:** Major
- **Location:** `_html/templates/partials/logo2.twig:5`
- **Description:** The secondary logo partial contains:
  ```twig
  <{{ link|notfalse ? 'a href="./"' : 'div' }} class="logo2-wrap " aria-label="Company Name">
  ```
  "Company Name" is a placeholder. Any `<a>` rendered using this partial will have the accessible name "Company Name" — meaningless for screen reader users.
- **Fix:** Pass the actual company name as a variable and render it: `aria-label="{{ partner_name }}"`. The PHP template using this component must supply the value.

---

### 3.3 Input Assistance

#### Finding U-04 — Custom form error handling not verifiable from code alone
- **WCAG:** 3.3.1 Error Identification (A), 3.3.3 Error Suggestion (AA)
- **Severity:** Not tested
- **Location:** Gravity Forms rendered output
- **Description:** Gravity Forms has built-in accessible error handling (ARIA live regions, `aria-required`, `aria-invalid`). However, the site uses classic Gravity Forms rendering (`[gravityform]` shortcode) with potential custom CSS that could hide error states. Not testable from code alone.
- **Fix:** Test form submission with intentional errors in a browser with a screen reader. Verify that `aria-live="assertive"` error containers are read aloud.

---

## 4. Robust

### 4.1 Compatible

#### Finding R-01 — `<a>` elements used as buttons sitewide
- **WCAG:** 4.1.2 Name, Role, Value (A)
- **Severity:** Major
- **Location:** Multiple partials (see O-01)
- **Description:** See O-01. JavaScript-driven controls implemented as `<a>` elements provide incorrect role ("link") to AT. Consolidated here for WCAG mapping.

---

#### Finding R-02 — Accordion missing `aria-expanded` and `aria-controls`
- **WCAG:** 4.1.2 Name, Role, Value (A)
- **Severity:** Critical
- **Location:** `_html/templates/partials/accordion1.twig`
- **Description:** See O-02. Consolidated here for WCAG mapping. The expanded/collapsed state of accordion panels is not communicated to AT.

---

#### Finding R-03 — JavaScript error may affect interactive component behavior
- **WCAG:** 4.1.1 Parsing (A)
- **Severity:** Major
- **Location:** `assets/scripts/app.js:866`
- **Description:** The console error `TypeError: Cannot redefine property: $persist` fires on every tested page. Alpine.js persistence plugin conflict. If this breaks the Alpine.js store initialization, all components using `$store.app.states.*` (drawers, overlays, navigation) may fail silently without keyboard fallback.
- **Fix:** Resolve the Alpine.js `$persist` conflict in `app.js`. Verify that modal/drawer functionality degrades gracefully if JavaScript fails.

---

#### Finding R-04 — `noblereach-map.js` fails to load (404)
- **WCAG:** 4.1.1 Parsing (A)
- **Severity:** Major
- **Location:** `https://noblereach.org/wp-content/themes/noblereach-2024/assets/js/noblereach-map.js` (404)
- **Description:** The map asset is missing, causing a JS error on every page load. Map interactive components are completely non-functional. MapSVG interactive maps — already inaccessible by default — are doubly broken.
- **Fix:** Restore the missing JS file. Then address MapSVG accessibility: SVG maps require ARIA roles, keyboard navigation, and text alternatives for each region.

---

#### Finding R-05 — `:disabled` attribute on `<a>` elements in carousel
- **WCAG:** 4.1.2 Name, Role, Value (A)
- **Severity:** Major
- **Location:** `_html/templates/partials/carousel1.twig:15`
- **Description:** `<a>` elements use `:disabled` (Alpine.js binding) to disable carousel arrows at boundaries. The `disabled` attribute is not valid on `<a>` elements; it has no semantic effect. AT will not communicate the disabled state to users, and the element remains in the tab order.
- **Fix:** Use `<button>` instead of `<a>`. On `<button>`, `:disabled` is a valid Alpine binding that maps to the `disabled` attribute, correctly removing the button from tab order and communicating its state.

---

## Summary Table

| ID | WCAG | Criterion | Severity | Source |
|---|---|---|---|---|
| P-01 | 1.3.1 / 2.4.1 | No `<main>` landmark | Critical | Code + Live |
| P-02 | 1.3.1 / 2.4.6 | Person page: no H1, name is H5 | Critical | Code + Live |
| P-03 | 1.3.1 / 2.4.6 | Story page: no H1, title is H4 | Critical | Code + Live |
| P-04 | 1.3.1 / 2.4.6 | Homepage heading hierarchy broken | Major | Live |
| P-05 | 1.3.1 | News article skips H2 | Major | Live |
| P-06 | 1.1.1 / 4.1.2 | Carousel arrows: no accessible name | Critical | Code + Live |
| P-07 | 1.1.1 | noscript images have empty alt | Major | Code |
| P-08 | 2.4.6 / 4.1.2 | CARD_TITLE_GOES_HERE placeholder | Critical | Code + Live |
| P-09 | 1.1.1 | Logo alt text — verify consistency | Minor | Code |
| P-10 | 1.2.2 / 1.2.3 | Video captions not verified | Not tested | — |
| P-13 | 1.1.1 | Person photo + story hero images: no alt text | Critical | Live |
| P-11 | 2.4.7 | Skip link outline: none | Major | Code |
| P-12 | 1.4.3 / 1.4.11 | Contrast requires live testing | Not tested | — |
| O-01 | 4.1.2 | Interactive `<a>` used as buttons | Major | Code |
| O-02 | 4.1.2 / 2.1.1 | Accordion: no button, no aria-expanded | Critical | Code |
| O-03 | 2.1.1 | Dropdown nav inaccessible by keyboard | Major | Code |
| O-04 | 2.1.1 | Accordion space key not handled | Major | Code |
| O-05 | 2.4.1 | Skip links nav: no aria-label | Major | Code + Live |
| O-06 | 2.4.1 | Main and utility nav: no aria-label | Major | Code + Live |
| O-07 | Advisory | Accesskeys conflict with AT | Minor | Code |
| O-08 | 2.1.4 | Staging arrow-key script may be live | Major | Code |
| O-09 | 1.3.1 | aria-current on `<li>` not `<a>` | Minor | Code |
| U-01 | 3.1.1 | lang="en" set correctly | Pass | Code |
| U-02 | 3.2.2 | Links open new tab without warning | Minor | Code |
| U-03 | 4.1.2 | logo2 "Company Name" placeholder | Major | Code |
| U-04 | 3.3.1 / 3.3.3 | Form error handling not tested | Not tested | — |
| R-01 | 4.1.2 | `<a>` used as buttons (consolidated) | Major | Code |
| R-02 | 4.1.2 | Accordion aria-expanded missing | Critical | Code |
| R-03 | 4.1.1 | JS error may break AT interactions | Major | Live |
| R-04 | 4.1.1 | map.js 404 — maps broken | Major | Live |
| R-05 | 4.1.2 | `:disabled` on `<a>` elements | Major | Code |
