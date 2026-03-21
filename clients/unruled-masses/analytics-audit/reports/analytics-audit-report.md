# Analytics Audit Report — Unruled Masses

**Site:** https://unruledmasses.org
**GA4 Property ID:** 526160702
**Audit date:** 2026-03-21
**Data range available:** 2026-02-26 to 2026-03-20 (~3.5 weeks)
**Audience:** Dev team / marketing ops

---

## Executive Summary

- **The analytics setup is newly created and critically incomplete.** The property was created on 2026-02-26; there are only 126 sessions of data. No trend analysis is possible yet.
- **Zero conversions are configured.** Not a single event is marked as a conversion, making GA4 useless for measuring any goal — donations, form submissions, downloads, or video plays.
- **The Sanity Studio admin panel (`/studio/`) is being tracked as public user traffic.** Internal editorial sessions are flowing into GA4 alongside real visitors, corrupting page-level data.
- **Duplicate event tracking is confirmed.** `Click`/`click` and `Download`/`file_download` both fire for the same actions, inflating event counts. Legacy GA3 events (`checkout_progress`, `set_checkout_option`) are also present — old tracking code has not been removed.
- **76% of sessions are "Direct"** — consistent with developer self-visits, untagged links in newsletters/social posts, and no internal traffic filter in place.
- **Search Console is not linked.** Organic keyword data is unavailable.
- **No SEO audit cross-reference available** — SEO audit has not yet been run for this client.

---

## 1. Property Configuration

| Property ID | Data Retention | Time Zone | Search Console | Google Ads | Custom Dimensions |
|---|---|---|---|---|---|
| 526160702 | Unknown (default: 2 mo) | America/New_York | Not linked | Not linked | 0 |

**Notes:**
- Standard GA4 (not 360). Data retention default is 2 months unless changed in Admin → Data Settings → Data Retention.
- No annotations, no custom dimensions, no custom metrics configured.
- Property was created 2026-02-26 — all data is from the first 3.5 weeks of operation.

---

## 2. Data Quality Assessment

| Check | Status | Evidence | Recommended Fix |
|---|---|---|---|
| **Sanity Studio tracked as user traffic** | FAIL | `/studio/` and deep sub-paths appear throughout page and landing page data (7 sessions on `/studio`, 6 on `/studio/structure/launchPage`, etc.) | Exclude `/studio` via GA4 Admin → Data Streams → Configure Tag → List of unwanted referrals, OR add a `traffic_type: internal` parameter and create a Data Filter in Admin → Data Filters |
| **Duplicate event tracking** | FAIL | `Click` (36) + `click` (26) = 62 events for clicks; `Download` (19) + `file_download` (23) = 42 events for downloads — same actions firing twice | Audit GTM or inline tracking code. Remove one of each duplicate pair. GA4 auto-collects `click` and `file_download` — custom `Click` and `Download` events should be retired |
| **Legacy GA3 events present** | FAIL | `checkout_progress` (12) and `set_checkout_option` (12) are Universal Analytics ecommerce events and should not appear in a GA4 property | Find and remove the old GA3 tracking snippet or GTM tag that fires these events |
| **No conversion events configured** | FAIL | All 15 event types show 0 conversions in GA4 | Mark key events as conversions in Admin → Events (see Section 4 for recommendations) |
| **No internal traffic filter** | FAIL | No data filter in property; direct traffic at 76% is consistent with unfiltered developer/team visits | GA4 Admin → Data Filters → Create filter → Internal Traffic. Add developer/team IPs to the `traffic_type=internal` parameter in the tag |
| **Search Console not linked** | FAIL | Not present in property metadata | GA4 Admin → Product Links → Search Console Links → Link |
| **High direct traffic (76%)** | FAIL | Direct = 96/126 sessions. New site with minimal organic presence — this is almost certainly self-visits and untagged links, not genuine direct traffic | Apply internal traffic filter; tag all outbound links (newsletters, social posts) with UTM parameters |
| **`(not set)` landing page (20 sessions)** | WARN | 85% bounce rate, 4s avg duration — likely bot traffic, crawler hits, or app-based sessions with no referrer | Monitor over time; if persistent, investigate via DebugView and consider bot filtering |
| **Data retention period** | Unknown | API did not return retention setting | GA4 Admin → Data Settings → Data Retention → change to 14 months |
| **Google Ads linked** | N/A | No paid search evidence | Link if paid campaigns are planned |
| **Custom dimensions for custom events** | FAIL | `Depth`, `Click`, `Download`, `Play` custom events fire but no custom dimensions capture their parameters (e.g., which file was downloaded, scroll depth value) | Define custom dimensions in Admin → Custom Definitions after standardizing event names |

---

## 3. Traffic Overview

### Channel Breakdown

