# Technology Inventory — Ocean Conservancy

**Audited:** 2026-03-23
**Source:** Local repo at `/Users/timarnold/sites/oceanconservancy-v1`
**Live site:** https://oceanconservancy.org

---

## 1. Architecture

| Attribute | Value |
|---|---|
| CMS | WordPress 6.9.1 |
| Theme | `simple-block` (custom FSE/block theme, Canic Interactive LLC) |
| PHP | 8.2 (set in `pantheon.yml`) |
| Database | MariaDB 10.4 (set in `pantheon.upstream.yml`) |
| Hosting | Pantheon |
| Caching | LiteSpeed Cache (plugin) + Object Cache Pro (Redis) |
| CDN/WAF | Cloudflare (plugin) |
| Build tools | Gulp 4 + SCSS (theme asset compilation) |
| Package manager | npm (`package-lock.json` present in theme) |
| Backup | UpdraftPlus 1.26.1 |
| HTTPS enforcement | **Off** — `pantheon.yml` sets `enforce_https: off`, overriding upstream's `transitional` |

**Site structure:**
- Full Site Editing (FSE) block theme with 34 custom Gutenberg blocks in `parts/blocks/`
- Content managed via WordPress admin + ACF Pro field groups
- Separate campaign microsites living in WP document root outside of WordPress: `/ensync/`, `/sharkweek/`, `/RiskyArcticDrilling/` — static HTML served directly by Pantheon
- robots.txt references `/wp-content/themes/oco-wp/` — the old theme slug (current theme is `simple-block`)

---

## 2. Theme

**Theme:** `simple-block` v1.0 (custom, authored by Canic Interactive LLC / 4Site Interactive Studios)

| Attribute | Value |
|---|---|
| Type | Full Site Editing (FSE) block theme |
| Template engine | PHP + WordPress block templates (`.html`) |
| CSS build | Gulp + `gulp-sass` + Dart Sass 1.87 → compiled CSS committed to repo |
| Custom blocks | 34 registered in `parts/blocks/` |
| Custom PHP includes | `functions-long-stories.php`, `functions-tfs_map_fields.php`, `functions-tfs_map_additional.php` |
| Dead code | `functions-import.php` — migration helper, all hooks commented out, NOT included in `functions.php` but left in the theme directory |
| 4Site subdirectory | `4site/` — Engaging Networks connector, Action Center, and other standalone PHP tools bundled inside theme |

**`4site/` directory contents:**

| Subdirectory | Purpose |
|---|---|
| `action-center/` | Action Center template (OC-specific, has own `package.json` with Stylus/Gulp build) |
| `ci/` | Unknown (not inspected) |
| `engaging-networks/` | Engaging Networks API connector — includes `guzzle.phar` (bundled PHAR), custom PHP API client |
| `fi/`, `pi/` | Unknown — likely campaign tools |
| `img/`, `js/`, `vid/`, `timeline/` | Static assets bundled in theme |

**ACF JSON:**
- ACF field group definitions are **NOT stored in the theme's** `acf-json/` directory (that folder does not exist in the theme)
- The `si-performance-helper.php` mu-plugin redirects ACF JSON reads/writes to `wp-content/uploads/acf-json/` in dev/non-live environments
- `wp-content/uploads/` is not version-controlled — **ACF field group definitions are not in source control**
- On Pantheon Live, ACF JSON scanning is disabled entirely (performance optimization)

---

## 3. Custom Post Types

| CPT Slug | Label | Registration Location | Notes |
|---|---|---|---|
| `long_story` | Long Story | Code — `functions-long-stories.php` | Hierarchical, public, rewrite slug `/ls/` |
| `tfs_map` | TFS Map | ACF Post Type UI (DB) or unknown | Referenced extensively in `functions-tfs_map_fields.php`; custom meta boxes for lat/lon, cleanup data |
| `people` | People | ACF Post Type UI (DB) | Staff/leadership profiles; single templates exist |
| `press-release` | Press Release | ACF Post Type UI (DB) | Single template exists |
| `wildlife-library` | Wildlife Library | ACF Post Type UI (DB) | Single template exists |
| `partner` | Partner | ACF Post Type UI (DB) | Referenced in theme functions |
| `corporate-supporter` | Corporate Supporter | ACF Post Type UI (DB) | Referenced in theme functions |
| `media-resource` | Media Resource | ACF Post Type UI (DB) | Referenced in permalink logic |

> **Note:** Most CPTs appear to be registered through ACF Pro's Post Type UI (database-only), not in code. This means they are not version-controlled and would need to be re-created manually in a new environment without a database export.

