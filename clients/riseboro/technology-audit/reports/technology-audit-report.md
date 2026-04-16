# Technology Audit Report — RiseBoro

**Site:** https://riseboro.org  
**Audit date:** 2026-04-16  
**Method:** Front-end only (no local source or database access)  
**Auditor:** Claude Code

---

## Executive Summary

- **HTTP 500 on `/news/`** — the URL corresponding to the `news` CPT slug returns a bare PHP fatal error page. This URL is not linked in the navigation (press content lives at `/press-room/`), so it may be an unintentional public URL with no archive template — but the 500 response should still be resolved.
- **ScrollMagic debug plugin in production** — `debug.addIndicators.min.js` is a developer tool that renders visual scroll-trigger indicators on screen. It is bundled and deployed in the production theme build.
- **Local dev URL leaking into structured data** — the JSON-LD `thumbnailUrl` on the homepage references `riseboro.lndo.site`, exposing the internal development environment name in public search engine markup.
- **Universal Analytics still firing** — UA-54060402-3 continues sending hits to Google's deprecated UA endpoint (sunset July 2023). This data goes nowhere and adds unnecessary page weight.
- **HSTS configured at 5 minutes** — `max-age=300` provides almost no protection against SSL stripping. Standard minimum is 1 year (31536000).
- **Staff CPT fully readable via REST API** — all staff records including full content are publicly accessible at `/wp-json/wp/v2/staff` with no authentication required.
- **jQuery Migrate loaded in production** — confirms the custom theme depends on deprecated jQuery APIs, creating a long-term maintainability risk.
- **Placeholder `<meta name="keywords">` never removed** — homepage source contains `your, site, keywords, here`.

---

## 1. Architecture Overview

| Item | Detail |
|---|---|
| CMS | WordPress 6.9.4 (current) |
| Theme | Custom — `riseboro` with compiled build artifacts in `/wp-content/themes/riseboro/build/` |
| Hosting | Pantheon |
| CDN | Cloudflare (WordPress cache integration active) |
| Search | ElasticPress (Elasticsearch-backed; active on all queries) |
| HTTP | HTTP/2 |
| Caching | Working well — `max-age=43200` (12 hours), Varnish + Cloudflare both caching (`X-Cache: HIT, HIT`) |

WordPress itself is up to date. The hosting stack (Pantheon + Cloudflare) is appropriate and caching is functioning. The primary risks are in plugin configuration, theme build artifacts, and analytics hygiene.

---

## 2. Dependencies

No source access was available; version data is inferred from asset query strings and meta generator tags.

### WordPress Core & Theme

| Component | Inferred Version | Notes |
|---|---|---|
| WordPress | 6.9.4 | Current; `?ver=6.9.4` on core assets |
| jQuery | 3.7.1 | Current |
| jQuery Migrate | 3.4.1 | Should not run in production |
| GSAP | Unknown | Bundled in theme build; version not exposed |
| ScrollMagic | Unknown | Bundled in theme build; debug plugin active |

### Active Plugins (inferred from REST API namespaces + asset URLs)

| Plugin | Version | Notes |
|---|---|---|
| ElasticPress | Unknown | REST namespace `elasticpress/v1` |
| Redirection | Unknown | REST namespace `redirection/v1` |
| Wordfence | Unknown | REST namespace `wordfence/v1` |
| Yoast SEO | Unknown | REST namespace `yoast/v1` |
| Yoast Duplicate Post | Unknown | REST namespace `duplicate-post/v1` |
| WP Smush | Unknown | REST namespace `wp-smush/v1` |
| Google Site Kit | 1.175.0 | Meta generator tag |
| Simple Banner | 3.2.1 | Asset URL `?ver=3.2.1` |
| Simple Lightbox | 2.9.5 | Asset URL `?ver=2.9.5` |
| GTranslate | Unknown | Script present |
| ACF (Advanced Custom Fields) | Unknown | `acf` key present in all CPT REST responses |

Specific plugin versions are not exposed for most plugins. A logged-in admin review of the Plugins screen is needed for a complete version audit and CVE scan.

---

## 3. Content and Data Model

### Custom Post Types

| CPT | Slug Pattern | REST Accessible | Notes |
|---|---|---|---|
| Programs | `/program/<slug>/` | Yes | Core content type; ElasticPress search active |
| Events | `/events/<slug>/` | Yes | ACF fields; archive works |
| Housing | `/housing/<slug>/` | Yes | Housing listings with ACF fields |
| Success Stories | `/lives-changed/` | Yes | Testimonials / impact stories |
| Staff | `/board-staff/` | Yes | **Full content publicly exposed via REST** |
| News | `/news/` | Yes (REST) | Archive URL not linked in nav; returns HTTP 500 |
| Newsletters | Unknown | Yes | No public archive found in nav |

### Content Model Issues

**`/news/` returns HTTP 500** — the URL derived from the `news` CPT slug is not linked anywhere in the navigation (press content is served at `/press-room/`). The CPT may have no archive enabled, or may be missing an archive template. Either way, the URL returns a bare PHP fatal error rather than a 404, which should be resolved — either by disabling the archive (`has_archive => false`) or adding a proper template.

