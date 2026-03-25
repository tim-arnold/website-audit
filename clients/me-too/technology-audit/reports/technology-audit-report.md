# Technology Audit Report — me too. International

**Audited:** 2026-03-25
**Site:** https://metoomvmt.org
**Source:** Live site only — no local repo or WPEngine access
**Prepared for:** Dev team (pre-redesign)

> **Scope note:** This audit is front-end only. All findings are derived from public HTML, the WP REST API, sitemaps, and network requests. Server-side code, database, build configuration, and environment variables cannot be assessed without source or admin access. Gaps are flagged below.

---

## Executive Summary

- **WordPress 6.9.4** on WPEngine, behind Cloudflare, with a custom theme named `metoo`. No block editor (FSE) — appears to be a classic PHP theme.
- **17 custom post types** covering content, resource library entries (organizations, hotlines), toolkits, team, press, and more. Several CPTs haven't been updated since 2020–2021 but have live URLs that must be preserved.
- **Salesforce NPSP** is deeply integrated via Lightning Out for newsletter signup — requires Salesforce org credentials and the `metoointernationalnpc` site to remain active during and after migration.
- **Two active analytics tracking IDs** — GA4 (active) and Universal Analytics (dead since July 2023; property still fires but receives no data). UA tag should be removed.
- **Three broken assets on every page load:** Font Awesome Kit (403), `lightbox.min.css` (404), and jQuery loaded twice in two different versions. These are current production issues, not migration risks.
- **Survivor's Sanctuary** (`sanctuary.metoomvmt.org`) is a separate, non-WordPress application — out of scope for this audit but must be accounted for in DNS and migration planning.
- **`xmlrpc.php` and the WP REST API are publicly accessible** — standard WP exposure, but worth locking down during hardening.

---

## Architecture

**Stack:**
- CMS: WordPress 6.9.4
- Hosting: WPEngine
- CDN / DDoS protection: Cloudflare
- Theme: Custom PHP theme (`wp-content/themes/metoo/`) — classic (non-FSE)
- No headless layer; server-rendered HTML

**Content authoring:** WordPress admin

**No build pipeline visible** from the frontend. No webpack/Vite fingerprints. Theme JS and CSS appear to be hand-bundled vendor files concatenated into `main.js` and `main.css`.

---

## Content Model

### Custom Post Types

The site has **16 custom post types** beyond standard `post` and `page`. Several are the backbone of the resource library and healing tools; several others are stale editorial CPTs not updated since 2020.

**Active CPTs (updated 2024+):**

| CPT | Purpose | Last Updated |
|---|---|---|
| `page` | Standard WP pages | 2026-03-03 |
| `press` | Press releases | 2026-02-24 |
| `healingtoolkits` | Healing toolkit resources | 2026-02-24 |
| `team` | Staff / team members | 2025-01-29 |
| `sources` | Source citations (likely for statistics/research pages) | 2025-09-04 |
| `news` | News articles | 2025-09-04 |
| `actiontoolkits` | Action toolkit resources | 2025-02-27 |

**Stale CPTs (last updated 2020–2022; live URLs, must preserve):**

| CPT | Last Updated | Notes |
|---|---|---|
| `post` (Blog) | 2021-12-09 | Standard WP posts; appears abandoned as editorial channel |
| `tellingourtruths` | 2020-12-09 | Survivor stories; has its own sitemap and category taxonomy |
| `statistics` | 2021-01-05 | Statistics with `statcategory` taxonomy |
| `glossary` | 2020-06-03 | Glossary terms with `alphabet` taxonomy (A–Z index) |
| `research` | 2020-11-18 | Research content with `researchtype` taxonomy |
| `survivorinfosheets` | 2020-07-23 | Info sheets for survivors |
| `partners` | 2022-10-18 | Partner organizations |
| `organizations` | 2022-10-21 | Resource library organizations |
| `hotlines` | 2021-09-08 | Hotlines with `hotlinetype` taxonomy |
| `mediakit` | 2022-10-25 | Press/media kit with `mediatype` taxonomy |

