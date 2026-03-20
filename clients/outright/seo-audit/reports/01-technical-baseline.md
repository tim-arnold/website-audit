# Technical SEO Baseline — Outright

**Site:** https://weareoutright.com
**Audit date:** 2026-03-20
**Stack:** Next.js / Cloudflare Pages

---

## Executive Summary

- Core Web Vitals pass on desktop, but the homepage weighs **15 MB** — a serious performance liability on mobile and slow connections
- **Best Practices Lighthouse score is 52/100** — the lowest category; likely caused by console errors, deprecated APIs, or cross-origin issues from third-party scripts
- **Multiple H1 tags on every page**: the homepage has 9 H1s; client brand names (Google/YouTube, Marriott, etc.) are incorrectly marked as H1 headings, confusing crawlers about page topic
- The homepage **has no meta description** and a 15-character title — both are critical on-page gaps
- **No structured data (schema markup)** found anywhere on the site
- **Images across audited pages are missing alt text**, affecting both accessibility and image search indexing

---

## 1. Core Web Vitals (Desktop)

Measured via Lighthouse 12.2 on the homepage. Desktop only — mobile performance was not captured in this pass and should be tested separately.

| Metric | Value | Threshold | Status |
|---|---|---|---|
| LCP (Largest Contentful Paint) | 2,048ms | <2,500ms | Pass |
| CLS (Cumulative Layout Shift) | 0 | <0.1 | Pass |
| FID / Max Potential FID | 18ms | <100ms | Pass |
| FCP (First Contentful Paint) | 1,535ms | — | — |
| TTI (Time to Interactive) | 2,051ms | — | — |
| Speed Index | 1,637ms | — | — |

All three Core Web Vitals pass on desktop. LCP at 2,048ms is close to the 2,500ms threshold — any added JS, larger hero images, or slower server response could push it into failing territory.

### Lighthouse Scores

| Category | Score | Status |
|---|---|---|
| Performance | 83/100 | Acceptable |
| Accessibility | 96/100 | Good |
| Best Practices | 52/100 | Poor — needs investigation |
| SEO | 92/100 | Good |

The **52/100 Best Practices** score is the most urgent finding. This typically signals console errors, deprecated JavaScript APIs, cross-origin issues, or insecure resource loading. The third-party scripts (Facebook pixel, Vimeo, GTM) are likely contributors.

### Performance Bottlenecks

| Issue | Impact |
|---|---|
| Total page weight | 15 MB — extremely heavy for a marketing homepage |
| Render-blocking resources | 3 stylesheets + 1 script (442ms delay) |
| Unused CSS | 540ms potential savings |
| Server latency | 359ms (Cloudflare edge) |
| Network RTT | 102ms |

15 MB is the most critical number. The average mobile page load budget is 1–3 MB. This likely means unoptimized images or video assets are being loaded on the homepage. Vimeo embeds or large background video/images are the likely culprits.

---

## 2. On-Page SEO

### Homepage

| Element | Current | Issue |
|---|---|---|
| Title tag | "Outright \| Home" | 15 characters — too short, no keyword |
| Meta description | None | Missing entirely |
| H1 count | 9 | Multiple H1s — major structural issue |
| H1 (primary) | "outright" | Lowercase brand name only; no keyword context |
| H1 (others) | "Google/YouTube", "Experience Fayetteville", "Marriott International", "Rails to Trails Conservancy", "World Resources Institute" | Client names marked as H1 — should be `<p>`, `<h3>`, or unlabeled headings |
| Canonical | https://weareoutright.com/ | Correct |
| Word count | 192 words | Very thin for homepage |
| Text-to-HTML ratio | 0.3% | Extremely low; page is mostly markup |
| Structured data | None | Missing |
| OG / Twitter tags | Present | OK |
| Image alt text | Missing | All images missing alt attributes |
| Robots | Follow | OK |

The title "Outright | Home" is not how a prospect would search for this agency. The absence of a meta description means Google auto-generates one from page copy, which for a JS-heavy page often results in poor snippets.

### Case Study — Washington Project for the Arts

| Element | Current | Issue |
|---|---|---|
| Title tag | "Art That Brings People Together \| Outright x Washington Project for the Arts" | 76 characters — over 70-char limit; likely truncated in SERPs |
| Meta description | "Art that brings people together. Building an experiential website for a DC-based arts organization." | OK (99 chars) |
| H1 count | 3 | Multiple H1s |
| H1 (first) | "outright" | Sitewide logo/nav element rendering as H1 |
| H1 (second) | "Supporting an experimental arts community with a more experiential online hub." | Correct page-level H1, but not the first |
| Canonical | Present and correct | OK |
| Image alt text | Missing | 9 images, none with alt text |
| Word count | 198 words | Thin |

The sitewide "outright" H1 appears to be the site logo or nav element — this is a template-level bug affecting every page on the site.

---

## 3. Structured Data

No structured data was detected on any audited page. For an agency site, the following schema types are relevant and missing:

| Schema Type | Page(s) | Value |
|---|---|---|
| `Organization` | Homepage | Name, description, logo, social profiles, contact |
| `WebSite` | Homepage | Enables sitelinks search box |
| `BreadcrumbList` | Case studies, all interior pages | Improves SERP breadcrumb display |
| `CreativeWork` / `Article` | Case studies | Eligible for rich results |
| `LocalBusiness` | Homepage | Reinforces DC location for local agency queries |

---

## 4. Internal Link Structure

Based on the on-page audits:

- **Homepage:** 10 internal links — sparse for a site of this scope
- **Case study (WPA):** 8 internal links
- No evidence of a blog, resource section, or any content hub that would distribute link equity to deeper pages
- Up Partnership lives on a subdomain (`up.weareoutright.com`) — its rankings and authority are siloed from the main domain

---

## 5. Broken Pages

The backlinks summary reports **2 broken pages** (pages with inbound links that return errors). Specific URLs were not identified in this audit pass. These should be identified via a full crawl and either repaired or redirected.

---

## 6. Mobile Readiness

Lighthouse was run in desktop mode only. Key mobile concerns based on available data:

- **15 MB page weight** is the highest-risk mobile issue — this will cause very slow loads on mobile connections
- Cloudflare serves content with Brotli compression (`content_encoding: br`) — good
- Viewport meta tag was not audited directly; should be confirmed via a live inspection
- No `user-scalable=no` or `maximum-scale` violations were flagged (based on accessibility score of 96)

---

## 7. Security and Hosting

| Item | Status |
|---|---|
| HTTPS | Enabled |
| Server | Cloudflare Pages |
| Canonical enforced | Yes |
| Content encoding | Brotli (br) — good compression |
| Cache headers | Cacheable (TTL: ~72,885s / ~20 hours) — adequate but not maximized |
| Console errors | 1 DOM parse error on homepage (line 444: "The given token cannot be inserted here") |

The DOM parse error may be causing rendering or indexing issues and should be investigated in the source code.

---

## 8. Third-Party Script Load

The following third-party entities were detected loading on the homepage:

| Entity | Category | Notes |
|---|---|---|
| Google Tag Manager | Tag manager | Present — should manage all other tags |
| Google Analytics | Analytics | Should fire through GTM |
| Google Fonts | CDN | Contributes to render-blocking resources |
| Facebook | Social | Pixel likely loaded; adds weight and privacy risk |
| Vimeo | Video | Likely source of heavy page weight (video embeds) |
| Copper CRM | CRM | contact/sales tool; evaluate if needed on every page |

All of these load on the homepage. Deferring non-critical third-party scripts (Facebook pixel, Copper) would reduce render-blocking time and improve Best Practices score.
