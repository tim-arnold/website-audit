# Technology Inventory — RiseBoro

**Audit date:** 2026-04-16  
**Site URL:** https://riseboro.org  
**Method:** Front-end only (no local source access)

---

## Platform

| Item | Value |
|---|---|
| CMS | WordPress |
| WP Version | 6.9.4 (current as of audit date) |
| Theme | Custom — `riseboro` (body class: `wp-theme-riseborobuild`) |
| Build artifacts | Compiled assets served from `/wp-content/themes/riseboro/build/` |
| Hosting | Pantheon (confirmed via `x-pantheon-styx-hostname` response header) |
| CDN / Proxy | Cloudflare (confirmed via `server: cloudflare` header) |
| HTTP Protocol | HTTP/2 |
| PHP | Not detectable from front-end |

---

## Server Response Headers (key)

| Header | Value | Notes |
|---|---|---|
| `server` | cloudflare | CDN layer |
| `cache-control` | `public, max-age=43200` | 12-hour page cache — good |
| `x-cache` | `HIT, HIT` | Varnish + Cloudflare both caching |
| `cf-edge-cache` | `cache,platform=wordpress` | Cloudflare WordPress cache integration |
| `x-elasticpress-query` | `true` | ElasticPress actively serving search queries |
| `strict-transport-security` | `max-age=300` | **Very weak HSTS — only 5 minutes** |
| `x-pantheon-styx-hostname` | present | Exposes Pantheon infrastructure |

---

## WordPress Plugins (inferred from REST API namespaces)

| Plugin | Namespace | Purpose | Notes |
|---|---|---|---|
| ElasticPress | `elasticpress/v1` | Search / Elasticsearch integration | Active on queries (`x-elasticpress-query: true` header) |
| Redirection | `redirection/v1` | 301/302 redirect management | DB-stored rules |
| Wordfence | `wordfence/v1` | Security / firewall | Actively blocking some endpoints |
| Yoast SEO | `yoast/v1` | SEO meta / schema | Generates `yoast_head` in REST API |
| Yoast Duplicate Post | `duplicate-post/v1` | Content duplication workflow | |
| WP Smush | `wp-smush/v1` | Image compression | |
| Google Site Kit | `google-site-kit/v1` | GA4 + Search Console dashboard | Version 1.175.0 (from meta generator) |
| Simple Banner | — | Top-of-page announcement banners | Version 3.2.1 |
| Simple Lightbox | — | Image lightbox | Version 2.9.5 |
| GTranslate | — | Machine translation switcher | 15 languages configured |
| ACF (Advanced Custom Fields) | — | Custom fields (confirmed via `acf` key in REST responses) | Field groups in DB; JSON sync status unknown |

Also visible in the `riseboro` custom namespace, suggesting additional custom plugin or `functions.php` REST endpoint registrations.

---

## Custom Post Types (from REST API `/wp-json/wp/v2/types`)

| CPT Slug | REST Accessible | Notes |
|---|---|---|
| `event` | Yes | Events with ACF fields; example: "Prom Drive 2026" |
| `housing` | Yes | Housing listings; example: "Bethany Senior Terraces" |
| `successstory` | Yes | Success stories / testimonials |
| `news` | Yes | News posts |
| `newsletter` | Yes | Newsletters |
| `staff` | Yes | Staff directory; content + meta exposed publicly via REST |

All CPTs return `acf` key in REST responses (ACF REST integration active).

---

## Front-End JavaScript Libraries

| Library | Version (from query string) | Source | Notes |
|---|---|---|---|
| jQuery | 3.7.1 | `/wp-includes/js/` | Current |
| jQuery Migrate | 3.4.1 | `/wp-includes/js/` | Loaded in production — indicates deprecated jQuery usage in theme |
| GSAP | Unknown (ver param = 6.9.4 = WP ver) | Custom build in theme | Animation library |
| ScrollMagic | Unknown | Custom build in theme | Scroll-triggered animations |
| ScrollMagic `debug.addIndicators` | — | Custom build in theme | **Debug plugin loaded in production** |
| jquery.drum | Unknown | Custom build in theme | Number drum/slot animation |
| wp-emoji | 6.9.4 | WordPress core | Standard |

