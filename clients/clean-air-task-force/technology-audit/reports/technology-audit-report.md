# Technology Audit Report — Clean Air Task Force

> **Audit date:** 2026-03-30
> **Auditor:** Front-end inspection (no server/source access)
> **Site URL:** https://www.catf.us/
> **CMS:** WordPress 6.9.1
> **Hosting:** WP Engine + Cloudflare CDN

---

## Executive Summary

1. **WordPress 6.9.1 on WP Engine** with Cloudflare CDN (HTTP/3). The stack is modern and well-maintained — WP core is current, hosting is enterprise-grade, and edge delivery is fast (~257 ms full page load).

2. **Custom theme `catf-2021` (v1.6.3)** built on the Gutenberg block editor with **9+ custom ACF blocks** (hero slider, page sections, post sliders, tabbed content, resource sliders, bio tiles, etc.). ACF Pro is the single most critical dependency — it powers both the block system and likely all custom field data.

3. **5 custom post types** beyond posts/pages: `resource`, `event`, `expert`, `bio`, and `declaration`. These are supported by **7 custom taxonomies** including `work_area`, `region`, `resource_type`, `team`, and declaration-specific taxonomies. The content model is rich and purpose-built.

4. **Heavy third-party integration layer** managed through GTM (server-side proxied at `load.gtm.catf.us`): GA4, Google Ads, DV360/Floodlight, Facebook, LinkedIn, Twitter/X, Reddit, Bing, StackAdapt, Growth Channel, MediaMath, and Microsoft Clarity. All ad pixels fire through GTM with consent mode gating via Cookie Script.

5. **Salesforce Pardot** is the marketing automation platform, embedded via iFrame Resizer. **Gravity Forms 2.8.18** handles on-site forms (newsletter signup with reCAPTCHA). Donations are handled externally at `give.catf.us`.

6. **SEO is managed by Yoast SEO + Schema Pro 2.7.23**, producing Open Graph, Twitter Cards, and JSON-LD structured data (Organization, WebPage, SiteNavigationElement).

7. **URL structure is non-trivial** — blog posts use `/YYYY/MM/slug/`, programs use inconsistent patterns (`/work/slug/` vs `/slug/program/`), resources use `/resource/slug/`, and experts use `/experts/slug/`. A comprehensive redirect map is essential.

8. **No source access was available** — dependency versions, build pipeline, server-side logic, ACF field group definitions, and hardcoded credentials could not be assessed. A follow-up filesystem audit is strongly recommended.

---

## Architecture Overview

### Stack

| Layer | Technology |
|---|---|
| CMS | WordPress 6.9.1 (monolithic, server-rendered) |
| Hosting | WP Engine (managed WordPress) |
| CDN | Cloudflare (HTTP/3, Brotli compression) |
| Asset CDN | `cdn.catf.us` (Cloudflare-proxied subdomain for uploads) |
| Theme | `catf-2021` v1.6.3 (custom PHP theme) |
| Block editor | Gutenberg + ACF Pro custom blocks |
| Front-end JS | jQuery 3.7.1, Flickity slider, a11y-dialog |
| Fonts | TT Norms Pro (4 weights), Frank Ruhl Libre (2 weights) — self-hosted |

### Architecture Type

Traditional WordPress monolith — server-rendered PHP, no headless/decoupled layer detected. The WP REST API is active at `/wp-json/` but appears to be used only for internal/admin purposes, not as a public content API.

---

## Content Model

### Custom Post Types

| CPT | URL Pattern | Description |
|---|---|---|
| `post` | `/YYYY/MM/slug/` | Blog articles, policy analysis, news |
| `page` | `/slug/` or nested | Static pages, program landing pages, regional pages |
| `resource` | `/resource/slug/` | Reports, fact sheets, filings, letters, presentations, testimony |
| `event` | `/event/slug/` (assumed) | Events — has category and featured taxonomies |
| `expert` | `/experts/slug/` | Staff profiles with photo, title, bio, linked posts |
| `bio` | Unknown | Possibly board members or non-expert profiles |
| `declaration` | Unknown | Country/topic declarations — has dedicated taxonomies |

### Key Taxonomies

| Taxonomy | Used By | Purpose |
|---|---|---|
| `category` | Posts, resources, experts | Primary content classification (Policy, Technology, Electricity, etc.) |
| `work_area` | Posts, resources | Program area tagging (Advanced Nuclear, Carbon Capture, etc.) |
| `region` | Posts, resources | Geographic region (U.S., Europe, Africa, MENA) |
| `resource_type` | Resources | Document type (Comments, Fact Sheet, Filing, Letter, Presentation, Reports & Papers, Testimony) |
| `team` | Experts, bios | Staff team grouping |

