# Technical SEO Baseline — Unruled Masses

**Site:** https://unruledmasses.org
**Audit date:** 2026-03-21
**CMS:** Next.js · **Hosting:** Cloudflare Pages

---

## Executive Summary

- Lighthouse SEO scores are perfect (100/100) across all audited pages — the technical foundation is solid.
- Two pages that receive real traffic are returning 404: `/playbooks` and `/playbooks/poster-campaigns`. These must be fixed immediately.
- Homepage images are missing alt text — 25 images flagged, which affects both accessibility and image SEO.
- The news index page has critically thin content (104 words) and a title tag that is too short to be competitive.
- The press release title tag is 122 characters — more than twice the recommended limit — and will be truncated in every SERP result.
- No structured data (schema.org) is present on any page. Adding `Organization` and `Article` schema is a quick, high-value fix.

---

## 1. Core Web Vitals & Performance

All measurements are desktop simulation (Lighthouse 12.2, simulated throttling).

| Metric | Homepage | /our-team | Threshold |
|---|---|---|---|
| LCP | 1,139ms | 1,469ms | < 2,500ms ✓ |
| CLS | 0 | 0 | < 0.1 ✓ |
| TTI | 1,163ms | 1,506ms | < 3,800ms ✓ |
| FCP | 600ms | 516ms | < 1,800ms ✓ |
| Performance score | 97/100 | 94/100 | — |
| SEO score | 100/100 | 100/100 | — |
| Accessibility score | 96/100 | 96/100 | — |
| Best Practices score | 81/100 | 81/100 | — |

**Core Web Vitals pass on desktop.** No failing CWV metrics were detected. The 81/100 Best Practices score on both pages likely reflects console errors or deprecated API usage introduced by a third-party script (GTM or an embedded widget) — worth investigating in DevTools.

**Page weight is heavy.** Both pages transfer ~4.5–4.9 MB. For a mostly-text site, this is high and will disproportionately affect mobile users on slower connections. Likely caused by unoptimized images loaded from Sanity CDN.

**Server response time on /our-team is 966ms** — nearly 1 second TTFB vs. 137ms on the homepage. This is likely caused by server-side image fetching from Sanity for the 10 team member photos. Should be investigated and addressed with image caching or static generation.

---

## 2. On-Page SEO

### Title Tags

| Page | Title | Length | Status |
|---|---|---|---|
| / | Unruled Masses - Democracy is Non-Negotiable \| Join Us | 54 | ✓ Good |
| /our-team | Leadership Team \| Unruled Masses | 32 | ✓ Acceptable |
| /news | News \| Unruled Masses | 21 | ⚠️ Too short |
| /news/um-launches-civic-intelligence-system | Unruled Masses Launches Public Civic Intelligence System to Expose Corruption and Power Nonviolent Action \| Unruled Masses | 122 | ⛔ Too long — truncated in SERPs |

### Meta Descriptions

| Page | Description | Length | Status |
|---|---|---|---|
| / | Civic intelligence and action infrastructure to expose corruption, map power abuses, and help people reclaim democracy together. | 128 | ✓ Good |
| /our-team | Unruled Masses is powered by a multidisciplinary team from across the United States | 83 | ⚠️ Generic — could be more specific |
| /news | Press releases, announcements, and news from Unruled Masses. | 60 | ⚠️ Generic |
| /news/um-launches-civic-intelligence-system | Unruled Masses (UM) launched today as a nonprofit, public-interest organization building shared civic intelligence and lawful, nonviolent action infrastructure | 159 | ⚠️ Borderline long; "launched today" is stale |

### H1 Tags

| Page | H1 | Notes |
|---|---|---|
| / | Democracy is Non-Negotiable | ✓ Strong, keyword-relevant |
| /our-team | Leadership Team | ✓ Clear |
| /news | News | ⚠️ Too generic — no keyword value |
| /news/um-launches-civic-intelligence-system | Unruled Masses Launches Public Civic Intelligence System... (102 chars) | ⚠️ Matches title — very long |

### Heading Structure Issues

- **/our-team** has one empty `<h2>` tag — likely a rendering artifact from a CMS field left blank. Empty heading tags can confuse crawlers and screen readers.
- **/news** has only one H2 (the single article headline) and one H1 ("News") — page architecture is too sparse to support indexation as a news hub.

---

## 3. Canonical Tags

All live pages have correct self-referencing canonical tags. No canonical issues detected.

---

## 4. Broken Pages (404s)

| URL | Status | Notes |
|---|---|---|
| /playbooks | 404 | GA4 shows real user sessions on this URL |
| /playbooks/poster-campaigns | 404 | GA4 shows real user sessions on this URL |

Both pages are linked from the homepage ("Action Playbook" section) and appear in GA4 traffic data. They are live in user navigation but return 404. This means Google cannot index them, and any user who follows a link to these pages sees an error. This is the highest-priority technical fix on the site.

---

## 5. Structured Data

No schema.org structured data detected on any page. Missing:

| Schema Type | Page(s) | SEO Value |
|---|---|---|
| `Organization` | / | Enables Knowledge Panel, brand SERP features |
| `WebSite` with `SearchAction` | / | Enables Sitelinks Search Box |
| `Article` or `NewsArticle` | /news/* | Rich results for press coverage |
| `Person` | /our-team | Enables People knowledge cards for team members |

---

## 6. Image SEO

- **Homepage:** 25 images, at least some missing `alt` attributes (flagged by DataForSEO).
- **All pages:** Images are missing `title` attributes (minor, but a consistent pattern).
- No `width` or `height` attributes checked — if absent, these contribute to layout shift during load.
- OG images are configured site-wide (`/images/og-image.png`) — this is a generic fallback image used on all pages. Article-specific OG images would improve social sharing click-through.

---

## 7. Render-Blocking Resources

Every audited page has 1 render-blocking script and 1 render-blocking stylesheet. Given the excellent Lighthouse performance scores, these are not currently causing meaningful user-facing harm — but they are candidates for `defer`/`async` optimization.

---

## 8. Mobile Readiness

No mobile Lighthouse audit was run (DataForSEO defaults to desktop). The site is Next.js on Cloudflare Pages and visually responsive based on site inspection. Recommend running a manual mobile audit — particularly checking:
- Touch target sizes (team member cards, nav links)
- Image scaling on small viewports
- Form usability on /our-team contact section

---

## 9. Security & Hosting

| Check | Status |
|---|---|
| HTTPS | ✓ All pages |
| Server | Cloudflare Pages |
| Content encoding | Brotli (br) — optimal |
| noindex meta | Not detected on live pages |
| robots directives | `follow: true` on all pages |

No security or crawlability issues detected.

---

## 10. Internal Link Structure

| Page | Internal Links | Notes |
|---|---|---|
| / | 5 | Low for a homepage with this much content — nav links likely not counted; playbook links go to 404 |
| /our-team | 6 | Reasonable |
| /news | 7 | Reasonable |
| /news/um-launches-civic-intelligence-system | 7 | Reasonable |

The homepage has only 5 internal links. Given that it's a long-scroll page with many sections, this suggests that deep content sections are not individually linked — reducing crawl equity distribution across the site.
