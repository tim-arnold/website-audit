# Analytics Audit Report — NobleReach Foundation

**GA4 Property ID:** 502550797  
**Audit date:** 2026-04-16  
**Date range:** Aug 2025 – Apr 2026 (full property history — 8 months)  
**Auditor:** Claude Code

---

## Executive Summary

- **No conversion events are configured.** `form_submit` fires 285 times but is not marked as a conversion. The rebuild must implement conversion tracking from day one — currently there is no measurable signal for any meaningful user action.
- **~26% of sessions are likely bot traffic.** China (17.6%) and Singapore (8.2%) together account for 29,413 sessions — anomalous for a US government-focused foundation. Combined with a 12,652-session "Unassigned" channel (94.1% bounce) and 5,736 `(not set)` landing page sessions, roughly a quarter of all reported traffic is not real user activity.
- **The Scholars Program is the entire site.** `/talent-opportunities/noblereach-scholars-program/` alone generates 36% of all sessions. Traffic peaks sharply Oct–Dec (application cycle) then declines 65% by March. The rebuild must launch before September 2026 or it will miss the critical traffic window.
- **Direct traffic at 50.9% signals heavy UTM leakage.** Email, social, and paid campaigns are likely arriving untagged, inflating Direct and masking true channel performance.
- **The GA4 property is only 8 months old.** There is no pre-August 2025 baseline. Historical comparisons are not possible, and data retention settings should be confirmed at 14 months to preserve what exists.
- **Person pages drive meaningful organic traffic.** GA4 confirms what the SEO audit found: `/person/arun-gupta/` (1,529 sessions), `/person/glenn-gaffney/` (1,481), and a dozen others receive consistent organic traffic and must be preserved with exact URLs.
- **`/person/arun-gupta-2/` is a duplicate page with 638 real sessions.** This WordPress permalink collision needs to be resolved and traffic redirected to the canonical URL before the rebuild.

---

## 1. Property Configuration

| Field | Value | Notes |
|---|---|---|
| Property ID | 502550797 | |
| Property created | 2025-08-26 | Only 8 months of history |
| Data retention | Unknown — verify in GA4 Admin | Default is 14 months for new properties; confirm it hasn't been reduced |
| Time zone | America/Los_Angeles | Org appears DC-based — consider switching to America/New_York |
| Search Console linked | Unconfirmed | Not returned in property details API; verify in GA4 Admin → Integrations |
| Google Ads linked | Unconfirmed | Paid Search accounts for 4.5% of sessions — verify linkage in GA4 Admin |
| Custom dimensions | None | |
| Custom metrics | None | |
| Service level | Standard | |

---

## 2. URL Preservation Priority List

All pages with >100 sessions in the 8-month window. Pages are **High** priority if they have >500 sessions, confirmed keyword rankings, or SEO backlinks.