---

## 4. Plugins

### Active Plugins

| Plugin | Version | Purpose | Hard Dependency? | Notes |
|---|---|---|---|---|
| Advanced Custom Fields Pro | 6.7.0.2 | Field groups, options pages, Post Type UI | **Yes** — site-critical | ACF JSON not in theme directory |
| Gravity Forms | 2.9.28 | Forms (donations, signups, contact) | **Yes** — form data in DB | DB-only form definitions |
| FacetWP | 4.4.1 | Filterable content (cleanup maps, wildlife) | **Yes** — used in templates | Facet config in DB |
| Yoast SEO | 27.0 | On-page SEO meta | Yes | |
| Yoast SEO Premium | 25.8 | Redirects, internal linking | Yes | Redirect rules in DB |
| Redirection | 5.7.3 | Redirect management | Yes — redirect rules in DB | Possibly overlapping with Yoast Premium redirects |
| LiteSpeed Cache | 7.7 | Full-page caching | Yes | |
| Object Cache Pro | 1.25.0 | Redis object caching | Yes — Pantheon Redis | |
| Pantheon Advanced Page Cache | 2.1.2 | Pantheon-specific cache purging | Yes | |
| Cloudflare | 4.14.2 | CDN + WAF integration | Yes | |
| WP Mail SMTP | 4.7.1 | Email delivery via SMTP | Yes | Credentials in DB/options |
| WP Mail Logging | 1.16.0 | Log all outgoing email | No | |
| UpdraftPlus | 1.26.1 | Backups | Yes | |
| OptinMonster | 2.16.22 | Popup/CTA campaigns | Soft | |
| Akismet | 5.6 | Spam filtering | Soft | |
| Gravity Forms reCAPTCHA | 2.1.0 | reCAPTCHA for Gravity Forms | Soft | |
| Gravity Forms Zero Spam | 1.4.6 | Additional spam protection | Soft | |
| Breadcrumb NavXT | 7.5.1 | Breadcrumb navigation | Soft | Used in theme templates |
| SVG Support | 2.5.14 | Allow SVG uploads | Soft | |
| GTM4WP (duracelltomi-google-tag-manager) | 1.22.3 | Google Tag Manager integration | Soft | |
| Upland SMS Signup | 1.0 | Mobile Commons SMS opt-in (4Site) | Yes — production integration | Custom DB table; credentials stored in WP options |
| CSHP Custom | 1.0.0 | Mobile Commons via Gravity Forms (Cornershop) | Yes — wires GF to Upland plugin | Has hardcoded Mobile Commons path key |
| plugin-gravityforms-en | trunk | Gravity Forms → Engaging Networks bridge | Yes — if EN forms used | No stable version; `trunk` tag |
| contact-form-cfdb7 | 1.3.5 | Store CF7 form entries in DB | Soft | |
| Contact Form 7 | 6.1.5 | Additional forms | Soft | |
| Better Search Replace | 1.4.10 | DB search/replace tool | **No** — dev/migration tool | Should not be on production |
| WordPress Importer | (trunk) | Import WXR files | **No** — migration tool | Should not be on production |
| Create Block Theme | 2.8.0 | Theme development tool | **No** — dev tool | Should not be on production |
| Duplicate Page | 4.5.6 | Duplicate pages/posts | No — editorial convenience | Low risk but unnecessary |
| Regenerate Thumbnails | 3.1.6 | Rebuild image sizes | **No** — maintenance tool | Can be activated on demand |

### MU-Plugins

| File/Directory | Purpose | Notes |
|---|---|---|
| `pantheon-mu-plugin/` | Pantheon platform integration | Required |
| `wp-native-php-sessions/` | PHP session handling for Pantheon | Required |
| `si-performance-helper.php` | Disables ACF JSON on Live; optimizes Yoast sitemap | Custom, authored "Strong Industries" |
| `admin-post-navigation.php` | Admin post navigation UI | Low-risk utility |
| `redirect-backtrace.php` | Debug helper — logs redirect chains | Debug tool in MU-plugins; runs on every request |
| `loader.php` | MU-plugin loader | |

---

## 5. Third-Party Integrations

