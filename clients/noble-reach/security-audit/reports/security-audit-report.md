# Security Audit Report — NobleReach Foundation

**Date:** 2026-03-23
**Site:** https://noblereach.org
**Platform:** WordPress 6.9.1 on WPEngine, behind Cloudflare CDN
**Scope:** Passive audit — live site headers + local WordPress filesystem. No active probing or exploitation.

---

## Executive Summary

- **A SQL injection vulnerability exists in the active theme.** `tm_get_nearby_cities()` in `inc/events.php` interpolates `$lat`, `$long`, and `$distance` directly into a raw `$wpdb->get_results()` query without `$wpdb->prepare()`. If any of these values reach the function from user input without upstream sanitization, the database is exploitable.
- **A Google Maps API key is hardcoded in the theme source** (`inc/events.php`) and exposed in the browser. If the key lacks referrer restrictions in the Google Cloud Console, it can be used from any domain to rack up API charges.
- **BugHerd, a bug-reporting dev tool, is actively loaded on production** with its API key embedded in the script URL. The key appears to be expired or invalid (authentication errors in console), but the script still loads and the key is publicly visible.
- **No HTTP security headers are set.** CSP, X-Frame-Options, X-Content-Type-Options, HSTS, and Referrer-Policy are all absent. This is addressable at the Cloudflare or WPEngine level without touching the WordPress codebase.
- **`DISALLOW_FILE_EDIT` is not set** in wp-config — the WordPress admin panel's theme/plugin file editor is enabled. Any admin-level account compromise allows direct server-side code execution.
- **`xmlrpc.php` is present and accessible.** Defender Security is installed; confirm it is configured to block XML-RPC in the production environment.
- **`readme.html` is publicly accessible**, exposing the WordPress version. The production WPEngine server should also be checked to confirm `local-xdebuginfo.php` (a Local by Flywheel dev tool present in the local copy) is absent there.

---

## 1. Platform Configuration

| Attribute | Value |
|---|---|
| WordPress version | 6.9.1 |
| Hosting | WPEngine |
| CDN / WAF | Cloudflare |
| Active theme | `noblereach-2024` |
| Security plugin | Defender Security 4.7.1 |
| Force login | `wp-force-login` + custom `tm_forcelogin` in theme — all pages require authentication |
| REST API | Restricted to authenticated users |
| `$table_prefix` | `wp_` (default) |
| `DISALLOW_FILE_EDIT` | Not set (file editor enabled) |

---

## 2. Security Headers

All headers assessed from live site response.

| Header | Status | Risk | Fix |
|---|---|---|---|
| `Content-Security-Policy` | **Absent** | Medium | Configure in Cloudflare Transform Rules or WPEngine nginx config |
| `X-Frame-Options` | **Absent** | Medium | Set `SAMEORIGIN` in Cloudflare or WPEngine |
| `X-Content-Type-Options` | **Absent** | Medium | Set `nosniff` in Cloudflare or WPEngine |
| `Strict-Transport-Security` | **Absent** | Medium | Set with `max-age=31536000; includeSubDomains` |
| `Referrer-Policy` | **Absent** | Low | Set `strict-origin-when-cross-origin` |
| `Permissions-Policy` | **Absent** | Low | Restrict camera/mic/geolocation as appropriate |

**All six headers can be added via Cloudflare Transform Rules (recommended) or WPEngine's nginx configuration** — no WordPress code changes needed. This is the highest-leverage fix in the audit: one configuration change closes six findings simultaneously.

**Information disclosure via headers:**
- `x-powered-by: WP Engine` — reveals hosting platform on every response
- `link` headers — expose the WordPress REST API root (`/wp-json/`) and internal page IDs on every page load (standard WordPress behavior, but worth noting for the rebuild)

---

## 3. Cookies

| Cookie | Secure | HttpOnly | SameSite | Assessment |
|---|---|---|---|---|
| `__cf_bm` | Yes | Yes | None | Cloudflare Bot Management — not configurable; `SameSite=None` is required by its function and paired with `Secure=true` |

No WordPress session cookies are exposed to unauthenticated visitors (expected, given force-login is active).

The rebuilt site should ensure any new session or auth cookies are set with `Secure`, `HttpOnly`, and `SameSite=Lax` or `Strict`.

---

## 4. Vulnerability Findings

### 4a. SQL Injection — `tm_get_nearby_cities()` (High)

**File:** `wp-content/themes/noblereach-2024/inc/events.php`, lines ~483–503

```php
function tm_get_nearby_cities($lat, $long, $distance) {
    global $wpdb;
    $nearbyCities = $wpdb->get_results(
        "SELECT DISTINCT ...
         ((ACOS(SIN($lat * PI() / 180) ...)) * 60 * 1.1515) AS distance
         HAVING distance < $distance
         ORDER BY distance ASC;"
    );
```

