# WordPress Inventory — noblereach.org

**Source:** `/Users/timarnold/Local Sites/noble-reach-foundation/app/public`
**Active theme:** `noblereach-2024` (Teal Media)
**Date:** 2026-03-20

---

## 1. Theme Architecture

### Overview

The active theme (`noblereach-2024`) is a ground-up Twig/Timber implementation. PHP template files handle WordPress routing; Twig templates handle rendering. There is no child theme.

| Item | Value |
|---|---|
| Theme directory | `wp-content/themes/noblereach-2024/` |
| Templating engine | Timber (Twig) — `Timber\Timber::init()` in `functions.php` |
| Twig partials path | `_html/templates/partials` (set via `Timber::$dirname`) |
| Twig templates path | `_html/templates/` |
| Legacy theme | `noblereach/` (ARCHIE, native WP, not active) |

### PHP Template Files

PHP files handle routing and pass context to Twig. Each calls `Timber::render()` or similar.

| PHP File | Twig Template | Renders |
|---|---|---|
| `front-page.php` | `home.twig` | Homepage |
| `page.php` | (default) | Generic pages |
| `single-person.php` | `team--individual.twig` | Person CPT single |
| `single-news.php` | `news--individual.twig` | News CPT single |
| `single-story.php` | `stories--individual.twig` | Story CPT single |
| `single-action.php` | `jobs--individual.twig` | Action/Job CPT single |
| `single-event.php` | `events--individual.twig` | Event CPT single |
| `single-partnership.php` | (partnership) | Partnership CPT single |
| `single-job.php` | (job) | Duplicate of action single |
| `single-case-studies.php` | (case-studies) | Dead — CPT disabled |
| `search.php` | `search.twig` | Search results |
| `404.php` | `error.twig` | 404 page |
| `header.php` / `footer.php` | — | WP include wrappers |
| `index.php` | — | Fallback |

### Page Templates (21 total)

| Template File | ACF Field Group | Purpose |
|---|---|---|
| `template-academic-partnership.php` | group_661ef146c06e5 | Academic partnership landing |
| `template-byo-hero.php` | group_66284a952ef53 | Flexible page with custom hero |
| `template-career-opportunities.php` | group_660eec028dc76 | Career opportunities |
| `template-events.php` | group_6246f862283f9 | Events landing page |
| `template-fellows-interns-ee.php` | group_661dbfea3a5a0 | Fellows/Interns/Emerging Entrepreneurs |
| `template-hire-noblereach.php` | group_661da604dcf76 | Hire NobleReach Talent |
| `template-innovations.php` | group_6619929335562 | Innovations page |
| `template-jobs-internships.php` | group_6616ffc027b02 | Jobs & Internships |
| `template-jobs-listing.php` | group_66168632a80f9 | Jobs listing |
| `template-jobs.php` | — | Jobs (alternate) |
| `template-news-events.php` | group_6616abf6db864 | News & Events combined |
| `template-news.php` | group_65f875e8069fb | News landing |
| `template-newsletter.php` | group_661d99b2b5020 | Newsletter signup |
| `template-partners.php` | group_6431ecc7c4b7c | Partners listing |
| `template-partnership.php` | group_6604a98789e24 | Individual academic partnership |
| `template-share.php` | group_6610479192106 | Share Your Story |
| `template-stories.php` | — | Stories archive |
| `template-talent-stories.php` | group_6616d2221f08b | Talent stories |
| `template-team-landing.php` | group_661071c575261 | Team/People landing |
| `template-vmm-stories.php` | group_661087fbbf892 | VMM Stories |
| `template-vmm.php` | group_660dec96346a1 | Venture Meets Mission |

### Twig Templates

Located in `_html/templates/`:

```
about.twig
academic--individual.twig
academic--partnership.twig
bundles/
core/
defaults.twig
error.twig
events--individual.twig
events--landing--1.twig
events--landing--2a.twig
events--landing--2b.twig
form.twig
hire.twig
home.twig
innovations.twig
interns.twig
jobs--individual.twig
jobs--internships.twig
jobs--landing.twig
loader.twig
news--individual.twig
news--landing.twig
newsletters.twig
opportunities.twig
partials/
partners.twig
search.twig
share.twig
sponsor.twig
stories--individual.twig
stories--landing.twig
talent-stories.twig
team--individual.twig
team--landing.twig
venture.twig
```

