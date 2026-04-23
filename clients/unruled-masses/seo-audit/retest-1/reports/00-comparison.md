# SEO Comparison Report — Retest 1

**Site:** https://unruledmasses.org
**Baseline date:** 2026-03-21 · **Retest date:** 2026-04-23 · **Elapsed:** 33 days

---

## Executive Summary

- **Critical new regression:** Two pages have had their URLs restructured — `/our-team` moved to `/about-us/our-team` and `/playbooks` moved to `/resources/action-playbooks` — without redirects at the old URLs. Both old paths now return 404. This erases any crawl equity accumulated on those URLs and breaks any external links pointing to them.
- **Good progress on content:** Three new news articles published and seven playbooks launched under the new `/resources/action-playbooks` path. Total indexable word count roughly doubled (≈3,200 → ≈6,100 words).
- **On-page fixes landed:** The /news title and meta description were corrected, the press release title was shortened from 122 to 66 characters, and the empty H2 on the team page was resolved.
- **New article OG images implemented:** Articles now use article-specific images served from Sanity CDN — a clean fix for the generic OG image issue.
- **Performance improved on the team page:** LCP dropped from 1,469ms to 1,056ms and server response time fell from 966ms to 348ms — the SSR/caching issue appears resolved.

---

## Rankings & Traffic

| Metric | Baseline | Retest 1 | Delta |
|---|---|---|---|
| Total ranked keywords (DataForSEO) | 0 | 0 | → |
| Top-10 rankings | 0 | 0 | → |
| Estimated monthly traffic (DataForSEO) | 0 | 0 | → |

No keyword data is available in either period. Domain launched January 26, 2026 (~87 days ago). DataForSEO's database requires 90–120 days to index a new domain. First measurable data is expected in the May–June 2026 pull.

**Notable keyword movements:** None — no data available.

---

## Technical Health

### Core Web Vitals & Lighthouse — Homepage (/)

Baseline used Lighthouse 12.2; Retest 1 uses Lighthouse 13.0.3. Minor measurement variance expected.

| Metric | Baseline | Retest 1 | Delta |
|---|---|---|---|
| LCP | 1,139ms | 1,065ms | ▲ |
| CLS | 0 | 0 | → |
| TTI | 1,163ms | 1,085ms | ▲ |
| FCP | 600ms | 606ms | → |
| Performance score | 97/100 | 97/100 | → |
| SEO score | 100/100 | 100/100 | → |
| Accessibility score | 96/100 | 97/100 | ▲ |
| Best Practices score | 81/100 | 81/100 | → |
| Total byte weight | ~4.6MB | ~1.7MB | ▲ |
| Server response time | 137ms | 992ms | ▼ |

The homepage byte weight reduction (~1.7MB vs ~4.6MB) is significant and suggests Sanity image optimization is now in effect. The server response time regression (137ms → 992ms) is flagged by Lighthouse; this may reflect a Cloudflare cache miss at test time but warrants monitoring.

### Core Web Vitals & Lighthouse — Team Page

Note: Baseline measured `/our-team`; Retest 1 measured `/about-us/our-team` (new URL).

| Metric | Baseline (/our-team) | Retest 1 (/about-us/our-team) | Delta |
|---|---|---|---|
| LCP | 1,469ms | 1,056ms | ▲ |
| CLS | 0 | 0 | → |
| TTI | 1,506ms | 1,072ms | ▲ |
| FCP | 516ms | 567ms | ▼ |
| Performance score | 94/100 | 98/100 | ▲ |
| SEO score | 100/100 | 100/100 | → |
| Accessibility score | 96/100 | 97/100 | ▲ |
| Best Practices score | 81/100 | 81/100 | → |
| Total byte weight | ~4.9MB | ~1.9MB | ▲ |
| Server response time | 966ms | 348ms | ▲ |

The TTFB on the team page improved dramatically (966ms → 348ms). The 1-second server response time that was flagged in the baseline appears resolved — likely from switching to static generation or improved Cloudflare edge caching for this route.

### Issues Resolved

| Issue | Status |
|---|---|
| /news title tag too short (21 chars) | ✓ Fixed — now 38 chars |
| /news meta description generic | ✓ Fixed — now specific and topical |
| Press release title 122 chars | ✓ Fixed — now 66 chars |
| Empty H2 on /our-team | ✓ Fixed — team members now named in H2s |
| Generic OG images on articles | ✓ Fixed — new articles use Sanity CDN article images |
| /our-team TTFB 966ms | ✓ Resolved at new URL (348ms) |
| /playbooks pages not built | ✓ Partially — index page live at /resources/action-playbooks with 7 playbooks listed |

### New Issues Introduced