| URL | Sessions (8mo) | Keyword Rankings | Backlinks | Redirect Priority | Notes |
|---|---|---|---|---|---|
| /talent-opportunities/noblereach-scholars-program/ | 40,923 | — | many | **High** | Dominant page — 36% of all traffic |
| / | 24,555 | — | homepage | **High** | |
| /talent-opportunities/noblereach-scholars-program/scholars-faq/ | 6,394 | — | 10 (.edu) | **High** | Low bounce (32.9%) — high intent |
| /about-noblereach/team-and-board/ | 5,690 | — | — | **High** | Low bounce (22.7%) |
| /stories/ | 4,942 | — | — | **High** | High bounce (87.2%) — archive landing issue |
| /work-and-compensation/ | 3,926 | — | — | **High** | Low bounce (29.4%) |
| /about-noblereach/noblereach-jobs-internships/ | 3,918 | — | — | **High** | Low bounce (26.8%) |
| /about-noblereach/ | 3,882 | — | — | **High** | |
| /scholars-cohort/ | 3,756 | — | — | **High** | Low bounce (32.1%), 141s avg duration |
| /talent-opportunities/noblereach-scholars-program/noblereach-scholars-interest-form/ | 3,441 | — | — | **High** | Application form — highest-value action on site |
| /professional-development/ | 2,086 | — | — | **High** | |
| /news-events/news/ | 2,052 | — | — | **High** | |
| /about-noblereach/founding-story/ | 1,769 | — | — | **High** | |
| /innovation/ | 1,714 | — | — | **High** | |
| /news/16-innovations-fueled-by-the-federal-government/ | 1,616 | — | — | **High** | In Google AI Overviews; 171s avg duration |
| /person/arun-gupta/ | 1,529 | arun gupta (rank varies) | 19 | **High** | 19 backlinks; duplicate page exists at /person/arun-gupta-2/ |
| /us-tech-force/ | 1,526 | tech force (rank 20) | — | **High** | SEO-confirmed keyword |
| /person/glenn-gaffney/ | 1,481 | glenn gaffney (480), UAP queries | 2 | **High** | SEO-confirmed |
| /venture-meets-mission/ | 1,410 | — | — | **High** | |
| /news/noblereach-foundation-tech-force/ | 1,387 | — | — | **High** | |
| /us-coast-guard-internship/ | 1,175 | — | — | **High** | |
| /academic-partnerships/ | 1,006 | — | — | **High** | |
| /education/ | 960 | — | — | **High** | |
| /sign-up-for-our-newsletters/ | 952 | — | — | **High** | |
| /education/curriculum-and-credentialing/ | 793 | — | — | **High** | |
| /person/sreenivas-sree-ramaswamy/ | 788 | sree ramaswamy (rank 2) | 6 | **High** | SEO-confirmed |
| /privacy/ | 721 | — | — | Med | High bounce (91.3%) — utility page |
| /about-noblereach/partners/ | 684 | — | — | **High** | |
| /terms-of-use/ | 644 | — | — | Med | High bounce (93.9%) — utility page |
| /person/arun-gupta-2/ | 638 | — | — | **High** | Duplicate of /person/arun-gupta/ — resolve pre-rebuild |
| /academic-partnerships/curriculum/ | 593 | — | — | **High** | |
| /talent-opportunities/scholars-program-archived/nominate-a-noblereach-scholar/ | 570 | — | — | **High** | Archived but still receiving 570 sessions |
| /education/convenings/ | 518 | — | — | **High** | |
| /science-to-venture/ | 472 | — | — | **High** | |
| /talent-opportunities/noblereach-scholars-program/host-a-scholar/ | 470 | — | — | **High** | |
| /person/benjamin-claflin/ | 434 | benjamin claflin (rank 1, 880 vol) | — | **High** | Ranks #1 for name |
| /person/victoria-virasingh/ | 416 | victoria virasingh (rank 2) | 2 | **High** | SEO-confirmed |
| /academic-partnerships/academic-partners/ | 415 | — | — | **High** | |
| /scholars-partners/ | 410 | — | — | **High** | |
| /science-to-venture/our-work-with-universities/ | 409 | — | — | **High** | |
| /about-noblereach/contact-us/ | 402 | — | — | **High** | |
| /news/noblereach-foundation-announces-board-leadership-changes/ | 395 | — | — | **High** | |
| /venture-meets-mission/venture-meets-mission-stories/ | 381 | — | — | **High** | |
| /news/u-s-coast-guard-and-noblereach-launch-ai-and-robotics-internship-to-advance-national-security/ | 347 | — | — | **High** | |
| /person/pat-tamburrino/ | 334 | tamburrino (rank 19) | — | **High** | |
| /person/rebeca-lamadrid/ | 326 | — | — | **High** | |
| /science-to-venture/our-work-with-nsf/ | 322 | — | — | **High** | |
| /talent-opportunities/noblereach-interns/ | 315 | — | — | **High** | |
| /science-to-venture/our-work-with-darpa/ | 314 | — | — | **High** | |

