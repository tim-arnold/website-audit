# Analytics Retest Report — Unruled Masses (Retest 2)

**Site:** https://unruledmasses.org
**GA4 Property ID:** 526160702
**Retest date:** 2026-03-28
**Data range:** 2026-02-26 to 2026-03-28 (all available data, 31 days)
**Baseline audit date:** 2026-03-21 (23 days of data)
**Retest 1 date:** 2026-03-28 (same day as this retest, run earlier)
**Audience:** Dev team / marketing ops

---

## Executive Summary

The analytics setup is largely unchanged from Retest 1. Three conversion events continue to function correctly (`sign_up`, `form_submit`, `donate_click`), and three items confirmed in Retest 1 via non-API means carry forward as resolved (internal traffic filter, Search Console link, data retention). However, this retest found that three items Retest 1 claimed as resolved do not hold up against current API data: custom dimensions (API now shows 0), `begin_checkout` as a conversion event (0 conversions), and `file_download` as a conversion event (0 conversions). These are either regressions or the prior claims were premature. All three critical data integrity issues — Sanity Studio contamination, legacy GA3 events, and duplicate event pairs — remain completely unresolved and the Studio path contamination continues to grow.

---

## 1. Property Configuration

| Property ID | Data Retention | Time Zone | Search Console | Google Ads | Custom Dimensions |
|---|---|---|---|---|---|
| 526160702 | Unknown (API-unreliable) | America/New_York | Carried forward ✓ | Not linked | **0 (regression)** |

**Changes since Retest 1:**
- `update_time` still equals `create_time` (`2026-02-26T17:40:29.195Z`) — the API `update_time` field does not reflect admin setting changes. No admin-level property changes are detectable via this field.
- **Custom dimensions:** `get_custom_dimensions_and_metrics` returns 0 dimensions. Retest 1 claimed 4 were created (`scroll_depth`→`percent`, `video_title`→`video_title`, `nav_element`→`element`, `social_platform`→`platform`). The custom dimensions API is reliable. Either the dimensions were deleted after Retest 1, or the prior report's claim was inaccurate. Action required.
- **Data retention:** Confirmed at 14 months in Retest 1 via manual verification. Carried forward — API `update_time` does not reflect data retention changes.
- **Search Console:** Confirmed linked in Retest 1 via manual verification; not re-verifiable via `get_property_details`. Organic search sessions (28) are present, consistent with an active Search Console link.

---

## 2. Data Quality Assessment

| Check | Original Status | Retest 1 Status | Retest 2 Status | Notes |
|---|---|---|---|---|
| **Sanity Studio tracked as user traffic** | FAIL | FAIL — WORSE | **FAIL — WORSE** | Now 19+ distinct `/studio` paths, 96+ pageviews. Prior 9-path/72-pv figure was a query undercount. |
| **Duplicate event tracking** | FAIL | FAIL — WORSE | **FAIL — STABLE** | 3 confirmed pairs: `Click`/`click`, `Download`/`file_download`, `Depth`/`scroll_depth`. Probable 4th: `Play`/`video_play`. No change since Retest 1. |
| **Legacy GA3 events present** | FAIL | FAIL — WORSE | **FAIL — STABLE** | `checkout_progress` and `set_checkout_option` at 36 each — unchanged from Retest 1. Old tracking code still live. |
| **No conversion events configured** | FAIL | RESOLVED | ✅ **RESOLVED** | `sign_up` (2 conversions), `form_submit` (2 conversions), `donate_click` (1 conversion) confirmed active. |
| **`begin_checkout` marked as conversion** | FAIL | RESOLVED (claimed) | **FAIL — REGRESSION** | `begin_checkout` shows 0 conversions. Retest 1 claimed this was marked; API does not confirm. |
| **`file_download` marked as conversion** | FAIL | RESOLVED (claimed) | **FAIL — REGRESSION** | `file_download` shows 0 conversions. Same issue as above. |
| **No internal traffic filter** | FAIL | ✅ RESOLVED | ✅ **RESOLVED — carried forward** | Confirmed Retest 1 — not re-verifiable via API. No evidence of regression. |
| **Search Console not linked** | FAIL | ✅ RESOLVED | ✅ **RESOLVED — carried forward** | Confirmed Retest 1 — not re-verifiable via API. Organic sessions present. |
| **High direct traffic / no UTM coverage** | FAIL | FAIL | **FAIL — STABLE** | Direct = 78.4% (was 78.5%). No improvement. |
| **`(not set)` landing page** | WARN | WARN — WORSE | **WARN — STABLE** | 32 sessions, 90.6% bounce — unchanged. |
| **Data retention period** | Unknown | ✅ RESOLVED | ✅ **RESOLVED — carried forward** | 14 months confirmed manually in Retest 1; not re-verifiable via API. |
| **Custom dimensions** | FAIL | RESOLVED (claimed) | **FAIL — REGRESSION** | `get_custom_dimensions_and_metrics` returns 0. Reliable API check. |
| **Google Ads linked** | N/A | N/A | **N/A** | No paid search activity. |