### JavaScript & CSS

Enqueued via `inc/core.php`:

| Handle | File | Notes |
|---|---|---|
| `app` | `assets/styles/app.css` | Main stylesheet |
| `misc-app` | `assets/styles/misc.css` | Misc styles |
| `overrides` | `assets/styles/overrides.css` | Overrides |
| `libs` | `assets/scripts/libs.js` | Third-party libs |
| `app` | `assets/scripts/app.js` | Main JS (depends on jquery, tm-extras) |
| `app-blank` | `assets/scripts/app-blank.js` | Loaded as ES module (`type="module"`) |
| `admin-scripts` | `assets/scripts/admin.js` | Admin-only JS |

### Custom Image Sizes

Registered in `inc/core.php`:

| Size Name | Width | Height | Crop |
|---|---|---|---|
| `tm-500` | 500 | 500 | No |
| `tm-620-c` | 620 | 620 | Yes (center) |
| `tm-1000` | 1000 | 1000 | No |
| `tm-1500` | 1500 | 1500 | No |
| `tm-2000` | 2000 | 2000 | No |
| `tm-2500` | 2500 | 2500 | No |
| `tm-wide` | 280 | 180 | Yes (center, top) |
| `tm-tall` | 253 | 320 | Yes (center, top) |

JPEG quality is set to 94 (default is 82).

### Navigation Menus

Registered: `main`, `footer`, `utilities`

---

## 2. ACF Field Groups

### Summary

| Source | Count |
|---|---|
| `noblereach-2024/acf-json/` | 44 field groups + 2 UI options pages |
| `noblereach/acf-json/` | 24 field groups (legacy) |

The 2024 theme uses a **clone field** architecture — component definitions are stored once in a library group (`group_66103c34a2966`) and cloned into page-specific groups. The `group_5e31f4bd0a574` "Layout" field provides the main flexible content engine.

### Options Page Groups

| Group Key | Title | Location | Notes |
|---|---|---|---|
| `group_5e2d037170edf` | Site Options | `options_page == nr-general-settings` | Global config: CPT slugs/labels, alert banner, GTM ID, misc. All CPT slug overrides live here. |
| `group_68a3b7d4ac96b` | Stories Archive Fields | `options_page == stories-archive-fields` | Archive title, callout text, featured item |
| `group_6924d959e52ef` | Map Options | `options_page == map-options` | Map data repeater (used by MapSVG) |

**Site Options group** (`group_5e2d037170edf`) is the single most critical field group — it controls CPT visibility, slugs, labels, landing page assignments, and global UI strings.

### CPT-Specific Groups

| Group Key | Title | Post Type | Key Fields |
|---|---|---|---|
| `group_64528e4e98756` | Single - Person | `person` | header (clone), layout (clone) |
| `group_6431b5845ddb8` | Single - News | `news` | header (clone), layout (clone), author_assignment (relationship) |
| `group_5e41db711410c` | Single – Jobs | `action` | title, short_description, brief_description, job_type (taxonomy), job_category (taxonomy), excerpt, disclaimer, layout (clone), action_embed (clone), offsite_links (group) |
| `group_6604b92cdbc95` | Single - Story | `story` | header (clone), layout (clone), related_story (clone), call_to_action (clone) |
| `group_6223c11344cf5` | Single - Event | `event` | header (clone), sidebar (group), layout (clone) |

### Page Template Groups