| Integration | Implementation | Credentials Exposed? | Notes |
|---|---|---|---|
| Google Tag Manager | GTM4WP plugin | GTM container ID in DB | All tracking via GTM |
| Engaging Networks | Custom PHP in `4site/engaging-networks/` | **YES — API key hardcoded in source** | `form.php` line 6: `const API_KEY = 'f09260ee-85b7-4e0a-b629-be476c52ae98'` |
| Mobile Commons | `upland-sms-signup` plugin + `cshp-custom` plugin | Path key hardcoded in `cshp-custom` | Dual-layer integration; CSHP plugin calls Upland plugin's AJAX endpoint |
| Gravity Forms → Engaging Networks | `plugin-gravityforms-en` (no stable version) | Unknown | `trunk` version; unclear maintenance status |
| OptinMonster | Plugin | API key in DB | Popup campaigns |
| Akismet | Plugin | API key in DB | Spam filtering |
| reCAPTCHA | Gravity Forms add-on | Site/secret keys in DB | |
| WP Mail SMTP | Plugin | SMTP credentials in DB | |
| Yoast SEO / Premium | Plugin | — | SEO meta + redirects |
| FacetWP | Plugin | — | Filterable archives |
| Cloudflare | Plugin | API credentials in DB | |
| Breadcrumb NavXT | Plugin | — | |

### Hardcoded credentials detail

| File | Credential | Type |
|---|---|---|
| `wp-content/themes/simple-block/4site/engaging-networks/form.php:6` | `f09260ee-85b7-4e0a-b629-be476c52ae98` | Engaging Networks API key |
| `wp-content/plugins/cshp-custom/inc/mobile-commons.php:94` | `OPF63500073B2F81675D4B3245FEA27105` | Mobile Commons optin path key |

---

## 6. Custom Functionality

### Engaging Networks connector (`4site/engaging-networks/`)
- Standalone PHP scripts inside the theme directory that operate outside the normal WP hook lifecycle
- Bundles `guzzle.phar` — a PHAR archive of the Guzzle HTTP client
- `form.php` handles form submissions and talks to the EN API
- `test.php` exists in the same directory — a debug/test script that should not be web-accessible
- Engaging Networks API key hardcoded in `form.php`

### Mobile Commons / SMS integration
- Two-layer setup: `upland-sms-signup` (4Site) provides an AJAX endpoint and stores credentials in WP options
- `cshp-custom` (Cornershop) hooks `gform_after_submission` and calls that AJAX endpoint with subscriber data
- Mobile Commons optin path key (`OPF6350...`) is hardcoded in `cshp-custom/inc/mobile-commons.php`
- Extensive `error_log()` calls throughout — logs full form entry data including phone numbers and emails on every form submission

### TFS Map (`tfs_map` CPT)
- Custom cleanup location database powering the International Coastal Cleanup map
- Post type has custom meta fields: lat/lon, address, city, county, state, country, event date, cleanup type, team seas flag
- Managed via custom meta boxes (`functions-tfs_map_fields.php`) — not ACF
- Singular posts redirect to `/work/plastics/cleanups-icc/map/?location_id=xx` (301)
- Custom search integration in `functions-tfs_map_additional.php`

### Long Story CPT
- Multi-page narrative format, registered in code
- Hierarchical, rewrite slug `/ls/`
- Has separate FacetWP integration and custom ACF fields

### Dead code
- `functions-import.php` — content migration helper with functions for XML import, author matching, press release extraction. All `add_action` hooks are commented out. File is present in theme but **not included** anywhere. Pure dead code — should be removed.
- `redirect-backtrace.php` in mu-plugins — debug utility that likely shouldn't be running in production

### Legacy microsites in WP document root
- `/ensync/` — placeholder HTML (4Site Interactive Studios page)
- `/sharkweek/` — Shark Week campaign page (static HTML)
- `/RiskyArcticDrilling/` — full mini-site with its own Gulp build, Node modules, assets

---

## 7. Configuration

| Item | Setting | Notes |
|---|---|---|
| HTTPS enforcement | `enforce_https: off` | Overrides upstream `transitional`; HTTPS not enforced at Pantheon level |
| PHP | 8.2 | Supported until Dec 2026; PHP 8.3/8.4 available |
| MariaDB | 10.4 | **EOL June 2024** — unsupported |
| WP_DEBUG | `false` | Correct for production |
| WP_MEMORY_LIMIT | 1024M | Set in `wp-config.php` |
| xmlrpc.php | Protected via `pantheon.yml` | Correct |
| Table prefix | `wp_` | Default prefix — minor security consideration |
| ACF JSON on Live | Disabled (mu-plugin) | Prevents scandir overhead; correct for performance |
| debug.log | Exists in `wp-content/uploads/` | Indicates WP_DEBUG_LOG was enabled; may contain sensitive data; publicly accessible URL |
