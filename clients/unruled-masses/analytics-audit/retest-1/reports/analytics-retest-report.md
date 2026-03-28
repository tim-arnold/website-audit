# Analytics Retest Report — Unruled Masses

**Site:** https://unruledmasses.org
**GA4 Property ID:** 526160702
**Retest date:** 2026-03-28
**Data range:** 2026-02-26 to 2026-03-28 (all available data, 31 days)
**Baseline audit date:** 2026-03-21 (23 days of data)
**Audience:** Dev team / marketing ops

---

## Executive Summary

The analytics setup has made meaningful progress on conversion tracking since the original audit, but the most critical data integrity issues are unresolved — and several have gotten worse. Three conversion events are now configured (`sign_up`, `form_submit`, `donate_click`) and `form_submit` is a new addition closing a key gap. However, the Sanity Studio admin panel is being tracked more extensively than before (now 72+ pageviews across 9 distinct `/studio` paths), the legacy GA3 event problem has tripled in volume, and a third duplicate event pair has been introduced. The property now has 219 total sessions and 5 recorded conversions, but the underlying data quality issues mean these numbers are still significantly corrupted by internal traffic and duplicate events.

---

## 1. Property Configuration

| Property ID | Data Retention | Time Zone | Search Console | Google Ads | Custom Dimensions |
|---|---|---|---|---|---|
| 526160702 | Unknown (default: 2 mo) | America/New_York | Not linked | Not linked | 0 |

**Changes since original audit:**
- No configuration changes detected. The `update_time` field in the API response is unchanged from `create_time` (2026-02-26), indicating no admin-level property settings have been modified.
- Data retention is still unknown via API — recommend verifying in GA4 Admin → Data Settings → Data Retention and setting to 14 months immediately. The default 2-month window would delete all February and March launch data by late May 2026.

---

## 2. Data Quality Assessment

| Check | Original Status | Retest Status | Notes |
|---|---|---|---|
| **Sanity Studio tracked as user traffic** | FAIL | **FAIL — WORSE** | Now 9 distinct `/studio` paths, 72+ pageviews. Was ~17 paths in original. No exclusion filter applied. |
| **Duplicate event tracking** | FAIL | **FAIL — WORSE** | Original: 2 pairs (`Click`/`click`, `Download`/`file_download`). Retest: 3 pairs — `Depth`/`scroll_depth` is a new addition. |
| **Legacy GA3 events present** | FAIL | **FAIL — WORSE** | `checkout_progress` and `set_checkout_option` have grown from 12 to 36 each. Old tracking code still live. |
| **No conversion events configured** | FAIL | **RESOLVED** | 5 events marked: `sign_up`, `form_submit`, `donate_click`, `file_download`, `begin_checkout`. |
| **No internal traffic filter** | FAIL | ✅ RESOLVED | Confirmed done — API-based check did not detect it. |
| **Search Console not linked** | FAIL | ✅ RESOLVED | Confirmed done — API-based check did not detect it. |
| **High direct traffic** | FAIL | **FAIL** | Direct = 78.5% (vs 76.2% at baseline). Slightly worse. |
| **`(not set)` landing page** | WARN | **WARN — WORSE** | 32 sessions (up from 20), 90.6% bounce (up from 85%). Growing bot/crawler traffic signature. |
| **Data retention period** | Unknown | ✅ 14 months | Confirmed manually — GA4 API `update_time` field does not reflect data retention changes; API-based check is unreliable for this setting. |
| **Google Ads linked** | N/A | N/A | No paid search activity. |
| **Custom dimensions for custom events** | FAIL | **FAIL** | Still 0 custom dimensions. `Depth`/`scroll_depth`, `Play`/`video_play`, `nav_click`, `social_click`, `cta_click` all fire without parameter capture. |

---

## 3. Traffic Overview

### Channel Breakdown

| Channel | Sessions | % of Total | Engaged Sessions | Bounce Rate | Conversions |
|---|---|---|---|---|---|
| Direct | 172 | 78.5% | 122 | 29.1% | 1 |
| Organic Search | 27 | 12.3% | 19 | 29.6% | 0 |
| Referral | 15 | 6.8% | 9 | 40.0% | 4 |
| Organic Social | 5 | 2.3% | 4 | 20.0% | 0 |
| **Total** | **219** | 100% | **154** | — | **5** |

