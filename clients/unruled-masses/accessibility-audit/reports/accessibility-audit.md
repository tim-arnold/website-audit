# Accessibility Audit: Browser Testing — Unruled Masses

**Site:** https://unruledmasses.org
**Date:** 2026-03-22
**Method:** Live browser testing via Playwright — accessibility snapshots, keyboard navigation, tab-order tracing, DOM inspection
**Pages Tested:**
- https://unruledmasses.org/ (Homepage)
- https://unruledmasses.org/our-team
- https://unruledmasses.org/news
- https://unruledmasses.org/news/um-launches-civic-intelligence-system

---

## Summary

The site has a solid structural foundation: skip link, landmark regions, and `<label>` elements on forms are all present. The most significant issues are missing `aria-expanded` on all accordion and disclosure buttons, a broken skip link target, missing focus indicators on two high-priority buttons, and an unannotated consent banner. Several of these are straightforward one-line fixes.

---

## Findings by Category

### 1. Skip Link

**Status: Partially working — target lacks `tabindex="-1"`**

- The "Skip to main content" link is present on all four pages and appears visually styled on first Tab press (dark red pill, clearly visible). Screenshot: `homepage-tab-01-skip-link.png`.
- Activating the link changes the URL to `/#main-content` and the `<main id="main-content">` element exists, but the `<main>` element has no `tabindex="-1"` attribute. As a result, focus returns to `<body>` rather than moving into the main content area — the skip behavior does not work for keyboard users.
- After pressing Enter on the skip link, the next Tab press jumped to the "Get Involved" button in the hero section (below the nav), suggesting the page may be rendering in a mobile-nav-hidden state where the nav links are not in the tab order, and the skip actually behaves correctly in this layout. However, this is implementation-dependent and unreliable — the target still needs `tabindex="-1"` to guarantee correct focus placement.

**Fix:** Add `tabindex="-1"` to `<main id="main-content">`.

---

### 2. Focus Indicators

**Status: Inconsistent — two key interactive elements have no visible focus ring**

Tab-order testing (10 stops from page top, with screenshots at each stop):

| Tab Stop | Element | Focus Indicator Visible? |
|---|---|---|
| 1 | Skip link | Yes — styled red pill |
| 2 | "Get Involved" button (hero) | No — no visible ring |
| 3 | "Play video demonstration" button | No — no visible ring |
| 4 | Carousel "Previous image" button | Yes — outline box |
| 5 | Carousel "Next image" button | Yes — outline box |
| 6 | "Donate Now" button | Yes — outline box |
| 7 | First Name input (signup form) | Yes — yellow outline on input |
| 8+ | Remaining form inputs | Yes |

The "Get Involved" CTA button (hero section) and the video play button both have no visible focus indicator when tabbed to. These are among the most prominent interactive elements on the page.

Screenshots: `homepage-tab-02-get-involved.png`, `homepage-tab-03-play-video.png`.

**Fix:** Add a `:focus-visible` CSS rule for all `button` elements. The existing focus style used on the carousel and form buttons should be extended globally.

---

### 3. Accordion / Disclosure Buttons — Missing `aria-expanded`

**Status: Fails — no ARIA state communicated**

The site has two sets of accordion-style disclosure sections:

1. **"How It All Works" accordion** (homepage) — 7 items: Abuse & Corruption Library, Corruption Intelligence System, Nonviolent Action Playbook, Alerts & Mobilization, Partner Program, Civic Materials Exchange, Community Building
2. **"The stewards of this work" accordion** (homepage, Our Team page) — 4 items: Our Team, Unruled Masses Advisory Council, How we work and organize, How we think and operate

All accordion trigger buttons have `null` for both `aria-expanded` and `aria-controls`. Tested via DOM inspection on all 11 buttons.

- Keyboard activation works: pressing Enter on a focused accordion button opens/closes the panel.
- However, no expanded/collapsed state is communicated to assistive technology. A screen reader user has no way to know whether a panel is open or closed.
- The "Expand All" button also has no `aria-expanded`.

Screenshot of open accordion: `homepage-accordion-abuse-library-clicked.png`, `homepage-accordion-keyboard-enter.png`.

**Fix:** Add `aria-expanded="false"` to all closed accordion buttons and toggle it to `"true"` when open. Add `aria-controls="[panel-id]"` pointing to each panel's `id`. The panel content `div` should get the corresponding `id` and `role="region"` with `aria-labelledby` pointing back to the button.