### Additional High-Priority URLs from SEO Audit (low/no GA4 traffic but confirmed rankings or backlinks)

These pages rank for meaningful keywords. Low GA4 traffic does not mean they are unimportant — the property is only 8 months old and these may have received traffic before GA4 was installed.

| URL | Top Keyword | Search Vol | Rank | Action |
|---|---|---|---|---|
| /person/kevin-stitt/ | governor of oklahoma | 6,600 | 7–43 | Preserve exactly |
| /person/dr-robert-m-gates/ | robert gates | 6,600 | 12–27 | Preserve exactly |
| /person/pulkit-sharma/ | pulkit sharma | 4,400 | 13 | Preserve exactly |
| /stories/founders-fund/ | trae stephens | 3,600 | 8 | Preserve exactly |
| /person/anne-neuberger/ | anne neuberger | 1,600 | 10 | Preserve exactly |
| /person/general-paul-nakasone-ret/ | paul nakasone | 1,600 | 6 | Preserve exactly — also in AI Overviews |
| /stories/noblereach-emerge-lightdeck/ | lightdeck | 8,100 | 19 | Preserve exactly |

---

## 3. Data Quality Assessment

| Check | Status | Evidence | Fix in Rebuild |
|---|---|---|---|
| **Duplicate tracking** | Pass | page_view / session_start ratio = 1.51 — normal | No action needed |
| **Conversion events configured** | **Fail** | 0 conversions across all events; form_submit (285) not marked as conversion | Mark form_submit as conversion; add specific conversion events per form type (scholars interest form, newsletter signup, contact) |
| **Bot / spam traffic** | **Fail** | China (17.6%) + Singapore (8.2%) = 25.9% of sessions; Unassigned channel (11.1%) at 94.1% bounce; (not set) landing page (5,736 sessions, 97.6% bounce) | Enable bot filtering; add geographic exclusions for known crawler IP ranges; internal traffic filter |
| **Internal traffic not excluded** | Unknown | No filter visible in property details API | Verify in GA4 Admin → Data Settings → Data Filters; add Outright IP exclusion |
| **UTM parameter gaps** | **Fail** | Direct at 50.9% is anomalously high for org this size; Email (1.1%) seems too low if campaigns are active | Tag all email, social, and paid campaigns with UTM parameters; audit GTM for missing referral exclusions |
| **Cross-domain / subdomain tracking** | Unknown | smapply.us (application platform) receives referrals — check if return traffic is tagged properly | Ensure smapply.us is added as a cross-domain measurement domain, or confirm it's intentionally excluded |
| **Search Console linked** | Unknown | Not confirmed via API | Verify in GA4 Admin → Integrations; link if not already connected |
| **Google Ads linked** | Unknown | Paid Search = 5,074 sessions — account exists | Verify in GA4 Admin → Integrations; link if not already connected |
| **Data retention period** | Unknown | Not returned in property details | Verify in GA4 Admin — confirm set to 14 months (not the 2-month default) |
| **Time zone accuracy** | Minor issue | Set to America/Los_Angeles; org appears DC-based | Consider switching to America/New_York in GA4 Admin for accurate daily reporting |

---

## 4. Traffic Overview

### Channel Breakdown

| Channel | Sessions | % of Total | Engaged Sessions | Bounce Rate |
|---|---|---|---|---|
| Direct | 57,247 | 50.4% | 12,216 | 78.7% |
| Organic Search | 25,317 | 22.3% | 15,171 | 40.1% |
| Unassigned | 12,652 | 11.1% | 744 | 94.1% |
| Referral | 5,287 | 4.7% | 3,164 | 40.2% |
| Paid Search | 5,074 | 4.5% | 2,431 | 52.1% |
| Organic Social | 3,555 | 3.1% | 1,334 | 62.5% |
| Organic Video | 2,867 | 2.5% | 520 | 81.9% |
| Email | 1,197 | 1.1% | 423 | 64.7% |
| Other | 389 | 0.3% | — | — |

