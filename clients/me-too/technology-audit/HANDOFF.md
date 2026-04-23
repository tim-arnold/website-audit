# Technology Audit

## Context

You are conducting a technology audit for the client described in `../CLAUDE.md`. Read that file first — it has the public URL, platform, local path, and any relevant context.

The goal is to document the technology stack, content model, and custom functionality so the dev team knows what to replicate, migrate, and discard during a rebuild.

If a local path is available in `../CLAUDE.md`, use it as the primary source. If not, infer what you can from the live site and flag gaps clearly.

**Do NOT modify any files.** Read and observe only.

## Deliverables

- `data/technology-inventory.md` — structured inventory of everything found
- `reports/technology-audit-report.md` — dev-team report with executive summary and migration checklist

---

## What to Audit

### 1. Architecture Overview

- What framework or CMS is in use? What version?
- How is the site structured — monolith, headless, static, hybrid?
- What is the build and deployment pipeline?
- How are environment variables and secrets managed?

### 2. Dependencies

If a local repo is available:
- Review `package.json`, `composer.json`, or equivalent. List major dependencies and their current versions.
- Note anything significantly behind current major versions or that appears abandoned (no releases in 2+ years).
- Note whether a lockfile is present and committed.

> Security evaluation of these dependencies (CVE scanning, hardcoded credentials) is covered in the security audit.

### 3. Content Model

- How is content structured and stored (database, files, CMS, API)?
- What content types / schemas exist?
- How is content authored — CMS admin, Markdown files, headless CMS, etc.?
- What content is in the codebase vs. in a database or external system?
- What must be exported or migrated before decommissioning the current system?

### 4. Third-Party Integrations

- Analytics, tag management (GTM, etc.)
- Marketing tools (HubSpot, Salesforce, Mailchimp, etc.)
- Forms and form handlers
- Maps, video embeds, social feeds
- Ad platforms or A/B testing tools
- Any integrations that require credentials to carry over

### 5. Custom Functionality

Review source files for:
- Custom routing or URL rewrite logic
- Search implementation
- Authentication or access control
- Any hardcoded content or configuration that should move to environment variables
- Anything non-obvious that would need to be replicated in a new stack

### 6. What to Drop

- Dev tools running in production (debug panels, annotation tools, etc.)
- Dead code, commented-out features, legacy files
- Plugins or packages no longer in use
- Staging-only configuration active on production

---

## Migration Checklist

The report must include a pre-decommission checklist covering everything that must be captured before the current environment is retired:

- [ ] Source code exported / repo access confirmed
- [ ] Database or content export (if applicable)
- [ ] Environment variables and secrets documented
- [ ] Third-party API credentials inventoried
- [ ] Form submission data exported (if needed)
- [ ] Redirect rules documented
- [ ] Media / uploaded assets exported
- [ ] Any platform-specific data exports (CMS exports, plugin data, etc.)

---

## Formatting Notes

- Use markdown tables for all structured data (dependencies, integrations, content types)
- Executive summary: 5-8 bullets covering the most important things the dev team must know
- Be specific: file paths, package names and versions, API endpoints where relevant
- Cross-reference the SEO audit risk register where URL structure or content types are mentioned

---

## WordPress-Specific Audit Areas

In addition to the generic technology audit above, cover these WordPress-specific areas:

### Theme Architecture
- Active theme: custom, child theme, or off-the-shelf? What templating engine (PHP, Timber/Twig, Blade)?
- PHP template files and routing logic; any component/partial system

### Content Model
- Custom post types (CPTs): slugs, public/non-public, archive routing
- Taxonomies per CPT; any configurable slugs stored in options
- ACF field groups: locations, key field types, flexible content layouts, options pages
- Are field group definitions version-controlled (JSON) or DB-only?

### Plugins
For each active plugin: purpose, hard vs. soft dependency, DB-only data (requires export), dev tools to remove.
Flag especially: form plugins, redirect plugins, SEO plugins, any with custom DB tables.

### Custom Functionality
Review `functions.php` and `inc/`. Document: CPT/taxonomy registration, custom queries, URL rewrites, API integrations, hardcoded credentials.

### Migration Checklist Additions
- [ ] Full database export (postmeta, options, term relationships)
- [ ] ACF field group JSON exports (verify completeness)
- [ ] Form plugin definitions export (Gravity Forms JSON, etc.)
- [ ] Redirect plugin rules export (JSON)
- [ ] Yoast/RankMath SEO meta (in DB export — flag if migrating off WP)
- [ ] ACF options page values (CPT slugs, GTM ID, global settings)
- [ ] Media library (`wp-content/uploads/`)
- [ ] Any plugin-specific custom DB tables (forms, maps, etc.)


---

## ⚠️ Front-End Only Mode

No local path was available at setup time. This audit is limited to what can be inferred from the public URL and HTML source.

**What you can still assess:**
- HTML source: framework fingerprints, meta tags, schema markup, script inventory
- Public URL structure and redirects
- Third-party scripts (GTM, analytics, ad platforms, integrations)
- Publicly visible content model (URL patterns, page types)
- Network requests (API calls, CDN assets, third-party resources)

**What you cannot assess without source access:**
- Dependency inventory and versions
- Build configuration and environment variables
- Server-side logic, API routes, custom middleware
- Hardcoded credentials or dev tools in source files
- Non-public content types or admin-only functionality

**Recommendation:** Flag gaps clearly in the report. If source access becomes available, supplement with a filesystem pass.

