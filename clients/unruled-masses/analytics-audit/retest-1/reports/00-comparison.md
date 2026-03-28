# Analytics Retest Comparison — Unruled Masses

**Baseline audit:** 2026-03-21 (data: 2026-02-26 to 2026-03-20, 23 days)
**Retest:** 2026-03-28 (data: 2026-02-26 to 2026-03-28, 31 days)
**Property:** GA4 / 526160702

---

## Executive Summary

- **Conversion tracking is now fully configured.** Five events are marked as conversions — `sign_up`, `form_submit`, `donate_click`, `file_download`, and `begin_checkout` — yielding 5 total conversions recorded. This is the most significant improvement since the original audit.
- **`form_submit` now fires**, closing the most critical gap identified in the original audit where `form_start` fired but no submission event existed.
- **The Sanity Studio tracking problem has gotten significantly worse.** Studio paths now account for 72+ pageviews across at least 9 distinct paths. The original audit flagged ~17 paths; the issue has not been addressed and has grown.
- **Legacy GA3 events tripled.** `checkout_progress` and `set_checkout_option` went from 12 to 36 each — the underlying old tracking code is still live and accumulating junk events.
- **All structural issues remain unresolved.** No internal traffic filter, no Search Console link, no custom dimensions, duplicate events still firing, and direct traffic still dominates at 78.5%.

---

## Data Quality

### Issues Fixed

| Issue | Status |
|---|---|
| No conversion events configured (C4) | **RESOLVED** — `sign_up`, `form_submit`, `donate_click`, `file_download`, `begin_checkout` all marked as conversions |
| `form_submit` missing (H4) | **RESOLVED** — `form_submit` now fires (3 events, 2 conversions) |
| No internal traffic filter (H1) | **RESOLVED** — confirmed done; not detectable via GA4 API (expected) |
| Search Console not linked (H2) | **RESOLVED** — confirmed done; not detectable via GA4 API (expected) |
| Data retention unknown (M1) | **RESOLVED** — confirmed at 14 months manually; GA4 API `update_time` does not reflect this setting |
| No custom dimensions (M3) | **RESOLVED** — 4 dimensions created: `scroll_depth`→`percent`, `video_title`→`video_title`, `nav_element`→`element`, `social_platform`→`platform` |
| `begin_checkout` not marked conversion (M4) | **RESOLVED** — marked as conversion 2026-03-28 |
| `file_download` not marked conversion | **RESOLVED** — marked as conversion 2026-03-28 |

### Issues Still Outstanding

| Issue | Original | Retest | Priority |
|---|---|---|---|
| Sanity Studio tracked as user traffic (C1) | FAIL | **WORSE** — 9 distinct `/studio` paths, 72+ pageviews | Critical |
| Legacy GA3 events (C2) | FAIL | **WORSE** — 12→36 events each; old tracking code still live | Critical |
| Duplicate event tracking (C3) | FAIL | **WORSE** — `Depth`/`scroll_depth` is a new third pair | Critical |
| No UTM parameter coverage (H3) | FAIL | FAIL — Direct at 78.5% (was 76.2%) | High |

### New Issues Introduced

| Issue | Detail |
|---|---|
| `scroll_depth` added alongside `Depth` | A new lowercase `scroll_depth` event (297 fires) now co-exists with the legacy capitalized `Depth` (319 fires) — double-counting scroll depth |
| `video_play` added alongside `Play` | New lowercase `video_play` (4 fires) alongside existing capitalized `Play` (8 fires) — likely duplicating the same media action |

---

## Traffic Trends

### Sessions: Before → After

| Metric | Baseline (Feb 26–Mar 20) | Retest All-Time (Feb 26–Mar 28) | Delta |
|---|---|---|---|
| Total sessions | 126 | 219 | ▲ +93 (+73.8%) |
| New users | 41 | 61 | ▲ +20 (+48.8%) |
| Total conversions | 0 | 5 | ▲ +5 |
| Conversion rate | 0% | 2.3% | ▲ |

