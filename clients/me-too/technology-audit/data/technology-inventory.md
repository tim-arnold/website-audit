# Technology Inventory — me too. International

**Collected:** 2026-03-25
**Source:** Live site (https://metoomvmt.org) — no local repo access
**Method:** HTML source inspection, WP REST API, sitemaps, network requests

---

## Platform

| Component | Value | Notes |
|---|---|---|
| CMS | WordPress | 6.9.4 |
| Hosting | WPEngine | Per client context |
| CDN / Security | Cloudflare | Challenge platform visible in network requests (`/cdn-cgi/`) |
| Theme | `metoo` | Custom theme, slug `metoo`, located at `wp-content/themes/metoo/` |
| REST API | Exposed publicly | `/wp-json/wp/v2/` returns post types, pages, etc. |
| xmlrpc.php | Exposed | `xmlrpc.php?rsd` in `EditURI` link header |

---

## WordPress Core

| Component | Installed | Notes |
|---|---|---|
| WordPress | 6.9.4 | Current as of audit date |
| PHP | Unknown | No local access |
| Database | Unknown | No local access |

---

## Custom Post Types

Derived from sitemap index entries at `/sitemap_index.xml`.

| CPT Slug | Name | Archive | Taxonomy/ies | Last Updated |
|---|---|---|---|---|
| `post` | Posts (Blog) | No | `post_tag` | 2021-12-09 — stale |
| `page` | Pages | No | — | 2026-03-03 |
| `tellingourtruths` | Telling Our Truths | Yes | `category` | 2020-12-09 — stale |
| `press` | Press | Unknown | Unknown | 2026-02-24 — active |
| `healingtoolkits` | Healing Toolkits | Unknown | Unknown | 2026-02-24 — active |
| `actiontoolkits` | Action Toolkits | Unknown | Unknown | 2025-02-27 — active |
| `statistics` | Statistics | Unknown | `statcategory` | 2021-01-05 — stale |
| `glossary` | Glossary | Unknown | `alphabet` | 2020-06-03 — stale |
| `research` | Research | Unknown | `researchtype` | 2020-11-18 — stale |
| `survivorinfosheets` | Survivor Info Sheets | Unknown | Unknown | 2020-07-23 — stale |
| `partners` | Partners | Unknown | Unknown | 2022-10-18 |
| `organizations` | Organizations | Unknown | Unknown | 2022-10-21 |
| `hotlines` | Hotlines | Unknown | `hotlinetype` | 2021-09-08 — stale |
| `mediakit` | Media Kit | Unknown | `mediatype` | 2022-10-25 |
| `team` | Team | Unknown | `teamcategory` | 2025-01-29 — active |
| `sources` | Sources | Unknown | Unknown | 2025-09-04 — active |
| `news` | News | Unknown | Unknown | 2025-09-04 — active |

> "Stale" = last updated before 2023; likely not actively managed. These CPTs still have live URLs and must be preserved in any migration.

---

## Custom Taxonomies

| Taxonomy Slug | Used By CPT | Notes |
|---|---|---|
| `statcategory` | `statistics` | |
| `alphabet` | `glossary` | Likely A–Z index for glossary browsing |
| `researchtype` | `research` | |
| `hotlinetype` | `hotlines` | |
| `mediatype` | `mediakit` | |
| `teamcategory` | `team` | |
| `category` | `tellingourtruths` | Shared WP category taxonomy |

---

## Plugins (Visible from Frontend)

| Plugin | Detected Version | Purpose | Notes |
|---|---|---|---|
| Yoast SEO | Unknown | SEO, sitemap, robots.txt | Generates sitemap_index.xml; manages robots.txt |
| Search & Filter | Unknown | Resource library filtering | `search-filter/style.css` enqueued |
| Page Links To | 3.3.7 | Redirect pages to external URLs | `page-links-to/dist/new-tab.js` |
| WP Emoji | Bundled with WP | Emoji handling | Standard WP include |

---

## Third-Party Scripts & Integrations

| Integration | Identifier | Purpose | Status |
|---|---|---|---|
| Google Tag Manager | GTM-KQP8P9F | Tag container | Active |
| Google Analytics 4 | G-6KC69QR6DN | GA4 property | Active |
| Google Analytics (UA) | UA-147537261-2 | Universal Analytics | **Dead** — UA sunset July 2023 |
| Hotjar | Site ID 1836662 | Session recording / heatmaps | Active |
| Salesforce NPSP | `metoointernationalnpc.my.salesforce-sites.com` | Newsletter signup (Lightning Out component `c:NewsletterSignupOut`) | Active |
| Font Awesome | Kit `188510237f` | Icon library | **Broken** — 403 on kit load |
| Google Fonts | Just Another Hand | Decorative typeface | Active |
| ACSBApp | `cdn.acsbapp.com` / `acsbapp.com/apps/app/` | Accessibility overlay widget | Active |

---

## JavaScript Libraries (Theme-Bundled)

| Library | Version | Source | Notes |
|---|---|---|---|
| jQuery | 3.6.0 | cdn.jquery.com | |
| jQuery | 3.2.1 | ajax.googleapis.com | **Duplicate — loaded twice** |
| Slick Carousel | 1.8.1 | CDN (jsdelivr) | Used in homepage carousel |
| Owl Carousel | Unknown | Theme (`metoo/js/scripts/`) | Used in some page sections |
| Masonry | Unknown | Theme (`metoo/js/scripts/`) | Grid layout |
| jQuery Validate | Unknown | Theme | Form validation |
| jQuery Mask | Unknown | Theme | Input masking |
| Lightbox | Unknown | Theme | Image lightbox |

---

## CSS Assets

| File | Status |
|---|---|
| `metoo/css/main.css` | 200 OK |
| `metoo/css/lightbox.min.css` | **404 Not Found** |
| `metoo/js/scripts/owl-slider/owl.carousel.min.css` | 200 OK |
| Slick Carousel (CDN) | 200 OK |
| Slick Carousel theme (CDN) | 200 OK |
| Salesforce NPSP newsletter | 200 OK |

---

## Subdomains

| Subdomain | Purpose | Notes |
|---|---|---|
| `sanctuary.metoomvmt.org` | Survivor's Sanctuary — 36 self-guided digital healing modules | Separate app, not WordPress |

---

## URL Structure (From Sitemaps)

- Standard WordPress permalink structure
- CPTs use their slug as URL prefix: e.g., `/press/`, `/team/`, `/news/`
- Pages use hierarchical structure: e.g., `/explore-healing/resource-library/`, `/get-to-know-us/contact-us`
- Blog posts not actively updated since 2021; accessible at `/post-slug/`

---

## Security / Infrastructure Signals

| Signal | Detail |
|---|---|
| Cloudflare | Challenge platform visible; CDN in use |
| `xmlrpc.php` | Exposed via `EditURI` link header — attack surface |
| WP REST API | Public; exposes post type list, page content, author IDs |
| ACSBApp overlay | Third-party JS with DOM access |

---

## Console Errors (Live Site)

| Error | Impact |
|---|---|
| `lightbox.min.css` 404 | Missing CSS — any lightbox components may be unstyled |
| Font Awesome kit 403 | All Font Awesome icons broken |
| Salesforce Lightning preload warnings (multiple) | Performance — eager preload of LWC resources |