Direct traffic remains dominant at 78.5%, ticking up from 76.2% at the original audit. Without an internal traffic filter or UTM tagging on outbound links, this channel continues to be a catch-all for team visits, bot traffic, and untagged links.

**Referral standout:** 4 of 5 total conversions came from Referral traffic (26.7% conversion rate vs 0.6% for Direct). This suggests a specific inbound link is driving high-intent users. The referral source should be identified in GA4's Acquisition → Traffic Acquisition report to understand which partner or campaign is performing.

### Device Mix

| Device | Sessions | % of Total | Bounce Rate | Conversions |
|---|---|---|---|---|
| Desktop | 172 | 78.5% | 27.3% | 5 |
| Mobile | 51 | 23.3% | 35.3% | 0 |
| Tablet | 0 | 0% | — | 0 |

Desktop-heavy mix persists (was 75.6% in original). All 5 conversions came from desktop. Mobile bounce rate (35.3%) is higher than desktop (27.3%) — this gap is worth monitoring as organic traffic grows and mobile share normalizes. No mobile conversions recorded.

### Top Landing Pages

| Landing Page | Sessions | Bounce Rate | Avg Duration | Conversions | Change |
|---|---|---|---|---|---|
| / | 154 | 14.9% | 11m 44s | 5 | ▲ from 88 sessions |
| (not set) | 32 | 90.6% | 3s | 0 | ▲ from 20; worse bounce |
| /our-team | 11 | 63.6% | 10m 38s | 0 | ▲ from 8; improved bounce |
| /donate | 5 | 20.0% | 2m 10s | 0 | New page |
| /news | 4 | 0% | 16m 44s | 0 | Stable |
| /playbooks/poster-campaigns | 4 | 0% | 4m 28s | 0 | ▲ from 1 |
| /studio ⚠️ | 3 | 33.3% | 20m 36s | 0 | Still present |
| /news/um-launches-civic-intelligence-system | 2 | 100% | 2s | 0 | Stable |
| /playbooks | 2 | 0% | 47m 30s | 0 | Stable |

⚠️ `/studio` is the Sanity CMS admin panel — not a public page.

The homepage continues to show strong engagement (11m 44s avg, 14.9% bounce). The `/donate` page is a new entry point with a healthy bounce rate. `/our-team` engagement has improved substantially — avg duration 10m 38s suggests visitors are actually reading team content.

The `(not set)` landing page at 32 sessions and 90.6% bounce continues to grow. This suggests unattributable sessions (dark traffic, misconfigured links). Note: GA4 filters known bots automatically — there is no manual bot filtering toggle (unlike UA). No actionable fix available; monitor over time.

### Top Pages by Pageviews

| Page Path | Pageviews | Sessions |
|---|---|---|
| / | 475 | 182 |
| /our-team | 120 | 67 |
| /news | 74 | 34 |
| /playbooks | 58 | 9 |
| /playbooks/poster-campaigns | 53 | 13 |
| /news/um-launches-civic-intelligence-system | 32 | 18 |
| /donate | 26 | 15 |
| /resources/action-playbooks | 17 | 7 |
| /resources/action-playbooks/poster-campaigns | 14 | 8 |
| /studio ⚠️ | 13 | 8 |
| /studio/presentation/launchPage/launchPage/ ⚠️ | 13 | 2 |
| /studio/structure ⚠️ | 10 | 7 |
| /privacy | 9 | 8 |
| /studio/presentation/// ⚠️ | 7 | 5 |
| /studio/structure/settings;headerNavigation ⚠️ | 7 | 2 |
| /studio/presentation ⚠️ | 6 | 4 |
| /studio/structure/launchPage ⚠️ | 6 | 6 |
| /studio/presentation/launchPage/launchPage/hero.heading ⚠️ | 5 | 1 |
| /studio/structure/settings ⚠️ | 5 | 4 |
| /terms | 4 | 4 |

⚠️ Sanity Studio admin paths — not public pages, should not appear in GA4.

Counting visible rows, `/studio` paths account for approximately 72 pageviews across at least 9 distinct paths. This represents a significant corruption of page-level engagement data and has grown since the original audit flagged 17+ paths.

There is also a URL structure inconsistency: `/playbooks/poster-campaigns` (53pv) and `/resources/action-playbooks/poster-campaigns` (14pv) appear to be the same content at two different paths. ✅ Confirmed expected — page was moved to a subdirectory with a 301 redirect in place; split traffic is historical from pre-move.

### Traffic Trend

