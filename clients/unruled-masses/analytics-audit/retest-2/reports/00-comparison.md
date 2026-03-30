# Analytics Retest Comparison — Unruled Masses

**Baseline audit:** 2026-03-21 (data: 2026-02-26 to 2026-03-20, 23 days)
**Retest 1:** 2026-03-28 (data: 2026-02-26 to 2026-03-28, 31 days)
**Retest 2:** 2026-03-28 (data: 2026-02-26 to 2026-03-28, 31 days — same date as Retest 1)
**Property:** GA4 / 526160702

---

## Executive Summary

- **Three items previously claimed as resolved are not confirmed by current API data.** Custom dimensions (0 returned), `begin_checkout` as a conversion event (0 conversions), and `file_download` as a conversion event (0 conversions) all fail API checks that are listed as reliable. These may be regressions or the Retest 1 claims were premature — either way, they require action.
- **Sanity Studio contamination has grown significantly.** The full page path query now surfaces 19+ distinct `/studio` paths accounting for 96+ pageviews. The prior retest's 9-path / 72-pageview figure was an undercount limited by query row limits. The underlying problem continues to grow.
- **All three critical data integrity issues remain completely unresolved.** Studio exclusion (C1), legacy GA3 event removal (C2), and event deduplication (C3) are identical to Retest 1 — no remediation applied.
- **Traffic is essentially flat.** Only +3 sessions since Retest 1 (both run on the same date, a few hours apart). No meaningful behavioral change to report.
- **The three core conversion events continue to function correctly.** `sign_up` (2 conversions), `form_submit` (2 conversions), and `donate_click` (1 conversion) are working as expected.

---

## Data Quality

### Issues Confirmed Resolved (Carried Forward)

| Issue | Status | Notes |
|---|---|---|
| Internal traffic filter | ✅ RESOLVED — carried forward | Confirmed in Retest 1; not re-verifiable via API. No evidence of regression (no internal IP clusters visible in session data). |
| Search Console linked | ✅ RESOLVED — carried forward | Confirmed in Retest 1; not re-verifiable via API. Organic search sessions present (28). |
| Data retention at 14 months | ✅ RESOLVED — carried forward | Confirmed manually in Retest 1; API `update_time` does not reflect retention changes. |
| `sign_up` / `form_submit` / `donate_click` as conversions | ✅ RESOLVED | API confirms: 2 + 2 + 1 = 5 total conversions recorded. |
| `form_submit` fires | ✅ RESOLVED | 3 events, 2 conversions. |

### Regressions (Previously Claimed Resolved — Now Failing)

| Issue | Retest 1 Claim | Retest 2 Status | Evidence |
|---|---|---|---|
| **Custom dimensions** | 4 created (`scroll_depth`→`percent`, `video_title`→`video_title`, `nav_element`→`element`, `social_platform`→`platform`) | **FAIL** | `get_custom_dimensions_and_metrics` returns 0 dimensions. API is listed as reliable for this check. |
| **`begin_checkout` as conversion** | Marked as conversion 2026-03-28 | **FAIL** | `begin_checkout` shows 30 fires / 0 conversions. Inconsistency between Retest 1 full report (claimed resolved) and 00-comparison (listed as not marked). |
| **`file_download` as conversion** | Marked as conversion 2026-03-28 | **FAIL** | `file_download` shows 23 fires / 0 conversions. Same inconsistency as above. |

### Issues Still Outstanding

| Issue | Baseline | Retest 1 | Retest 2 | Priority |
|---|---|---|---|---|
| Sanity Studio tracked as user traffic (C1) | FAIL | WORSE (9 paths / 72+ pv) | **WORSE** (19+ paths / 96+ pv) | Critical |
| Legacy GA3 events (C2) | FAIL | WORSE (36 each) | **STABLE** (36 each, unchanged) | Critical |
| Duplicate event tracking (C3) | FAIL (2 pairs) | WORSE (3 pairs) | **STABLE** (3 pairs + probable 4th) | Critical |
| High direct traffic / no UTM tagging (H3) | FAIL (76.2%) | FAIL (78.5%) | **STABLE** (78.4%) | High |
| Cross-domain donation tracking (H6) | FAIL | FAIL | **STABLE** (begin_checkout=30, purchase=0) | High |
| `(not set)` landing page growing | WARN (20 sessions) | WARN (32 sessions) | **STABLE** (32 sessions, unchanged) | Watch |

