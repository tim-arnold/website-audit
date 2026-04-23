# Strategic SEO Baseline — Retest 1

**Site:** https://unruledmasses.org
**Audit date:** 2026-04-23 · **Domain age:** ~87 days (launched January 26, 2026)

---

## Executive Summary

- The domain is still too new to have measurable keyword rankings in DataForSEO (90–120 day indexation lag). May 2026 is the earliest meaningful ranking data will be available.
- Content volume has roughly doubled since the baseline: three new articles and seven playbooks are now live. The site has ~6,100 indexable words across all live pages, up from ~3,200.
- New articles cover timely, relevant topics (youth resistance movements, No Kings protests, 501(c)(3) announcement) that have real news search potential.
- The 501(c)(3) designation, announced March 30, is a newsworthy event that may have generated backlinks from nonprofit directories and civic journalism outlets — but the backlinks API is currently inaccessible, so this cannot be confirmed.
- URL restructuring without redirects is the single most strategically damaging development: whatever crawl equity and early indexed links existed on `/our-team` and `/playbooks` is now severed.

---

## 1. Current Keyword Rankings

DataForSEO returns no ranking data for `unruledmasses.org` as of April 23, 2026. The domain is ~87 days old — third-party databases require 90–120 days to begin reflecting organic rankings.

**No keywords to report. No change from baseline.**

Estimated indexation timeline (updated):
- May 2026: DataForSEO should begin capturing first organic rankings
- June–July 2026: Sufficient data for strategy review and content gap analysis
- August 2026: Competitor intersection analysis becomes viable

---

## 2. Content Inventory

| URL | Status | Word Count | SEO-Ready? | Change from Baseline |
|---|---|---|---|---|
| / | Live | 1,526 | Mostly — image alt still missing | → |
| /about-us/our-team | Live | 1,535 | Mostly — title too short, meta generic | ▲ Moved + expanded (was 899 words at /our-team) |
| /news | Live | 270 | Partially — thin index | ▲ Improved (was 104 words) |
| /news/um-launches-civic-intelligence-system | Live | 662 | Partially — title borderline, meta stale | → |
| /news/from-brooklyn-to-budapest-the-fire-of-youth-resistance-is-rising | Live | 764 | Partially — title too long | New |
| /news/um-visits-nokings | Live | 562 | Mostly — meta slightly long | New |
| /news/um-secures-501c3-status | Live | 591 | Partially — title borderline, meta slightly long | New |
| /resources/action-playbooks | Live | 174 | Index only — links to individual pages | New |
| /our-team | 404 | — | — | ▼ Broken (moved, no redirect) |
| /playbooks | 404 | — | — | → Still broken |
| /playbooks/poster-campaigns | Not checked | — | — | Likely at /resources/action-playbooks now |

**Total indexable words (live pages): ~6,084** (was ~3,200 at baseline) **▲ +90%**

The playbooks section now exists at the index level. Individual playbook pages (Speak on Record, Poster Campaigns, Distributing Leaflets, Haunting Officials, Withdrawal of Bank Deposits, Reluctant and Slow Compliance, Overloading of Facilities) appear to have their own pages linked from the index — each of these is a potential SEO-targeted landing page for specific civic action queries.

---

## 3. Backlink Profile

| Metric | Baseline | Retest 1 | Delta |
|---|---|---|---|
| Total backlinks | 0 (no data) | N/A | — |
| Referring domains | 0 (no data) | N/A | — |
| .edu / .gov links | 0 | N/A | — |

The backlinks API returned an access denied error (subscription required). This was accessible at baseline and returned 0 results. Recommend:

1. Resolving the DataForSEO backlinks subscription
2. Checking Google Search Console (if set up) for the "Links" report
3. Running a one-off check via Ahrefs or Moz free tools

The 501(c)(3) announcement (March 30) and the No Kings field report (April 2) are the two events most likely to have generated early backlinks. Journalists, nonprofit directories (GuideStar, Idealist, Charity Navigator), and civic media outlets are the most probable sources.

---

## 4. AI / LLM Mention Presence

| Platform | Baseline | Retest 1 | Delta |
|---|---|---|---|
| ChatGPT | 0 mentions | N/A | — |