| Channel | Sessions | % of Total | Engaged Sessions | Bounce Rate | Conversions |
|---|---|---|---|---|---|
| Direct | 96 | 76.2% | 67 | 30.2% | 0 |
| Organic Search | 17 | 13.5% | 12 | 29.4% | 0 |
| Referral | 10 | 7.9% | 5 | 50.0% | 0 |
| Organic Social | 3 | 2.4% | 3 | 0% | 0 |
| **Total** | **126** | 100% | **87** | — | **0** |

Direct traffic at 76% on a 3.5-week-old site is a strong indicator that most traffic is the team itself using the live site during build/launch. Organic search at 13.5% is promising early signal but too small to draw conclusions.

### Device Mix

| Device | Sessions | % of Total | Bounce Rate |
|---|---|---|---|
| Desktop | 96 | 75.6% | 28.1% |
| Mobile | 31 | 24.4% | 38.7% |
| Tablet | 0 | 0% | — |

Desktop-heavy mix is consistent with a team-dominated audience in early launch phase. Real-world audience will likely skew more mobile. Mobile bounce rate is higher than desktop — worth monitoring as organic traffic grows.

### Top 10 Landing Pages

| Landing Page | Sessions | Bounce Rate | Avg Duration | Conversions |
|---|---|---|---|---|
| / | 88 | 15.9% | 9m 30s | 0 |
| (not set) | 20 | 85.0% | 4s | 0 |
| /our-team | 8 | 75.0% | 38s | 0 |
| /news | 4 | 0% | 16m 44s | 0 |
| /studio ⚠️ | 2 | 0% | 30m 51s | 0 |
| /news/um-launches-civic-intelligence-system | 1 | 100% | 4s | 0 |
| /playbooks | 1 | 0% | 2m 44s | 0 |
| /playbooks/poster-campaigns | 1 | 0% | 1m 5s | 0 |
| /privacy | 1 | 100% | 4s | 0 |

⚠️ `/studio` is the Sanity CMS admin — not a public page.

The homepage engagement is strong (9m 30s avg, 15.9% bounce) suggesting real visitors who do land there are meaningfully engaged. `/our-team` at 75% bounce is a flag — users arriving there aren't continuing to explore.

### Traffic Trend

Only 3.5 weeks of data exist. 126 sessions total, 41 new users. No trend is interpretable. Baseline for month-over-month comparison begins in April 2026.

---

## 4. Conversion Tracking

### Events Currently Configured as Conversions

None. Zero conversion events are marked in this property.

### All Events Tracked

| Event Name | Count | Type | Issue |
|---|---|---|---|
| page_view | 484 | GA4 standard | — |
| Depth | 313 | Custom | Capitalized name; no custom dimension for depth value |
| user_engagement | 199 | GA4 standard | — |
| session_start | 127 | GA4 standard | — |
| scroll | 64 | GA4 standard | — |
| first_visit | 41 | GA4 standard | — |
| Click | 36 | Custom | Duplicates `click`; capitalized |
| click | 26 | GA4 standard | — |
| file_download | 23 | GA4 standard | — |
| Download | 19 | Custom | Duplicates `file_download`; capitalized |
| checkout_progress | 12 | **Legacy GA3** | Should not exist in GA4 |
| set_checkout_option | 12 | **Legacy GA3** | Should not exist in GA4 |
| Play | 8 | Custom | Capitalized; no custom dimension for media title |
| begin_checkout | 8 | GA4 standard | Not marked as conversion |
| form_start | 5 | GA4 standard | No corresponding `form_submit` event found |

### Gaps: Actions That Should Be Tracked as Conversions

| Action | Recommended Event Name | Priority |
|---|---|---|
| Donation / contribute click or completion | `donate_click` or `purchase` | Critical |
| Newsletter / email signup | `sign_up` | High |
| Form submission (contact, etc.) | `form_submit` | High — `form_start` fires but no `form_submit` found |
| File/playbook download | `file_download` (deduplicated) | Medium — mark as conversion after deduplication |
| Video/media play | `play` (lowercase) | Medium |
| Outbound link to key partners | `outbound_click` with `link_url` dimension | Medium |

### Recommendations

1. **Immediately** mark at least one high-intent event as a conversion once deduplication is done (e.g., `form_submit`, `donate_click`).
2. Verify whether a `form_submit` event is expected on the site — `form_start` fires 5 times with no corresponding submission events, suggesting form submissions are not being tracked through to completion.
3. `begin_checkout` (8 events) — investigate what triggers this. If the site has a donation flow via a third-party checkout, this may be a cross-domain tracking gap where the conversion happens off-site and is never recorded.

---

## 5. SEO Correlation

*SEO audit not yet run for this client. Omitted.*

---

## 6. Remediation Priorities