| Group Key | Title | Template |
|---|---|---|
| `group_5e30f6611f13c` | Front Page | `page_type == front_page` |
| `group_6619794f73be9` | Template - Home | `page_type == front_page` |
| `group_66185d4caa256` | Single - Page | `page_template == default` (not front page) |
| `group_661071c575261` | Template - Team Landing | `template-team-landing.php` |
| `group_6604a98789e24` | Template - Individual Academic Partnership | `template-partnership.php` |
| `group_661ef146c06e5` | Template - Academic Partnership | `template-academic-partnership.php` |
| `group_65f875e8069fb` | Template - News Landing Page | `template-news.php` |
| `group_6616abf6db864` | Template - News & Events | `template-news-events.php` |
| `group_6616d2221f08b` | Template - Talent Stories | `template-talent-stories.php` |
| `group_6610479192106` | Template - Share Your Story | `template-share.php` |
| `group_660dec96346a1` | Template - Venture Meets Mission | `template-vmm.php` |
| `group_661087fbbf892` | Template - VMM Stories | `template-vmm-stories.php` |
| `group_660eec028dc76` | Template - Career Opportunities | `template-career-opportunities.php` |
| `group_661dbfea3a5a0` | Template - Fellows, Interns, EE | `template-fellows-interns-ee.php` |
| `group_661da604dcf76` | Template - Hire NobleReach Talent | `template-hire-noblereach.php` |
| `group_6619929335562` | Template - Innovations | `template-innovations.php` |
| `group_6246f862283f9` | Template - Event Landing Page | `template-events.php` |
| `group_6431ecc7c4b7c` | Template - Partners | `template-partners.php` |
| `group_66168632a80f9` | Template - Jobs Listing | `template-jobs-listing.php` |
| `group_6616ffc027b02` | Template - Jobs & Internships | `template-jobs-internships.php` |
| `group_661d99b2b5020` | Template - Newsletter Signup | `template-newsletter.php` |
| `group_66284a952ef53` | Template - BYO Hero | `template-byo-hero.php` |
| `group_6669e5aedd741` | EMERGE Extra Section | `page == 2506` (hardcoded page ID) |

### Component Libraries (internal — location: `post_type == post`)

These groups hold component definitions used as clone sources. They are not directly assigned to real post types.

| Group Key | Title | Field Count | Notes |
|---|---|---|---|
| `group_66103c34a2966` | Components (NEW) | 35 | Primary component library for 2024 theme |
| `group_5e30f77503576` | Components (Old) | 30 | Legacy components — some still in use via clone |
| `group_643205ee13d53` | Components - Headers & Heroes | 10 | Header/hero variants |
| `group_6234b711e5b21` | Component Modifiers and Elements | 3 | Display options, style options, image-text repeater |
| `group_6462ade124da0` | Elements | 2 | Spacing selects |
| `group_67b6fea82ee9c` | Background Colors | 1 | `component_bg_colors` select |
| `group_5e41ce129135d` | Post Options | 3 | Resource categories, pinned, offsite link |
| `group_5e41d2e07bcf5` | Post Options | 1 | Featured image |

### Layout Flexible Content Field (CRITICAL)

`group_5e31f4bd0a574` — **Layout** — is the main page-building engine. It is a `flexible_content` field named `layout` and is cloned into nearly every template via `layout_clone`.

**28 available layouts:**

| Layout Name | Label |
|---|---|
| `component_accordion` | Accordion |
| `component_accordion_two_col` | Accordion - Two Column |
| `component_call_to_action` | Call To Action |
| `component_featured_quote` | Featured Quote |
| `component_form_embed` | Form Embed |
| `component_html` | HTML Embed |
| `component_image` | Image |
| `component_image_text` | Image - Text |
| `component_image_grid` | Image Grid |
| `component_image_text_background` | Image + Text W/ Background |
| `logo_carousel` | Logo Carousel |
| `component_slideshow` | Slideshow |
| `component_statistics` | Statistics |
| `text_on_pattern` | Text on Pattern |
| `component_youtube` | Video - Full-width YouTube |
| `component_wysiwyg` | WYSIWYG |
| `component_wysiwyg_columns` | WYSIWYG Columns |
| `quote_carousel` | Quote Carousel |
| `component_key_dates_carousel` | Timeline / Key Dates Carousel |
| `component_email_signup` | Email Signup |
| `in_content_promo` | In-Content Promo |
| `groups_of_people` | People |
| `areas_of_focus_layout` | Areas of Focus |
| `body_copy` | Body Copy |
| `text_callout` | Text Callout |
| `recent_news` | Recent News |
| `featured_stories` | Featured Stories |
| `map` | Map |

There is also a `group_66255538475e3` — **Layout (ARCHIVE)** — which appears to be a duplicate/archive of the same flexible content field, also with `page_type != front_page` location.

---

## 3. Custom Post Types & Taxonomies

### Custom Post Types

All CPTs are registered in `inc/types.php` via `add_action('init', 'tm_post_types', 3)`.