**Orphaned URL pattern in nav** — the "Caregiver Support" nav link points to `/?post_type=program&p=422`, a raw ID-based URL. This indicates either a broken permalink or a post that was never given a proper slug. It will return a 404 if the post is moved or the permalink structure changes.

**ACF field groups** — ACF is active and fields are exposed in REST responses. Whether field group definitions are version-controlled as JSON sync files is not determinable from the front-end; this should be verified.

---

## 4. Third-Party Integrations

| Service | Purpose | Status | Issue |
|---|---|---|---|
| Google Tag Manager (GTM-WQCP8ZQ) | Tag orchestration | Active | — |
| Google Analytics 4 (G-1981Z91NNK) | Analytics | Active | — |
| Universal Analytics (UA-54060402-3) | Analytics | **Sending hits** | Google sunset UA in July 2023; hits are discarded |
| Google Ads (AW-940285834) | Conversion tracking | Active | — |
| Facebook Pixel (492147728201296) | Ad targeting | Active | — |
| LiveRamp (liadm.com) | Identity resolution | Active | Third-party cross-site tracking; privacy policy review recommended |
| Cloudflare Insights + RUM | Performance | Active | — |
| GTranslate | Machine translation | Active | 15 languages; widget configured top-right |
| Swoogo | Event registration | Linked | External platform (`riseboro.swoogo.com`) |

**Universal Analytics is dead.** UA was sunset in July 2023. The `analytics.js` script still loads and sends hits to `google-analytics.com/j/collect`, but Google discards them. This adds an unnecessary HTTP request and script load on every page. It should be removed from GTM.

**LiveRamp (liadm.com)** — fires an `idx.liadm.com` request and an `i.liadm.com` sync iframe. This is an identity resolution service used for ad audience matching. Its presence should be reflected in the site's privacy policy and cookie consent mechanism.

---

## 5. Custom Functionality

Limited visibility without source access. Observations from public front-end:

**Custom REST namespace `riseboro`** — a custom namespace is registered at `/wp-json/`, suggesting custom REST endpoints are defined in a plugin or `functions.php`. The contents of this namespace are not publicly documented.

**Theme JS modules** — the theme bundles multiple purpose-specific JS files (`donate.js`, `email-signup.js`, `services-search.js`, `audience-select.js`, `successstory-gallery.js`). This suggests significant custom front-end logic. No source maps are publicly accessible.

**GTranslate configuration is client-side** — language switcher and URL structure settings are embedded in an inline script, including the account ID (`51406871`). This is standard for GTranslate but means configuration changes require a plugin setting update and cache purge.

**jQuery Migrate** — the presence of jQuery Migrate in production confirms the theme (or a plugin) uses jQuery APIs deprecated before v1.9 or v3.x. This will eventually block a full jQuery upgrade.

---

## 6. Performance and Configuration

| Item | Status | Notes |
|---|---|---|
| Page caching | Good | `max-age=43200`, both Varnish and Cloudflare returning HITs |
| Asset versioning | Inconsistent | Core and plugin assets use `?ver=` query strings; some theme JS has no version query string |
| Image optimization | Plugin active | WP Smush is installed |
| HSTS | **Weak** | `max-age=300` (5 minutes). Should be ≥31536000 |
| HTTPS | Enforced | Cloudflare handles SSL termination |
| HTTP/2 | Enabled | Confirmed |
| ElasticPress | Active | Offloads search queries to Elasticsearch; header confirms it's processing queries |
| Debug script in production | **Yes** | `ScrollMagic/plugins/debug.addIndicators.min.js` is bundled and enqueued |

---

## 7. Security Observations

| Item | Status | Notes |
|---|---|---|
| `xmlrpc.php` | Blocked (403) | Good |
| `/wp-admin/` | Blocked (→ 404) | Good |
| REST API user enumeration | Blocked (401) | Good |
| REST API plugin namespace exposure | Open | Full plugin list readable without auth at `/wp-json/` |
| WP version in HTML | Exposed | `<meta name="generator" content="WordPress 6.9.4">` |
| Staff CPT via REST | **Open** | Full staff records readable without auth |
| Plugin versions in asset URLs | Partial | Simple Banner 3.2.1 and Simple Lightbox 2.9.5 exposed |
| HSTS duration | **Weak** | `max-age=300` — see above |
| Local dev URL in structured data | **Leaking** | `riseboro.lndo.site` in JSON-LD `thumbnailUrl` |

The most actionable security item is the **HSTS header**. The current 5-minute window means SSL stripping attacks are only blocked for 5 minutes after a user's most recent visit. This should be set to at minimum 1 year (`max-age=31536000`) and ideally include `includeSubDomains; preload`.

---

## Remediation Checklist

### Critical — Fix Immediately

