# Technology Audit Report — Ocean Conservancy

**Audited:** 2026-03-23
**Site:** https://oceanconservancy.org
**Source:** Local repo at `/Users/timarnold/sites/oceanconservancy-v1`
**Prepared for:** Dev team (remediation — no rebuild planned)

---

## Executive Summary

Ocean Conservancy runs WordPress 6.9.1 on Pantheon with a custom Full Site Editing block theme (`simple-block`) built by Canic Interactive. The stack is actively maintained and generally in good shape, but several issues require attention:

- **Hardcoded credentials in source:** An Engaging Networks API key is committed directly to the theme; a Mobile Commons path key is committed to a plugin. Both should be treated as compromised and rotated.
- **MariaDB 10.4 is EOL** (June 2024) — Pantheon continues to host it but the version receives no security patches.
- **HTTPS is not enforced** at the Pantheon platform level (`enforce_https: off` in `pantheon.yml`).
- **ACF field group definitions are not version-controlled** — they live in `wp-content/uploads/` (not tracked in git), creating risk of data loss and making environment parity impossible.
- **Three dev/migration plugins are active on production** and should be removed.
- **A debug log** (`wp-content/uploads/debug.log`) may be publicly accessible and may contain PII from form submissions.
- **Extensive `error_log()` calls** in the Mobile Commons integration log full form entries — including phone numbers and email addresses — on every SMS opt-in submission.

---

## Remediation Checklist

### Critical — Fix Immediately

**1. Rotate and move the Engaging Networks API key out of source**

- **What:** `const API_KEY = 'f09260ee-85b7-4e0a-b629-be476c52ae98'` is hardcoded on line 6 of `wp-content/themes/simple-block/4site/engaging-networks/form.php` and is committed to the repo. Anyone with repo access has this key.
- **Risk:** Security — credential exposure
- **Fix:** Rotate the key in the Engaging Networks admin immediately. Move the new key to a Pantheon environment variable or WP option (not in code). Update `form.php` to read from `getenv()` or `get_option()`.
- **Effort:** 1–2 hours

**2. Rotate and move the Mobile Commons optin path key**

- **What:** `'optin_path_key' => 'OPF63500073B2F81675D4B3245FEA27105'` is hardcoded in `wp-content/plugins/cshp-custom/inc/mobile-commons.php` line 94.
- **Risk:** Security — credential exposure
- **Fix:** Rotate the path key in Mobile Commons. Store the new value in a WP option or Pantheon environment variable and read it dynamically.
- **Effort:** 1 hour

**3. Check and delete the debug log**