The AI mentions API returned access denied in this retest. At baseline, the site had 0 mentions across all tested civic queries.

Given the site's age (~87 days) and current content volume, 0 mentions remains the expected baseline state. LLM training data has a multi-month to multi-year lag. Substantive content and third-party citations are the only path to AI visibility — both are now growing.

---

## 5. Competitor Landscape

No keyword footprint exists yet for a competitive gap analysis. The competitor landscape is unchanged from the baseline: Common Cause, Represent.Us, Indivisible, ProPublica, and Issue One occupy the overlapping topical space.

The civic news content being published (No Kings, youth resistance, 501(c)(3)) positions Unruled Masses in the "news" topical cluster rather than purely in the "civic org" category. This is a viable differentiation path — the major competitors rarely publish timely field reporting.

A full domain intersection analysis should be run once Unruled Masses has a keyword footprint (~June–July 2026).

---

## 6. SERP Features & Visibility

No SERP feature appearances detectable (consistent with zero ranked keywords). Knowledge Panel for "Unruled Masses" is not present — `Organization` schema has still not been implemented, which delays this.

The 501(c)(3) press release and the No Kings field report are candidate pages for Google News inclusion. Google News pickup requires: correct `NewsArticle` schema, a Sitemap News extension, and a history of publishing. None of these are confirmed as in place.

---

## 7. New Content Assessment

Three articles published since baseline:

| Article | Published | Word Count | SEO Opportunity |
|---|---|---|---|
| From Brooklyn to Budapest: The Fire of Youth Resistance is Rising | April 16, 2026 | 764 | Moderate — youth activism, protest movement queries |
| Beyond the Signs: No Kings protests field report | April 2, 2026 | 562 | High for near-term news cycle; will decay as story ages |
| Unruled Masses Secures 501(c)(3) Status | March 30, 2026 | 591 | Primarily brand/donor searches; potential nonprofit directory backlinks |

The No Kings field report (um-visits-nokings) is the standout: it covers a nationally significant protest movement with a unique angle (first-person field reporting from four cities). This is the kind of original content that earns backlinks from journalists and civic media. The title "No Kings Protests: Stories of Defiance and Hope" is search-optimized and not just a headline.

Seven playbooks are now live:
1. Speak on Record at Local City Council Meeting
2. Poster Campaigns
3. Distributing Leaflets
4. Haunting Officials
5. Withdrawal of Bank Deposits
6. Reluctant and Slow Compliance to Abusive or Illegal Demands
7. Overloading of Facilities

These are strong SEO targets for how-to civic action queries. The index page is thin (174 words) but the individual pages carry the content depth. Each playbook should have 500+ words, a specific H1 targeting the query (e.g., "How to Speak at a City Council Meeting"), and internal links to related playbooks.

---

## 8. Priority Actions for Next Retest Cycle

### Immediate (before next Google crawl cycle)

1. **Add 301 redirects** for `/our-team` → `/about-us/our-team` and `/playbooks` → `/resources/action-playbooks` (30 min in Cloudflare Pages `_redirects`)
2. **Fix stale meta description** on launch press release — remove "launched today" language (15 min)
3. **Add image alt text** to homepage, /resources/action-playbooks, and /news/from-brooklyn-to-budapest (2–4 hours)

### High impact

4. **Add Organization + NewsArticle schema** — with four published articles, this is now more pressing than at baseline (3–5 hours)
5. **Confirm Search Console is live** — verify sitemap submitted, no crawl errors on old URLs
6. **Lengthen /about-us/our-team title** from 25 to 50–55 chars with keyword context (15 min)
7. **Investigate homepage TTFB** — 992ms in Lighthouse is flagged; confirm whether it's a cache miss or a new rendering issue (1–2 hours)

### Ongoing

8. **Publish playbook content** — individual playbook pages should be audited for depth; the index shows 7 entries but content depth per playbook is unknown
9. **Continue news publishing cadence** — the 3-article output since launch is good; maintain 2–4 per month
10. **Verify backlinks API access** and run backlink check — the 501(c)(3) and No Kings coverage may have earned first referring domains