| # | What | Risk | Fix | Effort |
|---|---|---|---|---|
| C1 | `/news/` returns HTTP 500 | Stability | URL is not in the nav but is publicly reachable. Either disable the archive (`has_archive => false` in CPT registration) so it 404s cleanly, or add a proper archive template. Check Pantheon error logs to identify the PHP fatal. | 1–2 hrs |
| C2 | ScrollMagic `debug.addIndicators.min.js` loaded in production | Stability / UX | Remove `debug.addIndicators` from the theme's build/enqueue configuration. This is a dev-only tool that renders visual overlays on the live site. | 1 hr |
| C3 | Local dev URL (`riseboro.lndo.site`) in JSON-LD structured data | SEO / Privacy | Find where this URL is hardcoded in the theme or WP options (likely a Yoast option or ACF options page value pointing to the local environment). Replace with `https://riseboro.org`. | 1 hr |

### High — Fix Soon

| # | What | Risk | Fix | Effort |
|---|---|---|---|---|
| H1 | HSTS `max-age=300` (5 minutes) | Security | Set `Strict-Transport-Security: max-age=31536000; includeSubDomains` — via Pantheon or Cloudflare settings. | 30 min |
| H2 | Staff CPT fully readable via unauthenticated REST API | Privacy | Evaluate whether `staff` CPT should be public in the REST API. If not, add `'show_in_rest' => false` to the CPT registration or restrict the endpoint with `rest_authentication_errors`. | 1–2 hrs |
| H3 | Universal Analytics still firing (UA-54060402-3) | Performance / Hygiene | Remove the UA tag from GTM. The UA endpoint was sunset July 2023; hits are silently discarded. | 30 min |
| H4 | jQuery Migrate loaded in production | Maintainability | Identify which theme/plugin code triggers the migrate warnings (check browser console). Plan to update deprecated jQuery usage so Migrate can be removed. | 2–5 days (investigation + remediation) |
| H5 | `/?post_type=program&p=422` (Caregiver Support nav link) | Stability | Assign a proper permalink slug to the Caregiver Support program post and update the nav menu. | 30 min |

### Medium — Planned Work

| # | What | Risk | Fix | Effort |
|---|---|---|---|---|
| M1 | REST API plugin namespace enumeration | Security (low severity) | Add a filter to restrict `/wp-json/` namespace listing for unauthenticated requests, or accept as a known-low risk given Wordfence is active. | 1–2 hrs |
| M2 | WP version exposed in HTML `<meta>` | Security (info disclosure) | Remove the generator meta tag via `remove_action('wp_head', 'wp_generator')` in `functions.php`. | 15 min |
| M3 | Plugin versions exposed in asset URL query strings | Security (info disclosure) | Filter `script_loader_src` and `style_loader_src` to strip `?ver=` from asset URLs. | 1 hr |
| M4 | ACF field group JSON sync — verify status | Maintainability | Confirm that ACF field group definitions are saved as JSON files in the theme (not DB-only). If not, export and commit them. | 1–2 hrs |
| M5 | LiveRamp presence in privacy policy | Legal / Compliance | Verify that the privacy policy and cookie consent banner discloses LiveRamp identity resolution data sharing. | Legal review |
| M6 | `show_in_rest` review for housing, news, newsletter CPTs | Privacy | Audit whether all publicly-registered CPTs should expose full content via REST. Restrict any that shouldn't. | 2–3 hrs |

### Low — Backlog

| # | What | Risk | Fix | Effort |
|---|---|---|---|---|
| L1 | `<meta name="keywords">` placeholder text | SEO / Hygiene | Remove or update the `keywords` meta tag (value is `your, site, keywords, here`). Note: this meta is ignored by Google but looks unprofessional in source. | 15 min |
| L2 | Homepage `<meta name="description">` is empty | SEO | Set a descriptive homepage meta description in Yoast. | 15 min |
| L3 | Duplicate brand in page title (`RiseBoro \| Page Title - RiseBoro`) | SEO | Fix the Yoast title template to remove the trailing ` - RiseBoro`. | 15 min |
| L4 | Asset version query strings inconsistent (some theme JS lacks `?ver=`) | Caching | Ensure all enqueued scripts pass a version argument to `wp_enqueue_script()` for proper cache-busting. | 1 hr |
| L5 | No cookie consent banner observed | Legal / Compliance | Site uses Facebook Pixel, LiveRamp, and Google Ads — EU/CCPA users may require a consent mechanism. Assess legal requirements. | Sprint |

---

## Gaps — Requires Source Access

The following areas could not be assessed without access to the codebase or WP admin:

- **Plugin version audit** — most plugin versions not detectable from the front-end; a full CVE scan requires admin-level access.
- **ACF field group completeness** — cannot verify whether JSON sync files are committed or if field groups are DB-only.
- **`functions.php` and `inc/`** — custom routing, hardcoded credentials, or debug code in server-side PHP is not visible.
- **Environment variable / secrets management** — Pantheon uses environment-specific config via `wp-config.php` patterns; not auditable from the front-end.
- **Form integrations** — no form plugins (Gravity Forms, Contact Form 7) were observed on the pages visited, but may exist on interior pages.
- **Redirect rules** — the Redirection plugin is active but its rule set requires admin access to audit.
- **Wordfence configuration** — firewall rules, login protection, and scan results require admin access.
