# Accessibility Findings — Unruled Masses

**Site:** https://unruledmasses.org
**Audit date:** 2026-03-22
**Standard:** WCAG 2.2 Level AA
**Methods:** Code audit (local repo at `/Users/timarnold/sites-personal/um-launch-page`) + Live browser audit (Playwright)

---

## Summary Table

| ID | WCAG | Criterion | Severity | Source | Component / URL |
|---|---|---|---|---|---|
| F-01 | 4.1.2 | Name, Role, Value | Critical | Code + Live | `AccordionItem.tsx` — all pages |
| F-02 | 2.4.1 | Bypass Blocks | Critical | Code + Live | `layout.tsx` — all pages |
| F-03 | 2.4.7 | Focus Visible | Major | Code + Live | `HeroSection.tsx` — homepage |
| F-04 | 4.1.2 | Name, Role, Value | Major | Code + Live | `Header.tsx` — all pages |
| F-05 | 4.1.2 | Name, Role, Value | Major | Code | `ImageCarousel.tsx` modal — homepage |
| F-06 | 4.1.3 | Status Messages | Major | Code | `ContactForm.tsx`, `DonateSection.tsx` — homepage, /our-team |
| F-07 | 4.1.3 | Status Messages | Major | Code + Live | `ConsentBanner.tsx` — all pages |
| F-08 | 1.3.1 | Info and Relationships | Major | Code + Live | Homepage heading hierarchy |
| F-09 | 1.3.1 | Info and Relationships | Minor | Code + Live | `Footer.tsx` — all pages |
| F-10 | 1.3.6 | Identify Purpose | Minor | Code + Live | Carousel — homepage |
| F-11 | 2.4.4 | Link Purpose | Minor | Live | Playbook PDF links — homepage |
| F-12 | 1.3.1 | Info and Relationships | Minor | Code | `/our-team` dual header landmark |

---

## 1. Perceivable

---

### F-08 — Homepage heading hierarchy is broken
**WCAG:** 1.3.1 Info and Relationships
**Severity:** Major
**Source:** Code + Live
**Pages:** `/` (homepage)

Three section pairs each emit two sibling H2 elements where one should be H3:

| Section | First H2 | Second H2 (should be H3) | File |
|---|---|---|---|
| Donate | "Support the Mission" (SVG, sr-only) | "Help us build this movement." | `DonateSection.tsx` L103, L120 |
| Playbook | "Action Playbook" (SVG, sr-only) | "Action Playbook Samples" | `PlaybookSection.tsx` L30, L46 |
| What We're Building | "The systems meant to protect people are failing." | "What We're Building" (SVG, sr-only) | `WhatWereBuildingSection.tsx` L145, L161 |

Additionally, the contact form section on `/our-team` has an H2 "Contact Us" (line 149 in `our-team/page.tsx`) followed by an H3 "Contact Inquiry" inside `ContactForm.tsx` — this hierarchy is correct on its own, but "Contact Inquiry" is semantically redundant.

**Recommended fix:**
In `DonateSection.tsx`, change `<h2 className="text-3xl...">` on line 120 to `<h3>`.
In `PlaybookSection.tsx`, change `<h2 className="text-2xl...">` on line 46 to `<h3>`.
In `WhatWereBuildingSection.tsx`, change the problem section `<h2>` on line 145 to `<h2>` and the SVG "What We're Building" `<h2>` on line 161 to `<h3>` (it is a subsection label, not a sibling section). Review full heading outline after changes.

---

### F-09 — Footer section labels are `<p>` elements, not semantic headings or nav landmarks
**WCAG:** 1.3.1 Info and Relationships
**Severity:** Minor
**Source:** Code + Live
**File:** `src/app/components/Footer.tsx` lines 108, 119, 130
**Location:** All pages — footer

"Navigate", "Legal", and "Connect" labels render as `<p className="text-brand-gold font-bold...">`. The `<ul>` lists beneath them are not wrapped in `<nav>` elements.

**Recommended fix:** Wrap each column's content in `<nav aria-label="Navigate">`, `<nav aria-label="Legal">`, `<nav aria-label="Connect">`, and change the label `<p>` to a visually styled heading (`<h2>` or `<h3>`), or use `aria-labelledby` pointing to the label paragraph.

---

### F-12 — `/our-team` page creates two `<header>` landmarks
**WCAG:** 1.3.1 Info and Relationships
**Severity:** Minor
**Source:** Code
**File:** `src/app/(site)/our-team/page.tsx` line 77

The page-level hero section uses `<header className="relative overflow-hidden">` for the page banner. The site layout also wraps the `<Header>` component in a `<header>`. This creates two `<header>` (banner) landmarks in the accessibility tree, which is confusing for screen reader users navigating by landmarks.