### Critical — Fix immediately (data integrity)

| # | What | Risk | Fix | Effort |
|---|---|---|---|---|
| C1 | **Exclude Sanity Studio from GA4 tracking** | `/studio/` traffic is internal CMS editing sessions — corrupts all page-level metrics | Add `/studio` path exclusion in GA4 Data Stream tag settings, or add `traffic_type: internal` parameter on all `/studio` pageviews and create a Data Filter to exclude it | Low (1–2 hours) |
| C2 | **Remove legacy GA3 events** | `checkout_progress` and `set_checkout_option` indicate an old UA tracking snippet or GTM tag is still live — creates false event data | Audit GTM workspace or site codebase for any `ga()` or UA measurement ID calls; remove or disable | Low–Medium (2–4 hours) |
| C3 | **Deduplicate click and download events** | Double-counting inflates engagement metrics; `Click`/`click` and `Download`/`file_download` each fire twice per action | Remove custom `Click` and `Download` GTM tags/code — GA4 auto-collects these natively via `click` and `file_download` | Low (1–2 hours) |
| C4 | **Configure at least one conversion event** | Without conversions, GA4 cannot measure any goal — the property is analytics-only with no measurement value | In GA4 Admin → Events, toggle at minimum: `form_submit` (once verified firing), `donate_click` | Low (30 min — once events are clean) |

### High — Fix soon (configuration gaps)

| # | What | Risk | Fix | Effort |
|---|---|---|---|---|
| H1 | **Add internal traffic filter** | Team and developer visits inflate all metrics, particularly during launch period | GA4 Admin → Data Filters → Internal Traffic. Configure developer IPs in the gtag `traffic_type` parameter | Low (1–2 hours) |
| H2 | **Link Search Console** | No organic keyword data in GA4; can't correlate rankings with landing page traffic | GA4 Admin → Product Links → Search Console Links | Low (15 min) |
| H3 | **Add UTM parameters to all outbound links** | 76% direct traffic likely includes untagged newsletter, social, and partner links inflating "Direct" | Tag all links in email campaigns, social posts, and partner sites with `utm_source`, `utm_medium`, `utm_campaign` | Medium (ongoing) |
| H4 | **Add `form_submit` tracking** | `form_start` fires (5×) but no form submission event exists — form completions are invisible | Add `form_submit` event in GTM on form submission trigger; mark as conversion | Low–Medium (2–4 hours) |

### Medium — Planned work

| # | What | Risk | Fix | Effort |
|---|---|---|---|---|
| M1 | **Change data retention to 14 months** | Default 2-month retention will delete historical data — by May 2026 the launch period data will be gone | GA4 Admin → Data Settings → Data Retention → set to 14 months | Low (5 min) — do immediately |
| M2 | **Standardize custom event naming to snake_case** | `Depth`, `Click`, `Download`, `Play` use capitalized names — inconsistent with GA4 convention; makes reporting harder | Rename to `depth`, `play` etc. in GTM; update any code-based instrumentation. Note: renaming creates a historical break — document the date | Medium (2–4 hours) |
| M3 | **Add custom dimensions for custom events** | `Depth`, `Play`, `Download` fire without parameter data — can't see depth values, media titles, or file names in reports | Define custom dimensions in GA4 Admin → Custom Definitions after event names are standardized | Low (1 hour) |
| M4 | **Investigate `begin_checkout` and donation flow** | 8 `begin_checkout` events suggest a checkout/donation flow exists, but no `purchase` or completion event follows — possible cross-domain tracking gap | Confirm whether donations complete on unruledmasses.org or a third-party processor; if third-party, implement cross-domain tracking or server-side conversion pings | Medium–High (4–8 hours) |

### Low — Backlog

| # | What | Risk | Fix | Effort |
|---|---|---|---|---|
| L1 | **Link Google Ads** | Low priority unless paid campaigns are planned | GA4 Admin → Product Links → Google Ads Links | Low |
| L2 | **Set up audiences for remarketing** | No audiences configured | GA4 Admin → Audiences — create segments for engaged visitors, playbook viewers, etc. | Low (1 hour) |
| L3 | **Configure GA4 dashboard / custom reports** | Default GA4 interface is noisy for a small-traffic site | Explorations → create a simple overview report pinned to homepage | Low (1–2 hours) |

---

## Appendix: Key Numbers at a Glance

| Metric | Value |
|---|---|
| Total sessions (all time) | 126 |
| Total new users (all time) | 41 |
| Conversion rate | 0% (no conversions configured) |
| Direct traffic share | 76.2% |
| Top page | / (108 sessions, 6m 21s avg, 24.1% bounce) |
| Events with zero conversions | 15/15 |
| Distinct `/studio/` page paths tracked | 17+ |
| Property age at audit date | 23 days |
