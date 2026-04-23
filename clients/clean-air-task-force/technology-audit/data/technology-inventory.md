# Technology Inventory — Clean Air Task Force

> **Audit date:** 2026-03-30
> **Source:** Front-end inspection only (no local/server access)
> **URL:** https://www.catf.us/

---

## 1. Platform & Hosting

| Item | Value |
|---|---|
| CMS | WordPress 6.9.1 |
| Hosting | WP Engine |
| CDN / Edge | Cloudflare (HTTP/3, `cfExtPri` server timing) |
| Asset CDN | `cdn.catf.us` (Cloudflare-proxied, serves `wp-content/uploads/`) |
| GTM Proxy | `load.gtm.catf.us` (server-side GTM container proxy) |
| SSL | Yes (HTTPS enforced, HSTS) |
| Protocol | HTTP/3 (h3) |

---

## 2. Theme

| Item | Value |
|---|---|
| Active theme | `catf-2021` (custom theme) |
| Theme version | 1.6.3 |
| Templating | PHP (standard WordPress templates) |
| Block editor | Yes — uses Gutenberg core blocks + custom ACF blocks |
| Fonts (preloaded) | TT Norms Pro (Normal, Bold, Italic, Bold Italic), Frank Ruhl Libre (Regular, 500) |
| Front-end JS | `theme.min.js`, a11y-dialog, Flickity (slider), Flickity Fade |
| CSS | `screen.min.css`, `ie.min.css`, `gravity-forms.min.css`, Flickity CSS |
| jQuery | 3.7.1 + jQuery Migrate 3.4.1 |

---

## 3. Custom Post Types (CPTs)

| CPT Slug | REST Base | Public | Notes |
|---|---|---|---|
| `post` | `posts` | Yes | Blog / news articles at `/YYYY/MM/slug/` |
| `page` | `pages` | Yes | Standard pages |
| `resource` | `resource` | Yes | Reports, fact sheets, filings, letters, etc. at `/resource/slug/` |
| `event` | `event` | Yes | Events |
| `expert` | — (not exposed in REST types) | Yes | Staff profiles at `/experts/slug/` |
| `bio` | — (not exposed in REST types) | Unclear | May be legacy or board member profiles |
| `declaration` | — (referenced by taxonomy only) | Unclear | Country declarations; has own taxonomies |

---

## 4. Taxonomies

| Taxonomy Slug | Name | Applies To | Example Terms |
|---|---|---|---|
| `category` | Categories | post, resource, expert | Policy, Technology, Electricity, Infrastructure, News & Media |
| `post_tag` | Tags | post, resource | — |
| `work_area` | Work Areas | resource, post | Advanced Nuclear (ID 428), Carbon Capture, Hydrogen, etc. |
| `region` | Regions | resource, post | U.S., Europe, Africa, MENA |
| `resource_type` | Resource Type | resource | Comments, Fact Sheet, Filing, Letter, Presentation, Reports & Papers, Testimony |
| `team` | Teams | expert, bio | — |
| `featured_event` | Featured? | event | — |
| `event_category` | Event Categories | event | — |
| `declaration-country` | Declaration Countries | declaration | — |
| `declaration-topic` | Declaration Topics | declaration | — |

---

## 5. ACF Blocks (Custom Gutenberg Blocks)

All blocks are prefixed `acf-block-`. These are registered via Advanced Custom Fields and require ACF Pro with the block registration feature.

| Block Slug | Observed On | Description |
|---|---|---|
| `acf-block-hero-slider` | Homepage | Full-width hero carousel with background video/images, overlay text, CTAs |
| `acf-block-page-section` | Homepage, blog posts, program pages, resources | Flexible content section with background image/color and inner container |
| `acf-block-featured-posts` | Homepage | Grid of latest posts with category, title, date |
| `acf-block-logo-grid` | Homepage | Grid of partner/certification logos |
| `acf-block-side-image-text` | Program pages | Two-column layout: image + text with CTA |
| `acf-block-post-slider` | Program pages | Horizontal card slider of posts filtered by work area |
| `acf-block-tabbed-content` | Program pages | Tab UI for goals/achievements content |
| `acf-block-resource-slider` | Program pages, resources page | Horizontal slider of resource cards |
| `acf-block-bio-tiles` | Program pages | Grid of expert profile tiles with photo, name, title |

---

## 6. Plugins (Detected)

| Plugin | Version | Purpose | Hard Dependency? |
|---|---|---|---|
| **Advanced Custom Fields (ACF) Pro** | Unknown (blocks present) | Custom fields, ACF blocks, options pages | **Hard** — powers all custom blocks and likely CPT fields |
| **Gravity Forms** | 2.8.18 | Newsletter signup form (bottom of blog posts) | **Hard** — forms with reCAPTCHA |
| **Yoast SEO** | Unknown | SEO meta, Open Graph, Twitter Cards, XML sitemaps, JSON-LD | **Hard** — all SEO meta |
| **Schema Pro** | 2.7.23 | Additional structured data (JSON-LD) | Soft — supplements Yoast |
| **APM WP Pardot** | 1.0.0 | Pardot form embedding via iFrame Resizer | **Hard** — marketing automation forms |
| **Cloudflare** | Unknown | Email obfuscation (`email-decode.min.js`), performance | Soft |
| **Cookie Script** | N/A (external) | GDPR/cookie consent banner (`ca-eu.cookie-script.com`) | **Hard** — EU compliance |
| jQuery Migrate | 3.4.1 (WP core) | Legacy jQuery compatibility | Loaded by WP core |

### Plugins Inferred but Not Directly Confirmed