`$lat`, `$long`, and `$distance` are interpolated directly into a raw SQL string. WordPress's `$wpdb->prepare()` is not used. If these values are derived from `$_GET`, `$_POST`, or any other user-controlled input without sanitization upstream, this is exploitable.

**Fix:** Rewrite using `$wpdb->prepare()`:
```php
$nearbyCities = $wpdb->get_results(
    $wpdb->prepare(
        "SELECT DISTINCT ... ((...SIN(%f * PI() / 180)...) * 60 * 1.1515) AS distance
         HAVING distance < %f ORDER BY distance ASC;",
        $lat, $lat, $long, $distance
    )
);
```
Audit all callers of `tm_get_nearby_cities()` to confirm whether `$lat`, `$long`, `$distance` are user-controlled or only set from trusted internal values.

### 4b. Hardcoded Google Maps API Key (High)

**File:** `wp-content/themes/noblereach-2024/inc/events.php`, line ~509

```php
$api_key = 'AIzaSyBUA49bqSbSgj0ukEpU1v6e9uhXv8dsPpc';
wp_enqueue_script('google-places-api', "https://maps.googleapis.com/maps/api/js?key=$api_key&libraries=places", ...);
```

The key is also transmitted in the browser — any visitor can extract it from page source or DevTools. Risk is bounded by what Google Cloud Console restrictions are applied to this key.

**Fix:**
1. In Google Cloud Console: verify this key is restricted to `*.noblereach.org/*` as an allowed referrer
2. Verify the key only has permissions for the APIs actually used (Maps JavaScript API, Places API) — revoke any unnecessary API scopes
3. Move the key out of theme source code into a WordPress option (stored in the database) or a wp-config constant, so it is not committed to source control
4. Rotate the key if referrer restrictions were not already in place

### 4c. BugHerd Dev Tool Loaded on Production (High)

A bug-reporting/feedback tool intended for staging/QA environments is actively loaded on the live site. Two scripts load with the API key embedded in the URL:

```
https://www.bugherd.com/sidebarv2.js?apikey=3qbrqikhewhxejpgbacjiw
https://sidebar.bugherd.com/embed.js?apikey=3qbrqikhewhxejpgbacjiw
```

Console errors confirm the key is invalid or the account is inactive (`[AUTH] Unauthenticated Error`), but the scripts still load and the key is publicly visible to all site visitors. Even if the key is expired, loading unauthenticated third-party scripts on production is a security and performance issue.

**Fix:** Remove BugHerd from the production theme immediately. The `bugherd` plugin directory in `wp-content/plugins/` is empty — the script is being enqueued from the theme's `functions.php` or an `inc/` file. Find and remove the `wp_enqueue_script` call that loads it.

---

## 5. WordPress Configuration

### `DISALLOW_FILE_EDIT` Not Set (High)

The WordPress admin panel includes a built-in code editor for themes and plugins. With `DISALLOW_FILE_EDIT` absent, any user with Administrator access can edit PHP files directly from the browser — equivalent to server-side code execution.

**Fix:** Add to `wp-config.php` on the production server:
```php
define('DISALLOW_FILE_EDIT', true);
```

### Default Table Prefix (Medium)

`$table_prefix = 'wp_'` is the default value. Automated attacks targeting WordPress-specific table names (`wp_users`, `wp_options`) rely on this default.

**Fix:** Changing the table prefix on a live site requires a database migration and careful search/replace across serialized options. Defer to the rebuild — ensure the new site uses a non-default prefix from the start.

### `xmlrpc.php` Accessible (Medium)

WordPress XML-RPC is present and accessible. Attack vectors include brute-force credential testing via `system.multicall` (hundreds of attempts in a single HTTP request) and pingback-based DDoS amplification.

Defender Security (v4.7.1) is installed and can disable XML-RPC. **Confirm this is actively configured in the production Defender settings.** As a defense-in-depth measure, also block `/xmlrpc.php` at the Cloudflare WAF.

### DB Migration Tools Present (Medium)

`wp-migrate-db-pro` (2.6.12) and `better-search-replace` (1.4.10) are installed. Both can export database contents. Confirm both are **deactivated** on production and that access to their admin interfaces is not available to non-super-admin users.

---

## 6. Sensitive File Exposure

| File | Status | Action |
|---|---|---|
| `/readme.html` | Accessible | Remove from server or block via Cloudflare/WPEngine; exposes WordPress version |
| `/wp-config-sample.php` | Accessible | Remove from server |
| `/license.txt` | Accessible | Remove for cleanliness |
| `/local-xdebuginfo.php` | Present in local copy | **Verify this file is NOT on the production WPEngine server.** If present, it would expose PHP configuration to any visitor. |
| `/.env` | Not present | Good |
| `/.git` | Not present | Good |

---

## 7. Third-Party Scripts

12 third-party script domains load on the homepage. None load with Subresource Integrity (SRI) hashes. No CSP is set to scope what these scripts can do.

