# Analytics Raw Data — Unruled Masses

**Property:** Unruled Masses (526160702)
**Collected:** 2026-03-21
**Date range (most reports):** Last 12 months (365daysAgo–yesterday)
**Note:** Property was created 2026-02-26. All data covers only ~3.5 weeks (Feb 26–Mar 20, 2026).

---

## A. Property Metadata

```
name:             properties/526160702
display_name:     Unruled Masses
account:          accounts/385695679
create_time:      2026-02-26T17:40:29.195Z
industry_category: PEOPLE_AND_SOCIETY
time_zone:        America/New_York
currency_code:    USD
service_level:    GOOGLE_ANALYTICS_STANDARD
property_type:    PROPERTY_TYPE_ORDINARY
```

**Custom dimensions:** None configured
**Custom metrics:** None configured
**Google Ads links:** None
**Property annotations:** None
**Search Console link:** Not present in property metadata response (no linked service returned)
**Data retention:** Not returned by API — assumed default (2 months for standard properties)

---

## B. Traffic by Channel (Last 12 Months / actual: ~3.5 weeks)

| Channel | Sessions | Engaged Sessions | Bounce Rate | Conversions |
|---|---|---|---|---|
| Direct | 96 | 67 | 30.2% | 0 |
| Organic Search | 17 | 12 | 29.4% | 0 |
| Referral | 10 | 5 | 50.0% | 0 |
| Organic Social | 3 | 3 | 0% | 0 |
| **Total** | **126** | **87** | — | **0** |

Direct = 76.2% of all sessions.

---

## C. Top Landing Pages (Last 12 Months / actual: ~3.5 weeks)

| Landing Page | Sessions | Bounce Rate | Avg Session Duration | Conversions |
|---|---|---|---|---|
| / | 88 | 15.9% | 9m 30s | 0 |
| (not set) | 20 | 85.0% | 4s | 0 |
| /our-team | 8 | 75.0% | 38s | 0 |
| /news | 4 | 0% | 16m 44s | 0 |
| /studio | 2 | 0% | 30m 51s | 0 |
| /news/um-launches-civic-intelligence-system | 1 | 100% | 4s | 0 |
| /playbooks | 1 | 0% | 2m 44s | 0 |
| /playbooks/poster-campaigns | 1 | 0% | 1m 5s | 0 |
| /privacy | 1 | 100% | 4s | 0 |

**Note:** `/studio` appearing as a landing page indicates the Sanity CMS admin panel is being tracked as public traffic.

---

## D. Device Breakdown

| Device | Sessions | Bounce Rate | Conversions |
|---|---|---|---|
| Desktop | 96 | 28.1% | 0 |
| Mobile | 31 | 38.7% | 0 |
| Tablet | 0 | — | — |

Desktop = 75.6% of sessions. No tablet traffic recorded.

---

## E. Monthly Traffic Trend (Last 24 Months)

Only one month of data exists — property was created 2026-02-26.

| Month | Sessions | New Users |
|---|---|---|
| 202603 (Mar 2026) | 126 | 41 |

---

## F. Top Exit Pages

`exitRate` is not a valid GA4 metric in the Data API. Skipped. Bounce rate by page path used as proxy (see Section I).

---

## G. Events — All (Last 12 Months / actual: ~3.5 weeks)

| Event Name | Event Count | Conversions | Notes |
|---|---|---|---|
| page_view | 484 | 0 | Standard GA4 auto-event |
| Depth | 313 | 0 | Custom event — capitalized (naming inconsistency) |
| user_engagement | 199 | 0 | Standard GA4 auto-event |
| session_start | 127 | 0 | Standard GA4 auto-event |
| scroll | 64 | 0 | Standard GA4 auto-event |
| first_visit | 41 | 0 | Standard GA4 auto-event |
| Click | 36 | 0 | Custom event — capitalized; duplicates `click` |
| click | 26 | 0 | Standard GA4 auto-event (outbound clicks) |
| file_download | 23 | 0 | Standard GA4 auto-event |
| Download | 19 | 0 | Custom event — capitalized; duplicates `file_download` |
| checkout_progress | 12 | 0 | **Legacy GA3 ecommerce event — should not appear in GA4** |
| set_checkout_option | 12 | 0 | **Legacy GA3 ecommerce event — should not appear in GA4** |
| Play | 8 | 0 | Custom event — capitalized |
| begin_checkout | 8 | 0 | GA4 ecommerce event — not marked as conversion |
| form_start | 5 | 0 | Standard GA4 auto-event |