**Organic Search has the best engagement** (40.1% bounce, 15,171 engaged sessions) — this is the most valuable traffic. Referral is equally engaged. Direct's high volume with poor engagement (78.7% bounce) confirms significant bot/spam presence in that channel.

### Device Mix

| Device | Sessions | % |
|---|---|---|
| Desktop | 74,047 | 65.2% |
| Mobile | 36,904 | 32.5% |
| Tablet | 901 | 0.8% |

Desktop-heavy (65%) — consistent with a professional/government audience researching opportunities. Mobile must still perform well given 32.5% share.

### Monthly Traffic Trend

| Month | Sessions | New Users | Notes |
|---|---|---|---|
| Aug 2025 | 278 | 246 | Property launch, partial month |
| Sep 2025 | 7,899 | 5,806 | |
| Oct 2025 | 24,765 | 20,172 | Peak — Scholars Program cycle opens |
| Nov 2025 | 22,439 | 19,066 | |
| Dec 2025 | 21,545 | 17,541 | |
| Jan 2026 | 12,874 | 10,038 | Post-application drop |
| Feb 2026 | 10,481 | 7,770 | |
| Mar 2026 | 8,464 | 5,958 | |
| Apr 2026 | 3,411 | 2,246 | Partial month |

**Traffic is highly seasonal, driven by the Scholars Program application cycle.** Oct–Dec represents ~60% of all sessions in the 8-month window. January onward shows a consistent 30–50% month-over-month decline. The rebuild must be live and stable **before September 2026** to avoid disrupting the peak traffic window. A launch in August or early September is the safe target.

---

## 5. Conversion Tracking

### Current State

**No conversion events are configured.** The GA4 property has been collecting behavioral data since August 2025 but has never measured a conversion. Every `conversions` column in every report returns 0.

| Event | Count | Marked as Conversion | What It Represents |
|---|---|---|---|
| form_start | 579 | No | User began filling out a form |
| form_submit | 285 | No | User submitted a form — the most important unmeasured action on the site |
| view_search_results | 287 | No | Used site search |
| click | 7,351 | No | Outbound or tracked link click |
| scroll | 40,820 | No | Scrolled 90% of page |

### Conversion Funnel

Based on page traffic and form events, the primary conversion paths are:

**Scholars Program funnel:**
Scholars Program page (40,923 sessions) → FAQ page (6,394) → Interest Form (3,441) → form_submit (~285)

The form_submit:form_start ratio of 285/579 = 49% — reasonable start-to-complete rate. But because neither event is a conversion, the rebuild team has no historical baseline to measure against post-launch.

**Newsletter signup funnel:**
/sign-up-for-our-newsletters/ (952 sessions) → form_submit (included in 285 total above)

**Jobs/Careers funnel:**
/about-noblereach/noblereach-jobs-internships/ (3,918 sessions) → external job board (Lever) — no conversion measurable on-site

### Gaps and Rebuild Specifications

| Action | Current Status | Rebuild Implementation |
|---|---|---|
| Scholars interest form submission | Fires form_submit — not a conversion | Mark `form_submit` as conversion; add `conversion_type` parameter to distinguish form types |
| Newsletter signup | No conversion | Same — tag form_submit with form identifier parameter |
| Contact form submission | No conversion | Same |
| Outbound job link click | Click event fires but untagged | Add `click` conversion with filter on Lever/job board URLs |
| PDF/resource download | Unknown — no download event visible | Add `file_download` conversion event |

### Reconnection Checklist

- [ ] Verify Google Ads linkage in GA4 Admin (Paid Search is active — 5,074 sessions)
- [ ] Verify Search Console linkage in GA4 Admin
- [ ] Mark `form_submit` as a conversion event before or on launch day
- [ ] Add `form_id` or `form_type` parameter to form events to distinguish Scholars / Newsletter / Contact
- [ ] Confirm GA4 measurement ID is added to new site before DNS cutover