- **What:** `wp-content/uploads/debug.log` exists and is publicly accessible via `https://oceanconservancy.org/wp-content/uploads/debug.log`. Given that `error_log()` calls throughout the Mobile Commons integration log full form entries (phone, email, form data), this file may contain PII.
- **Risk:** Security / Privacy — potential PII exposure
- **Fix:** Immediately check the file contents (check if it's web-accessible first via curl). Delete it. Add `Disallow: /wp-content/uploads/debug.log` to `robots.txt` and/or protect it via Pantheon's `protected_web_paths` in `pantheon.yml`. Ensure `WP_DEBUG_LOG` is not enabled on production going forward.
- **Effort:** 30 minutes

**4. Remove `error_log()` calls from Mobile Commons integration**

- **What:** `cshp-custom/inc/mobile-commons.php` calls `error_log()` with `print_r($entry, true)` and `print_r($form, true)` on every Gravity Forms submission that triggers the SMS opt-in. This dumps the full form entry — including phone numbers, email addresses, and all submitted field values — to the error log.
- **Risk:** Security / Privacy — PII logging; GDPR/CCPA exposure if logs persist
- **Fix:** Remove or replace all `error_log()` calls with conditional logging gated on a debug constant. Keep only error-path logging (not success-path dumps). This is a quick edit to a 129-line file.
- **Effort:** 1 hour

---

### High — Fix Soon

**5. Upgrade MariaDB from 10.4 to a supported version**

- **What:** `pantheon.upstream.yml` specifies `database: version: 10.4`. MariaDB 10.4 reached end of life in June 2024 and no longer receives security patches.
- **Risk:** Security — unpatched database vulnerabilities
- **Fix:** Upgrade to MariaDB 10.6 (LTS, EOL July 2026) or 10.11 (LTS, EOL Feb 2028). Pantheon supports this via `pantheon.upstream.yml` `database.version` — test on dev/multidev first.
- **Effort:** 1 day (including testing)

**6. Enable HTTPS enforcement**

- **What:** `pantheon.yml` has `enforce_https: off`, overriding the upstream's `transitional` setting. Traffic can reach the site over plain HTTP without being redirected.
- **Risk:** Security — MITM, cookie hijacking if any non-Secure cookies exist
- **Fix:** Change `enforce_https: transitional` or `enforce_https: full` in `pantheon.yml`. `full` enables HSTS. Verify no legitimate HTTP-only traffic will break (e.g., API callbacks that don't follow redirects).
- **Effort:** 1 hour + monitoring

**7. Version-control ACF field group definitions**

- **What:** ACF JSON is saved to `wp-content/uploads/acf-json/` (per the `si-performance-helper.php` mu-plugin), which is not tracked in git. The theme's `acf-json/` directory does not exist. If the database is lost without a backup, or if a new environment is provisioned from code alone, all field group definitions are gone.
- **Risk:** Stability — environment parity impossible; risk of data loss; blocking for any rebuild or migration
- **Fix:** Move the ACF JSON load/save path from `uploads/acf-json/` to a directory inside the theme (e.g., `wp-content/themes/simple-block/acf-json/`) and commit the JSON files. Update the `si-performance-helper.php` mu-plugin's load/save path filters accordingly. Also export ACF Post Type UI definitions (CPT registrations) to JSON.
- **Effort:** 2–4 hours (including committing the existing JSON)

**8. Remove dev/migration plugins from production**

- **What:** Three plugins that serve no ongoing production purpose are active:
  - `better-search-replace` — DB search/replace tool; provides write access to the database via the WP admin
  - `wordpress-importer` — WXR import tool; unnecessary post-migration
  - `create-block-theme` — block theme development tool
- **Risk:** Stability / Security — unnecessary attack surface; `better-search-replace` in particular is a high-risk tool to leave enabled
- **Fix:** Deactivate and delete all three. Add to deployment checklist for future environments.
- **Effort:** 15 minutes

**9. Protect or remove `test.php` in the Engaging Networks directory**

- **What:** `wp-content/themes/simple-block/4site/engaging-networks/test.php` is a debug/test script that may be publicly accessible and could expose API behavior or internal logic.
- **Risk:** Security — debug endpoint exposure
- **Fix:** Delete `test.php`. If it needs to exist for development, add the path to `protected_web_paths` in `pantheon.yml`.
- **Effort:** 30 minutes

**10. Clarify CPT registration method and document it**

- **What:** Six of seven custom post types (`tfs_map`, `people`, `press-release`, `wildlife-library`, `partner`, `corporate-supporter`, `media-resource`) appear to be registered via ACF Pro's Post Type UI (stored in the database), not in code. There's no documentation of this. Only `long_story` is registered in code.
- **Risk:** Stability — CPT definitions will be lost without a DB export; impossible to reconstruct from the codebase
- **Fix:** Export ACF Post Type UI definitions to JSON (ACF Pro supports this). Commit those files. Document the dependency in a `README.md` or theme comments.
- **Effort:** 2 hours

---

### Medium — Planned Work

**11. Resolve duplicate redirect managers**

- **What:** Both Yoast SEO Premium and the Redirection plugin are active. Both handle URL redirects and store rules in separate DB tables. It's unclear which is authoritative.
- **Risk:** Maintainability — redirect rules split across two systems; potential conflicts; extra maintenance overhead
- **Fix:** Audit which plugin owns which redirects. Consolidate into one (Yoast Premium is the better choice if already paid for). Migrate the other's rules and deactivate the redundant plugin.
- **Effort:** 4–8 hours (audit) + 2 hours (migration)

**12. Move Engaging Networks integration out of the theme**

- **What:** `wp-content/themes/simple-block/4site/` bundles a full Engaging Networks API client including a PHAR file (`guzzle.phar`), standalone PHP scripts, and campaign assets. This code is embedded in the theme directory, making it fragile (theme updates would clobber it) and hard to maintain.
- **Risk:** Maintainability / Security — bundled PHAR is hard to audit; theme coupling
- **Fix:** Move the EN integration to a dedicated plugin (even a simple custom plugin). Replace `guzzle.phar` with a Composer-managed Guzzle dependency. Store the API key as a WP option or Pantheon environment variable.
- **Effort:** 1 sprint

**13. Remove `functions-import.php` dead code**

- **What:** `wp-content/themes/simple-block/functions-import.php` is a 400+ line migration helper file containing functions for XML import, author matching, and press release extraction. All `add_action` hooks are commented out and the file is not included anywhere. It's dead code from the initial content migration.
- **Risk:** Maintainability — clutter; confusing to future developers
- **Fix:** Delete the file.
- **Effort:** 5 minutes

**14. Remove `redirect-backtrace.php` from mu-plugins**

- **What:** `wp-content/mu-plugins/redirect-backtrace.php` is a debug utility that runs on every request. MU-plugins cannot be deactivated via the WP admin — this runs unconditionally in production.
- **Risk:** Stability / Performance — unnecessary overhead on every request
- **Fix:** Delete the file from mu-plugins. If needed for debugging, use it temporarily and remove it afterward.
- **Effort:** 5 minutes

**15. Update robots.txt — remove old theme reference**

- **What:** `robots.txt` has `Disallow: /wp-content/themes/oco-wp/images/video/` — `oco-wp` is the old theme (current theme is `simple-block`). The disallow rule is no longer meaningful.
- **Risk:** Maintainability — stale config; minor SEO noise
- **Fix:** Update the path to the current theme or remove the rule if it's no longer needed.
- **Effort:** 15 minutes

**16. Audit legacy microsites in the WP document root**

- **What:** Three standalone directories exist in the WordPress document root outside of WP: `/ensync/` (placeholder page), `/sharkweek/` (campaign), `/RiskyArcticDrilling/` (campaign mini-site with Node modules). These are not managed by WordPress and are not documented anywhere.
- **Risk:** Maintainability — undocumented, unmanaged; Node modules in `/RiskyArcticDrilling/` may have unpatched vulnerabilities
- **Fix:** Determine if each is still needed. Archive and remove inactive ones. Document any that remain. Do not serve Node `node_modules/` from a public web root.
- **Effort:** 2–4 hours (decision + cleanup)

**17. Add `protected_web_paths` for sensitive directories**

- **What:** Several paths in `wp-content/themes/simple-block/4site/` (including `test.php`, `guzzle.phar`, cache files) may be web-accessible.
- **Risk:** Security — debug/tool exposure
- **Fix:** Add these to `protected_web_paths` in `pantheon.yml` or restructure to move them outside the web root.
- **Effort:** 1 hour

---

### Low — Backlog

**18. Upgrade PHP from 8.2 to 8.3 or 8.4**

- **What:** PHP 8.2 is supported until December 2026. PHP 8.3 and 8.4 are available.
- **Risk:** Low (current version still supported)
- **Fix:** Test on Pantheon dev with PHP 8.3, update `pantheon.yml`, deploy.
- **Effort:** 2–4 hours (testing)

**19. Standardize Mobile Commons credential storage**

- **What:** The Upland SMS Signup plugin stores its credentials (Mobile Commons username/password) in WP options via the admin UI, which is correct. The CSHP Custom plugin has the optin path key hardcoded (see Critical #2 above). Once rotated, a consistent credential storage approach (WP options or Pantheon env vars) should be documented.
- **Risk:** Maintainability
- **Fix:** After rotating credentials, document the storage approach in a README or comments.
- **Effort:** 30 minutes

**20. Remove or deactivate `Duplicate Page` and `Regenerate Thumbnails`**

- **What:** These are low-risk convenience tools but unnecessary on production. `Regenerate Thumbnails` in particular should be run on-demand and deactivated afterward.
- **Risk:** Low
- **Fix:** Deactivate both. Reinstall `Regenerate Thumbnails` only when needed.
- **Effort:** 10 minutes

**21. Audit `wp-mail-logging` data retention**

- **What:** WP Mail Logging logs all outgoing email. Depending on email volume and retention settings, this table may contain a large amount of PII (email addresses, content).
- **Risk:** Privacy — GDPR/CCPA
- **Fix:** Check the retention period in WP Mail Logging settings. Set a reasonable max log age (e.g., 30–90 days).
- **Effort:** 30 minutes

---

## Dependency Versions

### WordPress Core & Platform

| Component | Installed | Notes |
|---|---|---|
| WordPress | 6.9.1 | Current |
| PHP | 8.2 | Supported until Dec 2026 |
| MariaDB | 10.4 | **EOL June 2024** |

### Theme Build Dependencies

| Package | Installed | Notes |
|---|---|---|
| gulp | ^4.0.2 | Current major |
| gulp-sass | ^6.0.1 | Current |
| sass (Dart Sass) | ^1.87.0 | Current |
| gulp-sourcemaps | ^3.0.0 | Current |

### Key Plugins

| Plugin | Installed | Notes |
|---|---|---|
| Advanced Custom Fields Pro | 6.7.0.2 | Check for latest |
| Gravity Forms | 2.9.28 | Check for latest |
| FacetWP | 4.4.1 | Check for latest |
| Yoast SEO | 27.0 | Check for latest |
| Yoast SEO Premium | 25.8 | Version gap vs Yoast free — may indicate Premium updates are lagging |
| Redirection | 5.7.3 | Check for latest |
| LiteSpeed Cache | 7.7 | Check for latest |
| Object Cache Pro | 1.25.0 | Check for latest |
| OptinMonster | 2.16.22 | Check for latest |
| WP Mail SMTP | 4.7.1 | Check for latest |
| GTM4WP | 1.22.3 | Check for latest |
| Cloudflare | 4.14.2 | Check for latest |
| Contact Form 7 | 6.1.5 | Check for latest |

> Plugin version currency should be verified against wordpress.org/plugins and vendor changelogs. Most plugins auto-update via WP admin; confirm auto-updates are configured for security releases.

---

## Migration Checklist Additions

If this site is ever migrated or rebuilt, the following are critical data dependencies that live **only in the database** (not in code):

- [ ] Full database export (all tables — postmeta, options, term relationships)
- [ ] ACF field group JSON exports — verify completeness; note that ACF JSON is currently in `uploads/acf-json/` (not in theme or repo)
- [ ] ACF Post Type UI exports — all CPT and taxonomy definitions
- [ ] Gravity Forms export (all form definitions — JSON export from GF admin)
- [ ] Gravity Forms entries export (if needed for continuity)
- [ ] Redirection plugin redirect rules export
- [ ] Yoast SEO Premium redirect rules (in DB export)
- [ ] FacetWP facet configuration (in DB)
- [ ] Upland SMS Signup credentials/config (in WP options)
- [ ] WP Mail SMTP credentials (in WP options or encrypted storage)
- [ ] OptinMonster campaign config (partially in DB, partially in OptinMonster cloud)
- [ ] Media library (`wp-content/uploads/`) — years 2012–2026 present locally
- [ ] Custom DB table: `wp_upland_sms_signup_log` (Upland SMS plugin)
- [ ] Legacy microsites: `/ensync/`, `/sharkweek/`, `/RiskyArcticDrilling/` — determine disposition
