# Analytics Retest 2 — Raw Data
**Site:** https://unruledmasses.org
**GA4 Property ID:** 526160702
**Retest date:** 2026-03-28
**Data range:** 2026-02-26 to 2026-03-28 (all available data, 31 days)
**Prior retest:** Retest 1 — 2026-03-28 (same day, earlier run)

---

## Carry-Forward Table

Items from Retest 1, assessed for continued validity before data collection.

| Issue | Last Known Status | Source | Re-verifiable via API? | Carry-Forward Decision |
|---|---|---|---|---|
| Internal traffic filter | ✅ RESOLVED (Retest 1) | Confirmed — not API-detectable | No | Carry forward unless evidence of regression |
| Search Console linked | ✅ RESOLVED (Retest 1) | Confirmed — not API-detectable | No | Carry forward unless evidence of regression |
| Data retention 14 months | ✅ RESOLVED (Retest 1) | Manual confirmation — API unreliable | No | Carry forward |
| `sign_up` / `form_submit` / `donate_click` as conversions | ✅ RESOLVED (Retest 1) | API — conversion counts confirmed | Yes | Re-verify |
| `form_submit` fires | ✅ RESOLVED (Retest 1) | API — event present | Yes | Re-verify |
| Custom dimensions (4 claimed) | ✅ RESOLVED (Retest 1 — claimed) | Claimed in report; not confirmed by API data in that run | Yes — API reliable | Re-verify |
| `begin_checkout` marked as conversion | ✅ RESOLVED (Retest 1 — claimed) | Claimed in full report; but 00-comparison listed it as NOT marked | Yes — API reliable | Re-verify |
| `file_download` marked as conversion | ✅ RESOLVED (Retest 1 — claimed) | Claimed in full report; but 00-comparison listed it as NOT marked | Yes — API reliable | Re-verify |
| Sanity Studio tracked as user traffic (C1) | FAIL — WORSE (Retest 1) | API confirmed | Yes | Re-verify |
| Legacy GA3 events (C2) | FAIL — WORSE (Retest 1) | API confirmed | Yes | Re-verify |
| Duplicate event tracking (C3) | FAIL — WORSE (Retest 1) | API confirmed | Yes | Re-verify |
| High direct traffic / UTM coverage (H3) | FAIL (Retest 1) | API confirmed | Yes | Re-verify |
| Cross-domain donation tracking (H6) | FAIL (Retest 1) | API confirmed | Yes | Re-verify |

---

## 1. Property Details

Source: `get_property_details`

```json
{
  "name": "properties/526160702",
  "create_time": "2026-02-26T17:40:29.195Z",
  "update_time": "2026-02-26T17:40:29.195Z",
  "display_name": "Unruled Masses",
  "industry_category": "PEOPLE_AND_SOCIETY",
  "time_zone": "America/New_York",
  "currency_code": "USD",
  "service_level": "GOOGLE_ANALYTICS_STANDARD",
  "property_type": "PROPERTY_TYPE_ORDINARY"
}
```

Note: `update_time` still equals `create_time` — no admin-level property changes detectable via API since launch. This includes data retention, linked services, and other admin settings. As noted in prior audits, this field does not update when data retention is changed.

---

## 2. Custom Dimensions and Metrics

Source: `get_custom_dimensions_and_metrics`

```json
{
  "custom_dimensions": [],
  "custom_metrics": []
}
```

**Finding:** API returns 0 custom dimensions. Retest 1 claimed 4 custom dimensions were created (`scroll_depth`→`percent`, `video_title`→`video_title`, `nav_element`→`element`, `social_platform`→`platform`). The `get_custom_dimensions_and_metrics` endpoint is listed as API-reliable in this audit's methodology. Zero dimensions returned = evidence of regression or that the prior claim was incorrect.

---

## 3. Traffic by Channel

Source: `run_report` — sessions by `sessionDefaultChannelGroup`, 2026-02-26 to 2026-03-28

| Channel | Sessions | Engaged Sessions | Bounce Rate | Conversions | New Users |
|---|---|---|---|---|---|
| Direct | 174 | 122 | 29.9% | 1 | 42 |
| Organic Search | 28 | 19 | 32.1% | 0 | 12 |
| Referral | 15 | 9 | 40.0% | 4 | 5 |
| Organic Social | 5 | 4 | 20.0% | 0 | 3 |
| **Total** | **222** | **154** | — | **5** | **62** |

