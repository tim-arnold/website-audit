# Technical SEO Baseline — Retest 1

**Site:** https://unruledmasses.org
**Audit date:** 2026-04-23 · **Baseline comparison:** 2026-03-21
**CMS:** Next.js · **Hosting:** Cloudflare Pages

---

## Executive Summary

- Core Web Vitals remain solid across all live pages. Performance scores held steady on the homepage (97/100) and improved significantly on the team page (94 → 98/100).
- Two URLs changed without redirects: `/our-team` moved to `/about-us/our-team` and `/playbooks` moved to `/resources/action-playbooks`. Both old paths return 404. This is the highest-priority technical issue in this retest.
- On-page fixes from the remediation plan were applied: the /news title tag and meta description are corrected, the press release title was shortened, and the empty H2 on the team page was resolved.
- Total byte weight on both main pages fell sharply (~60–65% reduction), consistent with Sanity CDN image optimization being applied.
- No structured data (schema.org) has been added. This remains an open gap.
- Image alt text is still missing on multiple pages including the homepage and the new playbooks index.

---

## 1. Core Web Vitals & Performance

All measurements: Lighthouse 13.0.3, desktop simulation, simulated throttling.

### Homepage (/)

| Metric | Retest 1 | Baseline | Threshold |
|---|---|---|---|
| LCP | 1,065ms | 1,139ms | < 2,500ms ✓ |
| CLS | 0 | 0 | < 0.1 ✓ |
| TTI | 1,085ms | 1,163ms | < 3,800ms ✓ |
| FCP | 606ms | 600ms | < 1,800ms ✓ |
| Performance score | 97/100 | 97/100 | — |
| SEO score | 100/100 | 100/100 | — |
| Accessibility score | 97/100 | 96/100 | — |
| Best Practices score | 81/100 | 81/100 | — |
| Total byte weight | ~1.7MB | ~4.6MB | — |
| Server response time | 992ms | 137ms | < 600ms recommended |

Core Web Vitals all pass. Byte weight has dropped substantially, likely from Sanity image pipeline optimization (`?w=...&auto=format` parameters now applied). The server response time of 992ms is flagged by Lighthouse. This may reflect a Cloudflare cold-start cache miss at test time — monitor on the next test. If it persists, investigate whether recent code changes introduced server-side rendering to the homepage route.

### /about-us/our-team

| Metric | Retest 1 | Baseline (/our-team) | Threshold |
|---|---|---|---|
| LCP | 1,056ms | 1,469ms | < 2,500ms ✓ |
| CLS | 0 | 0 | < 0.1 ✓ |
| TTI | 1,072ms | 1,506ms | < 3,800ms ✓ |
| FCP | 567ms | 516ms | < 1,800ms ✓ |
| Performance score | 98/100 | 94/100 | — |
| SEO score | 100/100 | 100/100 | — |
| Accessibility score | 97/100 | 96/100 | — |
| Best Practices score | 81/100 | 81/100 | — |
| Total byte weight | ~1.9MB | ~4.9MB | — |
| Server response time | 348ms | 966ms | < 600ms ✓ |

The TTFB issue that was flagged in the baseline (966ms — suspected SSR fetching Sanity data on each request) is resolved. The team page now loads in 348ms server response time, suggesting it has been switched to static generation or ISR.

---

## 2. On-Page SEO

### Title Tags

| Page | Title | Length | Status |
|---|---|---|---|
| / | Unruled Masses - Democracy is Non-Negotiable \| Join Us | 54 | ✓ Good |
| /about-us/our-team | Our Team \| Unruled Masses | 25 | ⚠️ Too short |
| /news | News & Press Releases \| Unruled Masses | 38 | ✓ Good |
| /news/um-launches-civic-intelligence-system | Unruled Masses Launches Civic Intelligence System \| Unruled Masses | 66 | ⚠️ Borderline long |
| /resources/action-playbooks | Action Playbooks \| Unruled Masses | 33 | ✓ Good |
| /news/from-brooklyn-to-budapest-the-fire-of-youth-resistance-is-rising | From Brooklyn to Budapest: The Fire of Youth Resistance is Rising \| Unruled Masses | 82 | ⛔ Too long |
| /news/um-visits-nokings | No Kings Protests: Stories of Defiance and Hope \| Unruled Masses | 64 | ⚠️ Borderline |
| /news/um-secures-501c3-status | Unruled Masses Secures 501(c)(3) Tax Exempt Status \| Unruled Masses | 67 | ⚠️ Borderline long |

