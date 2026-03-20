# Outright — Pre-Redesign Audit

## Project

Pre-redesign audit for **https://weareoutright.com**. The goal is to document everything that must be preserved, redirected, or fixed during the rebuild.

## Client

- **Name:** Outright
- **Public URL:** https://weareoutright.com
- **Previous domain:** N/A
- **CMS:** Next.js
- **Hosting:** Cloudflare Pages
- **Local site path:** /Users/timarnold/sites/outright-react-2024

## Audit Status

- SEO audit: planned
- WordPress audit: planned
- Accessibility audit: planned

## Tools Available

- **DataForSEO MCP** (`dfs-mcp`): SERP data, keyword volumes, on-page audits, Lighthouse, backlinks, AI mentions
- **Playwright MCP**: browser automation for live page inspection
- **Sanity MCP**: connected but not relevant to audit work

## Conventions

- Each audit type lives in its own subdirectory: `seo-audit/`, `wordpress-audit/`, `accessibility-audit/`
- Within each audit: raw/structured data goes in `<audit>/data/`, final reports go in `<audit>/reports/`
- Use markdown tables for all data presentation
- Reports should be factual and actionable — the audience is a dev team doing a site rebuild