---

## 4. Top Landing Pages

Source: `run_report` — `landingPage` dimension, 2026-02-26 to 2026-03-28

| Landing Page | Sessions | Bounce Rate | Avg Duration | Conversions |
|---|---|---|---|---|
| / | 156 | 16.0% | 11m 34s | 5 |
| (not set) | 32 | 90.6% | 3s | 0 |
| /our-team | 12 | 66.7% | 9m 45s | 0 |
| /donate | 5 | 20.0% | 2m 9s | 0 |
| /news | 4 | 0% | 16m 44s | 0 |
| /playbooks/poster-campaigns | 4 | 0% | 4m 28s | 0 |
| /studio ⚠️ | 3 | 33.3% | 20m 36s | 0 |
| /news/um-launches-civic-intelligence-system | 2 | 100% | 2s | 0 |
| /playbooks | 2 | 0% | 47m 30s | 0 |
| /privacy | 1 | 100% | 4s | 0 |
| /resources/action-playbooks/poster-campaigns | 1 | 100% | 0s | 0 |

⚠️ Sanity CMS admin path — not a public page.

---

## 5. Top Pages by Pageviews

Source: `run_report` — `pagePath` dimension, 2026-02-26 to 2026-03-28, limit 30, row_count 50

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
| /studio/presentation/launchPage/launchPage/donate.disclaimerLong ⚠️ | 3 | 1 | |
| /studio/presentation/launchPage/launchPage/solution.featuresList[0] ⚠️ | 3 | 1 | |
| /studio/presentation/launchPage/launchPage/solution.featuresList[3] ⚠️ | 3 | 1 | |
| /studio/presentation/launchPage/launchPage/trust.cards[_key=="cd5858496f14"].description ⚠️ | 3 | 1 | |
| /studio/presentation/launchPage/launchPage/donate.disclaimerShort ⚠️ | 2 | 1 | |
| /studio/presentation/launchPage/launchPage/hero.description ⚠️ | 2 | 1 | |
| /studio/presentation/launchPage/launchPage/solution.featureCards ⚠️ | 2 | 1 | |
| /studio/presentation/launchPage/launchPage/solution.featuresList[2] ⚠️ | 2 | 1 | |
| /studio/presentation/launchPage/launchPage/trust.cards:cd5858496f14.title ⚠️ | 2 | 1 | |
| /studio/presentation/launchPage/launchPage/trust.cards[_key=="cd5858496f14"].title ⚠️ | 2 | 1 | |

⚠️ Sanity Studio admin paths. row_count = 50, so at least 20 more paths not shown.

Studio paths visible in top 30 results: 19 distinct paths
Studio pageviews (visible): 13+13+10+7+7+6+6+5+5+3+3+3+3+2+2+2+2+2+2 = **96 pageviews**

---

## 6. Device Breakdown

Source: `run_report` — `deviceCategory`, 2026-02-26 to 2026-03-28

| Device | Sessions | Bounce Rate | Conversions |
|---|---|---|---|
| Desktop | 173 | 27.7% | 5 |
| Mobile | 53 | 37.7% | 0 |
| Tablet | 0 | — | 0 |
| **Total** | **226** | — | **5** |

Note: Device total (226) slightly exceeds channel total (222) — normal due to cross-device attribution.

---

## 7. Monthly Traffic Trend

Source: `run_report` — `yearMonth`, 2026-02-26 to 2026-03-28

| Month | Sessions | New Users | Conversions |
|---|---|---|---|
| March 2026 | 222 | 62 | 5 |

Only one month of data exists. February 2026 had 0 sessions (property created Feb 26, all traffic attributed to March). Month-over-month trending not yet possible.

---

## 8. All Events

Source: `run_report` — `eventName`, 2026-02-26 to 2026-03-28

