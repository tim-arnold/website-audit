# WordPress Audit Report — noblereach.org

**Prepared:** 2026-03-20
**Source:** Filesystem analysis of local WPEngine copy (`/Users/timarnold/Local Sites/noble-reach-foundation/app/public`)
**Active theme:** `noblereach-2024` (Teal Media)
**Full data:** `../data/wordpress-inventory.md`

---

## Executive Summary

- **The content model is entirely ACF-driven.** 46 field group JSON files define all content structure beyond title/body. Without ACF (or a content migration that maps these fields), the existing content is unreadable.
- **The `person` CPT is the single highest-risk asset.** It drives 88 of the site's top-10 ranked keywords and receives the majority of organic traffic (see `seo-audit/reports/03-redesign-risk-register.md`). Its slug (`/person/`) is hardcoded and must not change.
- **Three things require a DB export before decommissioning:** Redirection plugin rules, Gravity Forms definitions, and all ACF field values (which are `wp_postmeta` rows). None of these are in the filesystem.
- **The active theme uses Timber/Twig**, not native WP templates. The rebuild team needs to account for this when auditing Twig template logic — it is not standard PHP.
- **BugHerd is loading on production pages** with a hardcoded API key in `inc/core.php`. It was flagged in the SEO audit as reducing the Best Practices Lighthouse score. Remove it.
- **`action` and `resource` CPTs are registered as non-public.** They are surfaced only via custom queries in page templates, not through standard WP archive routing. The rebuild must replicate this pattern or implement equivalent content queries.
- **The `wp-force-login` plugin is active** — this means the entire site requires login to view. Ensure it is deactivated before any public launch.

---

## 1. Architecture Overview

### How the Site Is Built

noblereach.org runs on WordPress with the `noblereach-2024` theme by Teal Media. The theme uses **Timber** (Twig templating) — PHP files handle WP routing and data preparation; Twig files handle all HTML rendering.

```
Request → PHP template (e.g. single-person.php)
        → Timber::render() with context array
        → Twig template (e.g. team--individual.twig)
        → HTML output
```

**Content model:** All structured content beyond title/body is stored via **Advanced Custom Fields Pro**. Field group definitions are version-controlled as JSON files in `acf-json/`. Field *values* are in the database as `wp_postmeta`.

**Component architecture:** The theme uses ACF's `clone` field to create a shared component library. Component definitions live in library field groups (`group_66103c34a2966`), and page-specific field groups clone from this library. The main page-building engine is a `flexible_content` field (`layout`) with 28 available layout types.

**Multi-site heritage:** The theme is part of Teal Media's multi-site codebase (includes `inc/site_specific.php` patterns). NobleReach has no active site-specific constant overrides for CPT slugs — it uses the ACF options page values instead.

### File Locations

| Asset | Path |
|---|---|
| PHP templates | `wp-content/themes/noblereach-2024/*.php` |
| Twig templates | `wp-content/themes/noblereach-2024/_html/templates/` |
| Theme functions | `wp-content/themes/noblereach-2024/inc/` |
| ACF field group JSON | `wp-content/themes/noblereach-2024/acf-json/` (46 files) |
| CSS | `wp-content/themes/noblereach-2024/assets/styles/` |
| JS | `wp-content/themes/noblereach-2024/assets/scripts/` |

---

## 2. Content Model

### Custom Post Types

| CPT | URL Slug | Public | Notes |
|---|---|---|---|
| `person` | `/person/` | Yes | Primary traffic driver. Fixed slug — cannot change. No archive. |
| `story` | `/stories/` | Yes | Fixed slug. 2024 theme only. No archive. |
| `news` | `/news/` (configurable) | Yes | Slug set in ACF options. No archive (page template used instead). |
| `action` | `/actions/` (configurable) | **No** | Jobs/opportunities. Not public, not searchable. Surfaced via page templates. |
| `resource` | `/resources/` (configurable) | **No** | Whitepapers, etc. Not public, not searchable. Surfaced via page templates. |
| `event` | `/events/` (configurable) | Yes | Disabled by default in admin. |
| `case-studies` | `/case-studies/` | — | **Commented out.** Do not migrate. |

