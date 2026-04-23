# SEO Retest 1 — Raw Data

**Site:** https://unruledmasses.org
**Collected:** 2026-04-23
**Tools:** DataForSEO Labs, DataForSEO On-Page, Lighthouse 13.0.3, Playwright

---

## 1. Domain Rank Overview

`dataforseo_labs_google_domain_rank_overview` — target: unruledmasses.org, US/en

**Result:** No data. Empty items array. Domain not yet indexed in DataForSEO's organic database.

---

## 2. Ranked Keywords

`dataforseo_labs_google_ranked_keywords` — target: unruledmasses.org, US/en, limit 100, sorted by search volume

**Result:** No data. Empty items array.

`dataforseo_labs_google_ranked_keywords` — same, filtered rank_group ≤ 10

**Result:** No data. Empty items array.

---

## 3. Backlinks

`backlinks_summary`, `backlinks_referring_domains`, `backlinks_anchors` — all returned:

**Result:** Access denied (Code: 40204). Backlinks subscription not active. Could not compare against baseline.

Note: At baseline (March 21), these APIs returned 0 results (no subscription error). Subscription may have lapsed.

---

## 4. AI/LLM Mentions

`ai_opt_llm_ment_search` — target: unruledmasses.org, platform: chat_gpt, US/en

**Result:** Access denied (Code: 40204). API not accessible under current subscription.

---

## 5. On-Page Audits

### 5a. Homepage (/)

- Status: 200
- Onpage score: 97.07
- Title: "Unruled Masses - Democracy is Non-Negotiable | Join Us" — 54 chars
- Description: "Civic intelligence and action infrastructure to expose corruption, map power abuses, and help people reclaim democracy together." — 128 chars
- H1: "Democracy is Non-Negotiable"
- H2s: Systems meant to protect people are failing. / What We're Building / Help Us Build / How It All Works / Latest News / The stewards of this work / Navigate / Legal / Connect
- H3s: A system that turns awareness into peaceful power. / What We're Building / Corruption Intelligence Platform / Abuse Library & Action Playbook / Partnerships & Multi-Channel Outreach / Media Programming & Community Hope / **From Brooklyn to Budapest: The Fire of Youth Resistance is Rising** (new) / Contact Inquiry
- Canonical: https://unruledmasses.org/
- Internal links: 9 (was 5)
- External links: 5
- Images: 15 (was 25)
- Scripts: 23 (was 21)
- Word count: 1,526 (was 1,606)
- Render-blocking scripts: 1
- Render-blocking stylesheets: 1
- Flags: no_image_alt, no_image_title, low_content_rate, has_render_blocking_resources
- Timing: TTI 1,743ms, DOM complete 2,385ms, TTFB 1,242ms
- Server: Cloudflare / Brotli

### 5b. /our-team

- Status: **404 — BROKEN**
- URL has moved to /about-us/our-team; no redirect in place

### 5c. /about-us/our-team (new URL)

- Status: 200
- Onpage score: 98.17
- Title: "Our Team | Unruled Masses" — 25 chars (**title_too_short** flagged)
- Description: "Unruled Masses is powered by a multidisciplinary team from across the United States" — 83 chars
- H1: "Our Team"
- H2s (team members): Nick Van Zandt / Deanna Wilken / Jennifer Kirby-McLemore / Kim Taylor / Kurt Bauer / Tim Arnold / Dr. Honey Minkowitz / More Team Members / The stewards of this work / Contact Us / Stay in the loop / Support our work / Navigate / Legal / Connect
- Canonical: https://unruledmasses.org/about-us/our-team
- Internal links: 8 (was 6)
- Images: 18 (was 10)
- Word count: 1,535 (was 899)
- Scripts: 23
- Flags: title_too_short, no_image_title, low_content_rate, has_render_blocking_resources
- No empty H2 tags detected (was flagged in baseline) ✓
- Timing: TTI 935ms, DOM complete 1,627ms, TTFB 465ms
- Server: Cloudflare / Brotli

### 5d. /news

- Status: 200
- Onpage score: 100
- Title: "News & Press Releases | Unruled Masses" — 38 chars (was "News | Unruled Masses" — 21 chars) ✓ fixed
- Description: "Follow Unruled Masses for the latest on civic intelligence, corruption accountability, and nonviolent action." — 109 chars ✓ fixed
- H1: "News"
- H2s (articles listed): From Brooklyn to Budapest... / Beyond the Signs... / Unruled Masses Secures 501(c)(3) Status... / Unruled Masses Launches Public Civic Intelligence System...
- Canonical: https://unruledmasses.org/news
- Internal links: 12 (was 7)
- Images: 3
- Word count: 270 (was 104)
- Flags: no_image_title, low_content_rate, has_render_blocking_resources

### 5e. /news/um-launches-civic-intelligence-system

