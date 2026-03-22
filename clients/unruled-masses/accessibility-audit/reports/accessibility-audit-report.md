# Accessibility Audit Report — Unruled Masses

**Site:** https://unruledmasses.org
**Audit date:** 2026-03-22
**Standard:** WCAG 2.2 Level AA
**Codebase:** `/Users/timarnold/sites-personal/um-launch-page` (Next.js + Sanity)
**Auditor:** Two-pass — code review (filesystem) + live browser audit (Playwright)

---

## Executive Summary

- The site has a solid accessibility foundation: skip link, `lang="en"`, single H1 per page (except homepage where SVG section headings create sibling H2 conflicts), proper `<main>` landmark, good image alt text, and fully labelled form inputs.
- **Two Critical issues** require immediate attention: accordion buttons site-wide have no `aria-expanded` or `aria-controls` (screen readers cannot determine state), and the skip link target lacks `tabindex="-1"` so it provides no practical benefit to keyboard users.
- **Five Major issues** degrade experience significantly: two hero buttons with invisible focus rings, the mobile menu trigger missing `aria-expanded`, the carousel lightbox modal with no role or focus trap, form error messages not announced to screen readers, and the consent banner invisible to AT.
- The heading hierarchy on the homepage has repeated H2 pairs that should be H2 + H3 — the same SVG heading pattern appears in three sections.
- All issues are template or component-level fixes in Next.js; none require content or infrastructure changes. Most are 1–4 hour fixes.
- Lighthouse Accessibility score is already 96/100 on both tested pages — these issues are not caught by automated tools, which confirms the need for manual review.

---

## 1. WCAG 2.2 Compliance Summary

| Criterion | Level | Status | Notes |
|---|---|---|---|
| 1.1.1 Non-text Content | A | Pass | Images have alt text; decorative images use `alt=""` |
| 1.2.1 Audio-only / Video-only | A | N/A | No prerecorded audio-only content |
| 1.2.2 Captions | A | N/A | No live media |
| 1.2.3 Audio Description | A | N/A | |
| 1.3.1 Info and Relationships | A | Partial | Heading hierarchy issues on homepage; footer labels semantic issue |
| 1.3.2 Meaningful Sequence | A | Pass | |
| 1.3.3 Sensory Characteristics | A | Pass | |
| 1.3.4 Orientation | AA | Pass | No orientation lock |
| 1.3.5 Identify Input Purpose | AA | Pass | All form inputs use `autocomplete` attributes |
| 1.3.6 Identify Purpose | AAA | Partial | Carousel lacks ARIA identification |
| 1.4.1 Use of Color | A | Pass | No color-only information |
| 1.4.2 Audio Control | A | N/A | No auto-play audio |
| 1.4.3 Contrast (Minimum) | AA | Pass | Brand colors tested; no clear failures detected |
| 1.4.4 Resize Text | AA | Pass | Uses rem units, font scales |
| 1.4.5 Images of Text | AA | Pass | SVG headings have sr-only text equivalents |
| 1.4.10 Reflow | AA | Pass | Site is responsive |
| 1.4.11 Non-text Contrast | AA | Pass | UI components have sufficient border/color contrast |
| 1.4.12 Text Spacing | AA | Pass | |
| 1.4.13 Content on Hover/Focus | AA | Pass | |
| 2.1.1 Keyboard | A | Pass | All interactive elements are keyboard-reachable |
| 2.1.2 No Keyboard Trap | A | Fail | Carousel lightbox modal — no focus trap (F-05) |
| 2.1.4 Character Key Shortcuts | AA | Pass | No single-character shortcuts |
| 2.2.1 Timing Adjustable | A | N/A | No time limits |
| 2.2.2 Pause/Stop/Hide | A | N/A | No auto-advancing content except optional carousel |
| 2.3.1 Three Flashes | A | Pass | |
| 2.4.1 Bypass Blocks | A | Fail | Skip link present but target unfocusable (F-02) |
| 2.4.2 Page Titled | A | Pass | Unique titles on all pages |
| 2.4.3 Focus Order | A | Pass | Tab order is logical |
| 2.4.4 Link Purpose | A | Partial | PDF links lack type/new-tab warning (F-11) |
| 2.4.5 Multiple Ways | AA | Pass | Nav + footer links |
| 2.4.6 Headings and Labels | AA | Partial | Homepage heading hierarchy (F-08) |
| 2.4.7 Focus Visible | AA | Fail | Two hero buttons no focus ring (F-03) |
| 2.4.11 Focus Appearance | AA | Pass | Focus indicators otherwise visible throughout |
| 2.4.12 Focus Not Obscured (Minimum) | AA | Pass | Fixed header does not obscure focused elements |
| 2.5.3 Label in Name | A | Pass | |
| 2.5.8 Target Size (Minimum) | AA | Pass | Buttons meet minimum target sizes |
| 3.1.1 Language of Page | A | Pass | `<html lang="en">` |
| 3.1.2 Language of Parts | AA | Pass | |
| 3.2.1 On Focus | A | Pass | |
| 3.2.2 On Input | A | Pass | |
| 3.2.3 Consistent Navigation | AA | Pass | Nav identical across pages |
| 3.2.4 Consistent Identification | AA | Pass | |
| 3.3.1 Error Identification | A | Fail | Form errors not announced to AT (F-06) |
| 3.3.2 Labels or Instructions | A | Pass | All required fields labelled; asterisk + red color used |
| 3.3.3 Error Suggestion | AA | Not Tested | Error messages descriptive when visible |
| 4.1.1 Parsing | A | Pass | No critical HTML parsing errors |
| 4.1.2 Name, Role, Value | A | Fail | Accordion buttons missing `aria-expanded` (F-01); mobile menu trigger (F-04) |
| 4.1.3 Status Messages | AA | Fail | Consent banner (F-07), form errors (F-06) not announced |