| Likely Plugin | Evidence |
|---|---|
| Custom Post Type registration plugin or theme `functions.php` | CPTs `resource`, `event`, `expert`, `bio`, `declaration` exist |
| Redirect plugin (Redirection, Safe Redirect Manager, etc.) | Typical for WP Engine sites; not confirmed from front-end |
| WP Engine-specific mu-plugins | Standard on WP Engine hosting |

---

## 7. Third-Party Integrations & Scripts

### Tag Management

| Service | ID / Details |
|---|---|
| Google Tag Manager (GTM) | `GTM-5HSWVB5` — loaded via server-side proxy at `load.gtm.catf.us` |

### Analytics

| Service | ID / Details |
|---|---|
| Google Analytics 4 (GA4) | `G-88025VJ2M0` |
| Microsoft Clarity | `cs6tejz2qz` |

### Advertising / Conversion Tracking

| Service | ID / Details |
|---|---|
| Google Ads | `AW-314602869` |
| Google DV360 / Campaign Manager (Floodlight) | `DC-16485908` (activity tag: `src=16485908;type=invmedia;cat=catf-00`) |
| Facebook Pixel | `1235730240390610` |
| LinkedIn Insight | Partner ID `3995433` |
| Twitter/X Pixel | `o6zaj` |
| Reddit Pixel | `t2_gt8hjy23` (PageVisit, SignUp, Purchase events) |
| Microsoft UET (Bing Ads) | `97034119` |
| StackAdapt | `SeILt3n3fz62zaCyWqZ9hT` |
| Growth Channel | `b408a5db-19a7-4750-9c72-34d660210474` |
| MediaMath | `mt_id=2412250`, `mt_adid=432964` |

### Marketing Automation

| Service | Details |
|---|---|
| Salesforce Pardot | Account ID `909262`, Campaign ID `9046`, host `pi.pardot.com`; iFrame Resizer for embedded forms |

### Consent Management

| Service | Details |
|---|---|
| Cookie Script | External script `ca-eu.cookie-script.com`, config ID `f9381cc175438d4f5eec179f05a8d614` |
| Consent mode | GTM consent defaults: `ad_storage: denied`, `analytics_storage: denied`, `wait_for_update: 500` |

### Social / Embeds

| Integration | Details |
|---|---|
| YouTube | Embedded via `youtube-nocookie.com` (privacy-enhanced), YouTube IFrame API |
| Facebook domain verification | `g7mvq0hjxkzfpu4qg4dyx1y5w8mit9` |
| Social sharing | Custom share links (LinkedIn, Twitter/X, Facebook) on blog posts |
| Social profiles | LinkedIn, Twitter/X, Instagram, Facebook, YouTube (footer links) |

### External Platforms

| Platform | URL | Purpose |
|---|---|---|
| Donation platform | `give.catf.us` | Fundraising / donation processing (external) |
| CATF Action | `catfaction.org` | Companion advocacy site |

---

## 8. URL Structure

| Content Type | URL Pattern | Example |
|---|---|---|
| Homepage | `/` | `catf.us/` |
| Blog posts | `/YYYY/MM/slug/` | `/2026/03/maintaining-momentum-…/` |
| Pages | `/slug/` or `/parent/slug/` | `/about/`, `/work/`, `/the-latest/` |
| Program (work area) pages | `/work/slug/` or `/slug/program/` | `/work/advanced-nuclear-energy/`, `/carbon-capture/program/` |
| Resources | `/resource/slug/` | `/resource/clean-firm-electricity-technologies-why-what-how/` |
| Resource type archive | `/resource_type/slug/` | `/resource_type/fact-sheet/` |
| Resource archive/search | `/resource-archive/` | — |
| Experts | `/experts/slug/` | `/experts/armond-cohen/` |
| Expert content listing | `/content-by/slug/` | `/content-by/dan-west/` |
| Category archive | `/category/slug/` | `/category/policy/` |
| Work area archive | `/?cat_filter=&area_filter=ID&...` | Query-string filtered archive |
| Regional pages | `/us/`, `/europe/`, `/africa/`, `/mena/` | Top-level regional landing pages |
| Search | `/?s=query` | Default WP search |
| Donation | `give.catf.us/campaign/756949/donate` | External |
| Timeline | `/timeline/` | Interactive history timeline |

---

## 9. Content Delivery & Performance

| Item | Value |
|---|---|
| Page transfer size (homepage) | ~17 KB (compressed) / ~89 KB (decoded) |
| DOM content loaded | < 1 ms |
| Full page load | ~257 ms |
| Compression | Brotli/gzip via Cloudflare |
| Speculative prefetch | Document-level prefetch rules present (excludes WP admin, uploads, plugins) |
| Video | Background hero video served from `cdn.catf.us` (partial range requests) |
| Images | Served from `cdn.catf.us`, standard WP image sizes |
| WP emoji | Disabled (not loaded) |

---

## 10. Schema / Structured Data

| Type | Source |
|---|---|
| WebPage, Organization, WebSite | Yoast SEO (JSON-LD) |
| SiteNavigationElement | Schema Pro or Yoast (JSON-LD, navigation items) |
| Open Graph (og:*) | Yoast SEO |
| Twitter Cards | Yoast SEO |

---

## 11. Accessibility Features (Observed)

| Feature | Details |
|---|---|
| Skip to content | `<a href="#main">Skip to main content</a>` |
| a11y-dialog | Accessible modal/dialog library included |
| ARIA landmarks | `<nav>`, `<main>`, `<footer>` with roles |
| WP a11y script | `wp-includes/js/dist/a11y.min.js` loaded |
