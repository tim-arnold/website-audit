# Noble Reach — Pre-Redesign SEO Benchmark

## Project

SEO baseline audit for **noblereach.org** before a full website redesign and rebuild. The goal is to document everything that must be preserved, redirected, or fixed during the rebuild.

## Current State

- Baseline data (keywords, backlinks, AI mentions) has been collected and is in `data/baseline-data.md`
- Handoff instructions for completing the remaining work are in `HANDOFF.md`
- Three reports need to be produced in `reports/`
- A technical audit (on-page, Lighthouse) has NOT been run yet

## Key Facts About the Target Site

- Domain: noblereach.org (previously noblereachfoundation.org — redirects are load-bearing)
- Hosted on Cloudflare
- Person pages (`/person/`) are the primary traffic drivers
- 113 backlinks from .edu domains — highest-value links, mostly to Scholars and Emerge program pages
- 195 ranked keywords, ~1,685 monthly organic visits
- Site appears in Google AI Overviews for several queries

## Tools Available

- **DataForSEO MCP** (`dfs-mcp`): SERP data, keyword volumes, on-page audits, Lighthouse, backlinks, AI mentions
  - Backlinks API: `backlinks_summary`, `referring_domains`, and `anchors` work. `backlinks_backlinks` endpoint returns access denied — do not retry.
  - LLM mentions API: active (14-day trial)
- **Playwright MCP**: browser automation for page-level inspection if needed
- **Sanity MCP**: connected but not relevant to this audit work

## Conventions

- Save raw/structured data to `data/`
- Save final reports to `reports/`
- Use markdown tables for all data presentation
- Reports should be factual and actionable — the audience is a dev team doing a site rebuild