---

## 2. Critical Issues

### C-1 — Accordion buttons missing `aria-expanded` and `aria-controls`
**WCAG:** 4.1.2 Name, Role, Value
**File:** `src/app/components/AccordionItem.tsx` lines 21–35
**Affects:** All accordion instances: "How It All Works" (7 items) on homepage, "The stewards of this work" (4 items) on homepage and `/our-team`

Every accordion disclosure button omits `aria-expanded`. Screen readers cannot determine whether a panel is open or closed. The visual chevron rotates, but this is invisible to AT. Content panels also lack `id` attributes for `aria-controls` reference.

**Fix:** In `AccordionItem.tsx`:
```tsx
// Add unique id to button and panel
const panelId = `accordion-panel-${title.replace(/\s+/g, '-').toLowerCase()}`;
const buttonId = `accordion-btn-${title.replace(/\s+/g, '-').toLowerCase()}`;

<button
  id={buttonId}
  onClick={toggle}
  aria-expanded={open}
  aria-controls={panelId}
  className="..."
>

<div
  id={panelId}
  role="region"
  aria-labelledby={buttonId}
  className="..."
>
```
**Effort:** 1 hour | **Resolves:** WCAG 4.1.2 on all accordion instances

---

### C-2 — Skip link target not focusable — skip link provides no benefit
**WCAG:** 2.4.1 Bypass Blocks
**File:** `src/app/(site)/layout.tsx` line 84
**Affects:** All pages

The skip link is visually correct but broken functionally. `<main id="main-content">` lacks `tabindex="-1"`, so browser focus does not move to main content when the link is activated. Users must Tab through the entire header (skip link, logo, 3 nav links, 2 CTA buttons = ~7 stops) to reach main content.

**Fix:** One-line change:
```tsx
<main id="main-content" tabIndex={-1}>{children}</main>
```
**Effort:** 15 minutes | **Resolves:** WCAG 2.4.1

---

## 3. Major Issues

### M-1 — "Get Involved" and video play buttons have no visible focus indicator
**WCAG:** 2.4.7 Focus Visible
**File:** `src/app/components/sections/HeroSection.tsx` lines 91–97 (Get Involved), 107–125 (video play button)
**Affects:** Homepage hero section

Both buttons have no `focus:` or `focus-visible:` Tailwind classes and fall back to the global `outline-ring/50` (50%-opacity gray outline). This fails to meet the minimum visible focus requirement. All other buttons on the site have explicit focus ring styles.

**Fix:** Add `focus-visible:outline` classes to both buttons:
```tsx
// Get Involved button — add to className:
focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white

// Video play button — add to className:
focus-visible:outline focus-visible:outline-4 focus-visible:outline-white
```
**Effort:** 30 minutes | **Resolves:** WCAG 2.4.7

---

### M-2 — Mobile menu trigger missing `aria-expanded`
**WCAG:** 4.1.2 Name, Role, Value
**File:** `src/app/components/Header.tsx` lines 149–155
**Affects:** All pages (mobile viewport)

The hamburger button has `aria-label="Open menu"` but no `aria-expanded`. When the menu opens, screen readers do not know the button's state has changed. The dialog itself (Radix Sheet) is correctly implemented.