> Many stale CPTs are core resource library content that users still find via search. All URLs must redirect correctly in any rebuild.

### Custom Taxonomies

| Taxonomy | Used By | Notes |
|---|---|---|
| `statcategory` | `statistics` | |
| `alphabet` | `glossary` | A–Z browsing index |
| `researchtype` | `research` | |
| `hotlinetype` | `hotlines` | |
| `mediatype` | `mediakit` | |
| `teamcategory` | `team` | |
| `category` | `tellingourtruths` | Shared WP taxonomy |

### Resource Library

The `/explore-healing/resource-library/` page uses the **Search & Filter** plugin to filter across resource types (Hotline, In-Person, Online Chat, Digital Self-help). This filtering logic and its underlying taxonomy structure must be replicated in any new CMS.

---

## Plugins

Only frontend-visible plugins can be confirmed. Server-side plugins are undetectable without admin access.

| Plugin | Version | Purpose | Migration Notes |
|---|---|---|---|
| Yoast SEO | Unknown | SEO, XML sitemaps, robots.txt | Redirect rules and SEO meta stored in DB — must export |
| Search & Filter | Unknown | Resource library filtering | DB-stored filter configs — must export or rebuild |
| Page Links To | 3.3.7 | Redirect pages to external URLs | DB-stored — must export redirect mappings |

---

## Third-Party Integrations

### Analytics & Tag Management

| Tool | ID / Detail | Status | Action |
|---|---|---|---|
| Google Tag Manager | GTM-KQP8P9F | Active | Carry over container to new site |
| Google Analytics 4 | G-6KC69QR6DN | Active | Carry over via GTM |
| Universal Analytics | UA-147537261-2 | **Dead** — UA sunset July 2023 | Remove from GTM |
| Hotjar | Site ID 1836662 | Active | Carry over; confirm account ownership |

> UA is firing pageview hits on every load but the property no longer receives data. Remove from GTM to reduce tag bloat.

### Newsletter / CRM

| Tool | Detail | Status |
|---|---|---|
| Salesforce NPSP | `metoointernationalnpc.my.salesforce-sites.com` — Lightning Out component `c:NewsletterSignupOut` | Active |

The newsletter signup form is rendered via Salesforce's **Lightning Out** framework — a Salesforce-hosted Aura component embedded on the WordPress site via JS. This is a tight integration: the component lives in Salesforce, not in WordPress. During a rebuild:
- The component URL must remain accessible (no Salesforce credential changes during cutover)
- The new site must include the same Lightning Out JS embed pattern
- Confirm with Salesforce admin whether the `metoointernationalnpc` Experience Cloud site is managed separately

### Accessibility

| Tool | Detail | Notes |
|---|---|---|
| ACSBApp | Accessibility overlay widget (`cdn.acsbapp.com`) | Third-party overlay; see accessibility audit for evaluation |

### Icons / Fonts

| Tool | Detail | Status |
|---|---|---|
| Font Awesome | Kit `188510237f` (kit.fontawesome.com) | **Broken — 403 on every page load** |
| Google Fonts | Just Another Hand | Active |

> Font Awesome is completely broken. All FA icons on the current site are invisible or falling back to text. This must be fixed before launch on any rebuild — or replaced with a self-hosted icon solution.

---

## JavaScript & Dependencies

### Duplicate jQuery

jQuery is loaded **twice**, from two different sources and versions:
1. `https://cdn.jquery.com/jquery-3.6.0.min.js`
2. `https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js`

This causes the second load to overwrite the first and can cause plugin conflicts. One must be removed.

### Theme JS Libraries

The `metoo` theme bundles several vendored libraries:

| Library | Notes |
|---|---|
| Owl Carousel | Slider component |
| jQuery Mask | Input masking |
| Masonry | Grid layout |
| jQuery Validate | Client-side form validation |
| jQuery Validate Additional Methods | Extra validation rules |
| Lightbox | Image lightbox (CSS **404** on every load) |