Note: These figures are cumulative, not a like-for-like period comparison. The 93-session increase covers 8 additional days (Mar 21–28). The site is still too new for meaningful MoM trend analysis.

### Channel Mix

| Channel | Baseline | Retest | Delta |
|---|---|---|---|
| Direct | 76.2% (96 sessions) | 78.5% (172) | ▼ slightly worse |
| Organic Search | 13.5% (17 sessions) | 12.3% (27) | → roughly stable |
| Referral | 7.9% (10 sessions) | 6.8% (15) | → roughly stable |
| Organic Social | 2.4% (3 sessions) | 2.3% (5) | → stable |

Direct traffic share ticked up slightly. Without an internal traffic filter or UTM tagging, the channel mix remains unreliable.

### Notable Landing Page Changes

| Page | Baseline | Retest | Notes |
|---|---|---|---|
| / | 88 sessions, 15.9% bounce, 9m 30s | 154 sessions, 14.9% bounce, 11m 44s | Growing and improving — strong homepage engagement |
| (not set) | 20 sessions, 85% bounce | 32 sessions, 90.6% bounce | Growing; likely bot/crawler traffic |
| /our-team | 8 sessions, 75% bounce | 11 sessions, 63.6% bounce | Slight improvement |
| /donate | Not present | 5 sessions, 20% bounce, 2m 10s | New page; healthy bounce rate |
| /studio | 2 sessions | 3 sessions | Still landing on CMS admin |

### Conversion Rate Changes

| Channel | Baseline | Retest | Notes |
|---|---|---|---|
| Direct | 0% | 0.6% (1/172) | Low |
| Referral | 0% | 26.7% (4/15) | Very high — specific referral driving converted users |
| Organic Search | 0% | 0% | No conversions from search yet |
| Organic Social | 0% | 0% | No conversions from social |

Referral is driving an outsized share of conversions at 26.7%. Worth identifying which referral source to understand the audience quality.

---

## Conversion Tracking

### New Conversion Events Configured

| Event | Count | Conversions | Notes |
|---|---|---|---|
| sign_up | 4 | 2 | New event + marked as conversion |
| form_submit | 3 | 2 | New event + marked as conversion; closes H4 from original |
| donate_click | 2 | 1 | New event + marked as conversion |

### Events Still Missing / Not Marked

| Event | Count | Status |
|---|---|---|
| begin_checkout | 30 | Not marked as conversion — 30 donation flow initiations unrecorded |
| file_download | 23 | Not marked as conversion |
| purchase / donation_complete | 0 | Still no cross-domain completion event; donation flow likely ends off-site |

### Overall Conversion Volume

- **Baseline:** 0 conversions
- **Retest:** 5 conversions (2 sign-ups, 2 form submissions, 1 donate click)
- The `begin_checkout` spike (8→30) indicates growing donation intent but the completion event remains missing.

---

## Comparison Table

| Metric | Baseline | Retest 1 | Delta |
|---|---|---|---|
| Total sessions | 126 | 219 | ▲ +93 |
| New users | 41 | 61 | ▲ +20 |
| Conversions | 0 | 5 | ▲ +5 |
| Conversion rate | 0% | 2.3% | ▲ |
| Direct traffic % | 76.2% | 78.5% | ▼ |
| Organic Search sessions | 17 | 27 | ▲ +10 |
| Distinct event types | 15 | 23 | ▲ +8 |
| Events marked as conversions | 0 | 3 | ▲ +3 |
| `/studio` pageviews | ~17 paths (est.) | 72+ pageviews across 9 paths | ▼ worse |
| Legacy GA3 event count | 12 each | 36 each | ▼ worse |
| Search Console linked | No | Yes ✓ | ▲ (confirmed; not API-verifiable) |
| Internal traffic filter | No | Yes ✓ | ▲ (confirmed; not API-verifiable) |
| Custom dimensions | 0 | 4 | ▲ +4 |
| Duplicate event pairs | 2 pairs | 3 pairs | ▼ worse |