Changes from baseline:
- /news title fixed ✓ (was "News | Unruled Masses", 21 chars)
- Press release title fixed ✓ (was 122 chars)
- /about-us/our-team title now too short — "Our Team | Unruled Masses" provides less keyword signal than "Leadership Team | Unruled Masses" (baseline). Recommend expanding, e.g.: "Our Team | Unruled Masses — Civic Democracy Org"

### Meta Descriptions

| Page | Description | Length | Status |
|---|---|---|---|
| / | Civic intelligence and action infrastructure to expose corruption, map power abuses, and help people reclaim democracy together. | 128 | ✓ Good |
| /about-us/our-team | Unruled Masses is powered by a multidisciplinary team from across the United States | 83 | ⚠️ Generic |
| /news | Follow Unruled Masses for the latest on civic intelligence, corruption accountability, and nonviolent action. | 109 | ✓ Good |
| /news/um-launches-civic-intelligence-system | Unruled Masses (UM) launched today as a nonprofit, public-interest organization building shared civic intelligence and lawful, nonviolent action infrastructure | 159 | ⚠️ Stale — "launched today" is now 87 days ago |
| /resources/action-playbooks | Step-by-step guides for civic action — from poster campaigns to community organizing. | 85 | ✓ Good |
| /news/um-visits-nokings | Watch Unruled Masses' field report from the No Kings protests in NYC, DC, NOLA, and Charlotte. Hear the raw stories of citizens fighting oppression and tyranny. | 160 | ⚠️ Slightly over limit |

### H1 Tags

| Page | H1 | Notes |
|---|---|---|
| / | Democracy is Non-Negotiable | ✓ Strong |
| /about-us/our-team | Our Team | ⚠️ Generic — no keyword value |
| /news | News | ⚠️ Generic |
| /news/um-launches-civic-intelligence-system | Unruled Masses Launches Public Civic Intelligence System… (102 chars) | ⚠️ Matches H1 from baseline — still very long |
| /resources/action-playbooks | Action Playbooks | ✓ Clear |

### Heading Structure

- **/about-us/our-team:** Team member names are now in H2 tags (Nick Van Zandt, Deanna Wilken, etc.) — the empty H2 from the baseline is resolved. ✓
- **/resources/action-playbooks:** Seven playbooks listed as H2 headings. Content is thin (174 words) — the page is an index. Individual playbook pages carry the depth.
- **/news:** Four articles now indexed as H2 headings. Content growing but still thin at the index level (270 words).
- **/news/from-brooklyn-to-budapest:** No H2 headings within the article body — just footer nav H2s. Long-form articles benefit from internal subheadings for both readability and SEO.

---

## 3. Canonical Tags

All live pages have correct self-referencing canonical tags. No canonical issues detected.

The new URLs at `/about-us/our-team` and `/resources/action-playbooks` have correct canonicals pointing to their own URLs. There are no canonical tags at the old 404 URLs — they just 404, meaning any Google-indexed versions of those pages will surface as errors in Search Console.

---

## 4. Broken Pages / URL Changes

| URL | Baseline Status | Retest 1 Status | Notes |
|---|---|---|---|
| /our-team | 200 ✓ | 404 ⛔ | Moved to /about-us/our-team — no redirect |
| /playbooks | 404 ⛔ | 404 ⛔ | Moved to /resources/action-playbooks — no redirect |
| /playbooks/poster-campaigns | 404 ⛔ | not checked | Content now exists at /resources/action-playbooks |
| /about-us/our-team | — | 200 ✓ | New URL for team page |
| /resources/action-playbooks | — | 200 ✓ | New URL for playbooks index |