| CPT Key | Default Slug | Public | Searchable | Archive | Supports | Notes |
|---|---|---|---|---|---|---|
| `person` | `person` (fixed) | Yes | Yes | No | title, revisions, editor, excerpt | Primary traffic driver. Slug hardcoded, not configurable. |
| `story` | `stories` (fixed) | Yes | Yes | No | title, thumbnail | Fixed slug. 2024 theme only. |
| `news` | `news` (configurable) | Yes | Yes | No | title, revisions, editor, excerpt | Slug set via ACF options or `SLUG_NEWS` constant |
| `action` | `actions` (configurable) | **No** | **No** | No | title, revisions, editor | Jobs/opportunities. Excluded from nav and search. Slug via ACF options. |
| `resource` | `resources` (configurable) | **No** | **No** | No | title, revisions, editor, excerpt | Excluded from nav and search. Slug via ACF options or `SLUG_RESOURCE` constant. |
| `event` | `events` (configurable) | Yes | Yes | No | title, revisions, editor | Disabled by default (`show_events = false`). Hidden in admin from non-super-admins. |
| `case-studies` | `case-studies` | — | — | — | — | **Commented out.** Disabled in 2024 theme. |

**Notes on `action` and `resource` CPTs:** Despite `public=false`, they have `rewrite` rules and `show_in_rest=true`. Individual posts are reachable via their slug; there is no archive URL. Content is surfaced via custom queries in page templates, not via standard WP archive routing.

**Note on events:** The `wp-force-login` plugin wraps the entire site. Events CPT is hidden from admin menu for non-super-admins (`remove_menu_page('edit.php?post_type=event')`).

### Custom Taxonomies

Registered in `inc/types.php` via `add_action('init', 'theme_taxonomies', 4)`.

| Taxonomy | Applied To | Hierarchical | Slug (default) | Configurable | Notes |
|---|---|---|---|---|---|
| `person_type` | `person` | No | `person_type` | No | Scholar/Fellow/Partner classification |
| `resource_tax` | `resource` | No | `resource_tax` (configurable) | Yes — via ACF options | Label also configurable |
| `news_tax` | `news` | No | `news_tax` (configurable) | Yes — via ACF options | Label also configurable |
| `job_type` | `action` | No | `job_type` | No | |
| `job_category` | `action` | No | `job_category` | No | |
| `story_type` | `story` | **Yes** | `story_type` | No | |
| `event_type` | `event` | **Yes** | `event_type` | No | |
| `partnership_tax` | `partnership` + `story` | Yes | none | No | Shadow taxonomy — auto-synced |

### Custom Query Vars

Registered via `add_filter('query_vars', 'tm_add_query_vars')`:

`pg`, `filters`, `sort`, `query`, `category`, `type`

(Plus configurable taxonomy slugs for news and resources if they differ from defaults.)

---

## 4. Plugin Dependency Map

### Critical Plugins

#### `advanced-custom-fields-pro`

- **What depends on it:** Everything. All content fields beyond title/body are ACF fields. No ACF = no content.
- **Data stored:** `wp_postmeta` table (field values keyed by field name) + `wp_options` for options page fields. Field group definitions stored as JSON in `acf-json/` directories (already exported).
- **Migration:** Field group JSON files are already in `acf-json/`. The actual field *values* are in the database. A full DB dump is required to preserve content.

#### `gravityforms`

- **What depends on it:** All form submissions. Forms are embedded via `[gravityform id="X"]` shortcode throughout templates via ACF component data. The `component_form_embed` layout in the Layout flexible content also accepts a gravity form ID.
- **Data stored:** Custom tables (`gf_form`, `gf_entry`, `gf_entry_meta`, etc.) — **not in standard WP tables**. Form definitions require Gravity Forms export (`.json`). Entries require separate export.
- **Migration note:** Form IDs are stored in ACF postmeta. After rebuild, form IDs will change — ACF field values referencing old IDs must be updated.

#### `gravityformshubspot`

- **What depends on it:** Lead capture forms submit to HubSpot.
- **Data stored:** HubSpot API credentials in plugin settings (wp_options).
- **Migration:** Reconnect integration in new environment. Credentials needed.

#### `redirection`

- **What depends on it:** All redirect rules including the load-bearing `noblereachfoundation.org → noblereach.org` domain redirects.
- **Data stored:** Custom DB tables (`wp_redirection_items`, `wp_redirection_groups`, etc.). **Not file-based.** The plugin's fileio module (csv.php, json.php) provides export functionality from the admin UI.
- **Migration:** **Requires a running WordPress instance to export.** Export via Redirection admin → Import/Export → download JSON or CSV. This must be done before the rebuild environment is torn down.

