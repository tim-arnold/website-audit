# NobleReach Foundation — Security Audit Raw Findings

**Audited:** 2026-03-23
**Site:** https://noblereach.org
**Local path:** `/Users/timarnold/Local Sites/noble-reach-foundation/app/public`
**Platform:** WordPress 6.9.1 on WPEngine, behind Cloudflare CDN

---

## 1. HTTP Response Headers

### Homepage (https://noblereach.org/) — HTTP/2 200

```
date: Mon, 23 Mar 2026 15:42:10 GMT
content-type: text/html; charset=UTF-8
cf-ray: 9e0e8b65397205b7-IAD
vary: Accept-Encoding, Cookie
link: <https://noblereach.org/wp-json/>; rel="https://api.w.org/"
link: <https://noblereach.org/wp-json/wp/v2/pages/9>; rel="alternate"
link: <https://noblereach.org/>; rel=shortlink
x-powered-by: WP Engine
x-cacheable: SHORT
cache-control: max-age=600, must-revalidate
x-cache: HIT: 1
x-cache-group: normal
last-modified: Mon, 23 Mar 2026 15:37:56 GMT
cf-cache-status: HIT
age: 235
server: cloudflare
```

### Interior page (https://noblereach.org/person/william-foster/) — HTTP/2 200

Same headers observed; same missing security headers.

### Security Headers Assessment

| Header | Status | Value / Notes |
|---|---|---|
| `Content-Security-Policy` | **Absent** | Not set |
| `X-Frame-Options` | **Absent** | Not set |
| `X-Content-Type-Options` | **Absent** | Not set |
| `Strict-Transport-Security` | **Absent** | Not set |
| `Referrer-Policy` | **Absent** | Not set |
| `Permissions-Policy` | **Absent** | Not set |
| `X-XSS-Protection` | **Absent** | Not set (deprecated, but absence worth noting) |

### Information Disclosure via Headers

| Header | Value | Issue |
|---|---|---|
| `x-powered-by` | `WP Engine` | Reveals hosting platform |
| `link` | `https://noblereach.org/wp-json/`; `wp/v2/pages/9` | Exposes WordPress REST API root and internal page ID on every page load |

---

## 2. Cookies

| Name | Secure | HttpOnly | SameSite | Notes |
|---|---|---|---|---|
| `__cf_bm` | Yes | Yes | None | Cloudflare Bot Management cookie — not directly configurable; `SameSite=None` is required for cross-site operation and is paired with `Secure=true` |

No WordPress session cookies set for unauthenticated requests (expected).

---

## 3. Third-Party Scripts

| Domain | Script | Notes |
|---|---|---|
| `fonts.googleapis.com` | Google Fonts CSS | Standard |
| `www.googletagmanager.com` | `gtag/js?id=G-2DDSGV3L6L` | GA4 — measurement ID in URL (public identifier, expected) |
| `www.bugherd.com` | `sidebarv2.js?apikey=3qbrqikhewhxejpgbacjiw` | **BugHerd dev tool loaded on production with API key in URL** |
| `sidebar.bugherd.com` | `embed.js?apikey=3qbrqikhewhxejpgbacjiw` | Same BugHerd key |
| `acdn.adnxs.com` | `pixie.js` | Xandr/AppNexus ad tracking pixel |
| `ib.adnxs.com` | Xandr pixel | Ad network |
| `js.hs-analytics.net` | HubSpot analytics | Portal ID `39514383` in script URL |
| `js-na1.hs-scripts.com` | HubSpot script loader | Same portal ID |
| `js.hs-banner.com` | HubSpot cookie banner | |
| `js.hscollectedforms.net` | HubSpot form collector | |
| `js.hsadspixel.net` | HubSpot ads pixel | |
| `snap.licdn.com` | LinkedIn Insight Tag | LinkedIn partner ID `6615809` visible |
| `px.ads.linkedin.com` | LinkedIn attribution pixel | |
| `noblereach.org/cdn-cgi/` | Cloudflare challenge scripts | Cloudflare-managed |

**Console errors observed:**
- BugHerd authentication failures: `[AUTH] Unauthenticated Error` — the API key is invalid or the account is inactive; the script loads but fails
- 404 on `noblereach-map.js` — script enqueued in production but file does not exist
- 404 on `/assets/temp/video-landscape1.jpg` — temp asset path referenced in production

---

## 4. WordPress Core

**File:** `wp-includes/version.php`

```php
$wp_version = '6.9.1';
$wp_db_version = 60717;
$required_php_version = '7.2.24';
$required_mysql_version = '5.5.5';
```

WordPress 6.9.1. Verify against current WordPress release at time of rebuild.

---

## 5. Plugins

**Directory:** `wp-content/plugins/`