---

## 6. SEO Correlation

Cross-referencing GA4 sessions with the SEO baseline (collected 2026-03-19).

| Page | Organic Sessions (GA4) | Top Keyword | SEO Rank | Keyword Vol | Backlinks | AI Overview | Priority |
|---|---|---|---|---|---|---|---|
| /talent-opportunities/noblereach-scholars-program/ | 40,923 total | scholars program | — | — | many .edu | No | **Critical** |
| /talent-opportunities/noblereach-scholars-program/scholars-faq/ | 6,394 total | — | — | — | 10 .edu | No | **Critical** |
| /news/16-innovations-fueled-by-the-federal-government/ | 1,616 total | gov innovations | — | — | — | Yes | **High** |
| /person/arun-gupta/ | 1,529 total | arun gupta | varies | 720 | 19 | No | **High** |
| /us-tech-force/ | 1,526 total | tech force | 20 | 1,900 | — | No | **High** |
| /person/glenn-gaffney/ | 1,481 total | glenn gaffney | varies | 480 | 2 | No | **High** |
| /person/sreenivas-sree-ramaswamy/ | 788 total | sree ramaswamy | 2 | 50 | 6 | No | **High** |
| /person/benjamin-claflin/ | 434 total | benjamin claflin | 1 | 880 | — | No | **High** |
| /person/victoria-virasingh/ | 416 total | victoria virasingh | 2 | 90 | 2 | No | **High** |
| /person/pat-tamburrino/ | 334 total | tamburrino | 19 | 260 | — | No | High |
| /stories/noblereach-emerge-lightdeck/ | low (not in top 50) | lightdeck | 19 | 8,100 | — | No | **High** — high-volume keyword |
| /person/kevin-stitt/ | low (not in top 50) | governor of oklahoma | 7–43 | 6,600 | — | Yes (via co-citation) | **High** — high-volume keyword |
| /person/dr-robert-m-gates/ | low (not in top 50) | robert gates | 12–27 | 6,600 | — | No | **High** — high-volume keyword |
| /person/pulkit-sharma/ | low (not in top 50) | pulkit sharma | 13 | 4,400 | — | No | **High** |
| /stories/founders-fund/ | low (not in top 50) | trae stephens | 8 | 3,600 | — | No | **High** |
| /person/general-paul-nakasone-ret/ | low (not in top 50) | paul nakasone | 6 | 1,600 | — | Yes | **High** — AI Overview |

### Key Findings from SEO Correlation

**1. The Scholars Program cluster is both the SEO and traffic backbone.** The program page, FAQ, cohort page, interest form, and host-a-scholar page together account for ~54,000 sessions. These pages also hold the .edu backlink concentration. Any URL restructuring here is catastrophic.

**2. Person pages are confirmed organic traffic drivers.** The SEO audit identified person pages as the primary keyword engine; GA4 confirms that `/person/arun-gupta/`, `/person/glenn-gaffney/`, and others receive meaningful organic sessions. The low GA4 traffic on high-ranking person pages (kevin-stitt, dr-robert-m-gates) is likely explained by the property's late start — these pages ranked before GA4 was installed.

**3. `/news/16-innovations-fueled-by-the-federal-government/` is an AI Overview asset.** It receives 1,616 sessions with a long average duration (171 seconds) and appears in Google AI Overviews. Losing this URL would be a visible SEO regression.

**4. `/person/arun-gupta-2/` is a duplicate page receiving 638 real sessions.** WordPress created this when a second "Arun Gupta" record was added. The primary page `/person/arun-gupta/` has 19 backlinks. The `-2` page is splitting traffic and backlink equity. This should be resolved before the rebuild: merge content, 301 redirect `/person/arun-gupta-2/` → `/person/arun-gupta/`, and verify the canonical URL in Yoast.