### Taxonomies by CPT

| CPT | Taxonomy | Slug | Hierarchical | Configurable |
|---|---|---|---|---|
| `person` | `person_type` | `person_type` | No | No |
| `story` | `story_type` | `story_type` | Yes | No |
| `story` | `partnership_tax` | — | Yes | No (shadow taxonomy) |
| `news` | `news_tax` | configurable | No | Yes (slug + label) |
| `resource` | `resource_tax` | configurable | No | Yes (slug + label) |
| `action` | `job_type` | `job_type` | No | No |
| `action` | `job_category` | `job_category` | No | No |
| `event` | `event_type` | `event_type` | Yes | No |

### ACF Field Groups by Content Area

| Content Type | Field Group | Key Fields |
|---|---|---|
| **Person** | Single - Person | header (clone), layout flexible content |
| **News** | Single - News | header (clone), layout flexible content, author_assignment (relationship) |
| **Story** | Single - Story | header (clone), layout flexible content, related_story, call_to_action |
| **Action/Job** | Single – Jobs | title, short/brief description, job_type, job_category, excerpt, disclaimer, layout, action_embed (form), offsite_links |
| **Event** | Single - Event | header (clone), sidebar, layout flexible content |
| **Default Page** | Single - Page | header (clone), layout flexible content |
| **Homepage** | Template - Home | hero, image_and_text, featured_talent_stories, stats, carousel, upcoming_events, email_signup, recent_news |
| **Global Options** | Site Options | CPT slugs/labels, alert banner, GTM ID, 404 page, landing page assignments, modal frequency |

The **Layout flexible content field** (28 layouts) is the primary page-building mechanism. Nearly every template clones it. Layouts include: Accordion, CTA, Image+Text, Image Grid, Logo Carousel, Statistics, WYSIWYG, WYSIWYG Columns, Quote Carousel, Timeline/Key Dates, Email Signup, People grid, Map, and more. See the full list in `../data/wordpress-inventory.md`.

---

## 3. Critical Dependencies

### ACF Field Structure