| Event Name | Count | Conversions | Type | Notes |
|---|---|---|---|---|
| page_view | 1003 | 0 | GA4 standard | |
| user_engagement | 455 | 0 | GA4 standard | |
| Depth | 319 | 0 | Custom — capitalized | Duplicate of scroll_depth |
| scroll_depth | 297 | 0 | Custom | Duplicate of Depth |
| session_start | 224 | 0 | GA4 standard | |
| scroll | 129 | 0 | GA4 standard | |
| first_visit | 62 | 0 | GA4 standard | |
| click | 38 | 0 | GA4 standard | |
| Click | 36 | 0 | Custom — capitalized | Duplicate of click |
| checkout_progress | 36 | 0 | **Legacy GA3** | Unchanged from Retest 1 |
| set_checkout_option | 36 | 0 | **Legacy GA3** | Unchanged from Retest 1 |
| begin_checkout | 30 | 0 | GA4 standard | Not marked as conversion (Retest 1 claimed it was) |
| file_download | 23 | 0 | GA4 standard | Not marked as conversion (Retest 1 claimed it was) |
| nav_click | 21 | 0 | Custom | No custom dimension capturing parameter |
| Download | 19 | 0 | Custom — capitalized | Duplicate of file_download |
| form_start | 9 | 0 | GA4 standard | |
| Play | 8 | 0 | Custom — capitalized | Probable duplicate of video_play |
| social_click | 8 | 0 | Custom | No custom dimension capturing parameter |
| cta_click | 7 | 0 | Custom | No custom dimension capturing parameter |
| sign_up | 4 | 2 | Custom | ✅ Marked as conversion |
| video_play | 4 | 0 | Custom | Probable duplicate of Play |
| form_submit | 3 | 2 | Custom | ✅ Marked as conversion |
| donate_click | 2 | 1 | Custom | ✅ Marked as conversion |

**Distinct events:** 23 (unchanged from Retest 1)
**Events marked as conversions:** 3 (`sign_up`, `form_submit`, `donate_click`)

**Regression note:** Retest 1 claimed `begin_checkout` and `file_download` were marked as conversions on 2026-03-28. Both currently show 0 conversions — they are not marked. This is either a regression or the prior claim was incorrect.

---

## 9. Geographic Distribution

Source: `run_report` — `country`, 2026-02-26 to 2026-03-28

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
| **Total** | **222** | **62** |

US share: 93.7% (208/222).

---

## Data Quality Assessment

| Check | Prior Status (Retest 1) | Retest 2 Status | Evidence | API Reliable? |
|---|---|---|---|---|
| Sanity Studio tracked as user traffic | FAIL — WORSE | **FAIL — WORSE** | Now 19+ distinct `/studio` paths, 96+ pageviews (up from 9/72+) | Yes |
| Duplicate event tracking | FAIL — WORSE | **FAIL — STABLE** | Same 3 pairs: `Click`/`click`, `Download`/`file_download`, `Depth`/`scroll_depth`; `Play`/`video_play` probable 4th | Yes |
| Legacy GA3 events | FAIL — WORSE | **FAIL — STABLE** | `checkout_progress` and `set_checkout_option` at 36 each — unchanged from Retest 1 | Yes |
| Internal traffic filter | ✅ RESOLVED | ✅ **RESOLVED — carried forward** | Not re-verifiable via API; no evidence of regression | No |
| Search Console linked | ✅ RESOLVED | ✅ **RESOLVED — carried forward** | Not re-verifiable via API; organic sessions present | No |
| Data retention 14 months | ✅ RESOLVED | ✅ **RESOLVED — carried forward** | Not re-verifiable via API | No |
| Conversion events (sign_up, form_submit, donate_click) | ✅ RESOLVED | ✅ **RESOLVED** | API confirms 2+2+1 conversions | Yes |
| begin_checkout marked as conversion | ✅ RESOLVED (claimed) | **FAIL — REGRESSION** | API shows 0 conversions on begin_checkout; Retest 1 claim appears to have been premature or the change was reverted | Yes |
| file_download marked as conversion | ✅ RESOLVED (claimed) | **FAIL — REGRESSION** | API shows 0 conversions on file_download; same issue as above | Yes |
| Custom dimensions | ✅ RESOLVED (claimed, 4 created) | **FAIL — REGRESSION** | API returns 0 custom dimensions; prior claim appears to have been premature or dimensions were deleted | Yes |
| High direct traffic / UTM coverage | FAIL | **FAIL — STABLE** | Direct 78.4% (was 78.5%) — essentially unchanged | Yes |
| Cross-domain donation tracking | FAIL | **FAIL — STABLE** | begin_checkout at 30, purchase/completion at 0 | Yes |
| `(not set)` landing page | WARN | **WARN — STABLE** | 32 sessions, 90.6% bounce — unchanged from Retest 1 | Yes |
