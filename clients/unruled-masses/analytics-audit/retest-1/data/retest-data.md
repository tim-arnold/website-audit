# Analytics Retest Raw Data — Unruled Masses

**Retest date:** 2026-03-28
**GA4 Property ID:** 526160702
**Data range (all-time):** 2026-02-26 to 2026-03-28
**Baseline period (same window as original audit):** 2026-02-26 to 2026-03-20

---

## Property Details

```json
{
  "name": "properties/526160702",
  "parent": "accounts/385695679",
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

**Notes:**
- `update_time` unchanged from `create_time` — no admin configuration changes recorded via API
- No annotations configured

---

## Custom Dimensions & Metrics

```json
{
  "custom_dimensions": [],
  "custom_metrics": []
}
```

**Status:** No change. Still zero custom dimensions and zero custom metrics.

---

## Linked Services

- **Google Ads links:** None
- **Search Console:** Not detectable via Data API (confirmed absent in original audit)

---

## Baseline Period Confirmation (2026-02-26 to 2026-03-20)

Re-running the original audit's date window to confirm data integrity.

| Channel | Sessions | Engaged | Bounce Rate | Conversions |
|---|---|---|---|---|
| Direct | 96 | 67 | 30.2% | 0 |
| Organic Search | 17 | 12 | 29.4% | 0 |
| Referral | 10 | 5 | 50.0% | 0 |
| Organic Social | 3 | 3 | 0% | 0 |
| **Total** | **126** | **87** | — | **0** |

Matches original audit exactly — data integrity confirmed.

---

## Traffic by Channel — All Time (2026-02-26 to 2026-03-28)

| Channel | Sessions | Engaged | Bounce Rate | Conversions |
|---|---|---|---|---|
| Direct | 172 | 122 | 29.1% | 1 |
| Organic Search | 27 | 19 | 29.6% | 0 |
| Referral | 15 | 9 | 40.0% | 4 |
| Organic Social | 5 | 4 | 20.0% | 0 |
| **Total** | **219** | **154** | — | **5** |

---

## Monthly Traffic Trend (last 24 months, 2024-03-28 to 2026-03-28)

| Year-Month | Sessions | New Users | Conversions |
|---|---|---|---|
| 202603 | 219 | 61 | 5 |

Note: Only one month of data returned. Sessions from 2026-02-26 (launch) through 2026-02-28 appear to have been collapsed into March, or February data was below reporting thresholds. Property age: 31 days at retest.

---

## Top Landing Pages — All Time (2026-02-26 to 2026-03-28)

| Landing Page | Sessions | Bounce Rate | Avg Duration | Conversions |
|---|---|---|---|---|
| / | 154 | 14.9% | 703s (11m 44s) | 5 |
| (not set) | 32 | 90.6% | 3s | 0 |
| /our-team | 11 | 63.6% | 638s (10m 38s) | 0 |
| /donate | 5 | 20.0% | 130s (2m 10s) | 0 |
| /news | 4 | 0% | 1004s (16m 44s) | 0 |
| /playbooks/poster-campaigns | 4 | 0% | 268s (4m 28s) | 0 |
| /studio ⚠️ | 3 | 33.3% | 1236s (20m 36s) | 0 |
| /news/um-launches-civic-intelligence-system | 2 | 100% | 2s | 0 |
| /playbooks | 2 | 0% | 2850s (47m 30s) | 0 |
| /privacy | 1 | 100% | 4s | 0 |
| /resources/action-playbooks/poster-campaigns | 1 | 100% | 0s | 0 |

---

## Top Pages by Pageviews — All Time

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

⚠️ Sanity Studio paths — not public pages.

---

## Device Breakdown — All Time

| Device | Sessions | Bounce Rate | Conversions |
|---|---|---|---|
| Desktop | 172 | 27.3% | 5 |
| Mobile | 51 | 35.3% | 0 |
| Tablet | 0 | — | 0 |

---

## Geographic Distribution — All Time

| Country | Sessions | New Users |
|---|---|---|
| United States | 205 | 53 |
| United Kingdom | 4 | 1 |
| Italy | 3 | 1 |
| Canada | 2 | 1 |
| India | 2 | 2 |
| (not set) | 1 | 1 |
| Argentina | 1 | 1 |
| South Africa | 1 | 1 |

---

## Events — All Time (2026-02-26 to 2026-03-28)

| Event Name | Count | Conversions | Type | Issues |
|---|---|---|---|---|
| page_view | 1000 | 0 | GA4 standard | — |
| user_engagement | 454 | 0 | GA4 standard | — |
| Depth | 319 | 0 | Custom | Capitalized; duplicates scroll_depth |
| scroll_depth | 297 | 0 | Custom | Lowercase duplicate of Depth |
| session_start | 221 | 0 | GA4 standard | — |
| scroll | 129 | 0 | GA4 standard | — |
| first_visit | 61 | 0 | GA4 standard | — |
| click | 38 | 0 | GA4 standard | — |
| Click | 36 | 0 | Custom | Capitalized duplicate of click |
| checkout_progress | 36 | 0 | **Legacy GA3** | Was 12 at original audit — growing |
| set_checkout_option | 36 | 0 | **Legacy GA3** | Was 12 at original audit — growing |
| begin_checkout | 30 | 0 | GA4 standard | Was 8; not marked as conversion |
| file_download | 23 | 0 | GA4 standard | Not marked as conversion |
| nav_click | 21 | 0 | Custom | New since original audit |
| Download | 19 | 0 | Custom | Capitalized duplicate of file_download |
| form_start | 9 | 0 | GA4 standard | — |
| Play | 8 | 0 | Custom | Capitalized; possible duplicate of video_play |
| social_click | 8 | 0 | Custom | New since original audit |
| cta_click | 7 | 0 | Custom | New since original audit |
| sign_up | 4 | 2 | Custom | New; marked as conversion ✓ |
| video_play | 4 | 0 | Custom | New; possible duplicate of Play |
| form_submit | 3 | 2 | Custom | New; marked as conversion ✓ |
| donate_click | 2 | 1 | Custom | New; marked as conversion ✓ |

**Total distinct events:** 23 (was 15)
**Events marked as conversions:** 3 (sign_up, form_submit, donate_click)
**Total conversions recorded:** 5