#### `wordpress-seo` (Yoast SEO)

- **What depends on it:** All SEO meta — titles, meta descriptions, canonical URLs, OpenGraph data.
- **Data stored:** `wp_postmeta` using keys `_yoast_wpseo_title`, `_yoast_wpseo_metadesc`, `_yoast_wpseo_canonical`, `_yoast_wpseo_opengraph-image`, etc.
- **Migration:** Full DB export captures this. Alternatively, use Yoast's built-in SEO data export (free version supports this). The `acf-content-analysis-for-yoast-seo` plugin bridges ACF field content into Yoast's analysis — Yoast reads both post content and ACF fields.

### Important Plugins

#### `relevanssi`

- **What depends on it:** Site search. Relevanssi replaces WP's default search with a custom full-text index.
- **Data stored:** Custom table `wp_relevanssi` (search index). Must be rebuilt after content migration.
- **Migration:** Rebuild index after import. No export needed — the index is regenerated from content.

#### `mapsvg`

- **What depends on it:** Interactive map components on the site. The `map` layout in the flexible content engine uses MapSVG.
- **Data stored:** Custom tables for map data + SVG files in uploads. ACF options page `map-options` stores additional map configuration via the `map_data` repeater field.
- **Migration:** Export MapSVG maps from admin. SVG files are in the media library.

### Supporting Plugins

| Plugin | What It Does | Migration Need |
|---|---|---|
| `acf-extended` | Extends ACF (block types, forms — but these modules are **disabled** in code). Dev mode only. | None |
| `acf-code-field` | Adds a code editor field type to ACF | None if not rebuilding on WP |
| `acf-content-analysis-for-yoast-seo` | Makes Yoast analyze ACF field content | Replace if using different SEO plugin |
| `acf-gravityforms-add-on` | ACF field type for selecting Gravity Forms | Needed if keeping ACF + GF combination |
| `custom-taxonomy-order-ne` | Allows reordering taxonomy terms in admin | Term order is stored in term meta |
| `safe-svg` | Allows SVG uploads to media library | Rebuild will need SVG support |
| `classic-editor` | Forces Classic Editor (no Gutenberg) | Intentional — site uses ACF, not blocks |

### Infrastructure Plugins

| Plugin | Notes |
|---|---|
| `defender-security` | 2FA enforcement. Custom 2FA email fallback is in `inc/misc.php` (`tm_2fa_email_fallback()`). |
| `wp-force-login` | Forces login to view site (used for staging lockdown). **Must be deactivated in production.** |
| `wp-migrate-db-pro` | DB migration tool. Used for environment sync. |

### Dev Tools to Remove

| Plugin | Why Remove |
|---|---|
| `bugherd` | BugHerd script loads on all pages including production (see `inc/core.php:417`). API key is hardcoded (`3qbrqikhewhxejpgbacjiw`). **Flagged in SEO audit as hurting Best Practices score.** |
| `query-monitor` | Performance profiler. Dev-only. |
| `dummybot-master` | Test bot. Remove. |
| `duplicate-post` | Content utility. Not needed in production. |
| `enable-media-replace` | Media utility. Remove in production. |
| `ajax-thumbnail-rebuild` | Image utility. Remove after migration. |
| `better-search-replace` | DB utility. Remove after migration. |
| `stream` | Admin audit logging. Evaluate if needed. |

---

## 5. Gravity Forms Inventory

Gravity Forms form definitions are stored in the database only. No `.json` export files were found in the filesystem.

Form IDs in templates are **dynamic** — they are stored as ACF field values and passed via the component data arrays. Templates reference them as:
- `$data['gravity_form']` (in `components.php` and `misc.php`)
- `$data['component_form_embed']['gravity_form']` (in template context)

The form embed component (`component_form_embed` layout) appears in:
- The main Layout flexible content engine
- `template-share.php` (Share Your Story)
- `template-fellows-interns-ee.php` (Fellows/Interns/EE)
- `footer.php`

**To get form IDs and definitions:** Run a Gravity Forms export from the admin (`Forms → Import/Export → Export Forms`). This produces a `.json` file with all form definitions.

Additionally, two non-Gravity Forms integrations exist in `inc/misc.php`:
- **HubSpot embed form** (`tm_print_new_nr_salesforce_form`): Portal ID `39514383`, Form ID `1a9f6104-35b3-4221-9925-dad04d5265c9`
- **Salesforce Web-to-Lead form** (`tm_print_nr_salesforce_form`): OID `00Dt0000000g9QT`, lead source `Emerge-Jobs` — appears to be a legacy form for the Emerge program

