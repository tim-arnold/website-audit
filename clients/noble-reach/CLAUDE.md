# Noble Reach Foundation — Pre-Redesign Audit

## Project

Pre-redesign audit for **https://noblereach.org**. The goal is to document everything that must be preserved, redirected, or fixed during the rebuild.

## Client

- **Name:** Noble Reach Foundation
- **Public URL:** https://noblereach.org
- **Previous domain:** noblereachfoundation.org (redirects are load-bearing — 113 .edu backlinks depend on them)
- **CMS:** WordPress
- **Hosting:** WPEngine, behind Cloudflare
- **Local site path:** `/Users/timarnold/Local Sites/noble-reach-foundation/app/public`
- **Active theme:** `noblereach-2024` (Teal Media, Timber/Twig templating)

## Audit Status

- SEO audit: **complete** — data and reports in `seo-audit/`
- WordPress audit: **complete** — data and reports in `wordpress-audit/`
- Accessibility audit: **complete** — data, reports, and screenshots in `accessibility-audit/`

## Key Facts

- Person pages (`/person/`) are the primary traffic drivers — 88 top-10 keywords
- 113 backlinks from .edu domains — highest-value links
- ~270 ranked keywords, ~1,685 monthly organic visits
- Site appears in Google AI Overviews for several queries
- The `noblereachfoundation.org → noblereach.org` redirect chain must persist through the rebuild

## Tools Available

- **DataForSEO MCP** (`dfs-mcp`): SERP data, keyword volumes, on-page audits, Lighthouse, backlinks, AI mentions
  - `backlinks_backlinks` endpoint returns access denied — do not retry
  - LLM mentions API: active (14-day trial from 2026-03-20)
- **Playwright MCP**: browser automation for live page inspection
- **Sanity MCP**: connected but not relevant to this audit work

## Conventions

- Each audit type lives in its own subdirectory: `seo-audit/`, `wordpress-audit/`, `accessibility-audit/`
- Within each audit: raw/structured data goes in `<audit>/data/`, final reports go in `<audit>/reports/`
- Analytics audit: planned
- Security audit: planned
- Use markdown tables for all data presentation
- Reports should be factual and actionable — the audience is a dev team doing a site rebuild
