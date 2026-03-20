# Accessibility Audit — noblereach.org

**Status:** Planned

---

## What This Audit Will Cover

An audit of the site's accessibility against WCAG 2.1 AA standards. The goal is to document current issues so the rebuild can address them, and to establish a baseline for comparison post-launch. Likely scope:

- **Automated scan** — axe, Lighthouse accessibility, or WAVE for sitewide issue detection
- **Keyboard navigation** — tab order, focus indicators, skip links
- **Screen reader compatibility** — ARIA labels, landmark regions, heading hierarchy
- **Color contrast** — text/background ratios against WCAG AA thresholds
- **Images** — alt text coverage (SEO audit found at least one image missing alt text)
- **Forms** — label associations, error messaging
- **Motion and media** — reduced motion support, captions on any video content
- **PDF and document accessibility** — if any downloadable documents are linked

## Methodology

TBD — likely a combination of:
- Automated: Lighthouse accessibility scores (SEO audit found 85/100 on homepage, 100/100 on person page — automated only)
- Automated: axe DevTools or WAVE full-site scan
- Manual: keyboard navigation walkthrough on key page types
- Manual: screen reader spot-check (VoiceOver or NVDA) on high-traffic pages

## Contents

```
accessibility-audit/
├── data/        Raw scan results and issue logs
└── reports/     Final report(s) for the dev team
```