---

## 3. Traffic Overview

### Channel Breakdown

| Channel | Sessions | % of Total | Engaged Sessions | Bounce Rate | Conversions | New Users |
|---|---|---|---|---|---|---|
| Direct | 174 | 78.4% | 122 | 29.9% | 1 | 42 |
| Organic Search | 28 | 12.6% | 19 | 32.1% | 0 | 12 |
| Referral | 15 | 6.8% | 9 | 40.0% | 4 | 5 |
| Organic Social | 5 | 2.3% | 4 | 20.0% | 0 | 3 |
| **Total** | **222** | 100% | **154** | — | **5** | **62** |

Direct traffic is unchanged at 78.4% (was 78.5% in Retest 1). The channel mix continues to be unreliable as a performance signal without UTM tagging on outbound links and with confirmed studio admin sessions inflating Direct.

Referral continues to deliver all meaningful conversions: 4 of 5 total conversions (26.7% conversion rate) from 15 referral sessions. The specific referral source has not been identified in prior retests — identifying it in GA4's Acquisition → Traffic Acquisition report remains a high-value, low-effort task.

### Device Mix

| Device | Sessions | Bounce Rate | Conversions |
|---|---|---|---|
| Desktop | 173 | 27.7% | 5 |
| Mobile | 53 | 37.7% | 0 |
| Tablet | 0 | — | 0 |

Desktop-dominant (76.5%), consistent with prior audits. All 5 conversions from desktop. Mobile bounce rate (37.7%) is higher than desktop (27.7%) and has worsened since Retest 1 (was 35.3%). No mobile conversions recorded across the property's full lifetime.

### Top Landing Pages

| Landing Page | Sessions | Bounce Rate | Avg Duration | Conversions | vs. Retest 1 |
|---|---|---|---|---|---|
| / | 156 | 16.0% | 11m 34s | 5 | → stable |
| (not set) | 32 | 90.6% | 3s | 0 | → stable |
| /our-team | 12 | 66.7% | 9m 45s | 0 | ▲ +1 session |
| /donate | 5 | 20.0% | 2m 9s | 0 | → stable |
| /news | 4 | 0% | 16m 44s | 0 | → stable |
| /playbooks/poster-campaigns | 4 | 0% | 4m 28s | 0 | → stable |
| /studio ⚠️ | 3 | 33.3% | 20m 36s | 0 | → stable |
| /news/um-launches-civic-intelligence-system | 2 | 100% | 2s | 0 | → stable |
| /playbooks | 2 | 0% | 47m 30s | 0 | → stable |

⚠️ `/studio` is the Sanity CMS admin panel.

Homepage continues to show strong engagement (11m 34s avg, 16.0% bounce). No meaningful landing page changes since Retest 1.

### Top Pages by Pageviews

| Page Path | Pageviews | Sessions | Notes |
|---|---|---|---|
| / | 477 | 184 | |
| /our-team | 121 | 68 | |
| /news | 74 | 34 | |
| /playbooks | 58 | 9 | |
| /playbooks/poster-campaigns | 53 | 13 | |
| /news/um-launches-civic-intelligence-system | 32 | 18 | |
| /donate | 26 | 15 | |
| /resources/action-playbooks | 17 | 7 | |
| /resources/action-playbooks/poster-campaigns | 14 | 8 | |
| /studio ⚠️ | 13 | 8 | |
| /studio/presentation/launchPage/launchPage/ ⚠️ | 13 | 2 | |
| /studio/structure ⚠️ | 10 | 7 | |
| /privacy | 9 | 8 | |
| /studio/presentation/// ⚠️ | 7 | 5 | |
| /studio/structure/settings;headerNavigation ⚠️ | 7 | 2 | |
| /studio/presentation ⚠️ | 6 | 4 | |
| /studio/structure/launchPage ⚠️ | 6 | 6 | |
| /studio/presentation/launchPage/launchPage/hero.heading ⚠️ | 5 | 1 | |
| /studio/structure/settings ⚠️ | 5 | 4 | |
| /terms | 4 | 4 | |
| *(9 more `/studio` sub-paths, 2–3pv each)* ⚠️ | ~22 | ~9 | |

⚠️ Sanity Studio admin paths. Query returned 50 distinct page paths (top 30 shown). At minimum 19 distinct `/studio` paths and 96 studio pageviews are visible. Actual count is higher — the total row_count is 50 and not all studio paths are captured in the displayed results.

