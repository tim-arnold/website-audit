# Report 1: Technical Baseline — noblereach.org

**Audit date:** 2026-03-19
**Platform:** WordPress on WPEngine, behind Cloudflare CDN
**Audience:** Dev team performing site rebuild

---

## Executive Summary

- Lighthouse scores are solid on performance (84–93) and SEO (92) but Best Practices is critically low (56/100) on all pages — likely caused by AppNexus ad scripts and a dev tool (BugHerd) running on production.
- **Every person page and story page is missing an H1 tag** — the highest-traffic page type on the site has no primary heading for search engines to read.
- **8 of 9 audited pages have no meta description** — only the homepage has one.
- No structured data exists anywhere on the site — a significant missed opportunity for person pages appearing in AI Overviews.
- The `/us-tech-force/` URL (1,900 monthly search volume, rank 20) is a redirect destination for a press release, not a dedicated landing page.
- Homepage page weight is 5.5MB, which is heavy; person page LCP of 2,770ms is borderline on Core Web Vitals.

---

## 1. Core Web Vitals & Lighthouse Scores

Tests run: desktop, simulated throttling (10 Mbps, 40ms RTT). Source: DataForSEO Lighthouse API (Lighthouse 12.2.0).

| Metric | Homepage (`/`) | Person Page (`/person/kevin-stitt/`) |
|---|---|---|
| **Performance** | 93/100 | 84/100 |
| **Accessibility** | 85/100 | 100/100 |
| **Best Practices** | 56/100 ⚠️ | 56/100 ⚠️ |
| **SEO** | 92/100 | 92/100 |
| LCP | 1,339ms ✓ | 2,770ms ⚠️ |
| FCP | 584ms | 532ms |
| TTI | 1,339ms | 2,774ms |
| Speed Index | 1,831ms | 1,014ms |
| Total Page Weight | **5.5MB** ⚠️ | 648KB |
| Render-blocking delay | 128ms | 143ms |
| Unused CSS savings | 60ms | 100ms |
| Unused JS savings | 150ms | 100ms |

**LCP threshold:** Good < 2.5s / Needs Improvement 2.5–4s / Poor > 4s. The person page LCP of 2,770ms is above the "good" threshold in this simulated test; real-world mobile results may be worse.

**Best Practices: 56/100** — This score is consistent across both pages and is almost certainly caused by:
1. **AppNexus** (ad exchange scripts) — unusual for a nonprofit; may be loaded via HubSpot or GTM
2. **Macropod BugHerd** — a dev/QA annotation tool that appears to be running on production; should be removed before launch

### Third-Party Scripts Loaded on Every Page

| Script | Category | Action Required |
|---|---|---|
| Google Tag Manager | Tag manager | Keep — configure properly |
| Google Analytics | Analytics | Keep |
| HubSpot | Marketing | Keep — but fix UTM canonicalization |
| Google Fonts | CDN | Consider self-hosting to eliminate render-block |
| LinkedIn Ads | Advertising | Review if needed |
| AppNexus | Ad exchange | **Investigate — remove if not intentional** |
| Macropod BugHerd | Dev tool | **Remove from production** |

---

## 2. On-Page SEO Audit

### Summary Table

| Page | Title | Title Length | Meta Desc | H1 | Canonical | On-Page Score |
|---|---|---|---|---|---|---|
| `/` | NobleReach Foundation | 21 ⚠️ short | ✓ | ✓ | ✓ | 98.17 |
| `/person/kevin-stitt/` | Kevin Stitt - NobleReach Foundation | 35 | ✗ | ✗ | ✓ | 96.34 |
| `/person/dr-robert-m-gates/` | Dr. Robert M. Gates - NobleReach Foundation | 43 | ✗ | ✗ | ✓ | 96.34 |
| `/person/general-paul-nakasone-ret/` | General Paul Nakasone (ret.) - NobleReach Foundation | 52 | ✗ | ✗ | ✓ | 96.34 |
| `/person/anne-neuberger/` | Anne Neuberger - NobleReach Foundation | 38 | ✗ | ✗ | ✓ | 96.34 |
| `/stories/noblereach-emerge-lightdeck/` | NobleReach Emerge & LightDeck - NobleReach Foundation | 53 | ✗ | ✗ | ✓ | 96.34 |
| `/stories/founders-fund/` | Founders Fund: Trae Stephens - NobleReach Foundation | 52 | ✗ | ✗ | ✓ | 96.34 |
| `/us-tech-force/` → `/news/noblereach-foundation-tech-force/` | NobleReach to provide top early-career tech talent... | 122 ⚠️ long | ✗ | ✓ (news article) | ✓ (news URL) | 96.34 |
| `/news/16-innovations-fueled-by-the-federal-government/` | 16 Innovations Fueled by the Federal Government... | 71 ⚠️ long | ✗ | ✓ | ✓ | 93.41 |

### Heading Structure

**Person pages** use H5 for the person's name with no H1 present. This is a sitewide template issue — all `/person/` URLs are affected. Google is ranking these pages for high-volume name queries (Kevin Stitt: 6,600 vol; Paul Nakasone: 1,600 vol; Anne Neuberger: 1,600 vol) with no H1 to reinforce the page topic.