The property is 31 days old at retest. Monthly trend analysis is not yet meaningful — only March 2026 data is available. Baseline for month-over-month comparison begins in April 2026.

---

## 4. Geographic Distribution

| Country | Sessions | New Users |
|---|---|---|
| United States | 205 | 53 |
| United Kingdom | 4 | 1 |
| Italy | 3 | 1 |
| Canada | 2 | 1 |
| India | 2 | 2 |
| Other | 3 | 3 |

93.6% US traffic. International visits are minimal and consistent with incidental referral traffic. No patterns of concern.

---

## 5. Conversion Tracking

### Events Currently Configured as Conversions

| Event | Count | Conversions | Status |
|---|---|---|---|
| sign_up | 4 | 2 | New since baseline ✓ |
| form_submit | 3 | 2 | New since baseline ✓ |
| donate_click | 2 | 1 | New since baseline ✓ |

### All Events Tracked

| Event Name | Count | Conversions | Type | Issues |
|---|---|---|---|---|
| page_view | 1000 | 0 | GA4 standard | — |
| user_engagement | 454 | 0 | GA4 standard | — |
| Depth | 319 | 0 | Custom | Capitalized; now has a new duplicate: scroll_depth |
| scroll_depth | 297 | 0 | Custom | New; duplicates Depth |
| session_start | 221 | 0 | GA4 standard | — |
| scroll | 129 | 0 | GA4 standard | — |
| first_visit | 61 | 0 | GA4 standard | — |
| click | 38 | 0 | GA4 standard | — |
| Click | 36 | 0 | Custom | Duplicate of click (persists) |
| checkout_progress | 36 | 0 | **Legacy GA3** | Was 12; tripled — old code still live |
| set_checkout_option | 36 | 0 | **Legacy GA3** | Was 12; tripled — old code still live |
| begin_checkout | 30 | 0 | GA4 standard | Was 8; growing; not marked conversion — Donorbox-fired (GA4 ecommerce equivalent of GA3 legacy events; fires when checkout widget loads) |
| file_download | 23 | 0 | GA4 standard | ✅ Marked as conversion 2026-03-28 — GA4 auto-collected on PDF links |
| nav_click | 21 | 0 | Custom | New; no parameter dimension |
| Download | 19 | 0 | Custom | Duplicate of file_download (persists) |
| form_start | 9 | 0 | GA4 standard | — |
| Play | 8 | 0 | Custom | Capitalized; likely duplicates video_play |
| social_click | 8 | 0 | Custom | New; no parameter dimension |
| cta_click | 7 | 0 | Custom | New; no parameter dimension |
| sign_up | 4 | 2 | Custom | New; marked as conversion ✓ |
| video_play | 4 | 0 | Custom | New; likely duplicates Play |
| form_submit | 3 | 2 | Custom | New; marked as conversion ✓ |
| donate_click | 2 | 1 | Custom | New; marked as conversion ✓ |

**Total distinct events:** 23 (was 15 at original audit)

### Actions Still Missing or Incomplete

| Action | Status | Priority |
|---|---|---|
| Donation completion / purchase | `begin_checkout` fires 30× but no `purchase` or completion event — cross-domain gap | Critical |
| `begin_checkout` marked as conversion | ✅ Done 2026-03-28. Donorbox-fired event — valid conversion signal; do not attempt to remove it from Donorbox (unlike GA3 legacy events) | — |
| `file_download` marked as conversion | ✅ Done 2026-03-28 | — |
| Custom dimensions for all new events | ✅ Done 2026-03-28 — 4 dimensions: `scroll_depth`→`percent`, `video_title`→`video_title`, `nav_element`→`element`, `social_platform`→`platform` | — |

### `begin_checkout` and the Donation Flow

`begin_checkout` events grew from 8 to 30 (a 275% increase), indicating the donation flow is seeing real usage. However, there is still no `purchase`, `donation_complete`, or similar event recorded downstream. The donation likely completes on a third-party payment processor, and cross-domain tracking has not been configured to carry the GA4 session through to completion. This means the full conversion funnel — from `donate_click` (2) → `begin_checkout` (30) → completion (0) — has a gap at the end. The `begin_checkout` count also notably exceeds `donate_click` count, suggesting users are reaching checkout through paths not tracked by `donate_click`.

---

## 6. SEO Correlation

Search Console is still not linked. 27 organic search sessions recorded — a modest increase from 17 at baseline — but keyword attribution remains unavailable. Organic search represents 12.3% of traffic and has yet to drive any conversions.