### New Issues

None introduced since Retest 1.

---

## Traffic Trends

### Sessions: Retest 1 → Retest 2

| Metric | Baseline (Mar 21) | Retest 1 (Mar 28) | Retest 2 (Mar 28) | Delta R1→R2 |
|---|---|---|---|---|
| Total sessions | 126 | 219 | 222 | ▲ +3 |
| New users | 41 | 61 | 62 | ▲ +1 |
| Conversions | 0 | 5 | 5 | → |
| Conversion rate | 0% | 2.3% | 2.3% | → |

Note: Retest 1 and Retest 2 were both run on 2026-03-28. The +3 session difference reflects activity in the hours between both runs. No meaningful behavioral change.

### Channel Mix

| Channel | Baseline | Retest 1 | Retest 2 | Delta R1→R2 |
|---|---|---|---|---|
| Direct | 76.2% (96) | 78.5% (172) | 78.4% (174) | → |
| Organic Search | 13.5% (17) | 12.3% (27) | 12.6% (28) | → |
| Referral | 7.9% (10) | 6.8% (15) | 6.8% (15) | → |
| Organic Social | 2.4% (3) | 2.3% (5) | 2.3% (5) | → |

No channel mix changes. Direct traffic still dominant and unreliable due to absent UTM coverage.

### Notable Landing Page Changes

No meaningful changes since Retest 1. Top pages and engagement metrics are stable.

### Conversion Rate Changes

No change. All 5 conversions recorded as of Retest 1 remain the only 5 conversions recorded.

---

## Conversion Tracking

### Active Conversion Events

| Event | Count | Conversions | Status |
|---|---|---|---|
| sign_up | 4 | 2 | ✅ Working |
| form_submit | 3 | 2 | ✅ Working |
| donate_click | 2 | 1 | ✅ Working |

### Events Not Marked (Regressions / Unresolved)

| Event | Count | Status |
|---|---|---|
| begin_checkout | 30 | ❌ Not marked — Retest 1 claimed resolved; API contradicts |
| file_download | 23 | ❌ Not marked — Retest 1 claimed resolved; API contradicts |
| purchase / donation_complete | 0 | ❌ Still no cross-domain completion event |

### Overall Conversion Volume

- **Retest 1:** 5 conversions (2 sign-ups, 2 form submissions, 1 donate click)
- **Retest 2:** 5 conversions — no change

---

## Comparison Table

| Metric | Baseline | Retest 1 | Retest 2 | Delta R1→R2 |
|---|---|---|---|---|
| Total sessions | 126 | 219 | 222 | ▲ +3 |
| New users | 41 | 61 | 62 | ▲ +1 |
| Conversions | 0 | 5 | 5 | → |
| Conversion rate | 0% | 2.3% | 2.3% | → |
| Direct traffic % | 76.2% | 78.5% | 78.4% | → |
| Organic Search sessions | 17 | 27 | 28 | ▲ +1 |
| Events marked as conversions | 0 | 3 | 3 | → |
| `/studio` paths / pageviews | ~17 paths (est.) | 9 paths / 72+pv (undercount) | 19+ paths / 96+pv | ▼ worse |
| Legacy GA3 event count (each) | 12 | 36 | 36 | → |
| Duplicate event pairs | 2 | 3 (+probable 4th) | 3 (+probable 4th) | → |
| Custom dimensions | 0 | 4 (claimed) | 0 (API) | ▼ regression |
| `begin_checkout` as conversion | No | Yes (claimed) | No (API) | ▼ regression |
| `file_download` as conversion | No | Yes (claimed) | No (API) | ▼ regression |
| Search Console linked | No | Yes ✓ | Yes ✓ (carried forward) | → |
| Internal traffic filter | No | Yes ✓ | Yes ✓ (carried forward) | → |
| Data retention 14 months | Unknown | Yes ✓ | Yes ✓ (carried forward) | → |
