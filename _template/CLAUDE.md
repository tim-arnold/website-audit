# {{CLIENT_DISPLAY_NAME}} — {{AUDIT_PURPOSE_LABEL}} Audit

## Project

{{AUDIT_GOAL}}

## Client

- **Name:** {{CLIENT_DISPLAY_NAME}}
- **Public URL:** {{PUBLIC_URL}}
- **Previous domain:** {{PREVIOUS_DOMAIN}}
- **CMS:** {{CMS}}
- **Hosting:** {{HOSTING}}
- **Local site path:** {{LOCAL_SITE_PATH}}

## Audit Status

- SEO audit: planned
- Technology audit: planned
- Accessibility audit: planned
- Analytics audit: planned
- Security audit: planned

## Tools Available

- **DataForSEO MCP** (`dfs-mcp`): SERP data, keyword volumes, on-page audits, Lighthouse, backlinks, AI mentions
- **Playwright MCP**: browser automation for live page inspection
- **Google Analytics MCP**: GA4 data — traffic, behavior, conversions, data quality checks
- **Sanity MCP**: connected but not relevant to audit work

## Analytics Credentials

GA4 property ID and other non-public credentials are stored in `.env.local` in this directory (gitignored — not committed to the repo). Read that file at the start of any analytics audit work.

## Conventions

- Each audit type lives in its own subdirectory: `seo-audit/`, `technology-audit/`, `accessibility-audit/`, `analytics-audit/`, `security-audit/`
- Within each audit: raw/structured data goes in `<audit>/data/`, final reports go in `<audit>/reports/`
- Use markdown tables for all data presentation
- Reports should be factual and actionable — the audience is a dev team doing a site rebuild
- **Report H1 titles must start with the report name, not the client name.** The web app sidebar strips everything after the em dash, so `# Technology Audit Report — Client Name` is correct; `# Client Name — Technology Audit Report` is not.
