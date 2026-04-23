# Accessibility Audit Handoff — NobleReach

## Context

You are conducting an accessibility audit of **noblereach.org** as part of a pre-redesign evaluation. The SEO audit and WordPress audit are already complete (see `seo-audit/reports/` and `wordpress-audit/`). This audit documents accessibility issues the dev team must fix in the rebuild.

**Local site theme path:** `/Users/timarnold/Local Sites/noble-reach-foundation/app/public/wp-content/themes/noblereach-2024`

The active theme is `noblereach-2024`, built by Teal Media using **Timber/Twig** templating. Twig templates live in `_html/`. PHP template files and custom functions are in the theme root and `inc/`.

## What You Already Know

From prior audits:

- **Lighthouse accessibility scores:** Homepage 85/100, person page 100/100 (desktop, simulated throttling)
- **Missing H1 tags** on all person pages and story pages — person names use H5 instead
- **8 of 9 audited pages have no meta description** (SEO issue but also affects screen reader page summaries)
- **BugHerd and AppNexus scripts** are loading on production — may inject inaccessible overlays
- The site uses **Gravity Forms** for forms and **MapSVG** for interactive maps — both need accessibility review
- **editoria11y-accessibility-checker** plugin is installed, suggesting some a11y awareness already exists
- The 2024 theme has 21 page templates, 7 CPTs, and 46 ACF field groups — lots of surface area

## Your Task

Two passes: a **code-level audit** (filesystem) and a **live audit** (Playwright). Produce two deliverables.

### Pass 1: Code-Level Audit (Filesystem)

Read the Twig templates in `_html/` and the PHP template files. Check for:

1. **Semantic HTML structure**
   - Heading hierarchy (h1 → h2 → h3, no skips). The SEO audit already found person pages use H5 for names — catalog all heading misuse.
   - Landmark elements (`<nav>`, `<main>`, `<header>`, `<footer>`, `<aside>`, `<section>`, `<article>`)
   - List markup for navigation and repeated items

2. **Images and media**
   - `alt` attributes on all `<img>` tags — check both hardcoded and dynamic (ACF image fields rendered in Twig)
   - Decorative images should have `alt=""`
   - Any `<video>` or `<iframe>` embeds — check for captions/transcripts or accessible fallbacks
   - SVG accessibility (the site uses `safe-svg` plugin for uploads)

3. **Forms**
   - Gravity Forms rendering is mostly plugin-controlled, but check for any custom form markup in templates
   - Label/input associations (`for`/`id` pairing)
   - Error message handling
   - Required field indicators

4. **Interactive elements**
   - Navigation menus — keyboard accessibility, ARIA attributes, mobile menu toggle
   - Any JavaScript-driven interactions (accordions, tabs, modals, dropdowns) — check for ARIA roles, keyboard handlers, focus management
   - MapSVG interactive maps — these are almost certainly not accessible; flag prominently
   - Links vs buttons — check for `<a>` tags used as buttons without `role="button"` or `<div>`/`<span>` elements used as clickable elements

