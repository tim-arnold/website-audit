# {{CLIENT_DISPLAY_NAME}} — Pre-Redesign Audit

## Project

Pre-redesign audit for **{{PUBLIC_URL}}**. The goal is to document everything that must be preserved, redirected, or fixed during the rebuild.

## Client

- **Name:** {{CLIENT_DISPLAY_NAME}}
- **Public URL:** {{PUBLIC_URL}}
- **Previous domain:** {{PREVIOUS_DOMAIN}}
- **CMS:** {{CMS}}
- **Hosting:** {{HOSTING}}
- **Local site path:** {{LOCAL_SITE_PATH}}

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