| Issue | Severity | Notes |
|---|---|---|
| /our-team now 404 (moved, no redirect) | ⛔ Critical | Old URL had real traffic (45 sessions in baseline). Any indexed pages or external links are now broken. |
| /playbooks still 404 (moved, no redirect) | ⛔ Critical | Old URL carried from baseline. New location exists but old URL has no redirect. |
| Homepage server response time 992ms | ⚠️ Warning | Was 137ms at baseline. May be a cache miss; monitor on next test. |
| /about-us/our-team title too short (25 chars) | ⚠️ Minor | "Our Team \| Unruled Masses" — flagged by DataForSEO. Was 32 chars at baseline. |
| /news/from-brooklyn-to-budapest title 82 chars | ⚠️ Minor | Over 60-char threshold. Likely truncated in SERPs. |
| /news/um-secures-501c3-status title 67 chars | ⚠️ Minor | Borderline — 7 chars over threshold. |
| /news/um-visits-nokings meta description 160 chars | ⚠️ Minor | Slightly over ~155-char limit. |

---

## On-Page SEO

### Title Tags

| Page | Baseline | Retest 1 | Delta |
|---|---|---|---|
| / | 54 chars ✓ | 54 chars ✓ | → |
| /our-team (→ /about-us/our-team) | "Leadership Team \| Unruled Masses" 32 chars ✓ | "Our Team \| Unruled Masses" 25 chars ⚠️ | ▼ |
| /news | "News \| Unruled Masses" 21 chars ⛔ | "News & Press Releases \| Unruled Masses" 38 chars ✓ | ▲ |
| /news/um-launches-civic-intelligence-system | 122 chars ⛔ | 66 chars ⚠️ | ▲ |
| /resources/action-playbooks | — (was 404) | "Action Playbooks \| Unruled Masses" 33 chars ✓ | ▲ |

### Meta Descriptions

| Page | Baseline | Retest 1 | Delta |
|---|---|---|---|
| / | 128 chars ✓ | 128 chars ✓ | → |
| /about-us/our-team | 83 chars ⚠️ generic | 83 chars ⚠️ generic | → |
| /news | 60 chars ⚠️ generic | 109 chars ✓ specific | ▲ |
| /news/um-launches-civic-intelligence-system | 159 chars ⚠️ stale "launched today" | 159 chars ⚠️ stale "launched today" | → |

The "launched today" meta description on the original press release remains unchanged 87 days after launch. This is a live issue that affects click-through when the page appears in search results.

### Broken Pages

| URL | Baseline | Retest 1 | Delta |
|---|---|---|---|
| /our-team | 200 ✓ | 404 ⛔ | ▼ |
| /playbooks | 404 ⛔ | 404 ⛔ | → |
| /playbooks/poster-campaigns | 404 ⛔ | not checked | — |
| /about-us/our-team | — | 200 ✓ | new |
| /resources/action-playbooks | — | 200 ✓ | new |

---

## Backlink Profile

| Metric | Baseline | Retest 1 | Delta |
|---|---|---|---|
| Total backlinks | 0 | N/A | — |
| Referring domains | 0 | N/A | — |

The backlinks API returned an access denied error (subscription required) in this retest. The baseline showed 0 referring domains via the same API. Cannot confirm whether any backlinks have been acquired. Recommend resolving the DataForSEO subscription or checking via Google Search Console if it has been set up.

---

## AI/LLM Presence

| Platform | Baseline | Retest 1 | Delta |
|---|---|---|---|
| ChatGPT | 0 mentions | N/A | — |

The AI mentions API returned access denied in this retest. Baseline showed 0 mentions. No change can be confirmed. Given the domain age (87 days) and content volume, 0 mentions remains the expected state.

---

## Outstanding Issues

### Carried forward from baseline — not yet addressed

| # | Issue | Original Priority | Status |
|---|---|---|---|
| 1.2 | Add alt text to all images | P1 | Still open — homepage, /resources/action-playbooks, and new articles all flag no_image_alt |
| 2.1 | Add Organization/WebSite/Article structured data | P2 | Still open — no schema detected on any page |
| 2.3 | Debug Best Practices score (81/100) | P2 | Still open — unchanged on all pages |
| 2.4 | Set up Search Console + submit sitemap | P2 | Status unknown — cannot verify without access |
| 3.2 | Consistent news publishing | P3 | In progress — 3 articles published since baseline ✓ |
| 3.3 | Backlink acquisition | P3 | Unknown — API inaccessible |
| 3.4 | Build AI visibility | P3 | Unknown — API inaccessible |

### New issues from this retest

| # | Issue | Priority | Effort |
|---|---|---|---|
| N1 | Add 301 redirect: /our-team → /about-us/our-team | P1 | ✓ Fixed 2026-04-23 |
| N2 | Add 301 redirect: /playbooks → /resources/action-playbooks | P1 | ✓ Fixed 2026-04-23 |
| N3 | Fix stale meta description on launch press release ("launched today") | P1 | 15 min |
| N4 | Shorten /about-us/our-team title tag (25 chars — add keyword context) | P2 | 15 min |
| N5 | Investigate homepage TTFB regression (137ms → 992ms) | P2 | 1–2 hours |
| N6 | Shorten title on /news/from-brooklyn-to-budapest (82 chars) | P2 | 15 min |