- Status: 200
- Onpage score: 98.17
- Title: "Unruled Masses Launches Civic Intelligence System | Unruled Masses" — 66 chars (was 122 chars) ✓ fixed
- DataForSEO title_too_long still flagged (threshold: 60 chars); 66 chars is borderline in practice
- Description: "Unruled Masses (UM) launched today as a nonprofit..." — 159 chars (stale "launched today" unchanged)
- H1: "Unruled Masses Launches Public Civic Intelligence System..." (102 chars)
- OG type: article ✓ (was "website" in baseline)
- Word count: 662 (was 612)
- Internal links: 9
- Images: 3

### 5f. /playbooks

- Status: **404 — BROKEN**
- URL has moved to /resources/action-playbooks; no redirect in place

### 5g. /resources/action-playbooks (new URL)

- Status: 200
- Onpage score: 97.07
- Title: "Action Playbooks | Unruled Masses" — 33 chars
- Description: "Step-by-step guides for civic action — from poster campaigns to community organizing." — 85 chars
- H1: "Action Playbooks"
- H2s (playbooks): Speak on Record at Local City Council Meeting / Poster Campaigns / Distributing Leaflets / Haunting Officials / Withdrawal of Bank Deposits / Reluctant and Slow Compliance to Abusive or Illegal Demands / Overloading of Facilities / (footer nav items)
- Canonical: https://unruledmasses.org/resources/action-playbooks
- Internal links: 15
- Images: 11
- Word count: 174 (index page — thin, links to individual playbook pages)
- Flags: no_image_alt, no_image_title, low_content_rate

### 5h. /news/from-brooklyn-to-budapest-the-fire-of-youth-resistance-is-rising (new)

- Status: 200
- Onpage score: 95.24
- Published: April 16, 2026
- Title: "From Brooklyn to Budapest: The Fire of Youth Resistance is Rising | Unruled Masses" — 82 chars (title_too_long)
- Description: "They're young. They're angry. And there are millions of them. Youth activism against corruption is on the rise." — 111 chars
- H1: "From Brooklyn to Budapest: The Fire of Youth Resistance is Rising"
- OG type: article ✓
- OG image: Sanity CDN (article-specific) ✓
- Word count: 764
- Flags: title_too_long, no_image_alt, no_image_title, low_content_rate

### 5i. /news/um-visits-nokings (new)

- Status: 200
- Onpage score: 97.44
- Published: April 2, 2026
- Title: "No Kings Protests: Stories of Defiance and Hope | Unruled Masses" — 64 chars (borderline)
- Description: "Watch Unruled Masses' field report from the No Kings protests in NYC, DC, NOLA, and Charlotte. Hear the raw stories of citizens fighting oppression and tyranny." — 160 chars (slightly over limit)
- H1: "Beyond the Signs: Personal stories of defiance and hope at No Kings"
- OG type: article ✓
- OG image: Sanity CDN (article-specific) ✓
- Word count: 562
- seo_friendly_url not flagged

### 5j. /news/um-secures-501c3-status (new)

- Status: 200
- Onpage score: 98.17
- Published: March 30, 2026
- Title: "Unruled Masses Secures 501(c)(3) Tax Exempt Status | Unruled Masses" — 67 chars (title_too_long by DataForSEO threshold)
- Description: "Support Unruled Masses, now a 501(c)(3) public charity. We provide tools to expose corruption and coordinate nonviolent resistance. Your tax-deductible gift fuels democracy." — 173 chars (over limit)
- H1: "Unruled Masses Secures 501(c)(3) Status, Launching a People-First Organization for Democracy and Hope"
- OG type: article ✓
- OG image: Sanity CDN (article-specific) ✓
- Word count: 591

---

## 6. Lighthouse Scores

### Homepage (/)

Lighthouse 13.0.3, desktop simulation

| Category | Score |
|---|---|
| Performance | 97/100 |
| Accessibility | 97/100 |
| Best Practices | 81/100 |
| SEO | 100/100 |

| Metric | Value |
|---|---|
| FCP | 606ms |
| LCP | 1,065ms |
| TTI | 1,085ms |
| CLS | 0 |
| TBT | 0.5ms |
| Server response time | 992ms |
| Total byte weight | ~1.7MB |

### /about-us/our-team

Lighthouse 13.0.3, desktop simulation

| Category | Score |
|---|---|
| Performance | 98/100 |
| Accessibility | 97/100 |
| Best Practices | 81/100 |
| SEO | 100/100 |

| Metric | Value |
|---|---|
| FCP | 567ms |
| LCP | 1,056ms |
| TTI | 1,072ms |
| CLS | 0 |
| Server response time | 348ms |
| Total byte weight | ~1.9MB |

---

## 7. URL Structure Changes Detected via Playwright

Footer navigation links confirm site restructure:
- Old: `/our-team` → New: `/about-us/our-team`
- Old: `/playbooks` → New: `/resources/action-playbooks`

Neither old URL has a redirect in place (both return 404).

New article URLs confirmed:
- `/news/from-brooklyn-to-budapest-the-fire-of-youth-resistance-is-rising` (April 16, 2026)
- `/news/um-visits-nokings` (April 2, 2026)
- `/news/um-secures-501c3-status` (March 30, 2026)