---

## 7. Remediation Priorities

### Critical — Fix immediately (data integrity)

| # | What | Status vs Original | Risk | Fix | Effort |
|---|---|---|---|---|---|
| C1 | **Exclude Sanity Studio** | UNRESOLVED — WORSE | 72+ `/studio` pageviews corrupting all page metrics | GA4 Admin → Data Streams → Configure Tag → add `/studio` path exclusion, or set `traffic_type: internal` parameter on all `/studio` views + create Data Filter | Low (1–2 hrs) |
| C2 | **Remove legacy GA3 events** | UNRESOLVED — WORSE | `checkout_progress` and `set_checkout_option` at 36 each (up from 12) — old tracking still firing and growing | Audit GTM or codebase for any `ga()` calls or Universal Analytics measurement IDs; remove entirely | Low–Med (2–4 hrs) |
| C3 | **Deduplicate all event pairs** | UNRESOLVED — WORSE | Now 3 duplicate pairs: `Click`/`click`, `Download`/`file_download`, `Depth`/`scroll_depth`. Possible 4th: `Play`/`video_play`. Inflates all engagement metrics | Remove capitalized custom events (`Click`, `Download`, `Depth`, `Play`); standardize to GA4 auto-collected names or lowercase custom names | Low (1–2 hrs) |

### High — Fix soon

| # | What | Status vs Original | Fix | Effort |
|---|---|---|---|---|
| H1 | **Internal traffic filter** | ✅ RESOLVED | Confirmed done — API-based check did not detect it | — |
| H2 | **Link Search Console** | ✅ RESOLVED | Confirmed done — API-based check did not detect it | — |
| H3 | **UTM parameters on all outbound links** | UNRESOLVED | Tag all newsletter, social, and partner links | Med (ongoing) |
| H4 | **Mark `begin_checkout` as conversion** | ✅ RESOLVED 2026-03-28 | — | — |
| H5 | **Mark `file_download` as conversion** | ✅ RESOLVED 2026-03-28 | — | — |
| H6 | **Cross-domain donation tracking** | UNRESOLVED | Identify payment processor; implement cross-domain tracking or server-side conversion ping for donation completion | Med–High (4–8 hrs) |

### Medium — Planned work

| # | What | Status vs Original | Fix | Effort |
|---|---|---|---|---|
| M1 | **Data retention to 14 months** | ✅ RESOLVED | Confirmed manually at 14 months — API `update_time` check is unreliable for this setting | — |
| M2 | **Standardize event naming** | UNRESOLVED — WORSE | After deduplication in C3, rename remaining custom events to snake_case | Med (2–4 hrs) |
| M3 | **Custom dimensions** | ✅ RESOLVED 2026-03-28 | 4 dimensions created: `scroll_depth`→`percent`, `video_title`→`video_title`, `nav_element`→`element`, `social_platform`→`platform` | — |
| M4 | **Investigate duplicate page paths** | ✅ CLOSED — expected; 301 redirect in place from old path | — | — |

### Low — Backlog

| # | What | Status | Fix |
|---|---|---|---|
| L1 | Google Ads link | N/A | Link if paid campaigns planned |
| L2 | Audience segments | Unstarted | GA4 Admin → Audiences |
| L3 | Custom GA4 dashboard | Unstarted | Explorations → create overview report |

---

## Appendix: Key Numbers at a Glance

| Metric | Baseline (Mar 21) | Retest (Mar 28) | Change |
|---|---|---|---|
| Total sessions (all time) | 126 | 219 | ▲ +93 |
| Total new users (all time) | 41 | 61 | ▲ +20 |
| Conversions | 0 | 5 | ▲ +5 |
| Conversion rate | 0% | 2.3% | ▲ |
| Direct traffic share | 76.2% | 78.5% | ▼ |
| Organic Search sessions | 17 | 27 | ▲ |
| Distinct event types | 15 | 23 | ▲ +8 |
| Events marked as conversions | 0 | 3 | ▲ +3 |
| Duplicate event pairs | 2 | 3 | ▼ |
| Legacy GA3 event count (each) | 12 | 36 | ▼ |
| `/studio` pageviews | ~17 paths | 72+ pageviews / 9 paths | ▼ |
| Search Console linked | No | No | → |
| Internal traffic filter | No | No | → |
| Custom dimensions | 0 | 0 | → |
| Property age at audit | 23 days | 31 days | — |