> `lightbox.min.css` returns 404 on every page — the CSS file is missing from the theme. The lightbox JS is loaded but unstyled.

### CDN Libraries (not bundled)

| Library | Version | Source |
|---|---|---|
| Slick Carousel | 1.8.1 | jsdelivr CDN |

---

## Subdomains & Separate Properties

| URL | Purpose | Notes |
|---|---|---|
| `sanctuary.metoomvmt.org` | Survivor's Sanctuary — 36 self-guided digital healing modules | Separate application, not WordPress; out of scope for this audit but must be preserved in DNS |

---

## Security & Infrastructure

| Finding | Detail | Risk |
|---|---|---|
| `xmlrpc.php` exposed | Discoverable via `EditURI` link header on every page | Medium — brute force / DDoS amplification target; disable if not needed |
| WP REST API public | `/wp-json/wp/v2/` exposes post types, page content, author info | Low–Medium — standard WP; restrict if sensitive content types exist |
| Cloudflare active | Challenge platform in use | Positive — DDoS mitigation in place |
| ACSBApp third-party JS | Full DOM access via overlay script | Low — confirm vendor trust; third-party breach would affect users |

> Security depth (plugin versions, PHP version, WPEngine config, .htaccess, admin access controls) cannot be assessed from the frontend. A full security audit requires admin or filesystem access.

---

## Broken Assets (Current Production Issues)

These are bugs on the live site today, not migration risks:

| Issue | Details | Fix |
|---|---|---|
| Font Awesome Kit 403 | `kit.fontawesome.com/188510237f.js` returns 403 — all FA icons broken | Regenerate or replace the kit; or switch to self-hosted SVGs |
| `lightbox.min.css` 404 | Missing CSS file — lightbox is JS-only, unstyled | Restore missing file from backup or theme source |
| jQuery loaded twice | Versions 3.6.0 and 3.2.1 both enqueued | Remove one; standardize on a single version |
| UA tag still firing | UA-147537261-2 sends hits but property is dead | Remove from GTM |

---

## Migration Checklist

### Before Decommissioning the Current Site

- [ ] Full WordPress database export (all tables)
- [ ] Yoast SEO redirect rules export (stored in DB)
- [ ] Search & Filter plugin configuration export
- [ ] Page Links To redirect mappings export
- [ ] All CPT content exported — especially stale CPTs (`statistics`, `glossary`, `research`, `survivorinfosheets`, `tellingourtruths`, `hotlines`)
- [ ] Media library (`wp-content/uploads/`) — full export
- [ ] Custom theme source (`wp-content/themes/metoo/`) — full backup
- [ ] All active plugin files backed up
- [ ] WPEngine environment variables and `.htaccess` rules documented
- [ ] Cloudflare DNS records documented before any DNS changes
- [ ] Salesforce NPSP integration documented — contact Salesforce admin for `metoointernationalnpc` org credentials
- [ ] Hotjar account ownership confirmed

### Redirect Strategy Requirements

All 17 CPT URL patterns must have 1:1 redirects or equivalent content in the new system:
- `/press/*`, `/team/*`, `/news/*`, `/healingtoolkits/*`, `/actiontoolkits/*`, `/sources/*`
- `/tellingourtruths/*`, `/statistics/*`, `/glossary/*`, `/research/*`
- `/survivorinfosheets/*`, `/partners/*`, `/organizations/*`, `/hotlines/*`, `/mediakit/*`
- All page hierarchies (e.g., `/explore-healing/resource-library/`, `/take-action/*`)

### What Cannot Be Assessed Without Source Access

- PHP version and server configuration
- Full plugin list and versions
- ACF or other field group definitions
- Database size and table structure
- WPEngine-specific config (PHP settings, cache rules, protected paths)
- Build process for theme CSS/JS
- Environment variables and API keys
- Any wp-config.php non-default settings