**URL structure note:** `/playbooks/poster-campaigns` (53pv) and `/resources/action-playbooks/poster-campaigns` (14pv) are the same content at two paths. Confirmed in Retest 1 as expected — page was moved to a subdirectory with a 301 redirect; split traffic is historical.

### Traffic Trend

Property is 31 days old at this retest. Month-over-month analysis is not meaningful — only March 2026 data exists (222 sessions, 62 new users, 5 conversions). Baseline for MoM comparison begins in April 2026.

---

## 4. Geographic Distribution

| Country | Sessions | New Users |
|---|---|---|
| United States | 208 | 54 |
| United Kingdom | 4 | 1 |
| Italy | 3 | 1 |
| Canada | 2 | 1 |
| India | 2 | 2 |
| Argentina | 1 | 1 |
| South Africa | 1 | 1 |
| (not set) | 1 | 1 |

93.7% US traffic. Two new countries (Argentina, South Africa) since Retest 1 — consistent with incidental referral or social traffic. No patterns of concern.

---

## 5. Conversion Tracking

### Events Currently Configured as Conversions

| Event | Count | Conversions | Status |
|---|---|---|---|
| sign_up | 4 | 2 | ✅ Active — confirmed via API |
| form_submit | 3 | 2 | ✅ Active — confirmed via API |
| donate_click | 2 | 1 | ✅ Active — confirmed via API |

### All Events Tracked

| Event Name | Count | Conversions | Type | Issues |
|---|---|---|---|---|
| page_view | 1003 | 0 | GA4 standard | — |
| user_engagement | 455 | 0 | GA4 standard | — |
| Depth | 319 | 0 | Custom — capitalized | Duplicate of scroll_depth (UNRESOLVED) |
| scroll_depth | 297 | 0 | Custom | Duplicate of Depth (UNRESOLVED) |
| session_start | 224 | 0 | GA4 standard | — |
| scroll | 129 | 0 | GA4 standard | — |
| first_visit | 62 | 0 | GA4 standard | — |
| click | 38 | 0 | GA4 standard | — |
| Click | 36 | 0 | Custom — capitalized | Duplicate of click (UNRESOLVED) |
| checkout_progress | 36 | 0 | **Legacy GA3** | Old tracking code still live (UNRESOLVED) |
| set_checkout_option | 36 | 0 | **Legacy GA3** | Old tracking code still live (UNRESOLVED) |
| begin_checkout | 30 | 0 | GA4 standard | Not marked as conversion — REGRESSION |
| file_download | 23 | 0 | GA4 standard | Not marked as conversion — REGRESSION |
| nav_click | 21 | 0 | Custom | No custom dimension (REGRESSION — claimed resolved) |
| Download | 19 | 0 | Custom — capitalized | Duplicate of file_download (UNRESOLVED) |
| form_start | 9 | 0 | GA4 standard | — |
| Play | 8 | 0 | Custom — capitalized | Probable duplicate of video_play |
| social_click | 8 | 0 | Custom | No custom dimension (REGRESSION — claimed resolved) |
| cta_click | 7 | 0 | Custom | No custom dimension |
| sign_up | 4 | 2 | Custom | ✅ Conversion |
| video_play | 4 | 0 | Custom | Probable duplicate of Play |
| form_submit | 3 | 2 | Custom | ✅ Conversion |
| donate_click | 2 | 1 | Custom | ✅ Conversion |

**Total distinct events:** 23 (unchanged from Retest 1)

### Donation Flow Gap

`begin_checkout` at 30 fires (unchanged from Retest 1) with 0 completion events (`purchase`, `donation_complete`, or equivalent). The donation flow continues to terminate on a third-party payment processor without cross-domain session tracking. The funnel remains broken at the end: `donate_click` (2) → `begin_checkout` (30) → completion (0). The `begin_checkout` count exceeding `donate_click` by 15× confirms users reach checkout via paths other than `donate_click` (e.g., direct navigation to `/donate`).

---

## 6. SEO Correlation

> Confirmed resolved in Retest 1 (2026-03-28) — not re-verifiable via API. No evidence of regression detected.

28 organic search sessions recorded (up from 27 in Retest 1 — minimal growth). Keyword attribution is unavailable in the Data API regardless of Search Console link status. Organic search represents 12.6% of traffic and has not driven any conversions to date.

---

## 7. Remediation Priorities

### Critical — Fix immediately (data integrity)