**Notable:**
- HubSpot loads 5 separate scripts from 5 separate domains
- Xandr/AppNexus ad tracking loads 2 scripts — confirm this is intentional (this is an ad network tracker, not standard analytics)
- BugHerd (addressed above)

**For the rebuild:** Consolidate third-party scripts under GTM where possible, define a Content Security Policy, and remove any scripts that are no longer actively used (BugHerd, potentially Xandr if ad campaigns are not active).

---

## 8. Inactive Theme

`wp-content/themes/noblereach` (legacy theme) is present alongside the active theme. Inactive themes are still served by the web server and can be exploited if they contain vulnerable code, even if not "activated" in WordPress.

**Fix:** Delete the inactive `noblereach` theme directory from the production server.

---

## 9. Remediation Priorities

### Critical (fix immediately — before next code release)

| What | Risk | Fix | Effort |
|---|---|---|---|
| Remove BugHerd from production | Third-party unauthenticated script on live site | Find and remove the `wp_enqueue_script` call in the theme | 1 hour |

### High (fix soon)

| What | Risk | Fix | Effort |
|---|---|---|---|
| SQL injection in `tm_get_nearby_cities()` | Database exposure if `$lat`/`$long`/`$distance` are user-controlled | Rewrite with `$wpdb->prepare()`; audit callers | 2–4 hours |
| Google Maps API key hardcoded in theme | API key abuse / cost exposure | Verify referrer restrictions in GCP Console; move key out of source code | 2 hours |
| `DISALLOW_FILE_EDIT` not set | Admin-level code execution via browser | Add one constant to production `wp-config.php` | 15 minutes |
| Add all 6 security headers | Clickjacking, MIME sniffing, missing HSTS | Configure in Cloudflare Transform Rules | 1–2 hours |

### Medium (planned work)

| What | Risk | Fix | Effort |
|---|---|---|---|
| Confirm Defender Security blocks XML-RPC | Brute-force and DDoS amplification | Verify in Defender settings; add Cloudflare WAF rule | 30 minutes |
| Remove `readme.html`, `wp-config-sample.php`, `license.txt` | Version/platform disclosure | Delete files on production server | 15 minutes |
| Verify `local-xdebuginfo.php` absent on production | PHP config disclosure | Check WPEngine file manager | 15 minutes |
| Confirm DB tools deactivated on production | Database export exposure | Check plugin status in WP admin | 15 minutes |
| Suppress `x-powered-by: WP Engine` header | Hosting platform disclosure | WPEngine support or Cloudflare header transform | 30 minutes |

### Low (backlog / carry forward to rebuild)

| What | Risk | Fix | Effort |
|---|---|---|---|
| Remove inactive `noblereach` theme | Stale code attack surface | Delete directory on production | 15 minutes |
| Remove 6 empty plugin ghost directories | Hygiene | Delete empty directories | 15 minutes |
| Default `wp_` table prefix | Automated attack targeting | Rebuild with non-default prefix from the start | N/A (rebuild task) |
| Cookie `SameSite` configuration | CSRF | Ensure new session cookies use `SameSite=Lax` | Rebuild task |
| SRI hashes on third-party scripts | Supply chain risk | Add `integrity` attributes; define CSP | Rebuild task |
| Consolidate third-party scripts under GTM | Operational / security hygiene | Rebuild task | |

---

## 10. Pre-Launch Security Checklist (For the Rebuild)

- [ ] HTTPS enforced on all routes; HTTP redirects to HTTPS
- [ ] HSTS header set with `max-age=31536000; includeSubDomains`
- [ ] TLS 1.2+ only; TLS 1.0/1.1 disabled
- [ ] `Content-Security-Policy` configured and tested
- [ ] `X-Frame-Options: SAMEORIGIN`, `X-Content-Type-Options: nosniff`, `Referrer-Policy` set
- [ ] All session/auth cookies have `Secure`, `HttpOnly`, and `SameSite=Lax` or `Strict`
- [ ] No credentials or API keys committed to source control (Google Maps key moved to env/options)
- [ ] Environment variables or WP options used for all third-party API keys; `.env` in `.gitignore`
- [ ] `DISALLOW_FILE_EDIT true` in wp-config
- [ ] Non-default `$table_prefix`
- [ ] No sensitive files publicly accessible (`readme.html`, `.env`, `local-xdebuginfo.php`, `xmlrpc.php`)
- [ ] Admin interfaces protected by strong credentials + 2FA
- [ ] XML-RPC disabled at application and/or WAF level
- [ ] All SQL queries using `$wpdb->prepare()` — no raw interpolation
- [ ] Third-party scripts reviewed, reduced, and scoped in CSP
- [ ] Inactive themes and empty plugin directories removed
- [ ] DB migration tools deactivated or uninstalled on production
- [ ] Error pages do not expose stack traces or server details
- [ ] Security headers verified via Mozilla Observatory (target score: B or higher)