The missing redirects are the most critical technical gap in this retest. `/our-team` received 45 sessions in the baseline (the #2 traffic page). Google has likely already crawled it and may have indexed it. Without a 301 redirect:
- Any backlinks or bookmarks pointing to `/our-team` are broken
- Google will eventually drop the indexed page and treat it as a crawl error
- Link equity accumulated on `/our-team` is not transferred to `/about-us/our-team`

Fix: Add 301 redirects in Cloudflare Pages (`_redirects` file or Pages routing rules):
```
/our-team  /about-us/our-team  301
/playbooks  /resources/action-playbooks  301
/playbooks/poster-campaigns  /resources/action-playbooks  301
```

---

## 5. Structured Data

No schema.org structured data detected on any page. This gap is unchanged from the baseline.

| Schema Type | Page(s) | SEO Value | Status |
|---|---|---|---|
| `Organization` | / | Knowledge Panel, brand SERP features | ⛔ Missing |
| `WebSite` with `SearchAction` | / | Sitelinks Search Box | ⛔ Missing |
| `Article` / `NewsArticle` | /news/* | Rich results for press coverage | ⛔ Missing |
| `Person` | /about-us/our-team | People knowledge cards | ⛔ Missing |

With four published news articles, the absence of `NewsArticle` schema is increasingly costly — structured data enables rich snippets in news search.

---

## 6. Image SEO

| Page | Images | Alt Text | Status |
|---|---|---|---|
| / | 15 | Partially missing | ⚠️ no_image_alt flagged |
| /about-us/our-team | 18 | Not flagged by DataForSEO | Improved |
| /news | 3 | Not flagged | ✓ |
| /news/um-launches-civic-intelligence-system | 3 | Not flagged | ✓ |
| /resources/action-playbooks | 11 | Missing | ⚠️ no_image_alt flagged |
| /news/from-brooklyn-to-budapest | 4 | Missing | ⚠️ no_image_alt flagged |

The homepage image count dropped from 25 to 15 (some content reorganized), but alt text is still partially absent. New article images on um-visits-nokings and um-secures-501c3-status are not flagged. The action playbooks index and the Brooklyn/Budapest article are missing alt text.

All pages still missing image `title` attributes — a consistent pattern site-wide.

New articles now use article-specific OG images served via Sanity CDN with image transformation parameters (`?w=1200&h=630`). This is a meaningful improvement over the generic fallback used at baseline.

---

## 7. Render-Blocking Resources

All pages still have 1 render-blocking script and 1 render-blocking stylesheet. Consistent with baseline. Given the strong Lighthouse scores, these are not causing user-facing harm — but remain candidates for `defer`/`async` optimization.

---

## 8. Mobile Readiness

No mobile Lighthouse audit was run. Site remains Next.js on Cloudflare Pages with responsive layout. The team page content has expanded significantly (899 → 1,535 words) — recommend a mobile check to verify the expanded content layout holds on small viewports.

---

## 9. Security & Hosting

| Check | Status |
|---|---|
| HTTPS | ✓ All pages |
| Server | Cloudflare Pages |
| Content encoding | Brotli (br) ✓ |
| noindex meta | Not detected on live pages |
| robots directives | follow: true on all pages |

No change from baseline.

---

## 10. Internal Link Structure

| Page | Internal Links | Notes |
|---|---|---|
| / | 9 | Up from 5 — news article now linked from homepage |
| /about-us/our-team | 8 | Up from 6 |
| /news | 12 | Up from 7 — 4 articles now linked |
| /resources/action-playbooks | 15 | New — links to 7 individual playbook pages |
| /news/um-launches-civic-intelligence-system | 9 | Up from 7 |

Internal link structure has improved across the board. The homepage now links to the latest news article. The playbooks index links to 7 individual playbook pages, distributing crawl equity into the playbooks section.

The old homepage links to `/playbooks` are presumably now updated to `/resources/action-playbooks` — the footer confirms this. If any hardcoded `/playbooks` links remain in body content, they should be updated.