---

### 4. Mobile Menu / "Open Menu" Button — Missing `aria-expanded`

**Status: Fails — button has no expanded state**

The hamburger button has `aria-label="Open menu"` but no `aria-expanded` attribute. When the menu dialog opens, a screen reader user is not told that the button's state changed.

The menu itself opens correctly as a proper `dialog` element with:
- `role="dialog"` (implicit from `<dialog>`)
- `aria-label="Menu"` (H2 heading "Menu" visible)
- `navigation` landmark labelled "Mobile navigation"
- A "Close" button
- Focus appears to move into the dialog

However, a React console warning was observed: `Warning: Missing 'Description' or 'aria-describedby'` — the dialog lacks an `aria-describedby` pointing to a description element. The heading alone may not suffice.

Also: when the menu closes via Escape key, there is no confirmation that focus returned to the trigger button (this should be verified manually).

Screenshot: `homepage-mobile-menu-open.png`.

**Fix:** Add `aria-expanded="false"` to the "Open menu" button and toggle it when the dialog opens. Add `aria-describedby` to the dialog pointing to a brief description element, or suppress the warning if intentional. Ensure focus returns to the trigger button on dialog close.

---

### 5. Consent Banner — No ARIA Role or Region

**Status: Fails — plain `div`, no ARIA landmark or live region**

The Google Analytics consent banner (yellow bar, bottom of viewport) is rendered as a plain `div` with no role, no `aria-label`, no `aria-live`, and no `aria-modal`. Screen reader users may not be notified of its presence.

The banner does contain keyboard-accessible buttons ("Accept" and "Decline") and a "Privacy Policy" link, all reachable by Tab. The consent banner's buttons appear in the tab order and are functional.

**Fix:** Wrap the banner in `role="dialog"` with `aria-label="Cookie consent"` and `aria-modal="false"`, or use `role="alert"` / `aria-live="polite"` to announce it. The current `alert` element in the page snapshot appears elsewhere and is empty — it may be intended for form feedback.

---

### 6. Heading Structure

**Status: Homepage has heading-level issues; other pages are clean**

#### Homepage (`/`)

```
H1 — Democracy is Non-Negotiable
H2 — Systems meant to protect people are failing.
H2 — What We're Building
  H3 — A system that turns awareness into peaceful power.
    H4 — Intelligence
    H4 — Materials
    H4 — Communications
  H3 — What We're Building        ← duplicate heading title at same level
H2 — Help Us Build
  H3 — Corruption Intelligence Platform
  H3 — Abuse Library & Action Playbook
  H3 — Partnerships & Multi-Channel Outreach
  H3 — Media Programming & Community Hope
H2 — Support the Mission
H2 — Help us build this movement. ← second H2 inside "Support the Mission" section
  H3 — Why Donate?
  H3 — Member Benefits
H2 — How It All Works
H2 — Action Playbook
H2 — Action Playbook Samples      ← second H2 immediately after "Action Playbook"
H2 — The stewards of this work
  H3 — Contact Inquiry
```

Issues:
- "What We're Building" appears as both an H2 and an H3 — the H3 instance is a redundant sub-label within the same visual section.
- "Support the Mission" (H2) immediately followed by "Help us build this movement." (H2) — these are visually the section title and subsection title but both are H2.
- "Action Playbook" (H2) immediately followed by "Action Playbook Samples" (H2) — same issue.
- "Contact Inquiry" (H3) appears without an H2 parent on the homepage contact section (the form has no visible H2 heading above it in the heading tree).

#### Our Team (`/our-team`)

```
H1 — Leadership Team
H2 — Nick Van Zandt
H2 — Deanna Wilken
H2 — Jennifer Kirby-McLemore
H2 — Tim Arnold
H2 — "Architect"
H2 — Matt Farleo
H2 — Ashley Finden
H2 — The stewards of this work
H2 — Contact Us
  H3 — Contact Inquiry
```

Clean structure. One observation: "The stewards of this work" sits at H2 alongside person names — it could be argued it should be an H2 section heading with persons at H3, but this is a design/content decision rather than a strict error.

#### News (`/news`)

```
H1 — News
H2 — Unruled Masses Launches Public Civic Intelligence System...
```

Clean. Only one article currently.

#### News Article (`/news/um-launches-civic-intelligence-system`)

```
H1 — Unruled Masses Launches Public Civic Intelligence System...
H2 — About Unruled Masses
H2 — Media Contact
```