| # | What | Status | Risk | Fix | Effort |
|---|---|---|---|---|---|
| C1 | **Exclude Sanity Studio from tracking** | UNRESOLVED — WORSE | 19+ `/studio` paths, 96+ pageviews corrupting all page-level metrics | GA4 Admin → Data Streams → Configure Tag → add path exclusion for `/studio`; or set `traffic_type: internal` on all studio views and create a Data Filter | Low (1–2 hrs) |
| C2 | **Remove legacy GA3 events** | UNRESOLVED — STABLE | `checkout_progress` and `set_checkout_option` at 36 each — old UA tracking code still live | Audit GTM containers and codebase for any `ga()`, `gtag()` calls using Universal Analytics measurement IDs; remove entirely | Low–Med (2–4 hrs) |
| C3 | **Deduplicate all event pairs** | UNRESOLVED — STABLE | 3 confirmed pairs: `Click`/`click`, `Download`/`file_download`, `Depth`/`scroll_depth`; probable 4th: `Play`/`video_play`. All inflate engagement metrics | Remove capitalized custom events (`Click`, `Download`, `Depth`, `Play`); standardize to GA4 auto-collected or lowercase custom names | Low (1–2 hrs) |

### High — Fix soon

| # | What | Status | Fix | Effort |
|---|---|---|---|---|
| H1 | **Internal traffic filter** | ✅ RESOLVED — confirmed Retest 1, carried forward | — | — |
| H2 | **Link Search Console** | ✅ RESOLVED — confirmed Retest 1, carried forward | — | — |
| H3 | **UTM parameters on all outbound links** | UNRESOLVED | Tag all newsletter, social, and partner links with UTM params | Med (ongoing) |
| H4 | **Mark `begin_checkout` as conversion** | REGRESSION — was claimed resolved in Retest 1 | GA4 Admin → Events → Mark `begin_checkout` as conversion | Low (15 min) |
| H5 | **Mark `file_download` as conversion** | REGRESSION — was claimed resolved in Retest 1 | GA4 Admin → Events → Mark `file_download` as conversion | Low (15 min) |
| H6 | **Cross-domain donation tracking** | UNRESOLVED | Identify payment processor domain; implement cross-domain measurement or server-side conversion ping for donation completion | Med–High (4–8 hrs) |

### Medium — Planned work

| # | What | Status | Fix | Effort |
|---|---|---|---|---|
| M1 | **Data retention at 14 months** | ✅ RESOLVED — confirmed Retest 1, carried forward | — | — |
| M2 | **Standardize event naming (snake_case)** | UNRESOLVED | After C3 deduplication, rename remaining custom events to snake_case | Med (2–4 hrs) |
| M3 | **Custom dimensions for custom events** | REGRESSION — was claimed resolved in Retest 1 | Re-create in GA4 Admin → Custom Definitions: `scroll_depth`→`percent`, `video_title`→`video_title`, `nav_element`→`element`, `social_platform`→`platform` | Low (30 min) |
| M4 | **Duplicate page paths** | ✅ CLOSED — 301 redirect confirmed in Retest 1 | — | — |

### Low — Backlog

| # | What | Status | Fix |
|---|---|---|---|
| L1 | Google Ads link | N/A | Link if paid campaigns planned |
| L2 | Audience segments | Unstarted | GA4 Admin → Audiences |
| L3 | Custom GA4 dashboard | Unstarted | Explorations → create overview report |

---

## Appendix: Key Numbers at a Glance

| Metric | Baseline (Mar 21) | Retest 1 (Mar 28) | Retest 2 (Mar 28) | R1→R2 Change |
|---|---|---|---|---|
| Total sessions (all time) | 126 | 219 | 222 | ▲ +3 |
| Total new users (all time) | 41 | 61 | 62 | ▲ +1 |
| Conversions | 0 | 5 | 5 | → |
| Conversion rate | 0% | 2.3% | 2.3% | → |
| Direct traffic share | 76.2% | 78.5% | 78.4% | → |
| Organic Search sessions | 17 | 27 | 28 | ▲ +1 |
| Distinct event types | 15 | 23 | 23 | → |
| Events marked as conversions | 0 | 3 (API confirmed) | 3 (API confirmed) | → |
| `begin_checkout` as conversion | No | Claimed yes | **No (API)** | ▼ regression |
| `file_download` as conversion | No | Claimed yes | **No (API)** | ▼ regression |
| Duplicate event pairs | 2 | 3 + probable 4th | 3 + probable 4th | → |
| Legacy GA3 event count (each) | 12 | 36 | 36 | → |
| `/studio` paths / pageviews | ~17 (est.) | 9 paths / 72+pv | **19+ paths / 96+pv** | ▼ worse |
| Custom dimensions | 0 | 4 (claimed) | **0 (API)** | ▼ regression |
| Search Console linked | No | Yes ✓ | Yes ✓ (carried forward) | → |
| Internal traffic filter | No | Yes ✓ | Yes ✓ (carried forward) | → |
| Data retention 14 months | Unknown | Yes ✓ | Yes ✓ (carried forward) | → |
| Property age at audit | 23 days | 31 days | 31 days | — |