**Recommended fix:** Change `<header>` on line 77 of `our-team/page.tsx` to `<div>` or `<section>`. Reserve `<header>` for the global site header. If a heading is needed, the `<h1>` inside is sufficient.

---

## 2. Operable

---

### F-02 — Skip link target lacks `tabindex="-1"` — focus not received
**WCAG:** 2.4.1 Bypass Blocks
**Severity:** Critical
**Source:** Code + Live
**File:** `src/app/(site)/layout.tsx` line 84
**Location:** All pages

The skip link on line 73–77 is correctly implemented (`href="#main-content"`, visually appears on first Tab, styled with red background). However, `<main id="main-content">` on line 84 does not have `tabindex="-1"`. When a user activates the skip link, the URL updates to `/#main-content` but keyboard focus returns to `<body>` instead of moving into `<main>`. Tab must then traverse the entire header navigation again before reaching main content — the skip link provides no actual benefit.

**Recommended fix:**
```tsx
// layout.tsx line 84
<main id="main-content" tabIndex={-1}>{children}</main>
```

---

### F-03 — "Get Involved" and video play buttons have no visible focus indicator
**WCAG:** 2.4.7 Focus Visible
**Severity:** Major
**Source:** Code + Live
**File:** `src/app/components/sections/HeroSection.tsx` lines 91–97, 107–125
**Location:** Homepage hero section

The "Get Involved" button (line 91) and the video play button (line 107) have no Tailwind `focus:` or `focus-visible:` classes. They rely solely on the global `* { @apply outline-ring/50; }` rule in `theme.css`, which applies a 50%-opacity gray outline. This is insufficient contrast and may not be visible against the white background.

All other buttons tested (Donate, carousel arrows, form submit) have explicit `focus:ring-2 focus:ring-brand-blue` classes or equivalent — these pass. The two hero buttons are anomalies.

**Recommended fix:**
```tsx
// HeroSection.tsx — "Get Involved" button
className="bg-brand-blue hover:bg-brand-blue-dark text-white px-8 py-3 font-bold uppercase tracking-widest text-sm transition-colors focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white"

// HeroSection.tsx — video play button
className="absolute inset-0 w-full h-full group cursor-pointer focus-visible:outline focus-visible:outline-4 focus-visible:outline-white"
```

---

## 3. Understandable

No Level AA failures found under Understandable beyond heading structure (covered in F-08).

---

## 4. Robust

---

### F-01 — All accordion disclosure buttons missing `aria-expanded` and `aria-controls`
**WCAG:** 4.1.2 Name, Role, Value
**Severity:** Critical
**Source:** Code + Live
**File:** `src/app/components/AccordionItem.tsx` lines 21–35
**Location:** Homepage (How It All Works — 7 items; The stewards of this work — 4 items), `/our-team` (The stewards of this work — 4 items)

The accordion button renders as:
```tsx
<button onClick={toggle} className="...">
  <span>{title}</span>
  <ChevronDown className={`... ${open ? 'rotate-180' : ''}`} />
</button>
```

The `open` state controls the ChevronDown rotation and the content `max-h` transition, but is never communicated to assistive technology. Screen readers cannot determine whether an accordion panel is expanded or collapsed. The content panel also has no `id` for `aria-controls` reference.

**Recommended fix in `AccordionItem.tsx`:**
```tsx
const panelId = `accordion-panel-${title.replace(/\s+/g, '-').toLowerCase()}`;

<button
  onClick={toggle}
  aria-expanded={open}
  aria-controls={panelId}
  className="..."
>
  ...
</button>
<div
  id={panelId}
  role="region"
  aria-labelledby={...} // or use the button id
  className={`overflow-hidden transition-all ... ${open ? 'max-h-[1000px]' : 'max-h-0 opacity-0'}`}
>
```

---

### F-04 — Mobile menu trigger button missing `aria-expanded`
**WCAG:** 4.1.2 Name, Role, Value
**Severity:** Major
**Source:** Code + Live
**File:** `src/app/components/Header.tsx` lines 149–155
**Location:** All pages

The hamburger button (`aria-label="Open menu"`) has no `aria-expanded` attribute. The Sheet (Radix Dialog) provides proper `role="dialog"`, `aria-modal`, and focus management — but the trigger button's state change (open/closed) is not communicated:

```tsx
// Current — no aria-expanded
<button onClick={() => setMobileMenuOpen(true)} aria-label="Open menu">

// Fix
<button
  onClick={() => setMobileMenuOpen(true)}
  aria-expanded={mobileMenuOpen}
  aria-label={mobileMenuOpen ? 'Close menu' : 'Open menu'}
>
```

Additionally, a React warning is generated that the dialog is missing `aria-describedby`. While not strictly required by WCAG, it is best practice for dialogs without body text.

---

