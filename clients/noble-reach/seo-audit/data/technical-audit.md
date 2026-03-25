# NobleReach Technical Audit — 2026-03-19

## On-Page Audit Results

| Page | Title | Title Length | Meta Desc | H1 | Canonical | On-Page Score |
|---|---|---|---|---|---|---|
| `/` | NobleReach Foundation | 21 (short) | ✓ 140 chars | ✓ | ✓ | 98.17 |
| `/person/kevin-stitt/` | Kevin Stitt - NobleReach Foundation | 35 | ✗ missing | ✗ missing | ✓ | 96.34 |
| `/person/dr-robert-m-gates/` | Dr. Robert M. Gates - NobleReach Foundation | 43 | ✗ missing | ✗ missing | ✓ | 96.34 |
| `/person/general-paul-nakasone-ret/` | General Paul Nakasone (ret.) - NobleReach Foundation | 52 | ✗ missing | ✗ missing | ✓ | 96.34 |
| `/person/anne-neuberger/` | Anne Neuberger - NobleReach Foundation | 38 | ✗ missing | ✗ missing | ✓ | 96.34 |
| `/stories/noblereach-emerge-lightdeck/` | NobleReach Emerge & LightDeck - NobleReach Foundation | 53 | ✗ missing | ✗ missing | ✓ | 96.34 |
| `/stories/founders-fund/` | Founders Fund: Trae Stephens - NobleReach Foundation | 52 | ✗ missing | ✗ missing | ✓ | 96.34 |
| `/us-tech-force/` → (redirects to `/news/noblereach-foundation-tech-force/`) | NobleReach to provide top early-career tech talent as founding partner to United States Tech Force - NobleReach Foundation | 122 (too long) | ✗ missing | ✓ | ✓ (news URL) | 96.34 |
| `/news/16-innovations-fueled-by-the-federal-government/` | 16 Innovations Fueled by the Federal Government - NobleReach Foundation | 71 (too long) | ✗ missing | ✓ | ✓ | 93.41 |

### Notes on Heading Structure

- All person pages use **H5** for the person's name — no H1 present on any person page
- Story pages (`/stories/*`) also lack H1 tags
- News/article pages (`/news/*`) have proper H1 tags
- Homepage H1: "NobleReach is a civic leadership platform committed to rekindling a spirit of national service across all career stages."

### US Tech Force Redirect

- `/us-tech-force/` redirects to `/news/noblereach-foundation-tech-force/`
- The keyword "tech force" (1,900 search vol, rank 20) likely resolves via this redirect chain
- The news article title is 122 chars — significantly over the ~60 char recommended limit

### Structured Data / Schema

No structured data detected on any of the 9 audited pages. No Person schema, Article schema, Organization schema, or BreadcrumbList detected.

### Common Issues Across All Pages

- **Render-blocking resources**: 2 scripts + 2 stylesheets on every page
- **Low content rate** (text-to-HTML ratio): flagged on most pages — especially person pages (~4-6% text rate vs. recommended ~10%+)
- **Large DOM node count**: every page has a node with >60 children (warning)

### Page-Specific Issues

| Page | Issues |
|---|---|
| `/` | Title too short (21 chars); 3 HTML parse errors; render-blocking resources |
| `/person/kevin-stitt/` | No H1; no meta description; low content rate |
| `/person/dr-robert-m-gates/` | No H1; no meta description; low content rate |
| `/person/general-paul-nakasone-ret/` | No H1; no meta description; low content rate |
| `/person/anne-neuberger/` | No H1; no meta description; low content rate |
| `/stories/noblereach-emerge-lightdeck/` | No H1; no meta description; low content rate |
| `/stories/founders-fund/` | No H1; no meta description; low content rate |
| `/us-tech-force/` (redirects) | Title too long (122 chars); no meta description |
| `/news/16-innovations-fueled-by-the-federal-government/` | Title too long (71 chars); no meta description; image missing alt + title attributes |

---

## Lighthouse Audit Results

### Homepage (`/`)

| Metric | Score / Value |
|---|---|
| Performance | 93/100 |
| Accessibility | 85/100 |
| Best Practices | 56/100 |
| SEO | 92/100 |
| LCP | 1,339ms ✓ (good) |
| FCP | 584ms |
| TTI | 1,339ms |
| Speed Index | 1,831ms |
| Total Page Weight | 5.5MB ⚠️ |
| Render-blocking delay | 128ms |
| Unused CSS savings | 60ms |
| Unused JS savings | 150ms |

### Person Page — Kevin Stitt (`/person/kevin-stitt/`)

| Metric | Score / Value |
|---|---|
| Performance | 84/100 |
| Accessibility | 100/100 |
| Best Practices | 56/100 |
| SEO | 92/100 |
| LCP | 2,770ms ⚠️ (borderline — near 2.5s threshold) |
| FCP | 532ms |
| TTI | 2,774ms |
| Speed Index | 1,014ms |
| Total Page Weight | 648KB |
| Render-blocking delay | 143ms |
| Unused CSS savings | 100ms |
| Unused JS savings | 100ms |

### Third-Party Scripts (detected on both pages)

| Script | Category | Notes |
|---|---|---|
| Google Tag Manager | Tag Manager | Expected |
| Google Analytics | Analytics | Expected |
| HubSpot | Marketing | UTM parameter source |
| Google Fonts | CDN | Render-blocking |
| LinkedIn Ads | Ad | Unusual for nonprofit |
| AppNexus | Ad | Unusual for nonprofit — ad exchange |
| Macropod BugHerd | Utility | Dev/QA feedback tool — likely should NOT be on production |

### Best Practices Score: 56/100 (both pages)

The low Best Practices score is almost certainly driven by third-party scripts — specifically AppNexus (an ad exchange) and potentially BugHerd (a dev tool loaded on production). This warrants investigation.

---

## Summary of Key Technical Issues

1. **No meta descriptions** on 8 of 9 audited pages (all except homepage)
2. **No H1 tags** on all person pages and story pages — headings start at H5 for person name
3. **No structured data** anywhere — no Person, Article, Organization, or BreadcrumbList schema
4. **Homepage title too short** (21 chars: "NobleReach Foundation")
5. **US Tech Force page** (`/us-tech-force/`) redirects to a news article — the ranking URL is the redirect destination, not the intended landing page
6. **Render-blocking resources** on every page (2 scripts + 2 stylesheets)
7. **Homepage page weight: 5.5MB** — significantly heavy
8. **Person page LCP: 2,770ms** — borderline; could fail CWV threshold under real-world conditions
9. **Best Practices: 56/100** — likely caused by AppNexus ad scripts and BugHerd dev tool on production
10. **Image missing alt text** on `/news/16-innovations-fueled-by-the-federal-government/`
11. **Low content rate** sitewide — thin text relative to HTML, especially on person pages