5. **Color and contrast**
   - Check CSS/SCSS files for color values. Flag any text/background combinations that look potentially low-contrast (you can't compute ratios from code alone, but flag suspicious combos for the live audit)
   - Check for color-only state indicators (hover states, active states, error states)

6. **Focus management**
   - Check CSS for `outline: none` or `outline: 0` without replacement focus styles
   - `:focus` and `:focus-visible` styles
   - Tab order issues (any `tabindex` > 0)

7. **ARIA usage**
   - Audit all `aria-*` attributes and `role` attributes in templates
   - Flag misuse (e.g., `aria-hidden="true"` on focusable elements, redundant roles)

8. **Skip links and page structure**
   - Skip-to-content link present?
   - `<html lang>` attribute set?
   - Viewport meta tag (`user-scalable=no` or `maximum-scale=1` are violations)

### Pass 2: Live Audit (Playwright)

Use the Playwright MCP to test the live site at **https://noblereach.org**. Test these representative pages:

| Page | Why |
|---|---|
| `https://noblereach.org/` | Homepage — navigation, hero, overall structure |
| `https://noblereach.org/person/kevin-stitt/` | Person page — highest-traffic template |
| `https://noblereach.org/stories/noblereach-emerge-lightdeck/` | Story page — content-heavy template |
| `https://noblereach.org/news/16-innovations-fueled-by-the-federal-government/` | News page — article template |
| `https://noblereach.org/noblereach-emerge/` | Program page (if it exists) — likely uses a custom template |

For each page:

1. **Take a snapshot** (`browser_snapshot`) to get the accessibility tree
2. **Check keyboard navigation** — tab through the page, verify focus is visible and logical
3. **Check heading structure** — extract all headings and verify hierarchy
4. **Check landmark regions** — verify `main`, `nav`, `header`, `footer` are present
5. **Check images** — verify alt text presence and quality
6. **Check interactive elements** — expand any accordions/dropdowns, verify they're keyboard-accessible
7. **Check color contrast** — use the accessibility tree to identify any flagged contrast issues

If any page is inaccessible or errors out, note it and move on.

## Deliverables

Save to `/Users/timarnold/Documents/Outright/NobleReach/Eval/accessibility-audit/`:

### Data File: `data/accessibility-findings.md`

Structured findings from both passes. Organize by WCAG 2.2 principle:

**1. Perceivable** (text alternatives, captions, contrast, text resize)
**2. Operable** (keyboard, timing, seizures, navigation)
**3. Understandable** (readable, predictable, input assistance)
**4. Robust** (parsing, name/role/value)

For each finding:
- WCAG criterion (e.g., "1.1.1 Non-text Content")
- Severity: Critical / Major / Minor
- Location (file path and/or URL + element)
- Description of the issue
- Remediation recommendation

### Report: `reports/accessibility-audit-report.md`

A concise report for the dev team. Structure:

**Executive Summary** (5-7 bullets — overall accessibility posture, biggest issues, quick wins)

**1. WCAG Compliance Summary**
- Table: each WCAG 2.2 Level AA criterion, pass/fail/partial/not-tested
- Overall estimated conformance level

**2. Critical Issues** (must fix in rebuild)
- Issues that block users from accessing content
- Missing heading structure, keyboard traps, missing alt text, inaccessible interactive components

**3. Major Issues** (should fix in rebuild)
- Poor but not blocking — low contrast, missing landmarks, inconsistent focus styles

**4. Minor Issues** (nice to fix)
- Best practice violations that don't block access

**5. Component-Specific Findings**
- Navigation/header
- Person page template
- Story page template
- News page template
- Forms (Gravity Forms)
- Maps (MapSVG)
- Footer

**6. Rebuild Recommendations**
- Specific a11y requirements for the new build
- Recommended testing tools and process
- ARIA patterns to adopt for interactive components
- Heading structure plan that works for both SEO and a11y (cross-reference SEO audit's heading findings)

## Formatting

- Use markdown tables for structured data
- Include WCAG criterion numbers — the dev team will use these for acceptance criteria
- Be specific: file paths, line numbers, CSS selectors, URLs
- Severity ratings should be consistent and defensible
- Cross-reference SEO audit findings where they overlap (heading structure, structured data, page titles)

## Important Notes

- The code audit (Pass 1) and the live audit (Pass 2) can run in parallel since they use different tools.
- For the live audit, use the Playwright MCP (`browser_navigate`, `browser_snapshot`, `browser_press_key` for tab testing, `browser_click` for interactive elements).
- Do NOT use the Sanity MCP or DataForSEO MCP — this is a pure accessibility audit.
- Do NOT modify any files in the WordPress installation or on the live site. Read and observe only.
- If Playwright can't reach the live site or specific pages, fall back to code-only analysis and note what couldn't be tested.