Custom theme JS modules (all from `/wp-content/themes/riseboro/build/js/`):

- `home.js`
- `pagetitle.js`
- `audience-select.js`
- `donate.js`
- `email-signup.js`
- `main.js`
- `successstory-gallery.js`
- `services-search.js`

---

## Third-Party Integrations

| Service | Identifier | Type | Notes |
|---|---|---|---|
| Google Tag Manager | GTM-WQCP8ZQ | Tag management | Fires GA4, UAv3, Ads, Facebook Pixel |
| Google Analytics 4 | G-1981Z91NNK | Analytics | Current standard |
| Universal Analytics (GA3) | UA-54060402-3 | Analytics | **Deprecated — Google sunset UA July 2023** |
| Google Ads Conversion | AW-940285834 | Advertising | Conversion tracking |
| Facebook Pixel | 492147728201296 | Advertising | Meta CAPI integration via GTM |
| Cloudflare RUM | `/cdn-cgi/rum` | Performance monitoring | Cloudflare Real User Monitoring |
| Cloudflare Insights | `beacon.min.js` | Analytics | |
| LiveRamp (liadm.com) | `idx.liadm.com` | Identity resolution | Cross-site audience matching for ad targeting |
| GTranslate | ID 51406871 | Translation | 15 languages: EN, ES, AR, ZH-CN, HE, JA, VI, KO, RU, NL, FR, DE, EL, IT, PT |
| Google Site Kit | — | Dashboard | Embeds GA4 + Search Console in WP admin |
| Swoogo Events | `riseboro.swoogo.com` | Event registration | External platform linked from banner |

---

## Content Model (publicly observable)

### Site Structure (from nav + URL inspection)

- **Divisions** (taxonomy or CPT): Seniors, Housing, Education, Health, Empowerment, Community — served at `/division/<slug>/`
- **Programs** — served at `/program/<slug>/` (individual program pages)
- **Events** — `/events/` archive + individual records
- **Housing** — `/housing/<slug>/` individual listings
- **Success Stories** — `/lives-changed/`
- **Staff** — `/board-staff/`
- **News / Press** — `/press-room/`

### Broken / Problematic URLs Observed

| URL | Issue |
|---|---|
| `/news/` | HTTP 500 — Critical WordPress error on archive page |
| `/?post_type=program&p=422` | Raw ID-based URL in nav (Caregiver Support link) — should have a slug |

---

## Security Observations

| Item | Status | Notes |
|---|---|---|
| `xmlrpc.php` | Blocked (403) | Good |
| `/wp-admin/` | Redirects to `/404/` | Blocked or obscured |
| REST API `/wp/v2/users` | Returns 401 | Good — user enumeration blocked |
| REST API CPT content | Accessible | Staff, housing, event, news data publicly readable |
| REST API namespaces | Publicly exposed | Reveals full plugin list |
| HSTS | `max-age=300` | Should be ≥31536000 (1 year) |
| WP version in `<meta>` | 6.9.4 | Exposed in HTML source |
| Plugin versions in asset URLs | `?ver=3.2.1`, `?ver=2.9.5` | Simple Banner and Simple Lightbox versions exposed |
| Local dev URL in JSON-LD | `riseboro.lndo.site` | Leaked in `thumbnailUrl` in structured data |

---

## SEO / Meta Issues

| Item | Value | Issue |
|---|---|---|
| `<meta name="keywords">` | `your, site, keywords, here` | Placeholder text — never updated |
| `<meta name="description">` | empty on homepage | No meta description on root page |
| Page title format | `RiseBoro \| Page title - RiseBoro` | Duplicate brand name in title |