**Total events with conversion = true: 0**

**Duplicate event pairs detected:**
- `Click` (36) + `click` (26) = 62 total click events — likely double-firing
- `Download` (19) + `file_download` (23) = 42 total download events — likely double-firing

**Legacy GA3 events detected:** `checkout_progress`, `set_checkout_option` — these are GA Universal Analytics (GA3) ecommerce events that should not fire in a GA4 property. Indicates old tracking code is still active.

---

## H. Geographic Distribution (Top Countries)

| Country | Sessions | Conversions |
|---|---|---|
| United States | 117 | 0 |
| Italy | 3 | 0 |
| United Kingdom | 2 | 0 |
| (not set) | 1 | 0 |
| Argentina | 1 | 0 |
| India | 1 | 0 |
| South Africa | 1 | 0 |

US = 92.9% of sessions.

---

## I. Page-Level Engagement (Top 30 by Sessions)

| Page Path | Sessions | Avg Duration | Bounce Rate | Conversions |
|---|---|---|---|---|
| / | 108 | 6m 21s | 24.1% | 0 |
| /our-team | 45 | 2m 25s | 24.4% | 0 |
| /news | 15 | 3m 42s | 0% | 0 |
| /studio | 7 | 5m 2s | 0% | 0 |
| /studio/structure | 7 | 0s | 0% | 0 |
| /news/um-launches-civic-intelligence-system | 6 | 58s | 16.7% | 0 |
| /studio/structure/launchPage | 6 | 26s | 0% | 0 |
| /studio/presentation/// | 5 | 23s | 0% | 0 |
| /playbooks | 4 | 6m 27s | 0% | 0 |
| /playbooks/poster-campaigns | 4 | 3m 56s | 0% | 0 |
| /studio/presentation | 4 | 20s | 0% | 0 |
| /studio/structure/settings | 4 | 3m 17s | 0% | 0 |
| /privacy | 3 | 3s | 33.3% | 0 |
| /studio/presentation/launchPage/launchPage/ | 2 | 1m 50s | 0% | 0 |
| /studio/structure/settings;headerNavigation | 2 | 4m 4s | 0% | 0 |
| /studio/structure/teamMember | 2 | 48s | 0% | 0 |
| /studio/structure/teamMember;f211eed7-... | 2 | 34s | 0% | 0 |
| /our-team/studio | 1 | 6s | 0% | 0 |
| /studio/intent/edit/... | 1 | 6s | 0% | 0 |
| /studio/presentation/ | 1 | 16s | 0% | 0 |
| /studio/presentation/headerNavigation/... | 1 | 1m 32s | 0% | 0 |
| /studio/presentation/launchPage/.../text | 1 | 5s | 0% | 0 |
| ... (additional /studio/presentation/ deep paths) | — | — | — | — |

**Critical finding:** `/studio/` and all sub-paths are the Sanity CMS admin interface. GA4 tracking is firing inside the admin panel, polluting real user data with internal editorial sessions. These are not public users.

---

## J. Data Quality Assessment

| Check | Status | Evidence |
|---|---|---|
| Duplicate tracking | **FAIL** | `Click`/`click` and `Download`/`file_download` both fire for same actions |
| Sanity Studio tracked as user traffic | **FAIL** | `/studio/` paths appear throughout page and landing page data |
| Internal traffic not excluded | **FAIL** | No data filter in property; high direct % consistent with developer/internal visits |
| Legacy GA3 events present | **FAIL** | `checkout_progress` and `set_checkout_option` should not exist in GA4 |
| No conversions configured | **FAIL** | 0 conversions marked across all 15 event types |
| Search Console linked | **FAIL** | Not linked |
| Google Ads linked | **N/A** | Not linked; no indication client runs paid search |
| Custom dimensions/metrics | **FAIL** | None configured despite `Depth`, `Click`, `Download`, `Play` custom events firing |
| Data retention setting | **Unknown** | Not returned by API; default for Standard = 2 months |
| UTM/direct traffic inflation | **FAIL** | Direct = 76.2% — extremely high for a new site, consistent with untagged links and self-visits |
| Bot/spam traffic | **Possible** | 20 `(not set)` landing page sessions with 85% bounce |