Clean. Good use of `<article>` wrapping the content.

---

### 7. Landmark Regions

**Status: Good — all key landmarks present**

| Landmark | Element | Present? |
|---|---|---|
| `banner` | `<header>` | Yes — all pages |
| `main` | `<main id="main-content">` | Yes — all pages |
| `contentinfo` | `<footer>` | Yes — all pages |
| `navigation` (mobile) | `<nav aria-label="Mobile navigation">` | Yes — inside dialog |
| `navigation` (back link) | `<nav aria-label="Back to news">` | Yes — article page only |
| `form` (contact) | `<form aria-label="Contact inquiry form">` | Yes |
| `form` (signup) | `<form aria-label="Founding member signup">` | Yes |

Missing: The primary desktop/top navigation has no `<nav>` landmark — it is inside a `banner` `<header>` but the link and button group is not wrapped in `<nav aria-label="Primary navigation">`.

The footer navigation lists (Navigate, Legal, Connect) are wrapped in generic `<div>` elements. The group labels "Navigate", "Legal", "Connect" are rendered as `<p>` elements, not as headings or `aria-label` attributes. This means footer nav sections have no accessible group label beyond visual styling.

**Fix:** Wrap the header link group in `<nav aria-label="Primary navigation">`. Wrap each footer navigation group in `<nav aria-label="Navigate">`, `<nav aria-label="Legal">`, `<nav aria-label="Connect">` (or use `<h>` elements to label the groups).

---

### 8. Form Labels

**Status: Good — all user-facing inputs have proper `<label>` elements**

Both the "Founding member signup" form and the "Contact inquiry form" use explicit `<label for="...">` associations on all visible inputs:

Contact form fields: First Name *, Last Name *, Job Title, Organization, Email *, Phone, Message — all have associated labels.

Signup form fields: First Name, Last Name, Email — all have associated labels with the email labeled "Email for founding membership" (descriptive).

The checkbox "Sign me up for your e-newsletter" is associated with its label text.

Note: Both forms contain a hidden Cloudflare Turnstile input (`cf-chl-widget-*_response`) with no label — this is a hidden input injected by Cloudflare's CAPTCHA widget and is not user-facing; no fix needed.

---

### 9. Image Alt Text

**Status: Good overall — decorative images correctly use empty alt**

- All person photos on the Our Team page have descriptive alt text matching the person's name.
- Action Playbook card images have descriptive alt text.
- Carousel images have descriptive alt text ("Abuse Library Home", "Abuse Library - Smart Search", "Action Playbook - Posters").
- The video button image has `alt="Unruled Masses platform demonstration"` — appropriate.
- Decorative images (arrows, quote marks, checkmarks, accordion chevrons) all use `alt=""` — correct.
- Images inside headings (H1, H2) have alt text that duplicates the heading text — not harmful, but slightly redundant for screen readers who will read both the text node and the image alt. These images could be given `alt=""` since the heading text node already provides the name.

---

### 10. Carousel Keyboard Navigation

**Status: Works — buttons are keyboard operable, but no live region**

- "Previous image" and "Next image" buttons are both reachable by Tab and have clear `aria-label` values.
- Both buttons activate with Enter, advancing the carousel.
- Both buttons have a visible focus indicator (outline box).
- However, when the carousel advances, there is no `aria-live` region announcing the new image to screen reader users. The new image has an alt text but no announcement mechanism.

**Fix:** Add `aria-live="polite"` to a region wrapping the current image, or use `aria-atomic="true"` so screen readers announce the alt text of the newly displayed image.

---

### 11. Video Play Button

**Status: Good — accessible name present, keyboard operable**

- Button has `aria-label="Play video demonstration"`.
- Keyboard activation works (Enter key).
- The thumbnail image inside has `alt="Unruled Masses platform demonstration"`.
- Focus indicator is not visible on this button (same issue noted in section 2 above).

---

### 12. Action Playbook Card Links

**Status: Minor — link names include image alt text concatenated with card title**

Each playbook card link's accessible name is the image alt text plus the card title paragraph concatenated, e.g., "Publish the Contract Poster Campaign". This is because both elements are inside the `<a>` tag. Screen readers will read both, which is slightly verbose but not a failure — the links are distinct and descriptive.

All links open PDFs on Sanity CDN with no `type="application/pdf"` attribute and no warning text. Users are not warned that clicking will open a PDF.