---

## 6. Redirection Plugin Rules

The Redirection plugin (`redirection`) stores all redirect rules in custom database tables:
- `wp_redirection_items` — individual redirect rules
- `wp_redirection_groups` — redirect groups
- `wp_redirection_logs` — access logs

**No file-based redirect rules were found.** The plugin's fileio module (`redirection/fileio/`) supports CSV, JSON, Apache, and Nginx export formats, but these must be triggered from the admin UI against a running database.

**Export must be done before the rebuild environment is decommissioned.** From the Redirection admin: Tools → Import/Export → download as JSON.

The SEO audit (`seo-audit/reports/03-redesign-risk-register.md`) flagged that the `noblereachfoundation.org` domain redirects are load-bearing — the Redirection plugin is the mechanism managing these.

---

## 7. Custom Functions

### `functions.php`

- `Timber\Timber::init()` — initializes Twig templating
- `rewrite_search_url()` — rewrites `/query/[term]` → `/?s=[term]` (the Twig search template uses `?query=` instead of `?s=`)
- `query_var_cleanup()` — maps `query` var to `s` var at parse time
- `customfields_search_join()` / `customfields_search_where()` / `customfields_search_distinct()` — joins `wp_postmeta` into search queries so ACF field values are searchable

### `inc/core.php` — Theme Setup & Global Behavior

Key non-boilerplate functions:

| Function | Hook | What It Does |
|---|---|---|
| `tm_filter_post_metadata_postthumb()` | `get_post_metadata` | For `news` and `action` CPTs, returns `component_featured_image` ACF field as the featured image instead of the WP thumbnail. |
| `tm_gtm_container()` | `wp_head` | Injects GTM snippet. Only fires in production and for logged-out users. GTM container ID stored in ACF options (`misc.gtm_client_id`). |
| `tm_adjust_search_query()` | `pre_get_posts` | Sets search to include `post`, `page`, `event`, `person` post types. Respects configurable results count from ACF options. |
| `tm_upload_mimes()` | `upload_mimes` | Adds `woff2`, `woff`, `eot` to allowed MIME types. |
| `tm_include_bugherd()` | `admin_head` + `wp_head` | **Loads BugHerd on all pages including production.** API key hardcoded. This should be removed. |
| `tm_redirect_link()` | `admin_menu` | Adds Redirects shortcut to admin sidebar. |
| `tm_remove_protected_text()` | `protected_title_format` | Strips "Protected:" prefix from password-protected post titles. |
| `tm_password_protected_form()` | `the_password_form` | Custom password-protected page form using ACF strings. |

### `inc/misc.php` — Utility & Display Functions

Key functions:

| Function | What It Does |
|---|---|
| `tm_wp_get_environment_type()` | Custom env detection. Checks `$_SERVER['SERVER_NAME']` for `noblereach.tealmedia.dev` (staging) or `noblereachdev.wpenginepowered.com` (dev). Falls back to WP's `wp_get_environment_type()`. |
| `tm_offsite_links()` | `post_type_link` filter — replaces post permalink with ACF `header_offsite_links_url` if `header_offsite_links_is_offsite_link` is true. Used for news items that point to external publications. |
| `tm_redirect_for_offsite_links()` | Redirect front-end visitors away from internal WP post URL if post has an offsite link set. |
| `tm_pre_get_posts()` | `pre_get_posts` — complex query modification for resource and news archives: handles pinning, sorting, taxonomy filtering, and configurable slugs. |
| `tm_print_action_embed()` | Renders form embed components: Gravity Forms shortcode, HubSpot embed, or raw HTML embed depending on type. |
| `tm_print_nr_salesforce_form()` | Legacy Salesforce Web-to-Lead form (hardcoded field IDs). |
| `tm_print_new_nr_salesforce_form()` | HubSpot embedded form (portal `39514383`, form `1a9f6104-35b3-4221-9925-dad04d5265c9`). |
| `tm_get_modal_frequency()` | Returns modal display frequency from ACF options. |
| `tm_get_banner_frequency()` | Returns alert banner display frequency from ACF options. |
| `tm_get_string()` | Fetches UI strings from ACF options (key `field_5e7aab840f00f`). Used for customizable UI text. |
| `tm_print_pagination()` / `tm_print_pagination_simple()` | Custom pagination using `?pg=` query var. Uses ACF options to find the news landing page. |
| `tm_get_related_posts()` | Raw SQL query via `$wpdb` to find related posts by shared taxonomy terms. Supports configurable taxonomies and post types. Used for stories. |
| `tm_2fa_email_fallback()` | Ensures email 2FA (via Defender Security) is enabled for all users on profile update. |
| `update_robots_txt()` | Adds `Disallow: /*?s` to robots.txt to block search crawling. |

