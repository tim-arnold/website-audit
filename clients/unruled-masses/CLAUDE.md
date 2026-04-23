# Unruled Masses — Remediation Audit

## Project

Remediation audit for **https://unruledmasses.org**. The goal is to identify and prioritize issues to fix on the existing site — no rebuild is planned.

## Client

- **Name:** Unruled Masses
- **Public URL:** https://unruledmasses.org
- **Previous domain:** N/A
- **CMS:** Next.js
- **Hosting:** Cloudflare Pages
- **Local site path:** /Users/timarnold/sites-personal/um-launch-page

## Audit Status

- SEO audit: complete · retest-2 in progress (started 2026-04-23)
- Technology audit: complete · retest-2 in progress (started 2026-04-23)
- Accessibility audit: complete · retest-2 in progress (started 2026-04-23)
- Analytics audit: complete · retest-3 in progress (started 2026-04-23)
- Security audit: complete · retest-2 in progress (started 2026-04-23)

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
- Reports should be factual and actionable — the audience is a dev team
- **Report H1 titles must start with the report name, not the client name.** The web app sidebar strips everything after the em dash, so `# Technology Audit Report — Unruled Masses` is correct; `# Unruled Masses — Technology Audit Report` is not.

## Retesting

After a redesign or remediation, run `./add-retest.sh` from the repo root to scaffold a new retest. The script auto-increments the retest number and creates:

```
<audit-type>/
  retest-1/
    data/        ← re-collected raw data
    reports/     ← retest reports + comparison
    HANDOFF.md   ← retest instructions
```

Retest reports follow the same naming as baseline reports. The comparison report is always `reports/00-comparison.md` — it documents the delta between the baseline and this retest round, using ▲ / ▼ / → to indicate changes.

Multiple retests are supported: `retest-1/`, `retest-2/`, etc. The web app groups them under Initial / Retest 1 / Retest 2 sub-headers in the sidebar.
