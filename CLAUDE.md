# Noble Reach — Pre-Redesign Audit

## Project

Pre-redesign audit for **noblereach.org**. The goal is to document everything that must be preserved, redirected, or fixed during the rebuild.

## Current State

- SEO audit is complete — data and reports are in `seo-audit/`
- WordPress audit: planned
- Accessibility audit: planned

## Key Facts About the Target Site

- Domain: noblereach.org (previously noblereachfoundation.org — redirects are load-bearing)
- Hosted on Cloudflare, running WordPress
- Person pages (`/person/`) are the primary traffic drivers
- 113 backlinks from .edu domains — highest-value links, mostly to Scholars and Emerge program pages
- 270 ranked keywords, ~1,685 monthly organic visits
- Site appears in Google AI Overviews for several queries

## Tools Available

- **DataForSEO MCP** (`dfs-mcp`): SERP data, keyword volumes, on-page audits, Lighthouse, backlinks, AI mentions
  - Backlinks API: `backlinks_summary`, `referring_domains`, and `anchors` work. `backlinks_backlinks` endpoint returns access denied — do not retry.
  - LLM mentions API: active (14-day trial)
- **Playwright MCP**: browser automation for page-level inspection if needed
- **Sanity MCP**: connected but not relevant to this audit work

## Conventions

- Each audit type lives in its own subdirectory: `seo-audit/`, `wordpress-audit/`, `accessibility-audit/`, etc.
- Within each audit: raw/structured data goes in `<audit>/data/`, final reports go in `<audit>/reports/`
- Use markdown tables for all data presentation
- Reports should be factual and actionable — the audience is a dev team doing a site rebuild
