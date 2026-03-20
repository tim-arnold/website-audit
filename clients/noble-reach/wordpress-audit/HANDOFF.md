# WordPress Audit Handoff — Noble Reach

## Context

You are conducting a WordPress audit of **noblereach.org** as part of a pre-redesign evaluation. The SEO audit is already complete (see `seo-audit/reports/`). This audit documents everything a dev team needs to know about the current WordPress installation to plan a rebuild.

**Local site path:** `/Users/timarnold/Local Sites/noble-reach-foundation/app/public`

The site is a WPEngine-hosted WordPress install, currently running locally via Local. You have full filesystem access. You do NOT have database access or a running server — work from the filesystem only.

## What You Know

The exploration phase found the following. Use this as a starting point but verify and expand by reading the actual files.

### Themes

Two themes exist in `wp-content/themes/`:

| Theme | Directory | Author | Notes |
|---|---|---|---|
| ARCHIE | `noblereach` | Teal Media | Legacy theme, native WP templating |
| NobleReach Foundation 2024 | `noblereach-2024` | Teal Media | Current theme, uses **Timber/Twig** templating |

Neither is a child theme. The 2024 theme is a ground-up rewrite, not an iteration.

### Plugins (26 total)

| Plugin | Category | Rebuild Relevance |
|---|---|---|
| `advanced-custom-fields-pro` | Content modeling | **Critical** — all content structure depends on ACF |
| `gravityforms` | Forms | **Critical** — primary forms solution |
| `gravityformshubspot` | CRM integration | **Critical** — leads flow to HubSpot |
| `redirection` | URL management | **Critical** — manages redirect rules (export these) |
| `wordpress-seo` (Yoast) | SEO | Important — meta titles/descriptions stored in postmeta |
| `relevanssi` | Search | Important — custom search index |
| `mapsvg` | Maps | Important — interactive maps on site |
| `safe-svg` | Media | Minor — SVG upload support |
| `classic-editor` | Editor | Minor — legacy editor preference |
| `editoria11y-accessibility-checker` | A11y | Minor — dev tool |
| `acf-extended` | ACF add-on | Supporting |
| `acf-code-field` | ACF add-on | Supporting |
| `acf-content-analysis-for-yoast-seo` | ACF + Yoast bridge | Supporting |
| `acf-gravityforms-add-on` | ACF + GF bridge | Supporting |
| `custom-taxonomy-order-ne` | Taxonomy ordering | Supporting |
| `duplicate-post` | Content management | Dev tool |
| `enable-media-replace` | Media management | Dev tool |
| `stream` | Audit logging | Dev tool |
| `query-monitor` | Debugging | Dev tool — remove in production |
| `bugherd` | Client feedback | Dev tool — **remove in production** (flagged in SEO audit as hurting Best Practices score) |
| `ajax-thumbnail-rebuild` | Image tool | Dev tool |
| `better-search-replace` | DB tool | Dev tool |
| `dummybot-master` | Testing | Dev tool — remove |
| `defender-security` | Security | Infrastructure |
| `wp-force-login` | Security | Infrastructure |
| `wp-migrate-db-pro` | Migration | Infrastructure |

### Custom Post Types

Registered in `themes/noblereach-2024/inc/types.php`:

| CPT | Slug | Notes |
|---|---|---|
| `person` | `person` | **Primary traffic driver** — scholars, fellows, partners. Fixed slug. |
| `story` | `stories` | Narrative content. 2024 theme only. |
| `news` | Configurable via ACF | Blog/announcements |
| `action` | `actions` (configurable) | Job postings/opportunities |
| `resource` | `resources` (configurable) | Whitepapers, educational materials |
| `event` | `events` (configurable) | Events — restricted creation in legacy theme |
| `case-studies` | `case-studies` | **Disabled in 2024 theme** (commented out) |

Many slugs are dynamically set via ACF options fields — document the actual configured values.

### Custom Taxonomies

| Taxonomy | Applied To | Notes |
|---|---|---|
| `person_type` | `person` | Scholar/Fellow/Partner classification |
| `resource_tax` | `resource` | Configurable label |
| `news_tax` | `news` | Configurable label |
| `job_type` | `action` | 2024 only |
| `job_category` | `action` | 2024 only |
| `story_type` | `story` | 2024 only, hierarchical |
| `event_type` | `event` | 2024 only, hierarchical |
| Shadow taxonomies | Various | 2024 only — auto-sync across CPTs |

### Page Templates (noblereach-2024: 21 templates)

Too many to list here — see `themes/noblereach-2024/template-*.php` files.

### ACF Field Groups

- `noblereach/acf-json/` — 24 JSON exports
- `noblereach-2024/acf-json/` — 46 JSON exports