### `inc/shadow-tax.php` — Shadow Taxonomy System

| Function | Hook | What It Does |
|---|---|---|
| `tm_shadow_tax_posttypes()` | — | Returns array: `['partnership' => ['story']]`. Currently only partnership CPT is synced to shadow taxonomy for stories. |
| `tm_sync_tax()` | `save_post` (priority 20) | When a `partnership` post is saved, creates or updates a `partnership_tax` term matching the post's title/slug. |
| `tm_sync_tax_delete()` | `before_delete_post` | Deletes the associated `partnership_tax` term when a partnership post is permanently deleted. |
| `tm_save_partner_relationship()` | `save_post` | When a non-partnership post is saved with `header_related_partnership` ACF field, assigns the corresponding `partnership_tax` terms. |
| `tm_get_post_from_term()` | — | Utility: given a `partnership_tax` term, returns the corresponding partnership post ID. |
| `tm_get_tax_from_post()` | — | Utility: given a post ID, returns its shadow taxonomy term. |

**How the shadow tax works:** Every `partnership` CPT post has a matching `partnership_tax` term with the same name/slug. When another post (e.g., a `story`) is associated with a partnership via the `header_related_partnership` ACF relationship field, those `partnership_tax` terms are assigned to the story post. This allows querying stories by partnership using standard WP taxonomy queries.

### `inc/types.php` — CPT Admin UI

Beyond registration, this file also:
- Adds `Pinned` and `Location` columns to the resource post list
- Redirects resource archive to homepage if no resources exist
- Adds custom query vars for pagination and filtering
- Hides the Events admin menu from non-super-admins

### `inc/acf.php` — ACF Configuration

- Registers ACF options page `nr-general-settings` ("NobleReach Options") with `create_users` capability (Editor level)
- Disables several ACFE (ACF Extended) modules: block_types, forms, options_pages, multilang, post_types, categories, taxonomies
- Removes HTML sanitization filter from all ACF fields (`acf/allow_unfiltered_html`)

### `inc/lockdown.php` — Admin UI Hardening

- Removes admin bar Customizer link
- Removes default WordPress post editing from sidebar (native posts, options, tools)
- Restricts many admin menus to super-admins only
- Forces subscriber-role users to homepage on login

### `inc/rebuild_functions.php` — Utility Functions

Small file. Contains:
- `tm_get_featured_post_details()` — fetches permalink, title, taxonomy term name, and date for a given post ID
- `tm_format_date_components()` — formats a date string into component parts (month, day, year, time, datetime)

---

## 8. Media & Asset Notes

### MIME Types

Beyond WordPress defaults, the theme adds:
- `woff2` (`application/font-woff2`)
- `woff` (`application/font-woff`)
- `eot` (`application/vnd.ms-fontobject`)

SVG uploads are enabled via the `safe-svg` plugin.

### Upload Directory

Standard WordPress uploads at `wp-content/uploads/`. No custom upload directories were found in the theme code.

### Image Handling

- Custom `tm_print_figure()` and `tm_print_picture()` functions in `inc/misc.php` handle all image output with responsive srcsets
- All images use lazy loading (`data-src`, `data-srcset` with lazysizes library)
- Aspect ratio is calculated from image dimensions and passed as a CSS custom property (`--r`)
- SVG images skip aspect ratio calculation (MIME type check)

### Favicon

Favicon is stored in the media library and referenced via ACF options (`misc.favicon`). Not a static file.

### Logo

Logos are static theme assets:
- `assets/images/logo.svg` — primary logo
- `assets/images/login-logo.png` — inverse/login logo

### GTM Container

GTM container ID is stored in ACF options (`misc.gtm_client_id`), sanitized with `sanitize_key()` and uppercased. Only fires in production for logged-out users.