**5. The `/stories/` archive page has a structural problem.** It receives 4,942 sessions but has an 87.2% bounce rate and only 12.8 seconds average duration. As a landing page it's even worse: 4,496 landings at 95.6% bounce and 6.8 seconds. Users are arriving (likely from social/referral) and immediately leaving. The rebuild should give this page a proper featured-content treatment.

---

## 7. Pre-Redesign Risks

### Critical — Data loss or traffic drop if not addressed on launch day

| # | What | Impact | How to Mitigate in Rebuild | Effort |
|---|---|---|---|---|
| R1 | GA4 tracking not reconnected on new site | Total loss of analytics from launch date forward | Add GA4 measurement ID to new site before DNS cutover; test with GA4 DebugView before going live | 1 hr |
| R2 | Scholars Program URL changed | Immediate loss of 36% of all sessions and all .edu backlinks pointing to scholars pages | Preserve all /talent-opportunities/noblereach-scholars-program/* URLs exactly; if restructuring is needed, implement 301 redirects before DNS cutover | 4–8 hrs |
| R3 | form_submit never marked as conversion | Post-launch analytics show 0 conversions — impossible to measure rebuild success | Mark form_submit as conversion event in GA4 before or on launch; add form_type parameter | 2 hrs |
| R4 | Launch during Scholars Program peak (Oct–Dec) | Any downtime or crawl errors during peak will cause measurable traffic and application loss | Target launch before September 2026; freeze non-critical deploys Oct 1 – Dec 31 | Schedule risk |

### High — Will degrade analytics quality if not fixed

| # | What | Impact | How to Mitigate in Rebuild | Effort |
|---|---|---|---|---|
| R5 | Bot traffic not filtered | Inflated session counts make all benchmarks unreliable | Enable bot filtering; add geographic exclusion for known crawler ranges; add internal traffic filter for Outright IPs | 2–3 hrs |
| R6 | UTM leakage from email / social campaigns | Direct channel inflated; true channel ROI invisible | Audit and tag all active campaigns before launch; add UTM builder to marketing workflow | 1–2 hrs |
| R7 | Search Console not linked | Organic keyword data unavailable in GA4 | Verify and link in GA4 Admin → Integrations after new site is verified in Search Console | 30 min |
| R8 | Google Ads not linked | Paid campaign performance invisible in GA4 | Verify and link in GA4 Admin after launch | 30 min |
| R9 | /person/arun-gupta-2/ duplicate live at launch | Splits traffic and backlink equity from primary Arun Gupta page (19 backlinks) | 301 redirect /person/arun-gupta-2/ → /person/arun-gupta/; set canonical; ideally resolve pre-rebuild | 1 hr |

### Medium — Improvements that won't cause immediate harm if deferred

| # | What | Impact | How to Mitigate in Rebuild | Effort |
|---|---|---|---|---|
| R10 | Data retention not confirmed at 14 months | Risk of losing the limited historical data that exists | Verify in GA4 Admin → Data Settings; set to 14 months | 15 min |
| R11 | Time zone set to Pacific instead of Eastern | Daily and hourly reporting off by 3 hours | Update in GA4 Admin → Property Settings | 15 min |
| R12 | No custom dimensions or segments | No ability to segment by audience type (scholar, employer, researcher) | Define 2–3 custom dimensions aligned to site personas; implement in new GTM container | 4–8 hrs |
| R13 | smapply.us cross-domain tracking unverified | Application platform sessions may arrive as Direct, hiding the scholars funnel completion | Add smapply.us as cross-domain measurement domain or confirm intentional exclusion | 1 hr |
| R14 | /stories/ archive has structural bounce problem | High-value content section appears to be poorly engaging as a landing experience | Redesign /stories/ as a featured content hub, not a flat archive | Design sprint |