### Content Authoring

- Content is authored via the WordPress block editor (Gutenberg)
- Custom ACF blocks provide the page-building UI — editors compose pages from hero sliders, page sections, side-image-text blocks, post/resource sliders, tabbed content, bio tiles, and logo grids
- Blog posts use standard WordPress editor with ACF page-section wrappers
- Expert profiles link to authored content via `/content-by/slug/` archives

### What Must Be Exported

- Full MySQL database (all post types, postmeta, options, term relationships)
- ACF field group definitions (check if JSON-synced to theme or DB-only)
- Media library (`wp-content/uploads/` — served via `cdn.catf.us`)
- Gravity Forms definitions and entry data
- Pardot form configurations and integration credentials
- Any ACF options page values (global settings, GTM ID, etc.)

---

## Third-Party Integrations

### Analytics & Tag Management

| Service | Identifier | Managed Via |
|---|---|---|
| Google Tag Manager | `GTM-5HSWVB5` | Server-side proxy at `load.gtm.catf.us` |
| Google Analytics 4 | `G-88025VJ2M0` | GTM |
| Microsoft Clarity | `cs6tejz2qz` | GTM |

### Advertising Pixels

| Platform | Identifier | Notes |
|---|---|---|
| Google Ads | `AW-314602869` | Conversion tracking |
| DV360 / Campaign Manager | `DC-16485908` | Floodlight tag (invmedia activity) |
| Facebook Pixel | `1235730240390610` | PageView events |
| LinkedIn Insight | Partner ID `3995433` | Attribution + collect |
| Twitter/X Pixel | `o6zaj` | Pageview events |
| Reddit Pixel | `t2_gt8hjy23` | PageVisit, SignUp, Purchase |
| Bing UET | `97034119` | Conversion tracking |
| StackAdapt | `SeILt3n3fz62zaCyWqZ9hT` | Retargeting |
| Growth Channel | `b408a5db-19a7-4750-…` | Tracking pixel |
| MediaMath | `mt_id=2412250` | Conversion pixel |

### Marketing Automation

| Service | Details |
|---|---|
| Salesforce Pardot | Account `909262`, Campaign `9046`; embedded forms via `apm-wp-pardot` plugin with iFrame Resizer |

### Forms

| Service | Details |
|---|---|
| Gravity Forms | v2.8.18; newsletter signup form on blog posts with reCAPTCHA |
| Pardot forms | Embedded via iframe on sign-up and other pages |

### Consent Management

| Service | Details |
|---|---|
| Cookie Script | External script from `ca-eu.cookie-script.com`; GTM consent mode defaults to denied for `ad_storage` and `analytics_storage` with 500 ms wait |

### External Platforms

| Platform | URL | Notes |
|---|---|---|
| Donation platform | `give.catf.us` | External fundraising system — requires credential carry-over |
| CATF Action | `catfaction.org` | Companion advocacy/lobbying site |
| YouTube | `youtube-nocookie.com` embeds | Privacy-enhanced mode |

---

## Custom Functionality

### ACF Blocks (Gutenberg)

The site uses **9 identified custom ACF blocks** that form the primary page-building system:

| Block | Purpose |
|---|---|
| `acf-block-hero-slider` | Homepage hero with background video, image slides, overlay text |
| `acf-block-page-section` | Flexible content section (background image/color, inner container) |
| `acf-block-featured-posts` | Post grid with category, title, date |
| `acf-block-side-image-text` | Two-column image + text with CTA |
| `acf-block-post-slider` | Horizontal post card carousel (filtered by work area) |
| `acf-block-tabbed-content` | Tab UI (used for goals/achievements on program pages) |
| `acf-block-resource-slider` | Horizontal resource card carousel |
| `acf-block-bio-tiles` | Expert profile grid with photos |
| `acf-block-logo-grid` | Partner/certification logo grid |

These blocks are the primary editorial building blocks. Every page uses some combination of them. They must be replicated or replaced with equivalent components in a rebuild.

### Search

WordPress default search (`/?s=query`). No evidence of Algolia, ElasticSearch, or other enhanced search.

### Regional Content

The site has top-level regional landing pages (`/us/`, `/europe/`, `/africa/`, `/mena/`) linked from the header nav. Content appears to be filtered by the `region` taxonomy. The regional navigation is a secondary nav bar below the main nav.

### Social Sharing