**Fix:**
```tsx
<button
  onClick={() => setMobileMenuOpen(true)}
  aria-expanded={mobileMenuOpen}
  aria-label={mobileMenuOpen ? 'Close menu' : 'Open menu'}
  className="..."
>
```
**Effort:** 30 minutes | **Resolves:** WCAG 4.1.2

---

### M-3 — Carousel lightbox modal missing role, focus trap, and Escape handler
**WCAG:** 2.1.2 No Keyboard Trap (inverse), 4.1.2 Name, Role, Value
**File:** `src/app/components/ImageCarousel.tsx` lines 151–178
**Affects:** Homepage (What We're Building section)

When a user clicks a carousel image to open the full-size lightbox:
- The modal div has no `role="dialog"` or `aria-modal="true"`
- No `aria-label` describing the content
- No focus trap — Tab exits the modal freely to the page behind
- No Escape key handler — keyboard users cannot close it without clicking the button
- Focus is not moved to the modal on open or returned to the trigger on close

Compare to `DonateSection.tsx` which correctly implements all of these patterns.

**Fix:**
```tsx
// Add to modal div:
role="dialog"
aria-modal="true"
aria-label={`Full size: ${images[currentIndex].alt}`}

// Add to component:
useEffect(() => {
  if (!isModalOpen) return;
  closeButtonRef.current?.focus();
  const onKey = (e: KeyboardEvent) => { if (e.key === 'Escape') closeModal(); };
  document.addEventListener('keydown', onKey);
  return () => document.removeEventListener('keydown', onKey);
}, [isModalOpen]);
```
Add a `ref` to the close button and call `ref.current.focus()` on open. Return focus to the image that triggered the modal on close.

**Effort:** 2–3 hours | **Resolves:** WCAG 2.1.2, 4.1.2

---

### M-4 — Form error messages not announced to screen readers
**WCAG:** 3.3.1 Error Identification, 4.1.3 Status Messages
**Files:** `src/app/components/ContactForm.tsx` line 247, `src/app/components/sections/DonateSection.tsx` line 216
**Affects:** Contact form (homepage, /our-team), Founding member signup (homepage)

Error messages injected into the DOM on submission failure use plain `<div>` elements. Screen readers will not announce these dynamically — users are left without feedback that submission failed.

**Fix:** Add `role="alert"` to both error containers:
```tsx
{error && (
  <div role="alert" className="mb-4 p-3 bg-red-50 border border-red-200 rounded-md text-red-700 text-sm">
    {error}
  </div>
)}
```
**Effort:** 30 minutes | **Resolves:** WCAG 3.3.1, 4.1.3

---

### M-5 — Consent banner not announced to screen readers
**WCAG:** 4.1.3 Status Messages
**File:** `src/app/components/ConsentBanner.tsx`
**Affects:** All pages (first visit)

The consent banner appears dynamically after hydration as a plain `<div>`. Screen reader users receive no notification that a cookie consent decision is required. The Accept/Decline buttons are keyboard-reachable via Tab, but the banner's existence is not announced.

**Fix:**
```tsx
<div
  role="dialog"
  aria-label="Cookie consent"
  aria-modal="false"
  className="fixed bottom-0 left-0 right-0 z-50 shadow-lg"
  style={{ backgroundColor: '#e2b624' }}
>
```
Also move initial focus to the Accept button when the banner appears, or use `aria-live="polite"` as a fallback.

**Effort:** 1 hour | **Resolves:** WCAG 4.1.3

---

## 4. Minor Issues

### Mi-1 — Homepage heading hierarchy has repeated H2 pairs
**WCAG:** 1.3.1 Info and Relationships, 2.4.6 Headings and Labels
**Affects:** Homepage only

Three sections use the same pattern: an SVG-image H2 followed immediately by a text H2. The second H2 in each pair is a subsection title and should be H3. Affects screen reader users navigating by heading.

| Section | SVG H2 | Text H2 (→ should be H3) | File | Line |
|---|---|---|---|---|
| What We're Building | "What We're Building" (sr-only) | "A system that turns awareness..." | Wait, actually this is H3 already | — |
| Donate | "Support the Mission" (sr-only) | "Help us build this movement." | `DonateSection.tsx` | 103, 120 |
| Playbook | "Action Playbook" (sr-only) | "Action Playbook Samples" | `PlaybookSection.tsx` | 30, 46 |

**Fix:** Change the text-content heading in each pair from `<h2>` to `<h3>`. No visual change — font sizing is controlled by Tailwind utility classes.
**Effort:** 30 minutes

---

### Mi-2 — Footer nav groups not semantically marked up
**WCAG:** 1.3.1 Info and Relationships
**File:** `src/app/components/Footer.tsx` lines 108, 119, 130

"Navigate", "Legal", and "Connect" are `<p>` elements. Their `<ul>` lists are not wrapped in `<nav>`. Screen reader users navigating by landmark cannot jump to footer links.

**Fix:** Wrap each column in `<nav aria-label="[label]">` and change the `<p>` to `<h2>` styled to match current appearance.
**Effort:** 1 hour

---

### Mi-3 — `/our-team` page creates two `<header>` landmarks
**WCAG:** 1.3.1 Info and Relationships
**File:** `src/app/(site)/our-team/page.tsx` line 77

The page hero uses `<header>` for the banner area. Combined with the site `<Header>` (which renders as a `<header>` landmark), there are two `<header>` (banner) regions in the accessibility tree.

**Fix:** Change `<header>` on line 77 to `<section aria-label="Page header">` or just `<div>`.
**Effort:** 15 minutes

---

### Mi-4 — Carousel has no live region for image changes
**WCAG:** 4.1.3 Status Messages
**File:** `src/app/components/ImageCarousel.tsx`

When the carousel advances, the image change is not announced. Screen reader users cannot follow carousel navigation even though buttons are keyboard-operable.

**Fix:** Add an `aria-live` region:
```tsx
<div aria-live="polite" aria-atomic="true" className="sr-only">
  Image {currentIndex + 1} of {images.length}: {images[currentIndex].alt}
</div>
```
**Effort:** 30 minutes

---

### Mi-5 — Playbook PDF links have no file type or new-tab warning
**WCAG:** 2.4.4 Link Purpose
**File:** `src/app/components/sections/PlaybookSection.tsx` lines 63–79

All 8 playbook links open PDFs in a new tab with no notification.

**Fix:** Add `aria-label` or visually hidden text: `"${item.title} — PDF, opens in new tab"`.
**Effort:** 30 minutes

---

## 5. Component-Specific Findings

### Navigation (Header)

| Check | Status | Notes |
|---|---|---|
| Skip link present | Pass | Visible on first Tab, styled correctly |
| Skip link functional | Fail | Target lacks `tabindex="-1"` (C-2) |
| Desktop nav has `<nav>` landmark | Pass | `<nav aria-label="Site navigation">` present |
| Mobile menu trigger has `aria-expanded` | Fail | Missing (M-2) |
| Mobile nav has `<nav>` landmark | Pass | `<nav aria-label="Mobile navigation">` in Radix dialog |
| Mobile dialog accessible | Pass | Radix Sheet provides role, focus mgmt, Escape to close |
| Focus indicator on all nav elements | Pass | Links have default underline + color change + outline |

### Accordions (How It All Works, The Stewards of This Work)

| Check | Status | Notes |
|---|---|---|
| Button is `<button>` element | Pass | Correct element |
| `aria-expanded` | Fail | Missing on all accordions (C-1) |
| `aria-controls` | Fail | Missing on all accordions (C-1) |
| Keyboard activation | Pass | Enter activates; Space activates |
| Focus indicator | Pass | Default outline visible |
| Panel content reachable after expand | Pass | Content is in DOM, not `display:none` |

### Contact Form (`/our-team`, homepage)

| Check | Status | Notes |
|---|---|---|
| All inputs have labels | Pass | `for`/`id` pairing on all fields |
| Required field indicators | Pass | Red `*` + `required` attribute |
| Newsletter checkbox | Pass | Implicit label via wrapping `<label>` |
| `autocomplete` attributes | Pass | `given-name`, `family-name`, `email`, `tel` |
| Error messages announced | Fail | No `role="alert"` (M-4) |
| Submit button state | Pass | Disabled state visually clear |
| Form has accessible name | Pass | `aria-label="Contact inquiry form"` |

### Image Carousel (Homepage)

| Check | Status | Notes |
|---|---|---|
| Previous/Next buttons labelled | Pass | `aria-label="Previous image"` / `aria-label="Next image"` |
| Arrow buttons keyboard-operable | Pass | Tab + Enter works |
| Focus indicator on arrows | Pass | Default outline visible |
| Image alt text | Pass | All carousel images have descriptive `alt` |
| Live region for image changes | Fail | No announcement on navigation (Mi-4) |
| Lightbox modal role | Fail | No `role="dialog"` (M-3) |
| Lightbox focus management | Fail | No focus trap or Escape handler (M-3) |

### Consent Banner

| Check | Status | Notes |
|---|---|---|
| Buttons keyboard-reachable | Pass | In tab order |
| Banner announced to AT | Fail | No ARIA role or live region (M-5) |

### Footer

| Check | Status | Notes |
|---|---|---|
| `<footer>` landmark | Pass | Footer rendered as `<footer>` |
| Nav groups as `<nav>` | Fail | "Navigate", "Legal", "Connect" use `<p>` labels (Mi-2) |
| Social links accessible | Pass | Link text describes platform name |
| External links (`target="_blank"`) | Pass | `rel="noopener noreferrer"` on all |

---

## 6. Remediation Recommendations

### Priority order for greatest accessibility impact

#### Fix immediately (Critical — breaks or severely impairs access for AT users)

| Fix | File | Lines | WCAG | Effort |
|---|---|---|---|---|
| Add `tabIndex={-1}` to `<main>` | `layout.tsx` | 84 | 2.4.1 | 15 min |
| Add `aria-expanded`, `aria-controls`, panel `id` to AccordionItem | `AccordionItem.tsx` | 21–45 | 4.1.2 | 1 hr |

#### Fix soon (Major — significant degraded experience)

| Fix | File | Lines | WCAG | Effort |
|---|---|---|---|---|
| Add focus-visible styles to "Get Involved" and video play buttons | `HeroSection.tsx` | 91, 107 | 2.4.7 | 30 min |
| Add `aria-expanded` to mobile menu trigger | `Header.tsx` | 149 | 4.1.2 | 30 min |
| Add role, focus trap, Escape handler to carousel lightbox | `ImageCarousel.tsx` | 151–178 | 2.1.2, 4.1.2 | 2–3 hr |
| Add `role="alert"` to form error divs | `ContactForm.tsx`, `DonateSection.tsx` | 247, 216 | 4.1.3 | 30 min |
| Add dialog role/live region to consent banner | `ConsentBanner.tsx` | — | 4.1.3 | 1 hr |

#### Planned work (Minor — best-practice violations)

| Fix | File | WCAG | Effort |
|---|---|---|---|
| Fix homepage H2→H3 in Donate and Playbook sections | `DonateSection.tsx`, `PlaybookSection.tsx` | 1.3.1 | 30 min |
| Wrap footer nav groups in `<nav>` with `aria-label` | `Footer.tsx` | 1.3.1 | 1 hr |
| Change `/our-team` page `<header>` to `<section>` or `<div>` | `our-team/page.tsx` | 1.3.1 | 15 min |
| Add `aria-live` region to carousel | `ImageCarousel.tsx` | 4.1.3 | 30 min |
| Add PDF file type warning to playbook links | `PlaybookSection.tsx` | 2.4.4 | 30 min |

---

## Testing Process to Verify Fixes

**Automated (add to CI):**
- `axe-core` via `@axe-core/playwright` on all pages — catches role/ARIA mismatches and missing labels after fixes
- Lighthouse Accessibility audit in CI — should reach 100/100 once accordion and form fixes are in

**Keyboard walk (manual — 30 min per page):**
1. Tab through homepage from top to bottom, verify every interactive element has a visible focus ring
2. Activate "Skip to main content" — confirm focus lands in `<main>` and Tab reaches first article link next
3. Open and close mobile menu — verify `aria-expanded` toggles and focus returns to trigger
4. Expand and collapse all accordions — verify state changes are audible in screen reader
5. Navigate carousel with keyboard — verify image changes are announced

**Screen reader testing:**
- **macOS VoiceOver** (⌘F5): Navigate by headings (H key), landmarks (W key), and form fields (F key). Confirm accordion state, form errors, and consent banner are announced.
- **NVDA + Chrome** (Windows): Repeat landmark and heading navigation; test accordion and form error announcement.

**Suggested test order (highest value first):** Accordion fix → Skip link fix → Focus indicator fixes → Form error fixes → Consent banner fix

---

## SEO Audit Cross-Reference

Issues overlapping with the SEO audit findings:

| Issue | SEO Impact | A11y Impact | Combined Priority |
|---|---|---|---|
| Homepage missing alt text on 25 images | Image indexing | Non-text Content (1.1.1) | Already fixed (code shows alt text present) |
| Empty `<h2>` on /our-team | Crawler confusion | Meaningless heading for AT | Fix in Sanity content (empty CMS field) |
| Heading hierarchy | Keyword signal clarity | Navigation by heading | High — fix heading structure on homepage |
| `/playbooks` returns 404 | Lost traffic | Broken link from homepage nav | Fix in site routing (separate issue) |