The content model will not make sense without the ACF field group definitions. These are already exported to `acf-json/` directories in both themes, so the schema is preserved. However, the **field values** (every post's actual content) live in `wp_postmeta` and require a full database export.

The ACF options page (`nr-general-settings`) stores critical global configuration in `wp_options`:
- Which CPTs are active and what their slugs/labels are
- Which pages serve as landing pages for news, resources, etc.
- GTM container ID
- Alert banner content and frequency
- Global UI strings

This `wp_options` data must be exported with the DB.

### Gravity Forms (Form Submissions + HubSpot Integration)

- Form definitions live in Gravity Forms custom DB tables — **not in WP post tables or files**.
- Form IDs are referenced dynamically via ACF field values. The actual ID values are in the DB.
- The `gravityformshubspot` integration connects submissions to HubSpot. Credentials are in plugin settings (wp_options).
- **Export steps:** Forms → Import/Export → Export Forms (JSON) + export entries if needed.

### Redirection Plugin Rules

- All redirect rules are in the database (`wp_redirection_*` tables).
- The SEO audit identified that `noblereachfoundation.org → noblereach.org` redirects are **load-bearing** — 113 .edu backlinks depend on them.
- **Export before decommission:** Redirection admin → Tools → Import/Export → JSON.
- After export, verify the redirect rules cover the old domain, the old path structure, and any known URL changes.

### Yoast SEO Meta

- Meta titles, descriptions, canonical URLs, and OG images are stored in `wp_postmeta` with `_yoast_wpseo_*` keys.
- The `acf-content-analysis-for-yoast-seo` plugin feeds ACF field content into Yoast's analysis — this means SEO titles may reference ACF field values.
- **Migration:** Full DB export captures this. If rebuilding on a non-WP platform, the SEO meta must be mapped from the DB export to the new system.

---

## 4. Functionality to Replicate

### Shadow Taxonomy System (`inc/shadow-tax.php`)

Every `partnership` CPT post has a corresponding `partnership_tax` taxonomy term. The system:
1. Creates a `partnership_tax` term when a partnership post is saved
2. Keeps the term name/slug in sync with the post title/slug
3. Assigns `partnership_tax` terms to `story` posts via the `header_related_partnership` ACF relationship field

This allows a story to be queried by partnership without a direct post relationship. If the rebuild uses a different data model (e.g., direct references), this sync logic is no longer needed — but the existing content relationships must be preserved in migration.

### Configurable CPT Slugs and Labels

CPT slugs (`/news/`, `/resources/`, `/actions/`) and taxonomy slugs/labels are stored in ACF options (the `custom_post_types` group on the `nr-general-settings` options page). The theme reads these at `init` hook (priority 3/4) to register CPTs with the correct slugs.

**Why this matters:** If the rebuild system hard-codes slugs, any future slug changes would require code changes instead of admin configuration. Preserve this configurability if the new system allows it.

### Custom Search Behavior

Two significant search modifications:

1. **URL rewrite:** `/query/[term]` → `/?s=[term]` (the Twig search template uses `?query=` instead of WordPress's `?s=`). Registered in `functions.php`.

2. **ACF meta search:** WordPress search is extended via `posts_join` / `posts_where` / `posts_distinct` filters to search `wp_postmeta` values, not just post title and content. This allows ACF field content (descriptions, bios, etc.) to appear in search results.

Additionally, search is scoped to `post`, `page`, `event`, `person` post types (not all CPTs).

### Offsite Link Redirect

The `action` (jobs) and `news` CPTs support an `offsite_links` ACF group field (`is_offsite_link`, `url`). When set:
- The `post_type_link` filter replaces the internal WP permalink with the external URL
- Front-end visitors are redirected away from the WP post URL (`tm_redirect_for_offsite_links()`)
- Logged-in users see the internal page with an admin notice

This is used for news items that live on external publications and for job postings hosted on third-party sites.

### Secure Downloads (Legacy Theme Only)

The legacy theme (`noblereach/`) includes `inc/secure_downloads.php`. This functionality does **not** appear in the 2024 theme. If secure downloads are actively used, investigate whether they are handled by a plugin or another mechanism.

### Featured Image Override

For `news` and `action` CPTs, the featured image is sourced from the ACF field `component_featured_image` rather than the WP native `_thumbnail_id`. This is done via a `get_post_metadata` filter in `inc/core.php`. Any rebuild system querying featured images for these CPTs must account for this.

### HubSpot Form Embed

Beyond Gravity Forms, there is a hardcoded HubSpot embed in `inc/misc.php`:
- Portal ID: `39514383`
- Form ID: `1a9f6104-35b3-4221-9925-dad04d5265c9`

This is used via `tm_print_new_nr_salesforce_form()`. If this form is still in use, the embed credentials must carry over.

### MapSVG Configuration

The `map` layout in the flexible content engine uses MapSVG. Map data is also stored in an ACF options page (`map-options`). MapSVG stores its own data in custom DB tables. Export MapSVG maps separately.

---

## 5. What to Drop

### Dev Tools

| Item | Location | Action |
|---|---|---|
| BugHerd | Hardcoded in `inc/core.php:416-419` | Remove the two `add_action` calls and the plugin |
| Query Monitor plugin | `plugins/query-monitor/` | Deactivate and remove |
| Dummybot plugin | `plugins/dummybot-master/` | Remove |
| Duplicate Post plugin | `plugins/duplicate-post/` | Remove from production |
| Enable Media Replace | `plugins/enable-media-replace/` | Remove from production |
| Ajax Thumbnail Rebuild | `plugins/ajax-thumbnail-rebuild/` | Remove after media migration |
| Better Search Replace | `plugins/better-search-replace/` | Remove after migration |

### Dead Code

| Item | Location | Action |
|---|---|---|
| `case-studies` CPT | `inc/types.php:35-52` | Already commented out. Do not restore. |
| `case-studies` single template | `single-case-studies.php` | Delete |
| Salesforce Web-to-Lead form | `inc/misc.php:624-691` | Legacy form for Emerge program. Verify if still active before removing. |
| Components (Old) field group | `acf-json/group_5e30f77503576.json` | Legacy component library. Check if any live pages still use these fields. |
| Layout (ARCHIVE) field group | `acf-json/group_66255538475e3.json` | Appears to be a duplicate/archive of the main Layout group. Verify before removing. |

### Legacy Theme

The `noblereach/` theme (ARCHIE) should not be migrated. Document it for reference only. Notable: it contains `inc/secure_downloads.php` which the 2024 theme does not have — verify this feature is no longer in use.

### Multi-Site Code

The 2024 theme includes Teal Media multi-site infrastructure (`inc/site_specific.php`, constant-based slug overrides via `SLUG_NEWS`, `SLUG_RESOURCE`). NobleReach doesn't use these constants, but the code paths check for them. These are safe to remove in a Noble-Reach-specific rebuild.

### `wp-force-login` Plugin

This plugin gates the entire site behind a login screen. It is likely used for the staging environment. Ensure it is **not active on the production rebuild**.

---

## 6. Migration Checklist

Before decommissioning the current WordPress environment:

- [ ] **ACF field group exports** — already present in `acf-json/` directories. Verify completeness (44 groups in 2024 theme + 24 in legacy theme).
- [ ] **Full database export** — captures all postmeta (ACF field values, Yoast SEO meta), options page values, term relationships, and user data.
- [ ] **Redirection plugin export** — Admin → Redirection → Tools → Import/Export → JSON. Verify export includes all groups and the `noblereachfoundation.org` redirect rules.
- [ ] **Gravity Forms export** — Admin → Forms → Import/Export → Export Forms (JSON). Capture all forms.
- [ ] **Gravity Forms entries export** — If submission history needs to be preserved.
- [ ] **HubSpot API credentials** — Document portal ID and any API keys from the gravityformshubspot plugin settings.
- [ ] **Yoast SEO meta** — Captured in full DB export. If migrating off WordPress, extract `_yoast_wpseo_*` postmeta rows explicitly.
- [ ] **Media library** — Full `wp-content/uploads/` directory. Includes images, SVGs, and any uploaded fonts.
- [ ] **MapSVG maps** — Export from MapSVG admin if interactive maps are being carried forward.
- [ ] **ACF options page values** — Captured in DB export (`wp_options` rows with key prefix `options_`). Critical: CPT slugs, GTM ID, landing page assignments, global strings.
- [ ] **BugHerd API key** — Remove from `inc/core.php` before any production deployment on the new stack.
- [ ] **`wp-force-login` deactivation** — Confirm deactivated on production.
- [ ] **Relevanssi index rebuild** — After content migration, rebuild the search index.

### Cross-Reference: SEO Audit Risk Register

The SEO audit (`seo-audit/reports/03-redesign-risk-register.md`) identifies the following risks that are directly tied to WordPress configuration:

- **`/person/` URL structure** — Drives 88 top-10 keywords. Must be preserved exactly. Person CPT slug is hardcoded (not configurable).
- **Redirect chain from `noblereachfoundation.org`** — 113 .edu backlinks flow through this. The Redirection plugin manages these. Must be exported and re-implemented in the new stack (Cloudflare rules, new CMS redirect config, or Nginx config).
- **Yoast SEO titles** — The person CPT pages have custom SEO titles that drive click-through rates for program-related queries. Must migrate with the content.
