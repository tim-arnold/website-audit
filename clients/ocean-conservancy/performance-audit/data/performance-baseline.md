# Performance Baseline — Ocean Conservancy

**Collected:** 2026-02-20 (top 20 pages); 2026-02-13 (homepage initial)
**URL:** https://oceanconservancy.org
**Lighthouse version:** 13.0.1
**GA4 window:** November 2025 – February 2026 (90 days)
**Mobile emulation:** Moto G Power, Slow 4G

---

## PageSpeed Insights — Mobile

| Category | Score | Rating |
|---|---|---|
| Performance | 32 | Poor |
| Accessibility | 88 | Good |
| Best Practices | 54 | Needs Work |
| SEO | 85 | Good |

---

## Core Web Vitals — Field Data (28-day, Mobile, Chrome UX Report)

| Metric | Value | Rating | Threshold |
|---|---|---|---|
| Largest Contentful Paint (LCP) | 1.8s | Good | < 2.5s |
| Interaction to Next Paint (INP) | 419ms | Needs Improvement | < 200ms |
| Cumulative Layout Shift (CLS) | 0 | Good | < 0.1 |
| First Contentful Paint (FCP) | 1.5s | Good | < 1.8s |
| Time to First Byte (TTFB) | 0.5s | Good | < 0.8s |

**CWV overall:** Fails (INP fails)

---

## Lab Metrics — Lighthouse (Emulated Mobile)

| Metric | Value | Rating | Threshold |
|---|---|---|---|
| First Contentful Paint (FCP) | 15.5s | Poor | < 1.8s |
| Largest Contentful Paint (LCP) | 26.7s | Poor | < 2.5s |
| Total Blocking Time (TBT) | 1,130ms | Poor | < 200ms |
| Speed Index | 15.8s | Poor | < 3.4s |
| Cumulative Layout Shift (CLS) | 0 | Good | < 0.1 |

---

## Scripts Loaded on Every Page

| Script | Purpose | Load Behavior |
|---|---|---|
| UIkit JS v3.21.11 | UI framework | Sync |
| Swiper bundle | Carousels (8+ slider instances registered) | Sync |
| GSAP core + ScrollTrigger + CustomEase + SplitText | Animations | CDN, sync |
| Custom app.js | Theme JS | Sync |
| Google reCAPTCHA Enterprise | Bot protection | Sync, every page |
| OptinMonster | Popups | Async, footer |
| New Relic RUM | Real-user monitoring | Sync |
| Google Tag Manager | Analytics/tag management | Async |
| jQuery + jQuery Migrate | WordPress defaults | Sync |

---

## CSS Loaded on Every Page

| Stylesheet | Notes |
|---|---|
| UIkit CSS (full framework) | Render-blocking |
| Swiper CSS | Render-blocking |
| Theme custom styles | Render-blocking |
| Block-specific stylesheets (hero, statistic, spotlight, our-work, donate, partners) | Render-blocking; loaded globally regardless of blocks present |

---

## Fonts

| Detail | Value |
|---|---|
| Typefaces | Geologica (6 weights), Inter (2 weights) |
| Total font files | 8 |
| Format | WOFF2 |
| font-display | `fallback` (3-second block period before fallback text) |
| Preloaded | No |

---

## Infrastructure & Caching

| Layer | Technology | Status |
|---|---|---|
| Hosting | Pantheon (Nginx/Varnish) | Active |
| CDN | Pantheon Global CDN + Cloudflare | Active |
| Object cache | Object Cache Pro (Redis, zstd, igbinary) | Active |
| Cache purging | Pantheon Advanced Page Cache (surrogate keys) | Active |
| Frontend optimization | LiteSpeed Cache v7.7 | Installed but **inactive**; incompatible with Pantheon Nginx |

---

## Key Observations

- **TTFB is excellent (0.5s)** — server-side infrastructure (CDN + Redis) is working well
- **Field LCP (1.8s) vs lab LCP (26.7s)** — dramatic gap explained by CDN cache and fast repeat-visitor connections; lab simulates worst-case first-time mobile visitor
- **No frontend optimization layer** — LiteSpeed Cache inactive and incompatible; no minification, deferral, lazy loading, critical CSS, or image conversion of any kind
- **INP at 419ms fails CWV** — driven by main-thread JavaScript (UIkit, Swiper, GSAP, reCAPTCHA)
- **Best Practices score of 54** — likely browser console errors, missing security headers, deprecated APIs from plugins