**Fix (minor):** Add `aria-label` to each link with just the action title ("Poster Campaign"), or restructure the image alt so it uses `alt=""` and relies on the paragraph text only. Also add `(PDF)` suffix or `aria-label` to indicate the file type.

---

### 13. Console Errors

Errors observed on all pages originate from Cloudflare Turnstile/challenge scripts embedded in iframes — these are CSP-related errors from Cloudflare's own challenge infrastructure:

```
[ERROR] Failed to load resource: the server responded with 404
[ERROR] Note that 'script-src' was not explicitly set...
```

These are not application errors — they are Cloudflare's bot detection scripts and are not under the site's control. No application-level JavaScript errors were observed.

---

### 14. Contrast (Observed)

Full automated contrast analysis was not run (requires Axe or similar), but the following were observed visually:

- **Yellow text on blue background** ("Donate Now" button, "Sign Up" button): Yellow (#e2b624 approx) on dark blue — appears to pass based on visual assessment, but should be verified with a contrast checker. The ratio may be borderline for WCAG AA large text.
- **"EXPAND ALL" text**: Blue text on white background in the "How It All Works" section — appears to pass.
- **Small gray text** in the hero section (the 501(c)(3) disclosure text) and footer body text: Appears light on dark background — likely passes.
- **Placeholder text** on form inputs (the signup form shows placeholder text as the primary visual label) — placeholder text commonly fails contrast requirements. Verify against WCAG 1.4.3.

---

## Issues Summary Table

| # | Issue | WCAG Criterion | Severity | Pages Affected |
|---|---|---|---|---|
| 1 | Skip link target `<main>` lacks `tabindex="-1"` — focus not reliably placed | 2.4.1 | High | All pages |
| 2 | "Get Involved" button has no visible focus indicator | 2.4.7 | High | Homepage |
| 3 | "Play video demonstration" button has no visible focus indicator | 2.4.7 | High | Homepage |
| 4 | All accordion buttons missing `aria-expanded` and `aria-controls` | 4.1.2 | High | Homepage, Our Team |
| 5 | "Open menu" button missing `aria-expanded` | 4.1.2 | High | All pages |
| 6 | Consent banner has no ARIA role or live region | 4.1.3 | Medium | All pages |
| 7 | Mobile menu dialog missing `aria-describedby` (React warning) | 4.1.2 | Medium | All pages |
| 8 | Homepage heading hierarchy has duplicate/mis-leveled H2s | 1.3.1 | Medium | Homepage |
| 9 | Primary nav not wrapped in `<nav>` landmark | 1.3.1 | Medium | All pages |
| 10 | Footer nav groups labelled with `<p>` not semantic elements | 1.3.1 | Low | All pages |
| 11 | Carousel has no `aria-live` region for image change announcements | 4.1.3 | Medium | Homepage |
| 12 | "What We're Building" heading appears as both H2 and H3 | 1.3.1 | Low | Homepage |
| 13 | PDF links have no file-type warning | 2.4.4 | Low | Homepage |
| 14 | Heading images with alt text duplicate the heading's text node | 1.1.1 | Low | Homepage |

---

## Screenshots Index

| File | Description |
|---|---|
| `homepage.png` | Full-page screenshot of homepage |
| `homepage-tab-01-skip-link.png` | First Tab press — skip link visible |
| `homepage-tab-01-skip-link-activated.png` | After pressing Enter on skip link |
| `homepage-tab-02-get-involved.png` | Tab 2 — "Get Involved" button, no focus ring visible |
| `homepage-tab-03-play-video.png` | Tab 3 — video play button, no focus ring visible |
| `homepage-tab-04-carousel-prev.png` | Tab 4 — carousel "Previous image" with focus outline |
| `homepage-tab-05-carousel-next.png` | Tab 5 — carousel "Next image" with focus outline |
| `homepage-tab-06-donate-now.png` | Tab 6 — "Donate Now" with focus outline |
| `homepage-tab-07-form-firstname.png` | Tab 7 — First Name input with yellow focus ring |
| `homepage-accordion-abuse-library-clicked.png` | Accordion open via mouse click |
| `homepage-accordion-keyboard-enter.png` | Accordion opened via keyboard Enter |
| `homepage-mobile-menu-open.png` | Mobile menu dialog open |
| `our-team.png` | Full-page screenshot of Our Team |
| `news.png` | Full-page screenshot of News index |
| `news-article.png` | Full-page screenshot of news article |
| `news-article-tab-01-skip-link.png` | Skip link visible on news article page |