Custom social share links on blog posts (LinkedIn, Twitter/X, Facebook) using share URL APIs. Not a plugin — likely theme-implemented.

### Author Pages

Custom author archive at `/content-by/slug/` rather than the default WordPress `/author/slug/` pattern. This is a custom URL rewrite.

### Speculative Navigation

The site implements the Speculation Rules API for document-level prefetching, excluding WP admin, uploads, plugins, and nofollow links.

---

## What to Drop

| Item | Reason |
|---|---|
| jQuery Migrate 3.4.1 | Legacy compatibility shim — unnecessary in a modern build |
| `ie.min.css` | IE-specific stylesheet — IE is end-of-life |
| Flickity slider | GPL-licensed, no longer actively maintained — replace with modern alternative |
| iFrame Resizer warnings | 4 console warnings per page load from Pardot plugin — review if all iframes are necessary |
| MediaMath pixel | Verify if still in active use — MediaMath filed for bankruptcy in 2023 |

---

## Gaps (No Source Access)

The following could not be assessed without filesystem or admin access:

| Gap | Impact |
|---|---|
| ACF field group definitions | Cannot document field types, flexible content layouts, or options pages |
| ACF field group storage | Unknown if JSON-synced to theme or DB-only — critical for migration |
| `functions.php` and `inc/` | Cannot review CPT/taxonomy registration, custom queries, URL rewrites, hooks |
| Plugin list (full) | Only detected plugins with front-end footprint; admin-only plugins are invisible |
| Redirect rules | No way to detect redirect plugin or `.htaccess` / WP Engine redirect rules |
| Build pipeline | No `package.json`, `composer.json`, or build config visible |
| Environment variables | Cannot check for hardcoded credentials or config |
| Database schema | Cannot inspect custom tables from form plugins or other data stores |
| Server-side caching | WP Engine likely uses object caching + page caching, but config unknown |

**Recommendation:** Request WP admin access or a full site export to close these gaps before decommissioning.

---

## Pre-Decommission Migration Checklist

### General

- [ ] Source code exported / repo access confirmed
- [ ] Full database export (all post types, postmeta, options, term relationships)
- [ ] Environment variables and secrets documented
- [ ] Third-party API credentials inventoried (see integration table above)
- [ ] Gravity Forms submission data exported (if historical entries needed)
- [ ] Redirect rules documented (check WP Engine dashboard + any redirect plugin)
- [ ] Media library exported (`wp-content/uploads/` — also available at `cdn.catf.us`)
- [ ] URL structure mapped for 301 redirect plan (see URL patterns above)

### WordPress-Specific

- [ ] ACF field group JSON exports (verify completeness — check if synced to theme)
- [ ] ACF options page values exported (global settings, GTM ID, social URLs, etc.)
- [ ] Gravity Forms definitions exported (JSON)
- [ ] Yoast SEO meta included in DB export (flag if migrating off WordPress)
- [ ] Schema Pro settings exported
- [ ] Custom post type and taxonomy registration code documented
- [ ] Custom URL rewrites documented (`/content-by/`, `/experts/`, inconsistent program URLs)
- [ ] Full active plugin list from WP admin (front-end audit only detects ~7 of N plugins)

### Third-Party Credentials to Carry Over

- [ ] Google Tag Manager (`GTM-5HSWVB5`) — access to GTM account
- [ ] Google Analytics 4 (`G-88025VJ2M0`) — property access
- [ ] Google Ads (`AW-314602869`) — conversion tracking config
- [ ] DV360 / Campaign Manager (`DC-16485908`) — Floodlight config
- [ ] Facebook Pixel (`1235730240390610`) — Business Manager access
- [ ] LinkedIn Insight (PID `3995433`) — Campaign Manager access
- [ ] Twitter/X Pixel (`o6zaj`) — Ads Manager access
- [ ] Reddit Pixel (`t2_gt8hjy23`) — Ads dashboard access
- [ ] Bing UET (`97034119`) — Microsoft Advertising access
- [ ] StackAdapt, Growth Channel, MediaMath — verify if still active, get credentials if so
- [ ] Salesforce Pardot (Account `909262`) — integration credentials and form configs
- [ ] Cookie Script (config `f9381cc175438d4f5eec179f05a8d614`) — account access
- [ ] Microsoft Clarity (`cs6tejz2qz`) — project access
- [ ] Donation platform (`give.catf.us`) — platform credentials and campaign config
- [ ] Google reCAPTCHA — site key and secret key
- [ ] Facebook domain verification token
- [ ] Font licenses (TT Norms Pro is a commercial font — verify license covers new domain/platform)