These are the content model. Every field group needs to be documented.

### Architecture Notes

- The 2024 theme uses **Timber** (Twig templating) — templates are in `themes/noblereach-2024/_html/`
- A **shadow taxonomy system** (`inc/shadow-tax.php`) syncs taxonomies across related CPTs
- The theme is part of a **Teal Media multi-site network** codebase (`inc/site_specific.php`) but Noble Reach has no custom slug overrides
- **Secure downloads** system exists in the legacy theme (`inc/secure_downloads.php`)
- Custom search rewrites `/query/` → `/search` and includes ACF meta in search results
- No custom shortcodes in either theme (empty `inc/shortcodes.php`)

## Your Task

Produce two deliverables, saved to `/Users/timarnold/Documents/Outright/Noble Reach/Eval/wordpress-audit/`:

### Data File: `data/wordpress-inventory.md`

A structured inventory of the WordPress installation. Include:

1. **Theme architecture** — Timber/Twig setup, template hierarchy, key template files and what they render. Focus on the 2024 theme.

2. **ACF field groups** — Read every JSON file in `noblereach-2024/acf-json/` and document:
   - Field group name and key
   - What post type/template it's assigned to (check the `location` rules in each JSON)
   - List of fields with their types (text, image, repeater, flexible content, etc.)
   - Flag any flexible content or repeater fields — these are the complex ones the rebuild team needs to understand

3. **Custom post types & taxonomies** — Full detail on each CPT: slug, labels, capabilities, rewrite rules, archive settings. Read `inc/types.php` directly.

4. **Plugin dependency map** — For each critical/important plugin, document:
   - What content or functionality depends on it
   - What data it stores (postmeta keys, custom tables, options)
   - What the rebuild team needs to migrate or replace

5. **Gravity Forms inventory** — Check for form export files or any form references in templates. Document form IDs referenced in code.

6. **Redirection plugin rules** — Check if redirect rules are stored in files or only in the database. If in files, document them.

7. **Custom functions** — Read through `inc/core.php`, `inc/helper.php`, `inc/misc.php`, `inc/shadow-tax.php`, and `inc/rebuild_functions.php` in the 2024 theme. Document any custom functionality that the rebuild team needs to replicate (custom queries, REST API modifications, special routing, etc.). Skip generic WordPress boilerplate.

8. **Media/asset notes** — Check for any custom upload directories, SVG handling, or special media processing.

### Report: `reports/wordpress-audit-report.md`

A concise report for the dev team. Structure:

**Executive Summary** (5-7 bullets)

**1. Architecture Overview** — How the current site is built. Timber/Twig, ACF-driven content model, multi-site heritage.

**2. Content Model** — Summary table of all CPTs, their taxonomies, and their ACF field groups. This is the "what do we need to rebuild" section.

**3. Critical Dependencies** — What must be migrated or replaced:
- ACF field structure (the content won't make sense without it)
- Gravity Forms (form submissions, HubSpot integration)
- Redirection plugin rules (SEO audit found these are load-bearing)
- Yoast SEO meta (titles, descriptions, canonical URLs stored in postmeta)

**4. Functionality to Replicate** — Custom features that aren't just "install a plugin":
- Shadow taxonomy system
- Configurable CPT slugs via ACF options
- Secure downloads
- Custom search behavior
- Any REST API customizations

**5. What to Drop** — Dev tools and dead code that should not carry over:
- BugHerd, Query Monitor, Dummybot
- Legacy theme (document but don't migrate)
- Commented-out case-studies CPT
- Multi-site specific code (site_specific.php, site_variations.php)

**6. Migration Checklist** — Actionable list of what to export/extract before the rebuild:
- ACF field group exports ✓ (already in acf-json/)
- Redirection plugin export
- Gravity Forms export
- Yoast meta export
- Media library
- wp_options values that configure CPT slugs

Cross-reference the SEO audit where relevant (e.g., "the person CPT drives 88 top-10 keywords — see `seo-audit/reports/03-redesign-risk-register.md`").

## Formatting

- Use markdown tables for all structured data
- Lead each section with a brief summary before the detail
- Be factual and specific — URLs, file paths, field names, not generalizations
- The audience is a dev team, not a client presentation

## Important Notes

- Work from the **noblereach-2024** theme as primary — that's the active one. Reference the legacy theme only where it contains functionality not present in 2024.
- You have filesystem access only. No database queries, no running WordPress. If something can only be determined from the database (like Gravity Forms form definitions or Redirection rules), note it as "requires DB export" and move on.
- Do NOT use the Sanity MCP, DataForSEO MCP, or Playwright MCP — this is a pure filesystem audit.
- Do NOT modify any files in the WordPress installation. Read only.