**Story pages** (`/stories/*`) also lack H1 tags. Headings jump from the title tag to H3/H4 content.

**News/article pages** (`/news/*`) have proper H1 tags.

**Homepage H1:** "NobleReach is a civic leadership platform committed to rekindling a spirit of national service across all career stages." — This is a mission statement, not a keyword-optimized heading. Acceptable for the homepage but worth revisiting.

### Meta Descriptions

Only the homepage has a meta description (140 chars). All other audited pages — including the highest-traffic person pages — have none. Google will auto-generate snippets from page content, which may be suboptimal for CTR.

### Title Tag Issues

| Issue | Pages Affected |
|---|---|
| Too short (<30 chars) | Homepage ("NobleReach Foundation" — 21 chars) |
| Too long (>60 chars) | `/news/noblereach-foundation-tech-force/` (122 chars), `/news/16-innovations-fueled-by-the-federal-government/` (71 chars) |

### US Tech Force Redirect

`/us-tech-force/` (the URL that ranks for "tech force", 1,900 vol, rank 20) redirects to `/news/noblereach-foundation-tech-force/` — a press release with a 122-character title tag and no meta description. The rebuild should create a proper `/us-tech-force/` landing page rather than relying on this redirect.

---

## 3. Structured Data / Schema

**None detected on any audited page.**

This is a significant gap given the site's content:

| Schema Type | Where It Should Be Applied | Current Status |
|---|---|---|
| `Person` | All `/person/` pages | ✗ Missing |
| `Article` | All `/news/` and `/stories/` pages | ✗ Missing |
| `Organization` | Homepage | ✗ Missing |
| `BreadcrumbList` | All pages | ✗ Missing |
| `Book` | `/venture-meets-mission/` | ✗ Missing |

Person schema is particularly important: four person pages currently appear in Google AI Overviews. Structured data would strengthen those citations and improve eligibility for Knowledge Panel entries.

---

## 4. Internal Link Structure

Source: DataForSEO on-page crawl data.

- **Total internal links (sitewide):** 9,507
- **Average internal links per audited page:** ~31

Every audited page has roughly 30 internal links — a consistent navigation template. External outbound links are low (3–8 per page), appropriate for the content type.

No orphan pages were directly detected in this audit, but the high number of 404 pages (17 confirmed) suggests some internal links are pointing to dead URLs. This should be cross-checked during the rebuild.

---

## 5. Broken Pages

17 pages return 404 status. Of these, 7 have active backlinks pointing to them (link equity currently being lost):

| Broken URL | Backlinks | Ref Domains | Priority |
|---|---|---|---|
| `/person/linda-bixby/` | 8 | 7 | High |
| `/person/pasquale-tamburrino/` | 6 | 5 | High |
| `/person/luiz-camargo/` | 4 | 3 | High |
| `/person/thomas-fewer/` | 2 | 2 | Medium |
| `/jobs/` | 2 | 2 | Medium |
| `/person/jeremy-joseph/` | 2 | 2 | Medium |
| `/science-to-venture/` | 2 | 2 | Medium |

Additional 404 pages with no current backlinks (still should be resolved):
- `/providing-opportunities-for-top-tier-talent/jobs/`
- `/talent-opportunities/noblereach-fellows/`
- `/us-tech-force` (no trailing slash — duplicate of `/us-tech-force/`)
- `/about-noblereach/contact-us/`
- `/academic-partnerships/academic-partners/`
- `/_old-pages/bringing-emergingtechnologies-to-life/`

**Recommendation:** For removed person pages with backlinks (Bixby, Tamburrino, Camargo, Fewer, Joseph), redirect to the most relevant replacement — either a new person page or the team/board page. For `/jobs/`, redirect to the current jobs/careers page. For `/science-to-venture/`, redirect to the closest current program page.

---

## 6. Mobile Readiness

Not directly tested via mobile Lighthouse in this audit. However:

- Lighthouse tests ran in desktop mode; real-world mobile scores will typically be lower
- Person page LCP of 2,770ms on desktop suggests mobile could be borderline or poor under real conditions
- All pages use responsive viewport (confirmed via meta tag presence)
- WordPress platform with Cloudflare CDN — standard responsive setup, but the 5.5MB homepage weight is a concern on mobile connections

**Recommendation:** Run a mobile Lighthouse test on the new build before launch. Target LCP < 2.5s on mobile.

---

## 7. Security & Infrastructure

- **Host:** WPEngine (origin server)
- **CDN/WAF:** Cloudflare (confirmed via server header on all pages; sits in front of WPEngine)
- **HTTPS:** Enforced on all pages ✓
- **HTTP → HTTPS redirect:** Active (8 backlinks still arriving at `http://noblereach.org/`) ✓
- **Canonical tags:** Present and correct on all audited pages ✓
- **Cache TTL:** 600 seconds (10 minutes) on most pages — standard for WordPress + Cloudflare

No security issues identified in the technical audit.