| Plugin | Version | Notes |
|---|---|---|
| advanced-custom-fields-pro | 6.3.0.1 | Current |
| acf-extended | 0.9.0.4 | ACF Extended addon |
| acf-code-field | 1.8 | ACF addon |
| acf-content-analysis-for-yoast-seo | 3.1 | ACF + Yoast bridge |
| acf-gravityforms-add-on | 1.3.5 | ACF + Gravity Forms |
| gravityforms | 2.8.11 | Core Gravity Forms |
| gravityformshubspot | 2.1.0 | Gravity Forms HubSpot add-on |
| wordpress-seo | 22.7 | Yoast SEO |
| defender-security | 4.7.1 | WPMU Dev security plugin |
| redirection | 5.4.2 | Redirect manager |
| mapsvg | 8.6.11 | SVG map plugin |
| safe-svg | 2.2.4 | SVG sanitization |
| stream | 4.0.0 | Activity logging |
| wp-force-login | 5.6.3 | Forces login for all visitors |
| wp-migrate-db-pro | 2.6.12 | **DB migration/export tool — confirm deactivated on production** |
| better-search-replace | 1.4.10 | DB search/replace — confirm deactivated on production |
| classic-editor | 1.6.3 | |
| custom-taxonomy-order-ne | 4.0.0 | |
| duplicate-post | 4.5 | |
| ajax-thumbnail-rebuild | 1.14 | Utility |
| bugherd | Empty directory | No files — BugHerd loaded via hardcoded theme script |
| dummybot-master | Empty directory | No files |
| editoria11y-accessibility-checker | Empty directory | No files |
| enable-media-replace | Empty directory | No files |
| query-monitor | Empty directory | No files — dev tool stub |
| relevanssi | Empty directory | No files |

---

## 6. Themes

| Directory | Status |
|---|---|
| `noblereach-2024` | Active theme |
| `noblereach` | Inactive legacy theme — should be removed |

---

## 7. wp-config.php Review (local development copy)

Note: This is the **local development config**. `WP_ENVIRONMENT_TYPE = 'local'` and database credentials (`root`/`root` against `localhost`) confirm this is not the production config. The production wp-config.php on WP Engine cannot be reviewed from the local copy.

| Setting | Value | Notes |
|---|---|---|
| `WP_DEBUG` | `false` (conditional) | Correct |
| `WP_DEBUG_LOG` | Not set | Good |
| `WP_DEBUG_DISPLAY` | Not set | Good |
| `WP_ENVIRONMENT_TYPE` | `'local'` | Dev only |
| `$table_prefix` | `wp_` | **Default prefix — flag for production** |
| Auth keys/salts | All 8 defined with unique values | Good |
| `DISALLOW_FILE_EDIT` | **Not defined** | **Flag — file editor left enabled** |
| DB credentials | `root`/`root`/`localhost` | Dev only; verify production credentials are not default |

---

## 8. Sensitive File Exposure

| File | Present | Risk |
|---|---|---|
| `/.env` | No | Good |
| `/wp-config-sample.php` | **Yes** | Low — no real credentials; confirms WordPress in use |
| `/readme.html` | **Yes** | Medium — exposes WordPress version |
| `/license.txt` | Yes | Low |
| `/local-xdebuginfo.php` | **Yes (local only)** | High if on production — reveals PHP config. **Verify absent on WP Engine.** |
| `/xmlrpc.php` | **Yes** | Medium — known WordPress attack vector |

---

## 9. Active Theme — Security Findings

### inc/events.php — Critical Issues

**Hardcoded Google Maps API Key**

```php
// inc/events.php, line ~509
$api_key = 'AIzaSyBUA49bqSbSgj0ukEpU1v6e9uhXv8dsPpc';
wp_enqueue_script('google-places-api', "https://maps.googleapis.com/maps/api/js?key=$api_key&libraries=places", ...);
```

Key is hardcoded in PHP source and exposed in the browser (passed in the script URL). Risk depends on Google Cloud Console restrictions for this key — if referrer restrictions are absent or overly permissive, the key can be used from any domain.

**Unparameterized SQL Query — Potential SQL Injection**

```php
// inc/events.php, lines ~483–503
function tm_get_nearby_cities($lat, $long, $distance) {
    global $wpdb;
    $nearbyCities = $wpdb->get_results(
        "SELECT DISTINCT ...
         ((ACOS(SIN($lat * PI() / 180) ...)) * 60 * 1.1515) AS distance
         HAVING distance < $distance
         ORDER BY distance ASC;"
    );
```

`$lat`, `$long`, and `$distance` are interpolated directly into a raw SQL string without `$wpdb->prepare()`. If these values derive from user input without sanitization upstream, this is a SQL injection vulnerability. WordPress coding standards require `$wpdb->prepare()` for all queries with variable data.

### inc/lockdown.php — Positive Findings

- Removes admin menus for non-super-admins — appropriate hardening
- Disables Customizer, Options pages, and WP-CLI for non-super-admins
- REST API restricted to authenticated users only via `tm_forcelogin_rest_access`

### functions.php

- `disable_php_warnings()` suppresses `E_WARNING` globally — silences legitimate warnings that could signal security issues
- No `defined('ABSPATH') or exit` guard at top of `functions.php` (not strictly required but a WordPress best practice)

---

## 10. xmlrpc.php

Present at `/xmlrpc.php`. Default WordPress state. Known attack vectors:
- Brute-force amplification via `system.multicall` (test hundreds of credentials in one request)
- DDoS amplification via `pingback.ping`

Defender Security (v4.7.1) is installed and capable of disabling XML-RPC. Confirm this is configured in the production environment.