### F-05 — Image carousel lightbox modal has no role, focus trap, or Escape handler
**WCAG:** 4.1.2 Name, Role, Value
**Severity:** Major
**Source:** Code
**File:** `src/app/components/ImageCarousel.tsx` lines 151–178
**Location:** Homepage (What We're Building section)

When a user clicks a carousel image to open the lightbox, the modal div renders with no accessibility semantics:
- No `role="dialog"` or `aria-modal="true"`
- No `aria-label` or `aria-labelledby`
- No focus trap — Tab exits the modal freely
- No Escape key handler — keyboard users cannot close the modal without clicking
- Focus is not moved to the modal on open, nor returned to the trigger on close

The donate modal in `DonateSection.tsx` correctly implements `role="dialog"` and `aria-modal` and `aria-label` — use that as the pattern.

**Recommended fix:**
```tsx
// ImageCarousel.tsx modal div — add:
role="dialog"
aria-modal="true"
aria-label={`Image ${currentIndex + 1} of ${images.length}: ${images[currentIndex].alt}`}

// Add useEffect to manage focus and Escape key:
useEffect(() => {
  if (!isModalOpen) return;
  const onKeyDown = (e: KeyboardEvent) => {
    if (e.key === 'Escape') closeModal();
  };
  document.addEventListener('keydown', onKeyDown);
  return () => document.removeEventListener('keydown', onKeyDown);
}, [isModalOpen]);
```
Also implement a focus trap or move focus to the close button on open.

---

### F-06 — Form error messages have no `role="alert"` — not announced to screen readers
**WCAG:** 4.1.3 Status Messages
**Severity:** Major
**Source:** Code
**Files:** `src/app/components/ContactForm.tsx` line 247, `src/app/components/sections/DonateSection.tsx` line 216
**Location:** Contact form (homepage, /our-team), Founding member signup (homepage)

Form submission errors render in a styled `<div>` with no ARIA live region. Screen readers will not announce the error unless the user navigates to it manually:

```tsx
// ContactForm.tsx line 247 — current
{error && (
  <div className="mb-4 p-3 bg-red-50 border border-red-200 rounded-md text-red-700 text-sm">
    {error}
  </div>
)}

// Fix
{error && (
  <div role="alert" aria-live="assertive" className="...">
    {error}
  </div>
)}
```

Apply the same fix to `DonateSection.tsx` line 216.

---

### F-07 — Consent banner not announced to screen readers
**WCAG:** 4.1.3 Status Messages
**Severity:** Major
**Source:** Code + Live
**File:** `src/app/components/ConsentBanner.tsx`
**Location:** All pages (first visit)

The consent banner is a fixed `<div>` at the bottom of the screen. It appears dynamically after hydration, but there is no `role`, `aria-live`, or `aria-label` — screen reader users are not notified of its appearance. The buttons inside are keyboard-reachable once a user tabs to them, but the banner's existence is not announced.

**Recommended fix:**
```tsx
<div
  role="dialog"
  aria-label="Cookie consent"
  aria-modal="false"
  aria-live="polite"
  style={{ backgroundColor: '#e2b624' }}
  className="fixed bottom-0 left-0 right-0 z-50 shadow-lg"
>
```

---

### F-10 — Carousel has no `aria-live` announcement for image changes
**WCAG:** 4.1.3 Status Messages (advisory), 1.3.6 Identify Purpose
**Severity:** Minor
**Source:** Code + Live
**File:** `src/app/components/ImageCarousel.tsx` lines 84–116
**Location:** Homepage (What We're Building section)

When the carousel advances, the current image `alt` text is not announced. The Previous/Next buttons are keyboard-operable with visible focus rings, but blind users have no way of knowing the carousel has advanced or what the new image shows.

**Recommended fix:** Add an `aria-live="polite"` region that announces the current image:
```tsx
<div aria-live="polite" aria-atomic="true" className="sr-only">
  Image {currentIndex + 1} of {images.length}: {images[currentIndex].alt}
</div>
```

---

### F-11 — Playbook PDF links have no file type or new-tab warning
**WCAG:** 2.4.4 Link Purpose (In Context)
**Severity:** Minor
**Source:** Code + Live
**File:** `src/app/components/sections/PlaybookSection.tsx` lines 63–79
**Location:** Homepage (Action Playbook section)

Eight playbook card links open PDFs in a new tab (`target="_blank"`) with no `type="application/pdf"` attribute and no visual or screen-reader notification that a PDF or new tab will open. Sighted users who hover can see the URL contains `.pdf`, but keyboard and screen reader users receive no warning.

**Recommended fix:** Add `aria-label` to each link incorporating the file type and new-tab behavior:
```tsx
<a
  href={pdfHref}
  target="_blank"
  rel="noopener noreferrer"
  aria-label={`${item.title} — download PDF, opens in new tab`}
>
```
Or add a visually hidden `<span className="sr-only"> (PDF, opens in new tab)</span>` inside each link.
